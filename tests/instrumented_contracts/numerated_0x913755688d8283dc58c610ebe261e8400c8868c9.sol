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
136     uint public ecosystemAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for the ecosystem fund
137     uint public reservedAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for internal
138     bool public ecosystemAllocated = false;
139 
140     uint public transferLockup = 40320; //No transfers until 1 week after sale is over
141 
142     uint public constant MIN_ETHER = 1 finney;
143 
144     enum TokenSaleState {
145         Initial,    //contract initialized, bonus token
146         Presale,    //limited time crowdsale
147         Live,       //default price
148         Frozen      //prevent sale of tokens
149     }
150 
151     TokenSaleState public _saleState = TokenSaleState.Initial;
152 
153     function CHEXToken(address founderInput, address ownerInput, uint startBlockInput, uint endBlockInput) {
154         founder = founderInput;
155         owner = ownerInput;
156         startBlock = startBlockInput;
157         endBlock = endBlockInput;
158         
159         updateTokenSaleState();
160     }
161 
162     function price() constant returns(uint) {
163         if (_saleState == TokenSaleState.Initial) return 6001;
164         if (_saleState == TokenSaleState.Presale) {
165             uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);
166             return 3000 + 3 * percentRemaining;
167         }
168         return 3000;
169     }
170 
171     function updateTokenSaleState () {
172         if (_saleState == TokenSaleState.Frozen) return;
173 
174         if (_saleState == TokenSaleState.Live && block.number > endBlock) return;
175         
176         if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {
177             _saleState = TokenSaleState.Presale;
178         }
179         
180         if (_saleState == TokenSaleState.Presale && block.number > endBlock) {
181             _saleState = TokenSaleState.Live;
182         }
183     }
184 
185     function() payable {
186         buy(msg.sender);
187     }
188 
189     function buy(address recipient) payable {
190         if (recipient == 0x0) throw;
191         if (msg.value < MIN_ETHER) throw;
192         if (_saleState == TokenSaleState.Frozen) throw;
193         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
194         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleEtherRaised >= etherCap) throw;
195 
196         updateTokenSaleState();
197         uint tokens = mul(msg.value, price());
198 
199         if (tokens <= 0) throw;
200         
201         balances[recipient] = add(balances[recipient], tokens);
202         totalTokens = add(totalTokens, tokens);
203 
204         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
205             presaleEtherRaised = add(presaleEtherRaised, msg.value);
206             presaleSupply = add(presaleSupply, tokens);
207         }
208 
209         founder.transfer(msg.value);
210         
211         Transfer(0, recipient, tokens);
212         Buy(recipient, msg.value, tokens);
213     }
214 
215     function transfer(address _to, uint256 _value) returns (bool success) {
216         if (block.number <= endBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;
217         return super.transfer(_to, _value);
218     }
219 
220     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
221         if (block.number <= endBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;
222         return super.transferFrom(_from, _to, _value);
223     }
224 
225     modifier onlyInternal {
226         require(msg.sender == owner || msg.sender == founder);
227         _;
228     }
229 
230     function deliver(address recipient, uint tokens, string _for) onlyInternal {
231         if (tokens <= 0) throw;
232         if (totalTokens >= totalSupply) throw;
233         if (_saleState == TokenSaleState.Frozen) throw;
234         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
235 
236         updateTokenSaleState();
237 
238         balances[recipient] = add(balances[recipient], tokens);
239         totalTokens = add(totalTokens, tokens);
240 
241         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
242             presaleSupply = add(presaleSupply, tokens);
243         }
244 
245         Transfer(0, recipient, tokens);    
246         Deliver(recipient, tokens, _for);
247     }
248 
249     function allocateEcosystemTokens() onlyInternal {
250         if (block.number <= endBlock) throw;
251         if (ecosystemAllocated) throw;
252 
253         balances[owner] = add(balances[owner], ecosystemAllocation);
254         totalTokens = add(totalTokens, ecosystemAllocation);
255 
256         balances[founder] = add(balances[founder], reservedAllocation);
257         totalTokens = add(totalTokens, reservedAllocation);
258 
259         ecosystemAllocated = true;
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
271     function startSalePhase (uint start, uint length) onlyInternal {
272         if (_saleState == TokenSaleState.Presale) throw;
273         if (length == 0) throw;
274         if (start == 0) start = block.number;
275 
276         startBlock = start;
277         endBlock = startBlock + length;
278 
279         updateTokenSaleState();
280     }
281 
282 }