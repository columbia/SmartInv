1 pragma solidity ^0.4.18;
2 
3 contract InterfaceContentCreatorUniverse {
4   function ownerOf(uint256 _tokenId) public view returns (address _owner);
5   function priceOf(uint256 _tokenId) public view returns (uint256 price);
6   function getNextPrice(uint price, uint _tokenId) public pure returns (uint);
7   function lastSubTokenBuyerOf(uint tokenId) public view returns(address);
8   function lastSubTokenCreatorOf(uint tokenId) public view returns(address);
9 
10   //
11   function createCollectible(uint256 tokenId, uint256 _price, address creator, address owner) external ;
12 }
13 
14 contract InterfaceYCC {
15   function payForUpgrade(address user, uint price) external  returns (bool success);
16   function mintCoinsForOldCollectibles(address to, uint256 amount, address universeOwner) external  returns (bool success);
17   function tradePreToken(uint price, address buyer, address seller, uint burnPercent, address universeOwner) external;
18   function payoutForMining(address user, uint amount) external;
19   uint256 public totalSupply;
20 }
21 
22 contract InterfaceMining {
23   function createMineForToken(uint tokenId, uint level, uint xp, uint nextLevelBreak, uint blocknumber) external;
24   function payoutMining(uint tokenId, address owner, address newOwner) external;
25   function levelUpMining(uint tokenId) external;
26 }
27 
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 contract Owned {
71   // The addresses of the accounts (or contracts) that can execute actions within each roles.
72   address public ceoAddress;
73   address public cooAddress;
74   address private newCeoAddress;
75   address private newCooAddress;
76 
77 
78   function Owned() public {
79       ceoAddress = msg.sender;
80       cooAddress = msg.sender;
81   }
82 
83   /*** ACCESS MODIFIERS ***/
84   /// @dev Access modifier for CEO-only functionality
85   modifier onlyCEO() {
86     require(msg.sender == ceoAddress);
87     _;
88   }
89 
90   /// @dev Access modifier for COO-only functionality
91   modifier onlyCOO() {
92     require(msg.sender == cooAddress);
93     _;
94   }
95 
96   /// Access modifier for contract owner only functionality
97   modifier onlyCLevel() {
98     require(
99       msg.sender == ceoAddress ||
100       msg.sender == cooAddress
101     );
102     _;
103   }
104 
105   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
106   /// @param _newCEO The address of the new CEO
107   function setCEO(address _newCEO) public onlyCEO {
108     require(_newCEO != address(0));
109     newCeoAddress = _newCEO;
110   }
111 
112   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
113   /// @param _newCOO The address of the new COO
114   function setCOO(address _newCOO) public onlyCEO {
115     require(_newCOO != address(0));
116     newCooAddress = _newCOO;
117   }
118 
119   function acceptCeoOwnership() public {
120       require(msg.sender == newCeoAddress);
121       require(address(0) != newCeoAddress);
122       ceoAddress = newCeoAddress;
123       newCeoAddress = address(0);
124   }
125 
126   function acceptCooOwnership() public {
127       require(msg.sender == newCooAddress);
128       require(address(0) != newCooAddress);
129       cooAddress = newCooAddress;
130       newCooAddress = address(0);
131   }
132 
133   mapping (address => bool) public youCollectContracts;
134   function addYouCollectContract(address contractAddress, bool active) public onlyCOO {
135     youCollectContracts[contractAddress] = active;
136   }
137   modifier onlyYCC() {
138     require(youCollectContracts[msg.sender]);
139     _;
140   }
141 
142   InterfaceYCC ycc;
143   InterfaceContentCreatorUniverse yct;
144   InterfaceMining ycm;
145   function setMainYouCollectContractAddresses(address yccContract, address yctContract, address ycmContract, address[] otherContracts) public onlyCOO {
146     ycc = InterfaceYCC(yccContract);
147     yct = InterfaceContentCreatorUniverse(yctContract);
148     ycm = InterfaceMining(ycmContract);
149     youCollectContracts[yccContract] = true;
150     youCollectContracts[yctContract] = true;
151     youCollectContracts[ycmContract] = true;
152     for (uint16 index = 0; index < otherContracts.length; index++) {
153       youCollectContracts[otherContracts[index]] = true;
154     }
155   }
156   function setYccContractAddress(address yccContract) public onlyCOO {
157     ycc = InterfaceYCC(yccContract);
158     youCollectContracts[yccContract] = true;
159   }
160   function setYctContractAddress(address yctContract) public onlyCOO {
161     yct = InterfaceContentCreatorUniverse(yctContract);
162     youCollectContracts[yctContract] = true;
163   }
164   function setYcmContractAddress(address ycmContract) public onlyCOO {
165     ycm = InterfaceMining(ycmContract);
166     youCollectContracts[ycmContract] = true;
167   }
168 
169 }
170 
171 contract TransferInterfaceERC721YC {
172   function transferToken(address to, uint256 tokenId) public returns (bool success);
173 }
174 contract TransferInterfaceERC20 {
175   function transfer(address to, uint tokens) public returns (bool success);
176 }
177 
178 // ----------------------------------------------------------------------------
179 // ERC Token Standard #20 Interface
180 // https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol
181 // ----------------------------------------------------------------------------
182 contract YouCollectBase is Owned {
183   using SafeMath for uint256;
184 
185   event RedButton(uint value, uint totalSupply);
186 
187   // Payout
188   function payout(address _to) public onlyCLevel {
189     _payout(_to, this.balance);
190   }
191   function payout(address _to, uint amount) public onlyCLevel {
192     if (amount>this.balance)
193       amount = this.balance;
194     _payout(_to, amount);
195   }
196   function _payout(address _to, uint amount) private {
197     if (_to == address(0)) {
198       ceoAddress.transfer(amount);
199     } else {
200       _to.transfer(amount);
201     }
202   }
203 
204   // ------------------------------------------------------------------------
205   // Owner can transfer out any accidentally sent ERC20 tokens
206   // ------------------------------------------------------------------------
207   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyCEO returns (bool success) {
208       return TransferInterfaceERC20(tokenAddress).transfer(ceoAddress, tokens);
209   }
210 }
211 
212 // ----------------------------------------------------------------------------
213 // Contract function to receive approval and execute function in one call
214 // ----------------------------------------------------------------------------
215 contract ApproveAndCallFallBack {
216     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
217 }
218 
219 contract YouCollectCoins is YouCollectBase {
220 
221   //
222   //  ERC20 
223   //
224     /*** CONSTANTS ***/
225     string public constant NAME = "YouCollectCoin";
226     string public constant SYMBOL = "YCC";
227     uint8 public constant DECIMALS = 18;  
228 
229     uint256 public totalSupply;
230     uint256 constant private MAX_UINT256 = 2**256 - 1;
231     mapping (address => uint256) public balances;
232     mapping (address => mapping (address => uint256)) public allowed;
233     bool allowTransfer;
234 
235     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
236     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
237 
238     function YouCollectCoins() {
239       addYouCollectContract(msg.sender, true);
240     }
241 
242     /// @dev Required for ERC-20 compliance.
243     function name() public pure returns (string) {
244       return NAME;
245     }
246 
247     /// @dev Required for ERC-20 compliance.
248     function symbol() public pure returns (string) {
249       return SYMBOL;
250     }
251     /// @dev Required for ERC-20 compliance.
252     function decimals() public pure returns (uint8) {
253       return DECIMALS;
254     }
255 
256     function transfer(address _to, uint256 _value) public returns (bool success) {
257         require(allowTransfer);
258         require(balances[msg.sender] >= _value);
259         balances[msg.sender] -= _value;
260         balances[_to] += _value;
261         Transfer(msg.sender, _to, _value);
262         return true;
263     }
264 
265     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
266         require(allowTransfer);
267         uint256 allowance = allowed[_from][msg.sender];
268         require(balances[_from] >= _value && allowance >= _value);
269         balances[_to] += _value;
270         balances[_from] -= _value;
271         if (allowance < MAX_UINT256) {
272             allowed[_from][msg.sender] -= _value;
273         }
274         Transfer(_from, _to, _value);
275         return true;
276     }
277 
278     function balanceOf(address _owner) public view returns (uint256 balance) {
279         return balances[_owner];
280     }
281 
282     function approve(address _spender, uint256 _value) public returns (bool success) {
283         require(allowTransfer);
284         allowed[msg.sender][_spender] = _value;
285         Approval(msg.sender, _spender, _value);
286         return true;
287     }
288 
289     // ------------------------------------------------------------------------
290     // Token owner can approve for `spender` to transferFrom(...) `tokens`
291     // from the token owner's account. The `spender` contract function
292     // `receiveApproval(...)` is then executed
293     // ------------------------------------------------------------------------
294     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
295         require(allowTransfer);
296         allowed[msg.sender][spender] = tokens;
297         Approval(msg.sender, spender, tokens);
298         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
299         return true;
300     }
301 
302     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
303         return allowed[_owner][_spender];
304     }   
305   //
306   //
307 
308 
309   //
310   // Coin sale controlled by external smart contract
311   //
312     bool public coinSaleStarted;
313     address public mintableAddress;
314     uint public totalTokenSellAmount;
315     function mintCoins(address to, uint256 amount) external returns (bool success) {
316       require(coinSaleStarted);
317       require(msg.sender == mintableAddress);
318       require(balances[this] >= amount);
319       balances[this] -= amount;
320       balances[to] += amount;
321       uint bonus = amount.div(100);
322       address universeOwner = yct.ownerOf(0);
323       balances[universeOwner] += bonus;
324       totalSupply += bonus;
325       Transfer(this, to, amount);
326       Transfer(address(0), universeOwner, bonus);
327       return true;
328     }
329     function startCoinSale(uint totalTokens, address sellingContractAddress) public onlyCEO {
330       require(!coinSaleStarted);
331       totalTokenSellAmount = totalTokens;
332       mintableAddress = sellingContractAddress;
333     }
334     function acceptCoinSale() public onlyCEO {
335       coinSaleStarted = true;
336       balances[this] = totalTokenSellAmount;
337       totalSupply += totalTokenSellAmount;
338     }
339     function changeTransfer(bool allowTransfers) external {
340         require(msg.sender == mintableAddress);
341         allowTransfer = allowTransfers;
342     }
343   //
344   //
345 
346 
347   function mintCoinsForOldCollectibles(address to, uint256 amount, address universeOwner) external onlyYCC returns (bool success) {
348     balances[to] += amount;
349     uint bonus = amount.div(100);
350     balances[universeOwner] += bonus;
351     totalSupply += amount + bonus;
352     Transfer(address(0), to, amount);
353     Transfer(address(0), universeOwner, amount);
354     return true;
355   }
356 
357   function payForUpgrade(address user, uint price) external onlyYCC returns (bool success) {
358     require(balances[user] >= price);
359     balances[user] -= price;
360     totalSupply -= price;
361     Transfer(user, address(0), price);
362     return true;
363   }
364 
365   function payoutForMining(address user, uint amount) external onlyYCC {
366     balances[user] += amount;
367     totalSupply += amount;
368     Transfer(address(0), user, amount);
369   }
370 
371   function tradePreToken(uint price, address buyer, address seller, uint burnPercent, address universeOwner) external onlyYCC {
372     require(balances[buyer] >= price);
373     balances[buyer] -= price;
374     if (seller != address(0)) {
375       uint256 onePercent = price.div(100);
376       uint256 payment = price.sub(onePercent.mul(burnPercent+1));
377       // Payment for old owner
378       balances[seller] += payment;
379       totalSupply -= onePercent.mul(burnPercent);
380       balances[universeOwner] += onePercent;
381       Transfer(buyer, seller, payment);
382       Transfer(buyer, universeOwner, onePercent);
383     }else {
384       totalSupply -= price;
385     }
386   }
387 
388 }