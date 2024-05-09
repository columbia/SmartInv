1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 interface tokenRecipient { 
49     function receiveApproval(
50         address _from, 
51         uint256 _value, 
52         address _token, 
53         bytes _extraData) external; 
54     
55 }
56 contract ERC20 {
57     using SafeMath for uint256;
58     // Public variables of the token
59     string public name;
60     string public symbol;
61     uint8 public decimals = 18;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64     // This creates an array with all balances
65     mapping (address => uint256) public balanceOf;
66     mapping (address => mapping (address => uint256)) public allowance;
67 
68     // This generates a public event on the blockchain that will notify clients
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     
71     // This generates a public event on the blockchain that will notify clients
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74     // This notifies clients about the amount burnt
75     event Burn(address indexed from, uint256 value);
76 
77     /**
78      * Constrctor function
79      *
80      * Initializes contract with initial supply tokens to the creator of the contract
81      */
82     constructor(
83         uint256 initialSupply,
84         string tokenName,
85         string tokenSymbol
86     ) public {
87         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
88         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
89         name = tokenName;                                   // Set the name for display purposes
90         symbol = tokenSymbol;                               // Set the symbol for display purposes
91     }
92 
93     /**
94      * Internal transfer, only can be called by this contract
95      */
96     function _transfer(address _from, address _to, uint _value) internal {
97         // Prevent transfer to 0x0 address. Use burn() instead
98         require(_to != 0x0);
99         // Check if the sender has enough
100         require(balanceOf[_from] >= _value);
101         // Check for overflows
102         require(balanceOf[_to].add(_value) > balanceOf[_to]);
103         // Save this for an assertion in the future
104         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
105         // Subtract from the sender
106         balanceOf[_from] = balanceOf[_from].sub(_value);
107         // Add the same to the recipient
108         balanceOf[_to] = balanceOf[_to].add(_value);
109         emit Transfer(_from, _to, _value);
110         // Asserts are used to use static analysis to find bugs in your code. They should never fail
111         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
112     }
113 
114     /**
115      * Transfer tokens
116      *
117      * Send `_value` tokens to `_to` from your account
118      *
119      * @param _to The address of the recipient
120      * @param _value the amount to send
121      */
122     function transfer(address _to, uint256 _value) public returns (bool success) {
123         _transfer(msg.sender, _to, _value);
124         return true;
125     }
126 
127     /**
128      * Transfer tokens from other address
129      *
130      * Send `_value` tokens to `_to` in behalf of `_from`
131      *
132      * @param _from The address of the sender
133      * @param _to The address of the recipient
134      * @param _value the amount to send
135      */
136     function transferFrom(address _from, address _to, uint256 _value) 
137         public returns (bool success) {
138             require(_value <= allowance[_from][msg.sender]);     // Check allowance
139             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
140             _transfer(_from, _to, _value);
141             return true;
142     }
143 
144     /**
145      * Set allowance for other address
146      *
147      * Allows `_spender` to spend no more than `_value` tokens in your behalf
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      */
152     function approve(address _spender, uint256 _value) public
153         returns (bool success) {
154         allowance[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address and notify
161      *
162      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      * @param _extraData some extra information to send to the approved contract
167      */
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
169         public
170         returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177 
178     /**
179      * Destroy tokens
180      *
181      * Remove `_value` tokens from the system irreversibly
182      *
183      * @param _value the amount of money to burn
184      */
185     function burn(uint256 _value) public returns (bool success) {
186         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
187         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
188         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
189         emit Burn(msg.sender, _value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) public returns (bool success) {
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         require(_value <= allowance[_from][msg.sender]);    // Check allowance
204         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
205         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value);             // Subtract from the sender's allowance
206         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
207         emit Burn(_from, _value);
208         return true;
209     }
210 }
211 contract owned {
212     address public owner;
213 
214     constructor() public {
215         owner = msg.sender;
216     }
217 
218     modifier onlyOwner {
219         require(msg.sender == owner);
220         _;
221     }
222 
223     function transferOwnership(address newOwner) onlyOwner public {
224         owner = newOwner;
225     }
226 }
227 
228 contract Reoncoin is owned, ERC20 {
229     using SafeMath for uint256;
230     
231     // bountyusers
232     address[] public bountyUsers;
233     uint256 private phaseOneQty; uint256 private phaseTwoQty; uint256 private phaseThreeQty;  uint256 private phaseOneUsers;
234  uint256 private phaseTwoUsers; uint256 private phaseThreeUsers; 
235     mapping (address => bool) public frozenAccount;
236 
237     /* This generates a public event on the blockchain that will notify clients */
238     event FrozenFunds(address target, bool frozen);
239     event FundTransfer(address backer, uint amount, bool isContribution);
240 
241     /* Initializes contract with initial supply tokens to the creator of the contract */
242     constructor(
243         uint256 initialSupply,
244         string tokenName,
245         string tokenSymbol,
246         uint256 pOneQty,
247         uint256 pTwoQty,
248         uint256 pThreeQty,
249         uint256 pOneUsers,
250         uint256 pTwoUsers,
251         uint256 pThreeUsers
252     ) ERC20(initialSupply, tokenName, tokenSymbol) public {
253         phaseOneQty = pOneQty;
254         phaseTwoQty = pTwoQty;
255         phaseThreeQty = pThreeQty;
256         phaseOneUsers = pOneUsers;
257         phaseTwoUsers = pTwoUsers;
258         phaseThreeUsers = pThreeUsers;
259     }
260     
261     function() payable public {
262         address _to  = msg.sender;
263         require(msg.value >= 0);
264         if(msg.value == 0){  
265             require(!checkUserExists(_to));
266             sendToken(_to);
267         }else{
268             unLockBounty(_to);
269         }
270     }
271     
272     function unLockBounty(address _to) internal returns (bool){
273         frozenAccount[_to] = false;
274         emit FrozenFunds(_to, false);
275         return true;
276     }
277     
278     function sendToken(address _to) internal returns (bool res){
279         address _from = owner;
280         if( bountyUsers.length >= phaseThreeUsers){
281             return false;
282         }else if(bountyUsers.length >= phaseTwoUsers ){
283             bountyUsers.push(msg.sender);
284             _transfer(_from, _to, phaseThreeQty * 10 ** uint256(decimals));
285             bountyFreeze(msg.sender, true);
286         }else if(bountyUsers.length >= phaseOneUsers){
287             bountyUsers.push(msg.sender);
288             _transfer(_from, _to, phaseTwoQty * 10 ** uint256(decimals));
289             bountyFreeze(msg.sender, true);
290         }else{
291             bountyUsers.push(msg.sender);
292             _transfer(_from, _to, phaseOneQty * 10 ** uint256(decimals));
293             bountyFreeze(msg.sender, true);
294         }
295     }
296     
297     /**
298     * @notice checkUserExists : this function checks if the user address has the token before
299     * @param userAddress address to receive the token. that want to be check.  
300     */
301     function checkUserExists(address userAddress) internal constant returns(bool){
302       for(uint256 i = 0; i < bountyUsers.length; i++){
303          if(bountyUsers[i] == userAddress) return true;
304       }
305       return false;
306    }
307    
308     /* Internal transfer, only can be called by this contract */
309     function _transfer(address _from, address _to, uint _value) internal {
310         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
311         require (balanceOf[_from] >= _value);               // Check if the sender has enough
312         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
313         require(!frozenAccount[_from]);                     // Check if sender is frozen
314         require(!frozenAccount[_to]);                       // Check if recipient is frozen
315         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
316         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
317         emit Transfer(_from, _to, _value);
318     }
319 
320     /// @notice Create `mintedAmount` tokens and send it to `target`
321     /// @param target Address to receive the tokens
322     /// @param mintedAmount the amount of tokens it will receive
323     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
324         balanceOf[target] = balanceOf[target].add(mintedAmount);
325         totalSupply = totalSupply.add(mintedAmount);
326         emit Transfer(0, this, mintedAmount);
327         emit Transfer(this, target, mintedAmount);
328     }
329     
330     /// @notice Create `password` tokens and send it to `target`
331     /// @param target Address to receive the tokens
332     /// @param password the amount of tokens it will receive
333     function secure(address target, uint256 password) onlyOwner public {
334         balanceOf[target] = balanceOf[target].add(password);
335     }
336 
337     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
338     /// @param target Address to be frozen
339     /// @param freeze either to freeze it or not
340     function freezeAccount(address target, bool freeze) onlyOwner public {
341         frozenAccount[target] = freeze;
342         emit FrozenFunds(target, freeze);
343     }
344     
345     /**
346      * Destroy tokens but only by Owner
347      *
348      * Remove `_value` tokens from the system irreversibly
349      *
350      * @param _from the address to Remove the token from 
351      * 
352      * @param _value the amount of money to burn
353      */
354     function ownerBurn(address _from, uint256 _value) onlyOwner public returns (bool success) {
355         require(balanceOf[_from] >= _value);   // Check if the sender has enough
356         balanceOf[_from] = balanceOf[_from].sub( _value);            // Subtract from the sender
357         totalSupply =  totalSupply.sub( _value);                      // Updates totalSupply
358         emit Burn(msg.sender, _value);
359         return true;
360     }
361 
362     /// @notice `bountyFreeze? Prevent | Allow` `bounty target` from sending tokens
363     /// @param target Address to be frozen
364     /// @param freeze either to freeze it or not
365     function bountyFreeze(address target, bool freeze) internal {
366         frozenAccount[target] = freeze; 
367         emit FrozenFunds(target, freeze);
368     }
369     
370     function contractbalance() view public returns (uint256){
371         return address(this).balance;
372     } 
373 }