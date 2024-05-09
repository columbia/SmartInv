1 //sol MyAdvancedToken8
2 pragma solidity ^0.4.18;
3 // Peter's "tik", "TIK", "TiTok" - Token Contract IL MARE FILM, MyAdvancedToken8, 25th July 2017
4 
5 contract MyAdvancedToken8  {
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
16     event Deposit(address from, uint256 value);
17 
18 
19     /* Public variables of the token */
20     string public standard = 'ERC-Token 1.0';
21     string public name;
22     string public symbol;
23     uint8 public decimals;
24     uint256 public totalSupply;
25     
26 
27     function transferOwnership(address newOwner) public {
28         if (msg.sender != owner) revert();
29         owner = newOwner;
30     }
31 
32     /* Allow another contract to spend some tokens in your behalf */
33     function approve(address _spender, uint256 _value) public 
34         returns (bool success) {
35         allowance[msg.sender][_spender] = _value;
36         return true;
37     }
38 
39 
40     /* Initializes contract with initial supply tokens to the creator of the contract */
41     function MyAdvancedToken8(
42         uint256 initialSupply,
43         string tokenName,
44         uint8 decimalUnits,
45         string tokenSymbol
46     ) public
47     {
48         owner = msg.sender;
49         
50         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
51         totalSupply = initialSupply;                        // Update total supply
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54         decimals = decimalUnits;                            // Amount of decimals for display purposes
55     }
56     
57     /* Send coins */
58     function transfer(address _to, uint256 _value) public {
59         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
60         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
61         if (frozenAccount[msg.sender]) revert();                // Check if frozen
62         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
63         balanceOf[_to] += _value;                               // Add the same to the recipient
64         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
65     }
66 
67     /* A contract attempts to get the coins */
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         if (frozenAccount[_from]) revert();                        // Check if frozen            
70         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
71         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
72         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
73         balanceOf[_from] -= _value;                          // Subtract from the sender
74         balanceOf[_to] += _value;                            // Add the same to the recipient
75         allowance[_from][msg.sender] -= _value;
76         Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function mintToken(address target, uint256 mintedAmount) public {
81         if (msg.sender != owner) revert();
82         
83         balanceOf[target] += mintedAmount;
84         totalSupply += mintedAmount;
85         Transfer(0, this, mintedAmount);
86         Transfer(this, target, mintedAmount);
87     }
88 
89     function freezeAccount(address target, bool freeze) public {
90         if (msg.sender != owner) revert();
91         
92         frozenAccount[target] = freeze;
93         FrozenFunds(target, freeze);
94     }
95 
96     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public {
97         if (msg.sender != owner) revert();
98         
99         sellPrice = newSellPrice;
100         buyPrice = newBuyPrice;
101     }
102 
103     function buy() payable public {
104         uint amount = msg.value / buyPrice;                // calculates the amount
105         if (balanceOf[this] < amount) revert();             // checks if it has enough to sell
106         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
107         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
108         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
109     }
110 
111     function sell(uint256 amount) public {
112         bool sendSUCCESS = false;
113         if (balanceOf[msg.sender] < amount ) revert();        // checks if the sender has enough to sell
114         balanceOf[this] += amount;                         // adds the amount to owner's balance
115         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
116         
117         
118         sendSUCCESS = msg.sender.send(amount * sellPrice);
119         if (!sendSUCCESS) {                                     // sends ether to the seller. It's important
120             revert();                                           // to do this last to avoid recursion attacks
121         } else {
122             Transfer(msg.sender, this, amount);                 // executes an event reflecting on the change
123         }               
124     }
125     
126     // gets called when no other function matches
127 	function() payable public {
128 		// just being sent some cash?
129 		if (msg.value > 0)
130 			Deposit(msg.sender, msg.value);
131 	}
132     
133     
134 }