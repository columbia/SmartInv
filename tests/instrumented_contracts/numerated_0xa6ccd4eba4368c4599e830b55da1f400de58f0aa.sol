1 pragma solidity 0.4.19;
2 
3 contract EIP20Factory {
4     mapping(address => address[]) public created;
5 
6     mapping(address => bool) public isEIP20; //verify without having to do a bytecode check.
7 
8     bytes public EIP20ByteCode; // solhint-disable-line var-name-mixedcase
9 
10 
11 
12     function EIP20Factory() public {
13 
14         //upon creation of the factory, deploy a EIP20 (parameters are meaningless) and store the bytecode provably.
15 
16          address verifiedToken = createEIP20(600000000000000000, "HUNDREDMEDICINECASH", 8, "HMCA");
17 
18         EIP20ByteCode = codeAt(verifiedToken);
19 
20     }
21 
22 
23 
24     //verifies if a contract that has been deployed is a Human Standard Token.
25 
26     //NOTE: This is a very expensive function, and should only be used in an eth_call. ~800k gas
27 
28     function verifyEIP20(address _tokenContract) public view returns (bool) {
29 
30         bytes memory fetchedTokenByteCode = codeAt(_tokenContract);
31 
32 
33 
34         if (fetchedTokenByteCode.length != EIP20ByteCode.length) {
35 
36             return false; //clear mismatch
37 
38         }
39 
40 
41 
42       //starting iterating through it if lengths match
43 
44         for (uint i = 0; i < fetchedTokenByteCode.length; i++) {
45 
46             if (fetchedTokenByteCode[i] != EIP20ByteCode[i]) {
47 
48                 return false;
49 
50             }
51 
52         }
53 
54         return true;
55 
56     }
57 
58 
59 
60     function createEIP20(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol)
61 
62         public
63 
64     returns (address) {
65 
66 
67 
68         EIP20 newToken = (new EIP20(_initialAmount, _name, _decimals, _symbol));
69 
70         created[msg.sender].push(address(newToken));
71 
72         isEIP20[address(newToken)] = true;
73 
74         //the factory will own the created tokens. You must transfer them.
75 
76         newToken.transfer(msg.sender, _initialAmount);
77 
78         return address(newToken);
79 
80     }
81 
82 
83 
84     //for now, keeping this internal. Ideally there should also be a live version of this that
85 
86     // any contract can use, lib-style.
87 
88     //retrieves the bytecode at a specific address.
89 
90     function codeAt(address _addr) internal view returns (bytes outputCode) {
91 
92         assembly { // solhint-disable-line no-inline-assembly
93 
94             // retrieve the size of the code, this needs assembly
95 
96             let size := extcodesize(_addr)
97 
98             // allocate output byte array - this could also be done without assembly
99 
100             // by using outputCode = new bytes(size)
101 
102             outputCode := mload(0x40)
103 
104             // new "memory end" including padding
105 
106             mstore(0x40, add(outputCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))
107 
108             // store length in memory
109 
110             mstore(outputCode, size)
111 
112             // actually retrieve the code, this needs assembly
113 
114             extcodecopy(_addr, add(outputCode, 0x20), 0, size)
115 
116         }
117 
118     }
119 
120 }
121 
122 
123 contract EIP20Interface {
124 
125     /* This is a slight change to the ERC20 base standard.
126 
127     function totalSupply() constant returns (uint256 supply);
128 
129     is replaced with:
130 
131     uint256 public totalSupply;
132 
133     This automatically creates a getter function for the totalSupply.
134 
135     This is moved to the base contract since public getter functions are not
136 
137     currently recognised as an implementation of the matching abstract
138 
139     function by the compiler.
140 
141     */
142 
143     /// total amount of tokens
144 
145     uint256 public totalSupply;
146 
147 
148 
149     /// @param _owner The address from which the balance will be retrieved
150 
151     /// @return The balance
152 
153     function balanceOf(address _owner) public view returns (uint256 balance);
154 
155 
156 
157     /// @notice send `_value` token to `_to` from `msg.sender`
158 
159     /// @param _to The address of the recipient
160 
161     /// @param _value The amount of token to be transferred
162 
163     /// @return Whether the transfer was successful or not
164 
165     function transfer(address _to, uint256 _value) public returns (bool success);
166 
167 
168 
169     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
170 
171     /// @param _from The address of the sender
172 
173     /// @param _to The address of the recipient
174 
175     /// @param _value The amount of token to be transferred
176 
177     /// @return Whether the transfer was successful or not
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
180 
181 
182 
183     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
184 
185     /// @param _spender The address of the account able to transfer the tokens
186 
187     /// @param _value The amount of tokens to be approved for transfer
188 
189     /// @return Whether the approval was successful or not
190 
191     function approve(address _spender, uint256 _value) public returns (bool success);
192 
193 
194 
195     /// @param _owner The address of the account owning tokens
196 
197     /// @param _spender The address of the account able to transfer the tokens
198 
199     /// @return Amount of remaining tokens allowed to spent
200 
201     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
202 
203 
204 
205     // solhint-disable-next-line no-simple-event-func-name
206 
207     event Transfer(address indexed _from, address indexed _to, uint256 _value);
208 
209     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
210 
211 }
212 
213 /*
214 
215 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
216 
217 .*/
218 
219 
220 
221 
222 
223 
224 
225 
226 contract EIP20 is EIP20Interface {
227 
228 
229 
230     uint256 constant private MAX_UINT256 = 2**256 - 1;
231 
232     mapping (address => uint256) public balances;
233 
234     mapping (address => mapping (address => uint256)) public allowed;
235 
236 
237     string public name;                   //fancy name: eg Simon Bucks
238 
239     uint8 public decimals;                //How many decimals to show.
240 
241     string public symbol;                 //An identifier: eg SBX
242 
243 
244 
245     function EIP20(
246 
247         uint256 _initialAmount,
248 
249         string _tokenName,
250 
251         uint8 _decimalUnits,
252 
253         string _tokenSymbol
254 
255     ) public {
256 
257         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
258 
259         totalSupply = _initialAmount;                        // Update total supply
260 
261         name = _tokenName;                                   // Set the name for display purposes
262 
263         decimals = _decimalUnits;                            // Amount of decimals for display purposes
264 
265         symbol = _tokenSymbol;                               // Set the symbol for display purposes
266 
267     }
268 
269 
270 
271     function transfer(address _to, uint256 _value) public returns (bool success) {
272 
273         require(balances[msg.sender] >= _value);
274 
275         balances[msg.sender] -= _value;
276 
277         balances[_to] += _value;
278 
279         Transfer(msg.sender, _to, _value); 
280         //solhint-disable-line indent, no-unused-vars
281 
282         return true;
283 
284     }
285 
286 
287 
288     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
289 
290         uint256 allowance = allowed[_from][msg.sender];
291 
292         require(balances[_from] >= _value && allowance >= _value);
293 
294         balances[_to] += _value;
295 
296         balances[_from] -= _value;
297 
298         if (allowance < MAX_UINT256) {
299 
300             allowed[_from][msg.sender] -= _value;
301 
302         }
303 
304          Transfer(_from, _to, _value);
305          //solhint-disable-line indent, no-unused-vars
306 
307         return true;
308 
309     }
310 
311 
312 
313     function balanceOf(address _owner) public view returns (uint256 balance) {
314 
315         return balances[_owner];
316 
317     }
318 
319 
320 
321     function approve(address _spender, uint256 _value) public returns (bool success) {
322 
323         allowed[msg.sender][_spender] = _value;
324 
325          Approval(msg.sender, _spender, _value); 
326         
327         //solhint-disable-line indent, no-unused-vars
328 
329         return true;
330 
331     }
332 
333 
334 
335     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
336 
337         return allowed[_owner][_spender];
338 
339     }
340 
341 }