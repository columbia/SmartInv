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
13 pragma solidity 0.4.19;
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
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     function balanceOf(address who) view public returns (uint256);
96     function allowance(address owner, address spender) view public returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100 }
101 /*
102   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
103   Licensed under the Apache License, Version 2.0 (the "License");
104   you may not use this file except in compliance with the License.
105   You may obtain a copy of the License at
106   http://www.apache.org/licenses/LICENSE-2.0
107   Unless required by applicable law or agreed to in writing, software
108   distributed under the License is distributed on an "AS IS" BASIS,
109   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
110   See the License for the specific language governing permissions and
111   limitations under the License.
112 */
113 /*
114   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
115   Licensed under the Apache License, Version 2.0 (the "License");
116   you may not use this file except in compliance with the License.
117   You may obtain a copy of the License at
118   http://www.apache.org/licenses/LICENSE-2.0
119   Unless required by applicable law or agreed to in writing, software
120   distributed under the License is distributed on an "AS IS" BASIS,
121   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
122   See the License for the specific language governing permissions and
123   limitations under the License.
124 */
125 /// @title Ownable
126 /// @dev The Ownable contract has an owner address, and provides basic
127 ///      authorization control functions, this simplifies the implementation of
128 ///      "user permissions".
129 contract Ownable {
130     address public owner;
131     event OwnershipTransferred(
132         address indexed previousOwner,
133         address indexed newOwner
134     );
135     /// @dev The Ownable constructor sets the original `owner` of the contract
136     ///      to the sender.
137     function Ownable() public {
138         owner = msg.sender;
139     }
140     /// @dev Throws if called by any account other than the owner.
141     modifier onlyOwner() {
142         require(msg.sender == owner);
143         _;
144     }
145     /// @dev Allows the current owner to transfer control of the contract to a
146     ///      newOwner.
147     /// @param newOwner The address to transfer ownership to.
148     function transferOwnership(address newOwner) onlyOwner public {
149         require(newOwner != 0x0);
150         OwnershipTransferred(owner, newOwner);
151         owner = newOwner;
152     }
153 }
154 /// @title Claimable
155 /// @dev Extension for the Ownable contract, where the ownership needs
156 ///      to be claimed. This allows the new owner to accept the transfer.
157 contract Claimable is Ownable {
158     address public pendingOwner;
159     /// @dev Modifier throws if called by any account other than the pendingOwner.
160     modifier onlyPendingOwner() {
161         require(msg.sender == pendingOwner);
162         _;
163     }
164     /// @dev Allows the current owner to set the pendingOwner address.
165     /// @param newOwner The address to transfer ownership to.
166     function transferOwnership(address newOwner) onlyOwner public {
167         require(newOwner != 0x0 && newOwner != owner);
168         pendingOwner = newOwner;
169     }
170     /// @dev Allows the pendingOwner address to finalize the transfer.
171     function claimOwnership() onlyPendingOwner public {
172         OwnershipTransferred(owner, pendingOwner);
173         owner = pendingOwner;
174         pendingOwner = 0x0;
175     }
176 }
177 /// @title TokenTransferDelegate
178 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
179 /// versions of Loopring protocol to avoid ERC20 re-authorization.
180 /// @author Daniel Wang - <daniel@loopring.org>.
181 contract TokenTransferDelegate is Claimable {
182     using MathUint for uint;
183     ////////////////////////////////////////////////////////////////////////////
184     /// Variables                                                            ///
185     ////////////////////////////////////////////////////////////////////////////
186     mapping(address => AddressInfo) private addressInfos;
187     address public latestAddress;
188     ////////////////////////////////////////////////////////////////////////////
189     /// Structs                                                              ///
190     ////////////////////////////////////////////////////////////////////////////
191     struct AddressInfo {
192         address previous;
193         uint32  index;
194         bool    authorized;
195     }
196     ////////////////////////////////////////////////////////////////////////////
197     /// Modifiers                                                            ///
198     ////////////////////////////////////////////////////////////////////////////
199     modifier onlyAuthorized() {
200         require(addressInfos[msg.sender].authorized);
201         _;
202     }
203     ////////////////////////////////////////////////////////////////////////////
204     /// Events                                                               ///
205     ////////////////////////////////////////////////////////////////////////////
206     event AddressAuthorized(address indexed addr, uint32 number);
207     event AddressDeauthorized(address indexed addr, uint32 number);
208     ////////////////////////////////////////////////////////////////////////////
209     /// Public Functions                                                     ///
210     ////////////////////////////////////////////////////////////////////////////
211     /// @dev Disable default function.
212     function () payable public {
213         revert();
214     }
215     /// @dev Add a Loopring protocol address.
216     /// @param addr A loopring protocol address.
217     function authorizeAddress(address addr)
218         onlyOwner
219         external
220     {
221         AddressInfo storage addrInfo = addressInfos[addr];
222         if (addrInfo.index != 0) { // existing
223             if (addrInfo.authorized == false) { // re-authorize
224                 addrInfo.authorized = true;
225                 AddressAuthorized(addr, addrInfo.index);
226             }
227         } else {
228             address prev = latestAddress;
229             if (prev == 0x0) {
230                 addrInfo.index = 1;
231                 addrInfo.authorized = true;
232             } else {
233                 addrInfo.previous = prev;
234                 addrInfo.index = addressInfos[prev].index + 1;
235             }
236             addrInfo.authorized = true;
237             latestAddress = addr;
238             AddressAuthorized(addr, addrInfo.index);
239         }
240     }
241     /// @dev Remove a Loopring protocol address.
242     /// @param addr A loopring protocol address.
243     function deauthorizeAddress(address addr)
244         onlyOwner
245         external
246     {
247         uint32 index = addressInfos[addr].index;
248         if (index != 0) {
249             addressInfos[addr].authorized = false;
250             AddressDeauthorized(addr, index);
251         }
252     }
253     function getLatestAuthorizedAddresses(uint max)
254         external
255         view
256         returns (address[] addresses)
257     {
258         addresses = new address[](max);
259         address addr = latestAddress;
260         AddressInfo memory addrInfo;
261         uint count = 0;
262         while (addr != 0x0 && count < max) {
263             addrInfo = addressInfos[addr];
264             if (addrInfo.index == 0) {
265                 break;
266             }
267             addresses[count++] = addr;
268             addr = addrInfo.previous;
269         }
270     }
271     /// @dev Invoke ERC20 transferFrom method.
272     /// @param token Address of token to transfer.
273     /// @param from Address to transfer token from.
274     /// @param to Address to transfer token to.
275     /// @param value Amount of token to transfer.
276     function transferToken(
277         address token,
278         address from,
279         address to,
280         uint    value)
281         onlyAuthorized
282         external
283     {
284         if (value > 0 && from != to && to != 0x0) {
285             require(
286                 ERC20(token).transferFrom(from, to, value)
287             );
288         }
289     }
290     function batchTransferToken(
291         address lrcTokenAddress,
292         address feeRecipient,
293         bytes32[] batch)
294         onlyAuthorized
295         external
296     {
297         uint len = batch.length;
298         require(len % 6 == 0);
299         ERC20 lrc = ERC20(lrcTokenAddress);
300         for (uint i = 0; i < len; i += 6) {
301             address owner = address(batch[i]);
302             address prevOwner = address(batch[(i + len - 6) % len]);
303             // Pay token to previous order, or to miner as previous order's
304             // margin split or/and this order's margin split.
305             ERC20 token = ERC20(address(batch[i + 1]));
306             // Here batch[i+2] has been checked not to be 0.
307             if (owner != prevOwner) {
308                 require(
309                     token.transferFrom(owner, prevOwner, uint(batch[i + 2]))
310                 );
311             }
312             if (feeRecipient != 0x0 && owner != feeRecipient) {
313                 bytes32 item = batch[i + 3];
314                 if (item != 0) {
315                     require(
316                         token.transferFrom(owner, feeRecipient, uint(item))
317                     );
318                 }
319                 item = batch[i + 4];
320                 if (item != 0) {
321                     require(
322                         lrc.transferFrom(feeRecipient, owner, uint(item))
323                     );
324                 }
325                 item = batch[i + 5];
326                 if (item != 0) {
327                     require(
328                         lrc.transferFrom(owner, feeRecipient, uint(item))
329                     );
330                 }
331             }
332         }
333     }
334     function isAddressAuthorized(address addr)
335         public
336         view
337         returns (bool)
338     {
339         return addressInfos[addr].authorized;
340     }
341 }