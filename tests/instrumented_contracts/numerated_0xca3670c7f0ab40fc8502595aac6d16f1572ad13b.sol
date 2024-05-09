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
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 contract SafeMath {
65   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
66     if (a == 0) {
67       return 0;
68     }
69     uint256 c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
75     // assert(b > 0); // Solidity automatically throws when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78     return c;
79   }
80 
81   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 contract ITToken is ERC20, Ownable, SafeMath {
94 
95     // Token related informations
96     string public constant name = "INFINITY TRAVEL TOKEN";
97     string public constant symbol = "ITT";
98     uint256 public constant decimals = 18; // decimal places
99 
100     // Start withdraw of tokens
101     uint256 public startWithdraw;
102 
103     // MultiSig Wallet Address
104     address public ITTMultisig;
105 
106     // Address of wallet from which tokens assigned
107     address public ethExchangeWallet;
108 
109     uint256 public tokensPerEther = 1000;
110 
111     bool public startStop = false;
112 
113     mapping (address => uint256) public walletAngelPESales;
114     mapping (address => uint256) public walletFoundingInitiatorSales;
115 
116     mapping (address => uint256) public releasedAngelPESales;
117     mapping (address => uint256) public releasedFoundingInitiatorSales;
118 
119     mapping (uint => address) public walletAddresses;
120 
121     // Mapping of token balance and allowed address for each address with transfer limit
122     mapping (address => uint256) balances;
123     //mapping of allowed address for each address with tranfer limit
124     mapping (address => mapping (address => uint256)) allowed;
125 
126     function ITToken() public {
127         totalSupply = 500000000 ether;
128         balances[msg.sender] = totalSupply;
129     }
130 
131     // Only to be called by Owner of this contract
132     // @param _id Id of lock wallet address
133     // @param _walletAddress Address of lock wallet
134     function addWalletAddresses(uint _id, address _walletAddress) onlyOwner external{
135         require(_walletAddress != address(0));
136         walletAddresses[_id] = _walletAddress;
137     }
138 
139     // Owner can Set Multisig wallet
140     // @param _ittMultisig address of Multisig wallet.
141     function setITTMultiSig(address _ittMultisig) onlyOwner external{
142         require(_ittMultisig != address(0));
143         ITTMultisig = _ittMultisig;
144     }
145 
146     // Only to be called by Owner of this contract
147     // @param _ethExchangeWallet Ether Address of exchange wallet
148     function setEthExchangeWallet(address _ethExchangeWallet) onlyOwner external {
149         require(_ethExchangeWallet != address(0));
150         ethExchangeWallet = _ethExchangeWallet;
151     }
152 
153     // Only to be called by Owner of this contract
154     // @param _tokensPerEther Tokens per ether during ICO stages
155     function setTokensPerEther(uint256 _tokensPerEther) onlyOwner external {
156         require(_tokensPerEther > 0);
157         tokensPerEther = _tokensPerEther;
158     }
159 
160     function startStopICO(bool status) onlyOwner external {
161         startStop = status;
162     }
163 
164     function startLockingPeriod() onlyOwner external {
165         startWithdraw = now;
166     }
167 
168     // Assign tokens to investor with locking period
169     function assignToken(address _investor,uint256 _tokens) external {
170         // Tokens assigned by only Angel Sales,PE Sales,Founding Investor and Initiator Team wallets
171         require(msg.sender == walletAddresses[0] || msg.sender == walletAddresses[1] || msg.sender == walletAddresses[2] || msg.sender == walletAddresses[3]);
172 
173         // Check investor address and tokens.Not allow 0 value
174         require(_investor != address(0) && _tokens > 0);
175         // Check wallet have enough token balance to assign
176         require(_tokens <= balances[msg.sender]);
177         
178         // Debit the tokens from the wallet
179         balances[msg.sender] = safeSub(balances[msg.sender],_tokens);
180 
181         // Assign tokens to the investor
182         if(msg.sender == walletAddresses[0] || msg.sender == walletAddresses[1]){
183             walletAngelPESales[_investor] = safeAdd(walletAngelPESales[_investor],_tokens);
184         }
185         else if(msg.sender == walletAddresses[2] || msg.sender == walletAddresses[3]){
186             walletFoundingInitiatorSales[_investor] = safeAdd(walletFoundingInitiatorSales[_investor],_tokens);
187         }
188         else{
189             revert();
190         }
191     }
192 
193     function withdrawTokens() public {
194         require(walletAngelPESales[msg.sender] > 0 || walletFoundingInitiatorSales[msg.sender] > 0);
195         uint256 withdrawableAmount = 0;
196 
197         if (walletAngelPESales[msg.sender] > 0) {
198             uint256 withdrawableAmountANPES = getWithdrawableAmountANPES(msg.sender);
199             walletAngelPESales[msg.sender] = safeSub(walletAngelPESales[msg.sender], withdrawableAmountANPES);
200             releasedAngelPESales[msg.sender] = safeAdd(releasedAngelPESales[msg.sender],withdrawableAmountANPES);
201             withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountANPES);
202         }
203         if (walletFoundingInitiatorSales[msg.sender] > 0) {
204             uint256 withdrawableAmountFIIT = getWithdrawableAmountFIIT(msg.sender);
205             walletFoundingInitiatorSales[msg.sender] = safeSub(walletFoundingInitiatorSales[msg.sender], withdrawableAmountFIIT);
206             releasedFoundingInitiatorSales[msg.sender] = safeAdd(releasedFoundingInitiatorSales[msg.sender], withdrawableAmountFIIT);
207             withdrawableAmount = safeAdd(withdrawableAmount, withdrawableAmountFIIT);
208         }
209         require(withdrawableAmount > 0);
210         // Assign tokens to the sender
211         balances[msg.sender] = safeAdd(balances[msg.sender], withdrawableAmount);
212     }
213 
214     // For wallet Angel Sales and PE Sales
215     function getWithdrawableAmountANPES(address _investor) public view returns(uint256) {
216         require(startWithdraw != 0);
217         // interval in months
218         uint interval = safeDiv(safeSub(now,startWithdraw),30 days);
219         // total allocatedTokens
220         uint _allocatedTokens = safeAdd(walletAngelPESales[_investor],releasedAngelPESales[_investor]);
221         // Atleast 6 months
222         if (interval < 6) { 
223             return (0); 
224         } else if (interval >= 6 && interval < 12) {
225             return safeSub(getPercentageAmount(25,_allocatedTokens), releasedAngelPESales[_investor]);
226         } else if (interval >= 12 && interval < 18) {
227             return safeSub(getPercentageAmount(50,_allocatedTokens), releasedAngelPESales[_investor]);
228         } else if (interval >= 18 && interval < 24) {
229             return safeSub(getPercentageAmount(75,_allocatedTokens), releasedAngelPESales[_investor]);
230         } else if (interval >= 24) {
231             return safeSub(_allocatedTokens, releasedAngelPESales[_investor]);
232         }
233     }
234 
235     // For wallet Founding Investor and Initiator Team
236     function getWithdrawableAmountFIIT(address _investor) public view returns(uint256) {
237         require(startWithdraw != 0);
238         // interval in months
239         uint interval = safeDiv(safeSub(now,startWithdraw),30 days);
240         // total allocatedTokens
241         uint _allocatedTokens = safeAdd(walletFoundingInitiatorSales[_investor],releasedFoundingInitiatorSales[_investor]);
242         // Atleast 24 months
243         if (interval < 24) { 
244             return (0); 
245         } else if (interval >= 24) {
246             return safeSub(_allocatedTokens, releasedFoundingInitiatorSales[_investor]);
247         }
248     }
249 
250     function getPercentageAmount(uint256 percent,uint256 _tokens) internal pure returns (uint256) {
251         return safeDiv(safeMul(_tokens,percent),100);
252     }
253 
254     // Sale of the tokens. Investors can call this method to invest into ITT Tokens
255     function() payable external {
256         // Allow only to invest in ICO stage
257         require(startStop);
258 
259         //Sorry !! We only allow to invest with minimum 0.5 Ether as value
260         require(msg.value >= (0.5 ether));
261 
262         // multiply by exchange rate to get token amount
263         uint256 calculatedTokens = safeMul(msg.value, tokensPerEther);
264 
265         // Wait we check tokens available for assign
266         require(balances[ethExchangeWallet] >= calculatedTokens);
267 
268         // Call to Internal function to assign tokens
269         assignTokens(msg.sender, calculatedTokens);
270     }
271 
272     // Function will transfer the tokens to investor's address
273     // Common function code for assigning tokens
274     function assignTokens(address investor, uint256 tokens) internal {
275         // Debit tokens from ether exchange wallet
276         balances[ethExchangeWallet] = safeSub(balances[ethExchangeWallet], tokens);
277 
278         // Assign tokens to the sender
279         balances[investor] = safeAdd(balances[investor], tokens);
280 
281         // Finally token assigned to sender, log the creation event
282         Transfer(ethExchangeWallet, investor, tokens);
283     }
284 
285     function finalizeCrowdSale() external{
286         // Check ITT Multisig wallet set or not
287         require(ITTMultisig != address(0));
288         // Send fund to multisig wallet
289         require(ITTMultisig.send(address(this).balance));
290     }
291 
292     // @param _who The address of the investor to check balance
293     // @return balance tokens of investor address
294     function balanceOf(address _who) public constant returns (uint) {
295         return balances[_who];
296     }
297 
298     // @param _owner The address of the account owning tokens
299     // @param _spender The address of the account able to transfer the tokens
300     // @return Amount of remaining tokens allowed to spent
301     function allowance(address _owner, address _spender) public constant returns (uint) {
302         return allowed[_owner][_spender];
303     }
304 
305     //  Transfer `value` ITTokens from sender's account
306     // `msg.sender` to provided account address `to`.
307     // @param _to The address of the recipient
308     // @param _value The number of ITTokens to transfer
309     // @return Whether the transfer was successful or not
310     function transfer(address _to, uint _value) public returns (bool ok) {
311         //validate receiver address and value.Not allow 0 value
312         require(_to != 0 && _value > 0);
313         uint256 senderBalance = balances[msg.sender];
314         //Check sender have enough balance
315         require(senderBalance >= _value);
316         senderBalance = safeSub(senderBalance, _value);
317         balances[msg.sender] = senderBalance;
318         balances[_to] = safeAdd(balances[_to], _value);
319         Transfer(msg.sender, _to, _value);
320         return true;
321     }
322 
323     //  Transfer `value` ITTokens from sender 'from'
324     // to provided account address `to`.
325     // @param from The address of the sender
326     // @param to The address of the recipient
327     // @param value The number of ITTokens to transfer
328     // @return Whether the transfer was successful or not
329     function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {
330         //validate _from,_to address and _value(Now allow with 0)
331         require(_from != 0 && _to != 0 && _value > 0);
332         //Check amount is approved by the owner for spender to spent and owner have enough balances
333         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
334         balances[_from] = safeSub(balances[_from],_value);
335         balances[_to] = safeAdd(balances[_to],_value);
336         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
337         Transfer(_from, _to, _value);
338         return true;
339     }
340 
341     //  `msg.sender` approves `spender` to spend `value` tokens
342     // @param spender The address of the account able to transfer the tokens
343     // @param value The amount of wei to be approved for transfer
344     // @return Whether the approval was successful or not
345     function approve(address _spender, uint _value) public returns (bool ok) {
346         //validate _spender address
347         require(_spender != 0);
348         allowed[msg.sender][_spender] = _value;
349         Approval(msg.sender, _spender, _value);
350         return true;
351     }
352 
353 }