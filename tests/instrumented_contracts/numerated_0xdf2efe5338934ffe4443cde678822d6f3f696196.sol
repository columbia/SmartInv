1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33  * @title Owned
34  * @author Adria Massanet <adria@codecontext.io>
35  * @notice The Owned contract has an owner address, and provides basic
36  *  authorization control functions, this simplifies & the implementation of
37  *  user permissions; this contract has three work flows for a change in
38  *  ownership, the first requires the new owner to validate that they have the
39  *  ability to accept ownership, the second allows the ownership to be
40  *  directly transferred without requiring acceptance, and the third allows for
41  *  the ownership to be removed to allow for decentralization
42  */
43 contract Owned {
44 
45     address public owner;
46     address public newOwnerCandidate;
47 
48     event OwnershipRequested(address indexed by, address indexed to);
49     event OwnershipTransferred(address indexed from, address indexed to);
50     event OwnershipRemoved();
51 
52     /**
53      * @dev The constructor sets the `msg.sender` as the`owner` of the contract
54      */
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev `owner` is the only address that can call a function with this
61      * modifier
62      */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69      * @dev In this 1st option for ownership transfer `proposeOwnership()` must
70      *  be called first by the current `owner` then `acceptOwnership()` must be
71      *  called by the `newOwnerCandidate`
72      * @notice `onlyOwner` Proposes to transfer control of the contract to a
73      *  new owner
74      * @param _newOwnerCandidate The address being proposed as the new owner
75      */
76     function proposeOwnership(address _newOwnerCandidate) external onlyOwner {
77         newOwnerCandidate = _newOwnerCandidate;
78         emit OwnershipRequested(msg.sender, newOwnerCandidate);
79     }
80 
81     /**
82      * @notice Can only be called by the `newOwnerCandidate`, accepts the
83      *  transfer of ownership
84      */
85     function acceptOwnership() external {
86         require(msg.sender == newOwnerCandidate);
87 
88         address oldOwner = owner;
89         owner = newOwnerCandidate;
90         newOwnerCandidate = 0x0;
91 
92         emit OwnershipTransferred(oldOwner, owner);
93     }
94 
95     /**
96      * @dev In this 2nd option for ownership transfer `changeOwnership()` can
97      *  be called and it will immediately assign ownership to the `newOwner`
98      * @notice `owner` can step down and assign some other address to this role
99      * @param _newOwner The address of the new owner
100      */
101     function changeOwnership(address _newOwner) external onlyOwner {
102         require(_newOwner != 0x0);
103 
104         address oldOwner = owner;
105         owner = _newOwner;
106         newOwnerCandidate = 0x0;
107 
108         emit OwnershipTransferred(oldOwner, owner);
109     }
110 
111     /**
112      * @dev In this 3rd option for ownership transfer `removeOwnership()` can
113      *  be called and it will immediately assign ownership to the 0x0 address;
114      *  it requires a 0xdece be input as a parameter to prevent accidental use
115      * @notice Decentralizes the contract, this operation cannot be undone
116      * @param _dac `0xdac` has to be entered for this function to work
117      */
118     function removeOwnership(address _dac) external onlyOwner {
119         require(_dac == 0xdac);
120         owner = 0x0;
121         newOwnerCandidate = 0x0;
122         emit OwnershipRemoved();
123     }
124 }
125 
126 contract ERC820Registry {
127     function getManager(address addr) public view returns(address);
128     function setManager(address addr, address newManager) public;
129     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
130     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
131 }
132 
133 contract ERC820Implementer {
134     ERC820Registry public erc820Registry;
135 
136     constructor(address _registry) public {
137         erc820Registry = ERC820Registry(_registry);
138     }
139 
140     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
141         bytes32 ifaceHash = keccak256(ifaceLabel);
142         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
143     }
144 
145     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
146         bytes32 ifaceHash = keccak256(ifaceLabel);
147         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
148     }
149 
150     function delegateManagement(address newManager) internal {
151         erc820Registry.setManager(this, newManager);
152     }
153 }
154 
155 /**
156  * @title Safe Guard Contract
157  * @author Panos
158  */
159 contract SafeGuard is Owned {
160 
161     event Transaction(address indexed destination, uint value, bytes data);
162 
163     /**
164      * @dev Allows owner to execute a transaction.
165      */
166     function executeTransaction(address destination, uint value, bytes data)
167     public
168     onlyOwner
169     {
170         require(externalCall(destination, value, data.length, data));
171         emit Transaction(destination, value, data);
172     }
173 
174     /**
175      * @dev call has been separated into its own function in order to take advantage
176      *  of the Solidity's code generator to produce a loop that copies tx.data into memory.
177      */
178     function externalCall(address destination, uint value, uint dataLength, bytes data)
179     private
180     returns (bool) {
181         bool result;
182         assembly { // solhint-disable-line no-inline-assembly
183         let x := mload(0x40)   // "Allocate" memory for output
184             // (0x40 is where "free memory" pointer is stored by convention)
185             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
186             result := call(
187             sub(gas, 34710), // 34710 is the value that solidity is currently emitting
188             // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
189             // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
190             destination,
191             value,
192             d,
193             dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
194             x,
195             0                  // Output is ignored, therefore the output size is zero
196             )
197         }
198         return result;
199     }
200 }
201 
202 /**
203  * @title ERC664 Standard Balances Contract
204  * @author chrisfranko
205  */
206 contract ERC664Balances is SafeGuard {
207     using SafeMath for uint256;
208 
209     uint256 public totalSupply;
210 
211     event BalanceAdj(address indexed module, address indexed account, uint amount, string polarity);
212     event ModuleSet(address indexed module, bool indexed set);
213 
214     mapping(address => bool) public modules;
215     mapping(address => uint256) public balances;
216     mapping(address => mapping(address => uint256)) public allowed;
217 
218     modifier onlyModule() {
219         require(modules[msg.sender]);
220         _;
221     }
222 
223     /**
224      * @notice Constructor to create ERC664Balances
225      * @param _initialAmount Database initial amount
226      */
227     constructor(uint256 _initialAmount) public {
228         balances[msg.sender] = _initialAmount;
229         totalSupply = _initialAmount;
230     }
231 
232     /**
233      * @notice Set allowance of `_spender` in behalf of `_sender` at `_value`
234      * @param _sender Owner account
235      * @param _spender Spender account
236      * @param _value Value to approve
237      * @return Operation status
238      */
239     function setApprove(address _sender, address _spender, uint256 _value) external onlyModule returns (bool) {
240         allowed[_sender][_spender] = _value;
241         return true;
242     }
243 
244     /**
245      * @notice Decrease allowance of `_spender` in behalf of `_from` at `_value`
246      * @param _from Owner account
247      * @param _spender Spender account
248      * @param _value Value to decrease
249      * @return Operation status
250      */
251     function decApprove(address _from, address _spender, uint _value) external onlyModule returns (bool) {
252         allowed[_from][_spender] = allowed[_from][_spender].sub(_value);
253         return true;
254     }
255 
256     /**
257     * @notice Increase total supply by `_val`
258     * @param _val Value to increase
259     * @return Operation status
260     */
261     function incTotalSupply(uint _val) external onlyOwner returns (bool) {
262         totalSupply = totalSupply.add(_val);
263         return true;
264     }
265 
266     /**
267      * @notice Decrease total supply by `_val`
268      * @param _val Value to decrease
269      * @return Operation status
270      */
271     function decTotalSupply(uint _val) external onlyOwner returns (bool) {
272         totalSupply = totalSupply.sub(_val);
273         return true;
274     }
275 
276     /**
277      * @notice Set/Unset `_acct` as an authorized module
278      * @param _acct Module address
279      * @param _set Module set status
280      * @return Operation status
281      */
282     function setModule(address _acct, bool _set) external onlyOwner returns (bool) {
283         modules[_acct] = _set;
284         emit ModuleSet(_acct, _set);
285         return true;
286     }
287 
288     /**
289      * @notice Get `_acct` balance
290      * @param _acct Target account to get balance.
291      * @return The account balance
292      */
293     function getBalance(address _acct) external view returns (uint256) {
294         return balances[_acct];
295     }
296 
297     /**
298      * @notice Get allowance of `_spender` in behalf of `_owner`
299      * @param _owner Owner account
300      * @param _spender Spender account
301      * @return Allowance
302      */
303     function getAllowance(address _owner, address _spender) external view returns (uint256) {
304         return allowed[_owner][_spender];
305     }
306 
307     /**
308      * @notice Get if `_acct` is an authorized module
309      * @param _acct Module address
310      * @return Operation status
311      */
312     function getModule(address _acct) external view returns (bool) {
313         return modules[_acct];
314     }
315 
316     /**
317      * @notice Get total supply
318      * @return Total supply
319      */
320     function getTotalSupply() external view returns (uint256) {
321         return totalSupply;
322     }
323 
324     /**
325      * @notice Increment `_acct` balance by `_val`
326      * @param _acct Target account to increment balance.
327      * @param _val Value to increment
328      * @return Operation status
329      */
330     function incBalance(address _acct, uint _val) public onlyModule returns (bool) {
331         balances[_acct] = balances[_acct].add(_val);
332         emit BalanceAdj(msg.sender, _acct, _val, "+");
333         return true;
334     }
335 
336     /**
337      * @notice Decrement `_acct` balance by `_val`
338      * @param _acct Target account to decrement balance.
339      * @param _val Value to decrement
340      * @return Operation status
341      */
342     function decBalance(address _acct, uint _val) public onlyModule returns (bool) {
343         balances[_acct] = balances[_acct].sub(_val);
344         emit BalanceAdj(msg.sender, _acct, _val, "-");
345         return true;
346     }
347 }
348 
349 /**
350  * @title ERC664 Database Contract
351  * @author Panos
352  */
353 contract CStore is ERC664Balances, ERC820Implementer {
354 
355     mapping(address => mapping(address => bool)) private mAuthorized;
356 
357     /**
358      * @notice Database construction
359      * @param _totalSupply The total supply of the token
360      * @param _registry The ERC820 Registry Address
361      */
362     constructor(uint256 _totalSupply, address _registry) public
363     ERC664Balances(_totalSupply)
364     ERC820Implementer(_registry) {
365         setInterfaceImplementation("ERC664Balances", this);
366     }
367 
368     /**
369      * @notice Increase total supply by `_val`
370      * @param _val Value to increase
371      * @return Operation status
372      */
373     // solhint-disable-next-line no-unused-vars
374     function incTotalSupply(uint _val) external onlyOwner returns (bool) {
375         return false;
376     }
377 
378     /**
379      * @notice Decrease total supply by `_val`
380      * @param _val Value to decrease
381      * @return Operation status
382      */
383     // solhint-disable-next-line no-unused-vars
384     function decTotalSupply(uint _val) external onlyOwner returns (bool) {
385         return false;
386     }
387 
388     /**
389      * @notice moving `_amount` from `_from` to `_to`
390      * @param _from The sender address
391      * @param _to The receiving address
392      * @param _amount The moving amount
393      * @return bool The move result
394      */
395     function move(address _from, address _to, uint256 _amount) external
396     onlyModule
397     returns (bool) {
398         balances[_from] = balances[_from].sub(_amount);
399         emit BalanceAdj(msg.sender, _from, _amount, "-");
400         balances[_to] = balances[_to].add(_amount);
401         emit BalanceAdj(msg.sender, _to, _amount, "+");
402         return true;
403     }
404 
405     /**
406      * @notice Setting operator `_operator` for `_tokenHolder`
407      * @param _operator The operator to set status
408      * @param _tokenHolder The token holder to set operator
409      * @param _status The operator status
410      * @return bool Status of operation
411      */
412     function setOperator(address _operator, address _tokenHolder, bool _status) external
413     onlyModule
414     returns (bool) {
415         mAuthorized[_operator][_tokenHolder] = _status;
416         return true;
417     }
418 
419     /**
420      * @notice Getting operator `_operator` for `_tokenHolder`
421      * @param _operator The operator address to get status
422      * @param _tokenHolder The token holder address
423      * @return bool Operator status
424      */
425     function getOperator(address _operator, address _tokenHolder) external
426     view
427     returns (bool) {
428         return mAuthorized[_operator][_tokenHolder];
429     }
430 
431     /**
432      * @notice Increment `_acct` balance by `_val`
433      * @param _acct Target account to increment balance.
434      * @param _val Value to increment
435      * @return Operation status
436      */
437     // solhint-disable-next-line no-unused-vars
438     function incBalance(address _acct, uint _val) public onlyModule returns (bool) {
439         return false;
440     }
441 
442     /**
443      * @notice Decrement `_acct` balance by `_val`
444      * @param _acct Target account to decrement balance.
445      * @param _val Value to decrement
446      * @return Operation status
447      */
448     // solhint-disable-next-line no-unused-vars
449     function decBalance(address _acct, uint _val) public onlyModule returns (bool) {
450         return false;
451     }
452 }