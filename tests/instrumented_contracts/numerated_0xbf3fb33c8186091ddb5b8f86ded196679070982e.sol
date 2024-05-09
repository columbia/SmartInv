1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /* contract ownership status*/
35 contract owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 interface tokenRecipient { function receiveApproval(address _from, uint256 _oshiAmount, address _token, bytes _extraData) external; }
62 
63 contract TokenERC20 {
64     
65     using SafeMath for uint256;
66     // Public variables of the token
67     string public name;
68     string public symbol;
69     uint8 public decimals = 18;
70     // @param M Multiplier,
71     uint256 public M = 10**uint256(decimals); 
72     uint256 public totalSupply;
73 
74     
75     // This creates an array with all balances
76     mapping (address => uint256) public balanceOf;
77     mapping (address => mapping (address => uint256)) public allowed;
78 
79     /** oshi for Adamcoin is like wei for Ether, 1 Adamcoin = M * oshi as 1 Ether = 1e18 wei  */
80     
81     // This generates a public event on the blockchain that will notify clients
82     event Transfer(address indexed _from, address indexed _to, uint256 _oshiAmount);
83     // This generates a public event on the blockchain that will notify clients
84     event Approval(address indexed _approvedBy, address _spender, uint256 _oshiAmount);
85     // This notifies clients about the amount burnt
86     event Burn(address indexed _from, uint256 _oshiAmount);
87 
88     /**
89      * Constructor
90      *
91      * Initializes contract with initial supply tokens to the creator of the contract
92      */
93     constructor(
94        uint256 initialSupply,
95         string tokenName,
96         string tokenSymbol
97     )   public {
98         
99         totalSupply = initialSupply * M;
100         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
101         name = tokenName;                         // Set the name for display purposes
102         symbol = tokenSymbol;                    // Set the symbol for display purposes
103     }
104     
105     /**
106      * Internal transfer, only can be called by this contract
107      */
108     function _transfer(address _from, address _to, uint _oshiAmount) internal {
109         // Prevent transfer to 0x0 address. Use burn() instead
110         require(_to != 0x0);
111         // Subtract from the sender
112         balanceOf[_from] = balanceOf[_from].sub(_oshiAmount);
113         // Add the same to the recipient
114         balanceOf[_to] = balanceOf[_to].add(_oshiAmount);
115         emit Transfer(_from, _to, _oshiAmount);
116         
117     }
118 
119     /**
120      * Transfer tokens
121      *
122      * Send `_oshiAmount` tokens to `_to` from your account
123      *
124      * @param _to The address of the recipient
125      * @param _oshiAmount the amount of oshi to send
126      */
127     function transfer(address _to, uint256 _oshiAmount) public {
128         _transfer(msg.sender, _to, _oshiAmount);
129     }
130 
131     /**
132      * Transfer tokens from other address
133      *
134      * Send `_oshiAmount`  to `_to` in behalf of `_from`
135      *
136      * @param _from The address of the sender
137      * @param _to The address of the recipient
138      * @param _oshiAmount the amount or oshi to send
139      */
140      function transferFrom(address _from, address _to, uint256 _oshiAmount) public returns (bool success) {
141         require(_oshiAmount <= balanceOf[_from]);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_oshiAmount);
143         require(_oshiAmount > 0 && _from != _to); 
144         _transfer(_from, _to, _oshiAmount);
145         
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address
151      *
152      * Allows `_spender` to spend no more than `_oshiAmount` tokens in your behalf
153      *
154      * @param _spender The address authorized to spend
155      * @param _oshiAmount the max amount of oshi they can spend 
156      */
157      function approve(address _spender, uint _oshiAmount) public returns (bool success) {
158        
159         allowed[msg.sender][_spender] = _oshiAmount;
160         emit Approval(msg.sender, _spender, _oshiAmount);
161         return true;
162     }
163     
164       /**
165      * Set allowance for other address and notify
166      *
167      * Allows `_spender` to spend no more than `_oshiAmount`  in your behalf, and then ping the contract about it
168      *
169      * @param _spender The address authorized to spend
170      * @param _oshiAmount the max amount of oshi they can spend 
171      * @param _extraData some extra information to send to the approved contract
172      */
173     function approveAndCall(address _spender, uint256 _oshiAmount, bytes _extraData)
174         public
175         returns (bool success) {
176         tokenRecipient spender = tokenRecipient(_spender);
177         if (approve(_spender, _oshiAmount)) {
178             spender.receiveApproval(msg.sender, _oshiAmount, this, _extraData);
179             return true;
180         }
181     }
182   
183     /**
184      * Destroy tokens
185      *
186      * Remove `_oshiAmount`  from the system irreversibly
187      *
188      * @param _oshiAmount the amount of oshi to burn 
189      */
190     function burn(uint256 _oshiAmount) public returns (bool success) {
191     
192         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_oshiAmount);            // Subtract from the sender
193         totalSupply = totalSupply.sub(_oshiAmount);                      // Updates totalSupply
194         emit Burn(msg.sender, _oshiAmount);
195         return true;
196     }
197 
198 
199     /**
200      * Destroy tokens from other account
201      *
202      * Remove `_oshiAmount`  from the system irreversibly on behalf of `_from`.
203      *
204      * @param _from the address of the sender
205      * @param _oshiAmount the amount of oshi to burn 
206      */
207     function burnFrom(address _from, uint256 _oshiAmount)  public returns (bool success) {
208         balanceOf[_from] = balanceOf[_from].sub(_oshiAmount);                         // Subtract from the targeted balance
209         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_oshiAmount);             // Subtract from the sender's allowed
210         totalSupply = totalSupply.sub(_oshiAmount);                              // Update totalSupply
211         emit Burn(_from, _oshiAmount);
212         return true;
213     }
214 }
215 /******************************************/
216 /*       ADAMCOINS ADM STARTS HERE       */
217 /******************************************/
218 
219 contract Adamcoins is owned, TokenERC20 {
220     
221     using SafeMath for uint256;
222     
223     uint256 public sellPrice;                //Adamcoins sell price
224     uint256 public buyPrice;                 //Adamcoins buy price
225     bool public purchasingAllowed = true;
226     bool public sellingAllowed = true;
227 
228     
229     mapping (address => uint) public pendingWithdrawals;
230     mapping (address => bool) public frozenAccount;
231 
232     /* This generates a public event on the blockchain that will notify clients */
233     event FrozenFunds(address target, bool frozen);
234 
235     /* Initializes contract with initial supply tokens to the creator of the contract */
236      constructor(
237         uint256 initialSupply,
238         string tokenName,
239         string tokenSymbol
240     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
241     
242     /// @dev Public function to determine if an address is a contract
243     /// @param _addr The address being queried
244     /// @return True if `_addr` is a contract
245     function isContract(address _addr) view public returns(bool) {
246         uint size;
247         if (_addr == 0) return false;
248         assembly {
249             size := extcodesize(_addr)
250         }
251         return size>0;
252     }
253 
254     /// @notice allows to purchase from the contract 
255     function enablePurchasing() onlyOwner public {
256         require (msg.sender == owner); 
257         purchasingAllowed = true;
258     }
259     /// @notice doesn't allow to purchase from the contract
260     function disablePurchasing() onlyOwner public {
261         require (msg.sender == owner); 
262         purchasingAllowed = false;
263     }
264     
265     /// @notice allows to sell to the contract
266     function enableSelling() onlyOwner public {
267         require (msg.sender == owner); 
268         sellingAllowed = true;
269     }
270     /// @notice doesn't allow to sell to the contract
271     function disableSelling() onlyOwner public {
272         require (msg.sender == owner); 
273         sellingAllowed = false;
274     }
275     /* Internal transfer, only can be called by this contract */
276     function _transfer(address _from, address _to, uint _oshiAmount) internal {
277         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
278         require(!frozenAccount[_from]);                     // Check if sender is frozen
279         require(!frozenAccount[_to]);                       // Check if recipient is frozen
280         balanceOf[_from] = balanceOf[_from].sub(_oshiAmount);    // Subtract from the sender
281         balanceOf[_to] = balanceOf[_to].add(_oshiAmount);        // Add the same to the recipient
282         emit Transfer(_from, _to, _oshiAmount);
283     }
284 
285     /// @notice Create `mintedOshiAmount` and send it to `target`
286     /// @param target Address to receive oshi
287     /// @param mintedOshiAmount the amount of oshi it will receive 
288     function mintToken(address target, uint256 mintedOshiAmount) onlyOwner public returns (bool) {
289         
290         balanceOf[target] = balanceOf[target].add(mintedOshiAmount);
291         totalSupply = totalSupply.add(mintedOshiAmount);
292         emit Transfer(0, address(this), mintedOshiAmount);
293         emit Transfer(address(this), target, mintedOshiAmount);
294         return true;
295     }
296 
297     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
298     /// @param target Address to be frozen
299     /// @param freeze either to freeze it or not
300     function freezeAccount(address target, bool freeze) onlyOwner public {
301         frozenAccount[target] = freeze;
302         emit FrozenFunds(target, freeze);
303     }
304 
305     /// @notice Allow users to buy adamcoins for `newBuyPrice` and sell adamcoins for `newSellPrice`
306     /// @param newSellPrice the Price in wei that users can sell to the contract
307     /// @param newBuyPrice the Price in wei that users can buy from the contract
308     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
309         sellPrice = newSellPrice;
310         buyPrice = newBuyPrice;
311     
312     }
313 
314    /* transfer amount of wei to owner*/
315 	function withdrawEther(uint256 amount) onlyOwner public {
316 		require(msg.sender == owner);
317 		owner.transfer(amount);
318 	}
319 	/// @notice This method can be used by the owner to extract sent tokens 
320 	/// or ethers to this contract.
321     /// @param _token The address of token contract that you want to recover
322     ///  set to 0 address in case of ether
323 	function claimTokens(address _token) onlyOwner public {
324         if (_token == 0x0) {
325             owner.transfer(address(this).balance);
326             return;
327         }
328 
329         TokenERC20 token = TokenERC20(_token);
330         uint balance = token.balanceOf(address(this));
331         token.transfer(owner, balance);
332         
333     }
334     
335     /// @notice Buy tokens from contract by sending ether
336     function() public payable {
337         
338         require(msg.value > 0);
339         require(purchasingAllowed);
340         uint tokens = (msg.value * M)/buyPrice; // calculates the amount
341         
342 	    pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(tokens); // update the pendingWithdrawals amount for buyer
343 	}
344 	
345 	/// @notice Withdraw the amount of pendingWithdrawals from contract
346     function withdrawAdamcoins() public {
347         require(purchasingAllowed);
348         uint withdrawalAmount = pendingWithdrawals[msg.sender]; // calculates withdrawal amount 
349         
350         pendingWithdrawals[msg.sender] = 0;
351         
352         _transfer(address(this), msg.sender, withdrawalAmount);    // makes the transfers
353        
354     }
355     
356     /// @notice Sell Adamcoins  to the contract
357     /// @param _adamcoinsAmountToSell amount of  Adamcoins to be sold
358     function sell(uint256 _adamcoinsAmountToSell) public {
359         require(sellingAllowed);
360         uint256 weiAmount = _adamcoinsAmountToSell.mul(sellPrice);
361         require(address(this).balance >= weiAmount);      // checks if the contract has enough ether to buy
362         uint adamcoinsAmountToSell = _adamcoinsAmountToSell * M;
363         _transfer(msg.sender, address(this), adamcoinsAmountToSell);              // makes the transfers
364         msg.sender.transfer(weiAmount);          // sends ether to the seller.
365     }
366     
367     
368 }