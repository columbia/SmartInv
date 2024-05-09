1 pragma solidity ^0.5.5;
2 
3 //DCC VERSION 5
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
23     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
24 }
25 
26 /**
27  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
28  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
29  */
30 contract ERC721Metadata is ERC721 {
31   function name() external view returns (string memory _name);
32   function symbol() external view returns (string memory _symbol);
33   function tokenURI(uint256 _tokenId) public view returns (string memory);
34 }
35 
36 /**
37  * These are required for the DCC contract to interact with the WLC contract
38  */
39 interface WLCCompatible {
40     function getWLCReward(uint256 _boughtWLCAmount, address _owner) external returns (uint256 _remaining);
41     function setWLCParams(address _address, uint256 _reward) external;
42     function resetWLCParams() external;
43     
44     function getForWLC(address _owner) external;
45     
46     function getWLCRewardAmount() external view returns (uint256 _amount);
47     function getWLCAddress() external view returns (address _address);
48 }
49 
50 contract DreamCarToken1 is ERC721, ERC721Metadata, WLCCompatible {
51     string internal constant tokenName   = 'DreamCarCoin1';
52     string internal constant tokenSymbol = 'DCC1';
53     
54     uint8 public constant decimals = 0;
55     
56     //ERC721 VARIABLES
57     
58     //the total count of wishes
59     uint256 internal totalTokenSupply;
60     
61     //this address is the CEO
62     address payable public CEO;
63     
64     bytes4 constant InterfaceSignature_ERC165 =
65         bytes4(keccak256('supportsInterface(bytes4)'));
66 
67     bytes4 constant InterfaceSignature_ERC721 =
68         bytes4(keccak256('name()')) ^
69         bytes4(keccak256('symbol()')) ^
70         bytes4(keccak256('totalTokenSupply()')) ^
71         bytes4(keccak256('balanceOf(address)')) ^
72         bytes4(keccak256('ownerOf(uint256)')) ^
73         bytes4(keccak256('approve(address,uint256)')) ^
74         bytes4(keccak256('transfer(address,uint256)')) ^
75         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
76         bytes4(keccak256('tokensOfOwner(address)')) ^
77         bytes4(keccak256('tokenMetadata(uint256,string)'));
78     
79     // Mapping from owner to number of owned tokens
80     //mapping (address => uint256) internal tokensBalanceOf;
81     
82     // Mapping from token ID to owner
83     mapping (uint256 => address) internal tokenOwner;
84     
85     // Optional mapping for token URIs
86     mapping(uint256 => string) internal tokenURIs;
87     
88     //TOKEN SPECIFIC VARIABLES
89 
90     mapping (address => uint256) internal tokenBallanceOf;
91     
92     //Token price in WEI
93     uint256 public tokenPrice;
94     
95     //A list of price admins; they can change price, in addition to the CEO
96     address[] public priceAdmins;
97     
98     //Next id that will be assigned to token
99     uint256 internal nextTokenId = 1;
100     
101     //The winning token id
102     uint256 public winningTokenId = 0;
103     
104     //The winner's address, it will be empty, until the reward is claimed
105     address public winnerAddress; 
106     
107     //WLC CONTRACT INTERACTION VARIABLES
108     
109     //WLC tokens in a single purchase to earn a DCC token
110     uint256 internal WLCRewardAmount;
111     
112     //WLC deployed contract address
113     address internal WLCAdress;
114     
115     //ERC721 FUNCTIONS IMPLEMENTATIONS
116     
117     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
118         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
119     }
120     
121     /**
122      * Gets the total amount of tokens stored by the contract
123      * @return uint256 representing the total amount of tokens
124      */
125     function totalSupply() public view returns (uint256 total) {
126         return totalTokenSupply;
127     }
128     
129     /**
130      * Gets the balance of the specified address
131      * @param _owner address to query the balance of
132      * @return uint256 representing the amount owned by the passed address
133      */
134     function balanceOf(address _owner) public view returns (uint256 _balance) {
135         return tokenBallanceOf[_owner];
136     }
137     
138     /**
139      * Gets the owner of the specified token ID
140      * @param _tokenId uint256 ID of the token to query the owner of
141      * @return owner address currently marked as the owner of the given token ID
142      */
143     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
144         return tokenOwner[_tokenId];
145     }
146     
147     /**
148      * Returns whether the specified token exists
149      * @param _tokenId uint256 ID of the token to query the existence of
150      * @return whether the token exists
151      */
152     function exists(uint256 _tokenId) public view returns (bool) {
153         address owner = tokenOwner[_tokenId];
154         return owner != address(0);
155     }
156     
157     /**
158      * Not necessary in the contract
159      */
160     function transfer(address _to, uint256 _tokenId) external { }
161     
162     /**
163      * Not necessary in the contract
164      */
165     function approve(address _to, uint256 _tokenId) external { }
166     
167     /**
168      * Not necessary in the contract - reverts
169      */
170     function transferFrom(address _from, address _to, uint256 _tokenId) external { }
171     
172     /**
173      * Internal function to set the token URI for a given token
174      * Reverts if the token ID does not exist
175      * @param _tokenId uint256 ID of the token to set its URI
176      * @param _uri string URI to assign
177      */
178     function _setTokenURI(uint256 _tokenId, string storage _uri) internal {
179         require(exists(_tokenId));
180         tokenURIs[_tokenId] = _uri;
181     }
182     
183     //ERC721Metadata FUNCTIONS IMPLEMENTATIONS
184     /**
185      * Gets the token name
186      * @return string representing the token name
187      */
188     function name() external view returns (string memory _name) {
189         return tokenName;
190     }
191     
192     /**
193      * Gets the token symbol
194      * @return string representing the token symbol
195      */
196     function symbol() external view returns (string memory _symbol) {
197         return tokenSymbol;
198     }
199     
200     /**
201      * Returns an URI for a given token ID
202      * Throws if the token ID does not exist. May return an empty string.
203      * @param _tokenId uint256 ID of the token to query
204      */
205     function tokenURI(uint256 _tokenId) public view returns (string memory) {
206         require(exists(_tokenId));
207         return tokenURIs[_tokenId];
208     }
209     
210     //TOKEN SPECIFIC FUNCTIONS
211     
212     event Buy(address indexed from, uint256 amount, uint256 fromTokenId, uint256 toTokenId);
213     
214     event RewardIsClaimed(address indexed from, uint256 tokenId);
215     
216     event WinnerIsChosen(address indexed from, uint256 tokenId);
217     
218     /**
219      * Ensures that the caller of the function is the CEO of contract
220      */
221     modifier onlyCEO {
222         require(msg.sender == CEO, 'You need to be the CEO to do that!');
223         _;
224     }
225     
226     /**
227      * Constructor of the contract
228      * @param _ceo address the CEO (owner) of the contract
229      */
230     constructor (address payable _ceo) public {
231         CEO = _ceo;
232         
233         totalTokenSupply = 40000;
234         
235         tokenPrice = 6384880602732729; // (if eth = 156.62USD, 1 USD for token)
236     }
237     
238     /**
239      * Gets the last existing token ids
240      * @return uint256 the id of the token
241      */
242     function lastTokenId() public view returns (uint256 tokenId) {
243         return nextTokenId - 1;
244     }
245     
246     /**
247      * Sets a new price for the tokensExchangedBy
248      * @param _newPrice uint256 the new price in WEI
249      */
250     function setTokenPriceInWEI(uint256 _newPrice) public {
251         bool transactionAllowed = false;
252         
253         if (msg.sender == CEO) {
254             transactionAllowed = true;
255         } else {
256             for (uint256 i = 0; i < priceAdmins.length; i++) {
257                 if (msg.sender == priceAdmins[i]) {
258                     transactionAllowed = true;
259                     break;
260                 }
261             }
262         }
263         
264         require((transactionAllowed == true), 'You cannot do that!');
265         tokenPrice = _newPrice;
266     }
267     
268     /**
269      * Add a new price admin address to the list
270      * @param _newPriceAdmin address the address of the new price admin
271      */
272     function addPriceAdmin(address _newPriceAdmin) onlyCEO public {
273         priceAdmins.push(_newPriceAdmin);
274     }
275     
276     /**
277      * Remove existing price admin address from the list
278      * @param _existingPriceAdmin address the address of the existing price admin
279      */
280     function removePriceAdmin(address _existingPriceAdmin) onlyCEO public {
281         for (uint256 i = 0; i < priceAdmins.length; i++) {
282             if (_existingPriceAdmin == priceAdmins[i]) {
283                 delete priceAdmins[i];
284                 break;
285             }
286         }
287     }
288     
289     /**
290      * Adds the specified number of tokens to the specified address
291      * Internal method, used when creating new tokens
292      * @param _to address The address, which is going to own the tokens
293      * @param _amount uint256 The number of tokens
294      */
295     function _addTokensToAddress(address _to, uint256 _amount) internal {
296         for (uint256 i = 0; i < _amount; i++) {
297             tokenOwner[nextTokenId + i] = _to;
298         }
299         
300         tokenBallanceOf[_to] += _amount;
301         
302         nextTokenId += _amount;
303     }
304     
305     /**
306      * Checks if the specified token is owned by the transaction sender
307      */
308     function ensureAddressIsTokenOwner(address _owner, uint256 _tokenId) internal view {
309         require(balanceOf(_owner) >= 1, 'You do not own any tokens!');
310         
311         require(tokenOwner[_tokenId] == _owner, 'You do not own this token!');
312     }
313     
314     /**
315      * Generates a random number between 1 and totalTokenSupply variable
316      * This is used to choose the winning token id
317      */
318     function getRandomNumber() internal view returns (uint16) {
319         return uint16(
320                 uint256(
321                     keccak256(
322                         abi.encodePacked(block.timestamp, block.difficulty, block.number)
323                     )
324                 )%totalTokenSupply
325             ) + 1;
326     }
327     
328     /**
329      * Chooses a winning token id, if all tokens are purchased
330      */
331     function chooseWinner() internal {
332          if ((nextTokenId - 1) == totalTokenSupply) {
333             winningTokenId = getRandomNumber();
334             emit WinnerIsChosen(tokenOwner[winningTokenId], winningTokenId);
335         } 
336     }
337     
338     /**
339      * Scales the amount of tokens in a purchase, to ensure it will be less or equal to the amount of unsold tokens
340      * If there are no tokens left, it will return 0
341      * @param _amount uint256 the amout of tokens in the purchase attempt
342      * @return _exactAmount uint256
343      */
344     function scalePurchaseTokenAmountToMatchRemainingTokens(uint256 _amount) internal view returns (uint256 _exactAmount) {
345         if (nextTokenId + _amount - 1 > totalTokenSupply) {
346             _amount = totalTokenSupply - nextTokenId + 1;
347         }
348         
349         return _amount;
350     }
351 
352     /**
353     * Buy new tokens with ETH
354     * Calculates the nubmer of tokens for the given ETH amount
355     * Creates the new tokens when they are purchased
356     * Returns the excessive ETH (if any) to the transaction sender
357     */
358     function buy() payable public {
359         require(msg.value >= tokenPrice, "You did't send enough ETH");
360         
361         uint256 amount = scalePurchaseTokenAmountToMatchRemainingTokens(msg.value / tokenPrice);
362         
363         require(amount > 0, "Not enough tokens are available for purchase!");
364         
365         _addTokensToAddress(msg.sender, amount);
366         
367         emit Buy(msg.sender, amount, nextTokenId - amount, nextTokenId - 1);
368         
369         //transfer ETH to CEO
370         CEO.transfer((amount * tokenPrice));
371         
372         //returns excessive ETH
373         msg.sender.transfer(msg.value - (amount * tokenPrice));
374         
375         chooseWinner();
376     }
377     
378     /**
379     * Allows user to destroy a specified token
380     * This would allow a user to claim his prize for the destroyed token
381     * @param _tokenId uint256 ID of the token
382     */
383     function claimReward(uint256 _tokenId) public {
384         require(winningTokenId > 0, "The is not winner yet!");
385         require(_tokenId == winningTokenId, "This token is not the winner!");
386         
387         ensureAddressIsTokenOwner(msg.sender, _tokenId);
388         
389         winnerAddress = msg.sender;
390         
391         emit RewardIsClaimed(msg.sender, _tokenId);
392     }
393     
394     //WLC INTERACTION FUNCTIONS
395     
396     /**
397      * Allows the CEO to set the address and the reward values for a connected WishListToken
398      * @param _address address the address of the deployed contract
399      * @param _reward uint256 how many tokens need to be bought in a single transaction to the one DCC token
400      */
401     function setWLCParams(address _address, uint256 _reward) public onlyCEO {
402         WLCAdress = _address;
403         WLCRewardAmount = _reward;
404     }
405     
406     /**
407      * Allows the CEO to revmove a connected WishListToken
408      * This revokes the reward and exchange functions
409      */
410     function resetWLCParams() public onlyCEO {
411         WLCAdress = address(0);
412         WLCRewardAmount = 0;
413     }
414     
415     /**
416      * How many WLC tokens need to be bought in a single transaction to the one DCC token
417      * @return _amount uint256
418      */
419     function getWLCRewardAmount() public view returns (uint256 _amount) {
420         return WLCRewardAmount;
421     }
422     
423     /**
424      * The address of the deployed WLC contract
425      * @return _address address
426      */
427     function getWLCAddress() public view returns (address _address) {
428         return WLCAdress;
429     }
430     
431     /**
432      * Allows the buyer of at least the number of WLC tokens, specified in WLCRewardAmount
433      * to receive a DCC as a bonus.
434      * This can only be called by the deployed WLC contract, by the address specified in WLCAdress
435      * @param _boughtWLCAmount uint256 the number of bought WLC tokens
436      * @param _owner address the address of the buyer
437      */
438     function getWLCReward(uint256 _boughtWLCAmount, address _owner) public returns (uint256 _remaining) {
439         if (WLCAdress != address(0) && WLCRewardAmount > 0 && _boughtWLCAmount >= WLCRewardAmount) {
440             require(WLCAdress == msg.sender, "You cannot invoke this function directly!");
441             
442             uint256 DCCAmount = scalePurchaseTokenAmountToMatchRemainingTokens(_boughtWLCAmount / WLCRewardAmount);
443             
444             if (DCCAmount > 0) {
445                 _addTokensToAddress(_owner, DCCAmount);
446                 
447                 emit Buy(_owner, DCCAmount, nextTokenId - DCCAmount, nextTokenId - 1);
448                 
449                 chooseWinner();
450                 
451                 return _boughtWLCAmount - (DCCAmount * WLCRewardAmount);
452             }
453         }
454         
455         return _boughtWLCAmount;
456     }
457     
458     /**
459      * Allows an onwer of WLC token to excange it for DCC token
460      * This can only be called by the deployed WLC contract, by the address specified in WLCAdress
461      * @param _owner address the address of the exchanger
462      */
463     function getForWLC(address _owner) public {
464         require(WLCAdress == msg.sender, "You cannot invoke this function directly!");
465         
466         require(nextTokenId <= totalTokenSupply, "Not enough tokens are available for purchase!");
467         
468         _addTokensToAddress(_owner, 1);
469         
470         emit Buy(_owner, 1, nextTokenId - 1, nextTokenId - 1);
471         
472         chooseWinner();
473     }
474 }