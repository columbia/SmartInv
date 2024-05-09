1 pragma solidity ^0.5.0;
2 
3 contract DUO {
4 	// Public variables of the token
5 	string public name;
6 	string public symbol;
7 	uint8 public decimals = 18;
8 	// 18 decimals is the strongly suggested default, avoid changing it
9 	uint public totalSupply;
10 
11 	// This creates an array with all balances
12 	mapping (address => uint) public balanceOf;
13 	mapping (address => mapping (address => uint)) public allowance;
14 
15 	// This generates a public event on the blockchain that will notify clients
16 	event Transfer(address indexed from, address indexed to, uint tokens);
17 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 
19 	/**
20 	 * Constrctor function
21 	 *
22 	 * Initializes contract with initial supply tokens to the creator of the contract
23 	 */
24 	constructor(
25 		uint initialSupply,
26 		string memory tokenName,
27 		string memory tokenSymbol
28 	) public 
29 	{
30 		totalSupply = initialSupply;  // Update total supply with the decimal amount
31 		balanceOf[msg.sender] = totalSupply;				// Give the creator all initial tokens
32 		name = tokenName;								   // Set the name for display purposes
33 		symbol = tokenSymbol;							   // Set the symbol for display purposes
34 	}
35 
36 	/**
37 	 * Internal transfer, only can be called by this contract
38 	 */
39 	function transfer(address from, address to, uint value) internal {
40 		// Prevent transfer to 0x0 address. Use burn() instead
41 		require(to != address(0));
42 		// Check if the sender has enough
43 		require(balanceOf[from] >= value);
44 		// Check for overflows
45 		require(balanceOf[to] + value > balanceOf[to]);
46 		// Save this for an assertion in the future
47 		uint previousBalances = balanceOf[from] + balanceOf[to];
48 		// Subtract from the sender
49 		balanceOf[from] -= value;
50 		// Add the same to the recipient
51 		balanceOf[to] += value;
52 		emit Transfer(from, to, value);
53 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
54 		assert(balanceOf[from] + balanceOf[to] == previousBalances);
55 	}
56 
57 	/**
58 	 * Transfer tokens
59 	 *
60 	 * Send `value` tokens to `to` from your account
61 	 *
62 	 * @param to The address of the recipient
63 	 * @param value the amount to send
64 	 */
65 	function transfer(address to, uint value) public returns (bool success) {
66 		transfer(msg.sender, to, value);
67 		return true;
68 	}
69 
70 	/**
71 	 * Transfer tokens from other address
72 	 *
73 	 * Send `value` tokens to `to` in behalf of `from`
74 	 *
75 	 * @param from The address of the sender
76 	 * @param to The address of the recipient
77 	 * @param value the amount to send
78 	 */
79 	function transferFrom(address from, address to, uint value) public returns (bool success) {
80 		require(value <= allowance[from][msg.sender]);	 // Check allowance
81 		allowance[from][msg.sender] -= value;
82 		transfer(from, to, value);
83 		return true;
84 	}
85 
86 	/**
87 	 * Set allowance for other address
88 	 *
89 	 * Allows `spender` to spend no more than `value` tokens in your behalf
90 	 *
91 	 * @param spender The address authorized to spend
92 	 * @param value the max amount they can spend
93 	 */
94 	function approve(address spender, uint value) public returns (bool success) {
95 		allowance[msg.sender][spender] = value;
96 		emit Approval(msg.sender, spender, value);
97 		return true;
98 	}
99 }