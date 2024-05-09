1 pragma solidity ^0.4.4;
2 
3 contract Registry {
4   address owner;
5   mapping (address => uint) public expirations;
6   uint public weiPerBlock;
7   uint public minBlockPurchase;
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
18     uint senderExpirationBlock = expirations[msg.sender];
19     if (senderExpirationBlock > 0 && senderExpirationBlock < block.number) {
20       // The sender already has credit, add to it
21       expirations[msg.sender] = senderExpirationBlock + blocksForWei(msg.value);
22     } else {
23       // The senders credit has either expired or the sender is unregistered
24       // Give them block credits starting from the current block
25       expirations[msg.sender] = block.number + blocksForWei(msg.value);
26     }
27   }
28 
29   function blocksForWei(uint weiValue) returns (uint) {
30     assert(weiValue >= weiPerBlock * minBlockPurchase);
31     return weiValue / weiPerBlock;
32   }
33 
34   function setWeiPerBlock(uint newWeiPerBlock) {
35     if (msg.sender == owner) weiPerBlock = newWeiPerBlock;
36   }
37 
38   function setMinBlockPurchase(uint newMinBlockPurchase) {
39     if (msg.sender == owner) minBlockPurchase = newMinBlockPurchase;
40   }
41 
42   function withdraw(uint weiValue) {
43     if (msg.sender == owner) owner.transfer(weiValue);
44   }
45 
46 }