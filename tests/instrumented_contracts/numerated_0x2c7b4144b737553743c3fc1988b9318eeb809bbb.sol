1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a, "SafeMath: subtraction overflow");
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title Standard ERC20 token
70  *
71  * @dev Implementation of the basic standard token.
72  * https://eips.ethereum.org/EIPS/eip-20
73  * Originally based on code by FirstBlood:
74  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
75  *
76  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
77  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
78  * compliant implementations may not do it.
79  */
80  
81  interface ERC20 {
82     function balanceOf(address _owner) external view returns (uint balance);
83     function transfer(address _to, uint _value) external returns (bool success);
84     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
85     function approve(address _spender, uint _value) external returns (bool success);
86     function allowance(address _owner, address _spender) external view returns (uint remaining);
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint _value);
89 }
90  
91  
92  contract Token is ERC20 {
93     using SafeMath for uint256;
94     string public name;
95     string public symbol;
96     uint256 public totalSupply;
97     uint8 public decimals;
98     mapping (address => uint256) private balances;
99     mapping (address => mapping (address => uint256)) private allowed;
100 
101     constructor(string memory _tokenName, string memory _tokenSymbol,uint256 _initialSupply,uint8 _decimals) public {
102         decimals = _decimals;
103         totalSupply = _initialSupply * 10 ** uint256(decimals);
104         name = _tokenName;
105         symbol = _tokenSymbol;
106         balances[msg.sender] = totalSupply;
107     }
108 
109     function transfer(address _to, uint256 _value) public returns (bool) {
110         require(_to != address(0));
111         require(_value <= balances[msg.sender]);
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         emit Transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     function balanceOf(address _owner) public view returns (uint256 balance) {
119         return balances[_owner];
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         emit Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function approve(address _spender, uint256 _value) public returns (bool) {
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     function allowance(address _owner, address _spender) public view returns (uint256) {
140         return allowed[_owner][_spender];
141     }
142 
143 }
144 
145 contract ethGame{
146     using SafeMath for uint256;
147     
148     Token GainToken; // uds
149     
150     uint256 private _stageSn = 60; // rate
151     uint256 private _stage = 1; // stage
152     uint256 private _stageToken = 0; // stage total Gain
153     uint256 private _totalCoin = 0; // total Cost eth
154     uint256 private _totalGain = 0; // total Gain uds
155     
156     
157     address private owner;
158     
159     mapping (address => uint256) private _balances;
160     
161     event Exchange(address _from, uint256 value);
162     
163     constructor(address GainAddress,uint256 StageSn) public {
164         GainToken = Token(GainAddress); // uds
165         _stageSn = StageSn;
166         
167         owner = msg.sender;
168     }
169     
170     modifier onlyOwner() {
171         require(msg.sender == owner);
172         _;
173     }
174     
175     function setOwner(address _owner) public onlyOwner returns(bool) {
176         owner = _owner;
177         return true;
178     }
179     
180     function withdraw(uint256 value) public onlyOwner returns(bool){
181         (msg.sender).transfer(value);
182         return true;
183     }
184     
185     function exchange() public payable returns (bool){
186         // 0.001 eth
187         require(msg.value >= 1000000000000000,'value minimum');
188 
189         // gain to
190         uint256 gain = getGain(msg.value);
191         GainToken.transferFrom(address(owner),msg.sender,gain);
192         
193         // total gain
194         _totalGain = _totalGain.add(gain);
195         
196         // total eth
197         _totalCoin = _totalCoin.add(msg.value);
198         
199         // balance
200         _balances[msg.sender] = _balances[msg.sender].add(gain);
201         //_balances[msg.sender] = _balances[msg.sender].add(msg.value);
202         
203         emit Exchange(msg.sender, gain);
204         return true;
205     }
206     
207     function getGain(uint256 value) private returns (uint256){  
208         uint256 sn = getStageTotal(_stage);
209         uint256 rate = sn.div(_stageSn);  // stage rate
210         
211         uint256 gain = 0;
212         
213         // stage balance
214         uint256 TmpGain = rate.mul(value).div(10**18);// 6wei
215         
216         // TmpGain == sn 6wei
217         uint256 TmpStageToken = _stageToken.mul(1000).add(TmpGain); // usdt
218         
219         // (_stageToken + TmpGain ) / 10**6
220         if(sn < TmpStageToken){
221             //  sn - _stageToken * 1000
222             uint256 TmpStageTotal = _stageToken.mul(1000);
223             // stage balance
224             uint256 TmpGainAdd = sn.sub(TmpStageTotal); // 6
225             gain = gain.add(TmpGainAdd.div(10**3)); // uds
226             
227             //  next stage
228             _stage = _stage.add(1);
229             _stageToken = 0;
230             
231             uint256 LowerSn = getStageTotal(_stage);
232             
233             uint256 LowerRate = LowerSn.div(_stageSn);
234             
235             // LowerRate / rate
236             uint256 LastRate = LowerRate.mul(10**10).div(rate);
237             uint256 LowerGain = (TmpGain - TmpGainAdd).mul(LastRate);
238             
239             // game max
240             require(LowerSn >= LowerGain.div(10**10),'exceed max');
241             
242             // stage gain
243             _stageToken = _stageToken.add(LowerGain.div(10**13));
244             
245             gain = gain.add(LowerGain.div(10**13)); // LastRate 10 ** 7
246             
247             return gain;
248         }else{
249             // value * rate 
250             gain = value.mul(rate);
251             
252             // stage gain
253             _stageToken = _stageToken.add(gain.div(10**21));
254             
255             return gain.div(10**21); // 3
256         }
257     }
258     
259     function setStage(uint256 n) public onlyOwner returns (bool){
260         _stage = n;
261         return true;
262     }
263     
264     function setStageToken(uint256 value) public onlyOwner returns (bool){
265         _stageToken = value;
266         return true;
267     }
268     
269     function getStageTotal(uint256 n) public pure returns (uint256) {
270         require(n>=1);
271         require(n<=1000);
272         uint256 a = 1400000 * 14400 - 16801 * n ** 2;
273         uint256 b = (250000 - (n - 499) ** 2) * 22 * 1440;
274         uint256 c = 108722 * 1000000;
275         uint256 d = 14400 * 100000;
276         uint256 sn = (a - b) * c / d;
277         return sn; //  stage total 6
278     }
279     
280     function getAttr() public view returns (uint256[4] memory){
281         uint256[4] memory attr = [_stage,_stageToken,_totalCoin,_totalGain];
282         return attr;
283     }
284     
285     function balanceOf(address _owner) public view returns (uint256 balance) {
286         return _balances[_owner];
287     }
288     
289 }