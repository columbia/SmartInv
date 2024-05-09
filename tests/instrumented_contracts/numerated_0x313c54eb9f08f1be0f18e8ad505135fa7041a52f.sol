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
140     uint public constant MIN_ETHER = 10 finney;
141 
142     enum TokenSaleState {
143         Initial,    //contract initialized, bonus token
144         Presale,    //limited time crowdsale
145         Live,       //default price
146         Frozen      //prevent sale of tokens
147     }
148 
149     TokenSaleState public _saleState = TokenSaleState.Initial;
150 
151     function CHEXToken(address founderInput, address ownerInput, uint startBlockInput, uint endBlockInput) {
152         founder = founderInput;
153         owner = ownerInput;
154         startBlock = startBlockInput;
155         endBlock = endBlockInput;
156         
157         updateTokenSaleState();
158     }
159 
160     function price() constant returns(uint) {
161         if (_saleState == TokenSaleState.Initial) return 6001;
162         if (_saleState == TokenSaleState.Presale) {
163             uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);
164             return 3000 + 3 * percentRemaining;
165         }
166         return 3000;
167     }
168 
169     function updateTokenSaleState () {
170         if (_saleState == TokenSaleState.Frozen) return;
171 
172         if (_saleState == TokenSaleState.Live && block.number > endBlock) return;
173         
174         if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {
175             _saleState = TokenSaleState.Presale;
176         }
177         
178         if (_saleState == TokenSaleState.Presale && block.number > endBlock) {
179             _saleState = TokenSaleState.Live;
180         }
181     }
182 
183     function() payable {
184         buy(msg.sender);
185     }
186 
187     function buy(address recipient) payable {
188         if (recipient == 0x0) throw;
189         if (msg.value < MIN_ETHER) throw;
190         if (_saleState == TokenSaleState.Frozen) throw;
191         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
192         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleEtherRaised >= etherCap) throw;
193 
194         updateTokenSaleState();
195         uint tokens = mul(msg.value, price());
196 
197         if (tokens <= 0) throw;
198         
199         balances[recipient] = add(balances[recipient], tokens);
200         totalTokens = add(totalTokens, tokens);
201 
202         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
203             presaleEtherRaised = add(presaleEtherRaised, msg.value);
204             presaleSupply = add(presaleSupply, tokens);
205         }
206 
207         founder.transfer(msg.value);
208         
209         Transfer(0, recipient, tokens);
210         Buy(recipient, msg.value, tokens);
211     }
212 
213     modifier onlyInternal {
214         require(msg.sender == owner || msg.sender == founder);
215         _;
216     }
217 
218     function deliver(address recipient, uint tokens, string _for) onlyInternal {
219         if (tokens <= 0) throw;
220         if (totalTokens >= totalSupply) throw;
221         if (_saleState == TokenSaleState.Frozen) throw;
222         if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;
223 
224         updateTokenSaleState();
225 
226         balances[recipient] = add(balances[recipient], tokens);
227         totalTokens = add(totalTokens, tokens);
228 
229         if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {
230             presaleSupply = add(presaleSupply, tokens);
231         }
232 
233         Transfer(0, recipient, tokens);    
234         Deliver(recipient, tokens, _for);
235     }
236 
237     function allocateEcosystemTokens() onlyInternal {
238         if (block.number <= endBlock) throw;
239         if (ecosystemAllocated) throw;
240 
241         balances[owner] = add(balances[owner], ecosystemAllocation);
242         totalTokens = add(totalTokens, ecosystemAllocation);
243 
244         balances[founder] = add(balances[founder], reservedAllocation);
245         totalTokens = add(totalTokens, reservedAllocation);
246 
247         ecosystemAllocated = true;
248     }
249 
250     function freeze() onlyInternal {
251         _saleState = TokenSaleState.Frozen;
252     }
253 
254     function unfreeze() onlyInternal {
255         _saleState = TokenSaleState.Presale;
256         updateTokenSaleState();
257     }
258 
259     function startSalePhase (uint start, uint length) onlyInternal {
260         if (_saleState == TokenSaleState.Presale) throw;
261         if (length == 0) throw;
262         if (start == 0) start = block.number;
263 
264         startBlock = start;
265         endBlock = startBlock + length;
266 
267         updateTokenSaleState();
268     }
269 
270 }