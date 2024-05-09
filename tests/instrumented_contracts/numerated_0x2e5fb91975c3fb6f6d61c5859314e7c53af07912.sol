1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC820Registry {
46     function getManager(address addr) public view returns(address);
47     function setManager(address addr, address newManager) public;
48     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
49     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
50 }
51 
52 contract ERC820Implementer {
53     ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);
54 
55     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
56         bytes32 ifaceHash = keccak256(ifaceLabel);
57         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
58     }
59 
60     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
61         bytes32 ifaceHash = keccak256(ifaceLabel);
62         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
63     }
64 
65     function delegateManagement(address newManager) internal {
66         erc820Registry.setManager(this, newManager);
67     }
68 }
69 interface ERC777TokensSender {
70     function tokensToSend(address operator, address from, address to, uint amount, bytes userData,bytes operatorData) external;
71 }
72 
73 
74 interface ERC777TokensRecipient {
75     function tokensReceived(address operator, address from, address to, uint amount, bytes userData, bytes operatorData) external;
76 }
77 
78 contract Ownable {
79   address public owner;
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev The constructor sets the original owner of the contract to the sender account.
93    */
94   function Ownable() public {
95     setOwner(msg.sender);
96   }
97 
98   /**
99    * @dev Sets a new owner address
100    */
101   function setOwner(address newOwner) internal {
102     owner = newOwner;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     emit OwnershipTransferred(owner, newOwner);
112     setOwner(newOwner);
113   }
114 }
115 
116 contract JaroCoinToken is Ownable, ERC820Implementer {
117     using SafeMath for uint256;
118 
119     string public constant name = "JaroCoin";
120     string public constant symbol = "JARO";
121     uint8 public constant decimals = 18;
122     uint256 public constant granularity = 1e10;   // Token has 8 digits after comma
123 
124     mapping (address => uint256) public balanceOf;
125     mapping (address => mapping (address => bool)) public isOperatorFor;
126     mapping (address => mapping (uint256 => bool)) private usedNonces;
127 
128     event Transfer(address indexed from, address indexed to, uint256 value);
129     event Sent(address indexed operator, address indexed from, address indexed to, uint256 amount, bytes userData, bytes operatorData);
130     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
131     event Burned(address indexed operator, address indexed from, uint256 amount, bytes userData, bytes operatorData);
132     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
133     event RevokedOperator(address indexed operator, address indexed tokenHolder);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 
136     uint256 public totalSupply = 0;
137     uint256 public constant maxSupply = 21000000e18;
138 
139 
140     // ------- ERC777/ERC965 Implementation ----------
141 
142     /**
143     * @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient
144     * @param _to The address of the recipient
145     * @param _amount The number of tokens to be sent
146     * @param _userData Data generated by the user to be sent to the recipient
147     */
148     function send(address _to, uint256 _amount, bytes _userData) public {
149         doSend(msg.sender, _to, _amount, _userData, msg.sender, "", true);
150     }
151 
152     /**
153     * @dev transfer token for a specified address via cheque
154     * @param _to The address to transfer to
155     * @param _amount The amount to be transferred
156     * @param _userData The data to be executed
157     * @param _nonce Unique nonce to avoid double spendings
158     */
159     function sendByCheque(address _to, uint256 _amount, bytes _userData, uint256 _nonce, uint8 v, bytes32 r, bytes32 s) public {
160         require(_to != address(this));
161 
162         // Check if signature is valid, get signer's address and mark this cheque as used.
163         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
164         bytes32 hash = keccak256(prefix, keccak256(_to, _amount, _userData, _nonce));
165         // bytes32 hash = keccak256(_to, _amount, _userData, _nonce);
166 
167         address signer = ecrecover(hash, v, r, s);
168         require (signer != 0);
169         require (!usedNonces[signer][_nonce]);
170         usedNonces[signer][_nonce] = true;
171 
172         // Transfer tokens
173         doSend(signer, _to, _amount, _userData, signer, "", true);
174     }
175 
176     /**
177     * @notice Authorize a third party `_operator` to manage (send) `msg.sender`'s tokens.
178     * @param _operator The operator that wants to be Authorized
179     */
180     function authorizeOperator(address _operator) public {
181         require(_operator != msg.sender);
182         isOperatorFor[_operator][msg.sender] = true;
183         emit AuthorizedOperator(_operator, msg.sender);
184     }
185 
186     /**
187     * @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
188     * @param _operator The operator that wants to be Revoked
189     */
190     function revokeOperator(address _operator) public {
191         require(_operator != msg.sender);
192         isOperatorFor[_operator][msg.sender] = false;
193         emit RevokedOperator(_operator, msg.sender);
194     }
195 
196     /**
197     * @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.
198     * @param _from The address holding the tokens being sent
199     * @param _to The address of the recipient
200     * @param _amount The number of tokens to be sent
201     * @param _userData Data generated by the user to be sent to the recipient
202     * @param _operatorData Data generated by the operator to be sent to the recipient
203     */
204     function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {
205         require(isOperatorFor[msg.sender][_from]);
206         doSend(_from, _to, _amount, _userData, msg.sender, _operatorData, true);
207     }
208 
209     /* -- Helper Functions -- */
210     /**
211     * @notice Internal function that ensures `_amount` is multiple of the granularity
212     * @param _amount The quantity that want's to be checked
213     */
214     function requireMultiple(uint256 _amount) internal pure {
215         require(_amount.div(granularity).mul(granularity) == _amount);
216     }
217 
218     /**
219     * @notice Check whether an address is a regular address or not.
220     * @param _addr Address of the contract that has to be checked
221     * @return `true` if `_addr` is a regular address (not a contract)
222     */
223     function isRegularAddress(address _addr) internal constant returns(bool) {
224         if (_addr == 0) { return false; }
225         uint size;
226         assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly
227         return size == 0;
228     }
229 
230     /**
231     * @notice Helper function that checks for ERC777TokensSender on the sender and calls it.
232     *  May throw according to `_preventLocking`
233     * @param _from The address holding the tokens being sent
234     * @param _to The address of the recipient
235     * @param _amount The amount of tokens to be sent
236     * @param _userData Data generated by the user to be passed to the recipient
237     * @param _operatorData Data generated by the operator to be passed to the recipient
238     *  implementing `ERC777TokensSender`.
239     *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
240     *  functions SHOULD set this parameter to `false`.
241     */
242     function callSender(
243         address _operator,
244         address _from,
245         address _to,
246         uint256 _amount,
247         bytes _userData,
248         bytes _operatorData
249     ) private {
250         address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");
251         if (senderImplementation != 0) {
252             ERC777TokensSender(senderImplementation).tokensToSend(
253                 _operator, _from, _to, _amount, _userData, _operatorData);
254         }
255     }
256 
257     /**
258     * @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.
259     *  May throw according to `_preventLocking`
260     * @param _from The address holding the tokens being sent
261     * @param _to The address of the recipient
262     * @param _amount The number of tokens to be sent
263     * @param _userData Data generated by the user to be passed to the recipient
264     * @param _operatorData Data generated by the operator to be passed to the recipient
265     * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
266     *  implementing `ERC777TokensRecipient`.
267     *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
268     *  functions SHOULD set this parameter to `false`.
269     */
270     function callRecipient(
271         address _operator,
272         address _from,
273         address _to,
274         uint256 _amount,
275         bytes _userData,
276         bytes _operatorData,
277         bool _preventLocking
278     ) private {
279         address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");
280         if (recipientImplementation != 0) {
281             ERC777TokensRecipient(recipientImplementation).tokensReceived(
282                 _operator, _from, _to, _amount, _userData, _operatorData);
283         } else if (_preventLocking) {
284             require(isRegularAddress(_to));
285         }
286     }
287 
288     /**
289     * @notice Helper function actually performing the sending of tokens.
290     * @param _from The address holding the tokens being sent
291     * @param _to The address of the recipient
292     * @param _amount The number of tokens to be sent
293     * @param _userData Data generated by the user to be passed to the recipient
294     * @param _operatorData Data generated by the operator to be passed to the recipient
295     * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not
296     *  implementing `erc777_tokenHolder`.
297     *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer
298     *  functions SHOULD set this parameter to `false`.
299     */
300     function doSend(
301         address _from,
302         address _to,
303         uint256 _amount,
304         bytes _userData,
305         address _operator,
306         bytes _operatorData,
307         bool _preventLocking
308     )
309         private
310     {
311         requireMultiple(_amount);
312 
313         callSender(_operator, _from, _to, _amount, _userData, _operatorData);
314 
315         require(_to != 0x0);                  // forbid sending to 0x0 (=burning)
316         require(balanceOf[_from] >= _amount); // ensure enough funds
317 
318         balanceOf[_from] = balanceOf[_from].sub(_amount);
319         balanceOf[_to] = balanceOf[_to].add(_amount);
320 
321         callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);
322 
323         emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
324         emit Transfer(_from, _to, _amount);
325     }
326 
327     // ------- ERC20 Implementation ----------
328 
329     /**
330      * @dev transfer token for a specified address
331      * @param _to The address to transfer to.
332      * @param _value The amount to be transferred.
333      */
334     function transfer(address _to, uint256 _value) public returns (bool) {
335         doSend(msg.sender, _to, _value, "", msg.sender, "", false);
336         return true;
337     }
338 
339     /**
340      * @dev Transfer tokens from one address to another. Technically this is not ERC20 transferFrom but more ERC777 operatorSend.
341      * @param _from address The address which you want to send tokens from
342      * @param _to address The address which you want to transfer to
343      * @param _value uint256 the amount of tokens to be transferred
344      */
345     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
346         require(isOperatorFor[msg.sender][_from]);
347         doSend(_from, _to, _value, "", msg.sender, "", true);
348         emit Transfer(_from, _to, _value);
349         return true;
350     }
351 
352     /**
353 
354      * @dev Originally in ERC20 this function to check the amount of tokens that an owner allowed to a spender.
355      *
356      * Function was added purly for backward compatibility with ERC20. Use operator logic from ERC777 instead.
357      * @param _owner address The address which owns the funds.
358      * @param _spender address The address which will spend the funds.
359      * @return A returning uint256 balanceOf _spender if it's active operator and 0 if not.
360      */
361     function allowance(address _owner, address _spender) public view returns (uint256 _amount) {
362         if (isOperatorFor[_spender][_owner]) {
363             _amount = balanceOf[_owner];
364         } else {
365             _amount = 0;
366         }
367     }
368 
369     /**
370      * @dev Approve the passed address to spend tokens on behalf of msg.sender.
371      *
372      * This function is more authorizeOperator and revokeOperator from ERC777 that Approve from ERC20.
373      * Approve concept has several issues (e.g. https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729),
374      * so I prefer to use operator concept. If you want to revoke approval, just put 0 into _value.
375      * @param _spender The address which will spend the funds.
376      * @param _value Fake value to be compatible with ERC20 requirements.
377      */
378     function approve(address _spender, uint256 _value) public returns (bool) {
379         require(_spender != msg.sender);
380 
381         if (_value > 0) {
382             // Authorizing operator
383             isOperatorFor[_spender][msg.sender] = true;
384             emit AuthorizedOperator(_spender, msg.sender);
385         } else {
386             // Revoking operator
387             isOperatorFor[_spender][msg.sender] = false;
388             emit RevokedOperator(_spender, msg.sender);
389         }
390 
391         emit Approval(msg.sender, _spender, _value);
392         return true;
393     }
394 
395     // ------- Minting and burning ----------
396 
397     /**
398     * @dev Function to mint tokens
399     * @param _to The address that will receive the minted tokens.
400     * @param _amount The amount of tokens to mint.
401     * @param _operatorData Data that will be passed to the recipient as a first transfer.
402     */
403     function mint(address _to, uint256 _amount, bytes _operatorData) public onlyOwner {
404         require (totalSupply.add(_amount) <= maxSupply);
405         requireMultiple(_amount);
406 
407         totalSupply = totalSupply.add(_amount);
408         balanceOf[_to] = balanceOf[_to].add(_amount);
409 
410         callRecipient(msg.sender, 0x0, _to, _amount, "", _operatorData, true);
411 
412         emit Minted(msg.sender, _to, _amount, _operatorData);
413         emit Transfer(0x0, _to, _amount);
414     }
415 
416     /**
417     * @dev Function to burn sender's tokens
418     * @param _amount The amount of tokens to burn.
419     * @return A boolean that indicates if the operation was successful.
420     */
421     function burn(uint256 _amount, bytes _userData) public {
422         require (_amount > 0);
423         require (balanceOf[msg.sender] >= _amount);
424         requireMultiple(_amount);
425 
426         callSender(msg.sender, msg.sender, 0x0, _amount, _userData, "");
427 
428         totalSupply = totalSupply.sub(_amount);
429         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
430 
431         emit Burned(msg.sender, msg.sender, _amount, _userData, "");
432         emit Transfer(msg.sender, 0x0, _amount);
433     }
434 
435 }