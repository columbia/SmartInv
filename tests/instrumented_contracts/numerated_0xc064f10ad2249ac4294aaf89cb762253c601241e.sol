1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
19 
20 contract token {
21     /* Public variables of the token */
22     string public standard = 'Token 0.1';
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
51         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
52         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
53         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
54         balanceOf[_to] += _value;                            // Add the same to the recipient
55         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
56     }
57 
58     /* Allow another contract to spend some tokens in your behalf */
59     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         tokenRecipient spender = tokenRecipient(_spender);
63         spender.receiveApproval(msg.sender, _value, this, _extraData);
64         return true;
65     }
66 
67     /* A contract attempts to get the coins */
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
70         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
71         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
72         balanceOf[_from] -= _value;                          // Subtract from the sender
73         balanceOf[_to] += _value;                            // Add the same to the recipient
74         allowance[_from][msg.sender] -= _value;
75         Transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /* This unnamed function is called whenever someone tries to send ether to it */
80     function () {
81         throw;     // Prevents accidental sending of ether
82     }
83 }
84 
85 contract MyAdvancedToken is owned, token {
86 
87     uint256 public totalSupply;
88 
89     mapping (address => bool) public frozenAccount;
90 
91     /* This generates a public event on the blockchain that will notify clients */
92     event FrozenFunds(address target, bool frozen);
93 
94     /* Initializes contract with initial supply tokens to the creator of the contract */
95     function MyAdvancedToken(
96         uint256 initialSupply,
97         string tokenName,
98         uint8 decimalUnits,
99         string tokenSymbol,
100         address centralMinter
101     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
102         if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
103         balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
104     }
105 
106     /* Send coins */
107     function transfer(address _to, uint256 _value) {
108         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
109         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
110         if (frozenAccount[msg.sender]) throw;                // Check if frozen
111         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
112         balanceOf[_to] += _value;                            // Add the same to the recipient
113         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
114     }
115 
116 
117     /* A contract attempts to get the coins */
118     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
119         if (frozenAccount[_from]) throw;                        // Check if frozen            
120         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
121         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
122         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
123         balanceOf[_from] -= _value;                          // Subtract from the sender
124         balanceOf[_to] += _value;                            // Add the same to the recipient
125         allowance[_from][msg.sender] -= _value;
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function mintToken(address target, uint256 mintedAmount) onlyOwner {
131         balanceOf[target] += mintedAmount;
132         totalSupply += mintedAmount;
133         Transfer(0, owner, mintedAmount);
134         Transfer(owner, target, mintedAmount);
135     }
136 
137     function freezeAccount(address target, bool freeze) onlyOwner {
138         frozenAccount[target] = freeze;
139         FrozenFunds(target, freeze);
140     }
141 
142 }