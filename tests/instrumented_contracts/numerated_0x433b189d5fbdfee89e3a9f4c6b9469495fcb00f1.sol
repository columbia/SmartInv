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
64     string name;
65     
66     // start auction manually at given time
67     bool started;
68 
69     // pototo
70     uint public potato;
71     uint oldPotato;
72     uint oldHighestBindingBid;
73     
74     // transfer ownership
75     address creatureOwner;
76     address creature_newOwner;
77     event CreatureOwnershipTransferred(address indexed _from, address indexed _to);
78     
79     
80     // state
81     bool public canceled;
82     
83     uint public highestBindingBid;
84     address public highestBidder;
85     
86     // used to immidiately block placeBids
87     bool blockerPay;
88     bool blockerWithdraw;
89     
90     mapping(address => uint256) public fundsByBidder;
91     bool ownerHasWithdrawn;
92 
93     event LogBid(address bidder, address highestBidder, uint oldHighestBindingBid, uint highestBindingBid);
94     event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
95     event LogCanceled();
96     
97     
98     // initial settings on contract creation
99     constructor() public {
100         
101         blockerWithdraw = false;
102         blockerPay = false;
103         
104         owner = msg.sender;
105         creatureOwner = owner;
106         
107         // 0.01 ETH
108         highestBindingBid = 10000000000000000;
109         potato = 0;
110         
111         started = false;
112         
113         name = "Pixor";
114         
115     }
116 
117     function getHighestBid() internal
118         constant
119         returns (uint)
120     {
121         return fundsByBidder[highestBidder];
122     }
123     
124     // query remaining time
125     // this should not be used, query endTime once and then calculate it in your frontend
126     // it's helpful when you want to debug in remix
127     function timeLeft() public view returns (uint time) {
128         if (now >= endTime) return 0;
129         return endTime - now;
130     }
131     
132     function auctionName() public view returns (string _name) {
133         return name;
134     }
135     
136     // calculates the next bid amount to you can have a oneclick buy button
137     function nextBid() public view returns (uint _nextBid) {
138         return highestBindingBid.add(potato);
139     }
140     
141     // calculates the bid after the current bid so nifty hackers can skip the queue
142     // this is not in our frontend and no one knows if it actually works
143     function nextNextBid() public view returns (uint _nextBid) {
144         return highestBindingBid.add(potato).add((highestBindingBid.add(potato)).mul(4).div(9));
145     }
146     
147     // command to start the auction
148     function startAuction(string _name, uint _duration_secs) public onlyOwner returns (bool success){
149         require(started == false);
150         
151         started = true;
152         startTime = now;
153         endTime = now + _duration_secs;
154         name = _name;
155         
156         return true;
157         
158     }
159     
160     function isStarted() public view returns (bool success) {
161         return started;
162     }
163 
164     function placeBid() public
165         payable
166         onlyAfterStart
167         onlyBeforeEnd
168         onlyNotCanceled
169         onlyNotOwner
170         returns (bool success)
171     {   
172         // we are only allowing to increase in bidIncrements to make for true hot potato style
173         require(msg.value == highestBindingBid.add(potato));
174         require(msg.sender != highestBidder);
175         require(started == true);
176         require(blockerPay == false);
177         blockerPay = true;
178         
179         // calculate the user's total bid based on the current amount they've sent to the contract
180         // plus whatever has been sent with this transaction
181 
182         fundsByBidder[msg.sender] = fundsByBidder[msg.sender].add(highestBindingBid);
183         fundsByBidder[highestBidder] = fundsByBidder[highestBidder].add(potato);
184         
185         oldHighestBindingBid = highestBindingBid;
186         
187         // set new highest bidder
188         highestBidder = msg.sender;
189         highestBindingBid = highestBindingBid.add(potato);
190         
191         // 40% potato results in ~6% 2/7
192         // 44% potato results in ? 13% 4/9 
193         // 50% potato results in ~16% /2
194         oldPotato = potato;
195         potato = highestBindingBid.mul(5).div(9);
196         
197         emit LogBid(msg.sender, highestBidder, oldHighestBindingBid, highestBindingBid);
198         blockerPay = false;
199         return true;
200     }
201 
202     function cancelAuction() public
203         onlyOwner
204         onlyBeforeEnd
205         onlyNotCanceled
206         returns (bool success)
207     {
208         canceled = true;
209         emit LogCanceled();
210         return true;
211     }
212 
213     function withdraw() public
214     // can withdraw once overbid
215         returns (bool success)
216     {
217         require(blockerWithdraw == false);
218         blockerWithdraw = true;
219         
220         address withdrawalAccount;
221         uint withdrawalAmount;
222 
223         if (canceled) {
224             // if the auction was canceled, everyone should simply be allowed to withdraw their funds
225             withdrawalAccount = msg.sender;
226             withdrawalAmount = fundsByBidder[withdrawalAccount];
227             // set funds to 0
228             fundsByBidder[withdrawalAccount] = 0;
229         }
230         
231         // owner can withdraw once auction is cancelled or ended
232         if (ownerHasWithdrawn == false && msg.sender == owner && (canceled == true || now > endTime)) {
233             withdrawalAccount = owner;
234             withdrawalAmount = highestBindingBid.sub(oldPotato);
235             ownerHasWithdrawn = true;
236             
237             // set funds to 0
238             fundsByBidder[withdrawalAccount] = 0;
239         }
240         
241         // overbid people can withdraw their bid + profit
242         // exclude owner because he is set above
243         if (!canceled && (msg.sender != highestBidder && msg.sender != owner)) {
244             withdrawalAccount = msg.sender;
245             withdrawalAmount = fundsByBidder[withdrawalAccount];
246             fundsByBidder[withdrawalAccount] = 0;
247         }
248 
249         // highest bidder can withdraw leftovers if he didn't before
250         if (!canceled && msg.sender == highestBidder && msg.sender != owner) {
251             withdrawalAccount = msg.sender;
252             withdrawalAmount = fundsByBidder[withdrawalAccount].sub(oldHighestBindingBid);
253             fundsByBidder[withdrawalAccount] = fundsByBidder[withdrawalAccount].sub(withdrawalAmount);
254         }
255 
256         if (withdrawalAmount == 0) revert();
257     
258         // send the funds
259         msg.sender.transfer(withdrawalAmount);
260 
261         emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);
262         blockerWithdraw = false;
263         return true;
264     }
265     
266     // amount owner can withdraw after auction ended
267     // that way you can easily compare the contract balance with your amount
268     // if there is more in the contract than your balance someone didn't withdraw
269     // let them know that :)
270     function ownerCanWithdraw() public view returns (uint amount) {
271         return highestBindingBid.sub(oldPotato);
272     }
273     
274     // just in case the contract is bust and can't pay
275     // should never be needed but who knows
276     function fuelContract() public onlyOwner payable {
277         
278     }
279     
280     function balance() public view returns (uint _balance) {
281         return address(this).balance;
282     }
283 
284     modifier onlyOwner {
285         require(msg.sender == owner);
286         _;
287     }
288 
289     modifier onlyNotOwner {
290         require(msg.sender != owner);
291         _;
292     }
293 
294     modifier onlyAfterStart {
295         if (now < startTime) revert();
296         _;
297     }
298 
299     modifier onlyBeforeEnd {
300         if (now > endTime) revert();
301         _;
302     }
303 
304     modifier onlyNotCanceled {
305         if (canceled) revert();
306         _;
307     }
308     
309     // who owns the creature (not necessarily auction winner)
310     function queryCreatureOwner() public view returns (address _creatureOwner) {
311         return creatureOwner;
312     }
313     
314     // transfer ownership for auction winners in case they want to trade the creature before release
315     function transferCreatureOwnership(address _newOwner) public {
316         require(msg.sender == creatureOwner);
317         creature_newOwner = _newOwner;
318     }
319     
320     // buyer needs to confirm the transfer
321     function acceptCreatureOwnership() public {
322         require(msg.sender == creature_newOwner);
323         emit CreatureOwnershipTransferred(creatureOwner, creature_newOwner);
324         creatureOwner = creature_newOwner;
325         creature_newOwner = address(0);
326     }
327     
328 }