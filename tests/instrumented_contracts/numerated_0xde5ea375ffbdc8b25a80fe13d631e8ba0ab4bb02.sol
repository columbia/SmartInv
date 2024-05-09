1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-30
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
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27 }
28 
29 contract owned {
30     address public owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner,"ERC20: Required Owner !");
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         require (newOwner != address(0),"ERC20 New Owner cannot be zero address");
43         owner = newOwner;
44     }
45 }
46 
47 interface tokenRecipient {  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external ; }
48 
49 contract TOKENERC20 {
50     
51     using SafeMath for uint256;
52     event TransferEnabled (bool);
53     event TransferDisabled (bool);
54     // Public variables of the token
55     string public name;
56     string public symbol;
57     uint8 public decimals = 18;
58     // 18 decimals is the strongly suggested default, avoid changing it
59     uint256 public totalSupply;
60 
61     /* This generates a public event on the blockchain that will notify clients */
62 
63    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64     event Mint(address indexed from, uint256 value);
65     constructor(
66         uint256 initialSupply,
67         string memory tokenName,
68         string memory tokenSymbol
69        
70     ) public {
71         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
72         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
73         name = tokenName;                                   // Set the name for display purposes
74         symbol = tokenSymbol;                               // Set the symbol for display purposes
75         TransferAllowed = true;
76     }
77     // This creates an array with all balances
78     mapping (address => uint256) public balanceOf;
79     mapping (address => mapping (address => uint256)) private _allowance;
80     mapping (address => bool) public LockList;
81     mapping (address => uint256) public LockedTokens;
82       bool public TransferAllowed;
83 
84     // This generates a public event on the blockchain that will notify clients
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     // This notifies clients about the amount burnt
88     event Burn(address indexed from, uint256 value);
89 
90 
91     /* Internal transfer, only can be called by this contract */
92     function _transfer(address _from, address _to, uint256 _value) internal {
93         uint256 stage;
94         
95         require(_from != address(0), "ERC20: transfer from the zero address");
96         require(_to != address(0), "ERC20: transfer to the zero address");       // Prevent transfer to 0x0 address. Use burn() instead
97 
98         require (LockList[msg.sender] == false,"ERC20: Caller Locked !");            // Check if msg.sender is locked or not
99         require (LockList[_from] == false, "ERC20: Sender Locked !");
100         require (LockList[_to] == false,"ERC20: Receipient Locked !");
101         require (TransferAllowed == true,"ERC20: Transfer enabled false !");
102 
103        // Check if sender balance is locked 
104         stage=balanceOf[_from].sub(_value, "ERC20: transfer amount exceeds balance");
105         require (stage >= LockedTokens[_from],"ERC20: transfer amount exceeds Senders Locked Amount");
106         
107         //Deduct and add balance
108         balanceOf[_from]=stage;
109         balanceOf[_to]=balanceOf[_to].add(_value,"ERC20: Addition overflow");
110 
111         //emit Transfer event
112         emit Transfer(_from, _to, _value);
113 
114     }
115     
116     /**
117      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
118      *
119      * This is internal function is equivalent to `approve`, and can be used to
120      * e.g. set automatic allowances for certain subsystems, etc.
121      *
122      * Emits an {Approval} event.
123      *
124      * Requirements:
125      *
126      * - `owner` cannot be the zero address.
127      * - `spender` cannot be the zero address.
128      */
129     function _approve(address owner, address _spender, uint256 amount) internal {
130         require(owner != address(0), "ERC20: approve from the zero address");
131         require(_spender != address(0), "ERC20: approve to the zero address");
132 
133         _allowance[owner][_spender] = amount;
134         emit Approval(owner, _spender, amount);
135     }
136 
137     /**
138      * Transfer tokens
139      *
140      * Send `_value` tokens to `_to` from your account
141      *
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transfer(address _to, uint256 _value) public returns(bool){
146         _transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150    
151 
152     function burn(uint256 _value) public returns(bool){
153         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
154         
155         uint256 stage;
156         stage=balanceOf[msg.sender].sub(_value, "ERC20: transfer amount exceeds balance");
157         require (stage >= LockedTokens[msg.sender],"ERC20: transfer amount exceeds Senders Locked Amount");
158         
159         balanceOf[msg.sender]=balanceOf[msg.sender].sub(_value,"ERC20: Burn amount exceeds balance.");
160         totalSupply=totalSupply.sub(_value,"ERC20: Burn amount exceeds total supply");
161         
162         emit Burn(msg.sender, _value);
163         emit Transfer(msg.sender, address(0), _value);
164 
165         return true;
166     }
167      /**
168      * Destroy tokens
169      *
170      * Remove `_value` tokens from the system irreversibly
171      *
172      * @param Account address
173      *
174      * @param _value the amount of money to burn
175      * 
176      * Safely check if total supply is not overdrawn
177      */
178     function burnFrom(address Account, uint256 _value) public returns (bool success) {
179         require (LockList[msg.sender] == false,"ERC20: User Locked !");    
180         require (LockList[Account] == false,"ERC20: Owner Locked !");    
181         uint256 stage;
182         require(Account != address(0), "ERC20: Burn from the zero address");
183         
184         _approve(Account, msg.sender, _allowance[Account][msg.sender].sub(_value,"ERC20: burn amount exceeds allowance"));
185         
186         //Do not allow burn if Accounts tokens are locked.
187         stage=balanceOf[Account].sub(_value,"ERC20: Transfer amount exceeds allowance");
188         require(stage>=LockedTokens[Account],"ERC20: Burn amount exceeds accounts locked amount");
189         balanceOf[Account] =stage ;            // Subtract from the sender
190         
191         //Deduct burn amount from totalSupply
192         totalSupply=totalSupply.sub(_value,"ERC20: Burn Amount exceeds totalSupply");
193        
194         emit Burn(Account, _value);
195         emit Transfer(Account, address(0), _value);
196 
197         return true;
198     }
199     
200     
201  /**
202      * Transfer tokens from other address
203      *
204      * Send `_value` tokens to `_to` on behalf of `_from`
205      *
206      * @param _from The address of the sender
207      * @param _to The address of the recipient
208      * @param _value the amount to send
209      */
210   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
211         
212         _transfer(_from, _to, _value);
213         _approve(_from,msg.sender,_allowance[_from][msg.sender].sub(_value,"ERC20: transfer amount exceeds allowance"));
214         
215         return true;
216     }
217 
218 
219     /**
220      * Set allowance for other address
221      *
222      * Allows `_spender` to spend no more than `_value` tokens in your behalf
223      * Emits Approval Event
224      * @param _spender The address authorized to spend
225      * @param _value the max amount they can spend
226      */
227     function approve(address _spender, uint256 _value) public
228         returns (bool success) {
229         uint256 unapprovbal;
230 
231         // Do not allow approval if amount exceeds locked amount
232         unapprovbal=balanceOf[msg.sender].sub(_value,"ERC20: Allowance exceeds balance of approver");
233         require(unapprovbal>=LockedTokens[msg.sender],"ERC20: Approval amount exceeds locked amount ");
234        
235        
236         _allowance[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 
241     /**
242      * Set allowance for other address and notify
243      *
244      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
245      *
246      * @param _spender The address authorized to spend
247      * @param _value the max amount they can spend
248      * @param _extraData some extra information to send to the approved contract
249      */
250     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
251         public
252         returns (bool success) {
253         tokenRecipient spender = tokenRecipient(_spender);
254         if (approve(_spender, _value)) {
255             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
256             return true;
257         }
258     }
259     
260     function allowance(address _owner,address _spender) public view returns(uint256){
261         return _allowance[_owner][_spender];
262     }
263    
264 }
265 
266 
267 
268 contract GERA is owned, TOKENERC20 {
269 
270     /* Initializes contract with initial supply tokens to the creator of the contract */
271     constructor () TOKENERC20(
272         8800000000 * 1 ** uint256(decimals),
273     "Gera",
274     "GERA") public {
275     }
276     
277    
278      /**
279      * User Lock
280      *
281      * @param Account the address of account to lock for transaction
282      *
283      * @param mode true or false for lock mode
284      * 
285      */
286     function UserLock(address Account, bool mode) onlyOwner public {
287         LockList[Account] = mode;
288     }
289      /**
290      * Lock tokens
291      *
292      * @param Account the address of account to lock
293      * 
294      * @param amount the amount of money to lock
295      * 
296      * 
297      */
298    function LockTokens(address Account, uint256 amount) onlyOwner public{
299        LockedTokens[Account]=amount;
300    }
301    
302     function UnLockTokens(address Account) onlyOwner public{
303        LockedTokens[Account]=0;
304    }
305    
306     /**
307      * Mintable, Destroy tokens
308      *
309      * Remove `_value` tokens from the system irreversibly
310      *
311      * @param _value the amount of money to burn
312      */
313      
314     function mint(uint256 _value) onlyOwner public returns (bool success) {
315         require(balanceOf[msg.sender] >= _value); 
316         require(balanceOf[msg.sender] != 0x0);  // Check if the sender has enough
317         balanceOf[msg.sender]=balanceOf[msg.sender].add(_value,"ERC20: Addition overflow");            // Subtract from the sender
318         totalSupply=totalSupply.add(_value,"ERC20: totalSupply increased ");
319         emit Mint(msg.sender, _value);
320         return true;
321     } 
322 
323 
324   /**
325      * Airdrop tokens
326      *
327      * Remove `_value` tokens from the system irreversibly
328      *
329      * @param _value the amount with decimals(18)
330      *
331      */
332     mapping (address => uint256) public airDropHistory;
333     event AirDrop(address _receiver, uint256 _amount);
334 
335   function dropToken(address[] memory receivers, uint256[] memory values) onlyOwner public {
336     require(receivers.length != 0);
337     require(receivers.length == values.length);
338 
339     for (uint256 i = 0; i < receivers.length; i++) {
340       address receiver = receivers[i];
341       uint256 amount = values[i];
342 
343       transfer(receiver, amount);
344       airDropHistory[receiver] += amount;
345 
346       emit AirDrop(receiver, amount);
347     }
348   }
349   
350       /// Set whether transfer is enabled or disabled
351     
352   
353 
354     function enableTokenTransfer() onlyOwner public {
355         TransferAllowed = true;
356         emit TransferEnabled (true);
357     }
358 
359     function disableTokenTransfer() onlyOwner public {
360         TransferAllowed = false;
361         emit TransferDisabled (true);
362     }
363     
364    
365   
366 
367 
368 }