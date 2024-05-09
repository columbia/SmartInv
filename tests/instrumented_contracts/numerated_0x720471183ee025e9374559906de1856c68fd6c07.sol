1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/OwnableProxy.sol
4 
5 /**
6  * @title OwnableProxy
7  */
8 contract OwnableProxy {
9     event OwnershipRenounced(address indexed previousOwner);
10     event OwnershipTransferred(
11         address indexed previousOwner,
12         address indexed newOwner
13     );
14 
15     /**
16      * @dev Storage slot with the owner of the contract.
17      * This is the keccak-256 hash of "org.monetha.proxy.owner", and is
18      * validated in the constructor.
19      */
20     bytes32 private constant OWNER_SLOT = 0x3ca57e4b51fc2e18497b219410298879868edada7e6fe5132c8feceb0a080d22;
21 
22     /**
23      * @dev The OwnableProxy constructor sets the original `owner` of the contract to the sender
24      * account.
25      */
26     constructor() public {
27         assert(OWNER_SLOT == keccak256("org.monetha.proxy.owner"));
28 
29         _setOwner(msg.sender);
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(msg.sender == _getOwner());
37         _;
38     }
39 
40     /**
41      * @dev Allows the current owner to relinquish control of the contract.
42      * @notice Renouncing to ownership will leave the contract without an owner.
43      * It will not be possible to call the functions with the `onlyOwner`
44      * modifier anymore.
45      */
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipRenounced(_getOwner());
48         _setOwner(address(0));
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param _newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address _newOwner) public onlyOwner {
56         _transferOwnership(_newOwner);
57     }
58 
59     /**
60      * @dev Transfers control of the contract to a newOwner.
61      * @param _newOwner The address to transfer ownership to.
62      */
63     function _transferOwnership(address _newOwner) internal {
64         require(_newOwner != address(0));
65         emit OwnershipTransferred(_getOwner(), _newOwner);
66         _setOwner(_newOwner);
67     }
68 
69     /**
70      * @return The owner address.
71      */
72     function owner() public view returns (address) {
73         return _getOwner();
74     }
75 
76     /**
77      * @return The owner address.
78      */
79     function _getOwner() internal view returns (address own) {
80         bytes32 slot = OWNER_SLOT;
81         assembly {
82             own := sload(slot)
83         }
84     }
85 
86     /**
87      * @dev Sets the address of the proxy owner.
88      * @param _newOwner Address of the new proxy owner.
89      */
90     function _setOwner(address _newOwner) internal {
91         bytes32 slot = OWNER_SLOT;
92 
93         assembly {
94             sstore(slot, _newOwner)
95         }
96     }
97 }
98 
99 // File: contracts/ownership/ClaimableProxy.sol
100 
101 /**
102  * @title ClaimableProxy
103  * @dev Extension for the OwnableProxy contract, where the ownership needs to be claimed.
104  * This allows the new owner to accept the transfer.
105  */
106 contract ClaimableProxy is OwnableProxy {
107     /**
108      * @dev Storage slot with the pending owner of the contract.
109      * This is the keccak-256 hash of "org.monetha.proxy.pendingOwner", and is
110      * validated in the constructor.
111      */
112     bytes32 private constant PENDING_OWNER_SLOT = 0xcfd0c6ea5352192d7d4c5d4e7a73c5da12c871730cb60ff57879cbe7b403bb52;
113 
114     /**
115      * @dev The ClaimableProxy constructor validates PENDING_OWNER_SLOT constant.
116      */
117     constructor() public {
118         assert(PENDING_OWNER_SLOT == keccak256("org.monetha.proxy.pendingOwner"));
119     }
120 
121     function pendingOwner() public view returns (address) {
122         return _getPendingOwner();
123     }
124 
125     /**
126      * @dev Modifier throws if called by any account other than the pendingOwner.
127      */
128     modifier onlyPendingOwner() {
129         require(msg.sender == _getPendingOwner());
130         _;
131     }
132 
133     /**
134      * @dev Allows the current owner to set the pendingOwner address.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function transferOwnership(address newOwner) public onlyOwner {
138         _setPendingOwner(newOwner);
139     }
140 
141     /**
142      * @dev Allows the pendingOwner address to finalize the transfer.
143      */
144     function claimOwnership() public onlyPendingOwner {
145         emit OwnershipTransferred(_getOwner(), _getPendingOwner());
146         _setOwner(_getPendingOwner());
147         _setPendingOwner(address(0));
148     }
149 
150     /**
151      * @return The pending owner address.
152      */
153     function _getPendingOwner() internal view returns (address penOwn) {
154         bytes32 slot = PENDING_OWNER_SLOT;
155         assembly {
156             penOwn := sload(slot)
157         }
158     }
159 
160     /**
161      * @dev Sets the address of the pending owner.
162      * @param _newPendingOwner Address of the new pending owner.
163      */
164     function _setPendingOwner(address _newPendingOwner) internal {
165         bytes32 slot = PENDING_OWNER_SLOT;
166 
167         assembly {
168             sstore(slot, _newPendingOwner)
169         }
170     }
171 }
172 
173 // File: contracts/lifecycle/DestructibleProxy.sol
174 
175 /**
176  * @title Destructible
177  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
178  */
179 contract DestructibleProxy is OwnableProxy {
180     /**
181      * @dev Transfers the current balance to the owner and terminates the contract.
182      */
183     function destroy() public onlyOwner {
184         selfdestruct(_getOwner());
185     }
186 
187     function destroyAndSend(address _recipient) public onlyOwner {
188         selfdestruct(_recipient);
189     }
190 }
191 
192 // File: contracts/IPassportLogicRegistry.sol
193 
194 interface IPassportLogicRegistry {
195     /**
196      * @dev This event will be emitted every time a new passport logic implementation is registered
197      * @param version representing the version name of the registered passport logic implementation
198      * @param implementation representing the address of the registered passport logic implementation
199      */
200     event PassportLogicAdded(string version, address implementation);
201 
202     /**
203      * @dev This event will be emitted every time a new passport logic implementation is set as current one
204      * @param version representing the version name of the current passport logic implementation
205      * @param implementation representing the address of the current passport logic implementation
206      */
207     event CurrentPassportLogicSet(string version, address implementation);
208 
209     /**
210      * @dev Tells the address of the passport logic implementation for a given version
211      * @param _version to query the implementation of
212      * @return address of the passport logic implementation registered for the given version
213      */
214     function getPassportLogic(string _version) external view returns (address);
215 
216     /**
217      * @dev Tells the version of the current passport logic implementation
218      * @return version of the current passport logic implementation
219      */
220     function getCurrentPassportLogicVersion() external view returns (string);
221 
222     /**
223      * @dev Tells the address of the current passport logic implementation
224      * @return address of the current passport logic implementation
225      */
226     function getCurrentPassportLogic() external view returns (address);
227 }
228 
229 // File: contracts/upgradeability/Proxy.sol
230 
231 /**
232  * @title Proxy
233  * @dev Implements delegation of calls to other contracts, with proper
234  * forwarding of return values and bubbling of failures.
235  * It defines a fallback function that delegates all calls to the address
236  * returned by the abstract _implementation() internal function.
237  */
238 contract Proxy {
239     /**
240      * @dev Fallback function.
241      * Implemented entirely in `_fallback`.
242      */
243     function () payable external {
244         _delegate(_implementation());
245     }
246 
247     /**
248      * @return The Address of the implementation.
249      */
250     function _implementation() internal view returns (address);
251 
252     /**
253      * @dev Delegates execution to an implementation contract.
254      * This is a low level function that doesn't return to its internal call site.
255      * It will return to the external caller whatever the implementation returns.
256      * @param implementation Address to delegate.
257      */
258     function _delegate(address implementation) internal {
259         assembly {
260         // Copy msg.data. We take full control of memory in this inline assembly
261         // block because it will not return to Solidity code. We overwrite the
262         // Solidity scratch pad at memory position 0.
263             calldatacopy(0, 0, calldatasize)
264 
265         // Call the implementation.
266         // out and outsize are 0 because we don't know the size yet.
267             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
268 
269         // Copy the returned data.
270             returndatacopy(0, 0, returndatasize)
271 
272             switch result
273             // delegatecall returns 0 on error.
274             case 0 { revert(0, returndatasize) }
275             default { return(0, returndatasize) }
276         }
277     }
278 }
279 
280 // File: contracts/Passport.sol
281 
282 /**
283  * @title Passport
284  */
285 contract Passport is Proxy, ClaimableProxy, DestructibleProxy {
286 
287     event PassportLogicRegistryChanged(
288         address indexed previousRegistry,
289         address indexed newRegistry
290     );
291 
292     /**
293      * @dev Storage slot with the address of the current registry of the passport implementations.
294      * This is the keccak-256 hash of "org.monetha.passport.proxy.registry", and is
295      * validated in the constructor.
296      */
297     bytes32 private constant REGISTRY_SLOT = 0xa04bab69e45aeb4c94a78ba5bc1be67ef28977c4fdf815a30b829a794eb67a4a;
298 
299     /**
300      * @dev Contract constructor.
301      * @param _registry Address of the passport implementations registry.
302      */
303     constructor(IPassportLogicRegistry _registry) public {
304         assert(REGISTRY_SLOT == keccak256("org.monetha.passport.proxy.registry"));
305 
306         _setRegistry(_registry);
307     }
308 
309     /**
310      * @return the address of passport logic registry.
311      */
312     function getPassportLogicRegistry() public view returns (address) {
313         return _getRegistry();
314     }
315 
316     /**
317      * @dev Returns the current passport logic implementation (used in Proxy fallback function to delegate call
318      * to passport logic implementation).
319      * @return Address of the current passport implementation
320      */
321     function _implementation() internal view returns (address) {
322         return _getRegistry().getCurrentPassportLogic();
323     }
324 
325     /**
326      * @dev Returns the current passport implementations registry.
327      * @return Address of the current implementation
328      */
329     function _getRegistry() internal view returns (IPassportLogicRegistry reg) {
330         bytes32 slot = REGISTRY_SLOT;
331         assembly {
332             reg := sload(slot)
333         }
334     }
335 
336     function _setRegistry(IPassportLogicRegistry _registry) internal {
337         require(address(_registry) != 0x0, "Cannot set registry to a zero address");
338 
339         bytes32 slot = REGISTRY_SLOT;
340         assembly {
341             sstore(slot, _registry)
342         }
343     }
344 }