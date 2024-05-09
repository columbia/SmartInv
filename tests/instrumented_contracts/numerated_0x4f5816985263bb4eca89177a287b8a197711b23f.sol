1 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
2                             abcLotto: a Block Chain Lottery
3 
4                             Don't trust anyone but the CODE!
5  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
6  /*
7  * This product is protected under license.  Any unauthorized copy, modification, or use without 
8  * express written consent from the creators is prohibited.
9  */
10  
11 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
12                            this inviter book can be used by your applications too.
13                            
14                            have you heard about The 2009 DARPA Network Challenge?
15  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
16 pragma solidity ^0.4.20;
17 
18 /**
19 * @title abc address resolver. 
20  */ 
21 contract abcResolverI{
22     function getWalletAddress() public view returns (address);
23     function getAddress() public view returns (address);
24 }
25 
26 /**
27 * @title inviters book. 
28  */ 
29 contract inviterBook{
30     using SafeMath for *;
31     //storage varible
32     address public owner;
33     abcResolverI public resolver;
34     address public wallet;
35     address public lotto;
36     
37     mapping (address=>bytes32) _alias;
38     mapping (bytes32=>address) _addressbook;
39     mapping (address=>address) _inviter;
40     mapping (address=>uint) _earnings;
41     mapping (address=>bool) _isRoot;
42     uint public rootNumber = 0;
43 
44     //constant
45     uint constant REGISTRATION_FEE = 10000000000000000;    // registration fee is 0.01 ether.
46     
47     //modifier
48 
49     //check contract interface, are they upgrated?
50     modifier abcInterface {
51         if((address(resolver)==0)||(getCodeSize(address(resolver))==0)){
52             if(abc_initNetwork()){
53                 wallet = resolver.getWalletAddress();
54                 lotto = resolver.getAddress();
55             }
56         }
57         else{
58             if(wallet != resolver.getWalletAddress())
59                 wallet = resolver.getWalletAddress();
60 
61             if(lotto != resolver.getAddress())
62                 lotto = resolver.getAddress();
63         }    
64         
65         _;        
66     }    
67 
68     //modifier
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         
72         _;
73     }
74 
75     modifier onlyAuthorized{
76         require(
77             msg.sender == lotto
78         );
79         
80         _;
81     }
82     //events
83     event OnRegisterAlias(address user, bytes32 alias);
84     event OnAddRoot(address root);
85     event OnSetInviter(address user, address inviter);
86     event OnWithdraw(address user, uint earning);
87     event OnPay(address user, uint value);
88     
89     /**
90     * @dev constructor
91     */
92     constructor() public{
93         owner = msg.sender;
94     }
95 
96     //++++++++++++++++++++++++++++++++    root inviter functions   +++++++++++++++++++++++++++++++++++++++++++++++++
97     //      - root inviter can't be delete.
98     /**
99     * @dev add a root inviter.
100     */
101     function addRoot(address addr) onlyOwner public{
102         require(_inviter[addr] == address(0x0) && _isRoot[addr] == false); 
103         _isRoot[addr] = true;
104         rootNumber++;
105         emit OnAddRoot(addr);
106     }
107 
108     /**
109     * @dev if address is a root inviter? with address param.
110     */
111     function isRoot(address addr) 
112         public
113         view 
114         returns(bool)
115     {
116         return _isRoot[addr];
117     }
118 
119     /**
120     * @dev if i am a root inviter? no param.
121     */
122     function isRoot() 
123         public
124         view 
125         returns(bool)
126     {
127         return _isRoot[msg.sender];
128     }
129 
130     /**
131     * @dev change owner address.
132     */ 
133      function setOwner(address newOwner) 
134         onlyOwner 
135         public
136     {
137         require(newOwner != address(0x0));
138         owner = newOwner;
139     }    
140 
141     //++++++++++++++++++++++++++++++++    inviter functions   +++++++++++++++++++++++++++++++++++++++++++++++++++++
142     //   - inviter can be set just once.
143     //   - can't set yourself as inviter.
144     /**
145     * @dev does anyone has inviter? with address param.
146     */ 
147     function hasInviter(address addr) 
148         public 
149         view
150         returns(bool)
151     {
152         if(_inviter[addr] != address(0x0))
153             return true;
154         else
155             return false;
156     } 
157     /**
158     * @dev does i has inviter? no param.
159     */     
160     function hasInviter() 
161         public 
162         view
163         returns(bool)
164     {
165         if(_inviter[msg.sender] != address(0x0))
166             return true;
167         else
168             return false;
169     } 
170 
171     /**
172     * @dev set self's inviter by name.
173     */      
174     function setInviter(string inviter) public{
175          //root player can't set inviter;
176         require(_isRoot[msg.sender] == false);
177 
178         //inviter can be set just once.
179         require(_inviter[msg.sender] == address(0x0)); 
180 
181         //inviter must existed.
182         bytes32 _name = stringToBytes32(inviter);        
183         require(_addressbook[_name] != address(0x0));
184         
185         //can't set yourself as inviter.
186         require(_addressbook[_name] != msg.sender);       
187 
188         //inviter must be valid. 
189         require(isValidInviter(_addressbook[_name]));
190 
191         _inviter[msg.sender] = _addressbook[_name];
192         emit OnSetInviter(msg.sender, _addressbook[_name]);
193     }
194     /**
195     * @dev set another's inviter by name. only by authorized contract.
196     */   
197     function setInviter(address addr, string inviter) 
198         abcInterface
199         public
200         onlyAuthorized
201     {
202         //root player can't set inviter;
203         require(_isRoot[addr] == false);
204 
205         //inviter can be set just once.
206         require(_inviter[addr] == address(0x0)); 
207 
208         //inviter must existed.
209         bytes32 _name = stringToBytes32(inviter);        
210         require(_addressbook[_name] != address(0x0));
211 
212         //can't set yourself as inviter.
213         require(_addressbook[_name] != addr);       
214 
215         //inviter must be valid. 
216         require(isValidInviter(_addressbook[_name]));
217 
218         _inviter[addr] = _addressbook[_name];
219         emit OnSetInviter(addr, _addressbook[_name]);
220     }
221  
222     /**
223     * @dev set self's inviter by address.   
224     */ 
225     function setInviterXAddr(address inviter) public{
226         //root player can't set inviter;
227         require(_isRoot[msg.sender] == false);
228 
229         //inviter can be set just once.
230         require(_inviter[msg.sender] == address(0x0)); 
231 
232         //inviter must existed.        
233         require(inviter != address(0x0));
234 
235         //can't set yourself as inviter.
236         require(inviter != msg.sender);       
237 
238         //inviter must register his alias;
239         require(_alias[inviter] != bytes32(0x0));
240 
241         //inviter must be valid. 
242         require(isValidInviter(inviter));
243 
244         _inviter[msg.sender] = inviter;
245         emit OnSetInviter(msg.sender, inviter);
246     }
247  
248     /**
249     * @dev  set another's inviter by address. only authorized address can do this.
250     */ 
251     function setInviterXAddr(address addr, address inviter) 
252         abcInterface
253         public
254         onlyAuthorized
255     {
256          //root player can't set inviter;
257         require(_isRoot[addr] == false);
258 
259         //inviter can be set just once.
260         require(_inviter[addr] == address(0x0)); 
261 
262         //inviter must existed.        
263         require(inviter != address(0x0));
264 
265         //can't set yourself as inviter.
266         require(inviter != addr);       
267 
268         //inviter must register his alias;
269         require(_alias[inviter] != bytes32(0x0));
270 
271         //inviter must be valid. 
272         require(isValidInviter(inviter));
273 
274          _inviter[addr] = inviter;
275          emit OnSetInviter(addr, inviter);
276     }
277     
278      /**
279      * @dev get inviter's alias.
280      */ 
281      function getInviter() 
282         public 
283         view
284         returns(string)
285      {
286          if(!hasInviter(msg.sender)) return "";
287         
288          return bytes32ToString(_alias[_inviter[msg.sender]]);
289      }  
290  
291       /**
292      * @dev get inviter's address.
293      */ 
294      function getInviterAddr() 
295         public 
296         view
297         returns(address)
298      {
299          return _inviter[msg.sender];
300      } 
301 
302      /**
303     * @dev check inviter's addr is valid.
304      */
305      function isValidInviter(address inviter)
306         internal
307         view
308         returns(bool)
309     {
310         address addr = inviter;
311         while(_inviter[addr] != address(0x0)){
312             addr = _inviter[addr];
313         } 
314         
315         if(_isRoot[addr] == true)
316             return true;
317         else
318             return false;
319     }
320     //++++++++++++++++++++++++++++++++    earning functions   +++++++++++++++++++++++++++++++++++++++++++++++++++++
321       /**
322      * @dev get self's referral earning.
323      */ 
324      function getEarning()
325         public 
326         view 
327         returns (uint)
328      {
329          return _earnings[msg.sender];
330      }
331 
332      /**
333      * @dev withdraw self's referral earning.
334      */ 
335      function withdraw() public {
336          uint earning = _earnings[msg.sender];
337          if(earning>0){
338              _earnings[msg.sender] = 0;
339              msg.sender.transfer(earning);
340              emit OnWithdraw(msg.sender, earning);             
341          }
342      }
343 
344      /**
345      * @dev fallback funtion, calculate inviter's earning. no param.
346      *      - direct inviter get 1/2 of the total value.
347      *      - direct inviter's inviter get 1/2 of the direct inviter, and so on.
348      *      - remaining balance transfered to a wallet.
349      */
350     function() 
351         abcInterface
352         public 
353         payable 
354     {
355         address addr = msg.sender;
356         uint balance = msg.value;
357         uint earning = 0;
358         
359         while(_inviter[addr] != address(0x0)){
360             addr = _inviter[addr];
361             earning = balance.div(2);
362             balance = balance.sub(earning);
363             _earnings[addr] = _earnings[addr].add(earning);
364         }
365         
366         wallet.transfer(balance);
367         emit OnPay(msg.sender, msg.value);
368     }
369      
370      /**
371      * @dev pay funtion, calculate inviter's earning. 
372      *      - direct inviter get 1/2 of the total value.
373      *      - direct inviter's inviter get 1/2 of the direct inviter, and so on.
374      *      - remaining balance transfered to a wallet.
375      */
376     function pay(address addr) 
377         abcInterface
378         public 
379         payable 
380         onlyAuthorized
381     {
382         address _addr = addr;
383         uint balance = msg.value;
384         uint earning = 0;
385         
386         while(_inviter[_addr] != address(0x0)){
387             _addr = _inviter[_addr];
388             earning = balance.div(2);
389             balance = balance.sub(earning);
390             _earnings[_addr] = _earnings[_addr].add(earning);
391         }
392         
393         wallet.transfer(balance);
394         emit OnPay(addr, msg.value);
395     }
396     //++++++++++++++++++++++++++++++++    alias functions  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
397      /**
398      * @dev register a alias. you can register alias several times.
399      */    
400      function registerAlias(string alias) 
401         abcInterface 
402         public 
403         payable
404      {
405          require(msg.value >= REGISTRATION_FEE);
406          
407          //alias must be unique.
408          bytes32 _name = nameFilter(alias);
409          require(_addressbook[_name] == address(0x0));
410 
411          //player hasn't inviter or no root can't register alias.
412          require(hasInviter() || _isRoot[msg.sender] == true);
413 
414          if(_alias[msg.sender] != bytes32(0x0)){
415              //remove old alias mapping key.
416             _addressbook[_alias[msg.sender]] = address(0x0);
417          }
418          _alias[msg.sender] = _name;
419          _addressbook[_name] = msg.sender;
420 
421          wallet.transfer(REGISTRATION_FEE);
422          //refund extra value.
423          if(msg.value > REGISTRATION_FEE){
424              msg.sender.transfer( msg.value.sub( REGISTRATION_FEE ));
425          }
426          emit OnRegisterAlias(msg.sender,_name);
427      }    
428      
429      /**
430      * @dev does alias exist?
431      */  
432      function aliasExist(string alias) 
433         public 
434         view 
435         returns(bool) 
436     {
437         bytes32 _name = stringToBytes32(alias);
438         if(_addressbook[_name] == address(0x0))
439             return false;
440         else
441             return true;
442      }
443      
444      /**
445      * @dev get self's alias.
446      */ 
447     function getAlias() 
448         public 
449         view 
450         returns(string)
451     {
452          return bytes32ToString(_alias[msg.sender]);
453     }
454 
455     //++++++++++++++++++++++++++++++++     auxiliary functions  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
456      /**
457      * @dev name string filters
458      * -length limited to 32 characters.
459      * -restricts characters to A-Z, a-z, 0-9.
460      * -cannot be only numbers.
461      * -cannot start with 0x.
462      * @return reprocessed string in bytes32 format
463      */
464     function nameFilter(string _input)
465         internal
466         pure
467         returns(bytes32)
468     {
469         bytes memory _temp = bytes(_input);
470         uint256 _length = _temp.length;
471         
472         //sorry limited to 32 characters
473         require (_length <= 32 && _length > 0);
474         // make sure first two characters are not 0x
475         if (_temp[0] == 0x30)
476         {
477             require(_temp[1] != 0x78);
478             require(_temp[1] != 0x58);
479         }
480         
481         // create a bool to track if we have a non number character
482         bool _hasNonNumber;
483         
484         // convert & check
485         for (uint256 i = 0; i < _length; i++)
486         {
487             require
488             (
489                 // require character is A-Z
490                 (_temp[i] > 0x40 && _temp[i] < 0x5b) || 
491                 // OR lowercase a-z
492                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
493                 // or 0-9
494                 (_temp[i] > 0x2f && _temp[i] < 0x3a)
495              );
496                 
497             // see if we have a character other than a number
498             if (_hasNonNumber == false && _temp[i] > 0x3a)
499                 _hasNonNumber = true;    
500         
501         }
502         
503         require(_hasNonNumber == true);
504         
505         bytes32 _ret;
506         assembly {
507             _ret := mload(add(_temp, 32))
508         }
509         return (_ret);
510     }    
511  
512     /*
513     * @dev transfer string to bytes32
514     */
515     function stringToBytes32(string _input)
516         internal
517         pure
518         returns(bytes32)
519     {
520         bytes memory _temp = bytes(_input);
521         uint256 _length = _temp.length;
522         
523         //limited to 32 characters
524         if (_length > 32 || _length == 0) return "";
525         
526         bytes32 _ret;
527         assembly {
528             _ret := mload(add(_temp, 32))
529         }
530         return (_ret);
531     }   
532 
533     /*
534     * @dev transfer bytes32 to string
535     */    
536      function bytes32ToString(bytes32 x) 
537         internal
538         pure 
539         returns (string) 
540     {
541          bytes memory bytesString = new bytes(32);
542          uint charCount = 0;
543          for (uint j = 0; j < 32; j++) {
544              byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
545              if (char != 0) {
546                  bytesString[charCount] = char;
547                  charCount++;
548              }
549          }
550          bytes memory bytesStringTrimmed = new bytes(charCount);
551          for (j = 0; j < charCount; j++) {
552              bytesStringTrimmed[j] = bytesString[j];
553          }
554          return string(bytesStringTrimmed);
555      }
556      
557     /**
558     * @dev init address resolver.
559     */ 
560     function abc_initNetwork() 
561         internal 
562         returns(bool) 
563     { 
564          //mainnet
565          if (getCodeSize(0xde4413799c73a356d83ace2dc9055957c0a5c335)>0){     
566             resolver = abcResolverI(0xde4413799c73a356d83ace2dc9055957c0a5c335);
567             return true;
568          }
569          
570          //rinkeby
571          if (getCodeSize(0xcaddb7e777f7a1d4d60914cdae52aca561d539e8)>0){     
572             resolver = abcResolverI(0xcaddb7e777f7a1d4d60914cdae52aca561d539e8);
573             return true;
574          }         
575          //others ...
576 
577          return false;
578     }      
579     /**
580     * @dev get code size of appointed address.
581      */
582      function getCodeSize(address _addr) 
583         internal 
584         view 
585         returns(uint _size) 
586     {
587          assembly {
588              _size := extcodesize(_addr)
589          }
590     }
591 }
592 
593 /**
594  * @title SafeMath : it's from openzeppelin.
595  * @dev Math operations with safety checks that throw on error
596  */
597 library SafeMath {
598   /**
599   * @dev Multiplies two numbers, throws on overflow.
600   */
601   function mul(uint256 a, uint256 b) public pure returns (uint256 c) {
602     if (a == 0) {
603       return 0;
604     }
605     c = a * b;
606     assert(c / a == b);
607     return c;
608   }
609 
610   /**
611   * @dev Integer division of two numbers, truncating the quotient.
612   */
613   function div(uint256 a, uint256 b) public pure returns (uint256) {
614     // assert(b > 0); // Solidity automatically throws when dividing by 0
615     // uint256 c = a / b;
616     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
617     return a / b;
618   }
619 
620   /**
621   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
622   */
623   function sub(uint256 a, uint256 b) public pure returns (uint256) {
624     assert(b <= a);
625     return a - b;
626   }
627 
628   /**
629   * @dev Adds two numbers, throws on overflow.
630   */
631   function add(uint256 a, uint256 b) public pure returns (uint256 c) {
632     c = a + b;
633     assert(c >= a);
634     return c;
635   }
636 }