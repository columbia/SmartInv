1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4     mapping (address =>  bool) public admins;
5 
6     function owned() {
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
21     function transferOwnership(address newOwner) onlyOwner {
22         owner = newOwner;
23     }
24     function makeAdmin(address newAdmin, bool isAdmin) onlyOwner {
25         admins[newAdmin] = isAdmin;
26     }
27 }
28 
29 interface tokenRecipient {
30     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
31 }
32 
33 contract ETD is owned {
34     // Public variables of the token
35     string public name;
36     string public symbol;
37     uint8 public decimals;
38     uint256 public totalSupply;
39     uint256 minBalanceForAccounts;
40     bool public usersCanTrade;
41     bool public usersCanUnfreeze;
42 
43     bool public ico = true; //turn ico on and of
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
65     //This generates a public even on the blockhcain when an address is reward
66     event Reward(address from, address to, uint256 value, string data, uint256 time);
67 
68     // This notifies clients about the amount burnt
69     event Burn(address indexed from, uint256 value);
70 
71     // This generates a public event on the blockchain that will notify clients
72     event Frozen(address indexed addr, bool frozen);
73 
74     // This generates a public event on the blockchain that will notify clients
75     event Unlock(address indexed addr, address from, uint256 val);
76 
77     // This generates a public event on the blockchain that will notify clients
78 
79 
80     // This generates a public event on the blockchain that will notify clients
81     // event Unfreeze(address indexed addr);
82 
83     /**
84      * Constrctor function
85      *
86      * Initializes contract with initial supply tokens to the creator of the contract
87      */
88     function ETD() {
89         uint256 initialSupply = 20000000000000000000000000;
90         balanceOf[msg.sender] = initialSupply ;              // Give the creator all initial tokens
91         totalSupply = initialSupply;                        // Update total supply
92         name = "EthereumDiamond";                                   // Set the name for display purposes
93         symbol = "ETD";                               // Set the symbol for display purposes
94         decimals = 18;                            // Amount of decimals for display purposes
95         minBalanceForAccounts = 1000000000000000;
96         usersCanTrade=false;
97         usersCanUnfreeze=false;
98         admin[msg.sender]=true;
99         canTrade[msg.sender]=true;
100 
101     }
102 
103     /**
104      * Increace Total Supply
105      *
106      * Increases the total coin supply
107      */
108     function increaseTotalSupply (address target,  uint256 increaseBy )  onlyOwner {
109         balanceOf[target] += increaseBy;
110         totalSupply += increaseBy;
111         Transfer(0, owner, increaseBy);
112         Transfer(owner, target, increaseBy);
113     }
114 
115     function  usersCanUnFreeze(bool can) {
116         usersCanUnfreeze=can;
117     }
118 
119     function setMinBalance(uint minimumBalanceInWei) onlyOwner {
120         minBalanceForAccounts = minimumBalanceInWei;
121     }
122 
123     /**
124      * transferAndFreeze
125      *
126      * Function to transfer to and freeze and account at the same time
127      */
128     function transferAndFreeze (address target,  uint256 amount )  onlyAdmin {
129         _transfer(msg.sender, target, amount);
130         freeze(target, true);
131     }
132 
133     /**
134      * _freeze internal
135      *
136      * function to freeze an account
137      */
138     function _freeze (address target, bool froze )  internal  {
139 
140         frozen[target]=froze;
141         Frozen(target, froze);
142     }
143 
144 
145 
146     /**
147      * freeze
148      *
149      * function to freeze an account
150      */
151     function freeze (address target, bool froze )   {
152         if(froze || (!froze && !usersCanUnfreeze)) {
153             require(admin[msg.sender]);
154         }
155 
156         _freeze(target, froze);
157     }
158 
159 
160 
161     /**
162      * Internal transfer, only can be called by this contract
163      */
164     function _transfer(address _from, address _to, uint _value) internal {
165         require(_to != 0x0);                                   // Prevent transfer to 0x0 address. Use burn() instead
166 
167         require(!frozen[_from]);                       //prevent transfer from frozen address
168         require(balanceOf[_from] >= _value);                // Check if the sender has enough
169         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
170         balanceOf[_from] -= _value;                         // Subtract from the sender
171         balanceOf[_to] += _value;                           // Add the same to the recipient
172         Transfer(_from, _to, _value);
173     }
174 
175     /**
176      * Transfer tokens
177      *
178      * Send `_value` tokens to `_to` from your account
179      *
180      * @param _to The address of the recipient
181      * @param _value the amount to send
182      */
183     function transfer(address _to, uint256 _value) notICO {
184         require(!frozen[msg.sender]);                       //prevent transfer from frozen address
185         if (msg.sender.balance  < minBalanceForAccounts) {
186             sell((minBalanceForAccounts - msg.sender.balance) * sellPrice);
187         }
188         _transfer(msg.sender, _to, _value);
189     }
190 
191 
192 
193     mapping (address => uint256) public totalLockedRewardsOf;
194     mapping (address => mapping (address => uint256)) public lockedRewardsOf; //balance of a locked reward
195     mapping (address => mapping (uint32  => address)) public userRewarders; //indexed list of rewardees rewarder
196     mapping (address => mapping (address => uint32)) public userRewardCount; //a list of number of times a customer has received reward from a given merchant
197     mapping (address => uint32) public userRewarderCount; //number of rewarders per customer
198 
199     //merchant
200     mapping (address =>  uint256  ) public totalRewardIssuedOut;
201 
202     /**
203      * Reward tokens - tokens go to
204      *
205      * Send `_value` tokens to `_to` from your account
206      *
207      * @param _to The address of the recipient
208      * @param _value the amount to send
209      */
210     function reward(address _to, uint256 _value, bool locked, string data) {
211         require(_to != 0x0);
212         require(!frozen[msg.sender]);                       //prevent transfer from frozen address
213         if (msg.sender.balance  < minBalanceForAccounts) {
214             sell((minBalanceForAccounts - msg.sender.balance) * sellPrice);
215         }
216         if(!locked) {
217             _transfer(msg.sender, _to, _value);
218         }else{
219             //prevent transfer from frozen address
220             require(balanceOf[msg.sender] >= _value);                // Check if the sender has enough
221             require(totalLockedRewardsOf[_to] + _value > totalLockedRewardsOf[_to]); // Check for overflows
222             balanceOf[msg.sender] -= _value;                         // Subtract from the sender
223             totalLockedRewardsOf[_to] += _value;                           // Add the same to the recipient
224             lockedRewardsOf[_to][msg.sender] += _value;
225             if(userRewardCount[_to][msg.sender]==0) {
226                 userRewarderCount[_to] += 1;
227                 userRewarders[_to][userRewarderCount[_to]]=msg.sender;
228             }
229             userRewardCount[_to][msg.sender]+=1;
230             totalRewardIssuedOut[msg.sender]+= _value;
231             Transfer(msg.sender, _to, _value);
232         }
233 
234         Reward(msg.sender, _to, _value, data, now);
235     }
236 
237     /**
238      * Transfer locked rewards
239      *
240      * Send `_value` tokens to `_to` merchant
241      *
242      * @param _to The address of the recipient
243      * @param _value the amount to send
244      */
245     function transferReward(address _to, uint256 _value) {
246         require(!frozen[msg.sender]);                       //prevent transfer from frozen address
247         require(lockedRewardsOf[msg.sender][_to] >= _value );
248         require(totalLockedRewardsOf[msg.sender] >= _value);
249 
250         if (msg.sender.balance  < minBalanceForAccounts) {
251             sell((minBalanceForAccounts - msg.sender.balance) * sellPrice);
252         }
253         totalLockedRewardsOf[msg.sender] -= _value;                           // Add the same to the recipient
254         lockedRewardsOf[msg.sender][_to] -= _value;
255         balanceOf[_to] += _value;
256         Transfer(msg.sender, _to, _value);
257     }
258 
259     /**
260      * Unlocked locked rewards by merchant
261      *
262      * Unlock `_value` tokens of `add`
263      *
264      * @param addr The address of the recipient
265      * @param _value the amount to unlock
266      */
267     function unlockReward(address addr, uint256 _value) {
268         require(totalLockedRewardsOf[addr] > _value);                       //prevent transfer from frozen address
269         require(lockedRewardsOf[addr][msg.sender] >= _value );
270         if(_value==0) _value=lockedRewardsOf[addr][msg.sender];
271         if (msg.sender.balance  < minBalanceForAccounts) {
272             sell((minBalanceForAccounts - msg.sender.balance) * sellPrice);
273         }
274         totalLockedRewardsOf[addr] -= _value;                           // Add the same to the recipient
275         lockedRewardsOf[addr][msg.sender] -= _value;
276         balanceOf[addr] += _value;
277         Unlock(addr, msg.sender, _value);
278     }
279 
280 
281 
282     /**
283      * Transfer tokens from other address
284      *
285      * Send `_value` tokens to `_to` in behalf of `_from`
286      *
287      * @param _from The address of the sender
288      * @param _to The address of the recipient
289      * @param _value the amount to send
290      */
291     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
292         require(!frozen[_from]);                       //prevent transfer from frozen address
293         require(_value <= allowance[_from][msg.sender]);     // Check allowance
294         allowance[_from][msg.sender] -= _value;
295         _transfer(_from, _to, _value);
296         return true;
297     }
298 
299     /**
300      * Set allowance for other address
301      *
302      * Allows `_spender` to spend no more than `_value` tokens in your behalf
303      *
304      * @param _spender The address authorized to spend
305      * @param _value the max amount they can spend
306      */
307     function approve(address _spender, uint256 _value)
308     returns (bool success) {
309         allowance[msg.sender][_spender] = _value;
310         return true;
311     }
312 
313     /**
314      * Set allowance for other address and notify
315      *
316      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
317      *
318      * @param _spender The address authorized to spend
319      * @param _value the max amount they can spend
320      * @param _extraData some extra information to send to the approved contract
321      */
322     function approveAndCall(address _spender, uint256 _value, bytes _extraData) onlyOwner
323     returns (bool success) {
324         tokenRecipient spender = tokenRecipient(_spender);
325         if (approve(_spender, _value)) {
326             spender.receiveApproval(msg.sender, _value, this, _extraData);
327             return true;
328         }
329     }
330 
331     /**
332      * Destroy tokens
333      *
334      * Remove `_value` tokens from the system irreversibly
335      *
336      * @param _value the amount of money to burn
337      */
338     function burn(uint256 _value) onlyOwner returns (bool success) {
339         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
340         balanceOf[msg.sender] -= _value;            // Subtract from the sender
341         totalSupply -= _value;                      // Updates totalSupply
342         Burn(msg.sender, _value);
343         return true;
344     }
345 
346     /**
347      * Destroy tokens from other ccount
348      *
349      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
350      *
351      * @param _from the address of the sender
352      * @param _value the amount of money to burn
353      */
354     function burnFrom(address _from, uint256 _value)  returns (bool success) {
355         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
356         require(_value <= allowance[_from][msg.sender]);    // Check allowance
357         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
358         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
359         totalSupply -= _value;                              // Update totalSupply
360         Burn(_from, _value);
361         return true;
362     }
363 
364     /*
365      function increaseSupply(address _from, uint256 _value) onlyOwner  returns (bool success)  {
366      balanceOf[_from] += _value;                         // Subtract from the targeted balance
367      totalSupply += _value;                              // Update totalSupply
368      // Burn(_from, _value);
369      return true;
370      }
371      */
372 
373 
374 
375 
376     uint256 public sellPrice = 608;
377     uint256 public buyPrice = 760;
378 
379     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
380         sellPrice = newSellPrice;
381         buyPrice = newBuyPrice;
382     }
383     function setUsersCanTrade(bool trade) onlyOwner {
384         usersCanTrade=trade;
385     }
386     function setCanTrade(address addr, bool trade) onlyOwner {
387         canTrade[addr]=trade;
388     }
389 
390     //user is buying etd
391     function buy() payable returns (uint256 amount){
392         if(!usersCanTrade && !canTrade[msg.sender]) revert();
393         amount = msg.value * buyPrice;                    // calculates the amount
394 
395         require(balanceOf[this] >= amount);               // checks if it has enough to sell
396         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
397         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
398         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
399         return amount;                                    // ends function and returns
400     }
401 
402     //user is selling us etd, we are selling eth to the user
403     function sell(uint256 amount) returns (uint revenue){
404         require(!frozen[msg.sender]);
405         if(!usersCanTrade && !canTrade[msg.sender]) {
406             require(minBalanceForAccounts > amount/sellPrice);
407         }
408         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
409         balanceOf[this] += amount;                        // adds the amount to owner's balance
410         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
411         revenue = amount / sellPrice;
412         require(msg.sender.send(revenue));                // sends ether to the seller: it's important to do this last to prevent recursion attacks
413         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
414         return revenue;                                   // ends function and returns
415     }
416 
417     function() payable {
418     }
419     event Withdrawn(address indexed to, uint256 value);
420     function withdraw(address target, uint256 amount) onlyOwner {
421         target.transfer(amount);
422         Withdrawn(target, amount);
423     }
424 
425     function setAdmin(address addr, bool enabled) onlyOwner {
426         admin[addr]=enabled;
427     }
428 
429     function setICO(bool enabled) onlyOwner {
430         ico=enabled;
431     }
432 }