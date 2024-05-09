1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File contracts/interfaces/IMintFactory.sol
4 
5 // SPDX-License-Identifier: UNLICENSED
6 // ALL RIGHTS RESERVED
7 
8 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
9 
10 pragma solidity 0.8.17;
11 
12 interface IMintFactory {
13 
14     struct TaxHelper {
15         string Name;
16         address Address;
17         uint Index;
18     }
19 
20     function addTaxHelper(string calldata _name, address _address) external;
21 
22     function updateTaxHelper(uint _index, address _address) external;
23 
24     function getTaxHelperAddress(uint _index) external view returns(address);
25 
26     function getTaxHelpersDataByIndex(uint _index) external view returns(TaxHelper memory);
27 
28     function registerToken (address _tokenOwner, address _tokenAddress) external;
29 
30     function tokenIsRegistered(address _tokenAddress) external view returns (bool);
31 
32     function tokenGeneratorsLength() external view returns (uint256);
33 
34     function tokenGeneratorIsAllowed(address _tokenGenerator) external view returns (bool);
35 
36     function getFacetHelper() external view returns (address);
37 
38     function updateFacetHelper(address _newFacetHelperAddress) external;
39 
40     function getFeeHelper() external view returns (address);
41 
42     function updateFeeHelper(address _newFeeHelperAddress) external;
43     
44     function getLosslessController() external view returns (address);
45 
46     function updateLosslessController(address _newLosslessControllerAddress) external;
47 }
48 
49 
50 // File contracts/interfaces/ITaxHelper.sol
51 
52 // 
53 // ALL RIGHTS RESERVED
54 
55 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
56 
57 
58 
59 interface ITaxHelper {
60 
61     function initiateBuyBackTax(
62         address _token,
63         address _wallet
64     ) external returns (bool);
65 
66     function initiateLPTokenTax(        
67         address _token,
68         address _wallet
69     ) external returns (bool);
70 
71     function lpTokenHasReserves(address _lpToken) external view returns (bool);
72 
73     function createLPToken() external returns (address lpToken);
74 
75     function sync(address _lpToken) external;
76 }
77 
78 
79 // File contracts/interfaces/IERC20.sol
80 
81 
82 
83 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.0.0
84 
85 
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP.
89  */
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95 
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100 
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Moves `amount` tokens from `sender` to `recipient` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
148      * another (`to`).
149      *
150      * Note that `value` may be zero.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 // File contracts/interfaces/ITaxToken.sol
163 
164 // 
165 // ALL RIGHTS RESERVED
166 
167 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
168 
169 
170 interface ITaxToken is IERC20 {
171 
172     function taxHelperIndex()external view returns(uint);
173 
174     function buyBackBurn(uint256 _amount) external;
175 
176     function owner() external view returns (address);
177 
178     function pairAddress() external view returns (address);
179     function decimals() external view returns (uint8);
180 
181 }
182 
183 
184 // File contracts/libraries/Context.sol
185 
186 // 
187 
188 // File @openzeppelin/contracts/utils/Context.sol@v4.0.0
189 
190 
191 
192 /*
193  * @dev Provides information about the current execution context, including the
194  * sender of the transaction and its data. While these are generally available
195  * via msg.sender and msg.data, they should not be accessed in such a direct
196  * manner, since when dealing with meta-transactions the account sending and
197  * paying for execution may not be the actual sender (as far as an application
198  * is concerned).
199  *
200  * This contract is only required for intermediate, library-like contracts.
201  */
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
209         return msg.data;
210     }
211 }
212 
213 
214 // File contracts/libraries/Ownable.sol
215 
216 // 
217 
218 // File @openzeppelin/contracts/access/Ownable.sol@v4.0.0
219 
220 
221 /**
222  * @dev Contract module which provides a basic access control mechanism, where
223  * there is an account (an owner) that can be granted exclusive access to
224  * specific functions.
225  *
226  * By default, the owner account will be the one that deploys the contract. This
227  * can later be changed with {transferOwnership}.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor () {
242         address msgSender = _msgSender();
243         _owner = msgSender;
244         emit OwnershipTransferred(address(0), msgSender);
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view virtual returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(owner() == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() public virtual onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      * Can only be called by the current owner.
277      */
278     function transferOwnership(address newOwner) public virtual onlyOwner {
279         require(newOwner != address(0), "Ownable: new owner is the zero address");
280         emit OwnershipTransferred(_owner, newOwner);
281         _owner = newOwner;
282     }
283 }
284 
285 
286 // File contracts/BuyBackWallet.sol
287 
288 // 
289 // ALL RIGHTS RESERVED
290 
291 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
292 
293 
294 contract BuyBackWallet is Ownable{
295     
296 
297     ITaxToken public token; 
298     IMintFactory public factory;
299     uint256 private threshold;
300 
301     event UpdatedThreshold(uint256 _newThreshold);
302     event ETHtoTaxHelper(uint256 amount);
303 
304 
305     constructor(address _factory, address _token, uint256 _newThreshold) {
306         token = ITaxToken(_token);
307         factory = IMintFactory(_factory);
308         threshold = _newThreshold;
309         emit UpdatedThreshold(_newThreshold);
310         transferOwnership(_token);
311     }
312     
313     function checkBuyBackTrigger() public view returns (bool) {
314         return address(this).balance > threshold;
315     }
316 
317     function getBalance() public view returns (uint256) {
318         return address(this).balance;
319     }
320 
321     function sendEthToTaxHelper() external returns (uint256) {
322         uint index = token.taxHelperIndex();
323         require(msg.sender == factory.getTaxHelperAddress(index), "RA");
324         uint256 amount = address(this).balance;
325         (bool sent,) = msg.sender.call{value: amount}("");
326         require(sent, "Failed to send Ether");
327         emit ETHtoTaxHelper(amount);
328         return amount;
329     }
330 
331     function updateThreshold(uint256 _newThreshold) external onlyOwner {
332         threshold = _newThreshold;
333         emit UpdatedThreshold(_newThreshold);
334     }
335 
336     function getThreshold() external view returns (uint256) {
337         return threshold;
338     }
339 
340     receive() payable external {
341     }
342 }
343 
344 
345 // File contracts/FacetHelper.sol
346 
347 // 
348 // ALL RIGHTS RESERVED
349 
350 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
351 
352 
353 contract FacetHelper is Ownable{
354 
355     event AddedFacet(address _newFacet);
356     event AddedSelector(address _facet, bytes4 _sig);
357     event RemovedSelector(bytes4 _sig);
358     event ResetStorage();
359 
360     event UpdatedSettingsFacet(address _newAddress);
361     event UpdatedLosslessFacet(address _newAddress);
362     event UpdatedTaxFacet(address _newAddress);
363     event UpdatedConstructorFacet(address _newAddress);
364     event UpdatedWalletsFacet(address _newAddress);
365     event UpdatedAntiBotFacet(address _newAddress);
366     event UpdatedMulticallFacet(address _newAddress);
367 
368     struct Facets {
369         address Settings;
370         address Lossless;
371         address Tax;
372         address Constructor;
373         address Wallets;
374         address AntiBot;
375         address Multicall;
376     }
377 
378     struct FacetAddressAndPosition {
379         address facetAddress;
380         uint16 functionSelectorPosition; // position in facetFunctionSelectors.functionSelectors array
381     }
382 
383     struct FacetFunctionSelectors {
384         bytes4[] functionSelectors;
385         uint16 facetAddressPosition; // position of facetAddress in facetAddresses array
386     }
387 
388     // maps function selector to the facet address and
389     // the position of the selector in the facetFunctionSelectors.selectors array
390     mapping(bytes4 => FacetAddressAndPosition) _selectorToFacetAndPosition;
391     // maps facet addresses to function selectors
392     mapping(address => FacetFunctionSelectors) _facetFunctionSelectors;
393     // facet addresses
394     address[] _facetAddresses;
395     // Used to query if a contract implements an interface.
396     // Used to implement ERC-165.
397     mapping(bytes4 => bool) supportedInterfaces;
398 
399     Facets public facetsInfo;
400 
401     enum FacetCutAction {Add, Replace, Remove}
402     // Add=0, Replace=1, Remove=2
403 
404     struct FacetCut {
405         address facetAddress;
406         FacetCutAction action;
407         bytes4[] functionSelectors;
408     }
409 
410     struct Facet {
411         address facetAddress;
412         bytes4[] functionSelectors;
413     }
414 
415     /// @notice Gets all facets and their selectors.
416     /// @return facets_ Facet
417     function facets() external view returns (Facet[] memory facets_) {
418         uint256 numFacets = _facetAddresses.length;
419         facets_ = new Facet[](numFacets);
420         for (uint256 i; i < numFacets; i++) {
421             address facetAddress_ = _facetAddresses[i];
422             facets_[i].facetAddress = facetAddress_;
423             facets_[i].functionSelectors = _facetFunctionSelectors[facetAddress_].functionSelectors;
424         }
425     }
426 
427     /// @notice Gets all the function selectors provided by a facet.
428     /// @param _facet The facet address.
429     /// @return facetFunctionSelectors_
430     function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory facetFunctionSelectors_) {
431         facetFunctionSelectors_ = _facetFunctionSelectors[_facet].functionSelectors;
432     }
433 
434     /// @notice Get all the facet addresses used by a diamond.
435     /// @return facetAddresses_
436     function facetAddresses() external view returns (address[] memory facetAddresses_) {
437         facetAddresses_ = _facetAddresses;
438     }
439 
440     /// @notice Gets the facet that supports the given selector.
441     /// @dev If facet is not found return address(0).
442     /// @param _functionSelector The function selector.
443     /// @return facetAddress_ The facet address.
444     function facetAddress(bytes4 _functionSelector) external view returns (address facetAddress_) {
445         facetAddress_ = _selectorToFacetAndPosition[_functionSelector].facetAddress;
446     }
447 
448     // This implements ERC-165.
449     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
450         return supportedInterfaces[_interfaceId];
451     }
452 
453     event DiamondCut(FacetCut[] _diamondCut);
454 
455     function diamondCut(
456         FacetCut[] memory _diamondCut
457     ) public onlyOwner {
458         for (uint256 facetIndex; facetIndex < _diamondCut.length; facetIndex++) {
459             FacetCutAction action = _diamondCut[facetIndex].action;
460             if (action == FacetCutAction.Add) {
461                 addFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
462             } else if (action == FacetCutAction.Replace) {
463                 replaceFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
464             } else if (action == FacetCutAction.Remove) {
465                 removeFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
466             } else {
467                 revert("LibDiamondCut: Incorrect FacetCutAction");
468             }
469         }
470         emit DiamondCut(_diamondCut);
471     }
472 
473     function addFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
474         require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
475         // uint16 selectorCount = uint16(diamondStorage().selectors.length);
476         require(_facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");
477         uint16 selectorPosition = uint16(_facetFunctionSelectors[_facetAddress].functionSelectors.length);
478         // add new facet address if it does not exist
479         if (selectorPosition == 0) {
480             enforceHasContractCode(_facetAddress, "LibDiamondCut: New facet has no code");
481             _facetFunctionSelectors[_facetAddress].facetAddressPosition = uint16(_facetAddresses.length);
482             _facetAddresses.push(_facetAddress);
483         }
484         for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
485             bytes4 selector = _functionSelectors[selectorIndex];
486             address oldFacetAddress = _selectorToFacetAndPosition[selector].facetAddress;
487             require(oldFacetAddress == address(0), "LibDiamondCut: Can't add function that already exists");
488             _facetFunctionSelectors[_facetAddress].functionSelectors.push(selector);
489             _selectorToFacetAndPosition[selector].facetAddress = _facetAddress;
490             _selectorToFacetAndPosition[selector].functionSelectorPosition = selectorPosition;
491             selectorPosition++;
492         }
493     }
494 
495     function replaceFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
496         require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
497         require(_facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");
498         uint16 selectorPosition = uint16(_facetFunctionSelectors[_facetAddress].functionSelectors.length);
499         // add new facet address if it does not exist
500         if (selectorPosition == 0) {
501             enforceHasContractCode(_facetAddress, "LibDiamondCut: New facet has no code");
502             _facetFunctionSelectors[_facetAddress].facetAddressPosition = uint16(_facetAddresses.length);
503             _facetAddresses.push(_facetAddress);
504         }
505         for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
506             bytes4 selector = _functionSelectors[selectorIndex];
507             address oldFacetAddress = _selectorToFacetAndPosition[selector].facetAddress;
508             require(oldFacetAddress != _facetAddress, "LibDiamondCut: Can't replace function with same function");
509             removeFunction(oldFacetAddress, selector);
510             // add function
511             _selectorToFacetAndPosition[selector].functionSelectorPosition = selectorPosition;
512             _facetFunctionSelectors[_facetAddress].functionSelectors.push(selector);
513             _selectorToFacetAndPosition[selector].facetAddress = _facetAddress;
514             selectorPosition++;
515         }
516     }
517 
518     function removeFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
519         require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
520         // if function does not exist then do nothing and return
521         require(_facetAddress == address(0), "LibDiamondCut: Remove facet address must be address(0)");
522         for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
523             bytes4 selector = _functionSelectors[selectorIndex];
524             address oldFacetAddress = _selectorToFacetAndPosition[selector].facetAddress;
525             removeFunction(oldFacetAddress, selector);
526         }
527     }
528 
529     function removeFunction(address _facetAddress, bytes4 _selector) internal {
530         require(_facetAddress != address(0), "LibDiamondCut: Can't remove function that doesn't exist");
531         // an immutable function is a function defined directly in a diamond
532         require(_facetAddress != address(this), "LibDiamondCut: Can't remove immutable function");
533         // replace selector with last selector, then delete last selector
534         uint256 selectorPosition = _selectorToFacetAndPosition[_selector].functionSelectorPosition;
535         uint256 lastSelectorPosition = _facetFunctionSelectors[_facetAddress].functionSelectors.length - 1;
536         // if not the same then replace _selector with lastSelector
537         if (selectorPosition != lastSelectorPosition) {
538             bytes4 lastSelector = _facetFunctionSelectors[_facetAddress].functionSelectors[lastSelectorPosition];
539             _facetFunctionSelectors[_facetAddress].functionSelectors[selectorPosition] = lastSelector;
540             _selectorToFacetAndPosition[lastSelector].functionSelectorPosition = uint16(selectorPosition);
541         }
542         // delete the last selector
543         _facetFunctionSelectors[_facetAddress].functionSelectors.pop();
544         delete _selectorToFacetAndPosition[_selector];
545 
546         // if no more selectors for facet address then delete the facet address
547         if (lastSelectorPosition == 0) {
548             // replace facet address with last facet address and delete last facet address
549             uint256 lastFacetAddressPosition = _facetAddresses.length - 1;
550             uint256 facetAddressPosition = _facetFunctionSelectors[_facetAddress].facetAddressPosition;
551             if (facetAddressPosition != lastFacetAddressPosition) {
552                 address lastFacetAddress = _facetAddresses[lastFacetAddressPosition];
553                 _facetAddresses[facetAddressPosition] = lastFacetAddress;
554                 _facetFunctionSelectors[lastFacetAddress].facetAddressPosition = uint16(facetAddressPosition);
555             }
556             _facetAddresses.pop();
557             delete _facetFunctionSelectors[_facetAddress].facetAddressPosition;
558         }
559     }
560 
561     function enforceHasContractCode(address _contract, string memory _errorMessage) internal view {
562         uint256 contractSize;
563         assembly {
564             contractSize := extcodesize(_contract)
565         }
566         require(contractSize > 0, _errorMessage);
567     }
568 
569     // mapping(bytes4 => address) public selectorToFacet;
570     // bytes4[] public selectorsList;
571     // mapping(address => bool) public isFacet;
572     // address[] public facetsList;
573 
574     // function addFacet(address _newFacet) public onlyOwner {
575     //     isFacet[_newFacet] = true;
576     //     facetsList.push(_newFacet);
577     //     emit AddedFacet(_newFacet);
578     // }
579 
580     // function batchAddSelectors(address _facet, bytes4[] memory _sigs) public onlyOwner {
581     //     for(uint256 index; index < _sigs.length; index++) {
582     //         addSelector(_facet, _sigs[index]);
583     //     }
584     // }
585 
586     // function addSelector(address _facet, bytes4 _sig) public onlyOwner {
587     //     require(selectorToFacet[_sig] == address(0));
588     //     // require(isFacet[_facet]);
589     //     selectorToFacet[_sig] = _facet;
590     //     selectorsList.push(_sig);
591     //     emit AddedSelector(_facet, _sig);
592     // }
593 
594     // Removing of the selectors occurs during resetFacetStorage();
595     // it is easier to reset and rebuild using the script when deploying and updating the facets
596     // function removeSelector(bytes4 _sig) public onlyOwner {
597     //     selectorToFacet[_sig] = address(0);
598     //     emit RemovedSelector(_sig);
599     // }    
600 
601     // function getFacetAddressFromSelector(bytes4 _sig) public view returns (address) {
602     //     return selectorToFacet[_sig];
603     // }
604 
605     // function getFacetByIndex(uint256 _index) public view returns(address) {
606     //     return facetsList[_index];
607     // }
608 
609     // function resetFacetStorage() public onlyOwner {
610     //     for(uint i = 0; i < selectorsList.length; i++) {
611     //         bytes4 sig = selectorsList[i];
612     //         selectorToFacet[sig] = address(0);
613     //     }
614     //     delete selectorsList;
615 
616     //     for(uint i = 0; i < facetsList.length; i++) {
617     //         address facet = facetsList[i];
618     //         isFacet[facet] = false;
619     //     }
620     //     delete facetsList;
621 
622     //     emit ResetStorage();
623     // }
624 
625         // Facet getters and setters
626 
627     function getSettingsFacet() public view returns (address) {
628         return facetsInfo.Settings;
629     }
630 
631     function updateSettingsFacet(address _newSettingsAddress) public onlyOwner {
632         facetsInfo.Settings = _newSettingsAddress;
633         emit UpdatedSettingsFacet(_newSettingsAddress);
634     }
635 
636     function getLosslessFacet() public view returns (address) {
637         return facetsInfo.Lossless;
638     }
639 
640     function updateLosslessFacet(address _newLosslessAddress) public onlyOwner {
641         facetsInfo.Lossless = _newLosslessAddress;
642         emit UpdatedLosslessFacet(_newLosslessAddress);
643     }
644 
645     function getTaxFacet() public view returns (address) {
646         return facetsInfo.Tax;
647     }
648 
649     function updateTaxFacet(address _newTaxAddress) public onlyOwner {
650         facetsInfo.Tax = _newTaxAddress;
651         emit UpdatedTaxFacet(_newTaxAddress);
652     }
653 
654     function getConstructorFacet() public view returns (address) {
655         return facetsInfo.Constructor;
656     }
657 
658     function updateConstructorFacet(address _newConstructorAddress) public onlyOwner {
659         facetsInfo.Constructor = _newConstructorAddress;
660         emit UpdatedConstructorFacet(_newConstructorAddress);
661     }
662 
663     function getWalletsFacet() public view returns (address) {
664         return facetsInfo.Wallets;
665     }
666 
667     function updateWalletsFacet(address _newWalletsAddress) public onlyOwner {
668         facetsInfo.Wallets = _newWalletsAddress;
669         emit UpdatedWalletsFacet(_newWalletsAddress);
670     }
671 
672     function getAntiBotFacet() public view returns (address) {
673         return facetsInfo.AntiBot;
674     }
675 
676     function updateAntiBotFacet(address _newAntiBotAddress) public onlyOwner {
677         facetsInfo.AntiBot = _newAntiBotAddress;
678         emit UpdatedAntiBotFacet(_newAntiBotAddress);
679     }
680 
681     function getMulticallFacet() public view returns (address) {
682         return facetsInfo.Multicall;
683     }
684 
685     function updateMulticallFacet(address _newWalletsAddress) public onlyOwner {
686         facetsInfo.Multicall = _newWalletsAddress;
687         emit UpdatedMulticallFacet(_newWalletsAddress);
688     }
689 }
690 
691 
692 // File contracts/interfaces/ILosslessController.sol
693 
694 // 
695 
696 
697 
698 interface ILosslessController {
699     
700     function pause() external;
701     function unpause() external;
702     function setAdmin(address _newAdmin) external;
703     function setRecoveryAdmin(address _newRecoveryAdmin) external;
704 
705     function beforeTransfer(address _sender, address _recipient, uint256 _amount) external;
706     function beforeTransferFrom(address _msgSender, address _sender, address _recipient, uint256 _amount) external;
707     function beforeApprove(address _sender, address _spender, uint256 _amount) external;
708     function beforeIncreaseAllowance(address _msgSender, address _spender, uint256 _addedValue) external;
709     function beforeDecreaseAllowance(address _msgSender, address _spender, uint256 _subtractedValue) external;
710     function beforeMint(address _to, uint256 _amount) external;
711     function beforeBurn(address _account, uint256 _amount) external;
712     function afterTransfer(address _sender, address _recipient, uint256 _amount) external;
713 
714 
715     event AdminChange(address indexed _newAdmin);
716     event RecoveryAdminChange(address indexed _newAdmin);
717 }
718 
719 
720 // File contracts/facets/Storage.sol
721 
722 // 
723 // ALL RIGHTS RESERVED
724 
725 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
726 
727 
728 struct Storage {
729 
730     uint256 CONTRACT_VERSION;
731 
732 
733     TaxSettings taxSettings;
734     TaxSettings isLocked;
735     Fees fees;
736     CustomTax[] customTaxes;
737 
738     address transactionTaxWallet;
739     uint256 customTaxLength;
740     uint256 MaxTax;
741     uint8 MaxCustom;
742 
743     uint256 DENOMINATOR;
744 
745     mapping (address => uint256) _rOwned;
746     mapping (address => uint256) _tOwned;
747     mapping (address => mapping (address => uint256)) _allowances;
748 
749     mapping (address => bool) _isExcluded;
750     address[] _excluded;
751    
752     uint256 MAX;
753     uint256 _tTotal;
754     uint256 _rTotal;
755     uint256 _tFeeTotal;
756 
757     mapping (address => bool) lpTokens;
758     
759     string _name;
760     string _symbol;
761     uint8 _decimals;
762     address _creator;
763 
764     address factory;
765 
766     address buyBackWallet;
767     address lpWallet;
768 
769     bool isPaused;
770 
771     bool isTaxed;
772     
773     mapping(address => bool) blacklist;
774     mapping(address => bool) swapWhitelist;
775     mapping(address => bool) maxBalanceWhitelist;
776     mapping(address => bool) taxWhitelist;
777 
778     address pairAddress;
779 
780     uint256 taxHelperIndex;
781 
782     // AntiBot Variables
783 
784     bool marketInit;
785     uint256 marketInitBlockTime;
786 
787     AntiBotSettings antiBotSettings;
788 
789     mapping (address => uint256) antiBotBalanceTracker;
790 
791     uint256 maxBalanceAfterBuy;
792     
793     SwapWhitelistingSettings swapWhitelistingSettings;
794 
795     // Lossless data and events
796 
797     address recoveryAdmin;
798     address recoveryAdminCandidate;
799     bytes32 recoveryAdminKeyHash;
800     address admin;
801     uint256 timelockPeriod;
802     uint256 losslessTurnOffTimestamp;
803     bool isLosslessTurnOffProposed;
804     bool isLosslessOn;
805 }
806 
807 struct TaxSettings {
808     bool transactionTax;
809     bool buyBackTax;
810     bool holderTax;
811     bool lpTax;
812     bool canBlacklist;
813     bool canMint;
814     bool canPause;
815     bool maxBalanceAfterBuy;
816 }
817 
818 struct Fee {
819     uint256 buy;
820     uint256 sell;
821 }
822 
823 struct Fees {
824     Fee transactionTax;
825     uint256 buyBackTax;
826     uint256 holderTax;
827     uint256 lpTax;
828 }
829 
830 struct CustomTax {
831     string name;
832     Fee fee;
833     address wallet;
834     bool withdrawAsGas;
835 }
836 
837 struct AntiBotSettings {
838     uint256 startBlock;
839     uint256 endDate;
840     uint256 increment;
841     uint256 initialMaxHold;
842     bool isActive;
843 }
844 
845 struct SwapWhitelistingSettings {
846     uint256 endDate;
847     bool isActive;
848 }
849 
850 
851 // File contracts/facets/AntiBot.sol
852 
853 // 
854 // ALL RIGHTS RESERVED
855 
856 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
857 
858 
859 contract AntiBotFacet is Ownable {
860     Storage internal s;
861 
862     event UpdatedAntiBotIncrement(uint256 _updatedIncrement);
863     event UpdatedAntiBotEndDate(uint256 _updatedEndDate);
864     event UpdatedAntiBotInitialMaxHold(uint256 _updatedInitialMaxHold);
865     event UpdatedAntiBotActiveStatus(bool _isActive);
866     event UpdatedSwapWhitelistingEndDate(uint256 _updatedEndDate);
867     event UpdatedSwapWhitelistingActiveStatus(bool _isActive);
868     event UpdatedMaxBalanceAfterBuy(uint256 _newMaxBalance);
869 
870     event AddedMaxBalanceWhitelistAddress(address _address);   
871     event RemovedMaxBalanceWhitelistAddress(address _address);        
872     event AddedSwapWhitelistAddress(address _address);
873     event RemovedSwapWhitelistAddress(address _address);
874     
875     // AntiBot
876 
877     function antiBotIsActiveModifier() view internal {
878         require(s.antiBotSettings.isActive, "ABD");
879     }
880 
881     modifier antiBotIsActive() {
882         antiBotIsActiveModifier();
883         _;
884     }
885 
886     function setIncrement(uint256 _updatedIncrement) public onlyOwner antiBotIsActive {
887         s.antiBotSettings.increment = _updatedIncrement;
888         emit UpdatedAntiBotIncrement(_updatedIncrement);
889     }
890 
891     function setEndDate( uint256 _updatedEndDate) public onlyOwner antiBotIsActive {
892         require(_updatedEndDate <= 48, "ED");
893         s.antiBotSettings.endDate = _updatedEndDate;
894         emit UpdatedAntiBotEndDate(_updatedEndDate);
895     }
896 
897     function setInitialMaxHold( uint256 _updatedInitialMaxHold) public onlyOwner antiBotIsActive {
898         s.antiBotSettings.initialMaxHold = _updatedInitialMaxHold;
899         emit UpdatedAntiBotInitialMaxHold(_updatedInitialMaxHold);
900     }
901 
902     function updateAntiBot(bool _isActive) public onlyOwner {
903         require(!s.marketInit, "AMIE");
904         s.antiBotSettings.isActive = _isActive;
905         emit UpdatedAntiBotActiveStatus(_isActive);
906     }
907 
908     function antiBotCheck(uint256 amount, address receiver) public returns(bool) {
909         // restrict it to being only called by registered tokens
910         require(IMintFactory(s.factory).tokenIsRegistered(address(this)));
911         require(s.marketInit, "AMIE");
912         if(block.timestamp > s.marketInitBlockTime + (s.antiBotSettings.endDate * 1 hours)) {
913             s.antiBotSettings.isActive = false;
914             return true;
915         }
916 
917         s.antiBotBalanceTracker[receiver] += amount;
918         uint256 userAntiBotBalance = s.antiBotBalanceTracker[receiver];
919         uint256 maxAntiBotBalance = ((block.number - s.antiBotSettings.startBlock) * s.antiBotSettings.increment) + s.antiBotSettings.initialMaxHold;
920 
921         require((userAntiBotBalance <= maxAntiBotBalance), "ABMSA");
922         return true;
923     }
924 
925     // MaxBalanceAfterBuy
926    
927     function addMaxBalanceWhitelistedAddress(address _address) public onlyOwner {
928         require(s.taxSettings.maxBalanceAfterBuy, "AMBABD");
929         s.maxBalanceWhitelist[_address] = true;
930         emit AddedMaxBalanceWhitelistAddress(_address);
931     }
932 
933     function removeMaxBalanceWhitelistedAddress(address _address) public onlyOwner {
934         require(s.taxSettings.maxBalanceAfterBuy, "AMBABD");
935         s.maxBalanceWhitelist[_address] = false;
936         emit RemovedMaxBalanceWhitelistAddress(_address);
937     }
938 
939     function updateMaxBalanceWhitelistBatch(address[] calldata _updatedAddresses, bool _isMaxBalanceWhitelisted) public onlyOwner {
940         require(s.taxSettings.maxBalanceAfterBuy, "AMBABD");
941         for(uint i = 0; i < _updatedAddresses.length; i++) {
942             s.maxBalanceWhitelist[_updatedAddresses[i]] = _isMaxBalanceWhitelisted;
943             if(_isMaxBalanceWhitelisted) {
944                 emit AddedMaxBalanceWhitelistAddress(_updatedAddresses[i]);
945             } else {
946                 emit RemovedMaxBalanceWhitelistAddress(_updatedAddresses[i]);
947             }
948         }
949     }
950 
951     function isMaxBalanceWhitelisted(address _address) public view returns (bool) {
952         return s.maxBalanceWhitelist[_address];
953     }
954 
955     function updateMaxBalanceAfterBuy(uint256 _updatedMaxBalanceAfterBuy) public onlyOwner {
956         require(s.taxSettings.maxBalanceAfterBuy, "AMBABD");
957         s.maxBalanceAfterBuy = _updatedMaxBalanceAfterBuy;
958         emit UpdatedMaxBalanceAfterBuy(_updatedMaxBalanceAfterBuy);
959     }
960 
961     function maxBalanceAfterBuyCheck(uint256 amount, address receiver) public view returns(bool) {
962         if(s.maxBalanceWhitelist[receiver]) {
963             return true;
964         }
965         require(s.taxSettings.maxBalanceAfterBuy);
966         uint256 receiverBalance;
967         if(s.taxSettings.holderTax) {
968             receiverBalance = s._rOwned[receiver];
969         } else {
970             receiverBalance = s._tOwned[receiver];
971         }
972         receiverBalance += amount;
973         require(receiverBalance <= s.maxBalanceAfterBuy, "MBAB");
974         return true;
975     }
976 
977     // SwapWhitelist
978 
979     function addSwapWhitelistedAddress(address _address) public onlyOwner {
980         require(s.swapWhitelistingSettings.isActive, "ASWD");
981         s.swapWhitelist[_address] = true;
982         emit AddedSwapWhitelistAddress(_address);
983     }
984 
985     function removeSwapWhitelistedAddress(address _address) public onlyOwner {
986         require(s.swapWhitelistingSettings.isActive, "ASWD");
987         s.swapWhitelist[_address] = false;
988         emit RemovedSwapWhitelistAddress(_address);
989     }
990 
991     function updateSwapWhitelistBatch(address[] calldata _updatedAddresses, bool _isSwapWhitelisted) public onlyOwner {
992         require(s.swapWhitelistingSettings.isActive, "ASWD");
993         for(uint i = 0; i < _updatedAddresses.length; i++) {
994             s.swapWhitelist[_updatedAddresses[i]] = _isSwapWhitelisted;
995             if(_isSwapWhitelisted) {
996                 emit AddedSwapWhitelistAddress(_updatedAddresses[i]);
997             } else {
998                 emit RemovedSwapWhitelistAddress(_updatedAddresses[i]);
999             }
1000         }
1001     }
1002 
1003     function isSwapWhitelisted(address _address) public view returns (bool) {
1004         return s.swapWhitelist[_address];
1005     }
1006 
1007     function setSwapWhitelistEndDate( uint256 _updatedEndDate) public onlyOwner {
1008         require(s.swapWhitelistingSettings.isActive, "ASWD");
1009         require(_updatedEndDate <= 48, "ED");
1010         s.swapWhitelistingSettings.endDate = _updatedEndDate;
1011         emit UpdatedSwapWhitelistingEndDate(_updatedEndDate);
1012     }
1013 
1014     function updateSwapWhitelisting(bool _isActive) public onlyOwner {
1015         require(!s.marketInit, "AMIE");
1016         s.swapWhitelistingSettings.isActive = _isActive;
1017         emit UpdatedSwapWhitelistingActiveStatus(_isActive);
1018     }
1019 
1020     function swapWhitelistingCheck(address receiver) public returns(bool) {
1021         require(s.marketInit, "AMIE");
1022         if(block.timestamp > s.marketInitBlockTime + (s.swapWhitelistingSettings.endDate * 1 hours)) {
1023             s.swapWhitelistingSettings.isActive = false;
1024             return true;
1025         }
1026         require(s.swapWhitelist[receiver], "SWL");
1027         return true;
1028     }
1029 }
1030 
1031 
1032 // File contracts/interfaces/IBuyBackWallet.sol
1033 
1034 // 
1035 // ALL RIGHTS RESERVED
1036 
1037 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1038 
1039 
1040 
1041 interface IBuyBackWallet {
1042 
1043     function checkBuyBackTrigger() external view returns (bool);
1044 
1045     function getBalance() external view returns (uint256);
1046 
1047     function sendEthToTaxHelper() external returns(uint256);
1048 
1049     function updateThreshold(uint256 _newThreshold) external;
1050 
1051     function getThreshold() external view returns (uint256);
1052 }
1053 
1054 
1055 // File contracts/interfaces/IFacetHelper.sol
1056 
1057 // 
1058 // ALL RIGHTS RESERVED
1059 
1060 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1061 
1062 
1063 
1064 interface IFacetHelper {
1065 
1066     struct Facet {
1067         address facetAddress;
1068         bytes4[] functionSelectors;
1069     }
1070 
1071     /// @notice Gets all facet addresses and their four byte function selectors.
1072     /// @return facets_ Facet
1073     function facets() external view returns (Facet[] memory facets_);
1074 
1075     /// @notice Gets all the function selectors supported by a specific facet.
1076     /// @param _facet The facet address.
1077     /// @return facetFunctionSelectors_
1078     function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory facetFunctionSelectors_);
1079 
1080     /// @notice Get all the facet addresses used by a diamond.
1081     /// @return facetAddresses_
1082     function facetAddresses() external view returns (address[] memory facetAddresses_);
1083 
1084     /// @notice Gets the facet that supports the given selector.
1085     /// @dev If facet is not found return address(0).
1086     /// @param _functionSelector The function selector.
1087     /// @return facetAddress_ The facet address.
1088     function facetAddress(bytes4 _functionSelector) external view returns (address facetAddress_);
1089 
1090     // function addFacet(address _newFacet) external;
1091 
1092     // function addSelector(address _facet, bytes4 _sig) external;
1093 
1094     // function removeSelector(bytes4 _sig) external;
1095 
1096     function getFacetAddressFromSelector(bytes4 _sig) external view returns (address);
1097 
1098     function getSettingsFacet() external view returns (address);
1099 
1100     function updateSettingsFacet(address _newSettingsAddress) external;
1101 
1102     function getTaxFacet() external view returns (address);
1103 
1104     function updateTaxFacet(address _newTaxesAddress) external;
1105 
1106     function getLosslessFacet() external view returns (address);
1107 
1108     function updateLosslessFacet(address _newLosslessAddress) external;
1109 
1110     function getConstructorFacet() external view returns (address);
1111 
1112     function updateConstructorFacet(address _newConstructorAddress) external;
1113 
1114     function getWalletsFacet() external view returns (address);
1115 
1116     function updateWalletsFacet(address _newWalletsAddress) external;
1117 
1118     function getAntiBotFacet() external view returns (address);
1119 
1120     function updateAntiBotFacet(address _newWalletsAddress) external;
1121 
1122     function getMulticallFacet() external view returns (address);
1123 
1124     function updateMulticallFacet(address _newWalletsAddress) external;
1125     
1126 }
1127 
1128 
1129 // File contracts/interfaces/ILPWallet.sol
1130 
1131 // 
1132 // ALL RIGHTS RESERVED
1133 
1134 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1135 
1136 
1137 
1138 interface ILPWallet {
1139 
1140     function checkLPTrigger() external view returns (bool);
1141 
1142     function getBalance() external view returns (uint256);
1143 
1144     function sendEthToTaxHelper() external returns(uint256);
1145 
1146     function transferBalanceToTaxHelper() external;
1147 
1148     function updateThreshold(uint256 _newThreshold) external;
1149 
1150     function getThreshold() external view returns (uint256);
1151 }
1152 
1153 
1154 // File contracts/interfaces/ISettings.sol
1155 
1156 // 
1157 // ALL RIGHTS RESERVED
1158 
1159 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1160 
1161 
1162 
1163 interface ISettingsFacet {
1164 
1165     function getFacetAddressFromSelector(bytes4 _sig) external view returns (address);
1166     function createBuyBackWallet(address _factory, address _token) external returns (address);
1167     function createLPWallet(address _factory, address _token) external returns (address);
1168 }
1169 
1170 
1171 // File contracts/interfaces/IWallets.sol
1172 
1173 // 
1174 // ALL RIGHTS RESERVED
1175 
1176 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1177 
1178 
1179 
1180 interface IWalletsFacet {
1181 
1182     function createBuyBackWallet(address _factory, address _token, uint256 _newThreshold) external returns (address);
1183     function createLPWallet(address _factory, address _token, uint256 _newThreshold) external returns (address);
1184 
1185     function updateBuyBackWalletThreshold(uint256 _newThreshold) external;
1186 
1187     function updateLPWalletThreshold(uint256 _newThreshold) external;
1188 }
1189 
1190 
1191 // File contracts/facets/Constructor.sol
1192 
1193 // 
1194 // ALL RIGHTS RESERVED
1195 
1196 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1197 
1198 
1199 contract ConstructorFacet is Ownable {
1200     Storage internal s;
1201 
1202     event ExcludedAccount(address account);
1203     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
1204     event RecoveryAdminChanged(address indexed previousAdmin, address indexed newAdmin);
1205     event UpdatedCustomTaxes(CustomTax[] _customTaxes);
1206     event UpdatedTaxFees(Fees _updatedFees);
1207     event UpdatedTransactionTaxAddress(address _newAddress);
1208     event UpdatedLockedSettings(TaxSettings _updatedLocks);
1209     event UpdatedSettings(TaxSettings _updatedSettings);
1210     event UpdatedTaxHelperIndex(uint _newIndex);
1211     event UpdatedAntiBotSettings(AntiBotSettings _antiBotSettings);
1212     event UpdatedSwapWhitelistingSettings(SwapWhitelistingSettings _swapWhitelistingSettings);
1213     event UpdatedMaxBalanceAfterBuy(uint256 _newMaxBalance);
1214     event AddedLPToken(address _newLPToken);
1215     event TokenCreated(string name, string symbol, uint8 decimals, uint256 totalSupply, uint256 reflectionTotalSupply);
1216     event Transfer(address indexed from, address indexed to, uint256 value);
1217     
1218     struct ConstructorParams {
1219         string name_; 
1220         string symbol_; 
1221         uint8 decimals_; 
1222         address creator_; 
1223         uint256 tTotal_;
1224         uint256 _maxTax;
1225         TaxSettings _settings;
1226         TaxSettings _lockedSettings;
1227         Fees _fees;
1228         address _transactionTaxWallet;
1229         CustomTax[] _customTaxes;
1230         uint256 lpWalletThreshold;
1231         uint256 buyBackWalletThreshold;
1232         uint256 _taxHelperIndex;
1233         address admin_; 
1234         address recoveryAdmin_; 
1235         bool isLossless_;
1236         AntiBotSettings _antiBotSettings;
1237         uint256 _maxBalanceAfterBuy;
1238         SwapWhitelistingSettings _swapWhitelistingSettings;
1239     }
1240 
1241     function constructorHandler(ConstructorParams calldata params, address _factory) external {
1242         require(IMintFactory(_factory).tokenGeneratorIsAllowed(msg.sender), "RA");
1243         require(params.creator_ != address(0), "ZA");
1244         require(params._transactionTaxWallet != address(0), "ZA");
1245         require(params.admin_ != address(0), "ZA");
1246         require(params.recoveryAdmin_ != address(0), "ZA");
1247         require(_factory != address(0), "ZA");
1248 
1249         // Set inital values
1250         s.CONTRACT_VERSION = 1;
1251         s.customTaxLength = 0;
1252         s.MaxTax = 3000;
1253         s.MaxCustom = 10;
1254         s.MAX = ~uint256(0);
1255         s.isPaused = false;
1256         s.isTaxed = false;
1257         s.marketInit = false;
1258 
1259         s._name = params.name_;
1260         s._symbol = params.symbol_;
1261         s._decimals = params.decimals_;
1262         s._creator = params.creator_;
1263         s._isExcluded[params.creator_] = true;
1264         s._excluded.push(params.creator_);
1265         emit ExcludedAccount(s._creator);
1266         // Lossless
1267         s.isLosslessOn = params.isLossless_;
1268         s.admin = params.admin_;
1269         emit AdminChanged(address(0), s.admin);
1270         s.recoveryAdmin = params.recoveryAdmin_;
1271         emit RecoveryAdminChanged(address(0), s.recoveryAdmin);
1272         s.timelockPeriod = 7 days;
1273         address lossless = IMintFactory(_factory).getLosslessController();
1274         s._isExcluded[lossless] = true;
1275         s._excluded.push(lossless);
1276         emit ExcludedAccount(lossless);
1277         // Tax Settings
1278         require(params._maxTax <= s.MaxTax, "MT");
1279         s.MaxTax = params._maxTax;
1280         s.taxSettings = params._settings;
1281         emit UpdatedSettings(s.taxSettings);
1282         s.isLocked = params._lockedSettings;
1283         s.isLocked.holderTax = true;
1284         if(s.taxSettings.holderTax) {
1285             s.taxSettings.canMint = false;
1286             s.isLocked.canMint = true;
1287         }
1288         emit UpdatedLockedSettings(s.isLocked);
1289         s.fees = params._fees;
1290         emit UpdatedTaxFees(s.fees);
1291         require(params._customTaxes.length < s.MaxCustom + 1, "MCT");
1292         for(uint i = 0; i < params._customTaxes.length; i++) {
1293             require(params._customTaxes[i].wallet != address(0));
1294             s.customTaxes.push(params._customTaxes[i]);
1295         }
1296         emit UpdatedCustomTaxes(s.customTaxes);
1297         s.customTaxLength = params._customTaxes.length;
1298         s.transactionTaxWallet = params._transactionTaxWallet;
1299         emit UpdatedTransactionTaxAddress(s.transactionTaxWallet);
1300         // Factory, Wallets, Pair Address
1301         s.factory = _factory;
1302         s.taxHelperIndex = params._taxHelperIndex;
1303         emit UpdatedTaxHelperIndex(s.taxHelperIndex);
1304         address taxHelper = IMintFactory(s.factory).getTaxHelperAddress(s.taxHelperIndex);
1305         s.pairAddress = ITaxHelper(taxHelper).createLPToken();
1306         addLPToken(s.pairAddress);
1307         address wallets = IFacetHelper(IMintFactory(s.factory).getFacetHelper()).getWalletsFacet(); 
1308         s.buyBackWallet = IWalletsFacet(wallets).createBuyBackWallet(s.factory, address(this), params.buyBackWalletThreshold);
1309         s.lpWallet = IWalletsFacet(wallets).createLPWallet(s.factory, address(this), params.lpWalletThreshold);
1310         // Total Supply and other info
1311         s._rTotal = (s.MAX - (s.MAX % params.tTotal_));
1312         s._rOwned[params.creator_] = s._rTotal;
1313         s.DENOMINATOR = 10000;
1314         s._isExcluded[taxHelper] = true;
1315         s._excluded.push(taxHelper);
1316         emit ExcludedAccount(taxHelper);
1317         require(checkMaxTax(true), "BF");
1318         require(checkMaxTax(false), "SF");
1319         transferOwnership(params.creator_);
1320         _mintInitial(params.creator_, params.tTotal_);
1321         // AntiBot Settings
1322         require(params._antiBotSettings.endDate <= 48, "ED");
1323         require(params._swapWhitelistingSettings.endDate <= 48, "ED");
1324         s.antiBotSettings = params._antiBotSettings;
1325         emit UpdatedAntiBotSettings(s.antiBotSettings);
1326         s.maxBalanceAfterBuy = params._maxBalanceAfterBuy;
1327         emit UpdatedMaxBalanceAfterBuy(s.maxBalanceAfterBuy);
1328         s.swapWhitelistingSettings = params._swapWhitelistingSettings;
1329         emit UpdatedSwapWhitelistingSettings(s.swapWhitelistingSettings);
1330         emit TokenCreated(s._name, s._symbol, s._decimals, s._tTotal, s._rTotal);
1331     }
1332 
1333     function _mintInitial(address account, uint256 amount) internal virtual {
1334         s._tTotal += amount;
1335         s._tOwned[account] += amount;
1336         emit Transfer(address(0), account, amount);
1337     }
1338 
1339     function checkMaxTax(bool isBuy) internal view returns (bool) {
1340         uint256 totalTaxes;
1341         if(isBuy) {
1342             totalTaxes += s.fees.transactionTax.buy;
1343             totalTaxes += s.fees.holderTax;
1344             for(uint i = 0; i < s.customTaxes.length; i++) {
1345                 totalTaxes += s.customTaxes[i].fee.buy;
1346             }
1347         } else {
1348             totalTaxes += s.fees.transactionTax.sell;
1349             totalTaxes += s.fees.lpTax;
1350             totalTaxes += s.fees.holderTax;
1351             totalTaxes += s.fees.buyBackTax;
1352             for(uint i = 0; i < s.customTaxes.length; i++) {
1353                 totalTaxes += s.customTaxes[i].fee.sell;
1354             }
1355         }
1356         if(totalTaxes <= s.MaxTax) {
1357             return true;
1358         }
1359         return false;
1360     }
1361 
1362 
1363     function addLPToken(address _newLPToken) internal {
1364         s.lpTokens[_newLPToken] = true;
1365         emit AddedLPToken(_newLPToken);
1366     }
1367 }
1368 
1369 
1370 // File contracts/facets/Lossless.sol
1371 
1372 // 
1373 // ALL RIGHTS RESERVED
1374 
1375 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1376 
1377 
1378 contract LosslessFacet is Ownable {
1379     Storage internal s;
1380 
1381     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
1382     event RecoveryAdminChangeProposed(address indexed candidate);
1383     event RecoveryAdminChanged(address indexed previousAdmin, address indexed newAdmin);
1384     event LosslessTurnOffProposed(uint256 turnOffDate);
1385     event LosslessTurnedOff();
1386     event LosslessTurnedOn();
1387 
1388     function onlyRecoveryAdminCheck() internal view {
1389         require(_msgSender() == s.recoveryAdmin, "LRA");
1390     }
1391 
1392     modifier onlyRecoveryAdmin() {
1393         onlyRecoveryAdminCheck();
1394         _;
1395     }
1396 
1397     // --- LOSSLESS management ---
1398 
1399     function getAdmin() external view returns (address) {
1400         return s.admin;
1401     }
1402 
1403     function setLosslessAdmin(address newAdmin) external onlyRecoveryAdmin {
1404         require(newAdmin != address(0), "LZ");
1405         emit AdminChanged(s.admin, newAdmin);
1406         s.admin = newAdmin;
1407     }
1408 
1409     function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) external onlyRecoveryAdmin {
1410         require(candidate != address(0), "LZ");
1411         s.recoveryAdminCandidate = candidate;
1412         s.recoveryAdminKeyHash = keyHash;
1413         emit RecoveryAdminChangeProposed(candidate);
1414     }
1415 
1416     function acceptRecoveryAdminOwnership(bytes memory key) external {
1417         require(_msgSender() == s.recoveryAdminCandidate, "LC");
1418         require(keccak256(key) == s.recoveryAdminKeyHash, "LIK");
1419         emit RecoveryAdminChanged(s.recoveryAdmin, s.recoveryAdminCandidate);
1420         s.recoveryAdmin = s.recoveryAdminCandidate;
1421     }
1422 
1423     function proposeLosslessTurnOff() external onlyRecoveryAdmin {
1424         s.losslessTurnOffTimestamp = block.timestamp + s.timelockPeriod;
1425         s.isLosslessTurnOffProposed = true;
1426         emit LosslessTurnOffProposed(s.losslessTurnOffTimestamp);
1427     }
1428 
1429     function executeLosslessTurnOff() external onlyRecoveryAdmin {
1430         require(s.isLosslessTurnOffProposed, "LTNP");
1431         require(s.losslessTurnOffTimestamp <= block.timestamp, "LTL");
1432         s.isLosslessOn = false;
1433         s.isLosslessTurnOffProposed = false;
1434         emit LosslessTurnedOff();
1435     }
1436 
1437     function executeLosslessTurnOn() external onlyRecoveryAdmin {
1438         s.isLosslessTurnOffProposed = false;
1439         s.isLosslessOn = true;
1440         emit LosslessTurnedOn();
1441     }
1442 }
1443 
1444 
1445 // File contracts/facets/Multicall.sol
1446 
1447 // 
1448 // ALL RIGHTS RESERVED
1449 
1450 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1451 
1452 
1453 contract MulticallFacet is Ownable {
1454     Storage internal s;
1455 
1456     event UpdatedSettings(TaxSettings _updatedSettings);
1457     event UpdatedLockedSettings(TaxSettings _updatedLocks);
1458     event UpdatedCustomTaxes(CustomTax[] _customTaxes);
1459     event UpdatedTaxFees(Fees _updatedFees);
1460     event UpdatedTransactionTaxAddress(address _newAddress);
1461     event UpdatedMaxBalanceAfterBuy(uint256 _newMaxBalance);
1462     event UpdatedBuyBackWalletThreshold(uint256 _newThreshold);
1463     event UpdatedLPWalletThreshold(uint256 _newThreshold);
1464     event UpdatedAntiBotIncrement(uint256 _updatedIncrement);
1465     event UpdatedAntiBotEndDate(uint256 _updatedEndDate);
1466     event UpdatedAntiBotInitialMaxHold(uint256 _updatedInitialMaxHold);
1467     event UpdatedAntiBotActiveStatus(bool _isActive);
1468     event UpdatedSwapWhitelistingEndDate(uint256 _updatedEndDate);
1469     event UpdatedSwapWhitelistingActiveStatus(bool _isActive);
1470 
1471     struct MulticallAdminUpdateParams {
1472         TaxSettings _taxSettings;
1473         TaxSettings _lockSettings;
1474         CustomTax[] _customTaxes;
1475         Fees _fees;
1476         address _transactionTaxWallet;
1477         uint256 _maxBalanceAfterBuy;
1478         uint256 _lpWalletThreshold;
1479         uint256 _buyBackWalletThreshold;
1480     }
1481 
1482     function multicallAdminUpdate(MulticallAdminUpdateParams calldata params) public onlyOwner {
1483         // Tax Settings
1484         if(!s.isLocked.transactionTax && s.taxSettings.transactionTax != params._taxSettings.transactionTax) {
1485             s.taxSettings.transactionTax = params._taxSettings.transactionTax;
1486         }
1487         if(!s.isLocked.holderTax && s.taxSettings.holderTax != params._taxSettings.holderTax && !params._taxSettings.canMint) {
1488             s.taxSettings.holderTax = params._taxSettings.holderTax;
1489         }
1490         if(!s.isLocked.buyBackTax && s.taxSettings.buyBackTax != params._taxSettings.buyBackTax) {
1491             s.taxSettings.buyBackTax = params._taxSettings.buyBackTax;
1492         }
1493         if(!s.isLocked.lpTax && s.taxSettings.lpTax != params._taxSettings.lpTax) {
1494             s.taxSettings.lpTax = params._taxSettings.lpTax;
1495         }
1496         if(!s.isLocked.canMint && s.taxSettings.canMint != params._taxSettings.canMint && !s.taxSettings.holderTax) {
1497             s.taxSettings.canMint = params._taxSettings.canMint;
1498         }
1499         if(!s.isLocked.canPause && s.taxSettings.canPause != params._taxSettings.canPause) {
1500             s.taxSettings.canPause = params._taxSettings.canPause;
1501         }
1502         if(!s.isLocked.canBlacklist && s.taxSettings.canBlacklist != params._taxSettings.canBlacklist) {
1503             s.taxSettings.canBlacklist = params._taxSettings.canBlacklist;
1504         }
1505         if(!s.isLocked.maxBalanceAfterBuy && s.taxSettings.maxBalanceAfterBuy != params._taxSettings.maxBalanceAfterBuy) {
1506             s.taxSettings.maxBalanceAfterBuy = params._taxSettings.maxBalanceAfterBuy;
1507         }
1508         emit UpdatedSettings(s.taxSettings);
1509 
1510 
1511         // Lock Settings
1512         if(!s.isLocked.transactionTax) {
1513             s.isLocked.transactionTax = params._lockSettings.transactionTax;
1514         }
1515         if(!s.isLocked.holderTax) {
1516             s.isLocked.holderTax = params._lockSettings.holderTax;
1517         }
1518         if(!s.isLocked.buyBackTax) {
1519             s.isLocked.buyBackTax = params._lockSettings.buyBackTax;
1520         }
1521         if(!s.isLocked.lpTax) {
1522             s.isLocked.lpTax = params._lockSettings.lpTax;
1523         }
1524         if(!s.isLocked.canMint) {
1525             s.isLocked.canMint = params._lockSettings.canMint;
1526         }
1527         if(!s.isLocked.canPause) {
1528             s.isLocked.canPause = params._lockSettings.canPause;
1529         }
1530         if(!s.isLocked.canBlacklist) {
1531             s.isLocked.canBlacklist = params._lockSettings.canBlacklist;
1532         }
1533         if(!s.isLocked.maxBalanceAfterBuy) {
1534             s.isLocked.maxBalanceAfterBuy = params._lockSettings.maxBalanceAfterBuy;
1535         }
1536         emit UpdatedLockedSettings(s.isLocked);
1537 
1538 
1539         // Custom Taxes
1540         require(params._customTaxes.length < s.MaxCustom + 1, "MCT");
1541         delete s.customTaxes;
1542 
1543         for(uint i = 0; i < params._customTaxes.length; i++) {
1544             require(params._customTaxes[i].wallet != address(0), "ZA");
1545             s.customTaxes.push(params._customTaxes[i]);
1546         }
1547         s.customTaxLength = params._customTaxes.length;
1548         emit UpdatedCustomTaxes(params._customTaxes);
1549 
1550         // Fees        
1551         s.fees.transactionTax.buy = params._fees.transactionTax.buy;
1552         s.fees.transactionTax.sell = params._fees.transactionTax.sell;
1553 
1554         s.fees.buyBackTax = params._fees.buyBackTax;
1555 
1556         s.fees.holderTax = params._fees.holderTax;
1557 
1558         s.fees.lpTax = params._fees.lpTax;
1559 
1560         require(checkMaxTax(true), "BF");
1561         require(checkMaxTax(false), "SF");
1562         emit UpdatedTaxFees(params._fees);
1563         
1564         // transactionTax address
1565         require(params._transactionTaxWallet != address(0), "ZA");
1566         s.transactionTaxWallet = params._transactionTaxWallet;
1567         emit UpdatedTransactionTaxAddress(params._transactionTaxWallet);
1568 
1569         // maxBalanceAfterBuy
1570         if(s.taxSettings.maxBalanceAfterBuy) {
1571             s.maxBalanceAfterBuy = params._maxBalanceAfterBuy;
1572             emit UpdatedMaxBalanceAfterBuy(params._maxBalanceAfterBuy);
1573         }
1574 
1575         // update wallet thresholds
1576         ILPWallet(s.lpWallet).updateThreshold(params._lpWalletThreshold);
1577         emit UpdatedLPWalletThreshold(params._lpWalletThreshold);
1578 
1579         IBuyBackWallet(s.buyBackWallet).updateThreshold(params._buyBackWalletThreshold);
1580         emit UpdatedBuyBackWalletThreshold(params._buyBackWalletThreshold);
1581     }
1582 
1583     function checkMaxTax(bool isBuy) internal view returns (bool) {
1584         uint256 totalTaxes;
1585         if(isBuy) {
1586             totalTaxes += s.fees.transactionTax.buy;
1587             totalTaxes += s.fees.holderTax;
1588             for(uint i = 0; i < s.customTaxes.length; i++) {
1589                 totalTaxes += s.customTaxes[i].fee.buy;
1590             }
1591         } else {
1592             totalTaxes += s.fees.transactionTax.sell;
1593             totalTaxes += s.fees.lpTax;
1594             totalTaxes += s.fees.holderTax;
1595             totalTaxes += s.fees.buyBackTax;
1596             for(uint i = 0; i < s.customTaxes.length; i++) {
1597                 totalTaxes += s.customTaxes[i].fee.sell;
1598             }
1599         }
1600         if(totalTaxes <= s.MaxTax) {
1601             return true;
1602         }
1603         return false;
1604     }
1605 
1606     struct AntiBotUpdateParams {
1607         AntiBotSettings _antiBotSettings;
1608         SwapWhitelistingSettings _swapWhitelistingSettings;
1609     }
1610 
1611     // Multicall AntiBot Update
1612     function multicallAntiBotUpdate(AntiBotUpdateParams calldata params) public onlyOwner {
1613         // AntiBot
1614         s.antiBotSettings.increment = params._antiBotSettings.increment;
1615         emit UpdatedAntiBotIncrement(s.antiBotSettings.increment);
1616 
1617         require(params._antiBotSettings.endDate <= 48, "ED");
1618         s.antiBotSettings.endDate = params._antiBotSettings.endDate;
1619         emit UpdatedAntiBotEndDate(s.antiBotSettings.endDate);
1620 
1621         s.antiBotSettings.initialMaxHold = params._antiBotSettings.initialMaxHold;
1622         emit UpdatedAntiBotInitialMaxHold(s.antiBotSettings.initialMaxHold);
1623 
1624         if(!s.marketInit) {
1625             s.antiBotSettings.isActive = params._antiBotSettings.isActive;
1626             emit UpdatedAntiBotActiveStatus(s.antiBotSettings.isActive);
1627         }
1628 
1629         // SwapWhitelisting
1630         require(params._swapWhitelistingSettings.endDate <= 48, "ED");
1631         s.swapWhitelistingSettings.endDate = params._swapWhitelistingSettings.endDate;
1632         emit UpdatedSwapWhitelistingEndDate(s.antiBotSettings.endDate);
1633 
1634         if(!s.marketInit) {
1635             s.swapWhitelistingSettings.isActive = params._swapWhitelistingSettings.isActive;
1636             emit UpdatedSwapWhitelistingActiveStatus(s.swapWhitelistingSettings.isActive);
1637         }
1638     }
1639 }
1640 
1641 
1642 // File contracts/interfaces/IFeeHelper.sol
1643 
1644 // 
1645 // ALL RIGHTS RESERVED
1646 
1647 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1648 
1649 
1650 
1651 interface IFeeHelper {
1652     function getFee() view external returns(uint256);
1653     
1654     function getFeeDenominator() view external returns(uint256);
1655     
1656     function setFee(uint _fee) external;
1657     
1658     function getFeeAddress() view external returns(address);
1659     
1660     function setFeeAddress(address payable _feeAddress) external;
1661 
1662     function getGeneratorFee() view external returns(uint256);
1663 
1664     function setGeneratorFee(uint256 _fee) external;
1665 }
1666 
1667 
1668 // File contracts/LPWallet.sol
1669 
1670 // 
1671 // ALL RIGHTS RESERVED
1672 
1673 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1674 
1675 
1676 
1677 contract LPWallet is Ownable{
1678 
1679     ITaxToken public token;
1680     IMintFactory public factory;
1681     uint256 private threshold;
1682 
1683     event UpdatedThreshold(uint256 _newThreshold);
1684     event ETHtoTaxHelper(uint256 amount);
1685     event TransferBalancetoTaxHelper(uint256 tokenBalance);
1686 
1687     constructor(address _factory, address _token, uint256 _newThreshold) {
1688         token = ITaxToken(_token);
1689         factory = IMintFactory(_factory);
1690         threshold = _newThreshold;
1691         emit UpdatedThreshold(_newThreshold);
1692         transferOwnership(_token);
1693     }
1694     
1695     function checkLPTrigger() public view returns (bool) {
1696         return address(this).balance > threshold;
1697     }
1698 
1699     function getBalance() public view returns (uint256) {
1700         return address(this).balance;
1701     }
1702 
1703     function sendEthToTaxHelper() external returns (uint256) {
1704         uint index = token.taxHelperIndex();
1705         require(msg.sender == factory.getTaxHelperAddress(index), "RA");
1706         uint256 amount = address(this).balance;
1707         (bool sent,) = msg.sender.call{value: amount}("");
1708         require(sent, "Failed to send Ether");
1709         emit ETHtoTaxHelper(amount);
1710         return amount;
1711     }
1712 
1713     function transferBalanceToTaxHelper() external {
1714         uint index = token.taxHelperIndex();
1715         require(msg.sender == factory.getTaxHelperAddress(index));
1716         uint256 tokenBalance = token.balanceOf(address(this));
1717         token.transfer(msg.sender, tokenBalance);
1718         emit TransferBalancetoTaxHelper(tokenBalance);
1719     }
1720 
1721     function updateThreshold(uint256 _newThreshold) external onlyOwner {
1722         threshold = _newThreshold;
1723         emit UpdatedThreshold(_newThreshold);
1724     }
1725 
1726     function getThreshold() external view returns (uint256) {
1727         return threshold;
1728     }
1729 
1730     receive() payable external {
1731     }
1732 
1733 
1734 }
1735 
1736 
1737 // File contracts/facets/Settings.sol
1738 
1739 // 
1740 // ALL RIGHTS RESERVED
1741 
1742 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
1743 
1744 
1745 contract SettingsFacet is Ownable {
1746     Storage internal s;
1747 
1748     event AddedLPToken(address _newLPToken);
1749     event RemovedLPToken(address _lpToken);
1750     event AddedBlacklistAddress(address _address);
1751     event RemovedBlacklistAddress(address _address);
1752     event ToggledPause(bool _isPaused);
1753     event UpdatedCustomTaxes(CustomTax[] _customTaxes);
1754     event UpdatedTaxFees(Fees _updatedFees);
1755     event UpdatedTransactionTaxAddress(address _newAddress);
1756     event UpdatedLockedSettings(TaxSettings _updatedLocks);
1757     event UpdatedSettings(TaxSettings _updatedSettings);
1758     event UpdatedPairAddress(address _newPairAddress);
1759     event UpdatedTaxHelperIndex(uint _newIndex);
1760     event AddedTaxWhitelistAddress(address _address);   
1761     event RemovedTaxWhitelistAddress(address _address);
1762 
1763     function canBlacklistRequire() internal view {
1764         require(s.taxSettings.canBlacklist, "NB");
1765     }
1766 
1767     modifier canBlacklist {
1768         canBlacklistRequire();
1769         _;
1770     }
1771 
1772     function addLPToken(address _newLPToken) public onlyOwner {
1773         s.lpTokens[_newLPToken] = true;
1774         emit AddedLPToken(_newLPToken);
1775     }
1776 
1777     function removeLPToken(address _lpToken) public onlyOwner {
1778         s.lpTokens[_lpToken] = false;
1779         emit RemovedLPToken(_lpToken);
1780     }
1781 
1782     function checkMaxTax(bool isBuy) internal view returns (bool) {
1783         uint256 totalTaxes;
1784         if(isBuy) {
1785             totalTaxes += s.fees.transactionTax.buy;
1786             totalTaxes += s.fees.holderTax;
1787             for(uint i = 0; i < s.customTaxes.length; i++) {
1788                 totalTaxes += s.customTaxes[i].fee.buy;
1789             }
1790         } else {
1791             totalTaxes += s.fees.transactionTax.sell;
1792             totalTaxes += s.fees.lpTax;
1793             totalTaxes += s.fees.holderTax;
1794             totalTaxes += s.fees.buyBackTax;
1795             for(uint i = 0; i < s.customTaxes.length; i++) {
1796                 totalTaxes += s.customTaxes[i].fee.sell;
1797             }
1798         }
1799         if(totalTaxes <= s.MaxTax) {
1800             return true;
1801         }
1802         return false;
1803     }
1804 
1805     function paused() public view returns (bool) {
1806         if(s.taxSettings.canPause == false) {
1807             return false;
1808         }
1809         return s.isPaused;
1810     }
1811 
1812     function togglePause() public onlyOwner returns (bool) {
1813         require(s.taxSettings.canPause, "NP");
1814         s.isPaused = !s.isPaused;
1815         emit ToggledPause(s.isPaused);
1816         return s.isPaused;
1817     }
1818 
1819     function addBlacklistedAddress(address _address) public onlyOwner canBlacklist {
1820         IFeeHelper feeHelper = IFeeHelper(IMintFactory(s.factory).getFeeHelper());
1821         address feeAddress = feeHelper.getFeeAddress();
1822         require(_address != feeAddress);
1823         s.blacklist[_address] = true;
1824         emit AddedBlacklistAddress(_address);
1825     }
1826 
1827     function removeBlacklistedAddress(address _address) public onlyOwner canBlacklist {
1828         s.blacklist[_address] = false;
1829         emit RemovedBlacklistAddress(_address);
1830     }
1831 
1832     function updateBlacklistBatch(address[] calldata _updatedAddresses, bool _isBlacklisted) public onlyOwner canBlacklist {
1833         IFeeHelper feeHelper = IFeeHelper(IMintFactory(s.factory).getFeeHelper());
1834         address feeAddress = feeHelper.getFeeAddress();
1835         for(uint i = 0; i < _updatedAddresses.length; i++) {
1836             if(_updatedAddresses[i] != feeAddress) {
1837                 s.blacklist[_updatedAddresses[i]] = _isBlacklisted;
1838                 if(_isBlacklisted) {
1839                     emit AddedBlacklistAddress(_updatedAddresses[i]);
1840                 } else {
1841                     emit RemovedBlacklistAddress(_updatedAddresses[i]);
1842                 }
1843             }
1844         }
1845     }
1846 
1847     function isBlacklisted(address _address) public view returns (bool) {
1848         return s.blacklist[_address];
1849     }
1850 
1851     function updateCustomTaxes(CustomTax[] calldata _customTaxes) public onlyOwner {
1852         require(_customTaxes.length < s.MaxCustom + 1, "MCT");
1853         delete s.customTaxes;
1854 
1855         for(uint i = 0; i < _customTaxes.length; i++) {
1856             require(_customTaxes[i].wallet != address(0));
1857             s.customTaxes.push(_customTaxes[i]);
1858         }
1859         s.customTaxLength = _customTaxes.length;
1860 
1861         require(checkMaxTax(true), "BF");
1862         require(checkMaxTax(false), "SF");
1863         emit UpdatedCustomTaxes(_customTaxes);
1864     }
1865 
1866     function updateTaxFees(Fees calldata _updatedFees) public onlyOwner {
1867         s.fees.transactionTax.buy = _updatedFees.transactionTax.buy;
1868         s.fees.transactionTax.sell = _updatedFees.transactionTax.sell;
1869 
1870         s.fees.buyBackTax = _updatedFees.buyBackTax;
1871 
1872         s.fees.holderTax = _updatedFees.holderTax;
1873 
1874         s.fees.lpTax = _updatedFees.lpTax;
1875 
1876         require(checkMaxTax(true), "BF");
1877         require(checkMaxTax(false), "SF");
1878         emit UpdatedTaxFees(_updatedFees);
1879     }
1880 
1881     function updateTransactionTaxAddress(address _newAddress) public onlyOwner {
1882         // confirm if this is updateable
1883         require(_newAddress != address(0));
1884         s.transactionTaxWallet = _newAddress;
1885         emit UpdatedTransactionTaxAddress(_newAddress);
1886     }
1887 
1888     function lockSettings(TaxSettings calldata _updatedLocks) public onlyOwner {
1889         if(!s.isLocked.transactionTax) {
1890             s.isLocked.transactionTax = _updatedLocks.transactionTax;
1891         }
1892         if(!s.isLocked.holderTax) {
1893             s.isLocked.holderTax = _updatedLocks.holderTax;
1894         }
1895         if(!s.isLocked.buyBackTax) {
1896             s.isLocked.buyBackTax = _updatedLocks.buyBackTax;
1897         }
1898         if(!s.isLocked.lpTax) {
1899             s.isLocked.lpTax = _updatedLocks.lpTax;
1900         }
1901         if(!s.isLocked.canMint) {
1902             s.isLocked.canMint = _updatedLocks.canMint;
1903         }
1904         if(!s.isLocked.canPause) {
1905             s.isLocked.canPause = _updatedLocks.canPause;
1906         }
1907         if(!s.isLocked.canBlacklist) {
1908             s.isLocked.canBlacklist = _updatedLocks.canBlacklist;
1909         }
1910         if(!s.isLocked.maxBalanceAfterBuy) {
1911             s.isLocked.maxBalanceAfterBuy = _updatedLocks.maxBalanceAfterBuy;
1912         }
1913         emit UpdatedLockedSettings(s.isLocked);
1914     }
1915 
1916     function updateSettings(TaxSettings calldata _updatedSettings) public onlyOwner {
1917         if(!s.isLocked.transactionTax && s.taxSettings.transactionTax != _updatedSettings.transactionTax) {
1918             s.taxSettings.transactionTax = _updatedSettings.transactionTax;
1919         }
1920         if(!s.isLocked.holderTax && s.taxSettings.holderTax != _updatedSettings.holderTax && !_updatedSettings.canMint) {
1921             s.taxSettings.holderTax = _updatedSettings.holderTax;
1922         }
1923         if(!s.isLocked.buyBackTax && s.taxSettings.buyBackTax != _updatedSettings.buyBackTax) {
1924             s.taxSettings.buyBackTax = _updatedSettings.buyBackTax;
1925         }
1926         if(!s.isLocked.lpTax && s.taxSettings.lpTax != _updatedSettings.lpTax) {
1927             s.taxSettings.lpTax = _updatedSettings.lpTax;
1928         }
1929         if(!s.isLocked.canMint && s.taxSettings.canMint != _updatedSettings.canMint && !s.taxSettings.holderTax) {
1930             s.taxSettings.canMint = _updatedSettings.canMint;
1931         }
1932         if(!s.isLocked.canPause && s.taxSettings.canPause != _updatedSettings.canPause) {
1933             s.taxSettings.canPause = _updatedSettings.canPause;
1934         }
1935         if(!s.isLocked.canBlacklist && s.taxSettings.canBlacklist != _updatedSettings.canBlacklist) {
1936             s.taxSettings.canBlacklist = _updatedSettings.canBlacklist;
1937         }
1938         if(!s.isLocked.maxBalanceAfterBuy && s.taxSettings.maxBalanceAfterBuy != _updatedSettings.maxBalanceAfterBuy) {
1939             s.taxSettings.maxBalanceAfterBuy = _updatedSettings.maxBalanceAfterBuy;
1940         }
1941         emit UpdatedSettings(s.taxSettings);
1942     }
1943 
1944     function updatePairAddress(address _newPairAddress) public onlyOwner {
1945         s.pairAddress = _newPairAddress;
1946         s.lpTokens[_newPairAddress] = true;
1947         emit AddedLPToken(_newPairAddress);
1948         emit UpdatedPairAddress(_newPairAddress);
1949     }
1950 
1951     function updateTaxHelperIndex(uint8 _newIndex) public onlyOwner {
1952         s.taxHelperIndex = _newIndex;
1953         emit UpdatedTaxHelperIndex(_newIndex);
1954     }
1955 
1956     function addTaxWhitelistedAddress(address _address) public onlyOwner {
1957         s.taxWhitelist[_address] = true;
1958         emit AddedTaxWhitelistAddress(_address);
1959     }
1960 
1961     function removeTaxWhitelistedAddress(address _address) public onlyOwner {
1962         s.taxWhitelist[_address] = false;
1963         emit RemovedTaxWhitelistAddress(_address);
1964     }
1965 
1966     function updateTaxWhitelistBatch(address[] calldata _updatedAddresses, bool _isTaxWhitelisted) public onlyOwner {
1967         for(uint i = 0; i < _updatedAddresses.length; i++) {
1968             s.taxWhitelist[_updatedAddresses[i]] = _isTaxWhitelisted;
1969             if(_isTaxWhitelisted) {
1970                 emit AddedTaxWhitelistAddress(_updatedAddresses[i]);
1971             } else {
1972                 emit RemovedTaxWhitelistAddress(_updatedAddresses[i]);
1973             }
1974         }
1975     }
1976 }
1977 
1978 
1979 // File contracts/libraries/FullMath.sol
1980 
1981 // 
1982 
1983 
1984 /// @title Contains 512-bit math functions
1985 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1986 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1987 library FullMath {
1988    /// @notice Calculates floor(a├ùb├╖denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1989 /// @param a The multiplicand
1990 /// @param b The multiplier
1991 /// @param denominator The divisor
1992 /// @return result The 256-bit result
1993 /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1994 function mulDiv(
1995     uint256 a,
1996     uint256 b,
1997     uint256 denominator
1998 ) internal pure returns (uint256 result) {
1999     // 512-bit multiply [prod1 prod0] = a * b
2000     // Compute the product mod 2**256 and mod 2**256 - 1
2001     // then use the Chinese Remainder Theorem to reconstruct
2002     // the 512 bit result. The result is stored in two 256
2003     // variables such that product = prod1 * 2**256 + prod0
2004     uint256 prod0; // Least significant 256 bits of the product
2005     uint256 prod1; // Most significant 256 bits of the product
2006     assembly {
2007         let mm := mulmod(a, b, not(0))
2008         prod0 := mul(a, b)
2009         prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2010     }
2011 
2012     // Handle non-overflow cases, 256 by 256 division
2013     if (prod1 == 0) {
2014         require(denominator > 0);
2015         assembly {
2016             result := div(prod0, denominator)
2017         }
2018         return result;
2019     }
2020 
2021     // Make sure the result is less than 2**256.
2022     // Also prevents denominator == 0
2023     require(denominator > prod1);
2024 
2025     ///////////////////////////////////////////////
2026     // 512 by 256 division.
2027     ///////////////////////////////////////////////
2028 
2029     // Make division exact by subtracting the remainder from [prod1 prod0]
2030     // Compute remainder using mulmod
2031     uint256 remainder;
2032     assembly {
2033         remainder := mulmod(a, b, denominator)
2034     }
2035     // Subtract 256 bit number from 512 bit number
2036     assembly {
2037         prod1 := sub(prod1, gt(remainder, prod0))
2038         prod0 := sub(prod0, remainder)
2039     }
2040 
2041     // Factor powers of two out of denominator
2042     // Compute largest power of two divisor of denominator.
2043     // Always >= 1.
2044     unchecked {
2045         uint256 twos = (type(uint256).max - denominator + 1) & denominator;
2046         // Divide denominator by power of two
2047         assembly {
2048             denominator := div(denominator, twos)
2049         }
2050 
2051         // Divide [prod1 prod0] by the factors of two
2052         assembly {
2053             prod0 := div(prod0, twos)
2054         }
2055         // Shift in bits from prod1 into prod0. For this we need
2056         // to flip `twos` such that it is 2**256 / twos.
2057         // If twos is zero, then it becomes one
2058         assembly {
2059             twos := add(div(sub(0, twos), twos), 1)
2060         }
2061         prod0 |= prod1 * twos;
2062 
2063         // Invert denominator mod 2**256
2064         // Now that denominator is an odd number, it has an inverse
2065         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
2066         // Compute the inverse by starting with a seed that is correct
2067         // correct for four bits. That is, denominator * inv = 1 mod 2**4
2068         uint256 inv = (3 * denominator) ^ 2;
2069         // Now use Newton-Raphson iteration to improve the precision.
2070         // Thanks to Hensel's lifting lemma, this also works in modular
2071         // arithmetic, doubling the correct bits in each step.
2072         inv *= 2 - denominator * inv; // inverse mod 2**8
2073         inv *= 2 - denominator * inv; // inverse mod 2**16
2074         inv *= 2 - denominator * inv; // inverse mod 2**32
2075         inv *= 2 - denominator * inv; // inverse mod 2**64
2076         inv *= 2 - denominator * inv; // inverse mod 2**128
2077         inv *= 2 - denominator * inv; // inverse mod 2**256
2078 
2079         // Because the division is now exact we can divide by multiplying
2080         // with the modular inverse of denominator. This will give us the
2081         // correct result modulo 2**256. Since the precoditions guarantee
2082         // that the outcome is less than 2**256, this is the final result.
2083         // We don't need to compute the high bits of the result and prod1
2084         // is no longer required.
2085         result = prod0 * inv;
2086         return result;
2087         }
2088     }
2089 
2090     /// @notice Calculates ceil(a├ùb├╖denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2091     /// @param a The multiplicand
2092     /// @param b The multiplier
2093     /// @param denominator The divisor
2094     /// @return result The 256-bit result
2095     function mulDivRoundingUp(
2096         uint256 a,
2097         uint256 b,
2098         uint256 denominator
2099     ) internal pure returns (uint256 result) {
2100         result = mulDiv(a, b, denominator);
2101         if (mulmod(a, b, denominator) > 0) {
2102             require(result < type(uint256).max);
2103             result++;
2104         }
2105     }
2106 }
2107 
2108 
2109 // File contracts/facets/Tax.sol
2110 
2111 // 
2112 // ALL RIGHTS RESERVED
2113 
2114 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
2115 
2116 // This contract logs all tokens on the platform
2117 
2118 
2119 contract TaxFacet is Ownable {
2120     Storage internal s;
2121 
2122     event MarketInit(uint256 timestamp, uint256 blockNumber);
2123     event BuyBackTaxInitiated(address _sender, uint256 _fee, address _wallet, bool _isBuy);
2124     event TransactionTaxInitiated(address _sender, uint256 _fee, address _wallet, bool _isBuy);
2125     event LPTaxInitiated(address _sender, uint256 _fee, address _wallet, bool _isBuy);
2126     event CustomTaxInitiated(address _sender, uint256 _fee, address _wallet, bool _isBuy);
2127     event Transfer(address indexed from, address indexed to, uint256 value);
2128     event Reflect(uint256 tAmount, uint256 rAmount, uint256 rTotal_, uint256 teeTotal_);
2129     event ExcludedAccount(address account);
2130     event IncludedAccount(address account);
2131 
2132     function paused() internal view returns (bool) {
2133         return s.isPaused;
2134     }
2135 
2136     function isBlacklisted(address _address) internal view returns (bool) {
2137         return s.blacklist[_address];
2138     }
2139 
2140     /// @notice Handles the taxes for the token.
2141     /// Calls the appropriate tax helper contract to handle 
2142     /// LP and BuyBack tax logic
2143     /// @dev handles every tax within the tax facet. 
2144     /// @param sender the one sending the transaction
2145     /// @param recipient the one receiving the transaction
2146     /// @param amount the amount of tokens being sent
2147     /// @return totalTaxAmount the total amount of the token taxed
2148     function handleTaxes(address sender, address recipient, uint256 amount) public virtual returns (uint256 totalTaxAmount) {
2149         // restrict it to being only called by registered tokens
2150         require(IMintFactory(s.factory).tokenIsRegistered(address(this)));
2151         bool isBuy = false;
2152 
2153         if(s.lpTokens[sender]) {
2154             isBuy = true;
2155             if(!s.marketInit) {
2156                 s.marketInit = true;
2157                 s.antiBotSettings.startBlock = block.number;
2158                 s.marketInitBlockTime = block.timestamp;
2159                 emit MarketInit(block.timestamp, block.number);
2160             }
2161         }
2162 
2163         if(!s.lpTokens[sender] && !s.lpTokens[recipient]) {
2164             return 0;
2165         }
2166 
2167         if(isBuy && s.taxWhitelist[recipient]) {
2168             return 0;
2169         }
2170 
2171         if(!isBuy && s.taxWhitelist[sender]) {
2172             return 0;
2173         }
2174 
2175         ITaxHelper TaxHelper = ITaxHelper(IMintFactory(s.factory).getTaxHelperAddress(s.taxHelperIndex));
2176         if(sender == address(TaxHelper) || recipient == address(TaxHelper)) {
2177             return 0;
2178         }
2179         totalTaxAmount;
2180         uint256 fee;
2181         if(s.taxSettings.buyBackTax && !isBuy) {
2182             if(TaxHelper.lpTokenHasReserves(s.pairAddress)) {
2183                 fee = amount * s.fees.buyBackTax / s.DENOMINATOR;
2184             }
2185             
2186             if(fee != 0) {
2187                 _transfer(sender, address(TaxHelper), fee);
2188 
2189                 TaxHelper.initiateBuyBackTax(address(this), address(s.buyBackWallet));
2190                 emit BuyBackTaxInitiated(sender, fee, address(s.buyBackWallet), isBuy);
2191                 totalTaxAmount += fee;
2192             }
2193             fee = 0;
2194         }
2195         if(s.taxSettings.transactionTax) {
2196             if(isBuy) {
2197                 fee = amount * s.fees.transactionTax.buy / s.DENOMINATOR;
2198             } else {
2199                 fee = amount * s.fees.transactionTax.sell / s.DENOMINATOR;
2200             }
2201             if(fee != 0) {
2202                 _transfer(sender, s.transactionTaxWallet, fee);
2203                 emit TransactionTaxInitiated(sender, fee, s.transactionTaxWallet, isBuy);
2204                 totalTaxAmount += fee;
2205             }
2206             fee = 0;
2207         }
2208         if(s.taxSettings.lpTax && !isBuy) {
2209             if(TaxHelper.lpTokenHasReserves(s.pairAddress)) {
2210                 fee = amount * s.fees.lpTax / s.DENOMINATOR;
2211             }
2212             if(fee != 0) {
2213                 _transfer(sender, address(TaxHelper), fee);
2214                 TaxHelper.initiateLPTokenTax(address(this), address(s.lpWallet));
2215                 emit LPTaxInitiated(sender, fee, address(s.lpWallet), isBuy);
2216                 totalTaxAmount += fee;
2217             }
2218             fee = 0;
2219         }
2220         if(s.customTaxes.length > 0) {
2221             for(uint8 i = 0; i < s.customTaxes.length; i++) {
2222                 uint256 customFee;
2223                 if(isBuy) {
2224                     customFee = amount * s.customTaxes[i].fee.buy / s.DENOMINATOR;
2225                 } else {
2226                     customFee = amount * s.customTaxes[i].fee.sell / s.DENOMINATOR;
2227                 }
2228                 fee += customFee;
2229                 if(fee != 0) {
2230                     totalTaxAmount += fee;
2231                     _transfer(sender, s.customTaxes[i].wallet, fee);
2232                     emit CustomTaxInitiated(sender, fee, s.customTaxes[i].wallet, isBuy);
2233                     fee = 0;
2234                 }
2235             }
2236         }    
2237     }
2238 
2239     /// @notice internal transfer method
2240     /// @dev includes checks for all features not handled by handleTaxes()
2241     /// @param sender the one sending the transaction
2242     /// @param recipient the one receiving the transaction
2243     /// @param amount the amount of tokens being sent
2244     function _transfer(address sender, address recipient, uint256 amount) public {
2245         // restrict it to being only called by registered tokens
2246         if(!IMintFactory(s.factory).tokenGeneratorIsAllowed(msg.sender)) {
2247             require(IMintFactory(s.factory).tokenIsRegistered(address(this)));
2248         }
2249         require(sender != address(0), "ETFZ");
2250         require(recipient != address(0), "ETTZ");
2251         require(amount > 0, "TGZ");
2252         require(!paused(), "TP");
2253         require(!isBlacklisted(sender), "SB");
2254         require(!isBlacklisted(recipient), "RB"); 
2255         require(!isBlacklisted(tx.origin), "SB");
2256         // Reflection Transfers
2257         if(s.taxSettings.holderTax) {
2258             if (s._isExcluded[sender] && !s._isExcluded[recipient]) {
2259             _transferFromExcluded(sender, recipient, amount);
2260             } else if (!s._isExcluded[sender] && s._isExcluded[recipient]) {
2261                 _transferToExcluded(sender, recipient, amount);
2262             } else if (!s._isExcluded[sender] && !s._isExcluded[recipient]) {
2263                 _transferStandard(sender, recipient, amount);
2264             } else if (s._isExcluded[sender] && s._isExcluded[recipient]) {
2265                 _transferBothExcluded(sender, recipient, amount);
2266             } else {
2267                 _transferStandard(sender, recipient, amount);
2268             }
2269         } else {
2270             // Non Reflection Transfer
2271             _beforeTokenTransfer(sender, recipient, amount);
2272 
2273             uint256 senderBalance = s._tOwned[sender];
2274             require(senderBalance >= amount, "ETA");
2275             s._tOwned[sender] = senderBalance - amount;
2276             s._tOwned[recipient] += amount;
2277 
2278             emit Transfer(sender, recipient, amount);
2279         }
2280     }
2281 
2282     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2283 
2284 
2285     // Reflection Functions
2286 
2287 
2288     function reflect(uint256 tAmount) public {
2289         address sender = _msgSender();
2290         require(!s._isExcluded[sender], "EA");
2291         (uint256 rAmount,,,,) = _getValues(tAmount);
2292         s._rOwned[sender] = s._rOwned[sender] - rAmount;
2293         s._rTotal = s._rTotal - rAmount;
2294         s._tFeeTotal = s._tFeeTotal + tAmount;
2295         emit Reflect(tAmount, rAmount, s._rTotal, s._tFeeTotal);
2296         ITaxHelper TaxHelper = ITaxHelper(IMintFactory(s.factory).getTaxHelperAddress(s.taxHelperIndex));
2297         TaxHelper.sync(s.pairAddress);
2298     }
2299 
2300     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
2301         require(tAmount <= s._tTotal, "ALS");
2302         if (!deductTransferFee) {
2303             (uint256 rAmount,,,,) = _getValues(tAmount);
2304             return rAmount;
2305         } else {
2306             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
2307             return rTransferAmount;
2308         }
2309     }
2310 
2311     function tokenFromReflection(uint256 rAmount) public view returns(uint256)  {
2312         require(rAmount <= s._rTotal, "ALR");
2313         uint256 currentRate = _getRate();
2314         return rAmount / currentRate;
2315     }
2316 
2317     function excludeAccount(address account) external onlyOwner {
2318         require(!s._isExcluded[account], "AE");
2319         if(s._rOwned[account] > 0) {
2320             s._tOwned[account] = tokenFromReflection(s._rOwned[account]);
2321         }
2322         s._isExcluded[account] = true;
2323         s._excluded.push(account);
2324         emit ExcludedAccount(account);
2325     }
2326 
2327     function includeAccount(address account) external onlyOwner {
2328         require(s._isExcluded[account], "AI");
2329         for (uint256 i = 0; i < s._excluded.length; i++) {
2330             if (s._excluded[i] == account) {
2331                 s._excluded[i] = s._excluded[s._excluded.length - 1];
2332                 s._tOwned[account] = 0;
2333                 s._isExcluded[account] = false;
2334                 s._excluded.pop();
2335                 break;
2336             }
2337         }
2338         emit IncludedAccount(account);
2339     }
2340 
2341     function isExcluded(address account) external view returns(bool) {
2342         return s._isExcluded[account];
2343     }
2344 
2345     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
2346         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
2347         s._rOwned[sender] = s._rOwned[sender] - rAmount;
2348         s._rOwned[recipient] = s._rOwned[recipient] + rTransferAmount;    
2349         _reflectFee(rFee, tFee);
2350         emit Transfer(sender, recipient, tTransferAmount);
2351     }
2352 
2353     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
2354         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
2355         s._rOwned[sender] = s._rOwned[sender] - rAmount;
2356         s._tOwned[recipient] = s._tOwned[recipient] + tTransferAmount;
2357         s._rOwned[recipient] = s._rOwned[recipient] + rTransferAmount;           
2358         _reflectFee(rFee, tFee);
2359         emit Transfer(sender, recipient, tTransferAmount);
2360     }
2361 
2362     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
2363         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
2364         s._tOwned[sender] = s._tOwned[sender] - tAmount;
2365         s._rOwned[sender] = s._rOwned[sender] - rAmount;
2366         s._rOwned[recipient] = s._rOwned[recipient] + rTransferAmount;   
2367         _reflectFee(rFee, tFee);
2368         emit Transfer(sender, recipient, tTransferAmount);
2369     }
2370 
2371     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
2372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
2373         s._tOwned[sender] = s._tOwned[sender] - tAmount;
2374         s._rOwned[sender] = s._rOwned[sender] - rAmount;
2375         s._tOwned[recipient] = s._tOwned[recipient] + tTransferAmount;
2376         s._rOwned[recipient] = s._rOwned[recipient] + rTransferAmount;        
2377         _reflectFee(rFee, tFee);
2378         emit Transfer(sender, recipient, tTransferAmount);
2379     }
2380 
2381     function _reflectFee(uint256 rFee, uint256 tFee) private {
2382         s._rTotal = s._rTotal - rFee;
2383         s._tFeeTotal = s._tFeeTotal + tFee;
2384     }
2385 
2386     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
2387         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
2388         uint256 currentRate = _getRate();
2389         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
2390         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
2391     }
2392 
2393     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
2394         uint256 tFee = tAmount / s.fees.holderTax;
2395         uint256 tTransferAmount = tAmount - tFee;
2396         return (tTransferAmount, tFee);
2397     }
2398 
2399     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
2400         uint256 rAmount = tAmount * currentRate;
2401         uint256 rFee = tFee * currentRate;
2402         uint256 rTransferAmount = rAmount - rFee;
2403         return (rAmount, rTransferAmount, rFee);
2404     }
2405 
2406     function _getRate() private view returns(uint256) {
2407         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
2408         return rSupply / tSupply;
2409     }
2410 
2411     function _getCurrentSupply() private view returns(uint256, uint256) {
2412         uint256 rSupply = s._rTotal;
2413         uint256 tSupply = s._tTotal;      
2414         for (uint256 i = 0; i < s._excluded.length; i++) {
2415             if (s._rOwned[s._excluded[i]] > rSupply || s._tOwned[s._excluded[i]] > tSupply) return (s._rTotal, s._tTotal);
2416             rSupply = rSupply - s._rOwned[s._excluded[i]];
2417             tSupply = tSupply - s._tOwned[s._excluded[i]];
2418         }
2419         if (rSupply < s._rTotal / s._tTotal) return (s._rTotal, s._tTotal);
2420         return (rSupply, tSupply);
2421     }
2422 
2423     function burn(uint256 amount) public {
2424         address taxHelper = IMintFactory(s.factory).getTaxHelperAddress(s.taxHelperIndex);
2425         require(msg.sender == taxHelper || msg.sender == owner(), "RA");
2426         _burn(owner(), amount);
2427     }
2428 
2429     /// @notice custom burn to handle reflection
2430     function _burn(address account, uint256 amount) internal virtual {
2431         require(account != address(0), "EBZ");
2432 
2433         if (s.isLosslessOn) {
2434             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeBurn(account, amount);
2435         } 
2436 
2437         _beforeTokenTransfer(account, address(0), amount);
2438 
2439         if(s.taxSettings.holderTax && !s._isExcluded[account]) {
2440             (uint256 rAmount,,,,) = _getValues(amount);
2441             s._rOwned[account] = s._rOwned[account] - rAmount;
2442             s._rTotal = s._rTotal - rAmount;
2443             s._tFeeTotal = s._tFeeTotal + amount;
2444         }
2445 
2446         uint256 accountBalance = s._tOwned[account];
2447         require(accountBalance >= amount, "EBB");
2448         s._tOwned[account] = accountBalance - amount;
2449         s._tTotal -= amount;
2450 
2451         emit Transfer(account, address(0), amount);
2452     }
2453     
2454 }
2455 
2456 
2457 // File contracts/facets/Wallets.sol
2458 
2459 // 
2460 // ALL RIGHTS RESERVED
2461 
2462 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
2463 
2464 
2465 contract WalletsFacet is Ownable {
2466     Storage internal s;
2467 
2468     event CreatedBuyBackWallet(address _wallet);
2469     event CreatedLPWallet(address _wallet);
2470     event UpdatedBuyBackWalletThreshold(uint256 _newThreshold);
2471     event UpdatedLPWalletThreshold(uint256 _newThreshold);
2472 
2473     function createBuyBackWallet(address _factory, address _token, uint256 _newThreshold) external returns (address) {
2474         BuyBackWallet newBuyBackWallet = new BuyBackWallet(_factory, _token,_newThreshold);
2475         emit CreatedBuyBackWallet(address(newBuyBackWallet));
2476         return address(newBuyBackWallet);
2477     }
2478 
2479     function createLPWallet(address _factory, address _token, uint256 _newThreshold) external returns (address) {
2480         LPWallet newLPWallet = new LPWallet(_factory, _token, _newThreshold);
2481         emit CreatedLPWallet(address(newLPWallet));
2482         return address(newLPWallet);
2483     }
2484 
2485     function updateBuyBackWalletThreshold(uint256 _newThreshold) public onlyOwner {
2486         IBuyBackWallet(s.buyBackWallet).updateThreshold(_newThreshold);
2487         emit UpdatedBuyBackWalletThreshold(_newThreshold);
2488     }
2489 
2490     function updateLPWalletThreshold(uint256 _newThreshold) public onlyOwner {
2491         ILPWallet(s.lpWallet).updateThreshold(_newThreshold);
2492         emit UpdatedLPWalletThreshold(_newThreshold);
2493     }
2494 
2495 }
2496 
2497 
2498 // File contracts/FeeHelper.sol
2499 
2500 // 
2501 // ALL RIGHTS RESERVED
2502 
2503 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
2504 
2505 
2506 contract FeeHelper is Ownable{
2507     
2508     struct Settings {
2509         uint256 GENERATOR_FEE;
2510         uint256 FEE; 
2511         uint256 DENOMINATOR;
2512         address payable FEE_ADDRESS;
2513     }
2514     
2515     Settings public SETTINGS;
2516     
2517     constructor() {
2518         SETTINGS.GENERATOR_FEE = 0;
2519         SETTINGS.FEE = 100;
2520         SETTINGS.DENOMINATOR = 10000;
2521         SETTINGS.FEE_ADDRESS = payable(msg.sender);
2522     }
2523 
2524     function getGeneratorFee() external view returns(uint256) {
2525         return SETTINGS.GENERATOR_FEE;
2526     }
2527     
2528     function getFee() external view returns(uint256) {
2529         return SETTINGS.FEE;
2530     }
2531 
2532     function getFeeDenominator() external view returns(uint256) {
2533         return SETTINGS.DENOMINATOR;
2534     }
2535 
2536     function setGeneratorFee(uint256 _fee) external onlyOwner {
2537         SETTINGS.GENERATOR_FEE = _fee;
2538     }
2539     
2540     function setFee(uint _fee) external onlyOwner {
2541         SETTINGS.FEE = _fee;
2542     }
2543     
2544     function getFeeAddress() external view returns(address) {
2545         return SETTINGS.FEE_ADDRESS;
2546     }
2547     
2548     function setFeeAddress(address payable _feeAddress) external onlyOwner {
2549         SETTINGS.FEE_ADDRESS = _feeAddress;
2550     }
2551 }
2552 
2553 
2554 // File contracts/interfaces/IUniswapV2Router01.sol
2555 
2556 
2557 interface IUniswapV2Router01 {
2558     function factory() external pure returns (address);
2559     function WETH() external pure returns (address);
2560 
2561     function addLiquidity(
2562         address tokenA,
2563         address tokenB,
2564         uint amountADesired,
2565         uint amountBDesired,
2566         uint amountAMin,
2567         uint amountBMin,
2568         address to,
2569         uint deadline
2570     ) external returns (uint amountA, uint amountB, uint liquidity);
2571     function addLiquidityETH(
2572         address token,
2573         uint amountTokenDesired,
2574         uint amountTokenMin,
2575         uint amountETHMin,
2576         address to,
2577         uint deadline
2578     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
2579     function removeLiquidity(
2580         address tokenA,
2581         address tokenB,
2582         uint liquidity,
2583         uint amountAMin,
2584         uint amountBMin,
2585         address to,
2586         uint deadline
2587     ) external returns (uint amountA, uint amountB);
2588     function removeLiquidityETH(
2589         address token,
2590         uint liquidity,
2591         uint amountTokenMin,
2592         uint amountETHMin,
2593         address to,
2594         uint deadline
2595     ) external returns (uint amountToken, uint amountETH);
2596     function removeLiquidityWithPermit(
2597         address tokenA,
2598         address tokenB,
2599         uint liquidity,
2600         uint amountAMin,
2601         uint amountBMin,
2602         address to,
2603         uint deadline,
2604         bool approveMax, uint8 v, bytes32 r, bytes32 s
2605     ) external returns (uint amountA, uint amountB);
2606     function removeLiquidityETHWithPermit(
2607         address token,
2608         uint liquidity,
2609         uint amountTokenMin,
2610         uint amountETHMin,
2611         address to,
2612         uint deadline,
2613         bool approveMax, uint8 v, bytes32 r, bytes32 s
2614     ) external returns (uint amountToken, uint amountETH);
2615     function swapExactTokensForTokens(
2616         uint amountIn,
2617         uint amountOutMin,
2618         address[] calldata path,
2619         address to,
2620         uint deadline
2621     ) external returns (uint[] memory amounts);
2622     function swapTokensForExactTokens(
2623         uint amountOut,
2624         uint amountInMax,
2625         address[] calldata path,
2626         address to,
2627         uint deadline
2628     ) external returns (uint[] memory amounts);
2629     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
2630         external
2631         payable
2632         returns (uint[] memory amounts);
2633     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
2634         external
2635         returns (uint[] memory amounts);
2636     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
2637         external
2638         returns (uint[] memory amounts);
2639     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
2640         external
2641         payable
2642         returns (uint[] memory amounts);
2643 
2644     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
2645     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
2646     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
2647     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
2648     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
2649 }
2650 
2651 
2652 // File contracts/interfaces/ICamelotV2Router.sol
2653 
2654 
2655 interface ICamelotRouter is IUniswapV2Router01 {
2656   function removeLiquidityETHSupportingFeeOnTransferTokens(
2657     address token,
2658     uint liquidity,
2659     uint amountTokenMin,
2660     uint amountETHMin,
2661     address to,
2662     uint deadline
2663   ) external returns (uint amountETH);
2664 
2665   function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
2666     address token,
2667     uint liquidity,
2668     uint amountTokenMin,
2669     uint amountETHMin,
2670     address to,
2671     uint deadline,
2672     bool approveMax, uint8 v, bytes32 r, bytes32 s
2673   ) external returns (uint amountETH);
2674 
2675   function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2676     uint amountIn,
2677     uint amountOutMin,
2678     address[] calldata path,
2679     address to,
2680     address referrer,
2681     uint deadline
2682   ) external;
2683 
2684   function swapExactETHForTokensSupportingFeeOnTransferTokens(
2685     uint amountOutMin,
2686     address[] calldata path,
2687     address to,
2688     address referrer,
2689     uint deadline
2690   ) external payable;
2691 
2692   function swapExactTokensForETHSupportingFeeOnTransferTokens(
2693     uint amountIn,
2694     uint amountOutMin,
2695     address[] calldata path,
2696     address to,
2697     address referrer,
2698     uint deadline
2699   ) external;
2700 
2701 
2702 }
2703 
2704 
2705 // File contracts/interfaces/IUniswapV2Router02.sol
2706 
2707 interface IUniswapV2Router02 is IUniswapV2Router01 {
2708     function removeLiquidityETHSupportingFeeOnTransferTokens(
2709         address token,
2710         uint liquidity,
2711         uint amountTokenMin,
2712         uint amountETHMin,
2713         address to,
2714         uint deadline
2715     ) external returns (uint amountETH);
2716     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
2717         address token,
2718         uint liquidity,
2719         uint amountTokenMin,
2720         uint amountETHMin,
2721         address to,
2722         uint deadline,
2723         bool approveMax, uint8 v, bytes32 r, bytes32 s
2724     ) external returns (uint amountETH);
2725 
2726     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2727         uint amountIn,
2728         uint amountOutMin,
2729         address[] calldata path,
2730         address to,
2731         uint deadline
2732     ) external;
2733     function swapExactETHForTokensSupportingFeeOnTransferTokens(
2734         uint amountOutMin,
2735         address[] calldata path,
2736         address to,
2737         uint deadline
2738     ) external payable;
2739     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2740         uint amountIn,
2741         uint amountOutMin,
2742         address[] calldata path,
2743         address to,
2744         uint deadline
2745     ) external;
2746 }
2747 
2748 
2749 // File contracts/libraries/ERC20.sol
2750 
2751 // 
2752 
2753 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.0.0
2754 
2755 
2756 /**
2757  * @dev Implementation of the {IERC20} interface.
2758  *
2759  * This implementation is agnostic to the way tokens are created. This means
2760  * that a supply mechanism has to be added in a derived contract using {_mint}.
2761  * For a generic mechanism see {ERC20PresetMinterPauser}.
2762  *
2763  * TIP: For a detailed writeup see our guide
2764  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2765  * to implement supply mechanisms].
2766  *
2767  * We have followed general OpenZeppelin guidelines: functions revert instead
2768  * of returning `false` on failure. This behavior is nonetheless conventional
2769  * and does not conflict with the expectations of ERC20 applications.
2770  *
2771  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2772  * This allows applications to reconstruct the allowance for all accounts just
2773  * by listening to said events. Other implementations of the EIP may not emit
2774  * these events, as it isn't required by the specification.
2775  *
2776  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2777  * functions have been added to mitigate the well-known issues around setting
2778  * allowances. See {IERC20-approve}.
2779  */
2780 contract ERC20 is Context, IERC20 {
2781     mapping (address => uint256) private _balances;
2782 
2783     mapping (address => mapping (address => uint256)) private _allowances;
2784 
2785     uint256 private _totalSupply;
2786 
2787     string private _name;
2788     string private _symbol;
2789 
2790     /**
2791      * @dev Sets the values for {name} and {symbol}.
2792      *
2793      * The defaut value of {decimals} is 18. To select a different value for
2794      * {decimals} you should overload it.
2795      *
2796      * All three of these values are immutable: they can only be set once during
2797      * construction.
2798      */
2799     constructor (string memory name_, string memory symbol_) {
2800         _name = name_;
2801         _symbol = symbol_;
2802     }
2803 
2804     /**
2805      * @dev Returns the name of the token.
2806      */
2807     function name() public view virtual returns (string memory) {
2808         return _name;
2809     }
2810 
2811     /**
2812      * @dev Returns the symbol of the token, usually a shorter version of the
2813      * name.
2814      */
2815     function symbol() public view virtual returns (string memory) {
2816         return _symbol;
2817     }
2818 
2819     /**
2820      * @dev Returns the number of decimals used to get its user representation.
2821      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2822      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2823      *
2824      * Tokens usually opt for a value of 18, imitating the relationship between
2825      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2826      * overloaded;
2827      *
2828      * NOTE: This information is only used for _display_ purposes: it in
2829      * no way affects any of the arithmetic of the contract, including
2830      * {IERC20-balanceOf} and {IERC20-transfer}.
2831      */
2832     function decimals() public view virtual returns (uint8) {
2833         return 18;
2834     }
2835 
2836     /**
2837      * @dev See {IERC20-totalSupply}.
2838      */
2839     function totalSupply() public view virtual override returns (uint256) {
2840         return _totalSupply;
2841     }
2842 
2843     /**
2844      * @dev See {IERC20-balanceOf}.
2845      */
2846     function balanceOf(address account) public view virtual override returns (uint256) {
2847         return _balances[account];
2848     }
2849 
2850     /**
2851      * @dev See {IERC20-transfer}.
2852      *
2853      * Requirements:
2854      *
2855      * - `recipient` cannot be the zero address.
2856      * - the caller must have a balance of at least `amount`.
2857      */
2858     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2859         _transfer(_msgSender(), recipient, amount);
2860         return true;
2861     }
2862 
2863     /**
2864      * @dev See {IERC20-allowance}.
2865      */
2866     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2867         return _allowances[owner][spender];
2868     }
2869 
2870     /**
2871      * @dev See {IERC20-approve}.
2872      *
2873      * Requirements:
2874      *
2875      * - `spender` cannot be the zero address.
2876      */
2877     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2878         _approve(_msgSender(), spender, amount);
2879         return true;
2880     }
2881 
2882     /**
2883      * @dev See {IERC20-transferFrom}.
2884      *
2885      * Emits an {Approval} event indicating the updated allowance. This is not
2886      * required by the EIP. See the note at the beginning of {ERC20}.
2887      *
2888      * Requirements:
2889      *
2890      * - `sender` and `recipient` cannot be the zero address.
2891      * - `sender` must have a balance of at least `amount`.
2892      * - the caller must have allowance for ``sender``'s tokens of at least
2893      * `amount`.
2894      */
2895     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
2896         _transfer(sender, recipient, amount);
2897 
2898         uint256 currentAllowance = _allowances[sender][_msgSender()];
2899         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
2900         _approve(sender, _msgSender(), currentAllowance - amount);
2901 
2902         return true;
2903     }
2904 
2905     /**
2906      * @dev Atomically increases the allowance granted to `spender` by the caller.
2907      *
2908      * This is an alternative to {approve} that can be used as a mitigation for
2909      * problems described in {IERC20-approve}.
2910      *
2911      * Emits an {Approval} event indicating the updated allowance.
2912      *
2913      * Requirements:
2914      *
2915      * - `spender` cannot be the zero address.
2916      */
2917     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2918         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
2919         return true;
2920     }
2921 
2922     /**
2923      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2924      *
2925      * This is an alternative to {approve} that can be used as a mitigation for
2926      * problems described in {IERC20-approve}.
2927      *
2928      * Emits an {Approval} event indicating the updated allowance.
2929      *
2930      * Requirements:
2931      *
2932      * - `spender` cannot be the zero address.
2933      * - `spender` must have allowance for the caller of at least
2934      * `subtractedValue`.
2935      */
2936     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2937         uint256 currentAllowance = _allowances[_msgSender()][spender];
2938         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2939         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
2940 
2941         return true;
2942     }
2943 
2944     /**
2945      * @dev Moves tokens `amount` from `sender` to `recipient`.
2946      *
2947      * This is internal function is equivalent to {transfer}, and can be used to
2948      * e.g. implement automatic token fees, slashing mechanisms, etc.
2949      *
2950      * Emits a {Transfer} event.
2951      *
2952      * Requirements:
2953      *
2954      * - `sender` cannot be the zero address.
2955      * - `recipient` cannot be the zero address.
2956      * - `sender` must have a balance of at least `amount`.
2957      */
2958     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2959         require(sender != address(0), "ERC20: transfer from the zero address");
2960         require(recipient != address(0), "ERC20: transfer to the zero address");
2961 
2962         _beforeTokenTransfer(sender, recipient, amount);
2963 
2964         uint256 senderBalance = _balances[sender];
2965         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
2966         _balances[sender] = senderBalance - amount;
2967         _balances[recipient] += amount;
2968 
2969         emit Transfer(sender, recipient, amount);
2970     }
2971 
2972     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2973      * the total supply.
2974      *
2975      * Emits a {Transfer} event with `from` set to the zero address.
2976      *
2977      * Requirements:
2978      *
2979      * - `to` cannot be the zero address.
2980      */
2981     function _mint(address account, uint256 amount) internal virtual {
2982         require(account != address(0), "ERC20: mint to the zero address");
2983 
2984         _beforeTokenTransfer(address(0), account, amount);
2985 
2986         _totalSupply += amount;
2987         _balances[account] += amount;
2988         emit Transfer(address(0), account, amount);
2989     }
2990 
2991     /**
2992      * @dev Destroys `amount` tokens from `account`, reducing the
2993      * total supply.
2994      *
2995      * Emits a {Transfer} event with `to` set to the zero address.
2996      *
2997      * Requirements:
2998      *
2999      * - `account` cannot be the zero address.
3000      * - `account` must have at least `amount` tokens.
3001      */
3002     function _burn(address account, uint256 amount) internal virtual {
3003         require(account != address(0), "ERC20: burn from the zero address");
3004 
3005         _beforeTokenTransfer(account, address(0), amount);
3006 
3007         uint256 accountBalance = _balances[account];
3008         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
3009         _balances[account] = accountBalance - amount;
3010         _totalSupply -= amount;
3011 
3012         emit Transfer(account, address(0), amount);
3013     }
3014 
3015     /**
3016      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3017      *
3018      * This internal function is equivalent to `approve`, and can be used to
3019      * e.g. set automatic allowances for certain subsystems, etc.
3020      *
3021      * Emits an {Approval} event.
3022      *
3023      * Requirements:
3024      *
3025      * - `owner` cannot be the zero address.
3026      * - `spender` cannot be the zero address.
3027      */
3028     function _approve(address owner, address spender, uint256 amount) internal virtual {
3029         require(owner != address(0), "ERC20: approve from the zero address");
3030         require(spender != address(0), "ERC20: approve to the zero address");
3031 
3032         _allowances[owner][spender] = amount;
3033         emit Approval(owner, spender, amount);
3034     }
3035 
3036     /**
3037      * @dev Hook that is called before any transfer of tokens. This includes
3038      * minting and burning.
3039      *
3040      * Calling conditions:
3041      *
3042      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3043      * will be to transferred to `to`.
3044      * - when `from` is zero, `amount` tokens will be minted for `to`.
3045      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3046      * - `from` and `to` are never both zero.
3047      *
3048      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3049      */
3050     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
3051 }
3052 
3053 
3054 // File contracts/libraries/Pausable.sol
3055 
3056 // 
3057 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
3058 
3059 
3060 /**
3061  * @dev Contract module which allows children to implement an emergency stop
3062  * mechanism that can be triggered by an authorized account.
3063  *
3064  * This module is used through inheritance. It will make available the
3065  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
3066  * the functions of your contract. Note that they will not be pausable by
3067  * simply including this module, only once the modifiers are put in place.
3068  */
3069 abstract contract Pausable is Context {
3070     /**
3071      * @dev Emitted when the pause is triggered by `account`.
3072      */
3073     event Paused(address account);
3074 
3075     /**
3076      * @dev Emitted when the pause is lifted by `account`.
3077      */
3078     event Unpaused(address account);
3079 
3080     bool private _paused;
3081 
3082     /**
3083      * @dev Initializes the contract in unpaused state.
3084      */
3085     constructor() {
3086         _paused = false;
3087     }
3088 
3089     /**
3090      * @dev Returns true if the contract is paused, and false otherwise.
3091      */
3092     function paused() public view virtual returns (bool) {
3093         return _paused;
3094     }
3095 
3096     /**
3097      * @dev Modifier to make a function callable only when the contract is not paused.
3098      *
3099      * Requirements:
3100      *
3101      * - The contract must not be paused.
3102      */
3103     modifier whenNotPaused() {
3104         require(!paused(), "Pausable: paused");
3105         _;
3106     }
3107 
3108     /**
3109      * @dev Modifier to make a function callable only when the contract is paused.
3110      *
3111      * Requirements:
3112      *
3113      * - The contract must be paused.
3114      */
3115     modifier whenPaused() {
3116         require(paused(), "Pausable: not paused");
3117         _;
3118     }
3119 
3120     /**
3121      * @dev Triggers stopped state.
3122      *
3123      * Requirements:
3124      *
3125      * - The contract must not be paused.
3126      */
3127     function _pause() internal virtual whenNotPaused {
3128         _paused = true;
3129         emit Paused(_msgSender());
3130     }
3131 
3132     /**
3133      * @dev Returns to normal state.
3134      *
3135      * Requirements:
3136      *
3137      * - The contract must be paused.
3138      */
3139     function _unpause() internal virtual whenPaused {
3140         _paused = false;
3141         emit Unpaused(_msgSender());
3142     }
3143 }
3144 
3145 
3146 // File contracts/libraries/EnumerableSet.sol
3147 
3148 // 
3149 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
3150 
3151 
3152 
3153 /**
3154  * @dev Library for managing
3155  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
3156  * types.
3157  *
3158  * Sets have the following properties:
3159  *
3160  * - Elements are added, removed, and checked for existence in constant time
3161  * (O(1)).
3162  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
3163  *
3164  * ```
3165  * contract Example {
3166  *     // Add the library methods
3167  *     using EnumerableSet for EnumerableSet.AddressSet;
3168  *
3169  *     // Declare a set state variable
3170  *     EnumerableSet.AddressSet private mySet;
3171  * }
3172  * ```
3173  *
3174  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
3175  * and `uint256` (`UintSet`) are supported.
3176  */
3177 library EnumerableSet {
3178     // To implement this library for multiple types with as little code
3179     // repetition as possible, we write it in terms of a generic Set type with
3180     // bytes32 values.
3181     // The Set implementation uses private functions, and user-facing
3182     // implementations (such as AddressSet) are just wrappers around the
3183     // underlying Set.
3184     // This means that we can only create new EnumerableSets for types that fit
3185     // in bytes32.
3186 
3187     struct Set {
3188         // Storage of set values
3189         bytes32[] _values;
3190         // Position of the value in the `values` array, plus 1 because index 0
3191         // means a value is not in the set.
3192         mapping(bytes32 => uint256) _indexes;
3193     }
3194 
3195     /**
3196      * @dev Add a value to a set. O(1).
3197      *
3198      * Returns true if the value was added to the set, that is if it was not
3199      * already present.
3200      */
3201     function _add(Set storage set, bytes32 value) private returns (bool) {
3202         if (!_contains(set, value)) {
3203             set._values.push(value);
3204             // The value is stored at length-1, but we add 1 to all indexes
3205             // and use 0 as a sentinel value
3206             set._indexes[value] = set._values.length;
3207             return true;
3208         } else {
3209             return false;
3210         }
3211     }
3212 
3213     /**
3214      * @dev Removes a value from a set. O(1).
3215      *
3216      * Returns true if the value was removed from the set, that is if it was
3217      * present.
3218      */
3219     function _remove(Set storage set, bytes32 value) private returns (bool) {
3220         // We read and store the value's index to prevent multiple reads from the same storage slot
3221         uint256 valueIndex = set._indexes[value];
3222 
3223         if (valueIndex != 0) {
3224             // Equivalent to contains(set, value)
3225             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
3226             // the array, and then remove the last element (sometimes called as 'swap and pop').
3227             // This modifies the order of the array, as noted in {at}.
3228 
3229             uint256 toDeleteIndex = valueIndex - 1;
3230             uint256 lastIndex = set._values.length - 1;
3231 
3232             if (lastIndex != toDeleteIndex) {
3233                 bytes32 lastvalue = set._values[lastIndex];
3234 
3235                 // Move the last value to the index where the value to delete is
3236                 set._values[toDeleteIndex] = lastvalue;
3237                 // Update the index for the moved value
3238                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
3239             }
3240 
3241             // Delete the slot where the moved value was stored
3242             set._values.pop();
3243 
3244             // Delete the index for the deleted slot
3245             delete set._indexes[value];
3246 
3247             return true;
3248         } else {
3249             return false;
3250         }
3251     }
3252 
3253     /**
3254      * @dev Returns true if the value is in the set. O(1).
3255      */
3256     function _contains(Set storage set, bytes32 value) private view returns (bool) {
3257         return set._indexes[value] != 0;
3258     }
3259 
3260     /**
3261      * @dev Returns the number of values on the set. O(1).
3262      */
3263     function _length(Set storage set) private view returns (uint256) {
3264         return set._values.length;
3265     }
3266 
3267     /**
3268      * @dev Returns the value stored at position `index` in the set. O(1).
3269      *
3270      * Note that there are no guarantees on the ordering of values inside the
3271      * array, and it may change when more values are added or removed.
3272      *
3273      * Requirements:
3274      *
3275      * - `index` must be strictly less than {length}.
3276      */
3277     function _at(Set storage set, uint256 index) private view returns (bytes32) {
3278         return set._values[index];
3279     }
3280 
3281     /**
3282      * @dev Return the entire set in an array
3283      *
3284      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3285      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3286      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3287      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3288      */
3289     function _values(Set storage set) private view returns (bytes32[] memory) {
3290         return set._values;
3291     }
3292 
3293     // Bytes32Set
3294 
3295     struct Bytes32Set {
3296         Set _inner;
3297     }
3298 
3299     /**
3300      * @dev Add a value to a set. O(1).
3301      *
3302      * Returns true if the value was added to the set, that is if it was not
3303      * already present.
3304      */
3305     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3306         return _add(set._inner, value);
3307     }
3308 
3309     /**
3310      * @dev Removes a value from a set. O(1).
3311      *
3312      * Returns true if the value was removed from the set, that is if it was
3313      * present.
3314      */
3315     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3316         return _remove(set._inner, value);
3317     }
3318 
3319     /**
3320      * @dev Returns true if the value is in the set. O(1).
3321      */
3322     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
3323         return _contains(set._inner, value);
3324     }
3325 
3326     /**
3327      * @dev Returns the number of values in the set. O(1).
3328      */
3329     function length(Bytes32Set storage set) internal view returns (uint256) {
3330         return _length(set._inner);
3331     }
3332 
3333     /**
3334      * @dev Returns the value stored at position `index` in the set. O(1).
3335      *
3336      * Note that there are no guarantees on the ordering of values inside the
3337      * array, and it may change when more values are added or removed.
3338      *
3339      * Requirements:
3340      *
3341      * - `index` must be strictly less than {length}.
3342      */
3343     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
3344         return _at(set._inner, index);
3345     }
3346 
3347     /**
3348      * @dev Return the entire set in an array
3349      *
3350      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3351      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3352      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3353      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3354      */
3355     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
3356         return _values(set._inner);
3357     }
3358 
3359     // AddressSet
3360 
3361     struct AddressSet {
3362         Set _inner;
3363     }
3364 
3365     /**
3366      * @dev Add a value to a set. O(1).
3367      *
3368      * Returns true if the value was added to the set, that is if it was not
3369      * already present.
3370      */
3371     function add(AddressSet storage set, address value) internal returns (bool) {
3372         return _add(set._inner, bytes32(uint256(uint160(value))));
3373     }
3374 
3375     /**
3376      * @dev Removes a value from a set. O(1).
3377      *
3378      * Returns true if the value was removed from the set, that is if it was
3379      * present.
3380      */
3381     function remove(AddressSet storage set, address value) internal returns (bool) {
3382         return _remove(set._inner, bytes32(uint256(uint160(value))));
3383     }
3384 
3385     /**
3386      * @dev Returns true if the value is in the set. O(1).
3387      */
3388     function contains(AddressSet storage set, address value) internal view returns (bool) {
3389         return _contains(set._inner, bytes32(uint256(uint160(value))));
3390     }
3391 
3392     /**
3393      * @dev Returns the number of values in the set. O(1).
3394      */
3395     function length(AddressSet storage set) internal view returns (uint256) {
3396         return _length(set._inner);
3397     }
3398 
3399     /**
3400      * @dev Returns the value stored at position `index` in the set. O(1).
3401      *
3402      * Note that there are no guarantees on the ordering of values inside the
3403      * array, and it may change when more values are added or removed.
3404      *
3405      * Requirements:
3406      *
3407      * - `index` must be strictly less than {length}.
3408      */
3409     function at(AddressSet storage set, uint256 index) internal view returns (address) {
3410         return address(uint160(uint256(_at(set._inner, index))));
3411     }
3412 
3413     /**
3414      * @dev Return the entire set in an array
3415      *
3416      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3417      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3418      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3419      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3420      */
3421     function values(AddressSet storage set) internal view returns (address[] memory) {
3422         bytes32[] memory store = _values(set._inner);
3423         address[] memory result;
3424 
3425         assembly {
3426             result := store
3427         }
3428 
3429         return result;
3430     }
3431 
3432     // UintSet
3433 
3434     struct UintSet {
3435         Set _inner;
3436     }
3437 
3438     /**
3439      * @dev Add a value to a set. O(1).
3440      *
3441      * Returns true if the value was added to the set, that is if it was not
3442      * already present.
3443      */
3444     function add(UintSet storage set, uint256 value) internal returns (bool) {
3445         return _add(set._inner, bytes32(value));
3446     }
3447 
3448     /**
3449      * @dev Removes a value from a set. O(1).
3450      *
3451      * Returns true if the value was removed from the set, that is if it was
3452      * present.
3453      */
3454     function remove(UintSet storage set, uint256 value) internal returns (bool) {
3455         return _remove(set._inner, bytes32(value));
3456     }
3457 
3458     /**
3459      * @dev Returns true if the value is in the set. O(1).
3460      */
3461     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
3462         return _contains(set._inner, bytes32(value));
3463     }
3464 
3465     /**
3466      * @dev Returns the number of values on the set. O(1).
3467      */
3468     function length(UintSet storage set) internal view returns (uint256) {
3469         return _length(set._inner);
3470     }
3471 
3472     /**
3473      * @dev Returns the value stored at position `index` in the set. O(1).
3474      *
3475      * Note that there are no guarantees on the ordering of values inside the
3476      * array, and it may change when more values are added or removed.
3477      *
3478      * Requirements:
3479      *
3480      * - `index` must be strictly less than {length}.
3481      */
3482     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
3483         return uint256(_at(set._inner, index));
3484     }
3485 
3486     /**
3487      * @dev Return the entire set in an array
3488      *
3489      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3490      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3491      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3492      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3493      */
3494     function values(UintSet storage set) internal view returns (uint256[] memory) {
3495         bytes32[] memory store = _values(set._inner);
3496         uint256[] memory result;
3497 
3498         assembly {
3499             result := store
3500         }
3501 
3502         return result;
3503     }
3504 }
3505 
3506 
3507 // File contracts/MintFactory.sol
3508 
3509 // 
3510 // ALL RIGHTS RESERVED
3511 
3512 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
3513 
3514 
3515 // This contract logs all tokens on the platform
3516 
3517 
3518 contract MintFactory is Ownable {
3519     using EnumerableSet for EnumerableSet.AddressSet;
3520     
3521     EnumerableSet.AddressSet private tokens;
3522     EnumerableSet.AddressSet private tokenGenerators;
3523 
3524     struct TaxHelper {
3525         string Name;
3526         address Address;
3527         uint256 Index;
3528     }
3529 
3530     mapping(uint => TaxHelper) private taxHelpersData;
3531     address[] private taxHelpers;
3532      
3533     mapping(address => address[]) private tokenOwners;
3534 
3535     address private FacetHelper;
3536     address private FeeHelper;
3537     address private LosslessController;
3538 
3539     event TokenRegistered(address tokenOwner, address tokenContract);
3540     event AllowTokenGenerator(address _address, bool _allow);
3541 
3542     event AddedTaxHelper(string _name, address _address, uint256 _index);
3543     event UpdatedTaxHelper(address _newAddress, uint256 _index);
3544 
3545     event UpdatedFacetHelper(address _newAddress);
3546     event UpdatedFeeHelper(address _newAddress);
3547     event UpdatedLosslessController(address _newAddress);
3548     
3549     function adminAllowTokenGenerator (address _address, bool _allow) public onlyOwner {
3550         if (_allow) {
3551             tokenGenerators.add(_address);
3552         } else {
3553             tokenGenerators.remove(_address);
3554         }
3555         emit AllowTokenGenerator(_address, _allow);
3556     }
3557 
3558     function addTaxHelper(string calldata _name, address _address) public onlyOwner {
3559         uint256 index = taxHelpers.length;
3560         TaxHelper memory newTaxHelper;
3561         newTaxHelper.Name = _name;
3562         newTaxHelper.Address = _address;
3563         newTaxHelper.Index = index;
3564         taxHelpersData[index] = newTaxHelper;
3565         taxHelpers.push(_address);
3566         emit AddedTaxHelper(_name, _address, index);
3567     }
3568 
3569     function updateTaxHelper(uint256 _index, address _address) public onlyOwner {
3570         taxHelpersData[_index].Address = _address;
3571         taxHelpers[_index] = _address;
3572         emit UpdatedTaxHelper(_address, _index);
3573     }
3574 
3575     function getTaxHelperAddress(uint256 _index) public view returns(address){
3576         return taxHelpers[_index];
3577     }
3578 
3579     function getTaxHelpersDataByIndex(uint256 _index) public view returns(TaxHelper memory) {
3580         return taxHelpersData[_index];
3581     }
3582     
3583     /**
3584      * @notice called by a registered tokenGenerator upon token creation
3585      */
3586     function registerToken (address _tokenOwner, address _tokenAddress) public {
3587         require(tokenGenerators.contains(msg.sender), 'FORBIDDEN');
3588         tokens.add(_tokenAddress);
3589         tokenOwners[_tokenOwner].push(_tokenAddress);
3590         emit TokenRegistered(_tokenOwner, _tokenAddress);
3591     }
3592 
3593      /**
3594      * @notice gets a token at index registered under a user address
3595      * @return token addresses registered to the user address
3596      */
3597      function getTokenByOwnerAtIndex(address _tokenOwner, uint256 _index) external view returns(address) {
3598          return tokenOwners[_tokenOwner][_index];
3599      }
3600      
3601      /**
3602      * @notice gets the total of tokens registered under a user address
3603      * @return uint total of token addresses registered to the user address
3604      */
3605      
3606      function getTokensLengthByOwner(address _tokenOwner) external view returns(uint256) {
3607          return tokenOwners[_tokenOwner].length;
3608      }
3609     
3610     /**
3611      * @notice Number of allowed tokenGenerators
3612      */
3613     function tokenGeneratorsLength() external view returns (uint256) {
3614         return tokenGenerators.length();
3615     }
3616     
3617     /**
3618      * @notice Gets the address of a registered tokenGenerator at specified index
3619      */
3620     function tokenGeneratorAtIndex(uint256 _index) external view returns (address) {
3621         return tokenGenerators.at(_index);
3622     }
3623 
3624     /**
3625      * @notice returns true if user is allowed to generate tokens
3626      */
3627     function tokenGeneratorIsAllowed(address _tokenGenerator) external view returns (bool) {
3628         return tokenGenerators.contains(_tokenGenerator);
3629     }
3630     
3631     /**
3632      * @notice returns true if the token address was generated by the Unicrypt token platform
3633      */
3634     function tokenIsRegistered(address _tokenAddress) external view returns (bool) {
3635         return tokens.contains(_tokenAddress);
3636     }
3637     
3638     /**
3639      * @notice The length of all tokens on the platform
3640      */
3641     function tokensLength() external view returns (uint256) {
3642         return tokens.length();
3643     }
3644     
3645     /**
3646      * @notice gets a token at a specific index. Although using Enumerable Set, since tokens are only added and not removed, indexes will never change
3647      * @return the address of the token contract at index
3648      */
3649     function tokenAtIndex(uint256 _index) external view returns (address) {
3650         return tokens.at(_index);
3651     }
3652 
3653     // Helpers and Controllers
3654     
3655     function getFacetHelper() public view returns (address) {
3656         return FacetHelper;
3657     }
3658 
3659     function updateFacetHelper(address _newFacetHelperAddress) public onlyOwner {
3660         require(_newFacetHelperAddress != address(0));
3661         FacetHelper = _newFacetHelperAddress;
3662         emit UpdatedFacetHelper(_newFacetHelperAddress);
3663     }
3664 
3665     function getFeeHelper() public view returns (address) {
3666         return FeeHelper;
3667     }
3668 
3669     function updateFeeHelper(address _newFeeHelperAddress) public onlyOwner {
3670         require(_newFeeHelperAddress != address(0));
3671         FeeHelper = _newFeeHelperAddress;
3672         emit UpdatedFeeHelper(_newFeeHelperAddress);
3673     }
3674 
3675     function getLosslessController() public view returns (address) {
3676         return LosslessController;
3677     }
3678 
3679     function updateLosslessController(address _newLosslessControllerAddress) public onlyOwner {
3680         require(_newLosslessControllerAddress != address(0));
3681         LosslessController = _newLosslessControllerAddress;
3682         emit UpdatedLosslessController(_newLosslessControllerAddress);
3683     }
3684 }
3685 
3686 
3687 // File contracts/TaxToken.sol
3688 
3689 // 
3690 // ALL RIGHTS RESERVED
3691 
3692 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
3693 
3694 
3695 
3696 contract TaxToken is Ownable{
3697     Storage internal s;
3698 
3699     event Transfer(address indexed from, address indexed to, uint256 value);
3700     event Approval(address indexed owner, address indexed spender, uint256 value);
3701 
3702     struct ConstructorParams {
3703         string name_; 
3704         string symbol_; 
3705         uint8 decimals_; 
3706         address creator_;
3707         uint256 tTotal_;
3708         uint256 _maxTax;
3709         TaxSettings _settings;
3710         TaxSettings _lockedSettings;
3711         Fees _fees;
3712         address _transactionTaxWallet;
3713         CustomTax[] _customTaxes;
3714         uint256 lpWalletThreshold;
3715         uint256 buyBackWalletThreshold;
3716         uint256 _taxHelperIndex;
3717         address admin_;
3718         address recoveryAdmin_;
3719         bool isLossless_;
3720         AntiBotSettings _antiBotSettings;
3721         uint256 _maxBalanceAfterBuy;
3722         SwapWhitelistingSettings _swapWhitelistingSettings;
3723     }
3724 
3725     constructor(
3726         ConstructorParams memory params,
3727         address _factory
3728         ) {
3729         address constructorFacetAddress = IFacetHelper(IMintFactory(_factory).getFacetHelper()).getConstructorFacet();
3730         (bool success, bytes memory result) = constructorFacetAddress.delegatecall(abi.encodeWithSignature("constructorHandler((string,string,uint8,address,uint256,uint256,(bool,bool,bool,bool,bool,bool,bool,bool),(bool,bool,bool,bool,bool,bool,bool,bool),((uint256,uint256),uint256,uint256,uint256),address,(string,(uint256,uint256),address,bool)[],uint256,uint256,uint256,address,address,bool,(uint256,uint256,uint256,uint256,bool),uint256,(uint256,bool)),address)", params, _factory));
3731         if (!success) {
3732             if (result.length < 68) revert();
3733             revert(abi.decode(result, (string)));
3734         }
3735         IFeeHelper feeHelper = IFeeHelper(IMintFactory(s.factory).getFeeHelper());
3736         uint256 fee = FullMath.mulDiv(params.tTotal_, feeHelper.getFee(), feeHelper.getFeeDenominator());
3737         address feeAddress = feeHelper.getFeeAddress();
3738         _approve(params.creator_, msg.sender, fee);
3739         s.isTaxed = true;
3740         transferFrom(params.creator_, feeAddress, fee);
3741     }
3742 
3743     /// @notice this is the power behind Lossless
3744     function transferOutBlacklistedFunds(address[] calldata from) external {
3745         require(s.isLosslessOn); // added by us for extra protection
3746         require(_msgSender() == address(IMintFactory(s.factory).getLosslessController()), "LOL");
3747         for (uint i = 0; i < from.length; i++) {
3748             _transfer(from[i], address(IMintFactory(s.factory).getLosslessController()), balanceOf(from[i]));
3749         }
3750     }
3751 
3752     /// @notice Checks whether an address is blacklisted
3753     /// @param _address the address to check
3754     /// @return bool is blacklisted or not
3755     function isBlacklisted(address _address) public view returns (bool) {
3756         return s.blacklist[_address];
3757     }
3758 
3759     /// @notice Checks whether the contract has paused transactions
3760     /// @return bool is paused or not
3761     function paused() public view returns (bool) {
3762         if(s.taxSettings.canPause == false) {
3763             return false;
3764         }
3765         return s.isPaused;
3766     }
3767 
3768     /// @notice Handles the burning of token during the buyback tax process
3769     /// @dev must first receive the amount to be burned from the taxHelper contract (see initial transfer in function)
3770     /// @param _amount the amount to burn
3771     function buyBackBurn(uint256 _amount) external {
3772         address taxHelper = IMintFactory(s.factory).getTaxHelperAddress(s.taxHelperIndex);
3773         require(msg.sender == taxHelper, "RA");
3774         _transfer(taxHelper, owner(), _amount);
3775 
3776         address taxFacetAddress = IFacetHelper(IMintFactory(s.factory).getFacetHelper()).getTaxFacet();
3777         (bool success, bytes memory result) = taxFacetAddress.delegatecall(abi.encodeWithSignature("burn(uint256)", _amount));
3778         if (!success) {
3779             if (result.length < 68) revert();
3780             revert(abi.decode(result, (string)));
3781         }
3782     }
3783 
3784     /// @notice Handles the taxes for the token.
3785     /// @dev handles every tax within the tax facet. 
3786     /// @param sender the one sending the transaction
3787     /// @param recipient the one receiving the transaction
3788     /// @param amount the amount of tokens being sent
3789     /// @return totalTaxAmount the total amount of the token taxed
3790     function handleTaxes(address sender, address recipient, uint256 amount) internal virtual returns (uint256 totalTaxAmount) {
3791         address taxFacetAddress = IFacetHelper(IMintFactory(s.factory).getFacetHelper()).getTaxFacet();
3792         (bool success, bytes memory result) = taxFacetAddress.delegatecall(abi.encodeWithSignature("handleTaxes(address,address,uint256)", sender, recipient, amount));
3793         if (!success) {
3794             if (result.length < 68) revert();
3795             revert(abi.decode(result, (string)));
3796         }
3797         return abi.decode(result, (uint256));
3798 
3799     }
3800 
3801     // Getters
3802 
3803     function name() public view returns (string memory) {
3804         return s._name;
3805     }
3806 
3807     function symbol() public view returns (string memory) {
3808         return s._symbol;
3809     }
3810 
3811     function decimals() public view returns (uint8) {
3812         return s._decimals;
3813     }
3814 
3815     function totalSupply() public view returns (uint256) {
3816         return s._tTotal;
3817     }
3818 
3819     function CONTRACT_VERSION() public view returns (uint256) {
3820         return s.CONTRACT_VERSION;
3821     }
3822 
3823     function taxSettings() public view returns (TaxSettings memory) {
3824         return s.taxSettings;
3825     }
3826     
3827     function isLocked() public view returns (TaxSettings memory) {
3828         return s.isLocked;
3829     }
3830 
3831     function fees() public view returns (Fees memory) {
3832         return s.fees;
3833     }
3834 
3835     function customTaxes(uint _index) public view returns (CustomTax memory) {
3836         return s.customTaxes[_index];
3837     }
3838 
3839     function transactionTaxWallet() public view returns (address) {
3840         return s.transactionTaxWallet;
3841     }
3842 
3843     function customTaxLength() public view returns (uint256) {
3844         return s.customTaxLength;
3845     }
3846 
3847     function MaxTax() public view returns (uint256) {
3848         return s.MaxTax;
3849     }
3850 
3851     function MaxCustom() public view returns (uint8) {
3852         return s.MaxCustom;
3853     }
3854 
3855     function _allowances(address _address1, address _address2) public view returns (uint256) {
3856         return s._allowances[_address1][_address2];
3857     }
3858 
3859     function _isExcluded(address _address) public view returns (bool) {
3860         return s._isExcluded[_address];
3861     }
3862 
3863     function _tFeeTotal() public view returns (uint256) {
3864         return s._tFeeTotal;
3865     }
3866 
3867     function lpTokens(address _address) public view returns (bool) {
3868         return s.lpTokens[_address];
3869     }
3870 
3871     function factory() public view returns (address) {
3872         return s.factory;
3873     }
3874 
3875     function buyBackWallet() public view returns (address) {
3876         return s.buyBackWallet;
3877     }
3878 
3879     function lpWallet() public view returns (address) {
3880         return s.lpWallet;
3881     }
3882 
3883     function pairAddress() public view returns (address) {
3884         return s.pairAddress;
3885     }
3886     
3887     function taxHelperIndex() public view returns (uint256) {
3888         return s.taxHelperIndex;
3889     }
3890 
3891     function marketInit() public view returns (bool) {
3892         return s.marketInit;
3893     }
3894 
3895     function marketInitBlockTime() public view returns (uint256) {
3896         return s.marketInitBlockTime;
3897     }
3898 
3899     function antiBotSettings() public view returns (AntiBotSettings memory) {
3900         return s.antiBotSettings;
3901     }
3902 
3903     function maxBalanceAfterBuy() public view returns (uint256) {
3904         return s.maxBalanceAfterBuy;
3905     }
3906 
3907     function swapWhitelistingSettings() public view returns (SwapWhitelistingSettings memory) {
3908         return s.swapWhitelistingSettings;
3909     }
3910 
3911     function recoveryAdmin() public view returns (address) {
3912         return s.recoveryAdmin;
3913     }
3914 
3915     function admin() public view returns (address) {
3916         return s.admin;
3917     }
3918 
3919     function timelockPeriod() public view returns (uint256) {
3920         return s.timelockPeriod;
3921     }
3922 
3923     function losslessTurnOffTimestamp() public view returns (uint256) {
3924         return s.losslessTurnOffTimestamp;
3925     }
3926 
3927     function isLosslessTurnOffProposed() public view returns (bool) {
3928         return s.isLosslessTurnOffProposed;
3929     }
3930 
3931     function isLosslessOn() public view returns (bool) {
3932         return s.isLosslessOn;
3933     }
3934 
3935     function lossless() public view returns (ILosslessController) {
3936         return ILosslessController(IMintFactory(s.factory).getLosslessController());
3937     }
3938 
3939 
3940     // ERC20 Functions
3941 
3942     /// @dev modified to handle if the token has reflection active in it settings
3943     function balanceOf(address account) public view returns (uint256) {
3944         if(s.taxSettings.holderTax) {
3945             if (s._isExcluded[account]) return s._tOwned[account];
3946             return tokenFromReflection(s._rOwned[account]); 
3947         }
3948         return s._tOwned[account];
3949     }
3950 
3951     // Reflection Functions 
3952     // necessary to get reflection balance
3953 
3954     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
3955         require(rAmount <= s._rTotal, "ALR");
3956         uint256 currentRate =  _getRate();
3957         return rAmount / currentRate;
3958     }
3959 
3960     function _getRate() public view returns(uint256) {
3961         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
3962         return rSupply / tSupply;
3963     }
3964 
3965     function _getCurrentSupply() public view returns(uint256, uint256) {
3966         uint256 rSupply = s._rTotal;
3967         uint256 tSupply = s._tTotal;      
3968         for (uint256 i = 0; i < s._excluded.length; i++) {
3969             if (s._rOwned[s._excluded[i]] > rSupply || s._tOwned[s._excluded[i]] > tSupply) return (s._rTotal, s._tTotal);
3970             rSupply = rSupply - s._rOwned[s._excluded[i]];
3971             tSupply = tSupply - s._tOwned[s._excluded[i]];
3972         }
3973         if (rSupply < s._rTotal / s._tTotal) return (s._rTotal, s._tTotal);
3974         return (rSupply, tSupply);
3975     }
3976 
3977 
3978     // ERC20 Functions continued 
3979     /// @dev modified slightly to add taxes
3980 
3981     function transfer(address recipient, uint256 amount) public returns (bool) {
3982         if(!s.isTaxed) {
3983             s.isTaxed = true;
3984             uint256 totalTaxAmount = handleTaxes(_msgSender(), recipient, amount);
3985             amount -= totalTaxAmount;
3986         }
3987         if (s.isLosslessOn) {
3988             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeTransfer(_msgSender(), recipient, amount);
3989         } 
3990         _transfer(_msgSender(), recipient, amount);
3991         s.isTaxed = false;
3992         if (s.isLosslessOn) {
3993             ILosslessController(IMintFactory(s.factory).getLosslessController()).afterTransfer(_msgSender(), recipient, amount);
3994         } 
3995         return true;
3996     }
3997 
3998     function allowance(address _owner, address spender) public view returns (uint256) {
3999         return s._allowances[_owner][spender];
4000     }
4001 
4002     function approve(address spender, uint256 amount) public returns (bool) {
4003         _approve(_msgSender(), spender, amount);
4004         return true;
4005     }
4006 
4007     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
4008         if(!s.isTaxed) {
4009             s.isTaxed = true;
4010             uint256 totalTaxAmount = handleTaxes(sender, recipient, amount);
4011             amount -= totalTaxAmount;
4012         }
4013         if (s.isLosslessOn) {
4014             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeTransferFrom(_msgSender(), sender, recipient, amount);
4015         }
4016         _transfer(sender, recipient, amount);
4017 
4018         uint256 currentAllowance = s._allowances[sender][_msgSender()];
4019         require(currentAllowance >= amount, "ETA");
4020 
4021         _approve(sender, _msgSender(), s._allowances[sender][_msgSender()] - amount);
4022 
4023         s.isTaxed = false;
4024         if (s.isLosslessOn) {
4025             ILosslessController(IMintFactory(s.factory).getLosslessController()).afterTransfer(_msgSender(), recipient, amount);
4026         } 
4027         return true;
4028     }
4029 
4030     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
4031         if (s.isLosslessOn) {
4032             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeIncreaseAllowance(_msgSender(), spender, addedValue);
4033         }
4034         _approve(_msgSender(), spender, s._allowances[_msgSender()][spender] + addedValue);
4035         return true;
4036     }
4037 
4038     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
4039          if (s.isLosslessOn) {
4040             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeDecreaseAllowance(_msgSender(), spender, subtractedValue);
4041         }
4042         uint256 currentAllowance = s._allowances[_msgSender()][spender];
4043         require(currentAllowance >= subtractedValue, "EABZ");
4044         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
4045         return true;
4046     }
4047 
4048     function _approve(address _owner, address spender, uint256 amount) private {
4049         require(_owner != address(0), "EAFZ");
4050         require(spender != address(0), "EATZ");
4051         if (s.isLosslessOn) {
4052             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeApprove(_owner, spender, amount);
4053         } 
4054 
4055         s._allowances[_owner][spender] = amount;
4056         emit Approval(_owner, spender, amount);
4057     }
4058 
4059     function _transfer(address sender, address recipient, uint256 amount) private {
4060         // AntiBot Checks
4061         address antiBotFacetAddress = IFacetHelper(IMintFactory(s.factory).getFacetHelper()).getAntiBotFacet();
4062         if(s.marketInit && s.antiBotSettings.isActive && s.lpTokens[sender]) {
4063             (bool success, bytes memory result) = antiBotFacetAddress.delegatecall(abi.encodeWithSignature("antiBotCheck(uint256,address)", amount, recipient));
4064             if (!success) {
4065                 if (result.length < 68) revert();
4066                 revert(abi.decode(result, (string)));
4067             }
4068         } 
4069         if(s.taxSettings.maxBalanceAfterBuy && s.lpTokens[sender]) {
4070             (bool success2, bytes memory result2) = antiBotFacetAddress.delegatecall(abi.encodeWithSignature("maxBalanceAfterBuyCheck(uint256,address)", amount, recipient));
4071             if (!success2) {
4072                 if (result2.length < 68) revert();
4073                 revert(abi.decode(result2, (string)));
4074             }
4075         } 
4076         if(s.marketInit && s.swapWhitelistingSettings.isActive && s.lpTokens[sender]) {
4077             (bool success3, bytes memory result3) = antiBotFacetAddress.delegatecall(abi.encodeWithSignature("swapWhitelistingCheck(address)", recipient));
4078             if (!success3) {
4079                 if (result3.length < 68) revert();
4080                 revert(abi.decode(result3, (string)));
4081             }
4082         } 
4083         address taxFacetAddress = IFacetHelper(IMintFactory(s.factory).getFacetHelper()).getTaxFacet();
4084         (bool success4, bytes memory result4) = taxFacetAddress.delegatecall(abi.encodeWithSignature("_transfer(address,address,uint256)", sender, recipient, amount));
4085         if (!success4) {
4086             if (result4.length < 68) revert();
4087             revert(abi.decode(result4, (string)));
4088         }
4089     }
4090 
4091     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
4092 
4093     function mint(uint256 amount) public onlyOwner {
4094         _mint(msg.sender, amount);
4095     }
4096 
4097     /// @notice custom mint to handle fees
4098     function _mint(address account, uint256 amount) internal virtual {
4099         require(account != address(0), "EMZ");
4100         require(s.taxSettings.canMint, "NM");
4101         require(!s.taxSettings.holderTax, "NM");
4102         if (s.isLosslessOn) {
4103             ILosslessController(IMintFactory(s.factory).getLosslessController()).beforeMint(account, amount);
4104         } 
4105 
4106         IFeeHelper feeHelper = IFeeHelper(IMintFactory(s.factory).getFeeHelper());
4107         uint256 fee = FullMath.mulDiv(amount, feeHelper.getFee(), feeHelper.getFeeDenominator());
4108         address feeAddress = feeHelper.getFeeAddress();
4109 
4110         _beforeTokenTransfer(address(0), account, amount);
4111         s._tTotal += amount;
4112         s._tOwned[feeAddress] += fee;
4113         s._tOwned[account] += amount - fee;
4114 
4115         emit Transfer(address(0), feeAddress, fee);
4116         emit Transfer(address(0), account, amount - fee);
4117     }
4118 
4119     function burn(uint256 amount) public {
4120         address taxFacetAddress = IFacetHelper(IMintFactory(s.factory).getFacetHelper()).getTaxFacet();
4121         (bool success, bytes memory result) = taxFacetAddress.delegatecall(abi.encodeWithSignature("burn(uint256)", amount));
4122         if (!success) {
4123             if (result.length < 68) revert();
4124             revert(abi.decode(result, (string)));
4125         }
4126     }
4127 
4128     /// @notice Handles all facet logic
4129     /// @dev Implements a customized version of the EIP-2535 Diamond Standard to add extra functionality to the contract
4130     /// https://github.com/mudgen/diamond-3 
4131     fallback() external {
4132         address facetHelper = IMintFactory(s.factory).getFacetHelper(); 
4133         address facet = IFacetHelper(facetHelper).facetAddress(msg.sig);
4134         require(facet != address(0), "Function does not exist");
4135         assembly {
4136             let ptr := mload(0x40)
4137             calldatacopy(ptr, 0, calldatasize())
4138     
4139             let result := delegatecall(
4140                 gas(),
4141                 facet,
4142                 ptr,
4143                 calldatasize(),
4144                 0,
4145                 0
4146             )
4147 
4148             let size := returndatasize()
4149             returndatacopy(ptr, 0, size)
4150 
4151             switch result
4152             case 0 {
4153                 revert(ptr, size)
4154             }
4155             default {
4156                 return(ptr, size)
4157             }
4158         }
4159     }
4160   
4161 }
4162 
4163 
4164 // File contracts/MintGenerator.sol
4165 
4166 // 
4167 // ALL RIGHTS RESERVED
4168 
4169 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
4170 
4171 
4172 // This contract generates Token01 contracts and registers them in the TokenFactory.
4173 // Ideally you should not interact with this contract directly, and use the Unicrypt token app instead so warnings can be shown where necessary.
4174 
4175 
4176 contract MintGenerator is Ownable {
4177     
4178     uint256 public CONTRACT_VERSION = 1;
4179 
4180 
4181     IMintFactory public MINT_FACTORY;
4182     IFeeHelper public FEE_HELPER;
4183     
4184     constructor(address _mintFactory, address _feeHelper) {
4185         MINT_FACTORY = IMintFactory(_mintFactory);
4186         FEE_HELPER = IFeeHelper(_feeHelper);
4187     }
4188     
4189     /**
4190      * @notice Creates a new Token contract and registers it in the TokenFactory.sol.
4191      */
4192     
4193     function createToken (
4194       TaxToken.ConstructorParams calldata params
4195       ) public payable returns (address){
4196         require(msg.value == FEE_HELPER.getGeneratorFee(), 'FEE NOT MET');
4197         payable(FEE_HELPER.getFeeAddress()).transfer(FEE_HELPER.getGeneratorFee());
4198         TaxToken newToken = new TaxToken(params, address(MINT_FACTORY));
4199         MINT_FACTORY.registerToken(msg.sender, address(newToken));
4200         return address(newToken);
4201     }
4202 }
4203 
4204 
4205 // File contracts/interfaces/IUniswapV2Factory.sol
4206 
4207 
4208 interface IUniswapV2Factory {
4209     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
4210 
4211     function feeTo() external view returns (address);
4212     function feeToSetter() external view returns (address);
4213 
4214     function getPair(address tokenA, address tokenB) external view returns (address pair);
4215     function allPairs(uint) external view returns (address pair);
4216     function allPairsLength() external view returns (uint);
4217 
4218     function createPair(address tokenA, address tokenB) external returns (address pair);
4219 
4220     function setFeeTo(address) external;
4221     function setFeeToSetter(address) external;
4222 }
4223 
4224 
4225 // File contracts/interfaces/IUniswapV2Pair.sol
4226 
4227 
4228 interface IUniswapV2Pair {
4229     event Approval(address indexed owner, address indexed spender, uint value);
4230     event Transfer(address indexed from, address indexed to, uint value);
4231 
4232     function name() external pure returns (string memory);
4233     function symbol() external pure returns (string memory);
4234     function decimals() external pure returns (uint8);
4235     function totalSupply() external view returns (uint);
4236     function balanceOf(address owner) external view returns (uint);
4237     function allowance(address owner, address spender) external view returns (uint);
4238 
4239     function approve(address spender, uint value) external returns (bool);
4240     function transfer(address to, uint value) external returns (bool);
4241     function transferFrom(address from, address to, uint value) external returns (bool);
4242 
4243     function DOMAIN_SEPARATOR() external view returns (bytes32);
4244     function PERMIT_TYPEHASH() external pure returns (bytes32);
4245     function nonces(address owner) external view returns (uint);
4246 
4247     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
4248 
4249     event Mint(address indexed sender, uint amount0, uint amount1);
4250     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
4251     event Swap(
4252         address indexed sender,
4253         uint amount0In,
4254         uint amount1In,
4255         uint amount0Out,
4256         uint amount1Out,
4257         address indexed to
4258     );
4259     event Sync(uint112 reserve0, uint112 reserve1);
4260 
4261     function MINIMUM_LIQUIDITY() external pure returns (uint);
4262     function factory() external view returns (address);
4263     function token0() external view returns (address);
4264     function token1() external view returns (address);
4265     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
4266     function price0CumulativeLast() external view returns (uint);
4267     function price1CumulativeLast() external view returns (uint);
4268     function kLast() external view returns (uint);
4269 
4270     function mint(address to) external returns (uint liquidity);
4271     function burn(address to) external returns (uint amount0, uint amount1);
4272     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
4273     function skim(address to) external;
4274     function sync() external;
4275 
4276     function initialize(address, address) external;
4277 }
4278 
4279 
4280 // File contracts/TaxHelperCamelotV2.sol
4281 
4282 // 
4283 // ALL RIGHTS RESERVED
4284 
4285 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
4286 
4287 
4288 
4289 // add events
4290 
4291 contract TaxHelperCamelotV2 is Ownable{
4292     
4293     ICamelotRouter router;
4294     IUniswapV2Factory factory;
4295     IMintFactory mintFactory;
4296 
4297     // event Buy
4298     event CreatedLPToken(address token0, address token1, address LPToken);
4299 
4300     constructor(address swapV2Router, address swapV2Factory, address _mintFactory) {
4301     router = ICamelotRouter(swapV2Router);
4302     factory = IUniswapV2Factory(swapV2Factory);
4303     mintFactory = IMintFactory(_mintFactory);
4304  
4305     }
4306 
4307     modifier isToken() {
4308         require(mintFactory.tokenIsRegistered(msg.sender), "RA");
4309         _;
4310     }
4311 
4312     function initiateBuyBackTax(address _token, address _wallet) payable external isToken returns(bool) {
4313         ITaxToken token = ITaxToken(_token);
4314         uint256 _amount = token.balanceOf(address(this));
4315         address[] memory addressPaths = new address[](2);
4316         addressPaths[0] = _token;
4317         addressPaths[1] = router.WETH();
4318         token.approve(address(router), _amount);
4319         if(_amount > 0) {
4320             router.swapExactTokensForETHSupportingFeeOnTransferTokens(_amount, 0, addressPaths, _wallet, address(0), block.timestamp);
4321         }
4322         IBuyBackWallet buyBackWallet = IBuyBackWallet(_wallet);
4323         bool res = buyBackWallet.checkBuyBackTrigger();
4324         if(res) {
4325             addressPaths[0] = router.WETH();
4326             addressPaths[1] = _token;
4327             uint256 amountEth = buyBackWallet.sendEthToTaxHelper();
4328             uint256 balanceBefore = token.balanceOf(address(this));
4329             router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountEth}(0, addressPaths, address(this), address(0), block.timestamp);
4330             // burn baby burn!
4331             uint256 balanceAfter = token.balanceOf(address(this));
4332             uint256 amountToBurn = balanceAfter - balanceBefore;
4333             token.approve(token.owner(), amountToBurn);
4334             token.buyBackBurn(amountToBurn);
4335         }
4336         return true;
4337     }
4338 
4339     function initiateLPTokenTax(address _token, address _wallet) external isToken returns (bool) {
4340         ITaxToken token = ITaxToken(_token);
4341         uint256 _amount = token.balanceOf(address(this));
4342         address[] memory addressPaths = new address[](2);
4343         addressPaths[0] = _token;
4344         addressPaths[1] = router.WETH();
4345         uint256 halfAmount = _amount / 2;
4346         uint256 otherHalf = _amount - halfAmount;
4347         token.transfer(_wallet, otherHalf);
4348         token.approve(address(router), halfAmount);
4349         if(halfAmount > 0) {
4350             router.swapExactTokensForETHSupportingFeeOnTransferTokens(halfAmount, 0, addressPaths, _wallet, address(0), block.timestamp);
4351         }
4352         ILPWallet lpWallet = ILPWallet(_wallet);
4353         bool res = lpWallet.checkLPTrigger();
4354         if(res) {
4355             lpWallet.transferBalanceToTaxHelper();
4356             uint256 amountEth = lpWallet.sendEthToTaxHelper();
4357             uint256 tokenBalance = token.balanceOf(address(this));
4358             token.approve(address(router), tokenBalance);
4359             router.addLiquidityETH{value: amountEth}(_token, tokenBalance, 0, 0, token.owner(), block.timestamp + 20 minutes);
4360             uint256 ethDust = address(this).balance;
4361             if(ethDust > 0) {
4362                 (bool sent,) = _wallet.call{value: ethDust}("");
4363                 require(sent, "Failed to send Ether");
4364             }
4365             uint256 tokenDust = token.balanceOf(address(this));
4366             if(tokenDust > 0) {
4367                 token.transfer(_wallet, tokenDust);
4368             }
4369         }
4370         return true;
4371     }    
4372     
4373     function createLPToken() external returns(address lpToken) {
4374         // lpToken = factory.createPair(msg.sender, router.WETH());
4375         // emit CreatedLPToken(msg.sender, router.WETH(), lpToken);
4376         // Camelot V2 fails upon LP creation during the constructor
4377         // return zaero address to be updated after creation.
4378         return address(0);
4379     }
4380 
4381     function lpTokenHasReserves(address _lpToken) public view returns (bool) {
4382         (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(_lpToken).getReserves();
4383         return reserve0 > 0 && reserve1 > 0;
4384     }
4385 
4386     function sync(address _lpToken) public {
4387         IUniswapV2Pair(_lpToken).sync();
4388     }
4389 
4390     receive() payable external {
4391     }
4392 
4393 }
4394 
4395 
4396 // File contracts/TaxHelperUniswapV2.sol
4397 
4398 // 
4399 // ALL RIGHTS RESERVED
4400 
4401 // Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.
4402 
4403 
4404 
4405 // add events
4406 
4407 contract TaxHelperUniswapV2 is Ownable{
4408     
4409     IUniswapV2Router02 router;
4410     IUniswapV2Factory factory;
4411     IMintFactory mintFactory;
4412 
4413     // event Buy
4414     event CreatedLPToken(address token0, address token1, address LPToken);
4415 
4416     constructor(address swapV2Router, address swapV2Factory, address _mintFactory) {
4417     router = IUniswapV2Router02(swapV2Router);
4418     factory = IUniswapV2Factory(swapV2Factory);
4419     mintFactory = IMintFactory(_mintFactory);
4420  
4421     }
4422 
4423     modifier isToken() {
4424         require(mintFactory.tokenIsRegistered(msg.sender), "RA");
4425         _;
4426     }
4427 
4428     function initiateBuyBackTax(address _token, address _wallet) payable external isToken returns(bool) {
4429         ITaxToken token = ITaxToken(_token);
4430         uint256 _amount = token.balanceOf(address(this));
4431         address[] memory addressPaths = new address[](2);
4432         addressPaths[0] = _token;
4433         addressPaths[1] = router.WETH();
4434         token.approve(address(router), _amount);
4435         if(_amount > 0) {
4436             router.swapExactTokensForETHSupportingFeeOnTransferTokens(_amount, 0, addressPaths, _wallet, block.timestamp);
4437         }
4438         IBuyBackWallet buyBackWallet = IBuyBackWallet(_wallet);
4439         bool res = buyBackWallet.checkBuyBackTrigger();
4440         if(res) {
4441             addressPaths[0] = router.WETH();
4442             addressPaths[1] = _token;
4443             uint256 amountEth = buyBackWallet.sendEthToTaxHelper();
4444             uint256 balanceBefore = token.balanceOf(address(this));
4445             router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountEth}(0, addressPaths, address(this), block.timestamp);
4446             // burn baby burn!
4447             uint256 balanceAfter = token.balanceOf(address(this));
4448             uint256 amountToBurn = balanceAfter - balanceBefore;
4449             token.approve(token.owner(), amountToBurn);
4450             token.buyBackBurn(amountToBurn);
4451         }
4452         return true;
4453     }
4454 
4455     function initiateLPTokenTax(address _token, address _wallet) external isToken returns (bool) {
4456         ITaxToken token = ITaxToken(_token);
4457         uint256 _amount = token.balanceOf(address(this));
4458         address[] memory addressPaths = new address[](2);
4459         addressPaths[0] = _token;
4460         addressPaths[1] = router.WETH();
4461         uint256 halfAmount = _amount / 2;
4462         uint256 otherHalf = _amount - halfAmount;
4463         token.transfer(_wallet, otherHalf);
4464         token.approve(address(router), halfAmount);
4465         if(halfAmount > 0) {
4466             router.swapExactTokensForETHSupportingFeeOnTransferTokens(halfAmount, 0, addressPaths, _wallet, block.timestamp);
4467         }
4468         ILPWallet lpWallet = ILPWallet(_wallet);
4469         bool res = lpWallet.checkLPTrigger();
4470         if(res) {
4471             lpWallet.transferBalanceToTaxHelper();
4472             uint256 amountEth = lpWallet.sendEthToTaxHelper();
4473             uint256 tokenBalance = token.balanceOf(address(this));
4474             token.approve(address(router), tokenBalance);
4475             router.addLiquidityETH{value: amountEth}(_token, tokenBalance, 0, 0, token.owner(), block.timestamp + 20 minutes);
4476             uint256 ethDust = address(this).balance;
4477             if(ethDust > 0) {
4478                 (bool sent,) = _wallet.call{value: ethDust}("");
4479                 require(sent, "Failed to send Ether");
4480             }
4481             uint256 tokenDust = token.balanceOf(address(this));
4482             if(tokenDust > 0) {
4483                 token.transfer(_wallet, tokenDust);
4484             }
4485         }
4486         return true;
4487     }    
4488     
4489     function createLPToken() external returns(address lpToken) {
4490         lpToken = factory.createPair(msg.sender, router.WETH());
4491         emit CreatedLPToken(msg.sender, router.WETH(), lpToken);
4492     }
4493 
4494     function lpTokenHasReserves(address _lpToken) public view returns (bool) {
4495         (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(_lpToken).getReserves();
4496         return reserve0 > 0 && reserve1 > 0;
4497     }
4498 
4499     function sync(address _lpToken) public {
4500         IUniswapV2Pair(_lpToken).sync();
4501     }
4502 
4503     receive() payable external {
4504     }
4505 
4506 }