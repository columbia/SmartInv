1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6 		if (a == 0) {
7 			return 0;
8 		}
9 
10 		c = a * b;
11 		assert(c / a == b);
12 		return c;
13 	}
14 
15 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 		return a / b;
17 	}
18 
19 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20 		assert(b <= a);
21 		return a - b;
22 	}
23 
24 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25 		c = a + b;
26 		assert(c >= a);
27 		return c;
28 	}
29 }
30 
31 contract ERC20Basic {
32 	function totalSupply() public view returns (uint256);
33 	function balanceOf(address who) public view returns (uint256);
34 	function transfer(address to, uint256 value) public returns (bool);
35 	event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39 	function allowance(address owner, address spender)
40 		public view returns (uint256);
41 
42 	function transferFrom(address from, address to, uint256 value)
43 		public returns (bool);
44 
45 	function approve(address spender, uint256 value) public returns (bool);
46 		event Approval(
47 			address indexed owner,
48 			address indexed spender,
49 			uint256 value
50 		);
51 }
52 
53 contract BasicToken is ERC20Basic {
54 	using SafeMath for uint256;
55 
56 	mapping(address => uint256) balances;
57 
58 	uint256 totalSupply_;
59 
60 	function totalSupply() public view returns (uint256) {
61 		return totalSupply_;
62 	}
63 
64 	function transfer(address _to, uint256 _value) public returns (bool) {
65 		require(_value <= balances[msg.sender]);
66 		require(_to != address(0));
67 
68 		balances[msg.sender] = balances[msg.sender].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		emit Transfer(msg.sender, _to, _value);
71 		return true;
72 	}
73 
74 	function balanceOf(address _owner) public view returns (uint256) {
75 		return balances[_owner];
76 	}
77 
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82 	mapping (address => mapping (address => uint256)) internal allowed;
83 
84 
85 	function transferFrom(
86 		address _from,
87 		address _to,
88 		uint256 _value
89 	)
90 		public
91 		returns (bool)
92 	{
93 		require(_value <= balances[_from]);
94 		require(_value <= allowed[_from][msg.sender]);
95 		require(_to != address(0));
96 
97 		balances[_from] = balances[_from].sub(_value);
98 		balances[_to] = balances[_to].add(_value);
99 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100 		emit Transfer(_from, _to, _value);
101 		return true;
102 	}
103 
104 	function approve(address _spender, uint256 _value) public returns (bool) {
105 		allowed[msg.sender][_spender] = _value;
106 		emit Approval(msg.sender, _spender, _value);
107 		return true;
108 	}
109 
110 	function allowance(
111 		address _owner,
112 		address _spender
113 	 )
114 		public
115 		view
116 		returns (uint256)
117 	{
118 		return allowed[_owner][_spender];
119 	}
120 
121 	function increaseApproval(
122 		address _spender,
123 		uint256 _addedValue
124 	)
125 		public
126 		returns (bool)
127 	{
128 		allowed[msg.sender][_spender] = (
129 			allowed[msg.sender][_spender].add(_addedValue));
130 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131 		return true;
132 	}
133 
134 	function decreaseApproval(
135 		address _spender,
136 		uint256 _subtractedValue
137 	)
138 		public
139 		returns (bool)
140 	{
141 		uint256 oldValue = allowed[msg.sender][_spender];
142 		if (_subtractedValue >= oldValue) {
143 			allowed[msg.sender][_spender] = 0;
144 		} else {
145 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146 		}
147 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148 		return true;
149 	}
150 
151 }
152 
153 contract Ownable {
154 	address public owner;
155 
156 
157 	event OwnershipRenounced(address indexed previousOwner);
158 	event OwnershipTransferred(
159 		address indexed previousOwner,
160 		address indexed newOwner
161 	);
162 
163 
164 	constructor() public {
165 		owner = msg.sender;
166 	}
167 
168 	modifier onlyOwner() {
169 		require(msg.sender == owner);
170 		_;
171 	}
172 
173 	function renounceOwnership() public onlyOwner {
174 		emit OwnershipRenounced(owner);
175 		owner = address(0);
176 	}
177 
178 	function transferOwnership(address _newOwner) public onlyOwner {
179 		_transferOwnership(_newOwner);
180 	}
181 
182 	function _transferOwnership(address _newOwner) internal {
183 		require(_newOwner != address(0));
184 		emit OwnershipTransferred(owner, _newOwner);
185 		owner = _newOwner;
186 	}
187 }
188 
189 contract MintableToken is StandardToken, Ownable {
190 	event Mint(address indexed to, uint256 amount);
191 	event MintFinished();
192 
193 	bool public mintingFinished = false;
194 
195 
196 	modifier canMint() {
197 		require(!mintingFinished);
198 		_;
199 	}
200 
201 	modifier hasMintPermission() {
202 		require(msg.sender == owner);
203 		_;
204 	}
205 
206 	function mint(
207 		address _to,
208 		uint256 _amount
209 	)
210 		hasMintPermission
211 		canMint
212 		public
213 		returns (bool)
214 	{
215 		totalSupply_ = totalSupply_.add(_amount);
216 		balances[_to] = balances[_to].add(_amount);
217 		emit Mint(_to, _amount);
218 		emit Transfer(address(0), _to, _amount);
219 		return true;
220 	}
221 
222 	function finishMinting() onlyOwner canMint public returns (bool) {
223 		mintingFinished = true;
224 		emit MintFinished();
225 		return true;
226 	}
227 }
228 
229 contract SimexToken is MintableToken {
230 
231 	string public constant name = "SimexToken";
232 	string public constant symbol = "SMX";
233 	uint8 public constant decimals = 0;
234 
235 }