1 pragma solidity 0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract Ownable {
31   address public owner;
32 
33   function Ownable() {
34     owner = msg.sender;
35   }
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42 function transferOwnership(address newOwner) onlyOwner {
43     require(newOwner != address(0));
44     owner = newOwner;
45  }
46 
47 }
48 
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55   modifier whenNotPaused() {
56     require(!paused);
57     _;
58   }
59 
60   modifier whenPaused {
61     require(paused);
62     _;
63   }
64 
65   function pause() onlyOwner whenNotPaused returns (bool) {
66     paused = true;
67     Pause();
68     return true;
69   }
70 
71   function unpause() onlyOwner whenPaused returns (bool) {
72     paused = false;
73     Unpause();
74     return true;
75   }
76 }
77 
78 contract ERC20 {
79 
80   uint256 public totalSupply;
81 
82   function balanceOf(address _owner) constant returns (uint256);
83   function transfer(address _to, uint256 _value) returns (bool);
84   function transferFrom(address _from, address _to, uint256 _value) returns (bool);
85   function approve(address _spender, uint256 _value) returns (bool);
86   function allowance(address _owner, address _spender) constant returns (uint256);
87 
88   event Transfer(address indexed _from, address indexed _to, uint256 _value);
89   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 
91 }
92 
93 contract MercuryToken is ERC20, Ownable {
94 
95   using SafeMath for uint256;
96 
97   mapping(address => uint) balances;
98   mapping (address => mapping (address => uint)) allowed;
99 
100   string public constant name = "MERCURY TOKEN";
101   string public constant symbol = "MRC";
102   uint8 public constant decimals = 18;
103   bool public mintingFinished = false;
104 
105   event Mint(address indexed to, uint256 amount);
106   event MintFinished();
107 
108   function MercuryToken() {}
109 
110 
111   function() payable {
112     revert();
113   }
114 
115   function balanceOf(address _owner) constant returns (uint256) {
116     return balances[_owner];
117   }
118 
119   function transfer(address _to, uint _value) returns (bool) {
120 
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123 
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   function transferFrom(address _from, address _to, uint _value) returns (bool) {
129     var _allowance = allowed[_from][msg.sender];
130 
131     balances[_to] = balances[_to].add(_value);
132     balances[_from] = balances[_from].sub(_value);
133     allowed[_from][msg.sender] = _allowance.sub(_value);
134 
135     Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   function approve(address _spender, uint _value) returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   function allowance(address _owner, address _spender) constant returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149 
150   modifier canMint() {
151     require(!mintingFinished);
152     _;
153   }
154 
155   function mint(address _to, uint256 _amount) onlyOwner  returns (bool) {
156     totalSupply = totalSupply.add(_amount);
157     balances[_to] = balances[_to].add(_amount);
158     Mint(_to, _amount);
159     return true;
160   }
161 
162   function finishMinting() onlyOwner returns (bool) {
163     mintingFinished = true;
164     MintFinished();
165     return true;
166   }
167 
168   function allowMinting() onlyOwner returns (bool) {
169     mintingFinished = false;
170     return true;
171   }
172 
173 }
174 
175 contract MercuryPresale is Pausable {
176   using SafeMath for uint256;
177 
178   MercuryToken public token;
179 
180 
181   address public wallet; //wallet towards which the funds are forwarded
182   uint256 public weiRaised; //total amount of ether raised
183   uint256 public cap; // cap above which the presale ends
184   uint256 public minInvestment; // minimum investment
185   uint256 public rate; // number of tokens for one ether
186   bool public isFinalized;
187   string public contactInformation;
188 
189   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
190 
191   event Finalized();
192 
193 
194   function MercuryCrowdsale() {
195 
196     token = createTokenContract();
197     wallet = 0x1dE159F3bb50992b78E06697B6273e326ADCcf75;
198     rate = 6000;
199     minInvestment = 1 * (10**16);
200     cap = 180000000 * (10**18); 
201 
202   }
203 
204   // creates presale token
205   function createTokenContract() internal returns (MercuryToken) {
206     return new MercuryToken();
207   }
208 
209   // fallback function to buy tokens
210   function () payable {
211     buyTokens(msg.sender);
212   }
213 
214   function buyTokens(address beneficiary) payable whenNotPaused {
215     require(beneficiary != 0x0);
216     require(validPurchase());
217     require(!isFinalized);
218 
219     uint256 weiAmount = msg.value;
220 
221     weiRaised = weiRaised.add(weiAmount);
222 
223     uint256 tokens = weiAmount.mul(rate);
224 
225     token.mint(beneficiary, tokens);
226     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
227     forwardFunds();
228   }
229 
230 
231   function forwardFunds() internal {
232     wallet.transfer(msg.value);
233   }
234 
235   // return true if the transaction can buy tokens
236   function validPurchase() internal constant returns (bool) {
237 
238     uint256 weiAmount = weiRaised.add(msg.value);
239     bool notSmallAmount = msg.value >= minInvestment;
240     bool withinCap = weiAmount.mul(rate) <= cap;
241 
242     return (notSmallAmount && withinCap);
243   }
244 
245   function finalize() onlyOwner {
246     require(!isFinalized);
247     require(hasEnded());
248 
249     token.finishMinting();
250     Finalized();
251 
252     isFinalized = true;
253   }
254 
255 
256   function setContactInformation(string info) onlyOwner {
257       contactInformation = info;
258   }
259 
260 
261   //return true if crowdsale event has ended
262   function hasEnded() public constant returns (bool) {
263     bool capReached = (weiRaised.mul(rate) >= cap);
264     return capReached;
265   }
266 
267 }