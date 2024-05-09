1 /**
2  * @title ERC721 Non-Fungible Token Standard basic interface
3  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
4  */
5 contract ERC721Basic {
6     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
7     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
8     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
9 
10     function balanceOf(address _owner) public view returns (uint256 _balance);
11     function ownerOf(uint256 _tokenId) public view returns (address _owner);
12     function exists(uint256 _tokenId) public view returns (bool _exists);
13 
14     function approve(address _to, uint256 _tokenId) public;
15     function getApproved(uint256 _tokenId) public view returns (address _operator);
16 
17     function setApprovalForAll(address _operator, bool _approved) public;
18     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
19 
20     function transferFrom(address _from, address _to, uint256 _tokenId) public;
21 
22 
23 }
24 
25 // File: contracts/SafeMath.sol
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 // File: contracts/AddressUtils.sol
61 
62 /**
63  * Utility library of inline functions on addresses
64  */
65 library AddressUtils {
66 
67   /**
68    * Returns whether the target address is a contract
69    * @dev This function will return false if invoked during the constructor of a contract,
70    *  as the code is not actually created until after the constructor finishes.
71    * @param addr address to check
72    * @return whether the target address is a contract
73    */
74     function isContract(address addr) internal view returns (bool) {
75         uint256 size;
76     // XXX Currently there is no better way to check if there is a contract in an address
77     // than to check the size of the code at that address.
78     // See https://ethereum.stackexchange.com/a/14016/36603
79     // for more details about how this works.
80     // TODO Check this again before the Serenity release, because all addresses will be
81     // contracts then.
82         assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
83         return size > 0;
84     }
85 
86 }
87 
88 // File: contracts/acl.sol
89 
90 /**
91 * This is the first version of a simple ACL / Permission Management System
92 * It might differentiate from other Permission Management Systems and therefore be more restrictive in the following points:
93 * Every User can just have one Role
94 * No new Roles "Positions" can be generated
95 * Therefore all possible Roles must be defined at the beginning
96  */
97 
98 
99 contract acl{
100 
101     enum Role {
102         USER,
103         ORACLE,
104         ADMIN
105     }
106 
107     mapping (address=> Role) permissions;
108 
109     constructor() public {
110         permissions[msg.sender] = Role(2);
111     }
112 
113     function setRole(uint8 rolevalue,address entity)external check(2){
114         permissions[entity] = Role(rolevalue);
115     }
116 
117     function getRole(address entity)public view returns(Role){
118         return permissions[entity];
119     }
120 
121     modifier check(uint8 role) {
122         require(uint8(getRole(msg.sender)) == role);
123         _;
124     }
125 }
126 
127 // File: contracts/ERC721BasicToken.sol
128 
129 /**
130  * @title ERC721 Non-Fungible Token Standard basic implementation
131  * @dev edited verison of Open Zepplin implementation
132  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
133  * @dev edited _mint & isApprovedOrOwner modifiers
134  */
135 contract ERC721BasicToken is ERC721Basic, acl {
136     using SafeMath for uint256;
137     using AddressUtils for address;
138 
139     uint public numTokensTotal;
140 
141   // Mapping from token ID to owner
142     mapping (uint256 => address) internal tokenOwner;
143 
144   // Mapping from token ID to approved address
145     mapping (uint256 => address) internal tokenApprovals;
146 
147   // Mapping from owner to number of owned token
148     mapping (address => uint256) internal ownedTokensCount;
149 
150   // Mapping from owner to operator approvals
151     mapping (address => mapping (address => bool)) internal operatorApprovals;
152 
153   /**
154    * @dev Guarantees msg.sender is owner of the given token
155    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
156    */
157     modifier onlyOwnerOf(uint256 _tokenId) {
158         require(ownerOf(_tokenId) == msg.sender);
159         _;
160     }
161 
162   /**
163    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
164    * @param _tokenId uint256 ID of the token to validate
165    */
166     modifier canTransfer(uint256 _tokenId) {
167         require(isApprovedOrOwner(msg.sender, _tokenId));
168         _;
169     }
170 
171   /**
172    * @dev Gets the balance of the specified address
173    * @param _owner address to query the balance of
174    * @return uint256 representing the amount owned by the passed address
175    */
176     function balanceOf(address _owner) public view returns (uint256) {
177         require(_owner != address(0));
178         return ownedTokensCount[_owner];
179     }
180 
181   /**
182    * @dev Gets the owner of the specified token ID
183    * @param _tokenId uint256 ID of the token to query the owner of
184    * @return owner address currently marked as the owner of the given token ID
185    */
186     function ownerOf(uint256 _tokenId) public view returns (address) {
187         address owner = tokenOwner[_tokenId];
188      /* require(owner != address(0)); */
189         return owner;
190     }
191 
192   /**
193    * @dev Returns whether the specified token exists
194    * @param _tokenId uint256 ID of the token to query the existence of
195    * @return whether the token exists
196    */
197     function exists(uint256 _tokenId) public view returns (bool) {
198         address owner = tokenOwner[_tokenId];
199         return owner != address(0);
200     }
201 
202   /**
203    * @dev Approves another address to transfer the given token ID
204    * @dev The zero address indicates there is no approved address.
205    * @dev There can only be one approved address per token at a given time.
206    * @dev Can only be called by the token owner or an approved operator.
207    * @param _to address to be approved for the given token ID
208    * @param _tokenId uint256 ID of the token to be approved
209    */
210     function approve(address _to, uint256 _tokenId) public {
211         address owner = tokenOwner[_tokenId];
212 
213         tokenApprovals[_tokenId] = _to;
214 
215         require(_to != ownerOf(_tokenId));
216         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
217 
218         tokenApprovals[_tokenId] = _to;
219         emit Approval(owner, _to, _tokenId);
220     }
221 
222   /**
223    * @dev Gets the approved address for a token ID, or zero if no address set
224    * @param _tokenId uint256 ID of the token to query the approval of
225    * @return address currently approved for the given token ID
226    */
227     function getApproved(uint256 _tokenId) public view returns (address) {
228         return tokenApprovals[_tokenId];
229     }
230 
231   /**
232    * @dev Sets or unsets the approval of a given operator
233    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
234    * @param _to operator address to set the approval
235    * @param _approved representing the status of the approval to be set
236    */
237     function setApprovalForAll(address _to, bool _approved) public {
238         require(_to != msg.sender);
239         operatorApprovals[msg.sender][_to] = _approved;
240         emit ApprovalForAll(msg.sender, _to, _approved);
241     }
242 
243     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
244         return operatorApprovals[_owner][_operator];
245     }
246 
247   /**
248    * @dev Transfers the ownership of a given token ID to another address
249    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
250    * @dev Requires the msg sender to be the owner, approved, or operator
251    * @param _from current owner of the token
252    * @param _to address to receive the ownership of the given token ID
253    * @param _tokenId uint256 ID of the token to be transferred
254   */
255     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
256         require(_from != address(0));
257         require(_to != address(0));
258 
259         clearApproval(_from, _tokenId);
260         removeTokenFrom(_from, _tokenId);
261         addTokenTo(_to, _tokenId);
262 
263         emit Transfer(_from, _to, _tokenId);
264     }
265 
266 
267 
268   /**
269    * @dev Returns whether the given spender can transfer a given token ID
270    * @param _spender address of the spender to query
271    * @param _tokenId uint256 ID of the token to be transferred
272    * @return bool whether the msg.sender is approved for the given token ID,
273    *  is an operator of the owner, or is the owner of the token
274    */
275     function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool) {
276         address owner = ownerOf(_tokenId);
277         return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
278     }
279 
280   /**
281    * @dev Internal function to mint a new token
282    * @dev Reverts if the given token ID already exists
283    * @param _to The address that will own the minted token
284    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
285    * @dev _check(2) checks msg.sender == ADMIN
286    */
287     function _mint(address _to, uint256 _tokenId) external check(2) {
288         require(_to != address(0));
289         addTokenTo(_to, _tokenId);
290         numTokensTotal = numTokensTotal.add(1);
291         emit Transfer(address(0), _to, _tokenId);
292     }
293 
294   /**
295    * @dev Internal function to burn a specific token
296    * @dev Reverts if the token does not exist
297    * @param _tokenId uint256 ID of the token being burned by the msg.sender
298    */
299     function _burn(address _owner, uint256 _tokenId) external check(2) {
300         clearApproval(_owner, _tokenId);
301         removeTokenFrom(_owner, _tokenId);
302         numTokensTotal = numTokensTotal.sub(1);
303         emit Transfer(_owner, address(0), _tokenId);
304     }
305 
306   /**
307    * @dev Internal function to clear current approval of a given token ID
308    * @dev Reverts if the given address is not indeed the owner of the token
309    * @param _owner owner of the token
310    * @param _tokenId uint256 ID of the token to be transferred
311    */
312     function clearApproval(address _owner, uint256 _tokenId) internal {
313         require(ownerOf(_tokenId) == _owner);
314         if (tokenApprovals[_tokenId] != address(0)) {
315             tokenApprovals[_tokenId] = address(0);
316             emit Approval(_owner, address(0), _tokenId);
317         }
318     }
319 
320   /**
321    * @dev Internal function to add a token ID to the list of a given address
322    * @param _to address representing the new owner of the given token ID
323    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
324    */
325     function addTokenTo(address _to, uint256 _tokenId) internal {
326         require(tokenOwner[_tokenId] == address(0));
327         tokenOwner[_tokenId] = _to;
328         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
329     }
330 
331   /**
332    * @dev Internal function to remove a token ID from the list of a given address
333    * @param _from address representing the previous owner of the given token ID
334    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
335    */
336     function removeTokenFrom(address _from, uint256 _tokenId) internal {
337         require(ownerOf(_tokenId) == _from);
338         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
339         tokenOwner[_tokenId] = address(0);
340     }
341 }
342 
343 // File: contracts/testreg.sol
344 
345 contract testreg is ERC721BasicToken  {
346 
347 	// @param
348 
349     struct TokenStruct {
350         string token_uri;
351     }
352 
353     mapping (uint256 => TokenStruct) TokenId;
354 
355 }
356 
357 // File: contracts/update.sol
358 
359 contract update is testreg {
360 
361     event UpdateToken(uint256 _tokenId, string new_uri);
362 
363     function updatetoken(uint256 _tokenId, string new_uri) external check(1){
364         TokenId[_tokenId].token_uri = new_uri;
365 
366         emit UpdateToken(_tokenId, new_uri);
367     }
368 
369     function _mint_with_uri(address _to, uint256 _tokenId, string new_uri) external check(2) {
370         require(_to != address(0));
371         addTokenTo(_to, _tokenId);
372         numTokensTotal = numTokensTotal.add(1);
373         TokenId[_tokenId].token_uri = new_uri;
374         emit Transfer(address(0), _to, _tokenId);
375     }
376 }
377 
378 // File: contracts/bloomingPool.sol
379 
380 /// @dev altered version of Open Zepplin's 'SplitPayment' contract
381 
382 contract bloomingPool is update {
383 
384     using SafeMath for uint256;
385 
386     uint256 public totalShares = 0;
387     uint256 public totalReleased = 0;
388     bool public freeze;
389 
390     mapping(address => uint256) public shares;
391 
392     constructor() public {
393         freeze = false;
394     }
395 
396     function() public payable { }
397 
398 
399     function calculate_total_shares(uint256 _shares,uint256 unique_id )internal{
400         shares[tokenOwner[unique_id]] = shares[tokenOwner[unique_id]].add(_shares);
401         totalShares = totalShares.add(_shares);
402     }
403 
404     function oracle_call(uint256 unique_id) external check(1){
405         calculate_total_shares(1,unique_id);
406     }
407 
408     function get_shares() external view returns(uint256 individual_shares){
409         return shares[msg.sender];
410     }
411 
412     function freeze_pool(bool _freeze) external check(2){
413         freeze = _freeze;
414     }
415 
416     function reset_individual_shares(address payee)internal {
417         shares[payee] = 0;
418     }
419 
420     function substract_individual_shares(uint256 _shares)internal {
421         totalShares = totalShares - _shares;
422     }
423 
424     function claim()public{
425         payout(msg.sender);
426     }
427 
428     function payout(address to) internal returns(bool){
429         require(freeze == false);
430         address payee = to;
431         require(shares[payee] > 0);
432 
433         uint256 volume = address(this).balance;
434         uint256 payment = volume.mul(shares[payee]).div(totalShares);
435 
436         require(payment != 0);
437         require(address(this).balance >= payment);
438 
439         totalReleased = totalReleased.add(payment);
440         payee.transfer(payment);
441         substract_individual_shares(shares[payee]);
442         reset_individual_shares(payee);
443     }
444 
445     function emergency_withdraw(uint amount) external check(2) {
446         require(amount <= this.balance);
447         msg.sender.transfer(amount);
448     }
449 
450 }
451 
452 // File: contracts/buyable.sol
453 
454 contract buyable is bloomingPool {
455 
456     address INFRASTRUCTURE_POOL_ADDRESS;
457     mapping (uint256 => uint256) TokenIdtosetprice;
458     mapping (uint256 => uint256) TokenIdtoprice;
459 
460     event Set_price_and_sell(uint256 tokenId, uint256 Price);
461     event Stop_sell(uint256 tokenId);
462 
463     constructor() public {}
464 
465     function initialisation(address _infrastructure_address) public check(2){
466         INFRASTRUCTURE_POOL_ADDRESS = _infrastructure_address;
467     }
468 
469     function set_price_and_sell(uint256 UniqueID,uint256 Price) external {
470         approve(address(this), UniqueID);
471         TokenIdtosetprice[UniqueID] = Price;
472         emit Set_price_and_sell(UniqueID, Price);
473     }
474 
475     function stop_sell(uint256 UniqueID) external payable{
476         require(tokenOwner[UniqueID] == msg.sender);
477         clearApproval(tokenOwner[UniqueID],UniqueID);
478         emit Stop_sell(UniqueID);
479     }
480 
481     function buy(uint256 UniqueID) external payable {
482         address _to = msg.sender;
483         require(TokenIdtosetprice[UniqueID] == msg.value);
484         TokenIdtoprice[UniqueID] = msg.value;
485         uint _blooming = msg.value.div(20);
486         uint _infrastructure = msg.value.div(20);
487         uint _combined = _blooming.add(_infrastructure);
488         uint _amount_for_seller = msg.value.sub(_combined);
489         require(tokenOwner[UniqueID].call.gas(99999).value(_amount_for_seller)());
490         this.transferFrom(tokenOwner[UniqueID], _to, UniqueID);
491         if(!INFRASTRUCTURE_POOL_ADDRESS.call.gas(99999).value(_infrastructure)()){
492             revert("transfer to infrastructurePool failed");
493 		}
494     }
495 
496     function get_token_data(uint256 _tokenId) external view returns(uint256 _price, uint256 _setprice, bool _buyable){
497         _price = TokenIdtoprice[_tokenId];
498         _setprice = TokenIdtosetprice[_tokenId];
499         if (tokenApprovals[_tokenId] != address(0)){
500             _buyable = true;
501         }
502     }
503 
504     function get_token_data_buyable(uint256 _tokenId) external view returns(bool _buyable) {
505         if (tokenApprovals[_tokenId] != address(0)){
506             _buyable = true;
507         }
508     }
509 
510     function get_all_sellable_token()external view returns(bool[101] list_of_available){
511         uint i;
512         for(i = 0;i<101;i++) {
513             if (tokenApprovals[i] != address(0)){
514                 list_of_available[i] = true;
515           }else{
516                 list_of_available[i] = false;
517           }
518         }
519     }
520     function get_my_tokens()external view returns(bool[101] list_of_my_tokens){
521         uint i;
522         address _owner = msg.sender;
523         for(i = 0;i<101;i++) {
524             if (tokenOwner[i] == _owner){
525                 list_of_my_tokens[i] = true;
526           }else{
527                 list_of_my_tokens[i] = false;
528           }
529         }
530     }
531 
532 }