1 pragma solidity ^0.5.10;
2 
3 /**
4  * @title Guardian node nest storage
5  */
6 contract NEST_NodeSave {
7     IBMapping mappingContract;                      
8     IBNEST nestContract;                             
9     
10     /**
11     * @dev Initialization method
12     * @param map Mapping contract address
13     */
14     constructor (address map) public {
15         mappingContract = IBMapping(address(map));              
16         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));            
17     }
18     
19     /**
20     * @dev Change mapping contract
21     * @param map Mapping contract address
22     */
23     function changeMapping(address map) public onlyOwner {
24         mappingContract = IBMapping(address(map));              
25         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));            
26     }
27     
28     /**
29     * @dev Transfer out nest
30     * @param amount Transfer out quantity
31     * @param to Transfer out target
32     * @return Actual transfer out quantity
33     */
34     function turnOut(uint256 amount, address to) public onlyMiningCalculation returns(uint256) {
35         uint256 leftNum = nestContract.balanceOf(address(this));
36         if (leftNum >= amount) {
37             nestContract.transfer(to, amount);
38             return amount;
39         } else {
40             return 0;
41         }
42     }
43     
44     modifier onlyOwner(){
45         require(mappingContract.checkOwners(msg.sender) == true);
46         _;
47     }
48 
49     modifier onlyMiningCalculation(){
50         require(address(mappingContract.checkAddress("nodeAssignment")) == msg.sender);
51         _;
52     }
53     
54 }
55 
56 /**
57  * @title Guardian node receives data
58  */
59 contract NEST_NodeAssignmentData {
60     using SafeMath for uint256;
61     IBMapping mappingContract;              
62     uint256 nodeAllAmount = 0;                                 
63     mapping(address => uint256) nodeLatestAmount;               
64     
65     /**
66     * @dev Initialization method
67     * @param map Mapping contract address
68     */
69     constructor (address map) public {
70         mappingContract = IBMapping(map); 
71     }
72     
73     /**
74     * @dev Change mapping contract
75     * @param map Mapping contract address
76     */
77     function changeMapping(address map) public onlyOwner{
78         mappingContract = IBMapping(map); 
79     }
80     
81     //  Add nest
82     function addNest(uint256 amount) public onlyNodeAssignment {
83         nodeAllAmount = nodeAllAmount.add(amount);
84     }
85     
86     //  View cumulative total
87     function checkNodeAllAmount() public view returns (uint256) {
88         return nodeAllAmount;
89     }
90     
91     //  Record last received quantity
92     function addNodeLatestAmount(address add ,uint256 amount) public onlyNodeAssignment {
93         nodeLatestAmount[add] = amount;
94     }
95     
96     //  View last received quantity
97     function checkNodeLatestAmount(address add) public view returns (uint256) {
98         return nodeLatestAmount[address(add)];
99     }
100     
101     modifier onlyOwner(){
102         require(mappingContract.checkOwners(msg.sender) == true);
103         _;
104     }
105     
106     modifier onlyNodeAssignment(){
107         require(address(msg.sender) == address(mappingContract.checkAddress("nodeAssignment")));
108         _;
109     }
110 }
111 
112 /**
113  * @title Guardian node assignment
114  */
115 contract NEST_NodeAssignment {
116     
117     using SafeMath for uint256;
118     IBMapping mappingContract;  
119     IBNEST nestContract;                                   
120     SuperMan supermanContract;                              
121     NEST_NodeSave nodeSave;
122     NEST_NodeAssignmentData nodeAssignmentData;
123 
124     /**
125     * @dev Initialization method
126     * @param map Mapping contract address
127     */
128     constructor (address map) public {
129         mappingContract = IBMapping(map); 
130         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
131         supermanContract = SuperMan(address(mappingContract.checkAddress("nestNode")));
132         nodeSave = NEST_NodeSave(address(mappingContract.checkAddress("nestNodeSave")));
133         nodeAssignmentData = NEST_NodeAssignmentData(address(mappingContract.checkAddress("nodeAssignmentData")));
134     }
135     
136     /**
137     * @dev Change mapping contract
138     * @param map Mapping contract address
139     */
140     function changeMapping(address map) public onlyOwner{
141         mappingContract = IBMapping(map); 
142         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
143         supermanContract = SuperMan(address(mappingContract.checkAddress("nestNode")));
144         nodeSave = NEST_NodeSave(address(mappingContract.checkAddress("nestNodeSave")));
145         nodeAssignmentData = NEST_NodeAssignmentData(address(mappingContract.checkAddress("nodeAssignmentData")));
146     }
147     
148     /**
149     * @dev Deposit in nest
150     * @param amount Quantity deposited in nest
151     */
152     function bookKeeping(uint256 amount) public {
153         require(amount > 0);
154         require(nestContract.balanceOf(address(msg.sender)) >= amount);
155         require(nestContract.allowance(address(msg.sender), address(this)) >= amount);
156         require(nestContract.transferFrom(address(msg.sender), address(nodeSave), amount));
157         nodeAssignmentData.addNest(amount);
158     }
159     
160     /**
161     * @dev Guardian node collection
162     */
163     function nodeGet() public {
164         require(address(msg.sender) == address(tx.origin));
165         require(supermanContract.balanceOf(address(msg.sender)) > 0);
166         uint256 allAmount = nodeAssignmentData.checkNodeAllAmount();
167         uint256 amount = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(msg.sender)));
168         uint256 getAmount = amount.mul(supermanContract.balanceOf(address(msg.sender))).div(1500);
169         require(nestContract.balanceOf(address(nodeSave)) >= getAmount);
170         nodeSave.turnOut(getAmount,address(msg.sender));
171         nodeAssignmentData.addNodeLatestAmount(address(msg.sender),allAmount);
172     }
173     
174     /**
175     * @dev Transfer settlement
176     * @param fromAdd Transfer out address
177     * @param toAdd Transfer in address
178     */
179     function nodeCount(address fromAdd, address toAdd) public {
180         require(address(supermanContract) == address(msg.sender));
181         require(supermanContract.balanceOf(address(fromAdd)) > 0);
182         uint256 allAmount = nodeAssignmentData.checkNodeAllAmount();
183         
184         uint256 amountFrom = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(fromAdd)));
185         uint256 getAmountFrom = amountFrom.mul(supermanContract.balanceOf(address(fromAdd))).div(1500);
186         require(nestContract.balanceOf(address(nodeSave)) >= getAmountFrom);
187         nodeSave.turnOut(getAmountFrom,address(fromAdd));
188         nodeAssignmentData.addNodeLatestAmount(address(fromAdd),allAmount);
189         
190         uint256 amountTo = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(toAdd)));
191         uint256 getAmountTo = amountTo.mul(supermanContract.balanceOf(address(toAdd))).div(1500);
192         require(nestContract.balanceOf(address(nodeSave)) >= getAmountTo);
193         nodeSave.turnOut(getAmountTo,address(toAdd));
194         nodeAssignmentData.addNodeLatestAmount(address(toAdd),allAmount);
195     }
196     
197     //  Amount available to the guardian node
198     function checkNodeNum() public view returns (uint256) {
199          uint256 allAmount = nodeAssignmentData.checkNodeAllAmount();
200          uint256 amount = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(msg.sender)));
201          uint256 getAmount = amount.mul(supermanContract.balanceOf(address(msg.sender))).div(1500);
202          return getAmount;
203     }
204     
205     modifier onlyOwner(){
206         require(mappingContract.checkOwners(msg.sender) == true);
207         _;
208     }
209 }
210 
211 
212 /**
213  * @title ERC20 interface
214  * @dev see https://github.com/ethereum/EIPs/issues/20
215  */
216 interface IERC20 {
217     function totalSupply() external view returns (uint256);
218 
219     function balanceOf(address who) external view returns (uint256);
220 
221     function allowance(address owner, address spender) external view returns (uint256);
222 
223     function transfer(address to, uint256 value) external returns (bool);
224 
225     function approve(address spender, uint256 value) external returns (bool);
226 
227     function transferFrom(address from, address to, uint256 value) external returns (bool);
228 
229     event Transfer(address indexed from, address indexed to, uint256 value);
230 
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232     
233 }
234 
235 /**
236  * @title Standard ERC20 token
237  *
238  * @dev Implementation of the basic standard token.
239  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
240  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
241  *
242  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
243  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
244  * compliant implementations may not do it.
245  */
246 contract SuperMan is IERC20 {
247     using SafeMath for uint256;
248 
249     mapping (address => uint256) private _balances;
250 
251     mapping (address => mapping (address => uint256)) private _allowed;
252     
253     IBMapping mappingContract;  //映射合约
254 
255     uint256 private _totalSupply = 1500;
256     string public name = "NestNode";
257     string public symbol = "NN";
258     uint8 public decimals = 0;
259 
260     constructor (address map) public {
261     	_balances[msg.sender] = _totalSupply;
262     	mappingContract = IBMapping(map); 
263     }
264     
265     function changeMapping(address map) public onlyOwner{
266         mappingContract = IBMapping(map);
267     }
268     
269     /**
270     * @dev Total number of tokens in existence
271     */
272     function totalSupply() public view returns (uint256) {
273         return _totalSupply;
274     }
275 
276     /**
277     * @dev Gets the balance of the specified address.
278     * @param owner The address to query the balance of.
279     * @return An uint256 representing the amount owned by the passed address.
280     */
281     function balanceOf(address owner) public view returns (uint256) {
282         return _balances[owner];
283     }
284 
285     /**
286      * @dev Function to check the amount of tokens that an owner allowed to a spender.
287      * @param owner address The address which owns the funds.
288      * @param spender address The address which will spend the funds.
289      * @return A uint256 specifying the amount of tokens still available for the spender.
290      */
291     function allowance(address owner, address spender) public view returns (uint256) {
292         return _allowed[owner][spender];
293     }
294 
295     /**
296     * @dev Transfer token for a specified address
297     * @param to The address to transfer to.
298     * @param value The amount to be transferred.
299     */
300     function transfer(address to, uint256 value) public returns (bool) {
301         _transfer(msg.sender, to, value);
302         return true;
303     }
304 
305     /**
306      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
307      * Beware that changing an allowance with this method brings the risk that someone may use both the old
308      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
309      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      * @param spender The address which will spend the funds.
312      * @param value The amount of tokens to be spent.
313      */
314     function approve(address spender, uint256 value) public returns (bool) {
315         require(spender != address(0));
316 
317         _allowed[msg.sender][spender] = value;
318         emit Approval(msg.sender, spender, value);
319         return true;
320     }
321 
322     /**
323      * @dev Transfer tokens from one address to another.
324      * Note that while this function emits an Approval event, this is not required as per the specification,
325      * and other compliant implementations may not emit the event.
326      * @param from address The address which you want to send tokens from
327      * @param to address The address which you want to transfer to
328      * @param value uint256 the amount of tokens to be transferred
329      */
330     function transferFrom(address from, address to, uint256 value) public returns (bool) {
331         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
332         _transfer(from, to, value);
333         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
334         return true;
335     }
336 
337     /**
338      * @dev Increase the amount of tokens that an owner allowed to a spender.
339      * approve should be called when allowed_[_spender] == 0. To increment
340      * allowed value is better to use this function to avoid 2 calls (and wait until
341      * the first transaction is mined)
342      * From MonolithDAO Token.sol
343      * Emits an Approval event.
344      * @param spender The address which will spend the funds.
345      * @param addedValue The amount of tokens to increase the allowance by.
346      */
347     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
348         require(spender != address(0));
349 
350         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
351         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
352         return true;
353     }
354 
355     /**
356      * @dev Decrease the amount of tokens that an owner allowed to a spender.
357      * approve should be called when allowed_[_spender] == 0. To decrement
358      * allowed value is better to use this function to avoid 2 calls (and wait until
359      * the first transaction is mined)
360      * From MonolithDAO Token.sol
361      * Emits an Approval event.
362      * @param spender The address which will spend the funds.
363      * @param subtractedValue The amount of tokens to decrease the allowance by.
364      */
365     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
366         require(spender != address(0));
367 
368         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
369         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
370         return true;
371     }
372 
373     /**
374     * @dev Transfer token for a specified addresses
375     * @param from The address to transfer from.
376     * @param to The address to transfer to.
377     * @param value The amount to be transferred.
378     */
379     function _transfer(address from, address to, uint256 value) internal {
380         require(to != address(0));
381         
382         NEST_NodeAssignment nodeAssignment = NEST_NodeAssignment(address(mappingContract.checkAddress("nodeAssignment")));
383         nodeAssignment.nodeCount(from, to);
384         
385         _balances[from] = _balances[from].sub(value);
386         _balances[to] = _balances[to].add(value);
387         emit Transfer(from, to, value);
388         
389         
390     }
391     
392     modifier onlyOwner(){
393         require(mappingContract.checkOwners(msg.sender) == true);
394         _;
395     }
396 }
397 
398 /**
399  * @title SafeMath
400  * @dev Math operations with safety checks that revert on error
401  */
402 library SafeMath {
403     int256 constant private INT256_MIN = -2**255;
404 
405     /**
406     * @dev Multiplies two unsigned integers, reverts on overflow.
407     */
408     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
409         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
410         // benefit is lost if 'b' is also tested.
411         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
412         if (a == 0) {
413             return 0;
414         }
415 
416         uint256 c = a * b;
417         require(c / a == b);
418 
419         return c;
420     }
421 
422     /**
423     * @dev Multiplies two signed integers, reverts on overflow.
424     */
425     function mul(int256 a, int256 b) internal pure returns (int256) {
426         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
427         // benefit is lost if 'b' is also tested.
428         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
429         if (a == 0) {
430             return 0;
431         }
432 
433         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
434 
435         int256 c = a * b;
436         require(c / a == b);
437 
438         return c;
439     }
440 
441     /**
442     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
443     */
444     function div(uint256 a, uint256 b) internal pure returns (uint256) {
445         // Solidity only automatically asserts when dividing by 0
446         require(b > 0);
447         uint256 c = a / b;
448         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
449 
450         return c;
451     }
452 
453     /**
454     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
455     */
456     function div(int256 a, int256 b) internal pure returns (int256) {
457         require(b != 0); // Solidity only automatically asserts when dividing by 0
458         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
459 
460         int256 c = a / b;
461 
462         return c;
463     }
464 
465     /**
466     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
467     */
468     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
469         require(b <= a);
470         uint256 c = a - b;
471 
472         return c;
473     }
474 
475     /**
476     * @dev Subtracts two signed integers, reverts on overflow.
477     */
478     function sub(int256 a, int256 b) internal pure returns (int256) {
479         int256 c = a - b;
480         require((b >= 0 && c <= a) || (b < 0 && c > a));
481 
482         return c;
483     }
484 
485     /**
486     * @dev Adds two unsigned integers, reverts on overflow.
487     */
488     function add(uint256 a, uint256 b) internal pure returns (uint256) {
489         uint256 c = a + b;
490         require(c >= a);
491 
492         return c;
493     }
494 
495     /**
496     * @dev Adds two signed integers, reverts on overflow.
497     */
498     function add(int256 a, int256 b) internal pure returns (int256) {
499         int256 c = a + b;
500         require((b >= 0 && c >= a) || (b < 0 && c < a));
501 
502         return c;
503     }
504 
505     /**
506     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
507     * reverts when dividing by zero.
508     */
509     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
510         require(b != 0);
511         return a % b;
512     }
513 }
514 
515 contract IBMapping {
516 	function checkAddress(string memory name) public view returns (address contractAddress);
517 	function checkOwners(address man) public view returns (bool);
518 }
519 
520 contract IBNEST {
521     function totalSupply() public view returns (uint supply);
522     function balanceOf( address who ) public view returns (uint value);
523     function allowance( address owner, address spender ) public view returns (uint _allowance);
524 
525     function transfer( address to, uint256 value) external;
526     function transferFrom( address from, address to, uint value) public returns (bool ok);
527     function approve( address spender, uint value ) public returns (bool ok);
528 
529     event Transfer( address indexed from, address indexed to, uint value);
530     event Approval( address indexed owner, address indexed spender, uint value);
531     
532     function balancesStart() public view returns(uint256);
533     function balancesGetBool(uint256 num) public view returns(bool);
534     function balancesGetNext(uint256 num) public view returns(uint256);
535     function balancesGetValue(uint256 num) public view returns(address, uint256);
536 }