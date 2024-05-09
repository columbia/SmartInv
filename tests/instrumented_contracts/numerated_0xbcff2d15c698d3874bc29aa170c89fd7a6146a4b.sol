1 pragma solidity ^0.4.12;
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
126     
127     uint public totalTokens = 0;
128     uint public presaleSupply = 0;
129     uint public presaleEtherRaised = 0;
130 
131     event Buy(address indexed recipient, uint eth, uint chx);
132 
133     uint public presaleAllocation = totalSupply / 2; //50% of token supply allocated for crowdsale
134     uint public strategicAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for strategic supply
135     uint public reserveAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for internal
136     bool public strategicAllocated = false;
137     bool public reserveAllocated = false;
138 
139     uint public transferLockup = 172800; //no transfers until 30 days after crowdsale begins (assumes 100 day crowdsale)
140     uint public reserveLockup = 241920; //first wave of reserve locked until 42 days after sale is over
141 
142     uint public reserveWave = 0; //increments each time 10% of reserve is allocated, to a max of 10
143     uint public reserveWaveTokens = reserveAllocation / 10; //10% of reserve will be released on each wave
144     uint public reserveWaveLockup = 172800; //30 day intervals before subsequent wave of reserve tokens can be released
145 
146     uint public constant MIN_ETHER = 1 finney;
147 
148     enum TokenSaleState {
149         Initial,    //contract initialized, bonus token
150         Presale,    //limited time crowdsale
151         Live,       //default price
152         Frozen      //prevent sale of tokens
153     }
154 
155     TokenSaleState public _saleState = TokenSaleState.Initial;
156 
157     function CHEXToken(address founderInput, address ownerInput, uint startBlockInput, uint endBlockInput) {
158         founder = founderInput;
159         owner = ownerInput;
160         startBlock = startBlockInput;
161         endBlock = endBlockInput;
162         
163         updateTokenSaleState();
164     }
165 
166     function price() constant returns(uint) {
167         if (_saleState == TokenSaleState.Initial) return 12002;
168         if (_saleState == TokenSaleState.Presale) {
169             uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);
170             return 6000 + 6 * percentRemaining;
171         }
172         return 6000;
173     }
174 
175     function() payable {
176         buy(msg.sender);
177     }
178 
179     function buy(address recipient) payable {
180         if (recipient == 0x0) throw;
181         if (msg.value < MIN_ETHER) throw;
182         if (_saleState == TokenSaleState.Frozen) throw;
183         
184         updateTokenSaleState();
185 
186         uint tokens = mul(msg.value, price());
187         uint nextTotal = add(totalTokens, tokens);
188         uint nextPresaleTotal = add(presaleSupply, tokens);
189 
190         if (nextTotal >= totalSupply) throw;
191         if (nextPresaleTotal >= presaleAllocation) throw;
192         
193         balances[recipient] = add(balances[recipient], tokens);
194         presaleSupply = nextPresaleTotal;
195         totalTokens = nextTotal;
196 
197         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
198             presaleEtherRaised = add(presaleEtherRaised, msg.value);
199         }
200 
201         founder.transfer(msg.value);
202         
203         Transfer(0, recipient, tokens);
204         Buy(recipient, msg.value, tokens);
205     }
206 
207     function updateTokenSaleState () {
208         if (_saleState == TokenSaleState.Frozen) return;
209 
210         if (_saleState == TokenSaleState.Live && block.number > endBlock) return;
211         
212         if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {
213             _saleState = TokenSaleState.Presale;
214         }
215         
216         if (_saleState == TokenSaleState.Presale && block.number > endBlock) {
217             _saleState = TokenSaleState.Live;
218         }
219     }
220 
221     function transfer(address _to, uint256 _value) returns (bool success) {
222         if (block.number <= startBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;
223         return super.transfer(_to, _value);
224     }
225 
226     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
227         if (block.number <= startBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;
228         return super.transferFrom(_from, _to, _value);
229     }
230 
231     modifier onlyInternal {
232         require(msg.sender == owner || msg.sender == founder);
233         _;
234     }
235 
236     function allocateStrategicTokens() onlyInternal {
237         if (strategicAllocated) throw;
238 
239         balances[owner] = add(balances[owner], strategicAllocation);
240         totalTokens = add(totalTokens, strategicAllocation);
241 
242         strategicAllocated = true;
243 
244         Transfer(0, owner, strategicAllocation);
245     }
246 
247     function allocateReserveTokens() onlyInternal {
248         if (block.number <= endBlock + reserveLockup + (reserveWaveLockup * reserveWave)) throw;
249         if (reserveAllocated) throw;
250 
251         balances[founder] = add(balances[founder], reserveWaveTokens);
252         totalTokens = add(totalTokens, reserveWaveTokens);
253 
254         reserveWave++;
255         if (reserveWave >= 10) {
256             reserveAllocated = true;
257         }
258 
259         Transfer(0, founder, reserveWaveTokens);
260     }
261 
262     function freeze() onlyInternal {
263         _saleState = TokenSaleState.Frozen;
264     }
265 
266     function unfreeze() onlyInternal {
267         _saleState = TokenSaleState.Presale;
268         updateTokenSaleState();
269     }
270 
271 }