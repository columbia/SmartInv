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
119      * @dev Allows the current collector to transfer control of the contract to a newCollector.
120      * @param newCollector The address to transfer collectorship to.
121      */
122     function transferCollectorship(address newCollector) onlyOwner public {
123         require(isNonZeroAccount(newCollector));
124         emit CollectorshipTransferred(collector, newCollector);
125         collector = newCollector;
126     }
127 
128     /**
129      * @dev Allows the current distributor to transfer control of the contract to a newDistributor.
130      * @param newDistributor The address to transfer distributorship to.
131      */
132     function transferDistributorship(address newDistributor) onlyOwner public {
133         require(isNonZeroAccount(newDistributor));
134         emit DistributorshipTransferred(distributor, newDistributor);
135         distributor = newDistributor;
136     }
137 
138     /**
139      * @dev Allows the current freezer to transfer control of the contract to a newFreezer.
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
185     uint256 public totalSupply = 17e7 * 1e8;
186 
187     mapping(address => uint256) public balanceOf;
188     mapping(address => mapping (address => uint256)) public allowance;
189     mapping (address => bool) public frozenAccount;
190     mapping (address => uint256) public unlockUnixTime;
191 
192     event FrozenFunds(address indexed target, bool frozen);
193     event LockedFunds(address indexed target, uint256 locked);
194 
195     /**
196      * @dev Constructor is called only once and can not be called again
197      */
198     constructor(address founder) public {
199         owner = founder;
200         collector = founder;
201         distributor = founder;
202         freezer = founder;
203 
204         balanceOf[founder] = totalSupply;
205     }
206 
207     function name() public view returns (string _name) {
208         return name;
209     }
210 
211     function symbol() public view returns (string _symbol) {
212         return symbol;
213     }
214 
215     function decimals() public view returns (uint8 _decimals) {
216         return decimals;
217     }
218 
219     function totalSupply() public view returns (uint256 _totalSupply) {
220         return totalSupply;
221     }
222 
223     function balanceOf(address _owner) public view returns (uint256 balance) {
224         return balanceOf[_owner];
225     }
226 
227     /**
228      * @dev Prevent targets from sending or receiving tokens
229      * @param targets Addresses to be frozen
230      * @param isFrozen either to freeze it or not
231      */
232     function freezeAccounts(address[] targets, bool isFrozen) onlyFreezer public {
233         require(targets.length > 0);
234 
235         for (uint j = 0; j < targets.length; j++) {
236             require(isNonZeroAccount(targets[j]));
237             frozenAccount[targets[j]] = isFrozen;
238             emit FrozenFunds(targets[j], isFrozen);
239         }
240     }
241 
242     /**
243      * @dev Prevent targets from sending or receiving tokens by setting Unix times
244      * @param targets Addresses to be locked funds
245      * @param unixTimes Unix times when locking up will be finished
246      */
247     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
248         require(hasSameArrayLength(targets, unixTimes));
249 
250         for(uint j = 0; j < targets.length; j++){
251             require(unlockUnixTime[targets[j]] < unixTimes[j]);
252             unlockUnixTime[targets[j]] = unixTimes[j];
253             emit LockedFunds(targets[j], unixTimes[j]);
254         }
255     }
256 
257     /**
258      * @dev Standard function transfer with no _data
259      */
260     function transfer(address _to, uint _value) public returns (bool success) {
261         require(hasEnoughBalance(msg.sender, _value)
262                 && isAvailableAccount(msg.sender)
263                 && isAvailableAccount(_to));
264 
265         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
266         balanceOf[_to] = balanceOf[_to].add(_value);
267         emit Transfer(msg.sender, _to, _value);
268         return true;
269     }
270 
271     /**
272      * @dev Transfer tokens from one address to another
273      * @param _from address The address which you want to send tokens from
274      * @param _to address The address which you want to transfer to
275      * @param _value uint256 the amount of tokens to be transferred
276      */
277     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
278         require(isNonZeroAccount(_to)
279                 && hasEnoughBalance(_from, _value)
280                 && allowance[_from][msg.sender] >= _value
281                 && isAvailableAccount(_from)
282                 && isAvailableAccount(_to));
283 
284         balanceOf[_from] = balanceOf[_from].sub(_value);
285         balanceOf[_to] = balanceOf[_to].add(_value);
286         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
287         emit Transfer(_from, _to, _value);
288         return true;
289     }
290 
291     /**
292      * @dev Allows _spender to spend no more than _value tokens in your behalf
293      * @param _spender The address authorized to spend
294      * @param _value the max amount they can spend
295      */
296     function approve(address _spender, uint256 _value) public returns (bool success) {
297         allowance[msg.sender][_spender] = _value;
298         emit Approval(msg.sender, _spender, _value);
299         return true;
300     }
301 
302     /**
303      * @dev Function to check the amount of tokens that an owner allowed to a spender
304      * @param _owner address The address which owns the funds
305      * @param _spender address The address which will spend the funds
306      */
307     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
308         return allowance[_owner][_spender];
309     }
310 
311     /**
312      * @dev Function to collect tokens from the list of addresses
313      */
314     function collectTokens(address[] addresses, uint[] amounts) onlyCollector public returns (bool) {
315         require(hasSameArrayLength(addresses, amounts));
316 
317         uint256 totalAmount = 0;
318 
319         for (uint j = 0; j < addresses.length; j++) {
320             require(amounts[j] > 0
321                     && isNonZeroAccount(addresses[j])
322                     && isAvailableAccount(addresses[j]));
323 
324             require(hasEnoughBalance(addresses[j], amounts[j]));
325             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
326             totalAmount = totalAmount.add(amounts[j]);
327             emit Transfer(addresses[j], msg.sender, amounts[j]);
328         }
329         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
330         return true;
331     }
332 
333     /**
334      * @dev Function to distribute tokens to the list of addresses
335      */
336     function distributeTokens(address[] addresses, uint[] amounts) onlyDistributor public returns (bool) {
337         require(hasSameArrayLength(addresses, amounts)
338                 && isAvailableAccount(msg.sender));
339 
340         uint256 totalAmount = 0;
341 
342         for(uint j = 0; j < addresses.length; j++){
343             require(amounts[j] > 0
344                     && isNonZeroAccount(addresses[j])
345                     && isAvailableAccount(addresses[j]));
346 
347             totalAmount = totalAmount.add(amounts[j]);
348         }
349         require(hasEnoughBalance(msg.sender, totalAmount));
350 
351         for (j = 0; j < addresses.length; j++) {
352             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
353             emit Transfer(msg.sender, addresses[j], amounts[j]);
354         }
355         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
356         return true;
357     }
358 
359     // check if the given account is available
360     function isAvailableAccount(address _addr) private view returns (bool is_valid_account) {
361         return isUnLockedAccount(_addr) && isUnfrozenAccount(_addr);
362     }
363 
364     // check if the given account is not locked up
365     function isUnLockedAccount(address _addr) private view returns (bool is_unlocked_account) {
366         return now > unlockUnixTime[_addr];
367     }
368 
369     // check if the given account is not frozen
370     function isUnfrozenAccount(address _addr) private view returns (bool is_unfrozen_account) {
371         return frozenAccount[_addr] == false;
372     }
373 
374     // check if the given account has enough balance more than given amount
375     function hasEnoughBalance(address _addr, uint256 _value) private view returns (bool has_enough_balance) {
376         return _value > 0 && balanceOf[_addr] >= _value;
377     }
378 
379     // check if the given account is not frozen
380     function hasSameArrayLength(address[] addresses, uint[] amounts) private pure returns (bool has_same_array_length) {
381         return addresses.length > 0 && addresses.length == amounts.length;
382     }
383 }