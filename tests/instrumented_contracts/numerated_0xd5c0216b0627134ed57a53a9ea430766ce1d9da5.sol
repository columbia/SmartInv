1 pragma solidity 0.4.24;
2 
3 //Social Media Links
4 //Website : http://mirrorbase.finance
5 //Telegram : t.me/mibaseprotocol
6 //Twitter :https://twitter.com/mibaseprotocol
7 //Medium : https://medium.com/@mibaseprotocol
8  
9 contract Initializable {
10 
11   bool private initialized;
12   bool private initializing;
13 
14   modifier initializer() {
15     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
16 
17     bool wasInitializing = initializing;
18     initializing = true;
19     initialized = true;
20 
21     _;
22 
23     initializing = wasInitializing;
24   }
25 
26   function isConstructor() private view returns (bool) {
27     uint256 cs;
28     assembly { cs := extcodesize(address) }
29     return cs == 0;
30   }
31 
32   uint256[50] private ______gap;
33 }
34 
35 contract Ownable is Initializable {
36 
37   address private _owner;
38   uint256 private _ownershipLocked;
39 
40   event OwnershipLocked(address lockedOwner);
41   event OwnershipRenounced(address indexed previousOwner);
42   event OwnershipTransferred(
43     address indexed previousOwner,
44     address indexed newOwner
45   );
46 
47 
48   function initialize(address sender) internal initializer {
49     _owner = sender;
50 	_ownershipLocked = 0;
51   }
52 
53   function owner() public view returns(address) {
54     return _owner;
55   }
56 
57   modifier onlyOwner() {
58     require(isOwner());
59     _;
60   }
61 
62   function isOwner() public view returns(bool) {
63     return msg.sender == _owner;
64   }
65 
66   function transferOwnership(address newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   function _transferOwnership(address newOwner) internal {
71     require(_ownershipLocked == 0);
72     require(newOwner != address(0));
73     emit OwnershipTransferred(_owner, newOwner);
74     _owner = newOwner;
75   }
76   
77   // Set _ownershipLocked flag to lock contract owner forever
78   function lockOwnership() public onlyOwner {
79 	require(_ownershipLocked == 0);
80 	emit OwnershipLocked(_owner);
81     _ownershipLocked = 1;
82   }
83 
84   uint256[50] private ______gap;
85 }
86 
87 interface IERC20 {
88   function totalSupply() external view returns (uint256);
89 
90   function balanceOf(address who) external view returns (uint256);
91 
92   function allowance(address owner, address spender)
93     external view returns (uint256);
94 
95   function transfer(address to, uint256 value) external returns (bool);
96 
97   function approve(address spender, uint256 value)
98     external returns (bool);
99 
100   function transferFrom(address from, address to, uint256 value)
101     external returns (bool);
102 
103   event Transfer(
104     address indexed from,
105     address indexed to,
106     uint256 value
107   );
108 
109   event Approval(
110     address indexed owner,
111     address indexed spender,
112     uint256 value
113   );
114 }
115 
116 contract ERC20Detailed is Initializable, IERC20 {
117   string private _name;
118   string private _symbol;
119   uint8 private _decimals;
120 
121   function initialize(string name, string symbol, uint8 decimals) internal initializer {
122     _name = name;
123     _symbol = symbol;
124     _decimals = decimals;
125   }
126 
127   function name() public view returns(string) {
128     return _name;
129   }
130 
131   function symbol() public view returns(string) {
132     return _symbol;
133   }
134 
135   function decimals() public view returns(uint8) {
136     return _decimals;
137   }
138 
139   uint256[50] private ______gap;
140 }
141 
142 library SafeMath {
143 
144     function add(uint256 a, uint256 b) internal pure returns (uint256) {
145         uint256 c = a + b;
146         require(c >= a, "SafeMath: addition overflow");
147 
148         return c;
149     }
150 
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180 
181         return c;
182     }
183 
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         return mod(a, b, "SafeMath: modulo by zero");
186     }
187 
188     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b != 0, errorMessage);
190         return a % b;
191     }
192 }
193 
194 contract MIBASE is ERC20Detailed, Ownable {
195     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
196     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
197     // order to minimize this risk, we adhere to the following guidelines:
198     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
199     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
200     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
201     //    multiplying by the inverse rate, you should divide by the normal rate)
202     // 2) Gon balances converted into Fragments are always rounded down (truncated).
203     //
204     // We make the following guarantees:
205     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
206     //   be decreased by precisely x Fragments, and B's external balance will be precisely
207     //   increased by x Fragments.
208     //
209     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
210     // This is because, for any conversion function 'f()' that has non-zero rounding error,
211     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
212     using SafeMath for uint256;
213 
214     modifier validRecipient(address to) {
215         require(to != address(0x0));
216         require(to != address(this));
217         _;
218     }
219 
220     uint256 private constant DECIMALS = 9;
221     uint256 private constant MAX_UINT256 = ~uint256(0);
222     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 55000 * 10**DECIMALS;
223 
224     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
225     // Use the highest value that fits in a uint256 for max granularity.
226     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
227 
228     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
229     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
230 
231     uint256 private _totalSupply;
232     uint256 private _gonsPerFragment;
233     mapping(address => uint256) private _gonBalances;
234     
235     IERC20 BASETOKEN;
236     uint256 public lastTrackedBaseSupply;
237     bool public baseSupplyHasBeenInitilized = false;
238 
239     // This is denominated in Fragments, because the gons-fragments conversion might change before
240     // it's fully paid.
241     mapping (address => mapping (address => uint256)) private _allowedFragments;
242     
243     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
244     
245     function setREBASEcontract (IERC20 _basetoken) onlyOwner public {
246         BASETOKEN = _basetoken;
247     }
248     
249     // only callable once
250     function initBaseTotalSupply (uint256 _ts) onlyOwner public {
251       //  require(!baseSupplyHasBeenInitilized, 'DONE');
252         lastTrackedBaseSupply = _ts;
253         baseSupplyHasBeenInitilized = true;
254     }
255     
256     function nextRebaseInfo()
257         external view
258         returns (uint256, bool)
259     {
260         uint256 baseTotalSupply = BASETOKEN.totalSupply();
261         uint256 multiplier;
262         uint256 maxDebase =9000;
263         
264         
265         bool rebaseIsPositive = false;
266         if (baseTotalSupply > lastTrackedBaseSupply) {
267             
268            multiplier = (baseTotalSupply.sub(lastTrackedBaseSupply)).mul(10000).div(lastTrackedBaseSupply);
269            if(multiplier >= 10000){
270                multiplier= maxDebase;
271            }
272             
273         } else if (lastTrackedBaseSupply > baseTotalSupply) {
274         
275          multiplier = (lastTrackedBaseSupply.sub(baseTotalSupply)).mul(10000).div(lastTrackedBaseSupply).mul(2);
276            
277             rebaseIsPositive = true;
278         }
279 
280         return (multiplier, rebaseIsPositive);
281     }
282 
283     /**
284      * @dev Notifies Fragments contract about a new rebase cycle.
285      * @return The total number of fragments after the supply adjustment.
286      */
287     function rebase()
288         external
289         returns (uint256)
290     {
291         
292         uint256 baseTotalSupply = BASETOKEN.totalSupply();
293         uint256 multiplier;
294         uint256 maxDebase =9000;
295         require(baseTotalSupply != lastTrackedBaseSupply, 'NOT YET PLEASE WAIT');
296         if (baseTotalSupply > lastTrackedBaseSupply) {
297             
298               multiplier = (baseTotalSupply.sub(lastTrackedBaseSupply)).mul(10000).div(lastTrackedBaseSupply);
299               
300                if(multiplier >= 10000){
301                multiplier= maxDebase;
302            }
303             
304         } else if (lastTrackedBaseSupply > baseTotalSupply) {
305             
306             multiplier = (lastTrackedBaseSupply.sub(baseTotalSupply)).mul(10000).div(lastTrackedBaseSupply).mul(2);
307         }
308         
309         uint256 modification;
310         modification = _totalSupply.mul(multiplier).div(10000);
311         if (baseTotalSupply > lastTrackedBaseSupply) {
312             _totalSupply = _totalSupply.sub(modification);
313            
314         } else {
315             _totalSupply = _totalSupply.add(modification);
316         }
317 
318         if (_totalSupply > MAX_SUPPLY) {
319             _totalSupply = MAX_SUPPLY;
320         }
321 
322         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
323         
324         lastTrackedBaseSupply = baseTotalSupply;
325 
326        
327 
328         emit LogRebase(block.timestamp, _totalSupply);
329         return _totalSupply;
330     }
331     
332     constructor() public {
333 		Ownable.initialize(msg.sender);
334 		ERC20Detailed.initialize("MirrorBase Protocol", "MiBASE", uint8(DECIMALS));
335         
336         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
337         _gonBalances[msg.sender] = TOTAL_GONS;
338         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
339 
340         emit Transfer(address(0x0), msg.sender, _totalSupply);
341     }
342 
343     /**
344      * @return The total number of fragments.
345      */
346     function totalSupply()
347         public
348         view
349         returns (uint256)
350     {
351         return _totalSupply;
352     }
353 
354     /**
355      * @param who The address to query.
356      * @return The balance of the specified address.
357      */
358     function balanceOf(address who)
359         public
360         view
361         returns (uint256)
362     {
363         return _gonBalances[who].div(_gonsPerFragment);
364     }
365 
366     /**
367      * @dev Transfer tokens to a specified address.
368      * @param to The address to transfer to.
369      * @param value The amount to be transferred.
370      * @return True on success, false otherwise.
371      */
372     function transfer(address to, uint256 value)
373         public
374         validRecipient(to)
375         returns (bool)
376     {
377         uint256 gonValue = value.mul(_gonsPerFragment);
378         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
379         _gonBalances[to] = _gonBalances[to].add(gonValue);
380         emit Transfer(msg.sender, to, value);
381         return true;
382     }
383 
384     /**
385      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
386      * @param owner_ The address which owns the funds.
387      * @param spender The address which will spend the funds.
388      * @return The number of tokens still available for the spender.
389      */
390     function allowance(address owner_, address spender)
391         public
392         view
393         returns (uint256)
394     {
395         return _allowedFragments[owner_][spender];
396     }
397 
398     /**
399      * @dev Transfer tokens from one address to another.
400      * @param from The address you want to send tokens from.
401      * @param to The address you want to transfer to.
402      * @param value The amount of tokens to be transferred.
403      */
404     function transferFrom(address from, address to, uint256 value)
405         public
406         validRecipient(to)
407         returns (bool)
408     {
409         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
410 
411         uint256 gonValue = value.mul(_gonsPerFragment);
412         _gonBalances[from] = _gonBalances[from].sub(gonValue);
413         _gonBalances[to] = _gonBalances[to].add(gonValue);
414         emit Transfer(from, to, value);
415 
416         return true;
417     }
418 
419     /**
420      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
421      * msg.sender. This method is included for ERC20 compatibility.
422      * increaseAllowance and decreaseAllowance should be used instead.
423      * Changing an allowance with this method brings the risk that someone may transfer both
424      * the old and the new allowance - if they are both greater than zero - if a transfer
425      * transaction is mined before the later approve() call is mined.
426      *
427      * @param spender The address which will spend the funds.
428      * @param value The amount of tokens to be spent.
429      */
430     function approve(address spender, uint256 value)
431         public
432         returns (bool)
433     {
434         _allowedFragments[msg.sender][spender] = value;
435         emit Approval(msg.sender, spender, value);
436         return true;
437     }
438 
439     /**
440      * @dev Increase the amount of tokens that an owner has allowed to a spender.
441      * This method should be used instead of approve() to avoid the double approval vulnerability
442      * described above.
443      * @param spender The address which will spend the funds.
444      * @param addedValue The amount of tokens to increase the allowance by.
445      */
446     function increaseAllowance(address spender, uint256 addedValue)
447         public
448         returns (bool)
449     {
450         _allowedFragments[msg.sender][spender] =
451             _allowedFragments[msg.sender][spender].add(addedValue);
452         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
453         return true;
454     }
455 
456     /**
457      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
458      *
459      * @param spender The address which will spend the funds.
460      * @param subtractedValue The amount of tokens to decrease the allowance by.
461      */
462     function decreaseAllowance(address spender, uint256 subtractedValue)
463         public
464         returns (bool)
465     {
466         uint256 oldValue = _allowedFragments[msg.sender][spender];
467         if (subtractedValue >= oldValue) {
468             _allowedFragments[msg.sender][spender] = 0;
469         } else {
470             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
471         }
472         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
473         return true;
474     }
475 }