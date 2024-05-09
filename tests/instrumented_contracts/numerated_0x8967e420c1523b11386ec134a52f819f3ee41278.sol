1 // SPDX-License-Identifier: No License
2 pragma solidity 0.6.2;
3 
4 // ----------------------------------------------------------------------------
5 // 'Decentral Life' contract
6 //
7 // Symbol      : WDLF
8 // Name        : Decentral Life
9 // Total supply: 10 000 000 000
10 // Decimals    : 5
11 // ----------------------------------------------------------------------------
12 
13 
14 
15 /**
16  * @title ERC20 interface
17  */
18 interface ERC20
19 {
20 	function balanceOf(address who) external view returns (uint256);
21 	function transfer(address to, uint256 value) external returns (bool);
22 	function allowance(address owner, address spender) external view returns (uint256);
23 	function transferFrom(address from, address to, uint256 value) external returns (bool);
24 	function approve(address spender, uint256 value) external returns (bool);
25 	event Transfer(address indexed from, address indexed to, uint256 value);
26 	event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 /**
30  * @title ERC223 interface
31  */
32 interface ERC223
33 {
34 	function transfer(address to, uint256 value, bytes calldata data) external;
35 	event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
36 }
37 
38 /*
39 Base class contracts willing to accept ERC223 token transfers must conform to.
40 */
41 
42 abstract contract ERC223ReceivingContract
43 {
44 	function tokenFallback(address _from, uint256 _value, bytes calldata _data) virtual external;
45 }
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath
52 {
53 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
54 	{
55 		if (a == 0)
56 		{
57 			return 0;
58 		}
59 		uint256 c = a * b;
60 		assert(c / a == b);
61 		return c;
62 	}
63 
64 	function div(uint256 a, uint256 b) internal pure returns (uint256)
65 	{
66 		// assert(b > 0); // Solidity automatically throws when dividing by 0
67 		uint256 c = a / b;
68 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 		return c;
70 	}
71 
72 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
73 	{
74 		assert(b <= a);
75 		return a - b;
76 	}
77 
78 	function add(uint256 a, uint256 b) internal pure returns (uint256)
79 	{
80 		uint256 c = a + b;
81 		assert(c >= a);
82 		return c;
83 	}
84 }
85 
86 contract StandardToken is ERC20, ERC223
87 {
88 	using SafeMath for uint256;
89         
90 	uint256 public totalSupply;
91 
92         
93 	mapping (address => uint256) internal balances;
94 	mapping (address => mapping (address => uint256)) internal allowed;
95 
96 	event Burn(address indexed burner, uint256 value);
97 
98 	function transfer(address _to, uint256 _value) external override returns (bool)
99 	{
100 		require(_to != address(0));
101 		require(_value <= balances[msg.sender]);
102 		balances[msg.sender] = balances[msg.sender].sub(_value);
103 		balances[_to] = balances[_to].add(_value);
104 		emit Transfer(msg.sender, _to, _value);
105 		return true;
106 	}
107 
108 	function balanceOf (address _owner) public override view returns (uint256 balance)
109 	{
110 		return balances[_owner];
111 	}
112 
113 	function transferFrom(address _from, address _to, uint256 _value) external override returns (bool)
114 	{
115 		require(_to != address(0));
116 		require(_value <= balances[_from]);
117 		require(_value <= allowed[_from][msg.sender]);
118 
119 		balances[_from] = balances[_from].sub(_value);
120 		balances[_to] = balances[_to].add(_value);
121 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122 		emit Transfer(_from, _to, _value);
123 		return true;
124 	}
125 
126 	function approve(address _spender, uint256 _value) external override returns (bool)
127 	{
128 		allowed[msg.sender][_spender] = _value;
129 		emit Approval(msg.sender, _spender, _value);
130 		return true;
131 	}
132 
133 	function allowance(address _owner, address _spender) public override view returns (uint256)
134 	{
135 		return allowed[_owner][_spender];
136 	}
137 
138 	function increaseApproval(address _spender, uint256 _addedValue) external returns (bool)
139 	{
140 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142 		return true;
143 	}
144 
145 	function decreaseApproval(address _spender, uint256 _subtractedValue) external returns (bool)
146 	{
147 		uint256 oldValue = allowed[msg.sender][_spender];
148 		if (_subtractedValue > oldValue)
149 		{
150 			allowed[msg.sender][_spender] = 0;
151 		}
152 		else
153 		{
154 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155 		}
156 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157 		return true;
158 	}
159 
160 	function transfer(address _to, uint256 _value, bytes calldata _data) external override
161 	{
162 		require(_value > 0 );
163 		if(isContract(_to))
164 		{
165 			ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
166 			receiver.tokenFallback(msg.sender, _value, _data);
167 		}
168 		balances[msg.sender] = balances[msg.sender].sub(_value);
169 		balances[_to] = balances[_to].add(_value);
170 		emit Transfer(msg.sender, _to, _value, _data);
171 	}
172 
173 	function isContract(address _addr) view private returns (bool is_contract)
174 	{
175 		uint256 length;
176 		assembly
177 		{
178 			length := extcodesize(_addr)
179 		}
180 		return (length>0);
181 	}
182 
183 	function burn(uint256 _value) external
184 	{
185 		require(_value <= balances[msg.sender]);
186 
187 		balances[msg.sender] = balances[msg.sender].sub(_value);
188 		totalSupply = totalSupply.sub(_value);
189 		emit Burn(msg.sender, _value);
190 	}
191 }
192 
193 contract WDLF is StandardToken
194 {
195 	string public name = "Decentral Life";
196 	string public symbol = "WDLF";
197 	uint8 public constant decimals = 5;
198         address internal  _admin;
199 
200 	uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
201 
202 	constructor(address _owner) public
203 	{
204                  _admin = msg.sender;
205 		totalSupply = 10000000000 * DECIMALS_MULTIPLIER;
206 		balances[_owner] = totalSupply;
207 	  	emit Transfer(address(0), _owner, totalSupply);
208 	}
209 
210 
211       modifier ownership()  {
212     require(msg.sender == _admin);
213         _;
214     }
215 
216 
217 
218   //Admin can transfer his ownership to new address
219   function transferownership(address _newaddress) public returns(bool){
220       require(msg.sender==_admin);
221       _admin=_newaddress;
222       return true;
223   }
224 
225 
226 }