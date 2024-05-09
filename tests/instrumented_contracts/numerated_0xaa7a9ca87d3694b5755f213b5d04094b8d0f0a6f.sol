1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38  contract Ownable {
39   address public owner;
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46    function Ownable() public { owner = msg.sender; }
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51    modifier onlyOwner() { require(msg.sender == owner); _; }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58    function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71  contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) public constant returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83  contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     // SafeMath.sub will throw if there is not enough balance.
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public constant returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120  contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public constant returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134  contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167    function approve(address _spender, uint256 _value) public returns (bool) {
168     // mitigating the race condition
169     assert(allowed[msg.sender][_spender] == 0 || _value == 0);
170     
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
183     return allowed[_owner][_spender];
184   }
185 
186   /**
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    */
192    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202       } else {
203         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204       }
205       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206       return true;
207     }
208 
209   }
210 
211 /**
212  * @title Mintable token
213  * @dev Simple ERC20 Token example, with mintable token creation
214  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
215  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
216  */
217 
218  contract MintableToken is StandardToken, Ownable {
219   event Mint(address indexed to, uint256 amount);
220   event MintFinished();
221 
222   bool public mintingFinished = false;
223 
224 
225   modifier canMint() {
226     require(!mintingFinished);
227     _;
228   }
229 
230   /**
231    * @dev Function to mint tokens
232    * @param _to The address that will receive the minted tokens.
233    * @param _amount The amount of tokens to mint.
234    * @return A boolean that indicates if the operation was successful.
235    */
236    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
237     totalSupply = totalSupply.add(_amount);
238     balances[_to] = balances[_to].add(_amount);
239     Mint(_to, _amount);
240     Transfer(0x0, _to, _amount);
241     return true;
242   }
243 
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248    function finishMinting() onlyOwner public returns (bool) {
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 }
254 
255  contract TracToken is MintableToken {
256 
257   string public constant name = 'Trace Token';
258   string public constant symbol = 'TRAC';
259   uint8 public constant decimals = 18; // one TRAC = 10^18 Tracks
260   uint256 public startTime = 1516028400; // initial startTime from tokensale contract
261   uint256 public constant bountyReward = 1e25;
262   uint256 public constant preicoAndAdvisors = 4e25;
263   uint256 public constant liquidityPool = 25e24;
264   uint256 public constant futureDevelopment = 1e26; 
265   uint256 public constant teamAndFounders = 75e24;
266   uint256 public constant CORRECTION = 9605598917469000000000;  // overrun tokens
267 
268   // Notice: Including compensation for the overminting in initial contract for 9605598917469000000000 TRACKs (~9605.6 Trace tokens)
269   uint256[8] public founderAmounts = [uint256( teamAndFounders.div(8).sub(CORRECTION) ),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8)];
270   uint256[2] public preicoAndAdvisorsAmounts = [ uint256(preicoAndAdvisors.mul(2).div(5)),preicoAndAdvisors.mul(2).div(5)];
271 
272   // Withdraw multisig wallet
273   address public wallet;
274 
275   // Withdraw multisig wallet
276   address public teamAndFoundersWallet;
277 
278   // Withdraw multisig wallet
279   address public advisorsAndPreICO;
280   uint256 public TOTAL_NUM_TOKENS = 5e26;
281 
282 
283   function TracToken(address _wallet,address _teamAndFoundersWallet,address _advisorsAndPreICO) public {
284     require(_wallet!=0x0);
285     require(_teamAndFoundersWallet!=0x0);
286     require(_advisorsAndPreICO!=0x0);
287     wallet = _wallet;
288     teamAndFoundersWallet = _teamAndFoundersWallet;
289     advisorsAndPreICO = _advisorsAndPreICO;
290   }
291 
292 
293   event Transfer(address indexed from, address indexed to, uint256 value);
294   event TransferAllowed(bool transferIsAllowed);
295 
296   modifier canTransfer() {
297     require(mintingFinished);
298     _;        
299   }
300 
301   function transferFrom(address from, address to, uint256 value) canTransfer public returns (bool) {
302     return super.transferFrom(from, to, value);
303   }
304 
305   function transfer(address to, uint256 value) canTransfer public returns (bool) {
306     return super.transfer(to, value);
307   }
308 
309   function mint(address contributor, uint256 amount) onlyOwner public returns (bool) {
310     return super.mint(contributor, amount);
311   }
312 
313   function mintMany(address[] contributors, uint256[] amounts) onlyOwner public returns (bool) {
314      address contributor;
315      uint256 amount;
316      require(contributors.length == amounts.length);
317 
318      for (uint i = 0; i < contributors.length; i++) {
319       contributor = contributors[i];
320       amount = amounts[i];
321       require(mint(contributor, amount));
322     }
323     return true;
324   }
325 
326   function endMinting() onlyOwner public returns (bool) {
327     require(!mintingFinished);
328     TransferAllowed(true);
329     return super.finishMinting();
330   }
331 
332   function withdrawTokenToFounders() public {
333   
334     if (now > startTime + 720 days && founderAmounts[7]>0){
335       this.transfer(teamAndFoundersWallet, founderAmounts[7]);
336       founderAmounts[7] = 0;
337     }
338 
339     if (now > startTime + 630 days && founderAmounts[6]>0){
340       this.transfer(teamAndFoundersWallet, founderAmounts[6]);
341       founderAmounts[6] = 0;
342     }
343     if (now > startTime + 540 days && founderAmounts[5]>0){
344       this.transfer(teamAndFoundersWallet, founderAmounts[5]);
345       founderAmounts[5] = 0;
346     }
347     if (now > startTime + 450 days && founderAmounts[4]>0){
348       this.transfer(teamAndFoundersWallet, founderAmounts[4]);
349       founderAmounts[4] = 0;
350     }
351     if (now > startTime + 360 days&& founderAmounts[3]>0){
352       this.transfer(teamAndFoundersWallet, founderAmounts[3]);
353       founderAmounts[3] = 0;
354     }
355     if (now > startTime + 270 days && founderAmounts[2]>0){
356       this.transfer(teamAndFoundersWallet, founderAmounts[2]);
357       founderAmounts[2] = 0;
358     }
359     if (now > startTime + 180 days && founderAmounts[1]>0){
360       this.transfer(teamAndFoundersWallet, founderAmounts[1]);
361       founderAmounts[1] = 0;
362     }
363     if (now > startTime + 90 days && founderAmounts[0]>0){
364       this.transfer(teamAndFoundersWallet, founderAmounts[0]);
365       founderAmounts[0] = 0;
366     }
367   }
368 
369   function withdrawTokensToAdvisors() public {
370     if (now > startTime + 180 days && preicoAndAdvisorsAmounts[1]>0){
371       this.transfer(advisorsAndPreICO, preicoAndAdvisorsAmounts[1]);
372       preicoAndAdvisorsAmounts[1] = 0;
373     }
374 
375     if (now > startTime + 90 days && preicoAndAdvisorsAmounts[0]>0){
376       this.transfer(advisorsAndPreICO, preicoAndAdvisorsAmounts[0]);
377       preicoAndAdvisorsAmounts[0] = 0;
378     }
379   }
380 
381 
382   function allocateRestOfTokens() onlyOwner public{
383     require(totalSupply > TOTAL_NUM_TOKENS.div(2));
384     require(totalSupply < TOTAL_NUM_TOKENS);
385     require(!mintingFinished);
386     mint(wallet, bountyReward);
387     mint(advisorsAndPreICO,  preicoAndAdvisors.div(5));
388     mint(wallet, liquidityPool);
389     mint(wallet, futureDevelopment);
390     mint(this, teamAndFounders.sub(CORRECTION));
391     mint(this, preicoAndAdvisors.mul(4).div(5));
392   }
393 
394 }