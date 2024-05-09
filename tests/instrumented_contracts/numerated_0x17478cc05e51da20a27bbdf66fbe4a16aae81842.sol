1 // based on Bryn Bellomy code
2 // https://medium.com/@bryn.bellomy/solidity-tutorial-building-a-simple-auction-contract-fcc918b0878a
3 //
4 // updated to 0.4.21 standard, replaced blocks with time, converted to hot potato style by Chibi Fighters
5 // added custom start command for owner so they don't take off immidiately
6 //
7 
8 pragma solidity ^0.4.21;
9 
10 /**
11 * @title SafeMath
12 * @dev Math operations with safety checks that throw on error
13 */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     /**
39     * @dev Substracts two numbers, returns 0 if it would go into minus range.
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (b >= a) {
43             return 0;
44         }
45         return a - b;
46     }
47 
48     /**
49     * @dev Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 contract AuctionPotato {
59     using SafeMath for uint256; 
60     // static
61     address public owner;
62     uint public startTime;
63     uint public endTime;
64     string public infoUrl;
65     string name;
66     
67     // start auction manually at given time
68     bool started;
69 
70     // pototo
71     uint public potato;
72     uint oldPotato;
73     uint oldHighestBindingBid;
74     
75     // transfer ownership
76     address creatureOwner;
77     address creature_newOwner;
78     event CreatureOwnershipTransferred(address indexed _from, address indexed _to);
79     
80     
81     // state
82     bool public canceled;
83     
84     uint public highestBindingBid;
85     address public highestBidder;
86     
87     // used to immidiately block placeBids
88     bool blockerPay;
89     bool blockerWithdraw;
90     
91     mapping(address => uint256) public fundsByBidder;
92     bool ownerHasWithdrawn;
93 
94     event LogBid(address bidder, address highestBidder, uint oldHighestBindingBid, uint highestBindingBid);
95     event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
96     event LogCanceled();
97     
98     
99     // initial settings on contract creation
100     constructor() public {
101         
102         blockerWithdraw = false;
103         blockerPay = false;
104         
105         owner = msg.sender;
106         creatureOwner = owner;
107         
108         // 0.002 ETH
109         highestBindingBid = 2000000000000000;
110         potato = 0;
111         
112         started = false;
113         
114         name = "Minotaur";
115         infoUrl = "https://chibifighters.io";
116         
117     }
118 
119     function getHighestBid() internal
120         constant
121         returns (uint)
122     {
123         return fundsByBidder[highestBidder];
124     }
125     
126     // query remaining time
127     // this should not be used, query endTime once and then calculate it in your frontend
128     // it's helpful when you want to debug in remix
129     function timeLeft() public view returns (uint time) {
130         if (now >= endTime) return 0;
131         return endTime - now;
132     }
133     
134     function auctionName() public view returns (string _name) {
135         return name;
136     }
137     
138     // calculates the next bid amount to you can have a oneclick buy button
139     function nextBid() public view returns (uint _nextBid) {
140         return highestBindingBid.add(potato);
141     }
142     
143     // calculates the bid after the current bid so nifty hackers can skip the queue
144     // this is not in our frontend and no one knows if it actually works
145     function nextNextBid() public view returns (uint _nextBid) {
146         return highestBindingBid.add(potato).add((highestBindingBid.add(potato)).mul(4).div(9));
147     }
148     
149     // command to start the auction
150     function startAuction(string _name, uint _duration_secs) public onlyOwner returns (bool success){
151         require(started == false);
152         
153         started = true;
154         startTime = now;
155         endTime = now + _duration_secs;
156         name = _name;
157         
158         return true;
159         
160     }
161     
162     function isStarted() public view returns (bool success) {
163         return started;
164     }
165 
166     function placeBid() public
167         payable
168         onlyAfterStart
169         onlyBeforeEnd
170         onlyNotCanceled
171         onlyNotOwner
172         returns (bool success)
173     {   
174         // we are only allowing to increase in bidIncrements to make for true hot potato style
175         require(msg.value == highestBindingBid.add(potato));
176         require(msg.sender != highestBidder);
177         require(started == true);
178         require(blockerPay == false);
179         blockerPay = true;
180         
181         // calculate the user's total bid based on the current amount they've sent to the contract
182         // plus whatever has been sent with this transaction
183 
184         fundsByBidder[msg.sender] = fundsByBidder[msg.sender].add(highestBindingBid);
185         fundsByBidder[highestBidder] = fundsByBidder[highestBidder].add(potato);
186         
187         oldHighestBindingBid = highestBindingBid;
188         
189         // set new highest bidder
190         highestBidder = msg.sender;
191         highestBindingBid = highestBindingBid.add(potato);
192         
193         // 40% potato results in ~6% 2/7
194         // 44% potato results in ? 13% 4/9 
195         // 50% potato results in ~16% /2
196         oldPotato = potato;
197         potato = highestBindingBid.mul(4).div(9);
198         
199         emit LogBid(msg.sender, highestBidder, oldHighestBindingBid, highestBindingBid);
200         blockerPay = false;
201         return true;
202     }
203 
204     function cancelAuction() public
205         onlyOwner
206         onlyBeforeEnd
207         onlyNotCanceled
208         returns (bool success)
209     {
210         canceled = true;
211         emit LogCanceled();
212         return true;
213     }
214 
215     function withdraw() public
216     // can withdraw once overbid
217         returns (bool success)
218     {
219         require(blockerWithdraw == false);
220         blockerWithdraw = true;
221         
222         address withdrawalAccount;
223         uint withdrawalAmount;
224 
225         if (canceled) {
226             // if the auction was canceled, everyone should simply be allowed to withdraw their funds
227             withdrawalAccount = msg.sender;
228             withdrawalAmount = fundsByBidder[withdrawalAccount];
229             // set funds to 0
230             fundsByBidder[withdrawalAccount] = 0;
231         }
232         
233         // owner can withdraw once auction is cancelled or ended
234         if (ownerHasWithdrawn == false && msg.sender == owner && (canceled == true || now > endTime)) {
235             withdrawalAccount = owner;
236             withdrawalAmount = highestBindingBid.sub(oldPotato);
237             ownerHasWithdrawn = true;
238             
239             // set funds to 0
240             fundsByBidder[withdrawalAccount] = 0;
241         }
242         
243         // overbid people can withdraw their bid + profit
244         // exclude owner because he is set above
245         if (!canceled && (msg.sender != highestBidder && msg.sender != owner)) {
246             withdrawalAccount = msg.sender;
247             withdrawalAmount = fundsByBidder[withdrawalAccount];
248             fundsByBidder[withdrawalAccount] = 0;
249         }
250 
251         // highest bidder can withdraw leftovers if he didn't before
252         if (!canceled && msg.sender == highestBidder && msg.sender != owner) {
253             withdrawalAccount = msg.sender;
254             withdrawalAmount = fundsByBidder[withdrawalAccount].sub(oldHighestBindingBid);
255             fundsByBidder[withdrawalAccount] = fundsByBidder[withdrawalAccount].sub(withdrawalAmount);
256         }
257 
258         if (withdrawalAmount == 0) revert();
259     
260         // send the funds
261         msg.sender.transfer(withdrawalAmount);
262 
263         emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);
264         blockerWithdraw = false;
265         return true;
266     }
267     
268     // amount owner can withdraw after auction ended
269     // that way you can easily compare the contract balance with your amount
270     // if there is more in the contract than your balance someone didn't withdraw
271     // let them know that :)
272     function ownerCanWithdraw() public view returns (uint amount) {
273         return highestBindingBid.sub(oldPotato);
274     }
275     
276     // just in case the contract is bust and can't pay
277     // should never be needed but who knows
278     function fuelContract() public onlyOwner payable {
279         
280     }
281     
282     function balance() public view returns (uint _balance) {
283         return address(this).balance;
284     }
285 
286     modifier onlyOwner {
287         require(msg.sender == owner);
288         _;
289     }
290 
291     modifier onlyNotOwner {
292         require(msg.sender != owner);
293         _;
294     }
295 
296     modifier onlyAfterStart {
297         if (now < startTime) revert();
298         _;
299     }
300 
301     modifier onlyBeforeEnd {
302         if (now > endTime) revert();
303         _;
304     }
305 
306     modifier onlyNotCanceled {
307         if (canceled) revert();
308         _;
309     }
310     
311     // who owns the creature (not necessarily auction winner)
312     function queryCreatureOwner() public view returns (address _creatureOwner) {
313         return creatureOwner;
314     }
315     
316     // transfer ownership for auction winners in case they want to trade the creature before release
317     function transferCreatureOwnership(address _newOwner) public {
318         require(msg.sender == creatureOwner);
319         creature_newOwner = _newOwner;
320     }
321     
322     // buyer needs to confirm the transfer
323     function acceptCreatureOwnership() public {
324         require(msg.sender == creature_newOwner);
325         emit CreatureOwnershipTransferred(creatureOwner, creature_newOwner);
326         creatureOwner = creature_newOwner;
327         creature_newOwner = address(0);
328     }
329     
330 }