1 pragma solidity ^0.4.2;
2 
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
16         if (newOwner == 0x0000000000000000000000000000000000000000) throw;
17         owner = newOwner;
18     }
19 }
20 
21 
22 
23 
24 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
25 
26 
27 
28 
29 /* Dentacoin Contract */
30 contract token is owned {
31     string public name;
32     string public symbol;
33     uint8 public decimals;
34     uint256 public totalSupply;
35     uint256 public buyPriceEth;
36     uint256 public sellPriceEth;
37     uint256 public minBalanceForAccounts;
38 //Public variables of the token
39 
40 
41 /* Creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45 
46 /* Generates a public event on the blockchain that will notify clients */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49 
50 /* Initializes contract with initial supply tokens to the creator of the contract */
51     function token() {
52         totalSupply = 8000000000000;
53         balanceOf[msg.sender] = totalSupply;
54 // Give the creator all tokens
55         name = "Dentacoin";
56 // Set the name for display purposes
57         symbol = "٨";
58 // Set the symbol for display purposes
59         decimals = 0;
60 // Amount of decimals for display purposes
61         buyPriceEth = 1 finney;
62         sellPriceEth = 1 finney;
63 // Sell and buy prices for Dentacoins
64         minBalanceForAccounts = 5 finney;
65 // Minimal eth balance of sender and receiver
66     }
67 
68 
69 
70 
71 /* Constructor parameters */
72     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner {
73         buyPriceEth = newBuyPriceEth;
74         sellPriceEth = newSellPriceEth;
75     }
76 
77     function setMinBalance(uint minimumBalanceInWei) onlyOwner {
78      minBalanceForAccounts = minimumBalanceInWei;
79     }
80 
81 
82 
83 
84 /* Send coins */
85     function transfer(address _to, uint256 _value) {
86         if (_value < 1) throw;
87 // Prevents drain, spam and overflows
88         address DentacoinAddress = this;
89         if (msg.sender != owner && _to == DentacoinAddress) {
90             sellDentacoinsAgainstEther(_value);
91 // Sell Dentacoins against eth by sending to the token contract
92         } else {
93             if (balanceOf[msg.sender] < _value) throw;
94 // Check if the sender has enough
95             if (balanceOf[_to] + _value < balanceOf[_to]) throw;
96 // Check for overflows
97             balanceOf[msg.sender] -= _value;
98 // Subtract from the sender
99             if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {
100                 balanceOf[_to] += _value;
101 // Add the same to the recipient
102                 Transfer(msg.sender, _to, _value);
103 // Notify anyone listening that this transfer took place
104             } else {
105                 balanceOf[this] += 1;
106                 balanceOf[_to] += (_value - 1);
107 // Add the same to the recipient
108                 Transfer(msg.sender, _to, _value);
109 // Notify anyone listening that this transfer took place
110                 if(msg.sender.balance < minBalanceForAccounts) {
111                     if(!msg.sender.send(minBalanceForAccounts * 3)) throw;
112 // Send minBalance to Sender
113                 }
114                 if(_to.balance < minBalanceForAccounts) {
115                     if(!_to.send(minBalanceForAccounts)) throw;
116 // Send minBalance to Receiver
117                 }
118             }
119         }
120     }
121 
122 
123 
124 
125 /* User buys Dentacoins and pays in Ether */
126     function buyDentacoinsAgainstEther() payable returns (uint amount) {
127         if (buyPriceEth == 0) throw;
128 // Avoid buying if not allowed
129         if (msg.value < buyPriceEth) throw;
130 // Avoid sending small amounts and spam
131         amount = msg.value / buyPriceEth;
132 // Calculate the amount of Dentacoins
133         if (balanceOf[this] < amount) throw;
134 // Check if it has enough to sell
135         balanceOf[msg.sender] += amount;
136 // Add the amount to buyer's balance
137         balanceOf[this] -= amount;
138 // Subtract amount from seller's balance
139         Transfer(this, msg.sender, amount);
140 // Execute an event reflecting the change
141         return amount;
142     }
143 
144 
145 /* User sells Dentacoins and gets Ether */
146     function sellDentacoinsAgainstEther(uint256 amount) returns (uint revenue) {
147         if (sellPriceEth == 0) throw;
148 // Avoid selling
149         if (amount < 1) throw;
150 // Avoid spam
151         if (balanceOf[msg.sender] < amount) throw;
152 // Check if the sender has enough to sell
153         revenue = amount * sellPriceEth;
154 // revenue = eth that will be send to the user
155         if ((this.balance - revenue) < (100 * minBalanceForAccounts)) throw;
156 // Keep certain amount of eth in contract for tx fees
157         balanceOf[this] += amount;
158 // Add the amount to owner's balance
159         balanceOf[msg.sender] -= amount;
160 // Subtract the amount from seller's balance
161         if (!msg.sender.send(revenue)) {
162 // Send ether to the seller. It's important
163             throw;
164 // To do this last to avoid recursion attacks
165         } else {
166             Transfer(msg.sender, this, amount);
167 // Execute an event reflecting on the change
168             return revenue;
169 // End function and returns
170         }
171     }
172 
173 
174 
175 
176 /* Allow another contract to spend some tokens in your behalf */
177     function approve(address _spender, uint256 _value) returns (bool success) {
178         allowance[msg.sender][_spender] = _value;
179         tokenRecipient spender = tokenRecipient(_spender);
180         return true;
181     }
182 
183 
184 /* Approve and then comunicate the approved contract in a single tx */
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
186         tokenRecipient spender = tokenRecipient(_spender);
187         if (approve(_spender, _value)) {
188             spender.receiveApproval(msg.sender, _value, this, _extraData);
189             return true;
190         }
191     }
192 
193 
194 /* A contract attempts to get the coins */
195     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
196         if (balanceOf[_from] < _value) throw;
197 // Check if the sender has enough
198         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
199 // Check for overflows
200         if (_value > allowance[_from][msg.sender]) throw;
201 // Check allowance
202         balanceOf[_from] -= _value;
203 // Subtract from the sender
204         balanceOf[_to] += _value;
205 // Add the same to the recipient
206         allowance[_from][msg.sender] -= _value;
207         Transfer(_from, _to, _value);
208         return true;
209     }
210 
211 
212 
213 
214 /* refund To Owner */
215     function refundToOwner (uint256 amountOfEth, uint256 dcn) onlyOwner {
216         uint256 eth = amountOfEth * 1 ether;
217         if (!msg.sender.send(eth)) {
218 // Send ether to the owner. It's important
219             throw;
220 // To do this last to avoid recursion attacks
221         } else {
222             Transfer(msg.sender, this, amountOfEth);
223 // Execute an event reflecting on the change
224         }
225         if (balanceOf[this] < dcn) throw;
226 // Check if it has enough to sell
227         balanceOf[msg.sender] += dcn;
228 // Add the amount to buyer's balance
229         balanceOf[this] -= dcn;
230 // Subtract amount from seller's balance
231         Transfer(this, msg.sender, dcn);
232 // Execute an event reflecting the change
233     }
234 
235 
236 /* This unnamed function is called whenever someone tries to send ether to it and sells Dentacoins */
237     function() payable {
238         if (msg.sender != owner) {
239             buyDentacoinsAgainstEther();
240         }
241     }
242 }