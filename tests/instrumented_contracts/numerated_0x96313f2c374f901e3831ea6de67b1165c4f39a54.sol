1 pragma solidity ^0.4.18;
2 
3 // inspired by
4 // https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
5 contract AccessControl {
6     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles
7     address public ceoAddress;
8     address public cooAddress;
9 
10     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
11     bool public paused = false;
12 
13     /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account
14     function AccessControl() public {
15         ceoAddress = msg.sender;
16         cooAddress = msg.sender;
17     }
18 
19     /// @dev Access modifier for CEO-only functionality
20     modifier onlyCEO() {
21         require(msg.sender == ceoAddress);
22         _;
23     }
24 
25     /// @dev Access modifier for COO-only functionality
26     modifier onlyCOO() {
27         require(msg.sender == cooAddress);
28         _;
29     }
30 
31     /// @dev Access modifier for any CLevel functionality
32     modifier onlyCLevel() {
33         require(msg.sender == ceoAddress || msg.sender == cooAddress);
34         _;
35     }
36 
37     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO
38     /// @param _newCEO The address of the new CEO
39     function setCEO(address _newCEO) public onlyCEO {
40         require(_newCEO != address(0));
41         ceoAddress = _newCEO;
42     }
43 
44     /// @dev Assigns a new address to act as the COO. Only available to the current CEO
45     /// @param _newCOO The address of the new COO
46     function setCOO(address _newCOO) public onlyCEO {
47         require(_newCOO != address(0));
48         cooAddress = _newCOO;
49     }
50 
51     /// @dev Modifier to allow actions only when the contract IS NOT paused
52     modifier whenNotPaused() {
53         require(!paused);
54         _;
55     }
56 
57     /// @dev Modifier to allow actions only when the contract IS paused
58     modifier whenPaused {
59         require(paused);
60         _;
61     }
62 
63     /// @dev Pause the smart contract. Only can be called by the CEO
64     function pause() public onlyCEO whenNotPaused {
65         paused = true;
66     }
67 
68     /// @dev Unpauses the smart contract. Only can be called by the CEO
69     function unpause() public onlyCEO whenPaused {
70         paused = false;
71     }
72 }
73 
74 
75 /**
76  * Interface for required functionality in the ERC721 standard
77  * for non-fungible tokens.
78  *
79  * Author: Nadav Hollander (nadav at dharma.io)
80  * https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/ERC721.sol
81  */
82 contract ERC721 {
83     // Events
84     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
85     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
86 
87     /// For querying totalSupply of token.
88     function totalSupply() public view returns (uint256 _totalSupply);
89 
90     /// For querying balance of a particular account.
91     /// @param _owner The address for balance query.
92     /// @dev Required for ERC-721 compliance.
93     function balanceOf(address _owner) public view returns (uint256 _balance);
94 
95     /// For querying owner of token.
96     /// @param _tokenId The tokenID for owner inquiry.
97     /// @dev Required for ERC-721 compliance.
98     function ownerOf(uint256 _tokenId) public view returns (address _owner);
99 
100     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom()
101     /// @param _to The address to be granted transfer approval. Pass address(0) to
102     ///  clear all approvals.
103     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
104     /// @dev Required for ERC-721 compliance.
105     function approve(address _to, uint256 _tokenId) public;
106 
107     // NOT IMPLEMENTED
108     // function getApproved(uint256 _tokenId) public view returns (address _approved);
109 
110     /// Third-party initiates transfer of token from address _from to address _to.
111     /// @param _from The address for the token to be transferred from.
112     /// @param _to The address for the token to be transferred to.
113     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
114     /// @dev Required for ERC-721 compliance.
115     function transferFrom(address _from, address _to, uint256 _tokenId) public;
116 
117     /// Owner initates the transfer of the token to another account.
118     /// @param _to The address of the recipient, can be a user or contract.
119     /// @param _tokenId The ID of the token to transfer.
120     /// @dev Required for ERC-721 compliance.
121     function transfer(address _to, uint256 _tokenId) public;
122 
123     ///
124     function implementsERC721() public view returns (bool _implementsERC721);
125 
126     // EXTRA
127     /// @notice Allow pre-approved user to take ownership of a token.
128     /// @param _tokenId The ID of the token that can be transferred if this call succeeds.
129     /// @dev Required for ERC-721 compliance.
130     function takeOwnership(uint256 _tokenId) public;
131 }
132 
133 
134 contract DetailedERC721 is ERC721 {
135     function name() public view returns (string _name);
136     function symbol() public view returns (string _symbol);
137 }
138 
139 contract JoyArt is AccessControl, DetailedERC721 {
140     using SafeMath for uint256;
141 
142     event TokenCreated(uint256 tokenId, string name, uint256 price, address owner);
143     event TokenSold(
144         uint256 indexed tokenId,
145         string name,
146         uint256 sellingPrice,
147         uint256 newPrice,
148         address indexed oldOwner,
149         address indexed newOwner
150     );
151 
152     mapping (uint256 => address) private tokenIdToOwner;
153     mapping (uint256 => uint256) private tokenIdToPrice;
154     mapping (address => uint256) private ownershipTokenCount;
155     mapping (uint256 => address) private tokenIdToApproved;
156 
157     struct Art {
158         string name;
159     }
160 
161     Art[] private artworks;
162 
163     uint256 private startingPrice = 0.001 ether;
164     bool private erc721Enabled = false;
165 
166     modifier onlyERC721() {
167         require(erc721Enabled);
168         _;
169     }
170 
171     function createToken(string _name, address _owner, uint256 _price) public onlyCLevel {
172         require(_owner != address(0));
173         require(_price >= startingPrice);
174 
175         _createToken(_name, _owner, _price);
176     }
177 
178     function createToken(string _name) public onlyCLevel {
179 
180         _createToken(_name, address(this), startingPrice);
181     }
182 
183     function _createToken(string _name, address _owner, uint256 _price) private {
184         Art memory _art = Art({
185             name: _name
186         });
187         uint256 newTokenId = artworks.push(_art) - 1;
188         tokenIdToPrice[newTokenId] = _price;
189 
190         TokenCreated(newTokenId, _name, _price, _owner);
191 
192         _transfer(address(0), _owner, newTokenId);
193     }
194 
195     function getToken(uint256 _tokenId) public view returns (
196         string _tokenName,
197         uint256 _price,
198         uint256 _nextPrice,
199         address _owner
200     ) {
201         _tokenName = artworks[_tokenId].name;
202         _price = tokenIdToPrice[_tokenId];
203         _nextPrice = nextPriceOf(_tokenId);
204         _owner = tokenIdToOwner[_tokenId];
205     }
206 
207     function getAllTokens() public view returns (
208         uint256[],
209         uint256[],
210         address[]
211     ) {
212         uint256 total = totalSupply();
213         uint256[] memory prices = new uint256[](total);
214         uint256[] memory nextPrices = new uint256[](total);
215         address[] memory owners = new address[](total);
216 
217         for (uint256 i = 0; i < total; i++) {
218             prices[i] = tokenIdToPrice[i];
219             nextPrices[i] = nextPriceOf(i);
220             owners[i] = tokenIdToOwner[i];
221         }
222 
223         return (prices, nextPrices, owners);
224     }
225 
226     function tokensOf(address _owner) public view returns(uint256[]) {
227         uint256 tokenCount = balanceOf(_owner);
228         if (tokenCount == 0) {
229             return new uint256[](0);
230         } else {
231             uint256[] memory result = new uint256[](tokenCount);
232             uint256 total = totalSupply();
233             uint256 resultIndex = 0;
234 
235             for (uint256 i = 0; i < total; i++) {
236                 if (tokenIdToOwner[i] == _owner) {
237                     result[resultIndex] = i;
238                     resultIndex++;
239                 }
240             }
241             return result;
242         }
243     }
244 
245     function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
246         require(_amount <= this.balance);
247  
248         uint256 amountToWithdraw = _amount;
249  
250         if (amountToWithdraw == 0) {
251             amountToWithdraw = this.balance;
252         }
253  
254         if(_to == address(0)) {
255             ceoAddress.transfer(amountToWithdraw);
256         } else {
257             _to.transfer(amountToWithdraw);
258         }
259     }
260 
261     function purchase(uint256 _tokenId) public payable whenNotPaused {
262         address oldOwner = ownerOf(_tokenId);
263         address newOwner = msg.sender;
264         uint256 sellingPrice = priceOf(_tokenId);
265 
266         require(oldOwner != address(0));
267         require(newOwner != address(0));
268         require(oldOwner != newOwner);
269         require(!_isContract(newOwner));
270         require(sellingPrice > 0);
271         require(msg.value >= sellingPrice);
272 
273         _transfer(oldOwner, newOwner, _tokenId);
274         tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);
275         TokenSold(
276             _tokenId,
277             artworks[_tokenId].name,
278             sellingPrice,
279             priceOf(_tokenId),
280             oldOwner,
281             newOwner
282         );
283 
284         uint256 excess = msg.value.sub(sellingPrice);
285         uint256 contractCut = sellingPrice.mul(10).div(100); // 10% cut
286 
287         if (oldOwner != address(this)) {
288             oldOwner.transfer(sellingPrice.sub(contractCut));
289         }
290 
291         if (excess > 0) {
292             newOwner.transfer(excess);
293         }
294     }
295 
296     function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
297         return tokenIdToPrice[_tokenId];
298     }
299 
300     uint256 private increaseLimit1 = 0.02 ether;
301     uint256 private increaseLimit2 = 0.5 ether;
302     uint256 private increaseLimit3 = 2.0 ether;
303     uint256 private increaseLimit4 = 5.0 ether;
304 
305     function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
306         uint256 _price = priceOf(_tokenId);
307         if (_price < increaseLimit1) {
308             return _price.mul(200).div(95);
309         } else if (_price < increaseLimit2) {
310             return _price.mul(135).div(96);
311         } else if (_price < increaseLimit3) {
312             return _price.mul(125).div(97);
313         } else if (_price < increaseLimit4) {
314             return _price.mul(117).div(97);
315         } else {
316             return _price.mul(115).div(98);
317         }
318     }
319 
320     function enableERC721() public onlyCEO {
321         erc721Enabled = true;
322     }
323 
324     function totalSupply() public view returns (uint256 _totalSupply) {
325         _totalSupply = artworks.length;
326     }
327 
328     function balanceOf(address _owner) public view returns (uint256 _balance) {
329         _balance = ownershipTokenCount[_owner];
330     }
331 
332     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
333         _owner = tokenIdToOwner[_tokenId];
334     }
335 
336     function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
337         require(_owns(msg.sender, _tokenId));
338         tokenIdToApproved[_tokenId] = _to;
339         Approval(msg.sender, _to, _tokenId);
340     }
341 
342     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
343         require(_to != address(0));
344         require(_owns(_from, _tokenId));
345         require(_approved(msg.sender, _tokenId));
346 
347         _transfer(_from, _to, _tokenId);
348     }
349 
350     function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
351         require(_to != address(0));
352         require(_owns(msg.sender, _tokenId));
353 
354         _transfer(msg.sender, _to, _tokenId);
355     }
356 
357     function implementsERC721() public view whenNotPaused returns (bool) {
358         return erc721Enabled;
359     }
360 
361     function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {
362         require(_approved(msg.sender, _tokenId));
363         _transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);
364     }
365 
366     function name() public view returns (string _name) {
367         _name = "John Orion Young";
368     }
369 
370     function symbol() public view returns (string _symbol) {
371         _symbol = "JOY";
372     }
373 
374     function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
375         return tokenIdToOwner[_tokenId] == _claimant;
376     }
377 
378     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
379         return tokenIdToApproved[_tokenId] == _to;
380     }
381 
382     function _transfer(address _from, address _to, uint256 _tokenId) private {
383         ownershipTokenCount[_to]++;
384         tokenIdToOwner[_tokenId] = _to;
385 
386         if (_from != address(0)) {
387             ownershipTokenCount[_from]--;
388             delete tokenIdToApproved[_tokenId];
389         }
390 
391         Transfer(_from, _to, _tokenId);
392     }
393 
394     function _isContract(address addr) private view returns (bool) {
395         uint256 size;
396         assembly { size := extcodesize(addr) }
397         return size > 0;
398     }
399 }
400 
401 
402 library SafeMath {
403 
404     /**
405     * @dev Multiplies two numbers, throws on overflow.
406     */
407     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
408         if (a == 0) {
409             return 0;
410         }
411         uint256 c = a * b;
412         assert(c / a == b);
413         return c;
414     }
415 
416     /**
417     * @dev Integer division of two numbers, truncating the quotient.
418     */
419     function div(uint256 a, uint256 b) internal pure returns (uint256) {
420         // assert(b > 0); // Solidity automatically throws when dividing by 0
421         uint256 c = a / b;
422         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
423         return c;
424     }
425 
426     /**
427     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
428     */
429     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
430         assert(b <= a);
431         return a - b;
432     }
433 
434     /**
435     * @dev Adds two numbers, throws on overflow.
436     */
437     function add(uint256 a, uint256 b) internal pure returns (uint256) {
438         uint256 c = a + b;
439         assert(c >= a);
440         return c;
441     }
442 }