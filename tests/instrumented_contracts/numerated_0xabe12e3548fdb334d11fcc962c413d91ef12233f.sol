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
154     event TokenRegistered(
155         address indexed addr,
156         string          symbol
157     );
158     event TokenUnregistered(
159         address indexed addr,
160         string          symbol
161     );
162     function registerToken(
163         address addr,
164         string  symbol
165         )
166         external;
167     function unregisterToken(
168         address addr,
169         string  symbol
170         )
171         external;
172     function areAllTokensRegistered(
173         address[] addressList
174         )
175         external
176         view
177         returns (bool);
178     function getAddressBySymbol(
179         string symbol
180         )
181         external
182         view
183         returns (address);
184     function isTokenRegisteredBySymbol(
185         string symbol
186         )
187         public
188         view
189         returns (bool);
190     function isTokenRegistered(
191         address addr
192         )
193         public
194         view
195         returns (bool);
196     function getTokens(
197         uint start,
198         uint count
199         )
200         public
201         view
202         returns (address[] addressList);
203 }
204 /// @title An Implementation of TokenRegistry.
205 /// @author Kongliang Zhong - <kongliang@loopring.org>,
206 /// @author Daniel Wang - <daniel@loopring.org>.
207 contract TokenRegistryImpl is TokenRegistry, Claimable {
208     using AddressUtil for address;
209     address[] public addresses;
210     mapping (address => TokenInfo) addressMap;
211     mapping (string => address) symbolMap;
212     struct TokenInfo {
213         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
214                          // token's position in `addresses`.
215         string symbol;   // Symbol of the token
216     }
217     /// @dev Disable default function.
218     function ()
219         payable
220         public
221     {
222         revert();
223     }
224     function registerToken(
225         address addr,
226         string  symbol
227         )
228         external
229         onlyOwner
230     {
231         registerTokenInternal(addr, symbol);
232     }
233     function unregisterToken(
234         address addr,
235         string  symbol
236         )
237         external
238         onlyOwner
239     {
240         require(addr != 0x0);
241         require(symbolMap[symbol] == addr);
242         delete symbolMap[symbol];
243         uint pos = addressMap[addr].pos;
244         require(pos != 0);
245         delete addressMap[addr];
246         // We will replace the token we need to unregister with the last token
247         // Only the pos of the last token will need to be updated
248         address lastToken = addresses[addresses.length - 1];
249         // Don't do anything if the last token is the one we want to delete
250         if (addr != lastToken) {
251             // Swap with the last token and update the pos
252             addresses[pos - 1] = lastToken;
253             addressMap[lastToken].pos = pos;
254         }
255         addresses.length--;
256         emit TokenUnregistered(addr, symbol);
257     }
258     function areAllTokensRegistered(
259         address[] addressList
260         )
261         external
262         view
263         returns (bool)
264     {
265         for (uint i = 0; i < addressList.length; i++) {
266             if (addressMap[addressList[i]].pos == 0) {
267                 return false;
268             }
269         }
270         return true;
271     }
272     function getAddressBySymbol(
273         string symbol
274         )
275         external
276         view
277         returns (address)
278     {
279         return symbolMap[symbol];
280     }
281     function isTokenRegisteredBySymbol(
282         string symbol
283         )
284         public
285         view
286         returns (bool)
287     {
288         return symbolMap[symbol] != 0x0;
289     }
290     function isTokenRegistered(
291         address addr
292         )
293         public
294         view
295         returns (bool)
296     {
297         return addressMap[addr].pos != 0;
298     }
299     function getTokens(
300         uint start,
301         uint count
302         )
303         public
304         view
305         returns (address[] addressList)
306     {
307         uint num = addresses.length;
308         if (start >= num) {
309             return;
310         }
311         uint end = start + count;
312         if (end > num) {
313             end = num;
314         }
315         addressList = new address[](end - start);
316         for (uint i = start; i < end; i++) {
317             addressList[i - start] = addresses[i];
318         }
319     }
320     function registerTokenInternal(
321         address addr,
322         string  symbol
323         )
324         internal
325     {
326         require(0x0 != addr);
327         require(bytes(symbol).length > 0);
328         require(0x0 == symbolMap[symbol]);
329         require(0 == addressMap[addr].pos);
330         addresses.push(addr);
331         symbolMap[symbol] = addr;
332         addressMap[addr] = TokenInfo(addresses.length, symbol);
333         emit TokenRegistered(addr, symbol);
334     }
335 }