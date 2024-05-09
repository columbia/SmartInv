1 pragma solidity ^0.4.16;
2 
3 /** Owner permissions */
4 contract owned {
5     address public owner;
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
19 }
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
22 
23 /// ERC20 standard，Define the minimum unit of money to 18 decimal places,
24 /// transfer out, destroy coins, others use your account spending pocket money.
25 contract TokenERC20 {
26     uint256 public totalSupply;
27     // This creates an array with all balances.
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     // This generates a public event on the blockchain that will notify clients.
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     // This notifies clients about the amount burnt.
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Internal transfer, only can be called by this contract.
39      */
40     function _transfer(address _from, address _to, uint _value) internal {
41         // Prevent transfer to 0x0 address. Use burn() instead.
42         require(_to != 0x0);
43         // Check if the sender has enough.
44         require(balanceOf[_from] >= _value);
45         // Check for overflows.
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         // Save this for an assertion in the future.
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         // Subtract from the sender.
50         balanceOf[_from] -= _value;
51         // Add the same to the recipient.
52         balanceOf[_to] += _value;
53         emit Transfer(_from, _to, _value);
54         // Asserts are used to use static analysis to find bugs in your code. They should never fail.
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     /**
59      * Transfer tokens
60      *
61      * Send `_value` tokens to `_to` from your account.
62      *
63      * @param _to The address of the recipient.
64      * @param _value the amount to send.
65      */
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     /**
71      * Transfer tokens from other address.
72      *
73      * Send `_value` tokens to `_to` in behalf of `_from`.
74      *
75      * @param _from The address of the sender.
76      * @param _to The address of the recipient.
77      * @param _value the amount to send.
78      */
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         // Check allowance
81         require(_value <= allowance[_from][msg.sender]);
82         allowance[_from][msg.sender] -= _value;
83         _transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /**
88      * Set allowance for other address.
89      *
90      * Allows `_spender` to spend no more than `_value` tokens in your behalf.
91      *
92      * @param _spender The address authorized to spend.
93      * @param _value the max amount they can spend.
94      */
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
98 
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address and notify.
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it.
107      *
108      * @param _spender The address authorized to spend.
109      * @param _value the max amount they can spend.
110      * @param _extraData some extra information to send to the approved contract.
111      */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
113         public
114         returns (bool success) {
115         tokenRecipient spender = tokenRecipient(_spender);
116         if (approve(_spender, _value)) {
117             spender.receiveApproval(msg.sender, _value, this, _extraData);
118             return true;
119         }
120     }
121 
122     /**
123      * Destroy tokens
124      *
125      * Remove `_value` tokens from the system irreversibly.
126      *
127      * @param _value the amount of money to burn.
128      */
129     function burn(uint256 _value) public returns (bool success) {
130         // Check if the sender has enough
131         require(balanceOf[msg.sender] >= _value);
132         // Subtract from the sender
133         balanceOf[msg.sender] -= _value;
134         // Updates totalSupply
135         totalSupply -= _value;
136         emit Burn(msg.sender, _value);
137         return true;
138     }
139 
140     /**
141      * Destroy tokens from other account.
142      *
143      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
144      *
145      * @param _from the address of the sender.
146      * @param _value the amount of money to burn.
147      */
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149         // Check if the targeted balance is enough.
150         require(balanceOf[_from] >= _value);
151         // Check allowance
152         require(_value <= allowance[_from][msg.sender]);
153         // Subtract from the targeted balance.
154         balanceOf[_from] -= _value;
155         // Subtract from the sender's allowance.
156         allowance[_from][msg.sender] -= _value;
157         // Update totalSupply
158         totalSupply -= _value;
159         emit Burn(_from, _value);
160         return true;
161     }
162 }
163 
164 /******************************************/
165 /*         AIH TOKEN STARTS HERE          */
166 /******************************************/
167 
168 /// @title AIH Protocol Token.
169 contract AIHToken is owned, TokenERC20 {
170 
171     /// The full name of the AIH token.
172     string public constant name = "Artificial Intelligence Health";
173     /// Symbol of the AIH token.
174     string public constant symbol = "AIH";
175     /// 18 decimals is the strongly suggested default, avoid changing it.
176     uint8 public constant decimals = 18;
177 
178 
179     uint256 public totalSupply = 5000000000 * 10 ** uint256(decimals);
180 
181     /**
182      *  Locked tokens system
183      */
184     /// Stores the address of the locked tokens.
185     address public lockJackpots;
186 
187     /// Remaining rewards in the locked tokens.
188     uint256 public remainingReward;
189 
190     /// The start time to lock tokens. 2018/09/15 0:0:0
191     uint256 public lockStartTime = 1536940800;
192     /// The last time to lock tokens. 2018/10/30 0:0:0
193     uint256 public lockDeadline = 1540828800;
194     /// Release tokens lock time,Timestamp format 1557849600 ==  2019/5/15 0:0:0
195     uint256 public unLockTime = 1557849600;
196 
197     /// Reward factor for locked tokens 
198     uint public constant NUM_OF_PHASE = 3;
199     uint[3] public lockRewardsPercentages = [
200         300,   //30%
201         200,    //20%
202         100    //10%
203     ];
204 
205     /// Locked account details
206     mapping (address => uint256) public lockBalanceOf;
207 
208     /**
209      *  Freeze the account system
210      */
211     /* This generates a public event on the blockchain that will notify clients. */
212     mapping (address => bool) public frozenAccount;
213     event FrozenFunds(address target, bool frozen);
214 
215     /* Initializes contract with initial supply tokens to the creator of the contract. */
216     function AIHToken() public {
217         /// Give the creator all initial tokens.
218         balanceOf[msg.sender] = totalSupply;
219     }
220 
221     /**
222      * transfer token for a specified address.
223      *
224      * @param _to The address to transfer to.
225      * @param _value The amount to be transferred.
226      */
227     function transfer(address _to, uint256 _value) public {
228         /// Locked account can not complete the transfer.
229         require(!(lockJackpots != 0x0 && msg.sender == lockJackpots));
230 
231         /// Transponding the AIH token to a locked tokens account will be deemed a lock-up activity.
232         if (lockJackpots != 0x0 && _to == lockJackpots) {
233             _lockToken(_value);
234         }
235         else {
236             /// To unlock the time, automatically unlock tokens.
237             if (unLockTime <= now && lockBalanceOf[msg.sender] > 0) {
238                 lockBalanceOf[msg.sender] = 0;
239             }
240 
241             _transfer(msg.sender, _to, _value);
242         }
243     }
244 
245     /**
246      * transfer token for a specified address.Internal transfer, only can be called by this contract.
247      *
248      * @param _from The address to transfer from.
249      * @param _to The address to transfer to.
250      * @param _value The amount to be transferred.
251      */
252     function _transfer(address _from, address _to, uint _value) internal {
253         // Prevent transfer to 0x0 address. Use burn() instead.
254         require(_to != 0x0);
255         //Check for overflows.
256         require(lockBalanceOf[_from] + _value > lockBalanceOf[_from]);
257         // Check if the sender has enough.
258         require(balanceOf[_from] >= lockBalanceOf[_from] + _value);
259         // Check for overflows.
260         require(balanceOf[_to] + _value > balanceOf[_to]);
261         // Check if sender is frozen.
262         require(!frozenAccount[_from]);
263         // Check if recipient is frozen.
264         require(!frozenAccount[_to]);
265         // Subtract from the sender.
266         balanceOf[_from] -= _value;
267         // Add the same to the recipient.
268         balanceOf[_to] += _value;
269         emit Transfer(_from, _to, _value);
270     }
271 
272     /**
273      * Increase the token reward.
274      *
275      * @param _value Increase the amount of tokens awarded.
276      */
277     function increaseLockReward(uint256 _value) public{
278         require(_value > 0);
279         _transfer(msg.sender, lockJackpots, _value * 10 ** uint256(decimals));
280         _calcRemainReward();
281     }
282 
283     /**
284      * Locked tokens, in the locked token reward calculation and distribution.
285      *
286      * @param _lockValue Lock token reward.
287      */
288     function _lockToken(uint256 _lockValue) internal {
289         /// Lock the tokens necessary safety checks.
290         require(lockJackpots != 0x0);
291         require(now >= lockStartTime);
292         require(now <= lockDeadline);
293         require(lockBalanceOf[msg.sender] + _lockValue > lockBalanceOf[msg.sender]);
294         /// Check account tokens must be sufficient.
295         require(balanceOf[msg.sender] >= lockBalanceOf[msg.sender] + _lockValue);
296 
297         uint256 _reward =  _lockValue * _calcLockRewardPercentage() / 1000;
298         /// Distribute bonus tokens.
299         _transfer(lockJackpots, msg.sender, _reward);
300 
301         /// Save locked accounts and rewards.
302         lockBalanceOf[msg.sender] += _lockValue + _reward;
303         _calcRemainReward();
304     }
305 
306     uint256 lockRewardFactor;
307     /* Calculate locked token reward percentage，Actual value: rewardFactor/1000 */
308     function _calcLockRewardPercentage() internal returns (uint factor){
309 
310         uint phase = NUM_OF_PHASE * (now - lockStartTime)/( lockDeadline - lockStartTime);
311         if (phase  >= NUM_OF_PHASE) {
312             phase = NUM_OF_PHASE - 1;
313         }
314     
315         lockRewardFactor = lockRewardsPercentages[phase];
316         return lockRewardFactor;
317     }
318 
319     /** The activity is over and the token in the prize pool is sent to the manager for fund development. */
320     function rewardActivityEnd() onlyOwner public {
321         /// The activity is over.
322         require(unLockTime < now);
323         /// Send the token from the prize pool to the manager.
324         _transfer(lockJackpots, owner, balanceOf[lockJackpots]);
325         _calcRemainReward();
326     }
327 
328     function() payable public {}
329 
330     /**
331      * Set lock token address,only once.
332      *
333      * @param newLockJackpots The lock token address.
334      */
335     function setLockJackpots(address newLockJackpots) onlyOwner public {
336         require(lockJackpots == 0x0 && newLockJackpots != 0x0 && newLockJackpots != owner);
337         lockJackpots = newLockJackpots;
338         _calcRemainReward();
339     }
340 
341     /** Remaining rewards in the locked tokens. */
342     function _calcRemainReward() internal {
343         remainingReward = balanceOf[lockJackpots];
344     }
345 
346     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
347         // Check allowance
348         require(_from != lockJackpots);
349         return super.transferFrom(_from, _to, _value);
350     }
351 
352     function approve(address _spender, uint256 _value) public
353         returns (bool success) {
354         require(msg.sender != lockJackpots);
355         return super.approve(_spender, _value);
356     }
357 
358     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
359         public
360         returns (bool success) {
361         require(msg.sender != lockJackpots);
362         return super.approveAndCall(_spender, _value, _extraData);
363     }
364 
365     function burn(uint256 _value) public returns (bool success) {
366         require(msg.sender != lockJackpots);
367         return super.burn(_value);
368     }
369 
370     function burnFrom(address _from, uint256 _value) public returns (bool success) {
371         require(_from != lockJackpots);
372         return super.burnFrom(_from, _value);
373     }
374 }