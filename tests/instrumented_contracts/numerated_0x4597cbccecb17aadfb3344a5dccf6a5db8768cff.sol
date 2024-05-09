1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // ERC Token Standard #20 Interface
52 // ----------------------------------------------------------------------------
53 contract ERC20Interface {
54     function totalSupply() public constant returns (uint);
55     function balanceOf(address tokenOwner) public constant returns (uint balance);
56     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
57     function transfer(address to, uint tokens) public returns (bool success);
58     function approve(address spender, uint tokens) public returns (bool success);
59     function transferFrom(address from, address to, uint tokens) public returns (bool success);
60 
61     event Transfer(address indexed from, address indexed to, uint tokens);
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Contract function to receive approval and execute function in one call
68 //
69 // Borrowed from MiniMeToken
70 // ----------------------------------------------------------------------------
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // Owned contract
78 // ----------------------------------------------------------------------------
79 contract Owned {
80     address public owner;
81     address public newOwner;
82 
83     event OwnershipTransferred(address indexed _from, address indexed _to);
84 
85     function Owned() public {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     function transferOwnership(address _newOwner) public onlyOwner {
95         newOwner = _newOwner;
96     }
97     function acceptOwnership() public {
98         require(msg.sender == newOwner);
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 }
104 
105 /**
106  * @title Pausable
107  * @dev Base contract which allows children to implement an emergency stop mechanism.
108  */
109 contract Pausable is Owned {
110     event Pause();
111     event Unpause();
112 
113     bool public paused = false;
114 
115     /**
116     * @dev Modifier to make a function callable only when the contract is not paused.
117     */
118     modifier whenNotPaused() {
119         require(!paused);
120         _;
121     }
122 
123     /**
124     * @dev Modifier to make a function callable only when the contract is paused.
125     */
126     modifier whenPaused() {
127         require(paused);
128         _;
129     }
130 
131     /**
132     * @dev called by the owner to pause, triggers stopped state
133     */
134     function pause() public onlyOwner whenNotPaused {
135         paused = true;
136         emit Pause();
137     }
138 
139     /**
140     * @dev called by the owner to unpause, returns to normal state
141     */
142     function unpause() public onlyOwner whenPaused {
143         paused = false;
144         emit Unpause();
145     }
146 }
147 
148 // ----------------------------------------------------------------------------
149 // ERC20 Token, with the addition of symbol, name and decimals and an
150 // initial fixed supply
151 // ----------------------------------------------------------------------------
152 contract PonyToken is ERC20Interface, Pausable {
153     using SafeMath for uint;
154     string public symbol;
155     string public  name;
156     uint8 public decimals;
157     uint public _totalSupply;
158     uint public _currentSupply;
159     mapping(address => bool) _protect;
160     mapping(address => uint) balances;
161     mapping(address => mapping(address => uint)) allowed;
162     event Burn(address indexed burner, uint256 value);
163     
164     
165     /** ------------------------------------------------------------------------
166      * Constructor
167      * ------------------------------------------------------------------------
168     */ 
169     function PonyToken() public {
170         symbol = "Pony";
171         name = "Platform of Open Nodes Integrated";
172         decimals = 18;
173         _totalSupply = 1000000000 * 10**uint256(decimals);
174         emit Transfer(address(0), owner, _totalSupply);
175     }
176 
177     // check user in protect
178     modifier whenNotInProtect(){
179         require(_protect[msg.sender] == false);
180         _;
181     }
182 
183     // protect account
184     function accountProtect(address _account) public onlyOwner{
185         require(_account != 0);
186         _protect[_account] = true;
187     }
188 
189     // unprotect account
190     function accountUnProtect(address _account) public onlyOwner{
191         require(_account != 0);
192         _protect[_account] = false;
193     }
194 
195     /**
196     * @dev Burns a specific amount of tokens.
197     * @param _value The amount of token to be burned.
198     */
199     function burn(uint256 _value) public whenNotInProtect{
200         _burn(msg.sender, _value);
201     }
202 
203     /**
204     * @dev Internal function that burns an amount of the token of a given
205     * account.
206     * @param _account The account whose tokens will be burnt.
207     * @param _amount The amount that will be burnt.
208     */
209     function _burn(address _account, uint256 _amount) internal {
210         require(_account != 0);
211         require(_amount <= balances[_account]);
212         require(_totalSupply > _amount);
213         _totalSupply = _totalSupply.sub(_amount);
214         balances[_account] = balances[_account].sub(_amount);
215         emit Transfer(_account, address(0), _amount);
216         emit Burn(_account, _amount);
217     }
218 
219     /**
220     * @dev Burns a specific amount of tokens from the target address and decrements allowance
221     * @param _from address The address which you want to send tokens from
222     * @param _value uint256 The amount of token to be burned
223     */
224     function burnFrom(address _from, uint256 _value) public {
225         _burnFrom(_from, _value);
226     }
227 
228 
229     /**
230     * @dev Internal function that burns an amount of the token of a given
231     * account, deducting from the sender's allowance for said account. Uses the
232     * internal _burn function.
233     * @param _account The account whose tokens will be burnt.
234     * @param _amount The amount that will be burnt.
235     */
236     function _burnFrom(address _account, uint256 _amount) internal {
237         require(_amount <= allowed[_account][msg.sender]);
238 
239         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
240         _burn(_account, _amount);
241     }
242 
243 
244     // ------------------------------------------------------------------------
245     // Total supply
246     // ------------------------------------------------------------------------
247     function totalSupply() public constant returns (uint) {
248         return _totalSupply;
249     }
250 
251     // ------------------------------------------------------------------------
252     // Current supply
253     // ------------------------------------------------------------------------
254     function currentSupply() public constant returns (uint) {
255         return _currentSupply;
256     }
257 
258 
259     // ------------------------------------------------------------------------
260     // Get the token balance for account `tokenOwner`
261     // ------------------------------------------------------------------------
262     function balanceOf(address tokenOwner) public constant returns (uint balance) {
263         return balances[tokenOwner];
264     }
265 
266     // ------------------------------------------------------------------------
267     // Transfer the balance from token owner's account to `to` account
268     // - Owner's account must have sufficient balance to transfer
269     // - 0 value transfers are allowed
270     // ------------------------------------------------------------------------
271     function transfer(address to, uint tokens) public whenNotPaused whenNotInProtect returns (bool success) {
272         balances[msg.sender] = balances[msg.sender].sub(tokens);
273         balances[to] = balances[to].add(tokens);
274         emit Transfer(msg.sender, to, tokens);
275         return true;
276     }
277 
278 
279     // ------------------------------------------------------------------------
280     // Token owner can approve for `spender` to transferFrom(...) `tokens`
281     // from the token owner's account
282     //
283     // recommends that there are no checks for the approval double-spend attack
284     // as this should be implemented in user interfaces 
285     // ------------------------------------------------------------------------
286     function approve(address spender, uint tokens) public whenNotPaused whenNotInProtect returns (bool success) {
287         allowed[msg.sender][spender] = tokens;
288         emit Approval(msg.sender, spender, tokens);
289         return true;
290     }
291 
292 
293     // ------------------------------------------------------------------------
294     // Transfer `tokens` from the `from` account to the `to` account
295     // 
296     // The calling account must already have sufficient tokens approve(...)-d
297     // for spending from the `from` account and
298     // - From account must have sufficient balance to transfer
299     // - Spender must have sufficient allowance to transfer
300     // - 0 value transfers are allowed
301     // ------------------------------------------------------------------------
302     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
303         balances[from] = balances[from].sub(tokens);
304         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
305         balances[to] = balances[to].add(tokens);
306         emit Transfer(from, to, tokens);
307         return true;
308     }
309 
310 
311     // ------------------------------------------------------------------------
312     // Returns the amount of tokens approved by the owner that can be
313     // transferred to the spender's account
314     // ------------------------------------------------------------------------
315     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
316         return allowed[tokenOwner][spender];
317     }
318 
319 
320     // ------------------------------------------------------------------------
321     // Token owner can approve for `spender` to transferFrom(...) `tokens`
322     // from the token owner's account. The `spender` contract function
323     // `receiveApproval(...)` is then executed
324     // ------------------------------------------------------------------------
325     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
326         allowed[msg.sender][spender] = tokens;
327         emit Approval(msg.sender, spender, tokens);
328         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
329         return true;
330     }
331 
332 
333     // ------------------------------------------------------------------------
334     // Don't accept ETH
335     // ------------------------------------------------------------------------
336     function () public payable {
337         revert();
338     }
339 
340 
341     // @dev increase GDB's current supply
342     function increaseSupply (uint256 _value, address _to) onlyOwner whenNotPaused external {
343         require(_value + _currentSupply < _totalSupply);
344         _currentSupply = _currentSupply.add(_value);
345         balances[_to] = balances[_to].add(_value);
346         emit Transfer(address(0x0), _to, _value);
347     }
348 
349     /**
350      * Transfer `tokens` from the `msg.sender` account to the `_receivers` accounts
351      */
352     function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused whenNotInProtect returns (uint256) {
353         uint cnt = _receivers.length;
354         uint256 amount = uint256(cnt) .mul(_value);
355         
356         require(cnt > 0 && cnt <= 20);
357         require(_value > 0 && balances[msg.sender] >= amount);
358         require(amount >= _value);
359 
360         balances[msg.sender] = balances[msg.sender].sub(amount);
361 
362         for (uint i = 0; i < cnt; i++) {
363             balances[_receivers[i]] = balances[_receivers[i]].add(_value);
364         }
365         emit Transfer(msg.sender, address(0), amount);    
366         return amount;
367     }
368     
369 }
370 
371 
372 contract TokenTimelock {
373     ERC20Interface public token;
374     // beneficiary of tokens after they are released
375     address public beneficiary;
376 
377     // timestamp when token release is enabled
378     uint256 public releaseTime;
379 
380     constructor(ERC20Interface _token, address _beneficiary, uint256 _releaseTime) public
381     {
382         // solium-disable-next-line security/no-block-members
383         require(_releaseTime > block.timestamp);
384         token = _token;
385         beneficiary = _beneficiary;
386         releaseTime = _releaseTime;
387     }
388 
389     /**
390     * @notice Transfers tokens held by timelock to beneficiary.
391     */
392     function release() public {
393         // solium-disable-next-line security/no-block-members
394         require(block.timestamp >= releaseTime);
395 
396         uint256 amount = token.balanceOf(address(this));
397         require(amount > 0);
398 
399         token.transfer(beneficiary, amount);
400     }
401 }