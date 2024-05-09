1 pragma solidity ^0.8.0;
2 
3 
4 // THIS IS THE BASTARD GAN PUNKS V2 PROXY SALE CONTRACT: 
5 
6 // THE CONTRACT IS WRITTEN TO CATAPULT A NEW PRICING MODEL TO KILL THE BONDING CURVE ON ORIGINAL CONTRACT, TO GIVE NEW MINTS TO USERS VIA DISCOUNTED PRICE. AND ALL INCOME FROM MINTS DIRECTLY GO TO CHARITIES OF MINTER'S CHOICE. 
7 
8 // LONG LIVE BASTARDS! 
9 
10 // WHAT THIS CONTRACT BASICALLY DOES IS: 
11 
12 // THE PRICE GRADUALLY DECREASES EVERY SECOND, AND WHEN SOMEONE ADOPTS A BASTARD FROM HERE, FEE IS DIRECTLY TRANSFERRED TO CHARITY, AND THIS CONTRACT ADOPTS A BASTARD FROM ORIGINAL CONTRACT WITH ORIGINAL PRICE, AND TRANSFERS TO THE MINTER.
13 
14 // Project website: https://bastardganpunks.club
15 
16 // berk aka PrincessCamel - https://berkozdemir.com
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor () {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 /**
104  * @title ERC721 token receiver interface
105  * @dev Interface for any contract that wants to support safeTransfers
106  * from ERC721 asset contracts.
107  */
108 interface IERC721Receiver {
109     /**
110      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
111      * by `operator` from `from`, this function is called.
112      *
113      * It must return its Solidity selector to confirm the token transfer.
114      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
115      *
116      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
117      */
118     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
119 }
120 
121 interface BGANPUNKSV2 {
122     function calculatePrice() external view returns (uint256);
123 
124     function adoptBASTARD(uint256 numBastards) external payable;
125 
126     function safeTransferFrom(
127         address from,
128         address to,
129         uint256 tokenId,
130         bytes calldata data
131     ) external;
132 
133     function totalSupply() external view returns (uint256);
134 }
135 
136 // THIS IS WHERE THE MAGIC HAPPENS
137 
138 contract BASTARDGANPUNKSV2PROXYSALE is Ownable, IERC721Receiver {
139 
140     address payable public treasuryAddress;
141 
142     uint256 public startTime;
143     bool public saleRunning = false;
144 
145     uint256 private two = 2;
146     uint256 public startprice; 
147     uint256 public discountPerSecond;
148     uint256 public halvingTimeInterval;
149 
150     address public BGANPUNKSV2ADDRESS =
151         0x31385d3520bCED94f77AaE104b406994D8F2168C;
152 
153     struct Charity {
154         string name;
155         address charityAddress;
156     }
157 
158     Charity[] public charities;
159     
160     event saleStarted( uint indexed startTime, uint indexed startPrice, uint indexed halvingTimeInterval);
161     event charityAdded(string indexed _name, address indexed _address);
162     event charityEdited(uint indexed _index, string indexed _name, address indexed _address);
163     event charityRemoved(uint indexed _index);
164     event donationSent(string indexed charityName, uint indexed amount);
165 
166     constructor(address payable _treasuryAddress) {
167         treasuryAddress = _treasuryAddress;
168     }
169 
170     receive() external payable {}
171 
172     function startSale(uint256 _startPrice, uint256 _halvingInterval)
173         public
174         onlyOwner
175     {
176         startTime = block.timestamp;
177         startprice = _startPrice;
178         halvingTimeInterval = _halvingInterval;
179         discountPerSecond = startprice / halvingTimeInterval / two;
180         saleRunning = true;
181         emit saleStarted(startTime, _startPrice, _halvingInterval);
182     }
183 
184     function pauseSale() public onlyOwner {
185         saleRunning = false;
186     }
187     function resumeSale() public onlyOwner {
188         saleRunning = true;
189     }
190 
191     // SET CHARITIES AND VIEW
192 
193     function addCharity(address _address, string memory _name)
194         public
195         onlyOwner
196     {
197         charities.push(Charity(_name, _address));
198         emit charityAdded(_name, _address);
199     }
200     
201     
202     function editCharity(
203         uint256 index,
204         address _address,
205         string memory _name
206     ) public onlyOwner {
207         charities[index].name = _name;
208         charities[index].charityAddress = _address;
209         emit charityEdited(index, _name, _address);
210 
211     }
212 
213 
214     function removeCharityNoOrder(uint index)
215         public
216         onlyOwner
217     {
218         charities[index] = charities[charities.length - 1];
219         charities.pop();
220         emit charityRemoved(index);
221     }
222 
223     function getCharityCount() public view returns (uint256) {
224         return charities.length;
225     }
226 
227     function getCharities() public view returns (Charity[] memory) {
228         return charities;
229     }
230     
231     function getCharity(uint index) public view returns (Charity memory) {
232         require(index < charities.length, "YOU REQUESTED A CHARITY OUTSIDE THE RANGE PAL");
233         return charities[index];
234     }
235 
236     // MINTING BASTARDS - CALCULATING PRICE AND TIME
237 
238     function howManySecondsElapsed() public view returns (uint256) {
239         if(saleRunning) {
240         return block.timestamp - startTime;
241         } else {
242             return 0;
243         }
244     }
245 
246     function calculateDiscountedPrice() public view returns (uint256) {
247         require(saleRunning, "SALE HASN'T STARTED OR PAUSED");
248 
249         uint256 elapsed = block.timestamp - startTime;
250         uint256 factorpow = elapsed / halvingTimeInterval;
251         uint256 priceFactor = two ** factorpow;
252 
253         uint256 howmanyseconds =
254             elapsed % halvingTimeInterval * discountPerSecond / priceFactor;
255 
256         uint256 finalPrice = startprice / priceFactor - howmanyseconds;
257         return finalPrice;
258     }
259 
260     function calculateDiscountedPriceTest(uint256 elapsedTime)
261         public
262         view
263         returns (uint256)
264     {
265         require(saleRunning, "SALE HASN'T STARTED OR PAUSED");
266         uint256 factorpow = elapsedTime / halvingTimeInterval;
267         uint256 priceFactor = two**factorpow;
268 
269         uint256 howmanyseconds =
270             elapsedTime % halvingTimeInterval * discountPerSecond / priceFactor;
271 
272         uint256 finalPrice = startprice / priceFactor - howmanyseconds;
273         return finalPrice;
274     }
275 
276     function adoptCheaperBASTARD(uint256 _charitychoice, uint256 _amount)
277         public
278         payable
279     {
280         uint256 originalPrice =
281             BGANPUNKSV2(BGANPUNKSV2ADDRESS).calculatePrice() * _amount;
282 
283         require(
284             msg.value >= calculateDiscountedPrice() * _amount,
285             "YOU HAVEN'T PAID ENOUGH LOL"
286         );
287         require(
288             _charitychoice < charities.length,
289             "U CHOSE A CHARITY THAT DOESN'T EXIST"
290         );
291 
292         payable(charities[_charitychoice].charityAddress).transfer(msg.value);
293 
294         BGANPUNKSV2(BGANPUNKSV2ADDRESS).adoptBASTARD{value: originalPrice}(
295             _amount
296         );
297         uint256 total = BGANPUNKSV2(BGANPUNKSV2ADDRESS).totalSupply();
298         for (uint256 i = total - _amount; i < total; i++) {
299             BGANPUNKSV2(BGANPUNKSV2ADDRESS).safeTransferFrom(
300                 address(this),
301                 msg.sender,
302                 i,
303                 ""
304             );
305         }
306         emit donationSent(charities[_charitychoice].name, msg.value);
307     }
308 
309     // ADD - REMOVE FUNDS TO MAKE THIS CONTRACT ABLE TO BUY BASTARDS FROM THE ORIGINAL BGANPUNKSV2 CONTRACT
310 
311     function addFundsToContract() public payable onlyOwner {
312         payable(address(this)).transfer(msg.value);
313     }
314 
315     function returnFunds() public onlyOwner {
316         treasuryAddress.transfer(address(this).balance);
317     }
318 
319     function setTreasuryAddress(address payable _address) public onlyOwner {
320         treasuryAddress = _address;
321     }
322 
323     // SOME BORING STUFF THAT IS NEEDED
324 
325     function onERC721Received(
326         address,
327         address,
328         uint256,
329         bytes memory
330     ) public virtual override returns (bytes4) {
331         return this.onERC721Received.selector;
332     }
333 }