1 pragma solidity ^ 0.4.18;
2 
3 contract Ownable {
4 address public owner;
5 
6 function Ownable() public {
7 owner = msg.sender;
8 }
9 
10 modifier onlyOwner() {
11 require(msg.sender == owner);
12 _;
13 }
14 
15 function transferOwnership(address newOwner) public onlyOwner {
16 require(newOwner != address(0));
17 owner = newOwner;
18 }
19 }
20 
21 library SafeMath {
22 function mul(uint256 a, uint256 b) internal pure returns(uint256) {
23 if (a == 0) {
24 return 0;
25 }
26 uint256 c = a * b;
27 assert(c / a == b);
28 return c;
29 }
30 
31 function div(uint256 a, uint256 b) internal pure returns(uint256) {
32 uint256 c = a / b;
33 return c;
34 }
35 
36 function sub(uint256 a, uint256 b) internal pure returns(uint256) {
37 assert(b <= a);
38 return a - b;
39 }
40 
41 function add(uint256 a, uint256 b) internal pure returns(uint256) {
42 uint256 c = a + b;
43 assert(c >= a);
44 return c;
45 }
46 }
47 
48 contract Pausable is Ownable {
49 event Pause();
50 event Unpause();
51 
52 bool public paused = false;
53 
54 modifier whenNotPaused() {
55 require(!paused);
56 _;
57 }
58 
59 modifier whenPaused() {
60 require(paused);
61 _;
62 }
63 
64 function pause() onlyOwner whenNotPaused public {
65 paused = true;
66 Pause();
67 }
68 
69 function unpause() onlyOwner whenPaused public {
70 paused = false;
71 Unpause();
72 }
73 }
74 
75 contract ERC20 {
76 function totalSupply() public view returns(uint256);
77 function balanceOf(address who) public view returns(uint256);
78 function transfer(address to, uint256 value) public returns(bool);
79 function allowance(address owner, address spender) public view returns(uint256);
80 function transferFrom(address from, address to, uint256 value) public returns(bool);
81 function approve(address spender, uint256 value) public returns(bool);
82 
83 event Approval(address indexed owner, address indexed spender, uint256 value);
84 event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ACEToken is ERC20, Ownable, Pausable {
88 
89 using SafeMath for uint256;
90 
91 string public name;
92 string public symbol;
93 uint8 public decimals;
94 uint256 initialSupply;
95 uint256 totalSupply_;
96 
97 event Burn(address burner, uint256 value);
98 
99 mapping(address => uint256) balances;
100 mapping(address => bool) internal locks;
101 mapping(address => mapping(address => uint256)) internal allowed;
102 
103 function ACEToken() public {
104 name = "ACE Entertainment Token";
105 symbol = "ACE";
106 decimals = 6;
107 initialSupply = 2000000000;
108 totalSupply_ = initialSupply * (10 ** uint(decimals));
109 balances[owner] = totalSupply_;
110 Transfer(address(0), owner, totalSupply_);
111 }
112 
113 function totalSupply() public view returns(uint256) {
114 return totalSupply_;
115 }
116 
117 function transfer(address _to, uint256 _value) public whenNotPaused returns(bool) {
118 require(_to != address(0));
119 require(_value <= balances[msg.sender]);
120 require(locks[msg.sender] == false);
121 
122 // SafeMath.sub will throw if there is not enough balance.
123 balances[msg.sender] = balances[msg.sender].sub(_value);
124 balances[_to] = balances[_to].add(_value);
125 Transfer(msg.sender, _to, _value);
126 return true;
127 }
128 
129 function balanceOf(address _owner) public view returns(uint256 balance) {
130 return balances[_owner];
131 }
132 
133 function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {
134 require(_to != address(0));
135 require(_value <= balances[_from]);
136 require(_value <= allowed[_from][msg.sender]);
137 require(locks[_from] == false);
138 
139 balances[_from] = balances[_from].sub(_value);
140 balances[_to] = balances[_to].add(_value);
141 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142 Transfer(_from, _to, _value);
143 return true;
144 }
145 
146 function approve(address _spender, uint256 _value) public whenNotPaused returns(bool) {
147 require(_value > 0);
148 allowed[msg.sender][_spender] = _value;
149 Approval(msg.sender, _spender, _value);
150 return true;
151 }
152 
153 function allowance(address _owner, address _spender) public view returns(uint256) {
154 return allowed[_owner][_spender];
155 }
156 
157 function lock(address _owner) public onlyOwner returns(bool) {
158 require(locks[_owner] == false);
159 locks[_owner] = true;
160 return true;
161 }
162 
163 function unlock(address _owner) public onlyOwner returns(bool) {
164 require(locks[_owner] == true);
165 locks[_owner] = false;
166 return true;
167 }
168 
169 function showLockState(address _owner) public view returns(bool) {
170 return locks[_owner];
171 }
172 
173 function burn(uint256 _value) external onlyOwner {
174 require(_value <= balances[msg.sender]);
175 // no need to require value <= totalSupply, since that would imply the
176 // sender's balance is greater than the totalSupply, which *should* be an assertion failure
177 
178 address burner = msg.sender;
179 balances[burner] = balances[burner].sub(_value);
180 totalSupply_ = totalSupply_.sub(_value);
181 Burn(burner, _value);
182 Transfer(burner, address(0), _value);
183 }
184 }