1 pragma solidity ^0.4.12;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 // Abstract contract for the full ERC 20 Token standard
35 // https://github.com/ethereum/EIPs/issues/20
36 
37 contract Token {
38     /* This is a slight change to the ERC20 base standard.
39     function totalSupply() constant returns (uint256 supply);
40     is replaced with:
41     uint256 public totalSupply;
42     This automatically creates a getter function for the totalSupply.
43     This is moved to the base contract since public getter functions are not
44     currently recognised as an implementation of the matching abstract
45     function by the compiler.
46     */
47     /// total amount of tokens
48     uint256 public totalSupply;
49 
50     /// @param _owner The address from which the balance will be retrieved
51     /// @return The balance
52     function balanceOf(address _owner) constant returns (uint256 balance);
53 
54     /// @notice send `_value` token to `_to` from `msg.sender`
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transfer(address _to, uint256 _value) returns (bool success);
59 
60     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
61     /// @param _from The address of the sender
62     /// @param _to The address of the recipient
63     /// @param _value The amount of token to be transferred
64     /// @return Whether the transfer was successful or not
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
66 
67     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @param _value The amount of tokens to be approved for transfer
70     /// @return Whether the approval was successful or not
71     function approve(address _spender, uint256 _value) returns (bool success);
72 
73     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens, after that function `receiveApproval`
74     /// @notice will be called on `_spender` address
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @param _value The amount of tokens to be approved for transfer
77     /// @param _extraData Some data to pass in callback function
78     /// @return Whether the approval was successful or not
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
80 
81     /// @param _owner The address of the account owning tokens
82     /// @param _spender The address of the account able to transfer the tokens
83     /// @return Amount of remaining tokens allowed to spent
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     event Issuance(address indexed _to, uint256 _value);
89     event Burn(address indexed _from, uint256 _value);
90 }
91 
92 /*
93 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
94 .*/
95 
96 
97 contract StandardToken is Token {
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 
102     function transfer(address _to, uint256 _value) returns (bool success) {
103         //Default assumes totalSupply can't be over max (2^256 - 1).
104         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
105         //Replace the if with this one instead.
106         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
107         if (balances[msg.sender] >= _value && _value > 0) {
108             balances[msg.sender] -= _value;
109             balances[_to] += _value;
110             Transfer(msg.sender, _to, _value);
111             return true;
112         } else { return false; }
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
116         //same as above. Replace this line with the following if you want to protect against wrapping uints.
117         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
118         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
119             balances[_from] -= _value;
120             balances[_to] += _value;
121             allowed[_from][msg.sender] -= _value;
122             Transfer(_from, _to, _value);
123             return true;
124         } else { return false; }
125     }
126 
127     function balanceOf(address _owner) constant returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131     function approve(address _spender, uint256 _value) returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140 
141         string memory signature = "receiveApproval(address,uint256,address,bytes)";
142 
143         if (!_spender.call(bytes4(bytes32(sha3(signature))), msg.sender, _value, this, _extraData)) {
144             revert();
145         }
146 
147         return true;
148     }
149 
150     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
151       return allowed[_owner][_spender];
152     }
153 }
154 
155 
156 
157 contract LATToken is StandardToken {
158     using SafeMath for uint256;
159     /* Public variables of the token */
160 
161     address     public founder;
162     address     public minter = 0;
163     address     public exchanger = 0;
164 
165     string      public name             =       "LAToken";
166     uint8       public decimals         =       18;
167     string      public symbol           =       "LAToken";
168     string      public version          =       "0.7.2";
169 
170 
171     modifier onlyFounder() {
172         if (msg.sender != founder) {
173             revert();
174         }
175         _;
176     }
177 
178     modifier onlyMinterAndExchanger() {
179         if (msg.sender != minter && msg.sender != exchanger) {
180             revert();
181         }
182         _;
183     }
184 
185     function transfer(address _to, uint256 _value) returns (bool success) {
186 
187         if (exchanger != 0x0 && _to == exchanger) {
188             assert(ExchangeContract(exchanger).exchange(msg.sender, _value));
189             return true;
190         }
191 
192         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
193 
194             balances[msg.sender] = balances[msg.sender].sub(_value);
195             balances[_to] = balances[_to].add(_value);
196 
197             Transfer(msg.sender, _to, _value);
198             return true;
199 
200         } else {
201             return false;
202         }
203     }
204 
205     function issueTokens(address _for, uint tokenCount)
206         external
207         onlyMinterAndExchanger
208         returns (bool)
209     {
210         if (tokenCount == 0) {
211             return false;
212         }
213 
214         totalSupply = totalSupply.add(tokenCount);
215         balances[_for] = balances[_for].add(tokenCount);
216         Issuance(_for, tokenCount);
217         return true;
218     }
219 
220     function burnTokens(address _for, uint tokenCount)
221         external
222         onlyMinterAndExchanger
223         returns (bool)
224     {
225         if (tokenCount == 0) {
226             return false;
227         }
228 
229         if (totalSupply.sub(tokenCount) > totalSupply) {
230             revert();
231         }
232 
233         if (balances[_for].sub(tokenCount) > balances[_for]) {
234             revert();
235         }
236 
237         totalSupply = totalSupply.sub(tokenCount);
238         balances[_for] = balances[_for].sub(tokenCount);
239         Burn(_for, tokenCount);
240         return true;
241     }
242 
243     function changeMinter(address newAddress)
244         public
245         onlyFounder
246         returns (bool)
247     {
248         minter = newAddress;
249         return true;
250     }
251 
252     function changeFounder(address newAddress)
253         public
254         onlyFounder
255         returns (bool)
256     {
257         founder = newAddress;
258         return true;
259     }
260 
261     function changeExchanger(address newAddress)
262         public
263         onlyFounder
264         returns (bool)
265     {
266         exchanger = newAddress;
267         return true;
268     }
269 
270     function () payable {
271         require(false);
272     }
273 
274     function LATToken() {
275         founder = msg.sender;
276         totalSupply = 0;
277     }
278 }
279 
280 
281 
282 contract ExchangeContract {
283     using SafeMath for uint256;
284 
285 	address public founder;
286 	uint256 public prevCourse;
287 	uint256 public nextCourse;
288 
289 	address public prevTokenAddress;
290 	address public nextTokenAddress;
291 
292 	modifier onlyFounder() {
293         if (msg.sender != founder) {
294             revert();
295         }
296         _;
297     }
298 
299     modifier onlyPreviousToken() {
300     	if (msg.sender != prevTokenAddress) {
301             revert();
302         }
303         _;
304     }
305 
306     // sets new conversion rate
307 	function changeCourse(uint256 _prevCourse, uint256 _nextCourse)
308 		public
309 		onlyFounder
310 	{
311 		prevCourse = _prevCourse;
312 		nextCourse = _nextCourse;
313 	}
314 
315 	function exchange(address _for, uint256 prevTokensAmount)
316 		public
317 		onlyPreviousToken
318 		returns (bool)
319 	{
320 
321 		LATToken prevToken = LATToken(prevTokenAddress);
322      	LATToken nextToken = LATToken(nextTokenAddress);
323 
324 		// check if balance is correct
325 		if (prevToken.balanceOf(_for) >= prevTokensAmount) {
326 			uint256 amount = prevTokensAmount.div(prevCourse);
327 
328 			assert(prevToken.burnTokens(_for, amount.mul(prevCourse))); // remove previous tokens
329 			assert(nextToken.issueTokens(_for, amount.mul(nextCourse))); // give new ones
330 
331 			return true;
332 		} else {
333 			revert();
334 		}
335 	}
336 
337 	function changeFounder(address newAddress)
338         external
339         onlyFounder
340         returns (bool)
341     {
342         founder = newAddress;
343         return true;
344     }
345 
346 	function ExchangeContract(address _prevTokenAddress, address _nextTokenAddress, uint256 _prevCourse, uint256 _nextCourse) {
347 		founder = msg.sender;
348 
349 		prevTokenAddress = _prevTokenAddress;
350 		nextTokenAddress = _nextTokenAddress;
351 
352 		changeCourse(_prevCourse, _nextCourse);
353 	}
354 }
355 
356 
357 
358 contract LATokenMinter {
359     using SafeMath for uint256;
360 
361     LATToken public token; // Token contract
362 
363     address public founder; // Address of founder
364     address public helper;  // Address of helper
365 
366     address public teamPoolInstant; // Address of team pool for instant issuance after token sale end
367     address public teamPoolForFrozenTokens; // Address of team pool for smooth unfroze during 5 years after 5 years from token sale start
368 
369     bool public teamInstantSent = false; // Flag to prevent multiple issuance for team pool after token sale
370 
371     uint public startTime;               // Unix timestamp of start
372     uint public endTime;                 // Unix timestamp of end
373     uint public numberOfDays;            // Number of windows after 0
374     uint public unfrozePerDay;           // Tokens sold in each window
375     uint public alreadyHarvestedTokens;  // Tokens were already harvested and sent to team pool
376 
377     /*
378      *  Modifiers
379      */
380     modifier onlyFounder() {
381         // Only founder is allowed to do this action.
382         if (msg.sender != founder) {
383             revert();
384         }
385         _;
386     }
387 
388     modifier onlyHelper() {
389         // Only helper is allowed to do this action.
390         if (msg.sender != helper) {
391             revert();
392         }
393         _;
394     }
395 
396     // sends 400 millions of tokens to teamPool at the token sale ending (200m for distribution + 200m for company)
397     function fundTeamInstant()
398         external
399         onlyFounder
400         returns (bool)
401     {
402         require(!teamInstantSent);
403 
404         uint baseValue = 400000000;
405         uint totalInstantAmount = baseValue.mul(1000000000000000000); // 400 millions with 18 decimal points
406 
407         require(token.issueTokens(teamPoolInstant, totalInstantAmount));
408 
409         teamInstantSent = true;
410         return true;
411     }
412 
413     function changeTokenAddress(address newAddress)
414         external
415         onlyFounder
416         returns (bool)
417     {
418         token = LATToken(newAddress);
419         return true;
420     }
421 
422     function changeFounder(address newAddress)
423         external
424         onlyFounder
425         returns (bool)
426     {
427         founder = newAddress;
428         return true;
429     }
430 
431     function changeHelper(address newAddress)
432         external
433         onlyFounder
434         returns (bool)
435     {
436         helper = newAddress;
437         return true;
438     }
439 
440     function changeTeamPoolInstant(address newAddress)
441         external
442         onlyFounder
443         returns (bool)
444     {
445         teamPoolInstant = newAddress;
446         return true;
447     }
448 
449     function changeTeamPoolForFrozenTokens(address newAddress)
450         external
451         onlyFounder
452         returns (bool)
453     {
454         teamPoolForFrozenTokens = newAddress;
455         return true;
456     }
457 
458     // method which will be called each day after 5 years to get unfrozen tokens
459     function harvest()
460         external
461         onlyHelper
462         returns (uint)
463     {
464         require(teamPoolForFrozenTokens != 0x0);
465 
466         uint currentTimeDiff = getBlockTimestamp().sub(startTime);
467         uint secondsPerDay = 24 * 3600;
468         uint daysFromStart = currentTimeDiff.div(secondsPerDay);
469         uint currentDay = daysFromStart.add(1);
470 
471         if (getBlockTimestamp() >= endTime) {
472             currentTimeDiff = endTime.sub(startTime).add(1);
473             currentDay = 5 * 365;
474         }
475 
476         uint maxCurrentHarvest = currentDay.mul(unfrozePerDay);
477         uint wasNotHarvested = maxCurrentHarvest.sub(alreadyHarvestedTokens);
478 
479         require(wasNotHarvested > 0);
480         require(token.issueTokens(teamPoolForFrozenTokens, wasNotHarvested));
481         alreadyHarvestedTokens = alreadyHarvestedTokens.add(wasNotHarvested);
482 
483         return wasNotHarvested;
484     }
485 
486     function LATokenMinter(address _LATTokenAddress, address _helperAddress) {
487         founder = msg.sender;
488         helper = _helperAddress;
489         token = LATToken(_LATTokenAddress);
490 
491         numberOfDays = 5 * 365; // 5 years
492         startTime = 1661166000; // 22 august 2022 11:00 GMT+0;
493         endTime = numberOfDays.mul(1 days).add(startTime);
494 
495         uint baseValue = 600000000;
496         uint frozenTokens = baseValue.mul(1000000000000000000); // 600 millions with 18 decimal points
497         alreadyHarvestedTokens = 0;
498 
499         unfrozePerDay = frozenTokens.div(numberOfDays);
500     }
501 
502     function () payable {
503         require(false);
504     }
505 
506     function getBlockTimestamp() returns (uint256) {
507         return block.timestamp;
508     }
509 }