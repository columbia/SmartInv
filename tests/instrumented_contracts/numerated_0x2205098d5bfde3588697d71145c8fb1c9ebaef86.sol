1 // loosely based on Bryn Bellomy code
2 // https://medium.com/@bryn.bellomy/solidity-tutorial-building-a-simple-auction-contract-fcc918b0878a
3 //
4 // 
5 // Our Aetherian #0 ownership is now handled by this contract instead of our core. This contract "owns" 
6 // the monster and players can bid to get their hands on this mystical creature until someone else outbids them.
7 // Every following sale increases the price by x1.5 until no one is willing to outbid the current owner.
8 // Once a player has lost ownership, they will get a full refund of their bid + 50% of the revenue created by the sale.
9 // The other 50% go to the dev team to fund development. 
10 // This "hot potato" style auction technically never ends and enables some very interesting scenarios
11 // for our in-game world
12 //
13 
14 pragma solidity ^0.4.21;
15 
16 /**
17 * @title SafeMath
18 * @dev Math operations with safety checks that throw on error
19 */
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two numbers, truncating the quotient.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return c;
42     }
43 
44     /**
45     * @dev Substracts two numbers, returns 0 if it would go into minus range.
46     */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (b >= a) {
49             return 0;
50         }
51         return a - b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 contract AuctionPotato {
65     using SafeMath for uint256; 
66     // static
67     address public owner;
68     uint public startTime;
69     
70     string name;
71     
72     // start auction manually at given time
73     bool started;
74 
75     // pototo
76     uint public potato;
77     uint oldPotato;
78     uint oldHighestBindingBid;
79     
80     // transfer ownership
81     address creatureOwner;
82     
83     event CreatureOwnershipTransferred(address indexed _from, address indexed _to);
84     
85     
86    
87     
88     uint public highestBindingBid;
89     address public highestBidder;
90     
91     // used to immidiately block placeBids
92     bool blockerPay;
93     bool blockerWithdraw;
94     
95     mapping(address => uint256) public fundsByBidder;
96   
97 
98     event LogBid(address bidder, address highestBidder, uint oldHighestBindingBid, uint highestBindingBid);
99     event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
100     
101     
102     
103     // initial settings on contract creation
104     constructor() public {
105     
106         
107         blockerWithdraw = false;
108         blockerPay = false;
109         
110         owner = msg.sender;
111         creatureOwner = owner;
112         
113         // 1 ETH starting price
114         highestBindingBid = 1000000000000000000;
115         potato = 0;
116         
117         started = false;
118         
119         name = "Aetherian";
120         
121     }
122 
123     function getHighestBid() internal
124         constant
125         returns (uint)
126     {
127         return fundsByBidder[highestBidder];
128     }
129     
130     
131     
132     function auctionName() public view returns (string _name) {
133         return name;
134     }
135     
136     // calculates the next bid amount so that you can have a one-click buy button
137     function nextBid() public view returns (uint _nextBid) {
138         return highestBindingBid.add(potato);
139     }
140     
141     
142     // command to start the auction
143     function startAuction() public onlyOwner returns (bool success){
144         require(started == false);
145         
146         started = true;
147         startTime = now;
148         
149         
150         return true;
151         
152     }
153     
154     function isStarted() public view returns (bool success) {
155         return started;
156     }
157 
158     function placeBid() public
159         payable
160         onlyAfterStart
161         onlyNotOwner
162         returns (bool success)
163     {   
164         // we are only allowing to increase in bidIncrements to make for true hot potato style
165         // while still allowing overbid to happen in case some parties are trying to 
166         require(msg.value >= highestBindingBid.add(potato));
167         require(msg.sender != highestBidder);
168         require(started == true);
169         require(blockerPay == false);
170         blockerPay = true;
171 
172         // if someone overbids, return their
173         if (msg.value > highestBindingBid.add(potato))
174         {
175             uint overbid = msg.value - highestBindingBid.add(potato);
176             msg.sender.transfer(overbid);
177         }
178         
179         // calculate the user's total bid based on the current amount they've sent to the contract
180         // plus whatever has been sent with this transaction
181 
182         
183         
184         oldHighestBindingBid = highestBindingBid;
185         
186         // set new highest bidder
187         highestBidder = msg.sender;
188         highestBindingBid = highestBindingBid.add(potato);
189         
190         fundsByBidder[msg.sender] = fundsByBidder[msg.sender].add(highestBindingBid);
191         
192         
193         oldPotato = potato;
194         
195         uint potatoShare;
196         
197         potatoShare = potato.div(2);
198         potato = highestBindingBid.mul(5).div(10);
199             
200         // special case at start of auction
201         if (creatureOwner == owner) {
202             fundsByBidder[owner] = fundsByBidder[owner].add(highestBindingBid);
203         }
204         else {
205             fundsByBidder[owner] = fundsByBidder[owner].add(potatoShare);
206             
207             fundsByBidder[creatureOwner] = fundsByBidder[creatureOwner].add(potatoShare);
208         }
209         
210         
211         
212         
213         emit LogBid(msg.sender, highestBidder, oldHighestBindingBid, highestBindingBid);
214         
215         
216         emit CreatureOwnershipTransferred(creatureOwner, msg.sender);
217         creatureOwner = msg.sender;
218         
219         
220         blockerPay = false;
221         return true;
222     }
223 
224     
225 
226     function withdraw() public
227     // can withdraw once overbid
228         returns (bool success)
229     {
230         require(blockerWithdraw == false);
231         blockerWithdraw = true;
232         
233         address withdrawalAccount;
234         uint withdrawalAmount;
235         
236         if (msg.sender == owner) {
237             withdrawalAccount = owner;
238             withdrawalAmount = fundsByBidder[withdrawalAccount];
239             
240             
241             // set funds to 0
242             fundsByBidder[withdrawalAccount] = 0;
243         }
244        
245         // overbid people can withdraw their bid + profit
246         // exclude owner because he is set above
247         if (msg.sender != highestBidder && msg.sender != owner) {
248             withdrawalAccount = msg.sender;
249             withdrawalAmount = fundsByBidder[withdrawalAccount];
250             fundsByBidder[withdrawalAccount] = 0;
251         }
252         
253         if (withdrawalAmount == 0) revert();
254     
255         // send the funds
256         msg.sender.transfer(withdrawalAmount);
257 
258         emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);
259         blockerWithdraw = false;
260         return true;
261     }
262     
263     // amount owner can withdraw
264     // that way you can easily compare the contract balance with your amount
265     // if there is more in the contract than your balance someone didn't withdraw
266     // let them know that :)
267     function ownerCanWithdraw() public view returns (uint amount) {
268         return fundsByBidder[owner];
269     }
270     
271     // just in case the contract is bust and can't pay
272     // should never be needed but who knows
273     function fuelContract() public onlyOwner payable {
274         
275     }
276     
277     function balance() public view returns (uint _balance) {
278         return address(this).balance;
279     }
280 
281     modifier onlyOwner {
282         require(msg.sender == owner);
283         _;
284     }
285 
286     modifier onlyNotOwner {
287         require(msg.sender != owner);
288         _;
289     }
290 
291     modifier onlyAfterStart {
292         if (now < startTime) revert();
293         _;
294     }
295 
296     
297     
298     
299     // who owns the creature (not necessarily auction winner)
300     function queryCreatureOwner() public view returns (address _creatureOwner) {
301         return creatureOwner;
302     }
303     
304     
305     
306    
307     
308 }