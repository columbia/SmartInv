1 pragma solidity ^0.4.1;
2 
3 contract tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
5 }
6 
7 contract MyToken {
8     /* Public variables of the token */
9     string public standard = 'Token 0.1';
10     string public name;
11     string public symbol;
12     uint8 public decimals;
13     uint256 public totalSupply;
14 
15     /* This creates an array with all balances */
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     /* This generates a public event on the blockchain that will notify clients */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /* Initializes contract with initial supply tokens to the creator of the contract */
23     function MyToken(
24         uint256 initialSupply,
25         string tokenName,
26         uint8 decimalUnits,
27         string tokenSymbol
28         ) {
29         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
30         totalSupply = initialSupply;                        // Update total supply
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33         decimals = decimalUnits;                            // Amount of decimals for display purposes
34     }
35 
36     /* Send coins */
37     function transfer(address _to, uint256 _value) {
38         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
39         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
40         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
41         balanceOf[_to] += _value;                            // Add the same to the recipient
42         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
43     }
44 
45     /* Allow another contract to spend some tokens in your behalf */
46     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
47         returns (bool success) {
48         allowance[msg.sender][_spender] = _value;
49         tokenRecipient spender = tokenRecipient(_spender);
50         spender.receiveApproval(msg.sender, _value, this, _extraData);
51         return true;
52     }
53 
54     /* A contract attempts to get the coins */
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
57         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
58         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
59         balanceOf[_from] -= _value;                          // Subtract from the sender
60         balanceOf[_to] += _value;                            // Add the same to the recipient
61         allowance[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     /* This unnamed function is called whenever someone tries to send ether to it */
67     function () {
68         throw;     // Prevents accidental sending of ether
69     }
70     
71 }