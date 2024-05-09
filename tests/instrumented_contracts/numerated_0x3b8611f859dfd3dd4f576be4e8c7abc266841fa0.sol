1 /*
2 
3   Copyright 2018 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 contract IOwnable {
22 
23     function transferOwnership(address newOwner)
24         public;
25 }
26 
27 contract Ownable is
28     IOwnable
29 {
30     address public owner;
31 
32     constructor ()
33         public
34     {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(
40             msg.sender == owner,
41             "ONLY_CONTRACT_OWNER"
42         );
43         _;
44     }
45 
46     function transferOwnership(address newOwner)
47         public
48         onlyOwner
49     {
50         if (newOwner != address(0)) {
51             owner = newOwner;
52         }
53     }
54 }
55 
56 contract IAuthorizable is
57     IOwnable
58 {
59     /// @dev Authorizes an address.
60     /// @param target Address to authorize.
61     function addAuthorizedAddress(address target)
62         external;
63 
64     /// @dev Removes authorizion of an address.
65     /// @param target Address to remove authorization from.
66     function removeAuthorizedAddress(address target)
67         external;
68 
69     /// @dev Removes authorizion of an address.
70     /// @param target Address to remove authorization from.
71     /// @param index Index of target in authorities array.
72     function removeAuthorizedAddressAtIndex(
73         address target,
74         uint256 index
75     )
76         external;
77     
78     /// @dev Gets all authorized addresses.
79     /// @return Array of authorized addresses.
80     function getAuthorizedAddresses()
81         external
82         view
83         returns (address[] memory);
84 }
85 
86 contract MAuthorizable is
87     IAuthorizable
88 {
89     // Event logged when a new address is authorized.
90     event AuthorizedAddressAdded(
91         address indexed target,
92         address indexed caller
93     );
94 
95     // Event logged when a currently authorized address is unauthorized.
96     event AuthorizedAddressRemoved(
97         address indexed target,
98         address indexed caller
99     );
100 
101     /// @dev Only authorized addresses can invoke functions with this modifier.
102     modifier onlyAuthorized { revert(); _; }
103 }
104 
105 contract MixinAuthorizable is
106     Ownable,
107     MAuthorizable
108 {
109     /// @dev Only authorized addresses can invoke functions with this modifier.
110     modifier onlyAuthorized {
111         require(
112             authorized[msg.sender],
113             "SENDER_NOT_AUTHORIZED"
114         );
115         _;
116     }
117 
118     mapping (address => bool) public authorized;
119     address[] public authorities;
120 
121     /// @dev Authorizes an address.
122     /// @param target Address to authorize.
123     function addAuthorizedAddress(address target)
124         external
125         onlyOwner
126     {
127         require(
128             !authorized[target],
129             "TARGET_ALREADY_AUTHORIZED"
130         );
131 
132         authorized[target] = true;
133         authorities.push(target);
134         emit AuthorizedAddressAdded(target, msg.sender);
135     }
136 
137     /// @dev Removes authorizion of an address.
138     /// @param target Address to remove authorization from.
139     function removeAuthorizedAddress(address target)
140         external
141         onlyOwner
142     {
143         require(
144             authorized[target],
145             "TARGET_NOT_AUTHORIZED"
146         );
147 
148         delete authorized[target];
149         for (uint256 i = 0; i < authorities.length; i++) {
150             if (authorities[i] == target) {
151                 authorities[i] = authorities[authorities.length - 1];
152                 authorities.length -= 1;
153                 break;
154             }
155         }
156         emit AuthorizedAddressRemoved(target, msg.sender);
157     }
158 
159     /// @dev Removes authorizion of an address.
160     /// @param target Address to remove authorization from.
161     /// @param index Index of target in authorities array.
162     function removeAuthorizedAddressAtIndex(
163         address target,
164         uint256 index
165     )
166         external
167         onlyOwner
168     {
169         require(
170             authorized[target],
171             "TARGET_NOT_AUTHORIZED"
172         );
173         require(
174             index < authorities.length,
175             "INDEX_OUT_OF_BOUNDS"
176         );
177         require(
178             authorities[index] == target,
179             "AUTHORIZED_ADDRESS_MISMATCH"
180         );
181 
182         delete authorized[target];
183         authorities[index] = authorities[authorities.length - 1];
184         authorities.length -= 1;
185         emit AuthorizedAddressRemoved(target, msg.sender);
186     }
187 
188     /// @dev Gets all authorized addresses.
189     /// @return Array of authorized addresses.
190     function getAuthorizedAddresses()
191         external
192         view
193         returns (address[] memory)
194     {
195         return authorities;
196     }
197 }
198 
199 contract ERC721Proxy is
200     MixinAuthorizable
201 {
202     // Id of this proxy.
203     bytes4 constant internal PROXY_ID = bytes4(keccak256("ERC721Token(address,uint256)"));
204 
205     // solhint-disable-next-line payable-fallback
206     function () 
207         external
208     {
209         assembly {
210             // The first 4 bytes of calldata holds the function selector
211             let selector := and(calldataload(0), 0xffffffff00000000000000000000000000000000000000000000000000000000)
212 
213             // `transferFrom` will be called with the following parameters:
214             // assetData Encoded byte array.
215             // from Address to transfer asset from.
216             // to Address to transfer asset to.
217             // amount Amount of asset to transfer.
218             // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
219             if eq(selector, 0xa85e59e400000000000000000000000000000000000000000000000000000000) {
220 
221                 // To lookup a value in a mapping, we load from the storage location keccak256(k, p),
222                 // where k is the key left padded to 32 bytes and p is the storage slot
223                 let start := mload(64)
224                 mstore(start, and(caller, 0xffffffffffffffffffffffffffffffffffffffff))
225                 mstore(add(start, 32), authorized_slot)
226 
227                 // Revert if authorized[msg.sender] == false
228                 if iszero(sload(keccak256(start, 64))) {
229                     // Revert with `Error("SENDER_NOT_AUTHORIZED")`
230                     mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
231                     mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
232                     mstore(64, 0x0000001553454e4445525f4e4f545f415554484f52495a454400000000000000)
233                     mstore(96, 0)
234                     revert(0, 100)
235                 }
236 
237                 // `transferFrom`.
238                 // The function is marked `external`, so no abi decodeding is done for
239                 // us. Instead, we expect the `calldata` memory to contain the
240                 // following:
241                 //
242                 // | Area     | Offset | Length  | Contents                            |
243                 // |----------|--------|---------|-------------------------------------|
244                 // | Header   | 0      | 4       | function selector                   |
245                 // | Params   |        | 4 * 32  | function parameters:                |
246                 // |          | 4      |         |   1. offset to assetData (*)        |
247                 // |          | 36     |         |   2. from                           |
248                 // |          | 68     |         |   3. to                             |
249                 // |          | 100    |         |   4. amount                         |
250                 // | Data     |        |         | assetData:                          |
251                 // |          | 132    | 32      | assetData Length                    |
252                 // |          | 164    | **      | assetData Contents                  |
253                 //
254                 // (*): offset is computed from start of function parameters, so offset
255                 //      by an additional 4 bytes in the calldata.
256                 //
257                 // (**): see table below to compute length of assetData Contents
258                 //
259                 // WARNING: The ABIv2 specification allows additional padding between
260                 //          the Params and Data section. This will result in a larger
261                 //          offset to assetData.
262 
263                 // Asset data itself is encoded as follows:
264                 //
265                 // | Area     | Offset | Length  | Contents                            |
266                 // |----------|--------|---------|-------------------------------------|
267                 // | Header   | 0      | 4       | function selector                   |
268                 // | Params   |        | 2 * 32  | function parameters:                |
269                 // |          | 4      | 12 + 20 |   1. token address                  |
270                 // |          | 36     |         |   2. tokenId                        |
271                 
272                 // We construct calldata for the `token.transferFrom` ABI.
273                 // The layout of this calldata is in the table below.
274                 // 
275                 // | Area     | Offset | Length  | Contents                            |
276                 // |----------|--------|---------|-------------------------------------|
277                 // | Header   | 0      | 4       | function selector                   |
278                 // | Params   |        | 3 * 32  | function parameters:                |
279                 // |          | 4      |         |   1. from                           |
280                 // |          | 36     |         |   2. to                             |
281                 // |          | 68     |         |   3. tokenId                        |
282 
283                 // There exists only 1 of each token.
284                 // require(amount == 1, "INVALID_AMOUNT")
285                 if sub(calldataload(100), 1) {
286                     // Revert with `Error("INVALID_AMOUNT")`
287                     mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
288                     mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
289                     mstore(64, 0x0000000e494e56414c49445f414d4f554e540000000000000000000000000000)
290                     mstore(96, 0)
291                     revert(0, 100)
292                 }
293 
294                 /////// Setup Header Area ///////
295                 // This area holds the 4-byte `transferFrom` selector.
296                 // Any trailing data in transferFromSelector will be
297                 // overwritten in the next `mstore` call.
298                 mstore(0, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
299                 
300                 /////// Setup Params Area ///////
301                 // We copy the fields `from` and `to` in bulk
302                 // from our own calldata to the new calldata.
303                 calldatacopy(4, 36, 64)
304 
305                 // Copy `tokenId` field from our own calldata to the new calldata.
306                 let assetDataOffset := calldataload(4)
307                 calldatacopy(68, add(assetDataOffset, 72), 32)
308 
309                 /////// Call `token.transferFrom` using the calldata ///////
310                 let token := calldataload(add(assetDataOffset, 40))
311                 let success := call(
312                     gas,            // forward all gas
313                     token,          // call address of token contract
314                     0,              // don't send any ETH
315                     0,              // pointer to start of input
316                     100,            // length of input
317                     0,              // write output to null
318                     0               // output size is 0 bytes
319                 )
320                 if success {
321                     return(0, 0)
322                 }
323                 
324                 // Revert with `Error("TRANSFER_FAILED")`
325                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
326                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
327                 mstore(64, 0x0000000f5452414e534645525f4641494c454400000000000000000000000000)
328                 mstore(96, 0)
329                 revert(0, 100)
330             }
331 
332             // Revert if undefined function is called
333             revert(0, 0)
334         }
335     }
336 
337     /// @dev Gets the proxy id associated with the proxy address.
338     /// @return Proxy id.
339     function getProxyId()
340         external
341         pure
342         returns (bytes4)
343     {
344         return PROXY_ID;
345     }
346 }