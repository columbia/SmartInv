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
53 }
54 
55 contract StandardToken is ERC20, SafeMath {
56   mapping(address => uint) balances;
57   mapping (address => mapping (address => uint)) allowed;
58   uint public _totalSupply;
59   address public _creator;
60   bool bIsFreezeAll = false;
61 
62   function totalSupply() constant returns (uint256 totalSupply) {
63 	totalSupply = _totalSupply;
64   }
65 
66   function transfer(address _to, uint _value) returns (bool success) {
67     require(bIsFreezeAll == false);
68     balances[msg.sender] = safeSub(balances[msg.sender], _value);
69     balances[_to] = safeAdd(balances[_to], _value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
75     require(bIsFreezeAll == false);
76     var _allowance = allowed[_from][msg.sender];
77     balances[_to] = safeAdd(balances[_to], _value);
78     balances[_from] = safeSub(balances[_from], _value);
79     allowed[_from][msg.sender] = safeSub(_allowance, _value);
80     Transfer(_from, _to, _value);
81     return true;
82   }
83 
84   function balanceOf(address _owner) constant returns (uint balance) {
85     return balances[_owner];
86   }
87 
88   function approve(address _spender, uint _value) returns (bool success) {
89 	require(bIsFreezeAll == false);
90     allowed[msg.sender][_spender] = _value;
91     Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 
95   function allowance(address _owner, address _spender) constant returns (uint remaining) {
96     return allowed[_owner][_spender];
97   }
98 
99   function freezeAll()
100   {
101 	require(msg.sender == _creator);
102 	bIsFreezeAll = !bIsFreezeAll;
103   }
104 }
105 
106 contract COINBIG is StandardToken {
107 
108   string public name = "COINBIG";
109   string public symbol = "CB";
110   uint public decimals = 18;
111   uint public INITIAL_SUPPLY = 10000000000000000000000000000;
112   
113   function COINBIG() {
114     _totalSupply = INITIAL_SUPPLY;
115 	_creator = 0x34625c78472AbBb80190d8be945D949D07d95D12;
116 	balances[_creator] = INITIAL_SUPPLY;
117 	bIsFreezeAll = false;
118   }
119   
120   function destroy() {
121 	require(msg.sender == _creator);
122 	suicide(_creator);
123   }
124 
125 }