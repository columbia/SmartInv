1 pragma solidity 0.4.19;
2 // The frontend for this smart contract is a dApp hosted at
3 // https://hire.kohweijie.com
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   /**
73   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 
91 // The frontend for this smart contract is a dApp hosted at
92 // https://hire.kohweijie.com
93 contract HireMe is Ownable {
94     struct Bid { // Data structure representing an individual bid
95         bool exists;         // 0. Whether the bid exists
96         uint id;             // 1. The ID of the bid.
97         uint timestamp;      // 2. The timestamp of when the bid was made
98         address bidder;      // 3. The address of the bidder
99         uint amount;         // 4. The amount of ETH in the bid
100         string email;        // 5. The bidder's email address
101         string organisation; // 6. The bidder's organisation
102     }
103 
104     event BidMade(uint indexed id, address indexed bidder, uint indexed amount);
105     event Reclaimed(address indexed bidder, uint indexed amount);
106     event Donated(uint indexed amount);
107 
108     Bid[] public bids; // Array of all bids
109     uint[] public bidIds; // Array of all bid IDs
110 
111     // Constants which govern the bid prices and auction duration
112     uint private constant MIN_BID = 1 ether;
113     uint private constant BID_STEP = 0.01 ether;
114     uint private constant INITIAL_BIDS = 4;
115 
116     uint private constant EXPIRY_DAYS_BEFORE = 7 days;
117     uint private constant EXPIRY_DAYS_AFTER = 3 days;
118 
119     // For development only
120     //uint private constant EXPIRY_DAYS_BEFORE = 10 minutes;
121     //uint private constant EXPIRY_DAYS_AFTER = 10 minutes;
122 
123     // SHA256 checksum of https://github.com/weijiekoh/hireme/blob/master/AUTHOR.asc
124     // See the bottom of this file for the contents of AUTHOR.asc
125     string public constant AUTHORSIGHASH = "8c8b82a2d83a33cb0f45f5f6b22b45c1955f08fc54e7ab4d9e76fb76843c4918";
126 
127     // Whether the donate() function has been called
128     bool public donated = false;
129 
130     // Whether the manuallyEndAuction() function has been called
131     bool public manuallyEnded = false;
132 
133     // Tracks the total amount of ETH currently residing in the contract
134     // balance per address.
135     mapping (address => uint) public addressBalance;
136 
137     // The Internet Archive's ETH donation address
138     address public charityAddress = 0x635599b0ab4b5c6B1392e0a2D1d69cF7d1ddDF02;
139 
140     // Only the contract owner may end this contract, and may do so only if
141     // there are 0 bids.
142     function manuallyEndAuction () public onlyOwner {
143         require(manuallyEnded == false);
144         require(bids.length == 0);
145 
146         manuallyEnded = true;
147     }
148 
149     // Place a bid.
150     function bid(string _email, string _organisation) public payable {
151         address _bidder = msg.sender;
152         uint _amount = msg.value;
153         uint _id = bids.length;
154 
155         // The auction must not be over
156         require(!hasExpired() && !manuallyEnded);
157 
158         // The bidder must be neither the contract owner nor the charity
159         // donation address
160         require(_bidder != owner && _bidder != charityAddress);
161 
162         // The bidder address, email, and organisation must valid
163         require(_bidder != address(0));
164         require(bytes(_email).length > 0);
165         require(bytes(_organisation).length > 0);
166 
167         // Make sure the amount bid is more than the rolling minimum bid
168         require(_amount >= calcCurrentMinBid());
169 
170         // Update the state with the new bid
171         bids.push(Bid(true, _id, now, _bidder, _amount, _email, _organisation));
172         bidIds.push(_id);
173 
174         // Add to, not replace, the state variable which tracks the total
175         // amount paid per address, because a bidder may make multiple bids
176         addressBalance[_bidder] = SafeMath.add(addressBalance[_bidder], _amount);
177 
178         // Emit the event
179         BidMade(_id, _bidder, _amount);
180     }
181 
182     function reclaim () public {
183         address _caller = msg.sender;
184         uint _amount = calcAmtReclaimable(_caller);
185 
186         // There must be at least 2 bids. Note that if there is only 1 bid and
187         // that bid is the winning bid, it cannot be reclaimed.
188         require(bids.length >= 2);
189 
190         // The auction must not have been manually ended
191         require(!manuallyEnded);
192 
193         // Make sure the amount to reclaim is more than 0
194         require(_amount > 0);
195 
196         // Subtract the amount to be reclaimed from the state variable which
197         // tracks the total amount paid per address
198         uint _newTotal = SafeMath.sub(addressBalance[_caller], _amount);
199 
200         // The amount must not be negative, or the contract is buggy
201         assert(_newTotal >= 0);
202 
203         // Update the state to prevent double-spending
204         addressBalance[_caller] = _newTotal;
205 
206         // Make the transfer
207         _caller.transfer(_amount);
208 
209         // Emit the event
210         Reclaimed(_caller, _amount);
211     }
212 
213     function donate () public {
214         // donate() can only be called once
215         assert(donated == false);
216 
217         // Only the contract owner or the charity address may send the funds to
218         // charityAddress
219         require(msg.sender == owner || msg.sender == charityAddress);
220 
221         // The auction must be over
222         require(hasExpired());
223 
224         // If the auction has been manually ended at this point, the contract
225         // is buggy
226         assert(!manuallyEnded);
227 
228         // There must be at least 1 bid, or the contract is buggy
229         assert(bids.length > 0);
230 
231         // Calculate the amount to donate
232         uint _amount;
233         if (bids.length == 1) {
234             // If there is only 1 bid, transfer that amount
235             _amount = bids[0].amount;
236         } else {
237             // If there is more than 1 bid, transfer the second highest bid
238             _amount = bids[SafeMath.sub(bids.length, 2)].amount;
239         }
240 
241         // The amount to be donated must be more than 0, or this contract is
242         // buggy
243         assert(_amount > 0);
244 
245         // Prevent double-donating
246         donated = true;
247 
248         // Transfer the winning bid amount to charity
249         charityAddress.transfer(_amount);
250         Donated(_amount);
251     }
252 
253     function calcCurrentMinBid () public view returns (uint) {
254         if (bids.length == 0) {
255             return MIN_BID;
256         } else {
257             uint _lastBidId = SafeMath.sub(bids.length, 1);
258             uint _lastBidAmt = bids[_lastBidId].amount;
259             return SafeMath.add(_lastBidAmt, BID_STEP);
260         }
261     }
262 
263     function calcAmtReclaimable (address _bidder) public view returns (uint) {
264         // This function calculates the amount that _bidder can get back.
265 
266         // A. if the auction is over, and _bidder is the winner, they should
267         // get back the total amount bid minus the second highest bid.
268 
269         // B. if the auction is not over, and _bidder is not the current
270         // winner, they should get back the total they had bid
271 
272         // C. if the auction is ongoing, and _bidder is the current winner,
273         // they should get back the total amount they had bid minus the top
274         // bid.
275 
276         // D. if the auction is ongoing, and _bidder is not the current winner,
277         // they should get back the total amount they had bid.
278 
279         uint _totalAmt = addressBalance[_bidder];
280 
281         if (bids.length == 0) {
282             return 0;
283         }
284 
285         if (bids[SafeMath.sub(bids.length, 1)].bidder == _bidder) {
286             // If the bidder is the current winner
287             if (hasExpired()) { // scenario A
288                 uint _secondPrice = bids[SafeMath.sub(bids.length, 2)].amount;
289                 return SafeMath.sub(_totalAmt, _secondPrice);
290 
291             } else { // scenario C
292                 uint _highestPrice = bids[SafeMath.sub(bids.length, 1)].amount;
293                 return SafeMath.sub(_totalAmt, _highestPrice);
294             }
295 
296         } else { // scenarios B and D
297             // If the bidder is not the current winner
298             return _totalAmt;
299         }
300     }
301 
302     function getBidIds () public view returns (uint[]) {
303         return bidIds;
304     }
305 
306     // Calcuate the timestamp after which the auction will expire
307     function expiryTimestamp () public view returns (uint) {
308         uint _numBids = bids.length;
309 
310         // There is no expiry if there are no bids
311         require(_numBids > 0);
312 
313         // The timestamp of the most recent bid
314         uint _lastBidTimestamp = bids[SafeMath.sub(_numBids, 1)].timestamp;
315 
316         if (_numBids <= INITIAL_BIDS) {
317             return SafeMath.add(_lastBidTimestamp, EXPIRY_DAYS_BEFORE);
318         } else {
319             return SafeMath.add(_lastBidTimestamp, EXPIRY_DAYS_AFTER);
320         }
321     }
322 
323     function hasExpired () public view returns (bool) {
324         uint _numBids = bids.length;
325 
326         // The auction cannot expire if there are no bids
327         if (_numBids == 0) {
328             return false;
329         } else {
330             // Compare with the current time
331             return now >= this.expiryTimestamp();
332         }
333     }
334 }
335 
336 
337 // Contents of AUTHOR.asc and AUTHOR (remove the backslashes which preface each
338 // line)
339 
340 // AUTHOR.asc:
341 //-----BEGIN PGP SIGNATURE-----
342 //
343 //iQIzBAABCAAdBQJak6eBFhxjb250YWN0QGtvaHdlaWppZS5jb20ACgkQkNtDYXzM
344 //FjKytA/+JF75jH+d/9nEitJKRcsrFgadVjMwNjUt1B7IvoZJqpHj9BSHtKhsVEI5
345 //iME24rgbr3YRXLi7GbQS+Ovyf3Ks7BHCA/t12PWOVm9zRBEswojZIg1UjTqtYboS
346 //0xrnrY8A71g1RX/jN4uCQ9FohRMAPzTTV9Gt6XDpB9Uzk0HBkUOpVHPnqxSerzbp
347 //fSwTCzLgcsTKUJYfeOQMuSwTTXc/btJss82WQpK76xdi5+4hp3tjyZZuY7ruj60N
348 //g9f9pHafsWRujMhmX0G8btjK/7/cJL/KbFFafb3sA7Xes0uoUbs+pQXTvuMBx2g5
349 //1/BH63aHXdZC2/767JyR18gZN6PnwsZt7i8CowvDcGMni5f0la4O53HCZEGaHYFf
350 //IKnJX4LhEJEezcflqSgxm1y7hlUFqC1T7janL0s4rCxoW7iPgNlii62vSzg0TTwH
351 //9L6v8aYwWgAwfma2o3XWMCjA/K/BIfWd2w+1ex/gvTVCefOxz1zEPdjhWh89fopb
352 //ydxV4fllXLXoB2wmv305E4eryq4lX40w9WxO7Dxq3yU+fmK8BaXLsjUf4fT9AU1m
353 //VEo3ndjFXkSELwqTQalxod41j4rYxS6SyxOj6R3/3ejbJIL0kzwKuDlZIkj8Xsfx
354 //o2b+QtKANMwC2KRZQBnNdnF2XVOCEFW1XZykWPW6FR1iYS6WEJ0=
355 //=J3JJ
356 //-----END PGP SIGNATURE-----
357 
358 // AUTHOR:
359 //Koh Wei Jie <contact@kohweijie.com>