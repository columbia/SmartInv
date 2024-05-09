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
193 contract Constants {
194   address constant NULL_ADDRESS = address(0x0);
195   uint256 constant ZERO = uint256(0);
196   bytes32 constant EMPTY = bytes32(0x0);
197 }
198 
199 contract ACConditions is Constants {
200 
201   modifier not_null_address(address _item) {
202     require(_item != NULL_ADDRESS);
203     _;
204   }
205 
206   modifier if_null_address(address _item) {
207     require(_item == NULL_ADDRESS);
208     _;
209   }
210 
211   modifier not_null_uint(uint256 _item) {
212     require(_item != ZERO);
213     _;
214   }
215 
216   modifier if_null_uint(uint256 _item) {
217     require(_item == ZERO);
218     _;
219   }
220 
221   modifier not_empty_bytes(bytes32 _item) {
222     require(_item != EMPTY);
223     _;
224   }
225 
226   modifier if_empty_bytes(bytes32 _item) {
227     require(_item == EMPTY);
228     _;
229   }
230 
231   modifier not_null_string(string _item) {
232     bytes memory _i = bytes(_item);
233     require(_i.length > 0);
234     _;
235   }
236 
237   modifier if_null_string(string _item) {
238     bytes memory _i = bytes(_item);
239     require(_i.length == 0);
240     _;
241   }
242 
243   modifier require_gas(uint256 _requiredgas) {
244     require(msg.gas  >= (_requiredgas - 22000));
245     _;
246   }
247 
248   function is_contract(address _contract)
249            public
250            constant
251            returns (bool _is_contract)
252   {
253     uint32 _code_length;
254 
255     assembly {
256       _code_length := extcodesize(_contract)
257     }
258 
259     if(_code_length > 1) {
260       _is_contract = true;
261     } else {
262       _is_contract = false;
263     }
264   }
265 
266   modifier if_contract(address _contract) {
267     require(is_contract(_contract) == true);
268     _;
269   }
270 
271   modifier unless_contract(address _contract) {
272     require(is_contract(_contract) == false);
273     _;
274   }
275 }
276 
277 contract MarketplaceStorage {
278 }
279 
280 contract MarketplaceControllerCommon {
281 }
282 
283 contract MarketplaceController {
284 }
285 
286 contract MarketplaceAdminController {
287 }
288 
289 contract MarketplaceCommon is ResolverClient, ACConditions, DigixConstants {
290 
291   function marketplace_admin_controller()
292            internal
293            constant
294            returns (MarketplaceAdminController _contract)
295   {
296     _contract = MarketplaceAdminController(get_contract(CONTRACT_CONTROLLER_MARKETPLACE_ADMIN));
297   }
298 
299   function marketplace_storage()
300            internal
301            constant
302            returns (MarketplaceStorage _contract)
303   {
304     _contract = MarketplaceStorage(get_contract(CONTRACT_STORAGE_MARKETPLACE));
305   }
306 
307   function marketplace_controller()
308            internal
309            constant
310            returns (MarketplaceController _contract)
311   {
312     _contract = MarketplaceController(get_contract(CONTRACT_CONTROLLER_MARKETPLACE));
313   }
314 }
315 
316 contract DigixConstantsExtras {
317     /// storage contracts
318     bytes32 constant CONTRACT_STORAGE_MARKETPLACE_EXTRAS = "s:mp:extras";
319     bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE_ADMIN_EXTRAS = "c:mpadmin:extras";
320     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_V2 = "i:mp:v2";
321     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_ADMIN_EXTRAS = "i:mpadmin:extras";
322 }
323 
324 contract MarketplaceControllerV2 {
325   function purchase_with_eth(
326     uint256 _wei_sent,
327     address _buyer,
328     uint256 _block_number,
329     uint256 _nonce,
330     uint256 _wei_per_dgx_mg,
331     address _signer,
332     bytes _signature
333   ) payable public returns (bool _success, uint256 _purchased_amount);
334 
335   function purchase_with_dai(
336     uint256 _dai_sent,
337     address _buyer,
338     uint256 _block_number,
339     uint256 _nonce,
340     uint256 _dai_per_ton,
341     address _signer,
342     bytes _signature
343   ) public returns (bool _success, uint256 _purchased_amount);
344 }
345 
346 /// @title Digix's Marketplace
347 /// @author Digix Holdings Pte Ltd
348 /// @notice This contract is for KYC-approved users to purchase DGX using ETH
349 contract MarketplaceV2 is MarketplaceCommon, DigixConstantsExtras {
350 
351   function MarketplaceV2(address _resolver) public
352   {
353     require(init(CONTRACT_INTERACTIVE_MARKETPLACE_V2, _resolver));
354   }
355 
356   function marketplace_controller_v2()
357            internal
358            constant
359            returns (MarketplaceControllerV2 _contract)
360   {
361     _contract = MarketplaceControllerV2(get_contract(CONTRACT_CONTROLLER_MARKETPLACE));
362   }
363 
364   /// @dev purchase DGX gold using ETH
365   /// @param _block_number Block number from DTPO (Digix Trusted Price Oracle)
366   /// @param _nonce Nonce from DTPO
367   /// @param _wei_per_dgx_mg Price in wei for one milligram of DGX
368   /// @param _signer Address of the DTPO signer
369   /// @param _signature Signature of the payload
370   /// @return {
371   ///   "_success": "returns true if operation is successful",
372   ///   "_purchased_amount": "DGX nanograms received"
373   /// }
374   function purchaseWithEth(uint256 _block_number, uint256 _nonce, uint256 _wei_per_dgx_mg, address _signer, bytes _signature)
375            payable
376            public
377            returns (bool _success, uint256 _purchased_amount)
378   {
379     address _sender = msg.sender;
380 
381     (_success, _purchased_amount) =
382       marketplace_controller_v2().purchase_with_eth.value(msg.value).gas(600000)(msg.value, _sender, _block_number,
383                                                                              _nonce, _wei_per_dgx_mg, _signer, _signature);
384     require(_success);
385   }
386 
387   /// @dev purchase DGX gold using DAI
388   /// @param _dai_sent amount of DAI sent
389   /// @param _block_number Block number from DTPO (Digix Trusted Price Oracle)
390   /// @param _nonce Nonce from DTPO
391   /// @param _dai_per_ton Despite the variable name, this is actually the price in DAI for 1000 tonnes of DGXs
392   /// @param _signer Address of the DTPO signer
393   /// @param _signature Signature of the payload
394   /// @return {
395   ///   "_success": "returns true if operation is successful",
396   ///   "_purchased_amount": "DGX nanograms received"
397   /// }
398   function purchaseWithDai(uint256 _dai_sent, uint256 _block_number, uint256 _nonce, uint256 _dai_per_ton, address _signer, bytes _signature)
399            public
400            returns (bool _success, uint256 _purchased_amount)
401   {
402     address _sender = msg.sender;
403 
404     (_success, _purchased_amount) =
405       marketplace_controller_v2().purchase_with_dai.gas(800000)(_dai_sent, _sender, _block_number,
406                                                                              _nonce, _dai_per_ton, _signer, _signature);
407     require(_success);
408   }
409 }