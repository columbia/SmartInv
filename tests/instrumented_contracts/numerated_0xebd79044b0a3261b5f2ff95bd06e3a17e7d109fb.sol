1 pragma solidity ^0.4.21;
2 
3 // Project: imigize.io (original)
4 // v13, 2018-06-19
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 contract IFinancialStrategy{
11 
12     enum State { Active, Refunding, Closed }
13     State public state = State.Active;
14 
15     event Deposited(address indexed beneficiary, uint256 weiAmount);
16     event Receive(address indexed beneficiary, uint256 weiAmount);
17     event Refunded(address indexed beneficiary, uint256 weiAmount);
18     event Started();
19     event Closed();
20     event RefundsEnabled();
21     function freeCash() view public returns(uint256);
22     function deposit(address _beneficiary) external payable;
23     function refund(address _investor) external;
24     function setup(uint8 _state, bytes32[] _params) external;
25     function getBeneficiaryCash() external;
26     function getPartnerCash(uint8 _user, address _msgsender) external;
27 }
28 
29 contract ICreator{
30     IRightAndRoles public rightAndRoles;
31     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
32     function createFinancialStrategy() external returns(IFinancialStrategy);
33     function getRightAndRoles() external returns(IRightAndRoles);
34 }
35 
36 contract IRightAndRoles {
37     address[][] public wallets;
38     mapping(address => uint16) public roles;
39 
40     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
41     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
42 
43     function changeWallet(address _wallet, uint8 _role) external;
44     function setManagerPowerful(bool _mode) external;
45     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
46 }
47 
48 contract MigrationAgent
49 {
50     function migrateFrom(address _from, uint256 _value) public;
51 }
52 
53 contract GuidedByRoles {
54     IRightAndRoles public rightAndRoles;
55     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
56         rightAndRoles = _rightAndRoles;
57     }
58 }
59 
60 contract Pausable is GuidedByRoles {
61 
62     mapping (address => bool) public unpausedWallet;
63 
64     event Pause();
65     event Unpause();
66 
67     bool public paused = true;
68 
69 
70     /**
71      * @dev Modifier to make a function callable only when the contract is not paused.
72      */
73     modifier whenNotPaused(address _to) {
74         require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
75         _;
76     }
77 
78     function onlyAdmin() internal view {
79         require(rightAndRoles.onlyRoles(msg.sender,3));
80     }
81 
82     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
83     function setUnpausedWallet(address _wallet, bool mode) public {
84         onlyAdmin();
85         unpausedWallet[_wallet] = mode;
86     }
87 
88     /**
89      * @dev called by the owner to pause, triggers stopped state
90      */
91     function setPause(bool mode)  public {
92         require(rightAndRoles.onlyRoles(msg.sender,1));
93         if (!paused && mode) {
94             paused = true;
95             emit Pause();
96         }else
97         if (paused && !mode) {
98             paused = false;
99             emit Unpause();
100         }
101     }
102 
103 }
104 
105 contract ERC20Basic {
106     function totalSupply() public view returns (uint256);
107     function balanceOf(address who) public view returns (uint256);
108     function transfer(address to, uint256 value) public returns (bool);
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 contract ERC20 is ERC20Basic {
113     function allowance(address owner, address spender) public view returns (uint256);
114     function transferFrom(address from, address to, uint256 value) public returns (bool);
115     function approve(address spender, uint256 value) public returns (bool);
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 contract BasicToken is ERC20Basic {
120     using SafeMath for uint256;
121 
122     mapping(address => uint256) balances;
123 
124     uint256 totalSupply_;
125 
126     /**
127     * @dev total number of tokens in existence
128     */
129     function totalSupply() public view returns (uint256) {
130         return totalSupply_;
131     }
132 
133     /**
134     * @dev transfer token for a specified address
135     * @param _to The address to transfer to.
136     * @param _value The amount to be transferred.
137     */
138     function transfer(address _to, uint256 _value) public returns (bool) {
139         require(_to != address(0));
140         require(_value <= balances[msg.sender]);
141 
142         // SafeMath.sub will throw if there is not enough balance.
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         emit Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     /**
150     * @dev Gets the balance of the specified address.
151     * @param _owner The address to query the the balance of.
152     * @return An uint256 representing the amount owned by the passed address.
153     */
154     function balanceOf(address _owner) public view returns (uint256 balance) {
155         return balances[_owner];
156     }
157 
158 }
159 
160 contract MigratableToken is BasicToken,GuidedByRoles {
161 
162     uint256 public totalMigrated;
163     address public migrationAgent;
164 
165     event Migrate(address indexed _from, address indexed _to, uint256 _value);
166 
167     function setMigrationAgent(address _migrationAgent) public {
168         require(rightAndRoles.onlyRoles(msg.sender,1));
169         require(totalMigrated == 0);
170         migrationAgent = _migrationAgent;
171     }
172 
173 
174     function migrateInternal(address _holder) internal{
175         require(migrationAgent != 0x0);
176 
177         uint256 value = balances[_holder];
178         balances[_holder] = 0;
179 
180         totalSupply_ = totalSupply_.sub(value);
181         totalMigrated = totalMigrated.add(value);
182 
183         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
184         emit Migrate(_holder,migrationAgent,value);
185     }
186 
187     function migrateAll(address[] _holders) public {
188         require(rightAndRoles.onlyRoles(msg.sender,1));
189         for(uint i = 0; i < _holders.length; i++){
190             migrateInternal(_holders[i]);
191         }
192     }
193 
194     // Reissue your tokens.
195     function migrate() public
196     {
197         require(balances[msg.sender] > 0);
198         migrateInternal(msg.sender);
199     }
200 
201 }
202 
203 contract BurnableToken is BasicToken, GuidedByRoles {
204 
205     event Burn(address indexed burner, uint256 value);
206 
207     /**
208      * @dev Burns a specific amount of tokens.
209      * @param _value The amount of token to be burned.
210      */
211     function burn(address _beneficiary, uint256 _value) public {
212         require(rightAndRoles.onlyRoles(msg.sender,1));
213         require(_value <= balances[_beneficiary]);
214         // no need to require value <= totalSupply, since that would imply the
215         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
216 
217         balances[_beneficiary] = balances[_beneficiary].sub(_value);
218         totalSupply_ = totalSupply_.sub(_value);
219         emit Burn(_beneficiary, _value);
220         emit Transfer(_beneficiary, address(0), _value);
221     }
222 }
223 
224 library SafeMath {
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) {
227             return 0;
228         }
229         uint256 c = a * b;
230         assert(c / a == b);
231         return c;
232     }
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         uint256 c = a / b;
235         return c;
236     }
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         assert(b <= a);
239         return a - b;
240     }
241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a + b;
243         assert(c >= a);
244         return c;
245     }
246     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
247         if (b>=a) return 0;
248         return a - b;
249     }
250 }
251 
252 contract StandardToken is ERC20, BasicToken {
253 
254     mapping (address => mapping (address => uint256)) internal allowed;
255 
256 
257     /**
258      * @dev Transfer tokens from one address to another
259      * @param _from address The address which you want to send tokens from
260      * @param _to address The address which you want to transfer to
261      * @param _value uint256 the amount of tokens to be transferred
262      */
263     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
264         require(_to != address(0));
265         require(_value <= balances[_from]);
266         require(_value <= allowed[_from][msg.sender]);
267 
268         balances[_from] = balances[_from].sub(_value);
269         balances[_to] = balances[_to].add(_value);
270         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271         emit Transfer(_from, _to, _value);
272         return true;
273     }
274 
275     /**
276      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277      *
278      * Beware that changing an allowance with this method brings the risk that someone may use both the old
279      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282      * @param _spender The address which will spend the funds.
283      * @param _value The amount of tokens to be spent.
284      */
285     function approve(address _spender, uint256 _value) public returns (bool) {
286         allowed[msg.sender][_spender] = _value;
287         emit Approval(msg.sender, _spender, _value);
288         return true;
289     }
290 
291     /**
292      * @dev Function to check the amount of tokens that an owner allowed to a spender.
293      * @param _owner address The address which owns the funds.
294      * @param _spender address The address which will spend the funds.
295      * @return A uint256 specifying the amount of tokens still available for the spender.
296      */
297     function allowance(address _owner, address _spender) public view returns (uint256) {
298         return allowed[_owner][_spender];
299     }
300 
301     /**
302      * @dev Increase the amount of tokens that an owner allowed to a spender.
303      *
304      * approve should be called when allowed[_spender] == 0. To increment
305      * allowed value is better to use this function to avoid 2 calls (and wait until
306      * the first transaction is mined)
307      * From MonolithDAO Token.sol
308      * @param _spender The address which will spend the funds.
309      * @param _addedValue The amount of tokens to increase the allowance by.
310      */
311     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
312         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
313         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314         return true;
315     }
316 
317     /**
318      * @dev Decrease the amount of tokens that an owner allowed to a spender.
319      *
320      * approve should be called when allowed[_spender] == 0. To decrement
321      * allowed value is better to use this function to avoid 2 calls (and wait until
322      * the first transaction is mined)
323      * From MonolithDAO Token.sol
324      * @param _spender The address which will spend the funds.
325      * @param _subtractedValue The amount of tokens to decrease the allowance by.
326      */
327     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
328         uint oldValue = allowed[msg.sender][_spender];
329         if (_subtractedValue > oldValue) {
330             allowed[msg.sender][_spender] = 0;
331         } else {
332             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333         }
334         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335         return true;
336     }
337 
338 }
339 
340 contract MintableToken is StandardToken, GuidedByRoles {
341     event Mint(address indexed to, uint256 amount);
342     event MintFinished();
343 
344     /**
345      * @dev Function to mint tokens
346      * @param _to The address that will receive the minted tokens.
347      * @param _amount The amount of tokens to mint.
348      * @return A boolean that indicates if the operation was successful.
349      */
350     function mint(address _to, uint256 _amount) public returns (bool) {
351         require(rightAndRoles.onlyRoles(msg.sender,1));
352         totalSupply_ = totalSupply_.add(_amount);
353         balances[_to] = balances[_to].add(_amount);
354         emit Mint(_to, _amount);
355         emit Transfer(address(0), _to, _amount);
356         return true;
357     }
358 }
359 
360 contract IToken{
361     function setUnpausedWallet(address _wallet, bool mode) public;
362     function mint(address _to, uint256 _amount) public returns (bool);
363     function totalSupply() public view returns (uint256);
364     function setPause(bool mode) public;
365     function setMigrationAgent(address _migrationAgent) public;
366     function migrateAll(address[] _holders) public;
367     function burn(address _beneficiary, uint256 _value) public;
368     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
369     function defrostDate(address _beneficiary) public view returns (uint256 Date);
370     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
371 }
372 
373 contract IAllocation {
374     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
375 }
376 
377 contract PausableToken is StandardToken, Pausable {
378 
379     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
380         return super.transfer(_to, _value);
381     }
382 
383     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
384         return super.transferFrom(_from, _to, _value);
385     }
386 }
387 
388 contract FreezingToken is PausableToken {
389     struct freeze {
390     uint256 amount;
391     uint256 when;
392     }
393 
394 
395     mapping (address => freeze) freezedTokens;
396 
397     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
398         freeze storage _freeze = freezedTokens[_beneficiary];
399         if(_freeze.when < now) return 0;
400         return _freeze.amount;
401     }
402 
403     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
404         freeze storage _freeze = freezedTokens[_beneficiary];
405         if(_freeze.when < now) return 0;
406         return _freeze.when;
407     }
408 
409     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {
410         require(rightAndRoles.onlyRoles(msg.sender,1));
411         freeze storage _freeze = freezedTokens[_beneficiary];
412         _freeze.amount = _amount;
413         _freeze.when = _when;
414     }
415 
416     function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {
417         onlyAdmin();
418         require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);
419         for(uint16 i = 0; i < _beneficiary.length; i++){
420             freeze storage _freeze = freezedTokens[_beneficiary[i]];
421             _freeze.amount = _amount[i];
422             _freeze.when = _when[i];
423         }
424     }
425 
426 
427     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
428         require(unpausedWallet[msg.sender]);
429         require(freezedTokenOf(_to) == 0);
430         if(_when > 0){
431             freeze storage _freeze = freezedTokens[_to];
432             _freeze.amount = _value;
433             _freeze.when = _when;
434         }
435         transfer(_to,_value);
436     }
437 
438     function transfer(address _to, uint256 _value) public returns (bool) {
439         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
440         return super.transfer(_to,_value);
441     }
442 
443     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
444         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
445         return super.transferFrom( _from,_to,_value);
446     }
447 }
448 
449 contract Token is IToken, FreezingToken, MintableToken, MigratableToken, BurnableToken{
450     function Token(ICreator _creator) GuidedByRoles(_creator.rightAndRoles()) public {}
451     string public constant name = "Imigize";
452     string public constant symbol = "IMGZ";
453     uint8 public constant decimals = 18;
454 }