1 /** @title Onasander Token Contract
2 *   
3 *   @author: Andrzej Wegrzyn
4 *   Contact: development@onasander.com
5 *   Date: May 5, 2018
6 *   Location: New York, USA
7 *   Token: Onasander
8 *   Symbol: ONA
9 *   
10 *   @notice This is a simple contract due to solidity bugs and complications. 
11 *
12 *   @notice Owner has the option to burn all the remaining tokens after the ICO.  That way Owners will not end up with majority of the tokens.
13 *   @notice Onasander would love to give every user the option to burn the remaining tokens, but due to Solidity VM bugs and risk, we will process
14 *   @notice all coin burns and refunds manually.
15 *   
16 *   @notice How to run the contract:
17 *
18 *   Requires:
19 *   Wallet Address
20 *
21 *   Run:
22 *   1. Create Contract
23 *   2. Set Minimum Goal
24 *   3. Set Tokens Per ETH
25 *   4. Create PRE ICO Sale (can have multiple PRE-ICOs)
26 *   5. End PRE ICO Sale
27 *   6. Create ICO Sale
28 *   7. End ICO Sale
29 *   8. END ICO
30 *   9. Burn Remaining Tokens
31 *
32 *   e18 for every value except tokens per ETH
33 *   
34 *   @dev This contract allows you to configure as many Pre-ICOs as you need.  It's a very simple contract written to give contract admin lots of dynamic options.
35 *   @dev Here, most features except for total supply, max tokens for sale, company reserves, and token standard features, are dynamic.  You can configure your contract
36 *   @dev however you want to.  
37 *
38 *   @dev IDE: Remix with Mist 0.10
39 *   @dev Token supply numbers are provided in 0e18 format in MIST in order to bypass MIST number format errors.
40 */
41 
42 pragma solidity ^0.4.23;
43 
44 contract OnasanderToken
45 {
46     using SafeMath for uint;
47     
48     address private wallet;                                // Address where funds are collected
49     address public owner;                                  // contract owner
50     string constant public name = "Onasander";
51     string constant public symbol = "ONA";
52     uint8 constant public decimals = 18;
53     uint public totalSupply = 88000000e18;                       
54     uint public totalTokensSold = 0e18;                    // total number of tokens sold to date
55     uint public totalTokensSoldInThisSale = 0e18;          // total number of tokens sold in this sale
56     uint public maxTokensForSale = 79200000e18;            // 90%  max tokens we can ever sale  
57     uint public companyReserves = 8800000e18;              // 10%  company reserves. this is what we end up with after eco ends and burns the rest if any  
58     uint public minimumGoal = 0e18;                        // hold minimum goal
59     uint public tokensForSale = 0e18;                      // total number of tokens we are selling in the current sale (ICO, preICO)
60     bool public saleEnabled = false;                       // enables all sales: ICO and tokensPreICO
61     bool public ICOEnded = false;                          // flag checking if the ICO has completed
62     bool public burned = false;                            // Excess tokens burned flag after ICO ends
63     uint public tokensPerETH = 800;                        // amount of Onasander tokens you get for 1 ETH
64     bool public wasGoalReached = false;                    // checks if minimum goal was reached
65     address private lastBuyer;
66     uint private singleToken = 1e18;
67 
68     constructor(address icoWallet) public 
69     {   
70         require(icoWallet != address(0), "ICO Wallet address is required.");
71 
72         owner = msg.sender;
73         wallet = icoWallet;
74         balances[owner] = totalSupply;  // give initial full balance to contract owner
75         emit TokensMinted(owner, totalSupply);        
76     }
77 
78     event ICOHasEnded();
79     event SaleEnded();
80     event OneTokenBugFixed();
81     event ICOConfigured(uint minimumGoal);
82     event TokenPerETHReset(uint amount);
83     event ICOCapReached(uint amount);
84     event SaleCapReached(uint amount);
85     event GoalReached(uint amount);
86     event Burned(uint amount);    
87     event BuyTokens(address buyer, uint tokens);
88     event SaleStarted(uint tokensForSale);    
89     event TokensMinted(address targetAddress, uint tokens);
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint tokens);
91     event Transfer(address indexed from, address indexed to, uint tokens);
92     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
93 
94     mapping(address => uint) balances;
95     
96     mapping(address => mapping (address => uint)) allowances;
97 
98     function balanceOf(address accountAddress) public constant returns (uint balance)
99     {
100         return balances[accountAddress];
101     }
102 
103     function allowance(address sender, address spender) public constant returns (uint remainingAllowedAmount)
104     {
105         return allowances[sender][spender];
106     }
107 
108     function transfer(address to, uint tokens) public returns (bool success)
109     {     
110         require (ICOEnded, "ICO has not ended.  Can not transfer.");
111         require (balances[to] + tokens > balances[to], "Overflow is not allowed.");
112 
113         // actual transfer
114         // SafeMath.sub will throw if there is not enough balance.
115         balances[msg.sender] = balances[msg.sender].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         
118         emit Transfer(msg.sender, to, tokens);
119         return true;
120     }
121 
122 
123 
124     function transferFrom(address from, address to, uint tokens) public returns(bool success) 
125     {
126         require (ICOEnded, "ICO has not ended.  Can not transfer.");
127         require (balances[to] + tokens > balances[to], "Overflow is not allowed.");
128 
129         // actual transfer
130         balances[from] = balances[from].sub(tokens);
131         allowances[from][msg.sender] = allowances[from][msg.sender].sub(tokens); // lower the allowance by the amount of tokens 
132         balances[to] = balances[to].add(tokens);
133         
134         emit Transfer(from, to, tokens);        
135         return true;
136     }
137 
138     function approve(address spender, uint tokens) public returns(bool success) 
139     {          
140         require (ICOEnded, "ICO has not ended.  Can not transfer.");      
141         allowances[msg.sender][spender] = tokens;                
142         emit Approval(msg.sender, spender, tokens);
143         return true;
144     }
145 
146         // in case some investor pays by wire or credit card we will transfer him the tokens manually.
147     function wirePurchase(address to, uint numberOfTokenPurchased) onlyOwner public
148     {     
149         require (saleEnabled, "Sale must be enabled.");
150         require (!ICOEnded, "ICO already ended.");
151         require (numberOfTokenPurchased > 0, "Tokens must be greater than 0.");
152         require (tokensForSale > totalTokensSoldInThisSale, "There is no more tokens for sale in this sale.");
153                         
154         // calculate amount
155         uint buyAmount = numberOfTokenPurchased;
156         uint tokens = 0e18;
157 
158         // this check is not perfect as someone may want to buy more than we offer for sale and we lose a sale.
159         // the best would be to calclate and sell you only the amout of tokens that is left and refund the rest of money        
160         if (totalTokensSoldInThisSale.add(buyAmount) >= tokensForSale)
161         {
162             tokens = tokensForSale.sub(totalTokensSoldInThisSale);  // we allow you to buy only up to total tokens for sale, and refund the rest
163             // need to program the refund for the rest,or do it manually.  
164         }
165         else
166         {
167             tokens = buyAmount;
168         }
169 
170         // transfer only as we do not need to take the payment since we already did in wire
171         require (balances[to].add(tokens) > balances[to], "Overflow is not allowed.");
172         balances[to] = balances[to].add(tokens);
173         balances[owner] = balances[owner].sub(tokens);
174         lastBuyer = to;
175 
176         // update counts
177         totalTokensSold = totalTokensSold.add(tokens);
178         totalTokensSoldInThisSale = totalTokensSoldInThisSale.add(tokens);
179         
180         emit BuyTokens(to, tokens);
181         emit Transfer(owner, to, tokens);
182 
183         isGoalReached();
184         isMaxCapReached();
185     }
186 
187     function buyTokens() payable public
188     {        
189         require (saleEnabled, "Sale must be enabled.");
190         require (!ICOEnded, "ICO already ended.");
191         require (tokensForSale > totalTokensSoldInThisSale, "There is no more tokens for sale in this sale.");
192         require (msg.value > 0, "Must send ETH");
193 
194         // calculate amount
195         uint buyAmount = SafeMath.mul(msg.value, tokensPerETH);
196         uint tokens = 0e18;
197 
198         // this check is not perfect as someone may want to buy more than we offer for sale and we lose a sale.
199         // the best would be to calclate and sell you only the amout of tokens that is left and refund the rest of money        
200         if (totalTokensSoldInThisSale.add(buyAmount) >= tokensForSale)
201         {
202             tokens = tokensForSale.sub(totalTokensSoldInThisSale);  // we allow you to buy only up to total tokens for sale, and refund the rest
203 
204             // need to program the refund for the rest
205         }
206         else
207         {
208             tokens = buyAmount;
209         }
210 
211         // buy
212         require (balances[msg.sender].add(tokens) > balances[msg.sender], "Overflow is not allowed.");
213         balances[msg.sender] = balances[msg.sender].add(tokens);
214         balances[owner] = balances[owner].sub(tokens);
215         lastBuyer = msg.sender;
216 
217         // take the money out right away
218         wallet.transfer(msg.value);
219 
220         // update counts
221         totalTokensSold = totalTokensSold.add(tokens);
222         totalTokensSoldInThisSale = totalTokensSoldInThisSale.add(tokens);
223         
224         emit BuyTokens(msg.sender, tokens);
225         emit Transfer(owner, msg.sender, tokens);
226 
227         isGoalReached();
228         isMaxCapReached();
229     }
230 
231     // Fallback function. Used for buying tokens from contract owner by simply
232     // sending Ethers to contract.
233     function() public payable 
234     {
235         // we buy tokens using whatever ETH was sent in
236         buyTokens();
237     }
238 
239     // Called when ICO is closed. Burns the remaining tokens except the tokens reserved
240     // Must be called by the owner to trigger correct transfer event
241     function burnRemainingTokens() public onlyOwner
242     {
243         require (!burned, "Remaining tokens have been burned already.");
244         require (ICOEnded, "ICO has not ended yet.");
245 
246         uint difference = balances[owner].sub(companyReserves); 
247 
248         if (wasGoalReached)
249         {
250             totalSupply = totalSupply.sub(difference);
251             balances[owner] = companyReserves;
252         }
253         else
254         {
255             // in case we did not reach the goal, we burn all tokens except tokens purchased.
256             totalSupply = totalTokensSold;
257             balances[owner] = 0e18;
258         }
259 
260         burned = true;
261 
262         emit Transfer(owner, address(0), difference);    // this is run in order to update token holders in the website
263         emit Burned(difference);        
264     }
265 
266     modifier onlyOwner() 
267     {
268         require(msg.sender == owner);
269         _;
270     }
271 
272     function transferOwnership(address newOwner) onlyOwner public
273     {
274         address preOwner = owner;        
275         owner = newOwner;
276 
277         uint previousBalance = balances[preOwner];
278 
279         // transfer balance 
280         balances[newOwner] = balances[newOwner].add(previousBalance);
281         balances[preOwner] = 0;
282 
283         //emit Transfer(preOwner, newOwner, previousBalance); // required to update the Token Holders on the network
284         emit OwnershipTransferred(preOwner, newOwner, previousBalance);
285     }
286 
287     // Set the number of ONAs sold per ETH 
288     function setTokensPerETH(uint newRate) onlyOwner public
289     {
290         require (!ICOEnded, "ICO already ended.");
291         require (newRate > 0, "Rate must be higher than 0.");
292         tokensPerETH = newRate;
293         emit TokenPerETHReset(newRate);
294     }
295 
296     // Minimum goal is based on USD, not on ETH. Since we will have different dynamic prices based on the daily pirce of ETH, we
297     // will need to be able to adjust our minimum goal in tokens sold, as our goal is set in tokens, not USD.
298     function setMinimumGoal(uint goal) onlyOwner public
299     {   
300         require(goal > 0e18,"Minimum goal must be greater than 0.");
301         minimumGoal = goal;
302 
303         // since we can edit the goal, we want to check if we reached the goal before in case we lowered the goal number.
304         isGoalReached();
305 
306         emit ICOConfigured(goal);
307     }
308 
309     function createSale(uint numberOfTokens) onlyOwner public
310     {
311         require (!saleEnabled, "Sale is already going on.");
312         require (!ICOEnded, "ICO already ended.");
313         require (totalTokensSold < maxTokensForSale, "We already sold all our tokens.");
314 
315         totalTokensSoldInThisSale = 0e18;
316         uint tryingToSell = totalTokensSold.add(numberOfTokens);
317 
318         // in case we are trying to create a sale with too many tokens, we subtract and sell only what's left
319         if (tryingToSell > maxTokensForSale)
320         {
321             tokensForSale = maxTokensForSale.sub(totalTokensSold); 
322         }
323         else
324         {
325             tokensForSale = numberOfTokens;
326         }
327 
328         tryingToSell = 0e18;
329         saleEnabled = true;
330         emit SaleStarted(tokensForSale);
331     }
332 
333     function endSale() public
334     {
335         if (saleEnabled)
336         {
337             saleEnabled = false;
338             tokensForSale = 0e18;
339             emit SaleEnded();
340         }
341     }
342 
343     function endICO() onlyOwner public
344     {
345         if (!ICOEnded)
346         {
347             // run this before end of ICO and end of last sale            
348             fixTokenCalcBug();
349 
350             endSale();
351 
352             ICOEnded = true;            
353             lastBuyer = address(0);
354             
355             emit ICOHasEnded();
356         }
357     }
358 
359     function isGoalReached() internal
360     {
361         // check if we reached the goal
362         if (!wasGoalReached)
363         {
364             if (totalTokensSold >= minimumGoal)
365             {
366                 wasGoalReached = true;
367                 emit GoalReached(minimumGoal);
368             }
369         }
370     }
371 
372     function isMaxCapReached() internal
373     {
374         if (totalTokensSoldInThisSale >= tokensForSale)
375         {            
376             emit SaleCapReached(totalTokensSoldInThisSale);
377             endSale();
378         }
379 
380         if (totalTokensSold >= maxTokensForSale)
381         {            
382             emit ICOCapReached(maxTokensForSale);
383             endICO();
384         }
385     }
386 
387     // This is a hack to add the lost token during final full sale. 
388     function fixTokenCalcBug() internal
389     {        
390         require(!burned, "Fix lost token can only run before the burning of the tokens.");        
391         
392         if (maxTokensForSale.sub(totalTokensSold) == singleToken)
393         {
394             totalTokensSold = totalTokensSold.add(singleToken);
395             totalTokensSoldInThisSale = totalTokensSoldInThisSale.add(singleToken);
396             
397             balances[lastBuyer] = balances[lastBuyer].add(singleToken);
398             balances[owner] = balances[owner].sub(singleToken);
399 
400             emit Transfer(owner, lastBuyer, singleToken);
401             emit OneTokenBugFixed();
402         }
403     }
404 }
405 
406 library SafeMath {
407 
408   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
409     if (a == 0) {
410       return 0;
411     }
412     c = a * b;
413     assert(c / a == b);
414     return c;
415   }
416 
417   function div(uint256 a, uint256 b) internal pure returns (uint256) {
418     // assert(b > 0); // Solidity automatically throws when dividing by 0
419     // uint c = a / b;
420     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
421     return a / b;
422   }
423 
424   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
425     assert(b <= a);
426     return a - b;
427   }
428 
429   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
430     c = a + b;
431     assert(c >= a);
432     return c;
433   }
434 }