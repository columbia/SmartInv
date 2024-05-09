1 pragma solidity ^0.4.4;
2 
3 contract Registry {
4   address public owner;
5   mapping (address => uint) public expirations;
6   uint weiPerBlock;
7   uint minBlockPurchase;
8 
9   function Registry() {
10     owner = msg.sender;
11     // works out to about $7 per month
12     weiPerBlock = 100000000000;
13     // roughly 1 day worth of blocks at 20 sec transaction time
14     minBlockPurchase = 4320;
15   }
16 
17   function () payable {
18     if (expirations[msg.sender] > 0 && expirations[msg.sender] < block.number) {
19       // The sender already has credit, add to it
20       expirations[msg.sender] += blocksForWei(msg.value);
21     } else {
22       // The senders credit has either expired or the sender is unregistered
23       // Give them block credits starting from the current block
24       expirations[msg.sender] = block.number + blocksForWei(msg.value);
25     }
26   }
27 
28   function blocksForWei(uint weiValue) returns (uint) {
29     assert(weiValue >= weiPerBlock * minBlockPurchase);
30     return weiValue / weiPerBlock;
31   }
32 
33   function setWeiPerBlock(uint newWeiPerBlock) {
34     if (msg.sender == owner) weiPerBlock = newWeiPerBlock;
35   }
36 
37   function setMinBlockPurchase(uint newMinBlockPurchase) {
38     if (msg.sender == owner) minBlockPurchase = newMinBlockPurchase;
39   }
40 
41   function withdraw(uint weiValue) {
42     if (msg.sender == owner) owner.transfer(weiValue);
43   }
44 
45 }