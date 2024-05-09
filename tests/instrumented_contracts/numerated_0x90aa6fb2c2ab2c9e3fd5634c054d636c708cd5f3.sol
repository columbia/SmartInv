1 pragma solidity ^0.4.6;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) throw;
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract BuyerToken is owned {
22     /* Public variables of the token */
23     string public standard = 'Token 0.1';
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28     uint256 public buyPrice;
29 
30     /* This creates an array with all balances */
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /* Initializes contract with initial supply tokens to the creator of the contract */
38     function token(
39         uint256 initialSupply,
40         string tokenName,
41         uint8 decimalUnits,
42         string tokenSymbol
43         ) {
44         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
45         totalSupply = initialSupply;                        // Update total supply
46         name = tokenName;                                   // Set the name for display purposes
47         symbol = tokenSymbol;                               // Set the symbol for display purposes
48         decimals = decimalUnits;                            // Amount of decimals for display purposes
49     }
50     
51     /* Mint coins */
52     function mintToken(address target, uint256 mintedAmount) onlyOwner {
53         balanceOf[target] += mintedAmount;
54         totalSupply += mintedAmount;
55         Transfer(0, this, mintedAmount);
56         Transfer(this, target, mintedAmount);
57     }
58     
59     /* Distroy coins */
60     function distroyToken(address target) onlyOwner {
61         totalSupply -= balanceOf[target];
62         balanceOf[target] = 0;
63     }
64 
65     /* Send coins */
66     function transfer(address _to, uint256 _value) {
67         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
68         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
69         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
70         balanceOf[_to] += _value;                            // Add the same to the recipient
71         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
72     }
73 
74     /* Allow another contract to spend some tokens in your behalf */
75     function approve(address _spender, uint256 _value)
76         returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         tokenRecipient spender = tokenRecipient(_spender);
79         return true;
80     }
81 
82     /* Approve and then comunicate the approved contract in a single tx */
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
84         returns (bool success) {    
85         tokenRecipient spender = tokenRecipient(_spender);
86         if (approve(_spender, _value)) {
87             spender.receiveApproval(msg.sender, _value, this, _extraData);
88             return true;
89         }
90     }
91 
92     /* A contract attempts to get the coins */
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
95         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
96         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
97         balanceOf[_from] -= _value;                          // Subtract from the sender
98         balanceOf[_to] += _value;                            // Add the same to the recipient
99         allowance[_from][msg.sender] -= _value;
100         Transfer(_from, _to, _value);
101         return true;
102     }
103     
104     function setPrices(uint256 newBuyPrice) onlyOwner {
105         buyPrice = newBuyPrice;
106     }
107 
108     function buy() payable {
109         uint amount = msg.value / buyPrice;                // calculates the amount
110         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
111         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
112         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
113         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
114     }
115 
116     /* This unnamed function is called whenever someone tries to send ether to it */
117     function () {
118         throw;     // Prevents accidental sending of ether
119     }
120 }