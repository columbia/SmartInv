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
212     /// @dev Disable default function.
213     function () payable public {
214         revert();
215     }
216     /// @dev Add a Loopring protocol address.
217     /// @param addr A loopring protocol address.
218     function authorizeAddress(address addr)
219         onlyOwner
220         external
221     {
222         AddressInfo storage addrInfo = addressInfos[addr];
223         if (addrInfo.index != 0) { // existing
224             if (addrInfo.authorized == false) { // re-authorize
225                 addrInfo.authorized = true;
226                 AddressAuthorized(addr, addrInfo.index);
227             }
228         } else {
229             address prev = latestAddress;
230             if (prev == 0x0) {
231                 addrInfo.index = 1;
232                 addrInfo.authorized = true;
233             } else {
234                 addrInfo.previous = prev;
235                 addrInfo.index = addressInfos[prev].index + 1;
236             }
237             addrInfo.authorized = true;
238             latestAddress = addr;
239             AddressAuthorized(addr, addrInfo.index);
240         }
241     }
242     /// @dev Remove a Loopring protocol address.
243     /// @param addr A loopring protocol address.
244     function deauthorizeAddress(address addr)
245         onlyOwner
246         external
247     {
248         uint32 index = addressInfos[addr].index;
249         if (index != 0) {
250             addressInfos[addr].authorized = false;
251             AddressDeauthorized(addr, index);
252         }
253     }
254     function isAddressAuthorized(address addr)
255         public
256         view
257         returns (bool)
258     {
259         return addressInfos[addr].authorized;
260     }
261     function getLatestAuthorizedAddresses(uint max)
262         external
263         view
264         returns (address[] addresses)
265     {
266         addresses = new address[](max);
267         address addr = latestAddress;
268         AddressInfo memory addrInfo;
269         uint count = 0;
270         while (addr != 0x0 && count < max) {
271             addrInfo = addressInfos[addr];
272             if (addrInfo.index == 0) {
273                 break;
274             }
275             addresses[count++] = addr;
276             addr = addrInfo.previous;
277         }
278     }
279     /// @dev Invoke ERC20 transferFrom method.
280     /// @param token Address of token to transfer.
281     /// @param from Address to transfer token from.
282     /// @param to Address to transfer token to.
283     /// @param value Amount of token to transfer.
284     function transferToken(
285         address token,
286         address from,
287         address to,
288         uint    value)
289         onlyAuthorized
290         external
291     {
292         if (value > 0 && from != to) {
293             require(
294                 ERC20(token).transferFrom(from, to, value)
295             );
296         }
297     }
298     function batchTransferToken(
299         address lrcTokenAddress,
300         address feeRecipient,
301         bytes32[] batch)
302         onlyAuthorized
303         external
304     {
305         uint len = batch.length;
306         require(len % 6 == 0);
307         ERC20 lrc = ERC20(lrcTokenAddress);
308         for (uint i = 0; i < len; i += 6) {
309             address owner = address(batch[i]);
310             address prevOwner = address(batch[(i + len - 6) % len]);
311             // Pay token to previous order, or to miner as previous order's
312             // margin split or/and this order's margin split.
313             ERC20 token = ERC20(address(batch[i + 1]));
314             // Here batch[i+2] has been checked not to be 0.
315             if (owner != prevOwner) {
316                 require(
317                     token.transferFrom(owner, prevOwner, uint(batch[i + 2]))
318                 );
319             }
320             if (owner != feeRecipient) {
321                 bytes32 item = batch[i + 3];
322                 if (item != 0) {
323                     require(
324                         token.transferFrom(owner, feeRecipient, uint(item))
325                     );
326                 }
327                 item = batch[i + 4];
328                 if (item != 0) {
329                     require(
330                         lrc.transferFrom(feeRecipient, owner, uint(item))
331                     );
332                 }
333                 item = batch[i + 5];
334                 if (item != 0) {
335                     require(
336                         lrc.transferFrom(owner, feeRecipient, uint(item))
337                     );
338                 }
339             }
340         }
341     }
342 }