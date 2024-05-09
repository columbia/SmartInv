1 pragma solidity ^0.5.11;
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
63     uint256 internal limit = 10000000000000000000000000;
64 
65     /* This generates a public event on the blockchain that will notify clients */
66 
67    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68     event Mint(address indexed from, uint256 value);
69     constructor(
70         uint256 initialSupply,
71         string memory tokenName,
72         string memory tokenSymbol
73        
74     ) public {
75         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
76         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
77         name = tokenName;                                   // Set the name for display purposes
78         symbol = tokenSymbol;                               // Set the symbol for display purposes
79         TransferAllowed = true;
80     }
81     // This creates an array with all balances
82     mapping (address => uint256) public balanceOf;
83     mapping (address => mapping (address => uint256)) private _allowance;
84     mapping (address => bool) public LockList;
85     mapping (address => uint256) public LockedTokens;
86       bool public TransferAllowed;
87 
88     // This generates a public event on the blockchain that will notify clients
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     // This notifies clients about the amount burnt
92     event Burn(address indexed from, uint256 value);
93 
94 
95     /* Internal transfer, only can be called by this contract */
96     function _transfer(address _from, address _to, uint256 _value) internal {
97         uint256 stage;
98         
99         require(_from != address(0), "ERC20: transfer from the zero address");
100         require(_to != address(0), "ERC20: transfer to the zero address");       // Prevent transfer to 0x0 address. Use burn() instead
101 
102         require (LockList[msg.sender] == false,"ERC20: Caller Locked !");            // Check if msg.sender is locked or not
103         require (LockList[_from] == false, "ERC20: Sender Locked !");
104         require (LockList[_to] == false,"ERC20: Receipient Locked !");
105         require (TransferAllowed == true,"ERC20: Transfer enabled false !");
106 
107        // Check if sender balance is locked 
108         stage=balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
109         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
110         
111         //Deduct and add balance
112         balanceOf[_from]=stage;
113         balanceOf[_to]=balanceOf[_to].add(_value,"ERC20: Addition overflow");
114 
115         //emit Transfer event
116         emit Transfer(_from, _to, _value);
117 
118     }
119     
120     /**
121      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
122      *
123      * This is internal function is equivalent to `approve`, and can be used to
124      * e.g. set automatic allowances for certain subsystems, etc.
125      *
126      * Emits an {Approval} event.
127      *
128      * Requirements:
129      *
130      * - `owner` cannot be the zero address.
131      * - `spender` cannot be the zero address.
132      */
133     function _approve(address owner, address _spender, uint256 amount) internal {
134         require(owner != address(0), "ERC20: approve from the zero address");
135         require(_spender != address(0), "ERC20: approve to the zero address");
136 
137         _allowance[owner][_spender] = amount;
138         emit Approval(owner, _spender, amount);
139     }
140 
141     /**
142      * Transfer tokens
143      *
144      * Send `_value` tokens to `_to` from your account
145      *
146      * @param _to The address of the recipient
147      * @param _value the amount to send
148      */
149     function transfer(address _to, uint256 _value) public returns(bool){
150         _transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154    
155 
156     function burn(uint256 _value) public returns(bool){
157         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
158         
159         uint256 stage;
160         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
161         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
162         
163         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
164         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
165         
166         emit Burn(msg.sender, _value);
167         emit Transfer(msg.sender, address(0), _value);
168 
169         return true;
170     }
171      /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param Account address
177      *
178      * @param _value the amount of money to burn
179      * 
180      * Safely check if total supply is not overdrawn
181      */
182     function burnFrom(address Account, uint256 _value) public returns (bool success) {
183         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
184         require (LockList[Account] == false,"ERC20: Owner Locked !");    
185         uint256 stage;
186         require(Account != address(0), "ERC20: Burn from the zero address");
187         
188         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
189         
190         //Do not allow burn if Accounts tokens are locked.
191         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
192         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
193         balanceOf[Account] =stage ;            // Subtract from the sender
194         
195         //Deduct burn amount from totalSupply
196         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
197        
198         emit Burn(Account, _value);
199         emit Transfer(Account, address(0), _value);
200 
201         return true;
202     }
203     
204     
205  /**
206      * Transfer tokens from other address
207      *
208      * Send `_value` tokens to `_to` on behalf of `_from`
209      *
210      * @param _from The address of the sender
211      * @param _to The address of the recipient
212      * @param _value the amount to send
213      */
214   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
215         
216         _transfer(_from, _to, _value);
217         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
218         
219         return true;
220     }
221 
222 
223     /**
224      * Set allowance for other address
225      *
226      * Allows `_spender` to spend no more than `_value` tokens in your behalf
227      * Emits Approval Event
228      * @param _spender The address authorized to spend
229      * @param _value the max amount they can spend
230      */
231     function approve(address _spender, uint256 _value) public
232         returns (bool success) {
233         uint256 unapprovbal;
234 
235         // Do not allow approval if amount exceeds locked amount
236         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
237         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
238        
239        
240         _allowance[msg.sender][_spender] = _value;
241         emit Approval(msg.sender, _spender, _value);
242         return true;
243     }
244 
245     /**
246      * Set allowance for other address and notify
247      *
248      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
249      *
250      * @param _spender The address authorized to spend
251      * @param _value the max amount they can spend
252      * @param _extraData some extra information to send to the approved contract
253      */
254     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
255         public
256         returns (bool success) {
257         tokenRecipient spender = tokenRecipient(_spender);
258         if (approve(_spender, _value)) {
259             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
260             return true;
261         }
262     }
263     
264     function allowance(address _owner,address _spender) public view returns(uint256){
265         return _allowance[_owner][_spender];
266     }
267    
268 }
269 
270 
271 
272 contract GENEBANKToken is owned, TOKENERC20 {
273 
274     /* Initializes contract with initial supply tokens to the creator of the contract */
275     constructor () TOKENERC20(
276         10000000000 * 1 ** uint256(decimals),
277     "GENEBANK Token",
278     "GNBT") public {
279     }
280     
281    
282      /**
283      * User Lock
284      *
285      * @param Account the address of account to lock for transaction
286      *
287      * @param mode true or false for lock mode
288      * 
289      */
290     function UserLock(address Account, bool mode) onlyOwner public {
291         LockList[Account] = mode;
292     }
293      /**
294      * Lock tokens
295      *
296      * @param Account the address of account to lock
297      * 
298      * @param amount the amount of money to lock
299      * 
300      * 
301      */
302    function LockTokens(address Account, uint256 amount) onlyOwner public{
303        LockedTokens[Account]=amount;
304    }
305    
306     function UnLockTokens(address Account) onlyOwner public{
307        LockedTokens[Account]=0;
308    }
309    
310     /**
311      * Mintable, Destroy tokens
312      *
313      * Remove `_value` tokens from the system irreversibly
314      *
315      * @param _value the amount of money to burn
316      */
317      
318     function mint(uint256 _value) onlyOwner public returns (bool success) {
319         require(balanceOf[msg.sender] >= _value); 
320         require(balanceOf[msg.sender] != 0x0);  // Check if the sender has enough
321         require(balanceOf[msg.sender] != 0x0);
322         require(_value <  limit); //limit the mint function 
323         balanceOf[msg.sender]=balanceOf[msg.sender].add(_value,"ERC20: Addition overflow");            // Subtract from the sender
324         totalSupply=totalSupply.add(_value,"ERC20: totalSupply increased ");
325         emit Mint(msg.sender, _value);
326         return true;
327     } 
328 
329 
330   /**
331      * Airdrop tokens
332      *
333      * Remove `_value` tokens from the system irreversibly
334      *
335      * @param _value the amount with decimals(18)
336      *
337      */
338     mapping (address => uint256) public airDropHistory;
339     event AirDrop(address _receiver, uint256 _amount);
340 
341   function dropToken(address[] memory receivers, uint256[] memory values) onlyOwner public {
342     require(receivers.length != 0);
343     require(receivers.length == values.length);
344 
345     for (uint256 i = 0; i < receivers.length; i++) {
346       address receiver = receivers[i];
347       uint256 amount = values[i];
348 
349       transfer(receiver, amount);
350       airDropHistory[receiver] += amount;
351 
352       emit AirDrop(receiver, amount);
353     }
354   }
355   
356       /// Set whether transfer is enabled or disabled
357     
358   
359 
360     function enableTokenTransfer() onlyOwner public {
361         TransferAllowed = true;
362         emit TransferEnabled (true);
363     }
364 
365     function disableTokenTransfer() onlyOwner public {
366         TransferAllowed = false;
367         emit TransferDisabled (true);
368     }
369     
370    
371   
372 
373 
374 }