1 pragma solidity ^0.4.24;
2 
3 library SafeMath { 
4 function mul(uint256 a, uint256 b) internal pure returns (uint256) { 
5 if (a == 0) {
6 return 0;
7 }
8 
9 uint256 c = a * b;
10 require(c / a == b);
11 
12 return c;
13 } 
14 function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 require(b > 0);
16 uint256 c = a / b; 
17 return c;
18 } 
19 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20 require(b <= a);
21 uint256 c = a - b;
22 
23 return c;
24 } 
25 function add(uint256 a, uint256 b) internal pure returns (uint256) {
26 uint256 c = a + b;
27 require(c >= a);
28 
29 return c;
30 } 
31 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32 require(b != 0);
33 return a % b;
34 }
35 }
36 
37 contract ERC20Interface {
38 function totalSupply() public constant returns (uint);
39 function balanceOf(address tokenOwner) public constant returns (uint balance);
40 function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41 function transfer(address to, uint tokens) public returns (bool success);
42 function approve(address spender, uint tokens) public returns (bool success);
43 function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45 event Transfer(address indexed from, address indexed to, uint tokens);
46 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }  
48 contract ApproveAndCallFallBack {
49 function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 } 
51 contract Owned {
52 address public owner;
53 address public newOwner;
54 
55 event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57 constructor() public {
58 owner = msg.sender;
59 }
60 
61 modifier onlyOwner {
62 require(msg.sender == owner);
63 _;
64 }
65 
66 function transferOwnership(address _newOwner) public onlyOwner {
67 newOwner = _newOwner;
68 }
69 function acceptOwnership() public {
70 require(msg.sender == newOwner);
71 emit OwnershipTransferred(owner, newOwner);
72 owner = newOwner;
73 newOwner = address(0);
74 }
75 }  
76 contract FixedSupplyToken is ERC20Interface, Owned {
77 using SafeMath for uint;
78 
79 string public symbol;
80 string public  name;
81 uint8 public decimals;
82 uint _totalSupply; 
83 
84 bool public crowdsaleEnabled;
85 uint public ethPerToken;
86 uint public bonusMinEth;
87 uint public bonusPct; 
88 
89 mapping(address => uint) balances;
90 mapping(address => mapping(address => uint)) allowed; 
91 event Burn(address indexed from, uint256 value);
92 event Bonus(address indexed from, uint256 value);  
93 constructor() public {
94 symbol = "DN8";
95 name = "PLDGR.ORG";
96 decimals = 18;
97 _totalSupply = 450000000000000000000000000;
98 
99 
100 crowdsaleEnabled = false;
101 ethPerToken = 20000;
102 bonusMinEth = 0;
103 bonusPct = 0; 
104 
105 balances[owner] = _totalSupply;
106 emit Transfer(address(0), owner, _totalSupply);
107 } 
108 function totalSupply() public view returns (uint) {
109 return _totalSupply.sub(balances[address(0)]);
110 } 
111 function balanceOf(address tokenOwner) public view returns (uint balance) {
112 return balances[tokenOwner];
113 } 
114 function transfer(address to, uint tokens) public returns (bool success) {
115 balances[msg.sender] = balances[msg.sender].sub(tokens);
116 balances[to] = balances[to].add(tokens);
117 emit Transfer(msg.sender, to, tokens);
118 return true;
119 } 
120 function approve(address spender, uint tokens) public returns (bool success) {
121 allowed[msg.sender][spender] = tokens;
122 emit Approval(msg.sender, spender, tokens);
123 return true;
124 } 
125 function transferFrom(address from, address to, uint tokens) public returns (bool success) {
126 balances[from] = balances[from].sub(tokens);
127 allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
128 balances[to] = balances[to].add(tokens);
129 emit Transfer(from, to, tokens);
130 return true;
131 } 
132 function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
133 return allowed[tokenOwner][spender];
134 } 
135 function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
136 allowed[msg.sender][spender] = tokens;
137 emit Approval(msg.sender, spender, tokens);
138 ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
139 return true;
140 } 
141 function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
142 return ERC20Interface(tokenAddress).transfer(owner, tokens);
143 } 
144 function () public payable { 
145 require(crowdsaleEnabled);  
146 uint ethValue = msg.value; 
147 uint tokens = ethValue.mul(ethPerToken); 
148 if(bonusPct > 0 && ethValue >= bonusMinEth){ 
149 uint bonus = tokens.div(100).mul(bonusPct); 
150 emit Bonus(msg.sender, bonus); 
151 tokens = tokens.add(bonus);
152 } 
153 balances[owner] = balances[owner].sub(tokens);
154 balances[msg.sender] = balances[msg.sender].add(tokens); 
155 emit Transfer(owner, msg.sender, tokens);
156 }  
157 function enableCrowdsale() public onlyOwner{
158 crowdsaleEnabled = true; 
159 } 
160 function disableCrowdsale() public onlyOwner{
161 crowdsaleEnabled = false; 
162 } 
163 function setTokenPrice(uint _ethPerToken) public onlyOwner{ 
164 ethPerToken = _ethPerToken;
165 }  
166 function setBonus(uint _bonusPct, uint _minEth) public onlyOwner {
167 bonusMinEth = _minEth;
168 bonusPct = _bonusPct;
169 } 
170 function burn(uint256 _value) public onlyOwner {
171 require(_value > 0);
172 require(_value <= balances[msg.sender]); 
173 
174 address burner = msg.sender; 
175 balances[burner] = balances[burner].sub(_value); 
176 _totalSupply = _totalSupply.sub(_value);
177 
178 emit Burn(burner, _value); 
179 }  
180 function withdraw(uint _amount) onlyOwner public {
181 require(_amount > 0); 
182 require(_amount <= address(this).balance);     
183 
184 owner.transfer(_amount);
185 }
186 
187 
188 }