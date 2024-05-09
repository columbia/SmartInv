1 pragma solidity ^0.4.16;
2 
3 /**
4 
5  * Math operations with safety checks
6 
7  */
8 
9 contract BaseSafeMath {
10 
11 
12     /*
13     standard uint256 functions
14      */
15 
16 
17 
18     function add(uint256 a, uint256 b) internal 
19 
20     returns (uint256) {
21 
22         uint256 c = a + b;
23 
24         assert(c >= a);
25 
26         return c;
27 
28     }
29 
30 
31     function sub(uint256 a, uint256 b) internal 
32 
33     returns (uint256) {
34 
35         assert(b <= a);
36 
37         return a - b;
38 
39     }
40 
41 
42     function mul(uint256 a, uint256 b) internal 
43 
44     returns (uint256) {
45 
46         uint256 c = a * b;
47 
48         assert(a == 0 || c / a == b);
49 
50         return c;
51 
52     }
53 
54 
55     function div(uint256 a, uint256 b) internal 
56 
57     returns (uint256) {
58 
59 	    assert( b > 0 );
60 		
61         uint256 c = a / b;
62 
63         return c;
64 
65     }
66 
67 
68     function min(uint256 x, uint256 y) internal 
69 
70     returns (uint256 z) {
71 
72         return x <= y ? x : y;
73 
74     }
75 
76 
77     function max(uint256 x, uint256 y) internal 
78 
79     returns (uint256 z) {
80 
81         return x >= y ? x : y;
82 
83     }
84 
85 
86 
87     /*
88 
89     uint128 functions
90 
91      */
92 
93 
94 
95     function madd(uint128 a, uint128 b) internal 
96 
97     returns (uint128) {
98 
99         uint128 c = a + b;
100 
101         assert(c >= a);
102 
103         return c;
104 
105     }
106 
107 
108     function msub(uint128 a, uint128 b) internal 
109 
110     returns (uint128) {
111 
112         assert(b <= a);
113 
114         return a - b;
115 
116     }
117 
118 
119     function mmul(uint128 a, uint128 b) internal 
120 
121     returns (uint128) {
122 
123         uint128 c = a * b;
124 
125         assert(a == 0 || c / a == b);
126 
127         return c;
128 
129     }
130 
131 
132     function mdiv(uint128 a, uint128 b) internal 
133 
134     returns (uint128) {
135 
136 	    assert( b > 0 );
137 	
138         uint128 c = a / b;
139 
140         return c;
141 
142     }
143 
144 
145     function mmin(uint128 x, uint128 y) internal 
146 
147     returns (uint128 z) {
148 
149         return x <= y ? x : y;
150 
151     }
152 
153 
154     function mmax(uint128 x, uint128 y) internal 
155 
156     returns (uint128 z) {
157 
158         return x >= y ? x : y;
159 
160     }
161 
162 
163 
164     /*
165 
166     uint64 functions
167 
168      */
169 
170 
171 
172     function miadd(uint64 a, uint64 b) internal 
173 
174     returns (uint64) {
175 
176         uint64 c = a + b;
177 
178         assert(c >= a);
179 
180         return c;
181 
182     }
183 
184 
185     function misub(uint64 a, uint64 b) internal 
186 
187     returns (uint64) {
188 
189         assert(b <= a);
190 
191         return a - b;
192 
193     }
194 
195 
196     function mimul(uint64 a, uint64 b) internal 
197 
198     returns (uint64) {
199 
200         uint64 c = a * b;
201 
202         assert(a == 0 || c / a == b);
203 
204         return c;
205 
206     }
207 
208 
209     function midiv(uint64 a, uint64 b) internal 
210 
211     returns (uint64) {
212 
213 	    assert( b > 0 );
214 	
215         uint64 c = a / b;
216 
217         return c;
218 
219     }
220 
221 
222     function mimin(uint64 x, uint64 y) internal 
223 
224     returns (uint64 z) {
225 
226         return x <= y ? x : y;
227 
228     }
229 
230 
231     function mimax(uint64 x, uint64 y) internal 
232 
233     returns (uint64 z) {
234 
235         return x >= y ? x : y;
236 
237     }
238 
239 
240 }
241 
242 
243 // Abstract contract for the full ERC 20 Token standard
244 
245 // https://github.com/ethereum/EIPs/issues/20
246 
247 
248 
249 contract BaseERC20 {
250 
251     // Public variables of the token
252     string public name;
253     string public symbol;
254     uint8 public decimals;
255     // 18 decimals is the strongly suggested default, avoid changing it
256     uint256 public totalSupply;
257 
258     // This creates an array with all balances
259     mapping(address => uint256) public balanceOf;
260     mapping(address => mapping(address => uint256)) public allowed;
261 
262     // This generates a public event on the blockchain that will notify clients
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 	
265     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
266 
267     /**
268      * Internal transfer, only can be called by this contract
269      */
270     function _transfer(address _from, address _to, uint _value) internal;
271 
272     /**
273      * Transfer tokens
274      *
275      * Send `_value` tokens to `_to` from your account
276      *
277      * @param _to The address of the recipient
278      * @param _value the amount to send
279      */
280     function transfer(address _to, uint256 _value) public returns (bool success);
281     /**
282      * Transfer tokens from other address
283      *
284      * Send `_value` tokens to `_to` on behalf of `_from`
285      *
286      * @param _from The address of the sender
287      * @param _to The address of the recipient
288      * @param _value the amount to send
289      */
290     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
291 
292     /**
293      * Set allowance for other address
294      *
295      * Allows `_spender` to spend no more than `_value` tokens on your behalf
296      *
297      * @param _spender The address authorized to spend
298      * @param _value the max amount they can spend
299      */
300     function approve(address _spender, uint256 _value) public returns (bool success);
301 }
302 
303 
304 /**
305 
306  * @title Standard ERC20 token
307 
308  *
309 
310  * @dev Implementation of the basic standard token.
311 
312  * @dev https://github.com/ethereum/EIPs/issues/20
313 
314  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
315 
316  */
317 
318 contract LightCoinToken is BaseERC20, BaseSafeMath {
319 
320     //The solidity created time
321 	address public owner;
322 	address public lockOwner;
323 	uint256 public lockAmount ;
324 	uint256 public startTime ;
325     function LightCoinToken() public {
326 		owner = 0x9a64fE62837d8E2C0Bd0C2a96bbDdEA609Ab2F19;
327 		lockOwner = 0x821C05372425709a68090A17075A855dd20371c7;
328 		startTime = 1515686400;
329         name = "Lightcoin";
330         symbol = "Light";
331         decimals = 8;
332         totalSupply = 21000000000000000000;
333 		balanceOf[owner] = totalSupply * 90 /100 ;
334 		balanceOf[0x47388Cb39BE5E8e3049A1E357B03431F70f8af12]=2000000;
335 		lockAmount = totalSupply / 10 ;
336     }
337 
338 	/// @param _owner The address from which the balance will be retrieved
339     /// @return The balance
340     function getBalanceOf(address _owner) public constant returns (uint256 balance) {
341 		 return balanceOf[_owner];
342 	}
343 	
344     function _transfer(address _from, address _to, uint256 _value) internal {
345         // Prevent transfer to 0x0 address. Use burn() instead
346         require(_to != 0x0);
347 
348         // Save this for an assertion in the future
349         uint previousBalances = add(balanceOf[_from], balanceOf[_to]);
350 		
351         // Subtract from the sender
352         balanceOf[_from] = sub(balanceOf[_from], _value);
353         // Add the same to the recipient
354         balanceOf[_to] = add(balanceOf[_to], _value);
355 		
356 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
357         assert(add(balanceOf[_from], balanceOf[_to]) == previousBalances);
358 		
359         Transfer(_from, _to, _value);
360 
361     }
362 
363     function transfer(address _to, uint256 _value) public returns (bool success)  {
364         _transfer(msg.sender, _to, _value);
365 		return true;
366     }
367 
368     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
369         // Check allowance
370         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
371 		
372         _transfer(_from, _to, _value);
373         return true;
374     }
375 
376     function approve(address _spender, uint256 _value) public
377     returns (bool success) {
378         allowed[msg.sender][_spender] = _value;
379 		
380 	    Approval(msg.sender, _spender, _value);
381         return true;
382     }
383 
384     /// @param _owner The address of the account owning tokens
385     /// @param _spender The address of the account able to transfer the tokens
386     /// @return Amount of remaining tokens allowed to spent
387     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
388         return allowed[_owner][_spender];
389 	}
390 	
391 	function releaseToken() public{
392 	   require(now >= startTime + 2 * 365 * 86400 );	   
393        uint256 i = ((now  - startTime - 2 * 365 * 86400) / (0.5 * 365 * 86400));
394 	   uint256  releasevalue = totalSupply /40 ;
395 	   require(lockAmount > (4 - i - 1) * releasevalue); 	   
396 	   lockAmount -= releasevalue ;
397 	   balanceOf[lockOwner] +=  releasevalue ;
398     }
399 }