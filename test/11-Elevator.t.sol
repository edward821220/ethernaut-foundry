// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "../src/levels/11-Elevator/ElevatorFactory.sol";
import "../src/levels/11-Elevator/MyBuilding.sol";

contract ElevatorTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate random-looElevator address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        vm.deal(hacker, 1 ether);
    }

    function testElevatorHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(elevatorFactory);
        Elevator ethernautElevator = Elevator(payable(levelAddress));
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // implement your solution here
        MyBuilding building = new MyBuilding(address(ethernautElevator));
        building.callElevator(1);
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
