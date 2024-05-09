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
29     address public project_wallet;
30 
31     /* This creates an array with all balances */
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     /* This generates a public event on the blockchain that will notify clients */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function token(
40         uint256 initialSupply,
41         string tokenName,
42         uint8 decimalUnits,
43         string tokenSymbol
44         ) {
45         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
46         totalSupply = initialSupply;                        // Update total supply
47         name = tokenName;                                   // Set the name for display purposes
48         symbol = tokenSymbol;                               // Set the symbol for display purposes
49         decimals = decimalUnits;                            // Amount of decimals for display purposes
50     }
51     
52     function defineProjectWallet(address target) onlyOwner {
53         project_wallet = target;
54     }
55     
56     /* Mint coins */
57     function mintToken(address target, uint256 mintedAmount) onlyOwner {
58         balanceOf[target] += mintedAmount;
59         totalSupply += mintedAmount;
60         Transfer(0, this, mintedAmount);
61         Transfer(this, target, mintedAmount);
62     }
63     
64     /* Distroy coins */
65     function distroyToken(uint256 burnAmount) onlyOwner {
66         balanceOf[this] -= burnAmount;
67         totalSupply -= burnAmount;
68     }
69 
70     /* Send coins */
71     function transfer(address _to, uint256 _value) {
72         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
73         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
74         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
75         balanceOf[_to] += _value;                            // Add the same to the recipient
76         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
77     }
78 
79     /* Allow another contract to spend some tokens in your behalf */
80     function approve(address _spender, uint256 _value)
81         returns (bool success) {
82         allowance[msg.sender][_spender] = _value;
83         tokenRecipient spender = tokenRecipient(_spender);
84         return true;
85     }
86 
87     /* Approve and then comunicate the approved contract in a single tx */
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
89         returns (bool success) {    
90         tokenRecipient spender = tokenRecipient(_spender);
91         if (approve(_spender, _value)) {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93             return true;
94         }
95     }
96 
97     /* A contract attempts to get the coins */
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
100         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
101         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
102         balanceOf[_from] -= _value;                          // Subtract from the sender
103         balanceOf[_to] += _value;                            // Add the same to the recipient
104         allowance[_from][msg.sender] -= _value;
105         Transfer(_from, _to, _value);
106         return true;
107     }
108     
109     function setPrices(uint256 newBuyPrice) onlyOwner {
110         buyPrice = newBuyPrice;
111     }
112 
113     function buy() payable {
114         uint amount = msg.value / buyPrice;                // calculates the amount
115         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
116         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
117         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
118         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
119     }
120     
121     function moveFunds() onlyOwner {
122         if (!project_wallet.send(this.balance)) throw;
123     }
124 
125 
126     /* This unnamed function is called whenever someone tries to send ether to it */
127     function () {
128         throw;     // Prevents accidental sending of ether
129     }
130 }