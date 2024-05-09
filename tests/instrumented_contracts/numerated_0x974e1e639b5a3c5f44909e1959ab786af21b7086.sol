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
14 /*
15   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
16   Licensed under the Apache License, Version 2.0 (the "License");
17   you may not use this file except in compliance with the License.
18   You may obtain a copy of the License at
19   http://www.apache.org/licenses/LICENSE-2.0
20   Unless required by applicable law or agreed to in writing, software
21   distributed under the License is distributed on an "AS IS" BASIS,
22   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
23   See the License for the specific language governing permissions and
24   limitations under the License.
25 */
26 /*
27   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
28   Licensed under the Apache License, Version 2.0 (the "License");
29   you may not use this file except in compliance with the License.
30   You may obtain a copy of the License at
31   http://www.apache.org/licenses/LICENSE-2.0
32   Unless required by applicable law or agreed to in writing, software
33   distributed under the License is distributed on an "AS IS" BASIS,
34   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
35   See the License for the specific language governing permissions and
36   limitations under the License.
37 */
38 /// @title Ownable
39 /// @dev The Ownable contract has an owner address, and provides basic
40 ///      authorization control functions, this simplifies the implementation of
41 ///      "user permissions".
42 contract Ownable {
43     address public owner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48     /// @dev The Ownable constructor sets the original `owner` of the contract
49     ///      to the sender.
50     function Ownable() public {
51         owner = msg.sender;
52     }
53     /// @dev Throws if called by any account other than the owner.
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58     /// @dev Allows the current owner to transfer control of the contract to a
59     ///      newOwner.
60     /// @param newOwner The address to transfer ownership to.
61     function transferOwnership(address newOwner) onlyOwner public {
62         require(newOwner != 0x0);
63         OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65     }
66 }
67 /// @title Claimable
68 /// @dev Extension for the Ownable contract, where the ownership needs
69 ///      to be claimed. This allows the new owner to accept the transfer.
70 contract Claimable is Ownable {
71     address public pendingOwner;
72     /// @dev Modifier throws if called by any account other than the pendingOwner.
73     modifier onlyPendingOwner() {
74         require(msg.sender == pendingOwner);
75         _;
76     }
77     /// @dev Allows the current owner to set the pendingOwner address.
78     /// @param newOwner The address to transfer ownership to.
79     function transferOwnership(address newOwner) onlyOwner public {
80         require(newOwner != 0x0 && newOwner != owner);
81         pendingOwner = newOwner;
82     }
83     /// @dev Allows the pendingOwner address to finalize the transfer.
84     function claimOwnership() onlyPendingOwner public {
85         OwnershipTransferred(owner, pendingOwner);
86         owner = pendingOwner;
87         pendingOwner = 0x0;
88     }
89 }
90 /// @title Token Register Contract
91 /// @dev This contract maintains a list of tokens the Protocol supports.
92 /// @author Kongliang Zhong - <kongliang@loopring.org>,
93 /// @author Daniel Wang - <daniel@loopring.org>.
94 contract TokenRegistry is Claimable {
95     address[] public addresses;
96     mapping (address => TokenInfo) addressMap;
97     mapping (string => address) symbolMap;
98     
99     uint8 public constant TOKEN_STANDARD_ERC20   = 0;
100     uint8 public constant TOKEN_STANDARD_ERC223  = 1;
101     
102     ////////////////////////////////////////////////////////////////////////////
103     /// Structs                                                              ///
104     ////////////////////////////////////////////////////////////////////////////
105     struct TokenInfo {
106         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
107                          // token's position in `addresses`.
108         uint8  standard; // ERC20 or ERC223
109         string symbol;   // Symbol of the token
110     }
111     
112     ////////////////////////////////////////////////////////////////////////////
113     /// Events                                                               ///
114     ////////////////////////////////////////////////////////////////////////////
115     event TokenRegistered(address addr, string symbol);
116     event TokenUnregistered(address addr, string symbol);
117     
118     ////////////////////////////////////////////////////////////////////////////
119     /// Public Functions                                                     ///
120     ////////////////////////////////////////////////////////////////////////////
121     /// @dev Disable default function.
122     function () payable public {
123         revert();
124     }
125     function registerToken(
126         address addr,
127         string  symbol
128         )
129         external
130         onlyOwner
131     {
132         registerStandardToken(addr, symbol, TOKEN_STANDARD_ERC20);    
133     }
134     function registerStandardToken(
135         address addr,
136         string  symbol,
137         uint8   standard
138         )
139         public
140         onlyOwner
141     {
142         require(0x0 != addr);
143         require(bytes(symbol).length > 0);
144         require(0x0 == symbolMap[symbol]);
145         require(0 == addressMap[addr].pos);
146         require(standard <= TOKEN_STANDARD_ERC223);
147         addresses.push(addr);
148         symbolMap[symbol] = addr;
149         addressMap[addr] = TokenInfo(addresses.length, standard, symbol);
150         TokenRegistered(addr, symbol);      
151     }
152     function unregisterToken(
153         address addr,
154         string  symbol
155         )
156         external
157         onlyOwner
158     {
159         require(addr != 0x0);
160         require(symbolMap[symbol] == addr);
161         delete symbolMap[symbol];
162         
163         uint pos = addressMap[addr].pos;
164         require(pos != 0);
165         delete addressMap[addr];
166         
167         // We will replace the token we need to unregister with the last token
168         // Only the pos of the last token will need to be updated
169         address lastToken = addresses[addresses.length - 1];
170         
171         // Don't do anything if the last token is the one we want to delete
172         if (addr != lastToken) {
173             // Swap with the last token and update the pos
174             addresses[pos - 1] = lastToken;
175             addressMap[lastToken].pos = pos;
176         }
177         addresses.length--;
178         TokenUnregistered(addr, symbol);
179     }
180     function isTokenRegisteredBySymbol(string symbol)
181         public
182         view
183         returns (bool)
184     {
185         return symbolMap[symbol] != 0x0;
186     }
187     function isTokenRegistered(address addr)
188         public
189         view
190         returns (bool)
191     {
192         return addressMap[addr].pos != 0;
193     }
194     function areAllTokensRegistered(address[] addressList)
195         external
196         view
197         returns (bool)
198     {
199         for (uint i = 0; i < addressList.length; i++) {
200             if (addressMap[addressList[i]].pos == 0) {
201                 return false;
202             }
203         }
204         return true;
205     }
206     
207     function getTokenStandard(address addr)
208         public
209         view
210         returns (uint8)
211     {
212         TokenInfo memory info = addressMap[addr];
213         require(info.pos != 0);
214         return info.standard;
215     }
216     function getAddressBySymbol(string symbol)
217         external
218         view
219         returns (address)
220     {
221         return symbolMap[symbol];
222     }
223     
224     function getTokens(
225         uint start,
226         uint count
227         )
228         public
229         view
230         returns (address[] addressList)
231     {
232         uint num = addresses.length;
233         
234         if (start >= num) {
235             return;
236         }
237         
238         uint end = start + count;
239         if (end > num) {
240             end = num;
241         }
242         if (start == num) {
243             return;
244         }
245         
246         addressList = new address[](end - start);
247         for (uint i = start; i < end; i++) {
248             addressList[i - start] = addresses[i];
249         }
250     }
251 }