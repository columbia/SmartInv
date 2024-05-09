1 /**
2  * Lucky Block Network Project Smart-Contracts
3  * @authors https://grox.solutions
4  */
5 
6 pragma solidity 0.5.7;
7 
8 library SafeMath {
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         require(b <= a);
12         uint256 c = a - b;
13 
14         return c;
15     }
16 
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a);
20 
21         return c;
22     }
23 }
24 
25 contract MultiOwnable {
26 
27     mapping (address => bool) _owner;
28 
29     modifier onlyOwner() {
30         require(isOwner(msg.sender));
31         _;
32     }
33 
34     function isOwner(address addr) public view returns (bool) {
35         return _owner[addr];
36     }
37 
38 }
39 
40 /**
41  * @title ERC20 interface
42  * @dev see https://eips.ethereum.org/EIPS/eip-20
43  */
44 interface IERC20 {
45     function transfer(address to, uint256 value) external returns (bool);
46     function approve(address spender, uint256 value) external returns (bool);
47     function transferFrom(address from, address to, uint256 value) external returns (bool);
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address who) external view returns (uint256);
50     function allowance(address owner, address spender) external view returns (uint256);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 /**
56  * @title Standard ERC20 token
57  *
58  * @dev Implementation of the basic standard token.
59  * See https://eips.ethereum.org/EIPS/eip-20
60  */
61 contract ERC20 is IERC20 {
62     using SafeMath for uint256;
63 
64     mapping (address => uint256) private _balances;
65 
66     mapping (address => mapping (address => uint256)) private _allowed;
67 
68     uint256 private _totalSupply;
69 
70     function totalSupply() public view returns (uint256) {
71         return _totalSupply;
72     }
73 
74     function balanceOf(address owner) public view returns (uint256) {
75         return _balances[owner];
76     }
77 
78     function allowance(address owner, address spender) public view returns (uint256) {
79         return _allowed[owner][spender];
80     }
81 
82     function transfer(address to, uint256 value) public returns (bool) {
83         _transfer(msg.sender, to, value);
84         return true;
85     }
86 
87     function approve(address spender, uint256 value) public returns (bool) {
88         _approve(msg.sender, spender, value);
89         return true;
90     }
91 
92     function transferFrom(address from, address to, uint256 value) public returns (bool) {
93         _transfer(from, to, value);
94         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
99         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
104         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
105         return true;
106     }
107 
108     function _transfer(address from, address to, uint256 value) internal {
109         require(to != address(0));
110 
111         _balances[from] = _balances[from].sub(value);
112         _balances[to] = _balances[to].add(value);
113         emit Transfer(from, to, value);
114     }
115 
116     function _mint(address account, uint256 value) internal {
117         require(account != address(0));
118 
119         _totalSupply = _totalSupply.add(value);
120         _balances[account] = _balances[account].add(value);
121         emit Transfer(address(0), account, value);
122     }
123 
124     function _burn(address account, uint256 value) internal {
125         require(account != address(0));
126 
127         _totalSupply = _totalSupply.sub(value);
128         _balances[account] = _balances[account].sub(value);
129         emit Transfer(account, address(0), value);
130     }
131 
132     function _approve(address owner, address spender, uint256 value) internal {
133         require(spender != address(0));
134         require(owner != address(0));
135 
136         _allowed[owner][spender] = value;
137         emit Approval(owner, spender, value);
138     }
139 
140 }
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable {
147     event Paused(address account);
148     event Unpaused(address account);
149 
150     bool private _paused;
151 
152     constructor () internal {
153         _paused = false;
154     }
155 
156     function paused() public view returns (bool) {
157         return _paused;
158     }
159 
160     modifier whenNotPaused() {
161         require(!_paused);
162         _;
163     }
164 
165     modifier whenPaused() {
166         require(_paused);
167         _;
168     }
169 
170     function pause() public whenNotPaused {
171         _paused = true;
172         emit Paused(msg.sender);
173     }
174 
175     function unpause() public whenPaused {
176         _paused = false;
177         emit Unpaused(msg.sender);
178     }
179 }
180 
181 /**
182  * @title Pausable token
183  * @dev ERC20 modified with pausable transfers.
184  */
185 contract ERC20Pausable is ERC20, Pausable {
186     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
187         return super.transfer(to, value);
188     }
189 
190     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
191         return super.transferFrom(from, to, value);
192     }
193 
194     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
195         return super.approve(spender, value);
196     }
197 
198     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
199         return super.increaseAllowance(spender, addedValue);
200     }
201 
202     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
203         return super.decreaseAllowance(spender, subtractedValue);
204     }
205 }
206 
207 /**
208  * @title ApproveAndCall Interface.
209  * @dev ApproveAndCall system hepls to communicate with smart-contracts.
210  */
211 contract ApproveAndCallFallBack {
212     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
213 }
214 
215 /**
216  * @title The main project contract.
217  * @author https://grox.solutions
218  */
219 contract LBNToken is ERC20Pausable, MultiOwnable {
220 
221     // name of the token
222     string private _name = "Lucky Block Network";
223     // symbol of the token
224     string private _symbol = "LBN";
225     // decimals of the token
226     uint8 private _decimals = 18;
227 
228     // initial supply
229     uint256 public constant INITIAL_SUPPLY = 99990000 * (10 ** 18);
230 
231     // an amount of votes required to process an action
232     uint8 public consensusValue = 1;
233 
234     // struct for proposals
235     struct Proposal {
236         // amount of votes
237         uint8 votes;
238         // count of proposals
239         uint256 count;
240         // double mapping to prevent the error of repeating the same proposal
241         mapping (uint256 => mapping (address => bool)) voted;
242     }
243 
244     // mapping to implement muptiple owners
245     mapping (address => bool) _owner;
246 
247     // boolean value if minting is finished of not
248     bool public mintingIsFinished;
249 
250     /**
251      * @dev Throws if called while minting is finished.
252      */
253     modifier isNotFinished {
254         require(!mintingIsFinished);
255         _;
256     }
257 
258     /**
259      * @dev Throws if called by any account other than the owner.
260      */
261     modifier onlyOwner() {
262         require(isOwner(msg.sender));
263         _;
264     }
265 
266     // events
267     event LogProposal(string indexed method, address param1, address param2, uint256 param3, string param4, address indexed voter, uint8 votes, uint8 consensusValue);
268     event LogAction(string indexed method, address param1, address param2, uint256 param3, string param4);
269 
270     /**
271       * @dev constructor function that is called once at deployment of the contract.
272       * @param owners 5 initial owners to set.
273       * @param recipient Address to receive initial supply.
274       */
275     constructor(address[] memory owners, address recipient) public {
276 
277         for (uint8 i = 0; i < 5; i++) {
278             _owner[owners[i]] = true;
279         }
280 
281         _mint(recipient, INITIAL_SUPPLY);
282 
283     }
284 
285     /**
286       * @dev Internal function that process voting in a given proposal, returns `true` if the voting has succesfully ended.
287       * @param props The proposal storage.
288       * @notice Every next parameter is given only to emit events.
289       * @param method Name of the called method.
290       * @param param1 First address parameter.
291       * @param param2 Second address parameter.
292       * @param param3 uint256 parameter.
293       * @param param4 string parameter.
294       */
295     function _vote(Proposal storage props, string memory method, address param1, address param2, uint256 param3, string memory param4) internal returns(bool) {
296 
297         // if that is the new proposal add a number to count to prevent the error of repeating the same proposal
298         if (props.votes == 0) {
299             props.count++;
300         }
301 
302         // if msg.sender hasn't voted yet, do this
303         if (!props.voted[props.count][msg.sender]) {
304             props.votes++;
305             props.voted[props.count][msg.sender] = true;
306             emit LogProposal(method, param1, param2, param3, param4, msg.sender, props.votes, consensusValue);
307         }
308 
309         // if an amount of votes is equal or more than consensusValue renew the proposal and return `true` to process the action
310         if (props.votes >= consensusValue) {
311             props.votes = 0;
312             emit LogAction(method, param1, param2, param3, param4);
313             return true;
314         }
315 
316     }
317 
318     /**
319      * @dev Storage for owner proposals.
320      */
321     mapping (address => mapping(address => Proposal)) public ownerProp;
322 
323     /**
324      * @dev Vote to transfer control of the contract from one account to another.
325      * @param previousOwner The address to remove ownership from.
326      * @param newOwner The address to transfer ownership to.
327      * @notice There are only 5 owners of this contract
328      */
329     function changeOwner(address previousOwner, address newOwner) public onlyOwner {
330         require(isOwner(previousOwner) && !isOwner(newOwner));
331 
332         if (_vote(ownerProp[previousOwner][newOwner], "changeOwner", previousOwner, newOwner, 0, "")) {
333             _owner[previousOwner] = false;
334             _owner[newOwner] = true;
335         }
336 
337     }
338 
339     /**
340      * @dev Storage for consensus proposals.
341      */
342     mapping (uint8 => Proposal) public consProp;
343 
344     /**
345      * @dev Vote to change the consensusValue.
346      * @param newConsensusValue new value.
347      */
348     function setConsensusValue(uint8 newConsensusValue) public onlyOwner {
349 
350         if (_vote(consProp[newConsensusValue], "setConsensusValue", address(0), address(0), newConsensusValue, "")) {
351             consensusValue = newConsensusValue;
352         }
353 
354     }
355 
356     /**
357      * @dev Storage for minting finalize proposal.
358      */
359     Proposal public finMintProp;
360 
361     /**
362      * @dev Vote to stop minting of tokens forever.
363      */
364     function finalizeMinting() public onlyOwner {
365 
366         if (_vote(finMintProp, "finalizeMinting", address(0), address(0), 0, "")) {
367             mintingIsFinished = true;
368         }
369 
370     }
371 
372     /**
373      * @dev Storage for mint proposals.
374      */
375     mapping (address => mapping (uint256 => mapping (string => Proposal))) public mintProp;
376 
377     /**
378      * @dev Vote to mint an amount of the token and assigns it to
379      * an account.
380      * @param to The account that will receive the created tokens.
381      * @param value The amount that will be created.
382      */
383     function mint(address to, uint256 value) public isNotFinished onlyOwner returns (bool) {
384 
385         if (_vote(mintProp[to][value]["mint"], "mint", to, address(0), value, "")) {
386             _mint(to, value);
387         }
388 
389     }
390 
391     /**
392      * @dev Storage for burn proposals.
393      */
394     mapping (address => mapping (uint256 => mapping (string => Proposal))) public burnProp;
395 
396 
397     /**
398      * @dev Vote to burn an amount of the token of a given
399      * account.
400      * @param from The account whose tokens will be burnt.
401      * @param value The amount that will be burnt.
402      */
403     function burnFrom(address from, uint256 value) public onlyOwner {
404 
405         if (_vote(burnProp[from][value]["burnFrom"], "burnFrom", from, address(0), value, "")) {
406             _burn(from, value);
407         }
408 
409     }
410 
411     /**
412      * @dev Storage for pause proposals.
413      */
414     Proposal public pauseProp;
415 
416     /**
417      * @dev Vote to pause any transfer of tokens.
418      * Called by a owner to pause, triggers stopped state.
419      */
420     function pause() public onlyOwner {
421 
422         if (_vote(pauseProp, "pause", address(0), address(0), 0, "")) {
423             super.pause();
424         }
425 
426     }
427 
428     /**
429      * @dev Storage for unpause proposals.
430      */
431     Proposal public unpauseProp;
432 
433     /**
434      * @dev Vote to pause any transfer of tokens.
435      * Called by a owner to unpause, triggers normal state.
436      */
437     function unpause() public onlyOwner {
438 
439         if (_vote(unpauseProp, "unpause", address(0), address(0), 0, "")) {
440             super.unpause();
441         }
442 
443     }
444 
445     /**
446      * @dev Storage for name proposals.
447      */
448     mapping (string => mapping (string => Proposal)) public nameProp;
449 
450     /**
451     * @dev Change the name of the token.
452     * @param newName New name of the token.
453     */
454     function changeName(string memory newName) public onlyOwner {
455 
456         if (_vote(nameProp[newName]["name"], "changeName", address(0), address(0), 0, newName)) {
457             _name = newName;
458         }
459 
460     }
461 
462     /**
463      * @dev Storage for symbol proposals.
464      */
465     mapping (string => mapping (string => Proposal)) public symbolProp;
466 
467     /**
468     * @dev Change the symbol of the token.
469     * @param newSymbol New symbol of the token.
470     */
471     function changeSymbol(string memory newSymbol) public onlyOwner {
472 
473         if (_vote(symbolProp[newSymbol]["symbol"], "changeSymbol", address(0), address(0), 0, newSymbol)) {
474             _symbol = newSymbol;
475         }
476 
477     }
478 
479     /**
480     * @dev Allows to send tokens (via Approve and TransferFrom) to other smart contract.
481     * @param spender Address of smart contracts to work with.
482     * @param amount Amount of tokens to send.
483     * @param extraData Any extra data.
484     */
485     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {
486         require(approve(spender, amount));
487 
488         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
489 
490         return true;
491     }
492 
493     /**
494     * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
495     * @param ERC20Token Address of ERC20 token.
496     * @param recipient Account to receive tokens.
497     */
498     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
499 
500         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
501         IERC20(ERC20Token).transfer(recipient, amount);
502 
503     }
504 
505     /**
506     * @return true if `addr` is the owner of the contract.
507     */
508     function isOwner(address addr) public view returns (bool) {
509         return _owner[addr];
510     }
511 
512     /**
513      * @return the name of the token.
514      */
515     function name() public view returns (string memory) {
516         return _name;
517     }
518 
519     /**
520      * @return the symbol of the token.
521      */
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     /**
527      * @return the number of decimals of the token.
528      */
529     function decimals() public view returns (uint8) {
530         return _decimals;
531     }
532 
533 }