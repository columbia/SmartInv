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
95     address[] public tokens;
96     mapping (address => bool) tokenMap;
97     mapping (string => address) tokenSymbolMap;
98     function registerToken(address _token, string _symbol)
99         external
100         onlyOwner
101     {
102         require(_token != 0x0);
103         require(!isTokenRegisteredBySymbol(_symbol));
104         require(!isTokenRegistered(_token));
105         tokens.push(_token);
106         tokenMap[_token] = true;
107         tokenSymbolMap[_symbol] = _token;
108     }
109     function unregisterToken(address _token, string _symbol)
110         external
111         onlyOwner
112     {
113         require(_token != 0x0);
114         require(tokenSymbolMap[_symbol] == _token);
115         delete tokenSymbolMap[_symbol];
116         delete tokenMap[_token];
117         for (uint i = 0; i < tokens.length; i++) {
118             if (tokens[i] == _token) {
119                 tokens[i] = tokens[tokens.length - 1];
120                 tokens.length --;
121                 break;
122             }
123         }
124     }
125     function isTokenRegisteredBySymbol(string symbol)
126         public
127         view
128         returns (bool)
129     {
130         return tokenSymbolMap[symbol] != 0x0;
131     }
132     function isTokenRegistered(address _token)
133         public
134         view
135         returns (bool)
136     {
137         return tokenMap[_token];
138     }
139     function areAllTokensRegistered(address[] tokenList)
140         external
141         view
142         returns (bool)
143     {
144         for (uint i = 0; i < tokenList.length; i++) {
145             if (!tokenMap[tokenList[i]]) {
146                 return false;
147             }
148         }
149         return true;
150     }
151     function getAddressBySymbol(string symbol)
152         external
153         view
154         returns (address)
155     {
156         return tokenSymbolMap[symbol];
157     }
158 }