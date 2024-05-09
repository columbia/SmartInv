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
239 contract AnkhTokenDistributor is Ownable {
240     AnkhToken public token;
241 
242     mapping(uint32 => bool) public processedTransactions;
243 
244     constructor(AnkhToken _token) public {
245         token = _token == address(0x0) ? new AnkhToken() : _token;
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
264 contract AnkhTokenSender is AnkhTokenDistributor {
265     constructor(AnkhToken _token) AnkhTokenDistributor(_token) public { }
266 
267     function bulkTransfer(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts)
268         external onlyOwner validateInput(_payment_ids, _receivers, _amounts) {
269 
270         for (uint i = 0; i < _receivers.length; i++) {
271             if (!processedTransactions[_payment_ids[i]]) {
272                 processedTransactions[_payment_ids[i]] = true;
273 
274                 token.transfer(_receivers[i], _amounts[i]);
275             }
276         }
277     }
278 
279     function bulkTransferFrom(uint32[] _payment_ids, address _from, address[] _receivers, uint256[] _amounts)
280         external onlyOwner validateInput(_payment_ids, _receivers, _amounts) {
281 
282         for (uint i = 0; i < _receivers.length; i++) {
283             if (!processedTransactions[_payment_ids[i]]) {
284                 processedTransactions[_payment_ids[i]] = true;
285 
286                 token.transferFrom(_from, _receivers[i], _amounts[i]);
287             }
288         }
289     }
290 
291     function transferTokensToOwner() external onlyOwner {
292         token.transfer(owner, token.balanceOf(address(this)));
293     }
294 }
295 
296 contract MintableToken is StandardToken, Ownable {
297     event Mint(address indexed to, uint256 amount);
298     event MintFinished();
299 
300     bool public mintingFinished = false;
301 
302 
303     modifier canMint() {
304         require(!mintingFinished);
305 
306         _;
307     }
308 
309     /**
310     * @dev Function to mint tokens
311     * @param _to The address that will receive the minted tokens.
312     * @param _amount The amount of tokens to mint.
313     * @return A boolean that indicates if the operation was successful.
314     */
315     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
316         totalSupply_ = totalSupply_ + _amount;
317         balances[_to] = balances[_to] + _amount;
318 
319         emit Mint(_to, _amount);
320         emit Transfer(address(0), _to, _amount);
321 
322         return true;
323     }
324 
325     /**
326     * @dev Function to stop minting new tokens.
327     * @return True if the operation was successful.
328     */
329     function finishMinting() onlyOwner canMint public returns (bool) {
330         mintingFinished = true;
331         emit MintFinished();
332 
333         return true;
334     }
335 }
336 
337 contract CappedToken is MintableToken {
338 
339     uint256 public cap;
340 
341     constructor(uint256 _cap) public {
342         require(_cap > 0);
343 
344         cap = _cap;
345     }
346 
347     /**
348     * @dev Function to mint tokens
349     * @param _to The address that will receive the minted tokens.
350     * @param _amount The amount of tokens to mint.
351     * @return A boolean that indicates if the operation was successful.
352     */
353     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
354         require(totalSupply_ + _amount <= cap);
355         require(totalSupply_ + _amount >= totalSupply_);
356 
357         return super.mint(_to, _amount);
358     }
359 }
360 
361 contract Pausable is Ownable {
362     event Pause();
363     event Unpause();
364 
365     bool public paused = false;
366 
367 
368     /**
369     * @dev Modifier to make a function callable only when the contract is not paused.
370     */
371     modifier whenNotPaused() {
372         require(!paused || msg.sender == owner);
373 
374         _;
375     }
376 
377     /**
378     * @dev Modifier to make a function callable only when the contract is paused.
379     */
380     modifier whenPaused() {
381         require(paused || msg.sender == owner);
382 
383         _;
384     }
385 
386     /**
387     * @dev called by the owner to pause, triggers stopped state
388     */
389     function pause() onlyOwner whenNotPaused public {
390         paused = true;
391 
392         emit Pause();
393     }
394 
395     /**
396     * @dev called by the owner to unpause, returns to normal state
397     */
398     function unpause() onlyOwner whenPaused public {
399         paused = false;
400 
401         emit Unpause();
402     }
403 }
404 
405 contract PausableToken is StandardToken, Pausable {
406 
407     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
408         return super.transfer(_to, _value);
409     }
410 
411     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
412         return super.transferFrom(_from, _to, _value);
413     }
414 
415     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
416         return super.approve(_spender, _value);
417     }
418 
419     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
420         return super.increaseApproval(_spender, _addedValue);
421     }
422 
423     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
424         return super.decreaseApproval(_spender, _subtractedValue);
425     }
426 }
427 
428 contract AnkhToken is StandardBurnableToken, CappedToken, DetailedERC20, PausableToken  {
429     constructor() CappedToken(65*10**25) DetailedERC20("BeANKH token", "ANKH", 18) public {
430     }
431 }