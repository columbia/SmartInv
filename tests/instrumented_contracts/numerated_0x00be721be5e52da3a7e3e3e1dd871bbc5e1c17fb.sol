1 pragma solidity ^0.4.17;
2 /*
3 	REA Lottery Wheel Contract
4 
5 	The constructor sets last_hash to some initial value.
6 	Every call to spin() will increase the round_count by one and
7 	a put a new "random" hash into the storage map "hashes".
8 	spin() accepts an argument which can be used to introdue more "randomness".
9 
10 	The community can participate by sending small amounts of Eth (no matter the value)
11 	to the smart contract. The value sent together with timestamp and blocknumber increase
12 	the "randomness".
13 
14 	The outcome of round <n> can be retrived via call to get_hash(<n>).  
15 
16 	WARNING and DISCLAIMER: 
17 	We fully understand the fact that Ethereum Smart Contracts
18 	by design of Ethereum Blockchain and Solidity language work
19 	in a determenistic and predictable way. 
20 
21 	The block number and the timestamp are not random variables in
22 	a mathematical sense. Even worse, the interested miners can 
23 	affect the outcome by not including the contract transaction
24 	in a current block if they are not happy about the outcome 
25 	(since miners in theory know the outcome of every contract transaction
26 	before the transaction is included in a block). 
27 
28 	2017 Pavel Metelitsyn
29 
30 */
31 
32 contract REALotteryWheel{
33     
34     uint16 public round_count = 0;
35     bytes32 public last_hash;
36     address public controller;
37     
38     mapping (uint16 => bytes32) public hashes;
39     
40     function REALotteryWheel() public {
41         controller = msg.sender;
42         last_hash = keccak256(block.number, now);    
43     }
44     
45     function do_spin(bytes32 s) internal {
46         round_count = round_count + 1;
47         last_hash = keccak256(block.number,now,s);
48         hashes[round_count] = last_hash;
49     }
50 
51     function spin(bytes32 s) public { 
52     	if(controller != msg.sender) revert();
53     	do_spin(s);
54     }
55 
56     function get_hash (uint16 i) constant returns (bytes32){
57         return hashes[i];
58     }
59     
60     function () payable {
61         do_spin(bytes32(msg.value));
62     }
63     
64 }