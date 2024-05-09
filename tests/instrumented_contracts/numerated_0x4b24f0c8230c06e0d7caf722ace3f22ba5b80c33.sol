1 pragma solidity ^0.4.13;
2 
3 
4 /// @title Abstract ERC20 token interface
5 contract AbstractToken {
6 
7     function totalSupply() constant returns (uint256) {}
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16     event Issuance(address indexed to, uint256 value);
17 }
18 
19 
20 contract Owned {
21 
22     address public owner = msg.sender;
23     address public potentialOwner;
24 
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     modifier onlyPotentialOwner {
31         require(msg.sender == potentialOwner);
32         _;
33     }
34 
35     event NewOwner(address old, address current);
36     event NewPotentialOwner(address old, address potential);
37 
38     function setOwner(address _new)
39         public
40         onlyOwner
41     {
42         NewPotentialOwner(owner, _new);
43         potentialOwner = _new;
44     }
45 
46     function confirmOwnership()
47         public
48         onlyPotentialOwner
49     {
50         NewOwner(owner, potentialOwner);
51         owner = potentialOwner;
52         potentialOwner = 0;
53     }
54 }
55 
56 
57 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 contract StandardToken is AbstractToken, Owned {
59 
60     /*
61      *  Data structures
62      */
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     uint256 public totalSupply;
66 
67     /*
68      *  Read and write storage functions
69      */
70     /// @dev Transfers sender's tokens to a given address. Returns success.
71     /// @param _to Address of token receiver.
72     /// @param _value Number of tokens to transfer.
73     function transfer(address _to, uint256 _value) returns (bool success) {
74         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75             balances[msg.sender] -= _value;
76             balances[_to] += _value;
77             Transfer(msg.sender, _to, _value);
78             return true;
79         }
80         else {
81             return false;
82         }
83     }
84 
85     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
86     /// @param _from Address from where tokens are withdrawn.
87     /// @param _to Address to where tokens are sent.
88     /// @param _value Number of tokens to transfer.
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
90       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91             balances[_to] += _value;
92             balances[_from] -= _value;
93             allowed[_from][msg.sender] -= _value;
94             Transfer(_from, _to, _value);
95             return true;
96         }
97         else {
98             return false;
99         }
100     }
101 
102     /// @dev Returns number of tokens owned by given address.
103     /// @param _owner Address of token owner.
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     /// @dev Sets approved amount of tokens for spender. Returns success.
109     /// @param _spender Address of allowed account.
110     /// @param _value Number of approved tokens.
111     function approve(address _spender, uint256 _value) returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /*
118      * Read storage functions
119      */
120     /// @dev Returns number of allowed tokens for given address.
121     /// @param _owner Address of token owner.
122     /// @param _spender Address of token spender.
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124       return allowed[_owner][_spender];
125     }
126 
127 }
128 
129 
130 /// @title SafeMath contract - Math operations with safety checks.
131 /// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
132 contract SafeMath {
133     function mul(uint a, uint b) internal returns (uint) {
134         uint c = a * b;
135         assert(a == 0 || c / a == b);
136         return c;
137     }
138 
139     function div(uint a, uint b) internal returns (uint) {
140         assert(b > 0);
141         uint c = a / b;
142         assert(a == b * c + a % b);
143         return c;
144     }
145 
146     function sub(uint a, uint b) internal returns (uint) {
147         assert(b <= a);
148         return a - b;
149     }
150 
151     function add(uint a, uint b) internal returns (uint) {
152         uint c = a + b;
153         assert(c >= a);
154         return c;
155     }
156 
157     function pow(uint a, uint b) internal returns (uint) {
158         uint c = a ** b;
159         assert(c >= a);
160         return c;
161     }
162 }
163 
164 
165 /// @title Token contract - Implements Standard ERC20 with additional features.
166 /// @author Zerion - <inbox@zerion.io>
167 contract Token is StandardToken, SafeMath {
168 
169     // Time of the contract creation
170     uint public creationTime;
171 
172     function Token() {
173         creationTime = now;
174     }
175 
176 
177     /// @dev Owner can transfer out any accidentally sent ERC20 tokens
178     function transferERC20Token(address tokenAddress)
179         public
180         onlyOwner
181         returns (bool)
182     {
183         uint balance = AbstractToken(tokenAddress).balanceOf(this);
184         return AbstractToken(tokenAddress).transfer(owner, balance);
185     }
186 
187     /// @dev Multiplies the given number by 10^(decimals)
188     function withDecimals(uint number, uint decimals)
189         internal
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
205     //TODO: Fix before production
206     string constant public symbol = "TBX";
207     uint8 constant public decimals = 18;
208 
209     // Address where Foundation tokens are allocated
210     address constant public foundationReserve = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
211 
212     // Address where all tokens for the ICO stage are initially allocated
213     address constant public icoAllocation = 0x1111111111111111111111111111111111111111;
214 
215     // Address where all tokens for the PreICO are initially allocated
216     address constant public preIcoAllocation = 0x2222222222222222222222222222222222222222;
217 
218     // TGE start date. 11/14/2017 @ 12:00pm (UTC)
219     uint256 constant public startDate = 1510660800;
220     // TGE duration is 14 days
221     uint256 constant public duration = 14 days;
222 
223     // Vesting date to withdraw 15% of total sold tokens, 11/28/2018 @ 12:00pm (UTC)
224     uint256 constant public vestingDateEnd = 1543406400;
225 
226     // Total USD collected (10^-12)
227     uint256 public totalPicoUSD = 0;
228     uint8 constant public usdDecimals = 12;
229 
230     // Public key of the signer
231     address public signer;
232 
233     // Foundation multisignature wallet, all Ether is collected there
234     address public multisig;
235 
236     bool public finalised = false;
237 
238     // Events
239     event InvestmentInETH(address investor, uint256 tokenPriceInWei, uint256 investedInWei, uint256 investedInPicoUsd, uint256 tokensNumber, bytes32 hash);
240     event InvestmentInBTC(address investor, uint256 tokenPriceInSatoshi, uint256 investedInSatoshi, uint256 investedInPicoUsd, uint256 tokensNumber, string btcAddress);
241     event InvestmentInUSD(address investor, uint256 tokenPriceInPicoUsd, uint256 investedInPicoUsd, uint256 tokensNumber);
242     event PresaleInvestment(address investor, uint256 investedInPicoUsd, uint256 tokensNumber);
243 
244     /// @dev Contract constructor, sets totalSupply
245     function TokenboxToken(address _signer, address _multisig, uint256 _preIcoTokens )
246     {
247         // Overall, 31,000,000 TBX tokens are distributed
248         totalSupply = withDecimals(31000000, decimals);
249 
250         uint preIcoTokens = withDecimals(_preIcoTokens, decimals);
251 
252         // PreICO tokens are allocated to the special address and will be distributed manually
253         balances[preIcoAllocation] = preIcoTokens;
254 
255         // foundationReserve balance will be allocated after the end of the crowdsale
256         balances[foundationReserve] = 0;
257 
258         // The rest of the tokens is available for sale (75% of totalSupply)
259         balances[icoAllocation] = div(mul(totalSupply, 75), 100)  - preIcoTokens;
260 
261         signer = _signer;
262         multisig = _multisig;
263     }
264 
265     modifier icoIsActive {
266         require(now >= startDate && now < startDate + duration);
267         _;
268     }
269 
270     modifier icoIsCompleted {
271         require(now >= startDate + duration);
272         _;
273     }
274 
275     modifier onlyOwnerOrSigner {
276         require((msg.sender == owner) || (msg.sender == signer));
277         _;
278     }
279 
280     /// @dev Settle an investment made in ETH and distribute tokens
281     function invest(address investor, uint256 tokenPriceInPicoUsd, uint256 investedInWei, bytes32 hash, uint8 v, bytes32 r, bytes32 s, uint256 WeiToUSD)
282         public
283         icoIsActive
284         payable
285     {
286         // Check the hash
287         require(sha256(uint(investor) << 96 | tokenPriceInWei) == hash);
288 
289         // Check the signature
290         require(ecrecover(hash, v, r, s) == signer);
291 
292         // Difference between the value argument and actual value should not be
293         // more than 0.005 ETH (gas commission)
294         require(sub(investedInWei, msg.value) <= withDecimals(5, 15));
295 
296         uint tokenPriceInWei = div(mul(tokenPriceInPicoUsd, WeiToUSD), pow(10, usdDecimals));
297 
298         // Number of tokens to distribute
299         uint256 tokensNumber = div(withDecimals(investedInWei, decimals), tokenPriceInWei);
300 
301         // Check if there is enough tokens left
302         require(balances[icoAllocation] >= tokensNumber);
303 
304         // Send Ether to the multisig
305         require(multisig.send(msg.value));
306 
307         uint256 investedInPicoUsd = div(withDecimals(investedInWei, usdDecimals), WeiToUSD);
308 
309         investInUSD(investor, investedInPicoUsd, tokensNumber);
310 
311         InvestmentInETH(investor, tokenPriceInWei, investedInWei, investedInPicoUsd, tokensNumber, hash);
312     }
313 
314     /// @dev Settle an investment in BTC and distribute tokens.
315     function investInBTC(address investor, uint256 tokenPriceInPicoUsd, uint256 investedInSatoshi, string btcAddress, uint256 satoshiToUSD)
316         public
317         icoIsActive
318         onlyOwnerOrSigner
319     {
320         uint tokenPriceInSatoshi = div(mul(tokenPriceInPicoUsd, satoshiToUSD), pow(10, usdDecimals));
321 
322         // Number of tokens to distribute
323         uint256 tokensNumber = div(withDecimals(investedInSatoshi, decimals), tokenPriceInSatoshi);
324 
325         // Check if there is enough tokens left
326         require(balances[icoAllocation] >= tokensNumber);
327 
328         uint256 investedInPicoUsd = div(withDecimals(investedInSatoshi, usdDecimals), satoshiToUSD);
329 
330         investInUSD(investor, investedInPicoUsd, tokensNumber);
331 
332         InvestmentInBTC(investor, tokenPriceInSatoshi, investedInSatoshi, investedInPicoUsd, tokensNumber, btcAddress);
333     }
334 
335     // @dev Invest in USD
336     function investInUSD(address investor, uint256 investedInPicoUsd, uint256 tokensNumber)
337         private
338     {
339       totalPicoUSD = add(totalPicoUSD, investedInPicoUsd);
340 
341       // Allocate tokens to an investor
342       balances[icoAllocation] -= tokensNumber;
343       balances[investor] += tokensNumber;
344       Transfer(icoAllocation, investor, tokensNumber);
345     }
346 
347     // @dev Wire investment
348     function wireInvestInUSD(address investor, uint256 tokenPriceInUsdCents, uint256 investedInUsdCents)
349         public
350         icoIsActive
351         onlyOwnerOrSigner
352      {
353 
354        uint256 tokensNumber = div(withDecimals(investedInUsdCents, decimals), tokenPriceInUsdCents);
355 
356        // Check if there is enough tokens left
357        require(balances[icoAllocation] >= tokensNumber);
358 
359        // We subtract 2 because the value is in cents.
360        uint256 investedInPicoUsd = withDecimals(investedInUsdCents, usdDecimals - 2);
361        uint256 tokenPriceInPicoUsd = withDecimals(tokenPriceInUsdCents, usdDecimals - 2);
362 
363        investInUSD(investor, investedInPicoUsd, tokensNumber);
364 
365        InvestmentInUSD(investor, tokenPriceInPicoUsd, investedInPicoUsd, tokensNumber);
366     }
367 
368     // @dev Presale tokens distribution
369     function preIcoDistribution(address investor, uint256 investedInUsdCents, uint256 tokensNumber)
370         public
371         onlyOwner
372     {
373       uint256 tokensNumberWithDecimals = withDecimals(tokensNumber, decimals);
374 
375       // Check if there is enough tokens left
376       require(balances[preIcoAllocation] >= tokensNumberWithDecimals);
377 
378       // Allocate tokens to an investor
379       balances[preIcoAllocation] -= tokensNumberWithDecimals;
380       balances[investor] += tokensNumberWithDecimals;
381       Transfer(preIcoAllocation, investor, tokensNumberWithDecimals);
382 
383       uint256 investedInPicoUsd = withDecimals(investedInUsdCents, usdDecimals - 2);
384       // Add investment to totalPicoUSD collected
385       totalPicoUSD = add(totalPicoUSD, investedInPicoUsd);
386 
387       PresaleInvestment(investor, investedInPicoUsd, tokensNumberWithDecimals);
388     }
389 
390 
391     /// @dev Allow token withdrawals from Foundation reserve
392     function allowToWithdrawFromReserve()
393         public
394         onlyOwner
395     {
396         require(now >= vestingDateEnd);
397 
398         // Allow the owner to withdraw tokens from the Foundation reserve
399         allowed[foundationReserve][msg.sender] = balanceOf(foundationReserve);
400     }
401 
402 
403     // @dev Withdraws tokens from Foundation reserve
404     function withdrawFromReserve(uint amount)
405         public
406         onlyOwner
407     {
408         require(now >= vestingDateEnd);
409         // Withdraw tokens from Foundation reserve to multisig address
410         require(transferFrom(foundationReserve, multisig, amount));
411     }
412 
413     /// @dev Changes multisig address
414     function changeMultisig(address _multisig)
415         public
416         onlyOwner
417     {
418         multisig = _multisig;
419     }
420 
421     /// @dev Changes signer address
422     function changeSigner(address _signer)
423         public
424         onlyOwner
425     {
426         signer = _signer;
427     }
428 
429     /// @dev Burns the rest of the tokens after the crowdsale end and
430     /// send 10% tokens of totalSupply to team address
431     function finaliseICO()
432         public
433         onlyOwner
434         icoIsCompleted
435     {
436         require(!finalised);
437 
438         //total sold during ICO
439         totalSupply = sub(totalSupply, balanceOf(icoAllocation));
440         totalSupply = sub(totalSupply, withDecimals(7750000, decimals));
441 
442         //send 5% bounty + 7.5% of total sold tokens to team address
443         balances[multisig] = div(mul(totalSupply, 125), 1000);
444 
445         //lock 12.5% of sold tokens to team address for one year
446         balances[foundationReserve] = div(mul(totalSupply, 125), 1000);
447 
448         totalSupply = add(totalSupply, mul(balanceOf(foundationReserve), 2));
449 
450         //burn the rest of tokens
451         balances[icoAllocation] = 0;
452 
453         finalised = true;
454     }
455 
456     function totalUSD()
457       public
458       constant
459       returns (uint)
460     {
461        return div(totalPicoUSD, pow(10, usdDecimals));
462     }
463 }