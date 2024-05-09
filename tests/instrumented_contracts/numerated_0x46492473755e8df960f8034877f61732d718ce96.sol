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
11     address public owner;                                    //the contract owner
12 
13     function owned() {
14         owner = msg.sender;                                  //constructor initializes the creator as the owner on initialization
15     }
16 
17     modifier onlyOwner {
18         if (msg.sender != owner) throw;                      // functions with onlyOwner will throw an exception if not the contract owner
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner { // transfer contract owner to new owner
23         owner = newOwner;
24     }
25 }
26 
27 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
28 
29 
30 /**
31  * Centrally issued Ethereum token.
32  * 
33  *
34  * Token supply is created on deployment and allocated to contract owner and two 
35  * time-locked acccounts. The account deadlines (lock time) are in minutes from now.
36  * The owner can then transfer from its supply to crowdfund participants.
37  * The owner can burn any excessive tokens.
38  * The owner can freeze and unfreeze accounts
39  *
40  */
41 
42 contract StandardToken is owned{ 
43     /* Public variables of the token */
44     string public standard = 'Token 0.1';
45     string public name;                     // the token name 
46     string public symbol;                   // the ticker symbol
47     uint8 public decimals;                  // amount of decimal places in the token
48     address public the120address;           // the 120-day-locked address
49     address public the365address;           // the 365-day-locked address
50     uint public deadline120;                // days from contract creation in minutes to lock the120address (172800 minutes == 120 days)
51     uint public deadline365;                // days from contract creation in minutes to lock the365address (525600 minutes == 365 days)
52     uint256 public totalSupply;             // total number of tokens that exist (e.g. not burned)
53     
54     /* This creates an array with all balances */
55     mapping (address => uint256) public balanceOf;
56     mapping (address => mapping (address => uint256)) public allowance;
57     
58     /* This creates an array with all frozen accounts */
59     mapping (address => bool) public frozenAccount;
60 
61     /* This generates a public event on the blockchain that will notify clients */
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     
64     /* This generates a public event on the blockchain that will notify clients */
65     event FrozenFunds(address target, bool frozen);
66 
67     /* This generates a public event on the blockchain that will notify clients */
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70     /* Initializes contract with entire supply of tokens assigned to our distro accounts */
71     function StandardToken(
72 
73         string tokenName,   
74         uint8 decimalUnits,
75         string tokenSymbol,
76         
77         uint256 distro1,            // the initial crowdfund distro amount
78         uint256 distro120,          // the 120 day distro amount
79         uint256 distro365,          // the 365 day distro amount
80         address address120,         // the 120 day address 
81         address address365,         // the 365 day address
82         uint durationInMinutes120,  // amount of minutes to lock address120
83         uint durationInMinutes365   // amount of minutes to lock address365
84         
85         ) {
86         balanceOf[msg.sender] = distro1;                         // Give the owner tokens for initial crowdfund distro
87         balanceOf[address120] = distro120;                       // Set 120 day address balance (to be locked)
88         balanceOf[address365] = distro365;                       // Set 365 day address balance (to be locked)
89         freezeAccount(address120, true);                         // Freeze the 120 day address on creation
90         freezeAccount(address365, true);                         // Freeze the 120 day address on creation
91         totalSupply = distro1+distro120+distro365;               // Total supply is sum of tokens assigned to distro accounts
92         deadline120 = now + durationInMinutes120 * 1 minutes;    // Set the 120 day deadline
93         deadline365 = now + durationInMinutes365 * 1 minutes;    // Set the 365 day deadline
94         the120address = address120;                              // Set the publicly accessible 120 access
95         the365address = address365;                              // Set the publicly accessible 365 access
96         name = tokenName;                                        // Set the name for display purposes
97         symbol = tokenSymbol;                                    // Set the symbol for display purposes
98         decimals = decimalUnits;                                 // Number of decimals for display purposes
99     }
100 
101     /* Send tokens */
102     function transfer(address _to, uint256 _value) returns (bool success){
103         if (_value == 0) return false; 				             // Don't waste gas on zero-value transaction
104         if (balanceOf[msg.sender] < _value) return false;        // Check if the sender has enough
105         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
106         if (frozenAccount[msg.sender]) throw;                // Check if sender is frozen
107         if (frozenAccount[_to]) throw;                       // Check if target is frozen                 
108         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
109         balanceOf[_to] += _value;                            // Add the same to the recipient
110         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
111         return true;
112     }
113 
114     /* Allow another contract to spend some tokens on your behalf */
115     function approve(address _spender, uint256 _value)
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /* Approve and then communicate the approved contract in a single tx */
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124         returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }        
131 
132     /* A contract attempts to get the coins */
133     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
134         if (frozenAccount[_from]) throw;                        // Check if sender frozen       
135         if (frozenAccount[_to]) throw;                          // Check if target frozen                 
136         if (balanceOf[_from] < _value) return false;            // Check if the sender has enough
137         if (balanceOf[_to] + _value < balanceOf[_to]) throw;    // Check for overflows
138         if (_value > allowance[_from][msg.sender]) throw;       // Check allowance
139         balanceOf[_from] -= _value;                             // Subtract from the sender
140         balanceOf[_to] += _value;                               // Add the same to the recipient
141         allowance[_from][msg.sender] -= _value;                 // Allowance changes
142         Transfer(_from, _to, _value);                           // Tokens are send
143         return true;
144     }
145     
146     /* A function to freeze or un-freeze an account, to and from */
147     function freezeAccount(address target, bool freeze ) onlyOwner {    
148         if ((target == the120address) && (now < deadline120)) throw;    // Ensure you can not change 120address frozen status until deadline
149         if ((target == the365address) && (now < deadline365)) throw;    // Ensure you can not change 365address frozen status until deadline
150         frozenAccount[target] = freeze;                                 // Set the array object to the value of bool freeze
151         FrozenFunds(target, freeze);                                    // Notify event
152     }
153     
154     /* A function to burn tokens and remove from supply */
155     function burn(uint256 _value) returns (bool success)  {
156 		if (frozenAccount[msg.sender]) throw;                  // Check if sender frozen       
157         if (_value == 0) return false;			               // Don't waste gas on zero-value transaction
158         if (balanceOf[msg.sender] < _value) return false;      // Check if the sender has enough
159         balanceOf[msg.sender] -= _value;                       // Subtract from the sender
160         totalSupply -= _value;                                 // Reduce totalSupply accordingly
161         Transfer(msg.sender,0, _value);                        // Burn baby burn
162         return true;
163     }
164 
165     function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success)  {
166         if (frozenAccount[msg.sender]) throw;                  // Check if sender frozen       
167         if (frozenAccount[_from]) throw;                       // Check if recipient frozen 
168         if (_value == 0) return false;			               // Don't waste gas on zero-value transaction
169         if (balanceOf[_from] < _value) return false;           // Check if the sender has enough
170         if (_value > allowance[_from][msg.sender]) throw;      // Check allowance
171         balanceOf[_from] -= _value;                            // Subtract from the sender
172         allowance[_from][msg.sender] -= _value;                // Allowance is updated
173         totalSupply -= _value;                                 // Updates totalSupply
174         Transfer(_from, 0, _value);
175         return true;
176     }
177 
178 }