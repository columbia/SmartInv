1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint a, uint b) internal pure returns (uint256) {
16         uint c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function pow(uint a, uint b) internal pure returns (uint) {
32         uint c = a ** b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45     uint256 public totalSupply;
46     function balanceOf(address _who) public constant returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57 
58     using SafeMath for uint256;
59 
60     mapping(address => uint256) public balances;
61 
62     /// seconds since 01.01.1970 to 17.02.2018 00:00:00 GMT
63     uint64 public dateTransferable = 1518825600;
64 
65     /**
66      * @dev Transfer token for a specified address
67      * @param _to The address to transfer to.
68      * @param _value The amount to be transferred.
69      */
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         uint64 _now = uint64(block.timestamp);
72         require(_now >= dateTransferable);
73         require(_to != address(this)); // Don't allow to transfer tokens to contract address
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     /**
81      * @dev Gets the balance of the specified address.
82      * @param _address The address to query the balance of.
83      * @return An uint256 representing the amount owned by the passed address.
84      */
85     function balanceOf(address _address) public view returns (uint256) {
86         return balances[_address];
87     }
88 }
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address _owner, address _spender) public constant returns (uint256);
97     function transferFrom(address _from, address _to, uint256 value) public returns (bool);
98     function approve(address _spender, uint256 _value) public returns (bool);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /** 
104  * @title Ownable
105  * @dev The Ownable contract has an owner address, and provides basic authorization control
106  * functions, this simplifies the implementation of "user permissions".
107  */
108 contract Ownable {
109 
110     address public owner;
111 
112     /**
113      * @dev The Ownable constructor sets the original 'owner' of the contract to the sender account.
114      */
115     function Ownable() public {
116         owner = msg.sender;
117     }
118 
119     /**
120      * @dev Throws if called by any account other than the owner.
121      */
122     modifier onlyOwner() {
123         require(msg.sender == owner);
124         _;
125     }
126 }
127 
128 
129 /**
130  * @title Pausable
131  * @dev Base contract which allows children to implement an emergency stop mechanism.
132  */
133 contract Pausable is Ownable {
134     event Pause();
135     event Unpause();
136 
137     bool public paused = false;
138 
139     /**
140      * @dev modifier to allow actions only when the contract IS paused
141      */
142     modifier whenNotPaused() {
143         require(!paused);
144         _;
145     }
146 
147     /**
148      * @dev modifier to allow actions only when the contract IS NOT paused
149      */
150     modifier whenPaused() {
151         require(paused);
152         _;
153     }
154 
155     /**
156      * @dev called by the owner to pause, triggers stopped state
157      */
158     function pause() public onlyOwner whenNotPaused returns (bool) {
159         paused = true;
160         Pause();
161         return true;
162     }
163 
164     /**
165      * @dev called by the owner to unpause, returns to normal state
166      */
167     function unpause() public onlyOwner whenPaused returns (bool) {
168         paused = false;
169         Unpause();
170         return true;
171     }
172 }
173 
174 
175 /**
176  * @title Mintable token
177  * @dev Simple ERC20 Token example, with mintable token creation
178  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
179  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
180  */
181 contract MintableToken is BasicToken, Ownable {
182 
183     event Mint(address indexed to, uint256 amount);
184     event MintFinished();
185 
186     bool public mintingFinished = false;
187 
188     modifier canMint() {
189         require(!mintingFinished);
190         _;
191     }
192 
193     /**
194      * @dev Function to mint tokens
195      * @param _amount The amount of tokens to mint.
196      * @return A boolean that indicates if the operation was successful.
197      */
198     function mint(uint256 _amount) public onlyOwner canMint returns (bool) {
199         totalSupply = totalSupply.add(_amount);
200         balances[owner] = balances[owner].add(_amount);
201         Mint(owner, _amount);
202         Transfer(0x0, owner, _amount);
203         return true;
204     }
205 
206     /**
207      * @dev Function to stop minting new tokens.
208      * @return True if the operation was successful.
209      */
210     function finishMinting() public onlyOwner returns (bool) {
211         mintingFinished = true;
212         MintFinished();
213         return true;
214     }
215 }
216 
217 
218 /**
219  * @title Xineoken
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 contract Xineoken is BasicToken, Ownable, Pausable, MintableToken {
225 
226     using SafeMath for uint256;
227     
228     string public name = "Xineoken";
229     uint256 public decimals = 2;
230     string public symbol = "XIN";
231 
232     /// price for a single token
233     uint256 public buyPrice = 10526315789474;
234     /// price for a single token after the 2nd stage of tokens
235     uint256 public buyPriceFinal = 52631578947368;
236     /// number of tokens sold
237     uint256 public allocatedTokens = 0;
238     /// first tier of tokens at a discount
239     uint256 public stage1Tokens = 330000000 * (10 ** decimals);
240     /// second tier of tokens at a discount
241     uint256 public stage2Tokens = 660000000 * (10 ** decimals);
242     /// minimum amount in wei 0.1 ether
243     uint256 public minimumBuyAmount = 100000000000000000;
244     
245     function Xineoken() public {
246         totalSupply = 1000000000 * (10 ** decimals);
247         balances[owner] = totalSupply;
248     }
249 
250     // fallback function can be used to buy tokens
251     function () public payable {
252         buyToken();
253     }
254     
255     /**
256      * @dev Calculate the number of tokens based on the current stage
257      * @param _value The amount of wei
258      * @return The number of tokens
259      */
260     function calculateTokenAmount(uint256 _value) public view returns (uint256) {
261 
262         var tokenAmount = uint256(0);
263         var tokenAmountCurrentStage = uint256(0);
264         var tokenAmountNextStage = uint256(0);
265   
266         var stage1TokensNoDec = stage1Tokens / (10 ** decimals);
267         var stage2TokensNoDec = stage2Tokens / (10 ** decimals);
268         var allocatedTokensNoDec = allocatedTokens / (10 ** decimals);
269   
270         if (allocatedTokensNoDec < stage1TokensNoDec) {
271             tokenAmount = _value / buyPrice;
272             if (tokenAmount.add(allocatedTokensNoDec) > stage1TokensNoDec) {
273                 tokenAmountCurrentStage = stage1TokensNoDec.sub(allocatedTokensNoDec);
274                 tokenAmountNextStage = (_value.sub(tokenAmountCurrentStage.mul(buyPrice))) / (buyPrice * 2);
275                 tokenAmount = tokenAmountCurrentStage + tokenAmountNextStage;
276             }
277         } else if (allocatedTokensNoDec < (stage2TokensNoDec)) {
278             tokenAmount = _value / (buyPrice * 2);
279             if (tokenAmount.add(allocatedTokensNoDec) > stage2TokensNoDec) {
280                 tokenAmountCurrentStage = stage2TokensNoDec.sub(allocatedTokensNoDec);
281                 tokenAmountNextStage = (_value.sub(tokenAmountCurrentStage.mul(buyPrice * 2))) / buyPriceFinal;
282                 tokenAmount = tokenAmountCurrentStage + tokenAmountNextStage;
283             }
284         } else {
285             tokenAmount = _value / buyPriceFinal;
286         }
287 
288         return tokenAmount;
289     }
290 
291     /**
292      * @dev Buy tokens when the contract is not paused.
293      */
294     function buyToken() public whenNotPaused payable {
295 
296         require(msg.sender != 0x0);
297         require(msg.value >= minimumBuyAmount);
298         
299         uint256 weiAmount = msg.value;
300         uint256 tokens = calculateTokenAmount(weiAmount);
301 
302         require(tokens > 0);
303 
304         uint256 totalTokens = tokens * (10 ** decimals);
305 
306         balances[owner] = balances[owner].sub(totalTokens);
307         balances[msg.sender] = balances[msg.sender].add(totalTokens);
308         allocatedTokens = allocatedTokens.add(totalTokens);
309         Transfer(owner, msg.sender, totalTokens);
310         
311         forwardFunds();
312     }
313 
314     /**
315      * @dev Allocate tokens to an address
316      * @param _to Address where tokens should be allocated to.
317      * @param _tokens Amount of tokens.
318      * @return True if the operation was successful.
319      */
320     function allocateTokens(address _to, uint256 _tokens) public onlyOwner returns (bool) {
321         require(balanceOf(owner) >= _tokens);
322         balances[owner] = balances[owner].sub(_tokens);
323         balances[_to] = balances[_to].add(_tokens);
324         allocatedTokens = allocatedTokens.add(_tokens);
325         Transfer(owner, _to, _tokens);
326         return true;
327     }
328 
329     /** 
330      * @param _newBuyPrice Price in wei users can buy from the contract.
331      * @param _newBuyPriceFinal Final price in wei users can buy from the contract.
332      * @return True if the operation was successful.
333      */
334     function setBuyPrice(uint256 _newBuyPrice, uint256 _newBuyPriceFinal) public onlyOwner returns (bool) {
335         buyPrice = _newBuyPrice;
336         buyPriceFinal = _newBuyPriceFinal;
337         return true;
338     }
339 
340     /**
341      * @dev Set the date tokens can be transferred.
342      * @param _date The date after tokens can be transferred.
343      */
344     function setTransferableDate(uint64 _date) public onlyOwner {
345         dateTransferable = _date;
346     }
347 
348     /**
349      * @dev Set the minimum buy amount in wei.
350      * @param _amount Wei amount.
351      */
352     function setMinimumBuyAmount(uint256 _amount) public onlyOwner {
353         minimumBuyAmount = _amount;
354     }
355 
356     /**
357      * @dev Allows the current owner to transfer control of the contract to a newOwner.
358      * @param newOwner The address to transfer ownership to.
359      */
360     function transferOwnership(address newOwner) public onlyOwner {
361         if (newOwner != address(0)) {
362             // transfer tokens from owner to new owner
363             var previousOwner = owner;
364             var ownerBalance = balances[previousOwner];
365             balances[previousOwner] = balances[previousOwner].sub(ownerBalance);
366             balances[newOwner] = balances[newOwner].add(ownerBalance);
367             owner = newOwner;
368             Transfer(previousOwner, newOwner, ownerBalance);
369         }
370     }
371 
372     /**
373      * @dev Forward funds to owner address
374      */
375     function forwardFunds() internal {
376         if (!owner.send(msg.value)) {
377             revert();
378         }
379     }
380 }