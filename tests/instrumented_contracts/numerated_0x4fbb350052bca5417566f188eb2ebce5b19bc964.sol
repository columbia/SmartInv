1 /*
2 
3  Copyright 2017-2018 RigoBlock, Rigo Investment Sagl.
4 
5  Licensed under the Apache License, Version 2.0 (the "License");
6  you may not use this file except in compliance with the License.
7  You may obtain a copy of the License at
8 
9      http://www.apache.org/licenses/LICENSE-2.0
10 
11  Unless required by applicable law or agreed to in writing, software
12  distributed under the License is distributed on an "AS IS" BASIS,
13  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14  See the License for the specific language governing permissions and
15  limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.25;
20 pragma experimental "v0.5.0";
21 
22 contract SafeMath {
23 
24     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b > 0);
32         uint256 c = a / b;
33         assert(a == b * c + a % b);
34         return c;
35     }
36 
37     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c>=a && c>=b);
45         return c;
46     }
47 
48     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
49         return a >= b ? a : b;
50     }
51 
52     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
53         return a < b ? a : b;
54     }
55 
56     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a >= b ? a : b;
58     }
59 
60     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a < b ? a : b;
62     }
63 }
64 
65 interface ERC20Face {
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70     function transfer(address _to, uint256 _value) external returns (bool success);
71     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
72     function approve(address _spender, uint256 _value) external returns (bool success);
73 
74     function balanceOf(address _who) external view returns (uint256);
75     function allowance(address _owner, address _spender) external view returns (uint256);
76 }
77 
78 contract ERC20 is ERC20Face {
79 
80     function transfer(address _to, uint256 _value)
81         external
82         returns (bool success)
83     {
84         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
85         balances[msg.sender] -= _value;
86         balances[_to] += _value;
87         emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value)
92         external
93         returns (bool success)
94     {
95         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
96         balances[_to] += _value;
97         balances[_from] -= _value;
98         allowed[_from][msg.sender] -= _value;
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value)
104         external
105         returns (bool success)
106     {
107         allowed[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function balanceOf(address _owner)
113         external
114         view
115         returns (uint256)
116     {
117         return balances[_owner];
118     }
119 
120     function allowance(address _owner, address _spender)
121         external
122         view
123         returns (uint256)
124     {
125         return allowed[_owner][_spender];
126     }
127 
128     uint256 public totalSupply;
129     mapping (address => uint256) balances;
130     mapping (address => mapping (address => uint256)) allowed;
131 }
132 
133 contract UnlimitedAllowanceToken is ERC20 {
134 
135     uint256 constant MAX_UINT = 2**256 - 1;
136 
137     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
138     /// @param _from Address to transfer from.
139     /// @param _to Address to transfer to.
140     /// @param _value Amount to transfer.
141     /// @return Success of transfer.
142     function transferFrom(address _from, address _to, uint256 _value)
143         external
144         returns (bool)
145     {
146         uint256 allowance = allowed[_from][msg.sender];
147         require(
148             balances[_from] >= _value
149             && allowance >= _value
150             && balances[_to] + _value >= balances[_to]
151         );
152         balances[_to] += _value;
153         balances[_from] -= _value;
154         if (allowance < MAX_UINT) {
155             allowed[_from][msg.sender] -= _value;
156         }
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160 }
161 
162 /// @title Rigo Token - Rules of the Rigo token.
163 /// @author Gabriele Rigo - <gab@rigoblock.com>
164 /// @notice UnlimitedAllowanceToken is ERC20
165 contract RigoToken is UnlimitedAllowanceToken, SafeMath {
166 
167     string constant public name = "Rigo Token";
168     string constant public symbol = "GRG";
169     uint8 constant public decimals = 18;
170 
171     uint256 public totalSupply = 10**25; // 10 million tokens, 18 decimal places
172     address public minter;
173     address public rigoblock;
174 
175     /*
176      * EVENTS
177      */
178     event TokenMinted(address indexed recipient, uint256 amount);
179 
180     /*
181      * MODIFIERS
182      */
183     modifier onlyMinter {
184         require(msg.sender == minter);
185         _;
186     }
187 
188     modifier onlyRigoblock {
189         require(msg.sender == rigoblock);
190         _;
191     }
192 
193     constructor(address _setMinter, address _setRigoblock) public {
194         minter = _setMinter;
195         rigoblock = _setRigoblock;
196         balances[msg.sender] = totalSupply;
197     }
198 
199     /*
200      * CORE FUNCTIONS
201      */
202     /// @dev Allows minter to create new tokens
203     /// @param _recipient Address of who receives new tokens
204     /// @param _amount Number of new tokens
205     function mintToken(
206         address _recipient,
207         uint256 _amount)
208         external
209         onlyMinter
210     {
211         balances[_recipient] = safeAdd(balances[_recipient], _amount);
212         totalSupply = safeAdd(totalSupply, _amount);
213         emit TokenMinted(_recipient, _amount);
214     }
215 
216     /// @dev Allows rigoblock dao to change minter
217     /// @param _newAddress Address of the new minter
218     function changeMintingAddress(address _newAddress)
219         external
220         onlyRigoblock
221     {
222         minter = _newAddress;
223     }
224 
225     /// @dev Allows rigoblock dao to upgrade dao
226     /// @param _newAddress Address of the new rigoblock dao
227     function changeRigoblockAddress(address _newAddress)
228         external
229         onlyRigoblock
230     {
231         rigoblock = _newAddress;
232     }
233 }