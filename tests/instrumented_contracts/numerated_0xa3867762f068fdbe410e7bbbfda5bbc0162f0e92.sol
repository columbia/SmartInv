1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 }
28 /**
29  * @title Pausable
30  * @dev Base contract which allows children to implement an emergency stop mechanism.
31  */
32 contract Pausable is Ownable {
33   event Pause();
34   event Unpause();
35   event PrivateFundEnabled();
36   event PrivateFundDisabled();
37 
38   bool public paused = false;
39   bool public privateFundEnabled = true;
40 
41   /**
42    * @dev Modifier to make a function callable only when the contract is private fund not end.
43    */
44   modifier whenPrivateFundDisabled() {
45     require(!privateFundEnabled);
46     _;
47   }
48   
49   /**
50    * @dev Modifier to make a function callable only when the contract is private fund end.
51    */
52   modifier whenPrivateFundEnabled() {
53     require(privateFundEnabled);
54     _;
55   }
56 
57   /**
58    * @dev called by the owner to end private fund, triggers stopped state
59    */
60   function disablePrivateFund() onlyOwner whenPrivateFundEnabled public {
61     privateFundEnabled = false;
62     emit PrivateFundDisabled();
63   }
64 
65   /**
66    * @dev called by the owner to unlock private fund, returns to normal state
67    */
68   function enablePrivateFund() onlyOwner whenPrivateFundDisabled public {
69     privateFundEnabled = true;
70     emit PrivateFundEnabled();
71   }
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     emit Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     emit Unpause();
103   }
104 }
105 
106 library SafeMath {
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     if (a == 0) {
109       return 0;
110     }
111     uint256 c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     uint256 c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return c;
121   }
122 
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
134 contract ERC20 {
135   uint256 public totalSupply;
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139   function allowance(address owner, address spender) public view returns (uint256);
140   function transferFrom(address from, address to, uint256 value) public returns (bool);
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 contract GlobalSharingEconomyCoin is Pausable, ERC20 {
146   using SafeMath for uint256;
147   event BatchTransfer(address indexed owner, bool value);
148 
149   string public name;
150   string public symbol;
151   uint8 public decimals;
152 
153   mapping(address => uint256) balances;
154   mapping (address => mapping (address => uint256)) internal allowed;
155   mapping (address => bool) allowedBatchTransfers;
156 
157   constructor() public {
158     name = "GlobalSharingEconomyCoin";
159     symbol = "GSE";
160     decimals = 8;
161     totalSupply = 10000000000 * 10 ** uint256(decimals);
162     balances[msg.sender] = totalSupply;
163     allowedBatchTransfers[msg.sender] = true;
164   }
165 
166   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   function setBatchTransfer(address _address, bool _value) public onlyOwner returns (bool) {
177     allowedBatchTransfers[_address] = _value;
178     emit BatchTransfer(_address, _value);
179     return true;
180   }
181 
182   function getBatchTransfer(address _address) public onlyOwner view returns (bool) {
183     return allowedBatchTransfers[_address];
184   }
185 
186   /**
187    * 只允许项目方空投，如果项目方禁止批量转币，也同时禁用空投
188    */
189   function airdrop(address[] _funds, uint256 _amount) public whenNotPaused whenPrivateFundEnabled returns (bool) {
190     require(allowedBatchTransfers[msg.sender]);
191     uint256 fundslen = _funds.length;
192     // 根据gaslimit的限制，超过300个地址的循环基本就无法成功执行了
193     require(fundslen > 0 && fundslen < 300);
194     
195     uint256 totalAmount = 0;
196     for (uint i = 0; i < fundslen; ++i){
197       balances[_funds[i]] = balances[_funds[i]].add(_amount);
198       totalAmount = totalAmount.add(_amount);
199       emit Transfer(msg.sender, _funds[i], _amount);
200     }
201 
202     // 如果执行失败，则会回滚整个交易
203     require(balances[msg.sender] >= totalAmount);
204     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
205     return true;
206   }
207 
208   /**
209    * 允许交易所和项目放方批量转币
210    * _funds: 批量转币地址
211    * _amounts: 每个地址的转币数量，长度必须跟_funds的长度相同
212    */
213   function batchTransfer(address[] _funds, uint256[] _amounts) public whenNotPaused whenPrivateFundEnabled returns (bool) {
214     require(allowedBatchTransfers[msg.sender]);
215     uint256 fundslen = _funds.length;
216     uint256 amountslen = _amounts.length;
217     require(fundslen == amountslen && fundslen > 0 && fundslen < 300);
218 
219     uint256 totalAmount = 0;
220     for (uint i = 0; i < amountslen; ++i){
221       totalAmount = totalAmount.add(_amounts[i]);
222     }
223 
224     require(balances[msg.sender] >= totalAmount);
225     for (uint j = 0; j < amountslen; ++j) {
226       balances[_funds[j]] = balances[_funds[j]].add(_amounts[j]);
227       emit Transfer(msg.sender, _funds[j], _amounts[j]);
228     }
229     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
230     return true;
231   }
232 
233   function balanceOf(address _owner) public view returns (uint256 balance) {
234     return balances[_owner];
235   }
236 
237   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     emit Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   function allowance(address _owner, address _spender) public view returns (uint256) {
256     return allowed[_owner][_spender];
257   }
258 }