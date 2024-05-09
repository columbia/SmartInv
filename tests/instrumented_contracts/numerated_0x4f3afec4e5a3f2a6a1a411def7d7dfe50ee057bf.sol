1 pragma solidity ^0.4.19;
2 
3 /// @title Contract Resolver Interface
4 /// @author Digix Holdings Pte Ltd
5 
6 contract ResolverClient {
7 
8   /// The address of the resolver contract for this project
9   address public resolver;
10   /// The key to identify this contract
11   bytes32 public key;
12 
13   /// Make our own address available to us as a constant
14   address public CONTRACT_ADDRESS;
15 
16   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
17   /// @param _contract The resolver key
18   modifier if_sender_is(bytes32 _contract) {
19     require(msg.sender == ContractResolver(resolver).get_contract(_contract));
20     _;
21   }
22 
23   /// Function modifier to check resolver's locking status.
24   modifier unless_resolver_is_locked() {
25     require(is_locked() == false);
26     _;
27   }
28 
29   /// @dev Initialize new contract
30   /// @param _key the resolver key for this contract
31   /// @return _success if the initialization is successful
32   function init(bytes32 _key, address _resolver)
33            internal
34            returns (bool _success)
35   {
36     bool _is_locked = ContractResolver(_resolver).locked();
37     if (_is_locked == false) {
38       CONTRACT_ADDRESS = address(this);
39       resolver = _resolver;
40       key = _key;
41       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
42       _success = true;
43     }  else {
44       _success = false;
45     }
46   }
47 
48   /// @dev Destroy the contract and unregister self from the ContractResolver
49   /// @dev Can only be called by the owner of ContractResolver
50   function destroy()
51            public
52            returns (bool _success)
53   {
54     bool _is_locked = ContractResolver(resolver).locked();
55     require(!_is_locked);
56 
57     address _owner_of_contract_resolver = ContractResolver(resolver).owner();
58     require(msg.sender == _owner_of_contract_resolver);
59 
60     _success = ContractResolver(resolver).unregister_contract(key);
61     require(_success);
62 
63     selfdestruct(_owner_of_contract_resolver);
64   }
65 
66   /// @dev Check if resolver is locked
67   /// @return _locked if the resolver is currently locked
68   function is_locked()
69            private
70            constant
71            returns (bool _locked)
72   {
73     _locked = ContractResolver(resolver).locked();
74   }
75 
76   /// @dev Get the address of a contract
77   /// @param _key the resolver key to look up
78   /// @return _contract the address of the contract
79   function get_contract(bytes32 _key)
80            public
81            constant
82            returns (address _contract)
83   {
84     _contract = ContractResolver(resolver).get_contract(_key);
85   }
86 }
87 
88 contract ContractResolver {
89   address public owner;
90   bool public locked;
91   function init_register_contract(bytes32 _key, address _contract_address)
92            public
93            returns (bool _success) {}
94 
95   /// @dev Unregister a contract.  This can only be called from the contract with the key itself
96   /// @param _key the bytestring of the contract name
97   /// @return _success if the operation is successful
98   function unregister_contract(bytes32 _key)
99            public
100            returns (bool _success) {}
101 
102   /// @dev Get address of a contract
103   /// @param _key the bytestring name of the contract to look up
104   /// @return _contract the address of the contract
105   function get_contract(bytes32 _key)
106            public
107            constant
108            returns (address _contract) {}
109 }
110 
111 contract DigixConstants {
112     /// general constants
113     uint256 constant SECONDS_IN_A_DAY = 24 * 60 * 60;
114 
115     /// asset events
116     uint256 constant ASSET_EVENT_CREATED_VENDOR_ORDER = 1;
117     uint256 constant ASSET_EVENT_CREATED_TRANSFER_ORDER = 2;
118     uint256 constant ASSET_EVENT_CREATED_REPLACEMENT_ORDER = 3;
119     uint256 constant ASSET_EVENT_FULFILLED_VENDOR_ORDER = 4;
120     uint256 constant ASSET_EVENT_FULFILLED_TRANSFER_ORDER = 5;
121     uint256 constant ASSET_EVENT_FULFILLED_REPLACEMENT_ORDER = 6;
122     uint256 constant ASSET_EVENT_MINTED = 7;
123     uint256 constant ASSET_EVENT_MINTED_REPLACEMENT = 8;
124     uint256 constant ASSET_EVENT_RECASTED = 9;
125     uint256 constant ASSET_EVENT_REDEEMED = 10;
126     uint256 constant ASSET_EVENT_FAILED_AUDIT = 11;
127     uint256 constant ASSET_EVENT_ADMIN_FAILED = 12;
128     uint256 constant ASSET_EVENT_REMINTED = 13;
129 
130     /// roles
131     uint256 constant ROLE_ZERO_ANYONE = 0;
132     uint256 constant ROLE_ROOT = 1;
133     uint256 constant ROLE_VENDOR = 2;
134     uint256 constant ROLE_XFERAUTH = 3;
135     uint256 constant ROLE_POPADMIN = 4;
136     uint256 constant ROLE_CUSTODIAN = 5;
137     uint256 constant ROLE_AUDITOR = 6;
138     uint256 constant ROLE_MARKETPLACE_ADMIN = 7;
139     uint256 constant ROLE_KYC_ADMIN = 8;
140     uint256 constant ROLE_FEES_ADMIN = 9;
141     uint256 constant ROLE_DOCS_UPLOADER = 10;
142     uint256 constant ROLE_KYC_RECASTER = 11;
143     uint256 constant ROLE_FEES_DISTRIBUTION_ADMIN = 12;
144 
145     /// states
146     uint256 constant STATE_ZERO_UNDEFINED = 0;
147     uint256 constant STATE_CREATED = 1;
148     uint256 constant STATE_VENDOR_ORDER = 2;
149     uint256 constant STATE_TRANSFER = 3;
150     uint256 constant STATE_CUSTODIAN_DELIVERY = 4;
151     uint256 constant STATE_MINTED = 5;
152     uint256 constant STATE_AUDIT_FAILURE = 6;
153     uint256 constant STATE_REPLACEMENT_ORDER = 7;
154     uint256 constant STATE_REPLACEMENT_DELIVERY = 8;
155     uint256 constant STATE_RECASTED = 9;
156     uint256 constant STATE_REDEEMED = 10;
157     uint256 constant STATE_ADMIN_FAILURE = 11;
158 
159 
160 
161     /// interactive contracts
162     bytes32 constant CONTRACT_INTERACTIVE_ASSETS_EXPLORER = "i:asset:explorer";
163     bytes32 constant CONTRACT_INTERACTIVE_DIGIX_DIRECTORY = "i:directory";
164     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE = "i:mp";
165     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_ADMIN = "i:mpadmin";
166     bytes32 constant CONTRACT_INTERACTIVE_POPADMIN = "i:popadmin";
167     bytes32 constant CONTRACT_INTERACTIVE_PRODUCTS_LIST = "i:products";
168     bytes32 constant CONTRACT_INTERACTIVE_TOKEN = "i:token";
169     bytes32 constant CONTRACT_INTERACTIVE_BULK_WRAPPER = "i:bulk-wrapper";
170     bytes32 constant CONTRACT_INTERACTIVE_TOKEN_CONFIG = "i:token:config";
171     bytes32 constant CONTRACT_INTERACTIVE_TOKEN_INFORMATION = "i:token:information";
172     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_INFORMATION = "i:mp:information";
173     bytes32 constant CONTRACT_INTERACTIVE_IDENTITY = "i:identity";
174 
175 
176     /// controller contracts
177     bytes32 constant CONTRACT_CONTROLLER_ASSETS = "c:asset";
178     bytes32 constant CONTRACT_CONTROLLER_ASSETS_RECAST = "c:asset:recast";
179     bytes32 constant CONTRACT_CONTROLLER_ASSETS_EXPLORER = "c:explorer";
180     bytes32 constant CONTRACT_CONTROLLER_DIGIX_DIRECTORY = "c:directory";
181     bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE = "c:mp";
182     bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE_ADMIN = "c:mpadmin";
183     bytes32 constant CONTRACT_CONTROLLER_PRODUCTS_LIST = "c:products";
184 
185     bytes32 constant CONTRACT_CONTROLLER_TOKEN_APPROVAL = "c:token:approval";
186     bytes32 constant CONTRACT_CONTROLLER_TOKEN_CONFIG = "c:token:config";
187     bytes32 constant CONTRACT_CONTROLLER_TOKEN_INFO = "c:token:info";
188     bytes32 constant CONTRACT_CONTROLLER_TOKEN_TRANSFER = "c:token:transfer";
189 
190     bytes32 constant CONTRACT_CONTROLLER_JOB_ID = "c:jobid";
191     bytes32 constant CONTRACT_CONTROLLER_IDENTITY = "c:identity";
192 
193     /// storage contracts
194     bytes32 constant CONTRACT_STORAGE_ASSETS = "s:asset";
195     bytes32 constant CONTRACT_STORAGE_ASSET_EVENTS = "s:asset:events";
196     bytes32 constant CONTRACT_STORAGE_DIGIX_DIRECTORY = "s:directory";
197     bytes32 constant CONTRACT_STORAGE_MARKETPLACE = "s:mp";
198     bytes32 constant CONTRACT_STORAGE_PRODUCTS_LIST = "s:products";
199     bytes32 constant CONTRACT_STORAGE_GOLD_TOKEN = "s:goldtoken";
200     bytes32 constant CONTRACT_STORAGE_JOB_ID = "s:jobid";
201     bytes32 constant CONTRACT_STORAGE_IDENTITY = "s:identity";
202 
203     /// service contracts
204     bytes32 constant CONTRACT_SERVICE_TOKEN_DEMURRAGE = "sv:tdemurrage";
205     bytes32 constant CONTRACT_SERVICE_MARKETPLACE = "sv:mp";
206     bytes32 constant CONTRACT_SERVICE_DIRECTORY = "sv:directory";
207 
208     /// fees distributors
209     bytes32 constant CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR = "fees:distributor:demurrage";
210     bytes32 constant CONTRACT_RECAST_FEES_DISTRIBUTOR = "fees:distributor:recast";
211     bytes32 constant CONTRACT_TRANSFER_FEES_DISTRIBUTOR = "fees:distributor:transfer";
212 
213 }
214 
215 contract TokenLoggerCallback is ResolverClient, DigixConstants {
216 
217   event Transfer(address indexed _from,  address indexed _to,  uint256 _value);
218   event Approval(address indexed _owner,  address indexed _spender,  uint256 _value);
219 
220   function log_mint(address _to, uint256 _value)
221            if_sender_is(CONTRACT_CONTROLLER_ASSETS)
222            public
223   {
224     Transfer(address(0x0), _to, _value);
225   }
226 
227   function log_recast_fees(address _from, address _to, uint256 _value)
228            if_sender_is(CONTRACT_CONTROLLER_ASSETS_RECAST)
229            public
230   {
231     Transfer(_from, _to, _value);
232   }
233 
234   function log_recast(address _from, uint256 _value)
235            if_sender_is(CONTRACT_CONTROLLER_ASSETS_RECAST)
236            public
237   {
238     Transfer(_from, address(0x0), _value);
239   }
240 
241   function log_demurrage_fees(address _from, address _to, uint256 _value)
242            if_sender_is(CONTRACT_SERVICE_TOKEN_DEMURRAGE)
243            public
244   {
245     Transfer(_from, _to, _value);
246   }
247 
248   function log_move_fees(address _from, address _to, uint256 _value)
249            if_sender_is(CONTRACT_CONTROLLER_TOKEN_CONFIG)
250            public
251   {
252     Transfer(_from, _to, _value);
253   }
254 
255   function log_transfer(address _from, address _to, uint256 _value)
256            if_sender_is(CONTRACT_CONTROLLER_TOKEN_TRANSFER)
257            public
258   {
259     Transfer(_from, _to, _value);
260   }
261 
262   function log_approve(address _owner, address _spender, uint256 _value)
263            if_sender_is(CONTRACT_CONTROLLER_TOKEN_APPROVAL)
264            public
265   {
266     Approval(_owner, _spender, _value);
267   }
268 
269 }
270 
271 
272 contract TokenInfoController {
273   function get_total_supply() constant public returns (uint256 _total_supply){}
274   function get_allowance(address _account, address _spender) constant public returns (uint256 _allowance){}
275   function get_balance(address _user) constant public returns (uint256 _actual_balance){}
276 }
277 
278 contract TokenTransferController {
279   function put_transfer(address _sender, address _recipient, address _spender, uint256 _amount, bool _transfer_from) public returns (bool _success){}
280 }
281 
282 contract TokenApprovalController {
283   function approve(address _account, address _spender, uint256 _amount) public returns (bool _success){}
284 }
285 
286 /// The interface of a contract that can receive tokens from transferAndCall()
287 contract TokenReceiver {
288   function tokenFallback(address from, uint256 amount, bytes32 data) public returns (bool success);
289 }
290 
291 /// @title DGX2.0 ERC-20 Token. ERC-677 is also implemented https://github.com/ethereum/EIPs/issues/677
292 /// @author Digix Holdings Pte Ltd
293 contract Token is TokenLoggerCallback {
294 
295   string public constant name = "Digix Gold Token";
296   string public constant symbol = "DGX";
297   uint8 public constant decimals = 9;
298 
299   function Token(address _resolver) public
300   {
301     require(init(CONTRACT_INTERACTIVE_TOKEN, _resolver));
302   }
303 
304   /// @notice show the total supply of gold tokens
305   /// @return {
306   ///    "totalSupply": "total number of tokens"
307   /// }
308   function totalSupply()
309            constant
310            public
311            returns (uint256 _total_supply)
312   {
313     _total_supply = TokenInfoController(get_contract(CONTRACT_CONTROLLER_TOKEN_INFO)).get_total_supply();
314   }
315 
316   /// @notice display balance of given account
317   /// @param _owner the account to query
318   /// @return {
319   ///    "balance": "balance of the given account in nanograms"
320   /// }
321   function balanceOf(address _owner)
322            constant
323            public
324            returns (uint256 balance)
325   {
326     balance = TokenInfoController(get_contract(CONTRACT_CONTROLLER_TOKEN_INFO)).get_balance(_owner);
327   }
328 
329   /// @notice transfer amount to account
330   /// @param _to account to send to
331   /// @param _value the amount in nanograms to send
332   /// @return {
333   ///    "success": "returns true if successful"
334   /// }
335   function transfer(address _to, uint256 _value)
336            public
337            returns (bool success)
338   {
339     success =
340       TokenTransferController(get_contract(CONTRACT_CONTROLLER_TOKEN_TRANSFER)).put_transfer(msg.sender, _to, 0x0, _value, false);
341   }
342 
343   /// @notice transfer amount to account from account deducting from spender allowance
344   /// @param _to account to send to
345   /// @param _from account to send from
346   /// @param _value the amount in nanograms to send
347   /// @return {
348   ///    "success": "returns true if successful"
349   /// }
350   function transferFrom(address _from, address _to, uint256 _value)
351            public
352            returns (bool success)
353   {
354     success =
355       TokenTransferController(get_contract(CONTRACT_CONTROLLER_TOKEN_TRANSFER)).put_transfer(_from, _to, msg.sender,
356                                                                              _value, true);
357   }
358 
359   /// @notice implements transferAndCall() of ERC677
360   /// @param _receiver the contract to receive the token
361   /// @param _amount the amount of tokens to be transfered
362   /// @param _data the data to be passed to the tokenFallback function of the receiving contract
363   /// @return {
364   ///    "success": "returns true if successful"
365   /// }
366   function transferAndCall(address _receiver, uint256 _amount, bytes32 _data)
367            public
368            returns (bool success)
369   {
370     transfer(_receiver, _amount);
371     success = TokenReceiver(_receiver).tokenFallback(msg.sender, _amount, _data);
372     require(success);
373   }
374 
375   /// @notice approve given spender to transfer given amount this will set allowance to 0 if current value is non-zero
376   /// @param _spender the account that is given an allowance
377   /// @param _value the amount in nanograms to approve
378   /// @return {
379   ///   "success": "returns true if successful"
380   /// }
381   function approve(address _spender, uint256 _value)
382            public
383            returns (bool success)
384   {
385     success = TokenApprovalController(get_contract(CONTRACT_CONTROLLER_TOKEN_APPROVAL)).approve(msg.sender, _spender, _value);
386   }
387 
388   /// @notice check the spending allowance of a given user from a given account
389   /// @param _owner the account to spend from
390   /// @param _spender the spender
391   /// @return {
392   ///    "remaining": "the remaining allowance in nanograms"
393   /// }
394   function allowance(address _owner, address _spender)
395            constant
396            public
397            returns (uint256 remaining)
398   {
399     remaining = TokenInfoController(get_contract(CONTRACT_CONTROLLER_TOKEN_INFO)).get_allowance(_owner, _spender);
400   }
401 
402 }