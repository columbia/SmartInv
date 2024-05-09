1 pragma solidity ^0.5.8;
2 
3 contract IBNEST {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf( address who ) public view returns (uint value);
6     function allowance( address owner, address spender ) public view returns (uint _allowance);
7 
8     function transfer( address to, uint256 value) external;
9     function transferFrom( address from, address to, uint value) public returns (bool ok);
10     function approve( address spender, uint value ) public returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14     
15     function balancesStart() public view returns(uint256);
16     function balancesGetBool(uint256 num) public view returns(bool);
17     function balancesGetNext(uint256 num) public view returns(uint256);
18     function balancesGetValue(uint256 num) public view returns(address, uint256);
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (_a == 0) {
31       return 0;
32     }
33 
34     c = _a * _b;
35     assert(c / _a == _b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     assert(_b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = _a / _b;
45     assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
46     return _a / _b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     assert(_b <= _a);
54     return _a - _b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
61     c = _a + _b;
62     assert(c >= _a);
63     return c;
64   }
65 }
66 
67 contract IBMapping {
68     function checkAddress(string memory name) public view returns (address contractAddress);
69     function checkOwners(address man) public view returns (bool);
70 }
71 
72 library address_make_payable {
73    function make_payable(address x) internal pure returns (address payable) {
74       return address(uint160(x));
75    }
76 }
77 
78 /**
79  * @title Nest storage contract
80  */
81 contract NESTSave {
82     using SafeMath for uint256;
83     mapping (address => uint256) baseMapping;                   //  General ledger
84     IBNEST nestContract;                                        //  Nest contract
85     IBMapping mappingContract;                                  //  Mapping contract 
86     
87     /**
88     * @dev Initialization method
89     * @param map Mapping contract address
90     */
91     constructor(address map) public {
92         mappingContract = IBMapping(map); 
93         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
94     }
95     
96     /**
97     * @dev Change mapping contract
98     * @param map Mapping contract address
99     */
100     function changeMapping(address map) public onlyOwner{
101         mappingContract = IBMapping(map); 
102         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
103     }
104     
105     /**
106     * @dev Take out nest
107     * @param num Quantity taken out
108     */
109     function takeOut(uint256 num) public onlyContract {
110         require(isContract(address(tx.origin)) == false);          
111         require(num <= baseMapping[tx.origin]);
112         baseMapping[address(tx.origin)] = baseMapping[address(tx.origin)].sub(num);
113         nestContract.transfer(address(tx.origin), num);
114     }
115     
116     /**
117     * @dev Deposit in nest
118     * @param num Deposit quantity
119     */
120     function depositIn(uint256 num) public onlyContract {
121         require(isContract(address(tx.origin)) == false);                               
122         require(nestContract.balanceOf(address(tx.origin)) >= num);                     
123         require(nestContract.allowance(address(tx.origin), address(this)) >= num);      
124         require(nestContract.transferFrom(address(tx.origin),address(this),num));       
125         baseMapping[address(tx.origin)] = baseMapping[address(tx.origin)].add(num);
126     }
127     
128     /**
129     * @dev Take out all
130     */
131     function takeOutPrivate() public {
132         require(isContract(address(msg.sender)) == false);          
133         require(baseMapping[msg.sender] > 0);
134         nestContract.transfer(address(msg.sender), baseMapping[msg.sender]);
135         baseMapping[address(msg.sender)] = 0;
136     }
137     
138     function checkAmount(address sender) public view returns(uint256) {
139         return baseMapping[address(sender)];
140     }
141     
142     modifier onlyOwner(){
143         require(mappingContract.checkOwners(msg.sender) == true);
144         _;
145     }
146     
147     modifier onlyContract(){
148         require(mappingContract.checkAddress("nestAbonus") == msg.sender);
149         _;
150     }
151 
152     function isContract(address addr) public view returns (bool) {
153         uint size;
154         assembly { size := extcodesize(addr) }
155         return size > 0;
156     }
157 }
158 
159 /**
160  * @title Dividend pool contract
161  */
162 contract Abonus {
163     using address_make_payable for address;
164     IBMapping mappingContract;                                  //  Mapping contract
165     
166     /**
167     * @dev Initialization method
168     * @param map Mapping contract address
169     */
170     constructor(address map) public {
171         mappingContract = IBMapping(map);
172     }
173     
174     /**
175     * @dev Change mapping contract
176     * @param map Mapping contract address
177     */
178     function changeMapping(address map) public onlyOwner{
179         mappingContract = IBMapping(map);
180     }
181     
182     /**
183     * @dev Draw ETH
184     * @param num Draw amount
185     * @param target Transfer target
186     */
187     function getETH(uint256 num, address target) public onlyContract {
188         require(num <= getETHNum());
189         address payable addr = target.make_payable();
190         addr.transfer(num);                                                                              
191     }
192     
193     function getETHNum() public view returns (uint256) {
194         return address(this).balance;
195     }
196     
197     modifier onlyContract(){
198         require(mappingContract.checkAddress("nestAbonus") == msg.sender);
199         _;
200     }
201 
202     modifier onlyOwner(){
203         require(mappingContract.checkOwners(msg.sender) == true);
204         _;
205     }
206 
207     function () external payable {
208         
209     }
210 }
211 
212 /**
213  * @title Leveling contract
214  */
215 contract NESTLeveling {
216     using address_make_payable for address;
217     IBMapping mappingContract;                              //  Mapping contract
218 
219     /**
220     * @dev Initialization method
221     * @param map Mapping contract address
222     */
223     constructor (address map) public {
224         mappingContract = IBMapping(map); 
225     }
226     
227     /**
228     * @dev Change mapping contract
229     * @param map Mapping contract address
230     */
231     function changeMapping(address map) public onlyOwner {
232         mappingContract = IBMapping(map); 
233     }
234     
235     /**
236     * @dev Transfer ETH
237     * @param amount Transfer quantity
238     * @param target Transfer target
239     */
240     function tranEth(uint256 amount, address target) public {
241         require(address(msg.sender) == address(mappingContract.checkAddress("nestAbonus")));
242         uint256 tranAmount = amount;
243         if (amount > address(this).balance) {
244             tranAmount = address(this).balance;
245         }
246         address payable addr = target.make_payable();
247         addr.transfer(tranAmount);
248     }
249     
250     function () external payable {
251         
252     }
253     
254     modifier onlyOwner(){
255         require(mappingContract.checkOwners(msg.sender) == true);
256         _;
257     }
258 }
259 
260 /**
261  * @title Dividend logical contract
262  */
263 contract NESTAbonus {
264     using address_make_payable for address;
265     using SafeMath for uint256;
266     IBNEST nestContract;
267     IBMapping mappingContract;                  
268     NESTSave baseMapping;
269     Abonus abonusContract;
270     NESTLeveling nestLeveling;
271     uint256 timeLimit = 168 hours;                                  //  Dividend period
272     uint256 nextTime = 1587700800;                                  //  Next dividend time
273     uint256 getAbonusTimeLimit = 60 hours;                          //  Trigger calculation settlement time
274     uint256 ethNum = 0;                                             //  ETH amount
275     uint256 nestAllValue = 0;                                       //  Nest circulation
276     uint256 times = 0;                                              //  Dividend book
277     uint256 expectedIncrement = 3;                                  //  Expected dividend increment proportion
278     uint256 expectedMinimum = 100 ether;                            //  Expected minimum dividend
279     uint256 levelingProportion = 10;                                //  Proportion of dividends deducted
280     mapping(uint256 => mapping(address => bool)) getMapping;        //  Dividend collection record
281 
282     /**
283     * @dev Initialization method
284     * @param map Mapping contract address
285     */
286     constructor (address map) public {
287         mappingContract = IBMapping(map); 
288         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
289         baseMapping = NESTSave(address(mappingContract.checkAddress("nestSave")));
290         address payable addr = address(mappingContract.checkAddress("abonus")).make_payable();
291         abonusContract = Abonus(addr);
292         address payable levelingAddr = address(mappingContract.checkAddress("nestLeveling")).make_payable();
293         nestLeveling = NESTLeveling(levelingAddr);
294     }
295     
296     /**
297     * @dev Change mapping contract
298     * @param map Mapping contract address
299     */
300     function changeMapping(address map) public onlyOwner {
301         mappingContract = IBMapping(map); 
302         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
303         baseMapping = NESTSave(address(mappingContract.checkAddress("nestSave")));
304         address payable addr = address(mappingContract.checkAddress("abonus")).make_payable();
305         abonusContract = Abonus(addr);
306         address payable levelingAddr = address(mappingContract.checkAddress("nestLeveling")).make_payable();
307         nestLeveling = NESTLeveling(levelingAddr);
308     }
309     
310     /**
311     * @dev Deposit in nest
312     * @param amount Deposit quantity
313     */
314     function depositIn(uint256 amount) public {
315         require(address(tx.origin) == address(msg.sender));         
316         uint256 nowTime = now;
317         if (nowTime < nextTime) {
318             require(!(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit)));
319         } else {
320             require(!(nowTime >= nextTime && nowTime <= nextTime.add(getAbonusTimeLimit)));
321             uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
322             uint256 startTime = nextTime.add((time).mul(timeLimit));        
323             uint256 endTime = startTime.add(getAbonusTimeLimit);        
324             require(!(nowTime >= startTime && nowTime <= endTime));
325         }
326         baseMapping.depositIn(amount);                           
327     }
328     
329     /**
330     * @dev Take out nest
331     * @param amount Quantity taken out
332     */
333     function takeOut(uint256 amount) public {
334         require(address(tx.origin) == address(msg.sender));          
335         require(amount != 0);                                      
336         require(amount <= baseMapping.checkAmount(address(msg.sender)));
337         baseMapping.takeOut(amount);                           
338     }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
339     
340     /**
341     * @dev Receive dividend
342     */
343     function getETH() public {
344         require(address(tx.origin) == address(msg.sender));        
345         reloadTimeAndMapping ();            
346         uint256 nowTime = now;
347         require(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit));
348         require(getMapping[times.sub(1)][address(msg.sender)] != true);       
349         uint256 nestAmount = baseMapping.checkAmount(address(msg.sender));
350         require(nestAmount > 0);
351         require(nestAllValue > 0);
352         uint256 selfEth = nestAmount.mul(ethNum).div(nestAllValue);
353         require(selfEth > 0);
354         getMapping[times.sub(1)][address(msg.sender)] = true;
355         abonusContract.getETH(selfEth, address(msg.sender));                        
356     }
357     
358     function levelingResult() private {
359         abonusContract.getETH(abonusContract.getETHNum().mul(levelingProportion).div(100), address(nestLeveling));
360         uint256 miningAmount = allValue().div(100000000 ether);
361         uint256 minimumAbonus = expectedMinimum;
362         for (uint256 i = 0; i < miningAmount; i++) {
363             minimumAbonus = minimumAbonus.add(minimumAbonus.mul(expectedIncrement).div(100));
364         }
365         uint256 nowEth = abonusContract.getETHNum();
366         if (nowEth < minimumAbonus) {
367             nestLeveling.tranEth(minimumAbonus.sub(nowEth), address(abonusContract));
368         }
369     }
370     
371     function reloadTimeAndMapping() private {
372         uint256 nowTime = now;
373         if (nowTime >= nextTime) {                                          
374             levelingResult();
375             uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
376             uint256 startTime = nextTime.add((time).mul(timeLimit));      
377             uint256 endTime = startTime.add(getAbonusTimeLimit);           
378             if (nowTime >= startTime && nowTime <= endTime) {
379                 nextTime = getNextTime();                                   
380                 times = times.add(1);                                   
381                 ethNum = abonusContract.getETHNum();                    
382                 nestAllValue = allValue();                              
383             }
384         }
385     }
386     
387     function getInfo() public view returns (uint256 _nextTime, uint256 _getAbonusTime, uint256 _ethNum, uint256 _nestValue, uint256 _myJoinNest, uint256 _getEth, uint256 _allowNum, uint256 _leftNum, bool allowAbonus)  {
388         uint256 nowTime = now;
389         if (nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit)) {
390             allowAbonus = getMapping[times.sub(1)][address(msg.sender)];
391             _ethNum = ethNum;
392             _nestValue = nestAllValue;
393         } else {
394             _ethNum = abonusContract.getETHNum();
395             _nestValue = allValue();
396             allowAbonus = getMapping[times][address(msg.sender)];
397         }
398         _myJoinNest = baseMapping.checkAmount(address(msg.sender));
399         if (allowAbonus == true) {
400             _getEth = 0; 
401         } else {
402             _getEth = _myJoinNest.mul(_ethNum).div(_nestValue);
403         }
404         _nextTime = getNextTime();
405         _getAbonusTime = _nextTime.sub(timeLimit).add(getAbonusTimeLimit);
406         _allowNum = nestContract.allowance(address(msg.sender), address(baseMapping));
407         _leftNum = nestContract.balanceOf(address(msg.sender));
408     }
409     
410     function getNextTime() public view returns (uint256) {
411         uint256 nowTime = now;
412         if (nextTime > nowTime) { 
413             return nextTime; 
414         } else {
415             uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
416             return nextTime.add(timeLimit.mul(time.add(1)));
417         }
418     }
419     
420     function allValue() public view returns (uint256) {
421         uint256 all = 10000000000 ether;
422         uint256 leftNum = all.sub(nestContract.balanceOf(address(mappingContract.checkAddress("miningSave"))));
423         return leftNum;
424     }
425 
426     function checkTimeLimit() public view returns(uint256) {
427         return timeLimit;
428     }
429 
430     function checkGetAbonusTimeLimit() public view returns(uint256) {
431         return getAbonusTimeLimit;
432     }
433 
434     function checkMinimumAbonus() public view returns(uint256) {
435         uint256 miningAmount = allValue().div(100000000 ether);
436         uint256 minimumAbonus = expectedMinimum;
437         for (uint256 i = 0; i < miningAmount; i++) {
438             minimumAbonus = minimumAbonus.add(minimumAbonus.mul(expectedIncrement).div(100));
439         }
440         return minimumAbonus;
441     }
442 
443     function changeTimeLimit(uint256 hour) public onlyOwner {
444         require(hour > 0);
445         timeLimit = hour.mul(1 hours);
446     }
447 
448     function changeGetAbonusTimeLimit(uint256 hour) public onlyOwner {
449         require(hour > 0);
450         getAbonusTimeLimit = hour;
451     }
452 
453     function changeExpectedIncrement(uint256 num) public onlyOwner {
454         require(num > 0);
455         expectedIncrement = num;
456     }
457 
458     function changeExpectedMinimum(uint256 num) public onlyOwner {
459         require(num > 0);
460         expectedMinimum = num;
461     }
462 
463     function changeLevelingProportion(uint256 num) public onlyOwner {
464         require(num > 0);
465         levelingProportion = num;
466     }
467 
468     modifier onlyOwner(){
469         require(mappingContract.checkOwners(msg.sender) == true);
470         _;
471     }
472 
473 }