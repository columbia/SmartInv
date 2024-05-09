1 pragma solidity ^0.4.11;
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
14 }
15 
16 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
17 
18 contract ERC20 {
19     /* Public variables of the token */
20     string public standard = 'RIALTO 1.0';
21     string public name;
22     string public symbol;
23     uint8 public decimals;
24     uint256 public supply;
25 
26     /* This creates an array with all balances */
27     mapping (address => uint256) public balances;
28     mapping (address => mapping (address => uint256)) public allowance;
29 
30     /* This generates a public event on the blockchain that will notify clients */
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed _owner, address indexed _spender, uint _value);
33 
34     /* Initializes contract with initial supply tokens to the creator of the contract */
35     function ERC20(
36         uint256 initialSupply,
37         string tokenName,
38         uint8 decimalUnits,
39         string tokenSymbol
40         ) {
41         balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
42         supply = initialSupply;                        // Update total supply
43         name = tokenName;                                   // Set the name for display purposes
44         symbol = tokenSymbol;                               // Set the symbol for display purposes
45         decimals = decimalUnits;                            // Amount of decimals for display purposes
46     }
47 
48 
49     function totalSupply() constant returns (uint totalSupply);
50     function balanceOf(address _owner) constant returns (uint256 balance);
51 
52 
53     /* Send coins */
54     function transfer(address _to, uint256 _value) returns (bool success);
55 
56  /* A contract attempts to get the coins */
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
58 
59 
60     /* Get the amount of remaining tokens to spend */
61         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62                 return allowance[_owner][_spender];
63         }
64 
65     /* Allow another contract to spend some tokens in your behalf */
66     function approve(address _spender, uint256 _value)
67         returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72     
73     /* Approve and then communicate the approved contract in a single tx */
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
75         returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }   
81     }   
82     
83        /* This unnamed function is called whenever someone tries to send ether to it */
84     function () {
85         throw;     // Prevents accidental sending of ether
86     }   
87 }   
88 contract Rialto is owned, ERC20 {
89 
90     uint256 public lockPercentage = 15;
91 
92     uint256 public expiration = block.timestamp + 180 days;
93 
94 
95     /* Initializes contract with initial supply tokens to the creator of the contract */
96     function Rialto(
97         uint256 initialSupply, // 100000000000000000
98         string tokenName, //RIALTO
99         uint8 decimalUnits, //9
100         string tokenSymbol // XRL
101     ) ERC20 (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
102 
103         /* Get balance of specific address */
104         function balanceOf(address _owner) constant returns (uint256 balance) {
105                 return balances[_owner];
106         }
107 
108         /* Get total supply of issued coins */
109         function totalSupply() constant returns (uint256 totalSupply) {
110                 return supply;
111         }
112 
113     function transferOwnership(address newOwner) onlyOwner {
114         if(!transfer(newOwner, balances[msg.sender])) throw;
115         owner = newOwner;
116     }
117 
118     /* Send coins */
119     function transfer(address _to, uint256 _value) returns (bool success){
120 
121 
122         if (balances[msg.sender] < _value) throw;           // Check if the sender has enough
123 
124         if (balances[_to] + _value < balances[_to]) throw; // Check for overflows
125 
126         if (msg.sender == owner && block.timestamp < expiration && (balances[msg.sender]-_value) < lockPercentage * supply / 100 ) throw;  // Locked funds
127 
128         balances[msg.sender] -= _value;                     // Subtract from the sender
129         balances[_to] += _value;                            // Add the same to the recipient
130         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
131         return true;
132     }
133 
134 
135     /* A contract attempts to get the coins */
136     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
137 
138 
139         if (balances[_from] < _value) throw;                 // Check if the sender has enough
140         if (balances[_to] + _value < balances[_to]) throw;  // Check for overflows
141         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
142         if (_from == owner && block.timestamp < expiration && (balances[_from]-_value) < lockPercentage * supply / 100) throw; //Locked funds
143 
144         balances[_from] -= _value;                          // Subtract from the sender
145         balances[_to] += _value;                            // Add the same to the recipient
146         allowance[_from][msg.sender] -= _value;
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151 
152 
153   }