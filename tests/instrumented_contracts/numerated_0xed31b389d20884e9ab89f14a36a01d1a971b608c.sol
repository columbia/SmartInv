1 pragma solidity ^0.4.12;
2 /**
3  * Overflow aware uint math functions.
4  */
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41         return a < b ? a : b;
42     }
43 
44 }
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) constant returns (uint256);
54   function transfer(address to, uint256 value) returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) constant returns (uint256);
64   function transferFrom(address from, address to, uint256 value) returns (bool);
65   function approve(address spender, uint256 value) returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 /**
70  * @title Token
71  * @dev Adds token security measures
72  */
73 contract Token is ERC20 { using SafeMath for uint;
74 
75     mapping (address => uint256) balances;
76 
77     mapping (address => mapping (address => uint256)) allowed;
78 
79     /**
80     * @dev Fix for the ERC20 short address attack.
81     */
82     modifier onlyPayloadSize(uint size) {
83         if(msg.data.length < size + 4) revert();
84         _;
85     }
86 
87     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
88         if (balances[msg.sender] >= _value && _value > 0) {
89             balances[msg.sender] = balances[msg.sender].sub(_value);
90             balances[_to] = balances[_to].add(_value);
91             Transfer(msg.sender, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
97         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
98             balances[_to] = balances[_to].add(_value);
99             balances[_from] = balances[_from].sub(_value);
100             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101             Transfer(_from, _to, _value);
102             return true;
103         } else { return false; }
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         // To change the approve amount you first have to reduce the addresses`
108         //  allowance to zero by calling `approve(_spender, 0)` if it is not
109         //  already 0 to mitigate the race condition described here:
110         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
112 
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     // A vulernability of the approve method in the ERC20 standard was identified by
119     // Mikhail Vladimirov and Dmitry Khovratovich here:
120     // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
121     // It's better to use this method which is not susceptible to over-withdrawing by the approvee.
122     /// @param _spender The address to approve
123     /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)
124     /// @param _newValue The new value to approve, this will replace the _currentValue
125     /// @return bool Whether the approval was a success (see ERC20's `approve`)
126     function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
127         if (allowed[msg.sender][_spender] != _currentValue) {
128             return false;
129         }
130             return approve(_spender, _newValue);
131     }
132 
133     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134       return allowed[_owner][_spender];
135     }
136 
137     function balanceOf(address _owner) constant returns (uint256 balance) {
138         return balances[_owner];
139     }
140 }
141 
142 /**
143  *  @title CHEXToken
144  *  @dev ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
145  */
146 contract CHEXToken is Token { using SafeMath for uint;
147 
148     string public constant name = "CHEX Token";
149     string public constant symbol = "CHX";
150     uint public constant decimals = 18;
151     uint public startBlock; //crowdsale start block
152     uint public endBlock; //crowdsale end block
153 
154     address public founder;
155     
156     uint public tokenCap = 2000000000 * 10**decimals; // 2b tokens, each divided to up to 10^decimals units.
157     uint public crowdsaleSupply = 0;
158 
159     event Issuance(address indexed recipient, uint chx, uint eth);
160 
161     uint public crowdsaleAllocation = tokenCap; //100% of token supply allocated for crowdsale
162 
163     uint public etherRaised = 0;
164 
165     uint public constant MIN_ETHER = 1 finney; //minimum ether required to buy tokens
166     uint public constant HALVING_DELAY = 460800; //~80 days after sale begins, drop discount to 25%
167 
168     enum TokenSaleState {
169         Initial,    //contract initialized, bonus token
170         Crowdsale,  //limited time crowdsale
171         Live,       //default price
172         Frozen      //prevent sale of tokens
173     }
174 
175     TokenSaleState public _saleState = TokenSaleState.Initial;
176 
177     function CHEXToken(address founderInput, uint startBlockInput, uint endBlockInput) {
178         founder = founderInput;
179         startBlock = startBlockInput;
180         endBlock = endBlockInput;
181         
182         updateTokenSaleState();
183     }
184 
185     function price() constant returns(uint) {
186         if (_saleState == TokenSaleState.Initial) return 42007;
187         if (_saleState == TokenSaleState.Crowdsale) {
188             uint discount = 1000;
189             if (block.number > startBlock + HALVING_DELAY) discount = 500;
190             return 21000 + 21 * discount;
191         }
192         return 21000;
193     }
194 
195     function() payable {
196         buy(msg.sender);
197     }
198 
199     function tokenFallback() payable {
200         buy(msg.sender);
201     }
202 
203     function buy(address recipient) payable {
204         if (recipient == 0x0) revert();
205         if (msg.value < MIN_ETHER) revert();
206         if (_saleState == TokenSaleState.Frozen) revert();
207         
208         updateTokenSaleState();
209 
210         uint tokens = msg.value.mul(price());
211         uint nextTotal = totalSupply.add(tokens);
212         uint nextCrowdsaleTotal = crowdsaleSupply.add(tokens);
213 
214         if (nextTotal >= tokenCap) revert();
215         if (nextCrowdsaleTotal >= crowdsaleAllocation) revert();
216         
217         balances[recipient] = balances[recipient].add(tokens);
218 
219         totalSupply = nextTotal;
220         crowdsaleSupply = nextCrowdsaleTotal;
221     
222         etherRaised = etherRaised.add(msg.value);
223         
224         Transfer(0, recipient, tokens);
225         Issuance(recipient, tokens, msg.value);
226     }
227 
228     function updateTokenSaleState () {
229         if (_saleState == TokenSaleState.Frozen) return;
230 
231         if (_saleState == TokenSaleState.Live && block.number > endBlock) return;
232         
233         if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {
234             _saleState = TokenSaleState.Crowdsale;
235         }
236         
237         if (_saleState == TokenSaleState.Crowdsale && block.number > endBlock) {
238             _saleState = TokenSaleState.Live;
239         }
240     }
241 
242     /*
243     * FOR AUTHORIZED USE ONLY
244     */
245     modifier onlyInternal {
246         require(msg.sender == founder);
247         _;
248     }
249 
250     function freeze() onlyInternal {
251         _saleState = TokenSaleState.Frozen;
252     }
253 
254     function unfreeze() onlyInternal {
255         _saleState = TokenSaleState.Initial;
256         updateTokenSaleState();
257     }
258 
259     function withdrawFunds() onlyInternal {
260 		if (this.balance == 0) revert();
261 
262 		founder.transfer(this.balance);
263 	}
264 
265     function changeFounder(address _newAddress) onlyInternal {
266         if (msg.sender != founder) revert();
267         if (_newAddress == 0x0) revert();
268         
269 
270 		founder = _newAddress;
271 	}
272 
273 }