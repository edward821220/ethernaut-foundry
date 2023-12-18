// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/18-MagicNumber/MagicNumberFactory.sol";
import "../src/levels/18-MagicNumber/AttackMagicNumber.sol";

contract MagicNumberTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testMagicNumberHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        MagicNumFactory magicNumberFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumberFactory);
        vm.startPrank(hacker, hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(magicNumberFactory);
        MagicNum ethernautMagicNumber = MagicNum(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        AttackMagicNumber attacker = new AttackMagicNumber();
        address solver = attacker.deploy();
        ethernautMagicNumber.setSolver(solver);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
