1 pragma solidity ^0.4.21;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12 		if (a == 0) {
13 			return 0;
14 		}
15 		uint256 c = a * b;
16 		assert(c / a == b);
17 		return c;
18 	}
19 	
20 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
21 		// assert(b > 0); // Solidity automatically throws when dividing by 0
22 		uint256 c = a / b;
23 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 		return c;
25 	}
26 	
27 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28 		assert(b <= a);
29 		return a - b;
30 	}
31 	
32 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
33 		uint256 c = a + b;
34 		assert(c >= a);
35 		return c;
36 	}
37 }
38 
39 /**
40  * Changes by https://www.docademic.com/
41  */
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49 	address public owner;
50 	
51 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 	
53 	/**
54 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55 	 * account.
56 	 */
57 	function Ownable() public {
58 		owner = msg.sender;
59 	}
60 	
61 	/**
62 	 * @dev Throws if called by any account other than the owner.
63 	 */
64 	modifier onlyOwner() {
65 		require(msg.sender == owner);
66 		_;
67 	}
68 	
69 	/**
70 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
71 	 * @param _newOwner The address to transfer ownership to.
72 	 */
73 	function transferOwnership(address _newOwner) public onlyOwner {
74 		require(_newOwner != address(0));
75 		emit OwnershipTransferred(owner, _newOwner);
76 		owner = _newOwner;
77 	}
78 }
79 
80 contract Destroyable is Ownable {
81 	/**
82 	 * @notice Allows to destroy the contract and return the tokens to the owner.
83 	 */
84 	function destroy() public onlyOwner {
85 		selfdestruct(owner);
86 	}
87 }
88 
89 interface Token {
90 	function balanceOf(address who) view external returns (uint256);
91 	
92 	function allowance(address _owner, address _spender) view external returns (uint256);
93 	
94 	function transfer(address _to, uint256 _value) external returns (bool);
95 	
96 	function approve(address _spender, uint256 _value) external returns (bool);
97 	
98 	function increaseApproval(address _spender, uint256 _addedValue) external returns (bool);
99 	
100 	function decreaseApproval(address _spender, uint256 _subtractedValue) external returns (bool);
101 }
102 
103 contract TokenPool is Ownable, Destroyable {
104 	using SafeMath for uint256;
105 	
106 	Token public token;
107 	address public spender;
108 	
109 	event AllowanceChanged(uint256 _previousAllowance, uint256 _allowed);
110 	event SpenderChanged(address _previousSpender, address _spender);
111 	
112 	
113 	/**
114 	 * @dev Constructor.
115 	 * @param _token The token address
116 	 * @param _spender The spender address
117 	 */
118 	function TokenPool(address _token, address _spender) public{
119 		require(_token != address(0) && _spender != address(0));
120 		token = Token(_token);
121 		spender = _spender;
122 	}
123 	
124 	/**
125 	 * @dev Get the token balance of the contract.
126 	 * @return _balance The token balance of this contract in wei
127 	 */
128 	function Balance() view public returns (uint256 _balance) {
129 		return token.balanceOf(address(this));
130 	}
131 	
132 	/**
133 	 * @dev Get the token allowance of the contract to the spender.
134 	 * @return _balance The token allowed to the spender in wei
135 	 */
136 	function Allowance() view public returns (uint256 _balance) {
137 		return token.allowance(address(this), spender);
138 	}
139 	
140 	/**
141 	 * @dev Allows the owner to set up the allowance to the spender.
142 	 */
143 	function setUpAllowance() public onlyOwner {
144 		emit AllowanceChanged(token.allowance(address(this), spender), token.balanceOf(address(this)));
145 		token.approve(spender, token.balanceOf(address(this)));
146 	}
147 	
148 	/**
149 	 * @dev Allows the owner to update the allowance of the spender.
150 	 */
151 	function updateAllowance() public onlyOwner {
152 		uint256 balance = token.balanceOf(address(this));
153 		uint256 allowance = token.allowance(address(this), spender);
154 		uint256 difference = balance.sub(allowance);
155 		token.increaseApproval(spender, difference);
156 		emit AllowanceChanged(allowance, allowance.add(difference));
157 	}
158 	
159 	/**
160 	 * @dev Allows the owner to destroy the contract and return the tokens to the owner.
161 	 */
162 	function destroy() public onlyOwner {
163 		token.transfer(owner, token.balanceOf(address(this)));
164 		selfdestruct(owner);
165 	}
166 	
167 	/**
168 	 * @dev Allows the owner to change the spender.
169 	 * @param _spender The new spender address
170 	 */
171 	function changeSpender(address _spender) public onlyOwner {
172 		require(_spender != address(0));
173 		emit SpenderChanged(spender, _spender);
174 		token.approve(spender, 0);
175 		spender = _spender;
176 		setUpAllowance();
177 	}
178 	
179 }