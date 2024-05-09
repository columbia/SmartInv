1 pragma solidity ^0.4.8;
2 
3 contract Token {
4   function balanceOf(address owner) returns (uint256 balance);
5 }
6 contract SaleBalanceTracker {
7   uint256 public snapshotTimestamp = 0;
8   uint256 public balanceAtSnapshot = 0;
9   address public saleAddress = 0x0d845706DdC11f181303a80828219c714ceb3687;
10   address public owner = 0x000000ba8f84d23de76508547f809d75733ba170;
11   address public dvipAddress = 0xadc46ff5434910bd17b24ffb429e585223287d7f;
12   bool public locked = false;
13   function endSale() {
14     require(owner == msg.sender);
15     require(!locked);
16     snapshotTimestamp = block.timestamp;
17     balanceAtSnapshot = Token(dvipAddress).balanceOf(saleAddress);
18     locked = true;
19   }
20 }