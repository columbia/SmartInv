1 //ERC20 Token
2 pragma solidity ^0.4.2;
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
21 
22 contract token {
23     /* Public variables of the token */
24     string public standard = "ETHERCASH";
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     uint256 public totalSupply;
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
51     /* Send coins */
52     function transfer(address _to, uint256 _value) {
53         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
54         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
55         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
56         balanceOf[_to] += _value;                            // Add the same to the recipient
57         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
58     }
59 
60     /* Allow another contract to spend some tokens in your behalf */
61     function approve(address _spender, uint256 _value)
62         returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66 
67     /* Approve and then communicate the approved contract in a single tx */
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
69         returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 
77     /* A contract attempts _ to get the coins */
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
80         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
81         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
82         balanceOf[_from] -= _value;                          // Subtract from the sender
83         balanceOf[_to] += _value;                            // Add the same to the recipient
84         allowance[_from][msg.sender] -= _value;
85         Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     /* This unnamed function is called whenever someone tries to send ether to it */
90     function () {
91         throw;     // Prevents accidental sending of ether
92     }
93 }
94 
95 contract ETHERCASH is owned, token {
96 
97     uint256 public sellPrice;
98     uint256 public buyPrice;
99 
100     mapping(address=>bool) public frozenAccount;
101 
102 
103     /* This generates a public event on the blockchain that will notify clients */
104     event FrozenFunds(address target, bool frozen);
105 
106     /* Initializes contract with initial supply tokens to the creator of the contract */
107     uint256 public constant initialSupply = 200000000 * 10**18;
108     uint8 public constant decimalUnits = 18;
109     string public tokenName = "ETHERCASH";
110     string public tokenSymbol = "ETC";
111     function ETHERCASH() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
112      /* Send coins */
113     function transfer(address _to, uint256 _value) {
114         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
115         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
116         if (frozenAccount[msg.sender]) throw;                // Check if frozen
117         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
118         balanceOf[_to] += _value;                            // Add the same to the recipient
119         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
120     }
121 
122 
123     /* A contract attempts to get the coins */
124     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
125         if (frozenAccount[_from]) throw;                        // Check if frozen
126         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
127         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
128         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
129         balanceOf[_from] -= _value;                          // Subtract from the sender
130         balanceOf[_to] += _value;                            // Add the same to the recipient
131         allowance[_from][msg.sender] -= _value;
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     function mintToken(address target, uint256 mintedAmount) onlyOwner {
137         balanceOf[target] += mintedAmount;
138         totalSupply += mintedAmount;
139         Transfer(0, this, mintedAmount);
140         Transfer(this, target, mintedAmount);
141     }
142 
143     function freezeAccount(address target, bool freeze) onlyOwner {
144         frozenAccount[target] = freeze;
145         FrozenFunds(target, freeze);
146     }
147 
148     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
149         sellPrice = newSellPrice;
150         buyPrice = newBuyPrice;
151     }
152 
153     function buy() payable {
154         uint amount = msg.value / buyPrice;                // calculates the amount
155         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
156         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
157         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
158         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
159     }
160 
161     function sell(uint256 amount) {
162         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
163         balanceOf[this] += amount;                         // adds the amount to owner's balance
164         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
165         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
166             throw;                                         // to do this last to avoid recursion attacks
167         } else {
168             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
169         }
170     }
171 }