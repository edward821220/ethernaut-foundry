// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/26-DoubleEntryPoint/DoubleEntryPointFactory.sol";
import "src/levels/26-DoubleEntryPoint/AlertBot.sol";

contract DoubleEntryPointTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate random-looking address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testDoubleEntryPointHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DoubleEntryPointFactory doubleEntryPointFactory = new DoubleEntryPointFactory();
        ethernaut.registerLevel(doubleEntryPointFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(doubleEntryPointFactory);
        DoubleEntryPoint ethernautDoubleEntryPoint = DoubleEntryPoint(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        console.log("ethernautDoubleEntryPoint", address(ethernautDoubleEntryPoint));

        address vault = ethernautDoubleEntryPoint.cryptoVault();
        LegacyToken delegatedFrom = LegacyToken(ethernautDoubleEntryPoint.delegatedFrom());
        console.log("vault", vault);
        console.log("delegatedFrom", address(delegatedFrom));

        address underlying = address(CryptoVault(vault).underlying());
        console.log("underlying", underlying);

        address delegate = address(delegatedFrom.delegate());
        console.log("delegate", delegate);

        AlertBot alertBot = new AlertBot(vault);
        Forta forta = ethernautDoubleEntryPoint.forta();
        forta.setDetectionBot(address(alertBot));
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
