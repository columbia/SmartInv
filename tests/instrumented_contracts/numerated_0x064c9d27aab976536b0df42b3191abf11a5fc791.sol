1 pragma solidity ^0.4.16;
2 
3 /*
4 \/\/\/\/\/\/\/\WELCOME TO BIG 2018 TOKEN/\/\/\/\/\/\/\/
5 This token is the first stage in a revolutionary new 
6 distributed game where the odds are forever in your 
7 favour yet similar to poker where chip leads give you
8 the edge; BIG2018TOKEN will play a similar role.
9 
10 
11 \/\/\/\/\/\/\/\/THE PRICE CAN ONLY GO UP\/\/\/\/\/\/\/\/
12 This smart contract will only allow a limited number of 
13 tokens to be bought each day. Once they are gone, you 
14 will have to wait for the next days release, yet the 
15 price will go up each day. This is set so the price will
16 rise 2.7%/DAY (the best I can get from my bank each yr)
17 or x2.25 each month. Rounded this gives:
18     Day001 = 0.00010 Eth
19     Day050 = 0.00037 Eth
20     Day100 = 0.00138 Eth
21     Day150 = 0.00528 Eth
22     Day200 = 0.02003 Eth
23     Day250 = 0.07633 Eth
24     Day300 = 0.28959 Eth
25     Day350 = 1.10048 Eth
26     Day365 = 1.64232 Eth
27     Day366(2019) no longer available :(
28  
29  This price increase will be to benifit the super early
30  birds who work closley with Ethereum and likely to find
31  this smart contract hidden away and able to call it 
32  directly before word spreads to the wider masses and a
33  UI and promotion gets involved later in the year.
34 */
35 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
36 
37 contract Big2018Token {
38     ////////////////////////////////////////////////////////
39     //Intitial Parameters
40     /**********Admin**********/
41     address public creator;  //keep track of creator
42     /**********DailyRelease**********/
43     uint256 public tokensDaily = 10000; //max tokens available each day
44     uint256 tokensToday = 0; //no tokens given out today
45     uint256 public leftToday = 10000; //tokens left to sell today
46     uint startPrice = 100000000000000; //COMPOUND INCREASE: Wei starter price that will be compounded
47     uint q = 37; //COMPOUND INCREASE: for (1+1/q) multipler rate of 1.027 per day
48     uint countBuy = 0; //count times bought
49     uint start2018 = 1514764800; //when tokens become available 
50     uint end2018 = 1546300799; //last second tokens available
51     uint day = 1; //what day is it
52     uint d = 86400; //sedonds in a day
53     uint dayOld = 1; //counter to kep track of last day tokens were given
54     /**********GameUsage**********/
55     address public game;  //address of Game later in year
56     mapping (address => uint) public box; //record each persons box choice
57     uint boxRand = 0; //To start with random assignment of box used later in year, ignore use for token
58     uint boxMax = 5; //Max random random assignment to box used later in year, ignore use for token
59     event BoxChange(address who, uint newBox); //event that notifies of a box change in game
60     /**********ERC20**********/
61     string public name;
62     string public symbol;
63     uint8 public decimals = 18;
64     uint256 public totalSupply;
65     mapping (address => uint256) public balanceOf; //record who owns what
66     event Transfer(address indexed from, address indexed to, uint256 value);// This generates a public event on the blockchain that will notify clients
67     event Burn(address indexed from, uint256 value); // This notifies clients about the amount burnt
68     mapping (address => mapping (address => uint256)) public allowance;
69     /**********EscrowTrades**********/
70     struct EscrowTrade {
71         uint256 value; //value of number or tokens for sale
72         uint price; //min purchase price from seller
73         address to; //specify who is to purchase the tokens
74         bool open; //anyone can purchase rather than named buyer. false = closed. true = open to all.
75     }
76     mapping (address => mapping (uint => EscrowTrade)) public escrowTransferInfo;
77     mapping (address => uint) userEscrowCount;
78     event Escrow(address from, uint256 value, uint price, bool open, address to); // This notifies clients about the escrow
79     struct EscrowTfr {
80         address from; //who has defined this escrow trade
81         uint tradeNo; //trade number this user has made
82     }
83     EscrowTfr[] public escrowTransferList; //make an array of the escrow trades to be looked up
84     uint public escrowCount = 0;
85 
86     ////////////////////////////////////////////////////////
87     //Run at start
88     function Big2018Token() public {
89         creator = msg.sender; //store sender as creator
90         game = msg.sender; //to be updated once game released with game address
91         totalSupply = 3650000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
92         balanceOf[this] = totalSupply;     // Give the creator all initial tokens
93         name = "BIG2018TOKEN";                // Set the name for display purposes
94         symbol = "B18";                       // Set the symbol for display purposes
95     }
96 
97     ////////////////////////////////////////////////////////
98     //The Price of the Token Each Day. 0 = today
99     function getPriceWei(uint _day) public returns (uint) {
100         require(now >= start2018 && now <= end2018); //must be in 2018
101         day = (now - start2018)/d + 1; //count number of days since opening
102         if (day > dayOld) {  //resent counter if first tx per day
103             uint256 _value = ((day - dayOld - 1)*tokensDaily + leftToday) * 10 ** uint256(decimals);
104             _transfer(this, creator, _value); //give remaining tokens from previous day to creator
105             tokensToday = 0; //reset no of tokens sold today, this wont stick as 'veiw' f(x). will be saved in buy f(x)
106             dayOld = day; //reset dayOld counter
107         }
108         if (_day != 0) { //if _day = 0, calculate price for today
109         day = _day; //which day should be calculated
110         }
111         // Computes 'startPrice * (1+1/q) ^ n' with precision p, needed as solidity does not allow decimal for compounding
112             //q & startPrice defined at top
113             uint n = day - 1; //n of days to compound the multipler by
114             uint p = 3 + n * 5 / 100; //itterations to calculate compound daily multiplier. higher is greater precision but more expensive
115             uint s = 0; //output. itterativly added to for result
116             uint x = 1; //multiply side of binomial expansion
117             uint y = 1; //divide side of binomial expansion
118             //itterate top q lines binomial expansion to estimate compound multipler
119             for (uint i = 0; i < p; ++i) { //each itteration gets closer, higher p = closer approximation but more costly
120                 s += startPrice * x / y / (q**i); //iterate adding each time to s
121                 x = x * (n-i); //calc multiply side
122                 y = y * (i+1); //calc divide side
123             }
124             return (s); //return priceInWei = s
125     }
126 
127     ////////////////////////////////////////////////////////
128     //Giving New Tokens To Buyer
129     function () external payable {
130         // must buy whole token when minting new here, but can buy/sell fractions between eachother
131         require(now >= start2018 && now <= end2018); //must be in 2018
132         uint priceWei = this.getPriceWei(0); //get todays price
133         uint256 giveTokens = msg.value / priceWei; //rounds down to no of tokens that can afford
134             if (tokensToday + giveTokens > tokensDaily) { //if asking for tokens than left today
135                 giveTokens = tokensDaily - tokensToday;    //then limit giving to remaining tokens
136                 }
137         countBuy += 1; //count usage
138         tokensToday += giveTokens; //count whole tokens issued today
139         box[msg.sender] = this.boxChoice(0); //assign box number to buyer
140         _transfer(this, msg.sender, giveTokens * 10 ** uint256(decimals)); //transfer tokens from this contract
141         uint256 changeDue = msg.value - (giveTokens * priceWei) * 99 / 100; //calculate change due, charged 1% to disincentivise high volume full refund calls.
142         require(changeDue < msg.value); //make sure refund is not more than input
143         msg.sender.transfer(changeDue); //give change
144         
145     }
146 
147     ////////////////////////////////////////////////////////
148     //To Find Users Token Ammount and Box number
149     function getValueAndBox(address _address) view external returns(uint, uint) {
150         return (balanceOf[_address], box[_address]);
151     }
152 
153     ////////////////////////////////////////////////////////
154     //For transfering tokens to others
155     function _transfer(address _from, address _to, uint _value) internal {
156         require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
157         require(balanceOf[_from] >= _value); // Check if the sender has enough
158         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
159         uint previousbalanceOf = balanceOf[_from] + balanceOf[_to]; // Save this for an assertion in the future
160         balanceOf[_from] -= _value; // Subtract from the sender
161         balanceOf[_to] += _value; // Add the same to the recipient
162         Transfer(_from, _to, _value);
163         assert(balanceOf[_from] + balanceOf[_to] == previousbalanceOf); // Asserts are used to use static analysis to find bugs in your code. They should never fail
164     }
165 
166     ////////////////////////////////////////////////////////
167     //Transfer tokens
168     function transfer(address _to, uint256 _value) public {
169         _transfer(msg.sender, _to, _value);
170     }
171 
172     ////////////////////////////////////////////////////////
173     //Transfer tokens from other address
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
175         require(_value <= allowance[_from][msg.sender]); // Check allowance
176         allowance[_from][msg.sender] -= _value;
177         _transfer(_from, _to, _value);
178         return true;
179     }
180 
181     ////////////////////////////////////////////////////////
182     //Set allowance for other address
183     function approve(address _spender, uint256 _value) public returns (bool success) {
184         allowance[msg.sender][_spender] = _value;
185         return true;
186     }
187 
188     ////////////////////////////////////////////////////////
189     //Set allowance for other address and notify
190     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
191         tokenRecipient spender = tokenRecipient(_spender);
192         if (approve(_spender, _value)) {
193             spender.receiveApproval(msg.sender, _value, this, _extraData);
194             return true;
195         }
196     }
197 
198     ////////////////////////////////////////////////////////
199     //Decide or change box used in game
200     function boxChoice(uint _newBox) public returns (uint) { 
201         //for _newBox = 0 assign random 
202         boxRand += 1; //count up for even start box assingment
203         if (boxRand > boxMax) { //stop box assignment too high
204                     boxRand = 1; //return to box 1
205             }
206         if (_newBox == 0) {
207             box[msg.sender] = boxRand; //give new random assignment to owner (or this if buying)
208         } else {
209         box[msg.sender] = _newBox; //give new assignment to owner (or this if buying)
210         }
211         BoxChange(msg.sender, _newBox); //let everyone know
212             return (box[msg.sender]); //output to console
213     }
214 
215     ////////////////////////////////////////////////////////
216     //Release the funds for expanding project
217     //Payable to re-top up contract
218     function fundsOut() payable public { 
219         require(msg.sender == creator); //only alow creator to take out
220         creator.transfer(this.balance); //take the lot, can pay back into this via different address if wished re-top up
221     }
222 
223     ////////////////////////////////////////////////////////
224     //Used to tweak and update for Game
225     function update(uint _option, uint _newNo, address _newAddress) public returns (string, uint) {
226         require(msg.sender == creator || msg.sender == game); //only alow creator or game to use
227         //change Max Box Choice
228         if (_option == 1) {
229             require(_newNo > 0);
230             boxMax = _newNo;
231             return ("boxMax Updated", boxMax);
232         }
233         //change address of game smart contract
234         if (_option == 2) {
235             game = _newAddress;
236             return ("Game Smart Contract Updated", 1);
237         }
238     }
239 
240     ////////////////////////////////////////////////////////
241     //Destroy tokens
242     function burn(uint256 _value) public returns (bool success) {
243         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
244         balanceOf[msg.sender] -= _value;            // Subtract from the sender
245         totalSupply -= _value;                      // Updates totalSupply
246         Burn(msg.sender, _value);
247         return true;
248     }
249 
250     ////////////////////////////////////////////////////////
251     //Destroy tokens from other account
252     function burnFrom(address _from, uint256 _value) public returns (bool success) {
253         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
254         require(_value <= allowance[_from][msg.sender]);    // Check allowance
255         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
256         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
257         totalSupply -= _value;                              // Update totalSupply
258         Burn(_from, _value);
259         return true;
260     }
261 
262     ////////////////////////////////////////////////////////
263     //For trsnsfering tokens to others using this SC to enure they pay    
264     function setEscrowTransfer(address _to, uint _value, uint _price, bool _open) external returns (bool success) {
265             //_to to specify a address who can purchase
266             //_open if anyone can purchase (set _to to any address)
267             //_price is min asking value for full value of tokens
268             //_value is number of tokens available
269             //_to, who will purchase value of tokens
270         _transfer(msg.sender, this, _value); //store _value in this contract
271         userEscrowCount[msg.sender] += 1;
272         var escrowTrade = escrowTransferInfo[msg.sender][userEscrowCount[msg.sender]]; //record transfer option details
273         escrowTrade.value += _value;//add value into retaining store for trade
274         escrowTrade.price = _price; //set asking price
275         escrowTrade.to = _to; //who will purchase
276         escrowTrade.open = _open; //is trade open to all. false = closed. true = open to anyone.
277         escrowCount += 1;
278         escrowTransferList.push(EscrowTfr(msg.sender, userEscrowCount[msg.sender]));
279         Escrow(msg.sender, _value, _price, _open, _to); // This notifies clients about the escrow
280         return (true); //success!
281     }
282     
283     ////////////////////////////////////////////////////////
284     //For purchasing tokens from others using this SC to give trust to purchase
285     function recieveEscrowTransfer(address _sender, uint _no) external payable returns (bool success) { 
286             //_sender is person buying from
287             require(escrowTransferInfo[_sender][_no].value != 0); //end if trade already completed
288         box[msg.sender] = this.boxChoice(box[msg.sender]); //assign box number to buyer
289         if (msg.sender == _sender) {
290             _transfer(this, msg.sender, escrowTransferInfo[_sender][_no].value); //put tokens back to sender account
291             escrowTransferInfo[_sender][_no].value = 0; //reset counter for escrow token
292             Escrow(_sender, 0, msg.value, escrowTransferInfo[_sender][_no].open, msg.sender); // This notifies clients about the escrow
293             return (true);
294         } else {
295             require(msg.value >= escrowTransferInfo[_sender][_no].price); //Check _to is Paying Enough
296             if (escrowTransferInfo[_sender][_no].open == false) {
297                 require(msg.sender == escrowTransferInfo[_sender][_no].to); //Check _to is the intended purchaser
298                 }
299             _transfer(this, msg.sender, escrowTransferInfo[_sender][_no].value);   
300             _sender.transfer(msg.value); //Send the sender the value of the trade
301             escrowTransferInfo[_sender][_no].value = 0; //no more in retaining store
302             Escrow(_sender, 0, msg.value, escrowTransferInfo[_sender][_no].open, msg.sender); // This notifies clients about the escrow
303             return (true); //success!
304         }
305     }
306 }