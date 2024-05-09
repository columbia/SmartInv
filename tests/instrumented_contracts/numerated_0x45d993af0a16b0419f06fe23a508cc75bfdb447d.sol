1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     if (msg.sender != owner) {
13       throw;
14     }
15     _;
16   }
17 
18   function transferOwnership(address newOwner) onlyOwner {
19     if (newOwner != address(0)) {
20       owner = newOwner;
21     }
22   }
23 
24 }
25 
26 contract SafeMath {
27   function safeMul(uint a, uint b) internal returns (uint) {
28     uint c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function safeDiv(uint a, uint b) internal returns (uint) {
34     assert(b > 0);
35     uint c = a / b;
36     assert(a == b * c + a % b);
37     return c;
38   }
39 
40   function safeSub(uint a, uint b) internal returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function safeAdd(uint a, uint b) internal returns (uint) {
46     uint c = a + b;
47     assert(c>=a && c>=b);
48     return c;
49   }
50 
51   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a >= b ? a : b;
53   }
54 
55   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a < b ? a : b;
57   }
58 
59   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a >= b ? a : b;
61   }
62 
63   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a < b ? a : b;
65   }
66 
67   function assert(bool assertion) internal {
68     if (!assertion) {
69       throw;
70     }
71   }
72 }
73 
74 contract ERC20 {
75   uint public totalSupply;
76   function balanceOf(address who) constant returns (uint);
77   function allowance(address owner, address spender) constant returns (uint);
78 
79   function transfer(address to, uint value) returns (bool ok);
80   function transferFrom(address from, address to, uint value) returns (bool ok);
81   function approve(address spender, uint value) returns (bool ok);
82   event Transfer(address indexed from, address indexed to, uint value);
83   event Approval(address indexed owner, address indexed spender, uint value);
84 }
85 
86 contract StandardToken is ERC20, SafeMath {
87 
88   mapping(address => uint) balances;
89   mapping (address => mapping (address => uint)) allowed;
90 
91   function transfer(address _to, uint _value) returns (bool success) {
92     balances[msg.sender] = safeSub(balances[msg.sender], _value);
93     balances[_to] = safeAdd(balances[_to], _value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
99     var _allowance = allowed[_from][msg.sender];
100 
101     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
102     // if (_value > _allowance) throw;
103 
104     balances[_to] = safeAdd(balances[_to], _value);
105     balances[_from] = safeSub(balances[_from], _value);
106     allowed[_from][msg.sender] = safeSub(_allowance, _value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) constant returns (uint balance) {
112     return balances[_owner];
113   }
114 
115   function approve(address _spender, uint _value) returns (bool success) {
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   function allowance(address _owner, address _spender) constant returns (uint remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125 }
126 
127 /// Money Skelton is a faggot cuckold.The real flippening is ETH for BTC you dumb mongrol niggers, BTC master race, FUCK ETH! 
128 contract whiteToken is Ownable, StandardToken {
129 
130     string public name = "White Pride";            // name of the token
131     string public symbol = "HTLR";               // ERC20 compliant 4 digit token code
132     uint public decimals = 18;                  // token has 18 digit precision
133 
134     uint public totalSupply = 148800 ether;  // total supply of 6 Million Tokens
135 
136     /// @notice Initializes the contract and allocates all initial tokens to the owner
137     function whiteToken() {
138         balances[msg.sender] = totalSupply;
139     }
140   
141     //////////////// owner only functions below
142 
143     /// @notice To transfer token contract ownership
144     /// @param _newOwner The address of the new owner of this contract
145     function transferOwnership(address _newOwner) onlyOwner {
146         balances[_newOwner] = balances[owner];
147         balances[owner] = 0;
148         Ownable.transferOwnership(_newOwner);
149     }
150 }