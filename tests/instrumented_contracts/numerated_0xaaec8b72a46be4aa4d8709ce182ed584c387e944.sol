1 pragma solidity ^0.4.4;
2 
3 contract ThreesigWallet {
4 
5   mapping (address => bool) public founders;
6 
7   struct Tx {
8     address founder;
9     address destAddr;
10   }
11   
12   Tx[] public txs;
13   
14   uint256 balance;
15   
16   // constructor made of 3 independent wallets
17   function ThreesigWallet() {
18     founders[0x005A9c91CA71f9f69a4b3ad38c4B582E13595805] = true;
19     founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;
20     founders[0xB94a9Db26b59AC66E5bE7510636BE8b189BD184D] = true;
21   }
22   
23   // preICO contract will send ETHers here
24   function() payable {
25     balance += msg.value;
26   }
27   
28   // one of founders can propose destination address for ethers
29   function proposeTx(address destAddr) isFounder {
30     txs.push(Tx({
31       founder: msg.sender,
32       destAddr: destAddr
33     }));
34   }
35   
36   // another founder can approve specified tx and send it to destAddr
37   function approveTx(uint8 txIdx) isFounder {
38     assert(txs[txIdx].founder != msg.sender);
39     
40     txs[txIdx].destAddr.transfer(balance);
41     balance = 0;
42   }
43   
44   // check if msg.sender is founder
45   modifier isFounder() {
46     require(founders[msg.sender]);
47     _;
48   }
49 
50 }