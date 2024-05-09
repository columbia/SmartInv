1 pragma solidity ^0.5.5;
2 
3 //WLC VERSION 10
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 interface ERC721 {
8     // Required methods
9     function totalSupply() external view returns (uint256 total);
10     
11     function balanceOf(address _owner) external view returns (uint256 balance);
12     function ownerOf(uint256 _tokenId) external view returns (address owner);
13     function exists(uint256 _tokenId) external view returns (bool _exists);
14     
15     function approve(address _to, uint256 _tokenId) external;
16     function transfer(address _to, uint256 _tokenId) external;
17     function transferFrom(address _from, address _to, uint256 _tokenId) external;
18 
19     // Events
20     event Transfer(address from, address to, uint256 tokenId);
21     event Approval(address owner, address approved, uint256 tokenId);
22 
23     // Optional
24     function tokensOfOwner(address _owner) external view returns (uint256[] memory tokenIds);
25     
26     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
27 }
28 
29 /**
30  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
31  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
32  */
33 contract ERC721Metadata is ERC721 {
34   function name() external view returns (string memory _name);
35   function symbol() external view returns (string memory _symbol);
36   function tokenURI(uint256 _tokenId) public view returns (string memory);
37 }
38 
39 contract DreamCarToken {
40     function getWLCReward(uint256 _boughtWLCAmount, address _owner) public returns (uint256 remaining) {}
41     
42     function getForWLC(address _owner) public {}
43 }
44 
45 contract WishListToken is ERC721, ERC721Metadata {
46     string internal constant tokenName   = 'WishListCoin';
47     string internal constant tokenSymbol = 'WLC';
48     
49     uint256 public constant decimals = 0;
50     
51     //ERC721 VARIABLES
52     
53     //the total count of wishes
54     uint256 public totalTokenSupply;
55     
56     //this address is the CEO
57     address payable public CEO;
58     
59     bytes4 constant InterfaceSignature_ERC165 =
60         bytes4(keccak256('supportsInterface(bytes4)'));
61 
62     bytes4 constant InterfaceSignature_ERC721 =
63         bytes4(keccak256('name()')) ^
64         bytes4(keccak256('symbol()')) ^
65         bytes4(keccak256('totalSupply()')) ^
66         bytes4(keccak256('balanceOf(address)')) ^
67         bytes4(keccak256('ownerOf(uint256)')) ^
68         bytes4(keccak256('approve(address,uint256)')) ^
69         bytes4(keccak256('transfer(address,uint256)')) ^
70         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
71         bytes4(keccak256('tokensOfOwner(address)')) ^
72         bytes4(keccak256('tokenMetadata(uint256,string)'));
73     
74     // Mapping from token ID to owner
75     mapping (uint256 => address) internal tokenOwner;
76     
77     // Mapping from token ID to index of the owner tokens list
78     mapping(uint256 => uint256) internal ownedTokensIndex;
79     
80     // Optional mapping for token URIs
81     mapping(uint256 => string) internal tokenURIs;
82     
83     //TOKEN SPECIFIC VARIABLES
84     
85     // Mapping from owner to ids of owned tokens
86     mapping (address => uint256[]) internal tokensOwnedBy;
87     
88     // Mapping from owner to ids of exchanged tokens
89     mapping (address => uint256[]) internal tokensExchangedBy;
90     
91     //Token price in WEI
92     uint256 public tokenPrice;
93     
94     //A list of price admins; they can change price, in addition to the CEO
95     address[] public priceAdmins;
96     
97     //Next id that will be assigned to token
98     uint256 internal nextTokenId = 1;
99     
100     //DCC INTERACTION VARIABLES
101     
102     //A list, containing the addresses of DreamCarToken contracts, which will be used to award bonus tokens,
103     //when an user purchases a large number of WLC tokens
104     DreamCarToken[] public dreamCarCoinContracts;
105     
106     //A DreamCarToken contract address, which will be used to allow the excange of WLC tokens for DCC tokens
107     DreamCarToken public dreamCarCoinExchanger;
108     
109     //ERC721 FUNCTIONS IMPLEMENTATIONS
110     
111     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
112         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
113     }
114     
115     /**
116      * Gets the total amount of tokens stored by the contract
117      * @return uint256 representing the total amount of tokens
118      */
119     function totalSupply() public view returns (uint256 total) {
120         return totalTokenSupply;
121     }
122     
123     /**
124      * Gets the balance of the specified address
125      * @param _owner address to query the balance of
126      * @return uint256 representing the amount owned by the passed address
127      */
128     function balanceOf(address _owner) public view returns (uint256 _balance) {
129         return tokensOwnedBy[_owner].length;
130     }
131     
132     /**
133      * Gets the owner of the specified token ID
134      * @param _tokenId uint256 ID of the token to query the owner of
135      * @return owner address currently marked as the owner of the given token ID
136      */
137     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
138         return tokenOwner[_tokenId];
139     }
140     
141     /**
142      * Returns whether the specified token exists
143      * @param _tokenId uint256 ID of the token to query the existence of
144      * @return whether the token exists
145      */
146     function exists(uint256 _tokenId) public view returns (bool) {
147         address owner = tokenOwner[_tokenId];
148         return owner != address(0);
149     }
150     
151     /**
152      * Returns a list of the tokens ids, owned by the passed address
153      * @param _owner address the address to chesck
154      * @return the list of token ids
155      */
156     function tokensOfOwner(address _owner) external view returns (uint256[] memory tokenIds) {
157         return tokensOwnedBy[_owner];
158     }
159     
160     /**
161      * Transfers the specified token to the specified address
162      * @param _to address the receiver
163      * @param _tokenId uint256 the id of the token
164      */
165     function transfer(address _to, uint256 _tokenId) external {
166         require(_to != address(0));
167         
168         ensureAddressIsTokenOwner(msg.sender, _tokenId);
169         
170         //swap token for the last one in the list
171         tokensOwnedBy[msg.sender][ownedTokensIndex[_tokenId]] = tokensOwnedBy[msg.sender][tokensOwnedBy[msg.sender].length - 1];
172         
173         //record the changed position of the last element
174         ownedTokensIndex[tokensOwnedBy[msg.sender][tokensOwnedBy[msg.sender].length - 1]] = ownedTokensIndex[_tokenId];
175         
176         //remove last element of the list
177         tokensOwnedBy[msg.sender].pop();
178         
179         //delete tokensOwnedBy[msg.sender][ownedTokensIndex[_tokenId]];
180         tokensOwnedBy[_to].push(_tokenId);
181         
182         tokenOwner[_tokenId] = _to;
183         ownedTokensIndex[_tokenId] = tokensOwnedBy[_to].length - 1;
184         
185         emit Transfer(msg.sender, _to, _tokenId);
186     }
187     
188     /**
189      * Not necessary in the contract
190      */
191     function approve(address _to, uint256 _tokenId) external { }
192     
193     /**
194      * Not necessary in the contract
195      */
196     function transferFrom(address _from, address _to, uint256 _tokenId) external { }
197     
198     /**
199      * Internal function to set the token URI for a given token
200      * Reverts if the token ID does not exist
201      * @param _tokenId uint256 ID of the token to set its URI
202      * @param _uri string URI to assign
203      */
204     function _setTokenURI(uint256 _tokenId, string storage _uri) internal {
205         require(exists(_tokenId));
206         tokenURIs[_tokenId] = _uri;
207     }
208     
209     //ERC721Metadata FUNCTIONS IMPLEMENTATIONS
210     /**
211      * Gets the token name
212      * @return string representing the token name
213      */
214     function name() external view returns (string memory _name) {
215         return tokenName;
216     }
217     
218     /**
219      * Gets the token symbol
220      * @return string representing the token symbol
221      */
222     function symbol() external view returns (string memory _symbol) {
223         return tokenSymbol;
224     }
225     
226     /**
227      * Returns an URI for a given token ID
228      * Throws if the token ID does not exist. May return an empty string.
229      * @param _tokenId uint256 ID of the token to query
230      */
231     function tokenURI(uint256 _tokenId) public view returns (string memory) {
232         require(exists(_tokenId));
233         return tokenURIs[_tokenId];
234     }
235     
236     //TOKEN SPECIFIC FUNCTIONS
237     
238     event Buy(address indexed from, uint256 amount, uint256 fromTokenId, uint256 toTokenId, uint256 timestamp);
239     
240     event Exchange(address indexed from, uint256 tokenId);
241     
242     event ExchangeForDCC(address indexed from, uint256 tokenId);
243     
244     /**
245      * Ensures that the caller of the function is the CEO of contract
246      */
247     modifier onlyCEO {
248         require(msg.sender == CEO, 'You need to be the CEO to do that!');
249         _;
250     }
251     
252     /**
253      * Constructor of the contract
254      * @param _ceo address the CEO (owner) of the contract
255      */
256     constructor (address payable _ceo) public {
257         CEO = _ceo;
258         
259         totalTokenSupply = 1001000;
260         
261         tokenPrice = 3067484662576687; // (if eth = 163USD, 0.5 USD for token)
262     }
263 
264     /**
265      * Gets an array of all tokens ids, exchanged by the specified address
266      * @param _owner address The excanger of the tokens
267      * @return uint256[] The list of exchanged tokens ids
268      */
269     function exchangedBy(address _owner) external view returns (uint256[] memory tokenIds) {
270         return tokensExchangedBy[_owner];
271     }
272     
273     /**
274      * Gets the last existing token ids
275      * @return uint256 the id of the token
276      */
277     function lastTokenId() public view returns (uint256 tokenId) {
278         return nextTokenId - 1;
279     }
280     
281     /**
282      * Sets a new price for the tokensExchangedBy
283      * @param _newPrice uint256 the new price in WEI
284      */
285     function setTokenPriceInWEI(uint256 _newPrice) public {
286         bool transactionAllowed = false;
287         
288         if (msg.sender == CEO) {
289             transactionAllowed = true;
290         } else {
291             for (uint256 i = 0; i < priceAdmins.length; i++) {
292                 if (msg.sender == priceAdmins[i]) {
293                     transactionAllowed = true;
294                     break;
295                 }
296             }
297         }
298         
299         require((transactionAllowed == true), 'You cannot do that!');
300         tokenPrice = _newPrice;
301     }
302     
303     /**
304      * Add a new price admin address to the list
305      * @param _newPriceAdmin address the address of the new price admin
306      */
307     function addPriceAdmin(address _newPriceAdmin) onlyCEO public {
308         priceAdmins.push(_newPriceAdmin);
309     }
310     
311     /**
312      * Remove existing price admin address from the list
313      * @param _existingPriceAdmin address the address of the existing price admin
314      */
315     function removePriceAdmin(address _existingPriceAdmin) onlyCEO public {
316         for (uint256 i = 0; i < priceAdmins.length; i++) {
317             if (_existingPriceAdmin == priceAdmins[i]) {
318                 delete priceAdmins[i];
319                 break;
320             }
321         }
322     }
323     
324     /**
325      * Adds the specified number of tokens to the specified address
326      * Internal method, used when creating new tokens
327      * @param _to address The address, which is going to own the tokens
328      * @param _amount uint256 The number of tokens
329      */
330     function _addTokensToAddress(address _to, uint256 _amount) internal {
331         for (uint256 i = 0; i < _amount; i++) {
332             tokensOwnedBy[_to].push(nextTokenId + i);
333             tokenOwner[nextTokenId + i] = _to;
334             ownedTokensIndex[nextTokenId + i] = tokensOwnedBy[_to].length - 1;
335         }
336         
337         nextTokenId += _amount;
338     }
339     
340     /**
341      * Checks if the specified token is owned by the transaction sender
342      */
343     function ensureAddressIsTokenOwner(address _owner, uint256 _tokenId) internal view {
344         require(balanceOf(_owner) >= 1, 'You do not own any tokens!');
345         
346         require(tokenOwner[_tokenId] == _owner, 'You do not own this token!');
347     }
348     
349     /**
350      * Scales the amount of tokens in a purchase, to ensure it will be less or equal to the amount of unsold tokens
351      * If there are no tokens left, it will return 0
352      * @param _amount uint256 the amout of tokens in the purchase attempt
353      * @return _exactAmount uint256
354      */
355     function scalePurchaseTokenAmountToMatchRemainingTokens(uint256 _amount) internal view returns (uint256 _exactAmount) {
356         if (nextTokenId + _amount - 1 > totalTokenSupply) {
357             _amount = totalTokenSupply - nextTokenId + 1;
358         }
359         
360         if (balanceOf(msg.sender) + _amount > 100) {
361             _amount = 100 - balanceOf(msg.sender);
362             require(_amount > 0, "You can own maximum of 100 tokens!");
363         }
364         
365         return _amount;
366     }
367     
368     /**
369     * Buy new tokens with ETH
370     * Calculates the nubmer of tokens for the given ETH amount
371     * Creates the new tokens when they are purchased
372     * Returns the excessive ETH (if any) to the transaction sender
373     */
374     function buy() payable public {
375         require(msg.value >= tokenPrice, "You did't send enough ETH");
376         
377         uint256 amount = scalePurchaseTokenAmountToMatchRemainingTokens(msg.value / tokenPrice);
378         
379         require(amount > 0, "Not enough tokens are available for purchase!");
380         
381         _addTokensToAddress(msg.sender, amount);
382         
383         emit Buy(msg.sender, amount, nextTokenId - amount, nextTokenId - 1, now);
384         
385         //transfer ETH to CEO
386         CEO.transfer((amount * tokenPrice));
387         
388         getDCCRewards(amount);
389         
390         //returns excessive ETH
391         msg.sender.transfer(msg.value - (amount * tokenPrice));
392     }
393     
394     /**
395      * Removes a token from the provided address ballance and puts it in the tokensExchangedBy mapping
396      * @param _owner address the address of the token owner
397      * @param _tokenId uint256 the id of the token
398      */
399     function exchangeToken(address _owner, uint256 _tokenId) internal {
400         ensureAddressIsTokenOwner(_owner, _tokenId);
401         
402         //swap token for the last one in the list
403         tokensOwnedBy[_owner][ownedTokensIndex[_tokenId]] = tokensOwnedBy[_owner][tokensOwnedBy[_owner].length - 1];
404         
405         //record the changed position of the last element
406         ownedTokensIndex[tokensOwnedBy[_owner][tokensOwnedBy[_owner].length - 1]] = ownedTokensIndex[_tokenId];
407         
408         //remove last element of the list
409         tokensOwnedBy[_owner].pop();
410         
411         ownedTokensIndex[_tokenId] = 0;
412         
413         delete tokenOwner[_tokenId];
414         
415         tokensExchangedBy[_owner].push(_tokenId);
416     }
417     
418     /**
419     * Allows user to destroy a specified token in order to claim his prize for the it
420     * @param _tokenId uint256 ID of the token
421     */
422     function exchange(uint256 _tokenId) public {
423         exchangeToken(msg.sender, _tokenId);
424         
425         emit Exchange(msg.sender, _tokenId);
426     }
427     
428     /**
429      * Allows the CEO to increase the totalTokenSupply
430      * @param _amount uint256 the number of tokens to create
431      */
432     function mint(uint256 _amount) onlyCEO public {
433         require (_amount > 0, 'Amount must be bigger than 0!');
434         totalTokenSupply += _amount;
435     }
436     
437     //DCC INTERACTION FUNCTIONS
438     
439     /**
440      * Adds a DreamCarToken contract address to the list on a specific position.
441      * This allows to maintain and control the order of DreamCarToken contracts, according to their bonus rates
442      * @param _index uint256 the index where the address will be inserted/overwritten
443      * @param _address address the address of the DreamCarToken contract
444      */
445     function setDreamCarCoinAddress(uint256 _index, address _address) public onlyCEO {
446         require (_address != address(0));
447         if (dreamCarCoinContracts.length > 0 && dreamCarCoinContracts.length - 1 >= _index) {
448             dreamCarCoinContracts[_index] = DreamCarToken(_address);
449         } else {
450             dreamCarCoinContracts.push(DreamCarToken(_address));
451         }
452     }
453     
454     /**
455      * Removes a DreamCarToken contract address from the list, by its list index
456      * @param _index uint256 the position of the address
457      */
458     function removeDreamCarCoinAddress(uint256 _index) public onlyCEO {
459         delete(dreamCarCoinContracts[_index]);
460     }
461     
462     /**
463      * Allows the CEO to set an address of DreamCarToken contract, which will be used to excanger
464      * WLCs for DCCs
465      * @param _address address the address of the DreamCarToken contract
466      */
467     function setDreamCarCoinExchanger(address _address) public onlyCEO {
468         require (_address != address(0));
469         dreamCarCoinExchanger = DreamCarToken(_address);
470     }
471     
472     /**
473      * Allows the CEO to remove the address of DreamCarToken contract, which will be used to excanger
474      * WLCs for DCCs
475      */
476     function removeDreamCarCoinExchanger() public onlyCEO {
477         dreamCarCoinExchanger = DreamCarToken(address(0));
478     }
479     
480     /**
481      * Allows the buyer of WLC coins to receive DCCs as bonus.
482      * Works when a DreamCarToken address is set in the dreamCarCoinContracts array.
483      * Loops through the array, starting from the smallest index, where the DreamCarToken, which requires
484      * the highest number of WLCs in a single purchase should be.
485      * Gets the remaining WLCs, after the bonus is payed and tries to get bonus from the other DreamCarToken contracts
486      * in the list
487      * @param _amount uint256 how many tokens was purchased by the buyer
488      */
489     function getDCCRewards(uint256 _amount) internal {
490         for (uint256 i = 0; i < dreamCarCoinContracts.length; i++) {
491             if (_amount > 0 && address(dreamCarCoinContracts[i]) != address(0)) {
492                 _amount = dreamCarCoinContracts[i].getWLCReward(_amount, msg.sender);
493             } else {
494                 break;
495             }
496         }
497     }
498     
499     /**
500      * Allows a user to exchange any WLC coin token a DCC token
501      * @param _tokenId uint256 the id of the owned token
502      */
503     function exchangeForDCC(uint256 _tokenId) public {
504         require (address(dreamCarCoinExchanger) != address(0));
505         
506         dreamCarCoinExchanger.getForWLC(msg.sender);
507         
508         exchangeToken(msg.sender, _tokenId);
509         
510         emit ExchangeForDCC(msg.sender, _tokenId);
511     }
512 }