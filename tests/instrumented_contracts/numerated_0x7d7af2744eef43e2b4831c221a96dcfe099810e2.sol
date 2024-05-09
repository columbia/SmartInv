1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract InterfaceContentCreatorUniverse {
6   function ownerOf(uint256 _tokenId) public view returns (address _owner);
7   function priceOf(uint256 _tokenId) public view returns (uint256 price);
8   function getNextPrice(uint price, uint _tokenId) public pure returns (uint);
9   function lastSubTokenBuyerOf(uint tokenId) public view returns(address);
10   function lastSubTokenCreatorOf(uint tokenId) public view returns(address);
11 
12   //
13   function createCollectible(uint256 tokenId, uint256 _price, address creator, address owner) external ;
14 }
15 
16 contract InterfaceYCC {
17   function payForUpgrade(address user, uint price) external  returns (bool success);
18   function mintCoinsForOldCollectibles(address to, uint256 amount, address universeOwner) external  returns (bool success);
19   function tradePreToken(uint price, address buyer, address seller, uint burnPercent, address universeOwner) external;
20   function payoutForMining(address user, uint amount) external;
21   uint256 public totalSupply;
22 }
23 
24 contract InterfaceMining {
25   function createMineForToken(uint tokenId, uint level, uint xp, uint nextLevelBreak, uint blocknumber) external;
26   function payoutMining(uint tokenId, address owner, address newOwner) external;
27   function levelUpMining(uint tokenId) external;
28 }
29 
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 contract Owned {
73   // The addresses of the accounts (or contracts) that can execute actions within each roles.
74   address public ceoAddress;
75   address public cooAddress;
76   address private newCeoAddress;
77   address private newCooAddress;
78 
79 
80   function Owned() public {
81       ceoAddress = msg.sender;
82       cooAddress = msg.sender;
83   }
84 
85   /*** ACCESS MODIFIERS ***/
86   /// @dev Access modifier for CEO-only functionality
87   modifier onlyCEO() {
88     require(msg.sender == ceoAddress);
89     _;
90   }
91 
92   /// @dev Access modifier for COO-only functionality
93   modifier onlyCOO() {
94     require(msg.sender == cooAddress);
95     _;
96   }
97 
98   /// Access modifier for contract owner only functionality
99   modifier onlyCLevel() {
100     require(
101       msg.sender == ceoAddress ||
102       msg.sender == cooAddress
103     );
104     _;
105   }
106 
107   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
108   /// @param _newCEO The address of the new CEO
109   function setCEO(address _newCEO) public onlyCEO {
110     require(_newCEO != address(0));
111     newCeoAddress = _newCEO;
112   }
113 
114   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
115   /// @param _newCOO The address of the new COO
116   function setCOO(address _newCOO) public onlyCEO {
117     require(_newCOO != address(0));
118     newCooAddress = _newCOO;
119   }
120 
121   function acceptCeoOwnership() public {
122       require(msg.sender == newCeoAddress);
123       require(address(0) != newCeoAddress);
124       ceoAddress = newCeoAddress;
125       newCeoAddress = address(0);
126   }
127 
128   function acceptCooOwnership() public {
129       require(msg.sender == newCooAddress);
130       require(address(0) != newCooAddress);
131       cooAddress = newCooAddress;
132       newCooAddress = address(0);
133   }
134 
135   mapping (address => bool) public youCollectContracts;
136   function addYouCollectContract(address contractAddress, bool active) public onlyCOO {
137     youCollectContracts[contractAddress] = active;
138   }
139   modifier onlyYCC() {
140     require(youCollectContracts[msg.sender]);
141     _;
142   }
143 
144   InterfaceYCC ycc;
145   InterfaceContentCreatorUniverse yct;
146   InterfaceMining ycm;
147   function setMainYouCollectContractAddresses(address yccContract, address yctContract, address ycmContract, address[] otherContracts) public onlyCOO {
148     ycc = InterfaceYCC(yccContract);
149     yct = InterfaceContentCreatorUniverse(yctContract);
150     ycm = InterfaceMining(ycmContract);
151     youCollectContracts[yccContract] = true;
152     youCollectContracts[yctContract] = true;
153     youCollectContracts[ycmContract] = true;
154     for (uint16 index = 0; index < otherContracts.length; index++) {
155       youCollectContracts[otherContracts[index]] = true;
156     }
157   }
158   function setYccContractAddress(address yccContract) public onlyCOO {
159     ycc = InterfaceYCC(yccContract);
160     youCollectContracts[yccContract] = true;
161   }
162   function setYctContractAddress(address yctContract) public onlyCOO {
163     yct = InterfaceContentCreatorUniverse(yctContract);
164     youCollectContracts[yctContract] = true;
165   }
166   function setYcmContractAddress(address ycmContract) public onlyCOO {
167     ycm = InterfaceMining(ycmContract);
168     youCollectContracts[ycmContract] = true;
169   }
170 
171 }
172 
173 contract TransferInterfaceERC721YC {
174   function transferToken(address to, uint256 tokenId) public returns (bool success);
175 }
176 contract TransferInterfaceERC20 {
177   function transfer(address to, uint tokens) public returns (bool success);
178 }
179 
180 // ----------------------------------------------------------------------------
181 // ERC Token Standard #20 Interface
182 // https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol
183 // ----------------------------------------------------------------------------
184 contract YouCollectBase is Owned {
185   using SafeMath for uint256;
186 
187   event RedButton(uint value, uint totalSupply);
188 
189   // Payout
190   function payout(address _to) public onlyCLevel {
191     _payout(_to, this.balance);
192   }
193   function payout(address _to, uint amount) public onlyCLevel {
194     if (amount>this.balance)
195       amount = this.balance;
196     _payout(_to, amount);
197   }
198   function _payout(address _to, uint amount) private {
199     if (_to == address(0)) {
200       ceoAddress.transfer(amount);
201     } else {
202       _to.transfer(amount);
203     }
204   }
205 
206   // ------------------------------------------------------------------------
207   // Owner can transfer out any accidentally sent ERC20 tokens
208   // ------------------------------------------------------------------------
209   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyCEO returns (bool success) {
210       return TransferInterfaceERC20(tokenAddress).transfer(ceoAddress, tokens);
211   }
212 }
213 
214 
215 contract Donate is YouCollectBase {
216   mapping (uint256 => address) public tokenIndexToOwner;
217   mapping (uint256 => uint256) public tokenIndexToPrice;
218   mapping (uint256 => address) public donateAddress;
219   mapping (uint256 => address) public tokenWinner;
220   uint256 donateTokenCount;
221   uint256 highestPrice = 0.001 ether;
222   address public nextRoundWinner;
223 
224   uint256 lastBuyBlock;
225   uint256 roundDelay = 1999;
226   bool started = false;
227     
228   event TokenSold(uint256 indexed tokenId, uint256 price, address prevOwner, address winner);
229 
230   /*** CONSTRUCTOR ***/
231   function Donate() public {
232   }
233 
234   /// For creating Collectibles
235   function addDonateTokenAddress(address adr) external onlyCEO {
236     donateTokenCount = donateTokenCount.add(1);
237     donateAddress[donateTokenCount] = adr;
238   }
239   function updateDonateTokenAddress(address adr, uint256 tokenId) external onlyCEO {
240     donateAddress[tokenId] = adr;
241   }
242   function changeRoundDelay(uint256 delay) external onlyCEO {
243     roundDelay = delay;
244   }
245 
246   function getBlocksUntilNextRound() public view returns(uint) {
247     if (lastBuyBlock+roundDelay<block.number)
248       return 0;
249     return lastBuyBlock + roundDelay - block.number + 1;
250   }
251   function start() public onlyCEO {
252     started = true;
253     startNextRound();
254   }
255   
256   function startNextRound() public {
257     require(started);
258     require(lastBuyBlock+roundDelay<block.number);
259     tokenIndexToPrice[0] = highestPrice;
260     tokenIndexToOwner[0] = nextRoundWinner;
261     tokenWinner[0] = tokenIndexToOwner[0];
262     
263     for (uint index = 1; index <= donateTokenCount; index++) {
264       tokenIndexToPrice[index] = 0.001 ether;
265       tokenWinner[index] = tokenIndexToOwner[index];
266     }
267     highestPrice = 0.001 ether;
268     lastBuyBlock = block.number;
269   }
270 
271   function getNextPrice(uint price) public pure returns (uint) {
272     if (price < 1 ether)
273       return price.mul(200).div(87);
274     return price.mul(120).div(87);
275   }
276 
277   function buyToken(uint _tokenId) public payable {
278     address oldOwner = tokenIndexToOwner[_tokenId];
279     uint256 sellingPrice = tokenIndexToPrice[_tokenId];
280     require(oldOwner!=msg.sender);
281     require(msg.value >= sellingPrice);
282     require(sellingPrice > 0);
283 
284     uint256 purchaseExcess = msg.value.sub(sellingPrice);
285     uint256 payment = sellingPrice.mul(87).div(100);
286     uint256 feeOnce = sellingPrice.sub(payment).div(13);
287     uint256 feeThree = feeOnce.mul(3);
288     uint256 nextPrice = getNextPrice(sellingPrice);
289     // Update prices
290     tokenIndexToPrice[_tokenId] = nextPrice;
291     // Transfers the Token
292     tokenIndexToOwner[_tokenId] = msg.sender;
293     lastBuyBlock = block.number;
294     if (_tokenId > 0) {
295       // Taxes for last round winner or new owner of the All-Donate-Token
296       if (tokenIndexToOwner[0]!=address(0))
297         tokenIndexToOwner[0].transfer(feeThree);
298       // Check for new winner of this round
299       if (nextPrice > highestPrice) {
300         highestPrice = nextPrice;
301         nextRoundWinner = msg.sender;
302       }
303     }
304     // Donation
305     donateAddress[_tokenId].transfer(feeThree);
306     // Taxes for last round token winner 
307     if (tokenWinner[_tokenId]!=address(0))
308       tokenWinner[_tokenId].transfer(feeThree);
309     // Taxes for universe
310     yct.ownerOf(0).transfer(feeOnce);
311     // Payment for old owner
312     if (oldOwner != address(0)) {
313       oldOwner.transfer(payment);
314     }
315 
316     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
317 
318     // refund when paid too much
319     if (purchaseExcess>0)
320       msg.sender.transfer(purchaseExcess);
321   }
322 
323 
324   function getCollectibleWithMeta(uint256 tokenId) public view returns (uint256 _tokenId, uint256 sellingPrice, address owner, uint256 nextSellingPrice, address _tokenWinner, address _donateAddress) {
325     _tokenId = tokenId;
326     sellingPrice = tokenIndexToPrice[tokenId];
327     owner = tokenIndexToOwner[tokenId];
328     nextSellingPrice = getNextPrice(sellingPrice);
329     
330     _tokenWinner = tokenWinner[tokenId];
331     _donateAddress = donateAddress[tokenId];
332   }
333 
334 }