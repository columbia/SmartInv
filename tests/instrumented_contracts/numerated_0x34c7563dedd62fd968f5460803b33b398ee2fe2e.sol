1 pragma solidity ^0.4.11;
2 contract SafeMath {
3   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
10     assert(b > 0);
11     uint256 c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15 
16   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
22     uint256 c = a + b;
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
46   function balanceOf(address who) constant returns (uint256);
47   function allowance(address owner, address spender) constant returns (uint256);
48   function transfer(address to, uint256 value) returns (bool ok);
49   function transferFrom(address from, address to, uint256 value) returns (bool ok);
50   function approve(address spender, uint256 value) returns (bool ok);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 contract StandardToken is ERC20, SafeMath {
56   mapping(address => uint256) balances;
57   mapping (address => mapping (address => uint256)) allowed;
58   uint256 public _totalSupply;
59   address public _creator;
60   bool bIsFreezeAll = false;
61 
62   function totalSupply() constant returns (uint256 totalSupply) {
63 	totalSupply = _totalSupply;
64   }
65 
66   function transfer(address _to, uint256 _value) returns (bool success) {
67     require(bIsFreezeAll == false);
68     balances[msg.sender] = safeSub(balances[msg.sender], _value);
69     balances[_to] = safeAdd(balances[_to], _value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75     require(bIsFreezeAll == false);
76     var _allowance = allowed[_from][msg.sender];
77     balances[_to] = safeAdd(balances[_to], _value);
78     balances[_from] = safeSub(balances[_from], _value);
79     allowed[_from][msg.sender] = safeSub(_allowance, _value);
80     Transfer(_from, _to, _value);
81     return true;
82   }
83 
84   function balanceOf(address _owner) constant returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88   function approve(address _spender, uint256 _value) returns (bool success) {
89 	require(bIsFreezeAll == false);
90     allowed[msg.sender][_spender] = _value;
91     Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 
95   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
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
106 contract CGCG is StandardToken {
107 
108   string public name = "CGCG";
109   string public symbol = "CGCG";
110   uint256 public constant decimals = 18;
111   uint256 public constant INITIAL_SUPPLY = 3000000000 * 10 ** decimals;	
112 
113   
114   function CGCG() {
115     _totalSupply = INITIAL_SUPPLY;
116 	_creator = 0x4B76a15083F80d920008d2B893a1f1c8D96fd794;
117 	balances[_creator] = INITIAL_SUPPLY;
118 	bIsFreezeAll = false;
119   }
120   
121   function destroy() {
122 	require(msg.sender == _creator);
123 	suicide(_creator);
124   }
125 
126 }