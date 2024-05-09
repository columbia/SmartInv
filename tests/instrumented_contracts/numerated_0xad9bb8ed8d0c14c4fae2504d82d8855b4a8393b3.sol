1 // File contracts/@openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File contracts/@openzeppelin/contracts/utils/Counters.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @title Counters
36  * @author Matt Condon (@shrugs)
37  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
38  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
39  *
40  * Include with `using Counters for Counters.Counter;`
41  */
42 library Counters {
43     struct Counter {
44         // This variable should never be directly accessed by users of the library: interactions must be restricted to
45         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
46         // this feature: see https://github.com/ethereum/solidity/issues/4637
47         uint256 _value; // default: 0
48     }
49 
50     function current(Counter storage counter) internal view returns (uint256) {
51         return counter._value;
52     }
53 
54     function increment(Counter storage counter) internal {
55         unchecked {
56             counter._value += 1;
57         }
58     }
59 
60     function decrement(Counter storage counter) internal {
61         uint256 value = counter._value;
62         require(value > 0, "Counter: decrement overflow");
63         unchecked {
64             counter._value = value - 1;
65         }
66     }
67 }
68 
69 
70 // File contracts/@openzeppelin/contracts/access/Ownable.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Contract module which provides a basic access control mechanism, where
78  * there is an account (an owner) that can be granted exclusive access to
79  * specific functions.
80  *
81  * By default, the owner account will be the one that deploys the contract. This
82  * can later be changed with {transferOwnership}.
83  *
84  * This module is used through inheritance. It will make available the modifier
85  * `onlyOwner`, which can be applied to your functions to restrict their use to
86  * the owner.
87  */
88 abstract contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94      * @dev Initializes the contract setting the deployer as the initial owner.
95      */
96     constructor () {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101 
102     /**
103      * @dev Returns the address of the current owner.
104      */
105     function owner() public view virtual returns (address) {
106         return _owner;
107     }
108 
109     /**
110      * @dev Throws if called by any account other than the owner.
111      */
112     modifier onlyOwner() {
113         require(owner() == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     /**
118      * @dev Leaves the contract without owner. It will not be possible to call
119      * `onlyOwner` functions anymore. Can only be called by the current owner.
120      *
121      * NOTE: Renouncing ownership will leave the contract without an owner,
122      * thereby removing any functionality that is only available to the owner.
123      */
124     function renounceOwnership() public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, address(0));
126         _owner = address(0);
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Can only be called by the current owner.
132      */
133     function transferOwnership(address newOwner) public virtual onlyOwner {
134         require(newOwner != address(0), "Ownable: new owner is the zero address");
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 
141 // File contracts/final.sol
142 
143 //SPDX-License-Identifier: MIT
144 pragma solidity ^0.8.0;
145 
146 interface IERC20 {
147 
148     function totalSupply() external view returns (uint256);
149 
150     /**
151         * @dev Returns the amount of tokens owned by `account`.
152         */
153     function balanceOf(address account) external view returns (uint256);
154 
155     /**
156         * @dev Moves `amount` tokens from the caller's account to `recipient`.
157         *
158         * Returns a boolean value indicating whether the operation succeeded.
159         *
160         * Emits a {Transfer} event.
161         */
162     function transfer(address recipient, uint256 amount) external returns (bool);
163 
164     /**
165         * @dev Returns the remaining number of tokens that `spender` will be
166         * allowed to spend on behalf of `owner` through {transferFrom}. This is
167         * zero by default.
168         *
169         * This value changes when {approve} or {transferFrom} are called.
170         */
171     function allowance(address owner, address spender) external view returns (uint256);
172 
173     /**
174         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
175         *
176         * Returns a boolean value indicating whether the operation succeeded.
177         *
178         * IMPORTANT: Beware that changing an allowance with this method brings the risk
179         * that someone may use both the old and the new allowance by unfortunate
180         * transaction ordering. One possible solution to mitigate this race
181         * condition is to first reduce the spender's allowance to 0 and set the
182         * desired value afterwards:
183         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184         *
185         * Emits an {Approval} event.
186         */
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     /**
190         * @dev Moves `amount` tokens from `sender` to `recipient` using the
191         * allowance mechanism. `amount` is then deducted from the caller's
192         * allowance.
193         *
194         * Returns a boolean value indicating whether the operation succeeded.
195         *
196         * Emits a {Transfer} event.
197         */
198     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
199 
200     /**
201         * @dev Emitted when `value` tokens are moved from one account (`from`) to
202         * another (`to`).
203         *
204         * Note that `value` may be zero.
205         */
206     event Transfer(address indexed from, address indexed to, uint256 value);
207 
208     /**
209         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
210         * a call to {approve}. `value` is the new allowance.
211         */
212     event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 interface IShiryoinuPack {
216     function mint(address _to, uint256 _amount) external;
217 }
218 
219 contract ShiryoinuPackERC20 is Ownable{
220     using SafeMath for uint256;
221 
222     modifier onlyClevel() {
223         require(msg.sender == walletA || msg.sender == walletB || msg.sender == owner());
224     _;
225     }
226 
227     address walletA;
228     address walletB;
229     uint256 walletBPercentage = 15;
230 
231     IERC20 public founderToken;
232     IShiryoinuPack public founderPack;
233     IShiryoinuPack public normalPack;
234     uint256 public minimumFounderAmount = 25000000000000*10**9;  // founder token has 9 decimals!!
235 
236     mapping(uint256=>uint256) public mintAmountToPrice;
237 
238     constructor(IERC20 _founderToken, IShiryoinuPack _founderPack, IShiryoinuPack _normalPack, address _walletA, address _walletB) {
239         walletA = _walletA;
240         walletB = _walletB;
241         founderToken = _founderToken;
242 
243         founderPack = _founderPack;
244         normalPack = _normalPack;
245 
246         mintAmountToPrice[1]=  0.05 ether;
247         mintAmountToPrice[5]=  0.25 ether;
248         mintAmountToPrice[10]= 0.45 ether;
249         mintAmountToPrice[20]= 0.85 ether;
250 
251     }
252 
253     function mint_pack(uint256 _amount) public payable {
254         require(_amount>0 &&  mintAmountToPrice[_amount]>0, "Invalid amount to mint.");
255         require(msg.value>0 && msg.value==mintAmountToPrice[_amount] , "Invalid value.");
256 
257         bool founder = founderToken.balanceOf(msg.sender)>=minimumFounderAmount;
258 
259         if (founder){
260             // mint founder
261             founderPack.mint(msg.sender, _amount);
262         }else{
263             // mint normal
264             normalPack.mint(msg.sender, _amount);
265         }
266     }
267 
268     // admin and clevel functions
269     function setMinimumFounderTokenAmount(uint256 _amount) public onlyOwner {
270              minimumFounderAmount = _amount;
271     }
272 
273     function setMintPrice(uint256 _amount, uint256 _price) public onlyOwner {
274              mintAmountToPrice[_amount]=_price;
275     }
276 
277     function withdraw_all() public onlyClevel {
278         require (address(this).balance > 0);
279         uint256 amountB = SafeMath.div(address(this).balance,100).mul(walletBPercentage);
280         uint256 amountA = address(this).balance.sub(amountB);
281         payable(walletA).transfer(amountA);
282         payable(walletB).transfer(amountB);
283     }
284 
285     function setWalletA(address _walletA) public {
286         require (msg.sender == walletA, "Who are you?");
287         require (_walletA != address(0x0), "Invalid wallet");
288         walletA = _walletA;
289     }
290 
291     function setWalletB(address _walletB) public {
292         require (msg.sender == walletB, "Who are you?");
293         require (_walletB != address(0x0), "Invalid wallet.");
294         walletB = _walletB;
295     }
296 
297     function setWalletBPercentage(uint256 _percentage) public onlyOwner{
298         require (_percentage>walletBPercentage && _percentage<=100, "Invalid new slice.");
299         walletBPercentage = _percentage;
300     }
301 
302 }
303 
304 
305 library SafeMath {
306 
307     /**
308     * @dev Multiplies two numbers, throws on overflow.
309     */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         if (a == 0) {
312             return 0;
313         }
314         uint256 c = a * b;
315         assert(c / a == b);
316         return c;
317     }
318 
319     /**
320     * @dev Integer division of two numbers, truncating the quotient.
321     */
322     function div(uint256 a, uint256 b) internal pure returns (uint256) {
323         // assert(b > 0); // Solidity automatically throws when dividing by 0
324         uint256 c = a / b;
325         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
326         return c;
327     }
328 
329     /**
330     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
331     */
332     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333         assert(b <= a);
334         return a - b;
335     }
336 
337     /**
338     * @dev Adds two numbers, throws on overflow.
339     */
340     function add(uint256 a, uint256 b) internal pure returns (uint256) {
341         uint256 c = a + b;
342         assert(c >= a);
343         return c;
344     }
345 
346 }