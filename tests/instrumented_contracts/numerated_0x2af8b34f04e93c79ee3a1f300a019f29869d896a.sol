1 pragma solidity ^0.4.18;
2 
3 /*
4 *   Silicon Valley Token (SVL)
5 *   Created by Starlag Labs (www.starlag.com)
6 *   Copyright © Silicon-Valley.one 2018. All rights reserved.
7 *   https://www.silicon-valley.one/
8 */
9 
10 library Math {
11     function mul(uint256 a, uint256 b) 
12     internal 
13     pure 
14     returns (uint256) 
15     {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) 
25     internal 
26     pure 
27     returns (uint256) 
28     {
29         uint256 c = a / b;
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) 
34     internal 
35     pure 
36     returns (uint256) 
37     {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) 
43     internal 
44     pure 
45     returns (uint256) 
46     {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract Utils {
54     function Utils() public {}
55 
56     modifier greaterThanZero(uint256 _value) 
57     {
58         require(_value > 0);
59         _;
60     }
61 
62     modifier validUint(uint256 _value) 
63     {
64         require(_value >= 0);
65         _;
66     }
67 
68     modifier validAddress(address _address) 
69     {
70         require(_address != address(0));
71         _;
72     }
73 
74     modifier notThis(address _address) 
75     {
76         require(_address != address(this));
77         _;
78     }
79 
80     modifier validAddressAndNotThis(address _address) 
81     {
82         require(_address != address(0) && _address != address(this));
83         _;
84     }
85 
86     modifier notEmpty(string _data)
87     {
88         require(bytes(_data).length > 0);
89         _;
90     }
91 
92     modifier stringLength(string _data, uint256 _length)
93     {
94         require(bytes(_data).length == _length);
95         _;
96     }
97     
98     modifier validBytes32(bytes32 _bytes)
99     {
100         require(_bytes != 0);
101         _;
102     }
103 
104     modifier validUint64(uint64 _value) 
105     {
106         require(_value >= 0 && _value < 4294967296);
107         _;
108     }
109 
110     modifier validUint8(uint8 _value) 
111     {
112         require(_value >= 0 && _value < 256);
113         _;
114     }
115 
116     modifier validBalanceThis(uint256 _value)
117     {
118         require(_value <= address(this).balance);
119         _;
120     }
121 }
122 
123 contract Authorizable is Utils {
124     using Math for uint256;
125 
126     address public owner;
127     address public newOwner;
128     mapping (address => Level) authorizeds;
129     uint256 public authorizedCount;
130 
131     /*  
132     *   ZERO 0 - bug for null object
133     *   OWNER 1
134     *   ADMIN 2
135     *   DAPP 3
136     */  
137     enum Level {ZERO,OWNER,ADMIN,DAPP}
138 
139     event OwnerTransferred(address indexed _prevOwner, address indexed _newOwner);
140     event Authorized(address indexed _address, Level _level);
141     event UnAuthorized(address indexed _address);
142 
143     function Authorizable() 
144     public 
145     {
146         owner = msg.sender;
147         authorizeds[msg.sender] = Level.OWNER;
148         authorizedCount = authorizedCount.add(1);
149     }
150 
151     modifier onlyOwner {
152         require(authorizeds[msg.sender] == Level.OWNER);
153         _;
154     }
155 
156     modifier onlyOwnerOrThis {
157         require(authorizeds[msg.sender] == Level.OWNER || msg.sender == address(this));
158         _;
159     }
160 
161     modifier notOwner(address _address) {
162         require(authorizeds[_address] != Level.OWNER);
163         _;
164     }
165 
166     modifier authLevel(Level _level) {
167         require((authorizeds[msg.sender] > Level.ZERO) && (authorizeds[msg.sender] <= _level));
168         _;
169     }
170 
171     modifier authLevelOnly(Level _level) {
172         require(authorizeds[msg.sender] == _level);
173         _;
174     }
175     
176     modifier notSender(address _address) {
177         require(msg.sender != _address);
178         _;
179     }
180 
181     modifier isSender(address _address) {
182         require(msg.sender == _address);
183         _;
184     }
185 
186     modifier checkLevel(Level _level) {
187         require((_level > Level.ZERO) && (Level.DAPP >= _level));
188         _;
189     }
190 
191     function transferOwnership(address _newOwner) 
192     public 
193     {
194         _transferOwnership(_newOwner);
195     }
196 
197     function _transferOwnership(address _newOwner) 
198     onlyOwner 
199     validAddress(_newOwner)
200     notThis(_newOwner)
201     internal 
202     {
203         require(_newOwner != owner);
204         newOwner = _newOwner;
205     }
206 
207     function acceptOwnership() 
208     validAddress(newOwner)
209     isSender(newOwner)
210     public 
211     {
212         OwnerTransferred(owner, newOwner);
213         if (authorizeds[owner] == Level.OWNER) {
214             delete authorizeds[owner];
215         }
216         if (authorizeds[newOwner] > Level.ZERO) {
217             authorizedCount = authorizedCount.sub(1);
218         }
219         owner = newOwner;
220         newOwner = address(0);
221         authorizeds[owner] = Level.OWNER;
222     }
223 
224     function cancelOwnership() 
225     onlyOwner
226     public 
227     {
228         newOwner = address(0);
229     }
230 
231     function authorized(address _address, Level _level) 
232     public  
233     {
234         _authorized(_address, _level);
235     }
236 
237     function _authorized(address _address, Level _level) 
238     onlyOwner
239     validAddress(_address)
240     notOwner(_address)
241     notThis(_address)
242     checkLevel(_level)
243     internal  
244     {
245         if (authorizeds[_address] == Level.ZERO) {
246             authorizedCount = authorizedCount.add(1);
247         }
248         authorizeds[_address] = _level;
249         Authorized(_address, _level);
250     }
251 
252     function unAuthorized(address _address) 
253     onlyOwner
254     validAddress(_address)
255     notOwner(_address)
256     notThis(_address)
257     public  
258     {
259         if (authorizeds[_address] > Level.ZERO) {
260             authorizedCount = authorizedCount.sub(1);
261         }
262         delete authorizeds[_address];
263         UnAuthorized(_address);
264     }
265 
266     function isAuthorized(address _address) 
267     validAddress(_address)
268     notThis(_address)
269     public 
270     constant 
271     returns (Level) 
272     {
273         return authorizeds[_address];
274     }
275 }
276 
277 contract ITokenRecipient { function receiveApproval(address _spender, uint256 _value, address _token, bytes _extraData) public; }
278 
279 contract IERC20 {
280     function totalSupply() public constant returns (uint256);
281     function balanceOf(address _owner) public constant returns (uint256 balance);
282     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
283     function transfer(address _to, uint256 _value) public returns (bool success);
284     function approve(address _spender, uint256 _value) public returns (bool success);
285     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
286 
287     event Transfer(address indexed from, address indexed to, uint256 value);
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 contract ERC20Token is Authorizable, IERC20 {
292     mapping (address => uint256) balances;
293     mapping (address => mapping (address => uint256)) internal allowed;
294 
295     uint256 totalSupply_;
296 
297     event Transfer(address indexed from, address indexed to, uint256 value);
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 
300     modifier validBalance(uint256 _value)
301     {
302         require(_value <= balances[msg.sender]);
303         _;
304     }
305 
306     modifier validBalanceFrom(address _from, uint256 _value)
307     {
308         require(_value <= balances[_from]);
309         _;
310     }
311 
312     modifier validBalanceOverflows(address _to, uint256 _value)
313     {
314         require(balances[_to] <= balances[_to].add(_value));
315         _;
316     }
317 
318     function ERC20Token() public {}
319 
320     function totalSupply()
321     public 
322     constant 
323     returns (uint256) 
324     {
325         return totalSupply_;
326     }
327 
328     function transfer(address _to, uint256 _value)
329     public
330     returns (bool success) 
331     {
332         return _transfer(_to, _value);
333     }
334 
335     function _transfer(address _to, uint256 _value)
336     validAddress(_to)
337     greaterThanZero(_value)
338     validBalance(_value)
339     validBalanceOverflows(_to, _value)
340     internal
341     returns (bool success) 
342     {
343         balances[msg.sender] = balances[msg.sender].sub(_value);
344         balances[_to] = balances[_to].add(_value);
345         Transfer(msg.sender, _to, _value);
346         return true;
347     }
348 
349     function transferFrom(address _from, address _to, uint256 _value)
350     public 
351     returns (bool success) 
352     {
353         return _transferFrom(_from, _to, _value);
354     }
355 
356     function _transferFrom(address _from, address _to, uint256 _value)
357     validAddress(_to)
358     validAddress(_from)
359     greaterThanZero(_value)
360     validBalanceFrom(_from, _value)
361     validBalanceOverflows(_to, _value)
362     internal 
363     returns (bool success) 
364     {
365         require(_value <= allowed[_from][msg.sender]);
366         balances[_from] = balances[_from].sub(_value);
367         balances[_to] = balances[_to].add(_value);
368         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
369         Transfer(_from, _to, _value);
370         return true;
371     }
372 
373     function balanceOf(address _owner)
374     validAddress(_owner)
375     public 
376     constant 
377     returns (uint256 balance) 
378     {
379         return balances[_owner];
380     }
381 
382     function approve(address _spender, uint256 _value) 
383     public 
384     returns (bool success) 
385     {
386         return _approve(_spender, _value);
387     }
388 
389     function _approve(address _spender, uint256 _value) 
390     validAddress(_spender)
391     internal 
392     returns (bool success) 
393     {
394         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
395         allowed[msg.sender][_spender] = _value;
396         Approval(msg.sender, _spender, _value);
397         return true;
398     }
399 
400     function allowance(address _owner, address _spender)
401     validAddress(_owner)
402     validAddress(_spender)
403     public 
404     constant 
405     returns (uint256 remaining) 
406     {
407         return allowed[_owner][_spender];
408     }
409 
410     function increaseApproval(address _spender, uint256 _addedValue)
411     validAddress(_spender)
412     greaterThanZero(_addedValue)
413     public 
414     returns (bool success) 
415     {
416         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
417         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418         return true;
419     }
420 
421     function decreaseApproval(address _spender, uint256 _subtractedValue) 
422     validAddress(_spender)
423     greaterThanZero(_subtractedValue)
424     public
425     returns (bool success) 
426     {
427         uint256 oldValue = allowed[msg.sender][_spender];
428         if (_subtractedValue > oldValue) {
429             delete allowed[msg.sender][_spender];
430         } else {
431             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
432         }
433         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
434         return true;
435     }
436 }
437 
438 contract FrozenToken is ERC20Token, ITokenRecipient {
439     mapping (address => bool) frozeds;
440     uint256 public frozedCount;
441     bool public freezeEnabled = true;
442     bool public autoFreeze = true;
443     bool public mintFinished = false;
444 
445     event Freeze(address indexed wallet);
446     event UnFreeze(address indexed wallet);
447     event PropsChanged(address indexed sender, string props, bool oldValue, bool newValue);
448     event Mint(address indexed sender, address indexed wallet, uint256 amount);
449     event ReceiveTokens(address indexed spender, address indexed token, uint256 value, bytes extraData);
450     event ApproveAndCall(address indexed spender, uint256 value, bytes extraData); 
451     event Burn(address indexed sender, uint256 amount);
452     event MintFinished(address indexed spender);
453 
454     modifier notFreeze
455     {
456         require(frozeds[msg.sender] == false || freezeEnabled == false);
457         _;
458     }
459 
460     modifier notFreezeFrom(address _from) 
461     {
462         require((_from != address(0) && frozeds[_from] == false) || freezeEnabled == false);
463         _;
464     }
465 
466     modifier canMint
467     {
468         require(!mintFinished);
469         _;
470     }
471 
472     function FrozenToken() public {}
473 
474     function freeze(address _address) 
475     authLevel(Level.DAPP)
476     validAddress(_address)
477     notThis(_address)
478     notOwner(_address)
479     public 
480     {
481         if (!frozeds[_address]) {
482             frozeds[_address] = true;
483             frozedCount = frozedCount.add(1);
484             Freeze(_address);
485         }
486     }
487 
488     function unFreeze(address _address) 
489     authLevel(Level.DAPP)
490     validAddress(_address)
491     public 
492     {
493         if (frozeds[_address]) {
494             delete frozeds[_address];
495             frozedCount = frozedCount.sub(1);
496             UnFreeze(_address);
497         }
498     }
499 
500     function updFreezeEnabled(bool _freezeEnabled) 
501     authLevel(Level.ADMIN)
502     public 
503     {
504         PropsChanged(msg.sender, "freezeEnabled", freezeEnabled, _freezeEnabled);
505         freezeEnabled = _freezeEnabled;
506     }
507 
508     function updAutoFreeze(bool _autoFreeze) 
509     authLevel(Level.ADMIN)
510     public 
511     {
512         PropsChanged(msg.sender, "autoFreeze", autoFreeze, _autoFreeze);
513         autoFreeze = _autoFreeze;
514     }
515 
516     function isFreeze(address _address) 
517     validAddress(_address)
518     public 
519     constant 
520     returns(bool) 
521     {
522         return bool(frozeds[_address]);
523     }
524 
525     function transfer(address _to, uint256 _value) 
526     notFreeze
527     public 
528     returns (bool) 
529     {
530         return super.transfer(_to, _value);
531     }
532 
533     function transferFrom(address _from, address _to, uint256 _value) 
534     notFreezeFrom(_from)
535     public 
536     returns (bool) 
537     {
538         return super.transferFrom(_from, _to, _value);
539     }
540 
541     function approve(address _spender, uint256 _value) 
542     notFreezeFrom(_spender)
543     public 
544     returns (bool) 
545     {
546         return super.approve(_spender, _value);
547     }
548 
549     function increaseApproval(address _spender, uint256 _addedValue)
550     notFreezeFrom(_spender)
551     public 
552     returns (bool) 
553     {
554         return super.increaseApproval(_spender, _addedValue);
555     }
556 
557     function decreaseApproval(address _spender, uint256 _subtractedValue) 
558     notFreezeFrom(_spender)
559     public 
560     returns (bool) 
561     {
562         return super.decreaseApproval(_spender, _subtractedValue);
563     }
564 
565     function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
566     validAddress(_spender)
567     greaterThanZero(_value)
568     public 
569     returns (bool success) 
570     {
571         ITokenRecipient spender = ITokenRecipient(_spender);
572         if (approve(_spender, _value)) {
573             spender.receiveApproval(msg.sender, _value, this, _extraData);
574             ApproveAndCall(_spender, _value, _extraData); 
575             return true;
576         }
577     }
578 
579     function receiveApproval(address _spender, uint256 _value, address _token, bytes _extraData)
580     validAddress(_spender)
581     validAddress(_token)
582     greaterThanZero(_value)
583     public 
584     {
585         IERC20 token = IERC20(_token);
586         require(token.transferFrom(_spender, address(this), _value));
587         ReceiveTokens(_spender, _token, _value, _extraData);
588     }
589 
590     function mintFinish() 
591     onlyOwner
592     public 
593     returns (bool success)
594     {
595         mintFinished = true;
596         MintFinished(msg.sender);
597         return true;
598     }
599 
600     function mint(address _address, uint256 _value)
601     canMint
602     authLevel(Level.DAPP)
603     validAddress(_address)
604     greaterThanZero(_value)
605     public
606     returns (bool success) 
607     {
608         balances[_address] = balances[_address].add(_value);
609         totalSupply_ = totalSupply_.add(_value);
610         Transfer(0, _address, _value);
611 
612         if (freezeEnabled && autoFreeze && _address != address(this) && isAuthorized(_address) == Level.ZERO) {
613             if (!isFreeze(_address)) {
614                 frozeds[_address] = true;
615                 frozedCount = frozedCount.add(1);
616                 Freeze(_address);
617             }
618         }
619 
620         Mint(0, _address, _value);
621         return true;
622     }
623 
624     function burn(uint256 _value)
625     greaterThanZero(_value)
626     validBalance(_value)
627     public
628     returns (bool) 
629     {
630         balances[msg.sender] = balances[msg.sender].sub(_value);
631         totalSupply_ = totalSupply_.sub(_value);
632         Transfer(msg.sender, address(0), _value);
633 
634         if (isFreeze(msg.sender)) {
635             delete frozeds[msg.sender];
636             frozedCount = frozedCount.sub(1);
637             UnFreeze(msg.sender);
638         }
639 
640         Burn(msg.sender, _value);
641         return true;
642     }
643 }
644 
645 contract SiliconValleyToken is FrozenToken {
646     string public name = "Silicon Valley Token";
647     string public symbol = "SVL";
648     uint8 public decimals = 18;
649 
650     string public version = "0.1";
651     string public publisher = "https://www.silicon-valley.one/";
652     string public description = "This is an official Silicon Valley Token (SVL)";
653 
654     bool public acceptAdminWithdraw = false;
655     bool public acceptDonate = true;
656 
657     event InfoChanged(address indexed sender, string version, string publisher, string description);
658     event Withdraw(address indexed sender, address indexed wallet, uint256 amount);
659     event WithdrawTokens(address indexed sender, address indexed wallet, address indexed token, uint256 amount);
660     event Donate(address indexed sender, uint256 value);
661     event PropsChanged(address indexed sender, string props, bool oldValue, bool newValue);
662 
663     function SiliconValleyToken() public {}
664 
665     function setupInfo(string _version, string _publisher, string _description)
666     authLevel(Level.ADMIN)
667     notEmpty(_version)
668     notEmpty(_publisher)
669     notEmpty(_description)
670     public
671     {
672         version = _version;
673         publisher = _publisher;
674         description = _description;
675         InfoChanged(msg.sender, _version, _publisher, _description);
676     }
677 
678     function withdraw() 
679     public 
680     returns (bool success)
681     {
682         return withdrawAmount(address(this).balance);
683     }
684 
685     function withdrawAmount(uint256 _amount) 
686     authLevel(Level.ADMIN) 
687     greaterThanZero(address(this).balance)
688     greaterThanZero(_amount)
689     validBalanceThis(_amount)
690     public 
691     returns (bool success)
692     {
693         address wallet = owner;
694         if (acceptAdminWithdraw) {
695             wallet = msg.sender;
696         }
697 
698         Withdraw(msg.sender, wallet, address(this).balance);
699         wallet.transfer(address(this).balance);
700         return true;
701     }
702 
703     function withdrawTokens(address _token, uint256 _amount)
704     authLevel(Level.ADMIN)
705     validAddress(_token)
706     greaterThanZero(_amount)
707     public 
708     returns (bool success) 
709     {
710         address wallet = owner;
711         if (acceptAdminWithdraw) {
712             wallet = msg.sender;
713         }
714 
715         bool result = IERC20(_token).transfer(wallet, _amount);
716         if (result) {
717             WithdrawTokens(msg.sender, wallet, _token, _amount);
718         }
719         return result;
720     }
721 
722     function balanceToken(address _token)
723     validAddress(_token)
724     public 
725     constant
726     returns (uint256 amount) 
727     {
728         return IERC20(_token).balanceOf(address(this));
729     }
730 
731     function updAcceptAdminWithdraw(bool _accept)
732     onlyOwner
733     public
734     returns (bool success)
735     {
736         PropsChanged(msg.sender, "acceptAdminWithdraw", acceptAdminWithdraw, _accept);
737         acceptAdminWithdraw = _accept;
738         return true;
739     }
740     
741     function () 
742     external 
743     payable 
744     {
745         if (acceptDonate) {
746             donate();
747         } else {
748             revert();
749         }
750 	}
751 
752     function donate() 
753     greaterThanZero(msg.value)
754     internal 
755     {
756         Donate(msg.sender, msg.value);
757     }
758 
759     function updAcceptDonate(bool _accept)
760     authLevel(Level.ADMIN)
761     public
762     returns (bool success)
763     {
764         PropsChanged(msg.sender, "acceptDonate", acceptDonate, _accept);
765         acceptDonate = _accept;
766         return true;
767     }
768 }