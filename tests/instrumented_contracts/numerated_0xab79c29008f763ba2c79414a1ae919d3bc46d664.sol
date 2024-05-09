1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 library StringUtils {
68     
69     function toAsciiString(address x) internal pure returns (string memory) {
70         bytes memory s = new bytes(40);
71         for (uint i = 0; i < 20; i++) {
72             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
73             byte hi = byte(uint8(b) / 16);
74             byte lo = byte(uint8(b) - 16 * uint8(hi));
75             s[2*i] = _char(hi);
76             s[2*i+1] = _char(lo);            
77         }
78         return string(s);
79     }
80     
81     function _char(byte b) internal pure returns (byte c) {
82         if (uint8(b) < 10) return byte(uint8(b) + 0x30);
83         else return byte(uint8(b) + 0x57);
84     }
85     
86     function append(string memory a, string memory b) internal pure returns (string memory) {
87         return string(abi.encodePacked(a, b));
88     }
89     
90     function append3(string memory a, string memory b, string memory c) internal pure returns (string memory) {
91         return string(abi.encodePacked(a, b, c));
92     }
93     
94     function append4(string memory a, string memory b, string memory c, string memory d) internal pure returns (string memory) {
95         return string(abi.encodePacked(a, b, c, d));
96     }
97     
98     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
99         if (_i == 0) {
100             return "0";
101         }
102         uint j = _i;
103         uint len;
104         while (j != 0) {
105             len++;
106             j /= 10;
107         }
108         bytes memory bstr = new bytes(len);
109         uint k = len - 1;
110         while (_i != 0) {
111             bstr[k--] = byte(uint8(48 + _i % 10));
112             _i /= 10;
113         }
114         return string(bstr);
115     }
116 }
117 
118 library IterableMap {
119     
120     struct IMap {
121         mapping(address => uint256) mapToData;
122         mapping(address => uint256) mapToIndex; // start with index 1
123         address[] indexes;
124     }
125     
126     function insert(IMap storage self, address _address, uint256 _value) internal returns (bool replaced) {
127       
128         require(_address != address(0));
129         
130         if(self.mapToIndex[_address] == 0){
131             
132             // add new
133             self.indexes.push(_address);
134             self.mapToIndex[_address] = self.indexes.length;
135             self.mapToData[_address] = _value;
136             return false;
137         }
138         
139         // replace
140         self.mapToData[_address] = _value;
141         return true;
142     }
143     
144     function remove(IMap storage self, address _address) internal returns (bool success) {
145        
146         require(_address != address(0));
147         
148         // not existing
149         if(self.mapToIndex[_address] == 0){
150             return false;   
151         }
152         
153         uint256 deleteIndex = self.mapToIndex[_address];
154         if(deleteIndex <= 0 || deleteIndex > self.indexes.length){
155             return false;
156         }
157        
158          // if index to be deleted is not the last index, swap position.
159         if (deleteIndex < self.indexes.length) {
160             // swap 
161             self.indexes[deleteIndex-1] = self.indexes[self.indexes.length-1];
162             self.mapToIndex[self.indexes[deleteIndex-1]] = deleteIndex;
163         }
164         self.indexes.length -= 1;
165         delete self.mapToData[_address];
166         delete self.mapToIndex[_address];
167        
168         return true;
169     }
170   
171     function contains(IMap storage self, address _address) internal view returns (bool exists) {
172         return self.mapToIndex[_address] > 0;
173     }
174       
175     function size(IMap storage self) internal view returns (uint256) {
176         return self.indexes.length;
177     }
178   
179     function get(IMap storage self, address _address) internal view returns (uint256) {
180         return self.mapToData[_address];
181     }
182 
183     // start with index 0
184     function getKey(IMap storage self, uint256 _index) internal view returns (address) {
185         
186         if(_index < self.indexes.length){
187             return self.indexes[_index];
188         }
189         return address(0);
190     }
191 }
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://eips.ethereum.org/EIPS/eip-20
196  */
197 interface IERC20 {
198     function transfer(address to, uint256 value) external returns (bool);
199 
200     function approve(address spender, uint256 value) external returns (bool);
201 
202     function transferFrom(address from, address to, uint256 value) external returns (bool);
203 
204     function totalSupply() external view returns (uint256);
205 
206     function balanceOf(address who) external view returns (uint256);
207 
208     function allowance(address owner, address spender) external view returns (uint256);
209 
210     event Transfer(address indexed from, address indexed to, uint256 value);
211 
212     event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * https://eips.ethereum.org/EIPS/eip-20
221  * Originally based on code by FirstBlood:
222  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
223  *
224  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
225  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
226  * compliant implementations may not do it.
227  */
228 contract ERC20 is IERC20 {
229     using SafeMath for uint256;
230 
231     mapping (address => uint256) private _balances;
232 
233     mapping (address => mapping (address => uint256)) private _allowed;
234 
235     uint256 private _totalSupply;
236 
237     /**
238      * @dev Total number of tokens in existence.
239      */
240     function totalSupply() public view returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev Gets the balance of the specified address.
246      * @param owner The address to query the balance of.
247      * @return A uint256 representing the amount owned by the passed address.
248      */
249     function balanceOf(address owner) public view returns (uint256) {
250         return _balances[owner];
251     }
252 
253     /**
254      * @dev Function to check the amount of tokens that an owner allowed to a spender.
255      * @param owner address The address which owns the funds.
256      * @param spender address The address which will spend the funds.
257      * @return A uint256 specifying the amount of tokens still available for the spender.
258      */
259     function allowance(address owner, address spender) public view returns (uint256) {
260         return _allowed[owner][spender];
261     }
262 
263     /**
264      * @dev Transfer token to a specified address.
265      * @param to The address to transfer to.
266      * @param value The amount to be transferred.
267      */
268     function transfer(address to, uint256 value) public returns (bool) {
269         _transfer(msg.sender, to, value);
270         return true;
271     }
272 
273     /**
274      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275      * Beware that changing an allowance with this method brings the risk that someone may use both the old
276      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279      * @param spender The address which will spend the funds.
280      * @param value The amount of tokens to be spent.
281      */
282     function approve(address spender, uint256 value) public returns (bool) {
283         _approve(msg.sender, spender, value);
284         return true;
285     }
286 
287     /**
288      * @dev Transfer tokens from one address to another.
289      * Note that while this function emits an Approval event, this is not required as per the specification,
290      * and other compliant implementations may not emit the event.
291      * @param from address The address which you want to send tokens from
292      * @param to address The address which you want to transfer to
293      * @param value uint256 the amount of tokens to be transferred
294      */
295     function transferFrom(address from, address to, uint256 value) public returns (bool) {
296         _transfer(from, to, value);
297         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
298         return true;
299     }
300 
301     /**
302      * @dev Increase the amount of tokens that an owner allowed to a spender.
303      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * Emits an Approval event.
308      * @param spender The address which will spend the funds.
309      * @param addedValue The amount of tokens to increase the allowance by.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
312         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
313         return true;
314     }
315 
316     /**
317      * @dev Decrease the amount of tokens that an owner allowed to a spender.
318      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
319      * allowed value is better to use this function to avoid 2 calls (and wait until
320      * the first transaction is mined)
321      * From MonolithDAO Token.sol
322      * Emits an Approval event.
323      * @param spender The address which will spend the funds.
324      * @param subtractedValue The amount of tokens to decrease the allowance by.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
327         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Transfer token for a specified addresses.
333      * @param from The address to transfer from.
334      * @param to The address to transfer to.
335      * @param value The amount to be transferred.
336      */
337     function _transfer(address from, address to, uint256 value) internal {
338         require(to != address(0));
339 
340         _balances[from] = _balances[from].sub(value);
341         _balances[to] = _balances[to].add(value);
342         emit Transfer(from, to, value);
343     }
344 
345     /**
346      * @dev Internal function that mints an amount of the token and assigns it to
347      * an account. This encapsulates the modification of balances such that the
348      * proper events are emitted.
349      * @param account The account that will receive the created tokens.
350      * @param value The amount that will be created.
351      */
352     function _mint(address account, uint256 value) internal {
353         require(account != address(0));
354 
355         _totalSupply = _totalSupply.add(value);
356         _balances[account] = _balances[account].add(value);
357         emit Transfer(address(0), account, value);
358     }
359 
360     /**
361      * @dev Internal function that burns an amount of the token of a given
362      * account.
363      * @param account The account whose tokens will be burnt.
364      * @param value The amount that will be burnt.
365      */
366     function _burn(address account, uint256 value) internal {
367         require(account != address(0));
368 
369         _totalSupply = _totalSupply.sub(value);
370         _balances[account] = _balances[account].sub(value);
371         emit Transfer(account, address(0), value);
372     }
373 
374     /**
375      * @dev Approve an address to spend another addresses' tokens.
376      * @param owner The address that owns the tokens.
377      * @param spender The address that will spend the tokens.
378      * @param value The number of tokens that can be spent.
379      */
380     function _approve(address owner, address spender, uint256 value) internal {
381         require(spender != address(0));
382         require(owner != address(0));
383 
384         _allowed[owner][spender] = value;
385         emit Approval(owner, spender, value);
386     }
387 
388     /**
389      * @dev Internal function that burns an amount of the token of a given
390      * account, deducting from the sender's allowance for said account. Uses the
391      * internal burn function.
392      * Emits an Approval event (reflecting the reduced allowance).
393      * @param account The account whose tokens will be burnt.
394      * @param value The amount that will be burnt.
395      */
396     function _burnFrom(address account, uint256 value) internal {
397         _burn(account, value);
398         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
399     }
400 }
401 
402 /**
403  * @title ERC20Detailed token
404  * @dev The decimals are only for visualization purposes.
405  * All the operations are done using the smallest and indivisible token unit,
406  * just as on Ethereum all the operations are done in wei.
407  */
408 contract ERC20Detailed is IERC20 {
409     string private _name;
410     string private _symbol;
411     uint8 private _decimals;
412 
413     constructor (string memory name, string memory symbol, uint8 decimals) public {
414         _name = name;
415         _symbol = symbol;
416         _decimals = decimals;
417     }
418 
419     /**
420      * @return the name of the token.
421      */
422     function name() public view returns (string memory) {
423         return _name;
424     }
425 
426     /**
427      * @return the symbol of the token.
428      */
429     function symbol() public view returns (string memory) {
430         return _symbol;
431     }
432 
433     /**
434      * @return the number of decimals of the token.
435      */
436     function decimals() public view returns (uint8) {
437         return _decimals;
438     }
439 }
440 
441 
442 contract ERC20Votable is ERC20{
443     
444     // Use itmap for all functions on the struct
445     using IterableMap for IterableMap.IMap;
446     using SafeMath for uint256;
447     
448     // event
449     event MintToken(uint256 sessionID, address indexed beneficiary, uint256 amount);
450     event MintFinished(uint256 sessionID);
451     event BurnToken(uint256 sessionID, address indexed beneficiary, uint256 amount);
452     event AddAuthority(uint256 sessionID, address indexed authority);
453     event RemoveAuthority(uint256 sessionID, address indexed authority);
454     event ChangeRequiredApproval(uint256 sessionID, uint256 from, uint256 to);
455     
456     event VoteAccept(uint256 sessionID, address indexed authority);
457     event VoteReject(uint256 sessionID, address indexed authority);
458     
459     // constant
460     uint256 constant NUMBER_OF_BLOCK_FOR_SESSION_EXPIRE = 5760;
461 
462     // Declare an iterable mapping
463     IterableMap.IMap authorities;
464     
465     bool public isMintingFinished;
466     
467     struct Topic {
468         uint8 BURN;
469         uint8 MINT;
470         uint8 MINT_FINISHED;
471         uint8 ADD_AUTHORITY;
472         uint8 REMOVE_AUTHORITY;
473         uint8 CHANGE_REQUIRED_APPROVAL;
474     }
475     
476     struct Session {
477         uint256 id;
478         uint8 topic;
479         uint256 blockNo;
480         uint256 referNumber;
481         address referAddress;
482         uint256 countAccept;
483         uint256 countReject;
484        // number of approval from authories to accept the current session
485         uint256 requireAccept;
486     }
487     
488     ERC20Votable.Topic topic;
489     ERC20Votable.Session session;
490     
491     constructor() public {
492         
493         topic.BURN = 1;
494         topic.MINT = 2;
495         topic.MINT_FINISHED = 3;
496         topic.ADD_AUTHORITY = 4;
497         topic.REMOVE_AUTHORITY = 5;
498         topic.CHANGE_REQUIRED_APPROVAL = 6;
499         
500         session.id = 1;
501         session.requireAccept = 1;
502     
503         authorities.insert(msg.sender, session.id);
504     }
505     
506     /**
507      * @dev modifier
508      */
509     modifier onlyAuthority() {
510         require(authorities.contains(msg.sender));
511         _;
512     }
513     
514     modifier onlySessionAvailable() {
515         require(_isSessionAvailable());
516         _;
517     }
518     
519      modifier onlyHasSession() {
520         require(!_isSessionAvailable());
521         _;
522     }
523     
524     function isAuthority(address _address) public view returns (bool){
525         return authorities.contains(_address);
526     }
527 
528     /**
529      * @dev get session detail
530      */
531     function getSessionName() public view returns (string memory){
532         
533         bool isSession = !_isSessionAvailable();
534         
535         if(isSession){
536             return (_getSessionName());
537         }
538         
539         return "None";
540     }
541     
542     function getSessionExpireAtBlockNo() public view returns (uint256){
543         
544         bool isSession = !_isSessionAvailable();
545         
546         if(isSession){
547             return (session.blockNo.add(NUMBER_OF_BLOCK_FOR_SESSION_EXPIRE));
548         }
549         
550         return 0;
551     }
552     
553     function getSessionVoteAccept() public view returns (uint256){
554       
555         bool isSession = !_isSessionAvailable();
556         
557         if(isSession){
558             return session.countAccept;
559         }
560         
561         return 0;
562     }
563     
564     function getSessionVoteReject() public view returns (uint256){
565       
566         bool isSession = !_isSessionAvailable();
567         
568         if(isSession){
569             return session.countReject;
570         }
571         
572         return 0;
573     }
574     
575     function getSessionRequiredAcceptVote() public view returns (uint256){
576       
577         return session.requireAccept;
578     }
579     
580     function getTotalAuthorities() public view returns (uint256){
581       
582         return authorities.size();
583     }
584     
585 
586     
587     /**
588      * @dev create session
589      */
590      
591     function createSessionMintToken(address _beneficiary, uint256 _amount) public onlyAuthority onlySessionAvailable {
592         
593         require(!isMintingFinished);
594         require(_amount > 0);
595         require(_beneficiary != address(0));
596        
597         _createSession(topic.MINT);
598         session.referNumber = _amount;
599         session.referAddress = _beneficiary;
600     }
601     
602     function createSessionMintFinished() public onlyAuthority onlySessionAvailable {
603         
604         require(!isMintingFinished);
605         _createSession(topic.MINT_FINISHED);
606         session.referNumber = 0;
607         session.referAddress = address(0);
608     }
609     
610     function createSessionBurnAuthorityToken(address _authority, uint256 _amount) public onlyAuthority onlySessionAvailable {
611         
612         require(_amount > 0);
613         require(_authority != address(0));
614         require(isAuthority(_authority));
615        
616         _createSession(topic.BURN);
617         session.referNumber = _amount;
618         session.referAddress = _authority;
619     }
620     
621     function createSessionAddAuthority(address _authority) public onlyAuthority onlySessionAvailable {
622         
623         require(!authorities.contains(_authority));
624         
625         _createSession(topic.ADD_AUTHORITY);
626         session.referNumber = 0;
627         session.referAddress = _authority;
628     }
629     
630     function createSessionRemoveAuthority(address _authority) public onlyAuthority onlySessionAvailable {
631         
632         require(authorities.contains(_authority));
633         
634         // at least 1 authority remain
635         require(authorities.size() > 1);
636       
637         _createSession(topic.REMOVE_AUTHORITY);
638         session.referNumber = 0;
639         session.referAddress = _authority;
640     }
641     
642     function createSessionChangeRequiredApproval(uint256 _to) public onlyAuthority onlySessionAvailable {
643         
644         require(_to != session.requireAccept);
645         require(_to <= authorities.size());
646 
647         _createSession(topic.CHANGE_REQUIRED_APPROVAL);
648         session.referNumber = _to;
649         session.referAddress = address(0);
650     }
651     
652     /**
653      * @dev vote
654      */
655     function voteAccept() public onlyAuthority onlyHasSession {
656         
657         // already vote
658         require(authorities.get(msg.sender) != session.id);
659         
660         authorities.insert(msg.sender, session.id);
661         session.countAccept = session.countAccept.add(1);
662         
663         emit VoteAccept(session.id, session.referAddress);
664         
665         // execute
666         if(session.countAccept >= session.requireAccept){
667             
668             if(session.topic == topic.BURN){
669                 
670                 _burnToken();
671                 
672             }else if(session.topic == topic.MINT){
673                 
674                 _mintToken();
675                 
676             }else if(session.topic == topic.MINT_FINISHED){
677                 
678                 _finishMinting();
679                 
680             }else if(session.topic == topic.ADD_AUTHORITY){
681                 
682                 _addAuthority();    
683             
684             }else if(session.topic == topic.REMOVE_AUTHORITY){
685                 
686                 _removeAuthority();  
687                 
688             }else if(session.topic == topic.CHANGE_REQUIRED_APPROVAL){
689                 
690                 _changeRequiredApproval();  
691                 
692             }
693         }
694     }
695     
696     function voteReject() public onlyAuthority onlyHasSession {
697         
698         // already vote
699         require(authorities.get(msg.sender) != session.id);
700         
701         authorities.insert(msg.sender, session.id);
702         session.countReject = session.countReject.add(1);
703         
704         emit VoteReject(session.id, session.referAddress);
705     }
706     
707     /**
708      * @dev private
709      */
710     function _createSession(uint8 _topic) internal {
711         
712         session.topic = _topic;
713         session.countAccept = 0;
714         session.countReject = 0;
715         session.id = session.id.add(1);
716         session.blockNo = block.number;
717     }
718     
719     function _getSessionName() internal view returns (string memory){
720         
721         string memory topicName = "";
722         
723         if(session.topic == topic.BURN){
724           
725            topicName = StringUtils.append3("Burn ", StringUtils.uint2str(session.referNumber) , " token(s)");
726            
727         }else if(session.topic == topic.MINT){
728           
729            topicName = StringUtils.append4("Mint ", StringUtils.uint2str(session.referNumber) , " token(s) to address 0x", StringUtils.toAsciiString(session.referAddress));
730          
731         }else if(session.topic == topic.MINT_FINISHED){
732           
733            topicName = "Finish minting";
734          
735         }else if(session.topic == topic.ADD_AUTHORITY){
736           
737            topicName = StringUtils.append3("Add 0x", StringUtils.toAsciiString(session.referAddress), " to authorities");
738            
739         }else if(session.topic == topic.REMOVE_AUTHORITY){
740             
741             topicName = StringUtils.append3("Remove 0x", StringUtils.toAsciiString(session.referAddress), " from authorities");
742             
743         }else if(session.topic == topic.CHANGE_REQUIRED_APPROVAL){
744             
745             topicName = StringUtils.append4("Change approval from ", StringUtils.uint2str(session.requireAccept), " to ", StringUtils.uint2str(session.referNumber));
746             
747         }
748         
749         return topicName;
750     }
751     
752     function _isSessionAvailable() internal view returns (bool){
753         
754         // vote result accept
755         if(session.countAccept >= session.requireAccept) return true;
756         
757          // vote result reject
758         if(session.countReject > authorities.size().sub(session.requireAccept)) return true;
759         
760         // vote expire (1 day)
761         if(block.number.sub(session.blockNo) > NUMBER_OF_BLOCK_FOR_SESSION_EXPIRE) return true;
762         
763         return false;
764     }   
765     
766     function _addAuthority() internal {
767         
768         authorities.insert(session.referAddress, session.id);
769         emit AddAuthority(session.id, session.referAddress);
770     }
771     
772     function _removeAuthority() internal {
773         
774         authorities.remove(session.referAddress);
775         if(authorities.size() < session.requireAccept){
776             emit ChangeRequiredApproval(session.id, session.requireAccept, authorities.size());
777             session.requireAccept = authorities.size();
778         }
779         emit RemoveAuthority(session.id, session.referAddress);
780     }
781     
782     function _changeRequiredApproval() internal {
783         
784         emit ChangeRequiredApproval(session.id, session.requireAccept, session.referNumber);
785         session.requireAccept = session.referNumber;
786         session.countAccept = session.requireAccept;
787     }
788     
789     function _mintToken() internal {
790         
791         require(!isMintingFinished);
792         _mint(session.referAddress, session.referNumber);
793         emit MintToken(session.id, session.referAddress, session.referNumber);
794     }
795     
796     function _finishMinting() internal {
797         
798         require(!isMintingFinished);
799         isMintingFinished = true;
800         emit MintFinished(session.id);
801     }
802     
803     function _burnToken() internal {
804         
805         _burn(session.referAddress, session.referNumber);
806         emit BurnToken(session.id, session.referAddress, session.referNumber);
807     }
808 }
809 
810 contract WorldClassSmartFarmToken is ERC20Detailed, ERC20Votable {
811     constructor (string memory name, string memory symbol, uint8 decimals)
812         public
813         ERC20Detailed(name, symbol, decimals)
814     {
815         
816     }
817 }