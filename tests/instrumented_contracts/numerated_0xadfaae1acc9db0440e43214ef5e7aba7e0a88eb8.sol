1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 Author : RNDM (Discord RNDM#3033)
6 Write me if you need coding service
7 My Ethereum address : 0x13373FEdb7f8dF156E5718303897Fae2d363Cc96
8 
9 Description tl;dr :
10 Simple trustless lottery with entries
11 After the contract reaches a certain amount of ethereum or when the owner calls "payWinnerManually()"
12 a winner gets calculated/drawed and paid out (100%, no Dev or Owner fee).
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
28         owner = msg.sender;
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
56     // When this is active no one is able to participate
57     modifier restriction() {
58         require(!_restriction);
59         _;
60     }
61 
62     /**
63     * Events
64     */
65 
66     event BoughtTicket(uint256 amount, address customer, uint yourEntry);
67     event WinnerPaid(uint256 amount, address winner);
68 
69 
70     /**
71     * Data
72     */
73 
74     _Contract contractCall;  // a reference to the contract
75     address[] public entries; // array with entries
76     uint256 entryCounter; // counter for the entries
77     uint256 public automaticThreshold; // automatic Threshold to close the lottery and pay the winner
78     uint256 public ticketPrice = 10 finney; // the price per lottery ticket (0.01 eth)
79     bool public _restriction; // check restriction modifier
80     
81 
82 
83 
84 
85     constructor() public {
86         contractCall = _Contract(0x05215FCE25902366480696F38C3093e31DBCE69A);
87         _restriction = true;
88         automaticThreshold = 100; // 100 tickets
89         ticketPrice = 10 finney; // 10 finney = 0.01 eth
90         entryCounter = 0;
91     }
92 
93     // If you send money directly to the contract its like a donation
94     function() payable public {
95     }
96 
97 
98     function buyTickets() restriction() payable public {
99         //You have to send at least ticketPrice to get one entry
100         require(msg.value >= ticketPrice);
101 
102         address customerAddress = msg.sender;
103         //Use deposit to purchase _Contract tokens
104         contractCall.buy.value(msg.value)(customerAddress);
105         // add customer to the entry list
106         if (entryCounter == (entries.length)) {
107             entries.push(customerAddress);
108             }
109         else {
110             entries[entryCounter] = customerAddress;
111         }
112         // increment the entry counter
113         entryCounter++;
114         //fire event
115         emit BoughtTicket(msg.value, msg.sender, entryCounter);
116 
117          //Automatic Treshhold, checks if the always incremented entryCounter reached the threshold
118         if(entryCounter >= automaticThreshold) {
119             // withdraw + sell all tokens.
120             contractCall.exit();
121 
122             //payout winner & start from beginning
123             payWinner();
124         }
125     }
126 
127     // Other functions
128     function PRNG() internal view returns (uint256) {
129         uint256 initialize1 = block.timestamp;
130         uint256 initialize2 = uint256(block.coinbase);
131         uint256 initialize3 = uint256(blockhash(entryCounter));
132         uint256 initialize4 = block.number;
133         uint256 initialize5 = block.gaslimit;
134         uint256 initialize6 = block.difficulty;
135 
136         uint256 calc1 = uint256(keccak256(abi.encodePacked((initialize1 * 5),initialize5,initialize6)));
137         uint256 calc2 = 1-calc1;
138         int256 ov = int8(calc2);
139         uint256 calc3 = uint256(sha256(abi.encodePacked(initialize1,ov,initialize3,initialize4)));
140         uint256 PRN = uint256(keccak256(abi.encodePacked(initialize1,calc1,initialize2,initialize3,calc3)))%(entryCounter);
141         return PRN;
142     }
143     
144 
145     // Choose a winner and pay him
146     function payWinner() internal returns (address) {
147         uint256 balance = address(this).balance;
148         uint256 number = PRNG(); // generates a pseudorandom number
149         address winner = entries[number]; // choose the winner with the pseudorandom number
150         winner.transfer(balance); // payout winner
151         entryCounter = 0; // Zero entries again => Lottery resetted
152 
153         emit WinnerPaid(balance, winner);
154         return winner;
155     }
156 
157     /*
158         If you plan to use this contract for your projects
159         be a man of honor and do not change or delete this function
160     */
161     function donateToDev() payable public {
162         address developer = 0x13373FEdb7f8dF156E5718303897Fae2d363Cc96;
163         developer.transfer(msg.value);
164     }
165 
166     //Number of tokens currently in the Lottery pool
167     function myTokens() public view returns(uint256) {
168         return contractCall.myTokens();
169     }
170 
171     //Amount of dividends currently in the Lottery pool
172     function myDividends() public view returns(uint256) {
173         return contractCall.myDividends(true);
174     }
175 
176 
177     /**
178     * Administrator functions
179     */
180 
181     //Disable the buy restriction
182     function disableRestriction() onlyOwner() public {
183         _restriction = false;
184     }
185 
186     // change the Threshold
187     function changeThreshold(uint newThreshold) onlyOwner() public {
188         // Owner is only able to change the threshold when no one bought (otherwise it would be unfair)
189         require(entryCounter == 0);
190         automaticThreshold = newThreshold;
191     }
192 
193     function changeTicketPrice(uint newticketPrice) onlyOwner() public {
194         // Owner is only able to change the ticket price when no one bought (otherwise it would be unfair)
195         require(entryCounter == 0);
196         ticketPrice = newticketPrice;
197     }
198 
199     // Admin can call the payWinner (ends lottery round & starts a new one) if it takes too long to reach the threshold
200     function payWinnerManually() public onlyOwner() returns (address) {
201         address winner = payWinner();
202         return winner;
203     }
204 
205     // check special functions
206     function imAlive() public onlyOwner() {
207         inactivity = 1;
208     }
209     /**
210     * Special functions
211     */
212 
213     /* 
214     *   In case the threshold is way too high and the owner/admin disappeared (inactive for 30days)
215     *   Everyone can call this function then the timestamp gets saved
216     *   after 30 days of owner-inactivity someone can call the function again and calls payWinner with it
217     */
218     uint inactivity = 1;
219     function adminIsDead() public {
220         if (inactivity == 1) {
221             inactivity == block.timestamp;
222         }
223         else {
224             uint256 inactivityThreshold = (block.timestamp - (30 days));
225             assert(inactivityThreshold < block.timestamp);
226             if (inactivity < inactivityThreshold) {
227                 inactivity = 1;
228                 payWinnerManually2();
229             }
230         }
231     }
232 
233     function payWinnerManually2() internal {
234         payWinner();
235     }
236 
237 
238      /* A trap door for when someone sends tokens other than the intended ones so the overseers
239       can decide where to send them. (credit: Doublr Contract) */
240     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner() secCheck(tokenAddress) returns (bool success) {
241         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
242     }
243 
244 
245 }
246 
247 
248 //Need to ensure this contract can send tokens to people
249 contract ERC20Interface
250 {
251     function transfer(address to, uint256 tokens) public returns (bool success);
252 }
253 
254 // Interface to actually call contract functions of e.g. REV1
255 contract _Contract
256 {
257     function buy(address) public payable returns(uint256);
258     function exit() public;
259     function myTokens() public view returns(uint256);
260     function myDividends(bool) public view returns(uint256);
261 }