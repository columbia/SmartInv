1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-29
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 library SafeMath{
8       /**
9      * Returns the addition of two unsigned integers, reverting on
10      * overflow.
11      *
12      * - Addition cannot overflow.
13      */
14      function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, errorMessage);
17 
18         return c;
19     }
20 
21       /**
22      * Returns the subtraction of two unsigned integers, reverting with custom message on
23      * overflow (when the result is negative).
24      *
25      * - Subtraction cannot overflow.
26      *
27      */
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 }
35 
36 contract owned {
37     address public owner;
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner,"ERC20: Required Owner !");
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         require (newOwner != address(0),"ERC20 New Owner cannot be zero address");
50         owner = newOwner;
51     }
52 }
53 
54 interface tokenRecipient {  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external ; }
55 
56 contract TOKENERC20 {
57     
58     using SafeMath for uint256;
59 
60     // Public variables of the token
61     string public name;
62     string public symbol;
63     uint8 public decimals = 18;
64     // 18 decimals is the strongly suggested default, avoid changing it
65     uint256 public totalSupply;
66 
67     /* This generates a public event on the blockchain that will notify clients */
68 
69    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71     constructor(
72         uint256 initialSupply,
73         string memory tokenName,
74         string memory tokenSymbol
75     ) public {
76         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
78         name = tokenName;                                   // Set the name for display purposes
79         symbol = tokenSymbol;                               // Set the symbol for display purposes
80     }
81     // This creates an array with all balances
82     mapping (address => uint256) public balanceOf;
83     mapping (address => mapping (address => uint256)) private _allowance;
84     mapping (address => bool) public LockList;
85     mapping (address => uint256) public LockedTokens;
86 
87     // This generates a public event on the blockchain that will notify clients
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     // This notifies clients about the amount burnt
91     event Burn(address indexed from, uint256 value);
92 
93 
94     /* Internal transfer, only can be called by this contract */
95     function _transfer(address _from, address _to, uint256 _value) internal {
96         uint256 stage;
97         
98         require(_from != address(0), "ERC20: transfer from the zero address");
99         require(_to != address(0), "ERC20: transfer to the zero address");       // Prevent transfer to 0x0 address. Use burn() instead
100 
101         require (LockList[msg.sender] == false,"ERC20: Caller Locked !");            // Check if msg.sender is locked or not
102         require (LockList[_from] == false, "ERC20: Sender Locked !");
103         require (LockList[_to] == false,"ERC20: Receipient Locked !");
104 
105        // Check if sender balance is locked 
106         stage=balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
107         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
108         
109         //Deduct and add balance
110         balanceOf[_from]=stage;
111         balanceOf[_to]=balanceOf[_to].add(_value,"ERC20: Addition overflow");
112 
113         //emit Transfer event
114         emit Transfer(_from, _to, _value);
115 
116     }
117     
118     /**
119      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
120      *
121      * This is internal function is equivalent to `approve`, and can be used to
122      * e.g. set automatic allowances for certain subsystems, etc.
123      *
124      * Emits an {Approval} event.
125      *
126      * Requirements:
127      *
128      * - `owner` cannot be the zero address.
129      * - `spender` cannot be the zero address.
130      */
131     function _approve(address owner, address _spender, uint256 amount) internal {
132         require(owner != address(0), "ERC20: approve from the zero address");
133         require(_spender != address(0), "ERC20: approve to the zero address");
134 
135         _allowance[owner][_spender] = amount;
136         emit Approval(owner, _spender, amount);
137     }
138 
139     /**
140      * Transfer tokens
141      *
142      * Send `_value` tokens to `_to` from your account
143      *
144      * @param _to The address of the recipient
145      * @param _value the amount to send
146      */
147     function transfer(address _to, uint256 _value) public returns(bool){
148         _transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152 
153     function burn(uint256 _value) public returns(bool){
154         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
155         
156         uint256 stage;
157         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
158         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
159         
160         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
161         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
162         
163         emit Burn(msg.sender, _value);
164         emit Transfer(msg.sender, address(0), _value);
165 
166         return true;
167     }
168     
169      /**
170      * Destroy tokens
171      *
172      * Remove `_value` tokens from the system irreversibly
173      *
174      * @param Account address
175      *
176      * @param _value the amount of money to burn
177      * 
178      * Safely check if total supply is not overdrawn
179      */
180     function burnFrom(address Account, uint256 _value) public returns (bool success) {
181 
182         uint256 stage;
183         require(Account != address(0), "ERC20: Burn from the zero address");
184         
185         //Safely substract amount to be burned from callers allowance
186         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
187         
188         //Do not allow burn if Accounts tokens are locked.
189         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
190         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
191         balanceOf[Account] =stage ;            // Subtract from the sender
192         
193         //Deduct burn amount from totalSupply
194         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
195        
196         emit Burn(Account, _value);
197         emit Transfer(Account, address(0), _value);
198 
199         return true;
200     }
201     
202     
203  /**
204      * Transfer tokens from other address
205      *
206      * Send `_value` tokens to `_to` on behalf of `_from`
207      *
208      * @param _from The address of the sender
209      * @param _to The address of the recipient
210      * @param _value the amount to send
211      */
212   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
213         
214         _transfer(_from, _to, _value);
215         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
216         
217         return true;
218     }
219 
220 
221     /**
222      * Set allowance for other address
223      *
224      * Allows `_spender` to spend no more than `_value` tokens in your behalf
225      * Emits Approval Event
226      * @param _spender The address authorized to spend
227      * @param _value the max amount they can spend
228      */
229     function approve(address _spender, uint256 _value) public
230         returns (bool success) {
231         uint256 unapprovbal;
232 
233         // Do not allow approval if amount exceeds locked amount
234         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
235         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
236        
237        
238         _allowance[msg.sender][_spender] = _value;
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242 
243     /**
244      * Set allowance for other address and notify
245      *
246      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
247      *
248      * @param _spender The address authorized to spend
249      * @param _value the max amount they can spend
250      * @param _extraData some extra information to send to the approved contract
251      */
252     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
253         public
254         returns (bool success) {
255         tokenRecipient spender = tokenRecipient(_spender);
256         if (approve(_spender, _value)) {
257             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
258             return true;
259         }
260     }
261     
262     function allowance(address _owner,address _spender) public view returns(uint256){
263         return _allowance[_owner][_spender];
264     }
265    
266 }
267 
268 
269 
270 contract Dolla is owned, TOKENERC20 {
271 
272     /* Initializes contract with initial supply tokens to the creator of the contract */
273     constructor () TOKENERC20(
274         1000000000 * 1 ** uint256(decimals),
275     "Dolla",
276     "DLA") public {
277     }
278     
279    
280      /**
281      * User Lock
282      *
283      * @param Account the address of account to lock for transaction
284      *
285      * @param mode true or false for lock mode
286      * 
287      */
288     function UserLock(address Account, bool mode) onlyOwner public {
289         LockList[Account] = mode;
290     }
291      /**
292      * Lock tokens
293      *
294      * @param Account the address of account to lock
295      * 
296      * @param amount the amount of money to lock
297      * 
298      * 
299      */
300    function LockTokens(address Account, uint256 amount) onlyOwner public{
301        LockedTokens[Account]=amount;
302    }
303    
304     function UnLockTokens(address Account) onlyOwner public{
305        LockedTokens[Account]=0;
306    }
307    
308 
309 }