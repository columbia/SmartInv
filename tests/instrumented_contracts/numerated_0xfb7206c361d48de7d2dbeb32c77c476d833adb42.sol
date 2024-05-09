1 pragma solidity 0.7.3;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract MultiOwnable {
35 
36     mapping (address => bool) public isOwner;
37     address[] public ownerHistory;
38 
39     event OwnerAddedEvent(address indexed _newOwner);
40     event OwnerRemovedEvent(address indexed _oldOwner);
41 
42     constructor() {
43         // Add default owner
44         address owner = msg.sender;
45         ownerHistory.push(owner);
46         isOwner[owner] = true;
47     }
48 
49     modifier onlyOwner() {
50         require(isOwner[msg.sender], "Only owners allowed");
51         _;
52     }
53 
54     function ownerHistoryCount() public view returns (uint) {
55         return ownerHistory.length;
56     }
57 
58     /** Add extra owner. */
59     function addOwner(address owner) onlyOwner public {
60         require(owner != address(0), "Only valid addresses allowed");
61         require(!isOwner[owner], "Owner is already added");
62         ownerHistory.push(owner);
63         isOwner[owner] = true;
64         emit OwnerAddedEvent(owner);
65     }
66 
67     /** Remove extra owner. */
68     function removeOwner(address owner) onlyOwner public {
69         require(isOwner[owner], "Owner is not defined");
70         isOwner[owner] = false;
71         emit OwnerRemovedEvent(owner);
72     }
73 }
74 
75 interface ERC20 {
76 
77     function balanceOf(address _owner) external view returns (uint256 balance);
78 
79     function transfer(address _to, uint256 _value) external returns (bool success);
80 
81     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
82 
83     function approve(address _spender, uint256 _value) external returns (bool success);
84 
85     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88 
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }
91 
92 abstract contract StandardToken is ERC20 {
93 
94     using SafeMath for uint;
95 
96     uint256 public totalSupply;
97 
98     mapping(address => uint256) balances;
99 
100     mapping(address => mapping(address => uint256)) allowed;
101 
102     function balanceOf(address _owner) public override virtual view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function transferInternal(address _from, address _to, uint256 _value) internal {
107         require(_to != address(0), "Forbidden to transfer to zero address");
108 
109         trackBalance(_from);
110         trackBalance(_to);
111 
112         balances[_from] = balances[_from].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         emit Transfer(msg.sender, _to, _value);
115     }
116 
117     function approveInternal(address _owner, address _spender, uint256 _value) internal returns (bool) {
118         require(_spender != address(0), "Forbidden to approve zero address");
119 
120         allowed[_owner][_spender] = _value;
121         emit Approval(_owner, _spender, _value);
122 
123         return true;
124     }
125 
126     function transfer(address _to, uint256 _value) public override virtual returns (bool) {
127         transferInternal(msg.sender, _to, _value);
128 
129         return true;
130     }
131 
132     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
133     /// @param _from Address from where tokens are withdrawn.
134     /// @param _to Address to where tokens are sent.
135     /// @param _value Number of tokens to transfer.
136     function transferFrom(address _from, address _to, uint256 _value) public override virtual returns (bool) {
137         require(_from != address(0), "Forbidden to transfer from zero address");
138         require(_to != address(0), "Forbidden to transfer to zero address");
139 
140         trackBalance(_from);
141         trackBalance(_to);
142 
143         balances[_from] = balances[_from].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146 
147         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
148 
149         emit Transfer(_from, _to, _value);
150 
151         return true;
152     }
153 
154     /// @dev Sets approved amount of tokens for spender. Returns success.
155     /// @param _spender Address of allowed account.
156     /// @param _value Number of approved tokens.
157     function approve(address _spender, uint256 _value) public override virtual returns (bool) {
158         return approveInternal(msg.sender, _spender, _value);
159     }
160 
161     /// @dev Returns number of allowed tokens for given address.
162     /// @param _owner Address of token owner.
163     /// @param _spender Address of token spender.
164     function allowance(address _owner, address _spender) public override virtual view returns (uint256 remaining) {
165         return allowed[_owner][_spender];
166     }
167 
168     function trackBalance(address account) public virtual;
169 }
170 
171 contract CommonToken is StandardToken, MultiOwnable {
172     using SafeMath for uint;
173 
174     struct Dividend {
175         uint256 amount;
176         uint256 block;
177     }
178 
179     struct UserDividend {
180         uint256 lastClaimedDividend;
181         uint256 balanceTillDividend;
182     }
183 
184     string public constant name   = 'BRKROFX';
185     string public constant symbol = 'BRKROFX';
186     uint8 public constant decimals = 18;
187 
188     uint256 public saleLimit;   // 30% of tokens for sale (10% presale & 20% public sale).
189 
190     // The main account that holds all tokens at the beginning and during tokensale.
191     address public seller; // Seller address (main holder of tokens)
192 
193     address public distributor; // Distributor address
194 
195     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
196     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
197 
198     // Lock the transfer functions during tokensales to prevent price speculations.
199     bool public locked = true;
200 
201     mapping (address => uint256) public nonces;
202     bytes32 public immutable PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
203     bytes32 public immutable DOMAIN_SEPARATOR;
204 
205     mapping (address => bool) public dividendDistributors;
206 
207     Dividend [] public dividends;
208     mapping(address => UserDividend) public userDividends;
209     mapping(address => mapping(uint256 => uint256)) public balanceByDividends;
210 
211     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
212     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
213     event Burn(address indexed _burner, uint256 _value);
214     event Unlock();
215     event DividendAdded(uint256 _dividendId, uint256 _value, uint256 _block);
216     event DividendClaimed(address _account, uint256 _dividendId, uint256 _value);
217 
218     constructor(
219         address _seller
220     ) MultiOwnable() {
221 
222         totalSupply = 1_000_000_000 ether;
223         saleLimit   = 300_000_000 ether;
224 
225         seller = _seller;
226         distributor = msg.sender;
227 
228         uint sellerTokens = totalSupply;
229         balances[seller] = sellerTokens;
230         emit Transfer(address(0x0), seller, sellerTokens);
231 
232         uint256 chainId;
233         assembly {chainId := chainid()}
234 
235         DOMAIN_SEPARATOR = keccak256(
236             abi.encode(
237                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
238                 keccak256(bytes(name)),
239                 keccak256(bytes('1')),
240                 chainId,
241                 address(this)
242             )
243         );
244     }
245 
246     modifier ifUnlocked(address _from) {
247         require(!locked, "Allowed only if unlocked");
248         _;
249     }
250 
251     modifier onlyDistributor() {
252         require(msg.sender == distributor, "Allowed only for distributor");
253         _;
254     }
255 
256     modifier onlyDividendDistributor() {
257         require(dividendDistributors[msg.sender], "Allowed only for dividend distributor");
258         _;
259     }
260 
261     /** Can be called once by super owner. */
262     function unlock() onlyOwner public {
263         require(locked, "I am locked");
264         locked = false;
265         emit Unlock();
266     }
267 
268     /**
269      * An address can become a new seller only in case it has no tokens.
270      * This is required to prevent stealing of tokens  from newSeller via
271      * 2 calls of this function.
272      */
273     function changeSeller(address newSeller) onlyOwner public returns (bool) {
274         require(newSeller != address(0), "Invalid seller address");
275         require(seller != newSeller, "New seller is same");
276 
277         // To prevent stealing of tokens from newSeller via 2 calls of changeSeller:
278         require(balances[newSeller] == 0, "New seller balance is not empty");
279 
280         address oldSeller = seller;
281         uint256 unsoldTokens = balances[oldSeller];
282         balances[oldSeller] = 0;
283         balances[newSeller] = unsoldTokens;
284         emit Transfer(oldSeller, newSeller, unsoldTokens);
285 
286         seller = newSeller;
287         emit ChangeSellerEvent(oldSeller, newSeller);
288         return true;
289     }
290 
291     function changeDistributor(address newDistributor) onlyOwner public returns (bool) {
292         distributor = newDistributor;
293 
294         return true;
295     }
296 
297     /**
298      * User-friendly alternative to sell() function.
299      */
300     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
301         return sell(_to, _value * 1e18);
302     }
303 
304     function sell(address _to, uint256 _value) onlyDistributor public returns (bool) {
305 
306         // Check that we are not out of limit and still can sell tokens:
307         require(tokensSold.add(_value) <= saleLimit, "Sell exceeds allowed limit");
308 
309         require(_to != address(0), "Can't sell to zero address");
310         require(_value > 0, "_value is 0");
311         require(_value <= balances[seller], "Can't sell more tokens then available");
312 
313         balances[seller] = balances[seller].sub(_value);
314         balances[_to] = balances[_to].add(_value);
315         emit Transfer(seller, _to, _value);
316 
317         totalSales++;
318         tokensSold = tokensSold.add(_value);
319         emit SellEvent(seller, _to, _value);
320         return true;
321     }
322 
323     /**
324      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
325      */
326     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender) public override returns (bool) {
327         return super.transfer(_to, _value);
328     }
329 
330     /**
331      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
332      */
333     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from) public override returns (bool) {
334         return super.transferFrom(_from, _to, _value);
335     }
336 
337     function burn(uint256 _value) public returns (bool) {
338         require(_value > 0, "_value is 0");
339 
340         balances[msg.sender] = balances[msg.sender].sub(_value);
341         totalSupply = totalSupply.sub(_value);
342         emit Transfer(msg.sender, address(0x0), _value);
343         emit Burn(msg.sender, _value);
344         return true;
345     }
346 
347     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
348         require(deadline >= block.timestamp, 'CommonToken: expired deadline');
349 
350         bytes32 digest = keccak256(
351             abi.encodePacked(
352                 '\x19\x01',
353                 DOMAIN_SEPARATOR,
354                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
355             )
356         );
357 
358         address recoveredAddress = ecrecover(digest, v, r, s);
359 
360         require(recoveredAddress != address(0) && recoveredAddress == owner, 'CommonToken: invalid permit');
361 
362         approveInternal(owner, spender, value);
363     }
364 
365     function transferByPermit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public {
366         permit(owner, spender, value, deadline, v, r, s);
367 
368         require(msg.sender == spender, "CommonToken: spender should be method caller");
369 
370         transferFrom(owner, spender, value);
371     }
372 
373     function dividendsCount() public view returns (uint256 count) {
374         return dividends.length;
375     }
376 
377     function setDividendsDistributor(address _dividendDistributor, bool _allowed) public onlyOwner {
378         dividendDistributors[_dividendDistributor] = _allowed;
379     }
380 
381     function addDividend(uint256 _dividendTokens) public onlyDividendDistributor {
382         require(_dividendTokens > 0, "CommonToken: not enough dividend tokens shared");
383         require(balanceOf(msg.sender) >= _dividendTokens, "CommonToken: not enough balance to create dividend");
384 
385         dividends.push(Dividend(_dividendTokens, block.number));
386 
387         transferInternal(msg.sender, address(this), _dividendTokens);
388 
389         emit DividendAdded(dividends.length - 1, _dividendTokens, block.number);
390     }
391 
392     function claimDividend() public {
393         claimDividendsFor(msg.sender, 1);
394     }
395 
396     function claimDividends(uint256 _dividendsCount) public {
397         claimDividendsFor(msg.sender, _dividendsCount);
398     }
399 
400     function claimAllDividends() public {
401         claimAllDividendsFor(msg.sender);
402     }
403 
404     function claimDividendFor(address _account) public {
405         claimDividendsFor(_account, 1);
406     }
407 
408     function claimDividendsFor(address _account, uint256 _dividendsCount) public {
409         require(_dividendsCount > 0, "CommonToken: Dividends count to claim should be greater than 0");
410         require(dividends.length > 0, "CommonToken: No dividends present");
411 
412         trackBalance(_account);
413 
414         uint256 _fromDividend = userDividends[_account].lastClaimedDividend;
415         uint256 _toDividend = _fromDividend.add(_dividendsCount);
416 
417         require(_toDividend <= dividends.length, "CommonToken: no dividends available for claim");
418 
419         uint256 totalDividends = 0;
420 
421         for (uint256 i = _fromDividend; i < _toDividend; i++) {
422             uint256 dividendsFraction = dividends[i].amount.mul(balanceByDividends[_account][i]).div(totalSupply);
423             totalDividends = totalDividends.add(dividendsFraction);
424 
425             emit DividendClaimed(_account, i, dividendsFraction);
426         }
427 
428         userDividends[_account].lastClaimedDividend = _toDividend;
429 
430         transferInternal(address(this), _account, totalDividends);
431 
432         emit Transfer(address(this), _account, totalDividends);
433     }
434 
435     function claimAllDividendsFor(address _account) public {
436         claimDividendsFor(_account, dividends.length.sub(userDividends[_account].lastClaimedDividend));
437     }
438 
439     function trackBalance(address account) public override {
440         if (dividends.length == 0) {
441             return;
442         }
443 
444         if (balanceOf(account) == 0 && userDividends[account].lastClaimedDividend == 0) {
445             userDividends[account].lastClaimedDividend = dividends.length;
446 
447             return;
448         }
449 
450         if (userDividends[account].balanceTillDividend < dividends.length) {
451             for (uint256 i = userDividends[account].balanceTillDividend; i < dividends.length; i++) {
452                 balanceByDividends[account][i] = balanceOf(account);
453             }
454 
455             userDividends[account].balanceTillDividend = dividends.length;
456         }
457     }
458 }
459 
460 contract ProdToken is CommonToken {
461     constructor() CommonToken(
462         0xF774c190CDAD67578f7181F74323F996041cAcfd
463     ) {}
464 }