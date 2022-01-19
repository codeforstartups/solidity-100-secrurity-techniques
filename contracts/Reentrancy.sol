// Preventing Techniques

// Update the state variable before calling an out funtion

// Create a lock mechanism for calling one function at a time


//SPDX-License-Identifier : MIT

pragma solidity ^0.8.0;

contract HonestContract {
    mapping(address => uint256) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    bool internal locked;

    modifier noReentrant() {
        require(!locked, "no re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    function withdrawl(uint256 _amount) public noReentrant {
        require(balances[msg.sender] >= _amount);

        balances[msg.sender] -= _amount; // updating the balance before sending ether

        (bool sent, ) = msg.sender.call{value: _amount}("");

        require(sent, "Failed to send ether");

        // balances[msg.sender] -= _amount; this goes above before calling msg.sender.call
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Hack {
    HonestContract public honestContract;

    constructor(address _honestContractAddress){
        honestContract = HonestContract(_honestContractAddress);
    }

    fallback() external payable {
        if( address(honestContract).balance  >= 1 ether){
            honestContract.withdraw(1 ether);
        }
    }

    function attck() external payable {
        require(msg.value >= 1 ether );
        honestContract.deposit{value: 1 ether}();
        honestContract.withdraw(1 ether);
    }

    function getBalances() public view returns(uint){
        return address(this).balance;
    }
}

