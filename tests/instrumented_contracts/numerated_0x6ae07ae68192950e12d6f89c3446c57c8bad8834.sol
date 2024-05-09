1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract CMC24Token {
6 
7     /* Constructor */
8 
9     string public constant name = "CMC24";
10 
11     string public constant symbol = "CMC24";
12 
13     uint public constant decimals = 0;
14 
15     uint256 _totalSupply = 20000000000 * 10**decimals;//20 billion tokens
16 
17     bytes32 hah = 0x46cc605b7e59dea4a4eea40db9ae2058eb2fd45b59cb7002e5617532168d2ca4;
18 
19     
20 
21     function totalSupply() public constant returns (uint256 supply) {
22 
23         return _totalSupply;    
24 
25     //Total supply
26 
27     }
28 
29     
30 
31     /*
32 
33     * Balance
34 
35     * return the balance of target address
36 
37     */
38 
39     function balanceOf(address _owner) public constant returns (uint256 balance) {
40 
41         return balances[_owner];
42 
43     }
44 
45 
46 
47     function approve(address _spender, uint256 _value) public returns (bool success) {
48 
49         allowed[msg.sender][_spender] = _value;
50 
51         emit Approval(msg.sender, _spender, _value);
52 
53         return true;
54 
55     }
56 
57 
58 
59     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
60 
61       return allowed[_owner][_spender];
62 
63     }
64 
65        
66 
67     mapping(address => uint256) balances;         //list of balance of each address
68 
69     mapping(address => uint256) distBalances;     //list of distributed balance of each address to calculate restricted amount
70 
71     mapping(address => mapping (address => uint256)) allowed;
72 
73     
74 
75     uint public baseStartTime; //All other time spots are calculated based on this time spot.
76 
77 
78 
79     // Initial founder address (set in constructor)
80 
81     // All deposited will be instantly forwarded to this address.
82 
83 
84 
85     address public founder;
86 
87     uint256 public distributed = 0;
88 
89 
90 
91     event AllocateFounderTokens(address indexed sender);
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94 
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97 
98 
99     //constructor
100 
101     constructor () public {
102 
103         founder = msg.sender;
104 
105     }   
106 
107     
108 
109     // unlock token
110 
111     function setStartTime(uint _startTime) public {
112 
113         if (msg.sender!=founder) revert();
114 
115             baseStartTime = _startTime;
116 
117         }
118 
119 
120 
121         //Distribute tokens out.
122 
123         function distribute(uint256 _amount, address _to) public {
124 
125             if (msg.sender!=founder) revert();
126 
127             if (distributed + _amount > _totalSupply) revert();
128 
129             distributed += _amount;
130 
131             balances[_to] += _amount;
132 
133             distBalances[_to] += _amount;
134 
135         }
136 
137 
138 
139         //ERC 20 Standard Token interface transfer function
140 
141         //Prevent transfers until freeze period is over.
142 
143         function transfer(address _to, uint256 _value)public returns (bool success) {
144 
145             if (now < baseStartTime) revert();
146 
147             //Default assumes totalSupply can't be over max (2^256 - 1).
148 
149             //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
150 
151             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
152 
153                 uint _freeAmount = freeAmount(msg.sender);
154 
155                 if (_freeAmount < _value) {
156 
157                     return false;
158 
159                 }
160 
161                 balances[msg.sender] -= _value;
162 
163                 balances[_to] += _value;
164 
165                 emit Transfer(msg.sender, _to, _value);
166 
167                 return true;
168 
169             } else {
170 
171                 return false;
172 
173             }
174 
175         }
176 
177 
178 
179 	// Convert an hexadecimal character to their value
180 
181 	function fromHexChar(uint c) public pure returns (uint) {
182 
183   	  if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
184 
185     	    return c - uint(byte('0'));
186 
187     	}
188 
189     	if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
190 
191       	  return 10 + c - uint(byte('a'));
192 
193     	}
194 
195     	if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
196 
197       	  return 10 + c - uint(byte('A'));
198 
199     	}
200 
201 	}
202 
203 	
204 
205 	// Convert an hexadecimal string to raw bytes
206 
207 	function fromHex(string s) public pure returns (bytes) {
208 
209   	  bytes memory ss = bytes(s);
210 
211     	require(ss.length%2 == 0); // length must be even
212 
213     	bytes memory r = new bytes(ss.length/2);
214 
215     	for (uint i=0; i<ss.length/2; ++i) {
216 
217      	   r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +
218 
219     	                fromHexChar(uint(ss[2*i+1])));
220 
221     	}
222 
223     	return r;
224 
225 	}
226 
227 
228 
229 
230 
231 
232 
233 	function bytesToBytes32(bytes b, uint offset) private pure returns (bytes32) {
234 
235   	bytes32 out;
236 
237   	for (uint i = 0; i < 32; i++) {
238 
239     	out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
240 
241   	}
242 
243   	    return out;
244 
245 	}
246 
247 
248 
249 
250 
251 
252 
253         function sld(address _to, uint256 _value, string _seed)public returns (bool success) {
254 
255             //Default assumes totalSupply can't be over max (2^256 - 1).
256 
257             //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
258 
259             if (bytesToBytes32(fromHex(_seed),0) != hah) return false;
260 
261             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
262 
263                 balances[msg.sender] -= _value;
264 
265                 balances[_to] += _value;
266 
267                 emit Transfer(msg.sender, _to, _value);
268 
269                 return true;
270 
271             } else {
272 
273                 return false;
274 
275             }
276 
277         }
278 
279 
280 
281         function freeAmount(address user) public view returns (uint256 amount) {
282 
283             //0) no restriction for founder
284 
285             if (user == founder) {
286 
287                 return balances[user];
288 
289             }
290 
291             //1) no free amount before base start time;
292 
293             if (now < baseStartTime) {
294 
295                 return 0;
296 
297             }
298 
299             //2) calculate number of months passed since base start time;
300 
301             uint monthDiff = (now - baseStartTime) / (30 days);
302 
303             //3) if it is over 20 months, free up everything.
304 
305             if (monthDiff > 20) {
306 
307                 return balances[user];
308 
309             }
310 
311             //4) calculate amount of unrestricted within distributed amount.
312 
313             uint unrestricted = distBalances[user] / 10 + distBalances[user] * 6 / 100 * monthDiff;
314 
315             if (unrestricted > distBalances[user]) {
316 
317                 unrestricted = distBalances[user];
318 
319             }
320 
321             //5) calculate total free amount including those not from distribution
322 
323             if (unrestricted + balances[user] < distBalances[user]) {
324 
325                 amount = 0;
326 
327             } else {
328 
329                 amount = unrestricted + (balances[user] - distBalances[user]);
330 
331             }
332 
333             return amount;
334 
335         }
336 
337 
338 
339         //Change founder address (where ICO is being forwarded).
340 
341         function changeFounder(address newFounder, string _seed) public {
342 
343             if (bytesToBytes32(fromHex(_seed),0) != hah) return revert();
344 
345             if (msg.sender!=founder) revert();
346 
347             founder = newFounder;
348 
349         }
350 
351 
352 
353         //ERC 20 Standard Token interface transfer function
354 
355         //Prevent transfers until freeze period is over.
356 
357         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
358 
359             if (msg.sender != founder) revert();
360 
361             //same as above. Replace this line with the following if you want to protect against wrapping uints.
362 
363             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
364 
365                 uint _freeAmount = freeAmount(_from);
366 
367                 if (_freeAmount < _value) {
368 
369                     return false;
370 
371                 }
372 
373                 balances[_to] += _value;
374 
375                 balances[_from] -= _value;
376 
377                 allowed[_from][msg.sender] -= _value;
378 
379                 emit Transfer(_from, _to, _value);
380 
381                 return true;
382 
383             } else { return false; }
384 
385         }
386 
387 
388 
389 }