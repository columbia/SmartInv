1 pragma solidity ^0.4.8;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
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
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract ERC20 {
52   uint256 public totalSupply;
53   function balanceOf(address who) constant returns (uint256);
54   function allowance(address owner, address spender) constant returns (uint256);
55 
56   function transfer(address to, uint256 value) returns (bool ok);
57   function transferFrom(address from, address to, uint256 value) returns (bool ok);
58   function approve(address spender, uint256 value) returns (bool ok);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract StandardToken is ERC20, SafeMath {
64 
65   mapping(address => uint256) balances;
66   mapping (address => mapping (address => uint256)) allowed;
67 
68   function transfer(address _to, uint256 _value) returns (bool success) {
69     balances[msg.sender] = safeSub(balances[msg.sender], _value);
70     balances[_to] = safeAdd(balances[_to], _value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76     var _allowance = allowed[_from][msg.sender];
77 
78     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
79     // if (_value > _allowance) throw;
80 
81     balances[_to] = safeAdd(balances[_to], _value);
82     balances[_from] = safeSub(balances[_from], _value);
83     allowed[_from][msg.sender] = safeSub(_allowance, _value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function balanceOf(address _owner) constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92   function approve(address _spender, uint256 _value) returns (bool success) {
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99     return allowed[_owner][_spender];
100   }
101 
102 }
103 
104 /// @title EplusCoin Token
105 contract EplusCoinToken is StandardToken {
106 
107     string public name = "EplusCoin";          // name of the token
108     string public symbol = "EPLUS";
109     uint256 public decimals = 8;                  // token has 8 digit precision
110     string public version = 'H0.1';
111 
112     uint256 public totalSupply = 16800000000000000;  // total supply of 168 Million Tokens
113 
114     /// @notice Initializes the contract and allocates all initial tokens to the owner
115     function EplusCoinToken() {
116         balances[msg.sender] = totalSupply;
117     }
118 }