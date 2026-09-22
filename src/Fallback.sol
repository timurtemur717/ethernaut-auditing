// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 ether; // Yaratıcı baştan zengin
    }

    // 1. Katkı sağlama fonksiyonu
    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if(contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender; // En çok katkı vereni patron yap!
        }
    }

    // 2. Kasadan para çekme fonksiyonu
    function withdraw() public {
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }

    // 3. Doğrudan para alabilen özel fonksiyonlar
    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender; // Hey dostum, buraya dikkat!
    }
}