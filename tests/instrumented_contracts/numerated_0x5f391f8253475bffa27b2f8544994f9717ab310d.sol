1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal constant returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() {
72     owner = msg.sender;
73   }
74 
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) onlyOwner public {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 contract ClaimableTokens is Ownable {
98 
99     address public claimedTokensWallet;
100 
101     function ClaimableTokens(address targetWallet) {
102         claimedTokensWallet = targetWallet;
103     }
104 
105     function claimTokens(address tokenAddress) public onlyOwner {
106         require(tokenAddress != 0x0);
107         ERC20 claimedToken = ERC20(tokenAddress);
108         uint balance = claimedToken.balanceOf(this);
109         claimedToken.transfer(claimedTokensWallet, balance);
110     }
111 }
112 
113 contract CromToken is Ownable, ERC20, ClaimableTokens {
114     using SafeMath for uint256;
115     string public constant name = "CROM Token";
116     string public constant symbol = "CROM";
117     uint8 public constant decimals = 0;
118     uint256 public constant INITIAL_SUPPLY = 10 ** 7;
119     mapping (address => uint256) internal balances;
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122     function CromToken() Ownable() ClaimableTokens(msg.sender) {
123         totalSupply = INITIAL_SUPPLY;
124         balances[msg.sender] = totalSupply;
125     }
126 
127     function transfer(address to, uint256 value) public returns (bool success) {
128         require(to != 0x0);
129         require(balances[msg.sender] >= value);
130         balances[msg.sender] = balances[msg.sender].sub(value);
131         balances[to] = balances[to].add(value);
132         Transfer(msg.sender, to, value);
133         return true;
134     }
135 
136     function approve(address spender, uint256 value) public returns (bool success) {
137         allowed[msg.sender][spender] = value;
138         Approval(msg.sender, spender, value);
139         return true;
140     }
141 
142     function allowance(address owner, address spender) public constant returns (uint256 remaining) {
143         return allowed[owner][spender];
144     }
145 
146     function balanceOf(address who) public constant returns (uint256) {
147         return balances[who];
148     }
149 
150     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
151         require(to != 0x0);
152         require(balances[from] >= value);
153         require(value <= allowed[from][msg.sender]);
154         balances[from] = balances[from].sub(value);
155         balances[to] = balances[to].add(value);
156         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
157         Transfer(from, to, value);
158         return true;
159     }
160 }
161 
162 contract CromIco is Ownable, ClaimableTokens {
163     using SafeMath for uint256;
164 
165     CromToken public token;
166 
167     // start and end timestamps where investments are allowed (both inclusive)
168     uint public preStartTime;
169     uint public startTime;
170     uint public endTime;
171 
172     // address where funds are collected
173     address public targetWallet;
174     bool public targetWalletVerified;
175 
176     // caps definitions
177     uint256 public constant SOFT_CAP = 8000 ether;
178     uint256 public constant HARD_CAP = 56000 ether;
179 
180     // token price
181     uint256 public constant TOKEN_PRICE = 10 finney;
182 
183     uint public constant BONUS_BATCH = 2 * 10 ** 6;
184     uint public constant BONUS_PERCENTAGE = 25;
185     uint256 public constant MINIMAL_PRE_ICO_INVESTMENT = 10 ether;
186 
187     // ICO duration
188     uint public constant PRE_DURATION = 14 days;
189     uint public constant DURATION = 14 days;
190 
191     // contributions per individual
192     mapping (address => uint256) public balanceOf;
193 
194     // wallets allowed to take part in the pre ico
195     mapping (address => bool) public preIcoMembers;
196 
197     // total amount of funds raised
198     uint256 public amountRaised;
199 
200     uint256 public tokensSold;
201 
202     bool public paused;
203 
204     enum Stages {
205         WalletUnverified,
206         BeforeIco,
207         Payable,
208         AfterIco
209     }
210 
211     enum PayableStages {
212         PreIco,
213         PublicIco
214     }
215 
216     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
217 
218     // Constructor
219     function CromIco(address tokenAddress, address beneficiaryWallet) Ownable() ClaimableTokens(beneficiaryWallet) {
220         token = CromToken(tokenAddress);
221         preStartTime = 1510920000;
222         startTime = preStartTime + PRE_DURATION;
223         endTime = startTime + DURATION;
224         targetWallet = beneficiaryWallet;
225         targetWalletVerified = false;
226         paused = false;
227     }
228 
229     modifier atStage(Stages stage) {
230         require(stage == getCurrentStage());
231         _;
232     }
233 
234     // fallback function can be used to buy tokens
235     function() payable atStage(Stages.Payable) {
236         buyTokens();
237     }
238 
239   // low level token purchase function
240     function buyTokens() internal {
241         require(msg.sender != 0x0);
242         require(msg.value > 0);
243         require(!paused);
244 
245         uint256 weiAmount = msg.value;
246 
247         // calculate token amount to be transferred
248         uint256 tokens = calculateTokensAmount(weiAmount);
249         require(tokens > 0);
250         require(token.balanceOf(this) >= tokens);
251 
252         if (PayableStages.PreIco == getPayableStage()) {
253             require(preIcoMembers[msg.sender]);
254             require(weiAmount.add(balanceOf[msg.sender]) >= MINIMAL_PRE_ICO_INVESTMENT);
255             require(tokensSold.add(tokens) <= BONUS_BATCH);
256         }
257 
258         amountRaised = amountRaised.add(weiAmount);
259         balanceOf[msg.sender] = balanceOf[msg.sender].add(weiAmount);
260         tokensSold = tokensSold.add(tokens);
261         token.transfer(msg.sender, tokens);
262 
263         TokenPurchase(msg.sender, weiAmount, tokens);
264     }
265 
266     function verifyTargetWallet() public atStage(Stages.WalletUnverified) {
267         require(msg.sender == targetWallet);
268         targetWalletVerified = true;
269     }
270 
271     // add a list of wallets to be allowed to take part in pre ico
272     function addPreIcoMembers(address[] members) public onlyOwner {
273         for (uint i = 0; i < members.length; i++) {
274             preIcoMembers[members[i]] = true;
275         }
276     }
277 
278     // remove a list of wallets to be allowed to take part in pre ico
279     function removePreIcoMembers(address[] members) public onlyOwner {
280         for (uint i = 0; i < members.length; i++) {
281             preIcoMembers[members[i]] = false;
282         }
283     }
284 
285     // @return true if the ICO is in pre ICO phase
286     function isPreIcoActive() public constant returns (bool) {
287         bool isPayable = Stages.Payable == getCurrentStage();
288         bool isPreIco = PayableStages.PreIco == getPayableStage();
289         return isPayable && isPreIco;
290     }
291 
292     // @return true if the public ICO is in progress
293     function isPublicIcoActive() public constant returns (bool) {
294         bool isPayable = Stages.Payable == getCurrentStage();
295         bool isPublic = PayableStages.PublicIco == getPayableStage();
296         return isPayable && isPublic;
297     }
298 
299     // @return true if ICO has ended
300     function hasEnded() public constant returns (bool) {
301         return Stages.AfterIco == getCurrentStage();
302     }
303 
304     // @return true if the soft cap has been reached
305     function softCapReached() public constant returns (bool) {
306         return amountRaised >= SOFT_CAP;
307     }
308 
309     // withdraw the contributed funds if the ICO has
310     // ended and the goal has not been reached
311     function withdrawFunds() public atStage(Stages.AfterIco) returns(bool) {
312         require(!softCapReached());
313         require(balanceOf[msg.sender] > 0);
314 
315         uint256 balance = balanceOf[msg.sender];
316 
317         balanceOf[msg.sender] = 0;
318         msg.sender.transfer(balance);
319         return true;
320     }
321 
322     // transfer the raised funds to the target wallet if
323     // the ICO is over and the goal has been reached
324     function finalizeIco() public onlyOwner atStage(Stages.AfterIco) {
325         require(softCapReached());
326         targetWallet.transfer(this.balance);
327     }
328 
329     function withdrawUnsoldTokens() public onlyOwner atStage(Stages.AfterIco) {
330         token.transfer(targetWallet, token.balanceOf(this));
331     }
332 
333     function pause() public onlyOwner {
334         require(!paused);
335         paused = true;
336     }
337 
338     function resume() public onlyOwner {
339         require(paused);
340         paused = false;
341     }
342 
343     function changeTargetWallet(address wallet) public onlyOwner {
344         targetWallet = wallet;
345         targetWalletVerified = false;
346     }
347 
348     function calculateTokensAmount(uint256 funds) internal returns (uint256) {
349         uint256 tokens = funds.div(TOKEN_PRICE);
350         if (tokensSold < BONUS_BATCH) {
351             if (tokensSold.add(tokens) > BONUS_BATCH) {
352                 uint256 bonusBaseTokens = BONUS_BATCH.mul(100).div(125).sub(tokensSold);
353                 tokens = tokens.add(bonusBaseTokens.mul(BONUS_PERCENTAGE).div(100));
354             } else {
355                 tokens = tokens.mul(BONUS_PERCENTAGE + 100).div(100);
356             }
357         }
358         return tokens;
359     }
360 
361     function getCurrentStage() internal constant returns (Stages) {
362         if (!targetWalletVerified) {
363             return Stages.WalletUnverified;
364         } else if (now < preStartTime) {
365             return Stages.BeforeIco;
366         } else if (now < endTime && amountRaised < HARD_CAP) {
367             return Stages.Payable;
368         } else {
369             return Stages.AfterIco;
370         }
371     }
372 
373     function getPayableStage() internal constant returns (PayableStages) {
374         if (now < startTime) {
375             return PayableStages.PreIco;
376         } else {
377             return PayableStages.PublicIco;
378         }
379     }
380 }