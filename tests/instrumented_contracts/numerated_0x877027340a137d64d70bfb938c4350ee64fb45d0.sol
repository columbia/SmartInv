1 pragma solidity ^0.4.11;
2 
3 contract RedEnvelope{
4     address owner;
5     uint remainSize = 0;
6     uint min = 1000000000000000; // 0.001 ETH
7     uint max;
8     uint256 money;
9     mapping (address => uint) earned;
10     
11     function RedEnvelope() {
12         owner = msg.sender;
13     }
14     
15     function despoit(uint count) returns (uint){
16         if (msg.sender != owner) {
17             throw;
18         }
19         remainSize += count;
20         return remainSize;
21     }
22     
23     function randomGen(uint seed, uint max) constant returns (uint randomNumber) {
24         return(uint(sha3(block.blockhash(block.number - 1), seed)) % max);
25     }
26 
27     function multiBlockRandomGen(uint seed, uint size) constant returns (uint randomNumber) {
28         uint n = 0;
29         for (uint i = 0; i < size; i++){
30             if (uint(sha3(block.blockhash(block.number - i - 1), seed )) % 2 == 0)
31                 n += 2 ** i ;
32         }
33         return n;
34     }
35     
36     function goodluck(uint seed) payable {
37         if (earned[msg.sender] == 1) {
38             throw;
39         }
40         if (remainSize == 0) {
41             throw;
42         }
43         earned[msg.sender] = 1;
44         remainSize -= 1;
45         if (remainSize == 0) {
46             msg.sender.transfer(this.balance);
47             return;
48         }
49         max = this.balance / remainSize * 2;
50         money = randomGen(seed, max);
51         if (money < min) {
52             money = min;
53         }
54         msg.sender.transfer(money);
55     }
56     
57     function goodbye() {
58         if (msg.sender != owner) {
59             throw;
60         }
61         suicide(owner);
62     }
63 }