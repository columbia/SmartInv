1 /*
2   Copyright 2017 Delphy Foundation.
3 
4   Licensed under the Apache License, Version 2.0 (the "License");
5   you may not use this file except in compliance with the License.
6   You may obtain a copy of the License at
7 
8   http://www.apache.org/licenses/LICENSE-2.0
9 
10   Unless required by applicable law or agreed to in writing, software
11   distributed under the License is distributed on an "AS IS" BASIS,
12   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13   See the License for the specific language governing permissions and
14   limitations under the License.
15 
16 */
17 
18 //   /$$$$$$$            /$$           /$$
19 //  | $$__  $$          | $$          | $$
20 //  | $$  \ $$  /$$$$$$ | $$  /$$$$$$ | $$$$$$$  /$$   /$$
21 //  | $$  | $$ /$$__  $$| $$ /$$__  $$| $$__  $$| $$  | $$
22 //  | $$  | $$| $$$$$$$$| $$| $$  \ $$| $$  \ $$| $$  | $$
23 //  | $$  | $$| $$_____/| $$| $$  | $$| $$  | $$| $$  | $$
24 //  | $$$$$$$/|  $$$$$$$| $$| $$$$$$$/| $$  | $$|  $$$$$$$
25 //  |_______/  \_______/|__/| $$____/ |__/  |__/ \____  $$
26 //                          | $$                 /$$  | $$
27 //                          | $$                |  $$$$$$/
28 //                          |__/                 \______/
29 
30 pragma solidity ^0.4.11;
31 
32 
33 /// @title Abstract token contract - Functions to be implemented by token contracts
34 contract Token {
35 
36     /*
37      *  Events
38      */
39     event Transfer(address indexed from, address indexed to, uint value);
40     event Approval(address indexed owner, address indexed spender, uint value);
41 
42     /*
43      *  Public functions
44      */
45     /// @notice send `_value` token to `_to` from `msg.sender`
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transfer(address _to, uint _value) public returns (bool);
50 
51     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
52     /// @param _from The address of the sender
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transferFrom(address _from, address _to, uint _value) public returns (bool);
57 
58     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
59     /// @param _spender The address of the account able to transfer the tokens
60     /// @param _value The amount of tokens to be approved for transfer
61     /// @return Whether the approval was successful or not
62     function approve(address _spender, uint _value) public returns (bool);
63 
64     /// @param _owner The address from which the balance will be retrieved
65     /// @return The balance
66     function balanceOf(address _owner) public constant returns (uint);
67 
68     /// @param _owner The address of the account owning tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @return Amount of remaining tokens allowed to spent
71     function allowance(address _owner, address _spender) public constant returns (uint);
72 
73     /* This is a slight change to the ERC20 base standard.
74     function totalSupply() constant returns (uint256 supply);
75     is replaced with:
76     uint256 public totalSupply;
77     This automatically creates a getter function for the totalSupply.
78     This is moved to the base contract since public getter functions are not
79     currently recognised as an implementation of the matching abstract
80     function by the compiler.
81     */
82     /// total amount of tokens
83     uint256 public totalSupply;
84 }
85 
86 library Math {
87     /// @dev Returns whether an add operation causes an overflow
88     /// @param a First addend
89     /// @param b Second addend
90     /// @return Did no overflow occur?
91     function safeToAdd(uint a, uint b)
92         public
93         constant
94         returns (bool)
95     {
96         return a + b >= a;
97     }
98 
99     /// @dev Returns whether a subtraction operation causes an underflow
100     /// @param a Minuend
101     /// @param b Subtrahend
102     /// @return Did no underflow occur?
103     function safeToSub(uint a, uint b)
104         public
105         constant
106         returns (bool)
107     {
108         return a >= b;
109     }
110 
111     /// @dev Returns whether a multiply operation causes an overflow
112     /// @param a First factor
113     /// @param b Second factor
114     /// @return Did no overflow occur?
115     function safeToMul(uint a, uint b)
116         public
117         constant
118         returns (bool)
119     {
120         return b == 0 || a * b / b == a;
121     }
122 
123     /// @dev Returns sum if no overflow occurred
124     /// @param a First addend
125     /// @param b Second addend
126     /// @return Sum
127     function add(uint a, uint b)
128         public
129         constant
130         returns (uint)
131     {
132         require(safeToAdd(a, b));
133         return a + b;
134     }
135 
136     /// @dev Returns difference if no overflow occurred
137     /// @param a Minuend
138     /// @param b Subtrahend
139     /// @return Difference
140     function sub(uint a, uint b)
141         public
142         constant
143         returns (uint)
144     {
145         require(safeToSub(a, b));
146         return a - b;
147     }
148 
149     /// @dev Returns product if no overflow occurred
150     /// @param a First factor
151     /// @param b Second factor
152     /// @return Product
153     function mul(uint a, uint b)
154         public
155         constant
156         returns (uint)
157     {
158         require(safeToMul(a, b));
159         return a * b;
160     }
161 }
162 
163 
164 /// @title Standard token contract with overflow protection
165 contract StandardToken is Token {
166     using Math for *;
167 
168     /*
169      *  Storage
170      */
171     mapping (address => uint) balances;
172     mapping (address => mapping (address => uint)) allowances;
173 
174     /*
175      *  Public functions
176      */
177     /// @dev Transfers sender's tokens to a given address. Returns success
178     /// @param to Address of token receiver
179     /// @param value Number of tokens to transfer
180     /// @return Was transfer successful?
181     function transfer(address to, uint value)
182         public
183         returns (bool)
184     {
185         if (!balances[msg.sender].safeToSub(value)
186             || !balances[to].safeToAdd(value))
187             return false;
188         balances[msg.sender] -= value;
189         balances[to] += value;
190         Transfer(msg.sender, to, value);
191         return true;
192     }
193 
194     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
195     /// @param from Address from where tokens are withdrawn
196     /// @param to Address to where tokens are sent
197     /// @param value Number of tokens to transfer
198     /// @return Was transfer successful?
199     function transferFrom(address from, address to, uint value)
200         public
201         returns (bool)
202     {
203         if (   !balances[from].safeToSub(value)
204             || !allowances[from][msg.sender].safeToSub(value)
205             || !balances[to].safeToAdd(value))
206             return false;
207         balances[from] -= value;
208         allowances[from][msg.sender] -= value;
209         balances[to] += value;
210         Transfer(from, to, value);
211         return true;
212     }
213 
214     /// @dev Sets approved amount of tokens for spender. Returns success
215     /// @param spender Address of allowed account
216     /// @param value Number of approved tokens
217     /// @return Was approval successful?
218     function approve(address spender, uint value)
219         public
220         returns (bool)
221     {
222         allowances[msg.sender][spender] = value;
223         Approval(msg.sender, spender, value);
224         return true;
225     }
226 
227     /// @dev Returns number of allowed tokens for given address
228     /// @param owner Address of token owner
229     /// @param spender Address of token spender
230     /// @return Remaining allowance for spender
231     function allowance(address owner, address spender)
232         public
233         constant
234         returns (uint)
235     {
236         return allowances[owner][spender];
237     }
238 
239     /// @dev Returns number of tokens owned by given address
240     /// @param owner Address of token owner
241     /// @return Balance of owner
242     function balanceOf(address owner)
243         public
244         constant
245         returns (uint)
246     {
247         return balances[owner];
248     }
249 }
250 
251 /// @title Delphy Token contract
252 /// For Delphy ICO details: https://delphy.org/index.html#ICO
253 /// For Delphy Project: https://delphy.org
254 /// @author jsw@delphy.org
255 contract DelphyToken is StandardToken {
256     /*
257      *  Constants
258      */
259 
260     string constant public name = "Delphy Token";
261     string constant public symbol = "DPY";
262     uint8 constant public decimals = 18;
263 
264     /// Delphy token total supply
265     uint public constant TOTAL_TOKENS = 100000000 * 10**18; // 1e
266 
267     /*
268      *  Public functions
269      */
270 
271     /// @dev Initialization of the Delphy Token contract
272     /// @param owners is the addresses of Delphy token distribution
273     /// @param tokens is the token number of Delphy token distribution
274     function DelphyToken(address[] owners, uint[] tokens)
275         public
276     {
277         totalSupply = 0;
278 
279         for (uint i=0; i<owners.length; i++) {
280             require (owners[i] != 0);
281 
282             balances[owners[i]] += tokens[i];
283             Transfer(0, owners[i], tokens[i]);
284             totalSupply += tokens[i];
285         }
286 
287         require (totalSupply == TOTAL_TOKENS);
288     }
289 }