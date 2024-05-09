1 pragma solidity ^0.4.11;
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
43 }
44 
45 contract ERC20 {
46   function totalSupply() constant returns (uint256 totalSupply);
47   function balanceOf(address who) constant returns (uint256);
48   function allowance(address owner, address spender) constant returns (uint256);
49   function transfer(address to, uint256 value) returns (bool ok);
50   function transferFrom(address from, address to, uint256 value) returns (bool ok);
51   function approve(address spender, uint256 value) returns (bool ok);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract StandardToken is ERC20, SafeMath {
57   mapping(address => uint256) balances;
58   mapping (address => mapping (address => uint256)) allowed;
59   uint256 public _totalSupply;
60   address public _creator;
61   bool bIsFreezeAll = false;
62 
63   function totalSupply() constant returns (uint256 totalSupply) {
64 	totalSupply = _totalSupply;
65   }
66 
67   function transfer(address _to, uint256 _value) returns (bool success) {
68     require(bIsFreezeAll == false);
69     balances[msg.sender] = safeSub(balances[msg.sender], _value);
70     balances[_to] = safeAdd(balances[_to], _value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76     require(bIsFreezeAll == false);
77     var _allowance = allowed[_from][msg.sender];
78     balances[_to] = safeAdd(balances[_to], _value);
79     balances[_from] = safeSub(balances[_from], _value);
80     allowed[_from][msg.sender] = safeSub(_allowance, _value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89   function approve(address _spender, uint256 _value) returns (bool success) {
90 	require(bIsFreezeAll == false);
91     allowed[msg.sender][_spender] = _value;
92     Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97     return allowed[_owner][_spender];
98   }
99 
100   function freezeAll()
101   {
102 	require(msg.sender == _creator);
103 	bIsFreezeAll = !bIsFreezeAll;
104   }
105 }
106 
107 contract COINBIG is StandardToken {
108 
109   string public name = "COINBIG";
110   string public symbol = "CB";
111   uint256 public constant decimals = 18;
112   uint256 public constant INITIAL_SUPPLY = 10000000000 * 10 ** decimals;	
113 
114   
115   function COINBIG() {
116     _totalSupply = INITIAL_SUPPLY;
117 	_creator = 0xfCe1155052AF6c8CB04EDA1CeBB390132E2F0012;
118 	balances[_creator] = INITIAL_SUPPLY;
119 	bIsFreezeAll = false;
120   }
121   
122   function destroy() {
123 	require(msg.sender == _creator);
124 	suicide(_creator);
125   }
126 
127 }