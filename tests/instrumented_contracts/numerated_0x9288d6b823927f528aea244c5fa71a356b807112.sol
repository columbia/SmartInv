1 pragma solidity ^0.4.24;
2 
3 /*      _____    ______    ________ 
4  *     /     |  /      \  /        |
5  *     $$$$$ | /$$$$$$  | $$$$$$$$/ 
6  *        $$ | $$ |  $$/     $$ |  
7  *   __   $$ | $$ |          $$ |  
8  *  /  |  $$ | $$ |   __     $$ |  
9  *  $$ \__$$ | $$ \__/  |    $$ |
10  *  $$    $$/  $$    $$/     $$ |
11  *   $$$$$$/    $$$$$$/      $$/ 
12  */
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization
52  *      control functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56     address public collector;
57     address public distributor;
58     address public freezer;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61     event CollectorshipTransferred(address indexed previousCollector, address indexed newCollector);
62     event DistributorshipTransferred(address indexed previousDistributor, address indexed newDistributor);
63     event FreezershipTransferred(address indexed previousFreezer, address indexed newFreezer);
64 
65     /**
66      * @dev The Ownable constructor sets the original `owner`, `collector`, `distributor` and `freezer` of the contract to the
67      *      sender account.
68      */
69     constructor() public {
70         owner = msg.sender;
71         collector = msg.sender;
72         distributor = msg.sender;
73         freezer = msg.sender;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the collector.
86      */
87     modifier onlyCollector() {
88         require(msg.sender == collector);
89         _;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the distributor.
94      */
95     modifier onlyDistributor() {
96         require(msg.sender == distributor);
97         _;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the freezer.
102      */
103     modifier onlyFreezer() {
104         require(msg.sender == freezer);
105         _;
106     }
107 
108     /**
109      * @dev Allows the current owner to transfer control of the contract to a newOwner.
110      * @param newOwner The address to transfer ownership to.
111      */
112     function transferOwnership(address newOwner) onlyOwner public {
113         require(isNonZeroAccount(newOwner));
114         emit OwnershipTransferred(owner, newOwner);
115         owner = newOwner;
116     }
117 
118     /**
119      * @dev Allows the owner to transfer control of the contract to a newCollector.
120      * @param newCollector The address to transfer collectorship to.
121      */
122     function transferCollectorship(address newCollector) onlyOwner public {
123         require(isNonZeroAccount(newCollector));
124         emit CollectorshipTransferred(collector, newCollector);
125         collector = newCollector;
126     }
127 
128     /**
129      * @dev Allows the owner to transfer control of the contract to a newDistributor.
130      * @param newDistributor The address to transfer distributorship to.
131      */
132     function transferDistributorship(address newDistributor) onlyOwner public {
133         require(isNonZeroAccount(newDistributor));
134         emit DistributorshipTransferred(distributor, newDistributor);
135         distributor = newDistributor;
136     }
137 
138     /**
139      * @dev Allows the owner to transfer control of the contract to a newFreezer.
140      * @param newFreezer The address to transfer freezership to.
141      */
142     function transferFreezership(address newFreezer) onlyOwner public {
143         require(isNonZeroAccount(newFreezer));
144         emit FreezershipTransferred(freezer, newFreezer);
145         freezer = newFreezer;
146     }
147 
148     // check if the given account is valid
149     function isNonZeroAccount(address _addr) internal pure returns (bool is_nonzero_account) {
150         return _addr != address(0);
151     }
152 }
153 
154 /**
155  * @title ERC20
156  * @dev ERC20 contract interface
157  */
158 contract ERC20 {
159     uint public totalSupply;
160 
161     function balanceOf(address who) public view returns (uint);
162     function totalSupply() public view returns (uint256 _supply);
163     function transfer(address to, uint value) public returns (bool ok);
164     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
165     function approve(address _spender, uint256 _value) public returns (bool success);
166     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
167     function name() public view returns (string _name);
168     function symbol() public view returns (string _symbol);
169     function decimals() public view returns (uint8 _decimals);
170     event Transfer(address indexed _from, address indexed _to, uint256 _value);
171     event Approval(address indexed _owner, address indexed _spender, uint _value);
172 }
173 
174 /**
175  * @title JCT
176  * @author Daisuke Hirata & Noriyuki Izawa
177  * @dev JCT is an ERC20 Token. First envisioned by NANJCOIN
178  */
179 contract JCT is ERC20, Ownable {
180     using SafeMath for uint256;
181 
182     string public name = "JCT";
183     string public symbol = "JCT";
184     uint8 public decimals = 8;
185     uint256 public totalSupply = 18e7 * 1e8;
186     address public relay;
187 
188     mapping(address => uint256) public balanceOf;
189     mapping(address => mapping (address => uint256)) public allowance;
190     mapping (address => bool) public frozenAccount;
191     mapping (address => uint256) public unlockUnixTime;
192 
193     event FrozenFunds(address indexed target, bool frozen);
194     event LockedFunds(address indexed target, uint256 locked);
195 
196     /**
197      * @dev Constructor is called only once and can not be called again
198      */
199     constructor(address founder, address _relay) public {
200         owner = founder;
201         collector = founder;
202         distributor = founder;
203         freezer = founder;
204 
205         balanceOf[founder] = totalSupply;
206 
207         relay = _relay;
208     }
209 
210     modifier onlyAuthorized() {
211         require(msg.sender == relay || checkMessageData(msg.sender));
212         _;
213     }
214 
215     function name() public view returns (string _name) {
216         return name;
217     }
218 
219     function symbol() public view returns (string _symbol) {
220         return symbol;
221     }
222 
223     function decimals() public view returns (uint8 _decimals) {
224         return decimals;
225     }
226 
227     function totalSupply() public view returns (uint256 _totalSupply) {
228         return totalSupply;
229     }
230 
231     function balanceOf(address _owner) public view returns (uint256 balance) {
232         return balanceOf[_owner];
233     }
234 
235     /**
236      * @dev Prevent targets from sending or receiving tokens
237      * @param targets Addresses to be frozen
238      * @param isFrozen either to freeze it or not
239      */
240     function freezeAccounts(address[] targets, bool isFrozen) onlyFreezer public {
241         require(targets.length > 0);
242 
243         for (uint j = 0; j < targets.length; j++) {
244             require(isNonZeroAccount(targets[j]));
245             frozenAccount[targets[j]] = isFrozen;
246             emit FrozenFunds(targets[j], isFrozen);
247         }
248     }
249 
250     /**
251      * @dev Prevent targets from sending or receiving tokens by setting Unix times
252      * @param targets Addresses to be locked funds
253      * @param unixTimes Unix times when locking up will be finished
254      */
255     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
256         require(hasSameArrayLength(targets, unixTimes));
257 
258         for(uint j = 0; j < targets.length; j++){
259             require(unlockUnixTime[targets[j]] < unixTimes[j]);
260             unlockUnixTime[targets[j]] = unixTimes[j];
261             emit LockedFunds(targets[j], unixTimes[j]);
262         }
263     }
264 
265     /**
266      * @dev Standard function transfer with no _data
267      */
268     function transfer(address _to, uint _value) public returns (bool success) {
269         require(hasEnoughBalance(msg.sender, _value)
270                 && isAvailableAccount(msg.sender)
271                 && isAvailableAccount(_to));
272 
273         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
274         balanceOf[_to] = balanceOf[_to].add(_value);
275         emit Transfer(msg.sender, _to, _value);
276         return true;
277     }
278 
279     /**
280      * @dev Transfer tokens from one address to another
281      * @param _from address The address which you want to send tokens from
282      * @param _to address The address which you want to transfer to
283      * @param _value uint256 the amount of tokens to be transferred
284      */
285     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
286         require(isNonZeroAccount(_to)
287                 && hasEnoughBalance(_from, _value)
288                 && hasEnoughAllowance(_from, msg.sender, _value)
289                 && isAvailableAccount(_from)
290                 && isAvailableAccount(_to));
291 
292         balanceOf[_from] = balanceOf[_from].sub(_value);
293         balanceOf[_to] = balanceOf[_to].add(_value);
294         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
295         emit Transfer(_from, _to, _value);
296         return true;
297     }
298 
299     /**
300      * @dev Allows _spender to spend no more than _value tokens in your behalf
301      * @param _spender The address authorized to spend
302      * @param _value the max amount they can spend
303      */
304     function approve(address _spender, uint256 _value) public returns (bool success) {
305         allowance[msg.sender][_spender] = _value;
306         emit Approval(msg.sender, _spender, _value);
307         return true;
308     }
309 
310     /**
311      * @dev Allows _spender to spend no more than _value tokens in your behalf. intended to be called from TxRelay contract
312      */
313     function approveTokenCollection(address _claimedSender, address _spender, uint256 _value) onlyAuthorized public returns (bool success) {
314         require(isAvailableAccount(_claimedSender)
315                 && isAvailableAccount(msg.sender));
316         allowance[_claimedSender][_spender] = _value;
317         emit Approval(_claimedSender, _spender, _value);
318         return true;
319     }    
320 
321     /**
322      * @dev Function to check the amount of tokens that an owner allowed to a spender
323      * @param _owner address The address which owns the funds
324      * @param _spender address The address which will spend the funds
325      */
326     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
327         return allowance[_owner][_spender];
328     }
329 
330     /**
331      * @dev Function to collect tokens from the list of addresses
332      */
333     function collectTokens(address[] addresses, uint[] amounts) onlyCollector public returns (bool) {
334         require(hasSameArrayLength(addresses, amounts));
335 
336         uint256 totalAmount = 0;
337 
338         for (uint j = 0; j < addresses.length; j++) {
339             require(amounts[j] > 0
340                     && isNonZeroAccount(addresses[j])
341                     && isAvailableAccount(addresses[j])
342                     && hasEnoughAllowance(addresses[j], msg.sender, amounts[j]));
343 
344             require(hasEnoughBalance(addresses[j], amounts[j]));
345             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
346             allowance[addresses[j]][msg.sender] = allowance[addresses[j]][msg.sender].sub(amounts[j]);
347             totalAmount = totalAmount.add(amounts[j]);
348             emit Transfer(addresses[j], msg.sender, amounts[j]);
349         }
350         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
351         return true;
352     }
353 
354     /**
355      * @dev Function to distribute tokens to the list of addresses
356      */
357     function distributeTokens(address[] addresses, uint[] amounts) onlyDistributor public returns (bool) {
358         require(hasSameArrayLength(addresses, amounts)
359                 && isAvailableAccount(msg.sender));
360 
361         uint256 totalAmount = 0;
362 
363         for(uint j = 0; j < addresses.length; j++){
364             require(amounts[j] > 0
365                     && isNonZeroAccount(addresses[j])
366                     && isAvailableAccount(addresses[j]));
367 
368             totalAmount = totalAmount.add(amounts[j]);
369         }
370         require(hasEnoughBalance(msg.sender, totalAmount));
371 
372         for (j = 0; j < addresses.length; j++) {
373             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
374             emit Transfer(msg.sender, addresses[j], amounts[j]);
375         }
376         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
377         return true;
378     }
379 
380     // check if the given account is available
381     function isAvailableAccount(address _addr) public view returns (bool is_valid_account) {
382         return isUnLockedAccount(_addr) && isUnfrozenAccount(_addr);
383     }
384 
385     // check if the given account is not locked up
386     function isUnLockedAccount(address _addr) public view returns (bool is_unlocked_account) {
387         return now > unlockUnixTime[_addr];
388     }
389 
390     // check if the given account is not frozen
391     function isUnfrozenAccount(address _addr) public view returns (bool is_unfrozen_account) {
392         return frozenAccount[_addr] == false;
393     }
394 
395     // check if the given account has enough balance more than given amount
396     function hasEnoughBalance(address _addr, uint256 _value) public view returns (bool has_enough_balance) {
397         return _value > 0 && balanceOf[_addr] >= _value;
398     }
399 
400     // check if the given spender has enough allowance of owner more than given amount
401     function hasEnoughAllowance(address _owner, address _spender, uint256 _value) public view returns (bool has_enough_balance) {
402         return allowance[_owner][_spender] >= _value;
403     }    
404 
405     // check if the given account is not frozen
406     function hasSameArrayLength(address[] addresses, uint[] amounts) private pure returns (bool has_same_array_length) {
407         return addresses.length > 0 && addresses.length == amounts.length;
408     }
409 
410     //Checks that address a is the first input in msg.data.
411     //Has very minimal gas overhead.
412     function checkMessageData(address a) private pure returns (bool t) {
413         if (msg.data.length < 36) return false;
414         assembly {
415             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
416             t := eq(a, and(mask, calldataload(4)))
417         }
418     }    
419 }