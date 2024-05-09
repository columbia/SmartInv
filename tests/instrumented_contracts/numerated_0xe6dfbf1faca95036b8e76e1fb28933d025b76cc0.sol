1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9 	function totalSupply() public view returns (uint256);
10 	function balanceOf(address who) public view returns (uint256);
11 	function transfer(address to, uint256 value) public returns (bool);
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21 	/**
22 	* @dev Multiplies two numbers, throws on overflow.
23 	*/
24 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25 		if (a == 0) {
26 			return 0;
27 		}
28 		uint256 c = a * b;
29 		assert(c / a == b);
30 		return c;
31 	}
32 
33 	/**
34 	* @dev Integer division of two numbers, truncating the quotient.
35 	*/
36 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
37 		// assert(b > 0); // Solidity automatically throws when dividing by 0
38 		uint256 c = a / b;
39 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
40 		return c;
41 	}
42 
43 	/**
44 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45 	*/
46 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47 		assert(b <= a);
48 		return a - b;
49 	}
50 
51 	/**
52 	* @dev Adds two numbers, throws on overflow.
53 	*/
54 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
55 		uint256 c = a + b;
56 		assert(c >= a);
57 		return c;
58 	}
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66 	using SafeMath for uint256;
67 
68 	mapping(address => uint256) balances;
69 
70 	modifier onlyPayloadSize(uint size) {
71 		assert(msg.data.length >= size + 4);
72 		_;
73 	}
74 	
75 	uint256 totalSupply_;
76 
77 	/**
78 	* @dev total number of tokens in existence
79 	*/
80 	function totalSupply() public view returns (uint256) {
81 		return totalSupply_;
82 	}
83 
84 	/**
85 	* @dev transfer token for a specified address
86 	* @param _to The address to transfer to.
87 	* @param _value The amount to be transferred.
88 	*/
89 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
90 		require(_to != address(0));
91 		require(_value <= balances[msg.sender]);
92 
93 		// SafeMath.sub will throw if there is not enough balance.
94 		balances[msg.sender] = balances[msg.sender].sub(_value);
95 		balances[_to] = balances[_to].add(_value);
96 		emit Transfer(msg.sender, _to, _value);
97 		return true;
98 	}
99 
100 	/**
101 	* @dev Gets the balance of the specified address.
102 	* @param _owner The address to query the the balance of.
103 	* @return An uint256 representing the amount owned by the passed address.
104 	*/
105 	function balanceOf(address _owner) public view returns (uint256 balance) {
106 		return balances[_owner];
107 	}
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115 	function allowance(address owner, address spender) public view returns (uint256);
116 	function transferFrom(address from, address to, uint256 value) public returns (bool);
117 	function approve(address spender, uint256 value) public returns (bool);
118 	event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129 	mapping (address => mapping (address => uint256)) internal allowed;
130 
131 	/**
132 	 * @dev Transfer tokens from one address to another
133 	 * @param _from address The address which you want to send tokens from
134 	 * @param _to address The address which you want to transfer to
135 	 * @param _value uint256 the amount of tokens to be transferred
136 	 */
137 	function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
138 		require(_to != address(0));
139 		require(_value <= balances[_from]);
140 		require(_value <= allowed[_from][msg.sender]);
141 
142 		balances[_from] = balances[_from].sub(_value);
143 		balances[_to] = balances[_to].add(_value);
144 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145 		emit Transfer(_from, _to, _value);
146 		return true;
147 	}
148 
149 	/**
150 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151 	 * @param _spender The address which will spend the funds.
152 	 * @param _value The amount of tokens to be spent.
153 	 */
154 	function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
155 		// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156 		// require((_value==0) || (allowed[msg.sender][_spender]==0));
157 
158 		allowed[msg.sender][_spender] = _value;
159 		emit Approval(msg.sender, _spender, _value);
160 		return true;
161 	}
162 
163 	/**
164 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
165 	 * @param _owner address The address which owns the funds.
166 	 * @param _spender address The address which will spend the funds.
167 	 * @return A uint256 specifying the amount of tokens still available for the spender.
168 	 */
169 	function allowance(address _owner, address _spender) public view returns (uint256) {
170 		return allowed[_owner][_spender];
171 	}
172 
173 	/**
174 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
175 	 * @param _spender The address which will spend the funds.
176 	 * @param _addedValue The amount of tokens to increase the allowance by.
177 	 */
178 	function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2 * 32) public returns (bool) {
179 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181 		return true;
182 	}
183 
184 	/**
185 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
186 	 * @param _spender The address which will spend the funds.
187 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
188 	 */
189 	function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool) {
190 		uint oldValue = allowed[msg.sender][_spender];
191 		if (_subtractedValue > oldValue) {
192 			allowed[msg.sender][_spender] = 0;
193 		} else {
194 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195 		}
196 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197 		return true;
198 	}
199 }
200 contract Libereum is StandardToken {
201 	string public constant name = "Libereum";
202 	string public constant symbol = "LIBER";
203 	uint256 public constant decimals = 18;
204 	uint256 public constant initialSupply = 100000000 * (10 ** uint256(decimals));
205 	
206 	constructor(address _ownerAddress) public {
207 		totalSupply_ = initialSupply;
208 		balances[_ownerAddress] = initialSupply;
209 	}
210 }