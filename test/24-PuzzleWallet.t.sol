// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/24-PuzzleWallet/PuzzleWalletFactory.sol";
import "../src/levels/24-PuzzleWallet/AttackPuzzleWallet.sol";

contract PuzzleWalletTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testPuzzleWalletHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        PuzzleWalletFactory puzzleWalletFactory = new PuzzleWalletFactory();
        ethernaut.registerLevel(puzzleWalletFactory);
        vm.startPrank(hacker, hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(puzzleWalletFactory);
        PuzzleWallet ethernautPuzzleWallet = PuzzleWallet(levelAddress);
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        PuzzleProxy ethernautPuzzleProxy = PuzzleProxy(payable(levelAddress));
        AttackPuzzleWallet attacker = new AttackPuzzleWallet(ethernautPuzzleProxy, ethernautPuzzleWallet);

        attacker.attack{value: 0.001 ether}();
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
