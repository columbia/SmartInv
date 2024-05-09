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
268 
269 /**
270  * @title Cat's Token, miaow!!!
271  *
272  * @dev Defines token with name "Cat's Token", symbol "CTS"
273  * and 3 digits after the point
274  */
275 contract Cat is Token("Cat's Token", "CTS", 3), Owned {
276 
277     /**
278      * @dev Emits specified number of tokens. Only owner can emit.
279      * Emitted tokens are credited to owner's account
280      *
281      * @param _value number of emitting tokens
282      * @return true if emission succeeded, false otherwise
283      */
284     function emit(uint256 _value) onlyOwner returns (bool) {
285 
286         // overflow check
287         assert(totalSupply + _value >= totalSupply);
288 
289         // emission
290         totalSupply += _value;
291         balances[owner] += _value;
292 
293         return true;
294     }
295 }
296 
297 /**
298  * @title Drives Cat's Token ICO
299  */
300 contract CatICO {
301 
302     using SafeMath for uint256;
303 
304     /// Starts at 21 Sep 2017 05:00:00 UTC
305     uint256 public start = 1505970000;
306     /// Ends at 21 Nov 2017 05:00:00 UTC
307     uint256 public end = 1511240400;
308 
309     /// Keeps supplied ether
310     address public wallet;
311 
312     /// Cat's Token
313     Cat public cat;
314 
315     struct Stage {
316         /* price in weis for one milliCTS */
317         uint256 price;
318         /* supply cap in milliCTS */
319         uint256 cap;
320     }
321 
322     /* Stage 1: Cat Simulator */
323     Stage simulator = Stage(0.01 ether / 1000, 900000000);
324     /* Stage 2: Cats Online */
325     Stage online = Stage(0.0125 ether / 1000, 2500000000);
326     /* Stage 3: Cat Sequels */
327     Stage sequels = Stage(0.016 ether / 1000, 3750000000);
328 
329     /**
330      * @dev Cat's ICO constructor. It spawns a Cat contract.
331      *
332      * @param _wallet the address of the ICO wallet
333      */
334     function CatICO(address _wallet) {
335         cat = new Cat();
336         wallet = _wallet;
337     }
338 
339     /**
340      * @dev Fallback function, works only if ICO is running
341      */
342     function() payable onlyRunning {
343 
344         var supplied = cat.totalSupply();
345         var tokens = tokenEmission(msg.value, supplied);
346 
347         // revert if nothing to emit
348         require(tokens > 0);
349 
350         // emit tokens
351         bool success = cat.emit(tokens);
352         assert(success);
353 
354         // transfer new tokens to its owner
355         success = cat.transfer(msg.sender, tokens);
356         assert(success);
357 
358         // send value to the wallet
359         wallet.transfer(msg.value);
360     }
361 
362     /**
363      * @dev Calculates number of tokens to emit
364      *
365      * @param _value received ETH
366      * @param _supplied tokens qty supplied at the moment
367      * @return tokens count which is accepted for emission
368      */
369     function tokenEmission(uint256 _value, uint256 _supplied) private returns (uint256) {
370 
371         uint256 emission = 0;
372         uint256 stageTokens;
373 
374         Stage[3] memory stages = [simulator, online, sequels];
375 
376         /* Stage 1 and 2 */
377         for (uint8 i = 0; i < 2; i++) {
378             (stageTokens, _value, _supplied) = stageEmission(_value, _supplied, stages[i]);
379             emission += stageTokens;
380         }
381 
382         /* Stage 3, spend remainder value */
383         emission += _value / stages[2].price;
384 
385         return emission;
386     }
387 
388     /**
389      * @dev Calculates token emission in terms of given stage
390      *
391      * @param _value consuming ETH value
392      * @param _supplied tokens qty supplied within tokens supplied for prev stages
393      * @param _stage the stage
394      *
395      * @return tokens emitted in the stage, returns 0 if stage is passed or not enough _value
396      * @return valueRemainder the value remaining after emission in the stage
397      * @return newSupply total supplied tokens after emission in the stage
398      */
399     function stageEmission(uint256 _value, uint256 _supplied, Stage _stage)
400         private
401         returns (uint256 tokens, uint256 valueRemainder, uint256 newSupply)
402     {
403 
404         /* Check if there is space left in the stage */
405         if (_supplied >= _stage.cap) {
406             return (0, _value, _supplied);
407         }
408 
409         /* Check if there is enough value for at least one milliCTS */
410         if (_value < _stage.price) {
411             return (0, _value, _supplied);
412         }
413 
414         /* Potential emission */
415         var _tokens = _value / _stage.price;
416 
417         /* Adjust to the space left in the stage */
418         var remainder = _stage.cap.sub(_supplied);
419         _tokens = _tokens > remainder ? remainder : _tokens;
420 
421         /* Update value and supply */
422         var _valueRemainder = _value.sub(_tokens * _stage.price);
423         var _newSupply = _supplied + _tokens;
424 
425         return (_tokens, _valueRemainder, _newSupply);
426     }
427 
428     /**
429      * @dev Checks if ICO is still running
430      *
431      * @return true if ICO is running, false otherwise
432      */
433     function isRunning() constant returns (bool) {
434 
435         /* Timeframes */
436         if (now < start) return false;
437         if (now >= end) return false;
438 
439         /* Total cap, held by Stage 3 */
440         if (cat.totalSupply() >= sequels.cap) return false;
441 
442         return true;
443     }
444 
445     /**
446      * @dev Validates ICO timeframes and total cap
447      */
448     modifier onlyRunning() {
449 
450         /* Check timeframes */
451         require(now >= start);
452         require(now < end);
453 
454         /* Check Stage 3 cap */
455         require(cat.totalSupply() < sequels.cap);
456 
457         _;
458     }
459 }