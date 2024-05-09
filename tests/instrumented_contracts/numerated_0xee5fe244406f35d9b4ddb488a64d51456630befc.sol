1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4 
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7 
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address _owner) public view returns (uint256);
10     function transfer(address _to, uint256 _value) public returns (bool);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
12     function approve(address _spender, uint256 _value) public returns (bool);
13     function allowance(address _owner, address _spender) public view returns (uint256);
14 }
15 
16 contract ERC20Token is ERC20Interface {
17 
18     using SafeMath for uint256;
19 
20     // Total amount of tokens issued
21     uint256 internal totalTokenIssued;
22 
23     mapping(address => uint256) balances;
24     mapping(address => mapping (address => uint256)) internal allowed;
25 
26     function totalSupply() public view returns (uint256) {
27         return totalTokenIssued;
28     }
29 
30     /* Get the account balance for an address */
31     function balanceOf(address _owner) public view returns (uint256) {
32         return balances[_owner];
33     }
34 
35     /* Check whether an address is a contract address */
36     function isContract(address addr) internal view returns (bool) {
37         uint256 size;
38         assembly { size := extcodesize(addr) }
39         return (size > 0);
40     }
41 
42 
43     /* Transfer the balance from owner's account to another account */
44     function transfer(address _to, uint256 _amount) public returns (bool) {
45 
46         require(_to != address(0x0));
47 
48         // Do not allow to transfer token to contract address to avoid tokens getting stuck
49         require(isContract(_to) == false);
50 
51         // amount sent cannot exceed balance
52         require(balances[msg.sender] >= _amount);
53 
54         
55         // update balances
56         balances[msg.sender] = balances[msg.sender].sub(_amount);
57         balances[_to]        = balances[_to].add(_amount);
58 
59         // log event
60         emit Transfer(msg.sender, _to, _amount);
61         return true;
62     }
63     
64 
65     /* Allow _spender to withdraw from your account up to _amount */
66     function approve(address _spender, uint256 _amount) public returns (bool) {
67         
68         require(_spender != address(0x0));
69 
70         // update allowed amount
71         allowed[msg.sender][_spender] = _amount;
72 
73         // log event
74         emit Approval(msg.sender, _spender, _amount);
75         return true;
76     }
77 
78     /* Spender of tokens transfers tokens from the owner's balance */
79     /* Must be pre-approved by owner */
80     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
81         
82         require(_to != address(0x0));
83         
84         // Do not allow to transfer token to contract address to avoid tokens getting stuck
85         require(isContract(_to) == false);
86 
87         // balance checks
88         require(balances[_from] >= _amount);
89         require(allowed[_from][msg.sender] >= _amount);
90 
91         // update balances and allowed amount
92         balances[_from]            = balances[_from].sub(_amount);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
94         balances[_to]              = balances[_to].add(_amount);
95 
96         // log event
97         emit Transfer(_from, _to, _amount);
98         return true;
99     }
100 
101     /* Returns the amount of tokens approved by the owner */
102     /* that can be transferred by spender */
103     function allowance(address _owner, address _spender) public view returns (uint256) {
104         return allowed[_owner][_spender];
105     }
106 }
107 
108 contract Ownable {
109     address public owner;
110 
111     event OwnershipRenounced(address indexed previousOwner);
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116     * account.
117     */
118     function Ownable() public {
119         owner = msg.sender;
120     }
121 
122     /**
123     * @dev Throws if called by any account other than the owner.
124     */
125     modifier onlyOwner() {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     /**
131     * @dev Allows the current owner to transfer control of the contract to a newOwner.
132     * @param newOwner The address to transfer ownership to.
133     */
134     function transferOwnership(address newOwner) public onlyOwner {
135         require(newOwner != address(0));
136         emit OwnershipTransferred(owner, newOwner);
137         owner = newOwner;
138     }
139 
140     /**
141     * @dev Allows the current owner to relinquish control of the contract.
142     */
143     function renounceOwnership() public onlyOwner {
144         emit OwnershipRenounced(owner);
145         owner = address(0);
146     }
147 }
148 
149 library SafeMath {
150 
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a * b;
153         assert(a == 0 || c / a == b);
154         return c;
155     }
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         // assert(b > 0); // Solidity automatically throws when dividing by 0
158         return (a / b);
159     }
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         assert(b <= a);
162         return (a - b);
163     }
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         assert(c >= a);
167         return c;
168     }
169 }
170 
171 contract WhiteListManager is Ownable {
172 
173     // The list here will be updated by multiple separate WhiteList contracts
174     mapping (address => bool) public list;
175 
176     function unset(address addr) public onlyOwner {
177 
178         list[addr] = false;
179     }
180 
181     function unsetMany(address[] addrList) public onlyOwner {
182 
183         for (uint256 i = 0; i < addrList.length; i++) {
184             
185             unset(addrList[i]);
186         }
187     }
188 
189     function set(address addr) public onlyOwner {
190 
191         list[addr] = true;
192     }
193 
194     function setMany(address[] addrList) public onlyOwner {
195 
196         for (uint256 i = 0; i < addrList.length; i++) {
197             
198             set(addrList[i]);
199         }
200     }
201 
202     function isWhitelisted(address addr) public view returns (bool) {
203 
204         return list[addr];
205     }
206 }
207 
208 contract ShareToken is ERC20Token, WhiteListManager {
209 
210     using SafeMath for uint256;
211 
212     string public constant name = "ShareToken";
213     string public constant symbol = "SHR";
214     uint8  public constant decimals = 2;
215 
216     address public icoContract;
217 
218     // Any token amount must be multiplied by this const to reflect decimals
219     uint256 constant E2 = 10**2;
220 
221     mapping(address => bool) public rewardTokenLocked;
222     bool public mainSaleTokenLocked = true;
223 
224     uint256 public constant TOKEN_SUPPLY_MAINSALE_LIMIT = 1000000000 * E2; // 1,000,000,000 tokens (1 billion)
225     uint256 public constant TOKEN_SUPPLY_AIRDROP_LIMIT  = 6666666667; // 66,666,666.67 tokens (0.066 billion)
226     uint256 public constant TOKEN_SUPPLY_BOUNTY_LIMIT   = 33333333333; // 333,333,333.33 tokens (0.333 billion)
227 
228     uint256 public airDropTokenIssuedTotal;
229     uint256 public bountyTokenIssuedTotal;
230 
231     uint256 public constant TOKEN_SUPPLY_SEED_LIMIT      = 500000000 * E2; // 500,000,000 tokens (0.5 billion)
232     uint256 public constant TOKEN_SUPPLY_PRESALE_LIMIT   = 2500000000 * E2; // 2,500,000,000.00 tokens (2.5 billion)
233     uint256 public constant TOKEN_SUPPLY_SEED_PRESALE_LIMIT = TOKEN_SUPPLY_SEED_LIMIT + TOKEN_SUPPLY_PRESALE_LIMIT;
234 
235     uint256 public seedAndPresaleTokenIssuedTotal;
236 
237     uint8 private constant PRESALE_EVENT    = 0;
238     uint8 private constant MAINSALE_EVENT   = 1;
239     uint8 private constant BOUNTY_EVENT     = 2;
240     uint8 private constant AIRDROP_EVENT    = 3;
241 
242     function ShareToken() public {
243 
244         totalTokenIssued = 0;
245         airDropTokenIssuedTotal = 0;
246         bountyTokenIssuedTotal = 0;
247         seedAndPresaleTokenIssuedTotal = 0;
248         mainSaleTokenLocked = true;
249     }
250 
251     function unlockMainSaleToken() public onlyOwner {
252 
253         mainSaleTokenLocked = false;
254     }
255 
256     function lockMainSaleToken() public onlyOwner {
257 
258         mainSaleTokenLocked = true;
259     }
260 
261     function unlockRewardToken(address addr) public onlyOwner {
262 
263         rewardTokenLocked[addr] = false;
264     }
265 
266     function unlockRewardTokenMany(address[] addrList) public onlyOwner {
267 
268         for (uint256 i = 0; i < addrList.length; i++) {
269 
270             unlockRewardToken(addrList[i]);
271         }
272     }
273 
274     function lockRewardToken(address addr) public onlyOwner {
275 
276         rewardTokenLocked[addr] = true;
277     }
278 
279     function lockRewardTokenMany(address[] addrList) public onlyOwner {
280 
281         for (uint256 i = 0; i < addrList.length; i++) {
282 
283             lockRewardToken(addrList[i]);
284         }
285     }
286 
287     // Check if a given address is locked. The address can be in the whitelist or in the reward
288     function isLocked(address addr) public view returns (bool) {
289 
290         // Main sale is running, any addr is locked
291         if (mainSaleTokenLocked) {
292             return true;
293         } else {
294 
295             // Main sale is ended and thus any whitelist addr is unlocked
296             if (isWhitelisted(addr)) {
297                 return false;
298             } else {
299                 // If the addr is in the reward, it must be checked if locked
300                 // If the addr is not in the reward, it is considered unlocked
301                 return rewardTokenLocked[addr];
302             }
303         }
304     }
305 
306     function totalSupply() public view returns (uint256) {
307 
308         return totalTokenIssued.add(seedAndPresaleTokenIssuedTotal).add(airDropTokenIssuedTotal).add(bountyTokenIssuedTotal);
309     }
310 
311     function totalMainSaleTokenIssued() public view returns (uint256) {
312 
313         return totalTokenIssued;
314     }
315 
316     function totalMainSaleTokenLimit() public view returns (uint256) {
317 
318         return TOKEN_SUPPLY_MAINSALE_LIMIT;
319     }
320 
321     function totalPreSaleTokenIssued() public view returns (uint256) {
322 
323         return seedAndPresaleTokenIssuedTotal;
324     }
325 
326     function transfer(address _to, uint256 _amount) public returns (bool success) {
327 
328         require(isLocked(msg.sender) == false);    
329         require(isLocked(_to) == false);
330         
331         return super.transfer(_to, _amount);
332     }
333 
334     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
335         
336         require(isLocked(_from) == false);
337         require(isLocked(_to) == false);
338         
339         return super.transferFrom(_from, _to, _amount);
340     }
341 
342     function setIcoContract(address _icoContract) public onlyOwner {
343         
344         // Allow to set the ICO contract only once
345         require(icoContract == address(0));
346         require(_icoContract != address(0));
347 
348         icoContract = _icoContract;
349     }
350 
351     function sell(address buyer, uint256 tokens) public returns (bool success) {
352       
353         require (icoContract != address(0));
354         // The sell() method can only be called by the fixedly-set ICO contract
355         require (msg.sender == icoContract);
356         require (tokens > 0);
357         require (buyer != address(0));
358 
359         // Only whitelisted address can buy tokens. Otherwise, refund
360         require (isWhitelisted(buyer));
361 
362         require (totalTokenIssued.add(tokens) <= TOKEN_SUPPLY_MAINSALE_LIMIT);
363 
364         // Register tokens issued to the buyer
365         balances[buyer] = balances[buyer].add(tokens);
366 
367         // Update total amount of tokens issued
368         totalTokenIssued = totalTokenIssued.add(tokens);
369 
370         emit Transfer(address(MAINSALE_EVENT), buyer, tokens);
371 
372         return true;
373     }
374 
375     function rewardAirdrop(address _to, uint256 _amount) public onlyOwner {
376 
377         // this check also ascertains _amount is positive
378         require(_amount <= TOKEN_SUPPLY_AIRDROP_LIMIT);
379 
380         require(airDropTokenIssuedTotal < TOKEN_SUPPLY_AIRDROP_LIMIT);
381 
382         uint256 remainingTokens = TOKEN_SUPPLY_AIRDROP_LIMIT.sub(airDropTokenIssuedTotal);
383         if (_amount > remainingTokens) {
384             _amount = remainingTokens;
385         }
386 
387         // Register tokens to the receiver
388         balances[_to] = balances[_to].add(_amount);
389 
390         // Update total amount of tokens issued
391         airDropTokenIssuedTotal = airDropTokenIssuedTotal.add(_amount);
392 
393         // Lock the receiver
394         rewardTokenLocked[_to] = true;
395 
396         emit Transfer(address(AIRDROP_EVENT), _to, _amount);
397     }
398 
399     function rewardBounty(address _to, uint256 _amount) public onlyOwner {
400 
401         // this check also ascertains _amount is positive
402         require(_amount <= TOKEN_SUPPLY_BOUNTY_LIMIT);
403 
404         require(bountyTokenIssuedTotal < TOKEN_SUPPLY_BOUNTY_LIMIT);
405 
406         uint256 remainingTokens = TOKEN_SUPPLY_BOUNTY_LIMIT.sub(bountyTokenIssuedTotal);
407         if (_amount > remainingTokens) {
408             _amount = remainingTokens;
409         }
410 
411         // Register tokens to the receiver
412         balances[_to] = balances[_to].add(_amount);
413 
414         // Update total amount of tokens issued
415         bountyTokenIssuedTotal = bountyTokenIssuedTotal.add(_amount);
416 
417         // Lock the receiver
418         rewardTokenLocked[_to] = true;
419 
420         emit Transfer(address(BOUNTY_EVENT), _to, _amount);
421     }
422 
423     function rewardBountyMany(address[] addrList, uint256[] amountList) public onlyOwner {
424 
425         require(addrList.length == amountList.length);
426 
427         for (uint256 i = 0; i < addrList.length; i++) {
428 
429             rewardBounty(addrList[i], amountList[i]);
430         }
431     }
432 
433     function rewardAirdropMany(address[] addrList, uint256[] amountList) public onlyOwner {
434 
435         require(addrList.length == amountList.length);
436 
437         for (uint256 i = 0; i < addrList.length; i++) {
438 
439             rewardAirdrop(addrList[i], amountList[i]);
440         }
441     }
442 
443     function handlePresaleToken(address _to, uint256 _amount) public onlyOwner {
444 
445         require(_amount <= TOKEN_SUPPLY_SEED_PRESALE_LIMIT);
446 
447         require(seedAndPresaleTokenIssuedTotal < TOKEN_SUPPLY_SEED_PRESALE_LIMIT);
448 
449         uint256 remainingTokens = TOKEN_SUPPLY_SEED_PRESALE_LIMIT.sub(seedAndPresaleTokenIssuedTotal);
450         require (_amount <= remainingTokens);
451 
452         // Register tokens to the receiver
453         balances[_to] = balances[_to].add(_amount);
454 
455         // Update total amount of tokens issued
456         seedAndPresaleTokenIssuedTotal = seedAndPresaleTokenIssuedTotal.add(_amount);
457 
458         emit Transfer(address(PRESALE_EVENT), _to, _amount);
459 
460         // Also add to whitelist
461         set(_to);
462     }
463 
464     function handlePresaleTokenMany(address[] addrList, uint256[] amountList) public onlyOwner {
465 
466         require(addrList.length == amountList.length);
467 
468         for (uint256 i = 0; i < addrList.length; i++) {
469 
470             handlePresaleToken(addrList[i], amountList[i]);
471         }
472     }
473 }