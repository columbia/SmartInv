1 // ECE 398 SC - Smart Contracts and Blockchain Security
2 // http://soc1024.ece.illinois.edu/teaching/ece398sc/spring2018/
3 // March 28, 2018
4 
5 // This is an extra credit smart contract Pinata. It contains a puzzle 
6 // involving hash functions (you should be able to solve it pretty easily)
7 
8 pragma solidity ^0.4.21;
9 contract TestContract {
10     function SHA256(string s) public pure returns(bytes32) {
11         return(sha256(s));
12     }
13 
14     mapping ( bytes32 => uint ) public amount;
15     
16     // Pay for a preimage
17     function commitTo(bytes32 hash) public payable {
18         amount[hash] = msg.value;
19     }
20     
21     // Claim a hash preimage
22     
23     // On mainnet, for the class Spring 2018,
24     // The contract's address is 0x9faf31f1546ec47e99321045bbfda8ab5ef60b74
25     //
26     // A value has already been committed to ($10 of ETH)
27     // The is the hash of a string, of the form "word1 word2 word3", where
28     // word1,2,3 are randomly chosen words from the BIP39 word list.
29     // Call the view
30     // "amount(0xee67868e1463033b8cf103066b1d476b1698ca9a3e60c068430c520d2725b246)"
31     // to check whether it has been taken or not!
32     // 
33     // The first person to solve it wins the prize! The game is not too fun
34     // for anyone else unfortunately :(
35     
36     event BountyClaimed(string note, uint);
37     function claim(string s) public payable {
38         emit BountyClaimed("bounty claimed for eth amount:", amount[sha256(s)]);
39         msg.sender.transfer( amount[sha256(s)] );
40     }
41 
42 }