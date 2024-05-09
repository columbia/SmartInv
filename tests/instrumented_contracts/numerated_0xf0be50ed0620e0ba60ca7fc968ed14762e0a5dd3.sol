1 pragma solidity 0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Ownable {
55     address public _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () public {
60         _owner = msg.sender;
61         emit OwnershipTransferred(address(0), msg.sender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 contract Cow is Ownable {
86     using SafeMath for uint256;
87 
88     modifier validRecipient(address account) {
89         //require(account != address(0x0));
90         require(account != address(this));
91         _;
92     }
93 
94     struct Breeder {
95         uint256 snapshotPeriod;
96         uint256 snapshotBalance;
97     }
98 
99     // events
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102     event LogWhitelisted(address indexed addr);
103     event LogUnlocked(uint256 timestamp);
104     event LogBandits(uint256 totalSupply);
105     event LogBreed(uint256 indexed period, uint256 candidatesLength, uint256 estimatedBreeders, uint256 breededToken, uint256 availableUnits);
106 
107     // public constants
108     string public constant name = "Cowboy.Finance";
109     string public constant symbol = "COW";
110     uint256 public constant decimals = 9;
111 
112     // private constants
113     uint256 private constant MAX_UINT256 = ~uint256(0);
114     uint256 private constant INITIAL_TOKENS = 21 * 10**6;
115     uint256 private constant INITIAL_SUPPLY = INITIAL_TOKENS * 10**decimals;
116     uint256 private constant TOTAL_UNITS = MAX_UINT256 - (MAX_UINT256 % INITIAL_SUPPLY);
117     uint256 private constant POOL_SIZE = 50; // 50%
118     uint256 private constant INIT_POOL_FACTOR = 60;
119     uint256 private constant BREED_MIN_BALANCE = 100 * 10**decimals;
120     uint256 private constant BREED_ADDRESS_LIMIT = 1000;
121     uint256 private constant TIMELOCK_TIME = 24 hours;
122     uint256 private constant HALVING_PERIOD = 30;
123 
124     // mappings
125     mapping(address => uint256) private _balances;
126     mapping(address => mapping (address => uint256)) private _allowances;
127     mapping(address => bool) private _whitelist;
128     mapping(address => Breeder) private _breeders;
129     mapping(address => bool) private _knownAddresses;
130     mapping(uint256 => address) private _addresses;
131     uint256 _addressesLength;
132 
133     // ints
134     uint256 private _totalSupply;
135     uint256 private _unitsPerToken;
136     uint256 private _initialPoolToken;
137     uint256 private _poolBalance;
138     uint256 private _poolFactor;
139 
140     uint256 private _period;
141     uint256 private _timelockBreeding;
142     uint256 private _timelockBandits;
143 
144     // bools
145     bool private _lockTransfer;
146     bool private _lockBreeding;
147 
148 
149     constructor() public override {
150         _owner = msg.sender;
151 
152         // set toal supply = initial supply
153         _totalSupply = INITIAL_SUPPLY;
154         // set units per token based on total supply
155         _unitsPerToken = TOTAL_UNITS.div(_totalSupply);
156 
157         // set pool balance = TOTAL_UNITS / 100 * POOL_SIZE
158         _poolBalance = TOTAL_UNITS / 100 * POOL_SIZE;
159         // set initial pool token balance
160         _initialPoolToken = _poolBalance.div(_unitsPerToken);
161         // set initial pool factor
162         _poolFactor = INIT_POOL_FACTOR;
163 
164         // set owner balance
165         _balances[_owner] = TOTAL_UNITS - _poolBalance;
166 
167         // init locks & set defaults
168         _lockTransfer = true;
169         _lockBreeding = true;
170 
171         emit Transfer(address(0x0), _owner, _totalSupply.sub(_initialPoolToken));
172     }
173 
174 
175     function whitelistAdd(address addr) external onlyOwner {
176         _whitelist[addr] = true;
177         emit LogWhitelisted(addr);
178     }
179 
180     // main unlock function
181     // 1. set period
182     // 2. set timelocks
183     // 3. allow token transfer
184     function unlock() external onlyOwner {
185         require(_period == 0, "contract is unlocked");
186         _period = 1;
187         _timelockBreeding = now.add(TIMELOCK_TIME);
188         _timelockBandits = now.add(TIMELOCK_TIME);
189         _lockTransfer = false;
190         _lockBreeding = false;
191         emit LogUnlocked(block.timestamp);
192     }
193 
194 
195     // bandits stuff
196     function bandits() external onlyOwner {
197         require(_lockTransfer == false, "contract is locked");
198         require(_timelockBandits < now, "also bandits need time to rest");
199         _timelockBandits = now.add(TIMELOCK_TIME);
200         _totalSupply = _totalSupply.sub(_totalSupply.div(100));
201         _unitsPerToken = TOTAL_UNITS.div(_totalSupply);
202         emit LogBandits(_totalSupply);
203     }
204 
205     function getSnapshotBalance(address addr) private view returns (uint256) {
206         if (_breeders[addr].snapshotPeriod < _period) {
207             return _balances[addr];
208         }
209         return  _breeders[addr].snapshotBalance;
210     }
211 
212     // breed
213     function breed() external onlyOwner {
214         require(_lockTransfer == false, "contract is locked");
215         require(_timelockBreeding < now, "timelock is active");
216         _timelockBreeding = now.add(TIMELOCK_TIME);
217 
218         // need the sum of all breeder balances to calculate share in breed
219         uint256 totalBreedersBalance = 0;
220 
221         // check if address is candidate
222         address[] memory candidates = new address[](_addressesLength);
223         uint256 candidatesLength = 0;
224         for (uint256 i = 0; i < _addressesLength; i++) {
225             address addr = _addresses[i];
226             if(addr == address(0x0)) {
227                 continue;
228             }
229             uint256 snapbalance = getSnapshotBalance(addr);
230             // dont put it on the list if too low
231             if (snapbalance < BREED_MIN_BALANCE.mul(_unitsPerToken)) {
232                 continue;
233             }
234             // put it on the list if on of both conditions are true
235             // 1. snapshot is old [no coins moved]
236             // 2. balance >= snapshot balance [no tokens out]
237             if ((_breeders[addr].snapshotPeriod < _period) || (_balances[addr] >= snapbalance)) {
238                 candidates[candidatesLength] = addr;
239                 candidatesLength++;
240             }
241         }
242 
243         uint256 estimatedBreeders = 0;
244         uint256 breededUnits = 0;
245         uint256 availableUnits = _initialPoolToken.div(_poolFactor).mul(_unitsPerToken);
246         if(candidatesLength > 0) {
247             estimatedBreeders = 1;
248             // get lucky candidates breeders
249             uint256 randomNumber = uint256(keccak256(abi.encodePacked((_addressesLength + _poolBalance + _period), now, blockhash(block.number))));
250             uint256 randomIndex = randomNumber % 10;
251             uint256 randomOffset = 0;
252             if (candidatesLength >= 10) {
253                 estimatedBreeders = (candidatesLength - randomIndex - 1) / 10 + 1;
254             }
255             if (estimatedBreeders > BREED_ADDRESS_LIMIT) {
256                 randomOffset = (randomNumber / 100) % estimatedBreeders;
257                 estimatedBreeders = BREED_ADDRESS_LIMIT;
258             }
259             address[] memory breeders = new address[](estimatedBreeders);
260             uint256 breedersLength = 0;
261             for (uint256 i = 0; i < estimatedBreeders; i++) {
262                 address addr = candidates[(randomIndex + (i + randomOffset) * 10) % candidatesLength];
263                 breeders[breedersLength] = addr;
264                 breedersLength++;
265                 totalBreedersBalance = totalBreedersBalance.add(getSnapshotBalance(addr).div(_unitsPerToken));
266             }
267 
268 
269             for (uint256 i = 0; i < breedersLength; i++) {
270                 address addr = breeders[i];
271                 uint256 snapbalance = getSnapshotBalance(addr);
272                 uint256 tokensToAdd = availableUnits.div(_unitsPerToken).mul(snapbalance.div(_unitsPerToken)).div(totalBreedersBalance);
273                 uint256 unitsToAdd = tokensToAdd.mul(_unitsPerToken);
274                 _balances[addr] = _balances[addr].add(unitsToAdd);
275                 breededUnits = breededUnits.add(unitsToAdd);
276             }
277 
278             if ((breededUnits < availableUnits) && (breedersLength > 0)) {
279                 address addr = breeders[breedersLength-1];
280                 uint256 rest = availableUnits.sub(breededUnits);
281                 _balances[addr] = _balances[addr].add(rest);
282                 breededUnits = breededUnits.add(rest);
283             }
284             if (breededUnits > 0) {
285                 _poolBalance = _poolBalance.sub(breededUnits);
286             }
287         }
288 
289         uint256 breededTokens = 0;
290         if(breededUnits > 0) {
291             breededTokens = breededUnits.div(_unitsPerToken);
292         }
293         emit LogBreed(_period, candidatesLength, estimatedBreeders, breededTokens, availableUnits);
294 
295         if(_period % HALVING_PERIOD == 0) {
296             _poolFactor = _poolFactor.add(_poolFactor);
297         }
298         _period = _period.add(1);
299     }
300 
301 
302     function calcShareInTokens(uint256 snapshotToken, uint256 totalBreedersToken, uint256 availableToken) private pure returns(uint256) {
303         return availableToken.mul(snapshotToken).div(totalBreedersToken);
304     }
305 
306     function isOwnerOrWhitelisted(address addr) private view returns (bool) {
307         if (addr == _owner) {
308             return true;
309         }
310         return _whitelist[addr];
311     }
312 
313     function acquaintAddress(address candidate) private returns (bool) {
314         if((_knownAddresses[candidate] != true) && (candidate != _owner)) {
315             _knownAddresses[candidate] = true;
316             _addresses[_addressesLength] = candidate;
317             _addressesLength++;
318             return true;
319         }
320         return false;
321     }
322 
323 
324     function period() public view returns (uint256) {
325         return _period;
326     }
327 
328     function poolBalance() public view returns (uint256) {
329         return _poolBalance.div(_unitsPerToken);
330     }
331 
332     function totalSupply() public view returns (uint256) {
333         return _totalSupply;
334     }
335 
336     function balanceOf(address account) public view returns (uint256) {
337         return _balances[account].div(_unitsPerToken);
338     }
339 
340     function processBreedersBeforeTransfer(address from, address to, uint256 units) private {
341 
342         // process sender
343         // if we have no current snapshot, make it
344         // snapshot is balance before sending
345         if(_breeders[from].snapshotPeriod < _period) {
346             _breeders[from].snapshotBalance = _balances[from];
347             _breeders[from].snapshotPeriod = _period;
348         } else {
349             // snapshot is same period, set balance reduced by units (= current balance)
350             _breeders[from].snapshotBalance = _balances[from].sub(units);
351         }
352 
353         // process receiver
354         // if we have no current snapshot, make it
355         // snapshot is balance before receiving
356         if(_breeders[to].snapshotPeriod < _period) {
357             _breeders[to].snapshotBalance = _balances[to];
358             _breeders[to].snapshotPeriod = _period;
359         } else {
360             // snapshot is same period, nothing to do -> new tokens have to rest at least 1 period
361             // later in breeding we have also to check the snapshort period and update the balance if < to take care of no transfer/no updated snapshot balance situation
362         }
363     }
364 
365     function transfer(address recipient, uint256 value) public validRecipient(recipient) returns (bool) {
366         require(((_lockTransfer == false) || isOwnerOrWhitelisted(msg.sender)), 'token transfer is locked');
367         uint256 units = value.mul(_unitsPerToken);
368         uint256 newSenderBalance = _balances[msg.sender].sub(units);
369         processBreedersBeforeTransfer(msg.sender, recipient, units);
370         _balances[msg.sender] = newSenderBalance;
371         _balances[recipient] = _balances[recipient].add(units);
372         acquaintAddress(recipient);
373         emit Transfer(msg.sender, recipient, value);
374         return true;
375     }
376 
377     function transferFrom(address from, address to, uint256 value) public validRecipient(to) returns (bool) {
378         require(((_lockTransfer == false) || isOwnerOrWhitelisted(msg.sender)), 'token transfer is locked');
379         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
380         uint256 units = value.mul(_unitsPerToken);
381         processBreedersBeforeTransfer(from, to, units);
382         uint256 newSenderBalance = _balances[from].sub(units);
383         _balances[from] = newSenderBalance;
384         _balances[to] = _balances[to].add(units);
385         acquaintAddress(to);
386         emit Transfer(from, to, value);
387         return true;
388     }
389 
390     function allowance(address owner, address spender) public view returns (uint256) {
391         return _allowances[owner][spender];
392     }
393 
394     function approve(address spender, uint256 value) public returns (bool) {
395         _allowances[msg.sender][spender] = value;
396         emit Approval(msg.sender, spender, value);
397         return true;
398     }
399 
400     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
401         _allowances[msg.sender][spender] = _allowances[msg.sender][spender].add(addedValue);
402         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
403         return true;
404     }
405 
406     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
407         uint256 oldValue = _allowances[msg.sender][spender];
408         if (subtractedValue >= oldValue) {
409             _allowances[msg.sender][spender] = 0;
410         } else {
411             _allowances[msg.sender][spender] = oldValue.sub(subtractedValue);
412         }
413         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
414         return true;
415     }
416 
417 }