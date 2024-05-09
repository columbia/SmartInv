1 pragma solidity ^0.4.20;
2 
3 
4 pragma solidity ^0.4.15;
5 
6 /**
7  * @title Safe math operations that throw error on overflow.
8  *
9  * Credit: Taking ideas from FirstBlood token
10  */
11 library SafeMath {
12 
13     /** 
14      * @dev Safely add two numbers.
15      *
16      * @param x First operant.
17      * @param y Second operant.
18      * @return The result of x+y.
19      */
20     function add(uint256 x, uint256 y)
21     internal constant
22     returns(uint256) {
23         uint256 z = x + y;
24         assert((z >= x) && (z >= y));
25         return z;
26     }
27 
28     /** 
29      * @dev Safely substract two numbers.
30      *
31      * @param x First operant.
32      * @param y Second operant.
33      * @return The result of x-y.
34      */
35     function sub(uint256 x, uint256 y)
36     internal constant
37     returns(uint256) {
38         assert(x >= y);
39         uint256 z = x - y;
40         return z;
41     }
42 
43     /** 
44      * @dev Safely multiply two numbers.
45      *
46      * @param x First operant.
47      * @param y Second operant.
48      * @return The result of x*y.
49      */
50     function mul(uint256 x, uint256 y)
51     internal constant
52     returns(uint256) {
53         uint256 z = x * y;
54         assert((x == 0) || (z/x == y));
55         return z;
56     }
57 
58     /**
59     * @dev Parse a floating point number from String to uint, e.g. "250.56" to "25056"
60      */
61     function parse(string s) 
62     internal constant 
63     returns (uint256) 
64     {
65     bytes memory b = bytes(s);
66     uint result = 0;
67     for (uint i = 0; i < b.length; i++) {
68         if (b[i] >= 48 && b[i] <= 57) {
69             result = result * 10 + (uint(b[i]) - 48); 
70         }
71     }
72     return result; 
73 }
74 }
75 
76 
77 /**
78  * @title The abstract ERC-20 Token Standard definition.
79  *
80  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
81  */
82 contract Token {
83     /// @dev Returns the total token supply.
84     uint256 public totalSupply;
85 
86     function balanceOf(address _owner) public constant returns (uint256 balance);
87     function transfer(address _to, uint256 _value) public returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
91 
92     /// @dev MUST trigger when tokens are transferred, including zero value transfers.
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94 
95     /// @dev MUST trigger on any successful call to approve(address _spender, uint256 _value).
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 
99 /**
100  * @title Default implementation of the ERC-20 Token Standard.
101  */
102 contract StandardToken is Token {
103 
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106 
107     modifier onlyPayloadSize(uint numwords) {
108         assert(msg.data.length == numwords * 32 + 4);
109         _;
110     }
111 
112     /**
113      * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
114      * @dev The function SHOULD throw if the _from account balance does not have enough tokens to spend.
115      *
116      * @dev A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
117      *
118      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
119      *
120      * @param _to The receiver of the tokens.
121      * @param _value The amount of tokens to send.
122      * @return True on success, false otherwise.
123      */
124     function transfer(address _to, uint256 _value)
125     public
126     returns (bool success) {
127         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
128             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
129             balances[_to] = SafeMath.add(balances[_to], _value);
130             Transfer(msg.sender, _to, _value);
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     /**
138      * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
139      *
140      * @dev The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
141      * @dev This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in 
142      * @dev sub-currencies. The function SHOULD throw unless the _from account has deliberately authorized the sender of 
143      * @dev the message via some mechanism.
144      *
145      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
146      *
147      * @param _from The sender of the tokens.
148      * @param _to The receiver of the tokens.
149      * @param _value The amount of tokens to send.
150      * @return True on success, false otherwise.
151      */
152     function transferFrom(address _from, address _to, uint256 _value)
153     public
154     returns (bool success) {
155         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
156             balances[_to] = SafeMath.add(balances[_to], _value);
157             balances[_from] = SafeMath.sub(balances[_from], _value);
158             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
159             Transfer(_from, _to, _value);
160             return true;
161         } else {
162             return false;
163         }
164     }
165 
166     /**
167      * @dev Returns the account balance of another account with address _owner.
168      *
169      * @param _owner The address of the account to check.
170      * @return The account balance.
171      */
172     function balanceOf(address _owner)
173     public constant
174     returns (uint256 balance) {
175         return balances[_owner];
176     }
177 
178     /**
179      * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. 
180      * @dev If this function is called again it overwrites the current allowance with _value.
181      *
182      * @dev NOTE: To prevent attack vectors like the one described in [1] and discussed in [2], clients 
183      * @dev SHOULD make sure to create user interfaces in such a way that they set the allowance first 
184      * @dev to 0 before setting it to another value for the same spender. THOUGH The contract itself 
185      * @dev shouldn't enforce it, to allow backwards compatilibilty with contracts deployed before.
186      * @dev [1] https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
187      * @dev [2] https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      *
189      * @param _spender The address which will spend the funds.
190      * @param _value The amount of tokens to be spent.
191      * @return True on success, false otherwise.
192      */
193     function approve(address _spender, uint256 _value)
194     public
195     onlyPayloadSize(2)
196     returns (bool success) {
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203      * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
204      *
205      * @param _owner The address of the sender.
206      * @param _spender The address of the receiver.
207      * @return The allowed withdrawal amount.
208      */
209     function allowance(address _owner, address _spender)
210     public constant
211     onlyPayloadSize(2)
212     returns (uint256 remaining) {
213         return allowed[_owner][_spender];
214     }
215 }
216 
217 
218 /**
219  * @title The LCDToken Token contract.
220  *
221  * Credit: Taking ideas from BAT token and NET token
222  */
223  /*is StandardToken */
224 contract LCDToken is StandardToken {
225 
226     // Token metadata
227     string public constant name = "Lucyd";
228     string public constant symbol = "LCD";
229     uint256 public constant decimals = 18;
230 
231     uint256 public constant TOKEN_COMPANY_OWNED = 10 * (10**6) * 10**decimals; // 10 million LCDs
232     uint256 public constant TOKEN_MINTING = 30 * (10**6) * 10**decimals;       // 30 million LCDs
233     uint256 public constant TOKEN_BUSINESS = 10 * (10**6) * 10**decimals;       // 10 million LCDs
234 
235     // wallet that is allowed to distribute tokens on behalf of the app store
236     address public APP_STORE;
237 
238     // Administrator for multi-sig mechanism
239     address public admin1;
240     address public admin2;
241 
242     // Accounts that are allowed to deliver tokens
243     address public tokenVendor1;
244     address public tokenVendor2;
245 
246     // Keep track of holders and icoBuyers
247     mapping (address => bool) public isHolder; // track if a user is a known token holder to the smart contract - important for payouts later
248     address[] public holders;                  // array of all known holders - important for payouts later
249 
250     // store the hashes of admins' msg.data
251     mapping (address => bytes32) private multiSigHashes;
252 
253     // to track if management already got their tokens
254     bool public managementTokensDelivered;
255 
256     // current amount of disbursed tokens
257     uint256 public tokensSold;
258 
259     // Events used for logging
260     event LogLCDTokensDelivered(address indexed _to, uint256 _value);
261     event LogManagementTokensDelivered(address indexed distributor, uint256 _value);
262     event Auth(string indexed authString, address indexed user);
263 
264     modifier onlyOwner() {
265         // check if transaction sender is admin.
266         require (msg.sender == admin1 || msg.sender == admin2);
267         // if yes, store his msg.data. 
268         multiSigHashes[msg.sender] = keccak256(msg.data);
269         // check if his stored msg.data hash equals to the one of the other admin
270         if ((multiSigHashes[admin1]) == (multiSigHashes[admin2])) {
271             // if yes, both admins agreed - continue.
272             _;
273 
274             // Reset hashes after successful execution
275             multiSigHashes[admin1] = 0x0;
276             multiSigHashes[admin2] = 0x0;
277         } else {
278             // if not (yet), return.
279             return;
280         }
281     }
282 
283     modifier onlyVendor() {
284         require((msg.sender == tokenVendor1) || (msg.sender == tokenVendor2));
285         _;
286     }
287 
288     /**
289      * @dev Create a new LCDToken contract.
290      *
291      *  _admin1 The first admin account that owns this contract.
292      *  _admin2 The second admin account that owns this contract.
293      *  _tokenVendor1 The first token vendor
294      *  _tokenVendor2 The second token vendor
295      */
296     function LCDToken(
297         address _admin1,
298         address _admin2,
299         address _tokenVendor1,
300         address _tokenVendor2,
301         address _appStore,
302         address _business_development)
303     public
304     {
305         // admin1 and admin2 address must be set and must be different
306         require (_admin1 != 0x0);
307         require (_admin2 != 0x0);
308         require (_admin1 != _admin2);
309 
310         // tokenVendor1 and tokenVendor2 must be set and must be different
311         require (_tokenVendor1 != 0x0);
312         require (_tokenVendor2 != 0x0);
313         require (_tokenVendor1 != _tokenVendor2);
314 
315         // tokenVendors must be different from admins
316         require (_tokenVendor1 != _admin1);
317         require (_tokenVendor1 != _admin2);
318         require (_tokenVendor2 != _admin1);
319         require (_tokenVendor2 != _admin2);
320         require (_appStore != 0x0);
321 
322         admin1 = _admin1;
323         admin2 = _admin2;
324         tokenVendor1 = _tokenVendor1;
325         tokenVendor2 = _tokenVendor2;
326 
327         // Init app store balance
328         APP_STORE = _appStore;
329         balances[_appStore] = TOKEN_MINTING;
330         trackHolder(_appStore);
331 
332         // Init business development balance to admin1 
333         balances[_admin1] = TOKEN_BUSINESS;
334         trackHolder(_business_development);
335 
336         totalSupply = SafeMath.add(TOKEN_MINTING, TOKEN_BUSINESS);
337     }
338 
339     // Allows to figure out the amount of known token holders
340     function getHolderCount()
341     public
342     constant
343     returns (uint256 _holderCount)
344     {
345         return holders.length;
346     }
347 
348     // Allows for easier retrieval of holder by array index
349     function getHolder(uint256 _index)
350     public
351     constant
352     returns (address _holder)
353     {
354         return holders[_index];
355     }
356 
357     function trackHolder(address _to)
358     private
359     returns (bool success)
360     {
361         // Check if the recipient is a known token holder
362         if (isHolder[_to] == false) {
363             // if not, add him to the holders array and mark him as a known holder
364             holders.push(_to);
365             isHolder[_to] = true;
366         }
367         return true;
368     }
369 
370     /// @dev Transfer LCD tokens
371     function deliverTokens(address _buyer, uint256 _amount) // amount input will  be in cents
372     external
373     onlyVendor
374     returns(bool success)
375     {
376         // check if the function is called before May 1, 2018
377         require(block.timestamp <= 1525125600);
378 
379         // Calculate the number of tokens from the given amount in cents
380         uint256 tokens = SafeMath.mul(_amount, 10**decimals / 100);
381 
382         // update state
383         uint256 oldBalance = balances[_buyer];
384         balances[_buyer] = SafeMath.add(oldBalance, tokens);
385         tokensSold = SafeMath.add(tokensSold, tokens);
386         totalSupply = SafeMath.add(totalSupply, tokens);
387         trackHolder(_buyer);
388 
389         // Log the transfer of these tokens
390         Transfer(msg.sender, _buyer, tokens);
391         LogLCDTokensDelivered(_buyer, tokens);
392         return true;
393     }
394 
395     // @dev Transfer tokens to management wallet
396     function deliverManagementTokens(address _managementWallet)
397     external
398     onlyOwner
399     returns (bool success)
400     {
401         // check if management tokens are already unlocked, if the function is called after March 31., 2019
402         require(block.timestamp >= 1553990400);
403 
404         // Deliver management tokens only once
405         require(managementTokensDelivered == false);
406 
407         // update state
408         balances[_managementWallet] = TOKEN_COMPANY_OWNED;
409         totalSupply = SafeMath.add(totalSupply, TOKEN_COMPANY_OWNED);
410         managementTokensDelivered = true;
411         trackHolder(_managementWallet);
412 
413         // Log the transfer of these tokens
414         Transfer(address(this), _managementWallet, TOKEN_COMPANY_OWNED);
415         LogManagementTokensDelivered(_managementWallet, TOKEN_COMPANY_OWNED);
416         return true;
417     }
418 
419     // Using this for creating a reference between ETH wallets and accounts in the Lucyd backend
420     function auth(string _authString)
421     external
422     {
423         Auth(_authString, msg.sender);
424     }
425 }