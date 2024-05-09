1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error.
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a / b;
27         return c;
28     }
29 
30     /**
31      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42       uint256 c = a + b;
43       assert(c >= a);
44       return c;
45     }
46 
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization
53  *      control functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56 
57     // Public variable with address of owner
58     address public owner;
59 
60     /**
61      * Log ownership transference
62      */
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev The Ownable constructor sets the original `owner` of the
67      *      contract to the sender account.
68      */
69     function Ownable() public {
70         // Set the contract creator as the owner
71         owner = msg.sender;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         // Check that sender is owner
79         require(msg.sender == owner);
80         _;
81     }
82 
83     /**
84      * @dev Allows the current owner to transfer control of the contract to a newOwner.
85      * @param newOwner The address to transfer ownership to.
86      */
87     function transferOwnership(address newOwner) onlyOwner public {
88         // Check for a non-null owner
89         require(newOwner != address(0));
90         // Log ownership transference
91         OwnershipTransferred(owner, newOwner);
92         // Set new owner
93         owner = newOwner;
94     }
95 
96 }
97 
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 
112 /**
113  * @title Qwasder Token contract.
114  * @dev Custom ERC20 Token.
115  */
116 contract QwasderToken is ERC20Basic, Ownable {
117 
118     using SafeMath for uint256;
119 
120     /**
121      * BasicToken data.
122      */
123     uint256 public totalSupply_ = 0;
124     mapping(address => uint256) balances;
125 
126     /**
127      * StandardToken data.
128      */
129     mapping (address => mapping (address => uint256)) internal allowed;
130 
131     /**
132      * MintableToken data.
133      */
134     bool public mintingFinished = false;
135 
136     /**
137      * GrantableToken modifiers.
138      */
139     uint256 public grantsUnlock = 1523318400; // Tue, 10 Apr 2018 00:00:00 +0000 (GMT)
140     uint256 public reservedSupply = 20000000000000000000000000;
141     // -------------------------------------^
142 
143     /**
144      * CappedToken data.
145      */
146     uint256 public cap = 180000000000000000000000000;
147     // ---------------------------^
148 
149     /**
150      * DetailedERC20 data.
151      */
152     string public name     = "Qwasder";
153     string public symbol   = "QWS";
154     uint8  public decimals = 18;
155 
156     /**
157      * QwasderToken data.
158      */
159     mapping (address => bool) partners;
160     mapping (address => bool) blacklisted;
161     mapping (address => bool) freezed;
162     uint256 public publicRelease   = 1525046400; // Mon, 30 Apr 2018 00:00:00 +0000 (GMT)
163     uint256 public partnersRelease = 1539129600; // Wed, 10 Oct 2018 00:00:00 +0000 (GMT)
164     uint256 public hardcap = 200000000000000000000000000;
165     // -------------------------------^
166 
167     /**
168      * ERC20Basic events.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * ERC20 events.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 
177     /**
178      * MintableToken events.
179      */
180     event Mint(address indexed to, uint256 amount);
181     event MintFinished();
182 
183     /**
184      * GrantableToken events.
185      */
186     event Grant(address indexed to, uint256 amount);
187 
188     /**
189      * BurnableToken events.
190      */
191     event Burn(address indexed burner, uint256 value);
192 
193     /**
194      * QwasderToken events.
195      */
196     event UpdatedPublicReleaseDate(uint256 date);
197     event UpdatedPartnersReleaseDate(uint256 date);
198     event UpdatedGrantsLockDate(uint256 date);
199     event Blacklisted(address indexed account);
200     event Freezed(address indexed investor);
201     event PartnerAdded(address indexed investor);
202     event PartnerRemoved(address indexed investor);
203     event Unfreezed(address indexed investor);
204 
205     /**
206      * Initializes contract.
207      */
208     function QwasderToken() public {
209         assert(reservedSupply < cap && reservedSupply.add(cap) == hardcap);
210         assert(publicRelease <= partnersRelease);
211         assert(grantsUnlock < partnersRelease);
212     }
213 
214     /**
215      * MintableToken modifiers.
216      */
217 
218     modifier canMint() {
219         require(!mintingFinished);
220         _;
221     }
222 
223     /**
224      * GrantableToken modifiers.
225      */
226 
227     modifier canGrant() {
228         require(now >= grantsUnlock && reservedSupply > 0);
229         _;
230     }
231 
232     /**
233      * ERC20Basic interface.
234      */
235 
236     /**
237      * @dev Gets the total raised token supply.
238      */
239     function totalSupply() public view returns (uint256 total) {
240         return totalSupply_;
241     }
242 
243     /**
244      * @dev Gets the balance of the specified address.
245      * @param investor The address to query the the balance of.
246      * @return An uint256 representing the amount owned by the passed address.
247      */
248     function balanceOf(address investor) public view returns (uint256 balance) {
249         return balances[investor];
250     }
251 
252     /**
253      * @dev Transfer tokens to a specified address.
254      * @param to The address which you want to transfer to.
255      * @param amount The amount of tokens to be transferred.
256      * @return A boolean that indicates if the operation was successful.
257      */
258     function transfer(address to, uint256 amount) public returns (bool success) {
259         require(!freezed[msg.sender] && !blacklisted[msg.sender]);
260         require(to != address(0) && !freezed[to] && !blacklisted[to]);
261         require((!partners[msg.sender] && now >= publicRelease) || now >= partnersRelease);
262         require(0 < amount && amount <= balances[msg.sender]);
263         balances[msg.sender] = balances[msg.sender].sub(amount);
264         balances[to] = balances[to].add(amount);
265         Transfer(msg.sender, to, amount);
266         return true;
267     }
268 
269     /**
270      * ERC20 interface.
271      */
272 
273     /**
274      * @dev Function to check the amount of tokens that an owner allowed to a spender.
275      * @param holder The address which owns the funds.
276      * @param spender The address which will spend the funds.
277      * @return A uint256 specifying the amount of tokens still available for the spender.
278      */
279     function allowance(address holder, address spender) public view returns (uint256 remaining) {
280         return allowed[holder][spender];
281     }
282 
283     /**
284      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285      *      Beware that changing an allowance with this method brings the risk that someone may use both
286      *      the old and the new allowance by unfortunate transaction ordering. One possible solution to
287      *      mitigate this race condition is to first reduce the spender's allowance to 0 and set the
288      *      desired value afterwards.
289      * @param spender The address which will spend the funds.
290      * @param amount The amount of tokens to be spent.
291      * @return A boolean that indicates if the operation was successful.
292      */
293     function approve(address spender, uint256 amount) public returns (bool success) {
294         allowed[msg.sender][spender] = amount;
295         Approval(msg.sender, spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev Transfer tokens from one address to another.
301      * @param from The address which you want to send tokens from.
302      * @param to The address which you want to transfer to.
303      * @param amount The amount of tokens to be transferred.
304      * @return A boolean that indicates if the operation was successful.
305      */
306     function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
307         require(!blacklisted[msg.sender]);
308         require(to != address(0) && !freezed[to] && !blacklisted[to]);
309         require(from != address(0) && !freezed[from] && !blacklisted[from]);
310         require((!partners[from] && now >= publicRelease) || now >= partnersRelease);
311         require(0 < amount && amount <= balances[from]);
312         require(amount <= allowed[from][msg.sender]);
313         balances[from] = balances[from].sub(amount);
314         balances[to] = balances[to].add(amount);
315         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
316         Transfer(from, to, amount);
317         return true;
318     }
319 
320     /**
321      * StandardToken interface.
322      */
323 
324     /**
325      * @dev Decrease the amount of tokens that an owner allowed to a spender.
326      * @param spender The address which will spend the funds.
327      * @param amount The amount of token to be decreased, in fraction units.
328      * @return A boolean that indicates if the operation was successful.
329      */
330     function decreaseApproval(address spender, uint256 amount) public returns (bool success) {
331         uint256 oldValue = allowed[msg.sender][spender];
332         if (amount > oldValue) {
333             allowed[msg.sender][spender] = 0;
334         } else {
335             allowed[msg.sender][spender] = oldValue.sub(amount);
336         }
337         Approval(msg.sender, spender, allowed[msg.sender][spender]);
338         return true;
339     }
340 
341     /**
342      * @dev Increase the amount of tokens that an owner allowed to a spender.
343      *      approve should be called when allowance(owner, spender) == 0. To
344      *      increment allowed value is better to use this function to avoid 2
345      *      calls (and wait until the first transaction is mined).
346      * @param spender The address which will spend the funds.
347      * @param amount The amount of token to be increased, in fraction units.
348      * @return A boolean that indicates if the operation was successful.
349      */
350     function increaseApproval(address spender, uint amount) public returns (bool success) {
351         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(amount);
352         Approval(msg.sender, spender, allowed[msg.sender][spender]);
353         return true;
354     }
355 
356     /**
357      * MintableToken interface.
358      */
359 
360     /**
361      * @dev Function to mint tokens to investors.
362      * @param to The address that will receive the minted tokens.
363      * @param amount The amount of tokens to mint, in fraction units.
364      * @return A boolean that indicates if the operation was successful.
365      */
366     function mint(address to, uint256 amount) onlyOwner canMint public returns (bool success) {
367         require(!freezed[to] && !blacklisted[to] && !partners[to]);
368         uint256 total = totalSupply_.add(amount);
369         require(total <= cap);
370         totalSupply_ = total;
371         balances[to] = balances[to].add(amount);
372         Mint(to, amount);
373         Transfer(address(0), to, amount);
374         return true;
375     }
376 
377     /**
378      * @dev Function to stop minting new tokens.
379      * @return True if the operation was successful.
380      */
381     function finishMinting() onlyOwner public returns (bool success) {
382         mintingFinished = true;
383         MintFinished();
384         return true;
385     }
386 
387     /**
388      * GrantableToken interface.
389      */
390 
391     /**
392      * @dev Function to mint tokens to partners (grants), including up to reserved tokens.
393      * @param to The address that will receive the minted tokens.
394      * @param amount The amount of tokens to mint, in fraction units.
395      * @return A boolean that indicates if the operation was successful.
396      */
397     function grant(address to, uint256 amount) onlyOwner canGrant public returns (bool success) {
398         require(!freezed[to] && !blacklisted[to] && partners[to]);
399         require(amount <= reservedSupply);
400         totalSupply_ = totalSupply_.add(amount);
401         reservedSupply = reservedSupply.sub(amount);
402         balances[to] = balances[to].add(amount);
403         Grant(to, amount);
404         Transfer(address(0), to, amount);
405         return true;
406     }
407 
408     /**
409      * BurnableToken interface.
410      */
411 
412     /**
413      * @dev Burns a specific amount of tokens.
414      * @param amount The amount of token to be burned, in fraction units.
415      * @return A boolean that indicates if the operation was successful.
416      */
417     function burn(uint256 amount) public returns (bool success) {
418         require(!freezed[msg.sender]);
419         require((!partners[msg.sender] && now >= publicRelease) || now >= partnersRelease);
420         require(amount > 0 && amount <= balances[msg.sender]);
421         balances[msg.sender] = balances[msg.sender].sub(amount);
422         totalSupply_ = totalSupply_.sub(amount);
423         Burn(msg.sender, amount);
424         Transfer(msg.sender, address(0), amount);
425         return true;
426     }
427 
428     /**
429      * QwasderToken interface.
430      */
431 
432     /**
433      * Add a new partner.
434      */
435     function addPartner(address investor) onlyOwner public returns (bool) {
436         require(investor != address(0));
437         require(!partners[investor] && !blacklisted[investor] && balances[investor] == 0);
438         partners[investor] = true;
439         PartnerAdded(investor);
440         return partners[investor];
441     }
442 
443     /**
444      * Remove a partner.
445      */
446     function removePartner(address investor) onlyOwner public returns (bool) {
447         require(partners[investor] && balances[investor] == 0);
448         partners[investor] = false;
449         PartnerRemoved(investor);
450         return !partners[investor];
451     }
452 
453     /**
454      * Freeze permanently an investor.
455      * WARNING: This will burn out any token sold to the blacklisted account.
456      */
457     function blacklist(address account) onlyOwner public returns (bool) {
458         require(account != address(0));
459         require(!blacklisted[account]);
460         blacklisted[account] = true;
461         totalSupply_ = totalSupply_.sub(balances[account]);
462         uint256 amount = balances[account];
463         balances[account] = 0;
464         Blacklisted(account);
465         Burn(account, amount);
466         return blacklisted[account];
467     }
468 
469     /**
470      * Freeze (temporarily) an investor.
471      */
472     function freeze(address investor) onlyOwner public returns (bool) {
473         require(investor != address(0));
474         require(!freezed[investor]);
475         freezed[investor] = true;
476         Freezed(investor);
477         return freezed[investor];
478     }
479 
480     /**
481      * Unfreeze an investor.
482      */
483     function unfreeze(address investor) onlyOwner public returns (bool) {
484         require(freezed[investor]);
485         freezed[investor] = false;
486         Unfreezed(investor);
487         return !freezed[investor];
488     }
489 
490     /**
491      * @dev Set a new release date for investor's transfers.
492      *      Must be executed before the current release date, and the new
493      *      date must be a later one. Up to one more week for security reasons.
494      * @param date UNIX timestamp of the new release date for investor's transfers.
495      * @return True if the operation was successful.
496      */
497     function setPublicRelease(uint256 date) onlyOwner public returns (bool success) {
498         require(now < publicRelease && date > publicRelease);
499         require(date.sub(publicRelease) <= 604800);
500         publicRelease = date;
501         assert(publicRelease <= partnersRelease);
502         UpdatedPublicReleaseDate(date);
503         return true;
504     }
505 
506     /**
507      * @dev Set a new release date for partners' transfers.
508      *      Must be executed before the current release date, and the new
509      *      date must be a later one. Up to one more week for security reasons.
510      * @param date UNIX timestamp of the new release date for partners' transfers.
511      * @return True if the operation was successful.
512      */
513     function setPartnersRelease(uint256 date) onlyOwner public returns (bool success) {
514         require(now < partnersRelease && date > partnersRelease);
515         require(date.sub(partnersRelease) <= 604800);
516         partnersRelease = date;
517         assert(grantsUnlock < partnersRelease);
518         UpdatedPartnersReleaseDate(date);
519         return true;
520     }
521 
522     /**
523      * @dev Function to set a new unlock date for partners' minting grants.
524      *      Must be executed before the current unlock date, and the new
525      *      date must be a later one. Up to one more week for security reasons.
526      * @param date UNIX timestamp of the new unlock date for partners' grants.
527      * @param extendLocking boolean value, true to extend the locking periods,
528      *        false to leave the current dates.
529      * @return True if the operation was successful.
530      */
531     function setGrantsUnlock(uint256 date, bool extendLocking) onlyOwner public returns (bool success) {
532         require(now < grantsUnlock && date > grantsUnlock);
533         if (extendLocking) {
534           uint256 delay = date.sub(grantsUnlock);
535           require(delay <= 604800);
536           grantsUnlock = date;
537           publicRelease = publicRelease.add(delay);
538           partnersRelease = partnersRelease.add(delay);
539           assert(publicRelease <= partnersRelease);
540           assert(grantsUnlock < partnersRelease);
541           UpdatedPublicReleaseDate(publicRelease);
542           UpdatedPartnersReleaseDate(partnersRelease);
543         }
544         else {
545           // Can set a date more than one week later, provided it is before the release date.
546           grantsUnlock = date;
547           assert(grantsUnlock < partnersRelease);
548         }
549         UpdatedGrantsLockDate(date);
550         return true;
551     }
552 
553     /**
554      * @dev Function to extend the transfer locking periods up to one more
555      *      week. Must be executed before the current public release date.
556      * @param delay The amount of hours to extend the locking period.
557      * @return True if the operation was successful.
558      */
559     function extendLockPeriods(uint delay, bool extendGrantLock) onlyOwner public returns (bool success) {
560         require(now < publicRelease && 0 < delay && delay <= 168);
561         delay = delay * 3600;
562         publicRelease = publicRelease.add(delay);
563         partnersRelease = partnersRelease.add(delay);
564         assert(publicRelease <= partnersRelease);
565         UpdatedPublicReleaseDate(publicRelease);
566         UpdatedPartnersReleaseDate(partnersRelease);
567         if (extendGrantLock) {
568             grantsUnlock = grantsUnlock.add(delay);
569             assert(grantsUnlock < partnersRelease);
570             UpdatedGrantsLockDate(grantsUnlock);
571         }
572         return true;
573     }
574 
575 }