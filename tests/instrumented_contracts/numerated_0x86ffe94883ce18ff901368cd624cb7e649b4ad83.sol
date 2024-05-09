1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  
7 * @title SafeMath
8  */
9 
10 library SafeMath {
11 
12     
13 
14 /**
15     * Multiplies two numbers, throws on overflow.
16     
17 */
18     
19 function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         
21 if (a == 0) {
22             
23 return 0;
24         
25 }
26         
27 c = a * b;
28         
29 assert(c / a == b);
30         
31 return c;
32     
33 }
34 
35     
36 /**
37     
38 * Integer division of two numbers, truncating the quotient.
39     
40 */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         
43 // assert(b > 0); // Solidity automatically throws when dividing by 0
44         
45 // uint256 c = a / b;
46         
47 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         
49 return a / b;
50     
51 }
52 
53     
54 /**
55     
56 * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57     
58 */
59     
60 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         
62 assert(b <= a);
63         
64 return a - b;
65     
66 }
67 
68     
69 /**
70     
71 * Adds two numbers, throws on overflow.
72     
73 */
74     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
75        
76 c = a + b;
77         
78 assert(c >= a);
79         
80 return c;
81     
82 }
83 
84 }
85 
86 
87 
88 contract AltcoinToken {
89     
90 function balanceOf(address _owner) constant public returns (uint256);
91     
92 function transfer(address _to, uint256 _value) public returns (bool);
93 
94 }
95 
96 
97 
98 contract ERC20Basic {
99     
100 uint256 public totalSupply;
101     
102 function balanceOf(address who) public constant returns (uint256);
103     
104 function transfer(address to, uint256 value) public returns (bool);
105     
106 event Transfer(address indexed from, address indexed to, uint256 value);
107 
108 }
109 
110 
111 
112 contract ERC20 is ERC20Basic {
113     
114 function allowance(address owner, address spender) public constant returns (uint256);
115     
116 function transferFrom(address from, address to, uint256 value) public returns (bool);
117     
118 function approve(address spender, uint256 value) public returns (bool);
119     
120 event Approval(address indexed owner, address indexed spender, uint256 value);
121 
122 }
123 
124 
125 
126 contract PavvyOnline is ERC20 {
127     
128     
129 using SafeMath for uint256;
130     
131 //code
132 constructor() public {
133         
134 owner = 0xa920aAa9717dA781f11Bb218F4618C4ff443c339;
135         
136 contractAddress = this;
137         
138 balances[0x6fd3ba3bdF5615D3F9493855FB8085A22A9798eC] = 2500000000000000;
139         
140 emit Transfer(contractAddress, 0x6fd3ba3bdF5615D3F9493855FB8085A22A9798eC,2500000000000000 );
141         
142 balances[0xbE30288b9a37233fe44d92db8a8F83dc3e1d7b80] = 7500000000000000;
143         
144 emit Transfer(contractAddress, 0xbE30288b9a37233fe44d92db8a8F83dc3e1d7b80,7500000000000000);
145         
146 balances[0xf594f037B8613a6AF10E5F5A8E9Dbec3dD2e8b0E] = 10000000000000000;
147         
148 emit Transfer(contractAddress, 0xf594f037B8613a6AF10E5F5A8E9Dbec3dD2e8b0E, 10000000000000000);
149       
150 }
151 //akhircode
152 
153 address owner = msg.sender;
154 address public contractAddress;
155     
156 
157 mapping (address => uint256) balances;
158     
159 mapping (address => mapping (address => uint256)) allowed;    
160 
161     
162 
163 string public constant name = "Pavvy Online";
164     
165 string public constant symbol = "PVY";
166     
167 uint public constant decimals = 8;
168     
169     
170 
171 uint256 public totalSupply = 50000000000000000;
172     
173 uint256 public totalDistributed = 0;        
174     
175 uint256 public tokensPerEth = 10000000000000;
176     
177 uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
178 
179     
180 
181 event Transfer(address indexed _from, address indexed _to, uint256 _value);
182     
183 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
184     
185     
186 
187 event Distr(address indexed to, uint256 amount);
188     
189 event DistrFinished();
190 
191     
192 
193 event Airdrop(address indexed _owner, uint _amount, uint _balance);
194 
195     
196 
197 event TokensPerEthUpdated(uint _tokensPerEth);
198     
199     
200 
201 event Burn(address indexed burner, uint256 value);
202 
203     
204 bool public distributionFinished = false;
205     
206     
207 modifier canDistr() {
208         
209 require(!distributionFinished);
210        
211  _;
212     }
213     
214     
215 modifier onlyOwner() {
216         
217 require(msg.sender == owner);
218         
219 _;
220     
221 }
222     
223    
224     
225     
226 
227 function transferOwnership(address newOwner) onlyOwner public {
228         
229 if (newOwner != address(0)) {
230             
231 owner = newOwner;
232         
233 }
234     
235 }
236     
237 
238     
239 
240 function finishDistribution() onlyOwner canDistr public returns (bool) {
241         
242 distributionFinished = true;
243         
244 emit DistrFinished();
245         
246 return true;
247     
248 }
249     
250     
251 
252 function distr(address _to, uint256 _amount) canDistr private returns (bool) {
253         
254 totalDistributed = totalDistributed.add(_amount);        
255         
256 balances[_to] = balances[_to].add(_amount);
257         
258 emit Distr(_to, _amount);
259         
260 emit Transfer(address(0), _to, _amount);
261 
262        
263 return true;
264     
265 }
266 
267     
268 
269 function doAirdrop(address _participant, uint _amount) internal {
270 
271         
272 require( _amount > 0 );      
273 
274         
275 require( totalDistributed < totalSupply );
276         
277         
278 balances[_participant] = balances[_participant].add(_amount);
279         
280 totalDistributed = totalDistributed.add(_amount);
281 
282         
283 
284 if (totalDistributed >= totalSupply) {
285             
286 distributionFinished = true;
287         
288 }
289 
290         
291 // log
292         
293 emit Airdrop(_participant, _amount, balances[_participant]);
294         
295 emit Transfer(address(0), _participant, _amount);
296     
297 }
298 
299     
300 function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
301         
302 doAirdrop(_participant, _amount);
303     
304 }
305 
306     
307 
308 function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
309         
310 for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
311     
312 }
313 
314     
315 
316 function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
317         
318 tokensPerEth = _tokensPerEth;
319         
320 emit TokensPerEthUpdated(_tokensPerEth);
321     
322 }
323            
324     
325 
326 function () external payable {
327         
328 getTokens();
329      
330 }
331     
332     
333 
334 function getTokens() payable canDistr  public {
335         
336 uint256 tokens = 0;
337 
338         
339 require( msg.value >= minContribution );
340 
341         
342 require( msg.value > 0 );
343         
344         
345 tokens = tokensPerEth.mul(msg.value) / 1 ether;        
346         
347 address investor = msg.sender;
348         
349         
350 if (tokens > 0) {
351       
352 owner.transfer(msg.value);
353             
354 distr(investor, tokens);
355         
356 }
357 
358         
359 if (totalDistributed >= totalSupply) {
360             
361 distributionFinished = true;
362         
363 }
364     
365 }
366 
367     
368 
369 function balanceOf(address _owner) constant public returns (uint256) {
370         
371 return balances[_owner];
372     
373 }
374 
375  
376     
377 modifier onlyPayloadSize(uint size) {
378         
379 assert(msg.data.length >= size + 4);
380         
381 _;
382     
383 }
384     
385     
386 
387 function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
388 
389         
390 require(_to != address(0));
391         
392 require(_amount <= balances[msg.sender]);
393         
394         
395 balances[msg.sender] = balances[msg.sender].sub(_amount);
396         
397 balances[_to] = balances[_to].add(_amount);
398         
399 emit Transfer(msg.sender, _to, _amount);
400         
401 return true;
402     }
403     
404     
405 function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
406 
407         
408 require(_to != address(0));
409         
410 require(_amount <= balances[_from]);
411         
412 require(_amount <= allowed[_from][msg.sender]);
413         
414         
415 balances[_from] = balances[_from].sub(_amount);
416         
417 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
418         
419 balances[_to] = balances[_to].add(_amount);
420         
421 emit Transfer(_from, _to, _amount);
422         
423 return true;
424     
425 }
426     
427     
428 function approve(address _spender, uint256 _value) public returns (bool success) {
429         
430 // mitigates the ERC20 spend/approval race condition
431         
432 if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
433         
434 allowed[msg.sender][_spender] = _value;
435         
436 emit Approval(msg.sender, _spender, _value);
437         
438 return true;
439     }
440     
441     
442 function allowance(address _owner, address _spender) constant public returns (uint256) {
443        
444  return allowed[_owner][_spender];
445     
446 }
447     
448     
449 function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
450         
451 AltcoinToken t = AltcoinToken(tokenAddress);
452         
453 uint bal = t.balanceOf(who);
454         
455 return bal;
456     
457 }
458     
459     
460 
461     
462     
463 function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
464         
465 AltcoinToken token = AltcoinToken(_tokenContract);
466         
467 uint256 amount = token.balanceOf(address(this));
468         
469 return token.transfer(owner, amount);
470     }
471 }