1 pragma solidity ^0.4.20;
2 
3 contract PictureLibraryCoin {
4 
5 	// Public variables of the token
6 	string public name;
7 	string public symbol;
8 	uint8 public decimals = 18;
9 	
10 	// 18 decimals is the strongly suggested default, avoid changing it
11 	uint256 public totalSupply;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15 
16 	// This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19 	/**
20      * Constrctor function
21      *
22      * Initializes contract with initial supply tokens to the creator of the contract
23      */
24     function PictureLibraryCoin (
25         uint256 initialSupply
26         ) public {
27 		    totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
28 			balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
29 			name = "PictureLibraryCoin";                                   // Set the name for display purposes
30 			symbol = "PLC";                               // Set the symbol for display purposes
31         }
32 
33 	/**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 }