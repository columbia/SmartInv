1 pragma solidity ^0.4.18;
2 
3 
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
91 
92 contract CaiShen is Ownable {
93     struct Gift {
94         bool exists;        // 0 Only true if this exists
95         uint giftId;        // 1 The gift ID
96         address giver;      // 2 The address of the giver
97         address recipient;  // 3 The address of the recipient
98         uint expiry;        // 4 The expiry datetime of the timelock as a
99                             //   Unix timestamp
100         uint amount;        // 5 The amount of ETH
101         bool redeemed;      // 6 Whether the funds have already been redeemed
102         string giverName;   // 7 The giver's name
103         string message;     // 8 A message from the giver to the recipient
104         uint timestamp;     // 9 The timestamp of when the gift was given
105     }
106 
107     // Total fees gathered since the start of the contract or the last time
108     // fees were collected, whichever is latest
109     uint public feesGathered;
110 
111     // Each gift has a unique ID. If you increment this value, you will get
112     // an unused gift ID.
113     uint public nextGiftId;
114 
115     // Maps each recipient address to a list of giftIDs of Gifts they have
116     // received.
117     mapping (address => uint[]) public recipientToGiftIds;
118 
119     // Maps each gift ID to its associated gift.
120     mapping (uint => Gift) public giftIdToGift;
121 
122     event Constructed (address indexed by, uint indexed amount);
123 
124     event CollectedAllFees (address indexed by, uint indexed amount);
125 
126     event DirectlyDeposited(address indexed from, uint indexed amount);
127 
128     event Gave (uint indexed giftId,
129                 address indexed giver,
130                 address indexed recipient,
131                 uint amount, uint expiry);
132 
133     event Redeemed (uint indexed giftId,
134                     address indexed giver,
135                     address indexed recipient,
136                     uint amount);
137 
138     // Constructor
139     function CaiShen() public payable {
140         Constructed(msg.sender, msg.value);
141     }
142 
143     // Fallback function which allows this contract to receive funds.
144     function () public payable {
145         // Sending ETH directly to this contract does nothing except log an
146         // event.
147         DirectlyDeposited(msg.sender, msg.value);
148     }
149 
150     //// Getter functions:
151 
152     function getGiftIdsByRecipient (address recipient) 
153     public view returns (uint[]) {
154         return recipientToGiftIds[recipient];
155     }
156 
157     //// Contract functions:
158 
159     // Call this function while sending ETH to give a gift.
160     // @recipient: the recipient's address
161     // @expiry: the Unix timestamp of the expiry datetime.
162     // @giverName: the name of the giver
163     // @message: a personal message
164     // Tested in test/test_give.js and test/TestGive.sol
165     function give (address recipient, uint expiry, string giverName, string message)
166     public payable returns (uint) {
167         address giver = msg.sender;
168 
169         // Validate the giver address
170         assert(giver != address(0));
171 
172         // The gift must be a positive amount of ETH
173         uint amount = msg.value;
174         require(amount > 0);
175         
176         // The expiry datetime must be in the future.
177         // The possible drift is only 12 minutes.
178         // See: https://consensys.github.io/smart-contract-best-practices/recommendations/#timestamp-dependence
179         require(expiry > now);
180 
181         // The giver and the recipient must be different addresses
182         require(giver != recipient);
183 
184         // The recipient must be a valid address
185         require(recipient != address(0));
186 
187         // Make sure nextGiftId is 0 or positive, or this contract is buggy
188         assert(nextGiftId >= 0);
189 
190         // Calculate the contract owner's fee
191         uint feeTaken = fee(amount);
192         assert(feeTaken >= 0);
193 
194         // Increment feesGathered
195         feesGathered = SafeMath.add(feesGathered, feeTaken);
196 
197         // Shave off the fee from the amount
198         uint amtGiven = SafeMath.sub(amount, feeTaken);
199         assert(amtGiven > 0);
200 
201         // If a gift with this new gift ID already exists, this contract is buggy.
202         assert(giftIdToGift[nextGiftId].exists == false);
203 
204         // Update the mappings
205         recipientToGiftIds[recipient].push(nextGiftId);
206         giftIdToGift[nextGiftId] = 
207             Gift(true, nextGiftId, giver, recipient, expiry, 
208             amtGiven, false, giverName, message, now);
209 
210         uint giftId = nextGiftId;
211 
212         // Increment nextGiftId
213         nextGiftId = SafeMath.add(giftId, 1);
214 
215         // If a gift with this new gift ID already exists, this contract is buggy.
216         assert(giftIdToGift[nextGiftId].exists == false);
217 
218         // Log the event
219         Gave(giftId, giver, recipient, amount, expiry);
220 
221         return giftId;
222     }
223 
224     // Call this function to redeem a gift of ETH.
225     // Tested in test/test_redeem.js
226     function redeem (uint giftId) public {
227         // The giftID should be 0 or positive
228         require(giftId >= 0);
229 
230         // The gift must exist and must not have already been redeemed
231         require(isValidGift(giftIdToGift[giftId]));
232 
233         // The recipient must be the caller of this function
234         address recipient = giftIdToGift[giftId].recipient;
235         require(recipient == msg.sender);
236 
237         // The current datetime must be the same or after the expiry timestamp
238         require(now >= giftIdToGift[giftId].expiry);
239 
240         //// If the following assert statements are triggered, this contract is
241         //// buggy.
242 
243         // The amount must be positive because this is required in give()
244         uint amount = giftIdToGift[giftId].amount;
245         assert(amount > 0);
246 
247         // The giver must not be the recipient because this was asserted in give()
248         address giver = giftIdToGift[giftId].giver;
249         assert(giver != recipient);
250 
251         // Make sure the giver is valid because this was asserted in give();
252         assert(giver != address(0));
253 
254         // Update the gift to mark it as redeemed, so that the funds cannot be
255         // double-spent
256         giftIdToGift[giftId].redeemed = true;
257 
258         // Transfer the funds
259         recipient.transfer(amount);
260 
261         // Log the event
262         Redeemed(giftId, giftIdToGift[giftId].giver, recipient, amount);
263     }
264 
265     // Calculate the contract owner's fee
266     // Tested in test/test_fee.js
267     function fee (uint amount) public pure returns (uint) {
268         if (amount <= 0.01 ether) {
269             return 0;
270         } else if (amount > 0.01 ether) {
271             return SafeMath.div(amount, 100);
272         }
273     }
274 
275     // Transfer the fees collected thus far to the contract owner.
276     // Only the contract owner may invoke this function.
277     // Tested in test/test_collect_fees.js
278     function collectAllFees () public onlyOwner {
279         // Store the fee amount in a temporary variable
280         uint amount = feesGathered;
281 
282         // Make sure that the amount is positive
283         require(amount > 0);
284 
285         // Set the feesGathered state variable to 0
286         feesGathered = 0;
287 
288         // Make the transfer
289         owner.transfer(amount);
290 
291         CollectedAllFees(owner, amount);
292     }
293 
294     // Returns true only if the gift exists and has not already been
295     // redeemed
296     function isValidGift(Gift gift) private pure returns (bool) {
297         return gift.exists == true && gift.redeemed == false;
298     }
299 }