1 pragma solidity ^0.8.0;
2  
3 
4 contract Ownable {
5     
6     address public owner;
7     
8     event OwnershipTransferred(address indexed from, address indexed to);
9     
10     /**
11      * Constructor assigns ownership to the address used to deploy the contract.
12      * */
13     constructor() {
14         owner = msg.sender;
15     }
16 
17     function getOwner() public view returns(address) {
18         return owner;
19     }
20 
21     /**
22      * Any function with this modifier in its method signature can only be executed by
23      * the owner of the contract. Any attempt made by any other account to invoke the 
24      * functions with this modifier will result in a loss of gas and the contract's state
25      * will remain untampered.
26      * */
27     modifier onlyOwner {
28         require(msg.sender == owner, "Function restricted to owner of contract");
29         _;
30     }
31 
32     /**
33      * Allows for the transfer of ownership to another address;
34      * 
35      * @param _newOwner The address to be assigned new ownership.
36      * */
37     function transferOwnership(address _newOwner) public onlyOwner {
38         require(
39             _newOwner != address(0)
40             && _newOwner != owner 
41         );
42         emit OwnershipTransferred(owner, _newOwner);
43         owner = _newOwner;
44     }
45 }
46 
47 
48 
49 abstract contract DeprecatedMultisenderSC {
50     function isPremiumMember(address _who) external virtual view returns(bool);
51 }
52 
53 /**
54  * Contract acts as an interface between the Crypto Multisender contract and all ERC20 compliant
55  * tokens. 
56  * */
57 abstract contract ERC20Interface {
58     function transferFrom(address _from, address _to, uint256 _value) public virtual;
59     function balanceOf(address who)  public virtual returns (uint256);
60     function allowance(address owner, address spender)  public view virtual returns (uint256);
61     function transfer(address to, uint256 value) public virtual returns(bool);
62     function gasOptimizedAirdrop(address[] calldata _addrs, uint256[] calldata _values) external virtual; 
63 }
64 
65 /**
66  * Contract acts as an interface between the NFT Crypto Multisender contract and all ERC721 compliant
67  * tokens. 
68  * */
69 abstract contract ERC721Interface {
70     function transferFrom(address _from, address _to, uint256 _tokenId) public virtual;
71     function balanceOf(address who)  public virtual returns (uint256);
72     function isApprovedForAll(address _owner, address _operator) public view virtual returns(bool);
73     function setApprovalForAll(address _operator, bool approved) public virtual;
74     function gasOptimizedAirdrop(address _invoker, address[] calldata _addrs, uint256[] calldata _tokenIds) external virtual;
75 }
76 
77 
78 /**
79  * Contract acts as an interface between the NFT Crypto Multisender contract and all ERC1155 compliant
80  * tokens. 
81  * */
82 abstract contract ERC1155Interface {
83     function safeTransferFrom(address _from, address _to, uint256 _tokenId, uint256 _amount, bytes memory data) public virtual;
84     function balanceOf(address _who, uint256 _id)  public virtual returns (uint256);
85     function isApprovedForAll(address _owner, address _operator) public view virtual returns(bool);
86     function setApprovalForAll(address _operator, bool approved) public virtual;
87     function gasOptimizedAirdrop(address _invoker, address[] calldata _addrs, uint256[] calldata _tokenIds, uint256[] calldata _amounts) external virtual;
88 }
89 
90 
91 
92 contract CryptoMultisender is Ownable {
93  
94     mapping (address => uint256) public tokenTrialDrops;
95     mapping (address => uint256) public userTrialDrops;
96 
97     mapping (address => uint256) public premiumMembershipDiscount;
98     mapping (address => uint256) public membershipExpiryTime;
99 
100     mapping (address => bool) public isGrantedPremiumMember;
101 
102     mapping (address => bool) public isListedToken;
103     mapping (address => uint256) public tokenListingFeeDiscount;
104 
105     mapping (address => bool) public isGrantedListedToken;
106 
107     mapping (address => bool) public isAffiliate;
108     mapping (string => address) public affiliateCodeToAddr;
109     mapping (string => bool) public affiliateCodeExists;
110     mapping (address => string) public affiliateCodeOfAddr;
111     mapping (address => string) public isAffiliatedWith;
112     mapping (string => uint256) public commissionPercentage;
113 
114     uint256 public oneDayMembershipFee;
115     uint256 public sevenDayMembershipFee;
116     uint256 public oneMonthMembershipFee;
117     uint256 public lifetimeMembershipFee;
118     uint256 public tokenListingFee;
119     uint256 public rate;
120     uint256 public dropUnitPrice;
121     address public deprecatedMultisenderAddress;
122 
123     event TokenAirdrop(address indexed by, address indexed tokenAddress, uint256 totalTransfers);
124     event EthAirdrop(address indexed by, uint256 totalTransfers, uint256 ethValue);
125     event NftAirdrop(address indexed by, address indexed nftAddress, uint256 totalTransfers);
126     event RateChanged(uint256 from, uint256 to);
127     event RefundIssued(address indexed to, uint256 totalWei);
128     event ERC20TokensWithdrawn(address token, address sentTo, uint256 value);
129     event CommissionPaid(address indexed to, uint256 value);
130     event NewPremiumMembership(address indexed premiumMember);
131     event NewAffiliatePartnership(address indexed newAffiliate, string indexed affiliateCode);
132     event AffiliatePartnershipRevoked(address indexed affiliate, string indexed affiliateCode);
133     
134     constructor() {
135         rate = 3000;
136         dropUnitPrice = 333333333333333; 
137         oneDayMembershipFee = 9e17;
138         sevenDayMembershipFee = 125e16;
139         oneMonthMembershipFee = 2e18;
140         lifetimeMembershipFee = 25e17;
141         tokenListingFee = 5e18;
142         deprecatedMultisenderAddress=address(0xF521007C7845590C6c5ae46833DEFa0A68883CD4);
143     }
144 
145     /**
146      * Allows the owner of this contract to change the fees for users to become premium members.
147      * 
148      * @param _oneDayFee Fee for single day membership.
149      * @param _sevenDayFee Fee for one week membership.
150      * @param _oneMonthFee Fee for one month membership.
151      * @param _lifetimeFee Fee for lifetime membership.
152      * 
153      * @return success True if the fee is changed successfully. False otherwise.
154      * */
155     function setMembershipFees(uint256 _oneDayFee, uint256 _sevenDayFee, uint256 _oneMonthFee, uint256 _lifetimeFee) public onlyOwner returns(bool success) {
156         require(_oneDayFee>0 && _oneDayFee<_sevenDayFee && _sevenDayFee<_oneMonthFee && _oneMonthFee<_lifetimeFee);
157         oneDayMembershipFee = _oneDayFee;
158         sevenDayMembershipFee = _sevenDayFee;
159         oneMonthMembershipFee = _oneMonthFee;
160         lifetimeMembershipFee = _lifetimeFee;
161         return true;
162     }
163 
164     /**
165      * Allows for the conversion of an unsigned integer to a string value. 
166      * 
167      * @param _i The value of the unsigned integer
168      * 
169      * @return _uintAsString The string value of the unsigned integer.
170      * */
171     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
172         if (_i == 0) {
173             return "0";
174         }
175         uint j = _i;
176         uint len;
177         while (j != 0) {
178             len++;
179             j /= 10;
180         }
181         bytes memory bstr = new bytes(len);
182         uint k = len;
183         while (_i != 0) {
184             k = k-1;
185             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
186             bytes1 b1 = bytes1(temp);
187             bstr[k] = b1;
188             _i /= 10;
189         }
190         return string(bstr);
191     }
192 
193     /**
194     * Used to give change to users who accidentally send too much ETH to payable functions. 
195     *
196     * @param _price The service fee the user has to pay for function execution. 
197     **/
198     function giveChange(uint256 _price) internal {
199         if(msg.value > _price) {
200             uint256 change = msg.value - _price;
201             payable(msg.sender).transfer(change);
202         }
203     }
204     
205     /**
206     * Ensures that the correct affiliate code is used and also ensures that affiliate partners
207     * are not able to 'jack' commissions from existing users who they are not affiliated with. 
208     *
209     * @param _afCode The affiliate code provided by the user.
210     *
211     * @return code The correct affiliate code or void.
212     **/
213     function processAffiliateCode(string memory _afCode) internal returns(string memory code) {
214         if(stringsAreEqual(isAffiliatedWith[msg.sender], "void") || !isAffiliate[affiliateCodeToAddr[_afCode]]) {
215             isAffiliatedWith[msg.sender] = "void";
216             return "void";
217         }
218         if(!stringsAreEqual(_afCode, "") && stringsAreEqual(isAffiliatedWith[msg.sender],"") 
219                                                                 && affiliateCodeExists[_afCode]) {
220             if(affiliateCodeToAddr[_afCode] == msg.sender) {
221                 return "void";
222             }
223             isAffiliatedWith[msg.sender] = _afCode;
224         }
225         if(stringsAreEqual(_afCode,"") && !stringsAreEqual(isAffiliatedWith[msg.sender],"")) {
226             _afCode = isAffiliatedWith[msg.sender];
227         } 
228         if(stringsAreEqual(_afCode,"") || !affiliateCodeExists[_afCode]) {
229             isAffiliatedWith[msg.sender] = "void";
230             _afCode = "void";
231         }
232         return _afCode;
233     }
234 
235     /**
236      * Allows users to check if a user is a premium member or not. 
237      * 
238      * @param _addr The address of the user. 
239      * 
240      * @return isMember True if the user is a premium member, false otherwise.
241      * */
242     function checkIsPremiumMember(address _addr) public view returns(bool isMember) {
243         return membershipExpiryTime[_addr] >= block.timestamp || isGrantedPremiumMember[_addr];
244     }
245 
246     /**
247     * Allows the owner of this contract to grant users with premium membership.
248     *
249     * @param _addr The address of the user who is being granted premium membership.
250     *
251     * @return success True if premium membership is granted successfully. False otherwise. 
252     **/
253     function grantPremiumMembership(address _addr) public onlyOwner returns(bool success) {
254         require(checkIsPremiumMember(_addr) != true, "Is already premiumMember member");
255         isGrantedPremiumMember[_addr] = true;
256         emit NewPremiumMembership(_addr);
257         return true; 
258     }
259 
260     /**
261     * Allows the owner of this contract to revoke a granted membership.
262     *
263     * @param _addr The address of the user whos membership is being revoked.
264     *
265     * @return success True if membership is revoked successfully. False otherwise. 
266     **/
267     function revokeGrantedPremiumMembership(address _addr) public onlyOwner returns(bool success) {
268         require(isGrantedPremiumMember[_addr], "Not a granted membership");
269         isGrantedPremiumMember[_addr] = false;
270         return true;
271     }
272 
273     /**
274      * Allows the owner of the contract to grant a premium membership discount for a specified user.
275      * 
276      * @param _addr The address of the user.
277      * @param _discount The discount being granted.
278      * 
279      * @return success True if function executes successfully, false otherwise.
280      * */
281     function setPremiumMembershipDiscount(address _addr, uint256 _discount) public onlyOwner returns(bool success) {
282         premiumMembershipDiscount[_addr] = _discount;
283         return true;
284     }
285 
286     /**
287      * Allows users to check VIP membership fees for a specific address. This is useful for validating if a discount
288      * has been granted for the specified user. 
289      * 
290      * @param _addr The address of the user.
291      * @param _fee The default fee. 
292      * 
293      * @return fee The membership fee for the specified user. 
294      * 
295      * */
296     function getPremiumMembershipFeeOfUser(address _addr, uint256 _fee) public view returns(uint256 fee) {
297         if(premiumMembershipDiscount[_addr] > 0) {
298             return _fee * premiumMembershipDiscount[_addr] / 100;
299         }
300         return _fee;
301     }
302 
303 
304 
305     /**
306      * Allows the owner of the contract to set the contract address of the old multisender SC.
307      * 
308      * @param _addr The updated address.
309      * */
310     function setDeprecatedMultisenderAddress(address _addr) public onlyOwner {
311         deprecatedMultisenderAddress = _addr;
312     }
313 
314 
315     /**
316      * This function checks if a user address has a membership on the old SC.
317      * 
318      * @param _who The address of the user.
319      * 
320      * @return True if the user is a member on the old SC, false otherwise.
321      * */
322     function isMemberOfOldMultisender(address _who) public view returns(bool) {
323         DeprecatedMultisenderSC oldMultisender = DeprecatedMultisenderSC(deprecatedMultisenderAddress);
324         return oldMultisender.isPremiumMember(_who);
325     }
326 
327 
328     /**
329      * Allows users to transfer their membership from the old SC to this SC. 
330      * 
331      * @return True if there is a membership to be transferred, false otherwise. 
332      * */
333     function transferMembership() public returns(bool) {
334         require(isMemberOfOldMultisender(msg.sender), "No membership to transfer");
335         membershipExpiryTime[msg.sender] = block.timestamp + (36500 * 1 days);
336         return true;
337     }
338     
339 
340     /**
341      * This function is invoked internally the functions for purchasing memberships.
342      * 
343      * @param _days The number of days that the membership will be valid for. 
344      * @param _fee The fee that is to be paid. 
345      * @param _afCode If a user has been refferred by an affiliate partner, they can provide 
346      * an affiliate code so the partner gets commission.
347      * 
348      * @return success True if function executes successfully, false otherwise.
349      * */
350     function assignMembership(uint256 _days, uint256 _fee, string memory _afCode) internal returns(bool success) {
351         require(checkIsPremiumMember(msg.sender) != true, "Is already premiumMember member");
352         uint256 fee = getPremiumMembershipFeeOfUser(msg.sender, _fee);
353         require(
354             msg.value >= fee,
355             string(abi.encodePacked(
356                 "premiumMember fee is: ", uint2str(fee), ". Not enough funds sent. ", uint2str(msg.value)
357             ))
358         );
359         membershipExpiryTime[msg.sender] = block.timestamp + (_days * 1 days);
360         _afCode = processAffiliateCode(_afCode);
361         giveChange(fee);
362         distributeCommission(fee, _afCode);
363         emit NewPremiumMembership(msg.sender);
364         return true; 
365     }
366 
367     /**
368     * Allows users to become lifetime members.
369     *
370     * @param _afCode If a user has been refferred by an affiliate partner, they can provide 
371     * an affiliate code so the partner gets commission.
372     *
373     * @return success True if user successfully becomes premium member. False otherwise. 
374     **/
375     function becomeLifetimeMember(string memory _afCode) public payable returns(bool success) {
376         assignMembership(36500, lifetimeMembershipFee, _afCode);
377         return true;
378     }
379 
380 
381     /**
382     * Allows users to become members for 1 day.
383     *
384     * @param _afCode If a user has been refferred by an affiliate partner, they can provide 
385     * an affiliate code so the partner gets commission.
386     *
387     * @return success True if user successfully becomes premium member. False otherwise. 
388     **/
389     function becomeOneDayMember(string memory _afCode) public payable returns(bool success) {
390         assignMembership(1, oneDayMembershipFee, _afCode);
391         return true;
392     }
393 
394 
395     /**
396     * Allows users to become members for 7 days.
397     *
398     * @param _afCode If a user has been refferred by an affiliate partner, they can provide 
399     * an affiliate code so the partner gets commission.
400     *
401     * @return success True if user successfully becomes premium member. False otherwise. 
402     **/
403     function becomeOneWeekMember(string memory _afCode) public payable returns(bool success) {
404         assignMembership(7, sevenDayMembershipFee, _afCode);
405         return true;
406     }
407 
408 
409     /**
410     * Allows users to become members for 1 month
411     *
412     * @param _afCode If a user has been refferred by an affiliate partner, they can provide 
413     * an affiliate code so the partner gets commission.
414     *
415     * @return success True if user successfully becomes premium member. False otherwise. 
416     **/
417     function becomeOneMonthMember(string memory _afCode) public payable returns(bool success) {
418         assignMembership(31, oneMonthMembershipFee, _afCode);
419         return true;
420     }
421 
422 
423     /**
424      * Allows users to check whether or not a token is listed.
425      * 
426      * @param _tokenAddr The address of the token to query.
427      * 
428      * @return isListed True if the token is listed, false otherwise. 
429      * */
430     function checkIsListedToken(address _tokenAddr) public view returns(bool isListed) {
431         return isListedToken[_tokenAddr] || isGrantedListedToken[_tokenAddr];
432     }
433 
434 
435     /**
436      * Allows the owner of the contract to set a listing discount for a specified token.
437      * 
438      * @param _tokenAddr The address of the token that will receive the discount. 
439      * @param _discount The discount that will be applied. 
440      * 
441      * @return success True if function executes successfully, false otherwise.
442      * */
443     function setTokenListingFeeDiscount(address _tokenAddr, uint256 _discount) public onlyOwner returns(bool success) {
444         tokenListingFeeDiscount[_tokenAddr] = _discount;
445         return true;
446     }
447 
448     /**
449      * Allows users to query the listing fee for a token. This is useful to verify that a discount has been set. 
450      * 
451      * @param _tokenAddr The address of the token. 
452      * 
453      * @return fee The listing fee for the token. 
454      * */
455     function getListingFeeForToken(address _tokenAddr) public view returns(uint256 fee) {
456         if(tokenListingFeeDiscount[_tokenAddr] > 0) {
457             return tokenListingFee * tokenListingFeeDiscount[_tokenAddr] / 100;
458         }
459         return tokenListingFee;
460     }
461 
462     /**
463      * Allows users to list a token of their choosing. 
464      * 
465      * @param _tokenAddr The address of the token that will be listed. 
466      * @param _afCode If the user is affiliated with a partner, they will provide this code so that 
467      * the parter is paid commission.
468      * 
469      * @return success True if function executes successfully, false otherwise.
470      * */
471     function purchaseTokenListing(address _tokenAddr, string memory _afCode) public payable returns(bool success) {
472         require(!checkIsListedToken(_tokenAddr), "Token is already listed");
473         _afCode = processAffiliateCode(_afCode);
474         uint256 fee = getListingFeeForToken(_tokenAddr);
475         require(msg.value >= fee, "Not enough funds sent for listing");
476         isListedToken[_tokenAddr] = true;
477         giveChange(fee);
478         distributeCommission(fee, _afCode);
479         return true;
480     }
481 
482     /**
483      * Allows the owner of the contract to revoke a granted token listing. 
484      * 
485      * @param _tokenAddr The address of the token that is being delisted. 
486      * 
487      * @return success True if function executes successfully, false otherwise.
488      * */
489     function revokeGrantedTokenListing(address _tokenAddr) public onlyOwner returns(bool success) {
490         require(checkIsListedToken(_tokenAddr), "Is not listed token");
491         isGrantedListedToken[_tokenAddr] = false;
492         return  true;
493     }
494 
495 
496     /**
497      * Allows the owner of the contract to grant a token a free listing. 
498      * 
499      * @param _tokenAddr The address of the token being listed.
500      * 
501      * @return success True if function executes successfully, false otherwise.
502      * */
503     function grantTokenListing(address _tokenAddr) public onlyOwner returns(bool success){
504         require(!checkIsListedToken(_tokenAddr), "Token is already listed");
505         isGrantedListedToken[_tokenAddr] = true;
506         return true;
507     }
508 
509     /**
510      * Allows the owner of the contract to modify the token listing fee. 
511      * 
512      * @param _newFee The new fee for token listings. 
513      * 
514      * @return success True if function executes successfully, false otherwise.
515      * */
516     function setTokenListingFee(uint256 _newFee) public onlyOwner returns(bool success){
517         tokenListingFee = _newFee;
518         return true;
519     }
520     
521     /**
522     * Allows the owner of this contract to add an affiliate partner.
523     *
524     * @param _addr The address of the new affiliate partner.
525     * @param _code The affiliate code.
526     * 
527     * @return success True if the affiliate has been added successfully. False otherwise. 
528     **/
529     function addAffiliate(address _addr, string memory _code, uint256 _percentage) public onlyOwner returns(bool success) {
530         require(!isAffiliate[_addr], "Address is already an affiliate.");
531         require(_addr != address(0), "0x00 address not allowed");
532         require(!affiliateCodeExists[_code], "Affiliate code already exists!");
533         require(_percentage <= 100 && _percentage > 0, "Percentage must be > 0 && <= 100");
534         affiliateCodeExists[_code] = true;
535         isAffiliate[_addr] = true;
536         affiliateCodeToAddr[_code] = _addr;
537         affiliateCodeOfAddr[_addr] = _code;
538         commissionPercentage[_code] = _percentage;
539         emit NewAffiliatePartnership(_addr,_code);
540         return true;
541     }
542 
543 
544     /**
545      * Allows the owner of the contract to set a customised commission percentage for a given affiliate partner.
546      * 
547      * @param _addressOfAffiliate The wallet address of the affiliate partner.
548      * @param _percentage The commission percentage the affiliate will receive.
549      * 
550      * @return success True if function executes successfully, false otherwise.
551      * */
552     function changeAffiliatePercentage(address _addressOfAffiliate, uint256 _percentage) public onlyOwner returns(bool success) { 
553         require(isAffiliate[_addressOfAffiliate]);
554         string storage affCode = affiliateCodeOfAddr[_addressOfAffiliate];
555         commissionPercentage[affCode] = _percentage;
556         return true;
557     }
558 
559     /**
560     * Allows the owner of this contract to remove an affiliate partner. 
561     *
562     * @param _addr The address of the affiliate partner.
563     *
564     * @return success True if affiliate partner is removed successfully. False otherwise. 
565     **/
566     function removeAffiliate(address _addr) public onlyOwner returns(bool success) {
567         require(isAffiliate[_addr]);
568         isAffiliate[_addr] = false;
569         affiliateCodeToAddr[affiliateCodeOfAddr[_addr]] = address(0);
570         emit AffiliatePartnershipRevoked(_addr, affiliateCodeOfAddr[_addr]);
571         affiliateCodeOfAddr[_addr] = "No longer an affiliate partner";
572         return true;
573     }
574     
575     /**
576      * Checks whether or not an ERC20 token has used its free trial of 100 drops. This is a constant 
577      * function which does not alter the state of the contract and therefore does not require any gas 
578      * or a signature to be executed. 
579      * 
580      * @param _addressOfToken The address of the token being queried.
581      * 
582      * @return hasFreeTrial true if the token being queried has not used its 100 first free trial drops, false
583      * otherwise.
584      * */
585     function tokenHasFreeTrial(address _addressOfToken) public view returns(bool hasFreeTrial) {
586         return tokenTrialDrops[_addressOfToken] < 100;
587     }
588 
589 
590     /**
591      * Checks whether or not a user has a free trial. 
592      * 
593      * @param _addressOfUser The address of the user being queried.
594      * 
595      * @return hasFreeTrial true if the user address being queried has not used the first 100 free trial drops, false
596      * otherwise.
597      * */
598     function userHasFreeTrial(address _addressOfUser) public view returns(bool hasFreeTrial) {
599         return userTrialDrops[_addressOfUser] < 100;
600     }
601     
602     /**
603      * Checks how many remaining free trial drops a token has.
604      * 
605      * @param _addressOfToken the address of the token being queried.
606      * 
607      * @return remainingTrialDrops the total remaining free trial drops of a token.
608      * */
609     function getRemainingTokenTrialDrops(address _addressOfToken) public view returns(uint256 remainingTrialDrops) {
610         if(tokenHasFreeTrial(_addressOfToken)) {
611             uint256 maxTrialDrops =  100;
612             return maxTrialDrops - tokenTrialDrops[_addressOfToken];
613         } 
614         return 0;
615     }
616 
617     /**
618      * Checks how many remaining free trial drops a user has.
619      * 
620      * @param _addressOfUser the address of the user being queried.
621      * 
622      * @return remainingTrialDrops the total remaining free trial drops of a user.
623      * */
624     function getRemainingUserTrialDrops(address _addressOfUser) public view returns(uint256 remainingTrialDrops) {
625         if(userHasFreeTrial(_addressOfUser)) {
626             uint256 maxTrialDrops =  100;
627             return maxTrialDrops - userTrialDrops[_addressOfUser];
628         }
629         return 0;
630     }
631     
632     /**
633      * Allows for the price of drops to be changed by the owner of the contract. Any attempt made by 
634      * any other account to invoke the function will result in a loss of gas and the price will remain 
635      * untampered.
636      * 
637      * @return success true if function executes successfully, false otherwise.
638      * */
639     function setRate(uint256 _newRate) public onlyOwner returns(bool success) {
640         require(
641             _newRate != rate 
642             && _newRate > 0
643         );
644         emit RateChanged(rate, _newRate);
645         rate = _newRate;
646         uint256 eth = 1 ether;
647         dropUnitPrice = eth / rate;
648         return true;
649     }
650     
651     /**
652      * Allows for the allowance of a token from its owner to this contract to be queried. 
653      * 
654      * As part of the ERC20 standard all tokens which fall under this category have an allowance 
655      * function which enables owners of tokens to allow (or give permission) to another address 
656      * to spend tokens on behalf of the owner. This contract uses this as part of its protocol.
657      * Users must first give permission to the contract to transfer tokens on their behalf, however,
658      * this does not mean that the tokens will ever be transferrable without the permission of the 
659      * owner. This is a security feature which was implemented on this contract. It is not possible
660      * for the owner of this contract or anyone else to transfer the tokens which belong to others. 
661      * 
662      * @param _addr The address of the token's owner.
663      * @param _addressOfToken The contract address of the ERC20 token.
664      * 
665      * @return allowance The ERC20 token allowance from token owner to this contract. 
666      * */
667     function getTokenAllowance(address _addr, address _addressOfToken) public view returns(uint256 allowance) {
668         ERC20Interface token = ERC20Interface(_addressOfToken);
669         return token.allowance(_addr, address(this));
670     }
671     
672     fallback() external payable {
673         revert();
674     }
675 
676     receive() external payable {
677         revert();
678     }
679     
680     /**
681     * Checks if two strings are the same.
682     *
683     * @param _a String 1
684     * @param _b String 2
685     *
686     * @return areEqual True if both strings are the same. False otherwise. 
687     **/
688     function stringsAreEqual(string memory _a, string memory _b) internal pure returns(bool areEqual) {
689         bytes32 hashA = keccak256(abi.encodePacked(_a));
690         bytes32 hashB = keccak256(abi.encodePacked(_b));
691         return hashA == hashB;
692     }
693     
694     /**
695      * Allows for the distribution of Ether to be transferred to multiple recipients at 
696      * a time. 
697      * 
698      * @param _recipients The list of addresses which will receive tokens. 
699      * @param _values The corresponding amounts that the recipients will receive 
700      * @param _afCode If the user is affiliated with a partner, they will provide this code so that 
701      * the parter is paid commission.
702      * 
703      * @return success true if function executes successfully, false otherwise.
704      * */
705     function airdropNativeCurrency(address[] memory _recipients, uint256[] memory _values, uint256 _totalToSend, string memory _afCode) public payable returns(bool success) {
706         require(_recipients.length == _values.length, "Total number of recipients and values are not equal");
707         uint256 totalEthValue = _totalToSend;
708         uint256 price = _recipients.length * dropUnitPrice;
709         uint256 totalCost = totalEthValue + price;
710         bool userHasTrial = userHasFreeTrial(msg.sender);
711         bool isVIP = checkIsPremiumMember(msg.sender) == true;
712         require(
713             msg.value >= totalCost || isVIP || userHasTrial, 
714             "Not enough funds sent with transaction!"
715         );
716         _afCode = processAffiliateCode(_afCode);
717         if(!isVIP && !userHasTrial) {
718             distributeCommission(price, _afCode);
719         }
720         if((isVIP || userHasTrial) && msg.value > _totalToSend) {
721             payable(msg.sender).transfer((msg.value) - _totalToSend);
722         } else {
723             giveChange(totalCost);
724         }
725         for(uint i = 0; i < _recipients.length; i++) {
726             payable(_recipients[i]).transfer(_values[i]);
727         }
728         if(userHasTrial) {
729             userTrialDrops[msg.sender] = userTrialDrops[msg.sender] + _recipients.length;
730         }
731         emit EthAirdrop(msg.sender, _recipients.length, totalEthValue);
732         return true;
733     }
734 
735     /**
736      * Allows for the distribution of an ERC20 token to be transferred to multiple recipients at 
737      * a time. This function facilitates batch transfers of differing values (i.e., all recipients
738      * can receive different amounts of tokens).
739      * 
740      * @param _addressOfToken The contract address of an ERC20 token.
741      * @param _recipients The list of addresses which will receive tokens. 
742      * @param _values The corresponding values of tokens which each address will receive.
743      * @param _optimized Should only be enabled for tokens with gas optimized distribution functions. 
744      * @param _afCode If the user is affiliated with a partner, they will provide this code so that 
745      * the parter is paid commission.
746      * 
747      * @return success true if function executes successfully, false otherwise.
748      * */    
749     function erc20Airdrop(address _addressOfToken,  address[] memory _recipients, uint256[] memory _values, uint256 _totalToSend, bool _isDeflationary, bool _optimized, string memory _afCode) public payable returns(bool success) {
750         string memory afCode = processAffiliateCode(_afCode);
751         ERC20Interface token = ERC20Interface(_addressOfToken);
752         require(_recipients.length == _values.length, "Total number of recipients and values are not equal");
753         uint256 price = _recipients.length * dropUnitPrice;
754         bool isPremiumOrListed = checkIsPremiumMember(msg.sender) || checkIsListedToken(_addressOfToken);
755         bool eligibleForFreeTrial = tokenHasFreeTrial(_addressOfToken) && userHasFreeTrial(msg.sender);
756         require(
757             msg.value >= price || tokenHasFreeTrial(_addressOfToken) || userHasFreeTrial(msg.sender) || isPremiumOrListed,
758             "Not enough funds sent with transaction!"
759         );
760         if((eligibleForFreeTrial || isPremiumOrListed) && msg.value > 0) {
761             payable(msg.sender).transfer(msg.value);
762         } else {
763             giveChange(price);
764         }
765 
766         if(_optimized) {
767             token.transferFrom(msg.sender, address(this), _totalToSend);
768             token.gasOptimizedAirdrop(_recipients,_values);
769         } else {
770             if(!_isDeflationary) {
771                 token.transferFrom(msg.sender, address(this), _totalToSend);
772                 for(uint i = 0; i < _recipients.length; i++) {
773                     token.transfer(_recipients[i], _values[i]);
774                 }
775                 if(token.balanceOf(address(this)) > 0) {
776                     token.transfer(msg.sender,token.balanceOf(address(this)));
777                 }
778             } else {
779                 for(uint i=0; i < _recipients.length; i++) {
780                     token.transferFrom(msg.sender, _recipients[i], _values[i]);
781                 }
782             }
783         }
784 
785         if(tokenHasFreeTrial(_addressOfToken)) {
786             tokenTrialDrops[_addressOfToken] = tokenTrialDrops[_addressOfToken] + _recipients.length;
787         }
788         if(userHasFreeTrial(msg.sender)) {
789             userTrialDrops[msg.sender] = userTrialDrops[msg.sender] + _recipients.length;
790         }
791         if(!eligibleForFreeTrial && !isPremiumOrListed) {
792             distributeCommission(_recipients.length * dropUnitPrice, afCode);
793         }
794         emit TokenAirdrop(msg.sender, _addressOfToken, _recipients.length);
795         return true;
796     }
797 
798 
799     /**
800      * Allows for the distribution of ERC721 tokens to be transferred to multiple recipients at 
801      * a time. 
802      * 
803      * @param _addressOfNFT The contract address of an ERC721 token collection.
804      * @param _recipients The list of addresses which will receive tokens. 
805      * @param _tokenIds The corresponding IDs of the NFT collection which each address will receive.
806      * @param _optimized Should only be enabled for ERC721 token collections with gas optimized distribution functions. 
807      * @param _afCode If the user is affiliated with a partner, they will provide this code so that 
808      * the parter is paid commission.
809      * 
810      * @return success true if function executes successfully, false otherwise.
811      * */ 
812     function erc721Airdrop(address _addressOfNFT, address[] memory _recipients, uint256[] memory _tokenIds, bool _optimized, string memory _afCode) public payable returns(bool success) {
813         require(_recipients.length == _tokenIds.length, "Total number of recipients and total number of NFT IDs are not the same");
814         string memory afCode = processAffiliateCode(_afCode);
815         ERC721Interface erc721 = ERC721Interface(_addressOfNFT);
816         uint256 price = _recipients.length * dropUnitPrice;
817         bool isPremiumOrListed = checkIsPremiumMember(msg.sender) || checkIsListedToken(_addressOfNFT);
818         bool eligibleForFreeTrial = tokenHasFreeTrial(_addressOfNFT) && userHasFreeTrial(msg.sender);
819         require(
820             msg.value >= price || eligibleForFreeTrial || isPremiumOrListed,
821             "Not enough funds sent with transaction!"
822         );
823         if((eligibleForFreeTrial || isPremiumOrListed) && msg.value > 0) {
824             payable(msg.sender).transfer(msg.value);
825         } else {
826             giveChange(price);
827         }
828         if(_optimized){
829             erc721.gasOptimizedAirdrop(msg.sender,_recipients,_tokenIds);
830         } else {
831             for(uint i = 0; i < _recipients.length; i++) {
832                 erc721.transferFrom(msg.sender, _recipients[i], _tokenIds[i]);
833             }
834         }
835         if(tokenHasFreeTrial(_addressOfNFT)) {
836             tokenTrialDrops[_addressOfNFT] = tokenTrialDrops[_addressOfNFT] + _recipients.length;
837         }
838         if(userHasFreeTrial(msg.sender)) {
839             userTrialDrops[msg.sender] = userTrialDrops[msg.sender] + _recipients.length;
840         }
841         if(!eligibleForFreeTrial && !isPremiumOrListed) {
842             distributeCommission(_recipients.length * dropUnitPrice, afCode);
843         }
844         emit NftAirdrop(msg.sender, _addressOfNFT, _recipients.length);
845         return true;
846     }
847 
848     /**
849      * Allows for the distribution of ERC1155 tokens to be transferred to multiple recipients at 
850      * a time. 
851      * 
852      * @param _addressOfNFT The contract address of an ERC1155 token contract.
853      * @param _recipients The list of addresses which will receive tokens. 
854      * @param _ids The corresponding IDs of the token collection which each address will receive.
855      * @param _amounts The amount of tokens to send from each token type.
856      * @param _optimized Should only be enabled for ERC721 token collections with gas optimized distribution functions. 
857      * @param _afCode If the user is affiliated with a partner, they will provide this code so that 
858      * the parter is paid commission.
859      * 
860      * @return success true if function executes successfully, false otherwise.
861      * */ 
862     function erc1155Airdrop(address _addressOfNFT, address[] memory _recipients, uint256[] memory _ids, uint256[] memory _amounts, bool _optimized, string memory _afCode) public payable returns(bool success) {
863         require(_recipients.length == _ids.length, "Total number of recipients and total number of NFT IDs are not the same");
864         require(_recipients.length == _amounts.length, "Total number of recipients and total number of amounts are not the same");
865         string memory afCode = processAffiliateCode(_afCode);
866         ERC1155Interface erc1155 = ERC1155Interface(_addressOfNFT);
867         uint256 price = _recipients.length * dropUnitPrice;
868         bool isPremiumOrListed = checkIsPremiumMember(msg.sender) || checkIsListedToken(_addressOfNFT);
869         bool eligibleForFreeTrial = tokenHasFreeTrial(_addressOfNFT) && userHasFreeTrial(msg.sender);
870         require(
871             msg.value >= price || eligibleForFreeTrial || isPremiumOrListed,
872             "Not enough funds sent with transaction!"
873         );
874         if((eligibleForFreeTrial || isPremiumOrListed) && msg.value > 0) {
875             payable(msg.sender).transfer(msg.value);
876         } else {
877             giveChange(price);
878         }
879         if(_optimized){
880             erc1155.gasOptimizedAirdrop(msg.sender,_recipients,_ids,_amounts);
881         } else {
882             for(uint i = 0; i < _recipients.length; i++) {
883                 erc1155.safeTransferFrom(msg.sender, _recipients[i], _ids[i], _amounts[i], "");
884             }
885         }
886         if(tokenHasFreeTrial(_addressOfNFT)) {
887             tokenTrialDrops[_addressOfNFT] = tokenTrialDrops[_addressOfNFT] + _recipients.length;
888         }
889         if(userHasFreeTrial(msg.sender)) {
890             userTrialDrops[msg.sender] = userTrialDrops[msg.sender] + _recipients.length;
891         }
892         if(!eligibleForFreeTrial && !isPremiumOrListed) {
893             distributeCommission(_recipients.length * dropUnitPrice, afCode);
894         }
895         emit NftAirdrop(msg.sender, _addressOfNFT, _recipients.length);
896         return true;
897     }
898 
899 
900     /**
901     * Send the owner and affiliates commissions.
902     **/
903     function distributeCommission(uint256 _profits, string memory _afCode) internal {
904         if(!stringsAreEqual(_afCode,"void") && isAffiliate[affiliateCodeToAddr[_afCode]]) {
905             uint256 commission = _profits * commissionPercentage[_afCode] / 100;
906             payable(owner).transfer(_profits - commission);
907             payable(affiliateCodeToAddr[_afCode]).transfer(commission);
908             emit CommissionPaid(affiliateCodeToAddr[_afCode], commission);
909         } else {
910             payable(owner).transfer(_profits);
911         }
912     }
913 
914 
915     /**
916      * Allows the owner of the contract to withdraw any funds that may reside on the contract address.
917      * */
918     function withdrawFunds() public onlyOwner returns(bool success) {
919         payable(owner).transfer(address(this).balance);
920         return true;
921     }
922 
923     /**
924      * Allows for any ERC20 tokens which have been mistakenly  sent to this contract to be returned 
925      * to the original sender by the owner of the contract. Any attempt made by any other account 
926      * to invoke the function will result in a loss of gas and no tokens will be transferred out.
927      * 
928      * @param _addressOfToken The contract address of an ERC20 token.
929      * @param _recipient The address which will receive tokens. 
930      * @param _value The amount of tokens to refund.
931      * 
932      * @return success true if function executes successfully, false otherwise.
933      * */  
934     function withdrawERC20Tokens(address _addressOfToken,  address _recipient, uint256 _value) public onlyOwner returns(bool success){
935         ERC20Interface token = ERC20Interface(_addressOfToken);
936         token.transfer(_recipient, _value);
937         emit ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
938         return true;
939     }
940 
941 }