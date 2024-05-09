1 pragma solidity ^0.5.6;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */ 
7 library SafeMath{
8     function mul(uint a, uint b) internal pure returns (uint){
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13  
14     function div(uint a, uint b) internal pure returns (uint){
15         uint c = a / b;
16         return c;
17     }
18  
19     function sub(uint a, uint b) internal pure returns (uint){
20         assert(b <= a); 
21         return a - b; 
22     } 
23   
24     function add(uint a, uint b) internal pure returns (uint){ 
25         uint c = a + b; assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36     address public owner;
37  
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39  
40     constructor() public{
41         owner = msg.sender;
42     }
43  
44    /**
45     * @dev Throws if called by any account other than the owner.
46     */ 
47    modifier onlyOwner(){
48         require(msg.sender == owner);
49         _;
50     }
51  
52    /**
53     * @dev Allows the current owner to transfer control of the contract to a newOwner.
54     * @param newOwner The address to transfer ownership to.
55     */ 
56    function transferOwnership(address newOwner) onlyOwner public{
57         require(newOwner != address(0));
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60     }
61 }
62 
63 /**
64  * @title ITCMoney token
65  * @dev ERC20 Token implementation, with mintable and its own specific
66  */
67 contract ITCMoney is Ownable{
68     using SafeMath for uint;
69     
70     string public constant name = "ITC Money";
71     string public constant symbol = "ITCM";
72     uint32 public constant decimals = 18;
73     
74     address payable public companyAddr = address(0);
75     address public constant bonusAddr   = 0xaEA6949B27C44562Dd446c2C44f403cF6D13a2fD;
76     address public constant teamAddr    = 0xe0b70c54a1baa2847e210d019Bb8edc291AEA5c7;
77     address public constant sellerAddr  = 0x95E1f32981F909ce39d45bF52C9108f47e0FCc50;
78     
79     uint public totalSupply = 0;
80     uint public maxSupply = 17000000000 * 1 ether; // Maximum of tokens to be minted. 1 ether multiplier is decimal.
81     mapping(address => uint) balances;
82     mapping (address => mapping (address => uint)) internal allowed;
83     
84     bool public transferAllowed = false;
85     mapping(address => bool) internal customTransferAllowed;
86     
87     uint public tokenRate = 170 * 1 finney; // Start token rate * 10000 (0.017 CHF * 10000). 1 finney multiplier is for decimal.
88     uint private tokenRateDays = 0;
89     // growRate is the sequence of periods and percents of rate grow. First element is timestamp of period start. Second is grow percent * 10000.
90     uint[2][] private growRate = [
91         [1538784000, 100],
92         [1554422400,  19],
93         [1564617600,  17],
94         [1572566400,   0]
95     ];
96     
97     uint public rateETHCHF = 0;
98     mapping(address => uint) balancesCHF;
99     bool public amountBonusAllowed = true;
100     // amountBonus describes the token bonus that depends from CHF amount. First element is minimum accumulated CHF amount. Second one is bonus percent * 100.
101     uint[2][] private amountBonus = [
102         [uint32(2000),    500],
103         [uint32(8000),    700],
104         [uint32(17000),  1000],
105         [uint32(50000),  1500],
106         [uint32(100000), 1750],
107         [uint32(150000), 2000],
108         [uint32(500000), 2500]
109     ];
110     
111     // timeBonus describes the token bonus that depends from date. First element is the timestamp of start date. Second one is bonus percent * 100.
112     uint[2][] private timeBonus = [
113         [1535673600, 2000], // 2018-08-31
114         [1535760000, 1800], // 2018-09-01
115         [1538784000, 1500], // 2018-10-06
116         [1541462400, 1000], // 2018-11-06
117         [1544054400,  800], // 2018-12-06
118         [1546732800,  600], // 2019-01-06
119         [1549411200,  300], // 2019-02-06
120         [1551830400,  200]  // 2019-03-06
121     ];
122     uint private finalTimeBonusDate = 1554508800; // 2019-04-06. No bonus tokens after this date.
123     uint public constantBonus = 0;
124 
125     event Transfer(address indexed from, address indexed to, uint value);
126     event Approval(address indexed owner, address indexed spender, uint value);
127     event CompanyChanged(address indexed previousOwner, address indexed newOwner);
128     event TransfersAllowed();
129     event TransfersAllowedTo(address indexed to);
130     event CHFBonusStopped();
131     event AddedCHF(address indexed to, uint value);
132     event NewRateCHF(uint value);
133     event AddedGrowPeriod(uint startTime, uint rate);
134     event ConstantBonus(uint value);
135     event NewTokenRate(uint tokenRate);
136 
137     /** 
138      * @dev Gets the balance of the specified address.
139      * @param _owner The address to query the the balance of.
140      * @return An uint256 representing the amount owned by the passed address.
141      */
142     function balanceOf(address _owner) public view returns (uint){
143         return balances[_owner];
144     }
145  
146     /**
147      * @dev Transfer token for a specified address
148      * @param _to The address to transfer to.
149      * @param _value The amount to be transferred.
150      */ 
151     function transfer(address _to, uint _value) public returns (bool){
152         require(_to != address(0));
153         require(transferAllowed || _to == sellerAddr || customTransferAllowed[msg.sender]);
154         require(_value > 0 && _value <= balances[msg.sender]);
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true; 
159     } 
160 
161     /**
162      * @dev Transfer tokens from one address to another
163      * @param _from address The address which you want to send tokens from
164      * @param _to address The address which you want to transfer to
165      * @param _value uint256 the amount of tokens to be transferred
166      */ 
167     function transferFrom(address _from, address _to, uint _value) public returns (bool){
168         require(_to != address(0));
169         require(transferAllowed || _to == sellerAddr || customTransferAllowed[_from]);
170         require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         emit Transfer(_from, _to, _value);
175         return true;
176     }
177  
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      * @param _spender The address which will spend the funds.
181      * @param _value The amount of tokens to be spent.
182      */
183     function approve(address _spender, uint _value) public returns (bool){
184         allowed[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188  
189     /** 
190      * @dev Function to check the amount of tokens that an owner allowed to a spender.
191      * @param _owner address The address which owns the funds.
192      * @param _spender address The address which will spend the funds.
193      * @return A uint256 specifying the amount of tokens still available for the spender.
194      */
195     function allowance(address _owner, address _spender) public view returns (uint){
196         return allowed[_owner][_spender]; 
197     } 
198  
199     /**
200      * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.
201      * @param _spender The address which will spend the funds.
202      * @param _addedValue The amount of tokens to be spent.
203      */
204     function increaseApproval(address _spender, uint _addedValue) public returns (bool){
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
207         return true; 
208     }
209  
210     /**
211      * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.
212      * @param _spender The address which will spend the funds.
213      * @param _subtractedValue The amount of tokens to be spent.
214      */
215     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
216         uint oldValue = allowed[msg.sender][_spender];
217         if(_subtractedValue > oldValue){
218             allowed[msg.sender][_spender] = 0;
219         }else{
220             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221         }
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225     
226     /**
227      * @dev Function changes the company address. Ether moves to company address from contract.
228      * @param newCompany New company address.
229      */
230     function changeCompany(address payable newCompany) onlyOwner public{
231         require(newCompany != address(0));
232         emit CompanyChanged(companyAddr, newCompany);
233         companyAddr = newCompany;
234     }
235 
236     /**
237      * @dev Allow ITCM token transfer for each address.
238      */
239     function allowTransfers() onlyOwner public{
240         transferAllowed = true;
241         emit TransfersAllowed();
242     }
243  
244     /**
245      * @dev Allow ITCM token transfer for spcified address.
246      * @param _to Address to which token transfers become allowed.
247      */
248     function allowCustomTransfers(address _to) onlyOwner public{
249         customTransferAllowed[_to] = true;
250         emit TransfersAllowedTo(_to);
251     }
252     
253     /**
254      * @dev Stop adding token bonus that depends from accumulative CHF amount.
255      */
256     function stopCHFBonus() onlyOwner public{
257         amountBonusAllowed = false;
258         emit CHFBonusStopped();
259     }
260     
261     /**
262      * @dev Emit new tokens and transfer from 0 to client address. This function will generate tokens for bonus and team addresses.
263      * @param _to The address to transfer to.
264      * @param _value The amount to be transferred.
265      */ 
266     function _mint(address _to, uint _value) private returns (bool){
267         // 3% of token amount to bonus address
268         uint bonusAmount = _value.mul(3).div(87);
269         // 10% of token amount to team address
270         uint teamAmount = _value.mul(10).div(87);
271         // Restore the total token amount
272         uint total = _value.add(bonusAmount).add(teamAmount);
273         
274         require(total <= maxSupply);
275         
276         maxSupply = maxSupply.sub(total);
277         totalSupply = totalSupply.add(total);
278         
279         balances[_to] = balances[_to].add(_value);
280         balances[bonusAddr] = balances[bonusAddr].add(bonusAmount);
281         balances[teamAddr] = balances[teamAddr].add(teamAmount);
282 
283         emit Transfer(address(0), _to, _value);
284         emit Transfer(address(0), bonusAddr, bonusAmount);
285         emit Transfer(address(0), teamAddr, teamAmount);
286 
287         return true;
288     }
289 
290     /**
291      * @dev This is wrapper for _mint.
292      * @param _to The address to transfer to.
293      * @param _value The amount to be transferred.
294      */ 
295     function mint(address _to, uint _value) onlyOwner public returns (bool){
296         return _mint(_to, _value);
297     }
298 
299     /**
300      * @dev Similar to mint function but take array of addresses and values.
301      * @param _to The addresses to transfer to.
302      * @param _value The amounts to be transferred.
303      */ 
304     function mint(address[] memory _to, uint[] memory _value) onlyOwner public returns (bool){
305         require(_to.length == _value.length);
306 
307         uint len = _to.length;
308         for(uint i = 0; i < len; i++){
309             if(!_mint(_to[i], _value[i])){
310                 return false;
311             }
312         }
313         return true;
314     }
315     
316     /** 
317      * @dev Gets the accumulative CHF balance of the specified address.
318      * @param _owner The address to query the the CHF balance of.
319      * @return An uint256 representing the amount owned by the passed address.
320      */
321     function balanceCHFOf(address _owner) public view returns (uint){
322         return balancesCHF[_owner];
323     }
324 
325     /** 
326      * @dev Increase CHF amount for address to which the tokens were minted.
327      * @param _to Target address.
328      * @param _value The amount of CHF.
329      */
330     function increaseCHF(address _to, uint _value) onlyOwner public{
331         balancesCHF[_to] = balancesCHF[_to].add(_value);
332         emit AddedCHF(_to, _value);
333     }
334 
335     /** 
336      * @dev Increase CHF amounts for addresses to which the tokens were minted.
337      * @param _to Target addresses.
338      * @param _value The amounts of CHF.
339      */
340     function increaseCHF(address[] memory _to, uint[] memory _value) onlyOwner public{
341         require(_to.length == _value.length);
342 
343         uint len = _to.length;
344         for(uint i = 0; i < len; i++){
345             balancesCHF[_to[i]] = balancesCHF[_to[i]].add(_value[i]);
346             emit AddedCHF(_to[i], _value[i]);
347         }
348     }
349  
350     /** 
351      * @dev Sets the rate ETH to CHF that represents UINT (rate * 10000).
352      * @param _rate ETH CHF rate * 10000.
353      */
354     function setETHCHFRate(uint _rate) onlyOwner public{
355         rateETHCHF = _rate;
356         emit NewRateCHF(_rate);
357     }
358     
359     /** 
360      * @dev Set new period and grow percent at the day.
361      * @param _startTime timestamp when the rate will start grow.
362      * @param _rate Grow percent * 10000.
363      */
364     function addNewGrowRate(uint _startTime, uint _rate) onlyOwner public{
365         growRate.push([_startTime, _rate]);
366         emit AddedGrowPeriod(_startTime, _rate);
367     }
368  
369     /** 
370      * @dev Set constant token bonus for each address that applies in fallback.
371      * @param _value Grow percent * 100.
372      */
373     function setConstantBonus(uint _value) onlyOwner public{
374         constantBonus = _value;
375         emit ConstantBonus(_value);
376     }
377 
378     /** 
379      * @dev Calculate and store current token rate.
380      *      The rate grows every day per percent that is shown in growRate starting from timestamp that was set for the rate.
381      */
382     function getTokenRate() public returns (uint){
383         uint startTokenRate = tokenRate;
384         uint totalDays = 0;
385         uint len = growRate.length;
386         // For each period from growRate
387         for(uint i = 0; i < len; i++){
388             if(now > growRate[i][0] && growRate[i][1] > 0){
389                 // The final date is minimum from now and next period date
390                 uint end = now;
391                 if(i + 1 < len && end > growRate[i + 1][0]){
392                     end = growRate[i + 1][0];
393                 }
394                 uint dateDiff = (end - growRate[i][0]) / 1 days;
395                 totalDays = totalDays + dateDiff;
396                 // Check if the rate calculation required
397                 if(dateDiff > 0 && totalDays > tokenRateDays){
398                     // Calculate and store the rate.
399                     // This is like rate * (100+percent)**days but memory safe.
400                     for(uint ii = tokenRateDays; ii < totalDays; ii++){
401                         tokenRate = tokenRate * (10000 + growRate[i][1]) / 10000;
402                     }
403                     tokenRateDays = totalDays;
404                 }
405             }
406         }
407         if(startTokenRate != tokenRate){
408             emit NewTokenRate(tokenRate);
409         }
410         return tokenRate;
411     }
412     
413     /** 
414      * @dev Function that receives the ether, transfers it to company address and mints tokens to address that initiates payment. Company, bonus and team addresses gets the tokens as well.
415      */
416     function () external payable {
417         // Revert if there are no basic parameters
418         require(msg.data.length == 0);
419         require(msg.value > 0);
420         require(rateETHCHF > 0);
421         
422         // Calculate token amount (amount of CHF / current rate). Remember that token rate is multiplied by 1 finney, add the same multiplier for ether amount.
423         uint amount = (msg.value * rateETHCHF * 1 finney) / getTokenRate();
424         // Calculate CHF amount analogue, then store it for customer.
425         uint amountCHF = (msg.value * rateETHCHF) / 10000 / 1 ether;
426         uint totalCHF = balancesCHF[msg.sender].add(amountCHF);
427         emit AddedCHF(msg.sender, amountCHF);
428 
429         // Get the bonus percent that depends from time or its constant.
430         uint len = 0;
431         uint i = 0;
432         uint percent = 0;
433         uint bonus = 0;
434         if(constantBonus > 0){
435             bonus = amount.mul(constantBonus).div(10000);
436         }else if(now < finalTimeBonusDate){
437             len = timeBonus.length;
438             percent = 0;
439             for(i = 0; i < len; i++){
440                 if(now >= timeBonus[i][0]){
441                     percent = timeBonus[i][1];
442                 }else{
443                     break;
444                 }
445             }
446             if(percent > 0){
447                 bonus = amount.mul(percent).div(10000);
448             }
449         }
450 
451         // Add the bonus that depends from accumulated CHF amount
452         if(amountBonusAllowed){
453             len = amountBonus.length;
454             percent = 0;
455             for(i = 0; i < len; i++){
456                 if(totalCHF >= amountBonus[i][0]){
457                     percent = amountBonus[i][1];
458                 }else{
459                     break;
460                 }
461             }
462             if(percent > 0){
463                 bonus = bonus.add(amount.mul(percent).div(10000));
464             }
465         }
466         
467         amount = amount.add(bonus);
468         
469         // 3% of token amount to bonus address
470         uint bonusAmount = amount.mul(3).div(87);
471         // 10% of token amount to team address
472         uint teamAmount = amount.mul(10).div(87);
473         // Restore the total token amount
474         uint total = amount.add(bonusAmount).add(teamAmount);
475         
476         require(total <= maxSupply);
477         
478         maxSupply = maxSupply.sub(total);
479         totalSupply = totalSupply.add(total);
480         
481         balances[msg.sender] = balances[msg.sender].add(amount);
482         balancesCHF[msg.sender] = totalCHF;
483         balances[bonusAddr] = balances[bonusAddr].add(bonusAmount);
484         balances[teamAddr] = balances[teamAddr].add(teamAmount);
485 
486         companyAddr.transfer(msg.value);
487         
488         emit Transfer(address(0), msg.sender, amount);
489         emit Transfer(address(0), bonusAddr, bonusAmount);
490         emit Transfer(address(0), teamAddr, teamAmount);
491     }
492 }