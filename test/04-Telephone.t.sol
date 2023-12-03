// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/04-Telephone/TelephoneFactory.sol";
import "../src/levels/04-Telephone/TelephoneAttack.sol";

contract TelephoneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate random-looking address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testTelephoneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(levelAddress);
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        TelephoneAttack telephoneAttack = new TelephoneAttack(address(ethernautTelephone));
        telephoneAttack.attack(hacker);
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
