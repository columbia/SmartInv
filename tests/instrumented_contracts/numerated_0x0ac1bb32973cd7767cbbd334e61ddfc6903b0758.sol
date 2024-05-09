1 //sol MyAdvancedToken7
2 pragma solidity ^0.4.13;
3 // Peter's TiTok Token Contract MyAdvancedToken7 25th July 2017
4 
5 contract MyAdvancedToken7  {
6     address public owner;
7     uint256 public sellPrice;
8     uint256 public buyPrice;
9 
10     mapping (address => bool) public frozenAccount;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event FrozenFunds(address target, bool frozen);
16  
17 
18     /* Public variables of the token */
19     string public standard = 'Token 0.1';
20     string public name;
21     string public symbol;
22     uint8 public decimals;
23     uint256 public totalSupply;
24 
25     function transferOwnership(address newOwner) {
26         if (msg.sender != owner) revert();
27         owner = newOwner;
28     }
29 
30     /* Allow another contract to spend some tokens in your behalf */
31     function approve(address _spender, uint256 _value)
32         returns (bool success) {
33         allowance[msg.sender][_spender] = _value;
34         return true;
35     }
36 
37     /* This unnamed function is called whenever someone tries to send ether to it */
38     function () {
39         revert();     // Prevents accidental sending of ether
40     }
41 
42     /* Initializes contract with initial supply tokens to the creator of the contract */
43     function MyAdvancedToken7(
44         uint256 initialSupply,
45         string tokenName,
46         uint8 decimalUnits,
47         string tokenSymbol
48     ) 
49     {
50         owner = msg.sender;
51         
52         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
53         totalSupply = initialSupply;                        // Update total supply
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
56         decimals = decimalUnits;                            // Amount of decimals for display purposes
57     }
58     
59     /* Send coins */
60     function transfer(address _to, uint256 _value) {
61         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
62         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
63         if (frozenAccount[msg.sender]) revert();                // Check if frozen
64         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
65         balanceOf[_to] += _value;                            // Add the same to the recipient
66         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
67     }
68 
69     /* A contract attempts to get the coins */
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         if (frozenAccount[_from]) revert();                        // Check if frozen            
72         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
73         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
74         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
75         balanceOf[_from] -= _value;                          // Subtract from the sender
76         balanceOf[_to] += _value;                            // Add the same to the recipient
77         allowance[_from][msg.sender] -= _value;
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function mintToken(address target, uint256 mintedAmount) {
83         if (msg.sender != owner) revert();
84         
85         balanceOf[target] += mintedAmount;
86         totalSupply += mintedAmount;
87         Transfer(0, this, mintedAmount);
88         Transfer(this, target, mintedAmount);
89     }
90 
91     function freezeAccount(address target, bool freeze) {
92         if (msg.sender != owner) revert();
93         
94         frozenAccount[target] = freeze;
95         FrozenFunds(target, freeze);
96     }
97 
98     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) {
99         if (msg.sender != owner) revert();
100         
101         sellPrice = newSellPrice;
102         buyPrice = newBuyPrice;
103     }
104 
105     function buy() payable {
106         uint amount = msg.value / buyPrice;                // calculates the amount
107         if (balanceOf[this] < amount) revert();             // checks if it has enough to sell
108         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
109         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
110         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
111     }
112 
113     function sell(uint256 amount) {
114         if (balanceOf[msg.sender] < amount ) revert();        // checks if the sender has enough to sell
115         balanceOf[this] += amount;                         // adds the amount to owner's balance
116         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
117         
118         
119         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
120             revert();                                         // to do this last to avoid recursion attacks
121         } else {
122             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
123         }               
124     }
125 }