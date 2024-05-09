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
98     ////////////////////////////////////////////////////////////////////////////
99     /// Structs                                                              ///
100     ////////////////////////////////////////////////////////////////////////////
101     struct TokenInfo {
102         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
103                          // token's position in `addresses`.
104         string symbol;   // Symbol of the token
105     }
106     ////////////////////////////////////////////////////////////////////////////
107     /// Events                                                               ///
108     ////////////////////////////////////////////////////////////////////////////
109     event TokenRegistered(address addr, string symbol);
110     event TokenUnregistered(address addr, string symbol);
111     ////////////////////////////////////////////////////////////////////////////
112     /// Public Functions                                                     ///
113     ////////////////////////////////////////////////////////////////////////////
114     /// @dev Disable default function.
115     function () payable public {
116         revert();
117     }
118     function registerToken(
119         address addr,
120         string  symbol
121         )
122         external
123         onlyOwner
124     {
125         require(0x0 != addr);
126         require(bytes(symbol).length > 0);
127         require(0x0 == symbolMap[symbol]);
128         require(0 == addressMap[addr].pos);
129         addresses.push(addr);
130         symbolMap[symbol] = addr;
131         addressMap[addr] = TokenInfo(addresses.length, symbol);
132         TokenRegistered(addr, symbol);
133     }
134     function unregisterToken(
135         address addr,
136         string  symbol
137         )
138         external
139         onlyOwner
140     {
141         require(addr != 0x0);
142         require(symbolMap[symbol] == addr);
143         delete symbolMap[symbol];
144         uint pos = addressMap[addr].pos;
145         require(pos != 0);
146         delete addressMap[addr];
147         // We will replace the token we need to unregister with the last token
148         // Only the pos of the last token will need to be updated
149         address lastToken = addresses[addresses.length - 1];
150         // Don't do anything if the last token is the one we want to delete
151         if (addr != lastToken) {
152             // Swap with the last token and update the pos
153             addresses[pos - 1] = lastToken;
154             addressMap[lastToken].pos = pos;
155         }
156         addresses.length--;
157         TokenUnregistered(addr, symbol);
158     }
159     function areAllTokensRegistered(address[] addressList)
160         external
161         view
162         returns (bool)
163     {
164         for (uint i = 0; i < addressList.length; i++) {
165             if (addressMap[addressList[i]].pos == 0) {
166                 return false;
167             }
168         }
169         return true;
170     }
171     function getAddressBySymbol(string symbol)
172         external
173         view
174         returns (address)
175     {
176         return symbolMap[symbol];
177     }
178     function isTokenRegisteredBySymbol(string symbol)
179         public
180         view
181         returns (bool)
182     {
183         return symbolMap[symbol] != 0x0;
184     }
185     function isTokenRegistered(address addr)
186         public
187         view
188         returns (bool)
189     {
190         return addressMap[addr].pos != 0;
191     }
192     function getTokens(
193         uint start,
194         uint count
195         )
196         public
197         view
198         returns (address[] addressList)
199     {
200         uint num = addresses.length;
201         if (start >= num) {
202             return;
203         }
204         uint end = start + count;
205         if (end > num) {
206             end = num;
207         }
208         if (start == num) {
209             return;
210         }
211         addressList = new address[](end - start);
212         for (uint i = start; i < end; i++) {
213             addressList[i - start] = addresses[i];
214         }
215     }
216 }