1 contract SafeMath {
2   function safeMul(uint a, uint b) internal constant returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function safeDiv(uint a, uint b) internal constant returns (uint) {
9     require(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14 
15   function safeSub(uint a, uint b) internal constant returns (uint) {
16     require(b <= a);
17     return a - b;
18   }
19 
20   function safeAdd(uint a, uint b) internal constant returns (uint) {
21     uint c = a + b;
22     assert(c>=a && c>=b);
23     return c;
24   }
25 }
26 
27 contract PreICO is SafeMath {
28   mapping (address => uint) public balance;
29   uint public tokensIssued;
30 
31   address public ethWallet;
32 
33   uint public startPreico; // block
34   uint public endPreico; // timestamp
35 
36   // Tokens with decimals
37   uint public limit;
38 
39   event e_Purchase(address who, uint amount);
40 
41   modifier onTime() {
42     require(block.number >= startPreico && now <= endPreico);
43 
44     _;
45   }
46 
47   function PreICO(uint start, uint end, uint tokens, address wallet) {
48     startPreico = start;
49     endPreico = end;
50     limit = tokens;
51     ethWallet = wallet;
52   }
53 
54   function() payable {
55     buy();
56   }
57 
58   function buy() onTime payable {
59     uint numTokens = safeDiv(safeMul(msg.value, getRate(msg.value)), 1 ether);
60     assert(tokensIssued + numTokens <= limit);
61 
62     ethWallet.transfer(msg.value);
63     balance[msg.sender] += numTokens;
64     tokensIssued += numTokens;
65 
66     e_Purchase(msg.sender, numTokens);
67   }
68 
69   function getRate(uint value) constant returns (uint rate) {
70     if(value < 150 ether)
71       revert();
72     else if(value < 300 ether)
73       rate = 5800*10**18;
74     else if(value < 1500 ether)
75       rate = 6000*10**18;
76     else if(value < 3000 ether)
77       rate = 6200*10**18;
78     else if(value >= 3000 ether)
79       rate = 6400*10**18;
80   }
81 }