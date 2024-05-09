1 pragma solidity ^0.4.2;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) revert();
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
21 contract token {
22     /* Public variables of the token */
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     /* This creates an array with all balances */
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     /* This generates a public event on the blockchain that will notify clients */
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     /* Initializes contract with initial supply tokens to the creator of the contract */
36     function token(
37         uint256 initialSupply,
38         string tokenName,
39         uint8 decimalUnits,
40         string tokenSymbol
41         ) {
42         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
43         totalSupply = initialSupply;                        // Update total supply
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46         decimals = decimalUnits;                            // Amount of decimals for display purposes
47     }
48 
49     /* Send coins */
50     function transfer(address _to, uint256 _value) {
51         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
52         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
53         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
54         balanceOf[_to] += _value;                            // Add the same to the recipient
55         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
56     }
57 
58     /* Allow another contract to spend some tokens in your behalf */
59     function approve(address _spender, uint256 _value)
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65     /* Approve and then communicate the approved contract in a single tx */
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
67         returns (bool success) {    
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 
75     /* A contract attempts to get the coins */
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
79         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
80         balanceOf[_from] -= _value;                          // Subtract from the sender
81         balanceOf[_to] += _value;                            // Add the same to the recipient
82         allowance[_from][msg.sender] -= _value;
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /* This unnamed function is called whenever someone tries to send ether to it */
88     function () {
89         revert();     // Prevents accidental sending of ether
90     }
91 }
92 
93 contract VanMinhCoin is owned, token {
94 
95     uint public buyRate = 40000; // priceo of one token
96     bool public isSelling = true;
97 
98     mapping (address => bool) public frozenAccount;
99 
100     /* This generates a public event on the blockchain that will notify clients */
101     event FrozenFunds(address target, bool frozen);
102 
103     /* Initializes contract with initial supply tokens to the creator of the contract */
104     function VanMinhCoin(
105         uint256 initialSupply,
106         string tokenName,
107         uint8 decimalUnits,
108         string tokenSymbol
109     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
110 
111     /* Send coins */
112     function transfer(address _to, uint256 _value) {
113         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
114         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
115         if (frozenAccount[msg.sender]) revert();                // Check if frozen
116         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
117         balanceOf[_to] += _value;                            // Add the same to the recipient
118         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
119     }
120 
121     /* A contract attempts to get the coins */
122     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
123         if (frozenAccount[_from]) revert();                        // Check if frozen            
124         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
125         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
126         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
127         balanceOf[_from] -= _value;                          // Subtract from the sender
128         balanceOf[_to] += _value;                            // Add the same to the recipient
129         allowance[_from][msg.sender] -= _value;
130         Transfer(_from, _to, _value);
131         return true;
132     }
133 
134     function mintToken(address target, uint256 mintedAmount) onlyOwner {
135         balanceOf[target] += mintedAmount;
136         totalSupply += mintedAmount;
137         Transfer(0, owner, mintedAmount);
138         Transfer(owner, target, mintedAmount);
139     }
140 
141     function freezeAccount(address target, bool freeze) onlyOwner {
142         frozenAccount[target] = freeze;
143         FrozenFunds(target, freeze);
144     }
145 
146     function setBuyRate(uint newBuyRate) onlyOwner {
147         buyRate = newBuyRate;
148     }
149     
150     function setSelling(bool newStatus) onlyOwner {
151         isSelling = newStatus;
152     }
153 
154     function buy() payable {
155         if(isSelling == false) revert();
156         uint amount = msg.value * buyRate;                  // calculates the amount
157         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
158         balanceOf[owner] -= amount;                         // subtracts amount from seller's balance
159         Transfer(owner, msg.sender, amount);                // execute an event reflecting the change
160     }
161     
162     function withdrawToOwner(uint256 amountWei) onlyOwner {
163         owner.transfer(amountWei);
164     }
165 }