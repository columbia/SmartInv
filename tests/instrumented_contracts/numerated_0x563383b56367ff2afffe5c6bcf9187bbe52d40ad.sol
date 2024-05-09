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
15     mapping (address => uint256) public frozenAccount;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /* This notifies clients about the amount burnt */
21     event Burn(address indexed from, uint256 value);
22     
23     /* For frozen premine notifications*/
24     event FrozenFunds(address target, uint256 frozen);
25 
26     /* Initializes contract with initial supply tokens to the creator of the contract */
27     function MyToken() {
28         balanceOf[msg.sender] = 3330000000000;              // Give the creator all initial tokens
29         totalSupply = 3330000000000;                        // Update total supply
30         name = 'Hubcoin';                                   // Set the name for display purposes
31         symbol = 'HUB';                                     // Set the symbol for display purposes
32         decimals = 6;                                       // Amount of decimals for display purposes
33     }
34 
35     /* Send coins */
36     function transfer(address _to, uint256 _value) {
37         uint forbiddenPremine =  1501545600 - block.timestamp + 86400*365;
38         if (forbiddenPremine < 0) forbiddenPremine = 0;
39         
40         
41         require(_to != 0x0);                                 // Prevent transfer to 0x0 address. Use burn() instead
42         require(balanceOf[msg.sender] > _value + frozenAccount[msg.sender] * forbiddenPremine / (86400*365) );    // Check if the sender has enough
43         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
44         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
45         balanceOf[_to] += _value;                            // Add the same to the recipient
46         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
47     }
48 
49     /* Allow another contract to spend some tokens in your behalf */
50     function approve(address _spender, uint256 _value)
51         returns (bool success) {
52         allowance[msg.sender][_spender] = _value;
53         return true;
54     }
55 
56     /* Approve and then communicate the approved contract in a single tx */
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
58         returns (bool success) {
59         tokenRecipient spender = tokenRecipient(_spender);
60         if (approve(_spender, _value)) {
61             spender.receiveApproval(msg.sender, _value, this, _extraData);
62             return true;
63         }
64     }        
65 
66     /* A contract attempts to get the coins */
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         uint forbiddenPremine =  1501545600 - block.timestamp + 86400*365;        
69         if (forbiddenPremine < 0) forbiddenPremine = 0;   
70         
71         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
72         require(balanceOf[_from] > _value + frozenAccount[_from] * forbiddenPremine / (86400*365) );    // Check if the sender has enough
73         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
74         require(_value < allowance[_from][msg.sender]);     // Check allowance
75         balanceOf[_from] -= _value;                         // Subtract from the sender
76         balanceOf[_to] += _value;                           // Add the same to the recipient
77         allowance[_from][msg.sender] -= _value;
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function burn(uint256 _value) returns (bool success) {
83         require(balanceOf[msg.sender] > _value);            // Check if the sender has enough
84         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
85         totalSupply -= _value;                              // Updates totalSupply
86         Burn(msg.sender, _value);
87         return true;
88     }
89 
90     function burnFrom(address _from, uint256 _value) returns (bool success) {
91         require(balanceOf[_from] > _value);                // Check if the sender has enough
92         require(_value < allowance[_from][msg.sender]);    // Check allowance
93         balanceOf[_from] -= _value;                        // Subtract from the sender
94         totalSupply -= _value;                             // Updates totalSupply
95         Burn(_from, _value);
96         return true;
97     }
98     
99     function freezeAccount(address target, uint256 freeze) {
100         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
101         require(block.timestamp < 1502036759 + 3600*10);
102         frozenAccount[target] = freeze;
103         FrozenFunds(target, freeze);
104     }
105 }