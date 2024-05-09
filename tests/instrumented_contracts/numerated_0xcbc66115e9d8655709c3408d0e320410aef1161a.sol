1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic
4 {
5 	function totalSupply() public view returns (uint256);
6 
7 	function balanceOf(address who) public view returns (uint256);
8 
9 	function transfer(address to, uint256 value) public returns (bool);
10 
11 	event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic
15 {
16 	function allowance(address owner, address spender) public view returns (uint256);
17 
18 	function transferFrom(address from, address to, uint256 value) public returns (bool);
19 
20 	function approve(address spender, uint256 value) public returns (bool);
21 
22 	event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract Ownable
26 {
27 	address public owner;
28 
29 
30 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33 	/**
34 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
35 	* account.
36 	*/
37 	constructor() public
38 	{
39 		owner = msg.sender;
40 	}
41 
42 	/**
43 	* @dev Throws if called by any account other than the owner.
44 	*/
45 	modifier onlyOwner() {
46 		require(msg.sender == owner);
47 
48 		_;
49 	}
50 
51 	/**
52 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
53 	* @param newOwner The address to transfer ownership to.
54 	*/
55 	function transferOwnership(address newOwner) public onlyOwner {
56 		require(newOwner != address(0));
57 
58 		emit OwnershipTransferred(owner, newOwner);
59 		owner = newOwner;
60 	}
61 
62 }
63 
64 /**
65  * @title TokenTimelock
66  * @dev TokenTimelock is a token holder contract that will allow a
67  * beneficiary to extract the tokens after a given release time
68  */
69 contract TokenTimelock {
70 	// ERC20 basic token contract being held
71 	ERC20 private _token;
72 
73 	// beneficiary of tokens after they are released
74 	address private _beneficiary;
75 
76 	// timestamp when token release is enabled
77 	uint256 private _releaseTime;
78 
79 	constructor (ERC20 token, address beneficiary, uint256 releaseTime) public {
80 		// solium-disable-next-line security/no-block-members
81 		require(releaseTime > block.timestamp);
82 		_token = token;
83 		_beneficiary = beneficiary;
84 		_releaseTime = releaseTime;
85 	}
86 
87 	/**
88 	 * @return the token being held.
89 	 */
90 	function token() public view returns (ERC20) {
91 		return _token;
92 	}
93 
94 	/**
95 	 * @return the beneficiary of the tokens.
96 	 */
97 	function beneficiary() public view returns (address) {
98 		return _beneficiary;
99 	}
100 
101 	/**
102 	 * @return the time when the tokens are released.
103 	 */
104 	function releaseTime() public view returns (uint256) {
105 		return _releaseTime;
106 	}
107 
108 	/**
109 	 * @notice Transfers tokens held by timelock to beneficiary.
110 	 */
111 	function release() public {
112 		// solium-disable-next-line security/no-block-members
113 		require(block.timestamp >= _releaseTime);
114 
115 		uint256 amount = _token.balanceOf(address(this));
116 		require(amount > 0);
117 
118 		_token.transfer(_beneficiary, amount);
119 	}
120 }
121 
122 
123 contract MassVestingSender is Ownable
124 {
125 	mapping(uint32 => bool) processedTransactions;
126 
127 	event VestingTransfer(
128 		address indexed _recipient,
129 		address indexed _lock,
130 		uint32 indexed _vesting,
131 		uint _amount);
132 
133 	function bulkTransfer(ERC20 token, uint32[] payment_ids, address[] receivers, uint256[] transfers, uint32[] vesting) external
134 	{
135 		require(payment_ids.length == receivers.length);
136 		require(payment_ids.length == transfers.length);
137 		require(payment_ids.length == vesting.length);
138 
139 		for (uint i = 0; i < receivers.length; i++)
140 		{
141 			if (!processedTransactions[payment_ids[i]])
142 			{
143 				TokenTimelock vault = new TokenTimelock(token, receivers[i], vesting[i]);
144 
145 				require(token.transfer(address(vault), transfers[i]));
146 
147 				processedTransactions[payment_ids[i]] = true;
148 
149 				emit VestingTransfer(receivers[i], address(vault), vesting[i], transfers[i]);
150 			}
151 		}
152 	}
153 
154 	function r(ERC20 token) external onlyOwner
155 	{
156 		token.transfer(owner, token.balanceOf(address(this)));
157 	}
158 }