1 // loosely based on Bryn Bellomy code
2 // https://medium.com/@bryn.bellomy/solidity-tutorial-building-a-simple-auction-contract-fcc918b0878a
3 //
4 // updated to 0.4.25 standard, replaced blocks with time, converted to hot potato style by Chibi Fighters
5 // https://chibifighters.io
6 //
7 
8 pragma solidity ^0.4.25;
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
58 
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor () internal {
75         _owner = msg.sender;
76         emit OwnershipTransferred(address(0), _owner);
77     }
78 
79     /**
80      * @return the address of the owner.
81      */
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(isOwner());
91         _;
92     }
93 
94     /**
95      * @return true if `msg.sender` is the owner of the contract.
96      */
97     function isOwner() public view returns (bool) {
98         return msg.sender == _owner;
99     }
100 
101     /**
102      * @dev Allows the current owner to relinquish control of the contract.
103      * @notice Renouncing to ownership will leave the contract without an owner.
104      * It will not be possible to call the functions with the `onlyOwner`
105      * modifier anymore.
106      */
107     function renounceOwnership() public onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address newOwner) public onlyOwner {
117         _transferOwnership(newOwner);
118     }
119 
120     /**
121      * @dev Transfers control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function _transferOwnership(address newOwner) internal {
125         require(newOwner != address(0));
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 
132 contract AuctionPotato is Ownable {
133     using SafeMath for uint256; 
134 
135     string name;
136     uint public startTime;
137     uint public endTime;
138     uint auctionDuration;
139 
140     // pototo
141     uint public potato;
142     uint oldPotato;
143     uint oldHighestBindingBid;
144     
145     // state
146     bool public canceled;
147     uint public highestBindingBid;
148     address public highestBidder;
149     
150     // used to immidiately block placeBids
151     bool blockerPay;
152     bool blockerWithdraw;
153     
154     mapping(address => uint256) public fundsByBidder;
155     bool ownerHasWithdrawn;
156 
157     // couple events
158     event LogBid(address bidder, address highestBidder, uint oldHighestBindingBid, uint highestBindingBid);
159     event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
160     event LogCanceled();
161     event Withdraw(address owner, uint amount);
162     
163     
164     constructor() public {
165         
166         blockerWithdraw = false;
167         blockerPay = false;
168         
169         // 0.003 ETH
170         highestBindingBid = 3000000000000000;
171         potato = 0;
172         
173         // set to 3 hours
174         auctionDuration = 3 hours;
175 
176         // 01/06/2019 @ 6:00pm (UTC) 1546797600 Brenna Sparks 3
177 
178         startTime = 1546797600;
179         endTime = startTime + auctionDuration;
180 
181         name = "Brenna Sparks 3";
182 
183     }
184     
185     
186     function setStartTime(uint _time) onlyOwner public 
187     {
188         require(now < startTime);
189         startTime = _time;
190         endTime = startTime + auctionDuration;
191     }
192 
193 
194     // calculates the next bid amount to you can have a oneclick buy button
195     function nextBid() public view returns (uint _nextBid) {
196         return highestBindingBid.add(potato);
197     }
198     
199     
200     // calculates the bid after the current bid so nifty hackers can skip the queue
201     // this is not in our frontend and no one knows if it actually works
202     function nextNextBid() public view returns (uint _nextBid) {
203         return highestBindingBid.add(potato).add((highestBindingBid.add(potato)).mul(4).div(9));
204     }
205     
206     
207     function queryAuction() public view returns (string, uint, address, uint, uint, uint)
208     {
209         
210         return (name, nextBid(), highestBidder, highestBindingBid, startTime, endTime);
211         
212     }
213 
214 
215     function placeBid() public
216         payable
217         onlyAfterStart
218         onlyBeforeEnd
219         onlyNotCanceled
220     {   
221         // we are only allowing to increase in bidIncrements to make for true hot potato style
222         require(msg.value == highestBindingBid.add(potato));
223         require(msg.sender != highestBidder);
224         require(now > startTime);
225         require(blockerPay == false);
226         blockerPay = true;
227         
228         // calculate the user's total bid based on the current amount they've sent to the contract
229         // plus whatever has been sent with this transaction
230 
231         fundsByBidder[msg.sender] = fundsByBidder[msg.sender].add(highestBindingBid);
232         fundsByBidder[highestBidder] = fundsByBidder[highestBidder].add(potato);
233 
234         highestBidder.transfer(fundsByBidder[highestBidder]);
235         fundsByBidder[highestBidder] = 0;
236         
237         oldHighestBindingBid = highestBindingBid;
238         
239         // set new highest bidder
240         highestBidder = msg.sender;
241         highestBindingBid = highestBindingBid.add(potato);
242 
243         oldPotato = potato;
244         potato = highestBindingBid.mul(4).div(9);
245         
246         emit LogBid(msg.sender, highestBidder, oldHighestBindingBid, highestBindingBid);
247         
248         blockerPay = false;
249     }
250 
251 
252     function cancelAuction() public
253         onlyOwner
254         onlyBeforeEnd
255         onlyNotCanceled
256     {
257         canceled = true;
258         emit LogCanceled();
259         
260         emit Withdraw(highestBidder, address(this).balance);
261         highestBidder.transfer(address(this).balance);
262         
263     }
264 
265 
266     function withdraw() public onlyOwner {
267         require(now > endTime);
268         
269         emit Withdraw(msg.sender, address(this).balance);
270         msg.sender.transfer(address(this).balance);
271     }
272 
273 
274     function balance() public view returns (uint _balance) {
275         return address(this).balance;
276     }
277 
278 
279     modifier onlyAfterStart {
280         if (now < startTime) revert();
281         _;
282     }
283 
284     modifier onlyBeforeEnd {
285         if (now > endTime) revert();
286         _;
287     }
288 
289     modifier onlyNotCanceled {
290         if (canceled) revert();
291         _;
292     }
293     
294 }