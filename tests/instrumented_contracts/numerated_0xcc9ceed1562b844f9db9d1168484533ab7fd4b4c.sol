1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract Jojo {
5     /* Public variables of the token */
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     /* This generates a public event on the blockchain that will notify clients */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /* Initializes contract with initial supply tokens to the creator of the contract */
19     function Jojo(
20         uint256 initialSupply,
21         string tokenName,
22         uint8 decimalUnits,
23         string tokenSymbol
24         ) {
25         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
26         totalSupply = initialSupply;                        // Update total supply
27         name = tokenName;                                   // Set the name for display purposes
28         symbol = tokenSymbol;                               // Set the symbol for display purposes
29         decimals = decimalUnits;                            // Amount of decimals for display purposes
30     }
31 
32     /* Send coins */
33     function transfer(address _to, uint256 _value) {
34         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
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
49     /* Approve and then communicate the approved contract in a single tx */
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
61         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
62         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
63         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
64         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
65         balanceOf[_from] -= _value;                           // Subtract from the sender
66         balanceOf[_to] += _value;                             // Add the same to the recipient
67         allowance[_from][msg.sender] -= _value;
68         Transfer(_from, _to, _value);
69         return true;
70     }
71 }