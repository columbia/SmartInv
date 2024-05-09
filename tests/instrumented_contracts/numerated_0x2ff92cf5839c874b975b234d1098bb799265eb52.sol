1 pragma solidity ^0.4.2;
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
21 contract token {
22     /* Public variables of the token */
23     string public standard = 'Token 0.1';
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event FundTransfer(address backer, uint amount, bool isContribution);
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
77     /* A contract attempts to get the coins */
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
95 contract VNDCash is owned, token {
96 
97     uint256 public sellPrice;
98     uint256 public buyPrice;
99     uint256 public buyRate; // price one token per ether
100 
101     mapping (address => bool) public frozenAccount;
102 
103     /* This generates a public event on the blockchain that will notify clients */
104     event FrozenFunds(address target, bool frozen);
105 
106     /* Initializes contract with initial supply tokens to the creator of the contract */
107     function VNDCash(
108         uint256 initialSupply,
109         string tokenName,
110         uint8 decimalUnits,
111         string tokenSymbol
112     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
113 
114     /* Send coins */
115     function transfer(address _to, uint256 _value) {
116         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
117         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
118         if (frozenAccount[msg.sender]) throw;                // Check if frozen
119         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
120         balanceOf[_to] += _value;                            // Add the same to the recipient
121         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
122     }
123 
124 
125     /* A contract attempts to get the coins */
126     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
127         if (frozenAccount[_from]) throw;                        // Check if frozen            
128         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
129         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
130         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
131         balanceOf[_from] -= _value;                          // Subtract from the sender
132         balanceOf[_to] += _value;                            // Add the same to the recipient
133         allowance[_from][msg.sender] -= _value;
134         Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function mintToken(address target, uint256 mintedAmount) onlyOwner {
139         balanceOf[target] += mintedAmount;
140         totalSupply += mintedAmount;
141         Transfer(0, this, mintedAmount);
142         Transfer(this, target, mintedAmount);
143     }
144 
145     function freezeAccount(address target, bool freeze) onlyOwner {
146         frozenAccount[target] = freeze;
147         FrozenFunds(target, freeze);
148     }
149 
150     function setBuyRate(uint256 newBuyRate) onlyOwner {
151         buyRate = newBuyRate;
152     }
153 
154     function buy() payable {
155         uint256 amount = msg.value * buyRate;              // calculates the amount
156         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
157         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
158         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
159         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
160     }
161     
162     function withDraw(uint256 amountEther) onlyOwner {
163         FundTransfer(owner, amountEther, false);
164     }
165 }