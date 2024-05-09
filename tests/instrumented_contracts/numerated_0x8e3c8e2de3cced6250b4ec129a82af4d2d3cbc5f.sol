1 pragma solidity ^0.4.6;
2 contract SafeMath {
3   function safeMul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function safeDiv(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15 
16   function safeSub(uint a, uint b) internal returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint a, uint b) internal returns (uint) {
22     uint c = a + b;
23     assert(c>=a && c>=b);
24     return c;
25   }
26 
27   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a >= b ? a : b;
29   }
30 
31   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a < b ? a : b;
33   }
34 
35   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
36     return a >= b ? a : b;
37   }
38 
39   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a < b ? a : b;
41   }
42 }
43 
44 contract ERC20 {
45   function totalSupply() constant returns (uint256 totalSupply);
46   function balanceOf(address who) constant returns (uint);
47   function allowance(address owner, address spender) constant returns (uint);
48   function transfer(address to, uint value) returns (bool ok);
49   function transferFrom(address from, address to, uint value) returns (bool ok);
50   function approve(address spender, uint value) returns (bool ok);
51   event Transfer(address indexed from, address indexed to, uint value);
52   event Approval(address indexed owner, address indexed spender, uint value);
53   event FrozenFunds(address target, bool frozen);
54 }
55 
56 contract StandardToken is ERC20, SafeMath {
57   mapping(address => uint) balances;
58   mapping (address => mapping (address => uint)) allowed;
59   mapping (address => bool) public frozenAccount;
60   uint public _totalSupply;
61   address public _creator;
62   bool bIsFreezeAll = false;
63 
64   function totalSupply() constant returns (uint256 totalSupply) {
65 	totalSupply = _totalSupply;
66   }
67 
68   function transfer(address _to, uint _value) returns (bool success) {
69     require(bIsFreezeAll == false);
70 	require(!frozenAccount[msg.sender]);
71 	require(!frozenAccount[_to]);
72     balances[msg.sender] = safeSub(balances[msg.sender], _value);
73     balances[_to] = safeAdd(balances[_to], _value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
79     require(bIsFreezeAll == false);
80 	require(!frozenAccount[msg.sender]);
81 	require(!frozenAccount[_from]);
82 	require(!frozenAccount[_to]);
83     var _allowance = allowed[_from][msg.sender];
84     balances[_to] = safeAdd(balances[_to], _value);
85     balances[_from] = safeSub(balances[_from], _value);
86     allowed[_from][msg.sender] = safeSub(_allowance, _value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _owner) constant returns (uint balance) {
92     return balances[_owner];
93   }
94 
95   function approve(address _spender, uint _value) returns (bool success) {
96 	require(bIsFreezeAll == false);
97 	require(!frozenAccount[msg.sender]);
98 	require(!frozenAccount[_spender]);
99     allowed[msg.sender][_spender] = _value;
100     Approval(msg.sender, _spender, _value);
101     return true;
102   }
103 
104   function allowance(address _owner, address _spender) constant returns (uint remaining) {
105 	require(!frozenAccount[msg.sender]);
106 	require(!frozenAccount[_owner]);
107 	require(!frozenAccount[_spender]);
108     return allowed[_owner][_spender];
109   }
110 
111   function freezeAll()
112   {
113 	require(msg.sender == _creator);
114 	bIsFreezeAll = !bIsFreezeAll;
115   }
116   
117   function mintToken(address target, uint256 mintedAmount) {
118 	require(msg.sender == _creator);
119 	balances[target] += mintedAmount;
120 	_totalSupply += mintedAmount;
121 	Transfer(0, _creator, mintedAmount);
122 	Transfer(_creator, target, mintedAmount);
123   }
124 
125   function freezeAccount(address target, bool freeze) {
126 	require(msg.sender == _creator);
127 	frozenAccount[target] = freeze;
128 	FrozenFunds(target, freeze);
129   }
130 }
131 
132 contract SNS is StandardToken {
133 
134   string public name = "Skyrim Network";
135   string public symbol = "SNS";
136   uint public decimals = 18;
137   uint public INITIAL_SUPPLY = 49900000000000000000000000000;
138   
139   function SNS() {
140     _totalSupply = INITIAL_SUPPLY;
141 	_creator = 0x5bd7Daa872D4e4EBe77420E368C0d683317840bA;
142 	balances[_creator] = INITIAL_SUPPLY;
143 	bIsFreezeAll = false;
144   }
145   
146   function destroy() {
147 	require(msg.sender == _creator);
148 	suicide(_creator);
149   }
150 
151 }