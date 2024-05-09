1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 abstract contract Proxy {
9     function _delegate(address implementation) internal virtual {
10         assembly {
11             calldatacopy(0, 0, calldatasize())
12 
13             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
14 
15             returndatacopy(0, 0, returndatasize())
16 
17             switch result
18 
19             case 0 {
20                 revert(0, returndatasize())
21             }
22             default {
23                 return(0, returndatasize())
24             }
25         }
26     }
27 
28     function _implementation() internal view virtual returns (address);
29 
30     function _fallback() internal virtual {
31         _beforeFallback();
32         _delegate(_implementation());
33     }
34 
35     fallback() external payable virtual {
36         _fallback();
37     }
38 
39     receive() external payable virtual {
40         _fallback();
41     }
42 
43     function _beforeFallback() internal virtual {}
44 }
45 
46 interface IBeacon {
47     function implementation() external view returns (address);
48 }
49 interface IERC1822Proxiable {
50     function proxiableUUID() external view returns (bytes32);
51 }
52 library Address {
53     function isContract(address account) internal view returns (bool) {
54         return account.code.length > 0;
55     }
56 
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
65         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
66     }
67 
68     function functionCall(
69         address target,
70         bytes memory data,
71         string memory errorMessage
72     ) internal returns (bytes memory) {
73         return functionCallWithValue(target, data, 0, errorMessage);
74     }
75 
76     function functionCallWithValue(
77         address target,
78         bytes memory data,
79         uint256 value
80     ) internal returns (bytes memory) {
81         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
82     }
83 
84     function functionCallWithValue(
85         address target,
86         bytes memory data,
87         uint256 value,
88         string memory errorMessage
89     ) internal returns (bytes memory) {
90         require(address(this).balance >= value, "Address: insufficient balance for call");
91         (bool success, bytes memory returndata) = target.call{value: value}(data);
92         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
93     }
94 
95     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
96         return functionStaticCall(target, data, "Address: low-level static call failed");
97     }
98 
99     function functionStaticCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal view returns (bytes memory) {
104         (bool success, bytes memory returndata) = target.staticcall(data);
105         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
106     }
107 
108     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
109         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
110     }
111 
112     function functionDelegateCall(
113         address target,
114         bytes memory data,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         (bool success, bytes memory returndata) = target.delegatecall(data);
118         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
119     }
120 
121     function verifyCallResultFromTarget(
122         address target,
123         bool success,
124         bytes memory returndata,
125         string memory errorMessage
126     ) internal view returns (bytes memory) {
127         if (success) {
128             if (returndata.length == 0) {
129                 require(isContract(target), "Address: call to non-contract");
130             }
131             return returndata;
132         } else {
133             _revert(returndata, errorMessage);
134         }
135     }
136 
137     function verifyCallResult(
138         bool success,
139         bytes memory returndata,
140         string memory errorMessage
141     ) internal pure returns (bytes memory) {
142         if (success) {
143             return returndata;
144         } else {
145             _revert(returndata, errorMessage);
146         }
147     }
148 
149     function _revert(bytes memory returndata, string memory errorMessage) private pure {
150         if (returndata.length > 0) {
151             assembly {
152                 let returndata_size := mload(returndata)
153                 revert(add(32, returndata), returndata_size)
154             }
155         } else {
156             revert(errorMessage);
157         }
158     }
159 }
160 library StorageSlot {
161     struct AddressSlot {
162         address value;
163     }
164 
165     struct BooleanSlot {
166         bool value;
167     }
168 
169     struct Bytes32Slot {
170         bytes32 value;
171     }
172 
173     struct Uint256Slot {
174         uint256 value;
175     }
176 
177     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
178         assembly {
179             r.slot := slot
180         }
181     }
182 
183     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
184         assembly {
185             r.slot := slot
186         }
187     }
188 
189     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
190         assembly {
191             r.slot := slot
192         }
193     }
194 
195     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
196         assembly {
197             r.slot := slot
198         }
199     }
200 }
201 
202 abstract contract ERC1967Upgrade {
203     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
204 
205     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
206 
207     event Upgraded(address indexed implementation);
208 
209     function _getImplementation() internal view returns (address) {
210         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
211     }
212 
213     function _setImplementation(address newImplementation) private {
214         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
215         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
216     }
217 
218     function _upgradeTo(address newImplementation) internal {
219         _setImplementation(newImplementation);
220         emit Upgraded(newImplementation);
221     }
222 
223     function _upgradeToAndCall(
224         address newImplementation,
225         bytes memory data,
226         bool forceCall
227     ) internal {
228         _upgradeTo(newImplementation);
229         if (data.length > 0 || forceCall) {
230             Address.functionDelegateCall(newImplementation, data);
231         }
232     }
233 
234     function _upgradeToAndCallUUPS(
235         address newImplementation,
236         bytes memory data,
237         bool forceCall
238     ) internal {
239         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
240             _setImplementation(newImplementation);
241         } else {
242             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
243                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
244             } catch {
245                 revert("ERC1967Upgrade: new implementation is not UUPS");
246             }
247             _upgradeToAndCall(newImplementation, data, forceCall);
248         }
249     }
250 
251     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
252 
253     event AdminChanged(address previousAdmin, address newAdmin);
254 
255     function _getAdmin() internal view returns (address) {
256         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
257     }
258 
259     function _setAdmin(address newAdmin) private {
260         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
261         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
262     }
263 
264     function _changeAdmin(address newAdmin) internal {
265         emit AdminChanged(_getAdmin(), newAdmin);
266         _setAdmin(newAdmin);
267     }
268 
269     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
270 
271     event BeaconUpgraded(address indexed beacon);
272 
273     function _getBeacon() internal view returns (address) {
274         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
275     }
276 
277     function _setBeacon(address newBeacon) private {
278         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
279         require(
280             Address.isContract(IBeacon(newBeacon).implementation()),
281             "ERC1967: beacon implementation is not a contract"
282         );
283         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
284     }
285 
286     function _upgradeBeaconToAndCall(
287         address newBeacon,
288         bytes memory data,
289         bool forceCall
290     ) internal {
291         _setBeacon(newBeacon);
292         emit BeaconUpgraded(newBeacon);
293         if (data.length > 0 || forceCall) {
294             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
295         }
296     }
297 }
298 
299 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
300     constructor(address _logic, bytes memory _data) payable {
301         _upgradeToAndCall(_logic, _data, false);
302     }
303     function _implementation() internal view virtual override returns (address impl) {
304         return ERC1967Upgrade._getImplementation();
305     }
306 }
307 
308 contract TransparentUpgradeableProxy is ERC1967Proxy {
309     constructor(
310         address _logic,
311         address admin_,
312         bytes memory _data
313     ) payable ERC1967Proxy(_logic, _data) {
314         _changeAdmin(admin_);
315     }
316 
317     modifier ifAdmin() {
318         if (msg.sender == _getAdmin()) {
319             _;
320         } else {
321             _fallback();
322         }
323     }
324 
325     function admin() external ifAdmin returns (address admin_) {
326         admin_ = _getAdmin();
327     }
328 
329     function implementation() external ifAdmin returns (address implementation_) {
330         implementation_ = _implementation();
331     }
332 
333     function changeAdmin(address newAdmin) external virtual ifAdmin {
334         _changeAdmin(newAdmin);
335     }
336 
337     function upgradeTo(address newImplementation) external ifAdmin {
338         _upgradeToAndCall(newImplementation, bytes(""), false);
339     }
340 
341     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
342         _upgradeToAndCall(newImplementation, data, true);
343     }
344 
345     function _admin() internal view virtual returns (address) {
346         return _getAdmin();
347     }
348 
349     function _beforeFallback() internal virtual override {
350         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
351         super._beforeFallback();
352     }
353 }