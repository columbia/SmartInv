1 contract Token {
2     
3 	/* Public variables of the token */
4 	string public name;
5 	string public symbol;
6 	uint8 public decimals;
7 	uint256 public totalSupply;
8     
9 	/* This creates an array with all balances */
10 	mapping (address => uint256) public balanceOf;
11 
12 	/* This generates a public event on the blockchain that will notify clients */
13 	event Transfer(address indexed from, address indexed to, uint256 value);
14 
15 	function Token() {
16 	    totalSupply = 10*(10**8)*(10**18);
17 		balanceOf[msg.sender] = 10*(10**8)*(10**18);              // Give the creator all initial tokens
18 		name = "otoken";                                   // Set the name for display purposes
19 		symbol = "OT";                               // Set the symbol for display purposes
20 		decimals = 18;                            // Amount of decimals for display purposes
21 	}
22 
23 	function transfer(address _to, uint256 _value) {
24 	/* Check if sender has balance and for overflows */
25 	if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to])
26 		revert();
27 	/* Add and subtract new balances */
28 	balanceOf[msg.sender] -= _value;
29 	balanceOf[_to] += _value;
30 	/* Notifiy anyone listening that this transfer took place */
31 	Transfer(msg.sender, _to, _value);
32 	}
33 
34 	/* This unnamed function is called whenever someone tries to send ether to it */
35 	function () {
36 	revert();     // Prevents accidental sending of ether
37 	}
38 }