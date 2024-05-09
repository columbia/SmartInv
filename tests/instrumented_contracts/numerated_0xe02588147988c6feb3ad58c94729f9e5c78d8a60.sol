1 // Project: AleHub
2 // v1, 2018-05-24
3 // This code is the property of CryptoB2B.io
4 // Copying in whole or in part is prohibited.
5 // Authors: Ivan Fedorov and Dmitry Borodin
6 // Do you want the same TokenSale platform? www.cryptob2b.io
7 
8 // *.sol in 1 file - https://cryptob2b.io/solidity/alehub/
9 
10 pragma solidity ^0.4.21;
11 
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a / b;
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (b>=a) return 0;
36         return a - b;
37     }
38 }
39 
40 contract MigrationAgent
41 {
42     function migrateFrom(address _from, uint256 _value) public;
43 }
44 
45 contract IRightAndRoles {
46     address[][] public wallets;
47     mapping(address => uint16) public roles;
48 
49     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
50     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
51 
52     function changeWallet(address _wallet, uint8 _role) external;
53     function setManagerPowerful(bool _mode) external;
54     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
55 }
56 
57 contract GuidedByRoles {
58     IRightAndRoles public rightAndRoles;
59     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
60         rightAndRoles = _rightAndRoles;
61     }
62 }
63 
64 contract Pausable is GuidedByRoles {
65 
66     mapping (address => bool) public unpausedWallet;
67 
68     event Pause();
69     event Unpause();
70 
71     bool public paused = true;
72 
73 
74     /**
75      * @dev Modifier to make a function callable only when the contract is not paused.
76      */
77     modifier whenNotPaused(address _to) {
78         require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
79         _;
80     }
81 
82     function onlyAdmin() internal view {
83         require(rightAndRoles.onlyRoles(msg.sender,3));
84     }
85 
86     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
87     function setUnpausedWallet(address _wallet, bool mode) public {
88         onlyAdmin();
89         unpausedWallet[_wallet] = mode;
90     }
91 
92     /**
93      * @dev called by the owner to pause, triggers stopped state
94      */
95     function setPause(bool mode)  public {
96         require(rightAndRoles.onlyRoles(msg.sender,1));
97         if (!paused && mode) {
98             paused = true;
99             emit Pause();
100         }else
101         if (paused && !mode) {
102             paused = false;
103             emit Unpause();
104         }
105     }
106 
107 }
108 
109 contract ERC20Basic {
110     function totalSupply() public view returns (uint256);
111     function balanceOf(address who) public view returns (uint256);
112     function transfer(address to, uint256 value) public returns (bool);
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 contract BasicToken is ERC20Basic {
117     using SafeMath for uint256;
118 
119     mapping(address => uint256) balances;
120 
121     uint256 totalSupply_;
122 
123     /**
124     * @dev total number of tokens in existence
125     */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129 
130     /**
131     * @dev transfer token for a specified address
132     * @param _to The address to transfer to.
133     * @param _value The amount to be transferred.
134     */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138 
139         // SafeMath.sub will throw if there is not enough balance.
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         emit Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     /**
147     * @dev Gets the balance of the specified address.
148     * @param _owner The address to query the the balance of.
149     * @return An uint256 representing the amount owned by the passed address.
150     */
151     function balanceOf(address _owner) public view returns (uint256 balance) {
152         return balances[_owner];
153     }
154 
155 }
156 
157 contract BurnableToken is BasicToken, GuidedByRoles {
158 
159     event Burn(address indexed burner, uint256 value);
160 
161     /**
162      * @dev Burns a specific amount of tokens.
163      * @param _value The amount of token to be burned.
164      */
165     function burn(address _beneficiary, uint256 _value) public {
166         require(rightAndRoles.onlyRoles(msg.sender,1));
167         require(_value <= balances[_beneficiary]);
168         // no need to require value <= totalSupply, since that would imply the
169         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
170 
171         balances[_beneficiary] = balances[_beneficiary].sub(_value);
172         totalSupply_ = totalSupply_.sub(_value);
173         emit Burn(_beneficiary, _value);
174         emit Transfer(_beneficiary, address(0), _value);
175     }
176 }
177 
178 contract ERC20 is ERC20Basic {
179     function allowance(address owner, address spender) public view returns (uint256);
180     function transferFrom(address from, address to, uint256 value) public returns (bool);
181     function approve(address spender, uint256 value) public returns (bool);
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 contract StandardToken is ERC20, BasicToken {
186 
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190     /**
191      * @dev Transfer tokens from one address to another
192      * @param _from address The address which you want to send tokens from
193      * @param _to address The address which you want to transfer to
194      * @param _value uint256 the amount of tokens to be transferred
195      */
196     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197         require(_to != address(0));
198         require(_value <= balances[_from]);
199         require(_value <= allowed[_from][msg.sender]);
200 
201         balances[_from] = balances[_from].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210      *
211      * Beware that changing an allowance with this method brings the risk that someone may use both the old
212      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      * @param _spender The address which will spend the funds.
216      * @param _value The amount of tokens to be spent.
217      */
218     function approve(address _spender, uint256 _value) public returns (bool) {
219         allowed[msg.sender][_spender] = _value;
220         emit Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     /**
225      * @dev Function to check the amount of tokens that an owner allowed to a spender.
226      * @param _owner address The address which owns the funds.
227      * @param _spender address The address which will spend the funds.
228      * @return A uint256 specifying the amount of tokens still available for the spender.
229      */
230     function allowance(address _owner, address _spender) public view returns (uint256) {
231         return allowed[_owner][_spender];
232     }
233 
234     /**
235      * @dev Increase the amount of tokens that an owner allowed to a spender.
236      *
237      * approve should be called when allowed[_spender] == 0. To increment
238      * allowed value is better to use this function to avoid 2 calls (and wait until
239      * the first transaction is mined)
240      * From MonolithDAO Token.sol
241      * @param _spender The address which will spend the funds.
242      * @param _addedValue The amount of tokens to increase the allowance by.
243      */
244     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249 
250     /**
251      * @dev Decrease the amount of tokens that an owner allowed to a spender.
252      *
253      * approve should be called when allowed[_spender] == 0. To decrement
254      * allowed value is better to use this function to avoid 2 calls (and wait until
255      * the first transaction is mined)
256      * From MonolithDAO Token.sol
257      * @param _spender The address which will spend the funds.
258      * @param _subtractedValue The amount of tokens to decrease the allowance by.
259      */
260     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261         uint oldValue = allowed[msg.sender][_spender];
262         if (_subtractedValue > oldValue) {
263             allowed[msg.sender][_spender] = 0;
264         } else {
265             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266         }
267         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268         return true;
269     }
270 
271 }
272 
273 contract PausableToken is StandardToken, Pausable {
274 
275     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
276         return super.transfer(_to, _value);
277     }
278 
279     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
280         return super.transferFrom(_from, _to, _value);
281     }
282 }
283 
284 contract FreezingToken is PausableToken {
285     struct freeze {
286     uint256 amount;
287     uint256 when;
288     }
289 
290 
291     mapping (address => freeze) freezedTokens;
292 
293     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
294         freeze storage _freeze = freezedTokens[_beneficiary];
295         if(_freeze.when < now) return 0;
296         return _freeze.amount;
297     }
298 
299     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
300         freeze storage _freeze = freezedTokens[_beneficiary];
301         if(_freeze.when < now) return 0;
302         return _freeze.when;
303     }
304 
305     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {
306         require(rightAndRoles.onlyRoles(msg.sender,1));
307         freeze storage _freeze = freezedTokens[_beneficiary];
308         _freeze.amount = _amount;
309         _freeze.when = _when;
310     }
311 
312     function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {
313         onlyAdmin();
314         require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);
315         for(uint16 i = 0; i < _beneficiary.length; i++){
316             freeze storage _freeze = freezedTokens[_beneficiary[i]];
317             _freeze.amount = _amount[i];
318             _freeze.when = _when[i];
319         }
320     }
321 
322 
323     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
324         require(unpausedWallet[msg.sender]);
325         require(freezedTokenOf(_to) == 0);
326         if(_when > 0){
327             freeze storage _freeze = freezedTokens[_to];
328             _freeze.amount = _value;
329             _freeze.when = _when;
330         }
331         transfer(_to,_value);
332     }
333 
334     function transfer(address _to, uint256 _value) public returns (bool) {
335         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
336         return super.transfer(_to,_value);
337     }
338 
339     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
340         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
341         return super.transferFrom( _from,_to,_value);
342     }
343 }
344 
345 contract MigratableToken is BasicToken,GuidedByRoles {
346 
347     uint256 public totalMigrated;
348     address public migrationAgent;
349 
350     event Migrate(address indexed _from, address indexed _to, uint256 _value);
351 
352     function setMigrationAgent(address _migrationAgent) public {
353         require(rightAndRoles.onlyRoles(msg.sender,1));
354         require(totalMigrated == 0);
355         migrationAgent = _migrationAgent;
356     }
357 
358 
359     function migrateInternal(address _holder) internal{
360         require(migrationAgent != 0x0);
361 
362         uint256 value = balances[_holder];
363         balances[_holder] = 0;
364 
365         totalSupply_ = totalSupply_.sub(value);
366         totalMigrated = totalMigrated.add(value);
367 
368         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
369         emit Migrate(_holder,migrationAgent,value);
370     }
371 
372     function migrateAll(address[] _holders) public {
373         require(rightAndRoles.onlyRoles(msg.sender,1));
374         for(uint i = 0; i < _holders.length; i++){
375             migrateInternal(_holders[i]);
376         }
377     }
378 
379     // Reissue your tokens.
380     function migrate() public
381     {
382         require(balances[msg.sender] > 0);
383         migrateInternal(msg.sender);
384     }
385 
386 }
387 
388 contract IToken{
389     function setUnpausedWallet(address _wallet, bool mode) public;
390     function mint(address _to, uint256 _amount) public returns (bool);
391     function totalSupply() public view returns (uint256);
392     function setPause(bool mode) public;
393     function setMigrationAgent(address _migrationAgent) public;
394     function migrateAll(address[] _holders) public;
395     function burn(address _beneficiary, uint256 _value) public;
396     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
397     function defrostDate(address _beneficiary) public view returns (uint256 Date);
398     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
399 }
400 
401 contract MintableToken is StandardToken, GuidedByRoles {
402     event Mint(address indexed to, uint256 amount);
403     event MintFinished();
404 
405     /**
406      * @dev Function to mint tokens
407      * @param _to The address that will receive the minted tokens.
408      * @param _amount The amount of tokens to mint.
409      * @return A boolean that indicates if the operation was successful.
410      */
411     function mint(address _to, uint256 _amount) public returns (bool) {
412         require(rightAndRoles.onlyRoles(msg.sender,1));
413         totalSupply_ = totalSupply_.add(_amount);
414         balances[_to] = balances[_to].add(_amount);
415         emit Mint(_to, _amount);
416         emit Transfer(address(0), _to, _amount);
417         return true;
418     }
419 }
420 
421 contract Token is IToken, FreezingToken, MintableToken, MigratableToken, BurnableToken{
422     function Token(IRightAndRoles _rightAndRoles) GuidedByRoles(_rightAndRoles) public {}
423     string public constant name = "Ale Coin";
424     string public constant symbol = "ALE";
425     uint8 public constant decimals = 18;
426 }