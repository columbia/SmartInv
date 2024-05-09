1 pragma solidity ^0.4.18;
2 
3 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint public totalSupply;
10   function balanceOf(address _who) public constant returns (uint);
11   function allowance(address _owner, address _spender) public constant returns (uint);
12 
13   function transfer(address _to, uint _value) public returns (bool ok);
14   function transferFrom(address _from, address _to, uint _value) public returns (bool ok);
15   function approve(address _spender, uint _value) public returns (bool ok);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 contract SafeMath {
66   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
67     if (a == 0) {
68       return 0;
69     }
70     uint256 c = a * b;
71     assert(c / a == b);
72     return c;
73   }
74 
75   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 contract FToken is ERC20, Ownable, SafeMath {
95 
96     // Token related informations
97     string public constant name = "Future Token";
98     string public constant symbol = "FT";
99     uint256 public constant decimals = 18; // decimal places
100 
101     // Start withdraw of tokens
102     uint256 public startWithdraw;
103 
104     // Address of wallet from which tokens assigned
105     address public ethExchangeWallet;
106 
107     // MultiSig Wallet Address
108     address public FTMultisig;
109 
110     uint256 public tokensPerEther = 1500;
111 
112     bool public startStop = false;
113 
114     mapping (address => uint256) public walletAngelSales;
115     mapping (address => uint256) public walletPESales;
116 
117     mapping (address => uint256) public releasedAngelSales;
118     mapping (address => uint256) public releasedPESales;
119 
120     mapping (uint => address) public walletAddresses;
121 
122     // Mapping of token balance and allowed address for each address with transfer limit
123     mapping (address => uint256) balances;
124     //mapping of allowed address for each address with tranfer limit
125     mapping (address => mapping (address => uint256)) allowed;
126 
127     function FToken() public {
128         totalSupply = 2000000000 ether;
129         balances[msg.sender] = totalSupply;
130         emit Transfer(address(0), msg.sender,totalSupply);
131     }
132 
133     // Only to be called by Owner of this contract
134     // @param _id Id of lock wallet address
135     // @param _walletAddress Address of lock wallet
136     function addWalletAddresses(uint _id, address _walletAddress) onlyOwner external{
137         require(_walletAddress != address(0));
138         walletAddresses[_id] = _walletAddress;
139     }
140 
141     // Owner can Set Multisig wallet
142     // @param _FTMultisig address of Multisig wallet.
143     function setFTMultiSig(address _FTMultisig) onlyOwner external{
144         require(_FTMultisig != address(0));
145         FTMultisig = _FTMultisig;
146     }
147 
148     // Only to be called by Owner of this contract
149     // @param _ethExchangeWallet Ether Address of exchange wallet
150     function setEthExchangeWallet(address _ethExchangeWallet) onlyOwner external {
151         require(_ethExchangeWallet != address(0));
152         ethExchangeWallet = _ethExchangeWallet;
153     }
154 
155     // Only to be called by Owner of this contract
156     // @param _tokensPerEther Tokens per ether during ICO stages
157     function setTokensPerEther(uint256 _tokensPerEther) onlyOwner external {
158         require(_tokensPerEther > 0);
159         tokensPerEther = _tokensPerEther;
160     }
161 
162     function startStopICO(bool status) onlyOwner external {
163         startStop = status;
164     }
165 
166     function startLockingPeriod() onlyOwner external {
167         startWithdraw = now;
168     }
169 
170     // Assign tokens to investor with locking period
171     function assignToken(address _investor,uint256 _tokens) external {
172         // Tokens assigned by only Angel Sales And PE Sales wallets
173         require(msg.sender == walletAddresses[0] || msg.sender == walletAddresses[1]);
174 
175         // Check investor address and tokens.Not allow 0 value
176         require(_investor != address(0) && _tokens > 0);
177         // Check wallet have enough token balance to assign
178         require(_tokens <= balances[msg.sender]);
179         
180         // Debit the tokens from the wallet
181         balances[msg.sender] = safeSub(balances[msg.sender],_tokens);
182 
183         uint256 calCurrentTokens = getPercentageAmount(_tokens, 20);
184         uint256 allocateTokens = safeSub(_tokens, calCurrentTokens);
185 
186         // Initially assign 20% tokens to the investor
187         balances[_investor] = safeAdd(balances[_investor], calCurrentTokens);
188 
189         // Assign tokens to the investor
190         if(msg.sender == walletAddresses[0]){
191             walletAngelSales[_investor] = safeAdd(walletAngelSales[_investor],allocateTokens);
192             releasedAngelSales[_investor] = safeAdd(releasedAngelSales[_investor], calCurrentTokens);
193         }
194         else if(msg.sender == walletAddresses[1]){
195             walletPESales[_investor] = safeAdd(walletPESales[_investor],allocateTokens);
196             releasedPESales[_investor] = safeAdd(releasedPESales[_investor], calCurrentTokens);
197         }
198         else{
199             revert();
200         }
201     }
202 
203     function withdrawTokens() public {
204         require(walletAngelSales[msg.sender] > 0 || walletPESales[msg.sender] > 0);
205         uint256 withdrawableAmount = 0;
206 
207         if (walletAngelSales[msg.sender] > 0) {
208             uint256 withdrawableAmountAS = getWithdrawableAmountAS(msg.sender);
209             walletAngelSales[msg.sender] = safeSub(walletAngelSales[msg.sender], withdrawableAmountAS);
210             releasedAngelSales[msg.sender] = safeAdd(releasedAngelSales[msg.sender],withdrawableAmountAS);
211             withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountAS);
212         }
213         if (walletPESales[msg.sender] > 0) {
214             uint256 withdrawableAmountPS = getWithdrawableAmountPES(msg.sender);
215             walletPESales[msg.sender] = safeSub(walletPESales[msg.sender], withdrawableAmountPS);
216             releasedPESales[msg.sender] = safeAdd(releasedPESales[msg.sender], withdrawableAmountPS);
217             withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountPS);
218         }
219         require(withdrawableAmount > 0);
220         // Assign tokens to the sender
221         balances[msg.sender] = safeAdd(balances[msg.sender], withdrawableAmount);
222     }
223 
224     // For wallet Angel Sales
225     function getWithdrawableAmountAS(address _investor) public view returns(uint256) {
226         require(startWithdraw != 0);
227         // interval in months
228         uint interval = safeDiv(safeSub(now,startWithdraw),30 days);
229         // total allocatedTokens
230         uint _allocatedTokens = safeAdd(walletAngelSales[_investor],releasedAngelSales[_investor]);
231         // Atleast 6 months
232         if (interval < 6) { 
233             return (0); 
234         } else if (interval >= 6 && interval < 9) {
235             return safeSub(getPercentageAmount(40,_allocatedTokens), releasedAngelSales[_investor]);
236         } else if (interval >= 9 && interval < 12) {
237             return safeSub(getPercentageAmount(60,_allocatedTokens), releasedAngelSales[_investor]);
238         } else if (interval >= 12 && interval < 15) {
239             return safeSub(getPercentageAmount(80,_allocatedTokens), releasedAngelSales[_investor]);
240         } else if (interval >= 15) {
241             return safeSub(_allocatedTokens, releasedAngelSales[_investor]);
242         }
243     }
244 
245     // For wallet PE Sales
246     function getWithdrawableAmountPES(address _investor) public view returns(uint256) {
247         require(startWithdraw != 0);
248         // interval in months
249         uint interval = safeDiv(safeSub(now,startWithdraw),30 days);
250         // total allocatedTokens
251         uint _allocatedTokens = safeAdd(walletPESales[_investor],releasedPESales[_investor]);
252         // Atleast 12 months
253         if (interval < 12) { 
254             return (0); 
255         } else if (interval >= 12 && interval < 18) {
256             return safeSub(getPercentageAmount(40,_allocatedTokens), releasedPESales[_investor]);
257         } else if (interval >= 18 && interval < 24) {
258             return safeSub(getPercentageAmount(60,_allocatedTokens), releasedPESales[_investor]);
259         } else if (interval >= 24 && interval < 30) {
260             return safeSub(getPercentageAmount(80,_allocatedTokens), releasedPESales[_investor]);
261         } else if (interval >= 30) {
262             return safeSub(_allocatedTokens, releasedPESales[_investor]);
263         }
264     }
265 
266     function getPercentageAmount(uint256 percent,uint256 _tokens) internal pure returns (uint256) {
267         return safeDiv(safeMul(_tokens,percent),100);
268     }
269 
270     // Sale of the tokens. Investors can call this method to invest into FT Tokens
271     function() payable external {
272         // Allow only to invest in ICO stage
273         require(startStop);
274 
275         //Sorry !! We only allow to invest with minimum 0.5 Ether as value
276         require(msg.value >= (0.5 ether));
277 
278         // multiply by exchange rate to get token amount
279         uint256 calculatedTokens = safeMul(msg.value, tokensPerEther);
280 
281         // Wait we check tokens available for assign
282         require(balances[ethExchangeWallet] >= calculatedTokens);
283 
284         // Call to Internal function to assign tokens
285         assignTokens(msg.sender, calculatedTokens);
286     }
287 
288     // Function will transfer the tokens to investor's address
289     // Common function code for assigning tokens
290     function assignTokens(address investor, uint256 tokens) internal {
291         // Debit tokens from ether exchange wallet
292         balances[ethExchangeWallet] = safeSub(balances[ethExchangeWallet], tokens);
293 
294         // Assign tokens to the sender
295         balances[investor] = safeAdd(balances[investor], tokens);
296 
297         // Finally token assigned to sender, log the creation event
298         Transfer(ethExchangeWallet, investor, tokens);
299     }
300 
301     function finalizeCrowdSale() external{
302         // Check FT Multisig wallet set or not
303         require(FTMultisig != address(0));
304         // Send fund to multisig wallet
305         require(FTMultisig.send(address(this).balance));
306     }
307 
308     // @param _who The address of the investor to check balance
309     // @return balance tokens of investor address
310     function balanceOf(address _who) public constant returns (uint) {
311         return balances[_who];
312     }
313 
314     // @param _owner The address of the account owning tokens
315     // @param _spender The address of the account able to transfer the tokens
316     // @return Amount of remaining tokens allowed to spent
317     function allowance(address _owner, address _spender) public constant returns (uint) {
318         return allowed[_owner][_spender];
319     }
320 
321     //  Transfer `value` FT tokens from sender's account
322     // `msg.sender` to provided account address `to`.
323     // @param _to The address of the recipient
324     // @param _value The number of FT tokens to transfer
325     // @return Whether the transfer was successful or not
326     function transfer(address _to, uint _value) public returns (bool ok) {
327         //validate receiver address and value.Not allow 0 value
328         require(_to != 0 && _value > 0);
329         uint256 senderBalance = balances[msg.sender];
330         //Check sender have enough balance
331         require(senderBalance >= _value);
332         senderBalance = safeSub(senderBalance, _value);
333         balances[msg.sender] = senderBalance;
334         balances[_to] = safeAdd(balances[_to], _value);
335         Transfer(msg.sender, _to, _value);
336         return true;
337     }
338 
339     //  Transfer `value` FT tokens from sender 'from'
340     // to provided account address `to`.
341     // @param from The address of the sender
342     // @param to The address of the recipient
343     // @param value The number of FT to transfer
344     // @return Whether the transfer was successful or not
345     function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {
346         //validate _from,_to address and _value(Now allow with 0)
347         require(_from != 0 && _to != 0 && _value > 0);
348         //Check amount is approved by the owner for spender to spent and owner have enough balances
349         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
350         balances[_from] = safeSub(balances[_from],_value);
351         balances[_to] = safeAdd(balances[_to],_value);
352         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
353         Transfer(_from, _to, _value);
354         return true;
355     }
356 
357     //  `msg.sender` approves `spender` to spend `value` tokens
358     // @param spender The address of the account able to transfer the tokens
359     // @param value The amount of wei to be approved for transfer
360     // @return Whether the approval was successful or not
361     function approve(address _spender, uint _value) public returns (bool ok) {
362         //validate _spender address
363         require(_spender != 0);
364         allowed[msg.sender][_spender] = _value;
365         Approval(msg.sender, _spender, _value);
366         return true;
367     }
368 
369 }