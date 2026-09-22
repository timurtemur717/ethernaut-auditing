// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Telephone.sol";
import "../src/TelephoneAttacker.sol";

contract TelephoneTest is Test {
    Telephone public target;
    TelephoneAttacker public attacker;

    address public attackerUser = address(0x1337);

    function setUp() public {
        // Kurban ve Saldırı sözleşmelerini kuruyoruz
        target = new Telephone();
        attacker = new TelephoneAttacker(address(target));
    }

    function test_ExploitTelephone() public {
        // İşlemi attackerUser adresinin başlattığını simüle ediyoruz
        vm.prank(attackerUser);

        // Saldırı fonksiyonunu çağırıp yeni owner olarak attackerUser adresini veriyoruz
        attacker.attack(attackerUser);

        // DOĞRULAMA: Telephone sözleşmesinin yeni sahibi attackerUser oldu mu?
        assertEq(target.owner(), attackerUser, "Sahiplik degistirilemedi!");
    }
}