1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-16
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14     address public newOwner;
15 
16     event OwnershipTransferred(address previousOwner, address newOwner);
17 
18     /**
19     * @dev The Ownable constructor sets the original `owner` of the contract.
20     */
21     constructor(address _owner) public {
22         owner = _owner == address(0) ? msg.sender : _owner;
23     }
24 
25     /**
26     * @dev Throws if called by any account other than the owner.
27     */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     /**
34     * @dev Allows the current owner to transfer control of the contract to a newOwner.
35     * @param _newOwner The address to transfer ownership to.
36     */
37     function transferOwnership(address _newOwner) public onlyOwner {
38         require(_newOwner != owner);
39         newOwner = _newOwner;
40     }
41 
42     /**
43     * @dev confirm ownership by a new owner
44     */
45     function confirmOwnership() public {
46         require(msg.sender == newOwner);
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49         newOwner = 0x0;
50     }
51 }
52 
53 /**
54  * @title IERC20Token - ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract IERC20Token {
58     string public name;
59     string public symbol;
60     uint8 public decimals;
61     uint256 public totalSupply;
62 
63     function balanceOf(address _owner) public view returns (uint256 balance);
64     function transfer(address _to, uint256 _value)  public returns (bool success);
65     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
66     function approve(address _spender, uint256 _value)  public returns (bool success);
67     function allowance(address _owner, address _spender)  public view returns (uint256 remaining);
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 contract SafeMath {
78     /**
79     * @dev constructor
80     */
81     constructor() public {
82     }
83 
84     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a * b;
86         assert(a == 0 || c / a == b);
87         return c;
88     }
89 
90     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a / b;
92         return c;
93     }
94 
95     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
96         assert(a >= b);
97         return a - b;
98     }
99 
100     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         assert(c >= a);
103         return c;
104     }
105 }
106 
107 /**
108  * @title ERC20Token - ERC20 base implementation
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20Token is IERC20Token, SafeMath {
112     mapping (address => uint256) public balances;
113     mapping (address => mapping (address => uint256)) public allowed;
114 
115     function transfer(address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(balances[msg.sender] >= _value);
118 
119         balances[msg.sender] = safeSub(balances[msg.sender], _value);
120         balances[_to] = safeAdd(balances[_to], _value);
121         emit Transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
128 
129         balances[_to] = safeAdd(balances[_to], _value);
130         balances[_from] = safeSub(balances[_from], _value);
131         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
132         emit Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     function balanceOf(address _owner) public constant returns (uint256) {
137         return balances[_owner];
138     }
139 
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         allowed[msg.sender][_spender] = _value;
142         emit Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     function allowance(address _owner, address _spender) public constant returns (uint256) {
147         return allowed[_owner][_spender];
148     }
149 }
150 
151 /**
152  * @title ITokenEventListener
153  * @dev Interface which should be implemented by token listener
154  */
155 interface ITokenEventListener {
156     /**
157      * @dev Function is called after token transfer/transferFrom
158      * @param _from Sender address
159      * @param _to Receiver address
160      * @param _value Amount of tokens
161      */
162     function onTokenTransfer(address _from, address _to, uint256 _value) external;
163 }
164 
165 /**
166  * @title ManagedToken
167  * @dev ERC20 compatible token with issue and destroy facilities
168  * @dev All transfers can be monitored by token event listener
169  */
170 contract ManagedToken is ERC20Token, Ownable {
171     uint256 public totalIssue;                                                  //Total token issue
172     uint256 public totalSupply;
173     bool public allowTransfers = false;                                         //Default not transfer
174     bool public issuanceFinished = false;                                       //Finished issuance
175 
176     ITokenEventListener public eventListener;                                   //Listen events
177 
178     event AllowTransfersChanged(bool _newState);                                //Event:
179     event Issue(address indexed _to, uint256 _value);                           //Event: Issue
180     event Destroy(address indexed _from, uint256 _value);                       //Event:
181     event IssuanceFinished(bool _issuanceFinished);                             //Event: Finished issuance
182 
183     //Modifier: Allow all transfer if not any condition
184     modifier transfersAllowed() {
185         require(allowTransfers);
186         _;
187     }
188 
189     //Modifier: Allow continue to issue
190     modifier canIssue() {
191         require(!issuanceFinished);
192         _;
193     }
194 
195     /**
196      * @dev ManagedToken constructor
197      * @param _listener Token listener(address can be 0x0)
198      * @param _owner Owner of contract(address can be 0x0)
199      */
200     constructor(address _listener, address _owner) public Ownable(_owner) {
201         if(_listener != address(0)) {
202             eventListener = ITokenEventListener(_listener);
203         }
204     }
205 
206     /**
207      * @dev Enable/disable token transfers. Can be called only by owners
208      * @param _allowTransfers True - allow False - disable
209      */
210     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
211         allowTransfers = _allowTransfers;
212 
213         //Call event
214         emit AllowTransfersChanged(_allowTransfers);
215     }
216 
217     /**
218      * @dev Set/remove token event listener
219      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
220      */
221     function setListener(address _listener) public onlyOwner {
222         if(_listener != address(0)) {
223             eventListener = ITokenEventListener(_listener);
224         } else {
225             delete eventListener;
226         }
227     }
228     
229     /**
230      * @dev Destroy tokens on specified address (Called byallowance owner or token holder)
231      * @dev Fund contract address must be in the list of owners to burn token during refund
232      * @param _from Wallet address
233      * @param _value Amount of tokens to destroy
234      */
235     function destroy(address _from, uint256 _value) external onlyOwner {
236         require(balances[_from] >= _value, "Value of destroy is not greater balance of address wallet");
237 
238         totalIssue = safeSub(totalIssue, _value);
239         totalSupply = safeSub(totalSupply, _value);
240         balances[_from] = safeSub(balances[_from], _value);
241 
242         emit Transfer(_from, address(0), _value);
243         //Call event
244         emit Destroy(_from, _value);
245     }
246 
247     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
248         bool success = super.transfer(_to, _value);
249         /* if(hasListener() && success) {
250             eventListener.onTokenTransfer(msg.sender, _to, _value);
251         } */
252         return success;
253     }
254 
255     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
256         bool success = super.transferFrom(_from, _to, _value);
257 
258         //If has Listenser and transfer success
259         /* if(hasListener() && success) {
260             //Call event listener
261             eventListener.onTokenTransfer(_from, _to, _value);
262         } */
263         return success;
264     }
265 
266     function hasListener() internal view returns(bool) {
267         if(eventListener == address(0)) {
268             return false;
269         }
270         return true;
271     }
272 
273     /**
274      * @dev Issue tokens to specified wallet
275      * @param _to Wallet address
276      * @param _value Amount of tokens
277      */
278     function issue(address _to, uint256 _value) external onlyOwner canIssue {
279         totalIssue = safeAdd(totalIssue, _value);
280         require(totalSupply >= totalIssue, "Total issue is not greater total of supply");
281         balances[_to] = safeAdd(balances[_to], _value);
282         //Call event
283         emit Issue(_to, _value);
284         emit Transfer(address(0), _to, _value);
285     }
286 
287     /**
288      * @dev Increase the amount of tokens that an owner allowed to a spender.
289      *
290      * approve should be called when allowed[_spender] == 0. To increment
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From OpenZeppelin StandardToken.sol
294      * @param _spender The address which will spend the funds.
295      * @param _addedValue The amount of tokens to increase the allowance by.
296      */
297     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
298         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
299         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300         return true;
301     }
302 
303     /**
304      * @dev Decrease the amount of tokens that an owner allowed to a spender.
305      *
306      * approve should be called when allowed[_spender] == 0. To decrement
307      * allowed value is better to use this function to avoid 2 calls (and wait until
308      * the first transaction is mined)
309      * From OpenZeppelin StandardToken.sol
310      * @param _spender The address which will spend the funds.
311      * @param _subtractedValue The amount of tokens to decrease the allowance by.
312      */
313     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
314         uint oldValue = allowed[msg.sender][_spender];
315         if (_subtractedValue > oldValue) {
316             allowed[msg.sender][_spender] = 0;
317         } else {
318             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
319         }
320         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321         return true;
322     }
323 
324     /**
325      * @dev Finish token issuance
326      * @return True if success
327      */
328     function setAllowIssuance(bool _issuanceFinished) public onlyOwner returns (bool) {
329         issuanceFinished = _issuanceFinished;
330         //Call event
331         emit IssuanceFinished(_issuanceFinished);
332         return true;
333     }
334 }
335 
336 /**
337  * KCT Token Contract
338  * @title Kct
339  */
340 contract KCT is ManagedToken {
341     /**
342      * @dev Char constructor
343      */
344     constructor() public ManagedToken(msg.sender, msg.sender) {
345         name = "KCT";
346         symbol = "KCT";
347         decimals = 18;
348         totalIssue = 0;
349         totalSupply = 130000000 ether;                                         //The maximum number of tokens is unchanged and totals will decrease after issue
350     }
351 
352     function issue(address _to, uint256 _value) external onlyOwner canIssue {
353         totalIssue = safeAdd(totalIssue, _value);
354         require(totalSupply >= totalIssue, "Total issue is not greater total of supply");
355 
356         balances[_to] = safeAdd(balances[_to], _value);
357         //Call event
358         emit Issue(_to, _value);
359         emit Transfer(address(0), _to, _value);
360     }
361 }