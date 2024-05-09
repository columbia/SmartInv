1 pragma solidity ^0.4.8;
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
19     /* This notifies clients about the amount burnt */
20     event Burn(address indexed from, uint256 value);
21 
22     /* Initializes contract with initial supply tokens to the creator of the contract */
23     function MyToken() {
24         balanceOf[msg.sender] = 8000000000000;              // Give the creator all initial tokens
25         totalSupply = 8000000000000;                        // Update total supply
26         name = 'preYoho';                                   // Set the name for display purposes
27         symbol = 'preYCN';                                     // Set the symbol for display purposes
28         decimals = 6;                                       // Amount of decimals for display purposes
29     }
30 
31     /* Send coins */
32     function transfer(address _to, uint256 _value) {
33         require(_to != 0x0);                                 // Prevent transfer to 0x0 address. Use burn() instead
34         require(balanceOf[msg.sender] > _value);             // Check if the sender has enough
35         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
36         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
37         balanceOf[_to] += _value;                            // Add the same to the recipient
38         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
39     }
40 
41     /* Allow another contract to spend some tokens in your behalf */
42     function approve(address _spender, uint256 _value)
43         returns (bool success) {
44         allowance[msg.sender][_spender] = _value;
45         return true;
46     }
47 
48     /* Approve and then communicate the approved contract in a single tx */
49     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
50         returns (bool success) {
51         tokenRecipient spender = tokenRecipient(_spender);
52         if (approve(_spender, _value)) {
53             spender.receiveApproval(msg.sender, _value, this, _extraData);
54             return true;
55         }
56     }        
57 
58     /* A contract attempts to get the coins */
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
61         require(balanceOf[_from] > _value);                 // Check if the sender has enough
62         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
63         require(_value < allowance[_from][msg.sender]);     // Check allowance
64         balanceOf[_from] -= _value;                         // Subtract from the sender
65         balanceOf[_to] += _value;                           // Add the same to the recipient
66         allowance[_from][msg.sender] -= _value;
67         Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function burn(uint256 _value) returns (bool success) {
72         require(balanceOf[msg.sender] > _value);            // Check if the sender has enough
73         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
74         totalSupply -= _value;                              // Updates totalSupply
75         Burn(msg.sender, _value);
76         return true;
77     }
78 
79     function burnFrom(address _from, uint256 _value) returns (bool success) {
80         require(balanceOf[_from] > _value);                // Check if the sender has enough
81         require(_value < allowance[_from][msg.sender]);    // Check allowance
82         balanceOf[_from] -= _value;                        // Subtract from the sender
83         totalSupply -= _value;                             // Updates totalSupply
84         Burn(_from, _value);
85         return true;
86     }
87 }