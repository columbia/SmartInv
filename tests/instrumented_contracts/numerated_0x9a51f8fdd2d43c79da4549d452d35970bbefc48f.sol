1 pragma solidity ^0.4.11;
2 
3 //MOLD Bonus contract
4 
5 contract SafeMath {
6   //internals
7 
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeSub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function safeAdd(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24 
25   function safeDiv(uint a, uint b) internal returns (uint) {
26       assert(b > 0);
27       uint c = a / b;
28       assert(a == b * c + a % b);
29       return c;
30   }
31 }
32 
33 // ERC 20 Token
34 // https://github.com/ethereum/EIPs/issues/20
35 
36 contract Token {
37     /* This is a slight change to the ERC20 base standard.
38     function totalSupply() constant returns (uint256 supply);
39     is replaced with:
40     uint256 public totalSupply;
41     This automatically creates a getter function for the totalSupply.
42     This is moved to the base contract since public getter functions are not
43     currently recognised as an implementation of the matching abstract
44     function by the compiler.
45     */
46     /// total amount of tokens
47     uint256 public totalSupply;
48 
49     /// @param _owner The address from which the balance will be retrieved
50     /// @return The balance
51     function balanceOf(address _owner) constant returns (uint256 balance);
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transfer(address _to, uint256 _value) returns (bool success);
58 
59     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
60     /// @param _from The address of the sender
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
65 
66     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @param _value The amount of tokens to be approved for transfer
69     /// @return Whether the approval was successful or not
70     function approve(address _spender, uint256 _value) returns (bool success);
71 
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 contract StandardToken is Token {
82 
83     function transfer(address _to, uint256 _value) returns (bool success) {
84         //Default assumes totalSupply can't be over max (2^256 - 1).
85         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
86         //Replace the if with this one instead.
87         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
88         if (balances[msg.sender] >= _value && _value > 0) {
89             balances[msg.sender] -= _value;
90             balances[_to] += _value;
91             Transfer(msg.sender, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         //same as above. Replace this line with the following if you want to protect against wrapping uints.
98         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
99         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             allowed[_from][msg.sender] -= _value;
103             Transfer(_from, _to, _value);
104             return true;
105         } else { return false; }
106     }
107 
108     function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 }
125 
126 
127 /**
128  * MoldCoin pre-sell contract.
129  *
130  */
131 contract MoldCoin is StandardToken, SafeMath {
132 
133     string public name = "MOLD";
134     string public symbol = "MLD";
135     uint public decimals = 18;
136 
137     uint public startDatetime; //pre-sell start datetime seconds
138     uint public firstStageDatetime; //first 120 hours pre-sell in seconds
139     uint public secondStageDatetime; //second stage, 240 hours of pre-sell in seconds.
140     uint public endDatetime; //pre-sell end datetime seconds (set in constructor)
141 
142     // Initial founder address (set in constructor)
143     // All deposited ETH will be instantly forwarded to this address.
144     address public founder;
145 
146     // administrator address
147     address public admin;
148 
149     uint public coinAllocation = 20 * 10**8 * 10**decimals; //2000M tokens supply for pre-sell
150     uint public angelAllocation = 2 * 10**8 * 10**decimals; // 200M of token supply allocated angel investor
151     uint public founderAllocation = 3 * 10**8 * 10**decimals; //300M of token supply allocated for the founder allocation
152 
153     bool public founderAllocated = false; //this will change to true when the founder fund is allocated
154 
155     uint public saleTokenSupply = 0; //this will keep track of the token supply created during the pre-sell
156     uint public salesVolume = 0; //this will keep track of the Ether raised during the pre-sell
157 
158     uint public angelTokenSupply = 0; //this will keep track of the token angel supply
159 
160     bool public halted = false; //the admin address can set this to true to halt the pre-sell due to emergency
161 
162     event Buy(address indexed sender, uint eth, uint tokens);
163     event AllocateFounderTokens(address indexed sender, uint tokens);
164     event AllocateAngelTokens(address indexed sender, address to, uint tokens);
165     event AllocateUnsoldTokens(address indexed sender, address holder, uint tokens);
166 
167     modifier onlyAdmin {
168         require(msg.sender == admin);
169         _;
170     }
171 
172     modifier duringCrowdSale {
173         require(block.timestamp >= startDatetime && block.timestamp <= endDatetime);
174         _;
175     }
176 
177     /**
178      *
179      * Integer value representing the number of seconds since 1 January 1970 00:00:00 UTC
180      */
181     function MoldCoin(uint startDatetimeInSeconds, address founderWallet) {
182 
183         admin = msg.sender;
184         founder = founderWallet;
185         startDatetime = startDatetimeInSeconds;
186         firstStageDatetime = startDatetime + 120 * 1 hours;
187         secondStageDatetime = firstStageDatetime + 240 * 1 hours;
188         endDatetime = secondStageDatetime + 2040 * 1 hours;
189 
190     }
191 
192     /**
193      * Price for crowdsale by time
194      */
195     function price(uint timeInSeconds) constant returns(uint) {
196         if (timeInSeconds < startDatetime) return 0;
197         if (timeInSeconds <= firstStageDatetime) return 15000; //120 hours
198         if (timeInSeconds <= secondStageDatetime) return 12000; //240 hours
199         if (timeInSeconds <= endDatetime) return 10000; //2040 hours
200         return 0;
201     }
202 
203     /**
204      * allow anyone sends funds to the contract
205      */
206     function buy() payable {
207         buyRecipient(msg.sender);
208     }
209 
210     function() payable {
211         buyRecipient(msg.sender);
212     }
213 
214     /**
215      * Main token buy function.
216      * Buy for the sender itself or buy on the behalf of somebody else (third party address).
217      */
218     function buyRecipient(address recipient) duringCrowdSale payable {
219         require(!halted);
220 
221         uint tokens = safeMul(msg.value, price(block.timestamp));
222         require(safeAdd(saleTokenSupply,tokens)<=coinAllocation );
223 
224         balances[recipient] = safeAdd(balances[recipient], tokens);
225 
226         totalSupply = safeAdd(totalSupply, tokens);
227         saleTokenSupply = safeAdd(saleTokenSupply, tokens);
228         salesVolume = safeAdd(salesVolume, msg.value);
229 
230         if (!founder.call.value(msg.value)()) revert(); //immediately send Ether to founder address
231 
232         Buy(recipient, msg.value, tokens);
233     }
234 
235     /**
236      * Set up founder address token balance.
237      */
238     function allocateFounderTokens() onlyAdmin {
239         require( block.timestamp > endDatetime );
240         require(!founderAllocated);
241 
242         balances[founder] = safeAdd(balances[founder], founderAllocation);
243         totalSupply = safeAdd(totalSupply, founderAllocation);
244         founderAllocated = true;
245 
246         AllocateFounderTokens(msg.sender, founderAllocation);
247     }
248 
249     /**
250      * Set up angel address token balance.
251      */
252     function allocateAngelTokens(address angel, uint tokens) onlyAdmin {
253 
254         require(safeAdd(angelTokenSupply,tokens) <= angelAllocation );
255 
256         balances[angel] = safeAdd(balances[angel], tokens);
257         angelTokenSupply = safeAdd(angelTokenSupply, tokens);
258         totalSupply = safeAdd(totalSupply, tokens);
259 
260         AllocateAngelTokens(msg.sender, angel, tokens);
261     }
262 
263     /**
264      * Emergency Stop crowdsale.
265      */
266     function halt() onlyAdmin {
267         halted = true;
268     }
269 
270     function unhalt() onlyAdmin {
271         halted = false;
272     }
273 
274     /**
275      * Change admin address.
276      */
277     function changeAdmin(address newAdmin) onlyAdmin  {
278         admin = newAdmin;
279     }
280 
281     /**
282      * arrange unsold coins
283      */
284     function arrangeUnsoldTokens(address holder, uint256 tokens) onlyAdmin {
285         require( block.timestamp > endDatetime );
286         require( safeAdd(saleTokenSupply,tokens) <= coinAllocation );
287         require( balances[holder] >0 );
288 
289         balances[holder] = safeAdd(balances[holder], tokens);
290         saleTokenSupply = safeAdd(saleTokenSupply, tokens);
291         totalSupply = safeAdd(totalSupply, tokens);
292 
293         AllocateUnsoldTokens(msg.sender, holder, tokens);
294 
295     }
296 
297 }
298 
299 
300 contract MoldCoinBonus is SafeMath {
301 
302     function bonusBalanceOf(address _owner) constant returns (uint256 balance) {
303         return bonusBalances[_owner];
304     }
305 
306     mapping (address => uint256) bonusBalances;
307 
308     // administrator address
309     address public admin;
310 
311     // crowdfund address
312     MoldCoin public fundAddress;
313     uint public rate = 10;
314     uint public totalSupply = 0;
315 
316     bool public halted = false; //the admin address can set this to true to halt the pre-sell due to emergency
317 
318     event BuyWithBonus(address indexed sender, address indexed inviter, uint eth, uint tokens, uint bonus);
319     event BuyForFriend(address indexed sender, address indexed friend, uint eth, uint tokens, uint bonus);
320 
321     modifier onlyAdmin {
322         require(msg.sender == admin);
323         _;
324     }
325 
326     modifier validSale {
327         require(!halted);
328         require(!fundAddress.halted());
329         _;
330     }
331 
332     function MoldCoinBonus(MoldCoin _fundAddress, uint _rate) {
333 
334         admin = msg.sender;
335         fundAddress = _fundAddress;
336         rate = _rate;
337 
338     }
339 
340     function buyWithBonus(address inviter) validSale payable {
341 
342         require( msg.sender != inviter );
343 
344         uint tokens = safeMul(msg.value, fundAddress.price(block.timestamp));
345         uint bonus = safeDiv(safeMul(tokens, rate), 100);
346 
347         fundAddress.buyRecipient.value(msg.value)(msg.sender); //send Ether to pre-sale contract address
348 
349         totalSupply = safeAdd(totalSupply, bonus*2);
350 
351         bonusBalances[inviter] = safeAdd(bonusBalances[inviter], bonus);
352         bonusBalances[msg.sender] = safeAdd(bonusBalances[msg.sender], bonus);
353         BuyWithBonus(msg.sender, inviter, msg.value, tokens, bonus);
354 
355     }
356 
357 
358     /**
359      * Emergency Stop.
360      */
361     function halt() onlyAdmin {
362         halted = true;
363     }
364 
365     function unhalt() onlyAdmin {
366         halted = false;
367     }
368 
369     /**
370      * Change admin address.
371      */
372     function changeAdmin(address newAdmin) onlyAdmin  {
373         admin = newAdmin;
374     }
375 
376     function changeRate(uint _rate) onlyAdmin  {
377         rate = _rate;
378     }
379 
380 }