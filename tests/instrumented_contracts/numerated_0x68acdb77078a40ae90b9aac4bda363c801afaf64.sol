1 pragma solidity >=0.4.24;
2 
3 /**
4  * @title -Security PO8 Token
5  * SPO8 contract records the core attributes of SPO8 Token
6  * 
7  * ███████╗██████╗  ██████╗  █████╗     ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
8  * ██╔════╝██╔══██╗██╔═══██╗██╔══██╗    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
9  * ███████╗██████╔╝██║   ██║╚█████╔╝       ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
10  * ╚════██║██╔═══╝ ██║   ██║██╔══██╗       ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
11  * ███████║██║     ╚██████╔╝╚█████╔╝       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
12  * ╚══════╝╚═╝      ╚═════╝  ╚════╝        ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
13  * ---
14  * POWERED BY
15  *  __    ___   _     ___  _____  ___     _     ___
16  * / /`  | |_) \ \_/ | |_)  | |  / / \   | |\ |  ) )
17  * \_\_, |_| \  |_|  |_|    |_|  \_\_/   |_| \| _)_)
18  * Company Info at https://po8.io
19  * code at https://github.com/crypn3
20  */
21 
22 contract SPO8 {
23     using SafeMath for uint256;
24     
25     /* All props and event of Company */
26     // Company informations
27     string public companyName;
28     string public companyLicenseID;
29     string public companyTaxID;
30     string public companySecurityID;
31     string public companyURL;
32     address public CEO;
33     string public CEOName;
34     address public CFO;
35     string public CFOName;
36     address public BOD; // Board of directer
37     
38     event CEOTransferred(address indexed previousCEO, address indexed newCEO);
39     event CEOSuccession(string previousCEO, string newCEO);
40     event CFOTransferred(address indexed previousCFO, address indexed newCFO);
41     event CFOSuccession(string previousCFO, string newCFO);
42     event BODTransferred(address indexed previousBOD, address indexed newBOD);
43     
44     // Threshold
45     uint256 public threshold;
46     /* End Company */
47     
48     /* All props and event of user */
49     
50     address[] internal whiteListUser; // List of User
51     
52     // Struct of User Information
53     struct Infor{
54         string userName;
55         string phone;
56         string certificate;
57     }
58     
59     mapping(address => Infor) internal userInfor;
60     
61     mapping(address => uint256) internal userPurchasingTime; // The date when user purchases tokens from Sale contract.
62     
63     uint256 public transferLimitationTime = 31536000000; // 1 year
64     
65     event UserInforUpdated(address indexed user, string name, string phone, string certificate);
66     event NewUserAdded(address indexed newUser);
67     event UserRemoved(address indexed user);
68     event UserUnlocked(address indexed user);
69     event UserLocked(address indexed user);
70     event LimitationTimeSet(uint256 time);
71     event TokenUnlocked(uint256 time);
72     /* End user */
73     
74     /* Sale token Contracts address */
75     address[] internal saleContracts;
76     
77     event NewSaleContractAdded(address _saleContractAddress);
78     event SaleContractRemoved(address _saleContractAddress);
79     /* End Sale Contract */
80     
81     /* All props and event of SPO8 token */
82     // Token informations
83     string public name;
84     string public symbol;
85     uint256 internal _totalSupply;
86 
87     mapping (address => uint256) internal balances;
88 
89     mapping (address => mapping (address => uint256)) internal allowed;
90     
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93     event BODBudgetApproval(address indexed owner, address indexed spender, uint256 value, address indexed to);
94     event AllowanceCanceled(address indexed from, address indexed to, uint256 value);
95     event Mint(address indexed from, address indexed to, uint256 totalMint);
96     /* End Token */
97     
98     // Boss's power
99     modifier onlyBoss() {
100         require(msg.sender == CEO || msg.sender == CFO);
101         _;
102     }
103     
104     // BOD's power
105     modifier onlyBOD {
106         require(msg.sender == BOD);
107         _;
108     }
109     
110     // Change CEO and CFO and BOD address or name
111     function changeCEO(address newCEO) public onlyBoss {
112         require(newCEO != address(0));
113         emit CEOTransferred(CEO, newCEO);
114         CEO = newCEO;
115     }
116     
117     function changeCEOName(string newName) public onlyBoss {
118         emit CEOSuccession(CEOName, newName);
119         CEOName = newName;
120     }
121     
122     function changeCFO(address newCFO) public onlyBoss {
123         require(newCFO != address(0));
124         emit CEOTransferred(CFO, newCFO);
125         CFO = newCFO;
126     }
127     
128     function changeCFOName(string newName) public onlyBoss {
129         emit CFOSuccession(CFOName, newName);
130         CFOName = newName;
131     }
132     
133     function changeBODAddress(address newBOD) public onlyBoss {
134         require(newBOD != address(0));
135         emit BODTransferred(BOD, newBOD);
136         BOD = newBOD;
137     }
138     
139     // Informations of special Transfer
140     /**
141      * @dev: TransferState is a state of special transation. (sender have balance more than 10% total supply) 
142      * State: Fail - 0.
143      * State: Success - 1.
144      * State: Pending - 2 - default state.
145     */
146     enum TransactionState {
147         Fail,
148         Success,
149         Pending
150     }
151         
152     /**
153      * @dev Struct of one special transaction.
154      * from The sender of transaction.
155      * to The receiver of transaction.
156      * value Total tokens is sended.
157      * state State of transaction.
158      * date The date when transaction is made.
159     */
160     struct Transaction {
161         address from;
162         address to;
163         uint256 value;
164         TransactionState state;
165         uint256 date;
166         address bod;
167     }
168     
169      
170     Transaction[] internal specialTransactions; // An array where is used to save special transactions
171     
172     // Contract's constructor
173     constructor (uint256 totalSupply_,
174                 address _CEO, 
175                 string _CEOName, 
176                 address _CFO, 
177                 string _CFOName,
178                 address _BOD) public {
179         name = "Security PO8 Token";
180         symbol = "SPO8";
181         _totalSupply = totalSupply_;
182         companyName = "PO8 Ltd";
183         companyTaxID = "IBC";
184         companyLicenseID = "No. 203231 B";
185         companySecurityID = "qKkFiGP4235d";
186         companyURL = "https://po8.io";
187         CEO = _CEO;
188         CEOName = _CEOName; // Mathew Arnett
189         CFO = _CFO;
190         CFOName = _CFOName; // Raul Vasquez
191         BOD = _BOD;
192         threshold = (totalSupply_.mul(10)).div(100); // threshold = 10% of totalSupply
193         balances[CEO] = totalSupply_;
194     }
195     
196     /**
197     * @dev Total number of tokens in existence
198     */
199     function totalSupply() public view returns (uint256) {
200         return _totalSupply;
201     }
202     
203     /**
204     * @dev Gets the balance of the specified address.
205     * @param owner The address to query the balance of.
206     * @return An uint256 representing the amount owned by the passed address.
207     */
208     function balanceOf(address owner) public view returns (uint256) {
209         return balances[owner];
210     }
211 
212     /**
213     * @dev Function to check the amount of tokens that an owner allowed to a spender.
214     * @param owner address The address which owns the funds.
215     * @param spender address The address which will spend the funds.
216     * @return A uint256 specifying the amount of tokens still available for the spender.
217     */
218     function allowance(address owner, address spender) public view returns (uint256) {
219         return allowed[owner][spender];
220     }
221     
222     /**
223      * @dev Mint more tokens
224      * @param _totalMint total token will be minted and transfer to CEO wallet.
225     */
226     function mint(uint256 _totalMint) external onlyBoss returns (bool) {
227         balances[CEO] += _totalMint;
228         _totalSupply += _totalMint;
229         threshold = (_totalSupply.mul(10)).div(100);
230         
231         emit Mint(address(0), CEO, _totalMint);
232         
233         return true;
234     }
235     
236     /**
237     * @dev Transfer token for a specified address (utilities function)
238     * @param _from address The address which you want to send tokens from
239     * @param _to The address to transfer to.
240     * @param _value The amount to be transferred.
241     */
242     function _transfer(address _from, address _to, uint256 _value) internal {
243         require(_to != address(0));
244         require(balances[_from] >= _value);
245         require(balances[_to].add(_value) > balances[_to]);
246         require(checkWhiteList(_from));
247         require(checkWhiteList(_to));
248         require(!checkLockedUser(_from));
249         
250         if(balances[_from] < threshold || msg.sender == CEO || msg.sender == CFO || msg.sender == BOD) {
251             uint256 previousBalances = balances[_from].add(balances[_to]);
252             balances[_from] = balances[_from].sub(_value);
253             balances[_to] = balances[_to].add(_value);
254             emit Transfer(_from, _to, _value);
255     
256             assert(balances[_from].add(balances[_to]) == previousBalances);
257         }
258         
259         else {
260             specialTransfer(_from, _to, _value); // waiting for acceptance from board of directer
261             emit Transfer(_from, _to, 0);
262         }
263     }
264     
265     /**
266     * @dev Transfer token for a specified address
267     * @param _to The address to transfer to.
268     * @param _value The amount to be transferred.
269     */
270     function transfer(address _to, uint256 _value) public returns (bool) {
271         _transfer(msg.sender, _to, _value);
272 		return true;
273     }
274     
275     /**
276     * @dev Special Transfer token for a specified address, but waiting for acceptance from BOD, and push transaction infor to specialTransactions array
277     * @param _from The address transfer from.
278     * @param _to The address to transfer to.
279     * @param _value The amount to be transferred.
280     */
281     function specialTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
282         specialTransactions.push(Transaction({from: _from, to: _to, value: _value, state: TransactionState.Pending, date: now.mul(1000), bod: BOD}));
283         approveToBOD(_value, _to);
284         return true;
285     }
286 
287     /**
288     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
289     * Beware that changing an allowance with this method brings the risk that someone may use both the old
290     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
291     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
292     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
293     * @param _spender The address which will spend the funds.
294     * @param _value The amount of tokens to be spent.
295     */
296     function approve(address _spender, uint256 _value) public returns (bool) {
297         require(_spender != address(0));
298         require(_spender != BOD);
299 
300         allowed[msg.sender][_spender] = _value;
301         emit Approval(msg.sender, _spender, _value);
302         return true;
303     }
304     
305     /**
306     * @dev The approval to BOD address who will transfer the funds from msg.sender to address _to.  
307     * @param _value The amount of tokens to be spent.
308     * @param _to The address which will receive the funds from msg.sender.
309     */
310     function approveToBOD(uint256 _value, address _to) internal returns (bool) {
311         if(allowed[msg.sender][BOD] > 0)
312             allowed[msg.sender][BOD] = (allowed[msg.sender][BOD].add(_value));
313         else
314             allowed[msg.sender][BOD] = _value;
315         emit BODBudgetApproval(msg.sender, BOD, _value, _to);
316         return true;
317     }
318 
319     /**
320     * @dev Transfer tokens from one address to another
321     * @param _from address The address which you want to send tokens from
322     * @param _to address The address which you want to transfer to
323     * @param _value uint256 the amount of tokens to be transferred
324     */
325     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
326         require(_value <= allowed[_from][msg.sender]);     // Check allowance
327         require(msg.sender != BOD);
328         
329         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
330         _transfer(_from, _to, _value);
331         return true;
332     }
333     
334     /**
335     * @dev Increase the amount of tokens that an owner allowed to a spender.
336     * approve should be called when allowed_[_spender] == 0. To increment
337     * allowed value is better to use this function to avoid 2 calls (and wait until
338     * the first transaction is mined)
339     * From MonolithDAO Token.sol
340     * @param _spender The address which will spend the funds.
341     * @param _addedValue The amount of tokens to increase the allowance by.
342     */
343     function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
344         require(_spender != address(0));
345         require(_spender != BOD);
346 
347         allowed[msg.sender][_spender] = (
348             allowed[msg.sender][_spender].add(_addedValue));
349         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350         return true;
351     }
352 
353     /**
354     * @dev Decrease the amount of tokens that an owner allowed to a spender.
355     * approve should be called when allowed_[_spender] == 0. To decrement
356     * allowed value is better to use this function to avoid 2 calls (and wait until
357     * the first transaction is mined)
358     * From MonolithDAO Token.sol
359     * @param _spender The address which will spend the funds.
360     * @param _subtractedValue The amount of tokens to decrease the allowance by.
361     */
362     function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
363         require(_spender != address(0));
364         require(_spender != BOD);
365 
366         allowed[msg.sender][_spender] = (
367             allowed[msg.sender][_spender].sub(_subtractedValue));
368         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369         return true;
370     }
371     
372     /**
373      * @dev Cancel allowance of address from to BOD
374      * @param _from The address of whom approve tokens to BOD for spend.
375      * @param _value Total tokens are canceled.
376      */
377     function cancelAllowance(address _from, uint256 _value) internal onlyBOD {
378         require(_from != address(0));
379         
380         allowed[_from][BOD] = allowed[_from][BOD].sub(_value);
381         emit AllowanceCanceled(_from, BOD, _value);
382     }
383     
384     /**
385     * @dev Only CEO or CFO can add new users.
386     * @param _newUser The address which will add to whiteListUser array.
387     */
388     function addUser(address _newUser) external onlyBoss returns (bool) {
389         require (!checkWhiteList(_newUser));
390         whiteListUser.push(_newUser);
391         emit NewUserAdded(_newUser);
392         return true;
393     }
394     
395     /**
396     * @dev Only CEO or CFO can add new users.
397     * @param _newUsers The address array which will add to whiteListUser array.
398     */
399     function addUsers(address[] _newUsers) external onlyBoss returns (bool) {
400         for(uint i = 0; i < _newUsers.length; i++)
401         {
402             whiteListUser.push(_newUsers[i]);
403             emit NewUserAdded(_newUsers[i]);
404         }
405         return true;
406     }
407     
408     /**
409     * @dev Return total users in white list array.
410     */
411     function totalUsers() public view returns (uint256 users) {
412         return whiteListUser.length;
413     }
414     
415     /**
416     * @dev Checking the user address whether in WhiteList or not.
417     * @param _user The address which will be checked.
418     */
419     function checkWhiteList(address _user) public view returns (bool) {
420         uint256 length = whiteListUser.length;
421         for(uint i = 0; i < length; i++)
422             if(_user == whiteListUser[i])
423                 return true;
424         
425         return false;
426     }
427     
428      /**
429     * @dev Delete the user address in WhiteList.
430     * @param _user The address which will be delete.
431     * After the function excuted, address in the end of list will be moved to postion of deleted user.
432     */
433     function deleteUser(address _user) external onlyBoss returns (bool) {
434         require(checkWhiteList(_user));
435         
436         uint256 i;
437         uint256 length = whiteListUser.length;
438         
439         for(i = 0; i < length; i++)
440         {
441             if (_user == whiteListUser[i])
442                 break;
443         }
444         
445         whiteListUser[i] = whiteListUser[length - 1];
446         delete whiteListUser[length - 1];
447         whiteListUser.length--;
448         
449         emit UserRemoved(_user);
450         return true;
451     }
452     
453     /**
454     * @dev User or CEO or CFO can update user address informations.
455     * @param _user The address which will be checked.
456     * @param _name The new name
457     * @param _phone The new phone number
458     */
459     function updateUserInfor(address _user, string _name, string _phone, string _certificate) external onlyBoss returns (bool) {
460         require(checkWhiteList(_user));
461         
462         userInfor[_user].userName = _name;
463         userInfor[_user].phone = _phone;
464         userInfor[_user].certificate = _certificate;
465         emit UserInforUpdated(_user, _name, _phone, _certificate);
466         
467         return true;
468     }
469     
470     /**
471     * @dev User can get address informations.
472     * @param _user The address which will be checked.
473     */
474     function getUserInfor(address _user) public view returns (string, string) {
475         require(msg.sender == _user);
476         require(checkWhiteList(_user));
477         
478         Infor memory infor = userInfor[_user];
479         
480         return (infor.userName, infor.phone);
481     }
482     
483     /**
484     * @dev CEO and CFO can lock user address, prevent them from transfer token action. If users buy token from any sale contracts, user address also will be locked in 1 year.
485     * @param _user The address which will be locked.
486     */
487     function lockUser(address _user) external returns (bool) {
488         require(checkSaleContracts(msg.sender) || msg.sender == CEO || msg.sender == CFO);
489         
490         userPurchasingTime[_user] = now.mul(1000);
491         emit UserLocked(_user);
492         
493         return true;
494     }
495     
496     /**
497     * @dev CEO and CFO can unlock user address. That address can do transfer token action.
498     * @param _user The address which will be unlocked.
499     */
500     function unlockUser(address _user) external onlyBoss returns (bool) {
501         userPurchasingTime[_user] = 0;
502         emit UserUnlocked(_user);
503         
504         return true;
505     }
506     
507     /**
508     * @dev The function check the user address whether locked or not.
509     * @param _user The address which will be checked.
510     * if now sub User Purchasing Time < 1 year => Address is locked. In contrast, the address is unlocked.
511     * @return true The address is locked.
512     * @return false The address is unlock.
513     */
514     function checkLockedUser(address _user) public view returns (bool) {
515         if ((now.mul(1000)).sub(userPurchasingTime[_user]) < transferLimitationTime)
516             return true;
517         return false;
518     }
519     
520     /**
521     * @dev CEO or CFO can set transferLimitationTime.
522     * @param _time The new time will be set.
523     */
524     function setLimitationTime(uint256 _time) external onlyBoss returns (bool) {
525         transferLimitationTime = _time;
526         emit LimitationTimeSet(_time);
527         
528         return true;
529     }
530     
531     /**
532     * @dev CEO or CFO can unlock tokens.
533     * transferLimitationTime = 0;
534     */
535     function unlockToken() external onlyBoss returns (bool) {
536         transferLimitationTime = 0;
537         emit TokenUnlocked(now.mul(1000)); 
538         return true;
539     }
540     
541     /**
542     * @dev Get special transaction informations
543     * @param _index The index of special transaction which user want to know about.
544     */
545     function getSpecialTxInfor(uint256 _index) public view returns (address from, 
546                                                                             address to,
547                                                                             uint256 value, 
548                                                                             TransactionState state, 
549                                                                             uint256 date, 
550                                                                             address bod) {
551         Transaction storage txInfor = specialTransactions[_index];
552         return (txInfor.from, txInfor.to, txInfor.value, txInfor.state, txInfor.date, txInfor.bod);
553     }
554     
555     /**
556     * @dev Get total special pending transaction
557     */
558     function getTotalPendingTxs() internal view returns (uint32) {
559         uint32 count;
560         TransactionState txState = TransactionState.Pending;
561         for(uint256 i = 0; i < specialTransactions.length; i++) {
562             if(specialTransactions[i].state == txState)
563                 count++;
564         }
565         return count;
566     }
567     
568     /**
569      * @dev Get pending transation IDs from Special Transactions array
570      */
571     function getPendingTxIDs() public view returns (uint[]) {
572         uint32 totalPendingTxs = getTotalPendingTxs();
573         uint[] memory pendingTxIDs = new uint[](totalPendingTxs);
574         uint32 id = 0;
575         TransactionState txState = TransactionState.Pending;
576         for(uint256 i = 0; i < specialTransactions.length; i++) {
577             if(specialTransactions[i].state == txState) {
578                 pendingTxIDs[id] = i;
579                 id++;
580             }
581         }
582         return pendingTxIDs;
583     }
584     
585     /**
586      * @dev The function handle pending special transaction. Only BOD can use it.
587      * @param _index The id of pending transaction is in specialTransactions array.
588      * @param _decision The decision of BOD to handle pending Transaction (true or false).
589      * If true: transfer tokens from address txInfo.from to address txInfo.to and set state of that tx to Success.
590      * If false: cancel allowance from address txInfo.from to BOD and set state of that tx to Fail.
591      */
592     function handlePendingTx(uint256 _index, bool _decision) public onlyBOD returns (bool) {
593         Transaction storage txInfo = specialTransactions[_index];
594         require(txInfo.state == TransactionState.Pending);
595         require(txInfo.bod == BOD);
596         
597         if(_decision) {
598             require(txInfo.value <= allowed[txInfo.from][BOD]);
599             
600             allowed[txInfo.from][BOD] = allowed[txInfo.from][BOD].sub(txInfo.value);
601             _transfer(txInfo.from, txInfo.to, txInfo.value);
602             txInfo.state = TransactionState.Success;
603         }
604         else {
605             txInfo.state = TransactionState.Fail;
606             cancelAllowance(txInfo.from, txInfo.value);
607         }
608         return true;
609     }
610     
611     /**
612      * @dev The function check an address whether in saleContracts array or not.
613      * @param _saleContract The address will be checked.
614      */
615     function checkSaleContracts(address _saleContract) public view returns (bool) {
616         uint256 length = saleContracts.length;
617         for(uint i = 0; i < length; i++) {
618             if(saleContracts[i] == _saleContract)
619                 return true;
620         }
621         return false;
622     }
623     
624     /**
625      * @dev The function adds new sale contract address to saleContracts array.
626      * @param _newSaleContract The address will be added.
627      */
628     function addNewSaleContract(address _newSaleContract) external onlyBoss returns (bool) {
629         require(!checkSaleContracts(_newSaleContract));
630         
631         saleContracts.push(_newSaleContract);
632         emit NewSaleContractAdded(_newSaleContract);
633         
634         return true;
635     }
636     
637     /**
638      * @dev The function remove sale contract address from saleContracts array.
639      * @param _saleContract The address will be removed.
640      */
641     function removeSaleContract(address _saleContract) external onlyBoss returns (bool) {
642         require(checkSaleContracts(_saleContract));
643         
644         uint256 length = saleContracts.length;
645         uint256 i;
646         for(i = 0; i < length; i++) {
647             if(saleContracts[i] == _saleContract)
648                 break;
649         }
650         
651         saleContracts[i] = saleContracts[length - 1];
652         delete saleContracts[length - 1];
653         saleContracts.length--;
654         emit SaleContractRemoved(_saleContract);
655         
656         return true;
657     }
658     
659     // Contract does not accept Ether
660     function () public payable {
661         revert();
662     }
663 }
664 
665 /**
666  * @title SafeMath library
667  * @dev Math operations with safety checks that revert on error
668  */
669 library SafeMath {
670 
671     /**
672     * @dev Multiplies two numbers, reverts on overflow.
673     */
674     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
675         if (a == 0) {
676             return 0;
677         }
678     
679         uint256 c = a * b;
680         require(c / a == b);
681     
682         return c;
683     }
684     
685     /**
686     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
687     */
688     function div(uint256 a, uint256 b) internal pure returns (uint256) {
689         require(b > 0); // Solidity only automatically asserts when dividing by 0
690         uint256 c = a / b;
691         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
692         require(a == b * c);
693     
694         return c;
695     }
696     
697     /**
698     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
699     */
700     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
701         require(b <= a);
702         uint256 c = a - b;
703     
704         return c;
705     }
706     
707     /**
708     * @dev Adds two numbers, reverts on overflow.
709     */
710     function add(uint256 a, uint256 b) internal pure returns (uint256) {
711         uint256 c = a + b;
712         require(c >= a);
713     
714         return c;
715     }
716     
717     /**
718     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
719     * reverts when dividing by zero.
720     */
721     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
722         require(b != 0);
723         return a % b;
724     }
725 }