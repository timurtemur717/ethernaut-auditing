// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/CoinFlip.sol";
import "../src/CoinFlipAttacker.sol";

contract CoinFlipTest is Test {
    CoinFlip public target;
    CoinFlipAttacker public attacker;

    function setUp() public {
        // 1. Kurban sözleşmeyi sanal ağa dağıtıyoruz
        target = new CoinFlip();
        // 2. Saldırgan sözleşmemizi kurup kurbanın adresini hedef gösteriyoruz
        attacker = new CoinFlipAttacker(address(target));
    }

    function test_ExploitCoinFlip() public {
        // Ethernaut bizden 10 kez üst üste kazanmamızı istiyor
        for (uint256 i = 0; i < 10; i++) {
            // FOUNDRY HİLESİ: Zamanı/Bloğu ilerletiyoruz!
            // Her turda blok numarasını 1 artırarak "lastHash == blockValue" engelini aşıyoruz.
            vm.roll(block.number + 1);

            // Saldırıyı başlatıyoruz: Sözleşmemiz geleceği görüp doğru cevabı flip() ile gönderecek
            attacker.attack();
        }

        // DOĞRULAMA: Kurban kontrattaki üst üste galibiyet sayısı 10 oldu mu?
        assertEq(target.consecutiveWins(), 10, "10 kez ust uste kazanilamadi!");
    }
}