1 /**
2  * Copyright 2018 TosChain Foundation.
3  */
4 
5 pragma solidity ^0.4.16;
6 
7 /** Owner permissions */
8 contract owned {
9     address public owner;
10 
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26 
27 /// ERC20 standard，Define the minimum unit of money to 18 decimal places,
28 /// transfer out, destroy coins, others use your account spending pocket money.
29 contract TokenERC20 {
30     uint256 public totalSupply;
31     // This creates an array with all balances.
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients.
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt.
39     event Burn(address indexed from, uint256 value);
40 
41     /**
42      * Internal transfer, only can be called by this contract.
43      */
44     function _transfer(address _from, address _to, uint _value) internal {
45         // Prevent transfer to 0x0 address. Use burn() instead.
46         require(_to != 0x0);
47         // Check if the sender has enough.
48         require(balanceOf[_from] >= _value);
49         // Check for overflows.
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         // Save this for an assertion in the future.
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         // Subtract from the sender.
54         balanceOf[_from] -= _value;
55         // Add the same to the recipient.
56         balanceOf[_to] += _value;
57         Transfer(_from, _to, _value);
58         // Asserts are used to use static analysis to find bugs in your code. They should never fail.
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account.
66      *
67      * @param _to The address of the recipient.
68      * @param _value the amount to send.
69      */
70     function transfer(address _to, uint256 _value) public {
71         _transfer(msg.sender, _to, _value);
72     }
73 
74     /**
75      * Transfer tokens from other address.
76      *
77      * Send `_value` tokens to `_to` in behalf of `_from`.
78      *
79      * @param _from The address of the sender.
80      * @param _to The address of the recipient.
81      * @param _value the amount to send.
82      */
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         // Check allowance
85         require(_value <= allowance[_from][msg.sender]);
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /**
92      * Set allowance for other address.
93      *
94      * Allows `_spender` to spend no more than `_value` tokens in your behalf.
95      *
96      * @param _spender The address authorized to spend.
97      * @param _value the max amount they can spend.
98      */
99     function approve(address _spender, uint256 _value) public
100         returns (bool success) {
101         allowance[msg.sender][_spender] = _value;
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address and notify.
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it.
109      *
110      * @param _spender The address authorized to spend.
111      * @param _value the max amount they can spend.
112      * @param _extraData some extra information to send to the approved contract.
113      */
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
115         public
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, this, _extraData);
120             return true;
121         }
122     }
123 
124     /**
125      * Destroy tokens
126      *
127      * Remove `_value` tokens from the system irreversibly.
128      *
129      * @param _value the amount of money to burn.
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         // Check if the sender has enough
133         require(balanceOf[msg.sender] >= _value);
134         // Subtract from the sender
135         balanceOf[msg.sender] -= _value;
136         // Updates totalSupply
137         totalSupply -= _value;
138         Burn(msg.sender, _value);
139         return true;
140     }
141 
142     /**
143      * Destroy tokens from other account.
144      *
145      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
146      *
147      * @param _from the address of the sender.
148      * @param _value the amount of money to burn.
149      */
150     function burnFrom(address _from, uint256 _value) public returns (bool success) {
151         // Check if the targeted balance is enough.
152         require(balanceOf[_from] >= _value);
153         // Check allowance
154         require(_value <= allowance[_from][msg.sender]);
155         // Subtract from the targeted balance.
156         balanceOf[_from] -= _value;
157         // Subtract from the sender's allowance.
158         allowance[_from][msg.sender] -= _value;
159         // Update totalSupply
160         totalSupply -= _value;
161         Burn(_from, _value);
162         return true;
163     }
164 }
165 
166 /******************************************/
167 /*       TOS TOKEN STARTS HERE       */
168 /******************************************/
169 
170 /// @title TOS Protocol Token.
171 contract TosToken is owned, TokenERC20 {
172 
173     /// The full name of the TOS token.
174     string public constant name = "ThingsOpreatingSystem";
175     /// Symbol of the TOS token.
176     string public constant symbol = "TOS";
177     /// 18 decimals is the strongly suggested default, avoid changing it.
178     uint8 public constant decimals = 18;
179 
180 
181     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
182     /// Amount of TOS token to first issue.
183     uint256 public MAX_FUNDING_SUPPLY = totalSupply * 500 / 1000;
184 
185     /**
186      *  Locked tokens system
187      */
188     /// Stores the address of the locked tokens.
189     address public lockJackpots;
190     /// Reward for depositing the TOS token into a locked tokens.
191     /// uint256 public totalLockReward = totalSupply * 50 / 1000;
192     /// Remaining rewards in the locked tokens.
193     uint256 public remainingReward;
194 
195     /// The start time to lock tokens. 2018/03/15 0:0:0
196     uint256 public lockStartTime = 1521043200;
197     /// The last time to lock tokens. 2018/04/29 0:0:0
198     uint256 public lockDeadline = 1524931200;
199     /// Release tokens lock time,Timestamp format 1544803200 ==  2018/12/15 0:0:0
200     uint256 public unLockTime = 1544803200;
201 
202     /// Reward factor for locked tokens 
203     uint public constant NUM_OF_PHASE = 3;
204     uint[3] public lockRewardsPercentages = [
205         1000,   //100%
206         500,    //50%
207         300    //30%
208     ];
209 
210     /// Locked account details
211     mapping (address => uint256) public lockBalanceOf;
212 
213     /**
214      *  Freeze the account system
215      */
216     /* This generates a public event on the blockchain that will notify clients. */
217     mapping (address => bool) public frozenAccount;
218     event FrozenFunds(address target, bool frozen);
219 
220     /* Initializes contract with initial supply tokens to the creator of the contract. */
221     function TosToken() public {
222         /// Give the creator all initial tokens.
223         balanceOf[msg.sender] = totalSupply;
224     }
225 
226     /**
227      * transfer token for a specified address.
228      *
229      * @param _to The address to transfer to.
230      * @param _value The amount to be transferred.
231      */
232     function transfer(address _to, uint256 _value) public {
233         /// Locked account can not complete the transfer.
234         require(!(lockJackpots != 0x0 && msg.sender == lockJackpots));
235 
236         /// Transponding the TOS token to a locked tokens account will be deemed a lock-up activity.
237         if (lockJackpots != 0x0 && _to == lockJackpots) {
238             _lockToken(_value);
239         }
240         else {
241             /// To unlock the time, automatically unlock tokens.
242             if (unLockTime <= now && lockBalanceOf[msg.sender] > 0) {
243                 lockBalanceOf[msg.sender] = 0;
244             }
245 
246             _transfer(msg.sender, _to, _value);
247         }
248     }
249 
250     /**
251      * transfer token for a specified address.Internal transfer, only can be called by this contract.
252      *
253      * @param _from The address to transfer from.
254      * @param _to The address to transfer to.
255      * @param _value The amount to be transferred.
256      */
257     function _transfer(address _from, address _to, uint _value) internal {
258         // Prevent transfer to 0x0 address. Use burn() instead.
259         require(_to != 0x0);
260         //Check for overflows.
261         require(lockBalanceOf[_from] + _value > lockBalanceOf[_from]);
262         // Check if the sender has enough.
263         require(balanceOf[_from] >= lockBalanceOf[_from] + _value);
264         // Check for overflows.
265         require(balanceOf[_to] + _value > balanceOf[_to]);
266         // Check if sender is frozen.
267         require(!frozenAccount[_from]);
268         // Check if recipient is frozen.
269         require(!frozenAccount[_to]);
270         // Subtract from the sender.
271         balanceOf[_from] -= _value;
272         // Add the same to the recipient.
273         balanceOf[_to] += _value;
274         Transfer(_from, _to, _value);
275     }
276 
277     /**
278      * `freeze? Prevent | Allow` `target` from sending & receiving tokens.
279      *
280      * @param target Address to be frozen.
281      * @param freeze either to freeze it or not.
282      */
283     function freezeAccount(address target, bool freeze) onlyOwner public {
284         frozenAccount[target] = freeze;
285         FrozenFunds(target, freeze);
286     }
287 
288     /**
289      * Increase the token reward.
290      *
291      * @param _value Increase the amount of tokens awarded.
292      */
293     function increaseLockReward(uint256 _value) public{
294         require(_value > 0);
295         _transfer(msg.sender, lockJackpots, _value * 10 ** uint256(decimals));
296         _calcRemainReward();
297     }
298 
299     /**
300      * Locked tokens, in the locked token reward calculation and distribution.
301      *
302      * @param _lockValue Lock token reward.
303      */
304     function _lockToken(uint256 _lockValue) internal {
305         /// Lock the tokens necessary safety checks.
306         require(lockJackpots != 0x0);
307         require(now >= lockStartTime);
308         require(now <= lockDeadline);
309         require(lockBalanceOf[msg.sender] + _lockValue > lockBalanceOf[msg.sender]);
310         /// Check account tokens must be sufficient.
311         require(balanceOf[msg.sender] >= lockBalanceOf[msg.sender] + _lockValue);
312 
313         uint256 _reward =  _lockValue * _calcLockRewardPercentage() / 1000;
314         /// Distribute bonus tokens.
315         _transfer(lockJackpots, msg.sender, _reward);
316 
317         /// Save locked accounts and rewards.
318         lockBalanceOf[msg.sender] += _lockValue + _reward;
319         _calcRemainReward();
320     }
321 
322     uint256 lockRewardFactor;
323     /* Calculate locked token reward percentage，Actual value: rewardFactor/1000 */
324     function _calcLockRewardPercentage() internal returns (uint factor){
325 
326         uint phase = NUM_OF_PHASE * (now - lockStartTime)/( lockDeadline - lockStartTime);
327         if (phase  >= NUM_OF_PHASE) {
328             phase = NUM_OF_PHASE - 1;
329         }
330     
331         lockRewardFactor = lockRewardsPercentages[phase];
332         return lockRewardFactor;
333     }
334 
335     /** The activity is over and the token in the prize pool is sent to the manager for fund development. */
336     function rewardActivityEnd() onlyOwner public {
337         /// The activity is over.
338         require(unLockTime < now);
339         /// Send the token from the prize pool to the manager.
340         _transfer(lockJackpots, owner, balanceOf[lockJackpots]);
341         _calcRemainReward();
342     }
343 
344     function() payable public {}
345 
346     /**
347      * Set lock token address,only once.
348      *
349      * @param newLockJackpots The lock token address.
350      */
351     function setLockJackpots(address newLockJackpots) onlyOwner public {
352         require(lockJackpots == 0x0 && newLockJackpots != 0x0 && newLockJackpots != owner);
353         lockJackpots = newLockJackpots;
354         _calcRemainReward();
355     }
356 
357     /** Remaining rewards in the locked tokens. */
358     function _calcRemainReward() internal {
359         remainingReward = balanceOf[lockJackpots];
360     }
361 
362     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
363         // Check allowance
364         require(_from != lockJackpots);
365         return super.transferFrom(_from, _to, _value);
366     }
367 
368     function approve(address _spender, uint256 _value) public
369         returns (bool success) {
370         require(msg.sender != lockJackpots);
371         return super.approve(_spender, _value);
372     }
373 
374     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
375         public
376         returns (bool success) {
377         require(msg.sender != lockJackpots);
378         return super.approveAndCall(_spender, _value, _extraData);
379     }
380 
381     function burn(uint256 _value) public returns (bool success) {
382         require(msg.sender != lockJackpots);
383         return super.burn(_value);
384     }
385 
386     function burnFrom(address _from, uint256 _value) public returns (bool success) {
387         require(_from != lockJackpots);
388         return super.burnFrom(_from, _value);
389     }
390 }