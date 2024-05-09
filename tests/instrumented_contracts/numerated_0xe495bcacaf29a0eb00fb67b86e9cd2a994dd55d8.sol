1 /*
2 
3   Copyright 2017 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.18;
20 
21 contract Token {
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint _value) public returns (bool) {}
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint _value) public returns (bool) {}
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint _value) public returns (bool) {}
41 
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) public view returns (uint) {}
45 
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) public view returns (uint) {}
50 
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53 }
54 
55 contract ERC20Token is Token {
56 
57     function transfer(address _to, uint _value)
58         public
59         returns (bool) 
60     {
61         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]); 
62         balances[msg.sender] -= _value;
63         balances[_to] += _value;
64         Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint _value)
69         public 
70         returns (bool) 
71     {
72         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]); 
73         balances[_to] += _value;
74         balances[_from] -= _value;
75         allowed[_from][msg.sender] -= _value;
76         Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function approve(address _spender, uint _value) 
81         public
82         returns (bool)
83     {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function balanceOf(address _owner)
90         public
91         view
92         returns (uint)
93     {
94         return balances[_owner];
95     }
96 
97     function allowance(address _owner, address _spender) 
98         public
99         view
100         returns (uint)
101     {
102         return allowed[_owner][_spender];
103     }
104 
105     mapping (address => uint) balances;
106     mapping (address => mapping (address => uint)) allowed;
107     uint public totalSupply;
108 }
109 
110 contract UnlimitedAllowanceToken is ERC20Token {
111 
112     uint constant MAX_UINT = 2**256 - 1;
113 
114     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance. See https://github.com/ethereum/EIPs/issues/717
115     /// @param _from Address to transfer from.
116     /// @param _to Address to transfer to.
117     /// @param _value Amount to transfer.
118     /// @return Success of transfer.
119     function transferFrom(address _from, address _to, uint _value)
120         public 
121         returns (bool) 
122     {
123         uint allowance = allowed[_from][msg.sender];
124         require(balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]); 
125         balances[_to] += _value;
126         balances[_from] -= _value;
127         if (allowance < MAX_UINT) {
128             allowed[_from][msg.sender] -= _value;
129         }
130         Transfer(_from, _to, _value);
131         return true;
132     }
133 }
134 
135 contract SafeMath {
136     function safeMul(uint a, uint b)
137         internal
138         pure
139         returns (uint256)
140     {
141         uint c = a * b;
142         assert(a == 0 || c / a == b);
143         return c;
144     }
145 
146     function safeDiv(uint a, uint b)
147         internal
148         pure
149         returns (uint256)
150     {
151         uint c = a / b;
152         return c;
153     }
154 
155     function safeSub(uint a, uint b)
156         internal
157         pure
158         returns (uint256)
159     {
160         assert(b <= a);
161         return a - b;
162     }
163 
164     function safeAdd(uint a, uint b)
165         internal
166         pure
167         returns (uint256)
168     {
169         uint c = a + b;
170         assert(c >= a);
171         return c;
172     }
173 
174     function max64(uint64 a, uint64 b)
175         internal
176         pure
177         returns (uint256)
178     {
179         return a >= b ? a : b;
180     }
181 
182     function min64(uint64 a, uint64 b)
183         internal
184         pure
185         returns (uint256)
186     {
187         return a < b ? a : b;
188     }
189 
190     function max256(uint256 a, uint256 b)
191         internal
192         pure
193         returns (uint256)
194     {
195         return a >= b ? a : b;
196     }
197 
198     function min256(uint256 a, uint256 b)
199         internal
200         pure
201         returns (uint256)
202     {
203         return a < b ? a : b;
204     }
205 }
206 
207 contract EtherToken is UnlimitedAllowanceToken, SafeMath {
208 
209     string constant public name = "Ether Token";
210     string constant public symbol = "WETH";
211     string constant public version = "2.0.0"; // version 1.0.0 deployed on mainnet at 0x2956356cd2a2bf3202f771f50d3d14a367b48070
212     uint8 constant public decimals = 18;
213 
214     /// @dev Fallback to calling deposit when ether is sent directly to contract.
215     function()
216         public
217         payable
218     {
219         deposit();
220     }
221 
222     /// @dev Buys tokens with Ether, exchanging them 1:1.
223     function deposit()
224         public
225         payable
226     {
227         balances[msg.sender] = safeAdd(balances[msg.sender], msg.value);
228         totalSupply = safeAdd(totalSupply, msg.value);
229         Transfer(address(0), msg.sender, msg.value);
230     }
231 
232     /// @dev Sells tokens in exchange for Ether, exchanging them 1:1.
233     /// @param _value Number of tokens to sell.
234     function withdraw(uint _value)
235         public
236     {
237         balances[msg.sender] = safeSub(balances[msg.sender], _value);
238         totalSupply = safeSub(totalSupply, _value);
239         require(msg.sender.send(_value));
240         Transfer(msg.sender, address(0), _value);
241     }
242 }