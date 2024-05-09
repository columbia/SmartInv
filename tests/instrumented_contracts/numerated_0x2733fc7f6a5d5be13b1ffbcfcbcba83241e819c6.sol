1 pragma solidity ^0.4.19;
2 
3 contract DigixConstants {
4   /// general constants
5   uint256 constant SECONDS_IN_A_DAY = 24 * 60 * 60;
6 
7   /// asset events
8   uint256 constant ASSET_EVENT_CREATED_VENDOR_ORDER = 1;
9   uint256 constant ASSET_EVENT_CREATED_TRANSFER_ORDER = 2;
10   uint256 constant ASSET_EVENT_CREATED_REPLACEMENT_ORDER = 3;
11   uint256 constant ASSET_EVENT_FULFILLED_VENDOR_ORDER = 4;
12   uint256 constant ASSET_EVENT_FULFILLED_TRANSFER_ORDER = 5;
13   uint256 constant ASSET_EVENT_FULFILLED_REPLACEMENT_ORDER = 6;
14   uint256 constant ASSET_EVENT_MINTED = 7;
15   uint256 constant ASSET_EVENT_MINTED_REPLACEMENT = 8;
16   uint256 constant ASSET_EVENT_RECASTED = 9;
17   uint256 constant ASSET_EVENT_REDEEMED = 10;
18   uint256 constant ASSET_EVENT_FAILED_AUDIT = 11;
19   uint256 constant ASSET_EVENT_ADMIN_FAILED = 12;
20   uint256 constant ASSET_EVENT_REMINTED = 13;
21 
22   /// roles
23   uint256 constant ROLE_ZERO_ANYONE = 0;
24   uint256 constant ROLE_ROOT = 1;
25   uint256 constant ROLE_VENDOR = 2;
26   uint256 constant ROLE_XFERAUTH = 3;
27   uint256 constant ROLE_POPADMIN = 4;
28   uint256 constant ROLE_CUSTODIAN = 5;
29   uint256 constant ROLE_AUDITOR = 6;
30   uint256 constant ROLE_MARKETPLACE_ADMIN = 7;
31   uint256 constant ROLE_KYC_ADMIN = 8;
32   uint256 constant ROLE_FEES_ADMIN = 9;
33   uint256 constant ROLE_DOCS_UPLOADER = 10;
34   uint256 constant ROLE_KYC_RECASTER = 11;
35   uint256 constant ROLE_FEES_DISTRIBUTION_ADMIN = 12;
36 
37   /// states
38   uint256 constant STATE_ZERO_UNDEFINED = 0;
39   uint256 constant STATE_CREATED = 1;
40   uint256 constant STATE_VENDOR_ORDER = 2;
41   uint256 constant STATE_TRANSFER = 3;
42   uint256 constant STATE_CUSTODIAN_DELIVERY = 4;
43   uint256 constant STATE_MINTED = 5;
44   uint256 constant STATE_AUDIT_FAILURE = 6;
45   uint256 constant STATE_REPLACEMENT_ORDER = 7;
46   uint256 constant STATE_REPLACEMENT_DELIVERY = 8;
47   uint256 constant STATE_RECASTED = 9;
48   uint256 constant STATE_REDEEMED = 10;
49   uint256 constant STATE_ADMIN_FAILURE = 11;
50 
51   /// interactive contracts
52   bytes32 constant CONTRACT_INTERACTIVE_ASSETS_EXPLORER = "i:asset:explorer";
53   bytes32 constant CONTRACT_INTERACTIVE_DIGIX_DIRECTORY = "i:directory";
54   bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE = "i:mp";
55   bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_ADMIN = "i:mpadmin";
56   bytes32 constant CONTRACT_INTERACTIVE_POPADMIN = "i:popadmin";
57   bytes32 constant CONTRACT_INTERACTIVE_PRODUCTS_LIST = "i:products";
58   bytes32 constant CONTRACT_INTERACTIVE_TOKEN = "i:token";
59   bytes32 constant CONTRACT_INTERACTIVE_BULK_WRAPPER = "i:bulk-wrapper";
60   bytes32 constant CONTRACT_INTERACTIVE_TOKEN_CONFIG = "i:token:config";
61   bytes32 constant CONTRACT_INTERACTIVE_TOKEN_INFORMATION = "i:token:information";
62   bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_INFORMATION = "i:mp:information";
63   bytes32 constant CONTRACT_INTERACTIVE_IDENTITY = "i:identity";
64 
65   /// controller contracts
66   bytes32 constant CONTRACT_CONTROLLER_ASSETS = "c:asset";
67   bytes32 constant CONTRACT_CONTROLLER_ASSETS_RECAST = "c:asset:recast";
68   bytes32 constant CONTRACT_CONTROLLER_ASSETS_EXPLORER = "c:explorer";
69   bytes32 constant CONTRACT_CONTROLLER_DIGIX_DIRECTORY = "c:directory";
70   bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE = "c:mp";
71   bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE_ADMIN = "c:mpadmin";
72   bytes32 constant CONTRACT_CONTROLLER_PRODUCTS_LIST = "c:products";
73 
74   bytes32 constant CONTRACT_CONTROLLER_TOKEN_APPROVAL = "c:token:approval";
75   bytes32 constant CONTRACT_CONTROLLER_TOKEN_CONFIG = "c:token:config";
76   bytes32 constant CONTRACT_CONTROLLER_TOKEN_INFO = "c:token:info";
77   bytes32 constant CONTRACT_CONTROLLER_TOKEN_TRANSFER = "c:token:transfer";
78 
79   bytes32 constant CONTRACT_CONTROLLER_JOB_ID = "c:jobid";
80   bytes32 constant CONTRACT_CONTROLLER_IDENTITY = "c:identity";
81 
82   /// storage contracts
83   bytes32 constant CONTRACT_STORAGE_ASSETS = "s:asset";
84   bytes32 constant CONTRACT_STORAGE_ASSET_EVENTS = "s:asset:events";
85   bytes32 constant CONTRACT_STORAGE_DIGIX_DIRECTORY = "s:directory";
86   bytes32 constant CONTRACT_STORAGE_MARKETPLACE = "s:mp";
87   bytes32 constant CONTRACT_STORAGE_PRODUCTS_LIST = "s:products";
88   bytes32 constant CONTRACT_STORAGE_GOLD_TOKEN = "s:goldtoken";
89   bytes32 constant CONTRACT_STORAGE_JOB_ID = "s:jobid";
90   bytes32 constant CONTRACT_STORAGE_IDENTITY = "s:identity";
91 
92   /// service contracts
93   bytes32 constant CONTRACT_SERVICE_TOKEN_DEMURRAGE = "sv:tdemurrage";
94   bytes32 constant CONTRACT_SERVICE_MARKETPLACE = "sv:mp";
95   bytes32 constant CONTRACT_SERVICE_DIRECTORY = "sv:directory";
96 
97   /// fees distributors
98   bytes32 constant CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR = "fees:distributor:demurrage";
99   bytes32 constant CONTRACT_RECAST_FEES_DISTRIBUTOR = "fees:distributor:recast";
100   bytes32 constant CONTRACT_TRANSFER_FEES_DISTRIBUTOR = "fees:distributor:transfer";
101 }
102 
103 contract ContractResolver {
104   address public owner;
105   bool public locked;
106   function init_register_contract(bytes32 _key, address _contract_address) public returns (bool _success);
107   function unregister_contract(bytes32 _key) public returns (bool _success);
108   function get_contract(bytes32 _key) public constant returns (address _contract);
109 }
110 
111 contract ResolverClient {
112 
113   /// The address of the resolver contract for this project
114   address public resolver;
115   /// The key to identify this contract
116   bytes32 public key;
117 
118   /// Make our own address available to us as a constant
119   address public CONTRACT_ADDRESS;
120 
121   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
122   /// @param _contract The resolver key
123   modifier if_sender_is(bytes32 _contract) {
124     require(msg.sender == ContractResolver(resolver).get_contract(_contract));
125     _;
126   }
127 
128   /// Function modifier to check resolver's locking status.
129   modifier unless_resolver_is_locked() {
130     require(is_locked() == false);
131     _;
132   }
133 
134   /// @dev Initialize new contract
135   /// @param _key the resolver key for this contract
136   /// @return _success if the initialization is successful
137   function init(bytes32 _key, address _resolver)
138            internal
139            returns (bool _success)
140   {
141     bool _is_locked = ContractResolver(_resolver).locked();
142     if (_is_locked == false) {
143       CONTRACT_ADDRESS = address(this);
144       resolver = _resolver;
145       key = _key;
146       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
147       _success = true;
148     }  else {
149       _success = false;
150     }
151   }
152 
153   /// @dev Destroy the contract and unregister self from the ContractResolver
154   /// @dev Can only be called by the owner of ContractResolver
155   function destroy()
156            public
157            returns (bool _success)
158   {
159     bool _is_locked = ContractResolver(resolver).locked();
160     require(!_is_locked);
161 
162     address _owner_of_contract_resolver = ContractResolver(resolver).owner();
163     require(msg.sender == _owner_of_contract_resolver);
164 
165     _success = ContractResolver(resolver).unregister_contract(key);
166     require(_success);
167 
168     selfdestruct(_owner_of_contract_resolver);
169   }
170 
171   /// @dev Check if resolver is locked
172   /// @return _locked if the resolver is currently locked
173   function is_locked()
174            private
175            constant
176            returns (bool _locked)
177   {
178     _locked = ContractResolver(resolver).locked();
179   }
180 
181   /// @dev Get the address of a contract
182   /// @param _key the resolver key to look up
183   /// @return _contract the address of the contract
184   function get_contract(bytes32 _key)
185            public
186            constant
187            returns (address _contract)
188   {
189     _contract = ContractResolver(resolver).get_contract(_key);
190   }
191 }
192 
193 /// @title Some useful constants
194 /// @author Digix Holdings Pte Ltd
195 contract Constants {
196   address constant NULL_ADDRESS = address(0x0);
197   uint256 constant ZERO = uint256(0);
198   bytes32 constant EMPTY = bytes32(0x0);
199 }
200 
201 /// @title Condition based access control
202 /// @author Digix Holdings Pte Ltd
203 contract ACConditions is Constants {
204 
205   modifier not_null_address(address _item) {
206     require(_item != NULL_ADDRESS);
207     _;
208   }
209 
210   modifier if_null_address(address _item) {
211     require(_item == NULL_ADDRESS);
212     _;
213   }
214 
215   modifier not_null_uint(uint256 _item) {
216     require(_item != ZERO);
217     _;
218   }
219 
220   modifier if_null_uint(uint256 _item) {
221     require(_item == ZERO);
222     _;
223   }
224 
225   modifier not_empty_bytes(bytes32 _item) {
226     require(_item != EMPTY);
227     _;
228   }
229 
230   modifier if_empty_bytes(bytes32 _item) {
231     require(_item == EMPTY);
232     _;
233   }
234 
235   modifier not_null_string(string _item) {
236     bytes memory _i = bytes(_item);
237     require(_i.length > 0);
238     _;
239   }
240 
241   modifier if_null_string(string _item) {
242     bytes memory _i = bytes(_item);
243     require(_i.length == 0);
244     _;
245   }
246 
247   modifier require_gas(uint256 _requiredgas) {
248     require(msg.gas  >= (_requiredgas - 22000));
249     _;
250   }
251 
252   function is_contract(address _contract)
253            public
254            constant
255            returns (bool _is_contract)
256   {
257     uint32 _code_length;
258 
259     assembly {
260       _code_length := extcodesize(_contract)
261     }
262 
263     if(_code_length > 1) {
264       _is_contract = true;
265     } else {
266       _is_contract = false;
267     }
268   }
269 
270   modifier if_contract(address _contract) {
271     require(is_contract(_contract) == true);
272     _;
273   }
274 
275   modifier unless_contract(address _contract) {
276     require(is_contract(_contract) == false);
277     _;
278   }
279 }
280 
281 contract IdentityStorage {
282   function read_user(address _user) public constant returns (uint256 _id_expiration, bytes32 _doc);
283 }
284 
285 contract MarketplaceStorage {
286   function read_user(address _user) public constant returns (uint256 _daily_dgx_limit, uint256 _total_purchased_today);
287   function read_user_daily_limit(address _user) public constant returns (uint256 _daily_dgx_limit);
288   function read_config() public constant returns (uint256 _global_daily_dgx_ng_limit, uint256 _minimum_purchase_dgx_ng, uint256 _maximum_block_drift, address _payment_collector);
289   function read_dgx_inventory_balance_ng() public constant returns (uint256 _balance);
290   function read_total_number_of_purchases() public constant returns (uint256 _total_number_of_purchases);
291   function read_total_number_of_user_purchases(address _user) public constant returns (uint256 _total_number_of_user_purchases);
292   function read_purchase_at_index(uint256 _index) public constant returns (address _recipient, uint256 _timestamp, uint256 _amount, uint256 _price);
293   function read_user_purchase_at_index(address _user, uint256 _index) public constant returns (address _recipient, uint256 _timestamp, uint256 _amount, uint256 _price);
294   function read_total_global_purchased_today() public constant returns (uint256 _total_global_purchased_today);
295   function read_total_purchased_today(address _user) public constant returns (uint256 _total_purchased_today);
296   function read_max_dgx_available_daily() public constant returns (uint256 _max_dgx_available_daily);
297   function read_price_floor() public constant returns (uint256 _price_floor_wei_per_dgx_mg);
298 }
299 
300 contract MarketplaceControllerCommon {
301 }
302 
303 contract MarketplaceController {
304 }
305 
306 contract MarketplaceAdminController {
307 }
308 
309 contract MarketplaceCommon is ResolverClient, ACConditions, DigixConstants {
310 
311   function marketplace_admin_controller()
312            internal
313            constant
314            returns (MarketplaceAdminController _contract)
315   {
316     _contract = MarketplaceAdminController(get_contract(CONTRACT_CONTROLLER_MARKETPLACE_ADMIN));
317   }
318 
319   function marketplace_storage()
320            internal
321            constant
322            returns (MarketplaceStorage _contract)
323   {
324     _contract = MarketplaceStorage(get_contract(CONTRACT_STORAGE_MARKETPLACE));
325   }
326 
327   function marketplace_controller()
328            internal
329            constant
330            returns (MarketplaceController _contract)
331   {
332     _contract = MarketplaceController(get_contract(CONTRACT_CONTROLLER_MARKETPLACE));
333   }
334 }
335 
336 /// @title Digix Marketplace Information
337 /// @author Digix Holdings Pte Ltd
338 /// @notice This contract is used to read the configuration of the Digix's Marketplace
339 contract MarketplaceInformation is MarketplaceCommon {
340 
341   function MarketplaceInformation(address _resolver) public
342   {
343     require(init(CONTRACT_INTERACTIVE_MARKETPLACE_INFORMATION, _resolver));
344   }
345 
346   function identity_storage()
347            internal
348            constant
349            returns (IdentityStorage _contract)
350   {
351     _contract = IdentityStorage(get_contract(CONTRACT_STORAGE_IDENTITY));
352   }
353 
354   /// @dev show user's current marketplace information and configuration, as well as some global configurations
355   /// @param _user the user's ethereum address
356   /// @return {
357   ///   "_user_daily_dgx_limit": "the amount of DGX that the user can purchase at any given day",
358   ///   "_user_id_expiration": "if KYC approved this will be a non-zero value as Unix timestamp when the submitted ID will expire",
359   ///   "_user_total_purchased_today": "The amount of tokens that the user has purchased in the last 24 hours",
360   ///   "_config_maximum_block_drift": "The number of ethereum blocks for which a pricefeed is valid for"
361   ///   "_config_minimum_purchase_dgx_ng": "The minimum amount of DGX that has to be purchased in one order",
362   ///   "_config_payment_collector": "Ethereum address of the collector which collects marketplace ether sent by buyers to buy DGX"
363   /// }
364   function getUserInfoAndConfig(address _user)
365            public
366            constant
367            returns (uint256 _user_daily_dgx_limit, uint256 _user_id_expiration, uint256 _user_total_purchased_today,
368                     uint256 _config_global_daily_dgx_ng_limit, uint256 _config_maximum_block_drift,
369                     uint256 _config_minimum_purchase_dgx_ng, address _config_payment_collector)
370   {
371     (_user_daily_dgx_limit, _user_total_purchased_today) =
372       marketplace_storage().read_user(_user);
373 
374     (_user_id_expiration,) = identity_storage().read_user(_user);
375 
376     (_config_global_daily_dgx_ng_limit, _config_minimum_purchase_dgx_ng, _config_maximum_block_drift, _config_payment_collector) =
377       marketplace_storage().read_config();
378   }
379 
380   /// @dev get global marketplace configuration
381   /// @return {
382   ///     "_global_daily_dgx_ng_limit,": "the default max amount of DGX in nanograms the user can purchase daily",
383   ///     "_minimum_purchase_dgx_ng": "The minimum DGX nanograms that can be purchased",
384   ///     "_maximum_block_drift": "The number of blocks a pricefeed is valid for",
385   ///     "_payment_collector": "The ETH address where the payment should be sent to"
386   /// }
387   function getConfig()
388            public
389            constant
390            returns (uint256 _global_daily_dgx_ng_limit, uint256 _minimum_purchase_dgx_ng, uint256 _maximum_block_drift, address _payment_collector)
391   {
392      (_global_daily_dgx_ng_limit, _minimum_purchase_dgx_ng, _maximum_block_drift, _payment_collector) =
393        marketplace_storage().read_config();
394   }
395 
396   /// @dev show the user's daily limit on DGX purchase
397   /// @param _user the user's ethereum address
398   /// @return {
399   ///   "_maximum_purchase_amount_ng": "The amount in DGX nanograms that the user can purchase daily"
400   /// }
401   function userMaximumPurchaseAmountNg(address _user)
402            public
403            constant
404            returns (uint256 _maximum_purchase_amount_ng)
405   {
406     _maximum_purchase_amount_ng = marketplace_storage().read_user_daily_limit(_user);
407   }
408 
409   /// @dev show how many nanograms of DGX is in the Marketplace's inventory
410   /// @return {
411   ///   "_available_ng": "The amount in DGX nanograms in the inventory"
412   /// }
413   function availableDgxNg()
414            public
415            constant
416            returns (uint256 _available_ng)
417   {
418     _available_ng = marketplace_storage().read_dgx_inventory_balance_ng();
419   }
420 
421   /// @dev return the total number of purchases done on marketplace
422   /// @return _total_number_of_purchases the total number of purchases on marketplace
423   function readTotalNumberOfPurchases()
424            public
425            constant
426            returns (uint256 _total_number_of_purchases)
427   {
428     _total_number_of_purchases = marketplace_storage().read_total_number_of_purchases();
429   }
430 
431   /// @dev read the total number of purchases by a user
432   /// @param _user Ethereum address of the user
433   /// @return _total_number_of_user_purchases the total number of purchases made by the user on marketplace
434   function readTotalNumberOfUserPurchases(address _user)
435            public
436            constant
437            returns (uint256 _total_number_of_user_purchases)
438   {
439     _total_number_of_user_purchases = marketplace_storage().read_total_number_of_user_purchases(_user);
440   }
441 
442   /// @dev read the purchase details at an index from all purchases
443   /// @param _index the index of the purchase in all purchases (index starts from 0)
444   /// @return {
445   ///   "_recipient": "DGX was purchases to this Ethereum address",
446   ///   "_timestamp": "the time at which the purchase was made",
447   ///   "_amount": "the amount of DGX nanograms purchased in this purchase",
448   ///   "_price": "the price paid by purchaser in web per dgx milligram"
449   /// }
450   function readPurchaseAtIndex(uint256 _index)
451            public
452            constant
453            returns (address _recipient, uint256 _timestamp, uint256 _amount, uint256 _price)
454   {
455     (_recipient, _timestamp, _amount, _price) = marketplace_storage().read_purchase_at_index(_index);
456   }
457 
458   /// @dev read the purchase details by a user at an index from all the user's purchases
459   /// @param _index the index of the purchase in all purchases by this user (index starts from 0)
460   /// @return {
461   ///   "_recipient": "DGX was purchases to this Ethereum address",
462   ///   "_timestamp": "the time at which the purchase was made",
463   ///   "_amount": "the amount of DGX nanograms purchased in this purchase",
464   ///   "_price": "the price paid by purchaser in web per dgx milligram"
465   /// }
466   function readUserPurchaseAtIndex(address _user, uint256 _index)
467            public
468            constant
469            returns (address _recipient, uint256 _timestamp, uint256 _amount, uint256 _price)
470   {
471     (_recipient, _timestamp, _amount, _price) = marketplace_storage().read_user_purchase_at_index(_user, _index);
472   }
473 
474   /// @dev read the total amount of DGX purchased today
475   /// @return _total_purchased_today the total amount of DGX purchased today at marketplace
476   function readGlobalPurchasedToday()
477            public
478            constant
479            returns (uint256 _total_purchased_today)
480   {
481     _total_purchased_today = marketplace_storage().read_total_global_purchased_today();
482   }
483 
484   /// @dev read the amount of DGX purchased today by a user
485   /// @param _user Ethereum address of the user
486   /// @return _user_total_purchased_today the total amount of DGX purchased today by a user
487   function readUserPurchasedToday(address _user)
488            public
489            constant
490            returns (uint256 _user_total_purchased_today)
491   {
492     _user_total_purchased_today = marketplace_storage().read_total_purchased_today(_user);
493   }
494 
495   /// @dev read the marketplace configurations
496   /// @return {
497   ///   "_global_default_user_daily_limit,": "Default maximum number of DGX nanograms that a user can purchase per day",
498   ///   "_minimum_purchase_dgx_ng": "minimum number of DGX nanograms that has to be purchased in a single purchase",
499   ///   "_maximum_block_drift": "the number of ethereum blocks for which the pricefeed is valid for",
500   ///   "_payment_collector": "the ethereum address that will receive the eth paid for a purchase",
501   ///   "_max_dgx_available_daily": "maximum number of DGX nanograms that are available for purchase on marketplace in a day",
502   ///   "_price_floor_wei_per_dgx_mg": "the price floor, minimum price, below which a purchase is invalid"
503   function readMarketplaceConfigs()
504            public
505            constant
506            returns (uint256 _global_default_user_daily_limit,
507                     uint256 _minimum_purchase_dgx_ng,
508                     uint256 _maximum_block_drift,
509                     address _payment_collector,
510                     uint256 _max_dgx_available_daily,
511                     uint256 _price_floor_wei_per_dgx_mg)
512   {
513     (_global_default_user_daily_limit, _minimum_purchase_dgx_ng, _maximum_block_drift, _payment_collector)
514       = marketplace_storage().read_config();
515     _max_dgx_available_daily = marketplace_storage().read_max_dgx_available_daily();
516     _price_floor_wei_per_dgx_mg = marketplace_storage().read_price_floor();
517   }
518 
519 }