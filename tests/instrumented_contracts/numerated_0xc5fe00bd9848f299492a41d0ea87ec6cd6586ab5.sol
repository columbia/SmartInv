1 pragma solidity ^0.4.24;
2 //pragma experimental ABIEncoderV2;
3 
4 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 // File: contracts/registry/BancorBuyer.sol
92 
93 //pragma experimental ABIEncoderV2;
94 
95 
96 
97 
98 contract IMultiToken {
99     function changeableTokenCount() external view returns(uint16 count);
100     function tokens(uint256 i) public view returns(ERC20);
101     function weights(address t) public view returns(uint256);
102     function totalSupply() public view returns(uint256);
103     function mint(address _to, uint256 _amount) public;
104 }
105 
106 
107 contract BancorBuyer {
108     using SafeMath for uint256;
109 
110     mapping(address => uint256) public balances;
111     mapping(address => mapping(address => uint256)) public tokenBalances; // [owner][token]
112 
113     function sumWeightOfMultiToken(IMultiToken mtkn) public view returns(uint256 sumWeight) {
114         for (uint i = mtkn.changeableTokenCount(); i > 0; i--) {
115             sumWeight += mtkn.weights(mtkn.tokens(i - 1));
116         }
117     }
118     
119     function allBalances(address _account, address[] _tokens) public view returns(uint256[]) {
120         uint256[] memory tokenValues = new uint256[](_tokens.length);
121         for (uint i = 0; i < _tokens.length; i++) {
122             tokenValues[i] = tokenBalances[_account][_tokens[i]];
123         }
124         return tokenValues;
125     }
126 
127     function deposit(address _beneficiary, address[] _tokens, uint256[] _tokenValues) payable external {
128         if (msg.value > 0) {
129             balances[_beneficiary] = balances[_beneficiary].add(msg.value);
130         }
131 
132         for (uint i = 0; i < _tokens.length; i++) {
133             ERC20 token = ERC20(_tokens[i]);
134             uint256 tokenValue = _tokenValues[i];
135 
136             uint256 balance = token.balanceOf(this);
137             token.transferFrom(msg.sender, this, tokenValue);
138             require(token.balanceOf(this) == balance.add(tokenValue));
139             tokenBalances[_beneficiary][token] = tokenBalances[_beneficiary][token].add(tokenValue);
140         }
141     }
142     
143     function withdrawInternal(address _to, uint256 _value, address[] _tokens, uint256[] _tokenValues) internal {
144         if (_value > 0) {
145             _to.transfer(_value);
146             balances[msg.sender] = balances[msg.sender].sub(_value);
147         }
148 
149         for (uint i = 0; i < _tokens.length; i++) {
150             ERC20 token = ERC20(_tokens[i]);
151             uint256 tokenValue = _tokenValues[i];
152 
153             uint256 tokenBalance = token.balanceOf(this);
154             token.transfer(_to, tokenValue);
155             require(token.balanceOf(this) == tokenBalance.sub(tokenValue));
156             tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(tokenValue);
157         }
158     }
159 
160     function withdraw(address _to, uint256 _value, address[] _tokens, uint256[] _tokenValues) external {
161         withdrawInternal(_to, _value, _tokens, _tokenValues);
162     }
163     
164     function withdrawAll(address _to, address[] _tokens) external {
165         uint256[] memory tokenValues = allBalances(msg.sender, _tokens);
166         withdrawInternal(_to, balances[msg.sender], _tokens, tokenValues);
167     }
168 
169     // function approveAndCall(address _to, uint256 _value, bytes _data, address[] _tokens, uint256[] _tokenValues) payable external {
170     //     uint256[] memory tempBalances = new uint256[](_tokens.length);
171     //     for (uint i = 0; i < _tokens.length; i++) {
172     //         ERC20 token = ERC20(_tokens[i]);
173     //         uint256 tokenValue = _tokenValues[i];
174 
175     //         tempBalances[i] = token.balanceOf(this);
176     //         token.approve(_to, tokenValue);
177     //     }
178 
179     //     require(_to.call.value(_value)(_data));
180     //     balances[msg.sender] = balances[msg.sender].add(msg.value).sub(_value);
181 
182     //     for (i = 0; i < _tokens.length; i++) {
183     //         token = ERC20(_tokens[i]);
184     //         tokenValue = _tokenValues[i];
185 
186     //         uint256 tokenSpent = tempBalances[i].sub(token.balanceOf(this));
187     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(tokenSpent);
188     //         token.approve(_to, 0);
189     //     }
190     // }
191     
192     function buyInternal(
193         ERC20 token,
194         address _exchange,
195         uint256 _value,
196         bytes _data
197     ) 
198         internal
199     {
200         uint256 tokenBalance = token.balanceOf(this);
201         require(_exchange.call.value(_value)(_data));
202         balances[msg.sender] = balances[msg.sender].sub(_value);
203         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token]
204             .add(token.balanceOf(this).sub(tokenBalance));
205     }
206     
207     function mintInternal(
208         IMultiToken _mtkn,
209         uint256[] _notUsedValues
210     ) 
211         internal
212     {
213         uint256 totalSupply = _mtkn.totalSupply();
214         uint256 bestAmount = uint256(-1);
215         uint256 tokensCount = _mtkn.changeableTokenCount();
216         for (uint i = 0; i < tokensCount; i++) {
217             ERC20 token = _mtkn.tokens(i);
218 
219             // Approve XXX to mtkn
220             uint256 thisTokenBalance = tokenBalances[msg.sender][token];
221             uint256 mtknTokenBalance = token.balanceOf(_mtkn);
222             _notUsedValues[i] = token.balanceOf(this);
223             token.approve(_mtkn, thisTokenBalance);
224             
225             uint256 amount = totalSupply.mul(thisTokenBalance).div(mtknTokenBalance);
226             if (amount < bestAmount) {
227                 bestAmount = amount;
228             }
229         }
230 
231         // Mint mtkn
232         _mtkn.mint(msg.sender, bestAmount);
233         
234         for (i = 0; i < tokensCount; i++) {
235             token = _mtkn.tokens(i);
236             token.approve(_mtkn, 0);
237             tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token]
238                 .sub(token.balanceOf(this).sub(_notUsedValues[i]));
239         }
240     }
241     
242     // function buyAndMintInternal(
243     //     IMultiToken _mtkn,
244     //     uint256 _minAmount,
245     //     address[] _tokens,
246     //     address[] _exchanges,
247     //     uint256[] _values,
248     //     bytes[] _datas
249     // ) 
250     //     internal
251     // {
252     //     for (uint i = 0; i < _tokens.length; i++) {
253     //         buyInternal(ERC20(_tokens[i]), _exchanges[i], _values[i], _datas[i]);
254     //     }
255     //     mintInternal(_mtkn, _minAmount, _values);
256     // }
257     
258     ////////////////////////////////////////////////////////////////
259     
260     function buy1(
261         address[] _tokens,
262         address[] _exchanges,
263         uint256[] _values,
264         bytes _data1
265     ) 
266         payable
267         public
268     {
269         balances[msg.sender] = balances[msg.sender].add(msg.value);
270         buyInternal(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
271     }
272 
273     function buy2(
274         address[] _tokens,
275         address[] _exchanges,
276         uint256[] _values,
277         bytes _data1,
278         bytes _data2
279     ) 
280         payable
281         public
282     {
283         balances[msg.sender] = balances[msg.sender].add(msg.value);
284         buyInternal(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
285         buyInternal(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
286     }
287     
288     function buy3(
289         address[] _tokens,
290         address[] _exchanges,
291         uint256[] _values,
292         bytes _data1,
293         bytes _data2,
294         bytes _data3
295     ) 
296         payable
297         public
298     {
299         balances[msg.sender] = balances[msg.sender].add(msg.value);
300         buyInternal(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
301         buyInternal(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
302         buyInternal(ERC20(_tokens[2]), _exchanges[2], _values[2], _data3);
303     }
304     
305     function buy4(
306         address[] _tokens,
307         address[] _exchanges,
308         uint256[] _values,
309         bytes _data1,
310         bytes _data2,
311         bytes _data3,
312         bytes _data4
313     ) 
314         payable
315         public
316     {
317         balances[msg.sender] = balances[msg.sender].add(msg.value);
318         buyInternal(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
319         buyInternal(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
320         buyInternal(ERC20(_tokens[2]), _exchanges[2], _values[2], _data3);
321         buyInternal(ERC20(_tokens[3]), _exchanges[3], _values[3], _data4);
322     }
323     
324     function buy5(
325         address[] _tokens,
326         address[] _exchanges,
327         uint256[] _values,
328         bytes _data1,
329         bytes _data2,
330         bytes _data3,
331         bytes _data4,
332         bytes _data5
333     ) 
334         payable
335         public
336     {
337         balances[msg.sender] = balances[msg.sender].add(msg.value);
338         buyInternal(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
339         buyInternal(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
340         buyInternal(ERC20(_tokens[2]), _exchanges[2], _values[2], _data3);
341         buyInternal(ERC20(_tokens[3]), _exchanges[3], _values[3], _data4);
342         buyInternal(ERC20(_tokens[4]), _exchanges[4], _values[4], _data5);
343     }
344     
345     ////////////////////////////////////////////////////////////////
346     
347     function buy1mint(
348         IMultiToken _mtkn,
349         address[] _tokens,
350         address[] _exchanges,
351         uint256[] _values,
352         bytes _data1
353     ) 
354         payable
355         public
356     {
357         buy1(_tokens, _exchanges, _values, _data1);
358         mintInternal(_mtkn, _values);
359     }
360     
361     function buy2mint(
362         IMultiToken _mtkn,
363         address[] _tokens,
364         address[] _exchanges,
365         uint256[] _values,
366         bytes _data1,
367         bytes _data2
368     ) 
369         payable
370         public
371     {
372         buy2(_tokens, _exchanges, _values, _data1, _data2);
373         mintInternal(_mtkn, _values);
374     }
375     
376     function buy3mint(
377         IMultiToken _mtkn,
378         address[] _tokens,
379         address[] _exchanges,
380         uint256[] _values,
381         bytes _data1,
382         bytes _data2,
383         bytes _data3
384     ) 
385         payable
386         public
387     {
388         buy3(_tokens, _exchanges, _values, _data1, _data2, _data3);
389         mintInternal(_mtkn, _values);
390     }
391     
392     function buy4mint(
393         IMultiToken _mtkn,
394         address[] _tokens,
395         address[] _exchanges,
396         uint256[] _values,
397         bytes _data1,
398         bytes _data2,
399         bytes _data3,
400         bytes _data4
401     ) 
402         payable
403         public
404     {
405         buy4(_tokens, _exchanges, _values, _data1, _data2, _data3, _data4);
406         mintInternal(_mtkn, _values);
407     }
408     
409     function buy5mint(
410         IMultiToken _mtkn,
411         address[] _tokens,
412         address[] _exchanges,
413         uint256[] _values,
414         bytes _data1,
415         bytes _data2,
416         bytes _data3,
417         bytes _data4,
418         bytes _data5
419     ) 
420         payable
421         public
422     {
423         buy5(_tokens, _exchanges, _values, _data1, _data2, _data3, _data4, _data5);
424         mintInternal(_mtkn, _values);
425     }
426     
427     ////////////////////////////////////////////////////////////////
428     
429     function buyOne(
430         address _token,
431         address _exchange,
432         uint256 _value,
433         bytes _data
434     ) 
435         payable
436         public
437     {
438         balances[msg.sender] = balances[msg.sender].add(msg.value);
439         buyInternal(ERC20(_token), _exchange, _value, _data);
440     }
441     
442     // function buyMany(
443     //     address[] _tokens,
444     //     address[] _exchanges,
445     //     uint256[] _values,
446     //     bytes[] _datas
447     // ) 
448     //     payable
449     //     public
450     // {
451     //     balances[msg.sender] = balances[msg.sender].add(msg.value);
452     //     for (uint i = 0; i < _tokens.length; i++) {
453     //         buyInternal(ERC20(_tokens[i]), _exchanges[i], _values[i], _datas[i]);
454     //     }
455     // }
456 
457     // function buy(
458     //     IMultiToken _mtkn, // may be 0
459     //     address[] _exchanges, // may have 0
460     //     uint256[] _values,
461     //     bytes[] _datas
462     // ) 
463     //     payable
464     //     public
465     // {
466     //     require(_mtkn.changeableTokenCount() == _exchanges.length, "");
467 
468     //     balances[msg.sender] = balances[msg.sender].add(msg.value);
469     //     for (uint i = 0; i < _exchanges.length; i++) {
470     //         if (_exchanges[i] == 0) {
471     //             continue;
472     //         }
473 
474     //         ERC20 token = _mtkn.tokens(i);
475             
476     //         // ETH => XXX
477     //         uint256 tokenBalance = token.balanceOf(this);
478     //         require(_exchanges[i].call.value(_values[i])(_datas[i]));
479     //         balances[msg.sender] = balances[msg.sender].sub(_values[i]);
480     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].add(token.balanceOf(this).sub(tokenBalance));
481     //     }
482     // }
483 
484     // function buyAndMint(
485     //     IMultiToken _mtkn, // may be 0
486     //     uint256 _minAmount,
487     //     address[] _exchanges, // may have 0
488     //     uint256[] _values,
489     //     bytes[] _datas
490     // ) 
491     //     payable
492     //     public
493     // {
494     //     buy(_mtkn, _exchanges, _values, _datas);
495 
496     //     uint256 totalSupply = _mtkn.totalSupply();
497     //     uint256 bestAmount = uint256(-1);
498     //     for (uint i = 0; i < _exchanges.length; i++) {
499     //         ERC20 token = _mtkn.tokens(i);
500 
501     //         // Approve XXX to mtkn
502     //         uint256 thisTokenBalance = tokenBalances[msg.sender][token];
503     //         uint256 mtknTokenBalance = token.balanceOf(_mtkn);
504     //         _values[i] = token.balanceOf(this);
505     //         token.approve(_mtkn, thisTokenBalance);
506             
507     //         uint256 amount = totalSupply.mul(thisTokenBalance).div(mtknTokenBalance);
508     //         if (amount < bestAmount) {
509     //             bestAmount = amount;
510     //         }
511     //     }
512 
513     //     require(bestAmount >= _minAmount);
514     //     _mtkn.mint(msg.sender, bestAmount);
515 
516     //     for (i = 0; i < _exchanges.length; i++) {
517     //         token = _mtkn.tokens(i);
518     //         token.approve(_mtkn, 0);
519     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(token.balanceOf(this).sub(_values[i]));
520     //     }
521     // }
522 
523 }