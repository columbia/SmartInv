1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ownership/MultiOwnable.sol
4 
5 /**
6  * @title MultiOwnable
7  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
8  * functions, this simplifies the implementation of "users permissions".
9  */
10 contract MultiOwnable {
11     address public manager; // address used to set owners
12     address[] public owners;
13     mapping(address => bool) public ownerByAddress;
14 
15     event SetOwners(address[] owners);
16 
17     modifier onlyOwner() {
18         require(ownerByAddress[msg.sender] == true);
19         _;
20     }
21 
22     /**
23      * @dev MultiOwnable constructor sets the manager
24      */
25     function MultiOwnable() public {
26         manager = msg.sender;
27     }
28 
29     /**
30      * @dev Function to set owners addresses
31      */
32     function setOwners(address[] _owners) public {
33         require(msg.sender == manager);
34         _setOwners(_owners);
35 
36     }
37 
38     function _setOwners(address[] _owners) internal {
39         for(uint256 i = 0; i < owners.length; i++) {
40             ownerByAddress[owners[i]] = false;
41         }
42 
43 
44         for(uint256 j = 0; j < _owners.length; j++) {
45             ownerByAddress[_owners[j]] = true;
46         }
47         owners = _owners;
48         SetOwners(_owners);
49     }
50 
51     function getOwners() public constant returns (address[]) {
52         return owners;
53     }
54 }
55 
56 // File: contracts/math/SafeMath.sol
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 contract SafeMath {
63     /**
64     * @dev constructor
65     */
66     function SafeMath() public {
67     }
68 
69     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a * b;
71         assert(a == 0 || c / a == b);
72         return c;
73     }
74 
75     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a / b;
77         return c;
78     }
79 
80     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(a >= b);
82         return a - b;
83     }
84 
85     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 // File: contracts/token/IERC20Token.sol
93 
94 /**
95  * @title IERC20Token - ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract IERC20Token {
99     string public name;
100     string public symbol;
101     uint8 public decimals;
102     uint256 public totalSupply;
103 
104     function balanceOf(address _owner) public constant returns (uint256 balance);
105     function transfer(address _to, uint256 _value)  public returns (bool success);
106     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
107     function approve(address _spender, uint256 _value)  public returns (bool success);
108     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
109 
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112 }
113 
114 // File: contracts/token/ERC20Token.sol
115 
116 /**
117  * @title ERC20Token - ERC20 base implementation
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20Token is IERC20Token, SafeMath {
121     mapping (address => uint256) public balances;
122     mapping (address => mapping (address => uint256)) public allowed;
123 
124     function transfer(address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(balances[msg.sender] >= _value);
127 
128         balances[msg.sender] = safeSub(balances[msg.sender], _value);
129         balances[_to] = safeAdd(balances[_to], _value);
130         Transfer(msg.sender, _to, _value);
131         return true;
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
137 
138         balances[_to] = safeAdd(balances[_to], _value);
139         balances[_from] = safeSub(balances[_from], _value);
140         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
141         Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     function balanceOf(address _owner) public constant returns (uint256) {
146         return balances[_owner];
147     }
148 
149     function approve(address _spender, uint256 _value) public returns (bool) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     function allowance(address _owner, address _spender) public constant returns (uint256) {
156       return allowed[_owner][_spender];
157     }
158 }
159 
160 // File: contracts/token/ITokenEventListener.sol
161 
162 /**
163  * @title ITokenEventListener
164  * @dev Interface which should be implemented by token listener
165  */
166 interface ITokenEventListener {
167     /**
168      * @dev Function is called after token transfer/transferFrom
169      * @param _from Sender address
170      * @param _to Receiver address
171      * @param _value Amount of tokens
172      */
173     function onTokenTransfer(address _from, address _to, uint256 _value) external;
174 }
175 
176 // File: contracts/token/ManagedToken.sol
177 
178 /**
179  * @title ManagedToken
180  * @dev ERC20 compatible token with issue and destroy facilities
181  * @dev All transfers can be monitored by token event listener
182  */
183 contract ManagedToken is ERC20Token, MultiOwnable {
184     bool public allowTransfers = false;
185     bool public issuanceFinished = false;
186 
187     ITokenEventListener public eventListener;
188 
189     event AllowTransfersChanged(bool _newState);
190     event Issue(address indexed _to, uint256 _value);
191     event Destroy(address indexed _from, uint256 _value);
192     event IssuanceFinished();
193 
194     modifier transfersAllowed() {
195         require(allowTransfers);
196         _;
197     }
198 
199     modifier canIssue() {
200         require(!issuanceFinished);
201         _;
202     }
203 
204     /**
205      * @dev ManagedToken constructor
206      * @param _listener Token listener(address can be 0x0)
207      * @param _owners Owners list
208      */
209     function ManagedToken(address _listener, address[] _owners) public {
210         if(_listener != address(0)) {
211             eventListener = ITokenEventListener(_listener);
212         }
213         _setOwners(_owners);
214     }
215 
216     /**
217      * @dev Enable/disable token transfers. Can be called only by owners
218      * @param _allowTransfers True - allow False - disable
219      */
220     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
221         allowTransfers = _allowTransfers;
222         AllowTransfersChanged(_allowTransfers);
223     }
224 
225     /**
226      * @dev Set/remove token event listener
227      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
228      */
229     function setListener(address _listener) public onlyOwner {
230         if(_listener != address(0)) {
231             eventListener = ITokenEventListener(_listener);
232         } else {
233             delete eventListener;
234         }
235     }
236 
237     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
238         bool success = super.transfer(_to, _value);
239         if(hasListener() && success) {
240             eventListener.onTokenTransfer(msg.sender, _to, _value);
241         }
242         return success;
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
246         bool success = super.transferFrom(_from, _to, _value);
247         if(hasListener() && success) {
248             eventListener.onTokenTransfer(_from, _to, _value);
249         }
250         return success;
251     }
252 
253     function hasListener() internal view returns(bool) {
254         if(eventListener == address(0)) {
255             return false;
256         }
257         return true;
258     }
259 
260     /**
261      * @dev Issue tokens to specified wallet
262      * @param _to Wallet address
263      * @param _value Amount of tokens
264      */
265     function issue(address _to, uint256 _value) external onlyOwner canIssue {
266         totalSupply = safeAdd(totalSupply, _value);
267         balances[_to] = safeAdd(balances[_to], _value);
268         Issue(_to, _value);
269         Transfer(address(0), _to, _value);
270     }
271 
272     /**
273      * @dev Destroy tokens on specified address (Called by owner or token holder)
274      * @dev Fund contract address must be in the list of owners to burn token during refund
275      * @param _from Wallet address
276      * @param _value Amount of tokens to destroy
277      */
278     function destroy(address _from, uint256 _value) external {
279         require(ownerByAddress[msg.sender] || msg.sender == _from);
280         require(balances[_from] >= _value);
281         totalSupply = safeSub(totalSupply, _value);
282         balances[_from] = safeSub(balances[_from], _value);
283         Transfer(_from, address(0), _value);
284         Destroy(_from, _value);
285     }
286 
287     /**
288      * @dev Increase the amount of tokens that an owner allowed to a spender.
289      *
290      * approve should be called when allowed[_spender] == 0. To increment
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From OpenZeppelin StandardToken.sol
294      * @param _spender The address which will spend the funds.
295      * @param _addedValue The amount of tokens to increase the allowance by.
296      */
297     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
298         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
299         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300         return true;
301     }
302 
303     /**
304      * @dev Decrease the amount of tokens that an owner allowed to a spender.
305      *
306      * approve should be called when allowed[_spender] == 0. To decrement
307      * allowed value is better to use this function to avoid 2 calls (and wait until
308      * the first transaction is mined)
309      * From OpenZeppelin StandardToken.sol
310      * @param _spender The address which will spend the funds.
311      * @param _subtractedValue The amount of tokens to decrease the allowance by.
312      */
313     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
314         uint oldValue = allowed[msg.sender][_spender];
315         if (_subtractedValue > oldValue) {
316             allowed[msg.sender][_spender] = 0;
317         } else {
318             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
319         }
320         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321         return true;
322     }
323 
324     /**
325      * @dev Finish token issuance
326      * @return True if success
327      */
328     function finishIssuance() public onlyOwner returns (bool) {
329         issuanceFinished = true;
330         IssuanceFinished();
331         return true;
332     }
333 }
334 
335 // File: contracts/token/TransferLimitedToken.sol
336 
337 /**
338  * @title TransferLimitedToken
339  * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time
340  */
341 contract TransferLimitedToken is ManagedToken {
342     uint256 public constant LIMIT_TRANSFERS_PERIOD = 365 days;
343 
344     mapping(address => bool) public limitedWallets;
345     uint256 public limitEndDate;
346     address public limitedWalletsManager;
347     bool public isLimitEnabled;
348 
349     event TransfersEnabled();
350 
351     modifier onlyManager() {
352         require(msg.sender == limitedWalletsManager);
353         _;
354     }
355 
356     /**
357      * @dev Check if transfer between addresses is available
358      * @param _from From address
359      * @param _to To address
360      */
361     modifier canTransfer(address _from, address _to)  {
362         require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));
363         _;
364     }
365 
366     /**
367      * @dev TransferLimitedToken constructor
368      * @param _limitStartDate Limit start date
369      * @param _listener Token listener(address can be 0x0)
370      * @param _owners Owners list
371      * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets
372      */
373     function TransferLimitedToken(
374         uint256 _limitStartDate,
375         address _listener,
376         address[] _owners,
377         address _limitedWalletsManager
378     ) public ManagedToken(_listener, _owners)
379     {
380         limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;
381         isLimitEnabled = true;
382         limitedWalletsManager = _limitedWalletsManager;
383     }
384 
385     /**
386      * @dev Enable token transfers
387      */
388     function enableTransfers() public {
389         require(msg.sender == limitedWalletsManager);
390         allowTransfers = true;
391         TransfersEnabled();
392     }
393 
394     /**
395      * @dev Add address to limitedWallets
396      * @dev Can be called only by manager
397      */
398     function addLimitedWalletAddress(address _wallet) public {
399         require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);
400         limitedWallets[_wallet] = true;
401     }
402 
403     /**
404      * @dev Del address from limitedWallets
405      * @dev Can be called only by manager
406      */
407     function delLimitedWalletAddress(address _wallet) public onlyManager {
408         limitedWallets[_wallet] = false;
409     }
410 
411     /**
412      * @dev Disable transfer limit manually. Can be called only by manager
413      */
414     function disableLimit() public onlyManager {
415         isLimitEnabled = false;
416     }
417 
418     function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {
419         return super.transfer(_to, _value);
420     }
421 
422     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
423         return super.transferFrom(_from, _to, _value);
424     }
425 
426     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
427         return super.approve(_spender,_value);
428     }
429 }
430 
431 // File: contracts/EvolthToken.sol
432 
433 contract EVOLTH is TransferLimitedToken {
434     uint256 public constant SALE_END_TIME = 1538956800; // 08.10.2018 08:00:00 UTC
435 
436     function EVOLTH(address _listener, address[] _owners, address manager) public
437         TransferLimitedToken(SALE_END_TIME, _listener, _owners, manager)
438     {
439         name = "EVOLTH";
440         symbol = "EVH";
441         decimals = 18;
442     }
443 }