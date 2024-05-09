1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 author : RNDM (Discord RNDM#3033)
6 Write me if you need coding service
7 My Ethereum address : 0x13373FEdb7f8dF156E5718303897Fae2d363Cc96
8 
9 Description tl;dr :
10 Simple trustless lottery with entries
11 After the contract reaches a certain amount of ethereum or when the owner calls "payWinnerManually()"
12 a winner gets calculated/drawed and paid out (10% fee for token giveaways).
13 
14 */
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20 */
21 contract Ownable {
22     address public owner;
23 
24     event OwnershipRenounced(address indexed previousOwner);
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() public {
28         owner = 0xc42559F88481e1Df90f64e5E9f7d7C6A34da5691;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipRenounced(owner);
44         owner = address(0);
45     }
46 }
47 
48 contract Lottery is Ownable {
49 
50     // The tokens can never be stolen
51     modifier secCheck(address aContract) {
52         require(aContract != address(contractCall));
53         _;
54     }
55 
56     /**
57     * Events
58     */
59 
60     event BoughtTicket(uint256 amount, address customer, uint yourEntry);
61     event WinnerPaid(uint256 amount, address winner);
62 
63 
64     /**
65     * Data
66     */
67 
68     _Contract contractCall;  // a reference to the contract
69     address[] public entries; // array with entries
70     uint256 entryCounter; // counter for the entries
71     uint256 public automaticThreshold; // automatic Threshold to close the lottery and pay the winner
72     uint256 public ticketPrice = 10 finney; // the price per lottery ticket (0.01 eth)
73     
74 
75 
76 
77 
78     constructor() public {
79         contractCall = _Contract(0x05215FCE25902366480696F38C3093e31DBCE69A);
80         automaticThreshold = 56; // 56 tickets 
81         ticketPrice = 10 finney; // 10finney = 0.01 eth
82         entryCounter = 0;
83     }
84 
85     // If you send money directly to the contract it gets treated like a donation
86     function() payable public {
87     }
88 
89 
90     function buyTickets() payable public {
91         //You have to send at least ticketPrice to get one entry
92         require(msg.value >= ticketPrice);
93 
94         address customerAddress = msg.sender;
95         //Use deposit to purchase _Contract tokens
96         contractCall.buy.value(msg.value)(customerAddress);
97         // add customer to the entry list
98         if (entryCounter == (entries.length)) {
99             entries.push(customerAddress);
100             }
101         else {
102             entries[entryCounter] = customerAddress;
103         }
104         // increment the entry counter
105         entryCounter++;
106         //fire event
107         emit BoughtTicket(msg.value, msg.sender, entryCounter);
108 
109          //Automatic Treshhold, checks if the always incremented entryCounter reached the threshold
110         if(entryCounter >= automaticThreshold) {
111             // withdraw + sell all tokens.
112             contractCall.exit();
113             // 10% token giveaway fee
114             giveawayFee();
115             //payout winner & start from beginning
116             payWinner();
117         }
118     }
119 
120     // Other functions
121  
122     /*
123     PRNG(Pseudorandom number generator) :
124     PRN can be 0 up to entrycounter-1. (equivalent to 1 up to entrycounter)
125     n := entrycounter
126 
127     Let n be an arbitrary number 
128     and
129     y := uint256(keccak256(P)) where P is an arbitrary value.
130     The returned PRN % (n) is going to be between
131     0 and n-1 due to modular arithmetic.
132     */
133     function PRNG() internal view returns (uint256) {
134         uint256 initialize1 = block.timestamp;
135         uint256 initialize2 = uint256(block.coinbase);
136         uint256 initialize3 = uint256(blockhash(entryCounter));
137         uint256 initialize4 = block.number;
138         uint256 initialize5 = block.gaslimit;
139         uint256 initialize6 = block.difficulty;
140 
141         uint256 calc1 = uint256(keccak256(abi.encodePacked((initialize1 * 5),initialize5,initialize6)));
142         uint256 calc2 = 1-calc1;
143         int256 ov = int8(calc2);
144         uint256 calc3 = uint256(sha256(abi.encodePacked(initialize1,ov,initialize3,initialize4)));
145         uint256 PRN = uint256(keccak256(abi.encodePacked(initialize1,calc1,initialize2,initialize3,calc3)))%(entryCounter);
146         return PRN;
147     }
148     
149 
150     // Choose a winner and pay him
151     function payWinner() internal returns (address) {
152         uint256 balance = address(this).balance;
153         uint256 number = PRNG(); // generates a pseudorandom number
154         address winner = entries[number]; // choose the winner with the pseudorandom number
155         winner.transfer(balance); // payout winner
156         entryCounter = 0; // Zero entries again => Lottery resetted
157 
158         emit WinnerPaid(balance, winner);
159         return winner;
160     }
161 
162     //
163     function giveawayFee() internal {   
164         uint256 balance = (address(this).balance / 10);
165         owner.transfer(balance);
166     }
167 
168     /*
169         If you plan to use this contract for your projects
170         be a man of honor and do not change or delete this function
171     */
172     function donateToDev() payable public {
173         address developer = 0x13373FEdb7f8dF156E5718303897Fae2d363Cc96;
174         developer.transfer(msg.value);
175     }
176 
177     //Number of tokens currently in the Lottery pool
178     function myTokens() public view returns(uint256) {
179         return contractCall.myTokens();
180     }
181 
182     //Amount of dividends currently in the Lottery pool
183     function myDividends() public view returns(uint256) {
184         return contractCall.myDividends(true);
185     }
186 
187 
188     /**
189     * Administrator functions
190     */
191 
192     // change the Threshold
193     function changeThreshold(uint newThreshold) onlyOwner() public {
194         // Owner is only able to change the threshold when no one bought (otherwise it would be unfair)
195         require(entryCounter == 0);
196         automaticThreshold = newThreshold;
197     }
198 
199     function changeTicketPrice(uint newticketPrice) onlyOwner() public {
200         // Owner is only able to change the ticket price when no one bought (otherwise it would be unfair)
201         require(entryCounter == 0);
202         ticketPrice = newticketPrice;
203     }
204 
205     // Admin can call the payWinner (ends lottery round & starts a new one) if it takes too long to reach the threshold
206     function payWinnerManually() public onlyOwner() returns (address) {
207         address winner = payWinner();
208         return winner;
209     }
210 
211     // check special functions
212     function imAlive() public onlyOwner() {
213         inactivity = 1;
214     }
215     /**
216     * Special functions
217     */
218 
219     /* 
220     *   In case the threshold is way too high and the owner/admin disappeared (inactive for 30days)
221     *   Everyone can call this function then the timestamp gets saved
222     *   after 30 days of owner-inactivity someone can call the function again and calls payWinner with it
223     */
224     uint inactivity = 1;
225     function adminIsDead() public {
226         if (inactivity == 1) {
227             inactivity == block.timestamp;
228         }
229         else {
230             uint256 inactivityThreshold = (block.timestamp - (30 days));
231             assert(inactivityThreshold < block.timestamp);
232             if (inactivity < inactivityThreshold) {
233                 inactivity = 1;
234                 payWinnerManually2();
235             }
236         }
237     }
238 
239     function payWinnerManually2() internal {
240         payWinner();
241     }
242 
243 
244      /* A trap door for when someone sends tokens other than the intended ones so the overseers
245       can decide where to send them. (credit: Doublr Contract) */
246     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner() secCheck(tokenAddress) returns (bool success) {
247         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
248     }
249 
250 
251 }
252 
253 
254 //Need to ensure this contract can send tokens to people
255 contract ERC20Interface
256 {
257     function transfer(address to, uint256 tokens) public returns (bool success);
258 }
259 
260 // Interface to actually call contract functions of e.g. REV1
261 contract _Contract
262 {
263     function buy(address) public payable returns(uint256);
264     function exit() public;
265     function myTokens() public view returns(uint256);
266     function myDividends(bool) public view returns(uint256);
267 }