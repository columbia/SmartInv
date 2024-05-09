1 pragma solidity ^0.4.21;
2 
3 // Project: alehub.io
4 // v11, 2018-07-17
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 contract MigrationAgent
11 {
12     function migrateFrom(address _from, uint256 _value) public;
13 }
14 
15 contract IFinancialStrategy{
16 
17     enum State { Active, Refunding, Closed }
18     State public state = State.Active;
19 
20     event Deposited(address indexed beneficiary, uint256 weiAmount);
21     event Receive(address indexed beneficiary, uint256 weiAmount);
22     event Refunded(address indexed beneficiary, uint256 weiAmount);
23     event Started();
24     event Closed();
25     event RefundsEnabled();
26     function freeCash() view public returns(uint256);
27     function deposit(address _beneficiary) external payable;
28     function refund(address _investor) external;
29     function setup(uint8 _state, bytes32[] _params) external;
30     function getBeneficiaryCash() external;
31     function getPartnerCash(uint8 _user, address _msgsender) external;
32 }
33 
34 contract IAllocation {
35     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
36 }
37 
38 library SafeMath {
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         assert(c / a == b);
45         return c;
46     }
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a / b;
49         return c;
50     }
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a);
58         return c;
59     }
60     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (b>=a) return 0;
62         return a - b;
63     }
64 }
65 
66 contract GuidedByRoles {
67     IRightAndRoles public rightAndRoles;
68     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
69         rightAndRoles = _rightAndRoles;
70     }
71 }
72 
73 contract Pausable is GuidedByRoles {
74 
75     mapping (address => bool) public unpausedWallet;
76 
77     event Pause();
78     event Unpause();
79 
80     bool public paused = true;
81 
82 
83     /**
84      * @dev Modifier to make a function callable only when the contract is not paused.
85      */
86     modifier whenNotPaused(address _to) {
87         require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
88         _;
89     }
90 
91     function onlyAdmin() internal view {
92         require(rightAndRoles.onlyRoles(msg.sender,3));
93     }
94 
95     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
96     function setUnpausedWallet(address _wallet, bool mode) public {
97         onlyAdmin();
98         unpausedWallet[_wallet] = mode;
99     }
100 
101     /**
102      * @dev called by the owner to pause, triggers stopped state
103      */
104     function setPause(bool mode)  public {
105         require(rightAndRoles.onlyRoles(msg.sender,1));
106         if (!paused && mode) {
107             paused = true;
108             emit Pause();
109         }else
110         if (paused && !mode) {
111             paused = false;
112             emit Unpause();
113         }
114     }
115 
116 }
117 
118 contract IRightAndRoles {
119     address[][] public wallets;
120     mapping(address => uint16) public roles;
121 
122     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
123     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
124 
125     function changeWallet(address _wallet, uint8 _role) external;
126     function setManagerPowerful(bool _mode) external;
127     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
128 }
129 
130 contract IToken{
131     function setUnpausedWallet(address _wallet, bool mode) public;
132     function mint(address _to, uint256 _amount) public returns (bool);
133     function totalSupply() public view returns (uint256);
134     function setPause(bool mode) public;
135     function setMigrationAgent(address _migrationAgent) public;
136     function migrateAll(address[] _holders) public;
137     function rejectTokens(address _beneficiary, uint256 _value) public;
138     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
139     function defrostDate(address _beneficiary) public view returns (uint256 Date);
140     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
141 }
142 
143 contract ICreator{
144     IRightAndRoles public rightAndRoles;
145     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
146     function createFinancialStrategy() external returns(IFinancialStrategy);
147     function getRightAndRoles() external returns(IRightAndRoles);
148 }
149 
150 contract ERC20Provider is GuidedByRoles {
151     function transferTokens(ERC20Basic _token, address _to, uint256 _value) public returns (bool){
152         require(rightAndRoles.onlyRoles(msg.sender,2));
153         return _token.transfer(_to,_value);
154     }
155 }
156 
157 contract ERC20Basic {
158     function totalSupply() public view returns (uint256);
159     function balanceOf(address who) public view returns (uint256);
160     function transfer(address to, uint256 value) public returns (bool);
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 }
163 
164 contract BasicToken is ERC20Basic {
165     using SafeMath for uint256;
166 
167     mapping(address => uint256) balances;
168 
169     uint256 totalSupply_;
170 
171     /**
172     * @dev total number of tokens in existence
173     */
174     function totalSupply() public view returns (uint256) {
175         return totalSupply_;
176     }
177 
178     /**
179     * @dev transfer token for a specified address
180     * @param _to The address to transfer to.
181     * @param _value The amount to be transferred.
182     */
183     function transfer(address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[msg.sender]);
186 
187         // SafeMath.sub will throw if there is not enough balance.
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         emit Transfer(msg.sender, _to, _value);
191         return true;
192     }
193 
194     /**
195     * @dev Gets the balance of the specified address.
196     * @param _owner The address to query the the balance of.
197     * @return An uint256 representing the amount owned by the passed address.
198     */
199     function balanceOf(address _owner) public view returns (uint256 balance) {
200         return balances[_owner];
201     }
202 
203 }
204 
205 contract KycToken is BasicToken, GuidedByRoles {
206 
207     event TokensRejected(address indexed beneficiary, uint256 value);
208 
209     /**
210      * @dev Burns a specific amount of tokens.
211      * @param _value The amount of token to be burned.
212      */
213     function rejectTokens(address _beneficiary, uint256 _value) public {
214         require(rightAndRoles.onlyRoles(msg.sender,1));
215         require(_value <= balances[_beneficiary]);
216         // no need to require value <= totalSupply, since that would imply the
217         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
218 
219         balances[_beneficiary] = balances[_beneficiary].sub(_value);
220         totalSupply_ = totalSupply_.sub(_value);
221         emit TokensRejected(_beneficiary, _value);
222         emit Transfer(_beneficiary, address(0), _value);
223     }
224 }
225 
226 contract MigratableToken is BasicToken,GuidedByRoles {
227 
228     uint256 public totalMigrated;
229     address public migrationAgent;
230 
231     event Migrate(address indexed _from, address indexed _to, uint256 _value);
232 
233     function setMigrationAgent(address _migrationAgent) public {
234         require(rightAndRoles.onlyRoles(msg.sender,1));
235         require(totalMigrated == 0);
236         migrationAgent = _migrationAgent;
237     }
238 
239 
240     function migrateInternal(address _holder) internal{
241         require(migrationAgent != 0x0);
242 
243         uint256 value = balances[_holder];
244         balances[_holder] = 0;
245 
246         totalSupply_ = totalSupply_.sub(value);
247         totalMigrated = totalMigrated.add(value);
248 
249         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
250         emit Migrate(_holder,migrationAgent,value);
251     }
252 
253     function migrateAll(address[] _holders) public {
254         require(rightAndRoles.onlyRoles(msg.sender,1));
255         for(uint i = 0; i < _holders.length; i++){
256             migrateInternal(_holders[i]);
257         }
258     }
259 
260     // Reissue your tokens.
261     function migrate() public
262     {
263         require(balances[msg.sender] > 0);
264         migrateInternal(msg.sender);
265     }
266 
267 }
268 
269 contract ERC20 is ERC20Basic {
270     function allowance(address owner, address spender) public view returns (uint256);
271     function transferFrom(address from, address to, uint256 value) public returns (bool);
272     function approve(address spender, uint256 value) public returns (bool);
273     event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 contract StandardToken is ERC20, BasicToken {
277 
278     mapping (address => mapping (address => uint256)) internal allowed;
279 
280 
281     /**
282      * @dev Transfer tokens from one address to another
283      * @param _from address The address which you want to send tokens from
284      * @param _to address The address which you want to transfer to
285      * @param _value uint256 the amount of tokens to be transferred
286      */
287     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
288         require(_to != address(0));
289         require(_value <= balances[_from]);
290         require(_value <= allowed[_from][msg.sender]);
291 
292         balances[_from] = balances[_from].sub(_value);
293         balances[_to] = balances[_to].add(_value);
294         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295         emit Transfer(_from, _to, _value);
296         return true;
297     }
298 
299     /**
300      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
301      *
302      * Beware that changing an allowance with this method brings the risk that someone may use both the old
303      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
304      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
305      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
306      * @param _spender The address which will spend the funds.
307      * @param _value The amount of tokens to be spent.
308      */
309     function approve(address _spender, uint256 _value) public returns (bool) {
310         allowed[msg.sender][_spender] = _value;
311         emit Approval(msg.sender, _spender, _value);
312         return true;
313     }
314 
315     /**
316      * @dev Function to check the amount of tokens that an owner allowed to a spender.
317      * @param _owner address The address which owns the funds.
318      * @param _spender address The address which will spend the funds.
319      * @return A uint256 specifying the amount of tokens still available for the spender.
320      */
321     function allowance(address _owner, address _spender) public view returns (uint256) {
322         return allowed[_owner][_spender];
323     }
324 
325     /**
326      * @dev Increase the amount of tokens that an owner allowed to a spender.
327      *
328      * approve should be called when allowed[_spender] == 0. To increment
329      * allowed value is better to use this function to avoid 2 calls (and wait until
330      * the first transaction is mined)
331      * From MonolithDAO Token.sol
332      * @param _spender The address which will spend the funds.
333      * @param _addedValue The amount of tokens to increase the allowance by.
334      */
335     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
336         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
337         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
338         return true;
339     }
340 
341     /**
342      * @dev Decrease the amount of tokens that an owner allowed to a spender.
343      *
344      * approve should be called when allowed[_spender] == 0. To decrement
345      * allowed value is better to use this function to avoid 2 calls (and wait until
346      * the first transaction is mined)
347      * From MonolithDAO Token.sol
348      * @param _spender The address which will spend the funds.
349      * @param _subtractedValue The amount of tokens to decrease the allowance by.
350      */
351     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
352         uint oldValue = allowed[msg.sender][_spender];
353         if (_subtractedValue > oldValue) {
354             allowed[msg.sender][_spender] = 0;
355         } else {
356             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
357         }
358         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359         return true;
360     }
361 
362 }
363 
364 contract PausableToken is StandardToken, Pausable {
365 
366     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
367         return super.transfer(_to, _value);
368     }
369 
370     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
371         return super.transferFrom(_from, _to, _value);
372     }
373 }
374 
375 contract MintableToken is StandardToken, GuidedByRoles {
376     event Mint(address indexed to, uint256 amount);
377     event MintFinished();
378 
379     /**
380      * @dev Function to mint tokens
381      * @param _to The address that will receive the minted tokens.
382      * @param _amount The amount of tokens to mint.
383      * @return A boolean that indicates if the operation was successful.
384      */
385     function mint(address _to, uint256 _amount) public returns (bool) {
386         require(rightAndRoles.onlyRoles(msg.sender,1));
387         totalSupply_ = totalSupply_.add(_amount);
388         balances[_to] = balances[_to].add(_amount);
389         emit Mint(_to, _amount);
390         emit Transfer(address(0), _to, _amount);
391         return true;
392     }
393 }
394 
395 contract FreezingToken is PausableToken {
396     struct freeze {
397     uint256 amount;
398     uint256 when;
399     }
400 
401 
402     mapping (address => freeze) freezedTokens;
403 
404     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
405         freeze storage _freeze = freezedTokens[_beneficiary];
406         if(_freeze.when < now) return 0;
407         return _freeze.amount;
408     }
409 
410     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
411         freeze storage _freeze = freezedTokens[_beneficiary];
412         if(_freeze.when < now) return 0;
413         return _freeze.when;
414     }
415 
416     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {
417         require(rightAndRoles.onlyRoles(msg.sender,1));
418         freeze storage _freeze = freezedTokens[_beneficiary];
419         _freeze.amount = _amount;
420         _freeze.when = _when;
421     }
422 
423     function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {
424         onlyAdmin();
425         require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);
426         for(uint16 i = 0; i < _beneficiary.length; i++){
427             freeze storage _freeze = freezedTokens[_beneficiary[i]];
428             _freeze.amount = _amount[i];
429             _freeze.when = _when[i];
430         }
431     }
432 
433 
434     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
435         require(unpausedWallet[msg.sender]);
436         require(freezedTokenOf(_to) == 0);
437         if(_when > 0){
438             freeze storage _freeze = freezedTokens[_to];
439             _freeze.amount = _value;
440             _freeze.when = _when;
441         }
442         transfer(_to,_value);
443     }
444 
445     function transfer(address _to, uint256 _value) public returns (bool) {
446         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
447         return super.transfer(_to,_value);
448     }
449 
450     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
451         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
452         return super.transferFrom( _from,_to,_value);
453     }
454 }
455 
456 contract Token is IToken, FreezingToken, MintableToken, MigratableToken, KycToken,ERC20Provider {
457     function Token(ICreator _creator) GuidedByRoles(_creator.rightAndRoles()) public {}
458     string public constant name = "Ale Coin";
459     string public constant symbol = "ALE";
460     uint8 public constant decimals = 18;
461 }