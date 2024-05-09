1 pragma solidity ^0.4.13;
2 contract owned {
3     address public owner;
4     mapping (address =>  bool) public admins;
5 
6     function owned() public {
7         owner = msg.sender;
8         admins[msg.sender]=true;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     modifier onlyAdmin   {
17         require(admins[msg.sender] == true);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public{
22         owner = newOwner;
23     }
24     function makeAdmin(address newAdmin, bool isAdmin) onlyOwner public{
25         admins[newAdmin] = isAdmin;
26     }
27 }
28 
29 interface tokenRecipient {
30     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
31 }
32 
33 contract Sivalicoin is owned {
34     // Public variables of the token
35     string public name;
36     string public symbol;
37     uint8 public decimals;
38     uint256 public totalSupply;
39     uint256 minBalanceForAccounts;
40     bool public usersCanTrade;
41     bool public usersCanUnfreeze;
42 
43     bool public ico = false; //turn ico on and of
44     mapping (address => bool) public admin;
45 
46 
47     modifier notICO {
48         require(admin[msg.sender] || !ico);
49         _;
50     }
51 
52 
53     // This creates an array with all balances
54     mapping (address => uint256) public balanceOf;
55 
56 
57     mapping (address => mapping (address => uint256)) public allowance;
58     mapping (address =>  bool) public frozen;
59 
60     mapping (address =>  bool) public canTrade; //user allowed to buy or sell
61 
62     // This generates a public event on the blockchain that will notify clients
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65 
66     // This notifies clients about the amount burnt
67     event Burn(address indexed from, uint256 value);
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Frozen(address indexed addr, bool frozen);
71 
72     // This generates a public event on the blockchain that will notify clients
73     event Unlock(address indexed addr, address from, uint256 val);
74 
75     // This generates a public event on the blockchain that will notify clients
76 
77 
78     // This generates a public event on the blockchain that will notify clients
79     // event Unfreeze(address indexed addr);
80 
81     /**
82      * Constrctor function
83      *
84      * Initializes contract with initial supply tokens to the creator of the contract
85      */
86     function Sivalicoin() public {
87         uint256 initialSupply = 26680000000000000000000000;
88         balanceOf[msg.sender] = initialSupply ;              // Give the creator all initial tokens
89         totalSupply = initialSupply;                        // Update total supply
90         name = "Sivalicoin";                                   // Set the name for display purposes
91         symbol = "SVC";                               // Set the symbol for display purposes
92         decimals = 18;                            // Amount of decimals for display purposes
93         minBalanceForAccounts = 1000000000000000;
94         usersCanTrade=false;
95         usersCanUnfreeze=false;
96         admin[msg.sender]=true;
97         canTrade[msg.sender]=true;
98 
99     }
100 
101     /**
102      * Increace Total Supply
103      *
104      * Increases the total coin supply
105      */
106     function increaseTotalSupply (address target,  uint256 increaseBy )  onlyOwner public {
107         balanceOf[target] += increaseBy;
108         totalSupply += increaseBy;
109         Transfer(0, owner, increaseBy);
110         Transfer(owner, target, increaseBy);
111     }
112 
113     function  usersCanUnFreeze(bool can) public{
114         usersCanUnfreeze=can;
115     }
116 
117     function setMinBalance(uint minimumBalanceInWei) onlyOwner public{
118         minBalanceForAccounts = minimumBalanceInWei;
119     }
120 
121     /**
122      * transferAndFreeze
123      *
124      * Function to transfer to and freeze and account at the same time
125      */
126     function transferAndFreeze (address target,  uint256 amount )  onlyAdmin public{
127         _transfer(msg.sender, target, amount);
128         freeze(target, true);
129     }
130 
131     /**
132      * _freeze internal
133      *
134      * function to freeze an account
135      */
136     function _freeze (address target, bool froze )  internal  {
137 
138         frozen[target]=froze;
139         Frozen(target, froze);
140     }
141 
142 
143 
144     /**
145      * freeze
146      *
147      * function to freeze an account
148      */
149     function freeze (address target, bool froze ) public  {
150         if(froze || (!froze && !usersCanUnfreeze)) {
151             require(admin[msg.sender]);
152         }
153 
154         _freeze(target, froze);
155     }
156 
157 
158 
159     /**
160      * Internal transfer, only can be called by this contract
161      */
162     function _transfer(address _from, address _to, uint _value) internal {
163         require(_to != 0x0);                                   // Prevent transfer to 0x0 address. Use burn() instead
164 
165         require(!frozen[_from]);                       //prevent transfer from frozen address
166         require(balanceOf[_from] >= _value);                // Check if the sender has enough
167         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
168         balanceOf[_from] -= _value;                         // Subtract from the sender
169         balanceOf[_to] += _value;                           // Add the same to the recipient
170         Transfer(_from, _to, _value);
171     }
172 
173     /**
174      * Transfer tokens
175      *
176      * Send `_value` tokens to `_to` from your account
177      *
178      * @param _to The address of the recipient
179      * @param _value the amount to send
180      */
181     function transfer(address _to, uint256 _value) notICO public{
182         require(!frozen[msg.sender]);                       //prevent transfer from frozen address
183         _transfer(msg.sender, _to, _value);
184     }
185 
186 
187 
188     /**
189      * Transfer tokens from other address
190      *
191      * Send `_value` tokens to `_to` in behalf of `_from`
192      *
193      * @param _from The address of the sender
194      * @param _to The address of the recipient
195      * @param _value the amount to send
196      */
197     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
198         require(!frozen[_from]);                       //prevent transfer from frozen address
199         require(_value <= allowance[_from][msg.sender]);     // Check allowance
200         allowance[_from][msg.sender] -= _value;
201         _transfer(_from, _to, _value);
202         return true;
203     }
204 
205     /**
206      * Set allowance for other address
207      *
208      * Allows `_spender` to spend no more than `_value` tokens in your behalf
209      *
210      * @param _spender The address authorized to spend
211      * @param _value the max amount they can spend
212      */
213     function approve(address _spender, uint256 _value) public returns (bool success) {
214         allowance[msg.sender][_spender] = _value;
215         return true;
216     }
217 
218     /**
219      * Set allowance for other address and notify
220      *
221      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
222      *
223      * @param _spender The address authorized to spend
224      * @param _value the max amount they can spend
225      * @param _extraData some extra information to send to the approved contract
226      */
227     function approveAndCall(address _spender, uint256 _value, bytes _extraData) onlyOwner public returns (bool success) {
228         tokenRecipient spender = tokenRecipient(_spender);
229         if (approve(_spender, _value)) {
230             spender.receiveApproval(msg.sender, _value, this, _extraData);
231             return true;
232         }
233     }
234 
235     /**
236      * Destroy tokens
237      *
238      * Remove `_value` tokens from the system irreversibly
239      *
240      * @param _value the amount of money to burn
241      */
242     function burn(uint256 _value) onlyOwner public returns (bool success) {
243         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
244         balanceOf[msg.sender] -= _value;            // Subtract from the sender
245         totalSupply -= _value;                      // Updates totalSupply
246         Burn(msg.sender, _value);
247         return true;
248     }
249 
250     /**
251      * Destroy tokens from other ccount
252      *
253      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
254      *
255      * @param _from the address of the sender
256      * @param _value the amount of money to burn
257      */
258     function burnFrom(address _from, uint256 _value) public returns (bool success) {
259         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
260         require(_value <= allowance[_from][msg.sender]);    // Check allowance
261         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
262         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
263         totalSupply -= _value;                              // Update totalSupply
264         Burn(_from, _value);
265         return true;
266     }
267 
268     /*
269      function increaseSupply(address _from, uint256 _value) onlyOwner  returns (bool success)  {
270      balanceOf[_from] += _value;                         // Subtract from the targeted balance
271      totalSupply += _value;                              // Update totalSupply
272      // Burn(_from, _value);
273      return true;
274      }
275      */
276 
277 
278 
279 
280     uint256 public sellPrice = 1;
281     uint256 public buyPrice = 1000000000000000;
282 
283     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
284         sellPrice = newSellPrice;
285         buyPrice = newBuyPrice;
286     }
287     function setUsersCanTrade(bool trade) public onlyOwner {
288         usersCanTrade=trade;
289     }
290     function setCanTrade(address addr, bool trade) public onlyOwner {
291         canTrade[addr]=trade;
292     }
293 
294     //user is buying SVC
295     function buy() payable public returns (uint256 amount){
296         if(!usersCanTrade && !canTrade[msg.sender]) revert();
297         amount = msg.value * buyPrice;                    // calculates the amount
298 
299         require(balanceOf[this] >= amount);               // checks if it has enough to sell
300         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
301         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
302         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
303         return amount;                                    // ends function and returns
304     }
305 
306     //user is selling us SVC, we are selling eth to the user
307     function sell(uint256 amount) public returns (uint revenue){
308         require(!frozen[msg.sender]);
309         if(!usersCanTrade && !canTrade[msg.sender]) {
310             require(minBalanceForAccounts > amount/sellPrice);
311         }
312         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
313         balanceOf[this] += amount;                        // adds the amount to owner's balance
314         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
315         revenue = amount / sellPrice;
316         require(msg.sender.send(revenue));                // sends ether to the seller: it's important to do this last to prevent recursion attacks
317         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
318         return revenue;                                   // ends function and returns
319     }
320 
321     function() payable public {
322     }
323     event Withdrawn(address indexed to, uint256 value);
324     function withdraw(address target, uint256 amount) public onlyOwner {
325         target.transfer(amount);
326         Withdrawn(target, amount);
327     }
328 
329     function setAdmin(address addr, bool enabled) public onlyOwner {
330         admin[addr]=enabled;
331     }
332 
333     function setICO(bool enabled) public onlyOwner {
334         ico=enabled;
335     }
336 }