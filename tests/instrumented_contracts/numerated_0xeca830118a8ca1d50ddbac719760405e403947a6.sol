1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     address public admin;
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19     
20     function adminCreat(address _admin) onlyOwner public {
21        admin = _admin;
22     }
23 
24     modifier onlyAdmin {
25         require(msg.sender == admin);
26         _;
27     }
28 
29     function transferAdmin(address newAdmin) onlyOwner public {
30         admin = newAdmin;
31     }
32     
33     
34     
35     
36 }
37 
38 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
39 
40 contract TokenERC20 {
41     // Public variables of the token
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     // 18 decimals is the strongly suggested default, avoid changing it
46     uint256 public totalSupply;
47 
48     // This creates an array with all balances
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52     // This generates a public event on the blockchain that will notify clients
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     // This notifies clients about the amount burnt
56     event Burn(address indexed from, uint256 value);
57 
58     /**
59      * Constrctor function
60      *
61      * Initializes contract with initial supply tokens to the creator of the contract
62      */
63     function TokenERC20(
64         uint256 initialSupply,
65         string tokenName,
66         string tokenSymbol
67     ) public {
68         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
69         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
70         name = tokenName;                                   // Set the name for display purposes
71         symbol = tokenSymbol;                               // Set the symbol for display purposes
72     }
73 
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != 0x0);
80         // Check if the sender has enough
81         require(balanceOf[_from] >= _value);
82         // Check for overflows
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         // Save this for an assertion in the future
85         uint previousBalances = balanceOf[_from] + balanceOf[_to];
86         // Subtract from the sender
87         balanceOf[_from] -= _value;
88         // Add the same to the recipient
89         balanceOf[_to] += _value;
90         Transfer(_from, _to, _value);
91         // Asserts are used to use static analysis to find bugs in your code. They should never fail
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 
95     /**
96      * Transfer tokens
97      *
98      * Send `_value` tokens to `_to` from your account
99      *
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transfer(address _to, uint256 _value) public {
104         _transfer(msg.sender, _to, _value);
105     }
106 
107     /**
108      * Transfer tokens from other address
109      *
110      * Send `_value` tokens to `_to` in behalf of `_from`
111      *
112      * @param _from The address of the sender
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= allowance[_from][msg.sender]);     // Check allowance
118         allowance[_from][msg.sender] -= _value;
119         _transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      */
131     function approve(address _spender, uint256 _value) public
132         returns (bool success) {
133         allowance[msg.sender][_spender] = _value;
134         return true;
135     }
136 
137     /**
138      * Set allowance for other address and notify
139      *
140      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      * @param _extraData some extra information to send to the approved contract
145      */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
147         public
148         returns (bool success) {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 
156     /**
157      * Destroy tokens
158      *
159      * Remove `_value` tokens from the system irreversibly
160      *
161      * @param _value the amount of money to burn
162      */
163     function burn(uint256 _value) public returns (bool success) {
164         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
165         balanceOf[msg.sender] -= _value;            // Subtract from the sender
166         totalSupply -= _value;                      // Updates totalSupply
167         Burn(msg.sender, _value);
168         return true;
169     }
170 
171     /**
172      * Destroy tokens from other ccount
173      *
174      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
175      *
176      * @param _from the address of the sender
177      * @param _value the amount of money to burn
178      */
179     function burnFrom(address _from, uint256 _value) public returns (bool success) {
180         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
181         require(_value <= allowance[_from][msg.sender]);    // Check allowance
182         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
183         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
184         totalSupply -= _value;                              // Update totalSupply
185         Burn(_from, _value);
186         return true;
187     }
188 }
189 
190 contract Membership is owned {
191   //  address public owner;
192     mapping (address => uint) public memberId;
193     mapping (address => uint) balances;
194     Member[] public members;
195     
196     uint256 public totalSupply;
197     
198     
199     
200     event MembershipChanged(address member, bool isMember);
201 
202     struct Member {
203         address member;
204         string name;
205         uint memberSince;
206     }
207     
208         modifier onlyMembers {
209         require(memberId[msg.sender] != 0);
210         _;
211     }
212     
213         function addMember(address targetMember, string memberName) onlyOwner public {
214         uint id = memberId[targetMember];
215         if (id == 0) {
216             memberId[targetMember] = members.length;
217             id = members.length++;
218         }
219 
220         members[id] = Member({member: targetMember, memberSince: now, name: memberName});
221         MembershipChanged(targetMember, true);
222     }
223     
224         function removeMember(address targetMember) onlyOwner public {
225         require(memberId[targetMember] != 0);
226 
227         for (uint i = memberId[targetMember]; i<members.length-1; i++){
228             members[i] = members[i+1];
229         }
230         delete members[members.length-1];
231         members.length--;
232     }
233     
234     
235 }
236 
237 /******************************************/
238 /*       ADVANCED TOKEN STARTS HERE       */
239 /******************************************/
240 
241 contract bonusToken is owned, TokenERC20, Membership  {
242 
243     uint256 public sellPrice;
244     uint256 public buyPrice;
245     uint256 public dividend;
246     uint256 public pantry;
247     uint256 public pantryT;
248     uint256 public stopSetPrice = 1000000000000000000000000;
249 
250     mapping (address => bool) public frozenAccount;
251 
252     /* This generates a public event on the blockchain that will notify clients */
253     event FrozenFunds(address target, bool frozen);
254 
255     /* Initializes contract with initial supply tokens to the creator of the contract */
256     function bonusToken(
257         uint256 initialSupply,
258         string tokenName,
259         string tokenSymbol
260     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
261     }
262 
263     /* Internal transfer, only can be called by this contract */
264     function _transfer(address _from, address _to, uint _value) internal {
265         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
266         require (balanceOf[_from] > _value);                // Check if the sender has enough
267         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
268         require(!frozenAccount[_from]);                     // Check if sender is frozen
269         require(!frozenAccount[_to]);                       // Check if recipient is frozen
270         balanceOf[_from] -= _value;                         // Subtract from the sender
271         balanceOf[_to] += _value;                           // Add the same to the recipient
272         Transfer(_from, _to, _value);
273     }
274 
275     /// @notice Create `mintedAmount` tokens and send it to `target`
276     /// @param target Address to receive the tokens
277     /// @param mintedAmount the amount of tokens it will receive
278     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
279         balanceOf[target] += mintedAmount;
280         totalSupply += mintedAmount;
281         Transfer(0, this, mintedAmount);
282         Transfer(this, target, mintedAmount);
283     }
284     
285     /// Internal executable function for creating new tokens. Including 10% accumulation for members.
286         function _mintToken(address target, uint256 mintedAmount) internal {
287         balanceOf[target] += mintedAmount;
288         totalSupply += mintedAmount;
289         Transfer(0, this, mintedAmount);
290         Transfer(this, target, mintedAmount);
291         dividend += mintedAmount / 10;
292         totalSupply += mintedAmount / 10;
293     }
294 
295    
296 
297     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
298     /// @param target Address to be frozen
299     /// @param freeze either to freeze it or not
300     function freezeAccount(address target, bool freeze) onlyOwner public {
301         frozenAccount[target] = freeze;
302         FrozenFunds(target, freeze);
303     }
304 
305     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
306     /// @param newSellPrice Price the users can sell to the contract
307     /// @param newBuyPrice Price users can buy from the contract
308     /// After reaching the total release of tokens at the level specified. in variable stopSetPrice, the function is not accessible
309     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
310         require (totalSupply <= stopSetPrice) ;
311         sellPrice = newSellPrice;
312         buyPrice = newBuyPrice;
313     }
314 
315     /// @notice Buy tokens from contract by sending ether
316     function buy() payable public {
317         uint amount = msg.value * buyPrice;               // calculates the amount
318         _mintToken(msg.sender, amount);                    //
319        // _transfer(this, msg.sender, amount);              // makes the transfers
320     }
321 
322     /// @notice Sell `amount` tokens to contract * 10 ** (decimals))
323     /// @param amount amount of tokens to be sold
324     function sell(uint256 amount) public {
325         amount = amount * 10 ** uint256(decimals) ;
326         require(this.balance >= amount / sellPrice);      // checks if the contract has enough ether to buy
327         _transfer(msg.sender, this, amount);              // makes the transfers
328         msg.sender.transfer(amount / sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
329     }
330 
331     ///The distribution function, accumulated tokens on a variable dividend among members
332         function dividendDistribution () onlyOwner public {
333          Transfer(0, this, dividend);
334          uint256 divsum = dividend / members.length; 
335          dividend = 0;
336          for (uint i = 0; i < members.length; i++) {
337         address AdToDiv = members[i].member ;
338          balanceOf[AdToDiv] += divsum;
339          Transfer(this, AdToDiv, divsum);
340                 }
341        
342 }
343     /// The function of requesting balances of the smart contract for Wei and tokens.
344     function remainPantry () onlyOwner public returns (uint256, uint256) {
345         pantry = this.balance;
346         pantryT = balanceOf[this];
347         
348         return (pantry, pantryT);
349              
350            
351     }
352     
353     /// Pile robbery function of pantry owner contract. (Ethers)
354     /// When entering a parameter - use only whole Ethers !!!
355     function robPantry (address target, uint256 amount) onlyOwner public {
356         uint256 rob = amount * 10 ** uint256(decimals) ;
357         require(rob <= this.balance);
358         target.transfer(rob);
359     }
360     
361     /// The function of creating and crediting tokens for retail customers, participants of the bonus program. 
362     /// It is used only by the Administrator of the settlement system.
363     /// 
364      function mintToClient(address client, uint256 amount) onlyAdmin public {
365         _mintToken(client, amount);                    //
366         
367     
368 }
369      /// Pile robbery function of pantry owner contract. (tokens)
370         function robPantryT (address target, uint256 amount) onlyOwner public {
371         require(amount <= balanceOf[this]);
372         balanceOf[this] -= amount;                         // Subtract from the sender
373         balanceOf[target] += amount;                           // Add the same to the recipient
374         Transfer(this, target, amount);
375      }
376 }