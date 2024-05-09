1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) revert();
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
45         name = tokenName;                                   // Set the name for display purposes
46         symbol = tokenSymbol;                               // Set the symbol for display purposes
47         decimals = decimalUnits;                            // Amount of decimals for display purposes
48     }
49 
50     /* Send coins */
51     function transfer(address _to, uint256 _value) {
52         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
53         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
54         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
55         balanceOf[_to] += _value;                            // Add the same to the recipient
56         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
57     }
58 
59     /* Allow another contract to spend some tokens in your behalf */
60     function approve(address _spender, uint256 _value)
61         returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         return true;
64     }
65 
66     /* Approve and then communicate the approved contract in a single tx */
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
68         returns (bool success) {    
69         tokenRecipient spender = tokenRecipient(_spender);
70         if (approve(_spender, _value)) {
71             spender.receiveApproval(msg.sender, _value, this, _extraData);
72             return true;
73         }
74     }
75 
76     /* A contract attempts to get the coins */
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
79         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
80         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
81         balanceOf[_from] -= _value;                          // Subtract from the sender
82         balanceOf[_to] += _value;                            // Add the same to the recipient
83         allowance[_from][msg.sender] -= _value;
84         Transfer(_from, _to, _value);
85         return true;
86     }
87 
88     /* This unnamed function is called whenever someone tries to send ether to it */
89     function () {
90         revert();     // Prevents accidental sending of ether
91     }
92 }
93 
94 contract WorkerToken is owned, token {
95 
96     uint public buyPrice = 10000;
97     bool public isSelling = true;
98 
99     mapping (address => bool) public frozenAccount;
100 
101     /* This generates a public event on the blockchain that will notify clients */
102     event FrozenFunds(address target, bool frozen);
103 
104     /* Initializes contract with initial supply tokens to the creator of the contract */
105     function WorkerToken(
106         uint256 initialSupply,
107         string tokenName,
108         uint8 decimalUnits,
109         string tokenSymbol
110     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
111 
112     /* Send coins */
113     function transfer(address _to, uint256 _value) {
114         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
115         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
116         if (frozenAccount[msg.sender]) revert();                // Check if frozen
117         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
118         balanceOf[_to] += _value;                            // Add the same to the recipient
119         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
120     }
121 
122     /* A contract attempts to get the coins */
123     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
124         if (frozenAccount[_from]) revert();                        // Check if frozen            
125         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
126         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
127         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
128         balanceOf[_from] -= _value;                          // Subtract from the sender
129         balanceOf[_to] += _value;                            // Add the same to the recipient
130         allowance[_from][msg.sender] -= _value;
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function mintToken(address target, uint256 mintedAmount) onlyOwner {
136         balanceOf[target] += mintedAmount;
137         Transfer(0, owner, mintedAmount);
138         Transfer(owner, target, mintedAmount);
139     }
140 
141     function freezeAccount(address target, bool freeze) onlyOwner {
142         frozenAccount[target] = freeze;
143         FrozenFunds(target, freeze);
144     }
145 
146     function setPrice(uint newBuyPrice) onlyOwner {
147         buyPrice = newBuyPrice;
148     }
149     
150     function setSelling(bool newStatus) onlyOwner {
151         isSelling = newStatus;
152     }
153 
154     function buy() payable {
155         if(isSelling == false) revert();
156         uint amount = msg.value * buyPrice;                  // calculates the amount
157         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
158         balanceOf[owner] -= amount;                         // subtracts amount from seller's balance
159         Transfer(owner, msg.sender, amount);                // execute an event reflecting the change
160     }
161     
162     function withdrawToOwner(uint256 amountWei) onlyOwner {
163         owner.transfer(amountWei);
164     }
165 }