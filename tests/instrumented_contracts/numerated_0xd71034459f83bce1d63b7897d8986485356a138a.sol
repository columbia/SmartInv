1 pragma solidity ^0.4.10;
2 
3 // Library used for performing arithmetic operations
4 
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25     /*
26     ERC Token Standard #20 Interface
27     */
28 
29 // ----------------------------------------------------------------------------
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
31 // ----------------------------------------------------------------------------
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44     /*
45     Contract function to receive approval and execute function in one call
46      */
47 // ----------------------------------------------------------------------------
48 // Borrowed from MiniMeToken
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 //Owned contract
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61     /** @dev Assigns ownership to calling address
62       */
63     function Owned() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71     /** @dev Transfers ownership to new address
72      *  
73       */
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     
78     /** @dev Accept ownership of the contract
79       */
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is Owned {
93   event Pause();
94   event Unpause();
95 
96   bool public paused = false;
97 
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() onlyOwner whenNotPaused public {
119     paused = true;
120     emit Pause();
121   }
122 
123   /**
124    * @dev called by the owner to unpause, returns to normal state
125    */
126   function unpause() onlyOwner whenPaused public {
127     paused = false;
128     emit Unpause();
129   }
130 }
131 
132 
133 
134 /*
135 
136 ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply
137       
138 */
139       
140 contract SpaceXToken is ERC20Interface, Owned, Pausable {
141     using SafeMath for uint;
142 
143 
144     uint8 public decimals;
145     
146     uint256 public totalRaised;           // Total ether raised (in wei)
147     uint256 public startTimestamp;        // Timestamp after which ICO will start
148     uint256 public endTimeStamp;          // Timestamp at which ICO will end
149     uint256 public basePrice =  15000000000000000;              // All prices are in Wei
150     uint256 public step1 =      80000000000000;
151     uint256 public step2 =      60000000000000;
152     uint256 public step3 =      40000000000000;
153     uint256 public tokensSold;
154     uint256 currentPrice;
155     uint256 public totalPrice;
156     uint256 public _totalSupply;        // Total number of presale tokens available
157     
158     string public version = '1.0';      // The current version of token
159     string public symbol;           
160     string public  name;
161     
162     
163     address public fundsWallet;             // Where should the raised ETH go?
164 
165     mapping(address => uint) balances;    // Keeps the record of tokens with each owner address
166     mapping(address => mapping(address => uint)) allowed; // Tokens allowed to be transferred
167 
168     /** @dev Constructor
169       
170       */
171 
172     function SpaceXToken() public {
173         tokensSold = 0;
174         startTimestamp = 1527080400;
175         endTimeStamp = 1529672400;
176         fundsWallet = owner;
177         name = "SpaceXToken";                                     // Set the name for display purposes (CHANGE THIS)
178         decimals = 0;                                               // numberOfTokens of decimals for display purposes (CHANGE THIS)
179         symbol = "SCX";                       // symbol for token
180         _totalSupply = 4000 * 10**uint(decimals);       // total supply of tokens 
181         balances[owner] = _totalSupply;               // assigning all tokens to owner
182         tokensSold = 0;
183         currentPrice = basePrice;
184         totalPrice = 0;
185         Transfer(msg.sender, owner, _totalSupply);
186 
187 
188     }
189 
190 
191     /* @dev returns totalSupply of tokens.
192       
193       
194      */
195     function totalSupply() public constant returns (uint) {
196         return _totalSupply  - balances[address(0)];
197     }
198 
199 
200     /** @dev returns balance of tokens of Owner.
201      *  @param tokenOwner address token owner
202       
203       
204      */
205     function balanceOf(address tokenOwner) public constant returns (uint balance) {
206         return balances[tokenOwner];
207     }
208 
209 
210     /** @dev Transfer the tokens from token owner's account to `to` account
211      *  @param to address where token is to be sent
212      *  @param tokens  number of tokens
213       
214      */
215     
216     // ------------------------------------------------------------------------
217     // - Owner's account must have sufficient balance to transfer
218     // - 0 value transfers are allowed
219     // ------------------------------------------------------------------------
220     function transfer(address to, uint tokens) public returns (bool success) {
221         balances[msg.sender] = balances[msg.sender].sub(tokens);
222         balances[to] = balances[to].add(tokens);
223         Transfer(msg.sender, to, tokens);
224         return true;
225     }
226 
227     /** @dev Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account
228      *  @param spender address of spender 
229      *  @param tokens number of tokens
230      
231       
232      */
233     
234     // ------------------------------------------------------------------------
235     //
236     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
237     // recommends that there are no checks for the approval double-spend attack
238     // as this should be implemented in user interfaces 
239     // ------------------------------------------------------------------------
240     function approve(address spender, uint tokens) public returns (bool success) {
241         allowed[msg.sender][spender] = tokens;
242         Approval(msg.sender, spender, tokens);
243         return true;
244     }
245 
246     /** @dev Transfer `tokens` from the `from` account to the `to` account
247      *  @param from address from where token is being sent
248      *  @param to where token is to be sent
249      *  @param tokens number of tokens
250       
251       
252      */
253     
254     // ------------------------------------------------------------------------
255     // The calling account must already have sufficient tokens approve(...)-d
256     // for spending from the `from` account and
257     // - From account must have sufficient balance to transfer
258     // - Spender must have sufficient allowance to transfer
259     // - 0 value transfers are allowed
260     // ------------------------------------------------------------------------
261     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
262         balances[from] = balances[from].sub(tokens);
263         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
264         balances[to] = balances[to].add(tokens);
265         Transfer(from, to, tokens);
266         return true;
267     }
268 
269     /** 
270      *  @param tokenOwner Token Owner address
271      *  @param spender Address of spender
272       
273      */
274     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
275         return allowed[tokenOwner][spender];
276     }
277 
278     /** 
279      *  @dev Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account. The `spender` contract function`receiveApproval(...)` is then executed
280      
281       
282      */
283     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
284         allowed[msg.sender][spender] = tokens;
285         Approval(msg.sender, spender, tokens);
286         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
287         return true;
288     }
289     /** 
290      *  @dev Facilitates sale of presale tokens
291      *  @param numberOfTokens number of tokens to be bought
292      */
293     function TokenSale(uint256 numberOfTokens) public whenNotPaused payable { // Facilitates sale of presale token
294         
295         // All the required conditions for the sale of token
296         
297         require(now >= startTimestamp , "Sale has not started yet.");
298         require(now <= endTimeStamp, "Sale has ended.");
299         require(balances[fundsWallet] >= numberOfTokens , "There are no more tokens to be sold." );
300         require(numberOfTokens >= 1 , "You must buy 1 or more tokens.");
301         require(numberOfTokens <= 10 , "You must buy at most 10 tokens in a single purchase.");
302         require(tokensSold.add(numberOfTokens) <= _totalSupply);
303         require(tokensSold<3700, "There are no more tokens to be sold.");
304         
305         // Price step function
306         
307         if(tokensSold <= 1000){
308           
309             totalPrice = ((numberOfTokens) * (2*currentPrice + (numberOfTokens-1)*step1))/2;
310             
311         }
312         
313         if(tokensSold > 1000 && tokensSold <= 3000){
314             totalPrice = ((numberOfTokens) * (2*currentPrice + (numberOfTokens-1)*step2))/2;
315         
316             
317         }
318         
319         
320         if(tokensSold > 3000){
321             totalPrice = ((numberOfTokens) * (2*currentPrice + (numberOfTokens-1)*step3))/2;
322         
323             
324         }
325         
326         
327         require (msg.value >= totalPrice);  // Check if message value is enough to buy given number of tokens
328 
329         balances[fundsWallet] = balances[fundsWallet] - numberOfTokens;
330         balances[msg.sender] = balances[msg.sender] + numberOfTokens;
331 
332         tokensSold = tokensSold + numberOfTokens;
333         
334         if(tokensSold <= 1000){
335           
336             currentPrice = basePrice + step1 * tokensSold;
337             
338         }
339         
340         if(tokensSold > 1000 && tokensSold <= 3000){
341             currentPrice = basePrice + (step1 * 1000) + (step2 * (tokensSold-1000));
342         
343             
344         }
345         
346         if(tokensSold > 3000){
347             
348             currentPrice = basePrice + (step1 * 1000) + (step2 * 2000) + (step3 * (tokensSold-3000));
349           
350         }
351         totalRaised = totalRaised + totalPrice;
352         
353         msg.sender.transfer(msg.value - totalPrice);            ////Transfer extra ether to wallet of the spender
354         Transfer(fundsWallet, msg.sender, numberOfTokens); // Broadcast a message to the blockchain
355 
356     }
357     
358     /** 
359      *  @dev Owner can transfer out any accidentally sent ERC20 tokens
360      *  @dev Transfer the tokens from token owner's account to `to` account
361      *  @param tokenAddress address where token is to be sent
362      *  @param tokens  number of tokens
363      */
364      
365     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
366         return ERC20Interface(tokenAddress).transfer(owner, tokens);
367     }
368 
369    /** 
370      *  @dev view current price of tokens
371      */
372     
373     function viewCurrentPrice() view returns (uint) {
374         if(tokensSold <= 1000){
375           
376             return basePrice + step1 * tokensSold;
377             
378         }
379         
380         if(tokensSold > 1000 && tokensSold <= 3000){
381             return basePrice + (step1 * 1000) + (step2 * (tokensSold-1000));
382         
383             
384         }
385         
386         if(tokensSold > 3000){
387             
388             return basePrice + (step1 * 1000) + (step2 * 2000) + (step3 * (tokensSold-3000));
389           
390         }
391     }
392 
393     
394    /** 
395      *  @dev view number of tokens sold
396      */
397     
398     function viewTokensSold() view returns (uint) {
399         return tokensSold;
400     }
401 
402     /** 
403      *  @dev view number of remaining tokens
404      */
405     
406     function viewTokensRemaining() view returns (uint) {
407         return _totalSupply - tokensSold;
408     }
409     
410     /** 
411      *  @dev withdrawBalance from the contract address
412      *  @param amount that you want to withdrawBalance
413      * 
414      */
415      
416     function withdrawBalance(uint256 amount) onlyOwner returns(bool) {
417         require(amount <= address(this).balance);
418         owner.transfer(amount);
419         return true;
420 
421     }
422     
423     /** 
424      *  @dev view balance of contract
425      */
426      
427     function getBalanceContract() constant returns(uint){
428         return address(this).balance;
429     }
430 }