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
55 contract Token {
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
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
114 contract CHEXToken is Token, SafeMath {
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
125     uint public totalTokens = 2000000000 * 10**decimals; // 2b tokens, each divided to up to 10^decimals units.
126     uint public etherCap = 2500000 * 10**decimals;
127 
128     uint public presaleSupply = 0;
129     uint public presaleEtherRaised = 0;
130 
131     event Buy(address indexed recipient, uint eth, uint chx);
132     event Deliver(address indexed recipient, uint chx, string _for);
133 
134     uint public presaleAllocation = totalTokens / 2; //50% of token supply allocated for crowdsale
135     uint public ecosystemAllocation = totalTokens / 4; //25% of token supply allocated post-crowdsale for the ecosystem fund
136     uint public reservedAllocation = totalTokens / 4; //25% of token supply allocated post-crowdsale for internal
137     bool public ecosystemAllocated = false;
138 
139     enum TokenSaleState {
140         Initial,    //contract initialized, bonus token
141         Presale,    //limited time crowdsale
142         Live,       //default price
143         Frozen      //prevent sale of tokens
144     }
145 
146     TokenSaleState public _saleState = TokenSaleState.Initial;
147 
148     function CHEXToken(address founderInput, address ownerInput, uint startBlockInput, uint endBlockInput) {
149         founder = founderInput;
150         owner = ownerInput;
151         startBlock = startBlockInput;
152         endBlock = endBlockInput;
153         updateTokenSaleState();
154     }
155 
156     function price() constant returns(uint) {
157         if (_saleState == TokenSaleState.Initial) return 6001;
158         if (_saleState == TokenSaleState.Presale) {
159             uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);
160             return 3000 + 3 * percentRemaining;
161         }
162         return 3000;
163     }
164 
165     function updateTokenSaleState () {
166         if (_saleState == TokenSaleState.Frozen) return;
167 
168         if (_saleState == TokenSaleState.Live && block.number > endBlock) return;
169         
170         if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {
171             _saleState = TokenSaleState.Presale;
172         }
173         
174         if (_saleState == TokenSaleState.Presale && block.number > endBlock) {
175             _saleState = TokenSaleState.Live;
176         }
177     }
178 
179     function() payable {
180         buy(msg.sender);
181     }
182 
183     function buy(address recipient) payable {
184         if (recipient == 0x0) throw;
185         if (totalSupply >= totalTokens) throw;
186         if (_saleState == TokenSaleState.Frozen) throw;
187         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
188         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleEtherRaised >= etherCap) throw;
189 
190         updateTokenSaleState();
191         uint tokens = mul(msg.value, price());
192 
193         if (tokens <= 0) throw;
194         
195         balances[recipient] = add(balances[recipient], tokens);
196         totalSupply = add(totalSupply, tokens);
197 
198         if (_saleState <= TokenSaleState.Presale) {
199             presaleEtherRaised = add(presaleEtherRaised, msg.value);
200             presaleSupply = add(presaleSupply, tokens);
201         }
202 
203         founder.transfer(msg.value);
204             
205         Buy(recipient, msg.value, tokens);
206     }
207 
208     modifier onlyInternal {
209         require(msg.sender == owner || msg.sender == founder);
210         _;
211     }
212 
213     function deliver(address recipient, uint tokens, string _for) onlyInternal {
214         if (tokens == 0) throw;
215         if (totalSupply >= totalTokens) throw;
216         if (_saleState == TokenSaleState.Frozen) throw;
217         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
218 
219         updateTokenSaleState();
220 
221         if (add(totalSupply, tokens) >= totalTokens) throw;
222         
223         balances[recipient] = add(balances[recipient], tokens);
224         totalSupply = add(totalSupply, tokens);
225 
226         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
227             presaleSupply = add(presaleSupply, tokens);
228         }
229             
230         Deliver(recipient, tokens, _for);
231     }
232 
233     function allocateEcosystemTokens() onlyInternal {
234         if (block.number <= endBlock) throw;
235         if (ecosystemAllocated) throw;
236 
237         balances[owner] = add(balances[owner], ecosystemAllocation);
238         totalSupply = add(totalSupply, ecosystemAllocation);
239 
240         balances[founder] = add(balances[founder], reservedAllocation);
241         totalSupply = add(totalSupply, reservedAllocation);
242 
243         ecosystemAllocated = true;
244     }
245 
246     function freeze() onlyInternal {
247         _saleState = TokenSaleState.Frozen;
248     }
249 
250     function unfreeze() onlyInternal {
251         _saleState = TokenSaleState.Presale;
252         updateTokenSaleState();
253     }
254 
255     function startSalePhase (uint start, uint length) onlyInternal {
256         if (_saleState == TokenSaleState.Presale) throw;
257         if (length == 0) throw;
258         if (start == 0) start = block.number;
259 
260         startBlock = start;
261         endBlock = startBlock + length;
262 
263         updateTokenSaleState();
264     }
265 
266 }