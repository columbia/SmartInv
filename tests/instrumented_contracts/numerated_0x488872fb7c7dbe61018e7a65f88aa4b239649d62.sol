1 pragma solidity ^0.4.11;
2 /**
3  * Overflow aware uint math functions.
4  */
5 contract SafeMath {
6   function mul(uint256 a, uint256 b) internal returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function pct(uint numerator, uint denominator, uint precision) internal returns(uint quotient) {
18     uint _numerator = numerator * 10 ** (precision+1);
19     uint _quotient = ((_numerator / denominator) + 5) / 10;
20     return (_quotient);
21   }
22 
23   function sub(uint256 a, uint256 b) internal returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50 }
51 
52 /**
53  * ERC 20 token
54  */
55 contract Token is SafeMath {
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] = sub(balances[msg.sender], _value);
59             balances[_to] = add(balances[_to], _value);
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] = add(balances[_to], _value);
68             balances[_from] = sub(balances[_from], _value);
69             allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
70             Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91 
92     mapping (address => uint256) balances;
93 
94     mapping (address => mapping (address => uint256)) allowed;
95 
96     uint256 public totalSupply;
97 
98     // A vulernability of the approve method in the ERC20 standard was identified by
99     // Mikhail Vladimirov and Dmitry Khovratovich here:
100     // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
101     // It's better to use this method which is not susceptible to over-withdrawing by the approvee.
102     /// @param _spender The address to approve
103     /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)
104     /// @param _newValue The new value to approve, this will replace the _currentValue
105     /// @return bool Whether the approval was a success (see ERC20's `approve`)
106     function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
107         if (allowed[msg.sender][_spender] != _currentValue) {
108             return false;
109         }
110             return approve(_spender, _newValue);
111     }
112 }
113 
114 contract CHEXToken is Token {
115 
116     string public constant name = "CHEX Token";
117     string public constant symbol = "CHX";
118     uint public constant decimals = 18;
119     uint public startBlock; //crowdsale start block
120     uint public endBlock; //crowdsale end block
121 
122     address public founder;
123     address public owner;
124     
125     uint public totalSupply = 2000000000 * 10**decimals; // 2b tokens, each divided to up to 10^decimals units.
126     uint public etherCap = 2500000 * 10**decimals;
127     
128     uint public totalTokens = 0;
129     uint public presaleSupply = 0;
130     uint public presaleEtherRaised = 0;
131 
132     event Buy(address indexed recipient, uint eth, uint chx);
133     event Deliver(address indexed recipient, uint chx, string _for);
134 
135     uint public presaleAllocation = totalSupply / 2; //50% of token supply allocated for crowdsale
136     uint public strategicAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for strategic supply
137     uint public reserveAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for internal
138     bool public strategicAllocated = false;
139     bool public reserveAllocated = false;
140 
141     uint public transferLockup = 5760; //no transfers until 1 day after sale is over
142     uint public strategicLockup = 80640; //strategic supply locked until 14 days after sale is over
143     uint public reserveLockup = 241920; //first wave of reserve locked until 42 days after sale is over
144 
145     uint public reserveWave = 0; //increments each time 10% of reserve is allocated, to a max of 10
146     uint public reserveWaveTokens = reserveAllocation / 10; //10% of reserve will be released on each wave
147     uint public reserveWaveLockup = 172800; //30 day intervals before subsequent wave of reserve tokens can be released
148 
149     uint public constant MIN_ETHER = 1 finney;
150 
151     enum TokenSaleState {
152         Initial,    //contract initialized, bonus token
153         Presale,    //limited time crowdsale
154         Live,       //default price
155         Frozen      //prevent sale of tokens
156     }
157 
158     TokenSaleState public _saleState = TokenSaleState.Initial;
159 
160     function CHEXToken(address founderInput, address ownerInput, uint startBlockInput, uint endBlockInput) {
161         founder = founderInput;
162         owner = ownerInput;
163         startBlock = startBlockInput;
164         endBlock = endBlockInput;
165         
166         updateTokenSaleState();
167     }
168 
169     function price() constant returns(uint) {
170         if (_saleState == TokenSaleState.Initial) return 6001;
171         if (_saleState == TokenSaleState.Presale) {
172             uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);
173             return 3000 + 3 * percentRemaining;
174         }
175         return 3000;
176     }
177 
178     function updateTokenSaleState () {
179         if (_saleState == TokenSaleState.Frozen) return;
180 
181         if (_saleState == TokenSaleState.Live && block.number > endBlock) return;
182         
183         if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {
184             _saleState = TokenSaleState.Presale;
185         }
186         
187         if (_saleState == TokenSaleState.Presale && block.number > endBlock) {
188             _saleState = TokenSaleState.Live;
189         }
190     }
191 
192     function() payable {
193         buy(msg.sender);
194     }
195 
196     function buy(address recipient) payable {
197         if (recipient == 0x0) throw;
198         if (msg.value < MIN_ETHER) throw;
199         if (totalTokens >= totalSupply) throw;
200         if (_saleState == TokenSaleState.Frozen) throw;
201         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
202         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleEtherRaised >= etherCap) throw;
203 
204         updateTokenSaleState();
205         uint tokens = mul(msg.value, price());
206 
207         if (tokens == 0) throw;
208         
209         balances[recipient] = add(balances[recipient], tokens);
210         totalTokens = add(totalTokens, tokens);
211 
212         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
213             presaleEtherRaised = add(presaleEtherRaised, msg.value);
214             presaleSupply = add(presaleSupply, tokens);
215         }
216 
217         founder.transfer(msg.value);
218         
219         Transfer(0, recipient, tokens);
220         Buy(recipient, msg.value, tokens);
221     }
222 
223     function transfer(address _to, uint256 _value) returns (bool success) {
224         if (block.number <= endBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;
225         return super.transfer(_to, _value);
226     }
227 
228     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
229         if (block.number <= endBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;
230         return super.transferFrom(_from, _to, _value);
231     }
232 
233     modifier onlyInternal {
234         require(msg.sender == owner || msg.sender == founder);
235         _;
236     }
237 
238     function deliver(address recipient, uint tokens, string _for) onlyInternal {
239         if (tokens == 0) throw;
240         if (totalTokens >= totalSupply) throw;
241         if (_saleState == TokenSaleState.Frozen) throw;
242         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
243 
244         updateTokenSaleState();
245 
246         balances[recipient] = add(balances[recipient], tokens);
247         totalTokens = add(totalTokens, tokens);
248 
249         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
250             presaleSupply = add(presaleSupply, tokens);
251         }
252 
253         Transfer(0, recipient, tokens);    
254         Deliver(recipient, tokens, _for);
255     }
256 
257     function allocateStrategicTokens() onlyInternal {
258         if (block.number <= endBlock + strategicLockup) throw;
259         if (strategicAllocated) throw;
260 
261         balances[owner] = add(balances[owner], strategicAllocation);
262         totalTokens = add(totalTokens, strategicAllocation);
263 
264         strategicAllocated = true;
265     }
266 
267     function allocateReserveTokens() onlyInternal {
268         if (block.number <= endBlock + reserveLockup + (reserveWaveLockup * reserveWave)) throw;
269         if (reserveAllocated) throw;
270 
271         balances[founder] = add(balances[founder], reserveWaveTokens);
272         totalTokens = add(totalTokens, reserveWaveTokens);
273 
274         reserveWave++;
275         if (reserveWave >= 10) {
276             reserveAllocated = true;
277         }
278     }
279 
280     function freeze() onlyInternal {
281         _saleState = TokenSaleState.Frozen;
282     }
283 
284     function unfreeze() onlyInternal {
285         _saleState = TokenSaleState.Presale;
286         updateTokenSaleState();
287     }
288 
289 }