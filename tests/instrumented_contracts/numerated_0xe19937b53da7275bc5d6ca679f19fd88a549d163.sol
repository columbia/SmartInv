1 pragma solidity ^0.4.25;
2 
3 /// Code for ERC20+alpha token
4 /// @author A. Vidovic
5 contract WWCToken {
6     string public name = 'Wowbit Classic';      //fancy name
7     uint8 public decimals = 18;                 //How many decimals to show. It's like comparing 1 wei to 1 ether.
8     string public symbol = 'WCC';               //Identifier
9     string public version = '1.0';
10 
11     uint256 weisPerEth = 1000000000000000000;
12     /// total amount of tokens
13     uint256 public totalSupply = 3333333333 * weisPerEth;
14     uint256 public tokenWeisPerEth = 1000000000000000;  // 1 ETH = 0.001 WWBC
15     address owner0;     // just in case an owner change would be mistaken
16     address owner;
17     uint256 public saleCap = 0 * weisPerEth;
18     uint256 public notAttributed = totalSupply - saleCap;
19 
20     constructor(
21         uint256 _initialAmount,
22         uint256 _saleCap,
23         string _tokenName,
24         string _tokenSymbol,
25         uint8 _decimalUnits
26         ) public {
27         totalSupply = _initialAmount * weisPerEth;           // Update total supply
28         saleCap = _saleCap * weisPerEth;
29         notAttributed = totalSupply - saleCap;               // saleCap is an attributed amount
30         name = _tokenName;                                   // Set the name for display purposes
31         decimals = _decimalUnits;                            // Amount of decimals for display purposes
32         symbol = _tokenSymbol;                               // Set the symbol for display purposes
33 
34         owner0 = msg.sender;
35         owner = msg.sender;
36         
37         balances[owner] = 100 * weisPerEth;                  // initial allocation for test purposes
38         notAttributed -= balances[owner];
39         emit Transfer(0, owner, balances[owner]);
40     }
41     
42     modifier ownerOnly {
43         require(owner == msg.sender || owner0 == msg.sender);
44         _;
45     }
46 
47     function setOwner(address _newOwner) public ownerOnly {
48         if (owner0 == 0) {
49             if (owner == 0) {
50                 owner0 = _newOwner;
51             } else {
52                 owner0 = owner;
53             }
54         }
55         owner = _newOwner;
56     }
57     
58     function addToTotalSupply(uint256 _delta) public ownerOnly returns (uint256 availableAmount) {
59         totalSupply += _delta * weisPerEth;
60         notAttributed += _delta * weisPerEth;
61         return notAttributed;
62     }
63     
64     function withdraw() public ownerOnly {
65         msg.sender.transfer(address(this).balance);
66     }
67     
68     function setSaleCap(uint256 _saleCap) public ownerOnly returns (uint256 toBeSold) {
69         notAttributed += saleCap;           // restore remaining previous saleCap to notAttributed pool
70         saleCap = _saleCap * weisPerEth;
71         if (saleCap > notAttributed) {      // not oversold amount 
72             saleCap = notAttributed;
73         }
74         notAttributed -= saleCap;           // attribute this new cap
75         return saleCap;
76     }
77     
78     bool public onSaleFlag = false;
79     
80     function setSaleFlag(bool _saleFlag) public ownerOnly {
81         onSaleFlag = _saleFlag;
82     }
83     
84     bool public useWhitelistFlag = false;
85     
86     function setUseWhitelistFlag(bool _useWhitelistFlag) public ownerOnly {
87         useWhitelistFlag = _useWhitelistFlag;
88     }
89     
90     function calcTokenSold(uint256 _ethValue) public view returns (uint256 tokenValue) {
91         return _ethValue * tokenWeisPerEth / weisPerEth;
92     }
93     
94     uint256 public percentFrozenWhenBought = 75;   // % of tokens you buy that you can't use right away
95     uint256 public percentUnfrozenAfterBuyPerPeriod = 25;  //  % of bought tokens you get to use after each period
96     uint public buyUnfreezePeriodSeconds = 30 * 24 * 3600;  // aforementioned period
97     
98     function setPercentFrozenWhenBought(uint256 _percentFrozenWhenBought) public ownerOnly {
99         percentFrozenWhenBought = _percentFrozenWhenBought;
100     }
101     
102     function setPercentUnfrozenAfterBuyPerPeriod(uint256 _percentUnfrozenAfterBuyPerPeriod) public ownerOnly {
103         percentUnfrozenAfterBuyPerPeriod = _percentUnfrozenAfterBuyPerPeriod;
104     }
105     
106     function setBuyUnfreezePeriodSeconds(uint _buyUnfreezePeriodSeconds) public ownerOnly {
107         buyUnfreezePeriodSeconds = _buyUnfreezePeriodSeconds;
108     }
109     
110     function buy() payable public {
111         if (useWhitelistFlag) {
112             if (!isWhitelist(msg.sender)) {
113                 emit NotWhitelisted(msg.sender);
114                 revert();
115             }
116         }
117         if (saleCap>0) {
118             uint256 tokens = calcTokenSold(msg.value);
119             if (tokens<=saleCap) {
120                 if (tokens > 0) { 
121                     lastUnfrozenTimestamps[msg.sender] = block.timestamp;
122                     boughtTokens[msg.sender] += tokens;
123                     frozenTokens[msg.sender] += tokens * percentFrozenWhenBought / 100;
124                     balances[msg.sender] += tokens * ( 100 - percentFrozenWhenBought) / 100;
125                     saleCap -= tokens;
126                     emit Transfer(0, msg.sender, tokens);
127                 } else {
128                     revert();
129                 }
130             } else {
131                 emit NotEnoughTokensLeftForSale(saleCap);
132                 revert();
133             }
134         } else {
135             emit NotEnoughTokensLeftForSale(saleCap);
136             revert();
137         }
138     }
139 
140     function () payable public {
141         //if ether is sent to this address and token sale is not ON, send it back.
142         if (!onSaleFlag) {
143             revert();
144         } else {
145             buy();
146         }
147     }
148     
149     mapping (address => uint256) public boughtTokens;  // there is some kind of lockup even for those who bought tokens
150     mapping (address => uint) public lastUnfrozenTimestamps;
151     mapping (address => uint256) public frozenTokens;
152     
153     uint256 public percentFrozenWhenAwarded = 100;   // % of tokens you are awarded that you can't use right away
154     uint256 public percentUnfrozenAfterAwardedPerPeriod = 25;  //  % of bought tokens you get to use after each period
155     uint public awardedInitialWaitSeconds = 6 * 30 * 24 * 3600;  // initial waiting period for hodlers
156     uint public awardedUnfreezePeriodSeconds = 30 * 24 * 3600;  // aforementioned period
157     
158     function setPercentFrozenWhenAwarded(uint256 _percentFrozenWhenAwarded) public ownerOnly {
159         percentFrozenWhenAwarded = _percentFrozenWhenAwarded;
160     }
161     
162     function setPercentUnfrozenAfterAwardedPerPeriod(uint256 _percentUnfrozenAfterAwardedPerPeriod) public ownerOnly {
163         percentUnfrozenAfterAwardedPerPeriod = _percentUnfrozenAfterAwardedPerPeriod;
164     }
165     
166     function setAwardedInitialWaitSeconds(uint _awardedInitialWaitSeconds) public ownerOnly {
167         awardedInitialWaitSeconds = _awardedInitialWaitSeconds;
168     }
169     
170     function setAwardedUnfreezePeriodSeconds(uint _awardedUnfreezePeriodSeconds) public ownerOnly {
171         awardedUnfreezePeriodSeconds = _awardedUnfreezePeriodSeconds;
172     }
173     
174     function award(address _to, uint256 _nbTokens) public ownerOnly {
175         if (notAttributed>0) {
176             uint256 tokens = _nbTokens * weisPerEth;
177             if (tokens<=notAttributed) {
178                 if (tokens > 0) {
179                     awardedTimestamps[_to] = block.timestamp;
180                     awardedTokens[_to] += tokens;
181                     frozenAwardedTokens[_to] += tokens * percentFrozenWhenAwarded / 100;
182                     balances[_to] += tokens * ( 100 - percentFrozenWhenAwarded) / 100;
183                     notAttributed -= tokens;
184                     emit Transfer(0, _to, tokens);
185                 }
186             } else {
187                 emit NotEnoughTokensLeft(notAttributed);
188             }
189         } else {
190             emit NotEnoughTokensLeft(notAttributed);
191         }
192     }
193     
194     mapping (address => uint256) public awardedTokens;
195     mapping (address => uint) public awardedTimestamps;
196     mapping (address => uint) public lastUnfrozenAwardedTimestamps;
197     mapping (address => uint256) public frozenAwardedTokens;
198     
199     /// transfer tokens from unattributed pool without any lockup (e.g. for human sale)
200     function grant(address _to, uint256 _nbTokens) public ownerOnly {
201         if (notAttributed>0) {
202             uint256 tokens = _nbTokens * weisPerEth;
203             if (tokens<=notAttributed) {
204                 if (tokens > 0) {
205                     balances[_to] += tokens;
206                     notAttributed -= tokens;
207                     emit Transfer(0, _to, tokens);
208                 }
209             } else {
210                 emit NotEnoughTokensLeft(notAttributed);
211             }
212         } else {
213             emit NotEnoughTokensLeft(notAttributed);
214         }
215     }
216     
217     function setWhitelist(address _addr, bool _wlStatus) public ownerOnly {
218         whitelist[_addr] = _wlStatus;
219     }
220     
221     function isWhitelist(address _addr) public view returns (bool isWhitelisted) {
222         return whitelist[_addr]==true;
223     }
224     
225     mapping (address => bool) public whitelist;
226     
227     function setSaleAddr(address _addr, bool _saleStatus) public ownerOnly {
228         saleAddrs[_addr] = _saleStatus;
229     }
230     
231     function isSaleAddr(address _addr) public view returns (bool isASaleAddr) {
232         return saleAddrs[_addr]==true;
233     }
234     
235     mapping (address => bool) public saleAddrs;            // marks sale addresses : transfer recipients from those addresses are subjected to buy lockout rules
236     
237     bool public manualSaleFlag = false;
238     
239     function setManualSaleFlag(bool _manualSaleFlag) public ownerOnly {
240         manualSaleFlag = _manualSaleFlag;
241     }
242     
243     mapping (address => uint256) public balances;      // available on hand
244     mapping (address => mapping (address => uint256)) allowed;
245     
246 
247     function setBlockedAccount(address _addr, bool _blockedStatus) public ownerOnly {
248         blockedAccounts[_addr] = _blockedStatus;
249     }
250     
251     function isBlockedAccount(address _addr) public view returns (bool isAccountBlocked) {
252         return blockedAccounts[_addr]==true;
253     }
254     
255     mapping (address => bool) public blockedAccounts;  // mechanism allowing to stop thieves from profiting
256     
257     /// Used to empty blocked accounts of stolen tokens and return them to rightful owners
258     function moveTokens(address _from, address _to, uint256 _amount) public ownerOnly  returns (bool success) {
259         if (_amount>0 && balances[_from] >= _amount) {
260             balances[_from] -= _amount;
261             balances[_to] += _amount;
262             emit Transfer(_from, _to, _amount);
263             return true;
264         } else {
265             return false;
266         }
267     }
268     
269     function unfreezeBoughtTokens(address _owner) public {
270         if (frozenTokens[_owner] > 0) {
271             uint elapsed = block.timestamp - lastUnfrozenTimestamps[_owner];
272             if (elapsed > buyUnfreezePeriodSeconds) {
273                 uint256 tokensToUnfreeze = boughtTokens[_owner] * percentUnfrozenAfterBuyPerPeriod / 100;
274                 if (tokensToUnfreeze > frozenTokens[_owner]) {
275                     tokensToUnfreeze = frozenTokens[_owner];
276                 }
277                 balances[_owner] += tokensToUnfreeze;
278                 frozenTokens[_owner] -= tokensToUnfreeze;
279                 lastUnfrozenTimestamps[_owner] = block.timestamp;
280             }
281         } 
282     }
283 
284     function unfreezeAwardedTokens(address _owner) public {
285         if (frozenAwardedTokens[_owner] > 0) {
286             uint elapsed = 0;
287             uint waitTime = awardedInitialWaitSeconds;
288             if (lastUnfrozenAwardedTimestamps[_owner]<=0) {
289                 elapsed = block.timestamp - awardedTimestamps[_owner];
290             } else {
291                 elapsed = block.timestamp - lastUnfrozenAwardedTimestamps[_owner];
292                 waitTime = awardedUnfreezePeriodSeconds;
293             }
294             if (elapsed > waitTime) {
295                 uint256 tokensToUnfreeze = awardedTokens[_owner] * percentUnfrozenAfterAwardedPerPeriod / 100;
296                 if (tokensToUnfreeze > frozenAwardedTokens[_owner]) {
297                     tokensToUnfreeze = frozenAwardedTokens[_owner];
298                 }
299                 balances[_owner] += tokensToUnfreeze;
300                 frozenAwardedTokens[_owner] -= tokensToUnfreeze;
301                 lastUnfrozenAwardedTimestamps[_owner] = block.timestamp;
302             }
303         } 
304     }
305     
306     function unfreezeTokens(address _owner) public returns (uint256 frozenAmount) {
307         unfreezeBoughtTokens(_owner);
308         unfreezeAwardedTokens(_owner);
309         return frozenTokens[_owner] + frozenAwardedTokens[_owner];
310     }
311 
312     /// @param _owner The address from which the balance will be retrieved
313     /// @return The balance
314     function balanceOf(address _owner) public returns (uint256 balance) {
315         unfreezeTokens(_owner);
316         return balances[_owner];
317     }
318 
319     /// @notice send `_value` token to `_to` from `msg.sender`
320     /// @param _to The address of the recipient
321     /// @param _value The amount of token to be transferred
322     /// @return Whether the transfer was successful or not
323     function transfer(address _to, uint256 _value) public returns (bool success) {
324         //Default assumes totalSupply can't be over max (2^256 - 1).
325         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
326         //Replace the if with this one instead.
327         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
328         if (!isBlockedAccount(msg.sender) && (balanceOf(msg.sender) >= _value && _value > 0)) {
329             if (isSaleAddr(msg.sender)) {
330                 if (manualSaleFlag) {
331                     boughtTokens[_to] += _value;
332                     lastUnfrozenTimestamps[_to] = block.timestamp;
333                     frozenTokens[_to] += _value * percentFrozenWhenBought / 100;
334                     balances[_to] += _value * ( 100 - percentFrozenWhenBought) / 100;
335                 } else {
336                     return false;
337                 }
338             } else {
339                 balances[_to] += _value;
340             }
341             balances[msg.sender] -= _value;
342             emit Transfer(msg.sender, _to, _value);
343             return true;
344         } else { 
345             return false; 
346         }
347     }
348 
349     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
350     /// @param _from The address of the sender
351     /// @param _to The address of the recipient
352     /// @param _value The amount of token to be transferred
353     /// @return Whether the transfer was successful or not
354     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
355         //same as above. Replace this line with the following if you want to protect against wrapping uints.
356         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
357         if (!isBlockedAccount(msg.sender) && (balanceOf(_from) >= _value && allowed[_from][msg.sender] >= _value) && _value > 0) {
358             if (isSaleAddr(_from)) {
359                 if (manualSaleFlag) {
360                     boughtTokens[_to] += _value;
361                     lastUnfrozenTimestamps[_to] = block.timestamp;
362                     frozenTokens[_to] += _value * percentFrozenWhenBought / 100;
363                     balances[_to] += _value * ( 100 - percentFrozenWhenBought) / 100;
364                 } else {
365                     return false;
366                 }
367             } else {
368                 balances[_to] += _value;
369             }
370             balances[_from] -= _value;
371             allowed[_from][msg.sender] -= _value;
372             emit Transfer(_from, _to, _value);
373             return true;
374         } else { 
375             return false; 
376         }
377     }
378 
379     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
380     /// @param _spender The address of the account able to transfer the tokens
381     /// @param _value The amount of wei to be approved for transfer
382     /// @return Whether the approval was successful or not
383     function approve(address _spender, uint256 _value) public returns (bool success) {
384         allowed[msg.sender][_spender] = _value;
385         emit Approval(msg.sender, _spender, _value);
386         return true;
387     }
388     
389 
390     /// @param _owner The address of the account owning tokens
391     /// @param _spender The address of the account able to transfer the tokens
392     /// @return Amount of remaining tokens allowed to spent
393     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
394       return allowed[_owner][_spender];
395     }
396 
397     event Transfer(address indexed _from, address indexed _to, uint256 _value);
398     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
399     event NotEnoughTokensLeftForSale(uint256 _tokensLeft);
400     event NotEnoughTokensLeft(uint256 _tokensLeft);
401     event NotWhitelisted(address _addr);
402 }