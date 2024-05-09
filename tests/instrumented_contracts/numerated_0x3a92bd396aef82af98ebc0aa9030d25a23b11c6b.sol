1 pragma solidity ^0.4.18;
2 
3 
4 /// @title Abstract ERC20 token interface
5 contract AbstractToken {
6 
7     function balanceOf(address owner) public view returns (uint256 balance);
8     function transfer(address to, uint256 value) public returns (bool success);
9     function transferFrom(address from, address to, uint256 value) public returns (bool success);
10     function approve(address spender, uint256 value) public returns (bool success);
11     function allowance(address owner, address spender) public view returns (uint256 remaining);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15     event Issuance(address indexed to, uint256 value);
16 }
17 
18 
19 contract Owned {
20 
21     address public owner = msg.sender;
22     address public potentialOwner;
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     modifier onlyPotentialOwner {
30         require(msg.sender == potentialOwner);
31         _;
32     }
33 
34     event NewOwner(address old, address current);
35     event NewPotentialOwner(address old, address potential);
36 
37     function setOwner(address _new)
38         public
39         onlyOwner
40     {
41         NewPotentialOwner(owner, _new);
42         potentialOwner = _new;
43     }
44 
45     function confirmOwnership()
46         public
47         onlyPotentialOwner
48     {
49         NewOwner(owner, potentialOwner);
50         owner = potentialOwner;
51         potentialOwner = 0;
52     }
53 }
54 
55 
56 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
57 contract StandardToken is AbstractToken, Owned {
58 
59     /*
60      *  Data structures
61      */
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 
66     /*
67      *  Read and write storage functions
68      */
69     /// @dev Transfers sender's tokens to a given address. Returns success.
70     /// @param _to Address of token receiver.
71     /// @param _value Number of tokens to transfer.
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(msg.sender, _to, _value);
77             return true;
78         }
79         else {
80             return false;
81         }
82     }
83 
84     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
85     /// @param _from Address from where tokens are withdrawn.
86     /// @param _to Address to where tokens are sent.
87     /// @param _value Number of tokens to transfer.
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90             balances[_to] += _value;
91             balances[_from] -= _value;
92             allowed[_from][msg.sender] -= _value;
93             Transfer(_from, _to, _value);
94             return true;
95         }
96         else {
97             return false;
98         }
99     }
100 
101     /// @dev Returns number of tokens owned by given address.
102     /// @param _owner Address of token owner.
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     /// @dev Sets approved amount of tokens for spender. Returns success.
108     /// @param _spender Address of allowed account.
109     /// @param _value Number of approved tokens.
110     function approve(address _spender, uint256 _value) public returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     /*
117      * Read storage functions
118      */
119     /// @dev Returns number of allowed tokens for given address.
120     /// @param _owner Address of token owner.
121     /// @param _spender Address of token spender.
122     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
123       return allowed[_owner][_spender];
124     }
125 
126 }
127 
128 
129 /// @title SafeMath contract - Math operations with safety checks.
130 /// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
131 contract SafeMath {
132     function mul(uint a, uint b) internal pure returns (uint) {
133         uint c = a * b;
134         assert(a == 0 || c / a == b);
135         return c;
136     }
137 
138     function div(uint a, uint b) internal pure returns (uint) {
139         assert(b > 0);
140         uint c = a / b;
141         assert(a == b * c + a % b);
142         return c;
143     }
144 
145     function sub(uint a, uint b) internal pure returns (uint) {
146         assert(b <= a);
147         return a - b;
148     }
149 
150     function add(uint a, uint b) internal pure returns (uint) {
151         uint c = a + b;
152         assert(c >= a);
153         return c;
154     }
155 
156     function pow(uint a, uint b) internal pure returns (uint) {
157         uint c = a ** b;
158         assert(c >= a);
159         return c;
160     }
161 }
162 
163 
164 /// @title Token contract - Implements Standard ERC20 with additional features.
165 /// @author Zerion - <inbox@zerion.io>
166 contract Token is StandardToken, SafeMath {
167 
168     // Time of the contract creation
169     uint public creationTime;
170 
171     function Token() public {
172         creationTime = now;
173     }
174 
175 
176     /// @dev Owner can transfer out any accidentally sent ERC20 tokens
177     function transferERC20Token(address tokenAddress)
178         public
179         onlyOwner
180         returns (bool)
181     {
182         uint balance = AbstractToken(tokenAddress).balanceOf(this);
183         return AbstractToken(tokenAddress).transfer(owner, balance);
184     }
185 
186     /// @dev Multiplies the given number by 10^(decimals)
187     function withDecimals(uint number, uint decimals)
188         internal
189         pure
190         returns (uint)
191     {
192         return mul(number, pow(10, decimals));
193     }
194 }
195 
196 
197 /// @title Token contract - Implements Standard ERC20 Token for Tokenbox project.
198 /// @author Zerion - <inbox@zerion.io>
199 contract TokenboxToken is Token {
200 
201     /*
202      * Token meta data
203      */
204     string constant public name = "Tokenbox";
205  
206     string constant public symbol = "TBX";
207     uint8 constant public decimals = 18;
208 
209     // Address where Foundation tokens are allocated
210     address constant public foundationReserve = address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
211 
212     // Address where all tokens for the ICO stage are initially allocated
213     address constant public icoAllocation = address(0x1111111111111111111111111111111111111111);
214 
215     // Address where all tokens for the PreICO are initially allocated
216     address constant public preIcoAllocation = address(0x2222222222222222222222222222222222222222);
217 
218     // Vesting date to withdraw 15% of total sold tokens, 11/28/2018 @ 12:00pm (UTC)
219     uint256 constant public vestingDateEnd = 1543406400;
220 
221     // Total USD collected (10^-12)
222     uint256 public totalPicoUSD = 0;
223     uint8 constant public usdDecimals = 12;
224 
225     // Foundation multisignature wallet, all Ether is collected there
226     address public multisig;
227 
228     bool public migrationCompleted = false;
229 
230     // Events
231     event InvestmentInETH(address investor, uint256 tokenPriceInWei, uint256 investedInWei, uint256 investedInPicoUsd, uint256 tokensNumber, uint256 originalTransactionHash);
232     event InvestmentInBTC(address investor, uint256 tokenPriceInSatoshi, uint256 investedInSatoshi, uint256 investedInPicoUsd, uint256 tokensNumber, string btcAddress);
233     event InvestmentInUSD(address investor, uint256 tokenPriceInPicoUsd, uint256 investedInPicoUsd, uint256 tokensNumber);
234     event PresaleInvestment(address investor, uint256 investedInPicoUsd, uint256 tokensNumber);
235 
236     /// @dev Contract constructor, sets totalSupply
237     function TokenboxToken(address _multisig, uint256 _preIcoTokens)
238         public
239     {
240         // Overall, 31,000,000 TBX tokens are distributed
241         totalSupply = withDecimals(31000000, decimals);
242 
243         uint preIcoTokens = withDecimals(_preIcoTokens, decimals);
244 
245         // PreICO tokens are allocated to the special address and will be distributed manually
246         balances[preIcoAllocation] = preIcoTokens;
247 
248         // foundationReserve balance will be allocated after the end of the crowdsale
249         balances[foundationReserve] = 0;
250 
251         // The rest of the tokens is available for sale (75% of totalSupply)
252         balances[icoAllocation] = div(mul(totalSupply, 75), 100) - preIcoTokens;
253 
254         multisig = _multisig;
255     }
256 
257     modifier migrationIsActive {
258         require(!migrationCompleted);
259         _;
260     }
261 
262     modifier migrationIsCompleted {
263         require(migrationCompleted);
264         _;
265     }
266 
267     /// @dev Settle an investment made in ETH and distribute tokens
268     function ethInvestment(address investor, uint256 tokenPriceInPicoUsd, uint256 investedInWei, uint256 originalTransactionHash, uint256 usdToWei)
269         public
270         migrationIsActive
271         onlyOwner
272     {
273         uint tokenPriceInWei = div(mul(tokenPriceInPicoUsd, usdToWei), pow(10, usdDecimals));
274 
275         // Number of tokens to distribute
276         uint256 tokensNumber = div(withDecimals(investedInWei, decimals), tokenPriceInWei);
277 
278         // Check if there is enough tokens left
279         require(balances[icoAllocation] >= tokensNumber);
280 
281         uint256 investedInPicoUsd = div(withDecimals(investedInWei, usdDecimals), usdToWei);
282 
283         usdInvestment(investor, investedInPicoUsd, tokensNumber);
284         InvestmentInETH(investor, tokenPriceInWei, investedInWei, investedInPicoUsd, tokensNumber, originalTransactionHash);
285     }
286 
287     /// @dev Settle an investment in BTC and distribute tokens.
288     function btcInvestment(address investor, uint256 tokenPriceInPicoUsd, uint256 investedInSatoshi, string btcAddress, uint256 usdToSatoshi)
289         public
290         migrationIsActive
291         onlyOwner
292     {
293         uint tokenPriceInSatoshi = div(mul(tokenPriceInPicoUsd, usdToSatoshi), pow(10, usdDecimals));
294 
295         // Number of tokens to distribute
296         uint256 tokensNumber = div(withDecimals(investedInSatoshi, decimals), tokenPriceInSatoshi);
297 
298         // Check if there is enough tokens left
299         require(balances[icoAllocation] >= tokensNumber);
300 
301         uint256 investedInPicoUsd = div(withDecimals(investedInSatoshi, usdDecimals), usdToSatoshi);
302 
303         usdInvestment(investor, investedInPicoUsd, tokensNumber);
304         InvestmentInBTC(investor, tokenPriceInSatoshi, investedInSatoshi, investedInPicoUsd, tokensNumber, btcAddress);
305     }
306 
307     // @dev Wire investment
308     function wireInvestment(address investor, uint256 tokenPriceInUsdCents, uint256 investedInUsdCents)
309         public
310         migrationIsActive
311         onlyOwner
312      {
313 
314        uint256 tokensNumber = div(withDecimals(investedInUsdCents, decimals), tokenPriceInUsdCents);
315 
316        // Check if there is enough tokens left
317        require(balances[icoAllocation] >= tokensNumber);
318 
319        // We subtract 2 because the value is in cents.
320        uint256 investedInPicoUsd = withDecimals(investedInUsdCents, usdDecimals - 2);
321        uint256 tokenPriceInPicoUsd = withDecimals(tokenPriceInUsdCents, usdDecimals - 2);
322 
323        usdInvestment(investor, investedInPicoUsd, tokensNumber);
324 
325        InvestmentInUSD(investor, tokenPriceInPicoUsd, investedInPicoUsd, tokensNumber);
326     }
327 
328     // @dev Invest in USD
329     function usdInvestment(address investor, uint256 investedInPicoUsd, uint256 tokensNumber)
330         private
331     {
332       totalPicoUSD = add(totalPicoUSD, investedInPicoUsd);
333 
334       // Allocate tokens to an investor
335       balances[icoAllocation] -= tokensNumber;
336       balances[investor] += tokensNumber;
337       Transfer(icoAllocation, investor, tokensNumber);
338     }
339 
340     // @dev Repeat a transaction from the old contract during the migration
341     function migrateTransfer(address _from, address _to, uint256 amount, uint256 originalTransactionHash)
342         public
343         migrationIsActive
344         onlyOwner
345     {   
346         require(balances[_from] >= amount);
347         balances[_from] -= amount;
348         balances[_to] += amount;
349         Transfer(_from, _to, amount);
350     }
351 
352     // @dev Presale tokens distribution
353     function preIcoInvestment(address investor, uint256 investedInUsdCents, uint256 tokensNumber)
354         public
355         migrationIsActive
356         onlyOwner
357     {
358       uint256 tokensNumberWithDecimals = withDecimals(tokensNumber, decimals);
359 
360       // Check if there is enough tokens left
361       require(balances[preIcoAllocation] >= tokensNumberWithDecimals);
362 
363       // Allocate tokens to an investor
364       balances[preIcoAllocation] -= tokensNumberWithDecimals;
365       balances[investor] += tokensNumberWithDecimals;
366       Transfer(preIcoAllocation, investor, tokensNumberWithDecimals);
367 
368       uint256 investedInPicoUsd = withDecimals(investedInUsdCents, usdDecimals - 2);
369 
370       // Add investment to totalPicoUSD collected
371       totalPicoUSD = add(totalPicoUSD, investedInPicoUsd);
372 
373       PresaleInvestment(investor, investedInPicoUsd, tokensNumberWithDecimals);
374     }
375 
376 
377     /// @dev Allow token withdrawals from Foundation reserve
378     function allowToWithdrawFromReserve()
379         public
380         migrationIsCompleted
381         onlyOwner
382     {
383         require(now >= vestingDateEnd);
384 
385         // Allow the owner to withdraw tokens from the Foundation reserve
386         allowed[foundationReserve][msg.sender] = balanceOf(foundationReserve);
387     }
388 
389 
390     // @dev Withdraws tokens from Foundation reserve
391     function withdrawFromReserve(uint amount)
392         public
393         migrationIsCompleted
394         onlyOwner
395     {
396         require(now >= vestingDateEnd);
397 
398         // Withdraw tokens from Foundation reserve to multisig address
399         require(transferFrom(foundationReserve, multisig, amount));
400     }
401 
402     /// @dev Changes multisig address
403     function changeMultisig(address _multisig)
404         public
405         onlyOwner
406     {
407         multisig = _multisig;
408     }
409 
410     function transfer(address _to, uint256 _value)
411         public
412         migrationIsCompleted
413         returns (bool success) 
414     {
415         return super.transfer(_to, _value);
416     }
417 
418     function transferFrom(address _from, address _to, uint256 _value)
419         public
420         migrationIsCompleted
421         returns (bool success)
422     {
423         return super.transferFrom(_from, _to, _value);
424     }
425 
426     /// @dev Burns the rest of the tokens after the crowdsale end and
427     /// send 10% tokens of totalSupply to team address
428     function finaliseICO()
429         public
430         migrationIsActive
431         onlyOwner
432     {
433         // Total number of tokents sold during the ICO + preICO
434         uint256 tokensSold = sub(div(mul(totalSupply, 75), 100), balanceOf(icoAllocation));
435 
436         // 0.75 * totalSupply = tokensSold
437         totalSupply = div(mul(tokensSold, 100), 75);
438 
439         // Send 5% bounty + 7.5% of total supply to team address
440         balances[multisig] = div(mul(totalSupply, 125), 1000);
441         Transfer(icoAllocation, multisig, balanceOf(multisig));
442 
443         // Lock 12.5% of total supply to team address for one year
444         balances[foundationReserve] = div(mul(totalSupply, 125), 1000);
445         Transfer(icoAllocation, foundationReserve, balanceOf(foundationReserve));
446 
447         // Burn the rest of tokens
448         Transfer(icoAllocation, 0x0000000000000000000000000000000000000000, balanceOf(icoAllocation));
449         balances[icoAllocation] = 0;
450 
451         migrationCompleted = true;
452     }
453 
454     function totalUSD()
455       public view
456       returns (uint)
457     {
458        return div(totalPicoUSD, pow(10, usdDecimals));
459     }
460 }