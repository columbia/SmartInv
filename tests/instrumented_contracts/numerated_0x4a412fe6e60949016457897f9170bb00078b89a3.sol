1 pragma solidity ^0.4.4;
2 
3 // mainnet: 0x4a412fe6e60949016457897f9170bb00078b89a3
4 
5 contract SimpleMultisig {
6 
7   // wallet
8   struct Tx {
9     address founder;
10     address destAddr;
11     uint256 amount;
12     bool active;
13   }
14   
15   mapping (address => bool) public founders;
16   Tx[] public txs;
17 
18   function SimpleMultisig() public {
19     founders[0xf8e18E704Fb07282Eec78ADBEC6B584497d0B2e2] = true;
20     founders[0x0c621a12884c4F95B7Af1C46760a1bb7fE85ffaa] = true;
21     founders[0x6fc10338003273a46D7da62a126099998C981572] = true;
22   }
23 
24   // contribute function
25   function() public payable {}
26 
27   // one of founders can propose destination address for ethers
28   function proposeTx(address destAddr, uint256 amount) public isFounder {
29     txs.push(Tx({
30       founder: msg.sender,
31       destAddr: destAddr,
32       amount: amount,
33       active: true
34     }));
35   }
36 
37   // another founder can approve specified tx and send it to destAddr
38   function approveTx(uint8 txIdx) public isFounder {
39     assert(txs[txIdx].founder != msg.sender);
40     assert(txs[txIdx].active);
41 
42     txs[txIdx].active = false;
43     txs[txIdx].destAddr.transfer(txs[txIdx].amount);
44   }
45 
46   // founder who created tx can cancel it
47   function cancelTx(uint8 txIdx) public {
48     assert(txs[txIdx].founder == msg.sender);
49     assert(txs[txIdx].active);
50 
51     txs[txIdx].active = false;
52   }
53 
54   // check if msg.sender is founder
55   modifier isFounder() {
56     assert(founders[msg.sender]);
57     _;
58   }
59 }