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
94 contract VLToken is ERC20, Ownable, SafeMath {
95 
96     // Token related informations
97     string public constant name = "Villiam Blockchain Token";
98     string public constant symbol = "VLT";
99     uint256 public constant decimals = 18; // decimal places
100 
101     // Start withdraw of tokens
102     uint256 public startWithdraw;
103 
104     // Address of wallet from which tokens assigned
105     address public ethExchangeWallet;
106 
107     // MultiSig Wallet Address
108     address public VLTMultisig;
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
127     function VLToken() public {
128         totalSupply = 500000000 ether;
129         balances[msg.sender] = totalSupply;
130     }
131 
132     // Only to be called by Owner of this contract
133     // @param _id Id of lock wallet address
134     // @param _walletAddress Address of lock wallet
135     function addWalletAddresses(uint _id, address _walletAddress) onlyOwner external{
136         require(_walletAddress != address(0));
137         walletAddresses[_id] = _walletAddress;
138     }
139 
140     // Owner can Set Multisig wallet
141     // @param _vltMultisig address of Multisig wallet.
142     function setVLTMultiSig(address _vltMultisig) onlyOwner external{
143         require(_vltMultisig != address(0));
144         VLTMultisig = _vltMultisig;
145     }
146 
147     // Only to be called by Owner of this contract
148     // @param _ethExchangeWallet Ether Address of exchange wallet
149     function setEthExchangeWallet(address _ethExchangeWallet) onlyOwner external {
150         require(_ethExchangeWallet != address(0));
151         ethExchangeWallet = _ethExchangeWallet;
152     }
153 
154     // Only to be called by Owner of this contract
155     // @param _tokensPerEther Tokens per ether during ICO stages
156     function setTokensPerEther(uint256 _tokensPerEther) onlyOwner external {
157         require(_tokensPerEther > 0);
158         tokensPerEther = _tokensPerEther;
159     }
160 
161     function startStopICO(bool status) onlyOwner external {
162         startStop = status;
163     }
164 
165     function startLockingPeriod() onlyOwner external {
166         startWithdraw = now;
167     }
168 
169     // Assign tokens to investor with locking period
170     function assignToken(address _investor,uint256 _tokens) external {
171         // Tokens assigned by only Angel Sales And PE Sales wallets
172         require(msg.sender == walletAddresses[0] || msg.sender == walletAddresses[1]);
173 
174         // Check investor address and tokens.Not allow 0 value
175         require(_investor != address(0) && _tokens > 0);
176         // Check wallet have enough token balance to assign
177         require(_tokens <= balances[msg.sender]);
178         
179         // Debit the tokens from the wallet
180         balances[msg.sender] = safeSub(balances[msg.sender],_tokens);
181 
182         uint256 calCurrentTokens = getPercentageAmount(_tokens, 20);
183         uint256 allocateTokens = safeSub(_tokens, calCurrentTokens);
184 
185         // Initially assign 20% tokens to the investor
186         balances[_investor] = safeAdd(balances[_investor], calCurrentTokens);
187 
188         // Assign tokens to the investor
189         if(msg.sender == walletAddresses[0]){
190             walletAngelSales[_investor] = safeAdd(walletAngelSales[_investor],allocateTokens);
191             releasedAngelSales[_investor] = safeAdd(releasedAngelSales[_investor], calCurrentTokens);
192         }
193         else if(msg.sender == walletAddresses[1]){
194             walletPESales[_investor] = safeAdd(walletPESales[_investor],allocateTokens);
195             releasedPESales[_investor] = safeAdd(releasedPESales[_investor], calCurrentTokens);
196         }
197         else{
198             revert();
199         }
200     }
201 
202     function withdrawTokens() public {
203         require(walletAngelSales[msg.sender] > 0 || walletPESales[msg.sender] > 0);
204         uint256 withdrawableAmount = 0;
205 
206         if (walletAngelSales[msg.sender] > 0) {
207             uint256 withdrawableAmountAS = getWithdrawableAmountAS(msg.sender);
208             walletAngelSales[msg.sender] = safeSub(walletAngelSales[msg.sender], withdrawableAmountAS);
209             releasedAngelSales[msg.sender] = safeAdd(releasedAngelSales[msg.sender],withdrawableAmountAS);
210             withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountAS);
211         }
212         if (walletPESales[msg.sender] > 0) {
213             uint256 withdrawableAmountPS = getWithdrawableAmountPES(msg.sender);
214             walletPESales[msg.sender] = safeSub(walletPESales[msg.sender], withdrawableAmountPS);
215             releasedPESales[msg.sender] = safeAdd(releasedPESales[msg.sender], withdrawableAmountPS);
216             withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountPS);
217         }
218         require(withdrawableAmount > 0);
219         // Assign tokens to the sender
220         balances[msg.sender] = safeAdd(balances[msg.sender], withdrawableAmount);
221     }
222 
223     // For wallet Angel Sales
224     function getWithdrawableAmountAS(address _investor) public view returns(uint256) {
225         require(startWithdraw != 0);
226         // interval in months
227         uint interval = safeDiv(safeSub(now,startWithdraw),30 days);
228         // total allocatedTokens
229         uint _allocatedTokens = safeAdd(walletAngelSales[_investor],releasedAngelSales[_investor]);
230         // Atleast 6 months
231         if (interval < 6) { 
232             return (0); 
233         } else if (interval >= 6 && interval < 9) {
234             return safeSub(getPercentageAmount(40,_allocatedTokens), releasedAngelSales[_investor]);
235         } else if (interval >= 9 && interval < 12) {
236             return safeSub(getPercentageAmount(60,_allocatedTokens), releasedAngelSales[_investor]);
237         } else if (interval >= 12 && interval < 15) {
238             return safeSub(getPercentageAmount(80,_allocatedTokens), releasedAngelSales[_investor]);
239         } else if (interval >= 15) {
240             return safeSub(_allocatedTokens, releasedAngelSales[_investor]);
241         }
242     }
243 
244     // For wallet PE Sales
245     function getWithdrawableAmountPES(address _investor) public view returns(uint256) {
246         require(startWithdraw != 0);
247         // interval in months
248         uint interval = safeDiv(safeSub(now,startWithdraw),30 days);
249         // total allocatedTokens
250         uint _allocatedTokens = safeAdd(walletPESales[_investor],releasedPESales[_investor]);
251         // Atleast 12 months
252         if (interval < 12) { 
253             return (0); 
254         } else if (interval >= 12 && interval < 18) {
255             return safeSub(getPercentageAmount(40,_allocatedTokens), releasedPESales[_investor]);
256         } else if (interval >= 18 && interval < 24) {
257             return safeSub(getPercentageAmount(60,_allocatedTokens), releasedPESales[_investor]);
258         } else if (interval >= 24 && interval < 30) {
259             return safeSub(getPercentageAmount(80,_allocatedTokens), releasedPESales[_investor]);
260         } else if (interval >= 30) {
261             return safeSub(_allocatedTokens, releasedPESales[_investor]);
262         }
263     }
264 
265     function getPercentageAmount(uint256 percent,uint256 _tokens) internal pure returns (uint256) {
266         return safeDiv(safeMul(_tokens,percent),100);
267     }
268 
269     // Sale of the tokens. Investors can call this method to invest into VLT Tokens
270     function() payable external {
271         // Allow only to invest in ICO stage
272         require(startStop);
273 
274         //Sorry !! We only allow to invest with minimum 0.5 Ether as value
275         require(msg.value >= (0.5 ether));
276 
277         // multiply by exchange rate to get token amount
278         uint256 calculatedTokens = safeMul(msg.value, tokensPerEther);
279 
280         // Wait we check tokens available for assign
281         require(balances[ethExchangeWallet] >= calculatedTokens);
282 
283         // Call to Internal function to assign tokens
284         assignTokens(msg.sender, calculatedTokens);
285     }
286 
287     // Function will transfer the tokens to investor's address
288     // Common function code for assigning tokens
289     function assignTokens(address investor, uint256 tokens) internal {
290         // Debit tokens from ether exchange wallet
291         balances[ethExchangeWallet] = safeSub(balances[ethExchangeWallet], tokens);
292 
293         // Assign tokens to the sender
294         balances[investor] = safeAdd(balances[investor], tokens);
295 
296         // Finally token assigned to sender, log the creation event
297         Transfer(ethExchangeWallet, investor, tokens);
298     }
299 
300     function finalizeCrowdSale() external{
301         // Check VLT Multisig wallet set or not
302         require(VLTMultisig != address(0));
303         // Send fund to multisig wallet
304         require(VLTMultisig.send(address(this).balance));
305     }
306 
307     // @param _who The address of the investor to check balance
308     // @return balance tokens of investor address
309     function balanceOf(address _who) public constant returns (uint) {
310         return balances[_who];
311     }
312 
313     // @param _owner The address of the account owning tokens
314     // @param _spender The address of the account able to transfer the tokens
315     // @return Amount of remaining tokens allowed to spent
316     function allowance(address _owner, address _spender) public constant returns (uint) {
317         return allowed[_owner][_spender];
318     }
319 
320     //  Transfer `value` VLT tokens from sender's account
321     // `msg.sender` to provided account address `to`.
322     // @param _to The address of the recipient
323     // @param _value The number of VLT tokens to transfer
324     // @return Whether the transfer was successful or not
325     function transfer(address _to, uint _value) public returns (bool ok) {
326         //validate receiver address and value.Not allow 0 value
327         require(_to != 0 && _value > 0);
328         uint256 senderBalance = balances[msg.sender];
329         //Check sender have enough balance
330         require(senderBalance >= _value);
331         senderBalance = safeSub(senderBalance, _value);
332         balances[msg.sender] = senderBalance;
333         balances[_to] = safeAdd(balances[_to], _value);
334         Transfer(msg.sender, _to, _value);
335         return true;
336     }
337 
338     //  Transfer `value` VLT tokens from sender 'from'
339     // to provided account address `to`.
340     // @param from The address of the sender
341     // @param to The address of the recipient
342     // @param value The number of VLT to transfer
343     // @return Whether the transfer was successful or not
344     function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {
345         //validate _from,_to address and _value(Now allow with 0)
346         require(_from != 0 && _to != 0 && _value > 0);
347         //Check amount is approved by the owner for spender to spent and owner have enough balances
348         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
349         balances[_from] = safeSub(balances[_from],_value);
350         balances[_to] = safeAdd(balances[_to],_value);
351         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
352         Transfer(_from, _to, _value);
353         return true;
354     }
355 
356     //  `msg.sender` approves `spender` to spend `value` tokens
357     // @param spender The address of the account able to transfer the tokens
358     // @param value The amount of wei to be approved for transfer
359     // @return Whether the approval was successful or not
360     function approve(address _spender, uint _value) public returns (bool ok) {
361         //validate _spender address
362         require(_spender != 0);
363         allowed[msg.sender][_spender] = _value;
364         Approval(msg.sender, _spender, _value);
365         return true;
366     }
367 
368 }