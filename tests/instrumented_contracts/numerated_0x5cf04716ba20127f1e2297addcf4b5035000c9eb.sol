1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 		if (a == 0) {
10 			return 0;
11 		}
12 		uint256 c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	}
16 
17 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b > 0); 
19 		uint256 c = a / b;
20 		return c;
21 	}
22 
23 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24 		assert(b <= a);
25 		return a - b;
26 	}
27 
28 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
29 		uint256 c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 }
34 
35 /**
36  * @title ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/20
38  */
39 contract ERC20 {
40 	uint256 public totalSupply;
41 	function balanceOf(address who) public view returns (uint256);
42 	function transfer(address to, uint256 value) public returns (bool);
43 	function allowance(address owner, address spender) public view returns (uint256);
44 	function transferFrom(address from, address to, uint256 value) public returns (bool);
45 	function approve(address spender, uint256 value) public returns (bool);
46 
47 	event Transfer(address indexed from, address indexed to, uint256 value);
48 	event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract Owned {
52 	address public owner;
53 
54 	event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56 	constructor() public {
57 		owner = msg.sender;
58 	}
59 
60 	modifier onlyOwner {
61 		require(msg.sender == owner);
62 		_;
63 	}
64 
65 	function transferOwnership(address _owner) onlyOwner public {
66 		require(_owner != address(0));
67 		owner = _owner;
68 
69 		emit OwnershipTransferred(owner, _owner);
70 	}
71 }
72 
73 contract ERC20Token is ERC20, Owned {
74 	using SafeMath for uint256;
75 
76 	mapping(address => uint256) balances;
77 	mapping(address => mapping (address => uint256)) allowed;
78 
79 
80 	// True if transfers are allowed
81 	bool public transferable = false;
82 
83 	modifier canTransfer() {
84 		require(transferable == true);
85 		_;
86 	}
87 
88 	function setTransferable(bool _transferable) onlyOwner public {
89 		transferable = _transferable;
90 	}
91 
92 	/**
93 	 * @dev transfer token for a specified address
94 	 * @param _to The address to transfer to.
95 	 * @param _value The amount to be transferred.
96 	 */
97 	function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
98 		require(_to != address(0));
99 		require(_value <= balances[msg.sender]);
100 
101 		balances[msg.sender] = balances[msg.sender].sub(_value);
102 		balances[_to] = balances[_to].add(_value);
103 		emit Transfer(msg.sender, _to, _value);
104 		return true;
105 	}
106 
107 	/**
108 	* @dev Gets the balance of the specified address.
109 	* @param _owner The address to query the the balance of.
110 		* @return An uint256 representing the amount owned by the passed address.
111 		*/
112 	function balanceOf(address _owner) public view returns (uint256 balance) {
113 		return balances[_owner];
114 	}
115 
116 	/**
117 	* @dev Transfer tokens from one address to another
118 	* @param _from address The address which you want to send tokens from
119 	* @param _to address The address which you want to transfer to
120 	* @param _value uint256 the amount of tokens to be transferred
121 	*/
122 	function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
123 		require(_to != address(0));
124 		require(_value <= balances[_from]);
125 		require(_value <= allowed[_from][msg.sender]);
126 
127 		balances[_from] = balances[_from].sub(_value);
128 		balances[_to] = balances[_to].add(_value);
129 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130 		emit Transfer(_from, _to, _value);
131 		return true;
132 	}
133 
134 	// Allow `_spender` to withdraw from your account, multiple times.
135 	function approve(address _spender, uint _value) public returns (bool success) {
136 		// To change the approve amount you first have to reduce the addresses`
137 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
138 		//  already 0 to mitigate the race condition described here:
139 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140 		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
141 			revert();
142 		}
143 		allowed[msg.sender][_spender] = _value;
144 		emit Approval(msg.sender, _spender, _value);
145 		return true;
146 	}
147 
148 	/**
149 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
150 	 * @param _owner address The address which owns the funds.
151 	 * @param _spender address The address which will spend the funds.
152 	 * @return A uint256 specifying the amount of tokens still available for the spender.
153 	 */
154 	function allowance(address _owner, address _spender) public view returns (uint256) {
155 		return allowed[_owner][_spender];
156 	}
157 
158 	function () public payable {
159 		revert();
160 	}
161 }
162 
163 contract NKNToken is ERC20Token{
164 	string public name = "NKN";
165 	string public symbol = "NKN";
166 	uint8 public decimals = 18;
167 
168 	uint256 public totalSupplyCap = 7 * 10**8 * 10**uint256(decimals);
169 
170 	constructor(address _issuer) public {
171 		totalSupply = totalSupplyCap;
172 		balances[_issuer] = totalSupplyCap;
173 		emit Transfer(address(0), _issuer, totalSupplyCap);
174 	}
175 }