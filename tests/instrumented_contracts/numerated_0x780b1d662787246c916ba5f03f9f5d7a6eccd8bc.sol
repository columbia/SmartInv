1 pragma solidity ^0.4.18;
2 contract ERC20Basic {
3 function totalSupply() public view returns (uint256);
4 function balanceOf(address who) public view returns (uint256);
5 function transfer(address to, uint256 value) public returns (bool);
6 event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 library SafeMath {
10 
11 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12 if (a == 0) {
13 return 0;
14 }
15 uint256 c = a * b;
16 assert(c / a == b);
17 return c;
18 }
19 
20 
21 function div(uint256 a, uint256 b) internal pure returns (uint256) {
22 uint256 c = a / b;
23 return c;
24 }
25 
26 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27 assert(b <= a);
28 return a - b;
29 }
30 
31 function add(uint256 a, uint256 b) internal pure returns (uint256) {
32 uint256 c = a + b;
33 assert(c >= a);
34 return c;
35 }
36 }
37 
38 
39 contract BasicToken is ERC20Basic {
40 using SafeMath for uint256;
41 
42 mapping(address => uint256) balances;
43 
44 uint256 totalSupply_;
45 
46 function totalSupply() public view returns (uint256) {
47 return totalSupply_;
48 }
49 
50 
51 function transfer(address _to, uint256 _value) public returns (bool) {
52 require(_to != address(0));
53 require(_value <= balances[msg.sender]);
54 
55 balances[msg.sender] = balances[msg.sender].sub(_value);
56 balances[_to] = balances[_to].add(_value);
57 emit Transfer(msg.sender, _to, _value);
58 return true;
59 }
60 
61 
62 function balanceOf(address _owner) public view returns (uint256 balance) {
63 return balances[_owner];
64 }
65 }
66 
67 
68 contract ERC20 is ERC20Basic {
69 function allowance(address owner, address spender) public view returns (uint256);
70 function transferFrom(address from, address to, uint256 value) public returns (bool);
71 function approve(address spender, uint256 value) public returns (bool);
72 event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78 mapping (address => mapping (address => uint256)) internal allowed;
79 
80 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81 require(_to != address(0));
82 require(_value <= balances[_from]);
83 require(_value <= allowed[_from][msg.sender]);
84 
85 balances[_from] = balances[_from].sub(_value);
86 balances[_to] = balances[_to].add(_value);
87 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88 emit Transfer(_from, _to, _value);
89 return true;
90 }
91 
92 
93 function approve(address _spender, uint256 _value) public returns (bool) {
94 allowed[msg.sender][_spender] = _value;
95 emit Approval(msg.sender, _spender, _value);
96 return true;
97 }
98 
99 
100 function allowance(address _owner, address _spender) public view returns (uint256) {
101 return allowed[_owner][_spender];
102 }
103 
104 
105 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
106 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
107 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108 return true;
109 }
110 
111 
112 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
113 uint oldValue = allowed[msg.sender][_spender];
114 if (_subtractedValue > oldValue) {
115 allowed[msg.sender][_spender] = 0;
116 } else {
117 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
118 }
119 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120 return true;
121 }
122 }
123 
124 
125 contract APPToken612 is StandardToken {
126 
127 string public constant name = "Asia Pacific Peace 612"; 
128 string public constant symbol = "APP612"; 
129 uint8 public constant decimals = 8;
130 
131 uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
132 
133 
134 function APPToken612() public {
135 totalSupply_ = INITIAL_SUPPLY;
136 balances[msg.sender] = INITIAL_SUPPLY;
137 emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
138 }
139 }