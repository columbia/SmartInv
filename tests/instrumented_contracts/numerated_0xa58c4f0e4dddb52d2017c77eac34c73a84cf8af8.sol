1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ContractReceiver {
33     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
34 }
35 
36 contract ERC223Basic {
37     uint256 public totalSupply;
38     function balanceOf(address who) public constant returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     function transfer(address to, uint256 value, bytes data) public returns (bool);
41     function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC223 is ERC223Basic {
46     function allowance(address owner, address spender) public constant returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface Token { 
53     function distr(address _to, uint256 _value) public returns (bool);
54     function totalSupply() constant public returns (uint256 supply);
55     function balanceOf(address _owner) constant public returns (uint256 balance);
56 }
57 
58 contract JoygoEOS is ERC223 {
59     
60     using SafeMath for uint256;
61     address public owner;
62 
63     mapping (address => uint256) public balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     
66     mapping (address => bool) public blacklist;
67 
68     string public name;
69     string public symbol;
70     uint256 public decimals;
71     uint256 public totalSupply;
72     
73     uint256 public totalDistributed;
74     uint256 public totalRemaining;
75     uint256 public value;
76     uint256 public dividend;
77     uint256 public divisor;
78     uint256 public invitedReward = 1;
79     uint256 public inviteReward = 2;
80     uint256 public inviteAmountLimit = 0;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     event LOG_Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
85     
86     event Distr(address indexed to, uint256 amount);
87     event InviteInit(address indexed to, uint256 amount);
88 
89     event DistrFinished();
90     event DistrStarted();
91     
92     event Burn(address indexed burner, uint256 value);
93     event Mint(address indexed minter, uint256 value);
94     
95     bool public distributionFinished = false;
96     bool public inviteFinished = false;
97 
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102     
103     modifier canNotDistr() {
104         require(distributionFinished);
105         _;
106     }
107 
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112     
113     modifier onlyWhitelist() {
114         require(blacklist[msg.sender] == false);
115         _;
116     }
117     
118     function JoygoEOS (string _tokenName, string _tokenSymbol, uint256 _decimalUnits, uint256 _initialAmount, uint256 _totalDistributed, uint256 _value, uint256 _dividend, uint256 _divisor) public {
119         require(_decimalUnits != 0);
120         require(_initialAmount != 0);
121         require(_totalDistributed != 0);
122         require(_value != 0);
123         require(_dividend != 0);
124         require(_divisor != 0);
125         
126         
127         owner = msg.sender;
128         name = _tokenName;
129         symbol = _tokenSymbol;
130         decimals = _decimalUnits;
131         totalSupply = _initialAmount;
132         totalDistributed = _totalDistributed;
133         totalRemaining = totalSupply.sub(totalDistributed);
134         value = _value;
135         dividend = _dividend;
136         divisor = _divisor;
137         
138         balances[owner] = totalDistributed;
139         Transfer(address(0), owner, totalDistributed);
140     }
141     
142     function transferOwnership(address newOwner) onlyOwner public {
143         if (newOwner != address(0)) {
144             owner = newOwner;
145         }
146     }
147     
148     function enableWhitelist(address[] addresses) onlyOwner public {
149         for (uint i = 0; i < addresses.length; i++) {
150             blacklist[addresses[i]] = false;
151         }
152     }
153 
154     function disableWhitelist(address[] addresses) onlyOwner public {
155         for (uint i = 0; i < addresses.length; i++) {
156             blacklist[addresses[i]] = true;
157         }
158     }
159     
160     function finishDistribution() onlyOwner canDistr public returns (bool) {
161         distributionFinished = true;
162         DistrFinished();
163         return true;
164     }
165     
166     function startDistribution() onlyOwner canNotDistr public returns (bool) {
167         distributionFinished = false;
168         DistrStarted();
169         return true;
170     }
171     
172     function finishInvite() onlyOwner public returns (bool) {
173         require(!inviteFinished);
174         inviteFinished = true;
175         return true;
176     }
177     
178     function startInvite() onlyOwner public returns (bool) {
179         require(inviteFinished);
180         inviteFinished = false;
181         return true;
182     }
183     
184     function changeTotalDistributed(uint256 newTotalDistributed) onlyOwner public {
185         totalDistributed = newTotalDistributed;
186     }
187     
188     function changeTotalRemaining(uint256 newTotalRemaining) onlyOwner public {
189         totalRemaining = newTotalRemaining;
190     }
191     
192     function changeValue(uint256 newValue) onlyOwner public {
193         value = newValue;
194     }
195     
196     function changeTotalSupply(uint256 newTotalSupply) onlyOwner public {
197         totalSupply = newTotalSupply;
198     }
199     
200     function changeDecimals(uint256 newDecimals) onlyOwner public {
201         decimals = newDecimals;
202     }
203     
204     function changeName(string newName) onlyOwner public {
205         name = newName;
206     }
207     
208     function changeSymbol(string newSymbol) onlyOwner public {
209         symbol = newSymbol;
210     }
211     
212     function changeDivisor(uint256 newDivisor) onlyOwner public {
213         divisor = newDivisor;
214     }
215     
216     function changeDividend(uint256 newDividend) onlyOwner public {
217         dividend = newDividend;
218     }
219     
220     function changeInviteReward(uint256 newInviteReward) onlyOwner public {
221         inviteReward = newInviteReward;
222     }
223     
224     function changeInvitedReward(uint256 newInvitedReward) onlyOwner public {
225         invitedReward = newInvitedReward;
226     }
227     
228     function changInviteAmountLimit(uint256 newInviteAmountLimit) onlyOwner public {
229         inviteAmountLimit = newInviteAmountLimit;
230     }
231     
232     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
233         totalDistributed = totalDistributed.add(_amount);
234         totalRemaining = totalRemaining.sub(_amount);
235         balances[_to] = balances[_to].add(_amount);
236         Distr(_to, _amount);
237         Transfer(address(0), _to, _amount);
238         return true;
239         
240         if (totalDistributed >= totalSupply) {
241             distributionFinished = true;
242         }
243     }
244     
245     function airdrop(address[] addresses) onlyOwner canDistr public {
246         
247         require(addresses.length <= 255);
248         require(value <= totalRemaining);
249         
250         for (uint i = 0; i < addresses.length; i++) {
251             require(value <= totalRemaining);
252             distr(addresses[i], value);
253         }
254 	
255         if (totalDistributed >= totalSupply) {
256             distributionFinished = true;
257         }
258     }
259     
260     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
261         
262         require(addresses.length <= 255);
263         require(amount <= totalRemaining);
264         
265         for (uint i = 0; i < addresses.length; i++) {
266             require(amount <= totalRemaining);
267             distr(addresses[i], amount);
268         }
269 	
270         if (totalDistributed >= totalSupply) {
271             distributionFinished = true;
272         }
273     }
274     
275     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
276 
277         require(addresses.length <= 255);
278         require(addresses.length == amounts.length);
279         
280         for (uint8 i = 0; i < addresses.length; i++) {
281             require(amounts[i] <= totalRemaining);
282             distr(addresses[i], amounts[i]);
283             
284             if (totalDistributed >= totalSupply) {
285                 distributionFinished = true;
286             }
287         }
288     }
289     
290     function () external payable {
291             getTokens();
292      }
293     
294     function getTokens() payable canDistr onlyWhitelist public {
295         
296         if (value > totalRemaining) {
297             value = totalRemaining;
298         }
299         
300         require(value <= totalRemaining);
301         
302         address investor = msg.sender;
303         uint256 toGive = value;
304         
305         distr(investor, toGive);
306         
307         if (toGive > 0) {
308             blacklist[investor] = true;
309         }
310 
311         if (totalDistributed >= totalSupply) {
312             distributionFinished = true;
313         }
314         
315         value = value.div(dividend).mul(divisor);
316     }
317 
318     function balanceOf(address _owner) constant public returns (uint256) {
319 	    return getBalance(_owner);
320     }
321     
322     function getBalance(address _address) constant internal returns (uint256) {
323         if (_address !=address(0) && !distributionFinished && !blacklist[_address] && totalDistributed < totalSupply && !inviteFinished) {
324             return balances[_address].add(value);
325         }
326         else {
327             return balances[_address];
328         }
329     }
330 
331     // mitigates the ERC20 short address attack
332     modifier onlyPayloadSize(uint size) {
333         assert(msg.data.length >= size + 4);
334         _;
335     }
336     
337     function transfer(address _to, uint256 _amount, bytes _data, string _custom_fallback) onlyPayloadSize(2 * 32) public returns (bool success) {
338         if(isContract(_to)) {
339             require(balanceOf(msg.sender) >= _amount);
340             balances[msg.sender] = balanceOf(msg.sender).sub(_amount);
341             balances[_to] = balanceOf(_to).add(_amount);
342             ContractReceiver receiver = ContractReceiver(_to);
343             require(receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _amount, _data));
344             
345             Transfer(msg.sender, _to, _amount);
346             LOG_Transfer(msg.sender, _to, _amount, _data);
347             return true;
348         }
349         else {
350             return transferToAddress(_to, _amount, _data);
351         }
352     }
353 
354 
355     function transfer(address _to, uint256 _amount, bytes _data) onlyPayloadSize(2 * 32) public returns (bool success) {
356 
357         require(_to != address(0));
358 
359         if(isContract(_to)) {
360             return transferToContract(_to, _amount, _data);
361         }
362         else {
363             return transferToAddress(_to, _amount, _data);
364         }
365     }
366 
367     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
368         
369         require(_to != address(0));
370         
371         bytes memory empty;
372         
373         if(isContract(_to)) {
374             return transferToContract(_to, _amount, empty);
375         }
376         else {
377             if(_amount <= inviteAmountLimit){
378                 require(invite(msg.sender, _to));
379             }
380             return transferToAddress(_to, _amount, empty);
381         }
382     }
383     
384     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
385 
386         require(_to != address(0));
387         require(_amount <= balances[_from]);
388         require(_amount <= allowed[_from][msg.sender]);
389         
390         require(invite(_from, _to));
391         
392         bytes memory empty;
393         
394         balances[_from] = balances[_from].sub(_amount);
395         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
396         balances[_to] = balances[_to].add(_amount);
397         Transfer(_from, _to, _amount);
398         LOG_Transfer(_from, _to, _amount, empty);
399         return true;
400     }
401     
402     function invite(address _from, address _to) internal returns (bool success) {
403         
404         if(inviteFinished){
405            return true; 
406         }
407 
408         if(invitedInit(_from) && _from != _to){
409             inviteInit(_to);
410             return true;
411         }
412         invitedInit(_to);
413         return true;
414     }
415     
416     function inviteInit(address _address) internal returns (bool success) {
417         if (!distributionFinished && totalDistributed < totalSupply) {
418             
419             
420             if (value.mul(inviteReward) > totalRemaining) {
421                 value = totalRemaining;
422             }
423             require(value.mul(inviteReward) <= totalRemaining);
424             
425             uint256 toGive = value.mul(inviteReward);
426             
427             totalDistributed = totalDistributed.add(toGive);
428             totalRemaining = totalRemaining.sub(toGive);
429             balances[_address] = balances[_address].add(toGive);
430             InviteInit(_address, toGive);
431             Transfer(address(0), _address, toGive);
432 
433             if (toGive > 0) {
434                 blacklist[_address] = true;
435             }
436 
437             if (totalDistributed >= totalSupply) {
438                 distributionFinished = true;
439             }
440             
441             value = value.div(dividend).mul(divisor);
442             return true;
443         }
444         return false;
445     }
446     
447     function invitedInit(address _address) internal returns (bool success) {
448         if (!distributionFinished && totalDistributed < totalSupply && !blacklist[_address]) {
449             
450             if (value.mul(invitedReward) > totalRemaining) {
451                 value = totalRemaining;
452             }
453             require(value.mul(invitedReward) <= totalRemaining);
454             
455             uint256 toGive = value.mul(invitedReward);
456             
457             totalDistributed = totalDistributed.add(toGive);
458             totalRemaining = totalRemaining.sub(toGive);
459             balances[_address] = balances[_address].add(toGive);
460             InviteInit(_address, toGive);
461             Transfer(address(0), _address, toGive);
462 
463             if (toGive > 0) {
464                 blacklist[_address] = true;
465             }
466 
467             if (totalDistributed >= totalSupply) {
468                 distributionFinished = true;
469             }
470             
471             value = value.div(dividend).mul(divisor);
472             return true;
473         }
474         return false;
475     }
476     
477     function approve(address _spender, uint256 _value) public returns (bool success) {
478         allowed[msg.sender][_spender] = _value;
479         Approval(msg.sender, _spender, _value);
480         return true;
481     }
482     
483     function allowance(address _owner, address _spender) constant public returns (uint256) {
484         return allowed[_owner][_spender];
485     }
486     
487     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
488         ForeignToken t = ForeignToken(tokenAddress);
489         uint bal = t.balanceOf(who);
490         return bal;
491     }
492     
493     function withdraw() onlyOwner public {
494         uint256 etherBalance = this.balance;
495         owner.transfer(etherBalance);
496     }
497     
498     function mint(uint256 _value) onlyOwner public {
499 
500         address minter = msg.sender;
501         balances[minter] = balances[minter].add(_value);
502         totalSupply = totalSupply.add(_value);
503         Mint(minter, _value);
504     }
505     
506     function burn(uint256 _value) onlyOwner public {
507         require(_value <= balances[msg.sender]);
508 
509         address burner = msg.sender;
510         balances[burner] = balances[burner].sub(_value);
511         totalSupply = totalSupply.sub(_value);
512         Burn(burner, _value);
513     }
514     
515     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
516         ForeignToken token = ForeignToken(_tokenContract);
517         uint256 amount = token.balanceOf(address(this));
518         return token.transfer(owner, amount);
519     }
520     
521     function approveAndCall(address _spender, uint256 _value, bytes _extraData) payable public returns (bool) {
522         allowed[msg.sender][_spender] = _value;
523         Approval(msg.sender, _spender, _value);
524         
525         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
526         return true;
527     }
528     
529     function isContract(address _addr) private constant returns (bool) {
530         uint length;
531         assembly {
532             length := extcodesize(_addr)
533         }
534         return (length>0);
535     }
536 
537     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
538         require(balances[msg.sender] >= _value);
539         balances[msg.sender] =  balances[msg.sender].sub(_value);
540         balances[_to] = balances[_to].add(_value);
541         Transfer(msg.sender, _to, _value);
542         LOG_Transfer(msg.sender, _to, _value, _data);
543         return true;
544     }
545 
546     function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
547         require(balances[msg.sender] >= _value);
548         balances[msg.sender] = balances[msg.sender].sub(_value);
549         balances[_to] = balances[_to].add(_value);
550         ContractReceiver receiver = ContractReceiver(_to);
551         receiver.tokenFallback(msg.sender, _value, _data);
552         Transfer(msg.sender, _to, _value);
553         LOG_Transfer(msg.sender, _to, _value, _data);
554         return true;
555     }
556 
557 }