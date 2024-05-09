1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic interface for TradeNetCoin token.
5  * @dev Simpler version of ERC20 interface.
6  * @dev See https://github.com/ethereum/EIPs/issues/179.
7  */
8 contract ERC20Basic {
9 	uint256 public totalSupply;
10 	function balanceOf(address who) public constant returns (uint256);
11 	function transfer(address to, uint256 value) public returns (bool);
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface for TradeNetCoin token.
18  * @dev See https://github.com/ethereum/EIPs/issues/20.
19  */
20 contract ERC20 is ERC20Basic {
21 	function transferFrom(address from, address to, uint256 value) public returns (bool);
22 	function approve(address spender, uint256 value) public returns (bool);
23 	event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath.
29  * @dev Math operations with safety checks that throw on error.
30  */
31 library SafeMath {
32 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33 		uint256 c = a * b;
34 		assert(a == 0 || c / a == b);
35 		return c;
36 	}
37 
38 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
39 		// assert(b > 0); // Solidity automatically throws when dividing by 0.
40 		uint256 c = a / b;
41 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold.
42 		return c;
43 	}
44 
45 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46 		assert(b <= a);
47 		return a - b;
48 	}
49 
50 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
51 		uint256 c = a + b;
52 		assert(c >= a);
53 		return c;
54 	}
55 }
56 
57 
58 /**
59  * @dev Implementation of ERC20Basic interface for TradeNetCoin token.
60  * @dev Simpler version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63 	using SafeMath for uint256;
64 
65 	mapping(address => uint256) balances;
66 
67 	/**
68 	* @dev Function transfers token for a specified address.
69 	* @param _to is the address to transfer to.
70 	* @param _value is The amount to be transferred.
71 	*/
72 	function transfer(address _to, uint256 _value) public returns (bool) {
73 		balances[msg.sender] = balances[msg.sender].sub(_value);
74 		balances[_to] = balances[_to].add(_value);
75 		Transfer(msg.sender, _to, _value);
76 		return true;
77 	}
78 
79 	/**
80 	* @dev Function gets the balance of the specified address.
81 	* @param _owner is the address to query the the balance of.
82 	* @dev Function returns an uint256 representing the amount owned by the passed address.
83 	*/
84 	function balanceOf(address _owner) public constant returns (uint256 balance) {
85 		return balances[_owner];
86 	}
87 }
88 
89 
90 /**
91  * @dev Implementation of ERC20 interface for TradeNetCoin token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97 	mapping (address => mapping (address => uint256)) allowed;
98 
99 
100 	/**
101 	* @dev Function transfers tokens from one address to another.
102 	* @param _from is the address which you want to send tokens from.
103 	* @param _to is the address which you want to transfer to.
104 	* @param _value is the amout of tokens to be transfered.
105 	*/
106 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107 		uint256 _allowance = allowed[_from][msg.sender];
108 
109 		// Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110 		// require (_value <= _allowance);
111 
112 		balances[_to] = balances[_to].add(_value);
113 		balances[_from] = balances[_from].sub(_value);
114 		allowed[_from][msg.sender] = _allowance.sub(_value);
115 		Transfer(_from, _to, _value);
116 		return true;
117 	}
118 
119 	/**
120 	* @dev Function approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
121 	* @param _spender is the address which will spend the funds.
122 	* @param _value is the amount of tokens to be spent.
123 	*/
124 	function approve(address _spender, uint256 _value) public returns (bool) {
125 
126 		// To change the approve amount you first have to reduce the addresses`
127 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
128 		//  already 0 to mitigate the race condition described here:
129 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132 		allowed[msg.sender][_spender] = _value;
133 		Approval(msg.sender, _spender, _value);
134 		return true;
135 	}
136 
137 	/**
138 	* @dev Function is to check the amount of tokens that an owner allowed to a spender.
139 	* @param _owner is the address which owns the funds.
140 	* @param _spender is the address which will spend the funds.
141 	* @dev Function returns a uint256 specifing the amount of tokens still avaible for the spender.
142 	*/
143 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144 		return allowed[_owner][_spender];
145 	}
146 }
147 
148 
149 /**
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154 	address public owner;
155 
156 	/**
157 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
158 	*/
159 	function Ownable() public {
160 		owner = msg.sender;
161 	}
162 
163 	/**
164 	* @dev Modifier throws if called by any account other than the owner.
165 	*/
166 	modifier onlyOwner() {
167 		require(msg.sender == owner);
168 		_;
169 	}
170 
171 	/**
172 	* @dev Function allows the current owner to transfer control of the contract to a newOwner.
173 	* @param newOwner is the address to transfer ownership to.
174 	*/
175 	function transferOwnership(address newOwner) onlyOwner public {
176 		if (newOwner != address(0)) {
177 			owner = newOwner;
178 		}
179 	}
180 }
181 
182 
183 /**
184  * @title BurnableToken for TradeNetCoin token.
185  * @dev Token that can be irreversibly burned.
186  */
187 contract BurnableToken is StandardToken, Ownable {
188 
189 	/**
190 	* @dev Function burns a specific amount of tokens.
191 	* @param _value The amount of token to be burned.
192 	*/
193 	function burn(uint _value) public onlyOwner {
194 		require(_value > 0);
195 		address burner = msg.sender;
196 		balances[burner] = balances[burner].sub(_value);
197 		totalSupply = totalSupply.sub(_value);
198 		Burn(burner, _value);
199 	}
200 	event Burn(address indexed burner, uint indexed value);
201 }
202 
203 
204 /**
205  * @title TradeNetCoin token.
206  * @dev Total supply is 16 million tokens. No opportunity for additional minting of coins.
207  * @dev All unsold and unused tokens can be burned in order to more increase token price.
208  */
209 contract TradeNetCoin is BurnableToken {
210 	string public constant name = "TradeNetCoin";
211 	string public constant symbol = "TNC";
212 	uint8 public constant decimals = 2;
213 	uint256 public constant INITIAL_SUPPLY = 16000000 *( 10 ** uint256(decimals)); // 16,000,000 tokens
214 
215 	function TradeNetCoin() public {
216 		totalSupply = INITIAL_SUPPLY;
217 		balances[msg.sender] = INITIAL_SUPPLY;
218 	}
219 }