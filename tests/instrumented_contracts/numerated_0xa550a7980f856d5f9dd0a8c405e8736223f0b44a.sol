1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns(uint256) {
14 		assert(b > 0);
15 		uint256 c = a / b;
16 		assert(a == b * c + a % b);
17 		return c;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21 		assert(b <= a);
22 		return a - b;
23 	}
24 
25 	function add(uint256 a, uint256 b) internal pure returns(uint256) {
26 		uint256 c = a + b;
27 		assert(c >= a);
28 		return c;
29 	}
30 }
31 
32 contract Owned {
33 
34 	address public owner;
35 	address public newOwner;
36 
37 	event OwnershipTransferred(address indexed _from, address indexed _to);
38 
39 	constructor() public {
40 		owner = msg.sender;
41 	}
42 
43 	modifier onlyOwner {
44 		require(msg.sender == owner);
45 		_;
46 	}
47 
48 	function transferOwnership(address _newOwner) public onlyOwner {
49 		newOwner = _newOwner;
50 	}
51 
52 	function acceptOwnership() public {
53 		require(msg.sender == newOwner);
54 		emit OwnershipTransferred(owner, newOwner);
55 		owner = newOwner;
56 		newOwner = address(0);
57 	}
58 }
59 
60 contract ERC20Interface {
61 
62 	function totalSupply() public constant returns (uint);
63 	function balanceOf(address tokenOwner) public constant returns (uint balance);
64 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
65 	function transfer(address to, uint tokens) public returns (bool success);
66 	function approve(address spender, uint tokens) public returns (bool success);
67 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69 	event Transfer(address indexed from, address indexed to, uint tokens);
70 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 
72 }
73 
74 contract ERC20 is ERC20Interface, Owned {
75 
76 	using SafeMath for uint;
77 
78 	string  public symbol;
79 	string  public name;
80 	uint8   public decimals;
81 	uint    public totalSupply;
82 
83 	constructor() public {
84 		symbol = "BTO";
85 		name = "Bitron Coin";
86 		decimals = 9;
87 		totalSupply = 50000000 * 10 ** uint(decimals);
88 		balances[owner] = totalSupply;
89 		emit Transfer(address(0), owner, totalSupply);
90 	}
91 
92 	mapping(address => uint) balances;
93 	mapping(address => mapping(address => uint)) allowed;
94 
95 	function totalSupply() public constant returns (uint) {
96 		return totalSupply  - balances[address(0)];
97 	}
98 
99 	function balanceOf(address tokenOwner) public constant returns (uint balance) {
100 		return balances[tokenOwner];
101 	}
102 
103 	function transfer(address to, uint tokens) public returns (bool success) {
104 		require((tokens <= balances[msg.sender]));
105         require((tokens > 0));
106         require(to != address(0));
107 		balances[msg.sender] = balances[msg.sender].sub(tokens);
108 		balances[to] = balances[to].add(tokens);
109 		emit Transfer(msg.sender, to, tokens);
110 		return true;
111 	}
112 
113 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
114 	    require((tokens <= allowed[from][msg.sender] ));
115         require((tokens > 0));
116         require(to != address(0));
117 		require(balances[from] >= tokens);
118 		balances[from] = balances[from].sub(tokens);
119 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
120 		balances[to] = balances[to].add(tokens);
121 		emit Transfer(from, to, tokens);
122 		return true;
123 	}
124 
125 	function approve(address spender, uint tokens) public returns (bool success) {
126 	    require(spender != address(0));
127 	    require(tokens <= balances[msg.sender]);
128 		allowed[msg.sender][spender] = tokens;
129 		emit Approval(msg.sender, spender, tokens);
130 		return true;
131 	}
132 
133 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
134 		return allowed[tokenOwner][spender];
135 	}
136 
137 }
138 
139 contract BitronCoin is ERC20 {
140 
141 	uint    public oneEth       = 10000;
142 	uint    public icoEndDate   = 1535673600;
143 	bool    public stopped      = false;
144 	address public ethFundMain  = 0x1e6d1Fc2d934D2E4e2aE5e4882409C3fECD769dF;
145 
146 	modifier onlyWhenPause(){
147 		require( stopped == true );
148 		_;
149 	}
150 
151 	modifier onlyWhenResume(){
152 		require( stopped == false );
153 		_;
154 	}
155 
156 	function() payable public {
157 		if( msg.sender != owner && msg.value >= 0.02 ether && now <= icoEndDate && stopped == false ){
158 			uint tokens;
159 			tokens                = ( msg.value / 10 ** uint(decimals) ) * oneEth;
160 			balances[msg.sender] += tokens;
161 			balances[owner]      -= tokens;
162 			emit Transfer(owner, msg.sender, tokens);
163 		} else {
164 			revert();
165 		}
166 
167 	}
168 
169 	function drain() external onlyOwner {
170 		ethFundMain.transfer(address(this).balance);
171 	}
172 
173 	function PauseICO() external onlyOwner onlyWhenResume
174 	{
175 		stopped = true;
176 	}
177 
178 	function ResumeICO() external onlyOwner onlyWhenPause
179 	{
180 		stopped = false;
181 	}
182 	
183 	function sendTokens(address[] a, uint[] v) public {
184 	    uint i;
185 	    uint len = a.length;
186 	    for( i=0; i<len; i++  ){
187 	        transfer(a[i], v[i] * 10 ** uint(decimals));
188 	    }
189 	}
190 
191 }