1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 /**
48  * @title Basic token
49  * @dev Basic version of StandardToken, with no allowances. 
50  */
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) returns (bool) {
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of. 
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) constant returns (uint256 balance) {
74     return balances[_owner];
75   }
76 }
77 
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) returns (bool);
86   function approve(address spender, uint256 value) returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still avaible for the spender.
145    */
146   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 
153 
154 contract DEST  is StandardToken {
155 
156   // Constants
157   // =========
158 
159   string public constant name = "Decentralized Escrow Token";
160   string public constant symbol = "DEST";
161   uint   public constant decimals = 18;
162 
163   uint public constant ETH_MIN_LIMIT = 500 ether;
164   uint public constant ETH_MAX_LIMIT = 1500 ether;
165 
166   uint public constant START_TIMESTAMP = 1503824400; // 2017-08-27 09:00:00 UTC
167   uint public constant END_TIMESTAMP   = 1506816000; // 2017-10-01 00:00:00 UTC
168 
169   address public constant wallet = 0x51559EfC1AcC15bcAfc7E0C2fB440848C136A46B;
170 
171 
172   // State variables
173   // ===============
174 
175   uint public ethCollected;
176   mapping (address=>uint) ethInvested;
177 
178 
179   // Constant functions
180   // =========================
181 
182   function hasStarted() public constant returns (bool) {
183     return now >= START_TIMESTAMP;
184   }
185 
186 
187   // Payments are not accepted after ICO is finished.
188   function hasFinished() public constant returns (bool) {
189     return now >= END_TIMESTAMP || ethCollected >= ETH_MAX_LIMIT;
190   }
191 
192 
193   // Investors can move their tokens only after ico has successfully finished
194   function tokensAreLiquid() public constant returns (bool) {
195     return (ethCollected >= ETH_MIN_LIMIT && now >= END_TIMESTAMP)
196       || (ethCollected >= ETH_MAX_LIMIT);
197   }
198 
199 
200   function price(uint _v) public constant returns (uint) {
201     return // poor man's binary search
202       _v < 7 ether
203         ? _v < 3 ether
204           ? _v < 1 ether
205             ? 1000
206             : _v < 2 ether ? 1005 : 1010
207           : _v < 4 ether
208             ? 1015
209             : _v < 5 ether ? 1020 : 1030
210         : _v < 14 ether
211           ? _v < 10 ether
212             ? _v < 9 ether ? 1040 : 1050
213             : 1080
214           : _v < 100 ether
215             ? _v < 20 ether ? 1110 : 1150
216             : 1200;
217   }
218 
219 
220   // Public functions
221   // =========================
222 
223   function() public payable {
224     require(hasStarted() && !hasFinished());
225     require(ethCollected + msg.value <= ETH_MAX_LIMIT);
226 
227     ethCollected += msg.value;
228     ethInvested[msg.sender] += msg.value;
229 
230     uint _tokenValue = msg.value * price(msg.value);
231     balances[msg.sender] += _tokenValue;
232     totalSupply += _tokenValue;
233     Transfer(0x0, msg.sender, _tokenValue);
234   }
235 
236 
237   // Investors can get refund if ETH_MIN_LIMIT is not reached.
238   function refund() public {
239     require(ethCollected < ETH_MIN_LIMIT && now >= END_TIMESTAMP);
240     require(balances[msg.sender] > 0);
241 
242     totalSupply -= balances[msg.sender];
243     balances[msg.sender] = 0;
244     uint _ethRefund = ethInvested[msg.sender];
245     ethInvested[msg.sender] = 0;
246     msg.sender.transfer(_ethRefund);
247   }
248 
249 
250   // Owner can withdraw all the money after min_limit is reached.
251   function withdraw() public {
252     require(ethCollected >= ETH_MIN_LIMIT);
253     wallet.transfer(this.balance);
254   }
255 
256 
257   // ERC20 functions
258   // =========================
259 
260   function transfer(address _to, uint _value) public returns (bool)
261   {
262     require(tokensAreLiquid());
263     return super.transfer(_to, _value);
264   }
265 
266 
267   function transferFrom(address _from, address _to, uint _value)
268     public returns (bool)
269   {
270     require(tokensAreLiquid());
271     return super.transferFrom(_from, _to, _value);
272   }
273 
274 
275   function approve(address _spender, uint _value)
276     public returns (bool)
277   {
278     require(tokensAreLiquid());
279     return super.approve(_spender, _value);
280   }
281 }