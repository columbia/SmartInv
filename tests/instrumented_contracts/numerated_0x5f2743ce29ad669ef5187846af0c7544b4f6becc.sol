1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 	address public owner;
11 
12 
13 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16 	/**
17 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18 	 * account.
19 	 */
20 	function Ownable() public {
21 		owner = msg.sender;
22 	}
23 
24 	/**
25 	 * @dev Throws if called by any account other than the owner.
26 	 */
27 	modifier onlyOwner() {
28 		require(msg.sender == owner);
29 		_;
30 	}
31 
32 	/**
33 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
34 	 * @param newOwner The address to transfer ownership to.
35 	 */
36 	function transferOwnership(address newOwner) public onlyOwner {
37 		require(newOwner != address(0));
38 		emit OwnershipTransferred(owner, newOwner);
39 		owner = newOwner;
40 	}
41 
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50 	/**
51 	* @dev Multiplies two numbers, throws on overflow.
52 	*/
53 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54 		if (a == 0) {
55 			return 0;
56 		}
57 		uint256 c = a * b;
58 		assert(c / a == b);
59 		return c;
60 	}
61 
62 	/**
63 	* @dev Integer division of two numbers, truncating the quotient.
64 	*/
65 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
66 		// assert(b > 0); // Solidity automatically throws when dividing by 0
67 		// uint256 c = a / b;
68 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 		return a / b;
70 	}
71 
72 	/**
73 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74 	*/
75 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76 		assert(b <= a);
77 		return a - b;
78 	}
79 
80 	/**
81 	* @dev Adds two numbers, throws on overflow.
82 	*/
83 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
84 		uint256 c = a + b;
85 		assert(c >= a);
86 		return c;
87 	}
88 }
89 
90 contract ERC20Basic {
91 	function totalSupply() public view returns (uint256);
92 
93 	function balanceOf(address who) public view returns (uint256);
94 
95 	function transfer(address to, uint256 value) public returns (bool);
96 
97 	event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105 	function allowance(address owner, address spender) public view returns (uint256);
106 
107 	function transferFrom(address from, address to, uint256 value) public returns (bool);
108 
109 	function approve(address spender, uint256 value) public returns (bool);
110 
111 	event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Airdrop Controller
116  * @dev Controlls ERC20 token airdrop
117  * @notice Token Contract Must send enough tokens to this contract to be distributed before aidrop
118  */
119 contract AirdropController is Ownable {
120 	using SafeMath for uint;
121 
122 	uint public totalClaimed;
123 
124 	bool public airdropAllowed;
125 
126 	ERC20 public token;
127 
128 	mapping(address => bool) public tokenReceived;
129 
130 	modifier isAllowed() {
131 		require(airdropAllowed == true);
132 		_;
133 	}
134 
135 	function AirdropController() public {
136 		airdropAllowed = true;
137 	}
138 
139 	function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed {
140 		for (uint i = 0; i < _recipients.length; i++) {
141 			require(_recipients[i] != address(0));
142 			require(tokenReceived[_recipients[i]] == false);
143 			require(token.transfer(_recipients[i], _amounts[i]));
144 			tokenReceived[_recipients[i]] = true;
145 			totalClaimed = totalClaimed.add(_amounts[i]);
146 		}
147 	}
148 
149 	function airdropManually(address _holder, uint _amount) public onlyOwner isAllowed {
150 		require(_holder != address(0));
151 		require(tokenReceived[_holder] == false);
152 		if (!token.transfer(_holder, _amount)) revert();
153 		tokenReceived[_holder] = true;
154 		totalClaimed = totalClaimed.add(_amount);
155 	}
156 
157 	function setTokenAddress(address _token) public onlyOwner {
158 		require(_token != address(0));
159 		token = ERC20(_token);
160 	}
161 
162 	function remainingTokenAmount() public view returns (uint) {
163 		return token.balanceOf(this);
164 	}
165 
166 	function setAirdropEnabled(bool _allowed) public onlyOwner {
167 		airdropAllowed = _allowed;
168 	}
169 }