1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11 
12     mapping(address => uint256) balances;
13 
14     uint256 totalSupply_;
15 
16     /**
17     * @dev total number of tokens in existence
18     */
19     function totalSupply() public view returns (uint256) {
20         return totalSupply_;
21     }
22 
23     /**
24     * @dev transfer token for a specified address
25     * @param _to The address to transfer to.
26     * @param _value The amount to be transferred.
27     */
28     function transfer(address _to, uint256 _value) public returns (bool) {
29         require(_to != address(0));
30         require(_value <= balances[msg.sender]);
31 
32         balances[msg.sender] = balances[msg.sender] - _value;
33         balances[_to] = balances[_to] + _value;
34         emit Transfer(msg.sender, _to, _value);
35         return true;
36     }
37 
38     /**
39     * @dev Gets the balance of the specified address.
40     * @param _owner The address to query the the balance of.
41     * @return An uint256 representing the amount owned by the passed address.
42     */
43     function balanceOf(address _owner) public view returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47 }
48 
49 contract BurnableToken is BasicToken {
50 
51     event Burn(address indexed burner, uint256 value);
52 
53     /**
54     * @dev Burns a specific amount of tokens.
55     * @param _value The amount of token to be burned.
56     */
57     function burn(uint256 _value) public {
58         _burn(msg.sender, _value);
59     }
60 
61     function _burn(address _who, uint256 _value) internal {
62         require(_value <= balances[_who]);
63         // no need to require value <= totalSupply, since that would imply the
64         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
65 
66         balances[_who] = balances[_who] - _value;
67         totalSupply_ = totalSupply_ - _value;
68         emit Burn(_who, _value);
69         emit Transfer(_who, address(0), _value);
70     }
71 }
72 
73 contract ERC20 is ERC20Basic {
74     function allowance(address owner, address spender) public view returns (uint256);
75     function transferFrom(address from, address to, uint256 value) public returns (bool);
76     function approve(address spender, uint256 value) public returns (bool);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 contract DetailedERC20 is ERC20 {
81     string public name;
82     string public symbol;
83     uint8 public decimals;
84 
85     constructor (string _name, string _symbol, uint8 _decimals) public {
86         name = _name;
87         symbol = _symbol;
88         decimals = _decimals;
89     }
90 }
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94     mapping (address => mapping (address => uint256)) internal allowed;
95 
96 
97     /**
98     * @dev Transfer tokens from one address to another
99     * @param _from address The address which you want to send tokens from
100     * @param _to address The address which you want to transfer to
101     * @param _value uint256 the amount of tokens to be transferred
102     */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[_from]);
106         require(_value <= allowed[_from][msg.sender]);
107 
108         balances[_from] = balances[_from] - _value;
109         balances[_to] = balances[_to] + _value;
110         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
111         emit Transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
117     *
118     * Beware that changing an allowance with this method brings the risk that someone may use both the old
119     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
120     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
121     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     * @param _spender The address which will spend the funds.
123     * @param _value The amount of tokens to be spent.
124     */
125     function approve(address _spender, uint256 _value) public returns (bool) {
126         allowed[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128 
129         return true;
130     }
131 
132     /**
133     * @dev Function to check the amount of tokens that an owner allowed to a spender.
134     * @param _owner address The address which owns the funds.
135     * @param _spender address The address which will spend the funds.
136     * @return A uint256 specifying the amount of tokens still available for the spender.
137     */
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139         return allowed[_owner][_spender];
140     }
141 
142     /**
143     * @dev Increase the amount of tokens that an owner allowed to a spender.
144     *
145     * approve should be called when allowed[_spender] == 0. To increment
146     * allowed value is better to use this function to avoid 2 calls (and wait until
147     * the first transaction is mined)
148     * From MonolithDAO Token.sol
149     * @param _spender The address which will spend the funds.
150     * @param _addedValue The amount of tokens to increase the allowance by.
151     */
152     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
153         uint allowanceBefore = allowed[msg.sender][_spender];
154         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
155         assert(allowanceBefore <= allowed[msg.sender][_spender]);
156 
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158 
159         return true;
160     }
161 
162     /**
163     * @dev Decrease the amount of tokens that an owner allowed to a spender.
164     *
165     * approve should be called when allowed[_spender] == 0. To decrement
166     * allowed value is better to use this function to avoid 2 calls (and wait until
167     * the first transaction is mined)
168     * From MonolithDAO Token.sol
169     * @param _spender The address which will spend the funds.
170     * @param _subtractedValue The amount of tokens to decrease the allowance by.
171     */
172     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173         uint oldValue = allowed[msg.sender][_spender];
174         if (_subtractedValue >= oldValue) {
175             allowed[msg.sender][_spender] = 0;
176         } else {
177             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
178         }
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180 
181         return true;
182     }
183 
184 }
185 
186 contract StandardBurnableToken is BurnableToken, StandardToken {
187 
188     /**
189     * @dev Burns a specific amount of tokens from the target address and decrements allowance
190     * @param _from address The address which you want to send tokens from
191     * @param _value uint256 The amount of token to be burned
192     */
193     function burnFrom(address _from, uint256 _value) public {
194         require(_value <= allowed[_from][msg.sender]);
195         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
196         // this function needs to emit an event with the updated approval.
197         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
198         _burn(_from, _value);
199     }
200 }
201 
202 contract Ownable {
203     address public owner;
204 
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208 
209     /**
210     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
211     * account.
212     */
213     constructor() public {
214         owner = msg.sender;
215     }
216 
217     /**
218     * @dev Throws if called by any account other than the owner.
219     */
220     modifier onlyOwner() {
221         require(msg.sender == owner);
222 
223         _;
224     }
225 
226     /**
227     * @dev Allows the current owner to transfer control of the contract to a newOwner.
228     * @param newOwner The address to transfer ownership to.
229     */
230     function transferOwnership(address newOwner) public onlyOwner {
231         require(newOwner != address(0));
232 
233         emit OwnershipTransferred(owner, newOwner);
234         owner = newOwner;
235     }
236 
237 }
238 
239 contract SoundeonTokenDistributor is Ownable {
240     SoundeonToken public token;
241 
242     mapping(uint32 => bool) public processedTransactions;
243 
244     constructor(SoundeonToken _token) public {
245         token = _token == address(0x0) ? new SoundeonToken() : _token;
246     }
247 
248     function isTransactionSuccessful(uint32 id) external view returns (bool) {
249         return processedTransactions[id];
250     }
251 
252     modifier validateInput(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts) {
253         require(_receivers.length == _amounts.length);
254         require(_receivers.length == _payment_ids.length);
255 
256         _;
257     }
258 
259     function transferTokenOwnership() external onlyOwner {
260         token.transferOwnership(owner);
261     }
262 }
263 
264 contract SoundeonTokenMinter is SoundeonTokenDistributor {
265     address public reserveFundAddress = 0x5C7F38190c1E14aDB8c421886B196e7072B6356E;
266     address public artistManifestoFundAddress = 0xC94BBB49E139EAbA8Dc4EA8b0ae5066f9DFEEcEf;
267     address public bountyPoolAddress = 0x252a30D338E9dfd30042CEfA8bbd6C3CaF040443;
268     address public earlyBackersPoolAddress = 0x07478916c9effbc95b7D6C8F99E52B0fcC35a091;
269     address public teamPoolAddress = 0x3B467C1bD8712aA1182eced58a75b755d0314a65;
270     address public advisorsAndAmbassadorsAddress = 0x0e16D22706aB5b1Ec374d31bb3e27d04Cc07f9D8;
271 
272     constructor(SoundeonToken _token) SoundeonTokenDistributor(_token) public { }
273 
274     function bulkMint(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts)
275         external onlyOwner validateInput(_payment_ids, _receivers, _amounts) {
276         uint totalAmount = 0;
277 
278         for (uint i = 0; i < _receivers.length; i++) {
279             require(_receivers[i] != address(0));
280 
281             if (!processedTransactions[_payment_ids[i]]) {
282                 processedTransactions[_payment_ids[i]] = true;
283 
284                 token.mint(_receivers[i], _amounts[i]);
285 
286                 totalAmount += _amounts[i] / 65;
287             }
288         }
289 
290         require(token.mint(reserveFundAddress, totalAmount * 2));
291         require(token.mint(artistManifestoFundAddress, totalAmount * 6));
292         require(token.mint(bountyPoolAddress, totalAmount * 3));
293         require(token.mint(teamPoolAddress, totalAmount * 14));
294         require(token.mint(earlyBackersPoolAddress, totalAmount * 4));
295         require(token.mint(advisorsAndAmbassadorsAddress, totalAmount * 6));
296     }
297 }
298 
299 contract MintableToken is StandardToken, Ownable {
300     event Mint(address indexed to, uint256 amount);
301     event MintFinished();
302 
303     bool public mintingFinished = false;
304 
305 
306     modifier canMint() {
307         require(!mintingFinished);
308 
309         _;
310     }
311 
312     /**
313     * @dev Function to mint tokens
314     * @param _to The address that will receive the minted tokens.
315     * @param _amount The amount of tokens to mint.
316     * @return A boolean that indicates if the operation was successful.
317     */
318     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
319         totalSupply_ = totalSupply_ + _amount;
320         balances[_to] = balances[_to] + _amount;
321 
322         emit Mint(_to, _amount);
323         emit Transfer(address(0), _to, _amount);
324 
325         return true;
326     }
327 
328     /**
329     * @dev Function to stop minting new tokens.
330     * @return True if the operation was successful.
331     */
332     function finishMinting() onlyOwner canMint public returns (bool) {
333         mintingFinished = true;
334         emit MintFinished();
335 
336         return true;
337     }
338 }
339 
340 contract CappedToken is MintableToken {
341 
342     uint256 public cap;
343 
344     constructor(uint256 _cap) public {
345         require(_cap > 0);
346 
347         cap = _cap;
348     }
349 
350     /**
351     * @dev Function to mint tokens
352     * @param _to The address that will receive the minted tokens.
353     * @param _amount The amount of tokens to mint.
354     * @return A boolean that indicates if the operation was successful.
355     */
356     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
357         require(totalSupply_ + _amount <= cap);
358         require(totalSupply_ + _amount >= totalSupply_);
359 
360         return super.mint(_to, _amount);
361     }
362 }
363 
364 contract Pausable is Ownable {
365     event Pause();
366     event Unpause();
367 
368     bool public paused = false;
369 
370 
371     /**
372     * @dev Modifier to make a function callable only when the contract is not paused.
373     */
374     modifier whenNotPaused() {
375         require(!paused || msg.sender == owner);
376 
377         _;
378     }
379 
380     /**
381     * @dev Modifier to make a function callable only when the contract is paused.
382     */
383     modifier whenPaused() {
384         require(paused || msg.sender == owner);
385 
386         _;
387     }
388 
389     /**
390     * @dev called by the owner to pause, triggers stopped state
391     */
392     function pause() onlyOwner whenNotPaused public {
393         paused = true;
394 
395         emit Pause();
396     }
397 
398     /**
399     * @dev called by the owner to unpause, returns to normal state
400     */
401     function unpause() onlyOwner whenPaused public {
402         paused = false;
403 
404         emit Unpause();
405     }
406 }
407 
408 contract PausableToken is StandardToken, Pausable {
409 
410     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
411         return super.transfer(_to, _value);
412     }
413 
414     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
415         return super.transferFrom(_from, _to, _value);
416     }
417 
418     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
419         return super.approve(_spender, _value);
420     }
421 
422     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
423         return super.increaseApproval(_spender, _addedValue);
424     }
425 
426     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
427         return super.decreaseApproval(_spender, _subtractedValue);
428     }
429 }
430 
431 contract SoundeonToken is StandardBurnableToken, CappedToken, DetailedERC20, PausableToken  {
432     constructor() CappedToken(10**27) DetailedERC20("Soundeon Token", "Soundeon", 18) public {
433     }
434 }