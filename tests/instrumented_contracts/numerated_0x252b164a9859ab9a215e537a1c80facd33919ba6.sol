1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 contract ERC20 {
70   function totalSupply() public constant returns (uint256);
71 
72   function balanceOf(address _who) public constant returns (uint256);
73 
74   function allowance(address _owner, address _spender) public constant returns (uint256);
75 
76   function transfer(address _to, uint256 _value) public returns (bool);
77 
78   function approve(address _spender, uint256 _fromValue,uint256 _toValue) public returns (bool);
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
81 
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 contract Ownable {
88   address public owner;
89 
90   event OwnershipRenounced(address indexed previousOwner);
91   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93   constructor() public {
94     owner = msg.sender;
95   }
96 
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   function renounceOwnership() public onlyOwner {
103     emit OwnershipRenounced(owner);
104     owner = address(0);
105   }
106 
107   function transferOwnership(address _newOwner) public onlyOwner {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 
113   
114 }
115 
116 contract Pausable is Ownable {
117   event Paused();
118   event Unpaused();
119 
120   bool public paused = false;
121 
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   modifier whenPaused() {
128     require(paused);
129     _;
130   }
131 
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Paused();
135   }
136 
137   function unpause() public onlyOwner whenPaused {
138     paused = false;
139     emit Unpaused();
140   }
141 }
142 
143 
144 
145 contract Lambda is ERC20, Pausable {
146   using SafeMath for uint256;
147 
148   mapping (address => uint256) balances;
149   mapping (address => mapping (address => uint256)) allowed;
150 
151   string public symbol;
152   string public  name;
153   uint256 public decimals;
154   uint256 _totalSupply;
155 
156   constructor() public {
157     symbol = "LAMB";
158     name = "Lambda";
159     decimals = 18;
160 
161     _totalSupply = 6*(10**27);
162     balances[owner] = _totalSupply;
163     emit Transfer(address(0), owner, _totalSupply);
164   }
165 
166   function totalSupply() public  constant returns (uint256) {
167     return _totalSupply;
168   }
169 
170   function balanceOf(address _owner) public  constant returns (uint256) {
171     return balances[_owner];
172   }
173 
174   function allowance(address _owner, address _spender) public  constant returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
179     require(_value <= balances[msg.sender]);
180     require(_to != address(0));
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   function approve(address _spender, uint256 _fromValue, uint256 _toValue) public whenNotPaused returns (bool) {
189     require(_spender != address(0));
190     require(allowed[msg.sender][_spender] ==_fromValue);
191     allowed[msg.sender][_spender] = _toValue;
192     emit Approval(msg.sender, _spender, _toValue);
193     return true;
194   }
195 
196   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199     require(_to != address(0));
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     emit Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   
209 }
210 
211 
212 contract LambdaLock {
213     using SafeMath for uint256;
214     Lambda internal LambdaToken;
215     
216     uint256 internal genesisTime= 1545814800;//固定时间  秒 2018-12-27 09:00:00;  //开始时间设为固定值
217     
218 
219     uint256 internal ONE_MONTHS = 120;  //1个月的秒
220 
221     address internal beneficiaryAddress;
222 
223     struct Claim {
224         
225         uint256 pct;
226         uint256 delay;
227         bool claimed;
228     } 
229 
230     Claim [] internal beneficiaryClaims;
231     uint256 internal totalClaimable;
232 
233     event Claimed(
234         address indexed user,
235         uint256 amount,
236         uint256 timestamp
237     );
238 
239     function claim() public returns (bool){
240         require(msg.sender == beneficiaryAddress); 
241         for(uint256 i = 0; i < beneficiaryClaims.length; i++){
242             Claim memory cur_claim = beneficiaryClaims[i];
243             if(cur_claim.claimed == false){
244                 if(cur_claim.delay.add(genesisTime) < block.timestamp){
245         
246                     uint256 amount = cur_claim.pct*(10**18);
247                     require(LambdaToken.transfer(msg.sender, amount));
248                     beneficiaryClaims[i].claimed = true;
249                     emit Claimed(msg.sender, amount, block.timestamp);
250                 }
251             }
252         }
253     }
254 
255     function getBeneficiary() public view returns (address) {
256         return beneficiaryAddress;
257     }
258 
259     function getTotalClaimable() public view returns (uint256) {
260         return totalClaimable;
261     }
262 }
263 
264 
265 contract lambdaTeam is LambdaLock {
266     using SafeMath for uint256;
267     
268 
269     constructor(Lambda _LambdaToken) public {
270         LambdaToken = _LambdaToken;
271         
272         
273         
274         beneficiaryAddress = 0xB969C916B3FDc4CbC611d477b866e96ab8EcC1E2 ;
275         totalClaimable = 1000000000 * (10 ** 18);
276         for(uint i=0;i<36;i++){
277             beneficiaryClaims.push(Claim( 27777777, ONE_MONTHS*(i+1), false));
278        }
279         
280     
281     }
282 }