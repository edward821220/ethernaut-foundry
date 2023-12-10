// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut-06.sol";
import "../src/levels/10-Reentrance/ReentranceFactory.sol";
import "../src/levels/10-Reentrance/AttackReentrance.sol";

contract ReentranceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 2 ether);
    }

    function testReentranceHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(reentranceFactory);
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        AttackReentrace attackReentrace = new AttackReentrace(address(ethernautReentrance));
        ethernautReentrance.donate{value: 0.001 ether}(address(attackReentrace));
        attackReentrace.attack();
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
