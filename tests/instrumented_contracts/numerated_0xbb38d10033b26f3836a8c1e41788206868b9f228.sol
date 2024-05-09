1 // File: contracts/components/Owned.sol
2 
3 /*
4 
5   Copyright 2019 Wanchain Foundation.
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11   http://www.apache.org/licenses/LICENSE-2.0
12 
13   Unless required by applicable law or agreed to in writing, software
14   distributed under the License is distributed on an "AS IS" BASIS,
15   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16   See the License for the specific language governing permissions and
17   limitations under the License.
18 
19 */
20 
21 //                            _           _           _
22 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
23 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
24 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
25 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
26 //
27 //
28 
29 pragma solidity ^0.4.24;
30 
31 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
32 ///  later changed
33 contract Owned {
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /// @dev `owner` is the only address that can call a function with this
38     /// modifier
39     modifier onlyOwner() {
40         require(msg.sender == owner, "Not owner");
41         _;
42     }
43 
44     address public owner;
45 
46     /// @notice The Constructor assigns the message sender to be `owner`
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     address public newOwner;
52 
53     function transferOwner(address _newOwner) public onlyOwner {
54         require(_newOwner != address(0), "New owner is the zero address");
55         emit OwnershipTransferred(owner, _newOwner);
56         owner = _newOwner;
57     }
58 
59     /// @notice `owner` can step down and assign some other address to this role
60     /// @param _newOwner The address of the new owner. 0x0 can be used to create
61     ///  an unowned neutral vault, however that cannot be undone
62     function changeOwner(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65 
66     function acceptOwnership() public {
67         if (msg.sender == newOwner) {
68             owner = newOwner;
69         }
70     }
71 
72     function renounceOwnership() public onlyOwner {
73         owner = address(0);
74     }
75 }
76 
77 // File: contracts/lib/BasicStorageLib.sol
78 
79 pragma solidity ^0.4.24;
80 
81 library BasicStorageLib {
82 
83     struct UintData {
84         mapping(bytes => mapping(bytes => uint))           _storage;
85     }
86 
87     struct BoolData {
88         mapping(bytes => mapping(bytes => bool))           _storage;
89     }
90 
91     struct AddressData {
92         mapping(bytes => mapping(bytes => address))        _storage;
93     }
94 
95     struct BytesData {
96         mapping(bytes => mapping(bytes => bytes))          _storage;
97     }
98 
99     struct StringData {
100         mapping(bytes => mapping(bytes => string))         _storage;
101     }
102 
103     /* uintStorage */
104 
105     function setStorage(UintData storage self, bytes memory key, bytes memory innerKey, uint value) internal {
106         self._storage[key][innerKey] = value;
107     }
108 
109     function getStorage(UintData storage self, bytes memory key, bytes memory innerKey) internal view returns (uint) {
110         return self._storage[key][innerKey];
111     }
112 
113     function delStorage(UintData storage self, bytes memory key, bytes memory innerKey) internal {
114         delete self._storage[key][innerKey];
115     }
116 
117     /* boolStorage */
118 
119     function setStorage(BoolData storage self, bytes memory key, bytes memory innerKey, bool value) internal {
120         self._storage[key][innerKey] = value;
121     }
122 
123     function getStorage(BoolData storage self, bytes memory key, bytes memory innerKey) internal view returns (bool) {
124         return self._storage[key][innerKey];
125     }
126 
127     function delStorage(BoolData storage self, bytes memory key, bytes memory innerKey) internal {
128         delete self._storage[key][innerKey];
129     }
130 
131     /* addressStorage */
132 
133     function setStorage(AddressData storage self, bytes memory key, bytes memory innerKey, address value) internal {
134         self._storage[key][innerKey] = value;
135     }
136 
137     function getStorage(AddressData storage self, bytes memory key, bytes memory innerKey) internal view returns (address) {
138         return self._storage[key][innerKey];
139     }
140 
141     function delStorage(AddressData storage self, bytes memory key, bytes memory innerKey) internal {
142         delete self._storage[key][innerKey];
143     }
144 
145     /* bytesStorage */
146 
147     function setStorage(BytesData storage self, bytes memory key, bytes memory innerKey, bytes memory value) internal {
148         self._storage[key][innerKey] = value;
149     }
150 
151     function getStorage(BytesData storage self, bytes memory key, bytes memory innerKey) internal view returns (bytes memory) {
152         return self._storage[key][innerKey];
153     }
154 
155     function delStorage(BytesData storage self, bytes memory key, bytes memory innerKey) internal {
156         delete self._storage[key][innerKey];
157     }
158 
159     /* stringStorage */
160 
161     function setStorage(StringData storage self, bytes memory key, bytes memory innerKey, string memory value) internal {
162         self._storage[key][innerKey] = value;
163     }
164 
165     function getStorage(StringData storage self, bytes memory key, bytes memory innerKey) internal view returns (string memory) {
166         return self._storage[key][innerKey];
167     }
168 
169     function delStorage(StringData storage self, bytes memory key, bytes memory innerKey) internal {
170         delete self._storage[key][innerKey];
171     }
172 
173 }
174 
175 // File: contracts/components/BasicStorage.sol
176 
177 pragma solidity ^0.4.24;
178 
179 
180 contract BasicStorage {
181     /************************************************************
182      **
183      ** VARIABLES
184      **
185      ************************************************************/
186 
187     //// basic variables
188     using BasicStorageLib for BasicStorageLib.UintData;
189     using BasicStorageLib for BasicStorageLib.BoolData;
190     using BasicStorageLib for BasicStorageLib.AddressData;
191     using BasicStorageLib for BasicStorageLib.BytesData;
192     using BasicStorageLib for BasicStorageLib.StringData;
193 
194     BasicStorageLib.UintData    internal uintData;
195     BasicStorageLib.BoolData    internal boolData;
196     BasicStorageLib.AddressData internal addressData;
197     BasicStorageLib.BytesData   internal bytesData;
198     BasicStorageLib.StringData  internal stringData;
199 }
200 
201 // File: contracts/oracle/OracleStorage.sol
202 
203 pragma solidity 0.4.26;
204 
205 
206 contract OracleStorage is BasicStorage {
207   /************************************************************
208     **
209     ** STRUCTURE DEFINATIONS
210     **
211     ************************************************************/
212   struct StoremanGroupConfig {
213     uint    deposit;
214     uint[2] chain;
215     uint[2] curve;
216     bytes   gpk1;
217     bytes   gpk2;
218     uint    startTime;
219     uint    endTime;
220     uint8   status;
221     bool    isDebtClean;
222   }
223 
224   /************************************************************
225     **
226     ** VARIABLES
227     **
228     ************************************************************/
229   /// @notice symbol -> price,
230   mapping(bytes32 => uint) public mapPrices;
231 
232   /// @notice smgId -> StoremanGroupConfig
233   mapping(bytes32 => StoremanGroupConfig) public mapStoremanGroupConfig;
234 
235   /// @notice owner and admin have the authority of admin
236   address public admin;
237 }
238 
239 // File: contracts/components/Proxy.sol
240 
241 /*
242 
243   Copyright 2019 Wanchain Foundation.
244 
245   Licensed under the Apache License, Version 2.0 (the "License");
246   you may not use this file except in compliance with the License.
247   You may obtain a copy of the License at
248 
249   http://www.apache.org/licenses/LICENSE-2.0
250 
251   Unless required by applicable law or agreed to in writing, software
252   distributed under the License is distributed on an "AS IS" BASIS,
253   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
254   See the License for the specific language governing permissions and
255   limitations under the License.
256 
257 */
258 
259 //                            _           _           _
260 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
261 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
262 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
263 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
264 //
265 //
266 
267 pragma solidity ^0.4.24;
268 
269 /**
270  * Math operations with safety checks
271  */
272 
273 
274 contract Proxy {
275 
276     event Upgraded(address indexed implementation);
277 
278     address internal _implementation;
279 
280     function implementation() public view returns (address) {
281         return _implementation;
282     }
283 
284     function () external payable {
285         address _impl = _implementation;
286         require(_impl != address(0), "implementation contract not set");
287 
288         assembly {
289             let ptr := mload(0x40)
290             calldatacopy(ptr, 0, calldatasize)
291             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
292             let size := returndatasize
293             returndatacopy(ptr, 0, size)
294 
295             switch result
296             case 0 { revert(ptr, size) }
297             default { return(ptr, size) }
298         }
299     }
300 }
301 
302 // File: contracts/oracle/OracleProxy.sol
303 
304 /*
305 
306   Copyright 2019 Wanchain Foundation.
307 
308   Licensed under the Apache License, Version 2.0 (the "License");
309   you may not use this file except in compliance with the License.
310   You may obtain a copy of the License at
311 
312   http://www.apache.org/licenses/LICENSE-2.0
313 
314   Unless required by applicable law or agreed to in writing, software
315   distributed under the License is distributed on an "AS IS" BASIS,
316   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
317   See the License for the specific language governing permissions and
318   limitations under the License.
319 
320 */
321 
322 //                            _           _           _
323 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
324 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
325 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
326 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
327 //
328 //
329 
330 pragma solidity 0.4.26;
331 
332 
333 
334 
335 contract OracleProxy is OracleStorage, Owned, Proxy {
336     /**
337     *
338     * MANIPULATIONS
339     *
340     */
341 
342     /// @notice                           function for setting or upgrading OracleDelegate address by owner
343     /// @param impl                       OracleDelegate contract address
344     function upgradeTo(address impl) public onlyOwner {
345         require(impl != address(0), "Cannot upgrade to invalid address");
346         require(impl != _implementation, "Cannot upgrade to the same implementation");
347         _implementation = impl;
348         emit Upgraded(impl);
349     }
350 }