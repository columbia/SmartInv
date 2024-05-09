1 pragma solidity ^0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
35 
36 contract Ownable {
37   address public owner;
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 // File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
58 
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 // File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
67 
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
91 
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
100 
101 contract StandardToken is ERC20, BasicToken {
102   event ChangeBalance (address from, uint256 fromBalance, address to, uint256 toBalance, uint256 seq);
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106   uint256 internal seq = 0;
107 
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     Transfer(_from, _to, _value);
117     ChangeBalance (_from, balances[_from], _to, balances[_to], ++seq);
118     return true;
119   }
120 
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     allowed[msg.sender][_spender] = _value;
123     Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   function allowance(address _owner, address _spender) public view returns (uint256) {
128     return allowed[_owner][_spender];
129   }
130 
131   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
132     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
133     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 
137   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148 }
149 
150 // File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
151 
152 contract MintableToken is StandardToken, Ownable {
153   event Mint(address indexed to, uint256 amount);
154 
155   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
156     totalSupply = totalSupply.add(_amount);
157     balances[_to] = balances[_to].add(_amount);
158     Mint(_to, _amount);
159     Transfer(address(0), _to, _amount);
160     ChangeBalance (address(0), 0, _to, balances[_to], ++seq);
161     return true; 
162   }
163 }
164 
165 // File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
166 
167 contract Crowdsale {
168   using SafeMath for uint256;
169 
170   // The token being sold
171   MintableToken public token;
172 
173   // start and end timestamps where investments are allowed (both inclusive)
174   uint256 public startTime;
175   uint256 public endTime;
176 
177   // ICO Phases
178   uint256[] starts;
179   uint256[] ends;
180   uint256[] rates;
181 
182   // Purchase counter
183   uint256 internal seq;
184 
185   // address where funds are collected
186   address public wallet;
187 
188   // how many token units a buyer gets per wei
189   uint256 public rate;
190 
191   // amount of raised money in wei
192   uint256 public weiRaised;
193 
194   uint256 public cap;
195 
196   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 seq);
197   
198   function Crowdsale(uint256[] _startTime, uint256[] _endTime, uint256[] _rates, address _wallet, uint256 _cap) public {
199     // require(_startTime >= now);
200 
201     for (uint8 i = 0; i < starts.length; i ++) {
202       require(_endTime[i] >= _startTime[i]);
203       require(_rates[i] > 0);
204       require(_wallet != address(0));
205     }
206 
207     cap = _cap;
208     starts = _startTime;
209     ends = _endTime;
210     rates = _rates;
211 
212     // token = createTokenContract();
213     
214     
215     startTime = _startTime[0];
216     endTime = _endTime[_endTime.length - 1];
217     rate = _rates[0];
218     wallet = _wallet;
219   }
220 
221   function createTokenContract() internal returns (MintableToken) {
222     return new MintableToken();
223   }
224 
225 
226   function () external payable {
227     //minimum is 1 Ether
228     require (msg.value >= 1000000000000000000);
229     buyTokens(msg.sender);
230   }
231 
232   function buyTokens(address beneficiary) public payable {
233     require(beneficiary != address(0));
234     require(validPurchase());
235 
236     uint256 weiAmount = msg.value;
237     uint256 arrayLength = starts.length;
238 
239 
240     // calculate token amount to be created
241     for (uint8 i = 0; i < arrayLength; i ++) {
242       if (now >= starts[i] && now <= ends[i]) {
243         rate = rates[i];
244         break;
245       }
246     }    
247     uint256 tokens = weiAmount.mul(rate);
248     require (checkCap(tokens));
249 
250     // update state
251     weiRaised = weiRaised.add(weiAmount);
252 
253     token.mint(beneficiary, tokens);
254     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, ++seq);
255 
256     forwardFunds();
257   }
258 
259   function forwardFunds() internal {
260     wallet.transfer(msg.value);
261   }
262 
263   function validPurchase() internal view returns (bool) {
264     bool withinPeriod = now >= startTime && now <= endTime;
265     bool nonZeroPurchase = msg.value != 0;
266     
267     return withinPeriod && nonZeroPurchase;
268   }
269 
270   function hasEnded() public view returns (bool) {
271     uint256 tokenSupply = token.totalSupply();
272     bool capReached = tokenSupply >= cap;
273     bool overTime = now > endTime;
274     return capReached && overTime; //now > endTime;
275   }
276 
277   function checkCap(uint256 tokens) internal view returns (bool) {
278     uint256 issuedTokens = token.totalSupply();
279     return (issuedTokens.add(tokens) <= cap);
280   }
281 }
282 
283 // File: node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
284 
285 contract FinalizableCrowdsale is Crowdsale, Ownable {
286   using SafeMath for uint256;
287 
288   bool public isFinalized = false;
289 
290   event Finalized();
291 
292   function finalize() onlyOwner public {
293     require(!isFinalized);
294     require(hasEnded());
295 
296     Finalized();
297 
298     isFinalized = true;
299   }
300 }
301 
302 // File: contracts/OMXToken.sol
303 
304 contract OMXToken is MintableToken {
305     string public constant name = "OMEX";
306     string public constant symbol = "OMX";
307     uint8 public constant decimals = 18;
308 
309     function OMXToken () public MintableToken () {
310     }
311 
312 
313 }
314 
315 // File: contracts/OMXCrowdsale.sol
316 
317 contract OMXCrowdsale is FinalizableCrowdsale {
318     uint256[] start = [1514646000, 1515942000, 1516806000];
319     uint256[] end = [1515941999, 1516805999, 1517669999];
320     uint256[] rate = [1400, 1200, 1000];
321     address companyWallet;
322     address tokenAddress;
323 
324     uint256 salesCap    = 300000000000000000000000000;
325     uint256 cap         = 500000000000000000000000000;
326 
327   function OMXCrowdsale(address _wallet, address _token) public 
328       FinalizableCrowdsale() Crowdsale(start, end, rate, _wallet, salesCap)
329   {
330       companyWallet = _wallet;
331       tokenAddress = _token;
332       token = createTokenContract();
333   }
334 
335   function createTokenContract() internal returns (MintableToken) {
336       OMXToken omxInstance;
337       omxInstance = OMXToken (address(tokenAddress));
338       return omxInstance;
339   }
340 
341   function finalize() onlyOwner public {
342       // mint company share of tokens
343       token.mint(companyWallet, cap - token.totalSupply());
344       super.finalize();
345   }
346 }