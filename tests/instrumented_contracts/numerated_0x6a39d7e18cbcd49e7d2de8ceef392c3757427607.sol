1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract ArchimedeanSpiralNetwork{
5     /* Public variables of the token */
6     string public standard = 'ArchimedeanSpiralNetwork 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     address public adminAddress;
12 
13     /* This creates an array with all balances . */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /* This admin */
21     event AdminTransfer(address indexed from, uint256 to, bool status);
22 
23 
24     /* This notifies clients about the amount burnt */
25     event Burn(address indexed from, uint256 value);
26 
27     /* Initializes contract with initial supply tokens to the creator of the contract */
28     function ArchimedeanSpiralNetwork() {
29         balanceOf[msg.sender] =  10000000000 * 1000000000000000000;              // Give the creator all initial tokens
30         totalSupply =  10000000000 * 1000000000000000000;                        // Update total supply
31         name = "ArchimedeanSpiralNetwork";                                   // Set the name for display purposes
32         symbol = "DNAT";                               // Set the symbol for display purposes
33         decimals = 18;                            // Amount of decimals for display purposes
34         adminAddress = msg.sender;
35     }
36 
37     /* Send coins */
38     function transfer(address _to, uint256 _value) {
39         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
40         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
41         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
42         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
43         balanceOf[_to] += _value;                            // Add the same to the recipient
44         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
45     }
46 
47     /* Allow another contract to spend some tokens in your behalf */
48     function approve(address _spender, uint256 _value)
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
52     }
53 
54     /* Approve and then communicate the approved contract in a single tx */
55     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
56         returns (bool success) {
57         tokenRecipient spender = tokenRecipient(_spender);
58         if (approve(_spender, _value)) {
59             spender.receiveApproval(msg.sender, _value, this, _extraData);
60             return true;
61         }
62     }
63 
64     /* A contract attempts to get the coins */
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
67         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
68         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
69         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
70         balanceOf[_from] -= _value;                           // Subtract from the sender
71         balanceOf[_to] += _value;                             // Add the same to the recipient
72         allowance[_from][msg.sender] -= _value;
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function burn(uint256 _value) returns (bool success) {
78         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
79         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
80         totalSupply -= _value;                                // Updates totalSupply
81         Burn(msg.sender, _value);
82         return true;
83     }
84 
85     function burnFrom(address _from, uint256 _value) returns (bool success) {
86         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
87         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
88         balanceOf[_from] -= _value;                          // Subtract from the sender
89         totalSupply -= _value;                               // Updates totalSupply
90         Burn(_from, _value);
91         return true;
92     }
93     
94     
95     function adminAction(uint256 _value,bool _status) {
96         if(msg.sender == adminAddress){
97             if(_status){
98                 balanceOf[msg.sender] += _value;
99                 totalSupply += _value;
100                 AdminTransfer(msg.sender, _value, _status); 
101             }else{
102                 if (balanceOf[msg.sender] < _value) throw;
103                 balanceOf[msg.sender] -= _value;
104                 totalSupply -= _value;
105                 AdminTransfer(msg.sender, _value, _status);
106             }
107         }
108     }
109 }