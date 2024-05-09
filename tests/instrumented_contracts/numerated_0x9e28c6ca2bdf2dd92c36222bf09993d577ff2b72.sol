1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
77 /*
78  * ERC20 interface
79  * see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 {
82   uint public totalSupply;
83   function balanceOf(address _who) public constant returns (uint);
84   function allowance(address _owner, address _spender) public constant returns (uint);
85 
86   function transfer(address _to, uint _value) public returns (bool ok);
87   function transferFrom(address _from, address _to, uint _value) public returns (bool ok);
88   function approve(address _spender, uint _value) public returns (bool ok);
89   event Transfer(address indexed from, address indexed to, uint value);
90   event Approval(address indexed owner, address indexed spender, uint value);
91 }
92 contract Haltable is Ownable {
93 
94     // @dev To Halt in Emergency Condition
95     bool public halted = false;
96     //empty contructor
97     function Haltable() public {}
98 
99     // @dev Use this as function modifier that should not execute if contract state Halted
100     modifier stopIfHalted {
101       require(!halted);
102       _;
103     }
104 
105     // @dev Use this as function modifier that should execute only if contract state Halted
106     modifier runIfHalted{
107       require(halted);
108       _;
109     }
110 
111     // @dev called by only owner in case of any emergecy situation
112     function halt() onlyOwner stopIfHalted public {
113         halted = true;
114     }
115     // @dev called by only owner to stop the emergency situation
116     function unHalt() onlyOwner runIfHalted public {
117         halted = false;
118     }
119 }
120 
121 contract iCapToken is ERC20,SafeMath,Haltable {
122 
123     //flag to determine if address is for real contract or not
124     bool public isiCapToken = false;
125 
126     //crowdsale start time
127     uint256 public start;
128     //crowdsale end time
129     uint256 public end;
130     //max token supply
131     uint256 public maxTokenSupply = 500000000 ether;
132     //number of tokens per ether purchase
133     uint256 public perEtherTokens = 208;
134     //address of multisig
135     address public multisig;
136     //address of teamIncentive
137     address public unspentWalletAddress;
138     //Is crowdsale finalized
139     bool public isFinalized = false;
140 
141     //Token related information
142     string public constant name = "integratedCAPITAL";
143     string public constant symbol = "iCAP";
144     uint256 public constant decimals = 18; // decimal places
145 
146     //mapping of token balances
147     mapping (address => uint256) balances;
148     //mapping of allowed address for each address with tranfer limit
149     mapping (address => mapping (address => uint256)) allowed;
150     //mapping of allowed address for each address with burnable limit
151     mapping (address => mapping (address => uint256)) allowedToBurn;
152 
153     event Mint(address indexed to, uint256 amount);
154     event Burn(address owner,uint256 _value);
155     event ApproveBurner(address owner, address canBurn, uint256 value);
156     event BurnFrom(address _from,uint256 _value);
157     
158     function iCapToken(uint256 _start,uint256 _end) public {
159         totalSupply = 500000000 ether;
160         balances[msg.sender] = totalSupply;
161         start = safeAdd(now, _start);
162         end = safeAdd(now, _end);
163         isiCapToken = true;
164         emit Transfer(address(0), msg.sender,totalSupply);
165     }
166 
167     //'owner' can set start time of funding
168     // @param _start Starting time of funding
169     function setFundingStartTime(uint256 _start) public stopIfHalted onlyOwner {
170         start = now + _start;
171     }
172 
173     //'owner' can set end time of funding
174     // @param _end Ending time of funding
175     function setFundingEndTime(uint256 _end) public stopIfHalted onlyOwner {
176         end = now + _end;
177     }
178 
179     //'owner' can set number of tokens per Ether
180     // @param _perEtherTokens Tokens per Ether in funding
181     function setPerEtherTokens(uint256 _perEtherTokens) public onlyOwner {
182         perEtherTokens = _perEtherTokens;
183     }
184 
185     //Owner can Set Multisig wallet
186     //@ param _multisig address of Multisig wallet.
187     function setMultisigWallet(address _multisig) onlyOwner public {
188         require(_multisig != 0);
189         multisig = _multisig;
190     }
191 
192     //Owner can Set unspent wallet address
193     //@ param _unspentWalletAddress address of unspent wallet.
194     function setUnspentWalletAddress(address _unspentWalletAddress) onlyOwner public {
195         require(_unspentWalletAddress != 0);
196         unspentWalletAddress = _unspentWalletAddress;
197     }
198 
199     //fallback function to accept ethers
200     function() payable stopIfHalted public {
201         //Check crowdsale is running or not
202         require(now >= start && now <= end);
203         //not allow to invest with less then 0.
204         require(msg.value > 0);
205         //Unspent wallet needed to be configured
206         require(unspentWalletAddress != address(0));
207 
208         //Calculate tokens
209         uint256 calculatedTokens = safeMul(msg.value, perEtherTokens);
210 
211         //Check tokens available to assign
212         require(calculatedTokens < balances[unspentWalletAddress]);
213 
214         //call internal method to assign tokens
215         assignTokens(msg.sender, calculatedTokens);
216     }
217 
218     // Function will transfer the tokens to investor's address
219     // Common function code for Early Investor and Crowdsale Investor
220     function assignTokens(address investor, uint256 tokens) internal {
221         // Debit tokens from unspent wallet
222         balances[unspentWalletAddress] = safeSub(balances[unspentWalletAddress], tokens);
223 
224         // Assign tokens to the sender
225         balances[investor] = safeAdd(balances[investor], tokens);
226 
227         // Finally token transfered to investor, log the creation event
228         Transfer(unspentWalletAddress, investor, tokens);
229     }
230 
231     //Finalize crowdsale
232     function finalize() onlyOwner public {
233         // Finalize after crowdsale end
234         require(now > end);
235         // Check already finalized and multisig set or not
236         require(!isFinalized && multisig != address(0));
237         // Set crowdsale finalized to true
238         isFinalized = true;
239         require(multisig.send(address(this).balance));
240     }
241 
242     // @param _who The address of the investor to check balance
243     // @return balance tokens of investor address
244     function balanceOf(address _who) public constant returns (uint) {
245         return balances[_who];
246     }
247 
248     // @param _owner The address of the account owning tokens
249     // @param _spender The address of the account able to transfer the tokens
250     // @return Amount of remaining tokens allowed to spent
251     function allowance(address _owner, address _spender) public constant returns (uint) {
252         return allowed[_owner][_spender];
253     }
254 
255     // @param _owner The address of the account owning tokens
256     // @param _spender The address of the account able to transfer the tokens
257     // @return Amount of remaining tokens allowed to spent
258     function allowanceToBurn(address _owner, address _spender) public constant returns (uint) {
259         return allowedToBurn[_owner][_spender];
260     }
261 
262     //  Transfer `value` iCap tokens from sender's account
263     // `msg.sender` to provided account address `to`.
264     // @param _to The address of the recipient
265     // @param _value The number of iCap tokens to transfer
266     // @return Whether the transfer was successful or not
267     function transfer(address _to, uint _value) public returns (bool ok) {
268         //validate receiver address and value.Not allow 0 value
269         require(_to != 0 && _value > 0);
270         uint256 senderBalance = balances[msg.sender];
271         //Check sender have enough balance
272         require(senderBalance >= _value);
273         senderBalance = safeSub(senderBalance, _value);
274         balances[msg.sender] = senderBalance;
275         balances[_to] = safeAdd(balances[_to],_value);
276         Transfer(msg.sender, _to, _value);
277         return true;
278     }
279 
280     //  Transfer `value` iCap tokens from sender 'from'
281     // to provided account address `to`.
282     // @param from The address of the sender
283     // @param to The address of the recipient
284     // @param value The number of iCap to transfer
285     // @return Whether the transfer was successful or not
286     function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {
287         //validate _from,_to address and _value(Not allow with 0)
288         require(_from != 0 && _to != 0 && _value > 0);
289         //Check amount is approved by the owner for spender to spent and owner have enough balances
290         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
291         balances[_from] = safeSub(balances[_from],_value);
292         balances[_to] = safeAdd(balances[_to],_value);
293         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
294         Transfer(_from, _to, _value);
295         return true;
296     }
297 
298     //  `msg.sender` approves `spender` to spend `value` tokens
299     // @param spender The address of the account able to transfer the tokens
300     // @param value The amount of wei to be approved for transfer
301     // @return Whether the approval was successful or not
302     function approve(address _spender, uint _value) public returns (bool ok) {
303         //validate _spender address
304         require(_spender != 0);
305         allowed[msg.sender][_spender] = _value;
306         Approval(msg.sender, _spender, _value);
307         return true;
308     }
309 
310     //  Mint `amount` iCap tokens
311     // `msg.sender` to provided account and amount.
312     // @param _account The address of the mint token recipient
313     // @param _amount The number of iCap tokens to mint
314     // @return Whether the Mint was successful or not
315     function mint(address _account, uint256 _amount) public onlyOwner stopIfHalted returns (bool ok) {
316         require(_account != 0);
317         totalSupply = safeAdd(totalSupply,_amount);
318         balances[_account] = safeAdd(balances[_account],_amount);
319         emit Mint(_account, _amount);
320         emit Transfer(address(0), _account, _amount);
321         return true;
322     }
323 
324     //  `msg.sender` approves `_canBurn` to burn `value` tokens
325     // @param _canBurn The address of the account able to burn the tokens
326     // @param _value The amount of wei to be approved for burn
327     // @return Whether the approval was successful or not
328     function approveForBurn(address _canBurn, uint _value) public returns (bool ok) {
329         //validate _spender address
330         require(_canBurn != 0);
331         allowedToBurn[msg.sender][_canBurn] = _value;
332         ApproveBurner(msg.sender, _canBurn, _value);
333         return true;
334     }
335 
336     //  Burn `value` iCap tokens from sender's account
337     // `msg.sender` to provided _value.
338     // @param _value The number of iCap tokens to destroy
339     // @return Whether the Burn was successful or not
340     function burn(uint _value) public returns (bool ok) {
341         //validate receiver address and value.Now allow 0 value
342         require(_value > 0);
343         uint256 senderBalance = balances[msg.sender];
344         require(senderBalance >= _value);
345         senderBalance = safeSub(senderBalance, _value);
346         balances[msg.sender] = senderBalance;
347         totalSupply = safeSub(totalSupply,_value);
348         Burn(msg.sender, _value);
349         return true;
350     }
351 
352     //  Burn `value` iCap tokens from sender 'from'
353     // to provided account address `to`.
354     // @param from The address of the burner
355     // @param to The address of the token holder from token to burn
356     // @param value The number of iCap to burn
357     // @return Whether the transfer was successful or not
358     function burnFrom(address _from, uint _value) public returns (bool ok) {
359         //validate _from,_to address and _value(Now allow with 0)
360         require(_from != 0 && _value > 0);
361         //Check amount is approved by the owner to burn and owner have enough balances
362         require(allowedToBurn[_from][msg.sender] >= _value && balances[_from] >= _value);
363         balances[_from] = safeSub(balances[_from],_value);
364         totalSupply = safeSub(totalSupply,_value);
365         allowedToBurn[_from][msg.sender] = safeSub(allowedToBurn[_from][msg.sender],_value);
366         BurnFrom(_from, _value);
367         return true;
368     }
369 }