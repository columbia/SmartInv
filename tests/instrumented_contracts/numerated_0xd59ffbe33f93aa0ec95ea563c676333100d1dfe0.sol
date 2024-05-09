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
33 
34     constructor() public {
35         owner = msg.sender; 
36   
37     }
38 
39     address public owner;
40     modifier onlyOwner {
41         require(msg.sender == owner,"ERC20: Required Owner !");
42         _;
43     }
44 
45 
46 
47 
48     function transferOwnership(address newOwner) onlyOwner public{
49         require (newOwner != address(0),"ERC20 New Owner cannot be zero address");
50         owner = newOwner;
51     }
52 
53 
54 }
55 
56 interface tokenRecipient {  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external; }
57 
58 contract TOKENERC20 is owned {
59     
60     using SafeMath for uint256;
61 
62     // Public variables of the token
63 
64     /* This generates a public event on the blockchain that will notify clients */
65 
66    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67    
68    
69 
70     string public name;
71     string public symbol;
72     uint8 public decimals = 18;
73     uint256 public totalSupply;
74 
75     constructor(
76         uint256 initialSupply,
77         string memory tokenName,
78         string memory tokenSymbol
79     ) public {
80     
81         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
82         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
83         name = tokenName;                                   // Set the name for display purposes
84         symbol = tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     // This creates an array with all balances
88     mapping (address => uint256) public balanceOf;
89     mapping (address => mapping (address => uint256)) private _allowance;
90     mapping (address => bool) public LockList;
91     mapping (address => uint256) public LockedTokens;
92 
93 
94     // This generates a public event on the blockchain that will notify clients
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     // This notifies clients about the amount burnt
98     event Burn(address indexed from, uint256 value);
99 
100     /* Internal transfer, only can be called by this contract */
101     function _transfer(address _from, address _to, uint256 _value) internal {
102         uint256 stage;
103         
104         require(_from != address(0), "ERC20: transfer from the zero address");
105         require(_to != address(0), "ERC20: transfer to the zero address");       // Prevent transfer to 0x0 address. Use burn() instead
106 
107         require (LockList[msg.sender] == false,"ERC20: Caller Locked !");            // Check if msg.sender is locked or not
108         require (LockList[_from] == false, "ERC20: Sender Locked !");
109         require (LockList[_to] == false,"ERC20: Receipient Locked !");
110 
111        // Check if sender balance is locked 
112         stage = balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
113         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
114         
115         //Deduct and add balance
116         balanceOf[_from] = stage;
117         balanceOf[_to] = balanceOf[_to].add(_value,"ERC20: Addition overflow");
118 
119         //emit Transfer event
120         emit Transfer(_from, _to, _value);
121 
122     }
123     
124     /**
125      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
126      *
127      * This is internal function is equivalent to `approve`, and can be used to
128      * e.g. set automatic allowances for certain subsystems, etc.
129      *
130      * Emits an {Approval} event.
131      *
132      * Requirements:
133      *
134      * - `owner` cannot be the zero address.
135      * - `spender` cannot be the zero address.
136      */
137     function _approve(address owner, address _spender, uint256 amount) internal {
138         require(owner != address(0), "ERC20: approve from the zero address");
139         require(_spender != address(0), "ERC20: approve to the zero address");
140 
141         _allowance[owner][_spender] = amount;
142         emit Approval(owner, _spender, amount);
143     }
144 
145     /**
146      * Transfer tokens
147      *
148      * Send `_value` tokens to `_to` from your account
149      *
150      * @param _to The address of the recipient
151      * @param _value the amount to send
152      */
153     function transfer(address _to, uint256 _value) public returns(bool){
154         _transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     function burn(uint256 _value) public returns(bool){
159         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
160         
161         uint256 stage;
162         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
163         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
164         
165         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
166         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
167         
168         emit Burn(msg.sender, _value);
169         emit Transfer(msg.sender, address(0), _value);
170 
171         return true;
172     }
173     
174      /**
175      * Destroy tokens
176      *
177      * Remove `_value` tokens from the system irreversibly
178      *
179      * @param Account address
180      *
181      * @param _value the amount of money to burn
182      * 
183      * Safely check if total supply is not overdrawn
184      */
185     function burnFrom(address Account, uint256 _value) public returns (bool success) {
186         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
187         require (LockList[Account] == false,"ERC20: Owner Locked !");    
188         uint256 stage;
189         require(Account != address(0), "ERC20: Burn from the zero address");
190         
191         //Safely substract amount to be burned from callers allowance
192         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
193         
194         //Do not allow burn if Accounts tokens are locked.
195         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
196         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
197         balanceOf[Account] =stage ;            // Subtract from the sender
198         
199         //Deduct burn amount from totalSupply
200         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
201        
202         emit Burn(Account, _value);
203         emit Transfer(Account, address(0), _value);
204 
205         return true;
206     }
207     
208     
209  /**
210      * Transfer tokens from other address
211      *
212      * Send `_value` tokens to `_to` on behalf of `_from`
213      *
214      * @param _from The address of the sender
215      * @param _to The address of the recipient
216      * @param _value the amount to send
217      */
218   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
219         
220         _transfer(_from, _to, _value);
221         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
222         
223         return true;
224     }
225 
226 
227     /**
228      * Set allowance for other address
229      *
230      * Allows `_spender` to spend no more than `_value` tokens in your behalf
231      * Emits Approval Event
232      * @param _spender The address authorized to spend
233      * @param _value the max amount they can spend
234      */
235     function approve(address _spender, uint256 _value) public
236         returns (bool success) {
237         uint256 unapprovbal;
238 
239         // Do not allow approval if amount exceeds locked amount
240         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
241         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
242        
243        
244         _allowance[msg.sender][_spender] = _value;
245         emit Approval(msg.sender, _spender, _value);
246         return true;
247     }
248 
249     /**
250      * Set allowance for other address and notify
251      *
252      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
253      *
254      * @param _spender The address authorized to spend
255      * @param _value the max amount they can spend
256      * @param _extraData some extra information to send to the approved contract
257      */
258     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
259         public
260         returns (bool success) {
261         tokenRecipient spender = tokenRecipient(_spender);
262         if (approve(_spender, _value)) {
263             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
264             return true;
265         }
266     }
267     
268     function allowance(address _owner,address _spender) public view returns(uint256){
269         return _allowance[_owner][_spender];
270     }
271 
272 }
273 
274 
275 
276 contract TNCCoin is owned, TOKENERC20 {
277 
278     /* Initializes contract with initial supply tokens to the creator of the contract */
279     constructor () TOKENERC20(
280         1000000000000 * 1 ** uint256(decimals),
281     "TNC Coin",
282     "TNC") public {
283     }
284     
285    
286      /**
287      * User Lock
288      *
289      * @param Account the address of account to lock for transaction
290      *
291      * @param mode true or false for lock mode
292      * 
293      */
294     function UserLock(address Account, bool mode) onlyOwner public {
295         LockList[Account] = mode;
296     }
297      /**
298      * Lock tokens
299      *
300      * @param Account the address of account to lock
301      * 
302      * @param amount the amount of money to lock
303      * 
304      * 
305      */
306    function LockTokens(address Account, uint256 amount) onlyOwner public{
307        LockedTokens[Account]=amount;
308    }
309    
310     function UnLockTokens(address Account) onlyOwner public{
311        LockedTokens[Account]=0;
312    }
313    
314 
315 }