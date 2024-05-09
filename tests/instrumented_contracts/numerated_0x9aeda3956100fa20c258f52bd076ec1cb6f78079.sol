1 pragma solidity ^0.4.14;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract OuCoin {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public constant name = "OuCoin";
8     string public constant symbol = "IOU";
9     uint8 public constant decimals = 3;
10     uint256 public constant initialSupply = 10000000;
11     uint256 public totalSupply;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /* This notifies clients about the amount burnt */
21     event Burn(address indexed from, uint256 value);
22 
23     /* Initializes contract with initial supply tokens to the creator of the contract */
24     function OuCoin () {
25         totalSupply = initialSupply;
26         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
27     }
28 
29     /* Send coins */
30     function transfer(address _to, uint256 _value) {
31         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
32         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
33         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
34         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
35         balanceOf[_to] += _value;                            // Add the same to the recipient
36         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
37     }
38 
39     /* Allow another contract to spend some tokens in your behalf */
40     function approve(address _spender, uint256 _value)
41         returns (bool success) {
42         allowance[msg.sender][_spender] = _value;
43         return true;
44     }
45 
46     /* Approve and then communicate the approved contract in a single tx */
47     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
48         returns (bool success) {
49         tokenRecipient spender = tokenRecipient(_spender);
50         if (approve(_spender, _value)) {
51             spender.receiveApproval(msg.sender, _value, this, _extraData);
52             return true;
53         }
54     }        
55 
56     /* A contract attempts to get the coins */
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         require (_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
59         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
60         require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
61         require (_value <= allowance[_from][msg.sender]);     // Check allowance
62         balanceOf[_from] -= _value;                           // Subtract from the sender
63         balanceOf[_to] += _value;                             // Add the same to the recipient
64         allowance[_from][msg.sender] -= _value;
65         Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function burn(uint256 _value) returns (bool success) {
70         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
71         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
72         totalSupply -= _value;                                // Updates totalSupply
73         Burn(msg.sender, _value);
74         return true;
75     }
76 
77     function burnFrom(address _from, uint256 _value) returns (bool success) {
78         require (balanceOf[_from] >= _value);                // Check if the sender has enough
79         require (_value <= allowance[_from][msg.sender]);    // Check allowance
80         balanceOf[_from] -= _value;                          // Subtract from the sender
81         totalSupply -= _value;                               // Updates totalSupply
82         Burn(_from, _value);
83         return true;
84     }
85 }