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
17     function isContract(address addr)
18         internal
19         view
20         returns (bool)
21     {
22         if (addr == 0x0) {
23             return false;
24         } else {
25             uint size;
26             assembly { size := extcodesize(addr) }
27             return size > 0;
28         }
29     }
30 }
31 /*
32   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
33   Licensed under the Apache License, Version 2.0 (the "License");
34   you may not use this file except in compliance with the License.
35   You may obtain a copy of the License at
36   http://www.apache.org/licenses/LICENSE-2.0
37   Unless required by applicable law or agreed to in writing, software
38   distributed under the License is distributed on an "AS IS" BASIS,
39   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
40   See the License for the specific language governing permissions and
41   limitations under the License.
42 */
43 /*
44   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
45   Licensed under the Apache License, Version 2.0 (the "License");
46   you may not use this file except in compliance with the License.
47   You may obtain a copy of the License at
48   http://www.apache.org/licenses/LICENSE-2.0
49   Unless required by applicable law or agreed to in writing, software
50   distributed under the License is distributed on an "AS IS" BASIS,
51   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
52   See the License for the specific language governing permissions and
53   limitations under the License.
54 */
55 /*
56   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
57   Licensed under the Apache License, Version 2.0 (the "License");
58   you may not use this file except in compliance with the License.
59   You may obtain a copy of the License at
60   http://www.apache.org/licenses/LICENSE-2.0
61   Unless required by applicable law or agreed to in writing, software
62   distributed under the License is distributed on an "AS IS" BASIS,
63   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
64   See the License for the specific language governing permissions and
65   limitations under the License.
66 */
67 /// @title Ownable
68 /// @dev The Ownable contract has an owner address, and provides basic
69 ///      authorization control functions, this simplifies the implementation of
70 ///      "user permissions".
71 contract Ownable {
72     address public owner;
73     event OwnershipTransferred(
74         address indexed previousOwner,
75         address indexed newOwner
76     );
77     /// @dev The Ownable constructor sets the original `owner` of the contract
78     ///      to the sender.
79     function Ownable() public {
80         owner = msg.sender;
81     }
82     /// @dev Throws if called by any account other than the owner.
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87     /// @dev Allows the current owner to transfer control of the contract to a
88     ///      newOwner.
89     /// @param newOwner The address to transfer ownership to.
90     function transferOwnership(address newOwner) onlyOwner public {
91         require(newOwner != 0x0);
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94     }
95 }
96 /// @title Claimable
97 /// @dev Extension for the Ownable contract, where the ownership needs
98 ///      to be claimed. This allows the new owner to accept the transfer.
99 contract Claimable is Ownable {
100     address public pendingOwner;
101     /// @dev Modifier throws if called by any account other than the pendingOwner.
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106     /// @dev Allows the current owner to set the pendingOwner address.
107     /// @param newOwner The address to transfer ownership to.
108     function transferOwnership(address newOwner) onlyOwner public {
109         require(newOwner != 0x0 && newOwner != owner);
110         pendingOwner = newOwner;
111     }
112     /// @dev Allows the pendingOwner address to finalize the transfer.
113     function claimOwnership() onlyPendingOwner public {
114         emit OwnershipTransferred(owner, pendingOwner);
115         owner = pendingOwner;
116         pendingOwner = 0x0;
117     }
118 }
119 /// @title Token Register Contract
120 /// @dev This contract maintains a list of tokens the Protocol supports.
121 /// @author Kongliang Zhong - <kongliang@loopring.org>,
122 /// @author Daniel Wang - <daniel@loopring.org>.
123 contract TokenRegistry is Claimable {
124     using AddressUtil for address;
125     address tokenMintAddr;
126     address[] public addresses;
127     mapping (address => TokenInfo) addressMap;
128     mapping (string => address) symbolMap;
129     ////////////////////////////////////////////////////////////////////////////
130     /// Structs                                                              ///
131     ////////////////////////////////////////////////////////////////////////////
132     struct TokenInfo {
133         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
134                          // token's position in `addresses`.
135         string symbol;   // Symbol of the token
136     }
137     ////////////////////////////////////////////////////////////////////////////
138     /// Events                                                               ///
139     ////////////////////////////////////////////////////////////////////////////
140     event TokenRegistered(address addr, string symbol);
141     event TokenUnregistered(address addr, string symbol);
142     ////////////////////////////////////////////////////////////////////////////
143     /// Public Functions                                                     ///
144     ////////////////////////////////////////////////////////////////////////////
145     /// @dev Disable default function.
146     function () payable public {
147         revert();
148     }
149     function TokenRegistry(address _tokenMintAddr) public
150     {
151         require(_tokenMintAddr.isContract());
152         tokenMintAddr = _tokenMintAddr;
153     }
154     function registerToken(
155         address addr,
156         string  symbol
157         )
158         external
159         onlyOwner
160     {
161         registerTokenInternal(addr, symbol);
162     }
163     function registerMintedToken(
164         address addr,
165         string  symbol
166         )
167         external
168     {
169         require(msg.sender == tokenMintAddr);
170         registerTokenInternal(addr, symbol);
171     }
172     function unregisterToken(
173         address addr,
174         string  symbol
175         )
176         external
177         onlyOwner
178     {
179         require(addr != 0x0);
180         require(symbolMap[symbol] == addr);
181         delete symbolMap[symbol];
182         uint pos = addressMap[addr].pos;
183         require(pos != 0);
184         delete addressMap[addr];
185         // We will replace the token we need to unregister with the last token
186         // Only the pos of the last token will need to be updated
187         address lastToken = addresses[addresses.length - 1];
188         // Don't do anything if the last token is the one we want to delete
189         if (addr != lastToken) {
190             // Swap with the last token and update the pos
191             addresses[pos - 1] = lastToken;
192             addressMap[lastToken].pos = pos;
193         }
194         addresses.length--;
195         emit TokenUnregistered(addr, symbol);
196     }
197     function areAllTokensRegistered(address[] addressList)
198         external
199         view
200         returns (bool)
201     {
202         for (uint i = 0; i < addressList.length; i++) {
203             if (addressMap[addressList[i]].pos == 0) {
204                 return false;
205             }
206         }
207         return true;
208     }
209     function getAddressBySymbol(string symbol)
210         external
211         view
212         returns (address)
213     {
214         return symbolMap[symbol];
215     }
216     function isTokenRegisteredBySymbol(string symbol)
217         public
218         view
219         returns (bool)
220     {
221         return symbolMap[symbol] != 0x0;
222     }
223     function isTokenRegistered(address addr)
224         public
225         view
226         returns (bool)
227     {
228         return addressMap[addr].pos != 0;
229     }
230     function getTokens(
231         uint start,
232         uint count
233         )
234         public
235         view
236         returns (address[] addressList)
237     {
238         uint num = addresses.length;
239         if (start >= num) {
240             return;
241         }
242         uint end = start + count;
243         if (end > num) {
244             end = num;
245         }
246         if (start == num) {
247             return;
248         }
249         addressList = new address[](end - start);
250         for (uint i = start; i < end; i++) {
251             addressList[i - start] = addresses[i];
252         }
253     }
254     function registerTokenInternal(
255         address addr,
256         string  symbol
257         )
258         internal
259     {
260         require(0x0 != addr);
261         require(bytes(symbol).length > 0);
262         require(0x0 == symbolMap[symbol]);
263         require(0 == addressMap[addr].pos);
264         addresses.push(addr);
265         symbolMap[symbol] = addr;
266         addressMap[addr] = TokenInfo(addresses.length, symbol);
267         emit TokenRegistered(addr, symbol);
268     }
269 }