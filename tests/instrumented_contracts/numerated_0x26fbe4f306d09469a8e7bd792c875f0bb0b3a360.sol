1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Provides overflow safe arithmetic
5  */
6 library SafeMath {
7 
8     /**
9      * @dev Does subtract in safe manner
10      *
11      * @return result of (_subtrahend - _subtractor) or 0 if overflow occurs
12      */
13     function sub(uint256 _subtrahend, uint256 _subtractor) internal returns (uint256) {
14 
15         // overflow check
16         if (_subtractor > _subtrahend)
17             return 0;
18 
19         return _subtrahend - _subtractor;
20     }
21 }
22 
23 /**
24  * @title Contract owner definition
25  */
26 contract Owned {
27 
28     /* Owner's address */
29     address owner;
30 
31     /**
32      * @dev Constructor, records msg.sender as contract owner
33      */
34     function Owned() {
35         owner = msg.sender;
36     }
37 
38     /**
39      * @dev Validates if msg.sender is an owner
40      */
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 }
46 
47 /** 
48  * @title Standard token interface (ERC 20)
49  * 
50  * https://github.com/ethereum/EIPs/issues/20
51  */
52 interface ERC20 {
53     
54 // Functions:
55     
56     /**
57      * @return total amount of tokens
58      */
59     function totalSupply() constant returns (uint256);
60 
61     /** 
62      * @param _owner The address from which the balance will be retrieved
63      * @return The balance
64      */
65     function balanceOf(address _owner) constant returns (uint256);
66 
67     /** 
68      * @notice send `_value` token to `_to` from `msg.sender`
69      * 
70      * @param _to The address of the recipient
71      * @param _value The amount of token to be transferred
72      * @return Whether the transfer was successful or not
73      */
74     function transfer(address _to, uint256 _value) returns (bool);
75 
76     /** 
77      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
78      * 
79      * @param _from The address of the sender
80      * @param _to The address of the recipient
81      * @param _value The amount of token to be transferred
82      * @return Whether the transfer was successful or not
83      */
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
85 
86     /** 
87      * @notice `msg.sender` approves `_addr` to spend `_value` tokens
88      * 
89      * @param _spender The address of the account able to transfer the tokens
90      * @param _value The amount of wei to be approved for transfer
91      * @return Whether the approval was successful or not
92      */
93     function approve(address _spender, uint256 _value) returns (bool);
94 
95     /** 
96      * @param _owner The address of the account owning tokens
97      * @param _spender The address of the account able to transfer the tokens
98      * @return Amount of remaining tokens allowed to spent
99      */
100     function allowance(address _owner, address _spender) constant returns (uint256);
101 
102 // Events:
103 
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 }
107 
108 
109 /**
110  * @title Implementation of ERC 20 interface with holders list
111  */
112 contract Token is ERC20 {
113 
114     /// Name of the token
115     string public name;
116     /// Token symbol
117     string public symbol;
118 
119     /// Fixed point description
120     uint8 public decimals;
121 
122     /// Qty of supplied tokens
123     uint256 public totalSupply;
124 
125     /// Token holders list
126     address[] public holders;
127     /* address => index in array of hodlers, index starts from 1 */
128     mapping(address => uint256) index;
129 
130     /* Token holders map */
131     mapping(address => uint256) balances;
132     /* Token transfer approvals */
133     mapping(address => mapping(address => uint256)) allowances;
134 
135     /**
136      * @dev Constructs Token with given `_name`, `_symbol` and `_decimals`
137      */
138     function Token(string _name, string _symbol, uint8 _decimals) {
139         name = _name;
140         symbol = _symbol;
141         decimals = _decimals;
142     }
143 
144     /**
145      * @dev Get balance of given address
146      *
147      * @param _owner The address to request balance from
148      * @return The balance
149      */
150     function balanceOf(address _owner) constant returns (uint256) {
151         return balances[_owner];
152     }
153 
154     /**
155      * @dev Transfer own tokens to given address
156      * @notice send `_value` token to `_to` from `msg.sender`
157      *
158      * @param _to The address of the recipient
159      * @param _value The amount of token to be transferred
160      * @return Whether the transfer was successful or not
161      */
162     function transfer(address _to, uint256 _value) returns (bool) {
163 
164         // balance check
165         if (balances[msg.sender] >= _value) {
166 
167             // transfer
168             balances[msg.sender] -= _value;
169             balances[_to] += _value;
170 
171             // push new holder if _value > 0
172             if (_value > 0 && index[_to] == 0) {
173                 index[_to] = holders.push(_to);
174             }
175 
176             Transfer(msg.sender, _to, _value);
177 
178             return true;
179         }
180 
181         return false;
182     }
183 
184     /**
185      * @dev Transfer tokens between addresses using approvals
186      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
187      *
188      * @param _from The address of the sender
189      * @param _to The address of the recipient
190      * @param _value The amount of token to be transferred
191      * @return Whether the transfer was successful or not
192      */
193     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
194 
195         // approved balance check
196         if (allowances[_from][msg.sender] >= _value &&
197             balances[_from] >= _value ) {
198 
199             // hit approved amount
200             allowances[_from][msg.sender] -= _value;
201 
202             // transfer
203             balances[_from] -= _value;
204             balances[_to] += _value;
205 
206             // push new holder if _value > 0
207             if (_value > 0 && index[_to] == 0) {
208                 index[_to] = holders.push(_to);
209             }
210 
211             Transfer(_from, _to, _value);
212 
213             return true;
214         }
215 
216         return false;
217     }
218 
219     /**
220      * @dev Approve token transfer with specific amount
221      * @notice `msg.sender` approves `_addr` to spend `_value` tokens
222      *
223      * @param _spender The address of the account able to transfer the tokens
224      * @param _value The amount of wei to be approved for transfer
225      * @return Whether the approval was successful or not
226      */
227     function approve(address _spender, uint256 _value) returns (bool) {
228         allowances[msg.sender][_spender] = _value;
229         Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 
233     /**
234      * @dev Get amount of tokens approved for transfer
235      *
236      * @param _owner The address of the account owning tokens
237      * @param _spender The address of the account able to transfer the tokens
238      * @return Amount of remaining tokens allowed to spent
239      */
240     function allowance(address _owner, address _spender) constant returns (uint256) {
241         return allowances[_owner][_spender];
242     }
243 
244     /**
245      * @dev Convenient way to reset approval for given address, not a part of ERC20
246      *
247      * @param _spender the address
248      */
249     function unapprove(address _spender) {
250         allowances[msg.sender][_spender] = 0;
251     }
252 
253     /**
254      * @return total amount of tokens
255      */
256     function totalSupply() constant returns (uint256) {
257         return totalSupply;
258     }
259 
260     /**
261      * @dev Returns count of token holders
262      */
263     function holderCount() constant returns (uint256) {
264         return holders.length;
265     }
266 }
267 
268 /**
269  * @title Cat's Token, miaow!!!
270  *
271  * @dev Defines token with name "Cat's Token", symbol "CTS"
272  * and 3 digits after the point
273  */
274 contract Cat is Token("Test's Token", "TTS", 3), Owned {
275 
276     /**
277      * @dev Emits specified number of tokens. Only owner can emit.
278      * Emitted tokens are credited to owner's account
279      *
280      * @param _value number of emitting tokens
281      * @return true if emission succeeded, false otherwise
282      */
283     function emit(uint256 _value) onlyOwner returns (bool) {
284 
285         // overflow check
286         assert(totalSupply + _value >= totalSupply);
287 
288         // emission
289         totalSupply += _value;
290         balances[owner] += _value;
291 
292         return true;
293     }
294 }
295 
296 
297 /**
298  * @title Drives Cat's Token ICO
299  */
300 contract CatICO {
301 
302     using SafeMath for uint256;
303 
304     /// Starts at 21 Sep 2017 05:00:00 UTC
305     // uint256 public start = 1505970000;
306     uint256 public start = 1503970000;
307     /// Ends at 21 Nov 2017 05:00:00 UTC
308     uint256 public end = 1511240400;
309 
310     /// Keeps supplied ether
311     address public wallet;
312 
313     /// Cat's Token
314     Cat public cat;
315 
316     struct Stage {
317         /* price in weis for one milliCTS */
318         uint256 price;
319         /* supply cap in milliCTS */
320         uint256 cap;
321     }
322 
323     /* Stage 1: Cat Simulator */
324     Stage simulator = Stage(0.01 ether / 1000, 900000000);
325     /* Stage 2: Cats Online */
326     Stage online = Stage(0.0125 ether / 1000, 2500000000);
327     /* Stage 3: Cat Sequels */
328     Stage sequels = Stage(0.016 ether / 1000, 3750000000);
329 
330     /**
331      * @dev Cat's ICO constructor. It spawns a Cat contract.
332      *
333      * @param _wallet the address of the ICO wallet
334      */
335     function CatICO(address _wallet) {
336         cat = new Cat();
337         wallet = _wallet;
338     }
339 
340     /**
341      * @dev Fallback function, works only if ICO is running
342      */
343     function() payable onlyRunning {
344 
345         var supplied = cat.totalSupply();
346         var tokens = tokenEmission(msg.value, supplied);
347 
348         // revert if nothing to emit
349         require(tokens > 0);
350 
351         // emit tokens
352         bool success = cat.emit(tokens);
353         assert(success);
354 
355         // transfer new tokens to its owner
356         success = cat.transfer(msg.sender, tokens);
357         assert(success);
358 
359         // send value to the wallet
360         wallet.transfer(msg.value);
361     }
362 
363     /**
364      * @dev Calculates number of tokens to emit
365      *
366      * @param _value received ETH
367      * @param _supplied tokens qty supplied at the moment
368      * @return tokens count which is accepted for emission
369      */
370     function tokenEmission(uint256 _value, uint256 _supplied) private returns (uint256) {
371 
372         uint256 emission = 0;
373         uint256 stageTokens;
374 
375         Stage[3] memory stages = [simulator, online, sequels];
376 
377         /* Stage 1 and 2 */
378         for (uint8 i = 0; i < 2; i++) {
379             (stageTokens, _value, _supplied) = stageEmission(_value, _supplied, stages[i]);
380             emission += stageTokens;
381         }
382 
383         /* Stage 3, spend remainder value */
384         emission += _value / stages[2].price;
385 
386         return emission;
387     }
388 
389     /**
390      * @dev Calculates token emission in terms of given stage
391      *
392      * @param _value consuming ETH value
393      * @param _supplied tokens qty supplied within tokens supplied for prev stages
394      * @param _stage the stage
395      *
396      * @return tokens emitted in the stage, returns 0 if stage is passed or not enough _value
397      * @return valueRemainder the value remaining after emission in the stage
398      * @return newSupply total supplied tokens after emission in the stage
399      */
400     function stageEmission(uint256 _value, uint256 _supplied, Stage _stage)
401         private
402         returns (uint256 tokens, uint256 valueRemainder, uint256 newSupply)
403     {
404 
405         /* Check if there is space left in the stage */
406         if (_supplied >= _stage.cap) {
407             return (0, _value, _supplied);
408         }
409 
410         /* Check if there is enough value for at least one milliCTS */
411         if (_value < _stage.price) {
412             return (0, _value, _supplied);
413         }
414 
415         /* Potential emission */
416         var _tokens = _value / _stage.price;
417 
418         /* Adjust to the space left in the stage */
419         var remainder = _stage.cap.sub(_supplied);
420         _tokens = _tokens > remainder ? remainder : _tokens;
421 
422         /* Update value and supply */
423         var _valueRemainder = _value.sub(_tokens * _stage.price);
424         var _newSupply = _supplied + _tokens;
425 
426         return (_tokens, _valueRemainder, _newSupply);
427     }
428 
429     /**
430      * @dev Checks if ICO is still running
431      *
432      * @return true if ICO is running, false otherwise
433      */
434     function isRunning() constant returns (bool) {
435 
436         /* Timeframes */
437         if (now < start) return false;
438         if (now >= end) return false;
439 
440         /* Total cap, held by Stage 3 */
441         if (cat.totalSupply() >= sequels.cap) return false;
442 
443         return true;
444     }
445 
446     /**
447      * @dev Validates ICO timeframes and total cap
448      */
449     modifier onlyRunning() {
450 
451         /* Check timeframes */
452         require(now >= start);
453         require(now < end);
454 
455         /* Check Stage 3 cap */
456         require(cat.totalSupply() < sequels.cap);
457 
458         _;
459     }
460 }