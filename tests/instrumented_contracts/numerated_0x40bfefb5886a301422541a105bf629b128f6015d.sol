1 pragma solidity ^0.4.15;
2 
3 //EKN: deploy with Current version:0.4.16+commit.d7661dd9.Emscripten.clang
4 
5 // ================= Ownable Contract start =============================
6 /*
7  * Ownable
8  *
9  * Base contract with an owner.
10  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
11  */
12 contract Ownable {
13   address public owner;
14 
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   function transferOwnership(address newOwner) onlyOwner {
25     if (newOwner != address(0)) {
26       owner = newOwner;
27     }
28   }
29 }
30 
31 contract SafeMath {
32 
33   function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
34     uint256 z = x + y;
35     assert((z >= x) && (z >= y));
36     return z;
37   }
38 
39   function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
40     assert(x >= y);
41     uint256 z = x - y;
42     return z;
43   }
44 
45   function safeMult(uint256 x, uint256 y) internal returns(uint256) {
46     uint256 z = x * y;
47     assert((x == 0)||(z/x == y));
48     return z;
49   }
50 }
51 
52 /*
53  * ERC20 interface
54  * see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 {
57   uint public totalSupply;
58   function balanceOf(address who) constant returns (uint);
59   function allowance(address owner, address spender) constant returns (uint);
60 
61   function transfer(address to, uint value) returns (bool ok);
62   function transferFrom(address from, address to, uint value) returns (bool ok);
63   function approve(address spender, uint value) returns (bool ok);
64   event Transfer(address indexed from, address indexed to, uint value);
65   event Approval(address indexed owner, address indexed spender, uint value);
66 }
67 
68 contract StandardToken is ERC20, SafeMath {
69 
70   /**
71   * @dev Fix for the ERC20 short address attack.
72    */
73   modifier onlyPayloadSize(uint size) {
74     require(msg.data.length >= size + 4) ;
75     _;
76   }
77 
78   mapping(address => uint) balances;
79   mapping (address => mapping (address => uint)) allowed;
80 
81   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){
82     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
83     balances[_to] = safeAdd(balances[_to], _value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
89     var _allowance = allowed[_from][msg.sender];
90 
91     balances[_to] = safeAdd(balances[_to], _value);
92     balances[_from] = safeSubtract(balances[_from], _value);
93     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   function balanceOf(address _owner) constant returns (uint balance) {
99     return balances[_owner];
100   }
101 
102   function approve(address _spender, uint _value) returns (bool success) {
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) constant returns (uint remaining) {
109     return allowed[_owner][_spender];
110   }
111 }
112 
113 /**
114  * @title Pausable
115  * @dev Base contract which allows children to implement an emergency stop mechanism.
116  */
117 contract Pausable is Ownable {
118   event Pause();
119   event Unpause();
120 
121   bool public paused = false;
122 
123   /**
124   * @dev modifier to allow actions only when the contract IS paused
125   */
126   modifier whenNotPaused() {
127     require (!paused);
128     _;
129   }
130 
131   /**
132   * @dev modifier to allow actions only when the contract IS NOT paused
133   */
134   modifier whenPaused {
135     require (paused) ;
136     _;
137   }
138 
139   /**
140   * @dev called by the owner to pause, triggers stopped state
141   */
142   function pause() onlyOwner whenNotPaused returns (bool) {
143     paused = true;
144     Pause();
145     return true;
146   }
147 
148   /**
149   * @dev called by the owner to unpause, returns to normal state
150   */
151   function unpause() onlyOwner whenPaused returns (bool) {
152     paused = false;
153     Unpause();
154     return true;
155   }
156 }
157 
158 // ================= ZIONToken  start =======================
159 
160 contract IcoToken is SafeMath, StandardToken, Pausable {
161   string public name;
162   string public symbol;
163   uint256 public decimals;
164   string public version;
165   address public icoContract;
166   address public developer_BSR;
167   address public developer_EKN;
168 
169   //EKN: Reserve initial amount tokens for future ZION projects / Exchanges
170   //40 million
171   uint256 public constant INITIAL_SUPPLY = 40000000 * 10**18;
172   //EKN: Developers share
173   //10 million
174   uint256 public constant DEVELOPER_SUPPLY = 10000000 * 10**18;
175 
176   function IcoToken() {
177 
178     name = "ZION Token";
179     symbol = "ZION";
180     decimals = 18;
181     version = "1.0";
182     developer_BSR = 0xAEf46875Eb00Ce14B5830b8de2e05aB79dC625d9;
183     developer_EKN = 0x1dEB6F7f7F2c4807cE287A8627681044547AB00A;
184 
185     balances[msg.sender] = INITIAL_SUPPLY;
186     balances[developer_BSR] = DEVELOPER_SUPPLY / 2;
187     balances[developer_EKN] = DEVELOPER_SUPPLY / 2;
188 
189     totalSupply = INITIAL_SUPPLY + DEVELOPER_SUPPLY;
190 
191   }
192 
193   function transfer(address _to, uint _value) whenNotPaused returns (bool success) {
194     return super.transfer(_to,_value);
195   }
196 
197   function approve(address _spender, uint _value) whenNotPaused returns (bool success) {
198     return super.approve(_spender,_value);
199   }
200 
201   function balanceOf(address _owner) constant returns (uint balance) {
202     return super.balanceOf(_owner);
203   }
204 
205   function setIcoContract(address _icoContract) onlyOwner {
206     if (_icoContract != address(0)) {
207       icoContract = _icoContract;
208     }
209   }
210 
211   function sell(address _recipient, uint256 _value) whenNotPaused returns (bool success) {
212       assert(_value > 0);
213       require(msg.sender == icoContract);
214 
215       balances[_recipient] += _value;
216       totalSupply += _value;
217 
218       Transfer(0x0, owner, _value);
219       Transfer(owner, _recipient, _value);
220       return true;
221   }
222 }
223 
224 // ================= Sale Contract Start ====================
225 
226 contract IcoContract is SafeMath, Pausable {
227   IcoToken public ico;
228 
229   uint256 public tokenCreationCap;
230   uint256 public totalSupply;
231 
232   address public ethFundDeposit;
233   address public tokenAddress;
234 
235   uint256 public fundingStartTime;
236 
237   bool public isFinalized;
238   uint256 public tokenExchangeRate;
239 
240   event LogCreateICO(address from, address to, uint256 val);
241 
242   function CreateICO(address to, uint256 val) internal returns (bool success) {
243     LogCreateICO(0x0, to, val);
244     return ico.sell(to, val);
245   }
246 
247   function IcoContract(
248     address _ethFundDeposit,
249     address _tokenAddress,
250     uint256 _tokenCreationCap,
251     uint256 _tokenExchangeRate,
252     uint256 _fundingStartTime
253 
254   )
255   {
256     ethFundDeposit = _ethFundDeposit;         //ETH deposit Address
257     tokenAddress = _tokenAddress;             //ERC20 Token address
258     tokenCreationCap = _tokenCreationCap;     //"100000000000000000000000000", // 100.000.000 Token
259     tokenExchangeRate = _tokenExchangeRate;   //"5000", // Rate: 1 ETH = 5000 Token
260     fundingStartTime = _fundingStartTime;     //"1514764800", // StartTime 01/01/2018 (unixtimestamp.com)
261     ico = IcoToken(tokenAddress);
262     isFinalized = false;
263 
264   }
265 
266   function () payable {
267     createTokens(msg.sender, msg.value);
268   }
269 
270   /// @dev Accepts ether and creates new ICO tokens.
271   function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {
272     require (tokenCreationCap > totalSupply);
273     require (now >= fundingStartTime);
274     require (!isFinalized);
275 
276     uint256 tokens = safeMult(_value, tokenExchangeRate);
277     uint256 checkedSupply = safeAdd(totalSupply, tokens);
278 
279     if (tokenCreationCap < checkedSupply) {
280       uint256 tokensToAllocate = safeSubtract(tokenCreationCap, totalSupply);
281       uint256 tokensToRefund   = safeSubtract(tokens, tokensToAllocate);
282       totalSupply = tokenCreationCap;
283       uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
284 
285       require(CreateICO(_beneficiary, tokensToAllocate));
286       msg.sender.transfer(etherToRefund);
287       ethFundDeposit.transfer(this.balance);
288       return;
289     }
290 
291     totalSupply = checkedSupply;
292 
293     require(CreateICO(_beneficiary, tokens));
294     ethFundDeposit.transfer(this.balance);
295   }
296 
297   /// @dev Ends the funding period and sends the ETH home
298   function finalize() external onlyOwner {
299     require (!isFinalized);
300     // move to operational
301     isFinalized = true;
302     ethFundDeposit.transfer(this.balance);
303   }
304 }