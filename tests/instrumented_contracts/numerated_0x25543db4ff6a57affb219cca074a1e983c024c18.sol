1 pragma solidity ^0.4.25;
2 
3 
4 /// Code for ERC20+alpha token
5 /// @author A. Vidovic
6 contract EPCToken {
7     string public name = 'Earth Power Coin';    //fancy name
8     uint8 public decimals = 18;                 //How many decimals to show. It's like comparing 1 wei to 1 ether.
9     string public symbol = 'EPC';               //Identifier
10     string public version = '1.3';
11 
12     uint256 weisPerEth = 1000000000000000000;
13     /// total amount of tokens
14     uint256 public totalSupply = 20000000000 * weisPerEth;
15     uint256 public tokenWeisPerEth = 25000 * 1000000000000000000;  // 1 ETH = 0.00004 EPC
16     address owner0;     // just in case an owner change would be mistaken
17     address owner;
18     uint256 public saleCap = 2000000000 * weisPerEth;
19     uint256 public notAttributed = totalSupply - saleCap;
20 
21     constructor(
22         uint256 _initialAmount,
23         uint256 _saleCap,
24         string _tokenName,
25         string _tokenSymbol,
26         uint8 _decimalUnits
27         ) public {
28         totalSupply = _initialAmount * weisPerEth;           // Update total supply
29         saleCap = _saleCap * weisPerEth;
30         notAttributed = totalSupply - saleCap;               // saleCap is an attributed amount
31         name = _tokenName;                                   // Set the name for display purposes
32         decimals = _decimalUnits;                            // Amount of decimals for display purposes
33         symbol = _tokenSymbol;                               // Set the symbol for display purposes
34 
35         owner0 = msg.sender;
36         owner = msg.sender;
37         
38         balances[owner] = 100 * weisPerEth;                  // initial allocation for test purposes
39         notAttributed -= balances[owner];
40         emit Transfer(0, owner, balances[owner]);
41     }
42     
43     modifier ownerOnly {
44         require(owner == msg.sender || owner0 == msg.sender);
45         _;
46     }
47 
48     function setOwner(address _newOwner) public ownerOnly {
49         if (owner0 == 0) {
50             if (owner == 0) {
51                 owner0 = _newOwner;
52             } else {
53                 owner0 = owner;
54             }
55         }
56         owner = _newOwner;
57     }
58     
59     function addToTotalSupply(uint256 _delta) public ownerOnly returns (uint256 availableAmount) {
60         totalSupply += _delta * weisPerEth;
61         notAttributed += _delta * weisPerEth;
62         return notAttributed;
63     }
64     
65     function withdraw() public ownerOnly {
66         msg.sender.transfer(address(this).balance);
67     }
68     
69     function setSaleCap(uint256 _saleCap) public ownerOnly returns (uint256 toBeSold) {
70         notAttributed += saleCap;           // restore remaining previous saleCap to notAttributed pool
71         saleCap = _saleCap * weisPerEth;
72         if (saleCap > notAttributed) {      // not oversold amount 
73             saleCap = notAttributed;
74         }
75         notAttributed -= saleCap;           // attribute this new cap
76         return saleCap;
77     }
78     
79     bool public onSaleFlag = false;
80     
81     function setSaleFlag(bool _saleFlag) public ownerOnly {
82         onSaleFlag = _saleFlag;
83     }
84     
85     bool public useWhitelistFlag = false;
86     
87     function setUseWhitelistFlag(bool _useWhitelistFlag) public ownerOnly {
88         useWhitelistFlag = _useWhitelistFlag;
89     }
90     
91     function calcTokenSold(uint256 _ethValue) public view returns (uint256 tokenValue) {
92         return _ethValue * tokenWeisPerEth / weisPerEth;
93     }
94     
95     uint256 public percentFrozenWhenBought = 75;   // % of tokens you buy that you can't use right away
96     uint256 public percentUnfrozenAfterBuyPerPeriod = 25;  //  % of bought tokens you get to use after each period
97     uint public buyUnfreezePeriodSeconds = 30 * 24 * 3600;  // aforementioned period
98     
99     function setPercentFrozenWhenBought(uint256 _percentFrozenWhenBought) public ownerOnly {
100         percentFrozenWhenBought = _percentFrozenWhenBought;
101     }
102     
103     function setPercentUnfrozenAfterBuyPerPeriod(uint256 _percentUnfrozenAfterBuyPerPeriod) public ownerOnly {
104         percentUnfrozenAfterBuyPerPeriod = _percentUnfrozenAfterBuyPerPeriod;
105     }
106     
107     function setBuyUnfreezePeriodSeconds(uint _buyUnfreezePeriodSeconds) public ownerOnly {
108         buyUnfreezePeriodSeconds = _buyUnfreezePeriodSeconds;
109     }
110     
111     function buy() payable public {
112         if (useWhitelistFlag) {
113             if (!isWhitelist(msg.sender)) {
114                 emit NotWhitelisted(msg.sender);
115                 revert();
116             }
117         }
118         if (saleCap>0) {
119             uint256 tokens = calcTokenSold(msg.value);
120             if (tokens<=saleCap) {
121                 if (tokens > 0) { 
122                     lastUnfrozenTimestamps[msg.sender] = block.timestamp;
123                     boughtTokens[msg.sender] += tokens;
124                     frozenTokens[msg.sender] += tokens * percentFrozenWhenBought / 100;
125                     balances[msg.sender] += tokens * ( 100 - percentFrozenWhenBought) / 100;
126                     saleCap -= tokens;
127                     emit Transfer(0, msg.sender, tokens);
128                 } else {
129                     revert();
130                 }
131             } else {
132                 emit NotEnoughTokensLeftForSale(saleCap);
133                 revert();
134             }
135         } else {
136             emit NotEnoughTokensLeftForSale(saleCap);
137             revert();
138         }
139     }
140 
141     function () payable public {
142         //if ether is sent to this address and token sale is not ON, send it back.
143         if (!onSaleFlag) {
144             revert();
145         } else {
146             buy();
147         }
148     }
149     
150     mapping (address => uint256) public boughtTokens;  // there is some kind of lockup even for those who bought tokens
151     mapping (address => uint) public lastUnfrozenTimestamps;
152     mapping (address => uint256) public frozenTokens;
153     
154     uint256 public percentFrozenWhenAwarded = 100;   // % of tokens you are awarded that you can't use right away
155     uint256 public percentUnfrozenAfterAwardedPerPeriod = 25;  //  % of bought tokens you get to use after each period
156     uint public awardedInitialWaitSeconds = 6 * 30 * 24 * 3600;  // initial waiting period for hodlers
157     uint public awardedUnfreezePeriodSeconds = 30 * 24 * 3600;  // aforementioned period
158     
159     function setPercentFrozenWhenAwarded(uint256 _percentFrozenWhenAwarded) public ownerOnly {
160         percentFrozenWhenAwarded = _percentFrozenWhenAwarded;
161     }
162     
163     function setPercentUnfrozenAfterAwardedPerPeriod(uint256 _percentUnfrozenAfterAwardedPerPeriod) public ownerOnly {
164         percentUnfrozenAfterAwardedPerPeriod = _percentUnfrozenAfterAwardedPerPeriod;
165     }
166     
167     function setAwardedInitialWaitSeconds(uint _awardedInitialWaitSeconds) public ownerOnly {
168         awardedInitialWaitSeconds = _awardedInitialWaitSeconds;
169     }
170     
171     function setAwardedUnfreezePeriodSeconds(uint _awardedUnfreezePeriodSeconds) public ownerOnly {
172         awardedUnfreezePeriodSeconds = _awardedUnfreezePeriodSeconds;
173     }
174     
175     function award(address _to, uint256 _nbTokens) public ownerOnly {
176         if (notAttributed>0) {
177             uint256 tokens = _nbTokens * weisPerEth;
178             if (tokens<=notAttributed) {
179                 if (tokens > 0) {
180                     awardedTimestamps[_to] = block.timestamp;
181                     awardedTokens[_to] += tokens;
182                     frozenAwardedTokens[_to] += tokens * percentFrozenWhenAwarded / 100;
183                     balances[_to] += tokens * ( 100 - percentFrozenWhenAwarded) / 100;
184                     notAttributed -= tokens;
185                     emit Transfer(0, _to, tokens);
186                 }
187             } else {
188                 emit NotEnoughTokensLeft(notAttributed);
189             }
190         } else {
191             emit NotEnoughTokensLeft(notAttributed);
192         }
193     }
194     
195     mapping (address => uint256) public awardedTokens;
196     mapping (address => uint) public awardedTimestamps;
197     mapping (address => uint) public lastUnfrozenAwardedTimestamps;
198     mapping (address => uint256) public frozenAwardedTokens;
199     
200     /// transfer tokens from unattributed pool without any lockup (e.g. for human sale)
201     function grant(address _to, uint256 _nbTokens) public ownerOnly {
202         if (notAttributed>0) {
203             uint256 tokens = _nbTokens * weisPerEth;
204             if (tokens<=notAttributed) {
205                 if (tokens > 0) {
206                     balances[_to] += tokens;
207                     notAttributed -= tokens;
208                     emit Transfer(0, _to, tokens);
209                 }
210             } else {
211                 emit NotEnoughTokensLeft(notAttributed);
212             }
213         } else {
214             emit NotEnoughTokensLeft(notAttributed);
215         }
216     }
217     
218     function setWhitelist(address _addr, bool _wlStatus) public ownerOnly {
219         whitelist[_addr] = _wlStatus;
220     }
221     
222     function isWhitelist(address _addr) public view returns (bool isWhitelisted) {
223         return whitelist[_addr]==true;
224     }
225     
226     mapping (address => bool) public whitelist;
227     
228     function setSaleAddr(address _addr, bool _saleStatus) public ownerOnly {
229         saleAddrs[_addr] = _saleStatus;
230     }
231     
232     function isSaleAddr(address _addr) public view returns (bool isASaleAddr) {
233         return saleAddrs[_addr]==true;
234     }
235     
236     mapping (address => bool) public saleAddrs;            // marks sale addresses : transfer recipients from those addresses are subjected to buy lockout rules
237     
238     bool public manualSaleFlag = false;
239     
240     function setManualSaleFlag(bool _manualSaleFlag) public ownerOnly {
241         manualSaleFlag = _manualSaleFlag;
242     }
243     
244     mapping (address => uint256) public balances;      // available on hand
245     mapping (address => mapping (address => uint256)) allowed;
246     
247 
248     function setBlockedAccount(address _addr, bool _blockedStatus) public ownerOnly {
249         blockedAccounts[_addr] = _blockedStatus;
250     }
251     
252     function isBlockedAccount(address _addr) public view returns (bool isAccountBlocked) {
253         return blockedAccounts[_addr]==true;
254     }
255     
256     mapping (address => bool) public blockedAccounts;  // mechanism allowing to stop thieves from profiting
257     
258     /// Used to empty blocked accounts of stolen tokens and return them to rightful owners
259     function moveTokens(address _from, address _to, uint256 _amount) public ownerOnly  returns (bool success) {
260         if (_amount>0 && balances[_from] >= _amount) {
261             balances[_from] -= _amount;
262             balances[_to] += _amount;
263             emit Transfer(_from, _to, _amount);
264             return true;
265         } else {
266             return false;
267         }
268     }
269     
270     function unfreezeBoughtTokens(address _owner) public {
271         if (frozenTokens[_owner] > 0) {
272             uint elapsed = block.timestamp - lastUnfrozenTimestamps[_owner];
273             if (elapsed > buyUnfreezePeriodSeconds) {
274                 uint256 tokensToUnfreeze = boughtTokens[_owner] * percentUnfrozenAfterBuyPerPeriod / 100;
275                 if (tokensToUnfreeze > frozenTokens[_owner]) {
276                     tokensToUnfreeze = frozenTokens[_owner];
277                 }
278                 balances[_owner] += tokensToUnfreeze;
279                 frozenTokens[_owner] -= tokensToUnfreeze;
280                 lastUnfrozenTimestamps[_owner] = block.timestamp;
281             }
282         } 
283     }
284 
285     function unfreezeAwardedTokens(address _owner) public {
286         if (frozenAwardedTokens[_owner] > 0) {
287             uint elapsed = 0;
288             uint waitTime = awardedInitialWaitSeconds;
289             if (lastUnfrozenAwardedTimestamps[_owner]<=0) {
290                 elapsed = block.timestamp - awardedTimestamps[_owner];
291             } else {
292                 elapsed = block.timestamp - lastUnfrozenAwardedTimestamps[_owner];
293                 waitTime = awardedUnfreezePeriodSeconds;
294             }
295             if (elapsed > waitTime) {
296                 uint256 tokensToUnfreeze = awardedTokens[_owner] * percentUnfrozenAfterAwardedPerPeriod / 100;
297                 if (tokensToUnfreeze > frozenAwardedTokens[_owner]) {
298                     tokensToUnfreeze = frozenAwardedTokens[_owner];
299                 }
300                 balances[_owner] += tokensToUnfreeze;
301                 frozenAwardedTokens[_owner] -= tokensToUnfreeze;
302                 lastUnfrozenAwardedTimestamps[_owner] = block.timestamp;
303             }
304         } 
305     }
306     
307     function unfreezeTokens(address _owner) public returns (uint256 frozenAmount) {
308         unfreezeBoughtTokens(_owner);
309         unfreezeAwardedTokens(_owner);
310         return frozenTokens[_owner] + frozenAwardedTokens[_owner];
311     }
312 
313     /// @param _owner The address from which the balance will be retrieved
314     /// @return The balance
315     function balanceOf(address _owner) public returns (uint256 balance) {
316         unfreezeTokens(_owner);
317         return balances[_owner];
318     }
319 
320     /// @notice send `_value` token to `_to` from `msg.sender`
321     /// @param _to The address of the recipient
322     /// @param _value The amount of token to be transferred
323     /// @return Whether the transfer was successful or not
324     function transfer(address _to, uint256 _value) public returns (bool success) {
325         //Default assumes totalSupply can't be over max (2^256 - 1).
326         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
327         //Replace the if with this one instead.
328         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
329         if (!isBlockedAccount(msg.sender) && (balanceOf(msg.sender) >= _value && _value > 0)) {
330             if (isSaleAddr(msg.sender)) {
331                 if (manualSaleFlag) {
332                     boughtTokens[_to] += _value;
333                     lastUnfrozenTimestamps[_to] = block.timestamp;
334                     frozenTokens[_to] += _value * percentFrozenWhenBought / 100;
335                     balances[_to] += _value * ( 100 - percentFrozenWhenBought) / 100;
336                 } else {
337                     return false;
338                 }
339             } else {
340                 balances[_to] += _value;
341             }
342             balances[msg.sender] -= _value;
343             emit Transfer(msg.sender, _to, _value);
344             return true;
345         } else { 
346             return false; 
347         }
348     }
349 
350     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
351     /// @param _from The address of the sender
352     /// @param _to The address of the recipient
353     /// @param _value The amount of token to be transferred
354     /// @return Whether the transfer was successful or not
355     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
356         //same as above. Replace this line with the following if you want to protect against wrapping uints.
357         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
358         if (!isBlockedAccount(msg.sender) && (balanceOf(_from) >= _value && allowed[_from][msg.sender] >= _value) && _value > 0) {
359             if (isSaleAddr(_from)) {
360                 if (manualSaleFlag) {
361                     boughtTokens[_to] += _value;
362                     lastUnfrozenTimestamps[_to] = block.timestamp;
363                     frozenTokens[_to] += _value * percentFrozenWhenBought / 100;
364                     balances[_to] += _value * ( 100 - percentFrozenWhenBought) / 100;
365                 } else {
366                     return false;
367                 }
368             } else {
369                 balances[_to] += _value;
370             }
371             balances[_from] -= _value;
372             allowed[_from][msg.sender] -= _value;
373             emit Transfer(_from, _to, _value);
374             return true;
375         } else { 
376             return false; 
377         }
378     }
379 
380     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
381     /// @param _spender The address of the account able to transfer the tokens
382     /// @param _value The amount of wei to be approved for transfer
383     /// @return Whether the approval was successful or not
384     function approve(address _spender, uint256 _value) public returns (bool success) {
385         allowed[msg.sender][_spender] = _value;
386         emit Approval(msg.sender, _spender, _value);
387         return true;
388     }
389     
390 
391     /// @param _owner The address of the account owning tokens
392     /// @param _spender The address of the account able to transfer the tokens
393     /// @return Amount of remaining tokens allowed to spent
394     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
395       return allowed[_owner][_spender];
396     }
397 
398     event Transfer(address indexed _from, address indexed _to, uint256 _value);
399     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
400     event NotEnoughTokensLeftForSale(uint256 _tokensLeft);
401     event NotEnoughTokensLeft(uint256 _tokensLeft);
402     event NotWhitelisted(address _addr);
403 }