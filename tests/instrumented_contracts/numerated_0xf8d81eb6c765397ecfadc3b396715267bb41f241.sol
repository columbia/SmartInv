1 pragma solidity ^0.4.11;
2 
3 contract Crowdsale {
4     function buyTokens(address _recipient) payable;
5 }
6 
7 contract CapWhitelist {
8     address public owner;
9     mapping (address => uint256) public whitelist;
10 
11     event Set(address _address, uint256 _amount);
12 
13     function CapWhitelist() {
14         owner = msg.sender;
15         // Set in prod
16     }
17 
18     function destruct() {
19         require(msg.sender == owner);
20         selfdestruct(owner);
21     }
22 
23     function setWhitelisted(address _address, uint256 _amount) {
24         require(msg.sender == owner);
25         setWhitelistInternal(_address, _amount);
26     }
27 
28     function setWhitelistInternal(address _address, uint256 _amount) private {
29         whitelist[_address] = _amount;
30         Set(_address, _amount);
31     }
32 }
33 
34 contract Token {
35     uint256 public totalSupply;
36     function balanceOf(address _owner) constant returns (uint256 balance);
37     function transfer(address _to, uint256 _value) returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
39     function approve(address _spender, uint256 _value) returns (bool success);
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 /*  ERC 20 token */
47 contract StandardToken is Token {
48     using SafeMath for uint256;
49     function transfer(address _to, uint256 _value) returns (bool success) {
50       if (balances[msg.sender] >= _value) {
51         balances[msg.sender] = balances[msg.sender].sub(_value);
52         balances[_to] = balances[_to].add(_value);
53         Transfer(msg.sender, _to, _value);
54         return true;
55       } else {
56         return false;
57       }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
62         balances[_to] = balances[_to].add(_value);
63         balances[_from] = balances[_from].sub(_value);
64         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
65         Transfer(_from, _to, _value);
66         return true;
67       } else {
68         return false;
69       }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender,  uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
87       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
88       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
89       return true;
90     }
91 
92     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
93       uint oldValue = allowed[msg.sender][_spender];
94       if (_subtractedValue > oldValue) {
95         allowed[msg.sender][_spender] = 0;
96       } else {
97         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
98       }
99       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100       return true;
101     }
102 
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105 }
106 
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   function Ownable() {
119     owner = msg.sender;
120   }
121 
122 
123   /**
124    * @dev Throws if called by any account other than the owner.
125    */
126   modifier onlyOwner() {
127     require(msg.sender == owner);
128     _;
129   }
130 
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address newOwner) onlyOwner public {
137     require(newOwner != address(0));
138     OwnershipTransferred(owner, newOwner);
139     owner = newOwner;
140   }
141 
142 }
143 
144 library SafeMath {
145   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
146     uint256 c = a * b;
147     assert(a == 0 || c / a == b);
148     return c;
149   }
150 
151   function div(uint256 a, uint256 b) internal constant returns (uint256) {
152     // assert(b > 0); // Solidity automatically throws when dividing by 0
153     uint256 c = a / b;
154     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155     return c;
156   }
157 
158   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
159     assert(b <= a);
160     return a - b;
161   }
162 
163   function add(uint256 a, uint256 b) internal constant returns (uint256) {
164     uint256 c = a + b;
165     assert(c >= a);
166     return c;
167   }
168 }
169 
170 contract MintableToken is StandardToken, Ownable {
171   using SafeMath for uint256;
172   event Mint(address indexed to, uint256 amount);
173   event MintFinished();
174 
175   bool public mintingFinished = false;
176 
177   modifier canMint() {
178     require(!mintingFinished);
179     _;
180   }
181 
182   /**
183    * @dev Function to mint tokens
184    * @param _to The address that will receive the minted tokens.
185    * @param _amount The amount of tokens to mint.
186    */
187   function mint(address _to, uint256 _amount) onlyOwner canMint public {
188     totalSupply = totalSupply.add(_amount);
189     balances[_to] = balances[_to].add(_amount);
190     Mint(_to, _amount);
191     Transfer(0x0, _to, _amount);
192   }
193 
194   /**
195    * @dev Function to stop minting new tokens.
196    */
197   function finishMinting() onlyOwner public {
198     mintingFinished = true;
199     MintFinished();
200   }
201 }
202 contract RCNToken is MintableToken {
203     string public constant name = "Ripio Credit Network Token";
204     string public constant symbol = "RCN";
205     uint8 public constant decimals = 18;
206     string public version = "1.0";
207 }
208 
209 contract PreallocationsWhitelist {
210     address public owner;
211     mapping (address => bool) public whitelist;
212 
213     event Set(address _address, bool _enabled);
214 
215     function PreallocationsWhitelist() {
216         owner = msg.sender;
217         // Set in prod
218     }
219 
220     function destruct() {
221         require(msg.sender == owner);
222         selfdestruct(owner);
223     }
224 
225     function setWhitelisted(address _address, bool _enabled) {
226         require(msg.sender == owner);
227         setWhitelistInternal(_address, _enabled);
228     }
229 
230     function setWhitelistInternal(address _address, bool _enabled) private {
231         whitelist[_address] = _enabled;
232         Set(_address, _enabled);
233     }
234 }
235 
236 contract RCNCrowdsale is Crowdsale {
237     using SafeMath for uint256;
238 
239     // metadata
240     uint256 public constant decimals = 18;
241 
242     // contracts
243     address public ethFundDeposit;      // deposit address for ETH for Ripio
244     address public rcnFundDeposit;      // deposit address for Ripio use and RCN User Fund
245 
246     // crowdsale parameters
247     bool public isFinalized;              // switched to true in operational state
248     uint256 public fundingStartTimestamp;
249     uint256 public fundingEndTimestamp;
250     uint256 public constant rcnFund = 490 * (10**6) * 10**decimals;   // 490m RCN reserved for Ripio use
251     uint256 public constant tokenExchangeRate = 4000; // 4000 RCN tokens per 1 ETH
252     uint256 public constant tokenCreationCap =  1000 * (10**6) * 10**decimals;
253     uint256 public constant minBuyTokens = 400 * 10**decimals; // 0.1 ETH
254     uint256 public constant gasPriceLimit = 60 * 10**9; // Gas limit 60 gwei
255 
256     // events
257     event CreateRCN(address indexed _to, uint256 _value);
258 
259     mapping (address => uint256) bought; // cap map
260 
261     CapWhitelist public whiteList;
262     PreallocationsWhitelist public preallocationsWhitelist;
263     RCNToken public token;
264 
265     // constructor
266     function RCNCrowdsale(address _ethFundDeposit,
267           address _rcnFundDeposit,
268           uint256 _fundingStartTimestamp,
269           uint256 _fundingEndTimestamp) {
270       token = new RCNToken();
271       whiteList = new CapWhitelist();
272       preallocationsWhitelist = new PreallocationsWhitelist();
273 
274       // sanity checks
275       assert(_ethFundDeposit != 0x0);
276       assert(_rcnFundDeposit != 0x0);
277       assert(_fundingStartTimestamp < _fundingEndTimestamp);
278       assert(uint256(token.decimals()) == decimals); 
279 
280       isFinalized = false;                   //controls pre through crowdsale state
281       ethFundDeposit = _ethFundDeposit;
282       rcnFundDeposit = _rcnFundDeposit;
283       fundingStartTimestamp = _fundingStartTimestamp;
284       fundingEndTimestamp = _fundingEndTimestamp;
285       token.mint(rcnFundDeposit, rcnFund);
286       CreateRCN(rcnFundDeposit, rcnFund);  // logs Ripio Intl fund
287     }
288 
289     // fallback function can be used to buy tokens
290     function () payable {
291       buyTokens(msg.sender);
292     }
293 
294     // low level token purchase function
295     function buyTokens(address beneficiary) payable {
296       require (!isFinalized);
297       require (block.timestamp >= fundingStartTimestamp || preallocationsWhitelist.whitelist(msg.sender));
298       require (block.timestamp <= fundingEndTimestamp);
299       require (msg.value != 0);
300       require (beneficiary != 0x0);
301       require (tx.gasprice <= gasPriceLimit);
302 
303       uint256 tokens = msg.value.mul(tokenExchangeRate); // check that we're not over totals
304       uint256 checkedSupply = token.totalSupply().add(tokens);
305       uint256 checkedBought = bought[msg.sender].add(tokens);
306 
307       // if sender is not whitelisted or exceeds their cap, cancel the transaction
308       require (checkedBought <= whiteList.whitelist(msg.sender) || preallocationsWhitelist.whitelist(msg.sender));
309 
310       // return money if something goes wrong
311       require (tokenCreationCap >= checkedSupply);
312 
313       // return money if tokens is less than the min amount and the token is not finalizing
314       // the min amount does not apply if the availables tokens are less than the min amount.
315       require (tokens >= minBuyTokens || (tokenCreationCap - token.totalSupply()) <= minBuyTokens);
316 
317       token.mint(beneficiary, tokens);
318       bought[msg.sender] = checkedBought;
319       CreateRCN(beneficiary, tokens);  // logs token creation
320 
321       forwardFunds();
322     }
323 
324     function finalize() {
325       require (!isFinalized);
326       require (block.timestamp > fundingEndTimestamp || token.totalSupply() == tokenCreationCap);
327       require (msg.sender == ethFundDeposit);
328       isFinalized = true;
329       token.finishMinting();
330       whiteList.destruct();
331       preallocationsWhitelist.destruct();
332     }
333 
334     // send ether to the fund collection wallet
335     function forwardFunds() internal {
336       ethFundDeposit.transfer(msg.value);
337     }
338 
339     function setWhitelist(address _address, uint256 _amount) {
340       require (msg.sender == ethFundDeposit);
341       whiteList.setWhitelisted(_address, _amount);
342     }
343 
344     function setPreallocationWhitelist(address _address, bool _status) {
345       require (msg.sender == ethFundDeposit);
346       preallocationsWhitelist.setWhitelisted(_address, _status);
347     }
348 }