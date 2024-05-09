1 pragma solidity ^0.4.14;
2 contract TravellingFreeToken {
3     /* Public variables of the token */
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     /* This generates a public event on the blockchain that will notify clients */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /* This notifies clients about the amount burnt */
17     event Burn(address indexed from, uint256 value);
18 
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function TravellingFreeToken(
21         uint256 initialSupply,
22         string tokenName,
23         uint8 decimalUnits,
24         string tokenSymbol
25         ) {
26         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
27         totalSupply = initialSupply;                        // Update total supply
28         name = tokenName;                                   // Set the name for display purposes
29         symbol = tokenSymbol;                               // Set the symbol for display purposes
30         decimals = decimalUnits;                            // Amount of decimals for display purposes
31     }
32 
33 	/* Allow another contract to spend some tokens in your behalf */
34     function approve(address _spender, uint256 _value)
35         returns (bool success) {
36         allowance[msg.sender][_spender] = _value;
37         return true;
38     }
39 	
40     /* Send coins */
41     function transfer(address _to, uint256 _value) {
42         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
43         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
44         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
45         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
46         balanceOf[_to] += _value;                            // Add the same to the recipient
47         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
48     }
49 
50     /* A contract attempts to get the coins */
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
53         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
54         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
55         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
56         balanceOf[_from] -= _value;                           // Subtract from the sender
57         balanceOf[_to] += _value;                             // Add the same to the recipient
58         allowance[_from][msg.sender] -= _value;
59         Transfer(_from, _to, _value);
60         return true;
61     }
62 }