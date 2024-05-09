1 pragma solidity ^0.4.16;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract FuckToken {
5     /* Public variables of the FUCK token */
6     string public standard = 'FUCK 1.1';
7     string public name = 'Finally Usable Crypto Karma';
8     string public symbol = 'FUCK';
9     uint8 public decimals = 4;
10     uint256 public totalSupply = 708567744953;
11 
12     /* Creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     /* Generates a public event on the blockchain that will notify clients */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /* Notifies clients about the amount burnt */
20     event Burn(address indexed from, uint256 value);
21 
22     /* Initializes contract with initial supply tokens to me */
23     function FuckToken() {
24         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
25     }
26 
27     /* Send coins */
28     function transfer(address _to, uint256 _value) {
29         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
30         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
31         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
32         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
33         balanceOf[_to] += _value;                               // Add the same to the recipient
34         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
35     }
36 
37     /* Allow another contract to spend some tokens on my behalf */
38     function approve(address _spender, uint256 _value)
39         returns (bool success) {
40         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
41         allowance[msg.sender][_spender] = _value;
42         return true;
43     }
44 
45     /* Approve and then communicate the approved contract in a single tx */
46     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
47         returns (bool success) {
48         tokenRecipient spender = tokenRecipient(_spender);
49         if (approve(_spender, _value)) {
50             spender.receiveApproval(msg.sender, _value, this, _extraData);
51             return true;
52         }
53     }        
54 
55     /* A contract attempts to get the coins */
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
58         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
59         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
60         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
61         balanceOf[_from] -= _value;                              // Subtract from the sender
62         balanceOf[_to] += _value;                                // Add the same to the recipient
63         allowance[_from][msg.sender] -= _value;
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68 	/* Burn FUCKs by User */
69     function burn(uint256 _value) returns (bool success) {
70         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
71         balanceOf[msg.sender] -= _value;                         // Subtract from the sender
72         totalSupply -= _value;                                   // Updates totalSupply
73         Burn(msg.sender, _value);
74         return true;
75     }
76 
77 	/* Burn FUCKs from Users */
78     function burnFrom(address _from, uint256 _value) returns (bool success) {
79         if (balanceOf[_from] < _value) revert();                // Check if the sender has enough
80         if (_value > allowance[_from][msg.sender]) revert();    // Check allowance
81         balanceOf[_from] -= _value;                             // Subtract from the sender
82         totalSupply -= _value;                                  // Updates totalSupply
83         Burn(_from, _value);
84         return true;
85     }
86 }