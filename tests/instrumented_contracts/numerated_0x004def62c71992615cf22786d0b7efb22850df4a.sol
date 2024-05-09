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
13 pragma solidity 0.4.21;
14 /// @title Utility Functions for address
15 /// @author Daniel Wang - <daniel@loopring.org>
16 library AddressUtil {
17     function isContract(
18         address addr
19         )
20         internal
21         view
22         returns (bool)
23     {
24         if (addr == 0x0) {
25             return false;
26         } else {
27             uint size;
28             assembly { size := extcodesize(addr) }
29             return size > 0;
30         }
31     }
32 }
33 /*
34   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
35   Licensed under the Apache License, Version 2.0 (the "License");
36   you may not use this file except in compliance with the License.
37   You may obtain a copy of the License at
38   http://www.apache.org/licenses/LICENSE-2.0
39   Unless required by applicable law or agreed to in writing, software
40   distributed under the License is distributed on an "AS IS" BASIS,
41   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
42   See the License for the specific language governing permissions and
43   limitations under the License.
44 */
45 /*
46   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
47   Licensed under the Apache License, Version 2.0 (the "License");
48   you may not use this file except in compliance with the License.
49   You may obtain a copy of the License at
50   http://www.apache.org/licenses/LICENSE-2.0
51   Unless required by applicable law or agreed to in writing, software
52   distributed under the License is distributed on an "AS IS" BASIS,
53   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
54   See the License for the specific language governing permissions and
55   limitations under the License.
56 */
57 /*
58   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
59   Licensed under the Apache License, Version 2.0 (the "License");
60   you may not use this file except in compliance with the License.
61   You may obtain a copy of the License at
62   http://www.apache.org/licenses/LICENSE-2.0
63   Unless required by applicable law or agreed to in writing, software
64   distributed under the License is distributed on an "AS IS" BASIS,
65   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
66   See the License for the specific language governing permissions and
67   limitations under the License.
68 */
69 /// @title Ownable
70 /// @dev The Ownable contract has an owner address, and provides basic
71 ///      authorization control functions, this simplifies the implementation of
72 ///      "user permissions".
73 contract Ownable {
74     address public owner;
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79     /// @dev The Ownable constructor sets the original `owner` of the contract
80     ///      to the sender.
81     function Ownable()
82         public
83     {
84         owner = msg.sender;
85     }
86     /// @dev Throws if called by any account other than the owner.
87     modifier onlyOwner()
88     {
89         require(msg.sender == owner);
90         _;
91     }
92     /// @dev Allows the current owner to transfer control of the contract to a
93     ///      newOwner.
94     /// @param newOwner The address to transfer ownership to.
95     function transferOwnership(
96         address newOwner
97         )
98         onlyOwner
99         public
100     {
101         require(newOwner != 0x0);
102         emit OwnershipTransferred(owner, newOwner);
103         owner = newOwner;
104     }
105 }
106 /// @title Claimable
107 /// @dev Extension for the Ownable contract, where the ownership needs
108 ///      to be claimed. This allows the new owner to accept the transfer.
109 contract Claimable is Ownable {
110     address public pendingOwner;
111     /// @dev Modifier throws if called by any account other than the pendingOwner.
112     modifier onlyPendingOwner() {
113         require(msg.sender == pendingOwner);
114         _;
115     }
116     /// @dev Allows the current owner to set the pendingOwner address.
117     /// @param newOwner The address to transfer ownership to.
118     function transferOwnership(
119         address newOwner
120         )
121         onlyOwner
122         public
123     {
124         require(newOwner != 0x0 && newOwner != owner);
125         pendingOwner = newOwner;
126     }
127     /// @dev Allows the pendingOwner address to finalize the transfer.
128     function claimOwnership()
129         onlyPendingOwner
130         public
131     {
132         emit OwnershipTransferred(owner, pendingOwner);
133         owner = pendingOwner;
134         pendingOwner = 0x0;
135     }
136 }
137 /*
138   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
139   Licensed under the Apache License, Version 2.0 (the "License");
140   you may not use this file except in compliance with the License.
141   You may obtain a copy of the License at
142   http://www.apache.org/licenses/LICENSE-2.0
143   Unless required by applicable law or agreed to in writing, software
144   distributed under the License is distributed on an "AS IS" BASIS,
145   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
146   See the License for the specific language governing permissions and
147   limitations under the License.
148 */
149 /// @title Token Register Contract
150 /// @dev This contract maintains a list of tokens the Protocol supports.
151 /// @author Kongliang Zhong - <kongliang@loopring.org>,
152 /// @author Daniel Wang - <daniel@loopring.org>.
153 contract TokenRegistry {
154     event TokenRegistered(address addr, string symbol);
155     event TokenUnregistered(address addr, string symbol);
156     function registerToken(
157         address addr,
158         string  symbol
159         )
160         external;
161     function registerMintedToken(
162         address addr,
163         string  symbol
164         )
165         external;
166     function unregisterToken(
167         address addr,
168         string  symbol
169         )
170         external;
171     function areAllTokensRegistered(
172         address[] addressList
173         )
174         external
175         view
176         returns (bool);
177     function getAddressBySymbol(
178         string symbol
179         )
180         external
181         view
182         returns (address);
183     function isTokenRegisteredBySymbol(
184         string symbol
185         )
186         public
187         view
188         returns (bool);
189     function isTokenRegistered(
190         address addr
191         )
192         public
193         view
194         returns (bool);
195     function getTokens(
196         uint start,
197         uint count
198         )
199         public
200         view
201         returns (address[] addressList);
202 }
203 /// @title An Implementation of TokenRegistry.
204 /// @author Kongliang Zhong - <kongliang@loopring.org>,
205 /// @author Daniel Wang - <daniel@loopring.org>.
206 contract TokenRegistryImpl is TokenRegistry, Claimable {
207     using AddressUtil for address;
208     address[] public addresses;
209     mapping (address => TokenInfo) addressMap;
210     mapping (string => address) symbolMap;
211     struct TokenInfo {
212         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
213                          // token's position in `addresses`.
214         string symbol;   // Symbol of the token
215     }
216     /// @dev Disable default function.
217     function ()
218         payable
219         public
220     {
221         revert();
222     }
223     function registerToken(
224         address addr,
225         string  symbol
226         )
227         external
228         onlyOwner
229     {
230         registerTokenInternal(addr, symbol);
231     }
232     function registerMintedToken(
233         address addr,
234         string  symbol
235         )
236         external
237     {
238         registerTokenInternal(addr, symbol);
239     }
240     function unregisterToken(
241         address addr,
242         string  symbol
243         )
244         external
245         onlyOwner
246     {
247         require(addr != 0x0);
248         require(symbolMap[symbol] == addr);
249         delete symbolMap[symbol];
250         uint pos = addressMap[addr].pos;
251         require(pos != 0);
252         delete addressMap[addr];
253         // We will replace the token we need to unregister with the last token
254         // Only the pos of the last token will need to be updated
255         address lastToken = addresses[addresses.length - 1];
256         // Don't do anything if the last token is the one we want to delete
257         if (addr != lastToken) {
258             // Swap with the last token and update the pos
259             addresses[pos - 1] = lastToken;
260             addressMap[lastToken].pos = pos;
261         }
262         addresses.length--;
263         emit TokenUnregistered(addr, symbol);
264     }
265     function areAllTokensRegistered(
266         address[] addressList
267         )
268         external
269         view
270         returns (bool)
271     {
272         for (uint i = 0; i < addressList.length; i++) {
273             if (addressMap[addressList[i]].pos == 0) {
274                 return false;
275             }
276         }
277         return true;
278     }
279     function getAddressBySymbol(
280         string symbol
281         )
282         external
283         view
284         returns (address)
285     {
286         return symbolMap[symbol];
287     }
288     function isTokenRegisteredBySymbol(
289         string symbol
290         )
291         public
292         view
293         returns (bool)
294     {
295         return symbolMap[symbol] != 0x0;
296     }
297     function isTokenRegistered(
298         address addr
299         )
300         public
301         view
302         returns (bool)
303     {
304         return addressMap[addr].pos != 0;
305     }
306     function getTokens(
307         uint start,
308         uint count
309         )
310         public
311         view
312         returns (address[] addressList)
313     {
314         uint num = addresses.length;
315         if (start >= num) {
316             return;
317         }
318         uint end = start + count;
319         if (end > num) {
320             end = num;
321         }
322         if (start == num) {
323             return;
324         }
325         addressList = new address[](end - start);
326         for (uint i = start; i < end; i++) {
327             addressList[i - start] = addresses[i];
328         }
329     }
330     function registerTokenInternal(
331         address addr,
332         string  symbol
333         )
334         internal
335     {
336         require(0x0 != addr);
337         require(bytes(symbol).length > 0);
338         require(0x0 == symbolMap[symbol]);
339         require(0 == addressMap[addr].pos);
340         addresses.push(addr);
341         symbolMap[symbol] = addr;
342         addressMap[addr] = TokenInfo(addresses.length, symbol);
343         emit TokenRegistered(addr, symbol);
344     }
345 }