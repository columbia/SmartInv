1 pragma solidity 0.4.24;
2 
3 // SOURCE https://github.com/ampleforth/uFragments/blob/master/contracts/UFragments.sol
4 // Major portions of this contract are based on AMPL and OpenZepplin contracts
5  
6 contract Initializable {
7 
8   bool private initialized;
9   bool private initializing;
10 
11   modifier initializer() {
12     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
13 
14     bool wasInitializing = initializing;
15     initializing = true;
16     initialized = true;
17 
18     _;
19 
20     initializing = wasInitializing;
21   }
22 
23   function isConstructor() private view returns (bool) {
24     uint256 cs;
25     assembly { cs := extcodesize(address) }
26     return cs == 0;
27   }
28 
29   uint256[50] private ______gap;
30 }
31 
32 contract Ownable is Initializable {
33 
34   address private _owner;
35   uint256 private _ownershipLocked;
36 
37   event OwnershipLocked(address lockedOwner);
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   function initialize(address sender) internal initializer {
46     _owner = sender;
47 	_ownershipLocked = 0;
48   }
49 
50   function owner() public view returns(address) {
51     return _owner;
52   }
53 
54   modifier onlyOwner() {
55     require(isOwner());
56     _;
57   }
58 
59   function isOwner() public view returns(bool) {
60     return msg.sender == _owner;
61   }
62 
63   function transferOwnership(address newOwner) public onlyOwner {
64     _transferOwnership(newOwner);
65   }
66 
67   function _transferOwnership(address newOwner) internal {
68     require(_ownershipLocked == 0);
69     require(newOwner != address(0));
70     emit OwnershipTransferred(_owner, newOwner);
71     _owner = newOwner;
72   }
73   
74   // Set _ownershipLocked flag to lock contract owner forever
75   function lockOwnership() public onlyOwner {
76 	require(_ownershipLocked == 0);
77 	emit OwnershipLocked(_owner);
78     _ownershipLocked = 1;
79   }
80 
81   uint256[50] private ______gap;
82 }
83 
84 interface IERC20 {
85   function totalSupply() external view returns (uint256);
86 
87   function balanceOf(address who) external view returns (uint256);
88 
89   function allowance(address owner, address spender)
90     external view returns (uint256);
91 
92   function transfer(address to, uint256 value) external returns (bool);
93 
94   function approve(address spender, uint256 value)
95     external returns (bool);
96 
97   function transferFrom(address from, address to, uint256 value)
98     external returns (bool);
99 
100   event Transfer(
101     address indexed from,
102     address indexed to,
103     uint256 value
104   );
105 
106   event Approval(
107     address indexed owner,
108     address indexed spender,
109     uint256 value
110   );
111 }
112 
113 contract ERC20Detailed is Initializable, IERC20 {
114   string private _name;
115   string private _symbol;
116   uint8 private _decimals;
117 
118   function initialize(string name, string symbol, uint8 decimals) internal initializer {
119     _name = name;
120     _symbol = symbol;
121     _decimals = decimals;
122   }
123 
124   function name() public view returns(string) {
125     return _name;
126   }
127 
128   function symbol() public view returns(string) {
129     return _symbol;
130   }
131 
132   function decimals() public view returns(uint8) {
133     return _decimals;
134   }
135 
136   uint256[50] private ______gap;
137 }
138 
139 library SafeMath {
140 
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b > 0, errorMessage);
176         uint256 c = a / b;
177 
178         return c;
179     }
180 
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         return mod(a, b, "SafeMath: modulo by zero");
183     }
184 
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 contract EXBASE is ERC20Detailed, Ownable {
192     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
193     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
194     // order to minimize this risk, we adhere to the following guidelines:
195     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
196     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
197     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
198     //    multiplying by the inverse rate, you should divide by the normal rate)
199     // 2) Gon balances converted into Fragments are always rounded down (truncated).
200     //
201     // We make the following guarantees:
202     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
203     //   be decreased by precisely x Fragments, and B's external balance will be precisely
204     //   increased by x Fragments.
205     //
206     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
207     // This is because, for any conversion function 'f()' that has non-zero rounding error,
208     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
209     using SafeMath for uint256;
210 
211     modifier validRecipient(address to) {
212         require(to != address(0x0));
213         require(to != address(this));
214         _;
215     }
216 
217     uint256 private constant DECIMALS = 9;
218     uint256 private constant MAX_UINT256 = ~uint256(0);
219     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 20000 * 10**DECIMALS;
220 
221     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
222     // Use the highest value that fits in a uint256 for max granularity.
223     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
224 
225     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
226     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
227 
228     uint256 private _totalSupply;
229     uint256 private _gonsPerFragment;
230     mapping(address => uint256) private _gonBalances;
231     
232     IERC20 BASETOKEN;
233     uint256 public lastTrackedBaseSupply;
234     bool public baseSupplyHasBeenInitilized = false;
235 
236     // This is denominated in Fragments, because the gons-fragments conversion might change before
237     // it's fully paid.
238     mapping (address => mapping (address => uint256)) private _allowedFragments;
239     
240     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
241     
242     function setBASEAddress (IERC20 _basetoken) onlyOwner public {
243         BASETOKEN = _basetoken;
244     }
245     
246     // only callable once
247     function initBaseTotalSupply (uint256 _ts) onlyOwner public {
248         require(!baseSupplyHasBeenInitilized, 'SUPPLY ALREADY SET');
249         lastTrackedBaseSupply = _ts;
250         baseSupplyHasBeenInitilized = true;
251     }
252     
253     function nextRebaseInfo()
254         external view
255         returns (uint256, bool)
256     {
257         uint256 baseTotalSupply = BASETOKEN.totalSupply();
258         uint256 multiplier;
259         bool rebaseIsPositive = true;
260         if (baseTotalSupply > lastTrackedBaseSupply) {
261             multiplier = (baseTotalSupply.sub(lastTrackedBaseSupply)).mul(10000).div(lastTrackedBaseSupply).mul(2);
262         } else if (lastTrackedBaseSupply > baseTotalSupply) {
263             multiplier = (lastTrackedBaseSupply.sub(baseTotalSupply)).mul(10000).div(lastTrackedBaseSupply).div(2);
264             rebaseIsPositive = false;
265         }
266 
267         return (multiplier, rebaseIsPositive);
268     }
269 
270     /**
271      * @dev Notifies Fragments contract about a new rebase cycle.
272      * @return The total number of fragments after the supply adjustment.
273      */
274     function rebase()
275         external
276         returns (uint256)
277     {
278         
279         uint256 baseTotalSupply = BASETOKEN.totalSupply();
280         uint256 multiplier;
281         require(baseTotalSupply != lastTrackedBaseSupply, 'NOT YET');
282         if (baseTotalSupply > lastTrackedBaseSupply) {
283             multiplier = (baseTotalSupply.sub(lastTrackedBaseSupply)).mul(10000).div(lastTrackedBaseSupply).mul(2);
284         } else if (lastTrackedBaseSupply > baseTotalSupply) {
285             multiplier = (lastTrackedBaseSupply.sub(baseTotalSupply)).mul(10000).div(lastTrackedBaseSupply).div(2);
286         }
287         
288         uint256 modification;
289         modification = _totalSupply.mul(multiplier).div(10000);
290         if (baseTotalSupply > lastTrackedBaseSupply) {
291             _totalSupply = _totalSupply.add(modification);
292             // _totalSupply = _totalSupply.add(modification.mul(2));
293         } else {
294             _totalSupply = _totalSupply.sub(modification);
295         }
296 
297         if (_totalSupply > MAX_SUPPLY) {
298             _totalSupply = MAX_SUPPLY;
299         }
300 
301         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
302         
303         lastTrackedBaseSupply = baseTotalSupply;
304 
305         // From this point forward, _gonsPerFragment is taken as the source of truth.
306         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
307         // conversion rate.
308         // This means our applied supplyDelta can deviate from the requested supplyDelta,
309         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
310         //
311         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
312         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
313         // ever increased, it must be re-included.
314         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
315 
316         emit LogRebase(block.timestamp, _totalSupply);
317         return _totalSupply;
318     }
319     
320     constructor() public {
321 		Ownable.initialize(msg.sender);
322 		ERC20Detailed.initialize("exbase.finance", "EXBASE", uint8(DECIMALS));
323         
324         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
325         _gonBalances[msg.sender] = TOTAL_GONS;
326         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
327 
328         emit Transfer(address(0x0), msg.sender, _totalSupply);
329     }
330 
331     /**
332      * @return The total number of fragments.
333      */
334     function totalSupply()
335         public
336         view
337         returns (uint256)
338     {
339         return _totalSupply;
340     }
341 
342     /**
343      * @param who The address to query.
344      * @return The balance of the specified address.
345      */
346     function balanceOf(address who)
347         public
348         view
349         returns (uint256)
350     {
351         return _gonBalances[who].div(_gonsPerFragment);
352     }
353 
354     /**
355      * @dev Transfer tokens to a specified address.
356      * @param to The address to transfer to.
357      * @param value The amount to be transferred.
358      * @return True on success, false otherwise.
359      */
360     function transfer(address to, uint256 value)
361         public
362         validRecipient(to)
363         returns (bool)
364     {
365         uint256 gonValue = value.mul(_gonsPerFragment);
366         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
367         _gonBalances[to] = _gonBalances[to].add(gonValue);
368         emit Transfer(msg.sender, to, value);
369         return true;
370     }
371 
372     /**
373      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
374      * @param owner_ The address which owns the funds.
375      * @param spender The address which will spend the funds.
376      * @return The number of tokens still available for the spender.
377      */
378     function allowance(address owner_, address spender)
379         public
380         view
381         returns (uint256)
382     {
383         return _allowedFragments[owner_][spender];
384     }
385 
386     /**
387      * @dev Transfer tokens from one address to another.
388      * @param from The address you want to send tokens from.
389      * @param to The address you want to transfer to.
390      * @param value The amount of tokens to be transferred.
391      */
392     function transferFrom(address from, address to, uint256 value)
393         public
394         validRecipient(to)
395         returns (bool)
396     {
397         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
398 
399         uint256 gonValue = value.mul(_gonsPerFragment);
400         _gonBalances[from] = _gonBalances[from].sub(gonValue);
401         _gonBalances[to] = _gonBalances[to].add(gonValue);
402         emit Transfer(from, to, value);
403 
404         return true;
405     }
406 
407     /**
408      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
409      * msg.sender. This method is included for ERC20 compatibility.
410      * increaseAllowance and decreaseAllowance should be used instead.
411      * Changing an allowance with this method brings the risk that someone may transfer both
412      * the old and the new allowance - if they are both greater than zero - if a transfer
413      * transaction is mined before the later approve() call is mined.
414      *
415      * @param spender The address which will spend the funds.
416      * @param value The amount of tokens to be spent.
417      */
418     function approve(address spender, uint256 value)
419         public
420         returns (bool)
421     {
422         _allowedFragments[msg.sender][spender] = value;
423         emit Approval(msg.sender, spender, value);
424         return true;
425     }
426 
427     /**
428      * @dev Increase the amount of tokens that an owner has allowed to a spender.
429      * This method should be used instead of approve() to avoid the double approval vulnerability
430      * described above.
431      * @param spender The address which will spend the funds.
432      * @param addedValue The amount of tokens to increase the allowance by.
433      */
434     function increaseAllowance(address spender, uint256 addedValue)
435         public
436         returns (bool)
437     {
438         _allowedFragments[msg.sender][spender] =
439             _allowedFragments[msg.sender][spender].add(addedValue);
440         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
441         return true;
442     }
443 
444     /**
445      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
446      *
447      * @param spender The address which will spend the funds.
448      * @param subtractedValue The amount of tokens to decrease the allowance by.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue)
451         public
452         returns (bool)
453     {
454         uint256 oldValue = _allowedFragments[msg.sender][spender];
455         if (subtractedValue >= oldValue) {
456             _allowedFragments[msg.sender][spender] = 0;
457         } else {
458             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
459         }
460         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
461         return true;
462     }
463 }