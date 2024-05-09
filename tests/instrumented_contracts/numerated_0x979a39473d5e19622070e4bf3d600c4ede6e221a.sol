1 pragma solidity ^0.5.0;
2 
3 library SafeMath{
4       /**
5      * Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * - Addition cannot overflow.
9      */
10      function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, errorMessage);
13 
14         return c;
15     }
16 
17       /**
18      * Returns the subtraction of two unsigned integers, reverting with custom message on
19      * overflow (when the result is negative).
20      *
21      * - Subtraction cannot overflow.
22      *
23      */
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 }
31 
32 contract owned {
33     address public owner;
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner,"ERC20: Required Owner !");
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner public {
45         require (newOwner != address(0),"ERC20 New Owner cannot be zero address");
46         owner = newOwner;
47     }
48 }
49 
50 interface tokenRecipient {  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external ; }
51 
52 contract TOKENERC20 {
53     
54     using SafeMath for uint256;
55 
56     // Public variables of the token
57     string public name;
58     string public symbol;
59     uint8 public decimals = 18;
60     // 18 decimals is the strongly suggested default, avoid changing it
61     uint256 public totalSupply;
62 
63     /* This generates a public event on the blockchain that will notify clients */
64 
65    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67     constructor(
68         uint256 initialSupply,
69         string memory tokenName,
70         string memory tokenSymbol
71     ) public {
72         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
73         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76     }
77     // This creates an array with all balances
78     mapping (address => uint256) public balanceOf;
79     mapping (address => mapping (address => uint256)) private _allowance;
80     mapping (address => bool) public LockList;
81     mapping (address => uint256) public LockedTokens;
82 
83     // This generates a public event on the blockchain that will notify clients
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     // This notifies clients about the amount burnt
87     event Burn(address indexed from, uint256 value);
88 
89 
90     /* Internal transfer, only can be called by this contract */
91     function _transfer(address _from, address _to, uint256 _value) internal {
92         uint256 stage;
93         
94         require(_from != address(0), "ERC20: transfer from the zero address");
95         require(_to != address(0), "ERC20: transfer to the zero address");       // Prevent transfer to 0x0 address. Use burn() instead
96 
97         require (LockList[msg.sender] == false,"ERC20: Caller Locked !");            // Check if msg.sender is locked or not
98         require (LockList[_from] == false, "ERC20: Sender Locked !");
99         require (LockList[_to] == false,"ERC20: Receipient Locked !");
100 
101        // Check if sender balance is locked 
102         stage=balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
103         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
104         
105         //Deduct and add balance
106         balanceOf[_from]=stage;
107         balanceOf[_to]=balanceOf[_to].add(_value,"ERC20: Addition overflow");
108 
109         //emit Transfer event
110         emit Transfer(_from, _to, _value);
111 
112     }
113     
114     /**
115      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
116      *
117      * This is internal function is equivalent to `approve`, and can be used to
118      * e.g. set automatic allowances for certain subsystems, etc.
119      *
120      * Emits an {Approval} event.
121      *
122      * Requirements:
123      *
124      * - `owner` cannot be the zero address.
125      * - `spender` cannot be the zero address.
126      */
127     function _approve(address owner, address _spender, uint256 amount) internal {
128         require(owner != address(0), "ERC20: approve from the zero address");
129         require(_spender != address(0), "ERC20: approve to the zero address");
130 
131         _allowance[owner][_spender] = amount;
132         emit Approval(owner, _spender, amount);
133     }
134 
135     /**
136      * Transfer tokens
137      *
138      * Send `_value` tokens to `_to` from your account
139      *
140      * @param _to The address of the recipient
141      * @param _value the amount to send
142      */
143     function transfer(address _to, uint256 _value) public returns(bool){
144         _transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148 
149     function burn(uint256 _value) public returns(bool){
150         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
151         
152         uint256 stage;
153         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
154         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
155         
156         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
157         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
158         
159         emit Burn(msg.sender, _value);
160         emit Transfer(msg.sender, address(0), _value);
161 
162         return true;
163     }
164     
165      /**
166      * Destroy tokens
167      *
168      * Remove `_value` tokens from the system irreversibly
169      *
170      * @param Account address
171      *
172      * @param _value the amount of money to burn
173      * 
174      * Safely check if total supply is not overdrawn
175      */
176     function burnFrom(address Account, uint256 _value) public returns (bool success) {
177         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
178         require (LockList[Account] == false,"ERC20: Owner Locked !");    
179         uint256 stage;
180         require(Account != address(0), "ERC20: Burn from the zero address");
181         
182         //Safely substract amount to be burned from callers allowance
183         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
184         
185         //Do not allow burn if Accounts tokens are locked.
186         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
187         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
188         balanceOf[Account] =stage ;            // Subtract from the sender
189         
190         //Deduct burn amount from totalSupply
191         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
192        
193         emit Burn(Account, _value);
194         emit Transfer(Account, address(0), _value);
195 
196         return true;
197     }
198     
199     
200  /**
201      * Transfer tokens from other address
202      *
203      * Send `_value` tokens to `_to` on behalf of `_from`
204      *
205      * @param _from The address of the sender
206      * @param _to The address of the recipient
207      * @param _value the amount to send
208      */
209   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
210         
211         _transfer(_from, _to, _value);
212         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
213         
214         return true;
215     }
216 
217 
218     /**
219      * Set allowance for other address
220      *
221      * Allows `_spender` to spend no more than `_value` tokens in your behalf
222      * Emits Approval Event
223      * @param _spender The address authorized to spend
224      * @param _value the max amount they can spend
225      */
226     function approve(address _spender, uint256 _value) public
227         returns (bool success) {
228         uint256 unapprovbal;
229 
230         // Do not allow approval if amount exceeds locked amount
231         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
232         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
233        
234        
235         _allowance[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     /**
241      * Set allowance for other address and notify
242      *
243      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
244      *
245      * @param _spender The address authorized to spend
246      * @param _value the max amount they can spend
247      * @param _extraData some extra information to send to the approved contract
248      */
249     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
250         public
251         returns (bool success) {
252         tokenRecipient spender = tokenRecipient(_spender);
253         if (approve(_spender, _value)) {
254             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
255             return true;
256         }
257     }
258     
259     function allowance(address _owner,address _spender) public view returns(uint256){
260         return _allowance[_owner][_spender];
261     }
262    
263 }
264 
265 
266 
267 contract Aden is owned, TOKENERC20 {
268 
269     /* Initializes contract with initial supply tokens to the creator of the contract */
270     constructor () TOKENERC20(
271         100000000000 * 1 ** uint256(decimals),
272     "Aden",
273     "ADN    ") public {
274     }
275     
276    
277      /**
278      * User Lock
279      *
280      * @param Account the address of account to lock for transaction
281      *
282      * @param mode true or false for lock mode
283      * 
284      */
285     function UserLock(address Account, bool mode) onlyOwner public {
286         LockList[Account] = mode;
287     }
288      /**
289      * Lock tokens
290      *
291      * @param Account the address of account to lock
292      * 
293      * @param amount the amount of money to lock
294      * 
295      * 
296      */
297    function LockTokens(address Account, uint256 amount) onlyOwner public{
298        LockedTokens[Account]=amount;
299    }
300    
301     function UnLockTokens(address Account) onlyOwner public{
302        LockedTokens[Account]=0;
303    }
304    
305 
306 }