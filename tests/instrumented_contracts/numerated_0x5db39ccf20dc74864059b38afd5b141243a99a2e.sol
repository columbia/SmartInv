1 pragma solidity ^0.6.0;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender)
37         external
38         view
39         returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount)
67         external
68         returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(
83         address indexed owner,
84         address indexed spender,
85         uint256 value
86     );
87 }
88 
89 
90 interface IUniswapExchange {
91     // Protocol Functions
92     function tokenAddress() external view returns (address);
93 
94     function factoryAddress() external view returns (address);
95 
96     // ERC20 Functions (Keep track of liquidity providers)
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address _owner) external view returns (uint256);
100 
101     function transfer(address _to, uint256 _value) external returns (bool);
102 
103     function transferFrom(address _from, address _to, uint256 _value)
104         external
105         returns (bool);
106 
107     function approve(address _spender, uint256 _value) external returns (bool);
108 
109     function allowance(address _owner, address _spender)
110         external
111         view
112         returns (uint256);
113 
114     // Pricing functions
115     function getEthToTokenInputPrice(uint256 eth_sold)
116         external
117         view
118         returns (uint256);
119 
120     function getEthToTokenOutputPrice(uint256 tokens_bought)
121         external
122         view
123         returns (uint256);
124 
125     function getTokenToEthInputPrice(uint256 tokens_sold)
126         external
127         view
128         returns (uint256);
129 
130     function getTokenToEthOutputPrice(uint256 eth_bought)
131         external
132         view
133         returns (uint256);
134 
135     // Add Liquidity
136     function setup(address token_addr) external;
137 
138     function addLiquidity(
139         uint256 min_liquidity,
140         uint256 max_tokens,
141         uint256 deadline
142     ) external payable returns (uint256);
143 
144     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline)
145         external
146         returns (uint256);
147 
148     //Eth/Token Swap
149     //Sell all ETH
150     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
151         external
152         payable
153         returns (uint256);
154 
155     function ethToTokenTransferInput(
156         uint256 min_tokens,
157         uint256 deadline,
158         address recipient
159     ) external payable returns (uint256);
160 
161     //Sell some ETH and get refund
162     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline)
163         external
164         payable
165         returns (uint256);
166 
167     function ethToTokenTransferOutput(
168         uint256 tokens_bought,
169         uint256 deadline,
170         address recipient
171     ) external payable returns (uint256);
172 
173     //Token/Eth Swap
174     //Sell all tokens
175     function tokenToEthSwapInput(
176         uint256 tokens_sold,
177         uint256 min_eth,
178         uint256 deadline
179     ) external returns (uint256);
180 
181     function tokenToEthTransferInput(
182         uint256 tokens_sold,
183         uint256 min_eth,
184         uint256 deadline,
185         address recipient
186     ) external returns (uint256);
187 
188     //Sell some tokens and get refund
189     function tokenToEthSwapOutput(
190         uint256 eth_bought,
191         uint256 max_tokens,
192         uint256 deadline
193     ) external returns (uint256);
194 
195     function tokenToEthTransferOutput(
196         uint256 eth_bought,
197         uint256 max_tokens,
198         uint256 deadline,
199         address recipient
200     ) external returns (uint256);
201 
202     //Token/Token Swap
203     function tokenToTokenSwapInput(
204         uint256 tokens_sold,
205         uint256 min_tokens_bought,
206         uint256 min_eth_bought,
207         uint256 deadline,
208         address token_addr
209     ) external returns (uint256);
210 
211     function tokenToTokenTransferInput(
212         uint256 tokens_sold,
213         uint256 min_tokens_bought,
214         uint256 min_eth_bought,
215         uint256 deadline,
216         address recipient,
217         address token_addr
218     ) external returns (uint256);
219 
220     function tokenToTokenSwapOutput(
221         uint256 tokens_bought,
222         uint256 max_tokens_sold,
223         uint256 max_eth_sold,
224         uint256 deadline,
225         address token_addr
226     ) external returns (uint256);
227 
228     function tokenToTokenTransferOutput(
229         uint256 tokens_bought,
230         uint256 max_tokens_sold,
231         uint256 max_eth_sold,
232         uint256 deadline,
233         address recipient,
234         address token_addr
235     ) external returns (uint256);
236 
237     //Token/Exchange Swap
238     function tokenToExchangeSwapInput(
239         uint256 tokens_sold,
240         uint256 min_tokens_bought,
241         uint256 min_eth_bought,
242         uint256 deadline,
243         address exchange_addr
244     ) external returns (uint256);
245 
246     function tokenToExchangeTransferInput(
247         uint256 tokens_sold,
248         uint256 min_tokens_bought,
249         uint256 min_eth_bought,
250         uint256 deadline,
251         address recipient,
252         address exchange_addr
253     ) external returns (uint256);
254 
255     function tokenToExchangeSwapOutput(
256         uint256 tokens_bought,
257         uint256 max_tokens_sold,
258         uint256 max_eth_sold,
259         uint256 deadline,
260         address exchange_addr
261     ) external returns (uint256);
262 
263     function tokenToExchangeTransferOutput(
264         uint256 tokens_bought,
265         uint256 max_tokens_sold,
266         uint256 max_eth_sold,
267         uint256 deadline,
268         address recipient,
269         address exchange_addr
270     ) external returns (uint256);
271 }
272 
273 contract UniswapOTC {
274     address public owner;
275     address public exchangeAddress;
276     address public tokenAddress;
277 
278     uint256 public totalClients;
279     address[] public clients;
280     mapping (address => bool) public clientExists;
281     
282     mapping (address => uint256) public clientEthBalances;      //Client ETH balance
283     mapping (address => uint256) public clientMinTokens;        //Client Limit Order
284     mapping (address => uint256) public clientTokenBalances;    //Client Token balance
285     mapping (address => uint256) public clientTokenFees;        //Total OTC Fees
286     mapping (address => uint256) public purchaseTimestamp;        //Withdrawal timestamp
287     uint256 constant ONE_DAY_SECONDS = 86400;
288     uint256 constant FIVE_MINUTE_SECONDS = 300;
289     
290     mapping(address => bool) public triggerAddresses;           //Bot Trigger Addresses
291 
292     IERC20 token;
293     IUniswapExchange exchange;
294 
295     //Min volume values
296     uint256 public minEthLimit;     //Min Volume
297     uint256 public maxTokenPerEth;  //Min Price
298     
299     constructor(address _exchangeAddress, uint256 _minEthLimit, uint256 _maxTokenPerEth) public {
300         exchange = IUniswapExchange(_exchangeAddress);
301         exchangeAddress = _exchangeAddress;
302         tokenAddress = exchange.tokenAddress();
303         token = IERC20(tokenAddress);
304         owner = msg.sender;
305         minEthLimit = _minEthLimit;
306         maxTokenPerEth = _maxTokenPerEth;
307         totalClients = 0;
308     }
309 
310     /**
311      * @dev OTC Provider. Gives right to fee withdrawal.
312      */
313     modifier onlyOwner() {
314         require(msg.sender == owner, "Unauthorized");
315         _;
316     }
317 
318     /**
319      * @dev Authorized Purchase Trigger addresses for mempool bot.
320      */
321     modifier onlyTrigger() {
322         require(msg.sender == owner || triggerAddresses[msg.sender], "Unauthorized");
323         _;
324     }
325 
326     /**
327      * @dev Trigger Uniswap contract, drains client's ETH balance.
328      *      Computes fee as spread between execution price and limit price.
329      */
330     function executeLimitOrder(address _client, uint256 deadline)
331         public
332         onlyTrigger
333         returns (uint256, uint256)
334     {
335         //Avoids Uniswap Assert Failure when no liquidity (gas saving)
336         require(token.balanceOf(exchangeAddress) > 0, "No liquidity on Uniswap!"); //27,055 Gas
337 
338         uint256 ethBalance = clientEthBalances[_client];
339         uint256 tokensBought = exchange.getEthToTokenInputPrice(ethBalance);
340         uint256 minTokens = clientMinTokens[_client];
341 
342         require(tokensBought >= minTokens, "Purchase amount below min tokens!"); //27,055 Gas
343 
344         uint256 spreadFee = tokensBought - minTokens;
345         //Tokens bought, set balance 0
346         clientEthBalances[_client] = 0; //Reset state
347         clientMinTokens[_client] = 0; //Reset state
348         clientTokenBalances[_client] += minTokens;  //Add to balance
349         clientTokenFees[_client] += spreadFee;      //Add to balance
350         purchaseTimestamp[_client] = block.timestamp + ONE_DAY_SECONDS;
351 
352         //Call Uniswap contract
353         exchange.ethToTokenSwapInput.value(ethBalance)(
354             tokensBought,
355             deadline
356         );
357 
358         return (minTokens, spreadFee);
359     }
360 
361     /**
362      * @dev Add Trigger address.
363      */
364     function setTriggerAddress(address _address, bool _authorized)
365         public
366         onlyOwner
367     {
368         triggerAddresses[_address] = _authorized;
369     }
370 
371     /**
372      * @dev Get max limit price.
373      */
374     function getMaxTokens(uint256 _etherAmount)
375         public
376         view
377         returns (uint256)
378     {
379         return _etherAmount * maxTokenPerEth;
380     }
381 
382     /**
383      * @dev Fund contract and set limit price (in the form of min purchased tokens).
384      * Excess value is refunded to sender in the case of a re-balancing.
385      */
386     function setLimitOrder(uint256 _tokenAmount, uint256 _etherAmount)
387         public
388         payable
389     {
390         require(_etherAmount >= minEthLimit, "Insufficient ETH volume");
391         require(_tokenAmount <= maxTokenPerEth  * _etherAmount, "Excessive token per ETH");
392         require(_etherAmount == clientEthBalances[msg.sender] + msg.value, "Balance must equal purchase eth amount.");
393 
394         if (!clientExists[msg.sender]) {
395             clientExists[msg.sender] = true;
396             clients.push(msg.sender);
397             totalClients += 1;
398         }
399         
400         //Increment client balance
401         clientEthBalances[msg.sender] += msg.value;
402         clientMinTokens[msg.sender] = _tokenAmount;
403     }
404 
405 
406     /**
407      * @dev Return if purchase would be autherized at current prices
408      */
409     function canPurchase(address _client)
410         public
411         view
412         returns (bool)
413     {
414         //Avoids Uniswap Assert Failure when no liquidity (gas saving)
415         if (token.balanceOf(exchangeAddress) == 0) {
416             return false;
417         }
418 
419         uint256 ethBalance = clientEthBalances[_client];
420         if (ethBalance == 0) {
421             return false;
422         }
423         
424         uint256 tokensBought = exchange.getEthToTokenInputPrice(ethBalance);
425         uint256 minTokens = clientMinTokens[_client];
426 
427         //Only minimum amount of tokens
428         return tokensBought >= minTokens;
429     }
430 
431     /**
432      * @dev Withdraw OTC provider fee tokens.
433      */
434     function withdrawFeeTokens(address _client) public onlyOwner {
435         require(clientTokenFees[_client] > 0, "No fees!");
436         require(block.timestamp > purchaseTimestamp[_client], "Wait for client withdrawal.");
437 
438         uint256 sendFees = clientTokenFees[_client];
439         clientTokenFees[_client] = 0;
440 
441         token.transfer(msg.sender, sendFees);
442     }
443 
444     /**
445      * @dev Withdraw OTC client purchased tokens.
446      */
447     function withdrawClientTokens() public {
448         require(clientTokenBalances[msg.sender] > 0, "No tokens!");
449 
450         uint256 sendTokens = clientTokenBalances[msg.sender];
451         clientTokenBalances[msg.sender] = 0;
452         purchaseTimestamp[msg.sender] = block.timestamp + FIVE_MINUTE_SECONDS;  //Unlock in 5minutes
453 
454         token.transfer(msg.sender, sendTokens);
455     }
456     
457 
458     /**
459      * @dev Withdraw OTC client ether.
460      */
461     function withdrawEther() public {
462         require(clientEthBalances[msg.sender] > 0, "No ETH balance!");
463 
464         uint256 sendEth = clientEthBalances[msg.sender];
465         clientEthBalances[msg.sender] = 0;
466 
467         payable(msg.sender).transfer(sendEth);
468     }
469 
470     /**
471      * @dev Get eth balance of contract.
472      */
473     function contractEthBalance() public view returns (uint256) {
474         return address(this).balance;
475     }
476 
477     /**
478      * @dev Get token balance of contract
479      */
480     function contractTokenBalance() public view returns (uint256) {
481         return token.balanceOf(address(this));
482     }
483 
484 }