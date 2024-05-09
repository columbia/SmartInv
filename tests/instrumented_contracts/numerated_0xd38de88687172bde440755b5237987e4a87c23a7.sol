1 pragma solidity ^0.5.17;
2 // @notice SECURITY TOKEN CONTRACT
3 // @dev ERC-1404 with ERC-20 with ERC-223 protection Token Standard Compliant
4 // @author Geoffrey Tipton at AEN
5 // ----------------------------------------------------------------------------
6 // Deployed by : Geoffrey Tipton
7 // Reviewed by : Aaron Regala
8 // Symbol      : AENS
9 // Name        : AEN Smart Token
10 // Total supply: 4,000,000,000
11 // Decimals    : 8
12 //
13 // (c) AENSmart. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 // THE TOKENS HAVE NOT BEEN REGISTERED UNDER THE U.S. SECURITIES ACT OF
16 // 1933, AS AMENDED (THE　“SECURITIES ACT”).  THE TOKENS WERE ISSUED IN
17 // A TRANSACTION EXEMPT FROM THE REGISTRATION REQUIREMENTS OF THE SECURITIES
18 // ACT PURSUANT TO REGULATION S PROMULGATED UNDER IT.  THE TOKENS MAY NOT
19 // BE OFFERED OR SOLD IN THE UNITED STATES UNLESS REGISTERED UNDER THE SECURITIES
20 // ACT OR AN EXEMPTION FROM REGISTRATION IS AVAILABLE.  TRANSFERS OF THE
21 // TOKENS MAY NOT BE MADE EXCEPT IN ACCORDANCE WITH THE PROVISIONS OF REGULATION S,
22 // PURSUANT TO REGISTRATION UNDER THE SECURITIES ACT, OR PURSUANT TO AN AVAILABLE
23 // EXEMPTION FROM REGISTRATION.  FURTHER, HEDGING TRANSACTIONS WITH REGARD TO THE
24 // TOKENS MAY NOT BE CONDUCTED UNLESS IN COMPLIANCE WITH THE SECURITIES ACT.
25 // ----------------------------------------------------------------------------
26 
27 library SafeMath {
28     function add(uint a, uint b) internal pure returns (uint c) {
29         c = a + b; require(c >= a,"Can not add negative values"); }
30     function sub(uint a, uint b) internal pure returns (uint c) {
31         require(b <= a, "Result can not be negative"); c = a - b;  }
32     function mul(uint a, uint b) internal pure returns (uint c) {
33         c = a * b; require(a == 0 || c / a == b,"Divide by zero protection"); }
34     function div(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0,"Divide by zero protection"); c = a / b; }
36 }
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() external view returns (uint);
44     function balanceOf(address owner) public view returns (uint256 balance);
45     function allowance(address owner, address spender) public view returns (uint remaining);
46     function transfer(address to, uint value) public returns (bool success);
47     function approve(address spender, uint value) public returns (bool success);
48     function transferFrom(address from, address to, uint value) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 // ----------------------------------------------------------------------------
55 // Open Standard ERC Token Standard #1404 Interface
56 // https://erc1404.org
57 // ----------------------------------------------------------------------------
58 contract ERC1404 is ERC20Interface {
59     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
60     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string memory);
61 }
62 
63 contract Owned {
64     address public owner;
65     address internal newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     constructor() public {
70         owner = msg.sender;
71         emit OwnershipTransferred(address(0), owner);
72     }
73 
74     modifier onlyOwner() {
75         require(msg.sender == owner, "Only the contract owner can execute this function");
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) external onlyOwner {
80         newOwner = _newOwner;
81     }
82 
83     // Prevent accidental false ownership change
84     function acceptOwnership() external {
85         require(msg.sender == newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88         emit OwnershipTransferred(owner, newOwner);
89     }
90 
91     function getOwner() external view returns (address) {
92         return owner;
93     }
94 }
95 
96 contract Managed is Owned {
97     mapping(address => bool) public managers;
98 
99     modifier onlyManager() {
100         require(managers[msg.sender], "Only managers can perform this action");
101         _;
102     }
103 
104     function addManager(address managerAddress) external onlyOwner {
105         managers[managerAddress] = true;
106     }
107 
108     function removeManager(address managerAddress) external onlyOwner {
109         managers[managerAddress] = false;
110     }
111 }
112 
113 /* ----------------------------------------------------------------------------
114  * Contract function to manage the white list
115  * Byte operation to control function of the whitelist,
116  * and prevent duplicate address entries. simple example
117  * whiteList[add] = 0000 = 0x00 = Not allowed to do either
118  * whiteList[add] = 0001 = 0x01 = Allowed to receive
119  * whiteList[add] = 0010 = 0x02 = Allowed to send
120  * whiteList[add] = 0011 = 0x03 = Allowed to send and receive
121  * whiteList[add] = 0100 = 0x04 = Frozen not allowed to do either
122  * whiteList[add] = 1000 = 0x08 = Paused No one can transfer any tokens
123  *----------------------------------------------------------------------------
124  */
125 contract Whitelist is Managed {
126     mapping(address => bytes1) public whiteList;
127     bytes1 internal listRule;
128     bytes1 internal constant WHITELISTED_CAN_RX_CODE = 0x01;  // binary for 0001
129     bytes1 internal constant WHITELISTED_CAN_TX_CODE = 0x02;  // binary for 0010
130     bytes1 internal constant WHITELISTED_FREEZE_CODE = 0x04;  // binary for 0100 Always applies
131     bytes1 internal constant WHITELISTED_PAUSED_CODE = 0x08;  // binary for 1000 Always applies
132 
133     function isFrozen(address _account) public view returns (bool) {
134         return (WHITELISTED_FREEZE_CODE == (whiteList[_account] & WHITELISTED_FREEZE_CODE)); // 10 & 11 = True
135     }
136 
137     function addToSendAllowed(address _to) external onlyManager {
138         whiteList[_to] = whiteList[_to] | WHITELISTED_CAN_TX_CODE; // just add the code 1
139     }
140 
141     function addToReceiveAllowed(address _to) external onlyManager {
142         whiteList[_to] = whiteList[_to] | WHITELISTED_CAN_RX_CODE; // just add the code 2
143     }
144 
145     function removeFromSendAllowed(address _to) public onlyManager {
146         if (WHITELISTED_CAN_TX_CODE == (whiteList[_to] & WHITELISTED_CAN_TX_CODE))  { // check code 4 so it does toggle when recalled
147             whiteList[_to] = whiteList[_to] ^ WHITELISTED_CAN_TX_CODE; // xor the code to remove the flag
148         }
149     }
150 
151     function removeFromReceiveAllowed(address _to) public onlyManager {
152         if (WHITELISTED_CAN_RX_CODE == (whiteList[_to] & WHITELISTED_CAN_RX_CODE))  {
153             whiteList[_to] = whiteList[_to] ^ WHITELISTED_CAN_RX_CODE;
154         }
155     }
156 
157     function removeFromBothSendAndReceiveAllowed (address _to) external onlyManager {
158         removeFromSendAllowed(_to);
159         removeFromReceiveAllowed(_to);
160     }
161 
162     /*  this overrides the individual whitelisting and manager positions so a
163         frozen account can not be unfrozen by a lower level manager
164     */
165     function freeze(address _to) external onlyOwner {
166         whiteList[_to] = whiteList[_to] | WHITELISTED_FREEZE_CODE; // 4 [0100]
167     }
168 
169     function unFreeze(address _to) external onlyOwner {
170         if (WHITELISTED_FREEZE_CODE == (whiteList[_to] & WHITELISTED_FREEZE_CODE )) { // Already Unfrozen
171             whiteList[_to] = whiteList[_to] ^ WHITELISTED_FREEZE_CODE; // 4 [0100]
172         }
173     }
174 
175     function pause() external onlyOwner {
176         listRule = WHITELISTED_PAUSED_CODE; // 8 [1000]
177     }
178 
179     function resume() external onlyOwner {
180         if (WHITELISTED_PAUSED_CODE == listRule ) { // Already Unfrozen
181             listRule = listRule ^ WHITELISTED_PAUSED_CODE; // 4 [0100]
182         }
183     }
184 
185     /*    Whitelist Rule defines what the rules are for the whitelisting
186           0x00 = No rule
187           0x01 = Receiver must be whitelisted
188           0x10 = Sender must be whitelisted
189           0x11 = Both must be whitelisted
190     */
191     function setWhitelistRule(byte _newRule) external onlyOwner {
192         listRule = _newRule;
193     }
194 
195     function getWhitelistRule() external view returns (byte){
196         return listRule;
197     }
198 }
199 
200 // ----------------------------------------------------------------------------
201 // ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply
202 // ----------------------------------------------------------------------------
203 contract AENSToken is ERC1404, Owned, Whitelist {
204     using SafeMath for uint;
205 
206     string public symbol;
207     string public  name;
208     uint8 public decimals;
209     uint public _totalSupply;
210     uint8 internal restrictionCheck;
211 
212     mapping(address => uint) public balances;
213     mapping(address => mapping(address => uint)) allowed;
214 
215     constructor() public {
216         symbol = "AENS";
217         name = "AEN Smart Token";
218         decimals = 8;
219         _totalSupply = 4000000000 * 10**uint(decimals);
220         balances[msg.sender] = _totalSupply;
221         managers[msg.sender] = true;
222         listRule = 0x00; // Receiver does not need to be whitelisted
223         emit Transfer(address(0), msg.sender, _totalSupply);
224     }
225 
226     modifier transferAllowed(address _from, address _to, uint256 _amount ) {
227         require(!isFrozen(_to) && !isFrozen(_from), "One of the accounts are frozen");  // If not frozen go check
228         if ((listRule & WHITELISTED_CAN_TX_CODE) != 0) { // If whitelist send rule applies then must be set
229             require(WHITELISTED_CAN_TX_CODE == (whiteList[_from] & WHITELISTED_CAN_TX_CODE), "Sending account is not whitelisted"); // 10 & 11 = true
230         }
231         if ((listRule & WHITELISTED_CAN_RX_CODE) != 0) { // If whitelist to receive is required, then check,
232             require(WHITELISTED_CAN_RX_CODE == (whiteList[_to] & WHITELISTED_CAN_RX_CODE),"Receiving account is not whitelisted"); // 01 & 11 = True
233         }
234         _;
235     }
236 
237     // ------------------------------------------------------------------------
238     // Total supply minus any lost tokens to the zero address (Potential burn)
239     function totalSupply() external view returns (uint) {
240         return _totalSupply.sub(balances[address(0)]);
241     }
242 
243     // ------------------------------------------------------------------------
244     // Get the token balance for account `tokenOwner`
245     function balanceOf(address owner) public view returns (uint256) {
246         return balances[owner];
247     }
248 
249     // ------------------------------------------------------------------------
250     // Transfer the balance from token owner's account to `to` account
251     // - Owner's account must have sufficient balance to transfer
252     // - 0 value transfers are allowed
253     // function transfer(address _to, uint _tokens)  public receiveAllowed(_to)  returns (bool success) {
254     function transfer(address _to, uint _value)  public transferAllowed(msg.sender, _to, _value) returns (bool) {
255         require((_to != address(0)) && (_to != address(this))); // Do not allow transfer to 0x0 or the token contract itself
256         balances[msg.sender] = balances[msg.sender].sub(_value);
257         balances[_to] = balances[_to].add(_value);
258         emit Transfer(msg.sender, _to, _value);
259         return true;
260     }
261 
262     // ------------------------------------------------------------------------
263     // Token owner can approve for `spender` to transferFrom(...) `tokens`
264     // from the token owner's account
265     function approve(address spender, uint value) public transferAllowed(msg.sender, spender, value) returns (bool) {
266         allowed[msg.sender][spender] = value;
267         emit Approval(msg.sender, spender, value);
268         return true;
269     }
270 
271     // ------------------------------------------------------------------------
272     // Transfer `tokens` from the `from` account to the `to` account
273     function transferFrom(address _from, address _to, uint _value) public transferAllowed(_from, _to, _value) returns (bool) {
274         // function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
275         require((_to != address(0)) && (_to != address(this))); // Do not allow transfer to 0x0 or the token contract itself
276         balances[_from] = balances[_from].sub(_value);
277         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
278         balances[_to] = balances[_to].add(_value);
279         emit Transfer(_from, _to, _value);
280         return true;
281     }
282 
283     /* ------------------------------------------------------------------------
284      * Returns the amount of tokens approved by the owner that can be
285      * transferred to the spender's account
286     */
287     function allowance(address owner, address spender) public view returns (uint) {
288         return allowed[owner][spender];
289     }
290 
291 
292     /* ----------------------------------------------------------------------------------------
293      * @dev Creates `amount` tokens and assigns them to `account`, increasing the total supply.
294      * Emits a `Transfer` event with `from` set to the zero address.
295      * Requirements
296      * - `to` cannot be the zero address.
297      */
298     function mint(address account, uint256 amount) public onlyOwner {
299         require(account != address(0), "ERC20: mint to the zero address");
300 
301         _totalSupply = _totalSupply.add(amount);
302         balances[account] = balances[account].add(amount);
303         emit Transfer(address(0), account, amount);
304     }
305 
306     /* ------------------------------------------------------------------------
307      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
308      * Emits a `Transfer` event with `to` set to the zero address.
309      * Requirements
310      * - `account` cannot be the zero address.
311      * - `account` must have at least `amount` tokens.
312      */
313     function burn(address account, uint256 value) public onlyOwner {
314         require(account != address(0), "ERC20: prevent burn from a zero address");
315 
316         balances[account] = balances[account].sub(value);
317         _totalSupply = _totalSupply.sub(value);
318         emit Transfer(account, address(0), value);
319     }
320 
321 
322     /* ------------------------------------------------------------------------
323      * don't accept ETH
324      */
325     function() payable external {
326         revert();
327     }
328 
329     /* ------------------------------------------------------------------------
330      * This function prevents accidentally sent tokens to the contract
331      */
332     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
333         return ERC20Interface(tokenAddress).transfer(owner, tokens);
334     }
335 
336     /* ------------------------------------------------------------------------
337      * The following functions are for 1404 interface compliance, to detect
338      * a transaction is allowed before sending, to save gas and obtain a clear Message
339     */
340     function detectTransferRestriction (address _from, address _to, uint256 _value) public view returns (uint8 restrictionCode)
341     {
342         restrictionCode = 0; // No restrictions
343         if ( WHITELISTED_CAN_TX_CODE == (listRule & WHITELISTED_CAN_TX_CODE) ) { //Can Send rule applies
344             if (!(WHITELISTED_CAN_TX_CODE == (whiteList[_to] & WHITELISTED_CAN_TX_CODE)) ) { //True if allowed to send
345                 restrictionCode += 1; // Send is not allowed
346             }
347         }
348         if (WHITELISTED_CAN_RX_CODE == (listRule & WHITELISTED_CAN_RX_CODE)){ // Can Receive Rule applied
349             if (!(WHITELISTED_CAN_RX_CODE == (whiteList[_from] & WHITELISTED_CAN_RX_CODE))) {
350                 restrictionCode += 2; // Receive is not allowed
351             }
352         }
353         if ((WHITELISTED_FREEZE_CODE == (whiteList[_from] & WHITELISTED_FREEZE_CODE)) ) { // Added to Frozen
354             restrictionCode += 4; // Sender is Frozen
355         }
356         if ((WHITELISTED_FREEZE_CODE == (whiteList[_to] & WHITELISTED_FREEZE_CODE)) ) { // Added to Frozen
357             restrictionCode += 8; // Receiver is Frozen
358         }
359 
360         if (balanceOf(_from) < _value) {
361             restrictionCode += 16; // Send has insufficient balance
362         }
363 
364         if (listRule == (listRule & WHITELISTED_PAUSED_CODE) ) {
365             restrictionCode += 32; // Send has insufficient balance
366         }
367 
368         return restrictionCode;
369     }
370 
371     /* ------------------------------------------------------------------------------------
372     * helper function to return a human readable message for the detectTransferRestriction
373     */
374     function messageForTransferRestriction (uint8 _restrictionCode) public view returns (string memory _message) {
375         _message = "Transfer Allowed";  // default and when is zero
376 
377         if (_restrictionCode >= 32) {
378             _message = "Contract Token is Paused for all transfers";
379         } else if (_restrictionCode >= 16) {
380             _message = "Insufficient Balance to send";
381         } else if (_restrictionCode >= 8) {
382             _message = "To Account is Frozen, contact provider";
383         } else if (_restrictionCode >= 4) {
384             _message = "From Account is Frozen, contact provider";
385         } else if (_restrictionCode >= 3) {
386             _message = "Both Sending and receiving address has not been KYC Approved";
387         } else if (_restrictionCode >= 2) {
388             _message = "Receiving address has not been KYC Approved";
389         } else if (_restrictionCode >= 1) {
390             _message = "Sending address has not been KYC Approved";
391         }
392         return _message;
393     }
394 }