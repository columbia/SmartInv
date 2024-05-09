1 pragma solidity ^0.5.9;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 //  ercERC
8 contract ERC20 {
9     function totalSupply() public view returns (uint supply);
10     function balanceOf( address who ) public view returns (uint value);
11     function allowance( address owner, address spender ) public view returns (uint _allowance);
12 
13     function transfer( address to, uint256 value) external;
14     function transferFrom( address from, address to, uint value) public;
15     function approve( address spender, uint value ) public returns (bool ok);
16 
17     event Transfer( address indexed from, address indexed to, uint value);
18     event Approval( address indexed owner, address indexed spender, uint value);
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26     int256 constant private INT256_MIN = -2**255;
27 
28     /**
29     * @dev Multiplies two unsigned integers, reverts on overflow.
30     */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b);
41 
42         return c;
43     }
44 
45     /**
46     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
47     */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0);
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54         return c;
55     }
56 
57     /**
58     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59     */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68     * @dev Adds two unsigned integers, reverts on overflow.
69     */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a);
73 
74         return c;
75     }
76 
77     /**
78     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
79     * reverts when dividing by zero.
80     */
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b != 0);
83         return a % b;
84     }
85 }
86 
87 // We can define a library for explicitly converting ``address``
88 // to ``address payable`` as a workaround.
89 library address_make_payable {
90    function make_payable(address x) internal pure returns (address payable) {
91       return address(uint160(x));
92    }
93 }
94 
95 //  Lending Data Contract
96 contract NEST_ToLoanDataContract {
97     //  Add address
98     function addContractAddress(address contractAddress) public;
99     //  Check the contract address
100     function checkContract(address contractAddress) public view returns (bool);
101 }
102 
103 //  Mapping contract
104 contract IBMapping {
105     //  Query address
106 	function checkAddress(string memory name) public view returns (address contractAddress);
107 	//  See if you have permission to modify
108 	function checkOwners(address man) public view returns (bool);
109 }
110 
111 //  Lending and mining contracts
112 contract NEST_LoanMachinery {
113     function startMining(address borrower, address lender, address token, uint256 interest, uint256 time) public payable;
114 }
115 //  Verification of price contracts
116 contract NEST_PriceCheck {
117     //  Validation of loan contract price
118     function checkContract(address borrowAddress, uint256 borrowAmount, address lenderAddress, uint256 lenderAmount, uint256 mortgageRate, uint256 limitdays,uint256 interestRate ) public view returns (bool);
119 }
120 
121 //  Lending Factory Contract
122 contract NEST_LoanFactoryContract {
123     
124     using SafeMath for uint256;
125     using address_make_payable for address;
126     NEST_ToLoanDataContract dataContract;                   
127     IBMapping mappingContract;                              
128     mapping(uint256 => address) loanTokenAddress;           
129     mapping(address => uint256) mortgageRate;               
130     mapping(string => uint256) parameter;                   
131     NEST_PriceCheck priceCheck;                             
132     event ContractAddress(address contractAddress);
133     
134     constructor (address map) public {
135         mappingContract = IBMapping(map);
136         dataContract = NEST_ToLoanDataContract(address(mappingContract.checkAddress("toLoanData")));
137         priceCheck = NEST_PriceCheck(address(mappingContract.checkAddress("priceCheck")));
138         setupParameter();
139     }
140     function changeMapping(address map) public onlyOwner {
141         mappingContract = IBMapping(map);
142         dataContract = NEST_ToLoanDataContract(address(mappingContract.checkAddress("toLoanData")));
143         priceCheck = NEST_PriceCheck(address(mappingContract.checkAddress("priceCheck")));
144     }
145     
146     function setupParameter() private {
147         parameter["borroweCommission"] = 5;
148         parameter["lenderCommission"] = 10;
149         
150         mortgageRate[0x0000000000000000000000000000000000000000] = 50;
151         mortgageRate[0x0000000000085d4780B73119b644AE5ecd22b376] = 40;
152         mortgageRate[0xdAC17F958D2ee523a2206206994597C13D831ec7] = 40;
153         mortgageRate[0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359] = 40;
154         mortgageRate[0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2] = 40;
155         mortgageRate[0x6f259637dcD74C767781E37Bc6133cd6A68aa161] = 40;
156         mortgageRate[0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0] = 40;
157         mortgageRate[0x0D8775F648430679A709E98d2b0Cb6250d2887EF] = 40;
158         mortgageRate[0x6A27348483D59150aE76eF4C0f3622A78B0cA698] = 40;
159         mortgageRate[0xd26114cd6EE289AccF82350c8d8487fedB8A0C07] = 40;
160         
161         loanTokenAddress[1] = address(0x0000000000085d4780B73119b644AE5ecd22b376);
162         loanTokenAddress[2] = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
163         loanTokenAddress[3] = address(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
164         loanTokenAddress[4] = address(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
165         loanTokenAddress[5] = address(0x6f259637dcD74C767781E37Bc6133cd6A68aa161);
166         loanTokenAddress[6] = address(0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0);
167         loanTokenAddress[7] = address(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
168         loanTokenAddress[8] = address(0x6A27348483D59150aE76eF4C0f3622A78B0cA698);
169         loanTokenAddress[9] = address(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
170         
171     }
172     
173     function changeTokenAddress(uint256 num, address addr) public onlyOwner {
174         loanTokenAddress[num] = addr;
175     }
176 
177     function changeMortgageRate(address addr, uint256 num) public onlyOwner {
178         mortgageRate[addr] = num;
179     }
180 
181     function changeParameter(string memory name, uint256 value) public onlyOwner {
182         parameter[name] = value;
183     }
184 
185     function checkParameter(string memory name) public view returns(uint256) {
186         return parameter[name];
187     }
188     
189     function checkToken(uint256 num) public view returns (address) {
190         return loanTokenAddress[num];
191     }
192     
193     modifier onlyOwner(){
194         require(mappingContract.checkOwners(msg.sender) == true);
195         _;
196     }
197     
198     function isContract(address addr) public view returns (bool) {
199         uint size;
200         assembly { size := extcodesize(addr) }
201         return size > 0;
202     }
203     
204     function createContract(uint256 borrowerAmount, uint256 borrowerId, uint256 lenderAmount, uint256 lenderId, uint256 limitdays,uint256 interestRate) public {
205         if (borrowerId == 0 || lenderId == 0) {
206             address borrower = address(loanTokenAddress[borrowerId]);
207             address lender = address(loanTokenAddress[lenderId]);
208             require(priceCheck.checkContract(borrower, borrowerAmount, lender, lenderAmount, mortgageRate[borrower],limitdays, interestRate) == true);
209         }
210         NEST_LoanContract newContract = new NEST_LoanContract(borrowerAmount, borrowerId, lenderAmount, lenderId, limitdays,interestRate, address(mappingContract));
211         dataContract.addContractAddress(address(newContract));
212  
213         emit ContractAddress(address(newContract));
214     }
215 
216     function transferIntoMortgaged(address contractAddress) public payable {
217         require(isContract(address(msg.sender)) == false);   
218         require(dataContract.checkContract(address(contractAddress)) == true);
219         NEST_LoanContract newContract = NEST_LoanContract(address(contractAddress));
220         require(newContract.showContractState() == 0);      
221         require(address(msg.sender) == newContract.checkBorrower());   
222         if (newContract.checkContractType() == 1) {
223             newContract.mortgagedAssets.value(msg.value)();                 
224         } else {
225             require(msg.value == 0);
226             newContract.mortgagedAssets();                                      
227         }
228         
229     }
230 
231     function investmentContracts(address contractAddress) public payable {
232         require(isContract(address(msg.sender)) == false);   
233         require(dataContract.checkContract(address(contractAddress)) == true);
234         NEST_LoanContract newContract = NEST_LoanContract(address(contractAddress));
235         require(newContract.showContractState() == 1);      
236         if (newContract.checkContractType() == 2) {
237             newContract.sendLendAsset.value(msg.value)();
238         } else {
239             require(msg.value == 0);
240             newContract.sendLendAsset();            
241         }
242         
243     }
244 
245     function sendRepayment(address contractAddress) public payable {
246         require(isContract(address(msg.sender)) == false);   
247         require(dataContract.checkContract(address(contractAddress)) == true);
248         NEST_LoanContract newContract = NEST_LoanContract(address(contractAddress));
249         require(address(msg.sender) == newContract.checkBorrower());   
250         require(newContract.showContractState() == 2);      
251         if (newContract.checkContractType() == 2) {
252             newContract.sendRepayment.value(msg.value)();
253         } else {
254             require(msg.value == 0);
255             newContract.sendRepayment();            
256         }
257     }
258 }
259 
260 //  Loan contract
261 contract NEST_LoanContract {
262     using SafeMath for uint256;
263     using address_make_payable for address;
264     ERC20 Token;        
265     ERC20 lenderToken;  
266     uint256 _contractState;     
267     address _borrower;          
268     address _lender;            
269     uint256 _lenderAmount;      
270     uint256 _timeLimit;         
271     uint256 _interest;          
272     uint256 _borrowerAmount;    
273     uint256 _ibasset;           
274     uint256 _commissionRate;    
275     uint256 _investmentTime;    
276     uint256 _endTime;           
277     uint256 _borrowerPayable;   
278     uint256 _expireDate;        
279     uint256 _createTime;        
280     IBMapping mappingContract;  
281     uint256  contractType;      
282     uint256 version = 2;        
283     
284     constructor (uint256 borrowerAmount, uint256 borrowerId, uint256 lenderAmount, uint256 lenderId, uint256 limitdays,uint256 interestRate,address map) public {
285         require(isContract(address(tx.origin)) == false);   
286         require(borrowerAmount > 0);
287         require(limitdays > 0);
288         require(interestRate > 0);
289         require(lenderAmount > 0);
290         require(borrowerId != lenderId);
291         mappingContract = IBMapping(map);
292 
293         NEST_LoanFactoryContract factory = NEST_LoanFactoryContract(address(mappingContract.checkAddress("toLoanFactory")));
294         require(address(msg.sender) == address(factory));               
295         _borrower = tx.origin;                  
296         _borrowerAmount = borrowerAmount;       
297         _contractState = 0;                     
298         _lenderAmount = lenderAmount;           
299         _timeLimit = limitdays.mul(1 days);     
300         _interest = interestRate;               
301         _borrowerPayable = _lenderAmount.mul(interestRate.mul(limitdays).add(10000)).div(10000);
302         require(_borrowerPayable > 0);           
303         _createTime = now;                      
304         
305         setcontractType(borrowerId, lenderId);             
306         
307         
308         
309         if (contractType == 1) {
310             _commissionRate = factory.checkParameter("borroweCommission");                      
311             address tokenAddr = factory.checkToken(lenderId);
312             require(tokenAddr != address(0x0000000000000000000000000000000000000000));
313             lenderToken = ERC20(tokenAddr);
314             _ibasset = _borrowerAmount.mul(_commissionRate).div(1000);                          
315         } else if (contractType == 2) {
316             _commissionRate = factory.checkParameter("lenderCommission");                      
317             address tokenAddr = factory.checkToken(borrowerId);
318             require(tokenAddr != address(0x0000000000000000000000000000000000000000));
319             Token = ERC20(tokenAddr);
320             _ibasset = _lenderAmount.mul(_commissionRate).div(1000);                          
321         } else if (contractType == 3) {
322             _commissionRate = 0;
323             address tokenAddr = factory.checkToken(lenderId);
324             require(tokenAddr != address(0x0000000000000000000000000000000000000000));
325             lenderToken = ERC20(tokenAddr);
326             address token = factory.checkToken(borrowerId);
327             require(token != address(0x0000000000000000000000000000000000000000));
328             Token = ERC20(token);
329             _ibasset = 0;
330         }
331     }
332 
333     function setcontractType(uint256 borrowerId, uint256 lenderId) private {
334         if (borrowerId == 0) {
335             contractType = 1;
336         } else if (lenderId == 0) {
337             contractType = 2;
338         } else {
339             contractType = 3;
340         }
341     }
342     
343     function mortgagedAssets() public payable onlyBorrower onlyFactory {
344         require(isContract(address(tx.origin)) == false);   
345         require(showContractState() == 0);
346         require(address(tx.origin) == _borrower);   
347         if (contractType == 1) {
348             require(msg.value == checkAllEth());
349         } else {
350             require(msg.value == 0);
351             uint256 money = _borrowerAmount;
352             require(Token.balanceOf(address(tx.origin)) >= money);
353             require(Token.allowance(address(tx.origin), address(this)) >= money);
354             Token.transferFrom(address(tx.origin),address(this),money);         
355             require(Token.balanceOf(address(this)) >= _borrowerAmount);
356         }
357         _contractState = 1;
358     }
359     
360     function sendRepayment() public payable onlyBorrower onlyFactory {
361         require(isContract(address(tx.origin)) == false);   
362         if (contractType == 2) {
363             require(msg.value == _borrowerPayable);
364             repayEth(address(_lender), msg.value);
365             repayToken(address(_borrower), _borrowerAmount);
366         } else {
367             require(msg.value == 0);
368             require(lenderToken.balanceOf(tx.origin) >= _borrowerPayable);
369             require(lenderToken.allowance(address(tx.origin), address(this)) >= _borrowerPayable);
370             lenderToken.transferFrom(address(tx.origin),_lender,_borrowerPayable);
371             if (contractType == 1) {
372                 repayEth(address(_borrower), _borrowerAmount);
373             } else if (contractType == 3) {
374                 repayToken(address(_borrower), _borrowerAmount);
375             }
376         }
377         _contractState = 3;                                 
378         _endTime = now;                                     
379     }
380  
381     function sendLendAsset() public payable onlyFactory{
382         require(isContract(address(tx.origin)) == false);   
383         require(showContractState() == 1);
384         _lender = tx.origin;                            
385         _contractState = 2;                             
386         _expireDate = now + _timeLimit;                 
387         _investmentTime = now;                          
388         serviceChargeMining();
389     }
390     
391     function serviceChargeMining() private {
392         if (contractType == 2) {
393             NEST_LoanMachinery mining = NEST_LoanMachinery(mappingContract.checkAddress("toLoanBorrowMining"));
394             require(_ibasset > 0);
395             require(address(this).balance >= _lenderAmount);
396             uint256 _lenderasset = _lenderAmount.sub(_ibasset);
397             require(_lenderasset > 0);
398             repayEth(address(_borrower),_lenderasset);
399             mining.startMining.value(_ibasset)(_borrower, _lender, address(Token), _interest, _timeLimit.div(1 days));
400         } else {
401             NEST_LoanMachinery mining = NEST_LoanMachinery(mappingContract.checkAddress("toMortgageBorrowMining"));
402             require(lenderToken.balanceOf(tx.origin) >= _lenderAmount);
403             require(lenderToken.allowance(address(tx.origin), address(this)) >= _lenderAmount);
404             lenderToken.transferFrom(address(tx.origin),_borrower,_lenderAmount);
405             if (contractType == 1) {
406                 require(_ibasset > 0);
407                 mining.startMining.value(_ibasset)(_borrower, _lender, address(Token), _interest, _timeLimit.div(1 days));
408             }
409         }
410     }
411     
412     function cancelContract() public onlyBorrower{
413         require(isContract(address(tx.origin)) == false);   
414         require(showContractState() == 1);
415         if (contractType == 1) {
416             if(address(this).balance > 0) {
417                 repayEth(_borrower,_borrowerAmount.add(_ibasset));
418             }
419         } else {
420             if(Token.balanceOf(address(this)) > 0) {
421                 repayToken(_borrower, _borrowerAmount);
422             }
423         }
424         _contractState = 0;                            
425     }
426     
427     function applyForAssets() public onlyLender {
428         require(isContract(address(tx.origin)) == false);   
429         require(showContractState() == 4);              
430         if (contractType == 1) {
431             repayEth(_lender, _borrowerAmount);        
432         } else {
433             repayToken(_lender,_borrowerAmount);      
434         }
435         _contractState = 5;                             
436         _endTime = now;                                 
437     }
438     
439     function showContractState() public view returns(uint256) {
440         if (_contractState == 2 && now >_expireDate){
441             return 4;
442         }
443         return _contractState;
444     }
445     
446     function repayEth(address accountAddress, uint256 asset) internal {
447         address payable addr = accountAddress.make_payable();
448         addr.transfer(asset);
449     }
450 
451     function repayToken(address accountAddress, uint256 asset) internal {
452         Token.transfer(accountAddress, asset);
453     }
454     
455     function checkLender() public view returns (address) {
456         return _lender;
457     }
458 
459     function checkBorrower() public view returns (address) {
460         return _borrower;
461     }
462 
463     function checkAllEth()public view returns (uint256) {
464         uint256 amount = _borrowerAmount.mul(_commissionRate).div(1000);
465         return _borrowerAmount.add(amount);
466     }
467 
468     function checkContractType()public view returns (uint256) {
469         return contractType;
470     }
471 
472     modifier onlyBorrower(){
473         require(address(tx.origin) == _borrower);
474         _;
475     }
476 
477     modifier onlyLender(){
478         require(address(tx.origin) == _lender);
479         _;
480     }
481     
482     modifier onlyFactory(){
483         require(address(mappingContract.checkAddress("toLoanFactory")) == address(msg.sender));
484         _;
485     }
486 
487     function getContractInfo() public view returns(
488     uint256 state,
489     address borrowerAddress,
490     address investorAddress,
491     uint256 amount,
492     uint256 cycle,
493     uint256 interest,
494     uint256 mortgage,
495     uint256 investmentTime,
496     uint256 endtime,
497     uint256 borrowerPayable,
498     uint256 expiryTime,
499     uint256 createTime,
500     uint256 ibasset) {
501         return (
502         showContractState(),
503         _borrower,
504         _lender,
505         _lenderAmount,
506         _timeLimit,
507         _interest,
508         _borrowerAmount,
509         _investmentTime,
510         _endTime,
511         _borrowerPayable,
512         _expireDate,
513         _createTime,
514         _ibasset);
515     }
516 
517     function getTokenInfo() public view returns (
518         uint256 _contractType,
519         address borrowerToken,
520         address _lenderToken
521         ) {
522             return (
523                 contractType,
524                 address(Token),
525                 address(lenderToken)
526                 );
527     }
528     
529     function checkVersion() public view returns(uint256) {
530         return version;
531     }
532     
533     function isContract(address addr) public view returns (bool) {
534         uint size;
535         assembly { size := extcodesize(addr) }
536         return size > 0;
537     }
538     
539 }