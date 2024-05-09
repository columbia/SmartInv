1 pragma solidity ^0.4.14;
2 
3 
4 
5 
6 contract ERC20 {
7     uint256 public totalSupply;
8     function balanceOf(address who) constant returns (uint256);
9     
10     function transfer(address to, uint256 value) returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     
13     function allowance(address owner, address spender) constant returns (uint256);
14     function transferFrom(address from, address to, uint256 value) returns (bool);
15     
16     function approve(address spender, uint256 value) returns (bool);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract StandardToken is ERC20 {
47     using SafeMath for uint256;
48     mapping(address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) returns (bool) {
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   function balanceOf(address _owner) constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67     var _allowance = allowed[_from][msg.sender];
68 
69     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
70     // require (_value <= _allowance);
71 
72     balances[_to] = balances[_to].add(_value);
73     balances[_from] = balances[_from].sub(_value);
74     allowed[_from][msg.sender] = _allowance.sub(_value);
75     Transfer(_from, _to, _value);
76     return true;
77   }
78 
79   function approve(address _spender, uint256 _value) returns (bool) {
80 
81     // To change the approve amount you first have to reduce the addresses`
82     //  allowance to zero by calling `approve(_spender, 0)` if it is not
83     //  already 0 to mitigate the race condition described here:
84     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86 
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93     return allowed[_owner][_spender];
94   }
95 
96 }
97 
98 contract Ownable {
99   address public owner;
100 
101 
102   /**
103    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
104    * account.
105    */
106   function Ownable() {
107     owner = msg.sender;
108   }
109 
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119 
120   /**
121    * @dev Allows the current owner to transfer control of the contract to a newOwner.
122    * @param newOwner The address to transfer ownership to.
123    */
124   function transferOwnership(address newOwner) onlyOwner {
125     require(newOwner != address(0));      
126     owner = newOwner;
127   }
128 
129 }
130 
131 
132 contract Token is StandardToken, Ownable {
133     using SafeMath for uint256;
134 
135   // start and end block where investments are allowed (both inclusive)
136     uint256 public startBlock;
137     uint256 public endBlock;
138   // address where funds are collected
139     address public wallet;
140 
141   // how many token units a buyer gets per wei
142     uint256 public tokensPerEther;
143 
144   // amount of raised money in wei
145     uint256 public weiRaised;
146 
147     uint256 public cap;
148     uint256 public issuedTokens;
149     string public name = "Enter-Coin";
150     string public symbol = "ENTRC";
151     uint public decimals = 8;
152     uint public INITIAL_SUPPLY = 100000000 * (10**decimals);
153     address founder; 
154     uint internal factor;
155     bool internal isCrowdSaleRunning;
156     uint contractDeployedTime;
157     uint mf = 10**decimals; // multiplication factor due to decimal value
158 
159     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
160 
161 
162     function Token() { 
163   
164     
165 
166     wallet = address(0x6D6D8fDFeFDA898341a60340a5699769Af2BA350); 
167     founder = address(0x0CC74179395d9434C9A31586763861327C499E76); // address of the founder
168 
169     tokensPerEther = 306; // 12/10/17 value 1 dollar value
170     endBlock = block.number + 1000000;
171 
172     totalSupply = INITIAL_SUPPLY;
173                           // reserve         // for token sale
174     balances[msg.sender] = (25000000 * mf) + (65000000 * mf);
175     balances[founder] = 10000000 * mf;
176 
177     startBlock = block.number;    
178     cap = 65000000 * mf;
179     issuedTokens = 0;
180     factor = 10**10;
181     isCrowdSaleRunning = true;
182     contractDeployedTime = now;
183 
184     }
185 
186     // crowdsale entrypoint
187     // fallback function can be used to buy tokens
188 
189   function () payable {
190     buyTokens(msg.sender);
191   }
192   
193   function getTimePassed() public constant returns (uint256) {
194       return (now - contractDeployedTime).div(1 days);
195   }
196   // bonus based on the current time
197   function applyBonus(uint256 tokens) internal constant returns (uint256) {
198 
199     if ( (now < (contractDeployedTime + 14 days)) && (issuedTokens < (3500000*mf)) ) {
200 
201       return tokens.mul(20).div(10); // 100% bonus
202       
203     } else if ((now < (contractDeployedTime + 20 days)) && (issuedTokens < (13500000*mf)) ) {
204     
205       return tokens.mul(15).div(10); // 50% bonus
206     
207 
208     } else if ((now < (contractDeployedTime + 26 days)) && (issuedTokens < (23500000*mf)) ) {
209 
210       return tokens.mul(13).div(10); // 30% bonus
211 
212     } else if ((now < (contractDeployedTime + 32 days)) && (issuedTokens < (33500000*mf)) ) {
213 
214       return tokens.mul(12).div(10); // 20% bonus
215 
216     } else if ((now < (contractDeployedTime + 38 days)) && (issuedTokens < (43500000*mf)) ) {
217       return tokens.mul(11).div(10); // 10% bonus
218 
219     } 
220 
221     return tokens; // if reached till hear means no bonus 
222 
223   }
224 
225   // stop the crowd sale
226   function stopCrowdSale() onlyOwner {
227     isCrowdSaleRunning = false;
228     endBlock = block.number;
229   }
230 
231   function resetContractDeploymentDate() onlyOwner {
232       contractDeployedTime = now;
233   }
234 
235   function startCrowdsale(uint interval) onlyOwner {
236     if ( endBlock < block.number ) {
237       endBlock = block.number;  // normalize the end block
238     }
239 
240     endBlock = endBlock.add(interval);
241     isCrowdSaleRunning = true;
242   }
243 
244   function setWallet(address newWallet) onlyOwner {
245     require(newWallet != address(0));
246     wallet = newWallet;
247   }
248 
249   // low level token purchase function
250   function buyTokens(address beneficiary) payable {
251     require(beneficiary != 0x0);
252     require(validPurchase());
253 
254     uint256 weiAmount = msg.value;
255     // calculate token amount to be created
256     uint256 tokens = weiAmount.mul(tokensPerEther).div(factor);
257 
258     tokens = applyBonus(tokens);
259     
260     // check if the tokens are more than the cap
261     require(issuedTokens.add(tokens) <= cap);
262     // update state
263     weiRaised = weiRaised.add(weiAmount);
264     issuedTokens = issuedTokens.add(tokens);
265 
266     forwardFunds();
267     // transfer the token
268     issueToken(beneficiary,tokens);
269     TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
270 
271   }
272 
273   function setFounder(address newFounder) onlyOwner {
274     require(newFounder != address(0));
275     founder = newFounder; 
276   }
277 
278   // can be issued to anyone without owners concent but as this method is internal only buyToken is calling it.
279   function issueToken(address beneficiary, uint256 tokens) internal {
280     balances[owner] = balances[owner].sub(tokens);
281     balances[beneficiary] = balances[beneficiary].add(tokens);
282   }
283 
284   // send ether to the fund collection wallet
285   // override to create custom fund forwarding mechanisms
286   function forwardFunds() internal {
287     // to normalize the input 
288     wallet.transfer(msg.value);
289   
290   }
291 
292   // @return true if the transaction can buy tokens
293   function validPurchase() internal constant returns (bool) {
294     uint256 current = block.number;
295     bool withinPeriod = current >= startBlock && current <= endBlock;
296     bool nonZeroPurchase = msg.value != 0;
297     return withinPeriod && nonZeroPurchase && isCrowdSaleRunning;
298   }
299 
300   // @return true if crowdsale event has ended
301   function hasEnded() public constant returns (bool) {
302       return (block.number > endBlock) || !isCrowdSaleRunning;
303   }
304 
305 }