1 pragma solidity ^0.4.21;
2 
3 // Project: MOBU.io
4 // v12, 2018-08-24
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (b>=a) return 0;
34         return a - b;
35     }
36 }
37 
38 contract MigrationAgent
39 {
40     function migrateFrom(address _from, uint256 _value) public;
41 }
42 
43 contract ICreator{
44     IRightAndRoles public rightAndRoles;
45     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
46     function createFinancialStrategy() external returns(IFinancialStrategy);
47     function getRightAndRoles() external returns(IRightAndRoles);
48 }
49 
50 contract ERC20Basic {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public view returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract GuidedByRoles {
65     IRightAndRoles public rightAndRoles;
66     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
67         rightAndRoles = _rightAndRoles;
68     }
69 }
70 
71 contract Pausable is GuidedByRoles {
72 
73     mapping (address => bool) public unpausedWallet;
74 
75     event Pause();
76     event Unpause();
77 
78     bool public paused = true;
79 
80 
81     /**
82      * @dev Modifier to make a function callable only when the contract is not paused.
83      */
84     modifier whenNotPaused(address _to) {
85         require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
86         _;
87     }
88 
89     function onlyAdmin() internal view {
90         require(rightAndRoles.onlyRoles(msg.sender,3));
91     }
92 
93     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
94     function setUnpausedWallet(address _wallet, bool mode) public {
95         onlyAdmin();
96         unpausedWallet[_wallet] = mode;
97     }
98 
99     /**
100      * @dev called by the owner to pause, triggers stopped state
101      */
102     function setPause(bool mode)  public {
103         require(rightAndRoles.onlyRoles(msg.sender,1));
104         if (!paused && mode) {
105             paused = true;
106             emit Pause();
107         }else
108         if (paused && !mode) {
109             paused = false;
110             emit Unpause();
111         }
112     }
113 
114 }
115 
116 contract ERC20Provider is GuidedByRoles {
117     function transferTokens(ERC20Basic _token, address _to, uint256 _value) public returns (bool){
118         require(rightAndRoles.onlyRoles(msg.sender,2));
119         return _token.transfer(_to,_value);
120     }
121 }
122 
123 contract IRightAndRoles {
124     address[][] public wallets;
125     mapping(address => uint16) public roles;
126 
127     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
128     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
129 
130     function changeWallet(address _wallet, uint8 _role) external;
131     function setManagerPowerful(bool _mode) external;
132     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
133 }
134 
135 contract IToken{
136     function setUnpausedWallet(address _wallet, bool mode) public;
137     function mint(address _to, uint256 _amount) public returns (bool);
138     function totalSupply() public view returns (uint256);
139     function setPause(bool mode) public;
140     function setMigrationAgent(address _migrationAgent) public;
141     function migrateAll(address[] _holders) public;
142     function markTokens(address _beneficiary, uint256 _value) public;
143     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
144     function defrostDate(address _beneficiary) public view returns (uint256 Date);
145     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
146 }
147 
148 contract IFinancialStrategy{
149 
150     enum State { Active, Refunding, Closed }
151     State public state = State.Active;
152 
153     event Deposited(address indexed beneficiary, uint256 weiAmount);
154     event Receive(address indexed beneficiary, uint256 weiAmount);
155     event Refunded(address indexed beneficiary, uint256 weiAmount);
156     event Started();
157     event Closed();
158     event RefundsEnabled();
159     function freeCash() view public returns(uint256);
160     function deposit(address _beneficiary) external payable;
161     function refund(address _investor) external;
162     function setup(uint8 _state, bytes32[] _params) external;
163     function getBeneficiaryCash() external;
164     function getPartnerCash(uint8 _user, address _msgsender) external;
165 }
166 
167 contract IAllocation {
168     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
169 }
170 
171 contract BasicToken is ERC20Basic {
172     using SafeMath for uint256;
173 
174     mapping(address => uint256) balances;
175 
176     uint256 totalSupply_;
177 
178     /**
179     * @dev total number of tokens in existence
180     */
181     function totalSupply() public view returns (uint256) {
182         return totalSupply_;
183     }
184 
185     /**
186     * @dev transfer token for a specified address
187     * @param _to The address to transfer to.
188     * @param _value The amount to be transferred.
189     */
190     function transfer(address _to, uint256 _value) public returns (bool) {
191         require(_to != address(0));
192         require(_value <= balances[msg.sender]);
193 
194         // SafeMath.sub will throw if there is not enough balance.
195         balances[msg.sender] = balances[msg.sender].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         emit Transfer(msg.sender, _to, _value);
198         return true;
199     }
200 
201     /**
202     * @dev Gets the balance of the specified address.
203     * @param _owner The address to query the the balance of.
204     * @return An uint256 representing the amount owned by the passed address.
205     */
206     function balanceOf(address _owner) public view returns (uint256 balance) {
207         return balances[_owner];
208     }
209 
210 }
211 
212 contract KycToken is BasicToken, GuidedByRoles {
213 
214     event TokensMarked(address indexed beneficiary, uint256 value);
215 
216     function markTokens(address _beneficiary, uint256 _value) public {
217         require(rightAndRoles.onlyRoles(msg.sender,1));
218         require(_value <= balances[_beneficiary]);
219         // no need to require value <= totalSupply, since that would imply the
220         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
221 
222         balances[_beneficiary] = balances[_beneficiary].sub(_value);
223         totalSupply_ = totalSupply_.sub(_value);
224         emit TokensMarked(_beneficiary, _value);
225         emit Transfer(_beneficiary, address(0), _value);
226     }
227 }
228 
229 contract StandardToken is ERC20, BasicToken {
230 
231     mapping (address => mapping (address => uint256)) internal allowed;
232 
233 
234     /**
235      * @dev Transfer tokens from one address to another
236      * @param _from address The address which you want to send tokens from
237      * @param _to address The address which you want to transfer to
238      * @param _value uint256 the amount of tokens to be transferred
239      */
240     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241         require(_to != address(0));
242         require(_value <= balances[_from]);
243         require(_value <= allowed[_from][msg.sender]);
244 
245         balances[_from] = balances[_from].sub(_value);
246         balances[_to] = balances[_to].add(_value);
247         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248         emit Transfer(_from, _to, _value);
249         return true;
250     }
251 
252     /**
253      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254      *
255      * Beware that changing an allowance with this method brings the risk that someone may use both the old
256      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259      * @param _spender The address which will spend the funds.
260      * @param _value The amount of tokens to be spent.
261      */
262     function approve(address _spender, uint256 _value) public returns (bool) {
263         allowed[msg.sender][_spender] = _value;
264         emit Approval(msg.sender, _spender, _value);
265         return true;
266     }
267 
268     /**
269      * @dev Function to check the amount of tokens that an owner allowed to a spender.
270      * @param _owner address The address which owns the funds.
271      * @param _spender address The address which will spend the funds.
272      * @return A uint256 specifying the amount of tokens still available for the spender.
273      */
274     function allowance(address _owner, address _spender) public view returns (uint256) {
275         return allowed[_owner][_spender];
276     }
277 
278     /**
279      * @dev Increase the amount of tokens that an owner allowed to a spender.
280      *
281      * approve should be called when allowed[_spender] == 0. To increment
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * @param _spender The address which will spend the funds.
286      * @param _addedValue The amount of tokens to increase the allowance by.
287      */
288     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
289         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291         return true;
292     }
293 
294     /**
295      * @dev Decrease the amount of tokens that an owner allowed to a spender.
296      *
297      * approve should be called when allowed[_spender] == 0. To decrement
298      * allowed value is better to use this function to avoid 2 calls (and wait until
299      * the first transaction is mined)
300      * From MonolithDAO Token.sol
301      * @param _spender The address which will spend the funds.
302      * @param _subtractedValue The amount of tokens to decrease the allowance by.
303      */
304     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
305         uint oldValue = allowed[msg.sender][_spender];
306         if (_subtractedValue > oldValue) {
307             allowed[msg.sender][_spender] = 0;
308         } else {
309             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310         }
311         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312         return true;
313     }
314 
315 }
316 
317 contract PausableToken is StandardToken, Pausable {
318 
319     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
320         return super.transfer(_to, _value);
321     }
322 
323     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
324         return super.transferFrom(_from, _to, _value);
325     }
326 }
327 
328 contract FreezingToken is PausableToken {
329     struct freeze {
330     uint256 amount;
331     uint256 when;
332     }
333 
334 
335     mapping (address => freeze) freezedTokens;
336 
337     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
338         freeze storage _freeze = freezedTokens[_beneficiary];
339         if(_freeze.when < now) return 0;
340         return _freeze.amount;
341     }
342 
343     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
344         freeze storage _freeze = freezedTokens[_beneficiary];
345         if(_freeze.when < now) return 0;
346         return _freeze.when;
347     }
348 
349     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {
350         require(rightAndRoles.onlyRoles(msg.sender,1));
351         freeze storage _freeze = freezedTokens[_beneficiary];
352         _freeze.amount = _amount;
353         _freeze.when = _when;
354     }
355 
356     function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {
357         onlyAdmin();
358         require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);
359         for(uint16 i = 0; i < _beneficiary.length; i++){
360             require(_when[i] < 1557486000); //TODO - check
361             freeze storage _freeze = freezedTokens[_beneficiary[i]];
362             _freeze.amount = _amount[i];
363             _freeze.when = _when[i];
364         }
365     }
366 
367 
368     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
369         require(unpausedWallet[msg.sender]);
370         require(freezedTokenOf(_to) == 0);
371         if(_when > 0){
372             freeze storage _freeze = freezedTokens[_to];
373             _freeze.amount = _value;
374             _freeze.when = _when;
375         }
376         transfer(_to,_value);
377     }
378 
379     function transfer(address _to, uint256 _value) public returns (bool) {
380         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
381         return super.transfer(_to,_value);
382     }
383 
384     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
385         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
386         return super.transferFrom( _from,_to,_value);
387     }
388 }
389 
390 contract MintableToken is StandardToken, GuidedByRoles {
391     event Mint(address indexed to, uint256 amount);
392     event MintFinished();
393 
394     /**
395      * @dev Function to mint tokens
396      * @param _to The address that will receive the minted tokens.
397      * @param _amount The amount of tokens to mint.
398      * @return A boolean that indicates if the operation was successful.
399      */
400     function mint(address _to, uint256 _amount) public returns (bool) {
401         require(rightAndRoles.onlyRoles(msg.sender,1));
402         totalSupply_ = totalSupply_.add(_amount);
403         balances[_to] = balances[_to].add(_amount);
404         emit Mint(_to, _amount);
405         emit Transfer(address(0), _to, _amount);
406         return true;
407     }
408 }
409 
410 contract MigratableToken is BasicToken,GuidedByRoles {
411 
412     uint256 public totalMigrated;
413     address public migrationAgent;
414 
415     event Migrate(address indexed _from, address indexed _to, uint256 _value);
416 
417     function setMigrationAgent(address _migrationAgent) public {
418         require(rightAndRoles.onlyRoles(msg.sender,6));
419         require(totalMigrated == 0);
420         migrationAgent = _migrationAgent;
421     }
422 
423 
424     function migrateInternal(address _holder) internal{
425         require(migrationAgent != 0x0);
426 
427         uint256 value = balances[_holder];
428         balances[_holder] = 0;
429 
430         totalSupply_ = totalSupply_.sub(value);
431         totalMigrated = totalMigrated.add(value);
432 
433         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
434         emit Migrate(_holder,migrationAgent,value);
435     }
436 
437     function migrateAll(address[] _holders) public {
438         require(rightAndRoles.onlyRoles(msg.sender,6));
439         for(uint i = 0; i < _holders.length; i++){
440             migrateInternal(_holders[i]);
441         }
442     }
443 
444     // Reissue your tokens.
445     function migrate() public
446     {
447         require(balances[msg.sender] > 0);
448         migrateInternal(msg.sender);
449     }
450 
451 }
452 
453 contract Token is IToken, FreezingToken, MintableToken, MigratableToken, KycToken,ERC20Provider {
454     function Token(ICreator _creator) GuidedByRoles(_creator.rightAndRoles()) public {}
455     string public constant name = "MOBU token";
456     string public constant symbol = "MOBU";
457     uint8 public constant decimals = 18;
458 }