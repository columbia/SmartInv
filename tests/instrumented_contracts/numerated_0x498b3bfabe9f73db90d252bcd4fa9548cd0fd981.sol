1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title RegistryInterface Interface 
5  */
6 interface RegistryInterface {
7     function logic(address logicAddr) external view returns (bool);
8     function record(address currentOwner, address nextOwner) external;
9 }
10 
11 
12 /**
13  * @title Address Registry Record
14  */
15 contract AddressRecord {
16 
17     /**
18      * @dev address registry of system, logic and wallet addresses
19      */
20     address public registry;
21 
22     /**
23      * @dev Throws if the logic is not authorised
24      */
25     modifier logicAuth(address logicAddr) {
26         require(logicAddr != address(0), "logic-proxy-address-required");
27         require(RegistryInterface(registry).logic(logicAddr), "logic-not-authorised");
28         _;
29     }
30 
31 }
32 
33 
34 /**
35  * @title User Auth
36  */
37 contract UserAuth is AddressRecord {
38 
39     event LogSetOwner(address indexed owner);
40     address public owner;
41 
42     /**
43      * @dev Throws if not called by owner or contract itself
44      */
45     modifier auth {
46         require(isAuth(msg.sender), "permission-denied");
47         _;
48     }
49 
50     /**
51      * @dev sets new owner
52      */
53     function setOwner(address nextOwner) public auth {
54         RegistryInterface(registry).record(owner, nextOwner);
55         owner = nextOwner;
56         emit LogSetOwner(nextOwner);
57     }
58 
59     /**
60      * @dev checks if called by owner or contract itself
61      * @param src is the address initiating the call
62      */
63     function isAuth(address src) public view returns (bool) {
64         if (src == owner) {
65             return true;
66         } else if (src == address(this)) {
67             return true;
68         }
69         return false;
70     }
71 }
72 
73 
74 /**
75  * @dev logging the execute events
76  */
77 contract UserNote {
78     event LogNote(
79         bytes4 indexed sig,
80         address indexed guy,
81         bytes32 indexed foo,
82         bytes32 bar,
83         uint wad,
84         bytes fax
85     );
86 
87     modifier note {
88         bytes32 foo;
89         bytes32 bar;
90         assembly {
91             foo := calldataload(4)
92             bar := calldataload(36)
93         }
94         emit LogNote(
95             msg.sig, 
96             msg.sender, 
97             foo, 
98             bar, 
99             msg.value,
100             msg.data
101         );
102         _;
103     }
104 }
105 
106 
107 /**
108  * @title User Owned Contract Wallet
109  */
110 contract UserWallet is UserAuth, UserNote {
111 
112     event LogExecute(address target, uint srcNum, uint sessionNum);
113 
114     /**
115      * @dev sets the "address registry", owner's last activity, owner's active period and initial owner
116      */
117     constructor() public {
118         registry = msg.sender;
119         owner = msg.sender;
120     }
121 
122     function() external payable {}
123 
124     /**
125      * @dev Execute authorised calls via delegate call
126      * @param _target logic proxy address
127      * @param _data delegate call data
128      * @param _src to find the source
129      * @param _session to find the session
130      */
131     function execute(
132         address _target,
133         bytes memory _data,
134         uint _src,
135         uint _session
136     ) 
137         public
138         payable
139         note
140         auth
141         logicAuth(_target)
142         returns (bytes memory response)
143     {
144         emit LogExecute(
145             _target,
146             _src,
147             _session
148         );
149         
150         // call contract in current context
151         assembly {
152             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 0)
153             let size := returndatasize
154 
155             response := mload(0x40)
156             mstore(0x40, add(response, and(add(add(size, 0x20), 0x1f), not(0x1f))))
157             mstore(response, size)
158             returndatacopy(add(response, 0x20), 0, size)
159 
160             switch iszero(succeeded)
161                 case 1 {
162                     // throw if delegatecall failed
163                     revert(add(response, 0x20), size)
164                 }
165         }
166     }
167 
168 }
169 
170 
171 /// @title AddressRegistry
172 /// @notice 
173 /// @dev 
174 contract AddressRegistry {
175     event LogSetAddress(string name, address addr);
176 
177     /// @notice Registry of role and address
178     mapping(bytes32 => address) registry;
179 
180     /**
181      * @dev Check if msg.sender is admin or owner.
182      */
183     modifier isAdmin() {
184         require(
185             msg.sender == getAddress("admin") || 
186             msg.sender == getAddress("owner"),
187             "permission-denied"
188         );
189         _;
190     }
191 
192     /// @dev Get the address from system registry 
193     /// @param _name (string)
194     /// @return  (address) Returns address based on role
195     function getAddress(string memory _name) public view returns(address) {
196         return registry[keccak256(abi.encodePacked(_name))];
197     }
198 
199     /// @dev Set new address in system registry 
200     /// @param _name (string) Role name
201     /// @param _userAddress (string) User Address
202     function setAddress(string memory _name, address _userAddress) public isAdmin {
203         registry[keccak256(abi.encodePacked(_name))] = _userAddress;
204         emit LogSetAddress(_name, _userAddress);
205     }
206 }
207 
208 
209 /// @title LogicRegistry
210 /// @notice
211 /// @dev LogicRegistry 
212 contract LogicRegistry is AddressRegistry {
213 
214     event LogEnableStaticLogic(address logicAddress);
215     event LogEnableLogic(address logicAddress);
216     event LogDisableLogic(address logicAddress);
217 
218     /// @notice Map of static proxy state
219     mapping(address => bool) public logicProxiesStatic;
220     
221     /// @notice Map of logic proxy state
222     mapping(address => bool) public logicProxies;
223 
224     /// @dev 
225     /// @param _logicAddress (address)
226     /// @return  (bool)
227     function logic(address _logicAddress) public view returns (bool) {
228         if (logicProxiesStatic[_logicAddress] || logicProxies[_logicAddress]) {
229             return true;
230         }
231         return false;
232     }
233 
234     /// @dev 
235     /// @param _logicAddress (address)
236     /// @return  (bool)
237     function logicStatic(address _logicAddress) public view returns (bool) {
238         if (logicProxiesStatic[_logicAddress]) {
239             return true;
240         }
241         return false;
242     }
243 
244     /// @dev Sets the static logic proxy to true
245     /// static proxies mostly contains the logic for withdrawal of assets
246     /// and can never be false to freely let user withdraw their assets
247     /// @param _logicAddress (address)
248     function enableStaticLogic(address _logicAddress) public isAdmin {
249         logicProxiesStatic[_logicAddress] = true;
250         emit LogEnableStaticLogic(_logicAddress);
251     }
252 
253     /// @dev Enable logic proxy address
254     /// @param _logicAddress (address)
255     function enableLogic(address _logicAddress) public isAdmin {
256         logicProxies[_logicAddress] = true;
257         emit LogEnableLogic(_logicAddress);
258     }
259 
260     /// @dev Disable logic proxy address
261     /// @param _logicAddress (address)
262     function disableLogic(address _logicAddress) public isAdmin {
263         logicProxies[_logicAddress] = false;
264         emit LogDisableLogic(_logicAddress);
265     }
266 
267 }
268 
269 
270 /**
271  * @dev Deploys a new proxy instance and sets msg.sender as owner of proxy
272  */
273 contract WalletRegistry is LogicRegistry {
274     
275     event Created(address indexed sender, address indexed owner, address proxy);
276     event LogRecord(address indexed currentOwner, address indexed nextOwner, address proxy);
277     
278     /// @notice Address to UserWallet proxy map
279     mapping(address => UserWallet) public proxies;
280     
281     /// @dev Deploys a new proxy instance and sets custom owner of proxy
282     /// Throws if the owner already have a UserWallet
283     /// @return proxy ()
284     function build() public returns (UserWallet proxy) {
285         proxy = build(msg.sender);
286     }
287 
288     /// @dev update the proxy record whenever owner changed on any proxy
289     /// Throws if msg.sender is not a proxy contract created via this contract
290     /// @return proxy () UserWallet
291     function build(address _owner) public returns (UserWallet proxy) {
292         require(proxies[_owner] == UserWallet(0), "multiple-proxy-per-user-not-allowed");
293         proxy = new UserWallet();
294         proxies[address(this)] = proxy; // will be changed via record() in next line execution
295         proxy.setOwner(_owner);
296         emit Created(msg.sender, _owner, address(proxy));
297     }
298 
299     /// @dev Transafers ownership
300     /// @param _currentOwner (address) Current Owner
301     /// @param _nextOwner (address) Next Owner
302     function record(address _currentOwner, address _nextOwner) public {
303         require(msg.sender == address(proxies[_currentOwner]), "invalid-proxy-or-owner");
304         require(proxies[_nextOwner] == UserWallet(0), "multiple-proxy-per-user-not-allowed");
305         proxies[_nextOwner] = proxies[_currentOwner];
306         proxies[_currentOwner] = UserWallet(0);
307         emit LogRecord(_currentOwner, _nextOwner, address(proxies[_nextOwner]));
308     }
309 
310 }
311 
312 
313 /// @title InstaRegistry
314 /// @dev Initializing Registry
315 contract InstaRegistry is WalletRegistry {
316 
317     constructor() public {
318         registry[keccak256(abi.encodePacked("admin"))] = msg.sender;
319         registry[keccak256(abi.encodePacked("owner"))] = msg.sender;
320     }
321 }