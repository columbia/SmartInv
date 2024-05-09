1 pragma solidity ^0.4.23;
2 
3 contract ERC20Interface {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender) public view returns (uint256);
9 
10   function transfer(address _to, uint256 _value) public returns (bool);
11 
12   function approve(address _spender, uint256 _value) public returns (bool);
13 
14   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16   event Transfer(
17     address indexed from,
18     address indexed to,
19     uint256 value
20   );
21 
22   event Approval(
23     address indexed owner,
24     address indexed spender,
25     uint256 value
26   );
27 }
28 
29 /**
30  * @dev support ERC677
31  * https://github.com/ethereum/EIPs/issues/677
32  * |--------------|            |-----------------------|            |-------------------------|
33  * |    Sender    |            | ERC677SenderInterface |            | ERC677ReceiverInterface |
34  * |--------------|            |-----------------------|            |-------------------------|
35  *        |       transferAndCall()        |                                      |
36  *        |------------------------------->|            tokenFallback()           |
37  *        |                                |------------------------------------->|
38  *        |                                |                                      |
39  */
40 contract ERC677ReceiverInterface {
41     function tokenFallback(address _sender, uint256 _value, bytes _extraData) 
42         public returns (bool);
43 }
44 
45 contract ERC677SenderInterface {
46     function transferAndCall(address _recipient, uint256 _value, bytes _extraData) 
47         public returns (bool);
48 }
49 
50 /**
51  *  ____ ___ ____  ____  ____  ___    _    _   _ 
52  * / ___|_ _|  _ \| __ )|  _ \|_ _|  / \  | \ | |
53  * \___ \| || | | |  _ \| |_) || |  / _ \ |  \| |
54  *  ___) | || |_| | |_) |  _ < | | / ___ \| |\  |
55  * |____/___|____/|____/|_| \_\___/_/   \_\_| \_|
56  * 
57  * SIDBRIAN is a token which based on ERC20 standard.
58  * Some token will be locked after deploying contract.
59  * Activator will unlock token at some specific moment.
60  * */
61 
62 contract SIDBRIAN is ERC20Interface, ERC677SenderInterface {
63     
64     using SafeMath for uint256;
65     
66     constructor()
67         public
68     {
69         owner_ = msg.sender;
70         totalSupply_ = 1000000000 * (10**18);
71         activateTokens_ = 250000000 * (10**18);
72         increasingStep_ = 50000000 * (10**18);
73         
74         balances_[owner_] = activateTokens_;
75     }
76     
77     address public owner_;
78     
79     string public name = "SIDBRIAN";
80     string public symbol = "SIDB";
81     uint8 public decimals = 18;
82     
83     mapping(address => uint256) private balances_;
84     mapping(address => mapping(address => uint256)) private allowed_;
85     uint256 private totalSupply_;
86     
87     uint256 public activateTokens_;
88     uint256 public increasingStep_;
89     
90     bool public isPaused_ = false;
91     
92     mapping(address => bool) activators_;
93     
94     /**
95      *                   _ _  __ _               
96      *   /\/\   ___   __| (_)/ _(_) ___ _ __ ___ 
97      *  /    \ / _ \ / _` | | |_| |/ _ \ '__/ __|
98      * / /\/\ \ (_) | (_| | |  _| |  __/ |  \__ \
99      * \/    \/\___/ \__,_|_|_| |_|\___|_|  |___/
100      * 
101      * */
102     
103     modifier onlyOwner(
104         address _address
105     )
106     {
107         require(
108             _address == owner_, 
109             "This action not allowed because of permission."
110         );
111         
112         _;
113     }
114     
115     modifier onlyActivator(
116         address _activator    
117     )
118     {
119         require(
120             activators_[_activator] == true, 
121             "The action not allowed because of permission."
122         );
123         _;
124     }
125     
126     modifier onlyUnpaused
127     {
128         require(
129             isPaused_ == false, 
130             "This action not allowed when pausing"
131         );
132         
133         _;
134     }
135     
136     /**
137      *     __                 _       
138      *    /__\_   _____ _ __ | |_ ___   
139      *   /_\ \ \ / / _ \ '_ \| __/ __|
140      *  //__  \ V /  __/ | | | |_\__ \
141      *  \__/   \_/ \___|_| |_|\__|___/
142      * */
143      
144     event Pause();
145     event Unpause();
146     event Activation(
147         address activator,
148         uint256 activeTokens
149     );
150     event RemoveActivator(
151         address activator
152     );
153     event AddActivator(
154         address activator
155     );
156     
157     event TransferOwnership(
158         address newOwner
159     );
160     
161     /**
162      *      __  __    ___ ____   ___      ___                 _   _                 
163      *     /__\/__\  / __\___ \ / _ \    / __\   _ _ __   ___| |_(_) ___  _ __  ___  
164      *    /_\ / \// / /    __) | | | |  / _\| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
165      *   //__/ _  \/ /___ / __/| |_| | / /  | |_| | | | | (__| |_| | (_) | | | \__ \
166      *   \__/\/ \_/\____/|_____|\___/  \/    \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
167      *  ERC20 Functions
168      * */
169     
170     function totalSupply() 
171         view
172         public 
173         returns 
174         (uint256)
175     {
176         return totalSupply_;
177     }
178     
179     function balanceOf(
180         address _who
181     )
182         view
183         public
184         returns
185         (uint256)
186     {
187         return balances_[_who];
188     }
189     
190     function allowance(
191         address _who, 
192         address _spender
193     )
194         view
195         public
196         returns
197         (uint256)
198     {
199         return allowed_[_who][_spender];
200     }
201     
202     function transfer(
203         address _to, 
204         uint256 _value
205     )
206         public
207         onlyUnpaused
208         returns
209         (bool)
210     {
211         require(balances_[msg.sender] >= _value, "Insufficient balance");
212         require(_to != address(0));
213         
214         balances_[msg.sender] = balances_[msg.sender].sub(_value);
215         balances_[_to] = balances_[_to].add(_value);
216         
217         emit Transfer(
218             msg.sender,
219             _to,
220             _value
221         );
222         
223         return true;
224     }
225     
226     function approve(
227         address _spender, 
228         uint256 _value
229     )
230         public
231         returns
232         (bool)
233     {
234         allowed_[msg.sender][_spender] = _value;
235         emit Approval(
236             msg.sender,
237             _spender,
238             _value
239         );
240     }
241     
242     function transferFrom(
243         address _from, 
244         address _to, 
245         uint256 _value
246     )
247         public
248         onlyUnpaused
249         returns
250         (bool)
251     {
252         require(balances_[_from] >= _value, "Owner Insufficient balance");
253         require(allowed_[_from][msg.sender] >= _value, "Spender Insufficient balance");
254         require(_to != address(0), "Don't burn the coin.");
255         
256         balances_[_from] = balances_[_from].sub(_value);
257         balances_[_to] = balances_[_to].add(_value);
258         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
259         
260         emit Transfer(
261             _from,
262             _to,
263             _value
264         );
265     }
266     
267     function increaseApproval(
268         address _spender,
269         uint256 _addValue
270     )
271         public
272         returns
273         (bool)
274     {
275         allowed_[msg.sender][_spender] = 
276             allowed_[msg.sender][_spender].add(_addValue);
277         
278         emit Approval(
279             msg.sender,
280             _spender,
281             allowed_[msg.sender][_spender]
282         );
283     }
284     
285     function decreaseApproval(
286         address _spender,
287         uint256 _substractValue
288     )
289         public
290         returns
291         (bool)
292     {
293         uint256 _oldValue = allowed_[msg.sender][_spender];
294         if(_oldValue >= _substractValue) {
295             allowed_[msg.sender][_spender] = _oldValue.sub(_substractValue);
296         } 
297         else {
298             allowed_[msg.sender][_spender] = 0;    
299         }
300         
301         emit Approval(
302             msg.sender,
303             _spender,
304             allowed_[msg.sender][_spender]
305         );
306     }
307     
308     /**
309      *    ___       _     _ _          ___                 _   _                 
310      *   / _ \_   _| |__ | (_) ___    / __\   _ _ __   ___| |_(_) ___  _ __  ___ 
311      *  / /_)/ | | | '_ \| | |/ __|  / _\| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
312      * / ___/| |_| | |_) | | | (__  / /  | |_| | | | | (__| |_| | (_) | | | \__ \
313      * \/     \__,_|_.__/|_|_|\___| \/    \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
314      */
315     
316     function isPaused()
317         view
318         public 
319         returns
320         (bool)
321     {
322         return isPaused_;
323     }
324     
325     /**
326      
327      *    ___                                            _       
328      *   /___\__      ___ __   ___ _ __       ___  _ __ | |_   _ 
329      *  //  //\ \ /\ / / '_ \ / _ \ '__|____ / _ \| '_ \| | | | |
330      * / \_//  \ V  V /| | | |  __/ | |_____| (_) | | | | | |_| |
331      * \___/    \_/\_/ |_| |_|\___|_|        \___/|_| |_|_|\__, |
332      *                                                     |___/                                               
333      * The functions that owner can call.
334      */
335      
336     function pause()
337         public
338         onlyOwner(msg.sender)
339     {
340         isPaused_ = true;
341         emit Pause();
342     }
343     
344     function unpaused()
345         public
346         onlyOwner(msg.sender)
347     {
348         isPaused_ = false;
349         
350         emit Unpause();
351     }
352     
353     function addActivator(
354         address _activator
355     )
356         public
357         onlyOwner(msg.sender)
358     {
359         activators_[_activator] = true;
360         
361         emit AddActivator(_activator);
362     }
363     
364     function removeActivator(
365         address _activator
366     )
367         public
368         onlyOwner(msg.sender)
369     {
370         activators_[_activator] = false;
371         
372         emit RemoveActivator(_activator);
373     }
374     
375     function transferOwnership(
376         address _newOwner    
377     )
378         public
379         onlyOwner(msg.sender)
380     {
381         owner_ = _newOwner;
382         emit TransferOwnership(_newOwner);
383     }
384     
385     /**
386      *    _        _   _            _                              _       
387      *   /_\   ___| |_(_)_   ____ _| |_ ___  _ __       ___  _ __ | |_   _ 
388      *  //_\\ / __| __| \ \ / / _` | __/ _ \| '__|____ / _ \| '_ \| | | | |
389      * /  _  \ (__| |_| |\ V / (_| | || (_) | | |_____| (_) | | | | | |_| |
390      * \_/ \_/\___|\__|_| \_/ \__,_|\__\___/|_|        \___/|_| |_|_|\__, |
391      *                                                               |___/                                               
392      * The functions that only activators can call.
393      * */
394      
395      function activateToken()
396         public
397         onlyActivator(msg.sender)
398     {
399         require(activateTokens_ <= totalSupply_, "All token have been activated.");
400         uint256 _beforeValue = activateTokens_;
401         activateTokens_ = _beforeValue.add(increasingStep_);
402         
403         emit Activation(
404             msg.sender,
405             activateTokens_
406         );
407     }
408     
409     /**
410      * @dev ERC677 support
411      * 
412      * */
413     function transferAndCall(address _recipient,
414                     uint256 _value,
415                     bytes _extraData)
416         public
417         returns
418         (bool)
419     {
420         transfer(_recipient, _value);
421         if(isContract(_recipient)) {
422             require(ERC677ReceiverInterface(_recipient).tokenFallback(msg.sender, _value, _extraData));
423         }
424         return true;
425     }
426     
427     function isContract(address _addr) private view returns (bool) {
428         uint len;
429         assembly {
430             len := extcodesize(_addr)
431         }
432         return len > 0;
433     }
434 }
435 
436 /**
437  *   __        __                      _   _     
438     / _\ __ _ / _| ___ _ __ ___   __ _| |_| |__  
439     \ \ / _` | |_ / _ \ '_ ` _ \ / _` | __| '_ \ 
440     _\ \ (_| |  _|  __/ | | | | | (_| | |_| | | |
441     \__/\__,_|_|  \___|_| |_| |_|\__,_|\__|_| |_|
442       
443     SafeMath library, thanks to openzeppelin solidity.
444     https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
445  * */
446 
447 library SafeMath {
448 
449   /**
450   * @dev Multiplies two numbers, reverts on overflow.
451   */
452   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
453     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
454     // benefit is lost if 'b' is also tested.
455     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
456     if (_a == 0) {
457       return 0;
458     }
459 
460     uint256 c = _a * _b;
461     require(c / _a == _b);
462 
463     return c;
464   }
465 
466   /**
467   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
468   */
469   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
470     require(_b > 0); // Solidity only automatically asserts when dividing by 0
471     uint256 c = _a / _b;
472     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
473 
474     return c;
475   }
476 
477   /**
478   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
479   */
480   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
481     require(_b <= _a);
482     uint256 c = _a - _b;
483 
484     return c;
485   }
486 
487   /**
488   * @dev Adds two numbers, reverts on overflow.
489   */
490   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
491     uint256 c = _a + _b;
492     require(c >= _a);
493 
494     return c;
495   }
496 
497   /**
498   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
499   * reverts when dividing by zero.
500   */
501   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
502     require(b != 0);
503     return a % b;
504   }
505 }