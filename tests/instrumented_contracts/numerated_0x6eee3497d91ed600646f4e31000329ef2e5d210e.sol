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
14 /// @title UintUtil
15 /// @author Daniel Wang - <daniel@loopring.org>
16 /// @dev uint utility functions
17 library MathUint {
18     function mul(uint a, uint b) internal pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function sub(uint a, uint b) internal pure returns (uint) {
23         require(b <= a);
24         return a - b;
25     }
26     function add(uint a, uint b) internal pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
31         return (a >= b) ? a - b : 0;
32     }
33     /// @dev calculate the square of Coefficient of Variation (CV)
34     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
35     function cvsquare(
36         uint[] arr,
37         uint scale
38         )
39         internal
40         pure
41         returns (uint)
42     {
43         uint len = arr.length;
44         require(len > 1);
45         require(scale > 0);
46         uint avg = 0;
47         for (uint i = 0; i < len; i++) {
48             avg += arr[i];
49         }
50         avg = avg / len;
51         if (avg == 0) {
52             return 0;
53         }
54         uint cvs = 0;
55         uint s = 0;
56         for (i = 0; i < len; i++) {
57             s = arr[i] > avg ? arr[i] - avg : avg - arr[i];
58             cvs += mul(s, s);
59         }
60         return (mul(mul(cvs, scale) / avg, scale) / avg) / (len - 1);
61     }
62 }
63 /*
64   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
65   Licensed under the Apache License, Version 2.0 (the "License");
66   you may not use this file except in compliance with the License.
67   You may obtain a copy of the License at
68   http://www.apache.org/licenses/LICENSE-2.0
69   Unless required by applicable law or agreed to in writing, software
70   distributed under the License is distributed on an "AS IS" BASIS,
71   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
72   See the License for the specific language governing permissions and
73   limitations under the License.
74 */
75 /*
76   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
77   Licensed under the Apache License, Version 2.0 (the "License");
78   you may not use this file except in compliance with the License.
79   You may obtain a copy of the License at
80   http://www.apache.org/licenses/LICENSE-2.0
81   Unless required by applicable law or agreed to in writing, software
82   distributed under the License is distributed on an "AS IS" BASIS,
83   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
84   See the License for the specific language governing permissions and
85   limitations under the License.
86 */
87 /// @title ERC20 interface
88 /// @dev see https://github.com/ethereum/EIPs/issues/20
89 contract ERC20 {
90     uint public totalSupply;
91 	
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94     function balanceOf(address who) view public returns (uint256);
95     function allowance(address owner, address spender) view public returns (uint256);
96     function transfer(address to, uint256 value) public returns (bool);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99 }
100 /*
101   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
102   Licensed under the Apache License, Version 2.0 (the "License");
103   you may not use this file except in compliance with the License.
104   You may obtain a copy of the License at
105   http://www.apache.org/licenses/LICENSE-2.0
106   Unless required by applicable law or agreed to in writing, software
107   distributed under the License is distributed on an "AS IS" BASIS,
108   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
109   See the License for the specific language governing permissions and
110   limitations under the License.
111 */
112 /// @title Ownable
113 /// @dev The Ownable contract has an owner address, and provides basic
114 ///      authorization control functions, this simplifies the implementation of
115 ///      "user permissions".
116 contract Ownable {
117     address public owner;
118     /// @dev The Ownable constructor sets the original `owner` of the contract
119     ///      to the sender.
120     function Ownable() public {
121         owner = msg.sender;
122     }
123     /// @dev Throws if called by any account other than the owner.
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128     /// @dev Allows the current owner to transfer control of the contract to a
129     ///      newOwner.
130     /// @param newOwner The address to transfer ownership to.
131     function transferOwnership(address newOwner) onlyOwner public {
132         if (newOwner != address(0)) {
133             owner = newOwner;
134         }
135     }
136 }
137 /// @title TokenTransferDelegate - Acts as a middle man to transfer ERC20 tokens
138 /// on behalf of different versions of Loopring protocol to avoid ERC20
139 /// re-authorization.
140 /// @author Daniel Wang - <daniel@loopring.org>.
141 contract TokenTransferDelegate is Ownable {
142     using MathUint for uint;
143     ////////////////////////////////////////////////////////////////////////////
144     /// Variables                                                            ///
145     ////////////////////////////////////////////////////////////////////////////
146     mapping(address => AddressInfo) private addressInfos;
147     address public latestAddress;
148     ////////////////////////////////////////////////////////////////////////////
149     /// Structs                                                              ///
150     ////////////////////////////////////////////////////////////////////////////
151     struct AddressInfo {
152         address previous;
153         uint32  index;
154         bool    authorized;
155     }
156     ////////////////////////////////////////////////////////////////////////////
157     /// Modifiers                                                            ///
158     ////////////////////////////////////////////////////////////////////////////
159     modifier onlyAuthorized() {
160         if (isAddressAuthorized(msg.sender) == false) {
161             revert();
162         }
163         _;
164     }
165     ////////////////////////////////////////////////////////////////////////////
166     /// Events                                                               ///
167     ////////////////////////////////////////////////////////////////////////////
168     event AddressAuthorized(address indexed addr, uint32 number);
169     event AddressDeauthorized(address indexed addr, uint32 number);
170     ////////////////////////////////////////////////////////////////////////////
171     /// Public Functions                                                     ///
172     ////////////////////////////////////////////////////////////////////////////
173     /// @dev Add a Loopring protocol address.
174     /// @param addr A loopring protocol address.
175     function authorizeAddress(address addr)
176         onlyOwner
177         external
178     {
179         AddressInfo storage addrInfo = addressInfos[addr];
180         if (addrInfo.index != 0) { // existing
181             if (addrInfo.authorized == false) { // re-authorize
182                 addrInfo.authorized = true;
183                 AddressAuthorized(addr, addrInfo.index);
184             }
185         } else {
186             address prev = latestAddress;
187             if (prev == address(0)) {
188                 addrInfo.index = 1;
189                 addrInfo.authorized = true;
190             } else {
191                 addrInfo.previous = prev;
192                 addrInfo.index = addressInfos[prev].index + 1;
193             }
194             addrInfo.authorized = true;
195             latestAddress = addr;
196             AddressAuthorized(addr, addrInfo.index);
197         }
198     }
199     /// @dev Remove a Loopring protocol address.
200     /// @param addr A loopring protocol address.
201     function deauthorizeAddress(address addr)
202         onlyOwner
203         external
204     {
205         uint32 index = addressInfos[addr].index;
206         if (index != 0) {
207             addressInfos[addr].authorized = false;
208             AddressDeauthorized(addr, index);
209         }
210     }
211     function isAddressAuthorized(address addr)
212         public
213         view
214         returns (bool)
215     {
216         return addressInfos[addr].authorized;
217     }
218     function getLatestAuthorizedAddresses(uint max)
219         external
220         view
221         returns (address[] addresses)
222     {
223         addresses = new address[](max);
224         address addr = latestAddress;
225         AddressInfo memory addrInfo;
226         uint count = 0;
227         while (addr != address(0) && max < count) {
228             addrInfo = addressInfos[addr];
229             if (addrInfo.index == 0) {
230                 break;
231             }
232             addresses[count++] = addr;
233             addr = addrInfo.previous;
234         }
235     }
236     /// @dev Invoke ERC20 transferFrom method.
237     /// @param token Address of token to transfer.
238     /// @param from Address to transfer token from.
239     /// @param to Address to transfer token to.
240     /// @param value Amount of token to transfer.
241     function transferToken(
242         address token,
243         address from,
244         address to,
245         uint    value)
246         onlyAuthorized
247         external
248     {
249         if (value > 0 && from != to) {
250             require(
251                 ERC20(token).transferFrom(from, to, value)
252             );
253         }
254     }
255     function batchTransferToken(
256         uint ringSize, 
257         address lrcTokenAddress,
258         address feeRecipient,
259         bytes32[] batch)
260         onlyAuthorized
261         external
262     {
263         require(batch.length == ringSize * 6);
264         uint p = ringSize * 2;
265         var lrc = ERC20(lrcTokenAddress);
266         for (uint i = 0; i < ringSize; i++) {
267             uint prev = ((i + ringSize - 1) % ringSize);
268             address tokenS = address(batch[i]);
269             address owner = address(batch[ringSize + i]);
270             address prevOwner = address(batch[ringSize + prev]);
271             
272             // Pay tokenS to previous order, or to miner as previous order's
273             // margin split or/and this order's margin split.
274             ERC20 _tokenS;
275             // Try to create ERC20 instances only once per token.
276             if (owner != prevOwner || owner != feeRecipient && batch[p+1] != 0) {
277                 _tokenS = ERC20(tokenS);
278             }
279             // Here batch[p] has been checked not to be 0.
280             if (owner != prevOwner) {
281                 require(
282                     _tokenS.transferFrom(owner, prevOwner, uint(batch[p]))
283                 );
284             }
285             if (owner != feeRecipient) {
286                 if (batch[p+1] != 0) {
287                     require(
288                         _tokenS.transferFrom(owner, feeRecipient, uint(batch[p+1]))
289                     );
290                 } 
291                 if (batch[p+2] != 0) {
292                     require(
293                         lrc.transferFrom(feeRecipient, owner, uint(batch[p+2]))
294                     );
295                 }
296                 if (batch[p+3] != 0) {
297                     require(
298                         lrc.transferFrom(owner, feeRecipient, uint(batch[p+3]))
299                     );
300                 }
301             }
302             p += 4;
303         }
304     }
305 }