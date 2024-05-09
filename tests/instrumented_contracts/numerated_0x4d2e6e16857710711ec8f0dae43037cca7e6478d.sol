1 pragma solidity ^0.4.2;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract MyToken {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     /* This generates a public event on the blockchain that will notify clients */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function MyToken(
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
33     /* Send coins */
34     function transfer(address _to, uint256 _value) {
35         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
36         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
37         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
38         balanceOf[_to] += _value;                            // Add the same to the recipient
39         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
40     }
41 
42     /* Allow another contract to spend some tokens in your behalf */
43     function approve(address _spender, uint256 _value)
44         returns (bool success) {
45         allowance[msg.sender][_spender] = _value;
46         return true;
47     }
48 
49     /* Approve and then comunicate the approved contract in a single tx */
50     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
51         returns (bool success) {
52         tokenRecipient spender = tokenRecipient(_spender);
53         if (approve(_spender, _value)) {
54             spender.receiveApproval(msg.sender, _value, this, _extraData);
55             return true;
56         }
57     }        
58 
59     /* A contract attempts to get the coins */
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
62         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
63         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
64         balanceOf[_from] -= _value;                          // Subtract from the sender
65         balanceOf[_to] += _value;                            // Add the same to the recipient
66         allowance[_from][msg.sender] -= _value;
67         Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     /* This unnamed function is called whenever someone tries to send ether to it */
72     function () {
73         throw;     // Prevents accidental sending of ether
74     }
75 }