1 pragma solidity ^0.4.16;
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
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 {
51   uint256 public totalSupply;
52   function balanceOf(address who) constant returns (uint256);
53   function transfer(address to, uint256 value) returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title Token
63  * @dev Adds token security measures
64  */
65 contract Token is ERC20 { using SafeMath for uint;
66 
67     mapping (address => uint256) balances;
68 
69     mapping (address => mapping (address => uint256)) allowed;
70 
71     /**
72     * @dev Fix for the ERC20 short address attack.
73     */
74     modifier onlyPayloadSize(uint size) {
75         if(msg.data.length < size + 4) revert();
76         _;
77     }
78 
79     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
80         if (balances[msg.sender] >= _value && _value > 0) {
81             balances[msg.sender] = balances[msg.sender].sub(_value);
82             balances[_to] = balances[_to].add(_value);
83             Transfer(msg.sender, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
89         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
90             balances[_to] = balances[_to].add(_value);
91             balances[_from] = balances[_from].sub(_value);
92             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93             Transfer(_from, _to, _value);
94             return true;
95         } else { return false; }
96     }
97 
98     function approve(address _spender, uint256 _value) returns (bool success) {
99         // To change the approve amount you first have to reduce the addresses`
100         //  allowance to zero by calling `approve(_spender, 0)` if it is not
101         //  already 0 to mitigate the race condition described here:
102         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
104 
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     // A vulernability of the approve method in the ERC20 standard was identified by
111     // Mikhail Vladimirov and Dmitry Khovratovich here:
112     // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
113     // It's better to use this method which is not susceptible to over-withdrawing by the approvee.
114     /// @param _spender The address to approve
115     /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)
116     /// @param _newValue The new value to approve, this will replace the _currentValue
117     /// @return bool Whether the approval was a success (see ERC20's `approve`)
118     function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
119         if (allowed[msg.sender][_spender] != _currentValue) {
120             return false;
121         }
122             return approve(_spender, _newValue);
123     }
124 
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126       return allowed[_owner][_spender];
127     }
128 
129     function balanceOf(address _owner) constant returns (uint256 balance) {
130         return balances[_owner];
131     }
132 }
133 
134 /**
135  *  @title CHEX Token
136  *  @dev ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
137  */
138 contract CHEXToken is Token { using SafeMath for uint;
139 
140     string public constant name = "CHEX Token";
141     string public constant symbol = "CHX";
142     uint public constant decimals = 18;
143     uint public startBlock; //crowdsale start block
144     uint public endBlock; //crowdsale end block
145 
146     address public founder;
147     
148     uint public tokenCap = 1000000000 * 10**decimals; // 1b tokens, each divided to up to 10^decimals units.
149     uint public crowdsaleAllocation = tokenCap; //100% of token supply allocated for crowdsale
150     uint public crowdsaleSupply = 0;
151 
152     uint public transferLockup = 5760; //no transfers until ~1 day after crowdsale ends
153     bool public frozen = false;  //in case of emergency, freeze purchase of tokens
154 
155     uint public etherRaised = 0; //for reporting direct ether amount raised
156 
157     uint public constant MIN_ETHER = 1 finney; //minimum ether required to buy tokens
158 
159     function CHEXToken(address founderInput, uint startBlockInput, uint endBlockInput) {
160         founder = founderInput;
161         startBlock = startBlockInput;
162         endBlock = endBlockInput;
163     }
164 
165     function() payable {
166         buy(msg.sender);
167     }
168 
169     function price() constant returns(uint) {
170         if (block.number < startBlock) return 42007;
171         if (block.number >= startBlock && block.number <= endBlock) {
172             uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);
173             return 21000 + 21 * percentRemaining;
174         }
175         return 21000;
176     }
177 
178     function buy(address recipient) payable {
179         if (frozen) revert();
180         if (recipient == 0x0) revert();
181         if (msg.value < MIN_ETHER) revert();
182 
183         uint tokens = msg.value.mul(price());
184         uint nextTotal = totalSupply.add(tokens);
185 
186         if (nextTotal > tokenCap) revert();
187         
188         balances[recipient] = balances[recipient].add(tokens);
189 
190         totalSupply = nextTotal;
191 
192         if (block.number <= endBlock) {
193             crowdsaleSupply = nextTotal;
194             etherRaised = etherRaised.add(msg.value);
195         }
196 
197         Transfer(0, recipient, tokens);
198     }
199 
200     /*
201     * TRANSFER LOCK
202     */
203     function transfer(address _to, uint256 _value) returns (bool success) {
204         if (block.number <= endBlock + transferLockup && msg.sender != founder) return false;
205         return super.transfer(_to, _value);
206     }
207 
208     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
209         if (block.number <= endBlock + transferLockup && msg.sender != founder) return false;
210         return super.transferFrom(_from, _to, _value);
211     }
212 
213     function pct(uint numerator, uint denominator, uint precision) internal returns(uint quotient) {
214         uint _numerator = numerator * 10 ** (precision+1);
215         uint _quotient = ((_numerator / denominator) + 5) / 10;
216         return (_quotient);
217     }
218 
219     /*
220     * FOR AUTHORIZED USE ONLY
221     */
222     modifier onlyInternal {
223         require(msg.sender == founder);
224         _;
225     }
226 
227     function freeze() onlyInternal {
228         frozen = true;
229     }
230 
231     function unfreeze() onlyInternal {
232         frozen = false;
233     }
234 
235     function withdrawFunds() onlyInternal {
236 		if (this.balance == 0) revert();
237 
238 		founder.transfer(this.balance);
239 	}
240 
241     function changeFounder(address _newAddress) onlyInternal {
242         if (msg.sender != founder) revert();
243         if (_newAddress == 0x0) revert();
244         
245 
246 		founder = _newAddress;
247 	}
248 
249 }