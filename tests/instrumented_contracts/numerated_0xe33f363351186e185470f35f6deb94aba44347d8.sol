1 /**
2  *Submitted for verification at Etherscan.io on 2020-03-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-03-26
7 */
8 
9 pragma solidity ^0.5.0;
10 
11 library SafeMath{
12       /**
13      * Returns the addition of two unsigned integers, reverting on
14      * overflow.
15      *
16      * - Addition cannot overflow.
17      */
18      function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, errorMessage);
21 
22         return c;
23     }
24 
25       /**
26      * Returns the subtraction of two unsigned integers, reverting with custom message on
27      * overflow (when the result is negative).
28      *
29      * - Subtraction cannot overflow.
30      *
31      */
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38 }
39 
40 contract owned {
41     address public owner;
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner,"ERC20: Required Owner !");
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53         require (newOwner != address(0),"ERC20 New Owner cannot be zero address");
54         owner = newOwner;
55     }
56 }
57 
58 interface tokenRecipient {  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external ; }
59 
60 contract TOKENERC20 {
61     
62     using SafeMath for uint256;
63     event TransferEnabled (bool);
64     event TransferDisabled (bool);
65     // Public variables of the token
66     string public name;
67     string public symbol;
68     uint8 public decimals = 18;
69     // 18 decimals is the strongly suggested default, avoid changing it
70     uint256 public totalSupply;
71 
72     /* This generates a public event on the blockchain that will notify clients */
73 
74    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     event Mint(address indexed from, uint256 value);
76     constructor(
77         uint256 initialSupply,
78         string memory tokenName,
79         string memory tokenSymbol
80        
81     ) public {
82         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
83         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
84         name = tokenName;                                   // Set the name for display purposes
85         symbol = tokenSymbol;                               // Set the symbol for display purposes
86         TransferAllowed = true;
87     }
88     // This creates an array with all balances
89     mapping (address => uint256) public balanceOf;
90     mapping (address => mapping (address => uint256)) private _allowance;
91     mapping (address => bool) public LockList;
92     mapping (address => uint256) public LockedTokens;
93       bool public TransferAllowed;
94 
95     // This generates a public event on the blockchain that will notify clients
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     // This notifies clients about the amount burnt
99     event Burn(address indexed from, uint256 value);
100 
101 
102     /* Internal transfer, only can be called by this contract */
103     function _transfer(address _from, address _to, uint256 _value) internal {
104         uint256 stage;
105         
106         require(_from != address(0), "ERC20: transfer from the zero address");
107         require(_to != address(0), "ERC20: transfer to the zero address");       // Prevent transfer to 0x0 address. Use burn() instead
108 
109         require (LockList[msg.sender] == false,"ERC20: Caller Locked !");            // Check if msg.sender is locked or not
110         require (LockList[_from] == false, "ERC20: Sender Locked !");
111         require (LockList[_to] == false,"ERC20: Receipient Locked !");
112         require (TransferAllowed == true,"ERC20: Transfer enabled false !");
113 
114        // Check if sender balance is locked 
115         stage=balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
116         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
117         
118         //Deduct and add balance
119         balanceOf[_from]=stage;
120         balanceOf[_to]=balanceOf[_to].add(_value,"ERC20: Addition overflow");
121 
122         //emit Transfer event
123         emit Transfer(_from, _to, _value);
124 
125     }
126     
127     /**
128      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
129      *
130      * This is internal function is equivalent to `approve`, and can be used to
131      * e.g. set automatic allowances for certain subsystems, etc.
132      *
133      * Emits an {Approval} event.
134      *
135      * Requirements:
136      *
137      * - `owner` cannot be the zero address.
138      * - `spender` cannot be the zero address.
139      */
140     function _approve(address owner, address _spender, uint256 amount) internal {
141         require(owner != address(0), "ERC20: approve from the zero address");
142         require(_spender != address(0), "ERC20: approve to the zero address");
143 
144         _allowance[owner][_spender] = amount;
145         emit Approval(owner, _spender, amount);
146     }
147 
148     /**
149      * Transfer tokens
150      *
151      * Send `_value` tokens to `_to` from your account
152      *
153      * @param _to The address of the recipient
154      * @param _value the amount to send
155      */
156     function transfer(address _to, uint256 _value) public returns(bool){
157         _transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161    
162 
163     function burn(uint256 _value) public returns(bool){
164         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
165         
166         uint256 stage;
167         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
168         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
169         
170         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
171         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
172         
173         emit Burn(msg.sender, _value);
174         emit Transfer(msg.sender, address(0), _value);
175 
176         return true;
177     }
178      /**
179      * Destroy tokens
180      *
181      * Remove `_value` tokens from the system irreversibly
182      *
183      * @param Account address
184      *
185      * @param _value the amount of money to burn
186      * 
187      * Safely check if total supply is not overdrawn
188      */
189     function burnFrom(address Account, uint256 _value) public returns (bool success) {
190         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
191         require (LockList[Account] == false,"ERC20: Owner Locked !");    
192         uint256 stage;
193         require(Account != address(0), "ERC20: Burn from the zero address");
194         
195         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
196         
197         //Do not allow burn if Accounts tokens are locked.
198         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
199         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
200         balanceOf[Account] =stage ;            // Subtract from the sender
201         
202         //Deduct burn amount from totalSupply
203         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
204        
205         emit Burn(Account, _value);
206         emit Transfer(Account, address(0), _value);
207 
208         return true;
209     }
210     
211     
212  /**
213      * Transfer tokens from other address
214      *
215      * Send `_value` tokens to `_to` on behalf of `_from`
216      *
217      * @param _from The address of the sender
218      * @param _to The address of the recipient
219      * @param _value the amount to send
220      */
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
222         
223         _transfer(_from, _to, _value);
224         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
225         
226         return true;
227     }
228 
229 
230     /**
231      * Set allowance for other address
232      *
233      * Allows `_spender` to spend no more than `_value` tokens in your behalf
234      * Emits Approval Event
235      * @param _spender The address authorized to spend
236      * @param _value the max amount they can spend
237      */
238     function approve(address _spender, uint256 _value) public
239         returns (bool success) {
240         uint256 unapprovbal;
241 
242         // Do not allow approval if amount exceeds locked amount
243         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
244         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
245        
246        
247         _allowance[msg.sender][_spender] = _value;
248         emit Approval(msg.sender, _spender, _value);
249         return true;
250     }
251 
252     /**
253      * Set allowance for other address and notify
254      *
255      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
256      *
257      * @param _spender The address authorized to spend
258      * @param _value the max amount they can spend
259      * @param _extraData some extra information to send to the approved contract
260      */
261     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
262         public
263         returns (bool success) {
264         tokenRecipient spender = tokenRecipient(_spender);
265         if (approve(_spender, _value)) {
266             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
267             return true;
268         }
269     }
270     
271     function allowance(address _owner,address _spender) public view returns(uint256){
272         return _allowance[_owner][_spender];
273     }
274    
275 }
276 
277 
278 
279 contract BASID is owned, TOKENERC20 {
280 
281     /* Initializes contract with initial supply tokens to the creator of the contract */
282     constructor () TOKENERC20(
283         10000000000 * 1 ** uint256(decimals),
284     "BASID",
285     "BASID") public {
286     }
287     
288    
289      /**
290      * User Lock
291      *
292      * @param Account the address of account to lock for transaction
293      *
294      * @param mode true or false for lock mode
295      * 
296      */
297     function UserLock(address Account, bool mode) onlyOwner public {
298         LockList[Account] = mode;
299     }
300      /**
301      * Lock tokens
302      *
303      * @param Account the address of account to lock
304      * 
305      * @param amount the amount of money to lock
306      * 
307      * 
308      */
309    function LockTokens(address Account, uint256 amount) onlyOwner public{
310        LockedTokens[Account]=amount;
311    }
312    
313     function UnLockTokens(address Account) onlyOwner public{
314        LockedTokens[Account]=0;
315    }
316    
317     /**
318      * Mintable, Destroy tokens
319      *
320      * Remove `_value` tokens from the system irreversibly
321      *
322      * @param _value the amount of money to burn
323      */
324      
325     function mint(uint256 _value) onlyOwner public returns (bool success) {
326         require(balanceOf[msg.sender] >= _value); 
327         require(balanceOf[msg.sender] != 0x0);  // Check if the sender has enough
328         balanceOf[msg.sender]=balanceOf[msg.sender].add(_value,"ERC20: Addition overflow");            // Subtract from the sender
329         totalSupply=totalSupply.add(_value,"ERC20: totalSupply increased ");
330         emit Mint(msg.sender, _value);
331         return true;
332     } 
333 
334 
335   /**
336      * Airdrop tokens
337      *
338      * Remove `_value` tokens from the system irreversibly
339      *
340      * @param _value the amount with decimals(18)
341      *
342      */
343     mapping (address => uint256) public airDropHistory;
344     event AirDrop(address _receiver, uint256 _amount);
345 
346   function dropToken(address[] memory receivers, uint256[] memory values) onlyOwner public {
347     require(receivers.length != 0);
348     require(receivers.length == values.length);
349 
350     for (uint256 i = 0; i < receivers.length; i++) {
351       address receiver = receivers[i];
352       uint256 amount = values[i];
353 
354       transfer(receiver, amount);
355       airDropHistory[receiver] += amount;
356 
357       emit AirDrop(receiver, amount);
358     }
359   }
360   
361       /// Set whether transfer is enabled or disabled
362     
363   
364 
365     function enableTokenTransfer() onlyOwner public {
366         TransferAllowed = true;
367         emit TransferEnabled (true);
368     }
369 
370     function disableTokenTransfer() onlyOwner public {
371         TransferAllowed = false;
372         emit TransferDisabled (true);
373     }
374     
375    
376   
377 
378 
379 }