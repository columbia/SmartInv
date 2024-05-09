1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-09
3 */
4 
5 // File contracts/@openzeppelin/contracts/utils/Context.sol
6 
7 
8 
9 pragma solidity ^0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File contracts/@openzeppelin/contracts/utils/Counters.sol
33 
34 
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @title Counters
40  * @author Matt Condon (@shrugs)
41  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
42  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
43  *
44  * Include with `using Counters for Counters.Counter;`
45  */
46 library Counters {
47     struct Counter {
48         // This variable should never be directly accessed by users of the library: interactions must be restricted to
49         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
50         // this feature: see https://github.com/ethereum/solidity/issues/4637
51         uint256 _value; // default: 0
52     }
53 
54     function current(Counter storage counter) internal view returns (uint256) {
55         return counter._value;
56     }
57 
58     function increment(Counter storage counter) internal {
59         unchecked {
60             counter._value += 1;
61         }
62     }
63 
64     function decrement(Counter storage counter) internal {
65         uint256 value = counter._value;
66         require(value > 0, "Counter: decrement overflow");
67         unchecked {
68             counter._value = value - 1;
69         }
70     }
71 }
72 
73 
74 // File contracts/@openzeppelin/contracts/access/Ownable.sol
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Contract module which provides a basic access control mechanism, where
82  * there is an account (an owner) that can be granted exclusive access to
83  * specific functions.
84  *
85  * By default, the owner account will be the one that deploys the contract. This
86  * can later be changed with {transferOwnership}.
87  *
88  * This module is used through inheritance. It will make available the modifier
89  * `onlyOwner`, which can be applied to your functions to restrict their use to
90  * the owner.
91  */
92 abstract contract Ownable is Context {
93     address private _owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /**
98      * @dev Initializes the contract setting the deployer as the initial owner.
99      */
100     constructor () {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     /**
107      * @dev Returns the address of the current owner.
108      */
109     function owner() public view virtual returns (address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(owner() == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     /**
122      * @dev Leaves the contract without owner. It will not be possible to call
123      * `onlyOwner` functions anymore. Can only be called by the current owner.
124      *
125      * NOTE: Renouncing ownership will leave the contract without an owner,
126      * thereby removing any functionality that is only available to the owner.
127      */
128     function renounceOwnership() public virtual onlyOwner {
129         emit OwnershipTransferred(_owner, address(0));
130         _owner = address(0);
131     }
132 
133     /**
134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
135      * Can only be called by the current owner.
136      */
137     function transferOwnership(address newOwner) public virtual onlyOwner {
138         require(newOwner != address(0), "Ownable: new owner is the zero address");
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 
145 // File contracts/final.sol
146 
147 //SPDX-License-Identifier: MIT
148 pragma solidity ^0.8.0;
149 
150 interface IERC20 {
151 
152     function totalSupply() external view returns (uint256);
153 
154     /**
155         * @dev Returns the amount of tokens owned by `account`.
156         */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160         * @dev Moves `amount` tokens from the caller's account to `recipient`.
161         *
162         * Returns a boolean value indicating whether the operation succeeded.
163         *
164         * Emits a {Transfer} event.
165         */
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     /**
169         * @dev Returns the remaining number of tokens that `spender` will be
170         * allowed to spend on behalf of `owner` through {transferFrom}. This is
171         * zero by default.
172         *
173         * This value changes when {approve} or {transferFrom} are called.
174         */
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     /**
178         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
179         *
180         * Returns a boolean value indicating whether the operation succeeded.
181         *
182         * IMPORTANT: Beware that changing an allowance with this method brings the risk
183         * that someone may use both the old and the new allowance by unfortunate
184         * transaction ordering. One possible solution to mitigate this race
185         * condition is to first reduce the spender's allowance to 0 and set the
186         * desired value afterwards:
187         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188         *
189         * Emits an {Approval} event.
190         */
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     /**
194         * @dev Moves `amount` tokens from `sender` to `recipient` using the
195         * allowance mechanism. `amount` is then deducted from the caller's
196         * allowance.
197         *
198         * Returns a boolean value indicating whether the operation succeeded.
199         *
200         * Emits a {Transfer} event.
201         */
202     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
203 
204     /**
205         * @dev Emitted when `value` tokens are moved from one account (`from`) to
206         * another (`to`).
207         *
208         * Note that `value` may be zero.
209         */
210     event Transfer(address indexed from, address indexed to, uint256 value);
211 
212     /**
213         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
214         * a call to {approve}. `value` is the new allowance.
215         */
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 interface IMetaGochiEgg {
220     function mint(address _to, uint256 _amount) external;
221 }
222 
223 contract MetagochiEggMinter is Ownable{
224     using SafeMath for uint256;
225 
226     modifier onlyClevel() {
227         require(msg.sender == walletA || msg.sender == walletB || msg.sender == owner());
228     _;
229     }
230 
231     address walletA;
232     address walletB;
233     uint256 walletBPercentage = 10;
234 
235     IERC20 public founderToken;
236     IMetaGochiEgg public founderPack;
237     IMetaGochiEgg public normalPack;
238     uint256 public minimumFounderAmount = 15000000000000*10**9;  // founder token has 9 decimals!!
239 
240     uint256 public mintAmountToPrice = 0.05 ether;
241 
242     constructor() {
243         walletA = payable(0x352b858FFE3584238870478A53d7cd2339363A3b);
244         walletB = payable(0x5FFeB4E72401143BcEC5aDC543EcC5fd388d2A88);
245         founderToken = IERC20(0xC1a85Faa09c7f7247899F155439c5488B43E8429);
246 
247         founderPack = IMetaGochiEgg(0x7F1cf2796D7C33B8f5AcBB02c7FFfab51F7A3D36);
248         normalPack = IMetaGochiEgg(0x90749BcAE7bDeE78fD7b8829aeAc855c32A56376);
249     }
250 
251     function mint_pack(uint256 _amount) public payable {
252         require(msg.value>0 && msg.value == mintAmountToPrice.mul(_amount) , "Invalid value.");
253         require(_amount < 50, "Invalid value.");
254 
255         bool founder = founderToken.balanceOf(msg.sender)>=minimumFounderAmount;
256 
257         if (founder){
258             // mint founder
259             founderPack.mint(msg.sender, _amount);
260         }else{
261             // mint normal
262             normalPack.mint(msg.sender, _amount);
263         }
264     }
265 
266     // admin and clevel functions
267     function setMinimumFounderTokenAmount(uint256 _amount) public onlyOwner {
268              minimumFounderAmount = _amount;
269     }
270 
271     function getMinimumFounderTokenAmount() public view returns(uint256) {
272              return minimumFounderAmount;
273     }
274 
275     function setMintPrice(uint256 _price) public onlyOwner {
276              mintAmountToPrice =_price;
277     }
278 
279     function getMintPrice() public view returns (uint256) {
280         return mintAmountToPrice ;
281     }
282 
283     function withdraw_all() public onlyClevel {
284         require (address(this).balance > 0);
285         uint256 amountB = SafeMath.div(address(this).balance,100).mul(walletBPercentage);
286         uint256 amountA = address(this).balance.sub(amountB);
287         payable(walletA).transfer(amountA);
288         payable(walletB).transfer(amountB);
289     }
290 
291     function setWalletA(address _walletA) public {
292         require (msg.sender == walletA, "Who are you?");
293         require (_walletA != address(0x0), "Invalid wallet");
294         walletA = _walletA;
295     }
296 
297     function setWalletB(address _walletB) public {
298         require (msg.sender == walletB, "Who are you?");
299         require (_walletB != address(0x0), "Invalid wallet.");
300         walletB = _walletB;
301     }
302 
303     function setWalletBPercentage(uint256 _percentage) public onlyOwner{
304         require (_percentage>walletBPercentage && _percentage<=100, "Invalid new slice.");
305         walletBPercentage = _percentage;
306     }
307 
308 }
309 
310 
311 library SafeMath {
312 
313     /**
314     * @dev Multiplies two numbers, throws on overflow.
315     */
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         if (a == 0) {
318             return 0;
319         }
320         uint256 c = a * b;
321         assert(c / a == b);
322         return c;
323     }
324 
325     /**
326     * @dev Integer division of two numbers, truncating the quotient.
327     */
328     function div(uint256 a, uint256 b) internal pure returns (uint256) {
329         // assert(b > 0); // Solidity automatically throws when dividing by 0
330         uint256 c = a / b;
331         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
332         return c;
333     }
334 
335     /**
336     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
337     */
338     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
339         assert(b <= a);
340         return a - b;
341     }
342 
343     /**
344     * @dev Adds two numbers, throws on overflow.
345     */
346     function add(uint256 a, uint256 b) internal pure returns (uint256) {
347         uint256 c = a + b;
348         assert(c >= a);
349         return c;
350     }
351 
352 }