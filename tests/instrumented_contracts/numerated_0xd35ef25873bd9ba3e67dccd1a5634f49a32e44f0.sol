1 // OwnTheDay Source code
2 // copyright 2018 xeroblood <https://owntheday.io>
3 
4 pragma solidity 0.4.19;
5 
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55 * @title Ownable
56 * @dev The Ownable contract has an owner address, and provides basic authorization control
57 * functions, this simplifies the implementation of "user permissions".
58 */
59 contract Ownable {
60     address public owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66     * account.
67     */
68     function Ownable() public {
69         owner = msg.sender;
70     }
71 
72     /**
73     * @dev Throws if called by any account other than the owner.
74     */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81     * @dev Allows the current owner to transfer control of the contract to a newOwner.
82     * @param newOwner The address to transfer ownership to.
83     */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90 }
91 
92 
93 /**
94 * @title Pausable
95 * @dev Base contract which allows children to implement an emergency stop mechanism.
96 */
97 contract Pausable is Ownable {
98     event Pause();
99     event Unpause();
100 
101     bool public paused = false;
102 
103     /**
104     * @dev Modifier to make a function callable only when the contract is not paused.
105     */
106     modifier whenNotPaused() {
107         require(!paused);
108         _;
109     }
110 
111     /**
112     * @dev Modifier to make a function callable only when the contract is paused.
113     */
114     modifier whenPaused() {
115         require(paused);
116         _;
117     }
118 
119     /**
120     * @dev called by the owner to pause, triggers stopped state
121     */
122     function pause() public onlyOwner whenNotPaused {
123         paused = true;
124         Pause();
125     }
126 
127     /**
128     * @dev called by the owner to unpause, returns to normal state
129     */
130     function unpause() public onlyOwner whenPaused {
131         paused = false;
132         Unpause();
133     }
134 }
135 
136 
137 /**
138 * @title Helps contracts guard agains reentrancy attacks.
139 * @author Remco Bloemen <remco@2π.com>
140 * @notice If you mark a function `nonReentrant`, you should also
141 * mark it `external`.
142 */
143 contract ReentrancyGuard {
144 
145     /**
146     * @dev We use a single lock for the whole contract.
147     */
148     bool private reentrancyLock = false;
149 
150     /**
151     * @dev Prevents a contract from calling itself, directly or indirectly.
152     * @notice If you mark a function `nonReentrant`, you should also
153     * mark it `external`. Calling one nonReentrant function from
154     * another is not supported. Instead, you can implement a
155     * `private` function doing the actual work, and a `external`
156     * wrapper marked as `nonReentrant`.
157     */
158     modifier nonReentrant() {
159         require(!reentrancyLock);
160         reentrancyLock = true;
161         _;
162         reentrancyLock = false;
163     }
164 
165 }
166 
167 
168 /// @title Own the Day!
169 /// @author xeroblood (https://owntheday.io)
170 contract OwnTheDay is Pausable, ReentrancyGuard {
171     using SafeMath for uint256;
172 
173     event DayClaimed(address buyer, address seller, uint16 dayIndex, uint256 newPrice);
174 
175     /// @dev A mapping from Day Index to Current Price.
176     ///  Initial Price set at 1 finney (1/1000th of an ether).
177     mapping (uint16 => uint256) public dayIndexToPrice;
178 
179     /// @dev A mapping from Day Index to the address owner. Days with
180     ///  no valid owner address are assigned to contract owner.
181     mapping (uint16 => address) public dayIndexToOwner;
182 
183     /// @dev A mapping from Account Address to Nickname.
184     mapping (address => string) public ownerAddressToName;
185 
186     /// @dev Calculate the Final Sale Price after the Owner-Cut has been calculated
187     function calculateOwnerCut(uint256 price) public pure returns (uint256) {
188         uint8 percentCut = 5;
189         if (price > 5000 finney) {
190             percentCut = 2;
191         } else if (price > 500 finney) {
192             percentCut = 3;
193         } else if (price > 250 finney) {
194             percentCut = 4;
195         }
196         return price.mul(percentCut).div(100);
197     }
198 
199     /// @dev Calculate the Price Increase based on the current Purchase Price
200     function calculatePriceIncrease(uint256 price) public pure returns (uint256) {
201         uint8 percentIncrease = 100;
202         if (price > 5000 finney) {
203             percentIncrease = 15;
204         } else if (price > 2500 finney) {
205             percentIncrease = 18;
206         } else if (price > 500 finney) {
207             percentIncrease = 26;
208         } else if (price > 250 finney) {
209             percentIncrease = 36;
210         }
211         return price.mul(percentIncrease).div(100);
212     }
213 
214     /// @dev Gets the Current (or Default) Price of a Day
215     function getPriceByDayIndex(uint16 dayIndex) public view returns (uint256) {
216         require(dayIndex >= 0 && dayIndex < 366);
217         uint256 price = dayIndexToPrice[dayIndex];
218         if (price == 0) { price = 1 finney; }
219         return price;
220     }
221 
222     /// @dev Sets the Nickname for an Account Address
223     function setAccountNickname(string nickname) public whenNotPaused {
224         require(msg.sender != address(0));
225         require(bytes(nickname).length > 0);
226         ownerAddressToName[msg.sender] = nickname;
227     }
228 
229     /// @dev Claim a Day for Your Very Own!
230     /// The Purchase Price is Paid to the Previous Owner
231     function claimDay(uint16 dayIndex) public nonReentrant whenNotPaused payable {
232         require(msg.sender != address(0));
233         require(dayIndex >= 0 && dayIndex < 366);
234 
235         // Prevent buying from self
236         address buyer = msg.sender;
237         address seller = dayIndexToOwner[dayIndex];
238         require(buyer != seller);
239 
240         // Get Amount Paid
241         uint256 amountPaid = msg.value;
242 
243         // Get Current Purchase Price from Index and ensure enough was Paid
244         uint256 purchasePrice = dayIndexToPrice[dayIndex];
245         if (purchasePrice == 0) {
246             purchasePrice = 1 finney; // == 0.001 ether or 1000000000000000 wei
247         }
248         require(amountPaid >= purchasePrice);
249 
250         // If too much was paid, track the change to be returned
251         uint256 changeToReturn = 0;
252         if (amountPaid > purchasePrice) {
253             changeToReturn = amountPaid.sub(purchasePrice);
254             amountPaid -= changeToReturn;
255         }
256 
257         // Calculate New Purchase Price and update storage
258         uint256 priceIncrease = calculatePriceIncrease(purchasePrice);
259         uint256 newPurchasePrice = purchasePrice.add(priceIncrease);
260         dayIndexToPrice[dayIndex] = newPurchasePrice;
261 
262         // Calculate Sale Price after Owner-Cut and update Owner Balance
263         uint256 ownerCut = calculateOwnerCut(amountPaid);
264         uint256 salePrice = amountPaid.sub(ownerCut);
265 
266         // Assign Day to New Owner
267         dayIndexToOwner[dayIndex] = buyer;
268 
269         // Fire Claim Event
270         DayClaimed(buyer, seller, dayIndex, newPurchasePrice);
271 
272         // Transfer Funds (Initial sales are made to owner)
273         if (seller != address(0)) {
274             owner.transfer(ownerCut);
275             seller.transfer(salePrice);
276         } else {
277             owner.transfer(salePrice.add(ownerCut));
278         }
279         if (changeToReturn > 0) {
280             buyer.transfer(changeToReturn);
281         }
282     }
283 }