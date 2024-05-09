1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4 
5     function totalSupply() constant returns (uint totalSupply);
6 
7     function balanceOf(address _owner) constant returns (uint balance);
8 
9     function transfer(address _to, uint _value) returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint _value) returns (bool success);
12 
13     function approve(address _spender, uint _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns (uint remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20 
21 }
22 
23 contract owned {
24     address public _owner;
25 
26     function owned() {
27         _owner = msg.sender;
28     }
29 
30     modifier onlyOwner {
31         require(msg.sender == _owner);
32         _;
33     }
34 
35     function transferOwnership(address newOwner) onlyOwner {
36         _owner = newOwner;
37     }
38 }
39 
40 contract mortal is owned {
41     function mortal() { 
42     }
43 
44     function kill() onlyOwner {
45         selfdestruct(_owner);
46     }
47 }
48 
49 contract hackethereumIco is mortal {
50     uint256 public _amountRaised;
51     uint256 public _deadline;
52 
53     uint256 private _timeBetweenWithdrawCalls;
54     uint256 private _timeBetweenControlFlipCalls;
55 
56     uint256 private _priceIncrease1;
57     uint256 private _priceIncrease2;
58 
59     bool private _hackedTenuous;
60     bool private _hackedEducated;
61     bool private _hackedAdept;
62     bool private _whitehatActive;
63 
64     bool private _initialised;
65     
66     address private _beneficiary;
67     address private _hackerTenuous;
68     address private _hackerEducated;
69     address private _hackerAdept;
70     address private _hackerDecisive;
71     address private _whitehat;
72 
73     uint256 private _lastHack;
74     uint256 private _lastWhitehat;
75     uint256 private _lastControlFlip;
76 
77     uint256 private _initialPrice;
78 
79     uint256 private constant _participationThreshold =  50000000000000000;
80     uint256 private constant _participationMax       = 500000000000000000;
81 
82     uint256 private constant _hackTokenThreshold     =  10000000000000000;
83 
84     hackoin public _hackoinToken;
85     hackoin public _tenuousToken;
86     hackoin public _educatedToken;
87     hackoin public _adeptToken;
88 
89     mapping(address => uint256) private _balanceOf;
90 
91     event FundTransfer(address indexed backer, string indexed transferType, uint256 amount);
92 
93     function hackethereumIco(
94         address ifSuccessfulSendTo,
95         address hackerTenuousAddress,
96         address hackerEducatedAddress,
97         address hackerAdeptAddress,
98         address hackerDecisiveAddress,
99         address whitehatAddress
100         // uint256 durationInMinutes,
101         // uint256 timeBetweenWithdrawMinutes,
102         // uint256 timeBetweenFlipMinutes
103         
104     ) {
105         _beneficiary = ifSuccessfulSendTo;
106         _hackerTenuous = hackerTenuousAddress;
107         _hackerEducated = hackerEducatedAddress;
108         _hackerAdept = hackerAdeptAddress;
109         _hackerDecisive = hackerDecisiveAddress;
110         _whitehat = whitehatAddress;
111     
112         _initialised = false;
113     }
114 
115     function initialise() onlyOwner {
116         require(!_initialised);
117 
118         _deadline = 1504301337; // Fri, 01 Sep 2017 21:28:57 // now + durationInMinutes * 1 minutes; //1504231337
119 
120         _timeBetweenWithdrawCalls = 30 minutes;
121         _timeBetweenControlFlipCalls = 300 minutes;
122 
123         _priceIncrease2 = _deadline - 4 days;
124         _priceIncrease1 = _priceIncrease2 - 6 days;
125 
126         _lastHack = now;//_deadline + 1 days;
127         _lastWhitehat = now;//_deadline + 1 days;
128         _lastControlFlip = now;//_deadline + 1 days;
129 
130         _initialPrice = 1;
131 
132         address tokenContractAddress = new hackoin("Hackoin", "HK");
133         _hackoinToken = hackoin(tokenContractAddress);
134 
135         address tenuousTokenContractAddress = new hackoin("Hackoin_Tenuous", "HKT");
136         address educatedTokenContractAddress = new hackoin("Hackoin_Educated", "HKE");
137         address adeptTokenContractAddress = new hackoin("Hackoin_Adept", "HKA");
138 
139         _tenuousToken = hackoin(tenuousTokenContractAddress);
140         _educatedToken = hackoin(educatedTokenContractAddress);
141         _adeptToken = hackoin(adeptTokenContractAddress);
142 
143         _hackoinToken.mintToken(msg.sender, _participationMax*2);
144         _tenuousToken.mintToken(msg.sender, _hackTokenThreshold*2);
145         _educatedToken.mintToken(msg.sender, _hackTokenThreshold*2);
146         _adeptToken.mintToken(msg.sender, _hackTokenThreshold*2);
147         _initialised = true;
148     }
149 
150     function adjustTiming(uint256 timeBetweenWithdrawMinutes, uint256 timeBetweenFlipMinutes) onlyOwner {
151         _timeBetweenWithdrawCalls = timeBetweenWithdrawMinutes * 1 minutes;
152         _timeBetweenControlFlipCalls = timeBetweenFlipMinutes * 1 minutes;
153     }
154 
155     function () payable {
156         require(now < _deadline);
157 
158         uint256 amount = msg.value;
159 
160         uint256 currentPrice;
161         if(now < _priceIncrease1)
162         {
163             currentPrice = _initialPrice;
164         }
165         else if (now < _priceIncrease2)
166         {
167             currentPrice = _initialPrice * 2;
168         }
169         else
170         {
171             currentPrice = _initialPrice * 4;
172         }
173 
174         uint256 tokenAmount = amount / currentPrice;
175 
176         require(tokenAmount > 0);
177         require(_balanceOf[msg.sender] + amount >= _balanceOf[msg.sender]);
178         require(this.balance + amount >= this.balance);
179 
180         _balanceOf[msg.sender] += amount;
181         _amountRaised += amount;
182 
183         _hackoinToken.mintToken(msg.sender, tokenAmount);
184         FundTransfer(msg.sender, "Ticket Purchase", amount);
185     }
186 
187     modifier afterDeadline()
188     { 
189         require (now >= _deadline); 
190         _;
191     }
192 
193     function withdrawFunds(uint256 amount) afterDeadline {
194         require(_beneficiary == msg.sender);
195 
196         require(this.balance > 0);
197         require(amount <= this.balance);
198 
199         if (_beneficiary.send(amount))
200         {
201             FundTransfer(_beneficiary, "Withdrawal", amount);
202         }
203     }
204 
205     function hackDecisive(address targetAddress, uint256 amount) afterDeadline {
206         require(msg.data.length == 32*2+4);
207         require(_hackerDecisive == msg.sender);
208 
209         require(_hackoinToken.balanceOf(targetAddress) >= _participationMax*2);
210 
211         require(this.balance > 0);
212         require(amount <= this.balance);
213 
214         if (targetAddress.send(amount))
215         {
216             FundTransfer(targetAddress, "Decisive hack", amount);
217         }
218     }
219 
220     function whitehatRecover() afterDeadline {
221         require(_whitehat == msg.sender);
222         require(_whitehatActive);
223 
224         require(_lastWhitehat + _timeBetweenWithdrawCalls < now);
225 
226         require(this.balance > 0);
227 
228         uint amount;
229         if(_amountRaised > 500 ether)
230         {
231             amount = _amountRaised / 50;
232         }
233         else if(_amountRaised > 100 ether)
234         {
235             amount = _amountRaised / 20;
236         }
237         else
238         {
239             amount = _amountRaised / 10;
240         }
241         
242         if(amount > this.balance)
243         {
244             amount = this.balance;
245         }
246 
247         _lastWhitehat = now;
248 
249         if (_whitehat.send(amount))
250         {
251             FundTransfer(_whitehat, "Whitehat recovery", amount);
252         }
253     }
254 
255     function hack(address targetAddress) afterDeadline {
256         require(msg.data.length == 32+4);
257 
258         require(_hackerTenuous == msg.sender || _hackerEducated == msg.sender || _hackerAdept == msg.sender);
259         require(_hackedTenuous);
260         require(_hackedEducated);
261         require(_hackedAdept);
262         require(!_whitehatActive);
263 
264         require(_lastHack + _timeBetweenWithdrawCalls < now);
265 
266         require(this.balance > 0);
267 
268         require(_hackoinToken.balanceOf(targetAddress) >= _participationThreshold);
269 
270         require(_tenuousToken.balanceOf(targetAddress) >= _hackTokenThreshold);
271         require(_educatedToken.balanceOf(targetAddress) >= _hackTokenThreshold);
272         require(_adeptToken.balanceOf(targetAddress) >= _hackTokenThreshold);
273 
274         uint minAmount;
275         if(_amountRaised > 500 ether)
276         {
277             minAmount = _amountRaised / 500;
278         }
279         else if(_amountRaised > 100 ether)
280         {
281             minAmount = _amountRaised / 200;
282         }
283         else
284         {
285             minAmount = _amountRaised / 100;
286         }
287 
288 
289         uint256 participationAmount = _hackoinToken.balanceOf(targetAddress);
290         if(participationAmount > _participationMax)
291         {
292             participationAmount = _participationMax;
293         }
294 
295         uint256 ratio = participationAmount / _participationThreshold;
296         uint256 amount = minAmount * ratio;
297         
298         if(amount > this.balance)
299         {
300             amount = this.balance;
301         }
302 
303         _lastHack = now;
304 
305         if (targetAddress.send(amount))
306         {
307             FundTransfer(targetAddress, "Hack", amount);
308         }
309     }
310 
311     function hackTenuous(address targetAddress) afterDeadline {
312         require(msg.data.length == 32+4);
313         require(_hackerTenuous == msg.sender);
314 
315         if(!_hackedTenuous) {
316             require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
317         }
318 
319         _hackedTenuous = true;
320 
321         if(_tenuousToken.balanceOf(targetAddress) == 0) {
322             _tenuousToken.mintToken(targetAddress, _hackTokenThreshold);
323         }
324     }
325 
326     function hackEducated(address targetAddress) afterDeadline {
327         require(msg.data.length == 32+4);
328         require(_hackerEducated == msg.sender);
329         require(_hackedTenuous);
330 
331         if(!_hackedEducated) {
332             require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
333         }
334 
335         _hackedEducated = true;
336 
337         if(_educatedToken.balanceOf(targetAddress) == 0) {
338             _educatedToken.mintToken(targetAddress, _hackTokenThreshold);
339         }
340     }
341 
342     function hackAdept(address targetAddress) afterDeadline {
343         require(msg.data.length == 32+4);
344         require(_hackerAdept == msg.sender);
345         require(_hackedTenuous && _hackedEducated);
346 
347         if(!_hackedAdept) {
348             require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
349             _lastControlFlip = now;
350         }
351 
352         _whitehatActive = false;
353         _hackedAdept = true;
354 
355         if(_adeptToken.balanceOf(targetAddress) == 0) {
356             _adeptToken.mintToken(targetAddress, _hackTokenThreshold);
357         }
358     }
359 
360     function whiteHat() afterDeadline {
361         require(_whitehat == msg.sender);
362         require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
363         _hackedTenuous = false;
364         _hackedEducated = false;
365         _hackedAdept = false;
366 
367         if(!_whitehatActive){
368             _lastControlFlip = now;
369         }
370 
371         _whitehatActive = true;
372     }
373 
374     function kill() onlyOwner {
375         _hackoinToken.kill();
376         _tenuousToken.kill();
377         _educatedToken.kill();
378         _adeptToken.kill();
379         mortal.kill();
380     }
381 
382     // function transferHackoinTokenOwnership(address newOwner) onlyOwner afterDeadline {
383     //     require(msg.data.length == 32+4);
384     //     _hackoinToken.transferOwnership(newOwner);
385     // }
386 
387     // function transferTenuousTokenOwnership(address newOwner) onlyOwner afterDeadline {
388     //     require(msg.data.length == 32+4);
389     //     _tenuousToken.transferOwnership(newOwner);
390     // }
391 
392     // function transferEducatedTokenOwnership(address newOwner) onlyOwner afterDeadline {
393     //     require(msg.data.length == 32+4);
394     //     _educatedToken.transferOwnership(newOwner);
395     // }
396 
397     // function transferAdeptTokenOwnership(address newOwner) onlyOwner afterDeadline {
398     //     require(msg.data.length == 32+4);
399     //     _adeptToken.transferOwnership(newOwner);
400     // }
401 }
402 
403 contract hackoin is ERC20, owned, mortal {
404     string public name;
405     string public symbol;
406     uint8 public constant decimals = 16;
407 
408     uint256 public _totalSupply;
409 
410 
411     mapping (address => uint256) balances;
412     mapping (address => mapping (address => uint256)) allowed;
413 
414     function hackoin(string _name, string _symbol) {
415         name = _name;
416         symbol = _symbol;
417         _totalSupply = 0;
418     }
419 
420     function transfer(address _to, uint256 _value) returns (bool success) {
421         require(msg.data.length == 32*2+4);
422 
423         require(balances[msg.sender] >= _value);
424         require(_value > 0);
425         require(balances[_to] + _value >= balances[_to]);
426 
427         balances[msg.sender] -= _value;
428         balances[_to] += _value;
429 
430         Transfer(msg.sender, _to, _value);
431         return true;
432     }
433 
434     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
435         require(msg.data.length == 32*3+4);
436 
437         require(balances[_from] >= _amount);
438         require(allowed[_from][msg.sender] >= _amount);
439         require(_amount > 0);
440         require(balances[_to] + _amount > balances[_to]);
441 
442         balances[_from] -= _amount;
443         allowed[_from][msg.sender] -= _amount;
444         balances[_to] += _amount;
445         Transfer(_from, _to, _amount);
446         return true;
447     }
448 
449     function mintToken(address target, uint256 mintedAmount) onlyOwner {
450         require(msg.data.length == 32*2+4);
451 
452         balances[target] += mintedAmount;
453         _totalSupply += mintedAmount;
454         Transfer(0, _owner, mintedAmount);
455         Transfer(_owner, target, mintedAmount);
456     }
457 
458     function totalSupply() constant returns (uint256 totalSupply) {
459         return _totalSupply;
460     }
461 
462     function balanceOf(address _owner) constant returns (uint256 balance) {
463         require(msg.data.length == 32+4);
464         return balances[_owner];
465     }
466 
467     function approve(address _spender, uint256 _value) returns (bool success) {
468         require(msg.data.length == 32*2+4);
469         allowed[msg.sender][_spender] = _value;
470         Approval(msg.sender, _spender, _value);
471         return true;
472     }
473 
474     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
475         require(msg.data.length == 32*2+4);
476         return allowed[_owner][_spender];
477     }
478 }