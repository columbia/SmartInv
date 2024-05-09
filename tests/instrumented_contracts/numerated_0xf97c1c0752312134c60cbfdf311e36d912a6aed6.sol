1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract JinKuangLian{
5     string public standard = 'JinKuangLian 0.1';
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
18     /* This notifies clients about the amount burnt */
19     event Burn(address indexed from, uint256 value);
20 
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function JinKuangLian() {
23         balanceOf[msg.sender] =  1200000000 * 1000000000000000000;              // Give the creator all initial tokens
24         totalSupply =  1200000000 * 1000000000000000000;                        // Update total supply
25         name = "JinKuangLian";                                   // Set the name for display purposes
26         symbol = "JKL";                               // Set the symbol for display purposes
27         decimals = 18;                            // Amount of decimals for display purposes
28     }
29 
30     /* Send coins */
31     function transfer(address _to, uint256 _value) {
32         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
33         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
34         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
35         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
36         balanceOf[_to] += _value;                            // Add the same to the recipient
37         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
38     }
39 
40     /* Allow another contract to spend some tokens in your behalf */
41     function approve(address _spender, uint256 _value)
42         returns (bool success) {
43         allowance[msg.sender][_spender] = _value;
44         return true;
45     }
46 
47     /* Approve and then communicate the approved contract in a single tx */
48     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
49         returns (bool success) {
50         tokenRecipient spender = tokenRecipient(_spender);
51         if (approve(_spender, _value)) {
52             spender.receiveApproval(msg.sender, _value, this, _extraData);
53             return true;
54         }
55     }
56 
57     /* A contract attempts to get the coins */
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
60         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
61         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
62         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
63         balanceOf[_from] -= _value;                           // Subtract from the sender
64         balanceOf[_to] += _value;                             // Add the same to the recipient
65         allowance[_from][msg.sender] -= _value;
66         Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function burn(uint256 _value) returns (bool success) {
71         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
72         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
73         totalSupply -= _value;                                // Updates totalSupply
74         Burn(msg.sender, _value);
75         return true;
76     }
77 
78     function burnFrom(address _from, uint256 _value) returns (bool success) {
79         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
80         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
81         balanceOf[_from] -= _value;                          // Subtract from the sender
82         totalSupply -= _value;                               // Updates totalSupply
83         Burn(_from, _value);
84         return true;
85     }
86 }