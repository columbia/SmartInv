1 pragma solidity >= 0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     // constructor () internal { }
17     // // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      * - Subtraction cannot overflow.
80      *
81      * _Available since v2.4.0._
82      */
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `*` operator.
95      *
96      * Requirements:
97      * - Multiplication cannot overflow.
98      */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      *
139      * _Available since v2.4.0._
140      */
141     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         // Solidity only automatically asserts when dividing by 0
143         require(b > 0, errorMessage);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return mod(a, b, "SafeMath: modulo by zero");
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts with custom message when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      *
176      * _Available since v2.4.0._
177      */
178     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b != 0, errorMessage);
180         return a % b;
181     }
182 }
183 
184 contract ERC20 is Context{
185     using SafeMath for uint256;
186 
187     mapping (address => uint256) _balances;
188     
189     mapping (address => uint256) _intactbal;
190     
191     mapping (address => uint256) _depositTime;
192     
193     mapping(address => mapping(address => uint)) _allowances;
194     
195     uint256 _maximumcoin;
196     uint256 _decimals ;
197     
198     uint256  _firstyearminbal ;
199     uint256  _secondyearminbal ;
200     uint256  _thirdyearminbal ;
201 
202     uint256  private _currentsupply;
203     
204     uint256 deployTime = block.timestamp;
205 
206     uint256  _1year ;
207     uint256  _3month ;
208     uint256 _1month ;
209     uint256  _3min ;
210     
211     address  admin = msg.sender;
212     uint256 _totaltransfered = 0;
213     event Approval(address indexed _from, address indexed _to, uint256 _value);
214     event OwnershipTransferred(address _oldAdmin, address _newAdmin);
215     event MinimumBalanceforinterestchanged(uint256 _oldminyear1, uint256 _oldminyear2, uint256 _oldminyear3, uint256 _newminyear1, uint256 _newminyear2, uint256 _newminyear3 );
216    
217      /**
218      * @dev See {IERC20-balanceOf}.
219      **/
220 
221     function balanceOf(address account) public view returns (uint256) {
222         return (_balances[account]);
223     }
224     
225     function transferOwnership(address _newAdmin) public {
226         require(msg.sender == admin, "Not an admin");
227         admin = _newAdmin;
228         emit OwnershipTransferred(msg.sender, admin);
229     }
230     
231     function changeMinimumBalanceforinterest(uint256 y1, uint256 y2, uint256 y3) public {
232         require(msg.sender == admin, "Not an admin");
233         _firstyearminbal = y1;
234         _secondyearminbal = y2;
235         _thirdyearminbal = y3;
236         
237         emit MinimumBalanceforinterestchanged(y1, y2, y3, _firstyearminbal, _secondyearminbal, _thirdyearminbal);
238     }
239 
240     function viewMinimumBalanceforinterest() public view returns (uint256, uint256, uint256){
241         return (_firstyearminbal,_secondyearminbal,_thirdyearminbal );
242     }
243         
244     function approve(address _spender, uint256 value) public {
245         _allowances[msg.sender][_spender] = value;
246         emit Approval(msg.sender,_spender, value);
247     }
248     
249     function transferFrom(address _from, address _to, uint256 _value)public {
250         _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
251         _transfer(_from, _to, _value);
252     }
253     
254     function allowances(address _from, address _spender) public view returns (uint) {
255         return _allowances[_from][_spender];
256     }
257     
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer( address recipient, uint256 amount) public returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271  
272     /**
273      * @dev Moves tokens `amount` from `sender` to `recipient`.
274      *
275      * This is internal function is equivalent to {transfer}, and can be used to
276      * e.g. implement automatic token fees, slashing mechanisms, etc.
277      *
278      * Emits a {Transfer} event.
279      *
280      * Requirements:
281      *
282      * - `sender` cannot be the zero address.
283      * - `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      */
286     function _transfer(address sender, address recipient, uint256 amount) internal {
287         require(sender != address(0), "ERC20: transfer from the zero address");
288         require(recipient != address(0), "ERC20: transfer to the zero address");
289         _balances[sender] = _balances[sender].sub(amount);
290         _balances[recipient] = _balances[recipient].add(amount);
291         // if(_depositTime[recipient] == 0)
292         // _depositTime[recipient] = block.timestamp;
293         emit Transfer (sender, recipient, amount);
294     }
295     
296     function _transferAdmin(address sender, address recipient, uint256 amount) internal {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299         _balances[sender] = _balances[sender].sub(amount);
300         _balances[recipient] = _balances[recipient].add(amount);
301         if(_depositTime[recipient] == 0)
302         _depositTime[recipient] = block.timestamp;
303         emit Transfer (sender, recipient, amount);
304     }
305 
306     /**
307      * @dev Emitted when `value` tokens are moved from one account (`from`) to
308      * another (`to`).
309      *
310      * Note that `value` may be zero.
311      */
312     event Transfer(address indexed frm, address indexed to, uint256 value);
313 
314     event InterestTransfer(address indexed to, uint256 value, uint256 transferTime);
315 
316 }
317 
318 
319 contract Interest is Context, ERC20 {
320     
321     using SafeMath for uint256;
322     
323     //cron this function daily after 3 months of deployment of contract upto 3 years
324     
325      function multiInterestUpdate(address[] memory _contributors)public  returns (bool) { 
326          require(msg.sender == admin, "ERC20: Only admin can transfer from contract");
327          uint256 _time =block.timestamp.sub(deployTime);
328          require(_time >= _3month.add(_1month), "ERC20: Only after 4 months of deployment of contract" );
329     
330             uint i = 0;
331             for (i; i < _contributors.length; i++) {
332         
333                 address  user = _contributors[i];
334                  uint256 _deposittime =block.timestamp.sub(_depositTime[user]);
335                  
336                  if(_time <= _1year){           //less than 1 year
337                  
338                      if((_balances[ user] >= _firstyearminbal) && (_deposittime > _3month) && (_intactbal[user] == 0))
339                      _intactbal[user] = _intactbal[user].add((_balances[user]*3)/(100));
340                 
341                  }
342                  else if(_time <= (_1year*2)){  //less than 2 year
343                         
344                      if(_balances[ user] >= _secondyearminbal && (_deposittime > _1month*2) && (_intactbal[user] == 0))
345                       _intactbal[user] = _intactbal[user].add((_balances[ user]*15)/(1000));
346                  }
347                  else if(_time <= (_1year*3)){  //less than 3 year
348                  
349                      if(_balances[user] >= _thirdyearminbal  && (_deposittime > _1month) && (_intactbal[user] == 0))
350                      _intactbal[user] = _intactbal[user].add((_balances[ user])/(100));
351                  }
352          
353             }
354          
355 
356     return (true);
357     }
358     
359     
360     //cron this function monthly after 4 months of deployment of contract upto 3 years
361     
362      function multiInterestCredit( address[] memory _contributors) public returns(uint256) {
363        require(msg.sender == admin, "ERC20: Only admin can transfer from contract");
364        uint256 _time =block.timestamp.sub(deployTime);
365          require(_time >= _3month.add(_1month), "ERC20: Only after 4 months of deployment of contract" );
366        
367             uint256 monthtotal = 0;
368             
369             uint i = 0;
370             for (i; i < _contributors.length; i++) {
371                 _transfer(address(this), _contributors[i], _intactbal[_contributors[i]]);
372                  emit InterestTransfer (_contributors[i], _intactbal[_contributors[i]], block.timestamp);
373                 _totaltransfered = _totaltransfered.add(_intactbal[_contributors[i]]);
374                 _intactbal[_contributors[i]] = 0;
375                 monthtotal += _intactbal[_contributors[i]];
376                 
377             }
378             
379         return (monthtotal);
380     }
381     
382 }
383 
384 
385 /**
386  * @dev Optional functions from the ERC20 standard.
387  */
388 contract ERC20Detailed {
389     string private _name;
390     string private _symbol;
391     uint256 private _decimals;
392 
393     /**
394      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
395      * these values are immutable: they can only be set once during
396      * construction.
397      */
398     constructor (string memory name, string memory symbol, uint256 decimals) public {
399         _name = name;
400         _symbol = symbol;
401         _decimals = decimals;
402     }
403 
404     /**
405      * @dev Returns the name of the token.
406      */
407     function name() public view returns (string memory) {
408         return _name;
409     }
410 
411     /**
412      * @dev Returns the symbol of the token, usually a shorter version of the
413      * name.
414      */
415     function symbol() public view returns (string memory) {
416         return _symbol;
417     }
418 
419     /**
420      * @dev Returns the number of decimals used to get its user representation.
421      * For example, if `decimals` equals `2`, a balance of `505` tokens should
422      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
423      *
424      * Tokens usually opt for a value of 18, imitating the relationship between
425      * Ether and Wei.
426      *
427      * NOTE: This information is only used for _display_ purposes: it in
428      * no way affects any of the arithmetic of the contract, including
429      * {IERC20-balanceOf} and {IERC20-transfer}.
430      */
431     function decimals() public view returns (uint256) {
432         return _decimals;
433     }
434 }
435 
436 contract ARIX is ERC20, ERC20Detailed, Interest{
437     
438         constructor(
439         uint256   maximumcoin,
440         uint32 secondsforoneyear,
441         uint32 secondsforthreemonths,
442         uint32 secondsforonemonth,
443         uint32 secondsforthreeminute ,
444         uint256 minimumbalanceforfirstyearinterest,
445         uint256 minimumbalanceforsecondyearinterest,
446         uint256 minimumbalanceforthirdyearinterest,
447         string memory name, 
448         string memory symbol, 
449         uint256 decimals 
450         )public ERC20Detailed(name, symbol, decimals) {
451 
452             _balances[address(this)] = maximumcoin;
453             _maximumcoin = maximumcoin;
454             _decimals = 10**decimals;
455             _1year = secondsforoneyear;
456             _3month = secondsforthreemonths;
457             _1month = secondsforonemonth;
458             _3min = secondsforthreeminute;
459             _firstyearminbal = minimumbalanceforfirstyearinterest;
460             _secondyearminbal = minimumbalanceforsecondyearinterest;
461             _thirdyearminbal = minimumbalanceforthirdyearinterest;
462    }
463    using SafeMath for uint256;
464    
465     function totalSupply() public view returns (uint256) {
466          
467         uint256 _1yearcoin = (_1year/_3min)*100*_decimals;
468         uint256 _2yearcoin = _1yearcoin.add((_1year/_3min)*50*_decimals);
469         uint256 _3yearcoin = _2yearcoin.add((_1year/_3min)*25*_decimals);
470         uint256 _4yearcoin = _3yearcoin.add(((_1year/_3min)*125*_decimals)/10);
471         uint256 _5yearcoin = _4yearcoin.add(((_1year/_3min)*625*_decimals)/100);
472         
473         uint256 _elapsetime = block.timestamp.sub(deployTime);
474 
475         if(_elapsetime <=_1year){      
476             if((_elapsetime/_3min)*100*_decimals < _maximumcoin)
477                 return ((_elapsetime/_3min)*100*_decimals);
478             else
479             return(_maximumcoin);
480         
481         
482         }else if(_elapsetime <=(_1year*2)){
483             if(_1yearcoin.add(((_elapsetime.sub(_1year))/_3min)*50*_decimals) < _maximumcoin)
484                 return (_1yearcoin.add(((_elapsetime.sub(_1year))/_3min)*50*_decimals));
485             else
486             return(_maximumcoin);
487         
488         
489         }else if(_elapsetime <=(_1year*3)){
490             if(_2yearcoin.add(((_elapsetime.sub(_1year*2))/_3min)*25*_decimals) < _maximumcoin)
491                 return (_2yearcoin.add(((_elapsetime.sub(_1year*2))/_3min)*25*_decimals));
492             else
493             return(_maximumcoin);
494         
495         
496         }else if(_elapsetime <=(_1year*4)){
497             if(_3yearcoin.add((((_elapsetime.sub(_1year*3))/_3min)*125*_decimals)/10) < _maximumcoin)
498                 return (_3yearcoin.add((((_elapsetime.sub(_1year*3))/_3min)*125*_decimals)/10));
499             else
500             return(_maximumcoin);
501         
502         
503         }else if(_elapsetime <=(_1year*5)){
504             if(_4yearcoin.add((((_elapsetime.sub(_1year*4))/_3min)*625*_decimals)/100) < _maximumcoin)
505                 return (_4yearcoin.add((((_elapsetime.sub(_1year*4))/_3min)*625*_decimals)/100));
506             else
507             return(_maximumcoin);
508      
509         
510         }else if(_elapsetime > (_1year*5)){
511             if(_5yearcoin.add((((_elapsetime.sub(_1year*5))/_3min)*3125*_decimals)/1000) < _maximumcoin)
512                 return (_5yearcoin.add((((_elapsetime.sub(_1year*5))/_3min)*3125*_decimals)/1000));
513             else
514             return(_maximumcoin);
515         }
516        
517     }
518    
519    
520    function admintransfer(address recipient, uint256 amount) public returns (uint256) {
521            require(msg.sender == admin, "ERC20: Only admin can transfer from contract");
522            require(amount <= totalSupply(), "ERC20: Only less than total released can be tranfered");
523            require(amount <= totalSupply().sub(_totaltransfered), "Only less than total suppliable coin");
524            
525         _transferAdmin(address(this), recipient, amount);
526         _totaltransfered = _totaltransfered.add(amount);
527         return(_balances[recipient]);
528     }
529    
530 }