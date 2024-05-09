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
58 contract LearnChain is ERC223 {
59     
60     using SafeMath for uint256;
61     address public owner;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     
66     mapping (address => bool) public blacklist;
67     mapping(address => uint256) public proposals;
68 
69     string public name;
70     string public symbol;
71     uint256 public decimals;
72     uint256 public totalSupply;
73     
74     address public otherTokenAddress;
75     address public tokenSender;
76     uint256 public tokenApproves;
77     uint256 public tokenValue;
78     
79     uint256 public totalDistributed;
80     uint256 public totalRemaining;
81     uint256 public value;
82     uint256 public dividend;
83     uint256 public divisor;
84     uint256 public inviteReward = 2;
85     uint256 public proposalTimeout = 9999 days;
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     event LOG_Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
90     
91     event Distr(address indexed to, uint256 amount);
92     event InviteInit(address indexed to, uint256 amount);
93     event Invite(address indexed from, address indexed to, uint256 other_amount);
94     
95     event DistrFinished();
96     event DistrStarted();
97     
98     event Other_DistrFinished();
99     event Other_DistrStarted();
100     
101     event LOG_receiveApproval(address _sender,uint256 _tokenValue,address _otherTokenAddress,bytes _extraData);
102     event LOG_callTokenTransferFrom(address tokenSender,address _to,uint256 _value);
103     
104     event Burn(address indexed burner, uint256 value);
105     event Mint(address indexed minter, uint256 value);
106     
107     bool public distributionFinished = false;
108     bool public otherDistributionFinished = false;
109     
110     modifier canDistr() {
111         require(!distributionFinished);
112         _;
113     }
114     
115     modifier canNotDistr() {
116         require(distributionFinished);
117         _;
118     }
119     
120     modifier canDistrOther() {
121         require(!otherDistributionFinished);
122         _;
123     }
124     
125     modifier canNotDistrOther() {
126         require(otherDistributionFinished);
127         _;
128     }
129 
130     modifier onlyOwner() {
131         require(msg.sender == owner);
132         _;
133     }
134     
135     modifier onlyWhitelistOrTimeout() {
136         require(blacklist[msg.sender] == false || (blacklist[msg.sender] == true && proposals[msg.sender].add(proposalTimeout) <= now));
137         _;
138     }
139     
140     function LearnChain (string _tokenName, string _tokenSymbol, uint256 _decimalUnits, uint256 _initialAmount, uint256 _totalDistributed, uint256 _value, uint256 _dividend, uint256 _divisor) public {
141         require(_decimalUnits != 0);
142         require(_initialAmount != 0);
143         require(_value != 0);
144         require(_dividend != 0);
145         require(_divisor != 0);
146         
147         
148         owner = msg.sender;
149         name = _tokenName;
150         symbol = _tokenSymbol;
151         decimals = _decimalUnits;
152         totalSupply = _initialAmount;
153         totalDistributed = _totalDistributed;
154         totalRemaining = totalSupply.sub(totalDistributed);
155         value = _value;
156         dividend = _dividend;
157         divisor = _divisor;
158         
159         balances[owner] = totalDistributed;
160         Transfer(address(0), owner, totalDistributed);
161     }
162     
163     function transferOwnership(address newOwner) onlyOwner public {
164         if (newOwner != address(0)) {
165             owner = newOwner;
166         }
167     }
168     
169     function changeOtherTokenAddress(address newOtherTokenAddress) onlyOwner public {
170         if (newOtherTokenAddress != address(0)) {
171             otherTokenAddress = newOtherTokenAddress;
172         }
173     }
174     
175     function changeTokenSender(address newTokenSender) onlyOwner public {
176         if (newTokenSender != address(0)) {
177             tokenSender = newTokenSender;
178         }
179     }
180     
181     function changeTokenValue(uint256 newTokenValue) onlyOwner public {
182         tokenValue = newTokenValue;
183     }
184     
185     function changeProposalTimeout(uint256 newProposalTimeout) onlyOwner public {
186         proposalTimeout = newProposalTimeout;
187     }
188     
189     function changeTokenApproves(uint256 newTokenApproves) onlyOwner public {
190         tokenApproves = newTokenApproves;
191     }
192     
193     function enableWhitelist(address[] addresses) onlyOwner public {
194         for (uint i = 0; i < addresses.length; i++) {
195             blacklist[addresses[i]] = false;
196         }
197     }
198 
199     function disableWhitelist(address[] addresses) onlyOwner public {
200         for (uint i = 0; i < addresses.length; i++) {
201             blacklist[addresses[i]] = true;
202         }
203     }
204     
205     function finishDistribution() onlyOwner canDistr public returns (bool) {
206         distributionFinished = true;
207         DistrFinished();
208         return true;
209     }
210     
211     function startDistribution() onlyOwner canNotDistr public returns (bool) {
212         distributionFinished = false;
213         DistrStarted();
214         return true;
215     }
216     
217     function finishOtherDistribution() onlyOwner canDistrOther public returns (bool) {
218         otherDistributionFinished = true;
219         Other_DistrFinished();
220         return true;
221     }
222     
223     function startOtherDistribution() onlyOwner canNotDistrOther public returns (bool) {
224         otherDistributionFinished = false;
225         Other_DistrStarted();
226         return true;
227     }
228     
229     function changeTotalDistributed(uint256 newTotalDistributed) onlyOwner public {
230         totalDistributed = newTotalDistributed;
231     }
232     
233     function changeTotalRemaining(uint256 newTotalRemaining) onlyOwner public {
234         totalRemaining = newTotalRemaining;
235     }
236     
237     function changeValue(uint256 newValue) onlyOwner public {
238         value = newValue;
239     }
240     
241     function changeTotalSupply(uint256 newTotalSupply) onlyOwner public {
242         totalSupply = newTotalSupply;
243     }
244     
245     function changeDecimals(uint256 newDecimals) onlyOwner public {
246         decimals = newDecimals;
247     }
248     
249     function changeName(string newName) onlyOwner public {
250         name = newName;
251     }
252     
253     function changeSymbol(string newSymbol) onlyOwner public {
254         symbol = newSymbol;
255     }
256     
257     function changeDivisor(uint256 newDivisor) onlyOwner public {
258         divisor = newDivisor;
259     }
260     
261     function changeDividend(uint256 newDividend) onlyOwner public {
262         dividend = newDividend;
263     }
264     
265     function changeInviteReward(uint256 newInviteReward) onlyOwner public {
266         inviteReward = newInviteReward;
267     }
268     
269     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
270         totalDistributed = totalDistributed.add(_amount);
271         totalRemaining = totalRemaining.sub(_amount);
272         balances[_to] = balances[_to].add(_amount);
273         Distr(_to, _amount);
274         Transfer(address(0), _to, _amount);
275         return true;
276         
277         if (totalDistributed >= totalSupply) {
278             distributionFinished = true;
279         }
280     }
281     
282     function airdrop(address[] addresses) onlyOwner canDistr public {
283         
284         require(addresses.length <= 255);
285         require(value <= totalRemaining);
286         
287         for (uint i = 0; i < addresses.length; i++) {
288             require(value <= totalRemaining);
289             distr(addresses[i], value);
290         }
291 	
292         if (totalDistributed >= totalSupply) {
293             distributionFinished = true;
294         }
295     }
296     
297     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
298         
299         require(addresses.length <= 255);
300         require(amount <= totalRemaining);
301         
302         for (uint i = 0; i < addresses.length; i++) {
303             require(amount <= totalRemaining);
304             distr(addresses[i], amount);
305         }
306 	
307         if (totalDistributed >= totalSupply) {
308             distributionFinished = true;
309         }
310     }
311     
312     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
313 
314         require(addresses.length <= 255);
315         require(addresses.length == amounts.length);
316         
317         for (uint8 i = 0; i < addresses.length; i++) {
318             require(amounts[i] <= totalRemaining);
319             distr(addresses[i], amounts[i]);
320             
321             if (totalDistributed >= totalSupply) {
322                 distributionFinished = true;
323             }
324         }
325     }
326     
327     function () external payable {
328             getTokens();
329      }
330     
331     function getTokens() payable canDistr onlyWhitelistOrTimeout public {
332         
333         if (value > totalRemaining) {
334             value = totalRemaining;
335         }
336         
337         require(value <= totalRemaining);
338         
339         address investor = msg.sender;
340         uint256 toGive = value;
341         
342         distr(investor, toGive);
343         
344         if (toGive > 0) {
345             blacklist[investor] = true;
346             proposals[investor] = now;
347         }
348 
349         if (totalDistributed >= totalSupply) {
350             distributionFinished = true;
351         }
352         
353         value = value.div(dividend).mul(divisor);
354     }
355 
356     function balanceOf(address _owner) constant public returns (uint256) {
357 	    return getBalance(_owner);
358     }
359     
360     function getBalance(address _address) constant internal returns (uint256) {
361         if (_address !=address(0) && !distributionFinished && !blacklist[_address] && totalDistributed < totalSupply) {
362             return balances[_address].add(value);
363         }
364         else {
365             return balances[_address];
366         }
367     }
368 
369     // mitigates the ERC20 short address attack
370     modifier onlyPayloadSize(uint size) {
371         assert(msg.data.length >= size + 4);
372         _;
373     }
374     
375     function transfer(address _to, uint256 _amount, bytes _data, string _custom_fallback) onlyPayloadSize(2 * 32) public returns (bool success) {
376         if(isContract(_to)) {
377             require(balanceOf(msg.sender) >= _amount);
378             balances[msg.sender] = balanceOf(msg.sender).sub(_amount);
379             balances[_to] = balanceOf(_to).add(_amount);
380             ContractReceiver receiver = ContractReceiver(_to);
381             require(receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _amount, _data));
382             
383             Transfer(msg.sender, _to, _amount);
384             LOG_Transfer(msg.sender, _to, _amount, _data);
385             return true;
386         }
387         else {
388             return transferToAddress(_to, _amount, _data);
389         }
390     }
391 
392 
393     function transfer(address _to, uint256 _amount, bytes _data) onlyPayloadSize(2 * 32) public returns (bool success) {
394 
395         require(_to != address(0));
396 
397         if(isContract(_to)) {
398             return transferToContract(_to, _amount, _data);
399         }
400         else {
401             return transferToAddress(_to, _amount, _data);
402         }
403     }
404 
405     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
406         
407         require(_to != address(0));
408         
409         bytes memory empty;
410         
411         if(isContract(_to)) {
412             return transferToContract(_to, _amount, empty);
413         }
414         else {
415             require(invite(msg.sender, _to));
416             return transferToAddress(_to, _amount, empty);
417         }
418     }
419     
420     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
421 
422         require(_to != address(0));
423         require(_amount <= balances[_from]);
424         require(_amount <= allowed[_from][msg.sender]);
425         
426         require(invite(_from, _to));
427         
428         bytes memory empty;
429         
430         balances[_from] = balances[_from].sub(_amount);
431         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
432         balances[_to] = balances[_to].add(_amount);
433         Transfer(_from, _to, _amount);
434         LOG_Transfer(_from, _to, _amount, empty);
435         return true;
436     }
437     
438     function invite(address _from, address _to) internal returns (bool success) {
439 
440         if(inviteInit(_from, false)){
441             if(!otherDistributionFinished){
442                 require(callTokenTransferFrom(_to, tokenValue));
443                 Invite(_from, _to, tokenValue);
444             }
445             inviteInit(_to, true);
446             return true;
447         }
448         inviteInit(_to, false);
449         return true;
450     }
451     
452     function inviteInit(address _address, bool _isInvitor) internal returns (bool success) {
453         if (!distributionFinished && totalDistributed < totalSupply) {
454             
455             if(!_isInvitor && blacklist[_address] && proposals[_address].add(proposalTimeout) > now){
456                 return false;
457             }
458             
459             if (value.mul(inviteReward) > totalRemaining) {
460                 value = totalRemaining;
461             }
462             require(value.mul(inviteReward) <= totalRemaining);
463             
464             uint256 toGive = value.mul(inviteReward);
465             
466             totalDistributed = totalDistributed.add(toGive);
467             totalRemaining = totalRemaining.sub(toGive);
468             balances[_address] = balances[_address].add(toGive);
469             InviteInit(_address, toGive);
470             Transfer(address(0), _address, toGive);
471 
472             if (toGive > 0) {
473                 blacklist[_address] = true;
474                 proposals[_address] = now;
475             }
476 
477             if (totalDistributed >= totalSupply) {
478                 distributionFinished = true;
479             }
480             
481             value = value.div(dividend).mul(divisor);
482             return true;
483         }
484         return false;
485     }
486     
487     function approve(address _spender, uint256 _value) public returns (bool success) {
488         allowed[msg.sender][_spender] = _value;
489         Approval(msg.sender, _spender, _value);
490         return true;
491     }
492     
493     function allowance(address _owner, address _spender) constant public returns (uint256) {
494         return allowed[_owner][_spender];
495     }
496     
497     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
498         ForeignToken t = ForeignToken(tokenAddress);
499         uint bal = t.balanceOf(who);
500         return bal;
501     }
502     
503     function withdraw() onlyOwner public {
504         uint256 etherBalance = this.balance;
505         owner.transfer(etherBalance);
506     }
507     
508     function mint(uint256 _value) onlyOwner public {
509 
510         address minter = msg.sender;
511         balances[minter] = balances[minter].add(_value);
512         totalSupply = totalSupply.add(_value);
513         Mint(minter, _value);
514     }
515     
516     function burn(uint256 _value) onlyOwner public {
517         require(_value <= balances[msg.sender]);
518 
519         address burner = msg.sender;
520         balances[burner] = balances[burner].sub(_value);
521         totalSupply = totalSupply.sub(_value);
522         Burn(burner, _value);
523     }
524     
525     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
526         ForeignToken token = ForeignToken(_tokenContract);
527         uint256 amount = token.balanceOf(address(this));
528         return token.transfer(owner, amount);
529     }
530     
531     function receiveApproval(address _sender,uint256 _tokenValue,address _otherTokenAddress,bytes _extraData) payable public returns (bool){
532         require(otherTokenAddress == _otherTokenAddress);
533         require(tokenSender == _sender);
534 
535         tokenApproves = _tokenValue;
536         LOG_receiveApproval(_sender, _tokenValue ,_otherTokenAddress ,_extraData);
537         return true;
538     }
539     
540     function callTokenTransferFrom(address _to,uint256 _value) private returns (bool){
541         
542         require(tokenSender != address(0));
543         require(otherTokenAddress.call(bytes4(bytes32(keccak256("transferFrom(address,address,uint256)"))), tokenSender, _to, _value));
544         
545         LOG_callTokenTransferFrom(tokenSender, _to, _value);
546         return true;
547     }
548     
549     function approveAndCall(address _spender, uint256 _value, bytes _extraData) payable public returns (bool) {
550         allowed[msg.sender][_spender] = _value;
551         Approval(msg.sender, _spender, _value);
552         
553         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
554         return true;
555     }
556     
557     function isContract(address _addr) private constant returns (bool) {
558         uint length;
559         assembly {
560             length := extcodesize(_addr)
561         }
562         return (length>0);
563     }
564 
565     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
566         require(balanceOf(msg.sender) >= _value);
567         balances[msg.sender] =  balanceOf(msg.sender).sub(_value);
568         balances[_to] = balanceOf(_to).add(_value);
569         Transfer(msg.sender, _to, _value);
570         LOG_Transfer(msg.sender, _to, _value, _data);
571         return true;
572     }
573 
574     function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
575         require(balanceOf(msg.sender) >= _value);
576         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
577         balances[_to] = balanceOf(_to).add(_value);
578         ContractReceiver receiver = ContractReceiver(_to);
579         receiver.tokenFallback(msg.sender, _value, _data);
580         Transfer(msg.sender, _to, _value);
581         LOG_Transfer(msg.sender, _to, _value, _data);
582         return true;
583     }
584 
585 }