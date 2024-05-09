1 /*
2 
3 SHTCOIN (SHT)
4 
5 THE NAME YOU KNOW
6 
7 WEB:      https://shtcoin.cash
8 
9 DISCORD:  https://discord.gg/SRhBEtK
10 
11 When your grandkids ask how you were able to afford the million dollar bribes to get them 
12 into college.........SHTCOIN.
13 
14 */
15 
16 
17 pragma solidity ^0.4.10;
18 
19 contract SafeMath {
20 
21 
22 
23     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
24       uint256 z = x + y;
25       assert((z >= x) && (z >= y));
26       return z;
27     }
28 
29     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
30       assert(x >= y);
31       uint256 z = x - y;
32       return z;
33     }
34 
35     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
36       uint256 z = x * y;
37       assert((x == 0)||(z/x == y));
38       return z;
39     }
40 
41 }
42 
43 contract Token {
44     uint256 public totalSupply;
45     function balanceOf(address _owner) constant returns (uint256 balance);
46     function transfer(address _to, uint256 _value) returns (bool success);
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
48     function approve(address _spender, uint256 _value) returns (bool success);
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 
55 /*  ERC 20 token */
56 contract StandardToken is Token {
57 
58     function transfer(address _to, uint256 _value) returns (bool success) {
59       if (balances[msg.sender] >= _value && _value > 0) {
60         balances[msg.sender] -= _value;
61         balances[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64       } else {
65         return false;
66       }
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
70       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
71         balances[_to] += _value;
72         balances[_from] -= _value;
73         allowed[_from][msg.sender] -= _value;
74         Transfer(_from, _to, _value);
75         return true;
76       } else {
77         return false;
78       }
79     }
80 
81     function balanceOf(address _owner) constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint256 _value) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
92       return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97 }
98 
99 contract SHTCoin is StandardToken, SafeMath {
100 
101     // metadata
102     string public constant name = "SHTCOIN";
103     string public constant symbol = "SHT";
104     uint256 public constant decimals = 18;
105     string public version = "1.0";
106 
107     // contracts
108     address public ethFundDeposit;      // deposit address for ETH for SHT HQ
109     address public SHTFundDeposit;      // deposit address for SHT User Fund
110 
111     // crowdsale parameters
112     bool public isFinalized;              // switched to true in operational state
113     uint256 public fundingStartBlock;
114     uint256 public fundingEndBlock;
115     uint256 public constant SHTFund = 5000 * (10**4) * 10**decimals;   // 5000b SHT reserved for SHT HQ use
116     uint256 public constant tokenExchangeRate = 10000; // 10000 SHT tokens per 1 ETH
117     uint256 public constant tokenCreationCap =  5000 * (10**4) * 10**decimals;
118     uint256 public constant tokenCreationMin =  675 * (10**4) * 10**decimals;
119 
120 
121     // events
122     event LogRefund(address indexed _to, uint256 _value);
123     event CreateSHT(address indexed _to, uint256 _value);
124 
125     // constructor
126     function SHTCoin(
127         address _ethFundDeposit,
128         address _SHTFundDeposit,
129         uint256 _fundingStartBlock,
130         uint256 _fundingEndBlock)
131     {
132       isFinalized = true;                   //we won't have a crowdsale, airdrops will deliver tokens to the community
133       ethFundDeposit = _ethFundDeposit;
134       SHTFundDeposit = _SHTFundDeposit;
135       fundingStartBlock = _fundingStartBlock;
136       fundingEndBlock = _fundingEndBlock;
137       totalSupply = SHTFund;
138       balances[SHTFundDeposit] = SHTFund;    // Deposit SHT
139       CreateSHT(SHTFundDeposit, SHTFund);  // logs SHT fund
140     }
141 
142 
143 
144 
145 
146 }