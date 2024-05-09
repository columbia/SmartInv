1 pragma solidity ^0.5.8;
2 // @notice SECURITY TOKEN CONTRACT
3 // @dev ERC-1404 with ERC-20 with ERC223 protection Token Standard Compliant
4 // @author Geoffrey Tipton at AEN
5 // ----------------------------------------------------------------------------
6 // Deployed by : Geoffrey Tipton
7 // Symbol      : SMPT
8 // Name        : Smart Pharma Token
9 // Total supply: 1,000,000,000
10 // Decimals    : 8
11 //
12 // (c) AENCOIN. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 // THE SMPT TOKENS HAVE NOT BEEN REGISTERED UNDER THE U.S. SECURITIES ACT OF
15 // 1933, AS AMENDED (THE　“SECURITIES ACT”).  THE SMPT TOKENS WERE ISSUED IN
16 // A TRANSACTION EXEMPT FROM THE REGISTRATION REQUIREMENTS OF THE SECURITIES
17 // ACT PURSUANT TO REGULATION S PROMULGATED UNDER IT.  THE SMPT TOKENS MAY NOT
18 // BE OFFERED OR SOLD IN THE UNITED STATES UNLESS REGISTERED UNDER THE SECURITIES
19 // ACT OR AN EXEMPTION FROM REGISTRATION IS AVAILABLE.  TRANSFERS OF THE SMPT
20 // TOKENS MAY NOT BE MADE EXCEPT IN ACCORDANCE WITH THE PROVISIONS OF REGULATION S,
21 // PURSUANT TO REGISTRATION UNDER THE SECURITIES ACT, OR PURSUANT TO AN AVAILABLE
22 // EXEMPTION FROM REGISTRATION.  FURTHER, HEDGING TRANSACTIONS WITH REGARD TO THE
23 // SMPT TOKENS MAY NOT BE CONDUCTED UNLESS IN COMPLIANCE WITH THE SECURITIES ACT.
24 // ----------------------------------------------------------------------------
25 library SafeMath {
26     function add(uint a, uint b) internal pure returns (uint c) {
27         c = a + b; require(c >= a,"Can not add Negative Values"); }
28     function sub(uint a, uint b) internal pure returns (uint c) {
29         require(b <= a, "Result can not be negative"); c = a - b;  }
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b; require(a == 0 || c / a == b,"Dived by Zero protection"); }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0,"Devide by Zero protection"); c = a / b; }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() external view returns (uint);
42     function balanceOf(address owner) public view returns (uint256 balance);
43     function allowance(address owner, address spender) public view returns (uint remaining);
44     function transfer(address to, uint value) public returns (bool success);
45     function approve(address spender, uint value) public returns (bool success);
46     function transferFrom(address from, address to, uint value) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 contract ERC1404 is ERC20Interface {
53     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
54     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string memory);
55 }
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address internal newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public { //Only on contract creation
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner, "Only the contract owner can execute this function");
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) external onlyOwner {
76         newOwner = _newOwner;
77     }
78 
79     function acceptOwnership() external {
80         require(msg.sender == newOwner);
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 contract Managed is Owned {
88     mapping (address => bool) public managers;
89 
90 
91     modifier onlyManager () {
92         require(managers[msg.sender], "Only managers may perform this action");
93         _;
94     }
95 
96     function addManager (address managerAddress) public onlyOwner {
97         managers[managerAddress] = true;
98     }
99 
100     function removeManager (address managerAddress) external onlyOwner {
101         managers[managerAddress] = false;
102     }
103 }
104 
105 /* ----------------------------------------------------------------------------
106  * Contract function to manage the white list
107  * Byte operation to control function of the whitelist,
108  * and prevent duplicate address entries. simple example
109  * whiteList[add] = 0000 = 0x00 = Not allowed to do either
110  * whiteList[add] = 0001 = 0x01 = Allowed to receive
111  * whiteList[add] = 0010 = 0x02 = Allowed to send
112  * whiteList[add] = 0011 = 0x03 = Allowed to Send and Receive
113  * whiteList[add] = 0100 = 0x04 = Frozen not allowed to do either
114  *----------------------------------------------------------------------------
115  */
116 contract Whitelist is Managed {
117     mapping(address => bytes1) public whiteList;
118     bytes1 internal listRule;
119     bytes1 internal constant WHITELISTED_CAN_RX_CODE = 0x01;  // binary for 0001
120     bytes1 internal constant WHITELISTED_CAN_TX_CODE = 0x02;  // binary for 0010
121     bytes1 internal constant WHITELISTED_FREEZE_CODE = 0x04;  // binary for 0100
122 
123     function frozen(address _account) public view returns (bool){ //If account is flagged to freeze return true
124         return (WHITELISTED_FREEZE_CODE == (whiteList[_account] & WHITELISTED_FREEZE_CODE)); // 10 & 11 = True
125     }
126 
127     function addToSendAllowed(address _to) external onlyManager {
128         whiteList[_to] = whiteList[_to] | WHITELISTED_CAN_TX_CODE; // just add the code 1
129     }
130 
131     function addToReceiveAllowed(address _to) external onlyManager {
132         whiteList[_to] = whiteList[_to] | WHITELISTED_CAN_RX_CODE; // just add the code 2
133     }
134 
135     function removeFromSendAllowed(address _to) public onlyManager {
136         if (WHITELISTED_CAN_TX_CODE == (whiteList[_to] & WHITELISTED_CAN_TX_CODE))  { //check code 4 so it does toggle when recalled
137             whiteList[_to] = whiteList[_to] ^ WHITELISTED_CAN_TX_CODE; // xor the code to remove the flag
138         }
139     }
140 
141     function removeFromReceiveAllowed(address _to) public onlyManager {
142         if (WHITELISTED_CAN_RX_CODE == (whiteList[_to] & WHITELISTED_CAN_RX_CODE))  {
143             whiteList[_to] = whiteList[_to] ^ WHITELISTED_CAN_RX_CODE;
144         }
145     }
146 
147     function removeFromBothSendAndReceiveAllowed (address _to) external onlyManager {
148         removeFromSendAllowed(_to);
149         removeFromReceiveAllowed(_to);
150     }
151 
152     /*  this overides the individual whitelisting and manager positions so a
153         frozen account can not be unfrozen by a lower level manager
154     */
155     function freeze(address _to) external onlyOwner {
156         whiteList[_to] = whiteList[_to] | WHITELISTED_FREEZE_CODE; // 4 [0100]
157     }
158 
159     function unFreeze(address _to) external onlyOwner {
160         if (WHITELISTED_FREEZE_CODE == (whiteList[_to] & WHITELISTED_FREEZE_CODE )) { //Already UnFrozen
161             whiteList[_to] = whiteList[_to] ^ WHITELISTED_FREEZE_CODE; // 4 [0100]
162         }
163     }
164 
165     /*    WhitlistRule defines what the rules are for the white listing.
166           0x00 = No rule
167           0x01 = Receiver must be Listed
168           0x10 = Sender must be listed
169           0x11 = Both must be listed
170     */
171     function setWhitelistRule(byte _newRule) external onlyOwner {
172         listRule = _newRule;
173     }
174     function getWhitelistRule() external view returns (byte){
175         return listRule;
176     }
177 }
178 
179 // ----------------------------------------------------------------------------
180 // ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply
181 contract SPTToken is ERC1404, Owned, Whitelist {
182     using SafeMath for uint;
183 
184     string public symbol;
185     string public  name;
186     uint8 public decimals;
187     uint public _totalSupply;
188     uint8 internal restrictionCheck;
189 
190     mapping(address => uint) public balances;
191     mapping(address => mapping(address => uint)) allowed;
192 
193 
194     // ------------------------------------------------------------------------
195     // Constructor
196     constructor() public {
197         symbol = "SMPT";
198         name = "Smart Pharma Token";
199         decimals = 8;
200         _totalSupply = 100000000000000000;
201         balances[msg.sender] = _totalSupply;
202         managers[msg.sender] = true;
203         listRule = 0x00; //Receiver does not need to be whitelisted.
204         emit Transfer(address(0), msg.sender, _totalSupply);
205     }
206 
207     modifier transferAllowed(address _from, address _to, uint256 _amount ) {
208         require(!frozen(_to) && !frozen(_from), "One of the Accounts are Frozen");  //If not frozen go check
209         if ((listRule & WHITELISTED_CAN_TX_CODE) != 0) { // if whitelist send rul applies then must be set
210             require(WHITELISTED_CAN_TX_CODE == (whiteList[_from] & WHITELISTED_CAN_TX_CODE), "Sending Account is not whitelisted"); // 10 & 11 = true
211         }
212         if ((listRule & WHITELISTED_CAN_RX_CODE) != 0) { //if whitelist to receive is required, then check,
213             require(WHITELISTED_CAN_RX_CODE == (whiteList[_to] & WHITELISTED_CAN_RX_CODE),"Receiving Account is not Whitelisted"); // 01 & 11 = True
214         }
215         _;
216     }
217 
218     // ------------------------------------------------------------------------
219     // Total supply minus any lost tokens to the zero address (Potential burn)
220     function totalSupply() external view returns (uint) {
221         return _totalSupply.sub(balances[address(0)]);
222     }
223 
224     // ------------------------------------------------------------------------
225     // Get the token balance for account `tokenOwner`
226     function balanceOf(address owner) public view returns (uint256) {
227         return balances[owner];
228     }
229 
230     // ------------------------------------------------------------------------
231     // Transfer the balance from token owner's account to `to` account
232     // - Owner's account must have sufficient balance to transfer
233     // - 0 value transfers are allowed
234     // function transfer(address _to, uint _tokens)  public receiveAllowed(_to)  returns (bool success) {
235     function transfer(address _to, uint _value)  public transferAllowed(msg.sender, _to, _value) returns (bool) {
236         require((_to != address(0)) && (_to != address(this))); // Do not allow transfer to 0x0 or the token contract itself
237         balances[msg.sender] = balances[msg.sender].sub(_value);
238         balances[_to] = balances[_to].add(_value);
239         emit Transfer(msg.sender, _to, _value);
240         return true;
241     }
242 
243     // ------------------------------------------------------------------------
244     // Token owner can approve for `spender` to transferFrom(...) `tokens`
245     // from the token owner's account
246     function approve(address spender, uint value) public transferAllowed(msg.sender, spender, value) returns (bool) {
247         allowed[msg.sender][spender] = value;
248         emit Approval(msg.sender, spender, value);
249         return true;
250     }
251 
252     // ------------------------------------------------------------------------
253     // Transfer `tokens` from the `from` account to the `to` account
254     function transferFrom(address _from, address _to, uint _value) public transferAllowed(_from, _to, _value) returns (bool) {
255         // function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
256         require((_to != address(0)) && (_to != address(this))); // Do not allow transfer to 0x0 or the token contract itself
257         balances[_from] = balances[_from].sub(_value);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259         balances[_to] = balances[_to].add(_value);
260         emit Transfer(_from, _to, _value);
261         return true;
262     }
263 
264     /* ------------------------------------------------------------------------
265      * Returns the amount of tokens approved by the owner that can be
266      * transferred to the spender's account
267     */
268     function allowance(address owner, address spender) public view returns (uint) {
269         return allowed[owner][spender];
270     }
271 
272     /* ------------------------------------------------------------------------
273      * don't accept ETH
274      */
275     function () payable external {
276         revert();
277     }
278 
279     /* ------------------------------------------------------------------------
280      * @This is a security over ride function that allows error correction.
281      * Owner can transfer out any accidentally sent tokens
282      * Call the contract address with the token address, which pretends to be the sender
283      * The receiving address is the caller of the contract.
284      */
285     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
286         return ERC20Interface(tokenAddress).transfer(owner, tokens);
287     }
288 
289     /* ------------------------------------------------------------------------
290      * The following functions are for 1404 interface compliance, to detect
291      * a transaction is allowed before sending, to save gas and obtain a clear Message
292     */
293     function detectTransferRestriction (address _from, address _to, uint256 _value) public view returns (uint8 restrictionCode)
294     {
295         restrictionCode = 0; // No restrictions
296         if ( WHITELISTED_CAN_TX_CODE == (listRule & WHITELISTED_CAN_TX_CODE) ) { //Can Send rule applies
297             if (!(WHITELISTED_CAN_TX_CODE == (whiteList[_to] & WHITELISTED_CAN_TX_CODE)) ) { //True if allowed to send
298                 restrictionCode += 1; // Send is not allowed
299             }
300         }
301         if (WHITELISTED_CAN_RX_CODE == (listRule & WHITELISTED_CAN_RX_CODE)){ // Can Receive Rule applied
302             if (!(WHITELISTED_CAN_RX_CODE == (whiteList[_from] & WHITELISTED_CAN_RX_CODE))) {
303                 restrictionCode += 2; // Receive is not allowed
304             }
305         }
306         if ((WHITELISTED_FREEZE_CODE == (whiteList[_from] & WHITELISTED_FREEZE_CODE)) ) { // Added to Frozen
307             restrictionCode += 4; // Sender is Frozen
308         }
309         if ((WHITELISTED_FREEZE_CODE == (whiteList[_to] & WHITELISTED_FREEZE_CODE)) ) { // Added to Frozen
310             restrictionCode += 8; // Receiver is Frozen
311         }
312 
313         if (balanceOf(_from) < _value) {
314             restrictionCode += 16; // Send has insufficient balance
315         }
316 
317         return restrictionCode;
318     }
319 
320     /* ------------------------------------------------------------------------------------
321     * helper function to return a human readable message for the detectTransferRestriction
322     */
323     function messageForTransferRestriction (uint8 _restrictionCode) public view returns (string memory _message) {
324         _message = "Transfer Allowed";  // default and when is zero
325         if (_restrictionCode >= 16) {
326             _message = "Insufficient Balance to send";
327         } else if (_restrictionCode >= 8) {
328             _message = "To Account is Frozen, contact provider";
329         } else if (_restrictionCode >= 4) {
330             _message = "From Account is Frozen, contact provider";
331         } else if (_restrictionCode >= 3) {
332             _message = "Both Sending and receiving address has not been KYC Approved";
333         } else if (_restrictionCode >= 2) {
334             _message = "Receiving address has not been KYC Approved";
335         } else if (_restrictionCode >= 1) {
336             _message = "Sending address has not been KYC Approved";
337         }
338         return _message;
339     }
340 }