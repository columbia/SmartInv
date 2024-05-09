1 pragma solidity ^0.4.20;
2 // ----------------------------------------------------------------------------------------------
3 // KNOW Token by Kryptono Limited.
4 // An ERC223 standard
5 //
6 // author: Kryptono Team
7 // Contact: William@kryptono.exchange
8 
9 library SafeMath {
10 
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15 
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20 
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25 
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 
31 }
32 
33 contract ERC20 {
34     // Get the total token supply
35     function totalSupply() public constant returns (uint256 _totalSupply);
36  
37     // Get the account balance of another account with address _owner
38     function balanceOf(address _owner) public constant returns (uint256 balance);
39  
40     // Send _value amount of tokens to address _to
41     function transfer(address _to, uint256 _value) public returns (bool success);
42     
43     // transfer _value amount of token approved by address _from
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
45     
46     // approve an address with _value amount of tokens
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     // get remaining token approved by _owner to _spender
50     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
51   
52     // Triggered when tokens are transferred.
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54  
55     // Triggered whenever approve(address _spender, uint256 _value) is called.
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 contract ERC223 is ERC20{
60     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
61     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
62     event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);
63 }
64 
65 /// contract receiver interface
66 contract ContractReceiver {  
67     function tokenFallback(address _from, uint _value, bytes _data) external;
68 }
69 
70 contract BasicKNOW is ERC223 {
71     using SafeMath for uint256;
72     
73     uint256 public constant decimals = 10;
74     string public constant symbol = "KNOW";
75     string public constant name = "KNOW";
76     uint256 public _totalSupply = 10 ** 19; // total supply is 10^19 unit, equivalent to 10^9 KNOW
77 
78     // Owner of this contract
79     address public owner;
80 
81     // tradable
82     bool public tradable = false;
83 
84     // Balances KNOW for each account
85     mapping(address => uint256) balances;
86     
87     // Owner of account approves the transfer of an amount to another account
88     mapping(address => mapping (address => uint256)) allowed;
89             
90     /**
91      * Functions with this modifier can only be executed by the owner
92      */
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97 
98     modifier isTradable(){
99         require(tradable == true || msg.sender == owner);
100         _;
101     }
102 
103     /// @dev Constructor
104     function BasicKNOW() 
105     public {
106         owner = msg.sender;
107         balances[owner] = _totalSupply;
108         Transfer(0x0, owner, _totalSupply);
109     }
110     
111     /// @dev Gets totalSupply
112     /// @return Total supply
113     function totalSupply()
114     public 
115     constant 
116     returns (uint256) {
117         return _totalSupply;
118     }
119         
120     /// @dev Gets account's balance
121     /// @param _addr Address of the account
122     /// @return Account balance
123     function balanceOf(address _addr) 
124     public
125     constant 
126     returns (uint256) {
127         return balances[_addr];
128     }
129     
130     
131     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
132     function isContract(address _addr) 
133     private 
134     view 
135     returns (bool is_contract) {
136         uint length;
137         assembly {
138             //retrieve the size of the code on target address, this needs assembly
139             length := extcodesize(_addr)
140         }
141         return (length>0);
142     }
143  
144     /// @dev Transfers the balance from msg.sender to an account
145     /// @param _to Recipient address
146     /// @param _value Transfered amount in unit
147     /// @return Transfer status
148     // Standard function transfer similar to ERC20 transfer with no _data .
149     // Added due to backwards compatibility reasons .
150     function transfer(address _to, uint _value) 
151     public 
152     isTradable
153     returns (bool success) {
154         require(_to != 0x0);
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157 
158         Transfer(msg.sender, _to, _value);
159         return true;
160     }
161     
162     /// @dev Function that is called when a user or another contract wants to transfer funds .
163     /// @param _to Recipient address
164     /// @param _value Transfer amount in unit
165     /// @param _data the data pass to contract reveiver
166     function transfer(
167         address _to, 
168         uint _value, 
169         bytes _data) 
170     public
171     isTradable 
172     returns (bool success) {
173         require(_to != 0x0);
174         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
175         balances[_to] = balanceOf(_to).add(_value);
176         Transfer(msg.sender, _to, _value);
177         if(isContract(_to)) {
178             ContractReceiver receiver = ContractReceiver(_to);
179             receiver.tokenFallback(msg.sender, _value, _data);
180             Transfer(msg.sender, _to, _value, _data);
181         }
182         
183         return true;
184     }
185     
186     /// @dev Function that is called when a user or another contract wants to transfer funds .
187     /// @param _to Recipient address
188     /// @param _value Transfer amount in unit
189     /// @param _data the data pass to contract reveiver
190     /// @param _custom_fallback custom name of fallback function
191     function transfer(
192         address _to, 
193         uint _value, 
194         bytes _data, 
195         string _custom_fallback) 
196     public 
197     isTradable
198     returns (bool success) {
199         require(_to != 0x0);
200         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
201         balances[_to] = balanceOf(_to).add(_value);
202         Transfer(msg.sender, _to, _value);
203 
204         if(isContract(_to)) {
205             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
206             Transfer(msg.sender, _to, _value, _data);
207         }
208         return true;
209     }
210          
211     // Send _value amount of tokens from address _from to address _to
212     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
213     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
214     // fees in sub-currencies; the command should fail unless the _from account has
215     // deliberately authorized the sender of the message via some mechanism; we propose
216     // these standardized APIs for approval:
217     function transferFrom(
218         address _from,
219         address _to,
220         uint256 _value)
221     public
222     isTradable
223     returns (bool success) {
224         require(_to != 0x0);
225         balances[_from] = balances[_from].sub(_value);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227         balances[_to] = balances[_to].add(_value);
228 
229         Transfer(_from, _to, _value);
230         return true;
231     }
232     
233     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
234     // If this function is called again it overwrites the current allowance with _value.
235     function approve(address _spender, uint256 _amount) 
236     public
237     returns (bool success) {
238         allowed[msg.sender][_spender] = _amount;
239         Approval(msg.sender, _spender, _amount);
240         return true;
241     }
242     
243     // get allowance
244     function allowance(address _owner, address _spender) 
245     public
246     constant 
247     returns (uint256 remaining) {
248         return allowed[_owner][_spender];
249     }
250 
251     // withdraw any ERC20 token in this contract to owner
252     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
253         return ERC223(tokenAddress).transfer(owner, tokens);
254     }
255     
256     // allow people can transfer their token
257     // NOTE: can not turn off
258     function turnOnTradable() 
259     public
260     onlyOwner{
261         tradable = true;
262     }
263 }
264 
265 contract KNOW is BasicKNOW {
266 
267     bool public _selling = false;//initial selling
268     
269     uint256 public _originalBuyPrice = 50 * 10**12; // original buy 1ETH = 5000 KNOW = 50 * 10**12 unit
270 
271     // List of approved investors
272     mapping(address => bool) private approvedInvestorList;
273     
274     // deposit
275     mapping(address => uint256) private deposit;
276     
277     // icoPercent
278     uint256 public _icoPercent = 0;
279     
280     // _icoSupply is the avalable unit. Initially, it is _totalSupply
281     uint256 public _icoSupply = (_totalSupply * _icoPercent) / 100;
282     
283     // minimum buy 0.3 ETH
284     uint256 public _minimumBuy = 3 * 10 ** 17;
285     
286     // maximum buy 25 ETH
287     uint256 public _maximumBuy = 25 * 10 ** 18;
288 
289     // totalTokenSold
290     uint256 public totalTokenSold = 0;
291 
292     /**
293      * Functions with this modifier check on sale status
294      * Only allow sale if _selling is on
295      */
296     modifier onSale() {
297         require(_selling);
298         _;
299     }
300     
301     /**
302      * Functions with this modifier check the validity of address is investor
303      */
304     modifier validInvestor() {
305         require(approvedInvestorList[msg.sender]);
306         _;
307     }
308     
309     /**
310      * Functions with this modifier check the validity of msg value
311      * value must greater than equal minimumBuyPrice
312      * total deposit must less than equal maximumBuyPrice
313      */
314     modifier validValue(){
315         // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice
316         require ( (msg.value >= _minimumBuy) &&
317                 ( (deposit[msg.sender].add(msg.value)) <= _maximumBuy) );
318         _;
319     }
320 
321     /// @dev Fallback function allows to buy by ether.
322     function()
323     public
324     payable {
325         buyKNOW();
326     }
327     
328     /// @dev buy function allows to buy ether. for using optional data
329     function buyKNOW()
330     public
331     payable
332     onSale
333     validValue
334     validInvestor {
335         uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;
336         require(balances[owner] >= requestedUnits);
337         // prepare transfer data
338         balances[owner] = balances[owner].sub(requestedUnits);
339         balances[msg.sender] = balances[msg.sender].add(requestedUnits);
340         
341         // increase total deposit amount
342         deposit[msg.sender] = deposit[msg.sender].add(msg.value);
343         
344         // check total and auto turnOffSale
345         totalTokenSold = totalTokenSold.add(requestedUnits);
346         if (totalTokenSold >= _icoSupply){
347             _selling = false;
348         }
349         
350         // submit transfer
351         Transfer(owner, msg.sender, requestedUnits);
352         owner.transfer(msg.value);
353     }
354 
355     /// @dev Constructor
356     function KNOW() BasicKNOW()
357     public {
358         setBuyPrice(_originalBuyPrice);
359     }
360     
361     /// @dev Enables sale 
362     function turnOnSale() onlyOwner 
363     public {
364         _selling = true;
365     }
366 
367     /// @dev Disables sale
368     function turnOffSale() onlyOwner 
369     public {
370         _selling = false;
371     }
372     
373     /// @dev set new icoPercent
374     /// @param newIcoPercent new value of icoPercent
375     function setIcoPercent(uint256 newIcoPercent)
376     public 
377     onlyOwner {
378         _icoPercent = newIcoPercent;
379         _icoSupply = (_totalSupply * _icoPercent) / 100;
380     }
381     
382     /// @dev set new _maximumBuy
383     /// @param newMaximumBuy new value of _maximumBuy
384     function setMaximumBuy(uint256 newMaximumBuy)
385     public 
386     onlyOwner {
387         _maximumBuy = newMaximumBuy;
388     }
389 
390     /// @dev Updates buy price (owner ONLY)
391     /// @param newBuyPrice New buy price (in UNIT) 1ETH <=> 10 000 0000000000 unit
392     function setBuyPrice(uint256 newBuyPrice) 
393     onlyOwner 
394     public {
395         require(newBuyPrice>0);
396         _originalBuyPrice = newBuyPrice; // unit
397         // control _maximumBuy_USD = 10,000 USD, KNOW price is 0.1USD
398         // maximumBuy_KNOW = 100,000 KNOW = 100,000,0000000000 unit = 10^15
399         _maximumBuy = (10**18 * 10**15) /_originalBuyPrice;
400     }
401     
402     /// @dev check address is approved investor
403     /// @param _addr address
404     function isApprovedInvestor(address _addr)
405     public
406     constant
407     returns (bool) {
408         return approvedInvestorList[_addr];
409     }
410     
411     /// @dev get ETH deposit
412     /// @param _addr address get deposit
413     /// @return amount deposit of an buyer
414     function getDeposit(address _addr)
415     public
416     constant
417     returns(uint256){
418         return deposit[_addr];
419 }
420     
421     /// @dev Adds list of new investors to the investors list and approve all
422     /// @param newInvestorList Array of new investors addresses to be added
423     function addInvestorList(address[] newInvestorList)
424     onlyOwner
425     public {
426         for (uint256 i = 0; i < newInvestorList.length; i++){
427             approvedInvestorList[newInvestorList[i]] = true;
428         }
429     }
430 
431     /// @dev Removes list of investors from list
432     /// @param investorList Array of addresses of investors to be removed
433     function removeInvestorList(address[] investorList)
434     onlyOwner
435     public {
436         for (uint256 i = 0; i < investorList.length; i++){
437             approvedInvestorList[investorList[i]] = false;
438         }
439     }
440     
441     /// @dev Withdraws Ether in contract (Owner only)
442     /// @return Status of withdrawal
443     function withdraw() onlyOwner 
444     public 
445     returns (bool) {
446         return owner.send(this.balance);
447     }
448 }