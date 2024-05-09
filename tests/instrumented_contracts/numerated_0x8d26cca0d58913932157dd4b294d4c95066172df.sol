1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity ^0.8.0;
3 pragma experimental ABIEncoderV2;
4 
5 
6 library LibRichErrors {
7 	bytes4 internal constant STANDARD_ERROR_SELECTOR = bytes4(keccak256("Error(string)"));
8 
9     function StandardError(string memory message)
10         internal
11         pure
12         returns (bytes memory encodedError)
13     {
14         return abi.encodeWithSelector(
15             STANDARD_ERROR_SELECTOR,
16             bytes(message)
17         );
18     }
19 
20     function rrevert(bytes memory encodedError)
21         internal
22         pure
23     {
24         assembly {
25             revert(add(encodedError, 0x20), mload(encodedError))
26         }
27     }
28 }
29 
30 
31 library LibProxyRichErrors {
32     function NotImplementedError(bytes4 selector)
33         internal
34         pure
35         returns (bytes memory encodedError)
36     {
37         return abi.encodeWithSelector(
38             bytes4(keccak256("NotImplementedError(bytes4)")),
39             selector
40         );
41     }
42 
43     function InvalidBootstrapCallerError(address actual, address expected)
44         internal
45         pure
46         returns (bytes memory encodedError)
47     {
48         return abi.encodeWithSelector(
49             bytes4(keccak256("InvalidBootstrapCallerError(address,address)")),
50             actual,
51             expected
52         );
53     }
54 
55     function InvalidDieCallerError(address actual, address expected)
56         internal
57         pure
58         returns (bytes memory encodedError)
59     {
60         return abi.encodeWithSelector(
61             bytes4(keccak256("InvalidDieCallerError(address,address)")),
62             actual,
63             expected
64         );
65     }
66 
67     function BootstrapCallFailedError(address target, bytes memory resultData)
68         internal
69         pure
70         returns (bytes memory encodedError)
71     {
72         return abi.encodeWithSelector(
73             bytes4(keccak256("BootstrapCallFailedError(address,bytes)")),
74             target,
75             resultData
76         );
77     }
78 }
79 
80 
81 library LibBootstrap {
82     bytes4 internal constant BOOTSTRAP_SUCCESS = bytes4(keccak256("BOOTSTRAP_SUCCESS"));
83 
84     using LibRichErrors for bytes;
85 
86     function delegatecallBootstrapFunction(
87         address target,
88         bytes memory data
89     )
90         internal
91     {
92         (bool success, bytes memory resultData) = target.delegatecall(data);
93         if (!success ||
94             resultData.length != 32 ||
95             abi.decode(resultData, (bytes4)) != BOOTSTRAP_SUCCESS)
96         {
97             LibProxyRichErrors.BootstrapCallFailedError(target, resultData).rrevert();
98         }
99     }
100 }
101 
102 
103 /// @dev Common storage helpers
104 library LibStorage {
105     /// @dev What to bit-shift a storage ID by to get its slot.
106     ///      This gives us a maximum of 2**128 inline fields in each bucket.
107     uint256 private constant STORAGE_SLOT_EXP = 128;
108 
109     /// @dev Storage IDs for feature storage buckets.
110     ///      WARNING: APPEND-ONLY.
111     enum StorageId {
112         Proxy,
113         SimpleFunctionRegistry,
114         Ownable,
115         ERC20,
116         AccessControl,
117         ERC20AccessControl,
118         Test
119     }
120 
121     /// @dev Get the storage slot given a storage ID. We assign unique, well-spaced
122     ///     slots to storage bucket variables to ensure they do not overlap.
123     ///     See: https://solidity.readthedocs.io/en/v0.6.6/assembly.html#access-to-external-variables-functions-and-libraries
124     /// @param storageId An entry in `StorageId`
125     /// @return slot The storage slot.
126     function getStorageSlot(StorageId storageId)
127         internal
128         pure
129         returns (uint256 slot)
130     {
131         // This should never overflow with a reasonable `STORAGE_SLOT_EXP`
132         // because Solidity will do a range check on `storageId` during the cast.
133         return (uint256(storageId) + 1) << STORAGE_SLOT_EXP;
134     }
135 }
136 
137 
138 library LibProxyStorage {
139     struct Storage {
140         // Mapping of function selector -> function implementation
141         mapping(bytes4 => address) impls;
142         //address owner;
143     }
144 
145     function getStorage() internal pure returns (Storage storage stor) {
146         uint256 storageSlot = LibStorage.getStorageSlot(
147             LibStorage.StorageId.Proxy
148         );
149         assembly {
150             stor.slot := storageSlot
151         }
152     }
153 }
154 
155 
156 interface IBootstrapFeature {
157     /// @dev Bootstrap the initial feature set of this contract by delegatecalling
158     ///      into `target`. Before exiting the `bootstrap()` function will
159     ///      deregister itself from the proxy to prevent being called again.
160     /// @param target The bootstrapper contract address.
161     /// @param callData The call data to execute on `target`.
162     function bootstrap(address target, bytes calldata callData) external;
163 }
164 
165 
166 /// @dev Detachable `bootstrap()` feature.
167 contract BootstrapFeature is
168     IBootstrapFeature
169 {
170     // immutable -> persist across delegatecalls
171     /// @dev aka ZeroEx.
172     address immutable private _deployer;
173     /// @dev The implementation address of this contract.
174     address immutable private _implementation;
175     /// @dev aka InitialMigration.
176     address immutable private _bootstrapCaller;
177 
178     using LibRichErrors for bytes;
179 
180     constructor(address bootstrapCaller) {
181         _deployer = msg.sender;
182         _implementation = address(this);
183         _bootstrapCaller = bootstrapCaller;
184     }
185 
186     modifier onlyBootstrapCaller() {
187         if (msg.sender != _bootstrapCaller) {
188             LibProxyRichErrors.InvalidBootstrapCallerError(msg.sender, _bootstrapCaller).rrevert();
189         }
190         _;
191     }
192 
193     modifier onlyDeployer() {
194         if (msg.sender != _deployer) {
195             LibProxyRichErrors.InvalidDieCallerError(msg.sender, _deployer).rrevert();
196         }
197         _;
198     }
199 
200     function bootstrap(address target, bytes calldata callData) external override onlyBootstrapCaller {
201         LibProxyStorage.getStorage().impls[this.bootstrap.selector] = address(0);
202         BootstrapFeature(_implementation).die();
203         LibBootstrap.delegatecallBootstrapFunction(target, callData);
204     }
205 
206     function die() external onlyDeployer {
207         assert(address(this) == _implementation);
208         selfdestruct(payable(msg.sender));
209     }
210 }
211 
212 
213 contract ZeroEx_ {
214     /// @param bootstrapper Who can call `bootstrap()`.
215     constructor(address bootstrapper) {
216         BootstrapFeature bootstrap = new BootstrapFeature(bootstrapper);
217         LibProxyStorage.getStorage().impls[bootstrap.bootstrap.selector] = address(bootstrap);
218     }
219 
220     function getFunctionImplementation(bytes4 selector)
221         public
222         view
223         returns (address impl)
224     {
225         return LibProxyStorage.getStorage().impls[selector];
226     }
227 
228     fallback() external payable {
229         mapping(bytes4 => address) storage impls =
230             LibProxyStorage.getStorage().impls;
231 
232         assembly {
233             let cdlen := calldatasize()
234 
235             // receive() external payable {}
236             if iszero(cdlen) {
237                 return(0, 0)
238             }
239 
240             // 0x00-0x3F reserved for slot calculation
241             calldatacopy(0x40, 0, cdlen)
242             let selector := and(mload(0x40), 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
243 
244             // slot for impls[selector] = keccak256(selector . impls.slot)
245             mstore(0, selector)
246             mstore(0x20, impls.slot)
247             let slot := keccak256(0, 0x40)
248 
249             let delegate := sload(slot)
250             if iszero(delegate) {
251                 // abi.encodeWithSelector(bytes4(keccak256("NotImplementedError(bytes4)")), selector)
252                 mstore(0, 0x734e6e1c00000000000000000000000000000000000000000000000000000000)
253                 mstore(4, selector)
254                 revert(0, 0x24)
255             }
256 
257             let success := delegatecall(
258                 gas(),
259                 delegate,
260                 0x40, cdlen,
261                 0, 0
262             )
263             let rdlen := returndatasize()
264             returndatacopy(0, 0, rdlen)
265             if success {
266                 return(0, rdlen)
267             }
268             revert(0, rdlen)
269         }
270     }
271 }