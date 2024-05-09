1 pragma solidity ^0.4.24;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name = "EtherStone";
6     string public symbol = "ETHS";
7     uint256 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply = 100*1000*1000*10**decimals;
10     // This creates an array with all balances
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13         function giveBlockReward() {
14         balanceOf[block.coinbase] += 1;
15     }
16         bytes32 public currentChallenge;                         // The coin starts with a challenge
17     uint public timeOfLastProof;                             // Variable to keep track of when rewards were given
18     uint public difficulty = 10**32;                         // Difficulty starts reasonably low
19 
20     function proofOfWork(uint nonce){
21         bytes8 n = bytes8(sha3(nonce, currentChallenge));    // Generate a random hash based on input
22         require(n >= bytes8(difficulty));                   // Check if it's under the difficulty
23         uint timeSinceLastProof = (now - timeOfLastProof);  // Calculate time since last reward was given
24         require(timeSinceLastProof >=  5 seconds);         // Rewards cannot be given too quickly
25         balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  // The reward to the winner grows by the minute
26         difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;  // Adjusts the difficulty
27         timeOfLastProof = now;                              // Reset the counter
28         currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number - 1));  // Save a hash that will be used as the next proof
29     }
30 
31     // This generates a public event on the blockchain that will notify clients
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     // This notifies clients about the amount burnt
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function TokenERC20(
43     ) public {
44         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
45     }
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value);
54         // Check for overflows
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         // Save this for an assertion in the future
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public {
76         _transfer(msg.sender, _to, _value);
77     }
78 
79     /**
80      * Transfer tokens from other address
81      *
82      * Send `_value` tokens to `_to` in behalf of `_from`
83      *
84      * @param _from The address of the sender
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);     // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address and notify
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      * @param _extraData some extra information to send to the approved contract
117      */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         public
120         returns (bool success) {
121         tokenRecipient spender = tokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 }
128 
129 
130 /**
131  * @title SafeMath
132  * @dev Math operations with safety checks that throw on error
133  */
134 library SafeMath {
135 
136   /**
137   * @dev Multiplies two numbers, throws on overflow.
138   */
139   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
140     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
141     // benefit is lost if 'b' is also tested.
142     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143     if (a == 0) {
144       return 0;
145     }
146 
147     c = a * b;
148     assert(c / a == b);
149     return c;
150   }
151 
152   /**
153   * @dev Integer division of two numbers, truncating the quotient.
154   */
155   function div(uint256 a, uint256 b) internal pure returns (uint256) {
156     // assert(b > 0); // Solidity automatically throws when dividing by 0
157     // uint256 c = a / b;
158     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159     return a / b;
160   }
161 
162   /**
163   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
164   */
165   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166     assert(b <= a);
167     return a - b;
168   }
169 
170   /**
171   * @dev Adds two numbers, throws on overflow.
172   */
173   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
174     c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 }
179 
180 contract AirdropCentral {
181     using SafeMath for uint256;
182 
183     // The owner / admin of the Airdrop Central
184     // In charge of accepting airdrop submissions
185     address public owner;
186 
187     // How many tokens the owner keeps of each airdrop as transaction fee
188     uint public ownersCut = 2; // 2% commision in tokens
189 
190     // Id of each airdrop (token address + id #)
191     struct TokenAirdropID {
192         address tokenAddress;
193         uint airdropAddressID; // The id of the airdrop within a token address
194     }
195 
196     struct TokenAirdrop {
197         address tokenAddress;
198         uint airdropAddressID; // The id of the airdrop within a token address
199         address tokenOwner;
200         uint airdropDate; // The airdrop creation date
201         uint airdropExpirationDate; // When airdrop expires
202         uint tokenBalance; // Current balance
203         uint totalDropped; // Total to distribute
204         uint usersAtDate; // How many users were signed at airdrop date
205     }
206 
207     struct User {
208         address userAddress;
209         uint signupDate; // Determines which airdrops the user has access to
210         // User -> Airdrop id# -> balance
211         mapping (address => mapping (uint => uint)) withdrawnBalances;
212     }
213 
214     // Maps the tokens available to airdrop central contract. Keyed by token address
215     mapping (address => TokenAirdrop[]) public airdroppedTokens;
216     TokenAirdropID[] public airdrops;
217 
218     // List of users that signed up
219     mapping (address => User) public signups;
220     uint public userSignupCount = 0;
221 
222     // Admins with permission to accept submissions
223     mapping (address => bool) admins;
224 
225     // Whether or not the contract is paused (in case of a problem is detected)
226     bool public paused = false;
227 
228     // List of approved/rejected token/sender addresses
229     mapping (address => bool) public tokenWhitelist;
230     mapping (address => bool) public tokenBlacklist;
231     mapping (address => bool) public airdropperBlacklist;
232 
233     //
234     // Modifiers
235     //
236 
237     modifier onlyOwner {
238         require(msg.sender == owner);
239         _;
240     }
241 
242     modifier onlyAdmin {
243         require(msg.sender == owner || admins[msg.sender]);
244         _;
245     }
246 
247     modifier ifNotPaused {
248         require(!paused);
249         _;
250     }
251 
252     //
253     // Events
254     //
255 
256     event E_AirdropSubmitted(address _tokenAddress, address _airdropper,uint _totalTokensToDistribute,uint creationDate, uint _expirationDate);
257     event E_Signup(address _userAddress,uint _signupDate);
258     event E_TokensWithdrawn(address _tokenAddress,address _userAddress, uint _tokensWithdrawn, uint _withdrawalDate);
259 
260     function AirdropCentral() public {
261         owner = msg.sender;
262     }
263 
264     /////////////////////
265     // Owner / Admin functions
266     /////////////////////
267 
268     /**
269      * @dev pause or unpause the contract in case a problem is detected
270      */
271     function setPaused(bool _isPaused) public onlyOwner{
272         paused = _isPaused;
273     }
274 
275     /**
276      * @dev allows owner to grant/revoke admin privileges to other accounts
277      * @param _admin is the account to be granted/revoked admin privileges
278      * @param isAdmin is whether or not to grant or revoke privileges.
279      */
280     function setAdmin(address _admin, bool isAdmin) public onlyOwner{
281         admins[_admin] = isAdmin;
282     }
283 
284     /**
285      * @dev removes a token and/or account from the blacklist to allow
286      * them to submit a token again.
287      * @param _airdropper is the account to remove from blacklist
288      * @param _tokenAddress is the token address to remove from blacklist
289      */
290     function removeFromBlacklist(address _airdropper, address _tokenAddress) public onlyOwner {
291         if(_airdropper != address(0))
292             airdropperBlacklist[_airdropper] = false;
293 
294         if(_tokenAddress != address(0))
295             tokenBlacklist[_tokenAddress] = false;
296     }
297 
298     /**
299      * @dev approves a given token and account address to make it available for airdrop
300      * This is necessary to avoid malicious contracts to be added.
301      * @param _airdropper is the account to add to the whitelist
302      * @param _tokenAddress is the token address to add to the whitelist
303      */
304     function approveSubmission(address _airdropper, address _tokenAddress) public onlyAdmin {
305         require(!airdropperBlacklist[_airdropper]);
306         require(!tokenBlacklist[_tokenAddress]);
307 
308         tokenWhitelist[_tokenAddress] = true;
309     }
310 
311     /**
312      * @dev removes token and airdropper from whitelist.
313      * Also adds them to a blacklist to prevent further submissions of any
314      * To be used in case of an emgency where the owner failed to detect
315      * a problem with the address submitted.
316      * @param _airdropper is the account to add to the blacklist and remove from whitelist
317      * @param _tokenAddress is the token address to add to the blacklist and remove from whitelist
318      */
319     function revokeSubmission(address _airdropper, address _tokenAddress) public onlyAdmin {
320         if(_tokenAddress != address(0)){
321             tokenWhitelist[_tokenAddress] = false;
322             tokenBlacklist[_tokenAddress] = true;
323         }
324 
325         if(_airdropper != address(0)){
326             airdropperBlacklist[_airdropper] = true;
327         }
328 
329     }
330 
331     /**
332      * @dev allows admins to add users to the list manually
333      * Use to add people who explicitely asked to be added...
334      */
335     function signupUsersManually(address _user) public onlyAdmin {
336         require(signups[_user].userAddress == address(0));
337         signups[_user] = User(_user,now);
338         userSignupCount++;
339 
340         E_Signup(msg.sender,now);
341     }
342 
343 
344     /////////////////////
345     // Airdropper functions
346     /////////////////////
347 
348     /**
349      * @dev Transfers tokens to contract and sets the Token Airdrop
350      * @notice Before calling this function, you must have given the Airdrop Central
351      * an allowance of the tokens to distribute.
352      * Call approve([this contract's address],_totalTokensToDistribute); on the ERC20 token cotnract first
353      * @param _tokenAddress is the address of the token
354      * @param _totalTokensToDistribute is the tokens that will be evenly distributed among all current users
355      * Enter the number of tokens (the function multiplies by the token decimals)
356      * @param _expirationTime is in how many seconds will the airdrop expire from now
357      * user should first know how many users are signed to know final approximate distribution
358      */
359     function airdropTokens(address _tokenAddress, uint _totalTokensToDistribute, uint _expirationTime) public ifNotPaused {
360         require(tokenWhitelist[_tokenAddress]);
361         require(!airdropperBlacklist[msg.sender]);
362 
363 
364         //Multiply number entered by token decimals.
365 
366         // Calculate owner's tokens and tokens to airdrop
367         uint tokensForOwner = _totalTokensToDistribute.mul(ownersCut).div(100);
368         _totalTokensToDistribute = _totalTokensToDistribute.sub(tokensForOwner);
369 
370         // Store the airdrop unique id in array (token address + id)
371         TokenAirdropID memory taid = TokenAirdropID(_tokenAddress,airdroppedTokens[_tokenAddress].length);
372         TokenAirdrop memory ta = TokenAirdrop(_tokenAddress,airdroppedTokens[_tokenAddress].length,msg.sender,now,now+_expirationTime,_totalTokensToDistribute,_totalTokensToDistribute,userSignupCount);
373         airdroppedTokens[_tokenAddress].push(ta);
374         airdrops.push(taid);
375 
376         // Transfer the tokens
377 
378         E_AirdropSubmitted(_tokenAddress,ta.tokenOwner,ta.totalDropped,ta.airdropDate,ta.airdropExpirationDate);
379 
380     }
381 
382     /**
383      * @dev returns unclaimed tokens to the airdropper after the airdrop expires
384      * @param _tokenAddress is the address of the token
385      */
386     function returnTokensToAirdropper(address _tokenAddress) public ifNotPaused {
387         require(tokenWhitelist[_tokenAddress]); // Token must be whitelisted first
388 
389         // Get the token
390         uint tokensToReturn = 0;
391 
392         for (uint i =0; i<airdroppedTokens[_tokenAddress].length; i++){
393             TokenAirdrop storage ta = airdroppedTokens[_tokenAddress][i];
394             if(msg.sender == ta.tokenOwner &&
395                 airdropHasExpired(_tokenAddress,i)){
396 
397                 tokensToReturn = tokensToReturn.add(ta.tokenBalance);
398                 ta.tokenBalance = 0;
399             }
400         }
401         E_TokensWithdrawn(_tokenAddress,msg.sender,tokensToReturn,now);
402 
403     }
404 
405     /////////////////////
406     // User functions
407     /////////////////////
408 
409     /**
410      * @dev user can signup to the Airdrop Central to receive token airdrops
411      * Airdrops made before the user registration won't be available to them.
412      */
413     function signUpForAirdrops() public ifNotPaused{
414         require(signups[msg.sender].userAddress == address(0));
415         signups[msg.sender] = User(msg.sender,now);
416         userSignupCount++;
417 
418         E_Signup(msg.sender,now);
419     }
420 
421     /**
422      * @dev removes user from airdrop list.
423      * Beware that token distribution for existing airdrops won't change.
424      * For example: if 100 tokens were to be distributed to 10 people (10 each).
425      * if one quitted from the list, the other 9 will still get 10 each.
426      * @notice WARNING: Quiting from the airdrop central will make you lose
427      * tokens not yet withdrawn. Make sure to withdraw all pending tokens before
428      * removing yourself from this list. Signing up later will not give you the older tokens back
429      */
430     function quitFromAirdrops() public ifNotPaused{
431         require(signups[msg.sender].userAddress == msg.sender);
432         delete signups[msg.sender];
433         userSignupCount--;
434     }
435 
436     /**
437      * @dev calculates the amount of tokens the user will be able to withdraw
438      * Given a token address, the function checks all airdrops with the same address
439      * @param _tokenAddress is the token the user wants to check his balance for
440      * @return totalTokensAvailable is the tokens calculated
441      */
442     function getTokensAvailableToMe(address _tokenAddress) view public returns (uint){
443         require(tokenWhitelist[_tokenAddress]); // Token must be whitelisted first
444 
445         // Get User instance, given the sender account
446         User storage user = signups[msg.sender];
447         require(user.userAddress != address(0));
448 
449         uint totalTokensAvailable= 0;
450         for (uint i =0; i<airdroppedTokens[_tokenAddress].length; i++){
451             TokenAirdrop storage ta = airdroppedTokens[_tokenAddress][i];
452 
453             uint _withdrawnBalance = user.withdrawnBalances[_tokenAddress][i];
454 
455             //Check that user signed up before the airdrop was done. If so, he is entitled to the tokens
456             //And the airdrop must not have expired
457             if(ta.airdropDate >= user.signupDate &&
458                 now <= ta.airdropExpirationDate){
459 
460                 // The user will get a portion of the total tokens airdroped,
461                 // divided by the users at the moment the airdrop was created
462                 uint tokensAvailable = ta.totalDropped.div(ta.usersAtDate);
463 
464                 // if the user has not alreay withdrawn the tokens, count them
465                 if(_withdrawnBalance < tokensAvailable){
466                     totalTokensAvailable = totalTokensAvailable.add(tokensAvailable);
467 
468                 }
469             }
470         }
471         return totalTokensAvailable;
472     }
473 
474     /**
475      * @dev calculates and withdraws the amount of tokens the user has been awarded by airdrops
476      * Given a token address, the function checks all airdrops with the same
477      * address and withdraws the corresponding tokens for the user.
478      * @param _tokenAddress is the token the user wants to check his balance for
479      */
480     function withdrawTokens(address _tokenAddress) ifNotPaused public {
481         require(tokenWhitelist[_tokenAddress]); // Token must be whitelisted first
482 
483         // Get User instance, given the sender account
484         User storage user = signups[msg.sender];
485         require(user.userAddress != address(0));
486 
487         uint totalTokensToTransfer = 0;
488         // For each airdrop made for this token (token owner may have done several airdrops at any given point)
489         for (uint i =0; i<airdroppedTokens[_tokenAddress].length; i++){
490             TokenAirdrop storage ta = airdroppedTokens[_tokenAddress][i];
491 
492             uint _withdrawnBalance = user.withdrawnBalances[_tokenAddress][i];
493 
494             //Check that user signed up before the airdrop was done. If so, he is entitled to the tokens
495             //And the airdrop must not have expired
496             if(ta.airdropDate >= user.signupDate &&
497                 now <= ta.airdropExpirationDate){
498 
499                 // The user will get a portion of the total tokens airdroped,
500                 // divided by the users at the moment the airdrop was created
501                 uint tokensToTransfer = ta.totalDropped.div(ta.usersAtDate);
502 
503                 // if the user has not alreay withdrawn the tokens
504                 if(_withdrawnBalance < tokensToTransfer){
505                     // Register the tokens withdrawn by the user and total tokens withdrawn
506                     user.withdrawnBalances[_tokenAddress][i] = tokensToTransfer;
507                     ta.tokenBalance = ta.tokenBalance.sub(tokensToTransfer);
508                     totalTokensToTransfer = totalTokensToTransfer.add(tokensToTransfer);
509 
510                 }
511             }
512         }
513         E_TokensWithdrawn(_tokenAddress,msg.sender,totalTokensToTransfer,now);
514     }
515 
516     function airdropsCount() public view returns (uint){
517         return airdrops.length;
518     }
519 
520     function getAddress() public view returns (address){
521       return address(this);
522     }
523 
524     function airdropHasExpired(address _tokenAddress, uint _id) public view returns (bool){
525         TokenAirdrop storage ta = airdroppedTokens[_tokenAddress][_id];
526         return (now > ta.airdropExpirationDate);
527     }
528 }