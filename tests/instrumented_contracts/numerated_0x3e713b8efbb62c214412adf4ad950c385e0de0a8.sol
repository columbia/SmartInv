1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4 	address public owner;
5 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 	function Ownable() {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner() {
12 		require(msg.sender == owner);
13 		_;
14 	}
15 
16 	function transferOwnership(address newOwner) onlyOwner public {
17 		require(newOwner != address(0));
18 		OwnershipTransferred(owner, newOwner);
19 		owner = newOwner;
20 	}
21 }
22 
23 library SafeMath {
24 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25 		uint256 c = a * b;
26 		assert(a == 0 || c / a == b);
27 		return c;
28 	}
29 
30 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
31 		uint256 c = a / b;
32 		return c;
33 	}
34 
35 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
41 		uint256 c = a + b;
42 		assert(c >= a);
43 		return c;
44 	}
45 }
46 
47 contract ERC20 {
48 	uint256 public totalSupply;
49 	function balanceOf(address who) public constant returns (uint256);
50 	function transfer(address to, uint256 value) public returns (bool);
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52 
53 	function allowance(address owner, address spender) public constant returns (uint256);
54 	function transferFrom(address from, address to, uint256 value) public returns (bool);
55 	function approve(address spender, uint256 value) public returns (bool);
56 	event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20 {
60 	using SafeMath for uint256;
61 
62 	mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 
65 	function transfer(address _to, uint256 _value) public returns (bool) {
66 		require(_to != address(0));
67 
68 		balances[msg.sender] = balances[msg.sender].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		Transfer(msg.sender, _to, _value);
71 		return true;
72 	}
73 
74 	function balanceOf(address _owner) public constant returns (uint256 balance) {
75 		return balances[_owner];
76 	}
77 
78 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79 		require(_to != address(0));
80 
81 		uint256 _allowance = allowed[_from][msg.sender];
82 
83 		balances[_from] = balances[_from].sub(_value);
84 		balances[_to] = balances[_to].add(_value);
85 		allowed[_from][msg.sender] = _allowance.sub(_value);
86 		Transfer(_from, _to, _value);
87 		return true;
88 	}
89 
90 	function approve(address _spender, uint256 _value) public returns (bool) {
91 		allowed[msg.sender][_spender] = _value;
92 		Approval(msg.sender, _spender, _value);
93 		return true;
94 	}
95 
96 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97 		return allowed[_owner][_spender];
98 	}
99 }
100 
101 contract T8EXToken is StandardToken {
102 	string public constant name = "T8EX Token";
103     string public constant symbol = "T8EX";
104     uint8  public constant decimals = 18;
105 
106 	address public minter; 
107 	uint    public tokenSaleEndTime; 
108 
109 	// token lockup for cornerstone investors
110 	mapping(address=>uint) public lockedBalanceCor; 
111 	mapping(uint=>address) lockedBalanceCor_index;
112 	uint lockedBalanceCor_count;
113 
114 	// token lockup for private investors
115 	mapping(address=>uint) public lockedBalancePri; 
116 	mapping(uint=>address) lockedBalancePri_index;
117 	uint lockedBalancePri_count;
118 
119 	modifier onlyMinter {
120 		require (msg.sender == minter);
121 		_;
122 	}
123 
124 	modifier whenMintable {
125 		require (now <= tokenSaleEndTime);
126 		_;
127 	}
128 
129     modifier validDestination(address to) {
130         require(to != address(this));
131         _;
132     }
133 
134 	function T8EXToken(address _minter, uint _tokenSaleEndTime) public {
135 		minter = _minter;
136 		tokenSaleEndTime = _tokenSaleEndTime;
137     }
138 
139 	function transfer(address _to, uint _value)
140         public
141         validDestination(_to)
142         returns (bool) 
143     {
144         return super.transfer(_to, _value);
145     }
146 
147 	function transferFrom(address _from, address _to, uint _value)
148         public
149         validDestination(_to)
150         returns (bool) 
151     {
152         return super.transferFrom(_from, _to, _value);
153     }
154 
155 	function createToken(address _recipient, uint _value)
156 		whenMintable
157 		onlyMinter
158 		returns (bool)
159 	{
160 		balances[_recipient] += _value;
161 		totalSupply += _value;
162 		return true;
163 	}
164 
165 	// Create an lockedBalance which cannot be traded until admin make it liquid.
166 	// Can only be called by crowdfund contract before the end time.
167 	function createLockedTokenCor(address _recipient, uint _value)
168 		whenMintable
169 		onlyMinter
170 		returns (bool) 
171 	{
172 		lockedBalanceCor_index[lockedBalanceCor_count] = _recipient;
173 		lockedBalanceCor[_recipient] += _value;
174 		lockedBalanceCor_count++;
175 
176 		totalSupply += _value;
177 		return true;
178 	}
179 
180 	// Make sender's locked balance liquid when called after lockout period.
181 	function makeLiquidCor()
182 		onlyMinter
183 	{
184 		for (uint i=0; i<lockedBalanceCor_count; i++) {
185 			address investor = lockedBalanceCor_index[i];
186 			balances[investor] += lockedBalanceCor[investor];
187 			lockedBalanceCor[investor] = 0;
188 		}
189 	}
190 
191 	// Create an lockedBalance which cannot be traded until admin make it liquid.
192 	// Can only be called by crowdfund contract before the end time.
193 	function createLockedTokenPri(address _recipient, uint _value)
194 		whenMintable
195 		onlyMinter
196 		returns (bool) 
197 	{
198 		lockedBalancePri_index[lockedBalancePri_count] = _recipient;
199 		lockedBalancePri[_recipient] += _value;
200 		lockedBalancePri_count++;
201 
202 		totalSupply += _value;
203 		return true;
204 	}
205 
206 	// Make sender's locked balance liquid when called after lockout period.
207 	function makeLiquidPri()
208 		onlyMinter
209 	{
210 		for (uint i=0; i<lockedBalancePri_count; i++) {
211 			address investor = lockedBalancePri_index[i];
212 			balances[investor] += lockedBalancePri[investor];
213 			lockedBalancePri[investor] = 0;
214 		}
215 	}
216 }