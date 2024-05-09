1 //ERC20 Token customised for travelcoins
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
24     string public standard = 'TRV 0.1';
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
36     event Allocate(address from,address to, uint value,uint price,bool equals);
37 
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function token(
40         uint256 initialSupply,
41         string tokenName,
42         uint8 decimalUnits,
43         string tokenSymbol
44         ) {
45         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
46         totalSupply = initialSupply;                        // Update total supply
47         name = tokenName;                                   // Set the name for display purposes
48         symbol = tokenSymbol;                               // Set the symbol for display purposes
49         decimals = decimalUnits;                            // Amount of decimals for display purposes
50     }
51 
52     /* Send coins */
53     function transfer(address _to, uint256 _value) {
54         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
55         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
56         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
57         balanceOf[_to] += _value;                            // Add the same to the recipient
58         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
59     }
60 
61     /* Allow another contract to spend some tokens in your behalf */
62     function approve(address _spender, uint256 _value)
63         returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         return true;
66     }
67 
68     /* Approve and then communicate the approved contract in a single tx */
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
70         returns (bool success) {
71         tokenRecipient spender = tokenRecipient(_spender);
72         if (approve(_spender, _value)) {
73             spender.receiveApproval(msg.sender, _value, this, _extraData);
74             return true;
75         }
76     }
77 
78     /* A contract attempts _ to get the coins */
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
82         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
83         balanceOf[_from] -= _value;                          // Subtract from the sender
84         balanceOf[_to] += _value;                            // Add the same to the recipient
85         allowance[_from][msg.sender] -= _value;
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /* This unnamed function is called whenever someone tries to send ether to it */
91     function () {
92         throw;     // Prevents accidental sending of ether
93     }
94 }
95 
96 contract TravelCoinToken is owned, token {
97 
98     uint256 public sellPrice;
99     uint256 public buyPrice;
100 
101     mapping(address=>bool) public frozenAccount;
102     mapping(address=>uint) public rewardPoints;
103     mapping(address=>bool) public oneTimeTickets;
104     mapping (address => bool) public oneTimeSold;
105     address[] public ONETIMESOLD;
106 
107 
108     /* This generates a public event on the blockchain that will notify clients */
109     event FrozenFunds(address target, bool frozen);
110 
111     /* Initializes contract with initial supply tokens to the creator of the contract */
112     uint256 public constant initialSupply = 200000 * 10**16;
113     uint8 public constant decimalUnits = 16;
114     string public tokenName = "TravelCoin";
115     string public tokenSymbol = "TRV";
116     function TravelCoinToken() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
117 
118     /* Send coins */
119     function transfer(address _to, uint256 _value) {
120         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
121         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
122         if (frozenAccount[msg.sender]) throw;                // Check if frozen
123         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
124         balanceOf[_to] += _value;                            // Add the same to the recipient
125         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
126         if(ticket_address_added[_to]){
127             if(_value>=tickets[_to].price){
128                 if(oneTimeSold[_to]) throw;
129                 if(oneTimeTickets[_to]){
130                     oneTimeSold[_to] = true;
131                     ONETIMESOLD.push(_to);
132                 }
133                 allocateTicket(msg.sender,_to);
134                 rewardPoints[msg.sender]+=tickets[_to].reward_pts;
135                 Allocate(msg.sender,_to,_value,tickets[_to].price,_value>=tickets[_to].price);
136                 //this Allocate event is a customised test
137             }
138         }
139     }
140 
141 
142     /* A contract attempts to get the coins */
143     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
144         if (frozenAccount[_from]) throw;                        // Check if frozen
145         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
146         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
147         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
148         balanceOf[_from] -= _value;                          // Subtract from the sender
149         balanceOf[_to] += _value;                            // Add the same to the recipient
150         allowance[_from][msg.sender] -= _value;
151         Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     function mintToken(address target, uint256 mintedAmount) onlyOwner {
156         balanceOf[target] += mintedAmount;
157         totalSupply += mintedAmount;
158         Transfer(0, this, mintedAmount);
159         Transfer(this, target, mintedAmount);
160     }
161 
162     function freezeAccount(address target, bool freeze) onlyOwner {
163         frozenAccount[target] = freeze;
164         FrozenFunds(target, freeze);
165     }
166 
167     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
168         sellPrice = newSellPrice;
169         buyPrice = newBuyPrice;
170     }
171 
172     function buy() payable {
173         uint amount = msg.value / buyPrice;                // calculates the amount
174         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
175         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
176         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
177         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
178     }
179 
180     function sell(uint256 amount) {
181         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
182         balanceOf[this] += amount;                         // adds the amount to owner's balance
183         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
184         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
185             throw;                                         // to do this last to avoid recursion attacks
186         } else {
187             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
188         }
189     }
190 
191     //Lavi's additional dApp code start
192     struct ticket{
193         uint price;
194         // bytes32 destination;
195         // bytes32 starting_point;
196         address _company_addr;
197         // uint ticket_no;
198         // bytes32 ticket_name;
199         // bytes32 times;
200         // uint land_time;
201         // uint topup;
202         uint reward_pts;
203         // uint expriration_time;
204         // bytes32 promo_no;
205         // bytes32 insurance_no;
206         // bytes32 category;
207     }
208 
209     mapping(address=>ticket) public tickets;
210     mapping(address=>bool) public ticket_address_added;
211     mapping(address=>address[]) public customer_tickets;
212     address[] public ticket_addresses;
213 
214     function addNewTicket(
215         // bytes32 category,
216         address ticket_address,
217         uint price,
218         // bytes32 to,
219         // bytes32 from,
220         // uint ticket_no,
221         // bytes32 ticket_name,
222         // bytes32 times,
223         // uint land_time,
224         // uint topup,
225         uint reward_pts,
226         bool oneTime
227         // uint expriration_time,
228         // bytes32 promo_no,
229         // bytes32 insurance_no
230         )
231     {
232         if(ticket_address_added[ticket_address]) throw;
233         ticket memory newTicket;
234         // newTicket.category = category;
235         newTicket.price = price;
236         // newTicket.destination = to;
237         // newTicket.starting_point = from;
238         newTicket._company_addr = ticket_address;
239         // newTicket.ticket_no = ticket_no;
240         // newTicket.ticket_name = ticket_name;
241         // newTicket.times = times;
242         // newTicket.land_time = land_time;
243         // newTicket.topup = topup;
244         newTicket.reward_pts = reward_pts;
245         if(oneTime)
246             oneTimeTickets[ticket_address] = true;
247         // newTicket.expriration_time = expriration_time;
248         // newTicket.promo_no = promo_no;
249         // newTicket.insurance_no = insurance_no;
250         tickets[ticket_address] = newTicket;
251         ticket_address_added[ticket_address] = true;
252         ticket_addresses.push(ticket_address);
253     }
254 
255     function allocateTicket(address customer_addr,address ticket_addr) internal {
256         customer_tickets[customer_addr].push(ticket_addr);
257     }
258 
259     function getAllTickets() constant returns (address[],uint[],uint[],bool[])
260     {
261         address[] memory tcks = ticket_addresses;
262         uint length = tcks.length;
263 
264         address[] memory addrs = new address[](length);
265         uint[] memory prices = new uint[](length);
266         uint[] memory points = new uint[](length);
267         bool[] memory OT = new bool[](length);
268         for(uint i = 0;i<length;i++){
269             addrs[i] = tcks[i];
270             prices[i] = tickets[tcks[i]].price;
271             points[i] = tickets[tcks[i]].reward_pts;
272             OT[i] = oneTimeTickets[tcks[i]];
273         }
274         return (addrs,prices,points,OT);
275     }
276 
277     function getONETIMESOLD() constant returns (address[]){
278         return ONETIMESOLD;
279     }
280 
281     function getMyTicketAddresses(address c) constant returns (address[]){
282         return (customer_tickets[c]);
283     }
284 
285     function transferTicket(address _to,address _t){
286         address[] memory myTickets = new address[](customer_tickets[msg.sender].length);
287         bool done_once = false;
288         for(uint i = 0; i < customer_tickets[msg.sender].length;i++){
289             if(customer_tickets[msg.sender][i]==_t&&!done_once){
290                 done_once = true;
291                 allocateTicket(_to,_t);
292                 continue;
293             }
294             myTickets[i] = (customer_tickets[msg.sender][i]);
295         }
296         customer_tickets[msg.sender] = myTickets;
297     }
298 }