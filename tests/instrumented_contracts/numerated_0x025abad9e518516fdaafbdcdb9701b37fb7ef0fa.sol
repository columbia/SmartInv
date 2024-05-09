1 pragma solidity ^0.4.11;
2 
3 /**
4  * Authors: Justin Jones, Marshall Stokes
5  * Published: 2017 by Sprux LLC
6  */
7 
8 
9 /* Contract provides functions so only contract owner can execute a function */
10 contract owned {
11     address public owner; //the contract owner
12 
13     function owned() {
14         owner = msg.sender; //constructor initializes the creator as the owner on initialization
15     }
16 
17     modifier onlyOwner {
18         if (msg.sender != owner) throw; // functions with onlyOwner will throw and exception if not the contract owner
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner { // transfer contract owner to new owner
23         owner = newOwner;
24     }
25 }
26 
27 
28 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
29 
30 /**
31  * Centrally issued Ethereum token.
32  *
33  * Token supply is created in the token contract creation and allocated to one owner for distribution. This token is mintable, so more tokens
34  * can be added to the total supply and assigned to an address supplied at contract execution.
35  *
36  */
37 
38 contract StandardMintableToken is owned{ 
39     /* Public variables of the token */
40     string public standard = 'Token 0.1';
41     string public name;                     // the token name 
42     string public symbol;                   // the ticker symbol
43     uint8 public decimals;                  // amount of decimal places in the token
44     uint256 public totalSupply;             // total tokens
45     
46     /* This creates an array with all balances */
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49     
50     /* This creates an array with all frozen accounts */
51     mapping (address => bool) public frozenAccount;
52 
53     /* This generates a public event on the blockchain that will notify clients */
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     
56     /* This generates a public event on the blockchain that will notify clients */
57     event FrozenFunds(address target, bool frozen);
58     
59     /* This generates a public event on the blockchain that will notify clients */
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 
62     /* Initializes contract with initial supply tokens to the creator of the contract */
63     function StandardMintableToken(
64         string tokenName,               // the token name
65         uint8 decimalUnits,             // amount of decimal places in the token
66         string tokenSymbol,             // the token symbol
67         uint256 initialSupply            // the initial distro amount
68         ) {
69 
70         balanceOf[msg.sender] = initialSupply;                   // Give the creator all initial tokens
71         totalSupply = initialSupply;                             // Update total supply
72         name = tokenName;                                        // Set the name for display purposes
73         symbol = tokenSymbol;                                    // Set the symbol for display purposes
74         decimals = decimalUnits;                                 // Amount of decimals for display purposes
75     }
76 
77     /* Send tokens */
78     function transfer(address _to, uint256 _value) returns (bool success){
79         if (_value == 0) return false; 				             // Don't waste gas on zero-value transaction
80         if (balanceOf[msg.sender] < _value) return false;    // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
82         if (frozenAccount[msg.sender]) throw;                // Check if sender frozen
83         if (frozenAccount[_to]) throw;                       // Check if recipient frozen                 
84         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
85         balanceOf[_to] += _value;                            // Add the same to the recipient
86         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
87         return true;
88     }
89 
90     /* Allow another contract to spend some tokens on your behalf */
91     function approve(address _spender, uint256 _value)
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;            // Update allowance first
94         Approval(msg.sender, _spender, _value);              // Notify of new Approval
95         return true;
96     }
97 
98     /* Approve and then communicate the approved contract in a single tx */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100         returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }        
107 
108     /* A contract attempts to get the coins */
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         if (frozenAccount[_from]) throw;                        // Check if sender frozen       
111         if (frozenAccount[_to]) throw;                          // Check if recipient frozen                 
112         if (balanceOf[_from] < _value) return false;          	// Check if the sender has enough
113         if (balanceOf[_to] + _value < balanceOf[_to]) throw;    // Check for overflows
114         if (_value > allowance[_from][msg.sender]) throw;       // Check allowance
115         balanceOf[_from] -= _value;                             // Subtract from the sender
116         balanceOf[_to] += _value;                               // Add the same to the recipient
117         allowance[_from][msg.sender] -= _value;                 // Update sender's allowance 
118         Transfer(_from, _to, _value);                           // Perform the transfer
119         return true;
120     }
121     
122     /* A function to freeze or un-freeze accounts, to and from */
123     
124     function freezeAccount(address target, bool freeze ) onlyOwner {    
125         frozenAccount[target] = freeze;                       // set the array object to the value of bool freeze
126         FrozenFunds(target, freeze);                          // notify event
127     }
128     
129 
130     /* A function to burn tokens and remove from supply */
131     
132     function burn(uint256 _value) returns (bool success) {
133         if (frozenAccount[msg.sender]) throw;                 // Check if sender frozen       
134         if (_value == 0) return false; 				          // Don't waste gas on zero-value transaction
135         if (balanceOf[msg.sender] < _value) return false;     // Check if the sender has enough
136         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
137         totalSupply -= _value;                                // Updates totalSupply
138         Transfer(msg.sender,0, _value);	                      // Burn _value tokens
139         return true;
140     }
141 
142     function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success) {
143         if (frozenAccount[msg.sender]) throw;                // Check if sender frozen       
144         if (frozenAccount[_from]) throw;                     // Check if recipient frozen 
145         if (_value == 0) return false; 			             // Don't waste gas on zero-value transaction
146         if (balanceOf[_from] < _value) return false;         // Check if the sender has enough
147         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
148         balanceOf[_from] -= _value;                          // Subtract from the sender
149         totalSupply -= _value;                               // Updates totalSupply
150         allowance[_from][msg.sender] -= _value;				 // Updates allowance
151         Transfer(_from, 0, _value);                          // Burn tokens by Transfer to incinerator
152         return true;
153     }
154     
155     /* A function to add more tokens to the total supply, accessible only to owner*/
156     
157     function mintToken(address target, uint256 mintedAmount) onlyOwner {
158         if (balanceOf[target] + mintedAmount < balanceOf[target]) throw; // Check for overflows
159         balanceOf[target] += mintedAmount;
160         totalSupply += mintedAmount;
161         Transfer(0, target, mintedAmount);
162 
163     }
164     
165 }