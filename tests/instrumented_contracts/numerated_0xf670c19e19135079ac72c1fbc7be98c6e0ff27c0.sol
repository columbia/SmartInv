1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10     address public newOwner;
11 
12     event OwnershipTransferred(address previousOwner, address newOwner);
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract.
16     */
17     constructor(address _owner) public {
18         owner = _owner == address(0) ? msg.sender : _owner;
19     }
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param _newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address _newOwner) public onlyOwner {
34         require(_newOwner != owner);
35         newOwner = _newOwner;
36     }
37 
38     /**
39     * @dev confirm ownership by a new owner
40     */
41     function confirmOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = 0x0;
46     }
47 }
48 
49 /**
50  * @title IERC20Token - ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract IERC20Token {
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58 
59     function balanceOf(address _owner) public view returns (uint256 balance);
60     function transfer(address _to, uint256 _value)  public returns (bool success);
61     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
62     function approve(address _spender, uint256 _value)  public returns (bool success);
63     function allowance(address _owner, address _spender)  public view returns (uint256 remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 contract SafeMath {
74     /**
75     * @dev constructor
76     */
77     constructor() public {
78     }
79 
80     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a * b;
82         assert(a == 0 || c / a == b);
83         return c;
84     }
85 
86     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a / b;
88         return c;
89     }
90 
91     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
92         assert(a >= b);
93         return a - b;
94     }
95 
96     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 }
102 
103 /**
104  * @title ERC20Token - ERC20 base implementation
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20Token is IERC20Token, SafeMath {
108     mapping (address => uint256) public balances;
109     mapping (address => mapping (address => uint256)) public allowed;
110 
111     function transfer(address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(balances[msg.sender] >= _value);
114 
115         balances[msg.sender] = safeSub(balances[msg.sender], _value);
116         balances[_to] = safeAdd(balances[_to], _value);
117         emit Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
124 
125         balances[_to] = safeAdd(balances[_to], _value);
126         balances[_from] = safeSub(balances[_from], _value);
127         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     function balanceOf(address _owner) public constant returns (uint256) {
133         return balances[_owner];
134     }
135 
136     function approve(address _spender, uint256 _value) public returns (bool) {
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public constant returns (uint256) {
143         return allowed[_owner][_spender];
144     }
145 }
146 
147 /**
148  * @title ITokenEventListener
149  * @dev Interface which should be implemented by token listener
150  */
151 interface ITokenEventListener {
152     /**
153      * @dev Function is called after token transfer/transferFrom
154      * @param _from Sender address
155      * @param _to Receiver address
156      * @param _value Amount of tokens
157      */
158     function onTokenTransfer(address _from, address _to, uint256 _value) external;
159 }
160 
161 /**
162  * @title ManagedToken
163  * @dev ERC20 compatible token with issue and destroy facilities
164  * @dev All transfers can be monitored by token event listener
165  */
166 contract ManagedToken is ERC20Token, Ownable {
167     uint256 public totalIssue;                                                  //Total token issue
168     bool public allowTransfers = false;                                         //Default not transfer
169     bool public issuanceFinished = false;                                       //Finished issuance
170 
171     ITokenEventListener public eventListener;                                   //Listen events
172 
173     event AllowTransfersChanged(bool _newState);                                //Event:
174     event Issue(address indexed _to, uint256 _value);                           //Event: Issue
175     event Destroy(address indexed _from, uint256 _value);                       //Event:
176     event IssuanceFinished(bool _issuanceFinished);                             //Event: Finished issuance
177 
178     //Modifier: Allow all transfer if not any condition
179     modifier transfersAllowed() {
180         require(allowTransfers);
181         _;
182     }
183 
184     //Modifier: Allow continue to issue
185     modifier canIssue() {
186         require(!issuanceFinished);
187         _;
188     }
189 
190     /**
191      * @dev ManagedToken constructor
192      * @param _listener Token listener(address can be 0x0)
193      * @param _owner Owner of contract(address can be 0x0)
194      */
195     constructor(address _listener, address _owner) public Ownable(_owner) {
196         if(_listener != address(0)) {
197             eventListener = ITokenEventListener(_listener);
198         }
199     }
200 
201     /**
202      * @dev Enable/disable token transfers. Can be called only by owners
203      * @param _allowTransfers True - allow False - disable
204      */
205     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
206         allowTransfers = _allowTransfers;
207 
208         //Call event
209         emit AllowTransfersChanged(_allowTransfers);
210     }
211 
212     /**
213      * @dev Set/remove token event listener
214      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
215      */
216     function setListener(address _listener) public onlyOwner {
217         if(_listener != address(0)) {
218             eventListener = ITokenEventListener(_listener);
219         } else {
220             delete eventListener;
221         }
222     }
223 
224     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
225         bool success = super.transfer(_to, _value);
226         /* if(hasListener() && success) {
227             eventListener.onTokenTransfer(msg.sender, _to, _value);
228         } */
229         return success;
230     }
231 
232     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
233         bool success = super.transferFrom(_from, _to, _value);
234 
235         //If has Listenser and transfer success
236         /* if(hasListener() && success) {
237             //Call event listener
238             eventListener.onTokenTransfer(_from, _to, _value);
239         } */
240         return success;
241     }
242 
243     function hasListener() internal view returns(bool) {
244         if(eventListener == address(0)) {
245             return false;
246         }
247         return true;
248     }
249 
250     /**
251      * @dev Issue tokens to specified wallet
252      * @param _to Wallet address
253      * @param _value Amount of tokens
254      */
255     function issue(address _to, uint256 _value) external onlyOwner canIssue {
256         totalIssue = safeAdd(totalIssue, _value);
257         require(totalSupply >= totalIssue, "Total issue is not greater total of supply");
258         balances[_to] = safeAdd(balances[_to], _value);
259         //Call event
260         emit Issue(_to, _value);
261         emit Transfer(address(0), _to, _value);
262     }
263 
264     /**
265      * @dev Increase the amount of tokens that an owner allowed to a spender.
266      *
267      * approve should be called when allowed[_spender] == 0. To increment
268      * allowed value is better to use this function to avoid 2 calls (and wait until
269      * the first transaction is mined)
270      * From OpenZeppelin StandardToken.sol
271      * @param _spender The address which will spend the funds.
272      * @param _addedValue The amount of tokens to increase the allowance by.
273      */
274     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
275         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
276         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277         return true;
278     }
279 
280     /**
281      * @dev Decrease the amount of tokens that an owner allowed to a spender.
282      *
283      * approve should be called when allowed[_spender] == 0. To decrement
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From OpenZeppelin StandardToken.sol
287      * @param _spender The address which will spend the funds.
288      * @param _subtractedValue The amount of tokens to decrease the allowance by.
289      */
290     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
291         uint oldValue = allowed[msg.sender][_spender];
292         if (_subtractedValue > oldValue) {
293             allowed[msg.sender][_spender] = 0;
294         } else {
295             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
296         }
297         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298         return true;
299     }
300 
301     /**
302      * @dev Finish token issuance
303      * @return True if success
304      */
305     function setAllowIssuance(bool _issuanceFinished) public onlyOwner returns (bool) {
306         issuanceFinished = _issuanceFinished;
307         //Call event
308         emit IssuanceFinished(_issuanceFinished);
309         return true;
310     }
311 }
312 
313 /**
314  * Char Token Contract
315  * @title Char
316  */
317 contract Char is ManagedToken {
318     /**
319      * @dev Char constructor
320      */
321     constructor() public ManagedToken(msg.sender, msg.sender) {
322         name = "Char";
323         symbol = "Char";
324         decimals = 18;
325         totalIssue = 0;
326         totalSupply = 5000000000 ether;                                         //The maximum number of tokens is unchanged and totals will decrease after issue
327     }
328 
329     function issue(address _to, uint256 _value) external onlyOwner canIssue {
330         totalIssue = safeAdd(totalIssue, _value);
331         require(totalSupply >= totalIssue, "Total issue is not greater total of supply");
332 
333         balances[_to] = safeAdd(balances[_to], _value);
334         //Call event
335         emit Issue(_to, _value);
336         emit Transfer(address(0), _to, _value);
337     }
338 }