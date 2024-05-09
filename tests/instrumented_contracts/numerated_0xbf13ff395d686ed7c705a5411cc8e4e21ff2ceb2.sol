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
55     event TransferEnabled (bool);
56     event TransferDisabled (bool);
57     // Public variables of the token
58     string public name;
59     string public symbol;
60     uint8 public decimals = 18;
61     // 18 decimals is the strongly suggested default, avoid changing it
62     uint256 public totalSupply;
63 
64     /* This generates a public event on the blockchain that will notify clients */
65 
66    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     event Mint(address indexed from, uint256 value);
68     constructor(
69         uint256 initialSupply,
70         string memory tokenName,
71         string memory tokenSymbol
72        
73     ) public {
74         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
75         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78         TransferAllowed = true;
79     }
80     // This creates an array with all balances
81     mapping (address => uint256) public balanceOf;
82     mapping (address => mapping (address => uint256)) private _allowance;
83     mapping (address => bool) public LockList;
84     mapping (address => uint256) public LockedTokens;
85       bool public TransferAllowed;
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
104         require (TransferAllowed == true,"ERC20: Transfer enabled false !");
105 
106        // Check if sender balance is locked 
107         stage=balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
108         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
109         
110         //Deduct and add balance
111         balanceOf[_from]=stage;
112         balanceOf[_to]=balanceOf[_to].add(_value,"ERC20: Addition overflow");
113 
114         //emit Transfer event
115         emit Transfer(_from, _to, _value);
116 
117     }
118     
119     /**
120      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
121      *
122      * This is internal function is equivalent to `approve`, and can be used to
123      * e.g. set automatic allowances for certain subsystems, etc.
124      *
125      * Emits an {Approval} event.
126      *
127      * Requirements:
128      *
129      * - `owner` cannot be the zero address.
130      * - `spender` cannot be the zero address.
131      */
132     function _approve(address owner, address _spender, uint256 amount) internal {
133         require(owner != address(0), "ERC20: approve from the zero address");
134         require(_spender != address(0), "ERC20: approve to the zero address");
135 
136         _allowance[owner][_spender] = amount;
137         emit Approval(owner, _spender, amount);
138     }
139 
140     /**
141      * Transfer tokens
142      *
143      * Send `_value` tokens to `_to` from your account
144      *
145      * @param _to The address of the recipient
146      * @param _value the amount to send
147      */
148     function transfer(address _to, uint256 _value) public returns(bool){
149         _transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153    
154 
155     function burn(uint256 _value) public returns(bool){
156         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
157         
158         uint256 stage;
159         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
160         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
161         
162         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
163         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
164         
165         emit Burn(msg.sender, _value);
166         emit Transfer(msg.sender, address(0), _value);
167 
168         return true;
169     }
170      /**
171      * Destroy tokens
172      *
173      * Remove `_value` tokens from the system irreversibly
174      *
175      * @param Account address
176      *
177      * @param _value the amount of money to burn
178      * 
179      * Safely check if total supply is not overdrawn
180      */
181     function burnFrom(address Account, uint256 _value) public returns (bool success) {
182         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
183         require (LockList[Account] == false,"ERC20: Owner Locked !");    
184         uint256 stage;
185         require(Account != address(0), "ERC20: Burn from the zero address");
186         
187         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
188         
189         //Do not allow burn if Accounts tokens are locked.
190         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
191         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
192         balanceOf[Account] =stage ;            // Subtract from the sender
193         
194         //Deduct burn amount from totalSupply
195         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
196        
197         emit Burn(Account, _value);
198         emit Transfer(Account, address(0), _value);
199 
200         return true;
201     }
202     
203     
204  /**
205      * Transfer tokens from other address
206      *
207      * Send `_value` tokens to `_to` on behalf of `_from`
208      *
209      * @param _from The address of the sender
210      * @param _to The address of the recipient
211      * @param _value the amount to send
212      */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
214         
215         _transfer(_from, _to, _value);
216         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
217         
218         return true;
219     }
220 
221 
222     /**
223      * Set allowance for other address
224      *
225      * Allows `_spender` to spend no more than `_value` tokens in your behalf
226      * Emits Approval Event
227      * @param _spender The address authorized to spend
228      * @param _value the max amount they can spend
229      */
230     function approve(address _spender, uint256 _value) public
231         returns (bool success) {
232         uint256 unapprovbal;
233 
234         // Do not allow approval if amount exceeds locked amount
235         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
236         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
237        
238        
239         _allowance[msg.sender][_spender] = _value;
240         emit Approval(msg.sender, _spender, _value);
241         return true;
242     }
243 
244     /**
245      * Set allowance for other address and notify
246      *
247      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
248      *
249      * @param _spender The address authorized to spend
250      * @param _value the max amount they can spend
251      * @param _extraData some extra information to send to the approved contract
252      */
253     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
254         public
255         returns (bool success) {
256         tokenRecipient spender = tokenRecipient(_spender);
257         if (approve(_spender, _value)) {
258             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
259             return true;
260         }
261     }
262     
263     function allowance(address _owner,address _spender) public view returns(uint256){
264         return _allowance[_owner][_spender];
265     }
266    
267 }
268 
269 
270 
271 contract DoctorsCoin is owned, TOKENERC20 {
272 
273     /* Initializes contract with initial supply tokens to the creator of the contract */
274     constructor () TOKENERC20(
275         10000000000 * 1 ** uint256(decimals),
276     "Doctors Coin",
277     "DRS") public {
278     }
279     
280    
281      /**
282      * User Lock
283      *
284      * @param Account the address of account to lock for transaction
285      *
286      * @param mode true or false for lock mode
287      * 
288      */
289     function UserLock(address Account, bool mode) onlyOwner public {
290         LockList[Account] = mode;
291     }
292      /**
293      * Lock tokens
294      *
295      * @param Account the address of account to lock
296      * 
297      * @param amount the amount of money to lock
298      * 
299      * 
300      */
301    function LockTokens(address Account, uint256 amount) onlyOwner public{
302        LockedTokens[Account]=amount;
303    }
304    
305     function UnLockTokens(address Account) onlyOwner public{
306        LockedTokens[Account]=0;
307    }
308    
309     /**
310      * Mintable, Destroy tokens
311      *
312      * Remove `_value` tokens from the system irreversibly
313      *
314      * @param _value the amount of money to burn
315      */
316      
317     function mint(uint256 _value) onlyOwner public returns (bool success) {
318         require(balanceOf[msg.sender] >= _value); 
319         require(balanceOf[msg.sender] != 0x0);  // Check if the sender has enough
320         balanceOf[msg.sender]=balanceOf[msg.sender].add(_value,"ERC20: Addition overflow");            // Subtract from the sender
321         totalSupply=totalSupply.add(_value,"ERC20: totalSupply increased ");
322         emit Mint(msg.sender, _value);
323         return true;
324     } 
325 
326 
327   /**
328      * Airdrop tokens
329      *
330      * Remove `_value` tokens from the system irreversibly
331      *
332      * @param _value the amount with decimals(18)
333      *
334      */
335     mapping (address => uint256) public airDropHistory;
336     event AirDrop(address _receiver, uint256 _amount);
337 
338   function dropToken(address[] memory receivers, uint256[] memory values) onlyOwner public {
339     require(receivers.length != 0);
340     require(receivers.length == values.length);
341 
342     for (uint256 i = 0; i < receivers.length; i++) {
343       address receiver = receivers[i];
344       uint256 amount = values[i];
345 
346       transfer(receiver, amount);
347       airDropHistory[receiver] += amount;
348 
349       emit AirDrop(receiver, amount);
350     }
351   }
352   
353       /// Set whether transfer is enabled or disabled
354     
355   
356 
357     function enableTokenTransfer() onlyOwner public {
358         TransferAllowed = true;
359         emit TransferEnabled (true);
360     }
361 
362     function disableTokenTransfer() onlyOwner public {
363         TransferAllowed = false;
364         emit TransferDisabled (true);
365     }
366     
367    
368   
369 
370 
371 }