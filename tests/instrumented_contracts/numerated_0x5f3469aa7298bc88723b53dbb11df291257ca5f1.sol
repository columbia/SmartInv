1 /* Token - simple token for PreICO and ICO
2    Copyright (C) 2017  Sergey Sherkunov <leinlawun@leinlawun.org>
3 
4    This file is part of Token.
5 
6    Token is free software: you can redistribute it and/or modify
7    it under the terms of the GNU General Public License as published by
8    the Free Software Foundation, either version 3 of the License, or
9    (at your option) any later version.
10 
11    This program is distributed in the hope that it will be useful,
12    but WITHOUT ANY WARRANTY; without even the implied warranty of
13    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14    GNU General Public License for more details.
15 
16    You should have received a copy of the GNU General Public License
17    along with this program.  If not, see <https://www.gnu.org/licenses/>.  */
18 
19 pragma solidity ^0.4.18;
20 
21 library SafeMath {
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24 
25     assert (c >= a);
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     assert(b <= a);
30 
31     c = a - b;
32   }
33 
34   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
35     c = a * b;
36 
37     assert (c / a == b);
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a / b;
42   }
43 }
44 
45 contract ERC20MintableToken {
46   using SafeMath for uint256;
47 
48   address public owner;
49 
50   Minter public minter;
51 
52   string constant public name = "PayAll";
53 
54   string constant public symbol = "PLL";
55 
56   uint8 constant public decimals = 0;
57 
58   uint256 public totalSupply;
59 
60   mapping (address => uint256) public balanceOf;
61 
62   mapping (address => mapping (address => uint256)) public allowance;
63 
64   event Transfer(address indexed _oldTokensHolder,
65                  address indexed _newTokensHolder, uint256 _tokensNumber);
66 
67   //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68   event Transfer(address indexed _tokensSpender,
69                  address indexed _oldTokensHolder,
70                  address indexed _newTokensHolder, uint256 _tokensNumber);
71 
72   event Approval(address indexed _tokensHolder, address indexed _tokensSpender,
73                  uint256 _newTokensNumber);
74 
75   //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76   event Approval(address indexed _tokensHolder, address indexed _tokensSpender,
77                  uint256 _oldTokensNumber, uint256 _newTokensNumber);
78 
79   modifier onlyOwner {
80     require (owner == msg.sender);
81 
82     _;
83   }
84 
85   modifier onlyMinter {
86     require (minter == msg.sender);
87 
88     _;
89   }
90 
91   //https://vessenes.com/the-erc20-short-address-attack-explained
92   //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
93   //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
94   modifier checkPayloadSize(uint256 size) {
95      require (msg.data.length == size + 4);
96 
97      _;
98   }
99 
100   function setOwner(address _owner) public onlyOwner {
101     uint256 _allowance = allowance[this][owner];
102 
103     _approve(this, owner, 0);
104 
105     owner = _owner;
106 
107     _approve(this, owner, _allowance);
108   }
109 
110   function setMinter(Minter _minter) public onlyOwner {
111     uint256 _allowance = allowance[this][minter];
112 
113     _approve(this, minter, 0);
114 
115     minter = _minter;
116 
117     _approve(this, minter, _allowance);
118   }
119 
120   function ERC20MintableToken(Minter _minter) public {
121     owner = tx.origin;
122     minter = _minter;
123   }
124 
125   function _transfer(address _oldTokensHolder, address _newTokensHolder,
126                      uint256 _tokensNumber) private {
127     balanceOf[_oldTokensHolder] =
128       balanceOf[_oldTokensHolder].sub(_tokensNumber);
129 
130     balanceOf[_newTokensHolder] =
131       balanceOf[_newTokensHolder].add(_tokensNumber);
132 
133     Transfer(_oldTokensHolder, _newTokensHolder, _tokensNumber);
134   }
135 
136   //https://vessenes.com/the-erc20-short-address-attack-explained
137   //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
138   //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
139   function transfer(address _newTokensHolder, uint256 _tokensNumber) public
140                    checkPayloadSize(2 * 32) returns (bool) {
141     _transfer(msg.sender, _newTokensHolder, _tokensNumber);
142 
143     return true;
144   }
145 
146   //https://vessenes.com/the-erc20-short-address-attack-explained
147   //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
148   //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
149   //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150   function transferFrom(address _oldTokensHolder, address _newTokensHolder,
151                         uint256 _tokensNumber) public checkPayloadSize(3 * 32)
152                        returns (bool) {
153     allowance[_oldTokensHolder][msg.sender] =
154       allowance[_oldTokensHolder][msg.sender].sub(_tokensNumber);
155 
156     _transfer(_oldTokensHolder, _newTokensHolder, _tokensNumber);
157 
158     Transfer(msg.sender, _oldTokensHolder, _newTokensHolder, _tokensNumber);
159 
160     return true;
161   }
162 
163   function _approve(address _tokensHolder, address _tokensSpender,
164                     uint256 _newTokensNumber) private {
165     allowance[_tokensHolder][_tokensSpender] = _newTokensNumber;
166 
167     Approval(msg.sender, _tokensSpender, _newTokensNumber);
168   }
169 
170   //https://vessenes.com/the-erc20-short-address-attack-explained
171   //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
172   //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
173   //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174   function approve(address _tokensSpender, uint256 _newTokensNumber) public
175                   checkPayloadSize(2 * 32) returns (bool) {
176     require (allowance[msg.sender][_tokensSpender] == 0 ||
177              _newTokensNumber == 0);
178 
179     _approve(msg.sender, _tokensSpender, _newTokensNumber);
180 
181     return true;
182   }
183 
184   //https://vessenes.com/the-erc20-short-address-attack-explained
185   //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
186   //https://ericrafaloff.com/analyzing-the-erc20-short-address-attack
187   //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188   function approve(address _tokensSpender, uint256 _oldTokensNumber,
189                    uint256 _newTokensNumber) public checkPayloadSize(3 * 32)
190                   returns (bool) {
191     require (allowance[msg.sender][_tokensSpender] == _oldTokensNumber);
192 
193     _approve(msg.sender, _tokensSpender, _newTokensNumber);
194 
195     Approval(msg.sender, _tokensSpender, _oldTokensNumber, _newTokensNumber);
196 
197     return true;
198   }
199 
200   function () public {
201     revert();
202   }
203 
204   function mint(uint256 _tokensNumber) public onlyMinter {
205     totalSupply = totalSupply.add(_tokensNumber);
206 
207     balanceOf[this] = balanceOf[this].add(_tokensNumber);
208 
209     uint256 _allowance = allowance[this][msg.sender].add(_tokensNumber);
210 
211     _approve(this, minter, _allowance);
212 
213     _approve(this, owner, _allowance);
214   }
215 
216   function burnUndistributed() public onlyMinter {
217     _approve(this, minter, 0);
218 
219     _approve(this, owner, 0);
220 
221     totalSupply = totalSupply.sub(balanceOf[this]);
222 
223     balanceOf[this] = 0;
224   }
225 }
226 
227 contract Minter {
228   using SafeMath for uint256;
229 
230   enum MinterState {
231     PreICOWait,
232     PreICOStarted,
233     ICOWait,
234     ICOStarted,
235     Over
236   }
237 
238   struct Tokensale {
239     uint256 startTime;
240     uint256 endTime;
241     uint256 tokensMinimumNumberForBuy;
242     uint256 tokensCost;
243     uint256 tokensNumberForMint;
244     bool tokensMinted;
245     uint256 tokensStepOneBountyTime;
246     uint256 tokensStepTwoBountyTime;
247     uint256 tokensStepThreeBountyTime;
248     uint256 tokensStepFourBountyTime;
249     uint8 tokensStepOneBounty;
250     uint8 tokensStepTwoBounty;
251     uint8 tokensStepThreeBounty;
252     uint8 tokensStepFourBounty;
253   }
254 
255   address public owner;
256 
257   ERC20MintableToken public token;
258 
259   Tokensale public PreICO =
260     Tokensale(1511193600, 1513785600, 150, 340000000000000 wei, 10000000, false,
261               1 weeks, 2 weeks, 3 weeks, 4 weeks + 2 days, 25, 15, 10, 5);
262 
263   Tokensale public ICO =
264     Tokensale(1526828400, 1529506800, 150, 340000000000000 wei, 290000000,
265               false, 1 weeks, 2 weeks, 3 weeks, 4 weeks + 3 days, 20, 10, 5, 0);
266 
267   bool public paused = false;
268 
269   modifier onlyOwner {
270     require (owner == msg.sender);
271 
272     _;
273   }
274 
275   modifier onlyDuringTokensale {
276     MinterState _minterState_ = _minterState();
277 
278     require (_minterState_ == MinterState.PreICOStarted ||
279              _minterState_ == MinterState.ICOStarted);
280 
281     _;
282   }
283 
284   modifier onlyAfterTokensaleOver {
285     MinterState _minterState_ = _minterState();
286 
287     require (_minterState_ == MinterState.Over);
288 
289     _;
290   }
291 
292   modifier onlyNotPaused {
293     require (!paused);
294 
295     _;
296   }
297 
298   modifier checkLimitsToBuyTokens {
299     MinterState _minterState_ = _minterState();
300 
301     require (_minterState_ == MinterState.PreICOStarted &&
302              PreICO.tokensMinimumNumberForBuy <= msg.value / PreICO.tokensCost ||
303              _minterState_ == MinterState.ICOStarted &&
304              ICO.tokensMinimumNumberForBuy <= msg.value / ICO.tokensCost);
305 
306     _;
307   }
308 
309   function setOwner(address _owner) public onlyOwner {
310     owner = _owner;
311   }
312 
313   function setPaused(bool _paused) public onlyOwner {
314     paused = _paused;
315   }
316 
317   function Minter() public {
318     owner = msg.sender;
319     token = new ERC20MintableToken(this);
320   }
321 
322   function _minterState() private constant returns (MinterState) {
323     if (PreICO.startTime > now) {
324       return MinterState.PreICOWait;
325     } else if (PreICO.endTime > now) {
326       return MinterState.PreICOStarted;
327     } else if (ICO.startTime > now) {
328       return MinterState.ICOWait;
329     } else if (ICO.endTime > now) {
330       return MinterState.ICOStarted;
331     } else {
332       return MinterState.Over;
333     }
334   }
335 
336   function _tokensaleCountTokensNumber(Tokensale _tokensale, uint256 _timestamp,
337                                        uint256 _wei, uint256 _totalTokensNumber,
338                                        uint256 _totalTokensNumberAllowance)
339                                       private pure
340                                       returns (uint256, uint256) {
341     uint256 _tokensNumber = _wei.div(_tokensale.tokensCost);
342 
343     require (_tokensNumber >= _tokensale.tokensMinimumNumberForBuy);
344 
345     uint256 _aviableTokensNumber =
346       _totalTokensNumber <= _totalTokensNumberAllowance ?
347         _totalTokensNumber : _totalTokensNumberAllowance;
348 
349     uint256 _restWei = 0;
350 
351     if (_tokensNumber >= _aviableTokensNumber) {
352       uint256 _restTokensNumber = _tokensNumber.sub(_aviableTokensNumber);
353 
354       _restWei = _restTokensNumber.mul(_tokensale.tokensCost);
355 
356       _tokensNumber = _aviableTokensNumber;
357     } else {
358       uint256 _timePassed = _timestamp.sub(_tokensale.startTime);
359 
360       uint256 _tokensNumberBounty = 0;
361 
362       if (_timePassed < _tokensale.tokensStepOneBountyTime) {
363         _tokensNumberBounty = _tokensNumber.mul(_tokensale.tokensStepOneBounty)
364                                            .div(100);
365       } else if (_timePassed < _tokensale.tokensStepTwoBountyTime) {
366         _tokensNumberBounty = _tokensNumber.mul(_tokensale.tokensStepTwoBounty)
367                                            .div(100);
368       } else if (_timePassed < _tokensale.tokensStepThreeBountyTime) {
369         _tokensNumberBounty =
370           _tokensNumber.mul(_tokensale.tokensStepThreeBounty).div(100);
371       } else if (_timePassed < _tokensale.tokensStepFourBountyTime) {
372         _tokensNumberBounty = _tokensNumber.mul(_tokensale.tokensStepFourBounty)
373                                            .div(100);
374       }
375 
376       _tokensNumber = _tokensNumber.add(_tokensNumberBounty);
377 
378       if (_tokensNumber > _aviableTokensNumber) {
379         _tokensNumber = _aviableTokensNumber;
380       }
381     }
382 
383     return (_tokensNumber, _restWei);
384   }
385 
386   function _tokensaleStart(Tokensale storage _tokensale) private {
387     if (!_tokensale.tokensMinted) {
388       token.mint(_tokensale.tokensNumberForMint);
389 
390       _tokensale.tokensMinted = true;
391     }
392 
393     uint256 _totalTokensNumber = token.balanceOf(token);
394 
395     uint256 _totalTokensNumberAllowance = token.allowance(token, this);
396 
397     var (_tokensNumber, _restWei) =
398       _tokensaleCountTokensNumber(_tokensale, now, msg.value,
399                                   _totalTokensNumber,
400                                   _totalTokensNumberAllowance);
401 
402     token.transferFrom(token, msg.sender, _tokensNumber);
403 
404     if (_restWei > 0) {
405       msg.sender.transfer(_restWei);
406     }
407   }
408 
409   function _tokensaleSelect() private constant returns (Tokensale storage) {
410     MinterState _minterState_ = _minterState();
411 
412     if (_minterState_ == MinterState.PreICOStarted) {
413       return PreICO;
414     } else if (_minterState_ == MinterState.ICOStarted) {
415       return ICO;
416     } else {
417       revert();
418     }
419   }
420 
421   function () public payable onlyDuringTokensale onlyNotPaused
422     checkLimitsToBuyTokens {
423     Tokensale storage _tokensale = _tokensaleSelect();
424 
425     _tokensaleStart(_tokensale);
426   }
427 
428   function mint(uint256 _tokensNumber) public onlyOwner onlyDuringTokensale {
429     token.mint(_tokensNumber);
430   }
431 
432   function burnUndistributed() public onlyAfterTokensaleOver {
433     token.burnUndistributed();
434   }
435 
436   function withdraw() public onlyOwner {
437     msg.sender.transfer(this.balance);
438   }
439 }