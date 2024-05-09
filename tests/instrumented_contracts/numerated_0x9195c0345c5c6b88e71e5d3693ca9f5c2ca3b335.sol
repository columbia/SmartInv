1 pragma solidity ^0.4.13;
2 
3 contract Privileges {
4     // A person who owns the contract
5     address public owner;
6     // A person who can update the CENT price
7     address public trusted;
8 
9     function Privileges() public payable {
10         owner = msg.sender;
11     }
12 
13     function setTrusted(address addr) onlyOwner public {
14         trusted = addr;
15     }
16 
17     function setNewOwner(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     modifier onlyTrusted {
27         require(msg.sender == trusted || msg.sender == owner);
28         _;
29     }
30 }
31 
32 contract SafeMath {
33     function safeAdd(uint x, uint y) internal pure returns (uint) {
34         uint256 z = x + y;
35         assert((z >= x) && (z >= y));
36         return z;
37     }
38 
39     function safeSub(uint x, uint y) internal pure returns (uint) {
40         assert(x >= y);
41         uint256 z = x - y;
42         return z;
43     }
44 
45     function safeMul(uint x, uint y) internal pure returns (uint) {
46         uint256 z = x * y;
47         assert((x == 0)||(z/x == y));
48         return z;
49     }
50 
51     function safeDiv(uint a, uint b) internal pure returns (uint) {
52         uint c = a / b;
53         return c;
54     }
55 }
56 
57 contract Presale {
58 
59     uint numberOfPurchasers = 0;
60 
61     mapping (uint => address) presaleAddresses;
62     mapping (address => uint) tokensToSend;
63 
64     function Presale() public {
65         addPurchaser(0x41c8f018d10f500d231f723017389da5FF9F45F2, 191625 * ((1 ether / 1 wei) / 10));      
66     }
67 
68     function addPurchaser(address addr, uint tokens) private {
69         presaleAddresses[numberOfPurchasers] = addr;
70         tokensToSend[addr] = tokens;
71         numberOfPurchasers++;
72     }
73 
74 }
75 
76 contract Casper is SafeMath, Privileges, Presale {    
77 
78     string public constant NAME = "Casper Pre-ICO Token";
79     string public constant SYMBOL = "CSPT";
80     uint public constant DECIMALS = 18;
81 
82     uint public constant MIN_PRICE = 750; // 600USD per Ether
83     uint public constant MAX_PRICE = 1250; // 1000USD per Ether
84     uint public price = 1040;  // 832USD per Ehter
85     uint public totalSupply = 0;
86 
87     // PreICO hard cap
88     uint public constant TOKEN_SUPPLY_LIMIT = 1300000 * (1 ether / 1 wei); // 1 300 000 CSPT
89 
90     // PreICO timings
91     uint public beginTime;
92     uint public endTime;
93 
94     uint public index = 0;
95 
96     bool sendPresale = true;
97 
98     mapping (address => uint) balances;
99     mapping (uint => address) participants;
100 
101 
102     function Casper() Privileges() public {
103         beginTime = now;
104         endTime = now + 2 weeks;
105     }
106 
107     function() payable public {
108         require (now < endTime);
109         require (totalSupply < TOKEN_SUPPLY_LIMIT);
110         uint newTokens = msg.value * price;
111         if (newTokens + totalSupply <= TOKEN_SUPPLY_LIMIT) {
112             balances[msg.sender] = safeAdd(balances[msg.sender], newTokens);
113             totalSupply = safeAdd(totalSupply, newTokens);    
114         } else {
115             uint tokens = safeSub(TOKEN_SUPPLY_LIMIT, totalSupply); 
116             balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
117             totalSupply = TOKEN_SUPPLY_LIMIT;
118         }
119         addParicipant(msg.sender);
120     }
121 
122     function balanceOf(address addr) public constant returns (uint) {
123         return balances[addr];
124     }
125 
126     function setPrice(uint newPrice) onlyTrusted public {
127         require (newPrice > MIN_PRICE && newPrice < MAX_PRICE);
128         price = newPrice;
129     }
130 
131     function sendPresaleTokens() onlyOwner public {
132         require(sendPresale);
133         for (uint i = 0; i < numberOfPurchasers; i++) {
134             address addr = presaleAddresses[i];
135             uint tokens = tokensToSend[addr];
136             balances[addr] = tokens;
137             totalSupply = safeAdd(totalSupply, tokens);  
138         }
139         index = safeAdd(index, numberOfPurchasers);
140         sendPresale = false;
141     }
142 
143     function withdrawEther(uint eth) onlyOwner public {
144         owner.transfer(eth);
145     }
146 
147     function addParicipant(address addr) private {
148         participants[index] = addr;
149         index++;
150     }
151 
152 }