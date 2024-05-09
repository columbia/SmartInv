1 pragma solidity ^0.4.4;
2 
3 contract ThreesigWallet {
4 
5   mapping (address => bool) public founders;
6 
7   struct Tx {
8     address founder;
9     address destAddr;
10     bool active;
11   }
12   
13   Tx[] public txs;
14   
15   // constructor made of 3 independent wallets
16   function ThreesigWallet() {
17     founders[0xCE05A8Aa56E1054FAFC214788246707F5258c0Ae] = true;
18     founders[0xBb62A710BDbEAF1d3AD417A222d1ab6eD08C37f5] = true;
19     founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;
20   }
21   
22   // preICO contract will send ETHers here
23   function() payable {}
24   
25   // one of founders can propose destination address for ethers
26   function proposeTx(address destAddr) isFounder {
27     txs.push(Tx({
28       founder: msg.sender,
29       destAddr: destAddr,
30       active: true
31     }));
32   }
33   
34   // another founder can approve specified tx and send it to destAddr
35   function approveTx(uint8 txIdx) isFounder {
36     assert(txs[txIdx].founder != msg.sender);
37     assert(txs[txIdx].active);
38     
39     txs[txIdx].active = false;
40     txs[txIdx].destAddr.transfer(this.balance);
41   }
42 
43   // cancel tx
44   function cancelTx(uint8 txIdx) isFounder {
45     assert(txs[txIdx].founder == msg.sender);
46     txs[txIdx].active = false;
47   }
48   
49   // check if msg.sender is founder
50   modifier isFounder() {
51     require(founders[msg.sender]);
52     _;
53   }
54 
55 }