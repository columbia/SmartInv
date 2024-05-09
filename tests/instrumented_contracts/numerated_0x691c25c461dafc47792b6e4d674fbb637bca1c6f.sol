1 /* 
2  * 
3  *                                                                           
4  *                      ;'+:                                                                         
5  *                       ''''''`                                                                     
6  *                        ''''''';                                                                   
7  *                         ''''''''+.                                                                
8  *                          +''''''''',                                                              
9  *                           '''''''''+'.                                                            
10  *                            ''''''''''''                                                           
11  *                             '''''''''''''                                                         
12  *                             ,'''''''''''''.                                                       
13  *                              '''''''''''''''                                                      
14  *                               '''''''''''''''                                                     
15  *                               :'''''''''''''''.                                                   
16  *                                '''''''''''''''';                                                  
17  *                                .'''''''''''''''''                                                 
18  *                                 ''''''''''''''''''                                                
19  *                                 ;''''''''''''''''''                                               
20  *                                  '''''''''''''''''+'                                              
21  *                                  ''''''''''''''''''''                                             
22  *                                  '''''''''''''''''''',                                            
23  *                                  ,''''''''''''''''''''                                            
24  *                                   '''''''''''''''''''''                                           
25  *                                   ''''''''''''''''''''':                                          
26  *                                   ''''''''''''''''''''+'                                          
27  *                                   `''''''''''''''''''''':                                         
28  *                                    ''''''''''''''''''''''                                         
29  *                                    .''''''''''''''''''''';                                        
30  *                                    ''''''''''''''''''''''`                                       
31  *                                     ''''''''''''''''''''''                                       
32  *                                       ''''''''''''''''''''''                                      
33  *                  :                     ''''''''''''''''''''''                                     
34  *                  ,:                     ''''''''''''''''''''''                                    
35  *                  :::.                    ''+''''''''''''''''''':                                  
36  *                  ,:,,:`        .:::::::,. :''''''''''''''''''''''.                                
37  *                   ,,,::::,.,::::::::,:::,::,''''''''''''''''''''''';                              
38  *                   :::::::,::,::::::::,,,''''''''''''''''''''''''''''''`                           
39  *                    :::::::::,::::::::;'''''''''''''''''''''''''''''''''+`                         
40  *                    ,:,::::::::::::,;''''''''''''''''''''''''''''''''''''';                        
41  *                     :,,:::::::::::'''''''''''''''''''''''''''''''''''''''''                       
42  *                      ::::::::::,''''''''''''''''''''''''''''''''''''''''''''                      
43  *                       :,,:,:,:''''''''''''''''''''''''''''''''''''''''''''''`                     
44  *                        .;::;'''''''''''''''''''''''''''''''''''''''''''''''''                     
45  *                            :'+'''''''''''''''''''''''''''''''''''''''''''''''                     
46  *                                  ``.::;'''''''''''''';;:::,..`````,'''''''''',                    
47  *                                                                       ''''''';                    
48  *                                                                         ''''''                    
49  *                           .''''''';       '''''''''''''       ''''''''   '''''                    
50  *                          '''''''''''`     '''''''''''''     ;'''''''''';  ''';                    
51  *                         '''       '''`    ''               ''',      ,'''  '':                    
52  *                        '''         :      ''              `''          ''` :'`                    
53  *                        ''                 ''              '':          :''  '                     
54  *                        ''                 ''''''''''      ''            ''  '                     
55  *                       `''     '''''''''   ''''''''''      ''            ''                        
56  *                        ''     '''''''':   ''              ''            ''                        
57  *                        ''           ''    ''              '''          '''                        
58  *                        '''         '''    ''               '''        '''                         
59  *                         '''.     .'''     ''                '''.    .'''                         
60  *                          `''''''''''      '''''''''''''`    `''''''''''                          
61  *                            '''''''        '''''''''''''`      .''''''.                            
62  **/                                                                                                   
63 pragma solidity ^0.5.2;
64 // ---------------------------------------------------------------------------------------------
65 // 'iBlockchain Bank & Trust™' ERC20 Token
66 //
67 // Symbol           : iBBT
68 // Trademarks (tm)  : iBBT™ , IBBT™ , iBlockchain Bank & Trust™
69 // Name             : Utility Token
70 // Total supply     : 100,000,000,000 (Million)
71 // Decimals         : 18
72 // Github           : https://github.com/Geopay/iBlockchain-Bank-and-Trust-Utility-Token
73 //
74 // (c) by A. Valamontes with Blockchain Ventures / Geopay.me Inc 2013-2019. Affero GPLv3 Licence.
75 // --
76 
77 // ----------------------------------------------------------------------------
78 // ERC Token Standard #20 Interface
79 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
80 // ----------------------------------------------------------------------------
81 contract ERC20Interface {
82     function totalSharesIssued() public pure returns (uint);
83     function balanceOf(address tokenOwner) public pure returns (uint balance);
84     function allowance(address tokenOwner, address spender) public pure returns (uint remaining);
85     function transfer(address to, uint tokens) public returns (bool success);
86     function approve(address spender, uint tokens) public returns (bool success);
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://eips.ethereum.org/EIPS/eip-20
96  */
97 interface IERC20 {
98     function transfer(address to, uint256 value) external returns (bool);
99 
100     function approve(address spender, uint256 value) external returns (bool);
101 
102     function transferFrom(address from, address to, uint256 value) external returns (bool);
103 
104     function totalSupply() external view returns (uint256);
105 
106     function balanceOf(address who) external view returns (uint256);
107 
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 // File: contracts/math/SafeMath.sol
116 
117 
118 /**
119  * @title SafeMath
120  * @dev Unsigned math operations with safety checks that revert on error
121  */
122 library SafeMath {
123     /**
124      * @dev Multiplies two unsigned integers, reverts on overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128         // benefit is lost if 'b' is also tested.
129         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
130         if (a == 0) {
131             return 0;
132         }
133 
134         uint256 c = a * b;
135         require(c / a == b);
136 
137         return c;
138     }
139 
140     /**
141      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Solidity only automatically asserts when dividing by 0
145         require(b > 0);
146         uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148 
149         return c;
150     }
151 
152     /**
153      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         require(b <= a);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Adds two unsigned integers, reverts on overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a);
168 
169         return c;
170     }
171 
172     /**
173      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
174      * reverts when dividing by zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         require(b != 0);
178         return a % b;
179     }
180 }
181 contract Ownable {
182   address public owner;
183 
184   constructor() public {
185     owner = msg.sender;
186   }
187 
188   modifier onlyOwner {
189     require(msg.sender == owner);
190     _;
191   }
192 }
193   
194 // File: contracts/token/ERC20/ERC20.sol
195 
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * https://eips.ethereum.org/EIPS/eip-20
202  * Originally based on code by FirstBlood:
203  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  *
205  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
206  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
207  * compliant implementations may not do it.
208  */
209  
210 contract ERC20 is IERC20, Ownable {
211     using SafeMath for uint256;
212 
213     mapping (address => uint256) private _balances;
214 
215     mapping (address => mapping (address => uint256)) private _allowed;
216 
217     uint256 private _totalSupply;
218 
219     /**
220      * @dev Total number of tokens in existence
221      */
222     function totalSupply() public view returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227      * @dev Gets the balance of the specified address.
228      * @param owner The address to query the balance of.
229      * @return An uint256 representing the amount owned by the passed address.
230      */
231     function balanceOf(address owner) public view returns (uint256) {
232         return _balances[owner];
233     }
234 
235     /**
236      * @dev Function to check the amount of tokens that an owner allowed to a spender.
237      * @param owner address The address which owns the funds.
238      * @param spender address The address which will spend the funds.
239      * @return A uint256 specifying the amount of tokens still available for the spender.
240      */
241     function allowance(address owner, address spender) public view returns (uint256) {
242         return _allowed[owner][spender];
243     }
244 
245     /**
246      * @dev Transfer token for a specified address
247      * @param to The address to transfer to.
248      * @param value The amount to be transferred.
249      */
250     function transfer(address to, uint256 value) public returns (bool) {
251         _transfer(msg.sender, to, value);
252         return true;
253     }
254 
255     /**
256      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257      * Beware that changing an allowance with this method brings the risk that someone may use both the old
258      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      * @param spender The address which will spend the funds.
262      * @param value The amount of tokens to be spent.
263      */
264     function approve(address spender, uint256 value) public returns (bool) {
265         _approve(msg.sender, spender, value);
266         return true;
267     }
268 
269     /**
270      * @dev Transfer tokens from one address to another.
271      * Note that while this function emits an Approval event, this is not required as per the specification,
272      * and other compliant implementations may not emit the event.
273      * @param from address The address which you want to send tokens from
274      * @param to address The address which you want to transfer to
275      * @param value uint256 the amount of tokens to be transferred
276      */
277     function transferFrom(address from, address to, uint256 value) public returns (bool) {
278         _transfer(from, to, value);
279         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
280         return true;
281     }
282 
283     /**
284      * @dev Increase the amount of tokens that an owner allowed to a spender.
285      * approve should be called when allowed_[_spender] == 0. To increment
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * Emits an Approval event.
290      * @param spender The address which will spend the funds.
291      * @param addedValue The amount of tokens to increase the allowance by.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
295         return true;
296     }
297 
298     /**
299      * @dev Decrease the amount of tokens that an owner allowed to a spender.
300      * approve should be called when allowed_[_spender] == 0. To decrement
301      * allowed value is better to use this function to avoid 2 calls (and wait until
302      * the first transaction is mined)
303      * From MonolithDAO Token.sol
304      * Emits an Approval event.
305      * @param spender The address which will spend the funds.
306      * @param subtractedValue The amount of tokens to decrease the allowance by.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
310         return true;
311     }
312 
313     /**
314      * @dev Transfer token for a specified addresses
315      * @param from The address to transfer from.
316      * @param to The address to transfer to.
317      * @param value The amount to be transferred.
318      */
319     function _transfer(address from, address to, uint256 value) internal {
320         require(to != address(0));
321 
322         _balances[from] = _balances[from].sub(value);
323         _balances[to] = _balances[to].add(value);
324         emit Transfer(from, to, value);
325     }
326 
327     /**
328      * @dev Internal function that mints an amount of the token and assigns it to
329      * an account. This encapsulates the modification of balances such that the
330      * proper events are emitted.
331      * @param account The account that will receive the created tokens.
332      * @param value The amount that will be created.
333      */
334     function _mint(address account, uint256 value) internal {
335         require(account != address(0));
336 
337         _totalSupply = _totalSupply.add(value);
338         _balances[account] = _balances[account].add(value);
339         emit Transfer(address(0), account, value);
340     }
341 
342     /**
343      * @dev Internal function that burns an amount of the token of a given
344      * account.
345      * @param account The account whose tokens will be burnt.
346      * @param value The amount that will be burnt.
347      */
348     function _burn(address account, uint256 value) internal {
349         require(account != address(0));
350 
351         _totalSupply = _totalSupply.sub(value);
352         _balances[account] = _balances[account].sub(value);
353         emit Transfer(account, address(0), value);
354     }
355 
356     /**
357      * @dev Approve an address to spend another addresses' tokens.
358      * @param owner The address that owns the tokens.
359      * @param spender The address that will spend the tokens.
360      * @param value The number of tokens that can be spent.
361      */
362     function _approve(address owner, address spender, uint256 value) internal {
363         require(spender != address(0));
364         require(owner != address(0));
365 
366         _allowed[owner][spender] = value;
367         emit Approval(owner, spender, value);
368     }
369 
370     /**
371      * @dev Internal function that burns an amount of the token of a given
372      * account, deducting from the sender's allowance for said account. Uses the
373      * internal burn function.
374      * Emits an Approval event (reflecting the reduced allowance).
375      * @param account The account whose tokens will be burnt.
376      * @param value The amount that will be burnt.
377      */
378     function _burnFrom(address account, uint256 value) internal {
379         _burn(account, value);
380         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
381     }
382      
383   // ------------------------------------------------------------------------
384   // Owner can transfer out any accidentally sent ERC20 tokens
385   // ------------------------------------------------------------------------
386   function transferOtherERC20Assets(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
387         return ERC20Interface(tokenAddress).transfer(owner, tokens);
388   }
389 }
390 
391 // File: contracts/token/ERC20/ERC20Detailed.sol
392 
393 
394 /**
395  * @title ERC20Detailed token
396  * @dev The decimals are only for visualization purposes.
397  * All the operations are done using the smallest and indivisible token unit,
398  * just as on Ethereum all the operations are done in wei.
399  */
400 contract ERC20Detailed is IERC20 {
401     string private _name;
402     string private _symbol;
403     uint8 private _decimals;
404 
405     constructor (string memory name, string memory symbol, uint8 decimals) public {
406         _name = name;
407         _symbol = symbol;
408         _decimals = decimals;
409     }
410 
411     /**
412      * @return the name of the token.
413      */
414     function name() public view returns (string memory) {
415         return _name;
416     }
417 
418     /**
419      * @return the symbol of the token.
420      */
421     function symbol() public view returns (string memory) {
422         return _symbol;
423     }
424 
425     /**
426      * @return the number of decimals of the token.
427      */
428     function decimals() public view returns (uint8) {
429         return _decimals;
430     }
431 }
432 
433 // File: contracts/access/Roles.sol
434 
435 /**
436  * @title Roles
437  * @dev Library for managing addresses assigned to a Role.
438  */
439 library Roles {
440     struct Role {
441         mapping (address => bool) bearer;
442     }
443 
444     /**
445      * @dev give an account access to this role
446      */
447     function add(Role storage role, address account) internal {
448         require(account != address(0));
449         require(!has(role, account));
450 
451         role.bearer[account] = true;
452     }
453 
454     /**
455      * @dev remove an account's access to this role
456      */
457     function remove(Role storage role, address account) internal {
458         require(account != address(0));
459         require(has(role, account));
460 
461         role.bearer[account] = false;
462     }
463 
464     /**
465      * @dev check if an account has this role
466      * @return bool
467      */
468     function has(Role storage role, address account) internal view returns (bool) {
469         require(account != address(0));
470         return role.bearer[account];
471     }
472 }
473 
474 // File: contracts/access/roles/MinterRole.sol
475 
476 
477 contract MinterRole {
478     using Roles for Roles.Role;
479 
480     event MinterAdded(address indexed account);
481     event MinterRemoved(address indexed account);
482 
483     Roles.Role private _minters;
484 
485     constructor () internal {
486         _addMinter(msg.sender);
487     }
488 
489     modifier onlyMinter() {
490         require(isMinter(msg.sender));
491         _;
492     }
493 
494     function isMinter(address account) public view returns (bool) {
495         return _minters.has(account);
496     }
497 
498     function addMinter(address account) public onlyMinter {
499         _addMinter(account);
500     }
501 
502     function renounceMinter() public {
503         _removeMinter(msg.sender);
504     }
505 
506     function _addMinter(address account) internal {
507         _minters.add(account);
508         emit MinterAdded(account);
509     }
510 
511     function _removeMinter(address account) internal {
512         _minters.remove(account);
513         emit MinterRemoved(account);
514     }
515 }
516 
517 // File: contracts/token/ERC20/ERC20Mintable.sol
518 
519 /**
520  * @title ERC20Mintable
521  * @dev ERC20 minting logic
522  */
523 contract ERC20Mintable is ERC20, MinterRole {
524     /**
525      * @dev Function to mint tokens
526      * @param to The address that will receive the minted tokens.
527      * @param value The amount of tokens to mint.
528      * @return A boolean that indicates if the operation was successful.
529      */
530     function mint(address to, uint256 value) public onlyMinter returns (bool) {
531         _mint(to, value);
532         return true;
533     }
534 }
535 
536 
537 contract iBlockchainBankAndTrustToken is ERC20, ERC20Detailed, ERC20Mintable {
538     string public version = '0.2';
539     
540     constructor(
541         string memory name,
542         string memory symbol,
543         uint8 decimals
544     )
545         ERC20Mintable()
546         ERC20Detailed(name, symbol, decimals)
547         ERC20()
548         public
549     {}
550 }
551 
552 // (c) by A. Valamontes with Blockchain Ventures / Geopay.me Inc 2013-2019. Affero GPLv3 Licence.
553 // ----------------------------------------------------------------------------------------------