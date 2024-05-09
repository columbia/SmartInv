1 pragma solidity =0.5.11;
2 
3 // * Gods Unchained Raffle Token Exchange
4 //
5 // * Version 1.0
6 //
7 // * A dedicated contract for listing (selling) and buying raffle tokens.
8 //
9 // * https://gu.cards
10 
11 contract ERC20Interface {
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 }
14 
15 contract IERC20Interface {
16     function allowance(address owner, address spender) external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18 }
19 
20 contract RaffleToken is ERC20Interface, IERC20Interface {}
21 
22 /**
23  * @dev Wrappers over Solidity's arithmetic operations with added overflow
24  * checks.
25  *
26  * Arithmetic operations in Solidity wrap on overflow. This can easily result
27  * in bugs, because programmers usually assume that an overflow raises an
28  * error, which is the standard behavior in high level programming languages.
29  * `SafeMath` restores this intuition by reverting the transaction when an
30  * operation overflows.
31  *
32  * Using this library instead of the unchecked operations eliminates an entire
33  * class of bugs, so it's recommended to use it always.
34  */
35 library SafeMath {
36     /**
37      * @dev Returns the addition of two unsigned integers, reverting on
38      * overflow.
39      *
40      * Counterpart to Solidity's `+` operator.
41      *
42      * Requirements:
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a, "SafeMath: subtraction overflow");
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Solidity only automatically asserts when dividing by 0
104         require(b > 0, "SafeMath: division by zero");
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b != 0, "SafeMath: modulo by zero");
124         return a % b;
125     }
126 }
127 
128 contract RaffleTokenExchange {
129     using SafeMath for uint256;
130 
131     //////// V A R I A B L E S
132     //
133     // The raffle token contract
134     //
135     RaffleToken constant public raffleContract = RaffleToken(0x0C8cDC16973E88FAb31DD0FCB844DdF0e1056dE2);
136     //
137     // In case the exchange is paused.
138     //
139     bool public paused;
140     //
141     // Standard contract ownership.
142     //
143     address payable public owner;
144     //
145     // Next id for the next listing
146     //
147     uint256 public nextListingId;
148     //
149     // All raffle token listings mapped by id
150     //
151     mapping (uint256 => Listing) public listingsById;
152     //
153     // All purchases
154     //
155     mapping (uint256 => Purchase) public purchasesById;
156     //
157     // Next id for the next purche
158     //
159     uint256 public nextPurchaseId;
160 
161     //////// S T R U C T S
162     //
163     //  A listing of raffle tokens
164     //
165     struct Listing {
166         //
167         // price per token (in wei).
168         //
169         uint256 pricePerToken;
170         //
171         //
172         // How many tokens? (Original Amount)
173         //
174         uint256 initialAmount;
175         //
176         // How many tokens left? (Maybe altered due to partial sales)
177         //
178         uint256 amountLeft;
179         //
180         // Listed by whom?
181         //
182         address payable seller;
183         //
184         // Active/Inactive listing?
185         //
186         bool active;
187     }
188     //
189     //  A purchase of raffle tokens
190     //
191     struct Purchase {
192         //
193         // How many tokens?
194         //
195         uint256 totalAmount;
196         //
197         // total price payed
198         //
199         uint256 totalAmountPayed;
200         //
201         // When did the purchase happen?
202         //
203         uint256 timestamp;
204     }
205 
206     //////// EVENTS
207     //
208     //
209     //
210     event Listed(uint256 id, uint256 pricePerToken, uint256 initialAmount, address seller);
211     event Canceled(uint256 id);
212     event Purchased(uint256 id, uint256 totalAmount, uint256 totalAmountPayed, uint256 timestamp);
213 
214     //////// M O D I F I E R S
215     //
216     // Invokable only by contract owner.
217     //
218     modifier onlyContractOwner {
219         require(msg.sender == owner, "Function called by non-owner.");
220         _;
221     }
222     //
223     // Invokable only if exchange is not paused.
224     //
225     modifier onlyUnpaused {
226         require(paused == false, "Exchange is paused.");
227         _;
228     }
229 
230     //////// C O N S T R U C T O R
231     //
232     constructor() public {
233         owner = msg.sender;
234         nextListingId = 916;
235         nextPurchaseId = 344;
236     }
237 
238     //////// F U N C T I O N S
239     //
240     // buyRaffle
241     //
242     function buyRaffle(uint256[] calldata amounts, uint256[] calldata listingIds) payable external onlyUnpaused {
243         require(amounts.length == listingIds.length, "You have to provide amounts for every single listing!");
244         uint256 totalAmount;
245         uint256 totalAmountPayed;
246         for (uint256 i = 0; i < listingIds.length; i++) {
247             uint256 id = listingIds[i];
248             uint256 amount = amounts[i];
249             Listing storage listing = listingsById[id];
250             require(listing.active, "Listing is not active anymore!");
251             listing.amountLeft = listing.amountLeft.sub(amount);
252             require(listing.amountLeft >= 0, "Amount left needs to be higher than 0.");
253             if(listing.amountLeft == 0) { listing.active = false; }
254             uint256 amountToPay = listing.pricePerToken * amount;
255             listing.seller.transfer(amountToPay);
256             totalAmountPayed = totalAmountPayed.add(amountToPay);
257             totalAmount = totalAmount.add(amount);
258             require(raffleContract.transferFrom(listing.seller, msg.sender, amount), 'Token transfer failed!');
259         }
260         require(totalAmountPayed <= msg.value, 'Overpayed!');
261         uint256 id = nextPurchaseId++;
262         Purchase storage purchase = purchasesById[id];
263         purchase.totalAmount = totalAmount;
264         purchase.totalAmountPayed = totalAmountPayed;
265         purchase.timestamp = now;
266         emit Purchased(id, totalAmount, totalAmountPayed, now);
267     }
268     //
269     // Add listing
270     //
271     function addListing(uint256 initialAmount, uint256 pricePerToken) external onlyUnpaused {
272         require(raffleContract.balanceOf(msg.sender) >= initialAmount, "Amount to sell is higher than balance!");
273         require(raffleContract.allowance(msg.sender, address(this)) >= initialAmount, "Allowance is to small (increase allowance)!");
274         uint256 id = nextListingId++;
275         Listing storage listing = listingsById[id];
276         listing.initialAmount = initialAmount;
277         listing.amountLeft = initialAmount;
278         listing.pricePerToken = pricePerToken;
279         listing.seller = msg.sender;
280         listing.active = true;
281         emit Listed(id, listing.pricePerToken, listing.initialAmount, listing.seller);
282     }
283     //
284     // Cancel listing
285     //
286     function cancelListing(uint256 id) external {
287         Listing storage listing = listingsById[id];
288         require(listing.active, "This listing was turned inactive already!");
289         require(listing.seller == msg.sender || owner == msg.sender, "Only the listing owner or the contract owner can cancel the listing!");
290         listing.active = false;
291         emit Canceled(id);
292     }
293     //
294     // Set paused
295     //
296     function setPaused(bool value) external onlyContractOwner {
297         paused = value;
298     }
299     //
300     // Funds withdrawal to cover operational costs
301     //
302     function withdrawFunds(uint256 withdrawAmount) external onlyContractOwner {
303         owner.transfer(withdrawAmount);
304     }
305     //
306     // Contract may be destroyed only when there is nothing else going on. 
307     // All funds are transferred to contract owner.
308     //
309     function kill() external onlyContractOwner {
310         selfdestruct(owner);
311     }
312 }