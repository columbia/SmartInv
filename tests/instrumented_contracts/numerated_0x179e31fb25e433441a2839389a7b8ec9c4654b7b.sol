1 pragma solidity ^0.5.2;
2 // ----------------------------------------------------------------------------
3 // SynchroBit™ Hybrid Digital Assets Trading Platform Smart Contract
4 //
5 // Deployed to : 0x6241E4822100Eb51e28B7784636037ed1C657bB9
6 // Symbol : SNB
7 // Name : SynchroBitcoin
8 // Total supply: 1000000000
9 // Decimals :18
10 //
11 // Enjoy.
12 //
13 // SynchroBit™ Hybrid Digital Assets Trading Platform by SYNCHRONIUM®
14 // Compatible with Zero Trading Fee on SynchroBit Hybrid Exchange and integration with WinkPay, PikChat and other SYNCHRONIUM Omni Platforms
15 // ----------------------------------------------------------------------------
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://eips.ethereum.org/EIPS/eip-20
20  */
21 interface IERC20 {
22     function transfer(address to, uint256 value) external returns (bool);
23     function approve(address spender, uint256 value) external returns (bool);
24     function transferFrom(address from, address to, uint256 value) external returns (bool);
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address who) external view returns (uint256);
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 // ----------------------------------------------------------------------------
34 // Safe maths
35 // ----------------------------------------------------------------------------
36 
37 /**
38  * @title SafeMath
39  * @dev Unsigned math operations with safety checks that revert on error.
40  */
41 library SafeMath {
42     /**
43      * @dev Multiplies two unsigned integers, reverts on overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b,"Invalid values");
54         return c;
55     }
56 
57     /**
58      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
59      */
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0,"Invalid values");
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return c;
66     }
67 
68     /**
69      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a,"Invalid values");
73         uint256 c = a - b;
74         return c;
75     }
76 
77     /**
78      * @dev Adds two unsigned integers, reverts on overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a,"Invalid values");
83         return c;
84     }
85 
86     /**
87      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88      * reverts when dividing by zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0,"Invalid values");
92         return a % b;
93     }
94 }
95 
96 contract SynchroBitcoin is IERC20 {
97     using SafeMath for uint256;
98     address private _owner;
99     string private _name;
100     string private _symbol;
101     uint8 private _decimals;
102     uint256 private _totalSupply;
103     bool public _lockStatus = false;
104     bool private isValue;
105     uint256 public airdropcount = 0;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowed;
110 
111     mapping (address => uint256) private time;
112 
113     mapping (address => uint256) private _lockedAmount;
114 
115     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address owner) public {
116         _name = name;
117         _symbol = symbol;
118         _decimals = decimals;
119         _totalSupply = totalSupply*(10**uint256(decimals));
120         _balances[owner] = _totalSupply;
121         _owner = owner;
122     }
123 
124     /*----------------------------------------------------------------------------
125      * Functions for owner
126      *----------------------------------------------------------------------------
127      */
128 
129     /**
130     * @dev get address of smart contract owner
131     * @return address of owner
132     */
133     function getowner() public view returns (address) {
134         return _owner;
135     }
136 
137     /**
138     * @dev modifier to check if the message sender is owner
139     */
140     modifier onlyOwner() {
141         require(isOwner(),"You are not authenticate to make this transfer");
142         _;
143     }
144 
145     /**
146      * @dev Internal function for modifier
147      */
148     function isOwner() internal view returns (bool) {
149         return msg.sender == _owner;
150     }
151 
152     /**
153      * @dev Transfer ownership of the smart contract. For owner only
154      * @return request status
155       */
156     function transferOwnership(address newOwner) public onlyOwner returns (bool){
157         _owner = newOwner;
158         return true;
159     }
160 
161     /* ----------------------------------------------------------------------------
162      * Locking functions
163      * ----------------------------------------------------------------------------
164      */
165 
166     /**
167      * @dev Lock all transfer functions of the contract
168      * @return request status
169      */
170     function setAllTransfersLockStatus(bool RunningStatusLock) external onlyOwner returns (bool)
171     {
172         _lockStatus = RunningStatusLock;
173         return true;
174     }
175 
176     /**
177      * @dev check lock status of all transfers
178      * @return lock status
179      */
180     function getAllTransfersLockStatus() public view returns (bool)
181     {
182         return _lockStatus;
183     }
184 
185     /**
186      * @dev time calculator for locked tokens
187      */
188      function addLockingTime(address lockingAddress,uint8 lockingTime, uint256 amount) internal returns (bool){
189         time[lockingAddress] = now + (lockingTime * 1 days);
190         _lockedAmount[lockingAddress] = amount;
191         return true;
192      }
193 
194      /**
195       * @dev check for time based lock
196       * @param _address address to check for locking time
197       * @return time in block format
198       */
199       function checkLockingTimeByAddress(address _address) public view returns(uint256){
200          return time[_address];
201       }
202       /**
203        * @dev return locking status
204        * @param userAddress address of to check
205        * @return locking status in true or false
206        */
207        function getLockingStatus(address userAddress) public view returns(bool){
208            if (now < time[userAddress]){
209                return true;
210            }
211            else{
212                return false;
213            }
214        }
215 
216     /**
217      * @dev  Decreaese locking time
218      * @param _affectiveAddress Address of the locked address
219      * @param _decreasedTime Time in days to be affected
220      */
221     function decreaseLockingTimeByAddress(address _affectiveAddress, uint _decreasedTime) external onlyOwner returns(bool){
222           require(_decreasedTime > 0 && time[_affectiveAddress] > now, "Please check address status or Incorrect input");
223           time[_affectiveAddress] = time[_affectiveAddress] - (_decreasedTime * 1 days);
224           return true;
225       }
226 
227       /**
228      * @dev Increase locking time
229      * @param _affectiveAddress Address of the locked address
230      * @param _increasedTime Time in days to be affected
231      */
232     function increaseLockingTimeByAddress(address _affectiveAddress, uint _increasedTime) external onlyOwner returns(bool){
233           require(_increasedTime > 0 && time[_affectiveAddress] > now, "Please check address status or Incorrect input");
234           time[_affectiveAddress] = time[_affectiveAddress] + (_increasedTime * 1 days);
235           return true;
236       }
237 
238     /**
239      * @dev modifier to check validation of lock status of smart contract
240      */
241     modifier AllTransfersLockStatus()
242     {
243         require(_lockStatus == false,"All transactions are locked for this contract");
244         _;
245     }
246 
247     /**
248      * @dev modifier to check locking amount
249      * @param _address address to check
250      * @param requestedAmount Amount to check
251      * @return status
252      */
253      modifier checkLocking(address _address,uint256 requestedAmount){
254          if(now < time[_address]){
255          require(!( _balances[_address] - _lockedAmount[_address] < requestedAmount), "Insufficient unlocked balance");
256          }
257         else{
258             require(1 == 1,"Transfer can not be processed");
259         }
260         _;
261      }
262 
263     /* ----------------------------------------------------------------------------
264      * View only functions
265      * ----------------------------------------------------------------------------
266      */
267 
268     /**
269      * @return the name of the token.
270      */
271     function name() public view returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @return the symbol of the token.
277      */
278     function symbol() public view returns (string memory) {
279         return _symbol;
280     }
281 
282     /**
283      * @return the number of decimals of the token.
284      */
285     function decimals() public view returns (uint8) {
286         return _decimals;
287     }
288 
289     /**
290      * @dev Total number of tokens in existence.
291      */
292     function totalSupply() public view returns (uint256) {
293         return _totalSupply;
294     }
295 
296     /**
297      * @dev Gets the balance of the specified address.
298      * @param owner The address to query the balance of.
299      * @return A uint256 representing the amount owned by the passed address.
300      */
301     function balanceOf(address owner) public view returns (uint256) {
302         return _balances[owner];
303     }
304 
305     /**
306      * @dev Function to check the amount of tokens that an owner allowed to a spender.
307      * @param owner address The address which owns the funds.
308      * @param spender address The address which will spend the funds.
309      * @return A uint256 specifying the amount of tokens still available for the spender.
310      */
311     function allowance(address owner, address spender) public view returns (uint256) {
312         return _allowed[owner][spender];
313     }
314 
315     /* ----------------------------------------------------------------------------
316      * Transfer, allow, mint and burn functions
317      * ----------------------------------------------------------------------------
318      */
319 
320     /**
321      * @dev Transfer token to a specified address.
322      * @param to The address to transfer to.
323      * @param value The amount to be transferred.
324      */
325     function transfer(address to, uint256 value) public AllTransfersLockStatus checkLocking(msg.sender,value) returns (bool) {
326             _transfer(msg.sender, to, value);
327             return true;
328     }
329 
330     /**
331      * @dev Transfer tokens from one address to another.
332      * Note that while this function emits an Approval event, this is not required as per the specification,
333      * and other compliant implementations may not emit the event.
334      * @param from address The address which you want to send tokens from
335      * @param to address The address which you want to transfer to
336      * @param value uint256 the amount of tokens to be transferred
337      */
338     function transferFrom(address from, address to, uint256 value) public AllTransfersLockStatus checkLocking(from,value) returns (bool) {
339              _transfer(from, to, value);
340              _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
341              return true;
342     }
343 
344     /**
345      * @dev Transfer tokens to a secified address (For Only Owner)
346      * @param to The address to transfer to.
347      * @param value The amount to be transferred.
348      * @return Transfer status in true or false
349      */
350     function transferByOwner(address to, uint256 value, uint8 lockingTime) public AllTransfersLockStatus onlyOwner returns (bool) {
351         addLockingTime(to,lockingTime,value);
352         _transfer(msg.sender, to, value);
353         return true;
354     }
355 
356     /**
357      * @dev withdraw locked tokens only (For Only Owner)
358      * @param from locked address
359      * @param to address to be transfer tokens
360      * @param value amount of tokens to unlock and transfer
361      * @return transfer status
362      */
363      function transferLockedTokens(address from, address to, uint256 value) external onlyOwner returns (bool){
364         require((_lockedAmount[from] >= value) && (now < time[from]), "Insufficient unlocked balance");
365         require(from != address(0) && to != address(0), "Invalid address");
366         _lockedAmount[from] = _lockedAmount[from] - value;
367         _transfer(from,to,value);
368      }
369 
370      /**
371       * @dev Airdrop function to airdrop tokens. Best works upto 50 addresses in one time. Maximum limit is 200 addresses in one time.
372       * @param _addresses array of address in serial order
373       * @param _amount amount in serial order with respect to address array
374       */
375       function airdropByOwner(address[] memory _addresses, uint256[] memory _amount) public AllTransfersLockStatus onlyOwner returns (bool){
376           require(_addresses.length == _amount.length,"Invalid Array");
377           uint256 count = _addresses.length;
378           for (uint256 i = 0; i < count; i++){
379                _transfer(msg.sender, _addresses[i], _amount[i]);
380                airdropcount = airdropcount + 1;
381           }
382           return true;
383       }
384 
385     /**
386      * @dev Transfer token for a specified addresses.
387      * @param from The address to transfer from.
388      * @param to The address to transfer to.
389      * @param value The amount to be transferred.
390      */
391     function _transfer(address from, address to, uint256 value) internal {
392         require(to != address(0),"Invalid to address");
393         _balances[from] = _balances[from].sub(value);
394         _balances[to] = _balances[to].add(value);
395         emit Transfer(from, to, value);
396     }
397 
398     /**
399      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
400      * Beware that changing an allowance with this method brings the risk that someone may use both the old
401      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
402      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
403      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
404      * @param spender The address which will spend the funds.
405      * @param value The amount of tokens to be spent.
406      */
407     function approve(address spender, uint256 value) public returns (bool) {
408         _approve(msg.sender, spender, value);
409         return true;
410     }
411 
412     /**
413      * @dev Approve an address to spend another addresses' tokens.
414      * @param owner The address that owns the tokens.
415      * @param spender The address that will spend the tokens.
416      * @param value The number of tokens that can be spent.
417      */
418     function _approve(address owner, address spender, uint256 value) internal {
419         require(spender != address(0),"Invalid address");
420         require(owner != address(0),"Invalid address");
421         _allowed[owner][spender] = value;
422         emit Approval(owner, spender, value);
423     }
424 
425     /**
426      * @dev Increase the amount of tokens that an owner allowed to a spender.
427      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
428      * allowed value is better to use this function to avoid 2 calls (and wait until
429      * the first transaction is mined)
430      * From MonolithDAO Token.sol
431      * Emits an Approval event.
432      * @param spender The address which will spend the funds.
433      * @param addedValue The amount of tokens to increase the allowance by.
434      */
435     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
436         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
437         return true;
438     }
439 
440     /**
441      * @dev Decrease the amount of tokens that an owner allowed to a spender.
442      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
443      * allowed value is better to use this function to avoid 2 calls (and wait until
444      * the first transaction is mined)
445      * From MonolithDAO Token.sol
446      * Emits an Approval event.
447      * @param spender The address which will spend the funds.
448      * @param subtractedValue The amount of tokens to decrease the allowance by.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
451         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
452         return true;
453     }
454 
455     /**
456      * @dev Internal function that burns an amount of the token of a given
457      * account.
458      * @param account The account whose tokens will be burnt.
459      * @param value The amount that will be burnt.
460      */
461     function _burn(address account, uint256 value) internal {
462         require(account != address(0),"Invalid account");
463         _totalSupply = _totalSupply.sub(value);
464         _balances[account] = _balances[account].sub(value);
465         emit Transfer(account, address(0), value);
466     }
467 
468     /**
469      * @dev Burns a specific amount of tokens.
470      * @param value The amount of token to be burned.
471      */
472     function burn(uint256 value) public onlyOwner checkLocking(msg.sender,value){
473         _burn(msg.sender, value);
474     }
475 }