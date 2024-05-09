1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
41     return a < b ? a : b;
42   }
43 }
44 
45 contract ERC20 {
46   function totalSupply() public view returns (uint256 supply);
47   function balanceOf(address who) public view returns (uint256 balance);
48   function allowance(address owner, address spender) public view returns (uint256 remaining);
49   function transfer(address to, uint256 value) public returns (bool ok);
50   function transferFrom(address from, address to, uint256 value) public returns (bool ok);
51   function approve(address spender, uint256 value) public returns (bool ok);
52 
53   event Transfer(address indexed from, address indexed to, uint256 value);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract StandardToken is ERC20, SafeMath {
58   mapping(address => uint256) balances;
59   mapping (address => mapping (address => uint256)) allowed;
60   uint256 public _totalSupply;
61   address public _creator;
62   bool bIsFreezeAll = false;
63 
64   function totalSupply() public view returns (uint256) 
65   {
66     return _totalSupply;
67   }
68 
69   function balanceOf(address _owner) public view returns (uint256) 
70   {
71     return balances[_owner];
72   }
73 
74   function allowance(address _owner, address _spender) public view returns (uint256) 
75   {
76     return allowed[_owner][_spender];
77   }
78 
79   function transfer(address _to, uint256 _value) public returns (bool) 
80   {
81     require(bIsFreezeAll == false);
82     balances[msg.sender] = safeSub(balances[msg.sender], _value);
83     balances[_to] = safeAdd(balances[_to], _value);
84     emit Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
89   {
90     require(bIsFreezeAll == false);
91     uint256 _allowance = allowed[_from][msg.sender];
92     balances[_to] = safeAdd(balances[_to], _value);
93     balances[_from] = safeSub(balances[_from], _value);
94     allowed[_from][msg.sender] = safeSub(_allowance, _value);
95     emit Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   function approve(address _spender, uint256 _value) public returns (bool) 
100   {
101 	  require(bIsFreezeAll == false);
102     allowed[msg.sender][_spender] = _value;
103     emit Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function freezeAll() public
108   {
109     require(msg.sender == _creator);
110     bIsFreezeAll = !bIsFreezeAll;
111   }
112 }
113 
114 contract TYROS is StandardToken {
115   string public name = "TYROS Token";
116   string public symbol = "TYROS";
117   uint256 public constant decimals = 18;
118   uint256 public constant initial_supply = 50 * 10 ** 26;	
119   
120   mapping (address => string) public keys;
121 
122   event LogRegister (address user, string key);
123 
124   constructor() public
125   {
126     _creator = msg.sender;
127     _totalSupply = initial_supply;
128     balances[_creator] = initial_supply;
129     bIsFreezeAll = false;
130   }
131   
132   function destroy() public
133   {
134     require(msg.sender == _creator);
135     selfdestruct(_creator);
136   }
137 
138   function register(string key) public 
139   {
140     keys[msg.sender] = key;
141     emit LogRegister(msg.sender, key);
142   }
143 }