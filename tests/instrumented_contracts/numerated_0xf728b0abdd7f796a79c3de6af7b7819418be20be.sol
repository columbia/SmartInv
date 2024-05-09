1 pragma solidity ^0.4.13;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MyToken {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     string public votingDescription;
12     uint256 public sellPrice;
13 
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17     mapping (address => uint256) public voted;  
18     mapping (address => string) public votedFor;  
19     mapping (address => uint256) public restFinish; 
20 
21 
22     /* This generates a public event on the blockchain that will notify clients */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     /* This notifies clients about the amount burnt */
26     event Burn(address indexed from, uint256 value);
27 
28     /* This notifies clients about the voting */
29     event voting(address target, uint256 voteType, string votedDesc);
30     
31     
32     /* Initializes contract with initial supply tokens to the creator of the contract */
33     function MyToken() {
34         balanceOf[msg.sender] = 3000000;              // Give the creator all initial tokens
35         totalSupply = 3000000;                        // Update total supply
36         name = 'GamityTest2';                                   // Set the name for display purposes
37         symbol = 'GMTEST2';                                     // Set the symbol for display purposes
38         decimals = 0;                                       // Amount of decimals for display purposes
39     }
40 
41     /* Internal transfer, only can be called by this contract */
42     function _transfer(address _from, address _to, uint _value) internal {
43         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
44         require (balanceOf[_from] > _value);                // Check if the sender has enough
45         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
46         balanceOf[_from] -= _value;                         // Subtract from the sender
47         balanceOf[_to] += _value;                            // Add the same to the recipient
48         Transfer(_from, _to, _value);
49     }
50 
51     /// @notice Send `_value` tokens to `_to` from your account
52     /// @param _to The address of the recipient
53     /// @param _value the amount to send
54     function transfer(address _to, uint256 _value) {
55         _transfer(msg.sender, _to, _value);
56     }
57 
58     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
59     /// @param _from The address of the sender
60     /// @param _to The address of the recipient
61     /// @param _value the amount to send
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         require (_value < allowance[_from][msg.sender]);     // Check allowance
64         allowance[_from][msg.sender] -= _value;
65         _transfer(_from, _to, _value);
66         return true;
67     }
68 
69     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
70     /// @param _spender The address authorized to spend
71     /// @param _value the max amount they can spend
72     function approve(address _spender, uint256 _value)
73         returns (bool success) {
74         allowance[msg.sender][_spender] = _value;
75         return true;
76     }
77 
78     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
79     /// @param _spender The address authorized to spend
80     /// @param _value the max amount they can spend
81     /// @param _extraData some extra information to send to the approved contract
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, this, _extraData);
87             return true;
88         }
89     }        
90 
91     /// @notice Remove `_value` tokens from the system irreversibly
92     /// @param _value the amount of money to burn
93     function burn(uint256 _value) returns (bool success) {
94         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
95         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
96         totalSupply -= _value;                                // Updates totalSupply
97         Burn(msg.sender, _value);
98         return true;
99     }
100 
101     function burnFrom(address _from, uint256 _value) returns (bool success) {
102         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
103         require(_value <= allowance[_from][msg.sender]);    // Check allowance
104         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
105         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
106         totalSupply -= _value;                              // Update totalSupply
107         Burn(_from, _value);
108         return true;
109     }
110     
111     
112     
113     
114     
115     function voteFor()  returns (bool success){   
116         voted[msg.sender] = 1;    
117         votedFor[msg.sender] = votingDescription;    
118         voting (msg.sender, 1, votingDescription);          
119         return true;                                  // ends function and returns
120     }
121     
122     function voteAgainst()  returns (bool success){   
123         voted[msg.sender] = 2;
124         votedFor[msg.sender] = votingDescription;   
125         voting (msg.sender, 2, votingDescription);          
126         return true;                                  // ends function and returns
127     }
128     
129     
130     
131    function newVoting(string description)  returns (bool success){    
132         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
133         votingDescription=description;
134         return true; 
135     }
136     
137     
138     function rest()  returns (bool success){    
139         require(balanceOf[msg.sender] >= 5000);         // checks if the sender has enough to sell
140         balanceOf[this] += 5000;                        // adds the amount to owner's balance
141         balanceOf[msg.sender] -= 5000; 
142         restFinish[msg.sender] = block.timestamp + 3 days;
143         return true; 
144     }
145     
146     
147     
148     
149     function setPrice(uint256 newSellPrice){
150         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
151         sellPrice = newSellPrice;
152     }
153      
154 
155     function sell(uint amount) returns (uint revenue){
156         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
157         balanceOf[this] += amount;                        // adds the amount to owner's balance
158         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
159         revenue = amount * sellPrice;
160         require(msg.sender.send(revenue));                // sends ether to the seller: it's important to do this last to prevent recursion attacks
161         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
162         return revenue;                                   // ends function and returns
163     }
164     
165     function getTokens() returns (uint amount){
166         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
167         require(balanceOf[this] >= amount);               // checks if it has enough to sell
168         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
169         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
170         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
171         return amount;                                    // ends function and returns
172     }
173     
174     function sendEther() payable returns (uint amount){
175         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
176         return amount;                                    // ends function and returns
177     }
178 
179     
180     function getEther()  returns (uint amount){
181         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
182         require(msg.sender.send(amount));                 // sends ether to the seller: it's important to do this last to prevent recursion attacks
183         return amount;                                  // ends function and returns
184     }
185     
186     
187     
188     
189     
190     
191 }