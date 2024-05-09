1 /*
2      `sy-                                              `yy.     :y`             `    +y:
3      ymoN.                                             -MyN/    +M.            -M:   -+.
4     +N- hd`    h+syhh:/yhds`  yooyhh/:yydy.  so    /h  -M//No   +M.  -shyyh/ `ydMdyy`-h`  -shyhy:  `h/oyhds`
5    :M/  `my   `Mm.  yMo  .Ns  NN-  oMs` `mh  mh    sN` -M+ -mh` +M.  s+   /M-  :M:   /M. +M/   :No .Mm-  `Nh
6   .NNhhhhmM+  `Mo   oM`   Ny  Ny   /M-   dd  mh    sN` -M+  `dm.+M.  +hyyshM-  :M:   /M. mh     hN .M+    dd
7  `dd`     oM: `Mo   oM`   Ny  Ny   /M.   dd  dd   `dN` -M+    sNoM. +M-   +M-  :M:   /M. yN.   `my .M+    dd
8  sN.       hN``Mo   +M    ms  my   /M.   hh  :mdsyhyN  .M/     /NN. .ddsshyM:  `dmyh`/M.  odysydo` .M+    dh
9  `  `                               ``                     ```        ``         ```     `
10                                                                             ``
11                                                                             dh
12                                                                   +yyyhs. +yNNyy: `+hyyho`  -h/ydd. .syyys-
13                                                                  :M/   o/   dh   `mh`  `yN` /Mh.   :M/   :N/
14 Copyright 2018 ethbattle.io                                       +yhhyo-   dh   /M-    -M/ /M-    yNyyyyydo
15                                                                  :o   `sM`  dd   .Mo    oM- /M-    +M.    +-
16                                                                  .hdysydo   +Nyh+ -hdsshh:  /M.     +dyssdy.
17                                                                     ```       ``     ``                ``
18 
19 */
20 contract ERC721Basic {
21   event Transfer(
22     address indexed _from,
23     address indexed _to,
24     uint256 _tokenId
25   );
26   event Approval(
27     address indexed _owner,
28     address indexed _approved,
29     uint256 _tokenId
30   );
31   event ApprovalForAll(
32     address indexed _owner,
33     address indexed _operator,
34     bool _approved
35   );
36 
37   function balanceOf(address _owner) public view returns (uint256 _balance);
38   function ownerOf(uint256 _tokenId) public view returns (address _owner);
39   function exists(uint256 _tokenId) public view returns (bool _exists);
40 
41   function approve(address _to, uint256 _tokenId) public;
42   function getApproved(uint256 _tokenId)
43     public view returns (address _operator);
44 
45   function setApprovalForAll(address _operator, bool _approved) public;
46   function isApprovedForAll(address _owner, address _operator)
47     public view returns (bool);
48 
49   function transferFrom(address _from, address _to, uint256 _tokenId) public;
50   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
51     public;
52 
53   function safeTransferFrom(
54     address _from,
55     address _to,
56     uint256 _tokenId,
57     bytes _data
58   )
59     public;
60 }
61 
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 contract ERC721Receiver {
117   /**
118    * @dev Magic value to be returned upon successful reception of an NFT
119    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
120    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
121    */
122   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
123 
124   /**
125    * @notice Handle the receipt of an NFT
126    * @dev The ERC721 smart contract calls this function on the recipient
127    *  after a `safetransfer`. This function MAY throw to revert and reject the
128    *  transfer. This function MUST use 50,000 gas or less. Return of other
129    *  than the magic value MUST result in the transaction being reverted.
130    *  Note: the contract address is always the message sender.
131    * @param _from The sending address
132    * @param _tokenId The NFT identifier which is being transfered
133    * @param _data Additional data with no specified format
134    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
135    */
136   function onERC721Received(
137     address _from,
138     uint256 _tokenId,
139     bytes _data
140   )
141     public
142     returns(bytes4);
143 }
144 
145 library SafeMath {
146 
147   /**
148   * @dev Multiplies two numbers, throws on overflow.
149   */
150   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
151     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
152     // benefit is lost if 'b' is also tested.
153     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
154     if (a == 0) {
155       return 0;
156     }
157 
158     c = a * b;
159     assert(c / a == b);
160     return c;
161   }
162 
163   /**
164   * @dev Integer division of two numbers, truncating the quotient.
165   */
166   function div(uint256 a, uint256 b) internal pure returns (uint256) {
167     // assert(b > 0); // Solidity automatically throws when dividing by 0
168     // uint256 c = a / b;
169     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170     return a / b;
171   }
172 
173   /**
174   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
175   */
176   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177     assert(b <= a);
178     return a - b;
179   }
180 
181   /**
182   * @dev Adds two numbers, throws on overflow.
183   */
184   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
185     c = a + b;
186     assert(c >= a);
187     return c;
188   }
189 }
190 
191 contract Claimable is Ownable {
192   address public pendingOwner;
193 
194   /**
195    * @dev Modifier throws if called by any account other than the pendingOwner.
196    */
197   modifier onlyPendingOwner() {
198     require(msg.sender == pendingOwner);
199     _;
200   }
201 
202   /**
203    * @dev Allows the current owner to set the pendingOwner address.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) onlyOwner public {
207     pendingOwner = newOwner;
208   }
209 
210   /**
211    * @dev Allows the pendingOwner address to finalize the transfer.
212    */
213   function claimOwnership() onlyPendingOwner public {
214     emit OwnershipTransferred(owner, pendingOwner);
215     owner = pendingOwner;
216     pendingOwner = address(0);
217   }
218 }
219 
220 contract ERC721Holder is ERC721Receiver {
221   function onERC721Received(address, uint256, bytes) public returns(bytes4) {
222     return ERC721_RECEIVED;
223   }
224 }
225 
226 contract AmmuNationStore is Claimable, ERC721Holder{
227 
228     using SafeMath for uint256;
229 
230     GTAInterface public token;
231 
232     uint256 private tokenSellPrice; //wei
233     uint256 private tokenBuyPrice; //wei
234     uint256 public buyDiscount; //%
235 
236     mapping (address => mapping (uint256 => uint256)) public nftPrices;
237 
238     event Buy(address buyer, uint256 amount, uint256 payed);
239     event Robbery(address robber);
240 
241     constructor (address _tokenAddress) public {
242         token = GTAInterface(_tokenAddress);
243     }
244 
245     /** Owner's operations to fill and empty the stock */
246 
247     // Important! remember to call GoldenThalerToken(address).approve(this, amount)
248     // or this contract will not be able to do the transfer on your behalf.
249     function depositGTA(uint256 amount) onlyOwner public {
250         require(token.transferFrom(msg.sender, this, amount), "Insufficient funds");
251     }
252 
253     // Important! remember to call ERC721Basic(address).approve(this, tokenId)
254     // or this contract will not be able to do the transfer on your behalf.
255     function listNFT(address _nftToken, uint256[] _tokenIds, uint256 _price) onlyOwner public {
256         ERC721Basic erc721 = ERC721Basic(_nftToken);
257         for (uint256 i = 0; i < _tokenIds.length; i++) {
258             erc721.safeTransferFrom(msg.sender, this, _tokenIds[i]);
259             nftPrices[_nftToken][_tokenIds[i]] = _price;
260         }
261     }
262 
263     function delistNFT(address _nftToken, uint256[] _tokenIds) onlyOwner public {
264         ERC721Basic erc721 = ERC721Basic(_nftToken);
265         for (uint256 i = 0; i < _tokenIds.length; i++) {
266             erc721.safeTransferFrom(this, msg.sender, _tokenIds[i]);
267         }
268     }
269 
270     function withdrawGTA(uint256 amount) onlyOwner public {
271         require(token.transfer(msg.sender, amount), "Amount exceeds the available balance");
272     }
273 
274     function robCashier() onlyOwner public {
275         msg.sender.transfer(address(this).balance);
276         emit Robbery(msg.sender);
277     }
278 
279     /**
280    * @dev Set the prices in wei for 1 GTA
281    * @param _newSellPrice The price people can sell GTA for
282    * @param _newBuyPrice The price people can buy GTA for
283    */
284     function setTokenPrices(uint256 _newSellPrice, uint256 _newBuyPrice) onlyOwner public {
285         tokenSellPrice = _newSellPrice;
286         tokenBuyPrice = _newBuyPrice;
287     }
288 
289     function buyNFT(address _nftToken, uint256 _tokenId) payable public returns (uint256){
290         ERC721Basic erc721 = ERC721Basic(_nftToken);
291         require(erc721.ownerOf(_tokenId) == address(this), "This token is not available");
292         require(nftPrices[_nftToken][_tokenId] <= msg.value, "Payed too little");
293         erc721.safeTransferFrom(this, msg.sender, _tokenId);
294     }
295 
296     function buy() payable public returns (uint256){
297         //note: the price of 1 GTA is in wei, but the token transfer expects the amount in 'token wei'
298         //so we're missing 10*18
299         uint256 value = msg.value.mul(1 ether);
300         uint256 _buyPrice = tokenBuyPrice;
301         if (buyDiscount > 0) {
302             //happy discount!
303             _buyPrice = _buyPrice.sub(_buyPrice.mul(buyDiscount).div(100));
304         }
305         uint256 amount = value.div(_buyPrice);
306         require(token.balanceOf(this) >= amount, "Sold out");
307         require(token.transfer(msg.sender, amount), "Couldn't transfer token");
308         emit Buy(msg.sender, amount, msg.value);
309         return amount;
310     }
311 
312     // Important! remember to call GoldenThalerToken(address).approve(this, amount)
313     // or this contract will not be able to do the transfer on your behalf.
314     //TODO No sell at this moment
315     /*function sell(uint256 amount) public returns (uint256){
316         require(token.balanceOf(msg.sender) >= amount, "Insufficient funds");
317         require(token.transferFrom(msg.sender, this, amount), "Couldn't transfer token");
318         uint256 revenue = amount.mul(tokenSellPrice).div(1 ether);
319         msg.sender.transfer(revenue);
320         return revenue;
321     }*/
322 
323     function applyDiscount(uint256 discount) onlyOwner public {
324         buyDiscount = discount;
325     }
326 
327     function getTokenBuyPrice() public view returns (uint256) {
328         uint256 _buyPrice = tokenBuyPrice;
329         if (buyDiscount > 0) {
330             _buyPrice = _buyPrice.sub(_buyPrice.mul(buyDiscount).div(100));
331         }
332         return _buyPrice;
333     }
334 
335     function getTokenSellPrice() public view returns (uint256) {
336         return tokenSellPrice;
337     }
338 }
339 
340 /**
341  * @title GTA contract interface
342  */
343 interface GTAInterface {
344 
345     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
346 
347     function transfer(address to, uint256 value) external returns (bool);
348 
349     function balanceOf(address _owner) external view returns (uint256);
350 
351 }