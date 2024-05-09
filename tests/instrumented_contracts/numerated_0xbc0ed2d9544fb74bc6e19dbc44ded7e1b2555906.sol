1 pragma solidity 0.4.23;
2 
3 /**
4  * eMangir Token
5  * www.emangir.com
6 */
7 
8 
9 // @title Abstract ERC20 token interface
10 contract AbstractToken {
11 	function balanceOf(address owner) public view returns (uint256 balance);
12 	function transfer(address to, uint256 value) public returns (bool success);
13 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
14 	function approve(address spender, uint256 value) public returns (bool success);
15 	function allowance(address owner, address spender) public view returns (uint256 remaining);
16 
17 	event Transfer(address indexed from, address indexed to, uint256 value);
18 	event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract Owned {
22     address public owner;
23 
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner public {
34         owner = newOwner;
35     }
36 }
37 
38 // @title SafeMath contract - Math operations with safety checks.
39 // @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
40 contract SafeMath {
41 	/**
42 	* @dev Multiplies two numbers, throws on overflow.
43 	*/
44 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45 		if (a == 0) {
46 			return 0;
47 		}
48 		uint256 c = a * b;
49 		assert(c / a == b);
50 		return c;
51 	}
52 
53 	/**
54 	* @dev Integer division of two numbers, truncating the quotient.
55 	*/
56 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
57 		return a / b;
58 	}
59 
60 	/**
61 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62 	*/
63 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64 		assert(b <= a);
65 		return a - b;
66 	}
67 
68 	/**
69 	* @dev Adds two numbers, throws on overflow.
70 	*/
71 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
72 		uint256 c = a + b;
73 		assert(c >= a);
74 		return c;
75 	}
76 
77 	/**
78 	* @dev Raises `a` to the `b`th power, throws on overflow.
79 	*/
80 	function pow(uint256 a, uint256 b) internal pure returns (uint256) {
81 		uint256 c = a ** b;
82 		assert(c >= a);
83 		return c;
84 	}
85 }
86 
87 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
88 contract StandardToken is AbstractToken, Owned, SafeMath {
89 
90 	/*
91 	 *  Data structures
92 	 */
93 	mapping (address => uint256) internal balances;
94 	mapping (address => mapping (address => uint256)) internal allowed;
95 
96 	/*
97 	 *  Read and write storage functions
98 	 */
99 	/// @dev Transfers sender's tokens to a given address. Returns success.
100 	/// @param _to Address of token receiver.
101 	/// @param _value Number of tokens to transfer.
102 	function transfer(address _to, uint256 _value) public returns (bool success) {
103 		return _transfer(msg.sender, _to, _value);
104 	}
105 
106 	/// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
107 	/// @param _from Address from where tokens are withdrawn.
108 	/// @param _to Address to where tokens are sent.
109 	/// @param _value Number of tokens to transfer.
110 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111 		require(allowed[_from][msg.sender] >= _value);
112 		allowed[_from][msg.sender] -= _value;
113 
114 		return _transfer(_from, _to, _value);
115 	}
116 
117 	/// @dev Returns number of tokens owned by given address.
118 	/// @param _owner Address of token owner.
119 	function balanceOf(address _owner) public view returns (uint256 balance) {
120 		return balances[_owner];
121 	}
122 
123 	/// @dev Sets approved amount of tokens for spender. Returns success.
124 	/// @param _spender Address of allowed account.
125 	/// @param _value Number of approved tokens.
126 	function approve(address _spender, uint256 _value) public returns (bool success) {
127 		allowed[msg.sender][_spender] = _value;
128 		emit Approval(msg.sender, _spender, _value);
129 		return true;
130 	}
131 
132 	/*
133 	 * Read storage functions
134 	 */
135 	/// @dev Returns number of allowed tokens for given address.
136 	/// @param _owner Address of token owner.
137 	/// @param _spender Address of token spender.
138 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
139 		return allowed[_owner][_spender];
140 	}
141 
142 	/**
143 	* @dev Private transfer, can only be called by this contract.
144 	* @param _from The address of the sender.
145 	* @param _to The address of the recipient.
146 	* @param _value The amount to send.
147 	* @return success True if the transfer was successful, or throws.
148 	*/
149 	function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
150 		require(_to != address(0));
151 		require(balances[_from] >= _value);
152 		balances[_from] -= _value;
153 		balances[_to] = add(balances[_to], _value);
154 		emit Transfer(_from, _to, _value);
155 		return true;
156 	}
157 }
158 
159 /// @title Token contract - Implements Standard ERC20 with additional features.
160 contract eMangirToken is StandardToken {
161 
162 	// Time of the contract creation
163 	uint256 public creationTime;
164    // Token MetaData
165 	string constant public name = 'eMangir';
166 	string constant public symbol = 'EMG';
167 	uint8  public decimals = 18;
168 	uint256 public totalSupply = 1000000000e18;
169 
170 	constructor() public {
171 		/* solium-disable-next-line security/no-block-members */
172 		creationTime = now;
173 		balances[msg.sender] = totalSupply;
174 	}
175 
176 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
177 	function transferERC20Token(AbstractToken _token, address _to, uint256 _value)
178 		public
179 		onlyOwner
180 		returns (bool success)
181 	{
182 		require(_token.balanceOf(address(this)) >= _value);
183 		uint256 receiverBalance = _token.balanceOf(_to);
184 		require(_token.transfer(_to, _value));
185 
186 		uint256 receiverNewBalance = _token.balanceOf(_to);
187 		assert(receiverNewBalance == add(receiverBalance, _value));
188 
189 		return true;
190 	}
191 
192 	/// @dev Increases approved amount of tokens for spender. Returns success.
193 	function increaseApproval(address _spender, uint256 _value) public returns (bool success) {
194 		allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _value);
195 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196 		return true;
197 	}
198 
199 	/// @dev Decreases approved amount of tokens for spender. Returns success.
200 	function decreaseApproval(address _spender, uint256 _value) public returns (bool success) {
201 		uint256 oldValue = allowed[msg.sender][_spender];
202 		if (_value > oldValue) {
203 			allowed[msg.sender][_spender] = 0;
204 		} else {
205 			allowed[msg.sender][_spender] = sub(oldValue, _value);
206 		}
207 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208 		return true;
209 	}
210 
211 }