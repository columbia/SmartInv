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
200         require(
201             // 0xa9059cbb - transfer(address,uint256)
202             !(_data[0] == 0xa9 && _data[1] == 0x05 && _data[2] == 0x9c && _data[3] == 0xbb) &&
203             // 0x095ea7b3 - approve(address,uint256)
204             !(_data[0] == 0x09 && _data[1] == 0x5e && _data[2] == 0xa7 && _data[3] == 0xb3) &&
205             // 0x23b872dd - transferFrom(address,address,uint256)
206             !(_data[0] == 0x23 && _data[1] == 0xb8 && _data[2] == 0x72 && _data[3] == 0xdd),
207             "buyInternal: Do not try to call transfer, approve or transferFrom"
208         );
209         uint256 tokenBalance = token.balanceOf(this);
210         require(_exchange.call.value(_value)(_data));
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token]
213             .add(token.balanceOf(this).sub(tokenBalance));
214     }
215     
216     function mintInternal(
217         IMultiToken _mtkn,
218         uint256[] _notUsedValues
219     ) 
220         internal
221     {
222         uint256 totalSupply = _mtkn.totalSupply();
223         uint256 bestAmount = uint256(-1);
224         uint256 tokensCount = _mtkn.changeableTokenCount();
225         for (uint i = 0; i < tokensCount; i++) {
226             ERC20 token = _mtkn.tokens(i);
227 
228             // Approve XXX to mtkn
229             uint256 thisTokenBalance = tokenBalances[msg.sender][token];
230             uint256 mtknTokenBalance = token.balanceOf(_mtkn);
231             _notUsedValues[i] = token.balanceOf(this);
232             token.approve(_mtkn, thisTokenBalance);
233             
234             uint256 amount = totalSupply.mul(thisTokenBalance).div(mtknTokenBalance);
235             if (amount < bestAmount) {
236                 bestAmount = amount;
237             }
238         }
239 
240         // Mint mtkn
241         _mtkn.mint(msg.sender, bestAmount);
242         
243         for (i = 0; i < tokensCount; i++) {
244             token = _mtkn.tokens(i);
245             token.approve(_mtkn, 0);
246             tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token]
247                 .sub(_notUsedValues[i].sub(token.balanceOf(this)));
248         }
249     }
250     
251     // function buyAndMintInternal(
252     //     IMultiToken _mtkn,
253     //     uint256 _minAmount,
254     //     address[] _tokens,
255     //     address[] _exchanges,
256     //     uint256[] _values,
257     //     bytes[] _datas
258     // ) 
259     //     internal
260     // {
261     //     for (uint i = 0; i < _tokens.length; i++) {
262     //         buyInternal(ERC20(_tokens[i]), _exchanges[i], _values[i], _datas[i]);
263     //     }
264     //     mintInternal(_mtkn, _minAmount, _values);
265     // }
266     
267     ////////////////////////////////////////////////////////////////
268     
269     function buy10(
270         address[] _tokens,
271         address[] _exchanges,
272         uint256[] _values,
273         bytes _data1,
274         bytes _data2,
275         bytes _data3,
276         bytes _data4,
277         bytes _data5,
278         bytes _data6,
279         bytes _data7,
280         bytes _data8,
281         bytes _data9,
282         bytes _data10
283     ) 
284         payable
285         public
286     {
287         balances[msg.sender] = balances[msg.sender].add(msg.value);
288         buyInternal(ERC20(_tokens[0]), _exchanges[0], _values[0], _data1);
289         if (_tokens.length == 1) {
290             return;
291         }
292         buyInternal(ERC20(_tokens[1]), _exchanges[1], _values[1], _data2);
293         if (_tokens.length == 2) {
294             return;
295         }
296         buyInternal(ERC20(_tokens[2]), _exchanges[2], _values[2], _data3);
297         if (_tokens.length == 3) {
298             return;
299         }
300         buyInternal(ERC20(_tokens[3]), _exchanges[3], _values[3], _data4);
301         if (_tokens.length == 4) {
302             return;
303         }
304         buyInternal(ERC20(_tokens[4]), _exchanges[4], _values[4], _data5);
305         if (_tokens.length == 5) {
306             return;
307         }
308         buyInternal(ERC20(_tokens[5]), _exchanges[5], _values[5], _data6);
309         if (_tokens.length == 6) {
310             return;
311         }
312         buyInternal(ERC20(_tokens[6]), _exchanges[6], _values[6], _data7);
313         if (_tokens.length == 7) {
314             return;
315         }
316         buyInternal(ERC20(_tokens[7]), _exchanges[7], _values[7], _data8);
317         if (_tokens.length == 8) {
318             return;
319         }
320         buyInternal(ERC20(_tokens[8]), _exchanges[8], _values[8], _data9);
321         if (_tokens.length == 9) {
322             return;
323         }
324         buyInternal(ERC20(_tokens[9]), _exchanges[9], _values[9], _data10);
325     }
326     
327     ////////////////////////////////////////////////////////////////
328     
329     function buy10mint(
330         IMultiToken _mtkn,
331         address[] _tokens,
332         address[] _exchanges,
333         uint256[] _values,
334         bytes _data1,
335         bytes _data2,
336         bytes _data3,
337         bytes _data4,
338         bytes _data5,
339         bytes _data6,
340         bytes _data7,
341         bytes _data8,
342         bytes _data9,
343         bytes _data10
344     ) 
345         payable
346         public
347     {
348         buy10(_tokens, _exchanges, _values, _data1, _data2, _data3, _data4, _data5, _data6, _data7, _data8, _data9, _data10);
349         mintInternal(_mtkn, _values);
350     }
351     
352     ////////////////////////////////////////////////////////////////
353     
354     function buyOne(
355         address _token,
356         address _exchange,
357         uint256 _value,
358         bytes _data
359     ) 
360         payable
361         public
362     {
363         balances[msg.sender] = balances[msg.sender].add(msg.value);
364         buyInternal(ERC20(_token), _exchange, _value, _data);
365     }
366     
367     // function buyMany(
368     //     address[] _tokens,
369     //     address[] _exchanges,
370     //     uint256[] _values,
371     //     bytes[] _datas
372     // ) 
373     //     payable
374     //     public
375     // {
376     //     balances[msg.sender] = balances[msg.sender].add(msg.value);
377     //     for (uint i = 0; i < _tokens.length; i++) {
378     //         buyInternal(ERC20(_tokens[i]), _exchanges[i], _values[i], _datas[i]);
379     //     }
380     // }
381 
382     // function buy(
383     //     IMultiToken _mtkn, // may be 0
384     //     address[] _exchanges, // may have 0
385     //     uint256[] _values,
386     //     bytes[] _datas
387     // ) 
388     //     payable
389     //     public
390     // {
391     //     require(_mtkn.changeableTokenCount() == _exchanges.length, "");
392 
393     //     balances[msg.sender] = balances[msg.sender].add(msg.value);
394     //     for (uint i = 0; i < _exchanges.length; i++) {
395     //         if (_exchanges[i] == 0) {
396     //             continue;
397     //         }
398 
399     //         ERC20 token = _mtkn.tokens(i);
400             
401     //         // ETH => XXX
402     //         uint256 tokenBalance = token.balanceOf(this);
403     //         require(_exchanges[i].call.value(_values[i])(_datas[i]));
404     //         balances[msg.sender] = balances[msg.sender].sub(_values[i]);
405     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].add(token.balanceOf(this).sub(tokenBalance));
406     //     }
407     // }
408 
409     // function buyAndMint(
410     //     IMultiToken _mtkn, // may be 0
411     //     uint256 _minAmount,
412     //     address[] _exchanges, // may have 0
413     //     uint256[] _values,
414     //     bytes[] _datas
415     // ) 
416     //     payable
417     //     public
418     // {
419     //     buy(_mtkn, _exchanges, _values, _datas);
420 
421     //     uint256 totalSupply = _mtkn.totalSupply();
422     //     uint256 bestAmount = uint256(-1);
423     //     for (uint i = 0; i < _exchanges.length; i++) {
424     //         ERC20 token = _mtkn.tokens(i);
425 
426     //         // Approve XXX to mtkn
427     //         uint256 thisTokenBalance = tokenBalances[msg.sender][token];
428     //         uint256 mtknTokenBalance = token.balanceOf(_mtkn);
429     //         _values[i] = token.balanceOf(this);
430     //         token.approve(_mtkn, thisTokenBalance);
431             
432     //         uint256 amount = totalSupply.mul(thisTokenBalance).div(mtknTokenBalance);
433     //         if (amount < bestAmount) {
434     //             bestAmount = amount;
435     //         }
436     //     }
437 
438     //     require(bestAmount >= _minAmount);
439     //     _mtkn.mint(msg.sender, bestAmount);
440 
441     //     for (i = 0; i < _exchanges.length; i++) {
442     //         token = _mtkn.tokens(i);
443     //         token.approve(_mtkn, 0);
444     //         tokenBalances[msg.sender][token] = tokenBalances[msg.sender][token].sub(token.balanceOf(this).sub(_values[i]));
445     //     }
446     // }
447 
448 }