1 pragma solidity ^0.4.13;
2 
3 contract Math {
4   function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
5     assert((z = x + y) >= x);
6   }
7 
8   function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
9     assert((z = x - y) <= x);
10   }
11 
12   function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
13     assert((z = x * y) >= x);
14   }
15 
16   function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
17     z = x / y;
18   }
19 }
20 
21 contract Token {
22   uint256 public totalSupply;
23   function balanceOf(address _owner) public constant returns (uint256 balance);
24   function transfer(address _to, uint256 _value) public returns (bool success);
25   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
26   function approve(address _spender, uint256 _value) public returns (bool success);
27   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
28   event Transfer(address indexed _from, address indexed _to, uint256 _value);
29   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 /*  ERC 20 token */
33 contract ERC20 is Token {
34 
35   function name() public pure returns (string) { name; }
36   function symbol() public pure returns (string) { symbol; }
37   function decimals() public pure returns (uint8) { decimals; }
38 
39   function transfer(address _to, uint256 _value) public returns (bool success) {
40     if (balances[msg.sender] >= _value && _value > 0) {
41       balances[msg.sender] -= _value;
42       balances[_to] += _value;
43       Transfer(msg.sender, _to, _value);
44       return true;
45     } else {
46       return false;
47     }
48   }
49 
50   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52       balances[_to] += _value;
53       balances[_from] -= _value;
54       allowed[_from][msg.sender] -= _value;
55       Transfer(_from, _to, _value);
56       return true;
57     } else {
58       return false;
59     }
60   }
61 
62   function balanceOf(address _owner) public constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66   function approve(address _spender, uint256 _value) public returns (bool success) {
67     allowed[msg.sender][_spender] = _value;
68     Approval(msg.sender, _spender, _value);
69     return true;
70   }
71 
72   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
73     return allowed[_owner][_spender];
74   }
75 
76   mapping (address => uint256) balances;
77   mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract owned {
81   address public owner;
82 
83   function owned() public {
84     owner = msg.sender;
85   }
86 
87   modifier onlyOwner {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   function transferOwnership(address newOwner) public onlyOwner {
93     owner = newOwner;
94   }
95 }
96 
97 contract EPCToken is ERC20, Math, owned {
98   // metadata
99   string public name;
100   string public symbol;
101   uint8 public decimals = 18;
102   string public version;
103 
104   // events
105   event Reward(address indexed _to, uint256 _value);
106   event MintToken(address indexed _to, uint256 _value);
107   event Burn(address indexed _to, uint256 _value);
108 
109   // constructor
110   function EPCToken(
111    string _name,
112    string _symbol,
113    string _version
114   ) public {
115     name = _name;
116     symbol = _symbol;
117     version = _version;
118   }
119 
120   /*
121    * mint token
122    */
123   function mintToken(address target, uint256 mintedAmount) public onlyOwner {
124     balances[target] += mintedAmount;
125     totalSupply += mintedAmount;
126     MintToken(target, mintedAmount);
127   }
128 
129   /*
130    * burn the tokens, cant never get back
131    */
132   function burn(uint256 amount) public returns (bool success) {
133     require(balances[msg.sender] >= amount);
134     balances[msg.sender] -= amount;
135     totalSupply -= amount;
136     Burn(msg.sender, amount);
137     return true;
138   }
139 
140   /*
141    * reward token
142    */
143   function reward(address target, uint256 amount) public onlyOwner {
144     balances[target] += amount;
145     Reward(target, amount);
146   }
147 
148   /*
149    * kill the contract from the blockchain
150    * and send the balance to the owner
151    */
152   function kill() public onlyOwner {
153     selfdestruct(owner);
154   }
155 }
156 
157 contract EPCSale is Math, owned {
158   EPCToken public epc;
159   uint256 public constant decimals = 18;
160   // crowdsale parameters
161   bool public isFinalized;  // switched to true in operational state
162   uint256 public fundingStartBlock;
163   uint256 public fundingEndBlock;
164   uint256 public funded;
165   uint256 public constant totalCap = 250 * (10**6) * 10**decimals; // 250m epc
166 
167   // constructor
168   function EPCSale(
169    EPCToken _epc,
170    uint256 _fundingStartBlock,
171    uint256 _fundingEndBlock
172   )
173   public {
174     isFinalized = false; //controls pre through crowdsale state
175     epc = EPCToken(_epc);
176     fundingStartBlock = _fundingStartBlock;
177     fundingEndBlock = _fundingEndBlock;
178   }
179 
180   /*
181    * crowdsale
182    */
183   function crowdSale() public payable {
184     require(!isFinalized);
185     assert(block.number >= fundingStartBlock);
186     assert(block.number <= fundingEndBlock);
187     require(msg.value > 0);
188     uint256 tokens = mul(msg.value, exchangeRate()); // check that we're not over totals
189     funded = add(funded, tokens);
190     assert(funded <= totalCap);
191     assert(epc.transfer(msg.sender, tokens));
192   }
193 
194   /*
195    * caculate the crowdsale rate per eth
196    */
197   function exchangeRate() public constant returns(uint256) {
198     if (block.number<=fundingStartBlock+43200) return 10000; // early price
199     if (block.number<=fundingStartBlock+2*43200) return 8000; // crowdsale price
200     return 7000; // default price
201   }
202 
203   /*
204    * unit test for crowdsale exchange rate
205    */
206   function testExchangeRate(uint blockNumber) public constant returns(uint256) {
207     if (blockNumber <= fundingStartBlock+43200) return 10000; // early price
208     if (blockNumber <= fundingStartBlock+2*43200) return 8000; // crowdsale price
209     return 7000; // default price
210   }
211 
212   /*
213    * unit test for calculate funded amount
214    */
215   function testFunded(uint256 amount) public constant returns(uint256) {
216     uint256 tokens = mul(amount, exchangeRate());
217     return add(funded, tokens);
218   }
219 
220   /*
221    * unamed function for crowdsale
222    */
223   function () public payable {
224     crowdSale();
225   }
226 
227   /*
228    * withrawal the crowd eth
229    */
230   function withdrawal() public onlyOwner {
231     msg.sender.transfer(this.balance);
232   }
233 
234   /*
235    * stop the crowdsale
236    */
237   function stop() public onlyOwner {
238     isFinalized = true;
239   }
240 
241   /*
242    * start the crowdsale
243    */
244   function start() public onlyOwner {
245     isFinalized = false;
246   }
247 
248   /*
249    * retrieve tokens from the contract
250    */
251   function retrieveTokens(uint256 amount) public onlyOwner {
252     assert(epc.transfer(owner, amount));
253   }
254 
255   /*
256    * kill the contract from the blockchain
257    * and retrieve the tokens and balance to the owner
258    */
259   function kill() public onlyOwner {
260     epc.transfer(owner, epc.balanceOf(this));
261     selfdestruct(owner);
262   }
263 }