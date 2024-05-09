1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 // ================= ERC20 Token Contract start =========================
50 /*
51  * ERC20 interface
52  * see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 {
55   uint public totalSupply;
56   function balanceOf(address who) public constant returns (uint);
57   function allowance(address owner, address spender) public constant returns (uint);
58 
59   function transfer(address to, uint value) public returns (bool status);
60   function transferFrom(address from, address to, uint value) public returns (bool status);
61   function approve(address spender, uint value) public returns (bool status);
62   event Transfer(address indexed from, address indexed to, uint value);
63   event Approval(address indexed owner, address indexed spender, uint value);
64 }
65 
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipRenounced(address indexed previousOwner);
77   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     emit OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106   /**
107    * @dev Allows the current owner to relinquish control of the contract.
108    */
109   function renounceOwnership() public onlyOwner {
110     emit OwnershipRenounced(owner);
111     owner = address(0);
112   }
113 }
114 
115 
116 
117 
118 
119 
120 
121 
122 /**
123  * @title Pausable
124  * @dev Base contract which allows children to implement an emergency stop mechanism.
125  */
126 contract Pausable is Ownable {
127   event Pause();
128   event Unpause();
129 
130   bool public paused = false;
131 
132 
133   /**
134    * @dev Modifier to make a function callable only when the contract is not paused.
135    */
136   modifier whenNotPaused() {
137     require(!paused);
138     _;
139   }
140 
141   /**
142    * @dev Modifier to make a function callable only when the contract is paused.
143    */
144   modifier whenPaused() {
145     require(paused);
146     _;
147   }
148 
149   /**
150    * @dev called by the owner to pause, triggers stopped state
151    */
152   function pause() onlyOwner whenNotPaused public {
153     paused = true;
154     emit Pause();
155   }
156 
157   /**
158    * @dev called by the owner to unpause, returns to normal state
159    */
160   function unpause() onlyOwner whenPaused public {
161     paused = false;
162     emit Unpause();
163   }
164 }
165 
166 
167 
168 
169 
170 
171 
172 
173 contract StandardToken is ERC20{
174   
175    /*Define SafeMath library here for uint256*/
176    
177    using SafeMath for uint256; 
178        
179   /**
180   * @dev Fix for the ERC20 short address attack.
181    */
182   modifier onlyPayloadSize(uint size) {
183     require(msg.data.length >= size + 4) ;
184     _;
185   }
186 
187   mapping(address => uint) accountBalances;
188   mapping (address => mapping (address => uint)) allowed;
189 
190   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32)  returns (bool success){
191     accountBalances[msg.sender] = accountBalances[msg.sender].sub(_value);
192     accountBalances[_to] = accountBalances[_to].add(_value);
193     emit Transfer(msg.sender, _to, _value);
194     return true;
195   }
196 
197   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool success) {
198     uint _allowance = allowed[_from][msg.sender];
199 
200     accountBalances[_to] = accountBalances[_to].add(_value);
201     accountBalances[_from] = accountBalances[_from].sub(_value);
202     allowed[_from][msg.sender] = _allowance.sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   function balanceOf(address _owner) public constant returns (uint balance) {
208     return accountBalances[_owner];
209   }
210 
211   function approve(address _spender, uint _value) public returns (bool success) {
212     allowed[msg.sender][_spender] = _value;
213     emit Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
218     return allowed[_owner][_spender];
219   }
220 }
221 
222 
223 
224 contract IcoToken is StandardToken, Pausable{
225     /*define SafeMath library for uint256*/
226     using SafeMath for uint256;
227     
228     string public name;
229     string public symbol;
230     string public version;
231     uint public decimals;
232     address public icoSaleDeposit;
233     address public icoContract;
234     
235     constructor(string _name, string _symbol, uint256 _decimals, string _version) public {
236         name = _name;
237         symbol = _symbol;
238         decimals = _decimals;
239         version = _version;
240     }
241     
242     function transfer(address _to, uint _value) public whenNotPaused returns (bool success) {
243         return super.transfer(_to,_value);
244     }
245     
246     function approve(address _spender, uint _value) public whenNotPaused returns (bool success) {
247         return super.approve(_spender,_value);
248     }
249     
250     function balanceOf(address _owner) public view returns (uint balance){
251         return super.balanceOf(_owner);
252     }
253     
254     function setIcoContract(address _icoContract) public onlyOwner {
255         if(_icoContract != address(0)){
256             icoContract = _icoContract;           
257         }
258     }
259     
260     function sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success){
261         assert(_value > 0);
262         require(msg.sender == icoContract);
263         
264         accountBalances[_recipient] = accountBalances[_recipient].add(_value);
265         totalSupply = totalSupply.add(_value);
266         
267         emit Transfer(0x0,owner,_value);
268         emit Transfer(owner,_recipient,_value);
269         return true;
270     }
271     
272 }    
273 
274 contract IcoContract is Pausable{
275     /*define SafeMath library for uint256*/
276     using SafeMath for uint256;
277     IcoToken public ico ;
278     uint256 public tokenCreationCap;
279     uint256 public totalSupply;
280     uint256 public fundingStartTime;
281     uint256 public fundingEndTime;
282     uint256 public minContribution;
283     uint256 public tokenExchangeRate;
284     
285     address public ethFundDeposit;
286     address public icoAddress;
287     
288     bool public isFinalized;
289     
290     event LogCreateICO(address from, address to, uint256 val);
291     
292     function CreateIco(address to, uint256 val) internal returns (bool success) {
293         emit LogCreateICO(0x0,to,val);
294         return ico.sell(to,val);/*call to IcoToken sell() method*/
295     }
296     
297     constructor(address _ethFundDeposit,
298                 address _icoAddress,
299                 uint256 _tokenCreationCap,
300                 uint256 _tokenExchangeRate,
301                 uint256 _fundingStartTime,
302                 uint256 _fundingEndTime,
303                 uint256 _minContribution) public {
304         ethFundDeposit = _ethFundDeposit;
305         icoAddress = _icoAddress;
306         tokenCreationCap = _tokenCreationCap;
307         tokenExchangeRate = _tokenExchangeRate;
308         fundingStartTime = _fundingStartTime;
309         minContribution = _minContribution;
310         fundingEndTime = _fundingEndTime;
311         ico = IcoToken(icoAddress);
312         isFinalized = false;
313     }
314     
315     /*call fallback method*/
316     function () public payable{
317         createTokens(msg.sender,msg.value);
318     }
319     
320     function createTokens(address _beneficiary,uint256 _value) internal whenNotPaused {
321         require(tokenCreationCap > totalSupply);
322         require(now >= fundingStartTime);
323         require(now <= fundingEndTime);
324         require(_value >= minContribution);
325         require(!isFinalized);
326         
327         uint256 tokens = _value.mul(tokenExchangeRate);
328         uint256 checkSupply = totalSupply.add(tokens);
329         
330         if(tokenCreationCap < checkSupply){
331             uint256 tokenToAllocate = tokenCreationCap.sub(totalSupply);
332             uint256 tokenToRefund = tokens.sub(tokenToAllocate);
333             uint256 etherToRefund = tokenToRefund / tokenExchangeRate;
334             totalSupply = tokenCreationCap;
335             
336             require(CreateIco(_beneficiary,tokenToAllocate));
337             msg.sender.transfer(etherToRefund);
338             ethFundDeposit.transfer(address(this).balance);
339             return;
340         }
341         
342         totalSupply = checkSupply;
343         require(CreateIco(_beneficiary,tokens));
344         ethFundDeposit.transfer(address(this).balance);
345     }
346     
347     function finalize() external onlyOwner{
348         require(!isFinalized);
349         isFinalized = true;
350         ethFundDeposit.transfer(address(this).balance);
351     }
352 }