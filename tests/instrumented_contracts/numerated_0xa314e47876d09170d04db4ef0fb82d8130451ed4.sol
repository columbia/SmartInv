1 pragma solidity ^0.4.0;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     require(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     require(b > 0);
12     uint c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     require(c>=a && c>=b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 }
44 
45 
46 contract ERC20 {
47   uint public totalSupply;
48   function balanceOf(address who) constant returns (uint);
49   function allowance(address owner, address spender) constant returns (uint);
50 
51   function transfer(address to, uint value) returns (bool ok);
52   function transferFrom(address from, address to, uint value) returns (bool ok);
53   function approve(address spender, uint value) returns (bool ok);
54   event Transfer(address indexed from, address indexed to, uint value);
55   event Approval(address indexed owner, address indexed spender, uint value);
56 }
57 
58 
59 contract StandardToken is ERC20, SafeMath {
60 
61   /* Actual balances of token holders */
62   mapping(address => uint) balances;
63 
64   /* approve() allowances */
65   mapping (address => mapping (address => uint)) allowed;
66 
67   /* Interface declaration */
68   function isToken() public constant returns (bool weAre) {
69     return true;
70   }
71 
72   function transfer(address _to, uint _value) returns (bool success) {
73 
74     if (_value < 1) {
75       revert();
76     }
77 
78     balances[msg.sender] = safeSub(balances[msg.sender], _value);
79     balances[_to] = safeAdd(balances[_to], _value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
85 
86     if (_value < 1) {
87       revert();
88     }
89 
90     uint _allowance = allowed[_from][msg.sender];
91 
92     balances[_to] = safeAdd(balances[_to], _value);
93     balances[_from] = safeSub(balances[_from], _value);
94     allowed[_from][msg.sender] = safeSub(_allowance, _value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   function balanceOf(address _owner) constant returns (uint balance) {
100     return balances[_owner];
101   }
102 
103   function approve(address _spender, uint _value) returns (bool success) {
104 
105     // To change the approve amount you first have to reduce the addresses`
106     //  allowance to zero by calling `approve(_spender, 0)` if it is not
107     //  already 0 to mitigate the race condition described here:
108     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
110 
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   function allowance(address _owner, address _spender) constant returns (uint remaining) {
117     return allowed[_owner][_spender];
118   }
119 }
120 
121 contract OneUpToken is StandardToken {
122   address public creator;
123   ERC20 public yoshicoin;
124 
125   function name() constant returns (string) { return "1UP"; }
126   function symbol() constant returns (string) { return "UP"; }
127   function decimals() constant returns (uint8) { return 0; }
128 
129   function OneUpToken(
130     address _yoshicoin
131   ) {
132     creator = msg.sender;
133     yoshicoin = ERC20(_yoshicoin);
134   }
135 
136   function() payable {
137     require(msg.value >= 1 finney);
138 
139     // Try to move yoshicoins into this contract's address. They will no
140     // longer be usable since this contract can't spend them.
141     require(yoshicoin.transferFrom(msg.sender, this, 5));
142 
143     totalSupply = safeAdd(totalSupply, 1);
144     balances[msg.sender] = safeAdd(balances[msg.sender], 1);
145 
146     // This will make the mint transaction apper in EtherScan.io
147     // We can remove this after there is a standardized minting event
148     Transfer(0, msg.sender, 1);
149 
150     creator.transfer(msg.value);
151   }
152 }