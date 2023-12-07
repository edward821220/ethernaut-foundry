// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/09-King/KingFactory.sol";
import "../src/levels/09-King/AttackKing.sol";

contract KingTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate random-looking address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testKingHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King ethernautKing = King(payable(levelAddress));
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        AttackKing attackKing = new AttackKing(address(ethernautKing));
        vm.deal(address(attackKing), 2 ether);
        attackKing.attack();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
