1 pragma solidity ^0.4.25;
2 
3 /*
4 *   DAPCAR BOX Token (DAPBOX)
5 *   Created by Starlag Labs (https://starlag.com)
6 *   Copyright © Dapcar.io 2019. All rights reserved.
7 *   https://dapcar.io
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
54     //constructor()
55     //internal
56     //{
57     //}
58 
59     modifier greaterThanZero(uint256 _value) 
60     {
61         require(_value > 0);
62         _;
63     }
64 
65     modifier validUint(uint256 _value) 
66     {
67         require(_value >= 0);
68         _;
69     }
70 
71     modifier validAddress(address _address) 
72     {
73         require(_address != address(0));
74         _;
75     }
76 
77     modifier notThis(address _address) 
78     {
79         require(_address != address(this));
80         _;
81     }
82 
83     modifier validAddressAndNotThis(address _address) 
84     {
85         require(_address != address(0) && _address != address(this));
86         _;
87     }
88 
89     modifier notEmpty(string _data)
90     {
91         require(bytes(_data).length > 0);
92         _;
93     }
94 
95     modifier stringLength(string _data, uint256 _length)
96     {
97         require(bytes(_data).length == _length);
98         _;
99     }
100     
101     modifier validBytes32(bytes32 _bytes)
102     {
103         require(_bytes != 0);
104         _;
105     }
106 
107     modifier validUint64(uint64 _value) 
108     {
109         require(_value >= 0 && _value < 4294967296);
110         _;
111     }
112 
113     modifier validUint8(uint8 _value) 
114     {
115         require(_value >= 0 && _value < 256);
116         _;
117     }
118 
119     modifier validBalanceThis(uint256 _value)
120     {
121         require(_value <= address(this).balance);
122         _;
123     }
124 }
125 
126 contract Authorizable is Utils {
127     using Math for uint256;
128 
129     address public owner;
130     address public newOwner;
131     mapping (address => Level) authorizeds;
132     uint256 public authorizedCount;
133 
134     /*  
135     *   ZERO 0 - bug for null object
136     *   OWNER 1
137     *   ADMIN 2
138     *   DAPP 3
139     */  
140     enum Level {ZERO,OWNER,ADMIN,DAPP}
141 
142     event OwnerTransferred(address indexed _prevOwner, address indexed _newOwner);
143     event Authorized(address indexed _address, Level _level);
144     event UnAuthorized(address indexed _address);
145 
146     constructor()
147     public
148     {
149         owner = msg.sender;
150         authorizeds[msg.sender] = Level.OWNER;
151         authorizedCount = authorizedCount.add(1);
152     }
153 
154     modifier onlyOwner {
155         require(authorizeds[msg.sender] == Level.OWNER);
156         _;
157     }
158 
159     modifier onlyOwnerOrThis {
160         require(authorizeds[msg.sender] == Level.OWNER || msg.sender == address(this));
161         _;
162     }
163 
164     modifier notOwner(address _address) {
165         require(authorizeds[_address] != Level.OWNER);
166         _;
167     }
168 
169     modifier authLevel(Level _level) {
170         require((authorizeds[msg.sender] > Level.ZERO) && (authorizeds[msg.sender] <= _level));
171         _;
172     }
173 
174     modifier authLevelOnly(Level _level) {
175         require(authorizeds[msg.sender] == _level);
176         _;
177     }
178     
179     modifier notSender(address _address) {
180         require(msg.sender != _address);
181         _;
182     }
183 
184     modifier isSender(address _address) {
185         require(msg.sender == _address);
186         _;
187     }
188 
189     modifier checkLevel(Level _level) {
190         require((_level > Level.ZERO) && (Level.DAPP >= _level));
191         _;
192     }
193 
194     function transferOwnership(address _newOwner) 
195     public 
196     {
197         _transferOwnership(_newOwner);
198     }
199 
200     function _transferOwnership(address _newOwner) 
201     onlyOwner 
202     validAddress(_newOwner)
203     notThis(_newOwner)
204     internal 
205     {
206         require(_newOwner != owner);
207         newOwner = _newOwner;
208     }
209 
210     function acceptOwnership() 
211     validAddress(newOwner)
212     isSender(newOwner)
213     public 
214     {
215         OwnerTransferred(owner, newOwner);
216         if (authorizeds[owner] == Level.OWNER) {
217             delete authorizeds[owner];
218         }
219         if (authorizeds[newOwner] > Level.ZERO) {
220             authorizedCount = authorizedCount.sub(1);
221         }
222         owner = newOwner;
223         newOwner = address(0);
224         authorizeds[owner] = Level.OWNER;
225     }
226 
227     function cancelOwnership() 
228     onlyOwner
229     public 
230     {
231         newOwner = address(0);
232     }
233 
234     function authorized(address _address, Level _level) 
235     public  
236     {
237         _authorized(_address, _level);
238     }
239 
240     function _authorized(address _address, Level _level) 
241     onlyOwner
242     validAddress(_address)
243     notOwner(_address)
244     notThis(_address)
245     checkLevel(_level)
246     internal  
247     {
248         if (authorizeds[_address] == Level.ZERO) {
249             authorizedCount = authorizedCount.add(1);
250         }
251         authorizeds[_address] = _level;
252         Authorized(_address, _level);
253     }
254 
255     function unAuthorized(address _address) 
256     onlyOwner
257     validAddress(_address)
258     notOwner(_address)
259     notThis(_address)
260     public  
261     {
262         if (authorizeds[_address] > Level.ZERO) {
263             authorizedCount = authorizedCount.sub(1);
264         }
265         delete authorizeds[_address];
266         UnAuthorized(_address);
267     }
268 
269     function isAuthorized(address _address) 
270     validAddress(_address)
271     notThis(_address)
272     public 
273     constant 
274     returns (Level) 
275     {
276         return authorizeds[_address];
277     }
278 }
279 
280 contract ITokenRecipient { function receiveApproval(address _spender, uint256 _value, address _token, bytes _extraData) public; }
281 
282 contract IERC20 {
283     function totalSupply() public constant returns (uint256);
284     function balanceOf(address _owner) public constant returns (uint256 balance);
285     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
286     function transfer(address _to, uint256 _value) public returns (bool success);
287     function approve(address _spender, uint256 _value) public returns (bool success);
288     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
289 
290     event Transfer(address indexed from, address indexed to, uint256 value);
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 contract ERC20Token is Authorizable, IERC20 {
295     mapping (address => uint256) balances;
296     mapping (address => mapping (address => uint256)) internal allowed;
297 
298     uint256 totalSupply_;
299 
300     event Transfer(address indexed from, address indexed to, uint256 value);
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302 
303     modifier validBalance(uint256 _value)
304     {
305         require(_value <= balances[msg.sender]);
306         _;
307     }
308 
309     modifier validBalanceFrom(address _from, uint256 _value)
310     {
311         require(_value <= balances[_from]);
312         _;
313     }
314 
315     modifier validBalanceOverflows(address _to, uint256 _value)
316     {
317         require(balances[_to] <= balances[_to].add(_value));
318         _;
319     }
320 
321     //constructor()
322     //internal
323     //{
324     //}
325 
326     function totalSupply()
327     public 
328     constant 
329     returns (uint256) 
330     {
331         return totalSupply_;
332     }
333 
334     function transfer(address _to, uint256 _value)
335     public
336     returns (bool success) 
337     {
338         return _transfer(_to, _value);
339     }
340 
341     function _transfer(address _to, uint256 _value)
342     validAddress(_to)
343     greaterThanZero(_value)
344     validBalance(_value)
345     validBalanceOverflows(_to, _value)
346     internal
347     returns (bool success) 
348     {
349         balances[msg.sender] = balances[msg.sender].sub(_value);
350         balances[_to] = balances[_to].add(_value);
351         Transfer(msg.sender, _to, _value);
352         return true;
353     }
354 
355     function transferFrom(address _from, address _to, uint256 _value)
356     public 
357     returns (bool success) 
358     {
359         return _transferFrom(_from, _to, _value);
360     }
361 
362     function _transferFrom(address _from, address _to, uint256 _value)
363     validAddress(_to)
364     validAddress(_from)
365     greaterThanZero(_value)
366     validBalanceFrom(_from, _value)
367     validBalanceOverflows(_to, _value)
368     internal 
369     returns (bool success) 
370     {
371         require(_value <= allowed[_from][msg.sender]);
372         balances[_from] = balances[_from].sub(_value);
373         balances[_to] = balances[_to].add(_value);
374         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
375         Transfer(_from, _to, _value);
376         return true;
377     }
378 
379     function balanceOf(address _owner)
380     validAddress(_owner)
381     public 
382     constant 
383     returns (uint256 balance) 
384     {
385         return balances[_owner];
386     }
387 
388     function approve(address _spender, uint256 _value) 
389     public 
390     returns (bool success) 
391     {
392         return _approve(_spender, _value);
393     }
394 
395     function _approve(address _spender, uint256 _value) 
396     validAddress(_spender)
397     internal 
398     returns (bool success) 
399     {
400         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
401         allowed[msg.sender][_spender] = _value;
402         Approval(msg.sender, _spender, _value);
403         return true;
404     }
405 
406     function allowance(address _owner, address _spender)
407     validAddress(_owner)
408     validAddress(_spender)
409     public 
410     constant 
411     returns (uint256 remaining) 
412     {
413         return allowed[_owner][_spender];
414     }
415 
416     function increaseApproval(address _spender, uint256 _addedValue)
417     validAddress(_spender)
418     greaterThanZero(_addedValue)
419     public 
420     returns (bool success) 
421     {
422         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
423         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
424         return true;
425     }
426 
427     function decreaseApproval(address _spender, uint256 _subtractedValue) 
428     validAddress(_spender)
429     greaterThanZero(_subtractedValue)
430     public
431     returns (bool success) 
432     {
433         uint256 oldValue = allowed[msg.sender][_spender];
434         if (_subtractedValue > oldValue) {
435             delete allowed[msg.sender][_spender];
436         } else {
437             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
438         }
439         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440         return true;
441     }
442 }
443 
444 contract FrozenToken is ERC20Token, ITokenRecipient {
445     mapping (address => bool) frozeds;
446     uint256 public frozedCount;
447     bool public freezeEnabled = false;
448     bool public autoFreeze = false;
449     bool public mintFinished = false;
450 
451     event Freeze(address indexed wallet);
452     event UnFreeze(address indexed wallet);
453     event PropsChanged(address indexed sender, string props, bool oldValue, bool newValue);
454     event Mint(address indexed sender, address indexed wallet, uint256 amount);
455     event ReceiveTokens(address indexed spender, address indexed token, uint256 value, bytes extraData);
456     event ApproveAndCall(address indexed spender, uint256 value, bytes extraData); 
457     event Burn(address indexed sender, uint256 amount);
458     event MintFinished(address indexed spender);
459 
460     modifier notFreeze
461     {
462         require(frozeds[msg.sender] == false || freezeEnabled == false);
463         _;
464     }
465 
466     modifier notFreezeFrom(address _from) 
467     {
468         require((_from != address(0) && frozeds[_from] == false) || freezeEnabled == false);
469         _;
470     }
471 
472     modifier canMint
473     {
474         require(!mintFinished);
475         _;
476     }
477 
478     //constructor()
479     //internal
480     //{
481     //}
482 
483     function freeze(address _address) 
484     authLevel(Level.DAPP)
485     validAddress(_address)
486     notThis(_address)
487     notOwner(_address)
488     public 
489     {
490         if (!frozeds[_address]) {
491             frozeds[_address] = true;
492             frozedCount = frozedCount.add(1);
493             Freeze(_address);
494         }
495     }
496 
497     function unFreeze(address _address) 
498     authLevel(Level.DAPP)
499     validAddress(_address)
500     public 
501     {
502         if (frozeds[_address]) {
503             delete frozeds[_address];
504             frozedCount = frozedCount.sub(1);
505             UnFreeze(_address);
506         }
507     }
508 
509     function updFreezeEnabled(bool _freezeEnabled) 
510     authLevel(Level.ADMIN)
511     public 
512     {
513         PropsChanged(msg.sender, "freezeEnabled", freezeEnabled, _freezeEnabled);
514         freezeEnabled = _freezeEnabled;
515     }
516 
517     function updAutoFreeze(bool _autoFreeze) 
518     authLevel(Level.ADMIN)
519     public 
520     {
521         PropsChanged(msg.sender, "autoFreeze", autoFreeze, _autoFreeze);
522         autoFreeze = _autoFreeze;
523     }
524 
525     function isFreeze(address _address) 
526     validAddress(_address)
527     public 
528     constant 
529     returns(bool) 
530     {
531         return bool(frozeds[_address]);
532     }
533 
534     function transfer(address _to, uint256 _value) 
535     notFreeze
536     public 
537     returns (bool) 
538     {
539         return super.transfer(_to, _value);
540     }
541 
542     function transferFrom(address _from, address _to, uint256 _value) 
543     notFreezeFrom(_from)
544     public 
545     returns (bool) 
546     {
547         return super.transferFrom(_from, _to, _value);
548     }
549 
550     function approve(address _spender, uint256 _value) 
551     notFreezeFrom(_spender)
552     public 
553     returns (bool) 
554     {
555         return super.approve(_spender, _value);
556     }
557 
558     function increaseApproval(address _spender, uint256 _addedValue)
559     notFreezeFrom(_spender)
560     public 
561     returns (bool) 
562     {
563         return super.increaseApproval(_spender, _addedValue);
564     }
565 
566     function decreaseApproval(address _spender, uint256 _subtractedValue) 
567     notFreezeFrom(_spender)
568     public 
569     returns (bool) 
570     {
571         return super.decreaseApproval(_spender, _subtractedValue);
572     }
573 
574     function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
575     validAddress(_spender)
576     greaterThanZero(_value)
577     public 
578     returns (bool success) 
579     {
580         ITokenRecipient spender = ITokenRecipient(_spender);
581         if (approve(_spender, _value)) {
582             spender.receiveApproval(msg.sender, _value, this, _extraData);
583             ApproveAndCall(_spender, _value, _extraData); 
584             return true;
585         }
586     }
587 
588     function receiveApproval(address _spender, uint256 _value, address _token, bytes _extraData)
589     validAddress(_spender)
590     validAddress(_token)
591     greaterThanZero(_value)
592     public 
593     {
594         IERC20 token = IERC20(_token);
595         require(token.transferFrom(_spender, address(this), _value));
596         ReceiveTokens(_spender, _token, _value, _extraData);
597     }
598 
599     function mintFinish() 
600     onlyOwner
601     public 
602     returns (bool success)
603     {
604         mintFinished = true;
605         MintFinished(msg.sender);
606         return true;
607     }
608 
609     function mint(address _address, uint256 _value)
610     canMint
611     authLevel(Level.DAPP)
612     validAddress(_address)
613     greaterThanZero(_value)
614     public
615     returns (bool success) 
616     {
617         balances[_address] = balances[_address].add(_value);
618         totalSupply_ = totalSupply_.add(_value);
619         Transfer(0, _address, _value);
620 
621         if (freezeEnabled && autoFreeze && _address != address(this) && isAuthorized(_address) == Level.ZERO) {
622             if (!isFreeze(_address)) {
623                 frozeds[_address] = true;
624                 frozedCount = frozedCount.add(1);
625                 Freeze(_address);
626             }
627         }
628 
629         Mint(0, _address, _value);
630         return true;
631     }
632 
633     function burn(uint256 _value)
634     greaterThanZero(_value)
635     validBalance(_value)
636     public
637     returns (bool) 
638     {
639         balances[msg.sender] = balances[msg.sender].sub(_value);
640         totalSupply_ = totalSupply_.sub(_value);
641         Transfer(msg.sender, address(0), _value);
642 
643         if (isFreeze(msg.sender)) {
644             delete frozeds[msg.sender];
645             frozedCount = frozedCount.sub(1);
646             UnFreeze(msg.sender);
647         }
648 
649         Burn(msg.sender, _value);
650         return true;
651     }
652 }
653 
654 contract DAPBOXToken is FrozenToken {
655     string public name = "DAPCAR BOX Token";
656     string public symbol = "DAPBOX";
657     uint8 public decimals = 0;
658 
659     string public version = "0.1";
660     string public publisher = "https://dapcar.io";
661     string public description = "This is an official DAPCAR BOX Token (DAPBOX)";
662 
663     bool public acceptAdminWithdraw = false;
664     bool public acceptDonate = true;
665 
666     event InfoChanged(address indexed sender, string version, string publisher, string description);
667     event Withdraw(address indexed sender, address indexed wallet, uint256 amount);
668     event WithdrawTokens(address indexed sender, address indexed wallet, address indexed token, uint256 amount);
669     event Donate(address indexed sender, uint256 value);
670     event PropsChanged(address indexed sender, string props, bool oldValue, bool newValue);
671     
672     //constructor()
673     //internal
674     //{
675     //}
676 
677     function setupInfo(string _version, string _publisher, string _description)
678     authLevel(Level.ADMIN)
679     notEmpty(_version)
680     notEmpty(_publisher)
681     notEmpty(_description)
682     public
683     {
684         version = _version;
685         publisher = _publisher;
686         description = _description;
687         InfoChanged(msg.sender, _version, _publisher, _description);
688     }
689 
690     function withdraw() 
691     public 
692     returns (bool success)
693     {
694         return withdrawAmount(address(this).balance);
695     }
696 
697     function withdrawAmount(uint256 _amount) 
698     authLevel(Level.ADMIN) 
699     greaterThanZero(address(this).balance)
700     greaterThanZero(_amount)
701     validBalanceThis(_amount)
702     public 
703     returns (bool success)
704     {
705         address wallet = owner;
706         if (acceptAdminWithdraw) {
707             wallet = msg.sender;
708         }
709 
710         Withdraw(msg.sender, wallet, address(this).balance);
711         wallet.transfer(address(this).balance);
712         return true;
713     }
714 
715     function withdrawTokens(address _token, uint256 _amount)
716     authLevel(Level.ADMIN)
717     validAddress(_token)
718     greaterThanZero(_amount)
719     public 
720     returns (bool success) 
721     {
722         address wallet = owner;
723         if (acceptAdminWithdraw) {
724             wallet = msg.sender;
725         }
726 
727         bool result = IERC20(_token).transfer(wallet, _amount);
728         if (result) {
729             WithdrawTokens(msg.sender, wallet, _token, _amount);
730         }
731         return result;
732     }
733 
734     function balanceToken(address _token)
735     validAddress(_token)
736     public 
737     constant
738     returns (uint256 amount) 
739     {
740         return IERC20(_token).balanceOf(address(this));
741     }
742 
743     function updAcceptAdminWithdraw(bool _accept)
744     onlyOwner
745     public
746     returns (bool success)
747     {
748         PropsChanged(msg.sender, "acceptAdminWithdraw", acceptAdminWithdraw, _accept);
749         acceptAdminWithdraw = _accept;
750         return true;
751     }
752     
753     function () 
754     external 
755     payable 
756     {
757         if (acceptDonate) {
758             donate();
759         }
760 	}
761 
762     function donate() 
763     greaterThanZero(msg.value)
764     internal 
765     {
766         Donate(msg.sender, msg.value);
767     }
768 
769     function updAcceptDonate(bool _accept)
770     authLevel(Level.ADMIN)
771     public
772     returns (bool success)
773     {
774         PropsChanged(msg.sender, "acceptDonate", acceptDonate, _accept);
775         acceptDonate = _accept;
776         return true;
777     }
778 }