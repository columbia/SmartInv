1 pragma solidity ^0.4.18;
2 
3 
4 // inspired by
5 // https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
6 contract AccessControl {
7     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles
8     address public ceoAddress;
9     address public cooAddress;
10 
11     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
12     bool public paused = false;
13 
14     /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account
15     function AccessControl() public {
16         ceoAddress = msg.sender;
17         cooAddress = msg.sender;
18     }
19 
20     /// @dev Access modifier for CEO-only functionality
21     modifier onlyCEO() {
22         require(msg.sender == ceoAddress);
23         _;
24     }
25 
26     /// @dev Access modifier for COO-only functionality
27     modifier onlyCOO() {
28         require(msg.sender == cooAddress);
29         _;
30     }
31 
32     /// @dev Access modifier for any CLevel functionality
33     modifier onlyCLevel() {
34         require(msg.sender == ceoAddress || msg.sender == cooAddress);
35         _;
36     }
37 
38     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO
39     /// @param _newCEO The address of the new CEO
40     function setCEO(address _newCEO) public onlyCEO {
41         require(_newCEO != address(0));
42         ceoAddress = _newCEO;
43     }
44 
45     /// @dev Assigns a new address to act as the COO. Only available to the current CEO
46     /// @param _newCOO The address of the new COO
47     function setCOO(address _newCOO) public onlyCEO {
48         require(_newCOO != address(0));
49         cooAddress = _newCOO;
50     }
51 
52     /// @dev Modifier to allow actions only when the contract IS NOT paused
53     modifier whenNotPaused() {
54         require(!paused);
55         _;
56     }
57 
58     /// @dev Modifier to allow actions only when the contract IS paused
59     modifier whenPaused {
60         require(paused);
61         _;
62     }
63 
64     /// @dev Pause the smart contract. Only can be called by the CEO
65     function pause() public onlyCEO whenNotPaused {
66         paused = true;
67     }
68 
69     /// @dev Unpauses the smart contract. Only can be called by the CEO
70     function unpause() public onlyCEO whenPaused {
71         paused = false;
72     }
73 }
74 
75 
76 /**
77  * Interface for required functionality in the ERC721 standard
78  * for non-fungible tokens.
79  *
80  * Author: Nadav Hollander (nadav at dharma.io)
81  * https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/ERC721.sol
82  */
83 contract ERC721 {
84     // Events
85     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
86     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
87 
88     /// For querying totalSupply of token.
89     function totalSupply() public view returns (uint256 _totalSupply);
90 
91     /// For querying balance of a particular account.
92     /// @param _owner The address for balance query.
93     /// @dev Required for ERC-721 compliance.
94     function balanceOf(address _owner) public view returns (uint256 _balance);
95 
96     /// For querying owner of token.
97     /// @param _tokenId The tokenID for owner inquiry.
98     /// @dev Required for ERC-721 compliance.
99     function ownerOf(uint256 _tokenId) public view returns (address _owner);
100 
101     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom()
102     /// @param _to The address to be granted transfer approval. Pass address(0) to
103     ///  clear all approvals.
104     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
105     /// @dev Required for ERC-721 compliance.
106     function approve(address _to, uint256 _tokenId) public;
107 
108     // NOT IMPLEMENTED
109     // function getApproved(uint256 _tokenId) public view returns (address _approved);
110 
111     /// Third-party initiates transfer of token from address _from to address _to.
112     /// @param _from The address for the token to be transferred from.
113     /// @param _to The address for the token to be transferred to.
114     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
115     /// @dev Required for ERC-721 compliance.
116     function transferFrom(address _from, address _to, uint256 _tokenId) public;
117 
118     /// Owner initates the transfer of the token to another account.
119     /// @param _to The address of the recipient, can be a user or contract.
120     /// @param _tokenId The ID of the token to transfer.
121     /// @dev Required for ERC-721 compliance.
122     function transfer(address _to, uint256 _tokenId) public;
123 
124     ///
125     function implementsERC721() public view returns (bool _implementsERC721);
126 
127     // EXTRA
128     /// @notice Allow pre-approved user to take ownership of a token.
129     /// @param _tokenId The ID of the token that can be transferred if this call succeeds.
130     /// @dev Required for ERC-721 compliance.
131     function takeOwnership(uint256 _tokenId) public;
132 }
133 
134 
135 contract DetailedERC721 is ERC721 {
136 	function name() public view returns (string _name);
137 	function symbol() public view returns (string _symbol);
138 }
139 
140 
141 contract CryptoDoggies is AccessControl, DetailedERC721 {
142 	using SafeMath for uint256;
143 
144 	event TokenCreated(uint256 tokenId, string name, bytes5 dna, uint256 price, address owner);
145 	event TokenSold(
146 		uint256 indexed tokenId,
147 		string name,
148 		bytes5 dna,
149 		uint256 sellingPrice,
150 		uint256 newPrice,
151 		address indexed oldOwner,
152 		address indexed newOwner
153 		);
154 
155 	mapping (uint256 => address) private tokenIdToOwner;
156 	mapping (uint256 => uint256) private tokenIdToPrice;
157 	mapping (address => uint256) private ownershipTokenCount;
158 	mapping (uint256 => address) private tokenIdToApproved;
159 
160 	struct Doggy {
161 		string name;
162 		bytes5 dna;
163 	}
164 
165 	Doggy[] private doggies;
166 
167 	uint256 private startingPrice = 0.01 ether;
168 	bool private erc721Enabled = false;
169 
170 	modifier onlyERC721() {
171 		require(erc721Enabled);
172 		_;
173 	}
174 
175 	function createToken(string _name, address _owner, uint256 _price) public onlyCLevel {
176 		require(_owner != address(0));
177 		require(_price >= startingPrice);
178 
179 		bytes5 _dna = _generateRandomDna();
180 		_createToken(_name, _dna, _owner, _price);
181 	}
182 
183 	function createToken(string _name) public onlyCLevel {
184 		bytes5 _dna = _generateRandomDna();
185 		_createToken(_name, _dna, address(this), startingPrice);
186 	}
187 
188 	function _generateRandomDna() private view returns (bytes5) {
189 		uint256 lastBlockNumber = block.number - 1;
190 		bytes32 hashVal = bytes32(block.blockhash(lastBlockNumber));
191 		bytes5 dna = bytes5((hashVal & 0xffffffff) << 216);
192 		return dna;
193 	}
194 
195 	function _createToken(string _name, bytes5 _dna, address _owner, uint256 _price) private {
196 		Doggy memory _doggy = Doggy({
197 			name: _name,
198 			dna: _dna
199 		});
200 		uint256 newTokenId = doggies.push(_doggy) - 1;
201 		tokenIdToPrice[newTokenId] = _price;
202 
203 		TokenCreated(newTokenId, _name, _dna, _price, _owner);
204 
205 		_transfer(address(0), _owner, newTokenId);
206 	}
207 
208 	function getToken(uint256 _tokenId) public view returns (
209 		string _tokenName,
210 		bytes5 _dna,
211 		uint256 _price,
212 		uint256 _nextPrice,
213 		address _owner
214 	) {
215 		_tokenName = doggies[_tokenId].name;
216 		_dna = doggies[_tokenId].dna;
217 		_price = tokenIdToPrice[_tokenId];
218 		_nextPrice = nextPriceOf(_tokenId);
219 		_owner = tokenIdToOwner[_tokenId];
220 	}
221 
222 	function getAllTokens() public view returns (
223 		uint256[],
224 		uint256[],
225 		address[]
226 	) {
227 		uint256 total = totalSupply();
228 		uint256[] memory prices = new uint256[](total);
229 		uint256[] memory nextPrices = new uint256[](total);
230 		address[] memory owners = new address[](total);
231 
232 		for (uint256 i = 0; i < total; i++) {
233 			prices[i] = tokenIdToPrice[i];
234 			nextPrices[i] = nextPriceOf(i);
235 			owners[i] = tokenIdToOwner[i];
236 		}
237 
238 		return (prices, nextPrices, owners);
239 	}
240 
241 	function tokensOf(address _owner) public view returns(uint256[]) {
242 		uint256 tokenCount = balanceOf(_owner);
243 		if (tokenCount == 0) {
244 			return new uint256[](0);
245 		} else {
246 			uint256[] memory result = new uint256[](tokenCount);
247 			uint256 total = totalSupply();
248 			uint256 resultIndex = 0;
249 
250 			for (uint256 i = 0; i < total; i++) {
251 				if (tokenIdToOwner[i] == _owner) {
252 					result[resultIndex] = i;
253 					resultIndex++;
254 				}
255 			}
256 			return result;
257 		}
258 	}
259 
260 	function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
261 		require(_amount <= this.balance);
262 
263 		if (_amount == 0) {
264 			_amount = this.balance;
265 		}
266 
267 		if (_to == address(0)) {
268 			ceoAddress.transfer(_amount);
269 		} else {
270 			_to.transfer(_amount);
271 		}
272 	}
273 
274 	function purchase(uint256 _tokenId) public payable whenNotPaused {
275 		address oldOwner = ownerOf(_tokenId);
276 		address newOwner = msg.sender;
277 		uint256 sellingPrice = priceOf(_tokenId);
278 
279 		require(oldOwner != address(0));
280 		require(newOwner != address(0));
281 		require(oldOwner != newOwner);
282 		require(!_isContract(newOwner));
283 		require(sellingPrice > 0);
284 		require(msg.value >= sellingPrice);
285 
286 		_transfer(oldOwner, newOwner, _tokenId);
287 		tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);
288 		TokenSold(
289 			_tokenId,
290 			doggies[_tokenId].name,
291 			doggies[_tokenId].dna,
292 			sellingPrice,
293 			priceOf(_tokenId),
294 			oldOwner,
295 			newOwner
296 		);
297 
298 		uint256 excess = msg.value.sub(sellingPrice);
299 		uint256 contractCut = sellingPrice.mul(6).div(100); // 6% cut
300 
301 		if (oldOwner != address(this)) {
302 			oldOwner.transfer(sellingPrice.sub(contractCut));
303 		}
304 
305 		if (excess > 0) {
306 			newOwner.transfer(excess);
307 		}
308 	}
309 
310 	function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
311 		return tokenIdToPrice[_tokenId];
312 	}
313 
314 	uint256 private increaseLimit1 = 0.02 ether;
315 	uint256 private increaseLimit2 = 0.5 ether;
316 	uint256 private increaseLimit3 = 2.0 ether;
317 	uint256 private increaseLimit4 = 5.0 ether;
318 
319 	function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
320 		uint256 _price = priceOf(_tokenId);
321 		if (_price < increaseLimit1) {
322 			return _price.mul(200).div(95);
323 		} else if (_price < increaseLimit2) {
324 			return _price.mul(135).div(96);
325 		} else if (_price < increaseLimit3) {
326 			return _price.mul(125).div(97);
327 		} else if (_price < increaseLimit4) {
328 			return _price.mul(117).div(97);
329 		} else {
330 			return _price.mul(115).div(98);
331 		}
332 	}
333 
334 	function enableERC721() public onlyCEO {
335 		erc721Enabled = true;
336 	}
337 
338 	function totalSupply() public view returns (uint256 _totalSupply) {
339 		_totalSupply = doggies.length;
340 	}
341 
342 	function balanceOf(address _owner) public view returns (uint256 _balance) {
343 		_balance = ownershipTokenCount[_owner];
344 	}
345 
346 	function ownerOf(uint256 _tokenId) public view returns (address _owner) {
347 		_owner = tokenIdToOwner[_tokenId];
348 	}
349 
350 	function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
351 		require(_owns(msg.sender, _tokenId));
352 		tokenIdToApproved[_tokenId] = _to;
353 		Approval(msg.sender, _to, _tokenId);
354 	}
355 
356 	function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
357 		require(_to != address(0));
358 		require(_owns(_from, _tokenId));
359 		require(_approved(msg.sender, _tokenId));
360 
361 		_transfer(_from, _to, _tokenId);
362 	}
363 
364 	function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
365 		require(_to != address(0));
366 		require(_owns(msg.sender, _tokenId));
367 
368 		_transfer(msg.sender, _to, _tokenId);
369 	}
370 
371 	function implementsERC721() public view whenNotPaused returns (bool) {
372 		return erc721Enabled;
373 	}
374 
375 	function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {
376 		require(_approved(msg.sender, _tokenId));
377 		_transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);
378 	}
379 
380 	function name() public view returns (string _name) {
381 		_name = "CryptoDoggies";
382 	}
383 
384 	function symbol() public view returns (string _symbol) {
385 		_symbol = "CDT";
386 	}
387 
388 	function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
389 		return tokenIdToOwner[_tokenId] == _claimant;
390 	}
391 
392 	function _approved(address _to, uint256 _tokenId) private view returns (bool) {
393 		return tokenIdToApproved[_tokenId] == _to;
394 	}
395 
396 	function _transfer(address _from, address _to, uint256 _tokenId) private {
397 		ownershipTokenCount[_to]++;
398 		tokenIdToOwner[_tokenId] = _to;
399 
400 		if (_from != address(0)) {
401 			ownershipTokenCount[_from]--;
402 			delete tokenIdToApproved[_tokenId];
403 		}
404 
405 		Transfer(_from, _to, _tokenId);
406 	}
407 
408 	function _isContract(address addr) private view returns (bool) {
409 		uint256 size;
410 		assembly { size := extcodesize(addr) }
411 		return size > 0;
412 	}
413 }
414 
415 
416 library SafeMath {
417 
418     /**
419     * @dev Multiplies two numbers, throws on overflow.
420     */
421     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
422         if (a == 0) {
423             return 0;
424         }
425         uint256 c = a * b;
426         assert(c / a == b);
427         return c;
428     }
429 
430     /**
431     * @dev Integer division of two numbers, truncating the quotient.
432     */
433     function div(uint256 a, uint256 b) internal pure returns (uint256) {
434         // assert(b > 0); // Solidity automatically throws when dividing by 0
435         uint256 c = a / b;
436         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
437         return c;
438     }
439 
440     /**
441     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
442     */
443     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
444         assert(b <= a);
445         return a - b;
446     }
447 
448     /**
449     * @dev Adds two numbers, throws on overflow.
450     */
451     function add(uint256 a, uint256 b) internal pure returns (uint256) {
452         uint256 c = a + b;
453         assert(c >= a);
454         return c;
455     }
456 }