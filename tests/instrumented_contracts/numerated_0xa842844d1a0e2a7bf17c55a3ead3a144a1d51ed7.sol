1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner and manager address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10     address public manager;
11 
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16     event ManagerTransfer(address indexed oldaddr, address indexed newaddr);
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22     constructor() public {
23         owner = msg.sender;
24         manager = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     modifier onlyManager() {
36         require(msg.sender == manager);
37         _;
38     }
39     modifier onlyAdmin() {
40         require(msg.sender == owner || msg.sender == manager);
41         _;
42     }
43 
44     /**
45      * @dev Allows the current owner to transfer control of the contract to a newOwner.
46      * @param _newOwner The address to transfer ownership to.
47      */
48     function transferOwnership(address _newOwner) public onlyOwner {
49         _transferOwnership(_newOwner);
50     }
51 
52     function transferManager(address _newManager) onlyAdmin public {
53         require(_newManager != address(0));
54         emit ManagerTransfer(manager, _newManager);
55         manager = _newManager;
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param _newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address _newOwner) internal {
63         require(_newOwner != address(0));
64         emit OwnershipTransferred(owner, _newOwner);
65         owner = _newOwner;
66     }
67 }
68 
69 contract Pausable is Ownable {
70 
71     event Pause();
72     event Unpause();
73 
74     bool public paused = false;
75 
76     /**
77      * @dev modifier to allow actions only when the contract IS paused
78      */
79     modifier whenNotPaused() {
80         require(!paused);
81         _;
82     }
83 
84     /**
85      * @dev modifier to allow actions only when the contract IS NOT paused
86      */
87     modifier whenPaused {
88         require(paused);
89         _;
90     }
91 
92     /**
93      * @dev called by the owner to pause, triggers stopped state
94      */
95     function pause() onlyOwner whenNotPaused public returns (bool) {
96         paused = true;
97         emit Pause();
98         return true;
99     }
100 
101     /**
102      * @dev called by the owner to unpause, returns to normal state
103      */
104     function unpause() onlyOwner whenPaused public returns (bool) {
105         paused = false;
106         emit Unpause();
107         return true;
108     }
109 }
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116 
117     /**
118     * @dev Multiplies two numbers, throws on overflow.
119     */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
121         if (a == 0) {
122             return 0;
123         }
124         c = a * b;
125         assert(c / a == b);
126         return c;
127     }
128 
129     /**
130     * @dev Integer division of two numbers, truncating the quotient.
131     */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         // assert(b > 0); // Solidity automatically throws when dividing by 0
134         // uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136         return a / b;
137     }
138 
139     /**
140     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141     */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         assert(b <= a);
144         return a - b;
145     }
146 
147     /**
148     * @dev Adds two numbers, throws on overflow.
149     */
150     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
151         c = a + b;
152         assert(c >= a);
153         return c;
154     }
155 }
156 
157 library ContractLib {
158     /*
159     * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
160     */
161     function isContract(address _addr) internal view returns (bool) {
162         uint length;
163         assembly {
164         //retrieve the size of the code on target address, this needs assembly
165             length := extcodesize(_addr)
166         }
167         return (length > 0);
168     }
169 }
170 
171 /*
172 * Contract that is working with ERC223 tokens
173 */
174 contract ContractReceiver {
175     function tokenFallback(address _from, uint _value, bytes _data) public pure;
176 }
177 
178 // ERC Token Standard #20 Interface
179 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
180 contract ERC20Interface {
181 
182     function totalSupply() public constant returns (uint);
183 
184     function balanceOf(address tokenOwner) public constant returns (uint);
185 
186     function allowance(address tokenOwner, address spender) public constant returns (uint);
187 
188     function transfer(address to, uint tokens) public returns (bool);
189 
190     function approve(address spender, uint tokens) public returns (bool);
191 
192     function transferFrom(address from, address to, uint tokens) public returns (bool);
193 
194     function name() public constant returns (string);
195 
196     function symbol() public constant returns (string);
197 
198     function decimals() public constant returns (uint8);
199 
200     event Transfer(address indexed from, address indexed to, uint tokens);
201     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
202 
203 }
204 
205 
206 /**
207 * ERC223 token by Dexaran
208 *
209 * https://github.com/Dexaran/ERC223-token-standard
210 */
211 
212 contract ERC223 is ERC20Interface {
213 
214     function transfer(address to, uint value, bytes data) public returns (bool);
215 
216     event Transfer(address indexed from, address indexed to, uint tokens);
217     event Transfer(address indexed from, address indexed to, uint value, bytes data);
218 
219 }
220 
221 contract Lock is Ownable {
222     bool public useLock = true;
223     //accounts that is locked
224     mapping(address => bool) public lockedAccount;
225 
226     event Locked(address indexed target, bool locked);
227     modifier tokenLock() {
228         if (useLock == true) {
229             require(!lockedAccount[msg.sender], "account is locked");
230         }
231         _;
232     }
233 
234     function setLockToken(bool _lock) onlyAdmin public {
235         useLock = _lock;
236     }
237 
238     function lockAccounts(address[] targets) onlyAdmin public returns (bool){
239         for (uint8 i = 0; i < targets.length; i++) {
240             lockedAccount[targets[i]] = true;
241             emit Locked(targets[i], true);
242         }
243         return true;
244     }
245 
246     function unlockAccounts(address[] targets) onlyAdmin public returns (bool){
247         for (uint8 i = 0; i < targets.length; i++) {
248             lockedAccount[targets[i]] = false;
249             emit Locked(targets[i], false);
250         }
251         return true;
252     }
253 }
254 
255 contract ACCToken is ERC223, Lock, Pausable {
256 
257     using SafeMath for uint256;
258     using ContractLib for address;
259 
260     mapping(address => uint) balances;
261     mapping(address => mapping(address => uint)) allowed;
262 
263     string public name;
264     string public symbol;
265     uint8 public decimals;
266     uint256 public totalSupply;
267 
268     event Burn(address indexed from, uint256 value);
269 
270     constructor() public {
271         symbol = "ACC";
272         name = "AlphaCityCoin";
273         decimals = 18;
274         totalSupply = 100000000000 * 1 ether;
275         balances[msg.sender] = totalSupply;
276         emit Transfer(address(0), msg.sender, totalSupply);
277     }
278 
279     // Function to access name of token .
280     function name() public constant returns (string) {
281         return name;
282     }
283 
284     // Function to access symbol of token .
285     function symbol() public constant returns (string) {
286         return symbol;
287     }
288 
289     // Function to access decimals of token .
290     function decimals() public constant returns (uint8) {
291         return decimals;
292     }
293 
294     // Function to access total supply of tokens .
295     function totalSupply() public constant returns (uint256) {
296         return totalSupply;
297     }
298 
299     // Function that is called when a user or another contract wants to transfer funds .
300     function transfer(address _to, uint _value, bytes _data) public whenNotPaused tokenLock returns (bool) {
301         require(_to != 0x0);
302         if (_to.isContract()) {
303             return transferToContract(_to, _value, _data);
304         }
305         else {
306             return transferToAddress(_to, _value, _data);
307         }
308     }
309 
310     // Standard function transfer similar to ERC20 transfer with no _data .
311     // Added due to backwards compatibility reasons .
312     function transfer(address _to, uint _value) public whenNotPaused tokenLock returns (bool) {
313         require(_to != 0x0);
314 
315         bytes memory empty;
316         if (_to.isContract()) {
317             return transferToContract(_to, _value, empty);
318         }
319         else {
320             return transferToAddress(_to, _value, empty);
321         }
322     }
323 
324     // function that is called when transaction target is an address
325     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
326         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
327         balances[_to] = balanceOf(_to).add(_value);
328         emit Transfer(msg.sender, _to, _value);
329         emit Transfer(msg.sender, _to, _value, _data);
330         return true;
331     }
332 
333     // function that is called when transaction target is a contract
334     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
335         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
336         balances[_to] = balanceOf(_to).add(_value);
337         ContractReceiver receiver = ContractReceiver(_to);
338         receiver.tokenFallback(msg.sender, _value, _data);
339         emit Transfer(msg.sender, _to, _value);
340         emit Transfer(msg.sender, _to, _value, _data);
341         return true;
342     }
343 
344     // get the address of balance
345     function balanceOf(address _owner) public constant returns (uint) {
346         return balances[_owner];
347     }
348 
349     function burn(uint256 _value) public whenNotPaused returns (bool) {
350         require(_value > 0);
351         require(balanceOf(msg.sender) >= _value);
352         // Check if the sender has enough
353         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
354         // Subtract from the sender
355         totalSupply = totalSupply.sub(_value);
356         // Updates totalSupply
357         emit Burn(msg.sender, _value);
358         return true;
359     }
360 
361     ///@dev Token owner can approve for `spender` to transferFrom() `tokens`
362     ///from the token owner's account
363     function approve(address spender, uint tokens) public whenNotPaused returns (bool) {
364         allowed[msg.sender][spender] = tokens;
365         emit Approval(msg.sender, spender, tokens);
366         return true;
367     }
368 
369     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused
370     returns (bool success) {
371         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
372         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373         return true;
374     }
375 
376     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused
377     returns (bool success) {
378         uint oldValue = allowed[msg.sender][_spender];
379         if (_subtractedValue > oldValue) {
380             allowed[msg.sender][_spender] = 0;
381         } else {
382             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
383         }
384         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385         return true;
386     }
387 
388     ///@dev Transfer `tokens` from the `from` account to the `to` account
389     function transferFrom(address from, address to, uint tokens) public whenNotPaused tokenLock returns (bool) {
390         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
391         balances[from] = balances[from].sub(tokens);
392         balances[to] = balances[to].add(tokens);
393         emit Transfer(from, to, tokens);
394         return true;
395     }
396 
397     function allowance(address tokenOwner, address spender) public constant returns (uint) {
398         return allowed[tokenOwner][spender];
399     }
400 
401     function() public payable {
402         revert();
403     }
404 
405     // Owner can transfer out any accidentally sent ERC20 tokens
406     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
407         return ERC20Interface(tokenAddress).transfer(owner, tokens);
408     }
409 
410 }