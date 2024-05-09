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
50         for (uint i = 0; i < values.length; i++)
51         {
52             result = add(result, values[i]);
53         }
54         return result;
55     }
56 }
57 
58 contract Ownable
59 {
60     
61     constructor() public
62     {
63         ownerAddress = msg.sender;
64     }
65 
66     event TransferOwnership(
67         address indexed previousOwner,
68         address indexed newOwner
69     );
70 
71     address public ownerAddress;
72     //wallet that can change owner
73     address internal masterKey = 0x4977A392d8D207B49c7fDE8A6B91C23bCebE7291;
74    
75     function transferOwnership(address newOwner) 
76         public 
77         returns(bool);
78     
79    
80     modifier onlyOwner()
81     {
82         require(msg.sender == ownerAddress);
83         _;
84     }
85     // Prevents user to send transaction on his own address
86     modifier notSender(address owner)
87     {
88         require(msg.sender != owner);
89         _;
90     }
91 }
92 
93 contract ERC20Basic
94 {
95     event Transfer(
96         address indexed from, 
97         address indexed to,
98         uint256 value
99     );
100     
101     uint256 public totalSupply;
102     
103     function balanceOf(address who) public view returns(uint256);
104     function transfer(address to, uint256 value) public returns(bool);
105 }
106 
107 contract BasicToken is ERC20Basic, Ownable 
108 {
109     using SafeMath for uint256;
110 
111     struct WalletData 
112     {
113         uint256 tokensAmount;  //Tokens amount on wallet
114         uint256 freezedAmount;  //Freezed tokens amount on wallet.
115         bool canFreezeTokens;  //Is wallet can freeze tokens or not.
116         uint unfreezeDate; // Date when we can unfreeze tokens on wallet.
117     }
118    
119     mapping(address => WalletData) wallets;
120 
121     function transfer(address to, uint256 value)
122         public
123         notSender(to)
124         returns(bool)
125     {    
126         require(to != address(0) 
127         && wallets[msg.sender].tokensAmount >= value 
128         && checkIfCanUseTokens(msg.sender, value)); 
129 
130         uint256 amount = wallets[msg.sender].tokensAmount.sub(value);
131         wallets[msg.sender].tokensAmount = amount;
132         wallets[to].tokensAmount = wallets[to].tokensAmount.add(value);
133         
134         emit Transfer(msg.sender, to, value);
135         return true;
136     }
137 
138     function balanceOf(address owner)
139         public
140         view
141         returns(uint256 balance)
142     {
143         return wallets[owner].tokensAmount;
144     }
145     // Check wallet on unfreeze tokens amount
146     function checkIfCanUseTokens(
147         address owner,
148         uint256 amount
149     ) 
150         internal
151         view
152         returns(bool) 
153     {
154         uint256 unfreezedAmount = wallets[owner].tokensAmount - wallets[owner].freezedAmount;
155         return amount <= unfreezedAmount;
156     }
157 }
158 
159 contract FreezableToken is BasicToken 
160 {
161     event ChangeFreezePermission(address indexed who, bool permission);
162     event FreezeTokens(address indexed who, uint256 freezeAmount);
163     event UnfreezeTokens(address indexed who, uint256 unfreezeAmount);
164     
165     // Give\deprive permission to a wallet for freeze tokens.
166     function giveFreezePermission(address[] owners, bool permission)
167         public
168         onlyOwner
169         returns(bool)
170     {
171         for (uint i = 0; i < owners.length; i++)
172         {
173         wallets[owners[i]].canFreezeTokens = permission;
174         emit ChangeFreezePermission(owners[i], permission);
175         }
176         return true;
177     }
178     
179     function freezeAllowance(address owner)
180         public
181         view
182         returns(bool)
183     {
184         return wallets[owner].canFreezeTokens;   
185     }
186     // Freeze tokens on sender wallet if have permission.
187     function freezeTokens(uint256 amount, uint unfreezeDate)
188         public
189         isFreezeAllowed
190         returns(bool)
191     {
192         //We can freeze tokens only if there are no frozen tokens on the wallet.
193         require(wallets[msg.sender].freezedAmount == 0
194         && wallets[msg.sender].tokensAmount >= amount); 
195         wallets[msg.sender].freezedAmount = amount;
196         wallets[msg.sender].unfreezeDate = unfreezeDate;
197         emit FreezeTokens(msg.sender, amount);
198         return true;
199     }
200     
201     function showFreezedTokensAmount(address owner)
202     public
203     view
204     returns(uint256)
205     {
206         return wallets[owner].freezedAmount;
207     }
208     
209     function unfreezeTokens()
210         public
211         returns(bool)
212     {
213         require(wallets[msg.sender].freezedAmount > 0
214         && now >= wallets[msg.sender].unfreezeDate);
215         emit UnfreezeTokens(msg.sender, wallets[msg.sender].freezedAmount);
216         wallets[msg.sender].freezedAmount = 0; // Unfreeze all tokens.
217         wallets[msg.sender].unfreezeDate = 0;
218         return true;
219     }
220     //Show date in UNIX time format.
221     function showTokensUnfreezeDate(address owner)
222     public
223     view
224     returns(uint)
225     {
226         //If wallet don't have freezed tokens - function will return 0.
227         return wallets[owner].unfreezeDate;
228     }
229     
230     function getUnfreezedTokens(address owner)
231     internal
232     view
233     returns(uint256)
234     {
235         return wallets[owner].tokensAmount - wallets[owner].freezedAmount;
236     }
237     
238     modifier isFreezeAllowed()
239     {
240         require(freezeAllowance(msg.sender));
241         _;
242     }
243 }
244 
245 contract MultisendableToken is FreezableToken
246 {
247     using SafeMath for uint256;
248 
249     function massTransfer(address[] addresses, uint[] values)
250         public
251         onlyOwner
252         returns(bool) 
253     {
254         for (uint i = 0; i < addresses.length; i++)
255         {
256             transferFromOwner(addresses[i], values[i]);
257         }
258         return true;
259     }
260 
261     function transferFromOwner(address to, uint256 value)
262         internal
263         notSender(to)
264         onlyOwner
265     {
266         require(to != address(0)
267         && wallets[ownerAddress].tokensAmount >= value
268         && checkIfCanUseTokens(ownerAddress, value));
269         
270         wallets[ownerAddress].tokensAmount = wallets[ownerAddress].
271                                              tokensAmount.sub(value); 
272         wallets[to].tokensAmount = wallets[to].tokensAmount.add(value);
273         
274         emit Transfer(ownerAddress, to, value);
275     }
276 }
277     
278 contract Airdropper is MultisendableToken
279 {
280     using SafeMath for uint256[];
281     
282     event Airdrop(uint256 tokensDropped, uint256 airdropCount);
283     event AirdropFinished();
284     
285     uint256 public airdropsCount = 0;
286     uint256 public airdropTotalSupply = 0;
287     uint256 public airdropDistributedTokensAmount = 0;
288     bool public airdropFinished = false;
289     
290     function airdropToken(address[] addresses, uint256[] values) 
291         public
292         onlyOwner
293         returns(bool) 
294     {
295         require(!airdropFinished);
296         uint256 totalSendAmount = values.getAllValuesSum();
297         uint256 totalDropAmount = airdropDistributedTokensAmount
298                                   + totalSendAmount;
299         require(totalDropAmount <= airdropTotalSupply);
300         massTransfer(addresses, values);
301         airdropDistributedTokensAmount = totalDropAmount;
302         airdropsCount++;
303         
304         emit Airdrop(totalSendAmount, airdropsCount);
305         return true;
306     }
307     
308     function finishAirdrops() public onlyOwner 
309     {
310         // Can't finish airdrop before send all tokens for airdrop.
311         require(airdropDistributedTokensAmount == airdropTotalSupply);
312         airdropFinished = true;
313         emit AirdropFinished();
314     }
315 }
316 
317 contract CryptosoulToken is Airdropper
318 {
319     event Mint(address indexed to, uint256 value);
320     event AllowMinting();
321     event Burn(address indexed from, uint256 value);
322     
323     string constant public name = "CryptoSoul Token";
324     string constant public symbol = "SOUL";
325     uint constant public decimals = 18;
326     
327     uint256 constant public START_TOKENS = 500000000 * 10**decimals; //500M start
328     uint256 constant public MINT_AMOUNT = 1370000 * 10**decimals;
329     uint32 constant public MINT_INTERVAL_SEC = 1 days; // 24 hours
330     uint256 constant private MAX_BALANCE_VALUE = 2**256 - 1;
331     uint constant public startMintingDate = 1538352000; //01.10.2018 (DD, MM, YYYY)
332     
333     uint public nextMintPossibleTime = 0;
334     bool public canMint = false;
335     
336     constructor() public 
337     {
338         wallets[ownerAddress].tokensAmount = START_TOKENS;
339         wallets[ownerAddress].canFreezeTokens = true;
340         totalSupply = START_TOKENS;
341         airdropTotalSupply = 200000000 * 10**decimals;
342         emit Mint(ownerAddress, START_TOKENS);
343     }
344 
345     function allowMinting()
346     public
347     onlyOwner
348     {
349         // Can start minting token after 01.10.2018
350         require(!canMint
351         && now >= startMintingDate);
352         nextMintPossibleTime = now;
353         canMint = true;
354         emit AllowMinting();
355     }
356 
357     function mint()
358         public
359         onlyOwner
360         returns(bool)
361     {
362         require(canMint
363         && now >= nextMintPossibleTime
364         && totalSupply + MINT_AMOUNT <= MAX_BALANCE_VALUE);
365         nextMintPossibleTime = nextMintPossibleTime.add(MINT_INTERVAL_SEC);
366         wallets[ownerAddress].tokensAmount = wallets[ownerAddress].tokensAmount.
367                                              add(MINT_AMOUNT);  
368         totalSupply = totalSupply.add(MINT_AMOUNT);
369         
370         emit Mint(ownerAddress, MINT_AMOUNT);
371         return true;
372     }
373 
374     function burn(uint256 value)
375         public
376         onlyOwner
377         returns(bool)
378     {
379         require(checkIfCanUseTokens(ownerAddress, value)
380         && wallets[ownerAddress].tokensAmount >= value);
381         
382         wallets[ownerAddress].tokensAmount = wallets[ownerAddress].
383                                              tokensAmount.sub(value);
384         totalSupply = totalSupply.sub(value);                             
385         
386         emit Burn(ownerAddress, value);
387         return true;
388     }
389     
390     function transferOwnership(address newOwner) 
391         public
392         notSender(newOwner)
393         returns(bool)
394     {
395         require(msg.sender == masterKey 
396         && newOwner != address(0));
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