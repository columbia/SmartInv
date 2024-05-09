1 pragma solidity ^0.4.24;
2 
3 library SafeMath 
4 {
5     function mul(uint256 a, uint256 b)
6         internal
7         pure
8         returns (uint256)
9     {
10         uint256 result = a * b;
11         assert(a == 0 || result / a == b);
12         return result;
13     }
14  
15     function div(uint256 a, uint256 b)
16         internal
17         pure
18         returns (uint256)
19     {
20         uint256 result = a / b;
21         return result;
22     }
23  
24     function sub(uint256 a, uint256 b)
25         internal
26         pure
27         returns (uint256)
28     {
29         assert(b <= a); 
30         return a - b; 
31     } 
32   
33     function add(uint256 a, uint256 b)
34         internal
35         pure
36         returns (uint256)
37     { 
38         uint256 result = a + b; 
39         assert(result >= a);
40         return result;
41     }
42  
43     function getAllValuesSum(uint256[] values)
44         internal
45         pure
46         returns(uint256)
47     {
48         uint256 result = 0;
49         
50         for (uint i = 0; i < values.length; i++){
51             result = add(result, values[i]);
52         }
53         return result;
54     }
55 }
56 
57 contract Ownable {
58     constructor() public {
59         ownerAddress = msg.sender;
60     }
61 
62     event TransferOwnership(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67     address public ownerAddress;
68     //wallet that can change owner
69     address internal masterKey = 0x819466D9C043DBb7aB4E1168aB8E014c3dCAA470;
70    
71     function transferOwnership(address newOwner) 
72         public 
73         returns(bool);
74     
75    
76     modifier onlyOwner() {
77         require(msg.sender == ownerAddress);
78         _;
79     }
80     // Prevents user to send transaction on his own address
81     modifier notSender(address owner){
82         require(msg.sender != owner);
83         _;
84     }
85 }
86 
87 contract ERC20Basic
88 {
89     event Transfer(
90         address indexed from, 
91         address indexed to,
92         uint256 value
93     );
94     
95     uint256 public totalSupply;
96     
97     function balanceOf(address who) public view returns(uint256);
98     function transfer(address to, uint256 value) public returns(bool);
99 }
100 
101 contract BasicToken is ERC20Basic, Ownable {
102     using SafeMath for uint256;
103 
104     struct WalletData {
105         uint256 tokensAmount;
106         uint256 freezedAmount;
107         bool canFreezeTokens;
108     }
109    
110     mapping(address => WalletData) wallets;
111 
112     function transfer(address to, uint256 value)
113         public
114         notSender(to)
115         returns(bool)
116     {    
117         require(to != address(0) 
118         && wallets[msg.sender].tokensAmount >= value 
119         && (wallets[msg.sender].canFreezeTokens && checkIfCanUseTokens(msg.sender, value)));
120 
121         uint256 amount = wallets[msg.sender].tokensAmount.sub(value);
122         wallets[msg.sender].tokensAmount = amount;
123         wallets[to].tokensAmount = wallets[to].tokensAmount.add(value);
124         
125         emit Transfer(msg.sender, to, value);
126         return true;
127     }
128 
129     function balanceOf(address owner)
130         public
131         view
132         returns(uint256 balance)
133     {
134         return wallets[owner].tokensAmount;
135     }
136     // Check wallet on unfreeze tokens amount
137     function checkIfCanUseTokens(
138         address owner,
139         uint256 amount
140     ) 
141         internal
142         view
143         returns(bool) 
144     {
145         uint256 unfreezedAmount = wallets[owner].tokensAmount - wallets[owner].freezedAmount;
146         return amount <= unfreezedAmount;
147     }
148 }
149 
150 contract FreezableToken is BasicToken {
151     event AllowFreeze(address indexed who);
152     event DissallowFreeze(address indexed who);
153     event FreezeTokens(address indexed who, uint256 freezeAmount);
154     event UnfreezeTokens(address indexed who, uint256 unfreezeAmount);
155         
156     uint256 public freezeTokensAmount = 0;
157     
158     // Give permission to a wallet for freeze tokens.
159     function allowFreezing(address owner)
160         public
161         onlyOwner
162         returns(bool)
163     {
164         require(!wallets[owner].canFreezeTokens);
165         wallets[owner].canFreezeTokens = true;
166         emit AllowFreeze(owner);
167         return true;
168     }
169     
170     function dissalowFreezing(address owner)
171         public
172         onlyOwner
173         returns(bool)
174     {
175         require(wallets[owner].canFreezeTokens);
176         wallets[owner].canFreezeTokens = false;
177         wallets[owner].freezedAmount = 0;
178         
179         emit DissallowFreeze(owner);
180         return true;
181     }
182     
183     function freezeAllowance(address owner)
184         public
185         view
186         returns(bool)
187     {
188         return wallets[owner].canFreezeTokens;   
189     }
190     // Freeze tokens on sender wallet if have permission.
191     function freezeTokens(
192         uint256 amount
193     )
194         public
195         isFreezeAllowed
196         returns(bool)
197     {
198         uint256 freezedAmount = wallets[msg.sender].freezedAmount.add(amount);
199         require(wallets[msg.sender].tokensAmount >= freezedAmount);
200         wallets[msg.sender].freezedAmount = freezedAmount;
201         emit FreezeTokens(msg.sender, amount);
202         return true;
203     }
204     
205     function showFreezedTokensAmount(address owner)
206     public
207     view
208     returns(uint256)
209     {
210         return wallets[owner].freezedAmount;
211     }
212     
213     function unfreezeTokens(
214         uint256 amount
215     ) 
216         public
217         isFreezeAllowed
218         returns(bool)
219     {
220         uint256 freezeAmount = wallets[msg.sender].freezedAmount.sub(amount);
221         wallets[msg.sender].freezedAmount = freezeAmount;
222         emit UnfreezeTokens(msg.sender, amount);
223         return true;
224     }
225     
226     function getUnfreezedTokens(address owner)
227     internal
228     view
229     returns(uint256)
230     {
231         return wallets[owner].tokensAmount - wallets[owner].freezedAmount;
232     }
233     
234     modifier isFreezeAllowed() {
235         require(freezeAllowance(msg.sender));
236         _;
237     }
238 }
239 
240 contract MultisendableToken is FreezableToken
241 {
242     using SafeMath for uint256;
243 
244     function massTransfer(
245         address[] addresses,
246         uint[] values
247     ) 
248         public
249         onlyOwner
250         returns(bool) 
251     {
252         for (uint i = 0; i < addresses.length; i++){
253             transferFromOwner(addresses[i], values[i]);
254         }
255         return true;
256     }
257 
258     function transferFromOwner(
259         address to,
260         uint256 value
261     )
262         internal
263         onlyOwner
264     {
265         require(to != address(0)
266         && wallets[ownerAddress].tokensAmount >= value
267         && (freezeAllowance(ownerAddress) && checkIfCanUseTokens(ownerAddress, value)));
268         
269         uint256 freezeAmount = wallets[ownerAddress].tokensAmount.sub(value);
270         wallets[ownerAddress].tokensAmount = freezeAmount;
271         wallets[to].tokensAmount = wallets[to].tokensAmount.add(value);
272         
273         emit Transfer(ownerAddress, to, value);
274     }
275 }
276     
277 contract Airdropper is MultisendableToken
278 {
279     using SafeMath for uint256[];
280     
281     event Airdrop(uint256 tokensDropped, uint256 airdropCount);
282     event AirdropFinished();
283     
284     uint256 public airdropsCount = 0;
285     uint256 public airdropTotalSupply = 0;
286     uint256 public distributedTokensAmount = 0;
287     bool public airdropFinished = false;
288     
289     function airdropToken(
290         address[] addresses,
291         uint256[] values
292     ) 
293         public
294         onlyOwner
295         returns(bool) 
296     {
297         uint256 result = distributedTokensAmount + values.getAllValuesSum();
298         require(!airdropFinished && result <= airdropTotalSupply);
299         
300         distributedTokensAmount = result;
301         airdropsCount++;
302         
303         emit Airdrop(values.getAllValuesSum(), airdropsCount);
304         return massTransfer(addresses, values);
305     }
306     
307     function finishAirdrops() public onlyOwner {
308         // Can't finish airdrop before send all tokens for airdrop.
309         require(distributedTokensAmount == airdropTotalSupply);
310         airdropFinished = true;
311         emit AirdropFinished();
312     }
313 }
314 
315 contract CryptosoulToken is Airdropper {
316     event Mint(address indexed to, uint256 value);
317     event AllowMinting();
318     event Burn(address indexed from, uint256 value);
319     
320     string constant public name = "CryptoSoul";
321     string constant public symbol = "SOUL";
322     uint constant public decimals = 6;
323     
324     uint256 constant public START_TOKENS = 500000000 * 10**decimals; //500M start
325     uint256 constant public MINT_AMOUNT = 1360000 * 10**decimals;
326     uint32 constant public MINT_INTERVAL_SEC = 1 days; // 24 hours
327     uint256 constant private MAX_BALANCE_VALUE = 2**256 - 1;
328     uint constant public startMintingData = 1538352000;
329     
330     uint public nextMintPossibleTime = 0;
331     bool public canMint = false;
332     
333     constructor() public {
334         wallets[ownerAddress].tokensAmount = START_TOKENS;
335         wallets[ownerAddress].canFreezeTokens = true;
336         totalSupply = START_TOKENS;
337         airdropTotalSupply = 200000000 * 10**decimals;
338         emit Mint(ownerAddress, START_TOKENS);
339     }
340 
341     function allowMinting()
342     public
343     onlyOwner
344     {
345         // Can start minting token after 01.10.2018
346         require(now >= startMintingData);
347         nextMintPossibleTime = now;
348         canMint = true;
349         emit AllowMinting();
350     }
351 
352     function mint()
353         public
354         onlyOwner
355         returns(bool)
356     {
357         require(canMint &&
358         totalSupply + MINT_AMOUNT <= MAX_BALANCE_VALUE
359         && now >= nextMintPossibleTime);
360         nextMintPossibleTime = nextMintPossibleTime.add(MINT_INTERVAL_SEC);
361         uint256 freezeAmount = wallets[ownerAddress].tokensAmount.add(MINT_AMOUNT);
362         wallets[ownerAddress].tokensAmount = freezeAmount;
363         totalSupply = totalSupply.add(MINT_AMOUNT);
364         
365         emit Mint(ownerAddress, MINT_AMOUNT);
366         return true;
367     }
368 
369     function burn(uint256 value)
370         public
371         onlyOwner
372         returns(bool)
373     {
374         require(checkIfCanUseTokens(ownerAddress, value)
375         && wallets[ownerAddress].tokensAmount >= value);
376         
377         uint256 freezeAmount = wallets[ownerAddress].tokensAmount.sub(value);
378         wallets[ownerAddress].tokensAmount = freezeAmount;
379         totalSupply = totalSupply.sub(value);                             
380         
381         emit Burn(ownerAddress, value);
382         return true;
383     }
384     
385     function transferOwnership(address newOwner) 
386         public
387         returns(bool)
388     {
389         require(msg.sender == masterKey && newOwner != address(0));
390         // Transfer token data from old owner to new.
391         wallets[newOwner].tokensAmount = wallets[ownerAddress].tokensAmount;
392         wallets[newOwner].canFreezeTokens = true;
393         wallets[newOwner].freezedAmount = wallets[ownerAddress].freezedAmount;
394         wallets[ownerAddress].freezedAmount = 0;
395         wallets[ownerAddress].tokensAmount = 0;
396         wallets[ownerAddress].canFreezeTokens = false;
397         emit TransferOwnership(ownerAddress, newOwner);
398         ownerAddress = newOwner;
399         return true;
400     }
401     
402     function()
403         public
404         payable
405     {
406         revert();
407     }
408 }