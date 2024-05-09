1 pragma solidity 0.4.8;
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
23     string public standard = 'CJX 0.1';
24     string public name = 'CJX';
25     string public symbol = 'CJX';
26     uint8 public decimals = 6;
27     uint256 public totalSupply = 0;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /* Initializes contract with initial supply tokens to the creator of the contract */
37     function token(
38         uint256 initialSupply,
39         string tokenName,
40         uint8 decimalUnits,
41         string tokenSymbol
42         ) {
43         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
44         totalSupply = initialSupply;                        // Update total supply
45         name = name;                                   // Set the name for display purposes
46         symbol = symbol;                               // Set the symbol for display purposes
47         decimals = decimals;                            // Amount of decimals for display purposes
48     }
49 
50     /* Send coins */
51     function transfer(address _to, uint256 _value) {
52         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
53         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
54         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
55         balanceOf[_to] += _value;                            // Add the same to the recipient
56         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
57     }
58 
59     /* Allow another contract to spend some tokens in your behalf */
60     function approve(address _spender, uint256 _value)
61         returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         tokenRecipient spender = tokenRecipient(_spender);
64         return true;
65     }
66 
67     /* Approve and then comunicate the approved contract in a single tx */
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
95 contract CJXToken is owned, token {
96 
97     string public currentKey;
98     uint256 public bandwidthFactor;
99     uint256 public memoryFactor;
100     uint256 public timeFactor;
101     uint256 public totalSupply;
102 
103     mapping (address => bool) public frozenAccount;
104 
105     /* This generates a public event on the blockchain that will notify clients */
106     event FrozenFunds(address target, bool frozen);
107 
108     /* Initializes contract with initial supply tokens to the creator of the contract */
109     function CJXToken(
110         uint256 initialSupply,
111         string tokenName,
112         uint8 decimalUnits,
113         string tokenSymbol,
114         address centralMinter
115     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
116         if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
117         balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
118     }
119 
120     /* Send coins */
121     function transfer(address _to, uint256 _value) {
122         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
123         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
124         if (frozenAccount[msg.sender]) throw;                // Check if frozen
125         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
126         balanceOf[_to] += _value;                            // Add the same to the recipient
127         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
128     }
129 
130 
131     function mintToken(address target, uint256 mintedAmount) onlyOwner {
132         balanceOf[target] += mintedAmount;
133         totalSupply += mintedAmount;
134         Transfer(0, this, mintedAmount);
135         Transfer(this, target, mintedAmount);
136     }
137 
138     function freezeAccount(address target, bool freeze) onlyOwner {
139         frozenAccount[target] = freeze;
140         FrozenFunds(target, freeze);
141     }
142 
143     function setFactors(uint256 bf, uint256 mf, uint256 tf, string ck) onlyOwner {
144         bandwidthFactor = bf;
145         memoryFactor = mf;
146         timeFactor = tf;
147         currentKey = ck;
148     }
149 }