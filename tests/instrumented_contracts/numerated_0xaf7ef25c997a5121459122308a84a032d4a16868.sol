1 /*
2   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3   Licensed under the Apache License, Version 2.0 (the "License");
4   you may not use this file except in compliance with the License.
5   You may obtain a copy of the License at
6   http://www.apache.org/licenses/LICENSE-2.0
7   Unless required by applicable law or agreed to in writing, software
8   distributed under the License is distributed on an "AS IS" BASIS,
9   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
10   See the License for the specific language governing permissions and
11   limitations under the License.
12 */
13 pragma solidity 0.4.18;
14 /// @title Utility Functions for uint
15 /// @author Daniel Wang - <daniel@loopring.org>
16 library MathUint {
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function sub(uint a, uint b) internal pure returns (uint) {
22         require(b <= a);
23         return a - b;
24     }
25     function add(uint a, uint b) internal pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
30         return (a >= b) ? a - b : 0;
31     }
32     /// @dev calculate the square of Coefficient of Variation (CV)
33     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
34     function cvsquare(
35         uint[] arr,
36         uint scale
37         )
38         internal
39         pure
40         returns (uint)
41     {
42         uint len = arr.length;
43         require(len > 1);
44         require(scale > 0);
45         uint avg = 0;
46         for (uint i = 0; i < len; i++) {
47             avg += arr[i];
48         }
49         avg = avg / len;
50         if (avg == 0) {
51             return 0;
52         }
53         uint cvs = 0;
54         uint s;
55         uint item;
56         for (i = 0; i < len; i++) {
57             item = arr[i];
58             s = item > avg ? item - avg : avg - item;
59             cvs += mul(s, s);
60         }
61         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
62     }
63 }
64 /*
65   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
66   Licensed under the Apache License, Version 2.0 (the "License");
67   you may not use this file except in compliance with the License.
68   You may obtain a copy of the License at
69   http://www.apache.org/licenses/LICENSE-2.0
70   Unless required by applicable law or agreed to in writing, software
71   distributed under the License is distributed on an "AS IS" BASIS,
72   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
73   See the License for the specific language governing permissions and
74   limitations under the License.
75 */
76 /*
77   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
78   Licensed under the Apache License, Version 2.0 (the "License");
79   you may not use this file except in compliance with the License.
80   You may obtain a copy of the License at
81   http://www.apache.org/licenses/LICENSE-2.0
82   Unless required by applicable law or agreed to in writing, software
83   distributed under the License is distributed on an "AS IS" BASIS,
84   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
85   See the License for the specific language governing permissions and
86   limitations under the License.
87 */
88 /// @title ERC20 Token Interface
89 /// @dev see https://github.com/ethereum/EIPs/issues/20
90 /// @author Daniel Wang - <daniel@loopring.org>
91 contract ERC20 {
92     uint public totalSupply;
93 	
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96     function balanceOf(address who) view public returns (uint256);
97     function allowance(address owner, address spender) view public returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101 }
102 /*
103   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
104   Licensed under the Apache License, Version 2.0 (the "License");
105   you may not use this file except in compliance with the License.
106   You may obtain a copy of the License at
107   http://www.apache.org/licenses/LICENSE-2.0
108   Unless required by applicable law or agreed to in writing, software
109   distributed under the License is distributed on an "AS IS" BASIS,
110   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
111   See the License for the specific language governing permissions and
112   limitations under the License.
113 */
114 /*
115   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
116   Licensed under the Apache License, Version 2.0 (the "License");
117   you may not use this file except in compliance with the License.
118   You may obtain a copy of the License at
119   http://www.apache.org/licenses/LICENSE-2.0
120   Unless required by applicable law or agreed to in writing, software
121   distributed under the License is distributed on an "AS IS" BASIS,
122   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
123   See the License for the specific language governing permissions and
124   limitations under the License.
125 */
126 /// @title Ownable
127 /// @dev The Ownable contract has an owner address, and provides basic
128 ///      authorization control functions, this simplifies the implementation of
129 ///      "user permissions".
130 contract Ownable {
131     address public owner;
132     event OwnershipTransferred(
133         address indexed previousOwner,
134         address indexed newOwner
135     );
136     /// @dev The Ownable constructor sets the original `owner` of the contract
137     ///      to the sender.
138     function Ownable() public {
139         owner = msg.sender;
140     }
141     /// @dev Throws if called by any account other than the owner.
142     modifier onlyOwner() {
143         require(msg.sender == owner);
144         _;
145     }
146     /// @dev Allows the current owner to transfer control of the contract to a
147     ///      newOwner.
148     /// @param newOwner The address to transfer ownership to.
149     function transferOwnership(address newOwner) onlyOwner public {
150         require(newOwner != 0x0);
151         OwnershipTransferred(owner, newOwner);
152         owner = newOwner;
153     }
154 }
155 /// @title Claimable
156 /// @dev Extension for the Ownable contract, where the ownership needs
157 ///      to be claimed. This allows the new owner to accept the transfer.
158 contract Claimable is Ownable {
159     address public pendingOwner;
160     /// @dev Modifier throws if called by any account other than the pendingOwner.
161     modifier onlyPendingOwner() {
162         require(msg.sender == pendingOwner);
163         _;
164     }
165     /// @dev Allows the current owner to set the pendingOwner address.
166     /// @param newOwner The address to transfer ownership to.
167     function transferOwnership(address newOwner) onlyOwner public {
168         require(newOwner != 0x0 && newOwner != owner);
169         pendingOwner = newOwner;
170     }
171     /// @dev Allows the pendingOwner address to finalize the transfer.
172     function claimOwnership() onlyPendingOwner public {
173         OwnershipTransferred(owner, pendingOwner);
174         owner = pendingOwner;
175         pendingOwner = 0x0;
176     }
177 }
178 /// @title TokenTransferDelegate
179 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
180 /// versions of Loopring protocol to avoid ERC20 re-authorization.
181 /// @author Daniel Wang - <daniel@loopring.org>.
182 contract TokenTransferDelegate is Claimable {
183     using MathUint for uint;
184     ////////////////////////////////////////////////////////////////////////////
185     /// Variables                                                            ///
186     ////////////////////////////////////////////////////////////////////////////
187     mapping(address => AddressInfo) private addressInfos;
188     address public latestAddress;
189     ////////////////////////////////////////////////////////////////////////////
190     /// Structs                                                              ///
191     ////////////////////////////////////////////////////////////////////////////
192     struct AddressInfo {
193         address previous;
194         uint32  index;
195         bool    authorized;
196     }
197     ////////////////////////////////////////////////////////////////////////////
198     /// Modifiers                                                            ///
199     ////////////////////////////////////////////////////////////////////////////
200     modifier onlyAuthorized() {
201         require(addressInfos[msg.sender].authorized);
202         _;
203     }
204     ////////////////////////////////////////////////////////////////////////////
205     /// Events                                                               ///
206     ////////////////////////////////////////////////////////////////////////////
207     event AddressAuthorized(address indexed addr, uint32 number);
208     event AddressDeauthorized(address indexed addr, uint32 number);
209     ////////////////////////////////////////////////////////////////////////////
210     /// Public Functions                                                     ///
211     ////////////////////////////////////////////////////////////////////////////
212     /// @dev Add a Loopring protocol address.
213     /// @param addr A loopring protocol address.
214     function authorizeAddress(address addr)
215         onlyOwner
216         external
217     {
218         var addrInfo = addressInfos[addr];
219         if (addrInfo.index != 0) { // existing
220             if (addrInfo.authorized == false) { // re-authorize
221                 addrInfo.authorized = true;
222                 AddressAuthorized(addr, addrInfo.index);
223             }
224         } else {
225             address prev = latestAddress;
226             if (prev == 0x0) {
227                 addrInfo.index = 1;
228                 addrInfo.authorized = true;
229             } else {
230                 addrInfo.previous = prev;
231                 addrInfo.index = addressInfos[prev].index + 1;
232             }
233             addrInfo.authorized = true;
234             latestAddress = addr;
235             AddressAuthorized(addr, addrInfo.index);
236         }
237     }
238     /// @dev Remove a Loopring protocol address.
239     /// @param addr A loopring protocol address.
240     function deauthorizeAddress(address addr)
241         onlyOwner
242         external
243     {
244         uint32 index = addressInfos[addr].index;
245         if (index != 0) {
246             addressInfos[addr].authorized = false;
247             AddressDeauthorized(addr, index);
248         }
249     }
250     function isAddressAuthorized(address addr)
251         public
252         view
253         returns (bool)
254     {
255         return addressInfos[addr].authorized;
256     }
257     function getLatestAuthorizedAddresses(uint max)
258         external
259         view
260         returns (address[] addresses)
261     {
262         addresses = new address[](max);
263         address addr = latestAddress;
264         AddressInfo memory addrInfo;
265         uint count = 0;
266         while (addr != 0x0 && count < max) {
267             addrInfo = addressInfos[addr];
268             if (addrInfo.index == 0) {
269                 break;
270             }
271             addresses[count++] = addr;
272             addr = addrInfo.previous;
273         }
274     }
275     /// @dev Invoke ERC20 transferFrom method.
276     /// @param token Address of token to transfer.
277     /// @param from Address to transfer token from.
278     /// @param to Address to transfer token to.
279     /// @param value Amount of token to transfer.
280     function transferToken(
281         address token,
282         address from,
283         address to,
284         uint    value)
285         onlyAuthorized
286         external
287     {
288         if (value > 0 && from != to) {
289             require(
290                 ERC20(token).transferFrom(from, to, value)
291             );
292         }
293     }
294     function batchTransferToken(
295         address lrcTokenAddress,
296         address feeRecipient,
297         bytes32[] batch)
298         onlyAuthorized
299         external
300     {
301         uint len = batch.length;
302         require(len % 6 == 0);
303         var lrc = ERC20(lrcTokenAddress);
304         for (uint i = 0; i < len; i += 6) {
305             address owner = address(batch[i]);
306             address prevOwner = address(batch[(i + len - 6) % len]);
307             
308             // Pay token to previous order, or to miner as previous order's
309             // margin split or/and this order's margin split.
310             var token = ERC20(address(batch[i + 1]));
311             // Here batch[i+2] has been checked not to be 0.
312             if (owner != prevOwner) {
313                 require(
314                     token.transferFrom(owner, prevOwner, uint(batch[i + 2]))
315                 );
316             }
317             if (owner != feeRecipient) {
318                 bytes32 item = batch[i + 3];
319                 if (item != 0) {
320                     require(
321                         token.transferFrom(owner, feeRecipient, uint(item))
322                     );
323                 } 
324                 item = batch[i + 4];
325                 if (item != 0) {
326                     require(
327                         lrc.transferFrom(feeRecipient, owner, uint(item))
328                     );
329                 }
330                 item = batch[i + 5];
331                 if (item != 0) {
332                     require(
333                         lrc.transferFrom(owner, feeRecipient, uint(item))
334                     );
335                 }
336             }
337         }
338     }
339 }