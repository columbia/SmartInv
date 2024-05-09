1 pragma solidity ^0.4.19;
2 
3 library Types {
4   struct MutableUint {
5     uint256 pre;
6     uint256 post;
7   }
8 
9   struct MutableTimestamp {
10     MutableUint time;
11     uint256 in_units;
12   }
13 
14   function advance_by(MutableTimestamp memory _original, uint256 _units)
15            internal
16            constant
17            returns (MutableTimestamp _transformed)
18   {
19     _transformed = _original;
20     require(now >= _original.time.pre);
21     uint256 _lapsed = now - _original.time.pre;
22     _transformed.in_units = _lapsed / _units;
23     uint256 _ticks = _transformed.in_units * _units;
24     if (_transformed.in_units == 0) {
25       _transformed.time.post = _original.time.pre;
26     } else {
27       _transformed.time = add(_transformed.time, _ticks);
28     }
29   }
30 
31   function add(MutableUint memory _original, uint256 _amount)
32            internal
33            pure
34            returns (MutableUint _transformed)
35   {
36     require((_original.pre + _amount) >= _original.pre);
37     _transformed = _original;
38     _transformed.post = _original.pre + _amount;
39   }
40 }
41 
42 contract DigixConstants {
43     /// general constants
44     uint256 constant SECONDS_IN_A_DAY = 24 * 60 * 60;
45 
46     /// asset events
47     uint256 constant ASSET_EVENT_CREATED_VENDOR_ORDER = 1;
48     uint256 constant ASSET_EVENT_CREATED_TRANSFER_ORDER = 2;
49     uint256 constant ASSET_EVENT_CREATED_REPLACEMENT_ORDER = 3;
50     uint256 constant ASSET_EVENT_FULFILLED_VENDOR_ORDER = 4;
51     uint256 constant ASSET_EVENT_FULFILLED_TRANSFER_ORDER = 5;
52     uint256 constant ASSET_EVENT_FULFILLED_REPLACEMENT_ORDER = 6;
53     uint256 constant ASSET_EVENT_MINTED = 7;
54     uint256 constant ASSET_EVENT_MINTED_REPLACEMENT = 8;
55     uint256 constant ASSET_EVENT_RECASTED = 9;
56     uint256 constant ASSET_EVENT_REDEEMED = 10;
57     uint256 constant ASSET_EVENT_FAILED_AUDIT = 11;
58     uint256 constant ASSET_EVENT_ADMIN_FAILED = 12;
59     uint256 constant ASSET_EVENT_REMINTED = 13;
60 
61     /// roles
62     uint256 constant ROLE_ZERO_ANYONE = 0;
63     uint256 constant ROLE_ROOT = 1;
64     uint256 constant ROLE_VENDOR = 2;
65     uint256 constant ROLE_XFERAUTH = 3;
66     uint256 constant ROLE_POPADMIN = 4;
67     uint256 constant ROLE_CUSTODIAN = 5;
68     uint256 constant ROLE_AUDITOR = 6;
69     uint256 constant ROLE_MARKETPLACE_ADMIN = 7;
70     uint256 constant ROLE_KYC_ADMIN = 8;
71     uint256 constant ROLE_FEES_ADMIN = 9;
72     uint256 constant ROLE_DOCS_UPLOADER = 10;
73     uint256 constant ROLE_KYC_RECASTER = 11;
74     uint256 constant ROLE_FEES_DISTRIBUTION_ADMIN = 12;
75 
76     /// states
77     uint256 constant STATE_ZERO_UNDEFINED = 0;
78     uint256 constant STATE_CREATED = 1;
79     uint256 constant STATE_VENDOR_ORDER = 2;
80     uint256 constant STATE_TRANSFER = 3;
81     uint256 constant STATE_CUSTODIAN_DELIVERY = 4;
82     uint256 constant STATE_MINTED = 5;
83     uint256 constant STATE_AUDIT_FAILURE = 6;
84     uint256 constant STATE_REPLACEMENT_ORDER = 7;
85     uint256 constant STATE_REPLACEMENT_DELIVERY = 8;
86     uint256 constant STATE_RECASTED = 9;
87     uint256 constant STATE_REDEEMED = 10;
88     uint256 constant STATE_ADMIN_FAILURE = 11;
89 
90     /// interactive contracts
91     bytes32 constant CONTRACT_INTERACTIVE_ASSETS_EXPLORER = "i:asset:explorer";
92     bytes32 constant CONTRACT_INTERACTIVE_DIGIX_DIRECTORY = "i:directory";
93     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE = "i:mp";
94     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_ADMIN = "i:mpadmin";
95     bytes32 constant CONTRACT_INTERACTIVE_POPADMIN = "i:popadmin";
96     bytes32 constant CONTRACT_INTERACTIVE_PRODUCTS_LIST = "i:products";
97     bytes32 constant CONTRACT_INTERACTIVE_TOKEN = "i:token";
98     bytes32 constant CONTRACT_INTERACTIVE_BULK_WRAPPER = "i:bulk-wrapper";
99     bytes32 constant CONTRACT_INTERACTIVE_TOKEN_CONFIG = "i:token:config";
100     bytes32 constant CONTRACT_INTERACTIVE_TOKEN_INFORMATION = "i:token:information";
101     bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_INFORMATION = "i:mp:information";
102     bytes32 constant CONTRACT_INTERACTIVE_IDENTITY = "i:identity";
103 
104     /// controller contracts
105     bytes32 constant CONTRACT_CONTROLLER_ASSETS = "c:asset";
106     bytes32 constant CONTRACT_CONTROLLER_ASSETS_RECAST = "c:asset:recast";
107     bytes32 constant CONTRACT_CONTROLLER_ASSETS_EXPLORER = "c:explorer";
108     bytes32 constant CONTRACT_CONTROLLER_DIGIX_DIRECTORY = "c:directory";
109     bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE = "c:mp";
110     bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE_ADMIN = "c:mpadmin";
111     bytes32 constant CONTRACT_CONTROLLER_PRODUCTS_LIST = "c:products";
112 
113     bytes32 constant CONTRACT_CONTROLLER_TOKEN_APPROVAL = "c:token:approval";
114     bytes32 constant CONTRACT_CONTROLLER_TOKEN_CONFIG = "c:token:config";
115     bytes32 constant CONTRACT_CONTROLLER_TOKEN_INFO = "c:token:info";
116     bytes32 constant CONTRACT_CONTROLLER_TOKEN_TRANSFER = "c:token:transfer";
117 
118     bytes32 constant CONTRACT_CONTROLLER_JOB_ID = "c:jobid";
119     bytes32 constant CONTRACT_CONTROLLER_IDENTITY = "c:identity";
120 
121     /// storage contracts
122     bytes32 constant CONTRACT_STORAGE_ASSETS = "s:asset";
123     bytes32 constant CONTRACT_STORAGE_ASSET_EVENTS = "s:asset:events";
124     bytes32 constant CONTRACT_STORAGE_DIGIX_DIRECTORY = "s:directory";
125     bytes32 constant CONTRACT_STORAGE_MARKETPLACE = "s:mp";
126     bytes32 constant CONTRACT_STORAGE_PRODUCTS_LIST = "s:products";
127     bytes32 constant CONTRACT_STORAGE_GOLD_TOKEN = "s:goldtoken";
128     bytes32 constant CONTRACT_STORAGE_JOB_ID = "s:jobid";
129     bytes32 constant CONTRACT_STORAGE_IDENTITY = "s:identity";
130 
131     /// service contracts
132     bytes32 constant CONTRACT_SERVICE_TOKEN_DEMURRAGE = "sv:tdemurrage";
133     bytes32 constant CONTRACT_SERVICE_MARKETPLACE = "sv:mp";
134     bytes32 constant CONTRACT_SERVICE_DIRECTORY = "sv:directory";
135 
136     /// fees distributors
137     bytes32 constant CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR = "fees:distributor:demurrage";
138     bytes32 constant CONTRACT_RECAST_FEES_DISTRIBUTOR = "fees:distributor:recast";
139     bytes32 constant CONTRACT_TRANSFER_FEES_DISTRIBUTOR = "fees:distributor:transfer";
140 }
141 
142 /**
143  * @title Ownable
144  * @dev The Ownable contract has an owner address, and provides basic authorization control
145  * functions, this simplifies the implementation of "user permissions".
146  */
147 contract Ownable {
148   address public owner;
149 
150 
151   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153 
154   /**
155    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156    * account.
157    */
158   function Ownable() public {
159     owner = msg.sender;
160   }
161 
162   /**
163    * @dev Throws if called by any account other than the owner.
164    */
165   modifier onlyOwner() {
166     require(msg.sender == owner);
167     _;
168   }
169 
170   /**
171    * @dev Allows the current owner to transfer control of the contract to a newOwner.
172    * @param newOwner The address to transfer ownership to.
173    */
174   function transferOwnership(address newOwner) public onlyOwner {
175     require(newOwner != address(0));
176     OwnershipTransferred(owner, newOwner);
177     owner = newOwner;
178   }
179 }
180 
181 /**
182  * @title Claimable
183  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
184  * This allows the new owner to accept the transfer.
185  */
186 contract Claimable is Ownable {
187   address public pendingOwner;
188 
189   /**
190    * @dev Modifier throws if called by any account other than the pendingOwner.
191    */
192   modifier onlyPendingOwner() {
193     require(msg.sender == pendingOwner);
194     _;
195   }
196 
197   /**
198    * @dev Allows the current owner to set the pendingOwner address.
199    * @param newOwner The address to transfer ownership to.
200    */
201   function transferOwnership(address newOwner) onlyOwner public {
202     pendingOwner = newOwner;
203   }
204 
205   /**
206    * @dev Allows the pendingOwner address to finalize the transfer.
207    */
208   function claimOwnership() onlyPendingOwner public {
209     OwnershipTransferred(owner, pendingOwner);
210     owner = pendingOwner;
211     pendingOwner = address(0);
212   }
213 }
214 
215 contract ResolverClient {
216   /// @dev Get the address of a contract
217   /// @param _key the resolver key to look up
218   /// @return _contract the address of the contract
219   function get_contract(bytes32 _key) public constant returns (address _contract);
220 }
221 
222 contract TokenInformation is ResolverClient {
223   function showDemurrageConfigs() public constant returns (uint256 _base, uint256 _rate, address _collector, bool _no_demurrage_fee);
224   function showCollectorsAddresses() public constant returns (address[3] _collectors);
225 }
226 
227 contract Token {
228   function totalSupply() constant public returns (uint256 _total_supply);
229   function balanceOf(address _owner) constant public returns (uint256 balance);
230 }
231 
232 contract DgxDemurrageCalculator {
233   address public TOKEN_ADDRESS;
234   address public TOKEN_INFORMATION_ADDRESS;
235 
236   function token_information() internal view returns (TokenInformation _token_information) {
237     _token_information = TokenInformation(TOKEN_INFORMATION_ADDRESS);
238   }
239 
240   function DgxDemurrageCalculator(address _token_address, address _token_information_address) public {
241     TOKEN_ADDRESS = _token_address;
242     TOKEN_INFORMATION_ADDRESS = _token_information_address;
243   }
244 
245   function calculateDemurrage(uint256 _initial_balance, uint256 _days_elapsed)
246            public
247            view
248            returns (uint256 _demurrage_fees, bool _no_demurrage_fees)
249   {
250     uint256 _base;
251     uint256 _rate;
252     (_base, _rate,,_no_demurrage_fees) = token_information().showDemurrageConfigs();
253     _demurrage_fees = (_initial_balance * _days_elapsed * _rate) / _base;
254   }
255 }
256 
257 
258 /// @title Digix Gold Token Demurrage Reporter
259 /// @author Digix Holdings Pte Ltd
260 /// @notice This contract is used to keep a close estimate of how much demurrage fees would have been collected on Digix Gold Token if the demurrage fees is on.
261 /// @notice Anyone can call the function updateDemurrageReporter() to keep this contract updated to the lastest day. The more often this function is called the more accurate the estimate will be (but it can only be updated at most every 24hrs)
262 contract DgxDemurrageReporter is DgxDemurrageCalculator, Claimable, DigixConstants {
263   address[] public exempted_accounts;
264   uint256 public last_demurrageable_balance; // the total balance of DGX in non-exempted accounts, at last_payment_timestamp
265   uint256 public last_payment_timestamp;  // the last time this contract is updated
266   uint256 public culmulative_demurrage_collected; // this is the estimate of the demurrage fees that would have been collected from start_of_report_period to last_payment_timestamp
267   uint256 public start_of_report_period; // the timestamp when this contract started keeping track of demurrage fees
268 
269   using Types for Types.MutableTimestamp;
270 
271   function DgxDemurrageReporter(address _token_address, address _token_information_address) public DgxDemurrageCalculator(_token_address, _token_information_address)
272   {
273     address[3] memory _collectors;
274     _collectors = token_information().showCollectorsAddresses();
275     exempted_accounts.push(_collectors[0]);
276     exempted_accounts.push(_collectors[1]);
277     exempted_accounts.push(_collectors[2]);
278 
279     exempted_accounts.push(token_information().get_contract(CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR));
280     exempted_accounts.push(token_information().get_contract(CONTRACT_RECAST_FEES_DISTRIBUTOR));
281     exempted_accounts.push(token_information().get_contract(CONTRACT_TRANSFER_FEES_DISTRIBUTOR));
282 
283     exempted_accounts.push(token_information().get_contract(CONTRACT_STORAGE_MARKETPLACE));
284     start_of_report_period = now;
285     last_payment_timestamp = now;
286     updateDemurrageReporter();
287   }
288 
289   function addExemptedAccount(address _account) public onlyOwner {
290     exempted_accounts.push(_account);
291   }
292 
293   function updateDemurrageReporter() public {
294     Types.MutableTimestamp memory payment_timestamp;
295     payment_timestamp.time.pre = last_payment_timestamp;
296     payment_timestamp = payment_timestamp.advance_by(1 days);
297 
298     uint256 _base;
299     uint256 _rate;
300     (_base, _rate,,) = token_information().showDemurrageConfigs();
301 
302     culmulative_demurrage_collected += (payment_timestamp.in_units * last_demurrageable_balance * _rate) / _base;
303     last_payment_timestamp = payment_timestamp.time.post;
304     last_demurrageable_balance = getDemurrageableBalance();
305   }
306 
307   function getDemurrageableBalance() internal view returns (uint256 _last_demurrageable_balance) {
308     Token token = Token(TOKEN_ADDRESS);
309     uint256 _total_supply = token.totalSupply();
310     uint256 _no_demurrage_balance = 0;
311     for (uint256 i=0;i<exempted_accounts.length;i++) {
312       _no_demurrage_balance += token.balanceOf(exempted_accounts[i]);
313     }
314     _last_demurrageable_balance = _total_supply - _no_demurrage_balance;
315   }
316 
317 }