1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract owned {
50     address public owner;
51 
52     function owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address newOwner) onlyOwner public {
62         owner = newOwner;
63     }
64 }
65 
66 interface tokenRecipient {
67     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
68 }
69 
70 contract ParsecTokenERC20 {
71     // Public variables of the token
72     string public constant name = "Parsec Credits";
73     string public constant symbol = "PRSC";
74     uint8 public decimals = 6;
75     uint256 public initialSupply = 30856775800;
76     uint256 public totalSupply;
77 
78     // This creates an array with all balances
79     mapping (address => uint256) public balanceOf;
80     mapping (address => mapping (address => uint256)) public allowance;
81 
82     // This generates a public event on the blockchain that will notify clients
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     // This notifies clients about the amount burnt
86     event Burn(address indexed from, uint256 value);
87 
88     /**
89      * Constrctor function
90      *
91      * Initializes contract with initial supply tokens to the creator of the contract
92      */
93     function ParsecTokenERC20() public {
94         // Update total supply with the decimal amount
95         totalSupply = initialSupply * 10 ** uint256(decimals);
96 
97         // Give the creator all initial tokens
98         balanceOf[msg.sender] = totalSupply;
99     }
100 
101     /**
102      * Internal transfer, only can be called by this contract
103      */
104     function _transfer(address _from, address _to, uint _value) internal {
105         // Prevent transfer to 0x0 address. Use burn() instead
106         require(_to != 0x0);
107 
108         // Check if the sender has enough
109         require(balanceOf[_from] >= _value);
110 
111         // Check for overflows
112         require(balanceOf[_to] + _value > balanceOf[_to]);
113 
114         // Save this for an assertion in the future
115         uint previousBalances = balanceOf[_from] + balanceOf[_to];
116 
117         // Subtract from the sender
118         balanceOf[_from] -= _value;
119 
120         // Add the same to the recipient
121         balanceOf[_to] += _value;
122         Transfer(_from, _to, _value);
123 
124         // Asserts are used to use static analysis to find bugs in your code. They should never fail
125         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
126     }
127 
128     /**
129      * Transfer tokens
130      *
131      * Send `_value` tokens to `_to` from your account
132      *
133      * @param _to The address of the recipient
134      * @param _value the amount to send
135      */
136     function transfer(address _to, uint256 _value) public {
137         _transfer(msg.sender, _to, _value);
138     }
139 
140     /**
141      * Transfer tokens from other address
142      *
143      * Send `_value` tokens to `_to` in behalf of `_from`
144      *
145      * @param _from The address of the sender
146      * @param _to The address of the recipient
147      * @param _value the amount to send
148      */
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
150         // Check allowance
151         require(_value <= allowance[_from][msg.sender]);
152 
153         allowance[_from][msg.sender] -= _value;
154         _transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address
160      *
161      * Allows `_spender` to spend no more than `_value` tokens in your behalf
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      */
166     function approve(address _spender, uint256 _value) public returns (bool success) {
167         allowance[msg.sender][_spender] = _value;
168         return true;
169     }
170 
171     /**
172      * Set allowance for other address and notify
173      *
174      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
175      *
176      * @param _spender The address authorized to spend
177      * @param _value the max amount they can spend
178      * @param _extraData some extra information to send to the approved contract
179      */
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
181         tokenRecipient spender = tokenRecipient(_spender);
182 
183         if (approve(_spender, _value)) {
184             spender.receiveApproval(msg.sender, _value, this, _extraData);
185             return true;
186         }
187     }
188 
189     /**
190      * Destroy tokens
191      *
192      * Remove `_value` tokens from the system irreversibly
193      *
194      * @param _value the amount of money to burn
195      */
196     function burn(uint256 _value) public returns (bool success) {
197         // Check if the sender has enough
198         require(balanceOf[msg.sender] >= _value);
199 
200         // Subtract from the sender
201         balanceOf[msg.sender] -= _value;
202 
203         // Updates totalSupply
204         totalSupply -= _value;
205 
206         // Notify clients about burned tokens
207         Burn(msg.sender, _value);
208 
209         return true;
210     }
211 
212     /**
213      * Destroy tokens from other account
214      *
215      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216      *
217      * @param _from the address of the sender
218      * @param _value the amount of money to burn
219      */
220     function burnFrom(address _from, uint256 _value) public returns (bool success) {
221         // Check if the targeted balance is enough
222         require(balanceOf[_from] >= _value);
223 
224         // Check allowance
225         require(_value <= allowance[_from][msg.sender]);
226 
227         // Subtract from the targeted balance
228         balanceOf[_from] -= _value;
229 
230         // Subtract from the sender's allowance
231         allowance[_from][msg.sender] -= _value;
232 
233         // Update totalSupply
234         totalSupply -= _value;
235 
236         // Notify clients about burned tokens
237         Burn(_from, _value);
238 
239         return true;
240     }
241 }
242 
243 
244 contract ParsecPresale is owned {
245     // Use OpenZeppelin's SafeMath
246     using SafeMath for uint256;
247 
248     // Minimum and maximum goals of the presale
249     uint256 public constant PRESALE_MINIMUM_FUNDING =  287.348 ether;
250     uint256 public constant PRESALE_MAXIMUM_FUNDING = 1887.348 ether;
251 
252     // Minimum amount per transaction for public participants
253     uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 0.5 ether;
254 
255     // Public presale period
256     uint256 public constant PRESALE_START_DATE = 1516795200;            // 2018-01-24 12:00:00 UTC
257     uint256 public constant PRESALE_END_DATE = 1517400000;              // 2018-01-31 12:00:00 UTC
258 
259     // Second and third day of pre-sale timestamps
260     uint256 public constant PRESALE_SECOND_DAY_START = 1516881600;      // 2018-01-25 12:00:00 UTC
261     uint256 public constant PRESALE_THIRD_DAY_START = 1516968000;       // 2018-01-26 12:00:00 UTC
262 
263     // Owner can clawback after a date in the future, so no ethers remain trapped in the contract.
264     // This will only be relevant if the minimum funding level is not reached
265     uint256 public constant OWNER_CLAWBACK_DATE = 1519128000;           // 2018-02-20 12:00:00 UTC
266 
267     // Pledgers can withdraw their Parsec credits after a date in the future.
268     // This will only be relevant if the minimum funding level is reached
269     uint256 public constant TOKEN_WITHDRAWAL_START_DATE = 1525176000;   // 2018-05-01 12:00:00 UTC
270     uint256 public constant TOKEN_WITHDRAWAL_END_DATE = 1527854400;     // 2018-06-01 12:00:00 UTC
271 
272     // Minimal amount of Parsec credits to be avaibale on this contract balance
273     // in order to grant credits for all possible participant contributions
274     uint256 public constant PARSEC_CREDITS_MINIMAL_AMOUNT = 3549000000000000;   // 3549000000.000000 PRSC
275 
276     // Amount of Parsec credits to be granted per ether
277     uint256 public constant PARSEC_CREDITS_PER_ETHER = 1690000000000;           // 1690000.000000 PRSC
278 
279     // It amount of transfer is greater or equal to this threshold,
280     // additional bonus Parsec credits will be granted
281     uint256 public constant BONUS_THRESHOLD = 50 ether;
282 
283     // Keep track of total funding amount
284     uint256 public totalFunding;
285 
286     // Keep track of total whitelisted funding amount
287     uint256 public totalWhitelistedFunding;
288 
289     // Keep track of granted Parsec credits amount
290     uint256 public grantedParsecCredits;
291 
292     // Keep track of spent Parsec credits amount
293     uint256 public spentParsecCredits;
294 
295     // Keep track if unspent Parsec credits were withdrawn
296     bool public unspentCreditsWithdrawn = false;
297 
298     // Keep track if unclaimed Parsec credits were withdrawn
299     bool public unclaimedCreditsWithdrawn = false;
300 
301     // Keep track if unclaimed Parsec credits were clawbacked
302     bool public creditsClawbacked = false;
303 
304     // Keep track if contract balance has enough Parsec tokens
305     bool public contractPoweredUp = false;
306 
307     // Keep track if chunk 1 us already added to white list
308     bool public chunk1IsAdded = false;
309 
310     // Keep track if chunk 2 us already added to white list
311     bool public chunk2IsAdded = false;
312 
313     // Keep track if chunk 3 us already added to white list
314     bool public chunk3IsAdded = false;
315 
316     // Keep track if chunk 4 us already added to white list
317     bool public chunk4IsAdded = false;
318 
319     // Keep track if chunk 5 us already added to white list
320     bool public chunk5IsAdded = false;
321 
322     // Keep track if chunk 6 us already added to white list
323     bool public chunk6IsAdded = false;
324 
325     /// @notice Keep track of all participants contributions, including both the
326     ///         preallocation and public phases
327     /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
328     ///      this and show the balances of the address
329     mapping (address => uint256) public balanceOf;
330 
331     /// @notice Keep track of Parsec credits to be granted to participants.
332     mapping (address => uint256) public creditBalanceOf;
333 
334     /// @notice Define whitelisted addresses and sums for the first 2 days of pre-sale.
335     mapping (address => uint256) public whitelist;
336 
337     /// @notice Log an event for each funding contributed during the public phase
338     /// @notice Events are not logged when the constructor is being executed during
339     ///         deployment, so the preallocations will not be logged
340     event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
341 
342     // Parsec ERC20 token contract (from previously deployed address)
343     ParsecTokenERC20 private parsecToken;
344 
345     function ParsecPresale (address tokenAddress) public {
346         // Get Parsec ERC20 token instance
347         parsecToken = ParsecTokenERC20(tokenAddress);
348     }
349 
350     /// @notice A participant sends a contribution to the contract's address
351     ///         between the PRESALE_START_DATE and the PRESALE_END_DATE
352     /// @notice Only contributions above the MINIMUM_PARTICIPATION_AMOUNT are accepted.
353     ///         Otherwise the transaction is rejected and contributed amount is returned
354     ///         to the participant's account
355     /// @notice A participant's contribution will be rejected if the presale
356     ///         has been funded to the maximum amount
357     function () public payable {
358         // Contract should be powered up
359         require(contractPoweredUp);
360 
361         // A participant cannot send funds before the presale start date
362         require(now >= PRESALE_START_DATE);
363 
364         // A participant cannot send funds after the presale end date
365         require(now < PRESALE_END_DATE);
366 
367         // A participant cannot send less than the minimum amount
368         require(msg.value >= MINIMUM_PARTICIPATION_AMOUNT);
369 
370         // Contract logic for transfers relies on current date and time.
371         if (now >= PRESALE_START_DATE && now < PRESALE_SECOND_DAY_START) {
372             // Trasfer logic for the 1st day of pre-sale.
373             // Allow to transfer exact whitelisted sum for whitelisted addresses.
374             require(whitelist[msg.sender] == msg.value);
375             require(balanceOf[msg.sender] == 0);
376         } else if (now >= PRESALE_SECOND_DAY_START && now < PRESALE_THIRD_DAY_START) {
377             // Trasfer logic for the 2nd day of pre-sale.
378             // Allow to transfer any sum within contract max cap for whitelisted addresses.
379             require(whitelist[msg.sender] != 0);
380         }
381 
382         // A participant cannot send funds if the presale has been reached the maximum funding amount
383         require(totalFunding.add(msg.value) <= PRESALE_MAXIMUM_FUNDING);
384 
385         // Register the participant's contribution
386         addBalance(msg.sender, msg.value);
387 
388         // Grant Parsec credits according to participant's contribution
389         grantCreditsForParticipation(msg.sender, msg.value);
390     }
391 
392     /// @notice Add chunk 1 / 7 to the whitelist
393     function addChunk1ToWhiteList() external onlyOwner {
394         // Chunk should not be added previously
395         require(!chunk1IsAdded);
396 
397         // Add whitelisted amounts
398         addToWhitelist(0x2C66aDd04950eE3235fd3EC6BcB2577c88d804E4, 0.5 ether);
399         addToWhitelist(0x008e2E5FC70a2bccB5857AE8591119B3B63fdbc2, 0.5 ether);
400         addToWhitelist(0x0330cc41bDd33f820d92C2df591CD2A5cB99f792, 0.5 ether);
401         addToWhitelist(0x0756ea3a926399c3da2d5bfc520b711bdadfd0b9, 0.5 ether);
402         addToWhitelist(0x08c93a267832a8997a46f13b12faa2821d16a472, 0.5 ether);
403         addToWhitelist(0x0B58dAeAB6D292B5B8A836643023F43E4D0d9b78, 0.5 ether);
404         addToWhitelist(0x0b73f53885581caf26141b4bb5f8c192af611921, 0.5 ether);
405         addToWhitelist(0x0be30C8338C76Cc3EF92734863B0A898d8C8fef4, 0.5 ether);
406         addToWhitelist(0x0fb6829D5543F173d6bba244c2E21CB60544B7fA, 0.5 ether);
407         addToWhitelist(0x0fccb03ceb56e683fbcf0229c950d666def66d1d, 0.5 ether);
408         addToWhitelist(0x1578416c880a0F282bAc17c692b2A80b4336D29B, 0.5 ether);
409         addToWhitelist(0x16fc89d92592b88bc459e19717eEDD51732CfCA1, 0.5 ether);
410         addToWhitelist(0x183feBd8828a9ac6c70C0e27FbF441b93004fC05, 0.5 ether);
411         addToWhitelist(0x1A9D4a4DBb3Fb0750107406f4A7c9379DB42f7B3, 0.5 ether);
412         addToWhitelist(0x1bB95a9c7d50B9b270a604674f4Ed35265087c40, 0.5 ether);
413         addToWhitelist(0x1bf032d01bab6cd4a2d67ec251f5c3f09728a7e3, 0.5 ether);
414         addToWhitelist(0x1C1f687165F982Fcd4672B4319AB966256B57b2e, 0.5 ether);
415         addToWhitelist(0x1E2B069ca94e0232A04A4D1317e120f903D41c3A, 0.5 ether);
416         addToWhitelist(0x21F23Bb7299Caa26D854DDC38E134E49997471Dd, 0.5 ether);
417         addToWhitelist(0x23437833ebf735cdaf526c2a2c24f57ca4726358, 0.5 ether);
418         addToWhitelist(0x2389Ce4eFB2805Fd047C59Fa8991EA9c8361A9a0, 0.5 ether);
419         addToWhitelist(0x248dd8D2b7991d94860c44A5F99fc1483964FBBf, 0.5 ether);
420         addToWhitelist(0x257D66c42623c108060a66e4ddE5c3813691Ef38, 0.5 ether);
421         addToWhitelist(0x26D6F116a16efD1f8361c5Da90AEA4B26b564004, 0.5 ether);
422         addToWhitelist(0x272899d5b1451B09De35161B11722C95E34f06A9, 0.5 ether);
423         addToWhitelist(0x29F436906826a7d7Ef0B35292b4f285050108082, 0.5 ether);
424         addToWhitelist(0x2A8Be3303C83e5E9699a8b4B70976577BFedeC71, 0.5 ether);
425         addToWhitelist(0x2C351d47CE2737982D1E25FB6dfa30265913aEAa, 0.5 ether);
426         addToWhitelist(0x3cf2fC2cc45EACf1B6495Bf2AA69fbFC0d4b4a30, 0.5 ether);
427         addToWhitelist(0x3Cf5f48Dd9bec4Eff46Ee1E2B9e64b2892B5E64F, 0.5 ether);
428         addToWhitelist(0x3D86C8A928E9595114e01bb0539bdD69e9EfDF3B, 0.5 ether);
429         addToWhitelist(0x3e825763457fd92a6cb46f5ee0b4969089997da8, 0.5 ether);
430         addToWhitelist(0x3F4351eb6b1dd9a84890C1C89F4D4419Eb88f1Af, 0.5 ether);
431         addToWhitelist(0x459cc576ac8332f52ee93cb88228416a872bebd6, 0.5 ether);
432         addToWhitelist(0x45c556aff90d5fe6e91d24874a8036693cec18d0, 0.5 ether);
433         addToWhitelist(0x47449fa838794e665A648FA3e47208a7cd105c9D, 0.5 ether);
434         addToWhitelist(0x50405fB11735160056DBc40b92a09B4215501481, 0.5 ether);
435         addToWhitelist(0x51DD5Ef09cF73312BADe4C6BA8e03d647730Ecc3, 0.5 ether);
436         addToWhitelist(0x546A4F1eD47e853Ba119f55A20CbFeaa40ab70E6, 0.5 ether);
437         addToWhitelist(0x549022ad5cd11816eb7ce6ea15ae61c1fb4edb8a, 0.5 ether);
438         addToWhitelist(0x5abDC3cB826fC0277D642c9FB52FA76FE3ABb4E7, 0.5 ether);
439         addToWhitelist(0x5b65dfa08283e024c4ad09b5ea7212c539cb9dbf, 0.5 ether);
440         addToWhitelist(0x5cC69E09cA05004e5aDCdbE8C8Aac4D16A4651ed, 0.5 ether);
441         addToWhitelist(0x60a5550D1e43b63b3164F78F2D186bDb7D393C90, 0.5 ether);
442         addToWhitelist(0x6111d340C833661840ec4c11e84a79a67bE8acCD, 0.5 ether);
443         addToWhitelist(0x61E140a78Ec39d373C182bf3eD23cBc1AC86023b, 0.5 ether);
444         addToWhitelist(0x62f12F6C3AD04DFACB10ae05fB54f1E997b0133e, 0.5 ether);
445         addToWhitelist(0x65276d60Ab36879a6BD88F040D350cd60630FD03, 0.5 ether);
446         addToWhitelist(0x66B993F856d6175D11B98Be2cBc79EB1888B72f7, 0.5 ether);
447         addToWhitelist(0x6806408fd066ccddceaecc0a6c6fbbdb2ae8259c, 0.5 ether);
448         addToWhitelist(0x6918a5b07c2f79a4b272bb7653a43438ca96cd3f, 0.5 ether);
449         addToWhitelist(0x697DE67DB7d462480418814831d52DA25917A12E, 0.5 ether);
450 
451         // Set chunk added flag
452         chunk1IsAdded = true;
453     }
454 
455     /// @notice Add chunk 2 / 7 to the whitelist
456     function addChunk2ToWhiteList() external onlyOwner {
457         // Chunk should not be added previously
458         require(!chunk2IsAdded);
459 
460         // Add whitelisted amounts
461         addToWhitelist(0x6A35d29D8F63E4D8A8E5418Be9342A48c4C8eF07, 0.5 ether);
462         addToWhitelist(0x6b2a80FB3C8Eca5144E6F129a447b9D06224a402, 0.5 ether);
463         addToWhitelist(0x6b8ebca41389689e8875af541a2fa4328ac49917, 0.5 ether);
464         addToWhitelist(0x6c3Db34C768Ab1E67E2a7E973B7a83651657660b, 0.5 ether);
465         addToWhitelist(0x7018564dCe2c68417DFa7678541DfA0040Ca0c54, 0.5 ether);
466         addToWhitelist(0x708faa43f5824d271466c119148728467f66e233, 0.5 ether);
467         addToWhitelist(0x71526410C961727a89155D6a32Bb75f9a9d755F5, 0.5 ether);
468         addToWhitelist(0x746B426D0B8e272Ef7402db7CE0FD01C2B1c4aDE, 0.5 ether);
469         addToWhitelist(0x762C73603f5456c4ad729b3B46464269bcD7C212, 0.5 ether);
470         addToWhitelist(0x7a0D19955bBf6cff0D86F6e72355A8AFf3c0d74F, 0.5 ether);
471         addToWhitelist(0x7Cf017bDe8af2DfC67cb3f1b16943A0620eA1B54, 0.5 ether);
472         addToWhitelist(0x807bAf9e22F4e1E7A5Fcf4B5721ba54666d71421, 0.5 ether);
473         addToWhitelist(0x810f1C65f9C7c566E14a1E8ECA7b36b78C6da3A8, 0.5 ether);
474         addToWhitelist(0x871a314d75BdF106420B9e08314e776d2746E0Eb, 0.5 ether);
475         addToWhitelist(0x88Cf04474CFD3b9Bc4110FfC2980Bc56feBF0465, 0.5 ether);
476         addToWhitelist(0x8914316B6505b39e706a208A8E91ab8F79eFA7Cf, 0.5 ether);
477         addToWhitelist(0x8b104344F397aFC33Ee55C743a0FbD7d956201cD, 0.5 ether);
478         addToWhitelist(0x8Bd5306d0c08Eaa2D9AabaED62297A8AB42db1de, 0.5 ether);
479         addToWhitelist(0x8Be1843532E5eE0142420fe627a097a0E0681e97, 0.5 ether);
480         addToWhitelist(0x8c269040283c4112198bc59120ad2bcd70e6b387, 0.5 ether);
481         addToWhitelist(0x8E14437E18B1091B369c6ff6ecCa73D648aCA3bd, 0.5 ether);
482         addToWhitelist(0x8Fc9040b8B9305458716e90F83D9b656a07ae7e6, 0.5 ether);
483         addToWhitelist(0x906d9e4D0E028FE85625d06268A437Bb58753301, 0.5 ether);
484         addToWhitelist(0x91Fe65df20b13CA260990e096d4EBDbD64f7b399, 0.5 ether);
485         addToWhitelist(0x92cBbf4A87953975c39EaA2bF70deDEbC356358b, 0.5 ether);
486         addToWhitelist(0x95D4914d4f08732A169367674A8BE026c02c5B44, 0.5 ether);
487         addToWhitelist(0x985116bBCcEE828d439c4F6F9233016bf1e95669, 0.5 ether);
488         addToWhitelist(0x9976cF5617F5E4022CdC887A7A0a68E8eE5dBA22, 0.5 ether);
489         addToWhitelist(0x9A7379c8aF6765aa267d338A20D197DD1544bF9b, 0.5 ether);
490         addToWhitelist(0x9DEFB6A85680E11b6aD8AD4095e51464bB4C0C66, 0.5 ether);
491         addToWhitelist(0xA02896e448A35DeD03C48c2986A545779ed87edd, 0.5 ether);
492         addToWhitelist(0xa460A24F606d4ABba5041B162E06D42aD6f09157, 0.5 ether);
493         addToWhitelist(0xaB91cF12f8e133C7B1C849d87997dca895cE0BCB, 0.5 ether);
494         addToWhitelist(0xac935E0dD7F90851E0c6EE641cd30B800e35f7A8, 0.5 ether);
495         addToWhitelist(0xae41F73635b6F5F9556Cd3B0d3970aDA5Fb0C1b5, 0.5 ether);
496         addToWhitelist(0xB16fE19652ceDf4Ba2568b4886CeE29D4e0617B0, 0.5 ether);
497         addToWhitelist(0xB2F19E5457404dCaCd2d6344592e5a657DFcA27b, 0.5 ether);
498         addToWhitelist(0xB33cc3147d70Ce2aF31B2B90411BD6333EeA0EA7, 0.5 ether);
499         addToWhitelist(0xb49a6DD81a847f3A704D0C11C6e1a7C65C47d215, 0.5 ether);
500         addToWhitelist(0xb75312cdfBee6B6104a7161E27dbd48bb253E186, 0.5 ether);
501         addToWhitelist(0xB87e73ad25086C43a16fE5f9589Ff265F8A3A9Eb, 0.5 ether);
502         addToWhitelist(0xc12549d486e20835960Fb3A44ba67fD353B1C48a, 0.5 ether);
503         addToWhitelist(0xc4Eab1eAaCbf628F0f9Aee4B7375bDE18dd173C4, 0.5 ether);
504         addToWhitelist(0xc8B15B3189b8C6e90ff330CBA190153fF0A9997e, 0.5 ether);
505         addToWhitelist(0xCb033bE278d7bD297a2b1Cc6201113480daC579F, 0.5 ether);
506         addToWhitelist(0xCb570fE877CA6B7dE030afaf9483f58F774df135, 0.5 ether);
507         addToWhitelist(0xcD4929fdDC83Aca93cD4a75bD12780DaDF51870b, 0.5 ether);
508         addToWhitelist(0xcdc22860Ff346ead18ECA5E30f0d302a95F33A19, 0.5 ether);
509         addToWhitelist(0xD26BA3C03fBC1EA352b5F77B2c1F2881d03D1e2F, 0.5 ether);
510         addToWhitelist(0xd454ED303748Bb5a433388F9508433ba5d507030, 0.5 ether);
511         addToWhitelist(0xd4d1197fed5F9f3679497Df3604147087B85Ce39, 0.5 ether);
512         addToWhitelist(0xd83F072142C802A6fA3921d6512B25a7c1A216b1, 0.5 ether);
513 
514         // Set chunk added flag
515         chunk2IsAdded = true;
516     }
517 
518     /// @notice Add chunk 3 / 7 to the whitelist
519     function addChunk3ToWhiteList() external onlyOwner {
520         // Chunk should not be added previously
521         require(!chunk3IsAdded);
522 
523         // Add whitelisted amounts
524         addToWhitelist(0xd9b4cb7bf6a04f545c4c0e32d4570f16cbb3be56, 0.5 ether);
525         addToWhitelist(0xDCfe2F26c4c47741851e0201a91FB3b8b6452C81, 0.5 ether);
526         addToWhitelist(0xDf1734032A21Fc9F59E6aCE263b65E4c2bE29861, 0.5 ether);
527         addToWhitelist(0xDFEa4bE32b1f777d82a6389a0d4F399569c46202, 0.5 ether);
528         addToWhitelist(0xE18C42Ecb41d125FB21C61B9A18857A361aFC645, 0.5 ether);
529         addToWhitelist(0xE3e29044291E4f2678c8C1859849a3126B95C2a4, 0.5 ether);
530         addToWhitelist(0xE4B55adb4eCe93f4F53B3a18561BA876dbA3A2cb, 0.5 ether);
531         addToWhitelist(0xe96D559283cE2AFC3C79981dA4717bFfFAE69777, 0.5 ether);
532         addToWhitelist(0xEA7F1b3e36eD60257D79a65d8BA2b305d31cEEE7, 0.5 ether);
533         addToWhitelist(0xeaf61945762fa3408bfe286da7ea64bd212abfbf, 0.5 ether);
534         addToWhitelist(0xeC7715afA5Fd2833693Bfc3521EF5197716A65b0, 0.5 ether);
535         addToWhitelist(0xee15AD84321176b2644d0894f28db22621c12b74, 0.5 ether);
536         addToWhitelist(0xF05538779A8Ab41741e73a9650CE9B9FE1F3DEc7, 0.5 ether);
537         addToWhitelist(0xF0c106d282648da9690Cd611F4654fF0e78DEf18, 0.5 ether);
538         addToWhitelist(0xF132D556c8d065264A36d239b11Ad4Ad3d9f8f6e, 0.5 ether);
539         addToWhitelist(0xAac34A6B597240B1fAEBaEbeD762F0ecbe02fe18, 0.5 ether);
540         addToWhitelist(0xaae16c984ca5245E6AC3c646c1Fb3A9695d2f412, 0.5 ether);
541         addToWhitelist(0xfc575d7064ad46804b28ddc4fce90860addaa256, 0.5 ether);
542         addToWhitelist(0x4df33f230b862941c92585078eb549a7747c47bd, 0.51 ether);
543         addToWhitelist(0xaaF1Df7c351c71aD1Df94DB11Ec87b65F5e72531, 0.51 ether);
544         addToWhitelist(0x5C3E4c34f8a12AFBF1b9d85dfc83953c310e4645, 0.6 ether);
545         addToWhitelist(0x6580B24104BCAf1ba4171d6bB3B2F1D31a96C549, 0.6 ether);
546         addToWhitelist(0x0F3B2d5e7C51700aC0986fCe669aB3c69601499a, 0.7 ether);
547         addToWhitelist(0x0b74911659bfc903d978ea57a70ea00fab893aa2, 0.75 ether);
548         addToWhitelist(0x45cAa6B0a1d9Db9227DC3D883e31132Ef08F1980, 0.75 ether);
549         addToWhitelist(0xAcC0F848404e484D6fEB8Bef3bc53DF1a80CB94A, 0.75 ether);
550         addToWhitelist(0x32c299f7df2e46549fd2dd73f540bf5e8c867d8a, 0.9 ether);
551         addToWhitelist(0x00aEc73b737Bf387c60094f993B8010f70C06d4e, 1 ether);
552         addToWhitelist(0x014b65Cf880129A5aC836bcb1C35305De529b59c, 1 ether);
553         addToWhitelist(0x03D74A8b469dDB568072923323B370d64E795b03, 1 ether);
554         addToWhitelist(0x04E436cC3fCF465e82932DBd1c7598808Ed07b79, 1 ether);
555         addToWhitelist(0x0545Cb34B8e136768dF9f889072a87FD83605480, 1 ether);
556         addToWhitelist(0x0d421e17ABF7509113f3EF03C357Bc2aeF575cb7, 1 ether);
557         addToWhitelist(0x0faF819dE159B151Dd20E304134a6c167B55D9C1, 1 ether);
558         addToWhitelist(0x123d31DA8fCbc11ab3B507c61086a7444305fd44, 1 ether);
559         addToWhitelist(0x16C96155328d9F22973502c2aB2CbEa06Fb3D1A4, 1 ether);
560         addToWhitelist(0x16D6ddeA3cb142773ca7aD4b12842e47B9835C69, 1 ether);
561         addToWhitelist(0x1C3DF26aAC85dC9bebB1E8C0a771705b38abF673, 1 ether);
562         addToWhitelist(0x1d664ddD7A985bED478c94b029444BB43A13ba07, 1 ether);
563         addToWhitelist(0x218A7E78a960B437c409222ED6b48C088C429949, 1 ether);
564         addToWhitelist(0x232f4ADd6ee2d479A9178ea184a83D43C1dca70f, 1 ether);
565         addToWhitelist(0x23D6Fa98877C713C00968D43d7E1fE2B14ce443F, 1 ether);
566         addToWhitelist(0x241A410828DA842CFB24512b91004ba6bF555D0a, 1 ether);
567         addToWhitelist(0x3472bdEca240fDFE3A701254bdD62a6c10B2f0e7, 1 ether);
568         addToWhitelist(0x36889c0Bc35F585062613B6dfa30365AdE826804, 1 ether);
569         addToWhitelist(0x3775eF0bB806098e4678D7758f6b16595c4D0618, 1 ether);
570         addToWhitelist(0x37c9909DFb1f13281Cc0109f5C4F4775a337df7c, 1 ether);
571         addToWhitelist(0x3831ee9f3be7ac81d6653d312adefedbf8ede843, 1 ether);
572         addToWhitelist(0x38c9606DAaD44fEB86144ab55107a3154DddCf5c, 1 ether);
573         addToWhitelist(0x400d654A92494958E630A928f9c2Cfc9a0A8e011, 1 ether);
574         addToWhitelist(0x42593b745B20f03d36137B6E417C222c1b0FE1a8, 1 ether);
575         addToWhitelist(0x435ca13E9814e0edd2d203E3e14AD9dbcBd19224, 1 ether);
576 
577         // Set chunk added flag
578         chunk3IsAdded = true;
579     }
580 
581     /// @notice Add chunk 4 / 7 to the whitelist
582     function addChunk4ToWhiteList() external onlyOwner {
583         // Chunk should not be added previously
584         require(!chunk4IsAdded);
585 
586         // Add whitelisted amounts
587         addToWhitelist(0x47169f78750Be1e6ec2DEb2974458ac4F8751714, 1 ether);
588         addToWhitelist(0x499114EF97E50c0F01EDD6558aD6203A9B295419, 1 ether);
589         addToWhitelist(0x49C11D994DC19C5Edb62F70DFa76c393941d5fFf, 1 ether);
590         addToWhitelist(0x4bCC31189527dCdFde2f4c887A59b0b0C5dBBB1c, 1 ether);
591         addToWhitelist(0x4E5Be470d1B97400ce5E141Da1372e06575383ee, 1 ether);
592         addToWhitelist(0x5203CDD1D0b8cDc6d7CF60228D0c7E7146642405, 1 ether);
593         addToWhitelist(0x554C033720EfDaD25e5d6400Bdea854bF9E709b6, 1 ether);
594         addToWhitelist(0x5700e809Ea5b49f80B6117335FB7f6B29E0E4529, 1 ether);
595         addToWhitelist(0x62f33168582712391f916b4d42f9d7433ed390ea, 1 ether);
596         addToWhitelist(0x62f4e10FA6f1bA0f2b8282973FF4fE2141F917D6, 1 ether);
597         addToWhitelist(0x635Dc49b059dB00BF0d2723645Fa68Ffc839a525, 1 ether);
598         addToWhitelist(0x6465dFa666c6bFDF3E9bd95b5EC1E502843eeEB7, 1 ether);
599         addToWhitelist(0x6E88904BA0A062C7c13772c1895900E1482deC8e, 1 ether);
600         addToWhitelist(0x70580eA14d98a53fd59376dC7e959F4a6129bB9b, 1 ether);
601         addToWhitelist(0x70EbC02aBc8922c34fA901Bd0931A94634e5B6b2, 1 ether);
602         addToWhitelist(0x71b492cd6695fd85b21af5ae9f818c53f3823046, 1 ether);
603         addToWhitelist(0x7b8a0D81e8A760D1BCC058250D77F79d4827Fd3c, 1 ether);
604         addToWhitelist(0x7ba67f190771Cf0C751F2c4e461f40180e8a595c, 1 ether);
605         addToWhitelist(0x7ce2C04EfC51EaA4Ca7e927a61D51F4dc9A19f41, 1 ether);
606         addToWhitelist(0x7E8658A0467e34c3ac955117FA3Ba9C18d25d22A, 1 ether);
607         addToWhitelist(0x7eedaC1991eE2A59B072Be8Dc6Be82CCE9031f91, 1 ether);
608         addToWhitelist(0x7aa1bb9e0e5439298ec71fb67dc1574f85fecbd1, 1 ether);
609         addToWhitelist(0x832aC483326472Da0c177EAAf437EA681fAb3ABe, 1 ether);
610         addToWhitelist(0x861739a2fe0D7d16544c4a295b374705aEEA004F, 1 ether);
611         addToWhitelist(0x898C86446CcE1B7629aC7f5B5fD8eA0F51a933b3, 1 ether);
612         addToWhitelist(0x8b2F96cEc0849C6226cf5cFAF32044c12B16eeD9, 1 ether);
613         addToWhitelist(0x8fF73A67b4406341AfBc4b37c9f595a77Aa062A2, 1 ether);
614         addToWhitelist(0x964b513c0F30E28B93081195231305a2D92C7762, 1 ether);
615         addToWhitelist(0x96BC6015ff529eC3a3d0B5e1B7164935Df2bF2fd, 1 ether);
616         addToWhitelist(0x96BF1A8660C8D74603b3c4f429f6eC53AD32b0B0, 1 ether);
617         addToWhitelist(0x9840a6b89C53DDB6D6ef57240C6FC972cC97731A, 1 ether);
618         addToWhitelist(0xA8625D251046abd3F2858D0163A827368a068bac, 1 ether);
619         addToWhitelist(0xa93e77C28fB6A77518e5C3E61348Aec81E5004fD, 1 ether);
620         addToWhitelist(0xaEafb182b64FD2CC3866766BA72B030F9AcE69f0, 1 ether);
621         addToWhitelist(0xB3eA2C6feDb15CDC5228dd0B8606592d712c53e1, 1 ether);
622         addToWhitelist(0xBde128e0b3EA8E4a6399401A671ce9731282C4C2, 1 ether);
623         addToWhitelist(0xC3dA85745022fC89CdC774e1FE95ABC4F141292f, 1 ether);
624         addToWhitelist(0xC62c61Bbcd61A4817b95dA22339A4c856EC4A3F9, 1 ether);
625         addToWhitelist(0xcE13de0cBd0D7Bde1d2444e2d513868177D2B15F, 1 ether);
626         addToWhitelist(0xd45546Cbc3C4dE75CC2B1f324d621A7753f25bB3, 1 ether);
627         addToWhitelist(0xDAF8247Ebcd4BB033D0B82947c3c64a3E5089444, 1 ether);
628         addToWhitelist(0xEF2F95dbEEd23a04DD674898eaB10cA4C883d780, 1 ether);
629         addToWhitelist(0xDe3b6c96f7E6c002c1018b77f93b07956C6fB3e8, 1 ether);
630         addToWhitelist(0xe415638FC30b277EC7F466E746ABf2d406f821FF, 1 ether);
631         addToWhitelist(0xE4A12D142b218ed96C75AA8D43aa153dc774F403, 1 ether);
632         addToWhitelist(0xEEBEA0A8303aAc18D2cABaca1033f04c4a43E358, 1 ether);
633         addToWhitelist(0xf12059ad0EB7D393E41AC3b3250FB5E446AA8dFB, 1 ether);
634         addToWhitelist(0xF94EfB6049B7bca00cE8e211C9A3f5Ca7ff4800b, 1 ether);
635         addToWhitelist(0xFBCe0CBB70bD0Bf43B11f721Beaf941980C5fF4a, 1 ether);
636         addToWhitelist(0x573648f395c26f453bf06Fd046a110A016274710, 1.2 ether);
637         addToWhitelist(0x95159e796569A9A7866F9A6CF0E36B8D6ddE9c02, 1.2 ether);
638         addToWhitelist(0xEafF321951F891EBD791eF57Dc583A859626E295, 1.2 ether);
639 
640         // Set chunk added flag
641         chunk4IsAdded = true;
642     }
643 
644     /// @notice Add chunk 5 / 7 to the whitelist
645     function addChunk5ToWhiteList() external onlyOwner {
646         // Chunk should not be added previously
647         require(!chunk5IsAdded);
648 
649         // Add whitelisted amounts
650         addToWhitelist(0x439f5420d4eD1DE8c982100Fcf808C5FcEeC1bFa, 1.25 ether);
651         addToWhitelist(0xfd5D41Dad5218C312d693a8b6b1128889cFFec43, 1.25 ether);
652         addToWhitelist(0x1FBB99bf7E6e8920Fac8Ab371cEB5A90e0801656, 1.5 ether);
653         addToWhitelist(0x6d767fE3e87b6Ffb762cd46138aaaB48a6788d06, 1.5 ether);
654         addToWhitelist(0x9C299486fc9b5B1bA1dbE2d6D93E3580f9A64995, 1.5 ether);
655         addToWhitelist(0x009e511c89e033142bdd1f34f7cad0f3e188696d, 2 ether);
656         addToWhitelist(0x25929fF98a1e8D7d1c14674bD883A24C26FB1df4, 2 ether);
657         addToWhitelist(0x2a54850a5166d2fCC805B78A1D436b96e4477e09, 2 ether);
658         addToWhitelist(0x3D212E369e08fB9D5585a35449595df044cdD7a4, 2 ether);
659         addToWhitelist(0x417EcaE932D3bAE2d93a2af6dA91441d46532A7C, 2 ether);
660         addToWhitelist(0x53070A3A5faF50280563ea4fB4b5e6AcA53B7221, 2 ether);
661         addToWhitelist(0x67314b5CdFD52A1D5c4794C02C5b3b2cc4bdc21B, 2 ether);
662         addToWhitelist(0x67fb2006dd8990de950d1eb41f07ff7f929c3bca, 2 ether);
663         addToWhitelist(0x76b3a5aad6aD161680F9e7C9dd09bA9626135765, 2 ether);
664         addToWhitelist(0x77446d3Df1216B1e8Ea1913203B05F5cb182B112, 2 ether);
665         addToWhitelist(0x788b7433ddf168544b2adae3c6aa416d3f6fa112, 2 ether);
666         addToWhitelist(0x790310b3f668019056a8b811ced6e2a0af533660, 2 ether);
667         addToWhitelist(0x7dD1b95E76F7893002E4FB9a533628994b703479, 2 ether);
668         addToWhitelist(0x821578e6212651CAa996184404787ccC09C71014, 2 ether);
669         addToWhitelist(0x8b91B39Ef4ae08bEacC128d3C2e19140AbD0245F, 2 ether);
670         addToWhitelist(0x8f566cdE6724DEA78756B8C252055e6eA7D3d7a4, 2 ether);
671         addToWhitelist(0x90f7f982c2Ab40534e5E3bE449967B716ef04BB1, 2 ether);
672         addToWhitelist(0x91FDae97a5a3Ba806fA3Eb8B3cd3F0bEE6431b77, 2 ether);
673         addToWhitelist(0x99cf8060BaFca88C04Aa2Eace46CA880bE75F166, 2 ether);
674         addToWhitelist(0xa099638b5CFE746C0B3DD1a3998051c2Ac1F3dC8, 2 ether);
675         addToWhitelist(0xb9a2ACF30FB774881371F249928Cb48Ccc184bAC, 2 ether);
676         addToWhitelist(0xC301Fc1acCF9ab89Fa68Fd240dCDaa0Bd9a3658F, 2 ether);
677         addToWhitelist(0xc4f5bFad8Ec83Bcd4AB3b3a27266f08b4517f59B, 2 ether);
678         addToWhitelist(0xd1EA23d6713ca22cc1f2e10dc6FD8B1DfB65b563, 2 ether);
679         addToWhitelist(0xd4F2ad288874653F09e3Cc522C1106692E30394C, 2 ether);
680         addToWhitelist(0xddF81dabe498118df262b1b907492b391211321e, 2 ether);
681         addToWhitelist(0xE4fBc54c0a08a5d0CD1EEBC8bf0Ea48fdBFd7E0c, 2 ether);
682         addToWhitelist(0xf42F3c005B1723782FC25E5771748a6A1fff5e03, 2 ether);
683         addToWhitelist(0xff7ef21aC94961a3C9F71a3deFFfe2f58e102E1f, 2 ether);
684         addToWhitelist(0xa27A60769B426b1eEA3be951DF29D352B48ec5Da, 2.5 ether);
685         addToWhitelist(0xba334469f45f8e0ca1d61fa036fece3b4d5ec0f7, 2.5 ether);
686         addToWhitelist(0xdE47f3C16cDb757027F61D07a44c881d2D32B161, 2.5 ether);
687         addToWhitelist(0xfCD47A33207eD5a03390330Fd6EcFF2DFf8F5a2b, 2.5 ether);
688         addToWhitelist(0x27fcA80168B7eDC487B22F0F334BA922d1e26E2D, 3 ether);
689         addToWhitelist(0x36bd14eaf211d65164e1e0a2eab5c98b4b734875, 3 ether);
690         addToWhitelist(0x3D1a96c1fE8D1281537c5A8C93A89215DF254d3f, 3 ether);
691         addToWhitelist(0x40ED9F03BFfFA1cB30E36910907cd55ac27Be05d, 3 ether);
692         addToWhitelist(0x5Da227c19913F4deEB64A6E7fE41B30B230161D2, 3 ether);
693         addToWhitelist(0x7e443aA16aC53419CFd8056Bcc30b674864Ac55F, 3 ether);
694         addToWhitelist(0x80F30bAc95966922f1E8c66c0fD088959a00f15f, 3 ether);
695         addToWhitelist(0x8862004b5a7C21B8F771AF3213b79bD9b81f9DA0, 3 ether);
696         addToWhitelist(0x904063eF93eEEd9584f6B0131F9FD047d7c3C28d, 3 ether);
697         addToWhitelist(0xa14aC1A9B3D52aBD0652C5Aca346099A6eb16b54, 3 ether);
698         addToWhitelist(0xA2Ef14F0d1ae84609Cd104feB91EAeD4B39C4852, 3 ether);
699         addToWhitelist(0xA4D1905ceF480Fb9089578F88D3C128cf386ebd5, 3 ether);
700         addToWhitelist(0xa5D5404864E9eA3104ec6721CA08E563964Ae536, 3 ether);
701         addToWhitelist(0xB3ADF1FB9c488DBB42378876ff4Fc2be4c1B4365, 3 ether);
702 
703         // Set chunk added flag
704         chunk5IsAdded = true;
705     }
706 
707     /// @notice Add chunk 6 / 7 to the whitelist
708     function addChunk6ToWhiteList() external onlyOwner {
709         // Chunk should not be added previously
710         require(!chunk6IsAdded);
711 
712         // Add whitelisted amounts
713         addToWhitelist(0xC9403834046d64AAc2F98BA9CD29A84D48DBF58D, 3 ether);
714         addToWhitelist(0xd0f9899ec83BF1cf915bf101D6E7949361151523, 3 ether);
715         addToWhitelist(0xeB386a17ED99148dc98F07D0714751786836F68e, 3 ether);
716         addToWhitelist(0xeFc85EbccE16Db424fCEfBfA4a523fC9957C0E63, 3 ether);
717         addToWhitelist(0xfa52B6F191F57284762617Cfdbbf187E10C02D93, 3 ether);
718         addToWhitelist(0xfd0928783dd997D982AeeE5399f9B6816FbF789B, 3 ether);
719         addToWhitelist(0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD, 3 ether);
720         addToWhitelist(0xe9Cc01e48F027a0BFa97aFDa0229F09EDD9a590b, 3.7 ether);
721         addToWhitelist(0x4f7c845e4d09c3453bcfe03dd09cc96b5c6941a3, 4 ether);
722         addToWhitelist(0x0d41F957181E584dB82d2E316837B2DE1738C477, 5 ether);
723         addToWhitelist(0x102A65de4c20BCe35Aa9B6ae2eA2ecf60c91831B, 5 ether);
724         addToWhitelist(0x1Cff36DeBD53EEB3264fD75497356132C4067632, 5 ether);
725         addToWhitelist(0x21a39c71cb9544336e24d57df3655f30be99cf3b, 5 ether);
726         addToWhitelist(0x221CDC565782c03fe4ca913f1392741b67d48a81, 5 ether);
727         addToWhitelist(0x280cbA9bB3bd5E222B75fd9D5ff0D3Ec43F0D087, 5 ether);
728         addToWhitelist(0x2Fc0F28ee6C0172bD7D4DDbf791Fd520B29b10a1, 5 ether);
729         addToWhitelist(0x3243d70ed16410F55f22684a8768e7492E91108b, 5 ether);
730         addToWhitelist(0x44b38befe7a68fdbd50963feaa06566980a92f7e, 5 ether);
731         addToWhitelist(0x4AA75e261b28884718c49DA3f671b3C32a467faD, 5 ether);
732         addToWhitelist(0x522e98867715dA9e1fD87A7e759081cCE8ae61d6, 5 ether);
733         addToWhitelist(0x54e0766871b94d02f148b21a15d7ae4679f19c39, 5 ether);
734         addToWhitelist(0x61cf029E58713260aCDAd6e46a54BA687A465064, 5 ether);
735         addToWhitelist(0x6A4234773DC2c3cb4d2951aAa50107E9454451C1, 5 ether);
736         addToWhitelist(0x6beb418fc6e1958204ac8baddcf109b8e9694966, 5 ether);
737         addToWhitelist(0x90c0E8849266AE128aA355B46D090802DCfB1a25, 5 ether);
738         addToWhitelist(0x9b2c4a09ee37105d7ee139b83ca281ab20f6ca78, 5 ether);
739         addToWhitelist(0x9E4a9f2b4eFd85972cF952d2f5Fb16C291ED43B3, 5 ether);
740         addToWhitelist(0xafa2a0cd8ed977c2515b266c3bcc6fe1096c573d, 5 ether);
741         addToWhitelist(0xC1A065a2d29995692735c82d228B63Df1732030E, 5 ether);
742         addToWhitelist(0xD069A2c75999B87671a29c61B25848ee288a9d75, 5 ether);
743         addToWhitelist(0xd10f3f908611eca959f43667975f9e917435a449, 5 ether);
744         addToWhitelist(0xd4e470fad0d7195699cA9B713fD7C5196cb61Fec, 5 ether);
745         addToWhitelist(0xC32e75369bFcef12195741954687e211B3Bc807A, 6 ether);
746         addToWhitelist(0xe6fabdca7cb022434a61839268a7d9c10baf5eb2, 6 ether);
747         addToWhitelist(0xe26b11577372aa5e9c10407fe8f7cce6cb88aba0, 7 ether);
748         addToWhitelist(0x0edc326b97F071C1a5393Ba5344bb762DEE0C53a, 10 ether);
749         addToWhitelist(0x2A3F7E5170Ea8Ca967f85f091eF84591f639E031, 10 ether);
750         addToWhitelist(0x32f3474D1eB6aA38A85a7bb4fB85715A216A2640, 10 ether);
751         addToWhitelist(0x49CEF0ce48ab89E6C8bB50a184FbEb19b44Ade63, 10 ether);
752         addToWhitelist(0x67D8dFF88562D156a2306CE5f2eFCA0b452aAdD2, 10 ether);
753         addToWhitelist(0x969f18769a75847d39e91ad0dbdfd80820293b0d, 10 ether);
754         addToWhitelist(0x976D1CF16b5b2567503246d7D980F86234cB1fAd, 10 ether);
755         addToWhitelist(0xA02f61FE8DeB678b53a4eA1BE0353f4F78D16a5a, 10 ether);
756         addToWhitelist(0xd573C0f13aC91d30bC0A08F1c256063e3a6928eF, 10 ether);
757         addToWhitelist(0xe5FbbDfd081aaD4913eB25e4b195Ba15C2d64de5, 10 ether);
758         addToWhitelist(0xf159FdAfA300d4b7E417CFE06d55F09d93b60E53, 10 ether);
759         addToWhitelist(0xf831dB774BfC4e2c74b9b42474a0e0DD60B342b1, 10 ether);
760         addToWhitelist(0x8A7aA336E1909641558B906585fc56DeE2B44Dd0, 15 ether);
761         addToWhitelist(0x48ce7eBe80d771a7023E1dC3eB632a4E6Cb0559b, 20 ether);
762         addToWhitelist(0x6818025bd0e89506D3D34B0C45cC1E556d2Dbc5B, 20 ether);
763         addToWhitelist(0x9BE1c7a1F118F61740f01e96d292c0bae90360aB, 20 ether);
764         addToWhitelist(0xa1B0dDDEFFf18651206ae2d68A14f024760eAa75, 20 ether);
765 
766         // Set chunk added flag
767         chunk6IsAdded = true;
768     }
769 
770     /// @notice Check if pre-sale contract has enough Parsec credits on its account balance 
771     ///         to reward all possible participations within pre-sale period and max cap
772     function powerUpContract() external onlyOwner {
773         // Contract should not be powered up previously
774         require(!contractPoweredUp);
775 
776         // Contract should have enough Parsec credits
777         require(parsecToken.balanceOf(this) >= PARSEC_CREDITS_MINIMAL_AMOUNT);
778 
779         // Raise contract power-up flag
780         contractPoweredUp = true;
781     }
782 
783     /// @notice The owner can withdraw ethers only if the minimum funding level has been reached
784     //          and pre-sale is over
785     function ownerWithdraw() external onlyOwner {
786         // The owner cannot withdraw until pre-sale ends
787         require(now >= PRESALE_END_DATE);
788 
789         // The owner cannot withdraw if the presale did not reach the minimum funding amount
790         require(totalFunding >= PRESALE_MINIMUM_FUNDING);
791 
792         // Withdraw the total funding amount
793         owner.transfer(totalFunding);
794     }
795 
796     /// @notice The owner can withdraw unspent Parsec credits if the minimum funding level has been
797     ///         reached and pre-sale is over
798     function ownerWithdrawUnspentCredits() external onlyOwner {
799         // The owner cannot withdraw unspent Parsec credits until pre-sale ends
800         require(now >= PRESALE_END_DATE);
801 
802         // The owner cannot withdraw unspent Parsec credits if token withdrawal period started
803         require(now < TOKEN_WITHDRAWAL_START_DATE);
804 
805         // The owner cannot withdraw if the pre-sale did not reach the minimum funding amount
806         require(totalFunding >= PRESALE_MINIMUM_FUNDING);
807 
808         // The owner cannot withdraw unspent Parsec credits more than once
809         require(!unspentCreditsWithdrawn);
810 
811         // Transfer unspent Parsec credits back to pre-sale contract owner
812         uint256 currentCredits = parsecToken.balanceOf(this);
813         uint256 unspentAmount = currentCredits.sub(grantedParsecCredits);
814         unspentCreditsWithdrawn = true;
815         parsecToken.transfer(owner, unspentAmount);
816     }
817 
818     function ownerWithdrawUnclaimedCredits() external onlyOwner {
819         // The owner cannot withdraw unclaimed Parsec credits until token withdrawal period ends
820         require(now >= TOKEN_WITHDRAWAL_END_DATE);
821 
822         // The owner cannot withdraw if the presale did not reach the minimum funding amount
823         require(totalFunding >= PRESALE_MINIMUM_FUNDING);
824 
825         // The owner cannot withdraw unclaimed Parsec credits more than once
826         require(!unclaimedCreditsWithdrawn);
827 
828         // Transfer unclaimed Parsec credits back to pre-sale contract owner
829         unclaimedCreditsWithdrawn = true;
830         parsecToken.transfer(owner, parsecToken.balanceOf(this));
831     }
832 
833     /// @notice The participant will need to withdraw their Parsec credits if minimal pre-sale amount
834     ///         was reached and date between TOKEN_WITHDRAWAL_START_DATE and TOKEN_WITHDRAWAL_END_DATE
835     function participantClaimCredits() external {
836         // Participant can withdraw Parsec credits only during token withdrawal period
837         require(now >= TOKEN_WITHDRAWAL_START_DATE);
838         require(now < TOKEN_WITHDRAWAL_END_DATE);
839 
840         // Participant cannot withdraw Parsec credits if the minimum funding amount has not been reached
841         require(totalFunding >= PRESALE_MINIMUM_FUNDING);
842 
843         // Participant can only withdraw Parsec credits if granted amount exceeds zero
844         require(creditBalanceOf[msg.sender] > 0);
845 
846         // Get amount of tokens to approve
847         var tokensToApprove = creditBalanceOf[msg.sender];
848 
849         // Update amount of Parsec credits spent
850         spentParsecCredits = spentParsecCredits.add(tokensToApprove);
851 
852         // Participant's Parsec credit balance is reduced to zero
853         creditBalanceOf[msg.sender] = 0;
854 
855         // Give allowance for participant to withdraw certain amount of Parsec credits
856         parsecToken.approve(msg.sender, tokensToApprove);
857     }
858 
859     /// @notice The participant will need to withdraw their funds from this contract if
860     ///         the presale has not achieved the minimum funding level
861     function participantWithdrawIfMinimumFundingNotReached(uint256 value) external {
862         // Participant cannot withdraw before the presale ends
863         require(now >= PRESALE_END_DATE);
864 
865         // Participant cannot withdraw if the minimum funding amount has been reached
866         require(totalFunding < PRESALE_MINIMUM_FUNDING);
867 
868         // Get sender balance
869         uint256 senderBalance = balanceOf[msg.sender];
870 
871         // Participant can only withdraw an amount up to their contributed balance
872         require(senderBalance >= value);
873 
874         // Participant's balance is reduced by the claimed amount.
875         balanceOf[msg.sender] = senderBalance.sub(value);
876 
877         // Send ethers back to the participant's account
878         msg.sender.transfer(value);
879     }
880 
881     /// @notice The owner can clawback any ethers after a date in the future, so no
882     ///         ethers remain trapped in this contract. This will only be relevant
883     ///         if the minimum funding level is not reached
884     function ownerClawback() external onlyOwner {
885         // Minimum funding amount has not been reached
886         require(totalFunding < PRESALE_MINIMUM_FUNDING);
887 
888         // The owner cannot withdraw before the clawback date
889         require(now >= OWNER_CLAWBACK_DATE);
890 
891         // Send remaining funds back to the owner
892         owner.transfer(this.balance);
893     }
894 
895     /// @notice The owner can clawback any unspent Parsec credits after a date in the future,
896     ///         so no Parsec credits remain trapped in this contract. This will only be relevant
897     ///         if the minimum funding level is not reached
898     function ownerClawbackCredits() external onlyOwner {
899         // Minimum funding amount has not been reached
900         require(totalFunding < PRESALE_MINIMUM_FUNDING);
901 
902         // The owner cannot withdraw before the clawback date
903         require(now >= OWNER_CLAWBACK_DATE);
904 
905         // The owner cannot clawback unclaimed Parsec credits more than once
906         require(!creditsClawbacked);
907 
908         // Transfer clawbacked Parsec credits back to pre-sale contract owner
909         creditsClawbacked = true;
910         parsecToken.transfer(owner, parsecToken.balanceOf(this));
911     }
912 
913     /// @dev Keep track of participants contributions and the total funding amount
914     function addBalance(address participant, uint256 value) private {
915         // Participant's balance is increased by the sent amount
916         balanceOf[participant] = balanceOf[participant].add(value);
917 
918         // Keep track of the total funding amount
919         totalFunding = totalFunding.add(value); 
920 
921         // Log an event of the participant's contribution
922         LogParticipation(participant, value, now);
923     }
924 
925     /// @dev Add whitelisted amount
926     function ownerAddToWhitelist(address participant, uint256 value) external onlyOwner {
927         addToWhitelist(participant, value);
928     }
929     
930     /// @dev Keep track of whitelisted participants contributions
931     function addToWhitelist(address participant, uint256 value) private {
932         // Participant's balance is increased by the sent amount
933         whitelist[participant] = whitelist[participant].add(value);
934 
935         // Keep track of the total whitelisted funding amount
936         totalWhitelistedFunding = totalWhitelistedFunding.add(value);
937     }
938 
939     function grantCreditsForParticipation(address participant, uint256 etherAmount) private {
940         // Add bonus 5% if contributed amount is greater or equal to bonus threshold
941         uint256 dividend = etherAmount >= BONUS_THRESHOLD ? 105 : 100;
942         dividend = dividend.mul(etherAmount);
943         dividend = dividend.mul(PARSEC_CREDITS_PER_ETHER);
944         uint256 divisor = 100;
945         divisor = divisor.mul(1 ether);
946 
947         // Calculate amount of Parsec credits to grant to contributor
948         uint256 creditsToGrant = dividend.div(divisor);
949 
950         // Check if contract has enough Parsec credits
951         uint256 currentBalanceInCredits = parsecToken.balanceOf(this);
952         uint256 availableCredits = currentBalanceInCredits.sub(grantedParsecCredits);
953         require(availableCredits >= creditsToGrant);
954 
955         // Add Parsec credits amount to participant's credit balance
956         creditBalanceOf[participant] = creditBalanceOf[participant].add(creditsToGrant);
957 
958         // Add Parsec credits amount to total granted credits
959         grantedParsecCredits = grantedParsecCredits.add(creditsToGrant);
960     }
961 }