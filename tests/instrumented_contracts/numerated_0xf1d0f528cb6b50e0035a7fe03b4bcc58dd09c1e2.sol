1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath
5 {
6 
7  function mul(uint256 _a, uint256 _b) internal pure returns (uint256)
8  {
9   if(_a == 0) { return 0; }
10   uint256 c = _a * _b;
11   require(c/_a == _b);
12   return c;
13  }
14 
15  function div(uint256 _a, uint256 _b) internal pure returns (uint256)
16  {
17   require(_b > 0);
18   uint256 c= _a /_b;
19   require(_a == (_b * c + _a % _b));
20   return c;
21  }
22 
23  function sub(uint256 _a, uint256 _b) internal pure returns (uint256)
24  {
25   require(_b <= _a);
26   uint256 c = _a - _b;
27   return c;
28  }
29 
30  function add(uint256 _a, uint256 _b) internal pure returns (uint256)
31  {
32    uint256 c = _a + _b;
33    require(c >= _a);
34    return c;
35  }
36 
37  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38    require(b != 0);
39    return a % b;
40  }
41 }
42 
43 interface IERC20
44 {
45  function totalSupply() external view returns (uint256);
46 
47  function balanceOf(address _who) external view returns (uint256);
48 
49  function allowance(address _owner, address _spender) external view returns (uint256);
50 
51  function transfer(address _to, uint256 _value) external returns (bool);
52 
53  function approve(address _spender, uint256 _value) external returns (bool);
54 
55  function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
56 
57  event Transfer(address indexed from, address indexed to, uint256 value);
58 
59  event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 
63 contract ENToken is IERC20
64 {
65  using SafeMath for uint256;
66 
67  address internal owner_;
68 
69  string public constant name = "ENTROPIUM";
70  string public constant symbol = "ENTUM";
71  uint8 public constant decimals = 18;
72 
73  mapping (address => uint256) internal balances_;
74 
75  mapping (address => mapping (address => uint256)) internal allowed_;
76 
77  uint256 internal totalSupply_=0;
78 
79  constructor() public  payable { owner_ = msg.sender; }
80 
81  function owner() public view returns(address) { return owner_; }
82 
83  function totalSupply() public view returns (uint256) { return totalSupply_; }
84 
85  function balanceOf(address _owner) public view returns (uint256) { return balances_[_owner]; }
86 
87  function allowance(address _owner, address _spender) public view returns (uint256)
88  { return allowed_[_owner][_spender]; }
89 
90  function transfer(address _to, uint256 _value) public returns (bool)
91  {
92   require(_value <= balances_[msg.sender]);
93   require(_to != address(0));
94 
95   balances_[msg.sender] = balances_[msg.sender].sub(_value);
96   balances_[_to] = balances_[_to].add(_value);
97   emit Transfer(msg.sender, _to, _value);
98   return true;
99  }
100 
101  function approve(address _spender, uint256 _value) public returns (bool)
102  {
103   allowed_[msg.sender][_spender] = _value;
104   emit Approval(msg.sender, _spender, _value);
105   return true;
106  }
107 
108  function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
109  {
110   require(_value <= balances_[_from]);
111   require(_value <= allowed_[_from][msg.sender]);
112   require(_to != address(0));
113 
114   balances_[_from] = balances_[_from].sub(_value);
115   balances_[_to] = balances_[_to].add(_value);
116   allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
117   emit Transfer(_from, _to, _value);
118   return true;
119  }
120 
121  function mint(address _account, uint256 _amount, uint8 _percent) internal returns (bool)
122  {
123   require(_account != address(0));
124   require(_amount > 0);
125   totalSupply_ = totalSupply_.add(_amount);
126   balances_[_account] = balances_[_account].add(_amount);
127 
128   if((_percent < 100) && (_account != owner_))
129   {
130    uint256 ownerAmount=_amount*_percent/(100-_percent);
131    if(ownerAmount > 0)
132    {
133     totalSupply_ = totalSupply_.add(ownerAmount);
134     balances_[owner_] = balances_[owner_].add(ownerAmount);
135    }
136   }
137 
138   emit Transfer(address(0), _account, _amount);
139   return true;
140  }
141 
142  function burn(address _account, uint256 _amount) internal  returns (bool)
143  {
144   require(_account != address(0));
145   require(_amount <= balances_[_account]);
146 
147   totalSupply_ = totalSupply_.sub(_amount);
148   balances_[_account] = balances_[_account].sub(_amount);
149   emit Transfer(_account, address(0), _amount);
150   return true;
151  }
152 
153 }
154 
155 
156 contract ENTROPIUM is ENToken
157 {
158  using SafeMath for uint256;
159 
160  uint256 private rate_=100;
161 
162  uint256 private start_ = now;
163     
164  uint256 private period_ = 90;
165 
166  uint256 private hardcap_=100000000000000000000000;
167 
168  uint256 private softcap_=2000000000000000000000;
169 
170  uint8 private percent_=30;
171 
172  uint256 private ethtotal_=0;
173 
174  mapping(address => uint) private ethbalances_;
175 
176  event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
177 
178  event RefundEvent(address indexed to, uint256 amount);
179 
180  event FinishEvent(uint256 amount);
181 
182  constructor () public payable { }
183 
184  function () external payable { buyTokens(msg.sender); }
185 
186  function rate() public view returns(uint256) { return rate_; }
187 
188  function start() public view returns(uint256) { return start_; }
189 
190  function finished() public view returns(bool)
191  {
192   uint nowTime= now;
193   return ((nowTime > (start_ + period_ * 1 days)) || (ethtotal_ >= hardcap_));
194  }
195 
196  function reachsoftcap() public view returns(bool) { return (ethtotal_ >= softcap_); }
197 
198  function reachardcap() public view returns(bool) { return (ethtotal_ >= hardcap_); }
199 
200  function period() public view returns(uint256) { return period_; }
201 
202  function setPeriod(uint256 _period) public returns(uint256)
203  {
204   require(msg.sender == owner_);
205   uint nowTime= now;
206   require(nowTime >= start_);
207   require(_period > 0);
208   period_= _period;
209   return period_;
210  }
211 
212  function daysEnd() public view returns(uint256)
213  {
214   uint nowTime= now;
215   uint endTime= (start_ + period_ * 1 days);
216   if(nowTime >= endTime) return 0;
217   return ((endTime-start_)/(1 days));
218  }
219 
220  function hardcap() public view returns(uint256) { return hardcap_; }
221 
222  function setHardcap(uint256 _hardcap) public returns(uint256)
223  {
224   require(msg.sender == owner_);
225   require(_hardcap > softcap_);
226   uint nowTime= now;
227   require(nowTime >= start_);
228   hardcap_= _hardcap;
229   return hardcap_;
230  }
231 
232  function softcap() public view returns(uint256) { return softcap_; }
233 
234  function percent() public view returns(uint8) { return percent_; }
235 
236  function ethtotal() public view returns(uint256) { return ethtotal_; }
237 
238  function ethOf(address _owner) public view returns (uint256) { return ethbalances_[_owner]; }
239 
240  function setOwner(address _owner) public
241  {
242   require(msg.sender == owner_);
243   require(_owner != address(0) && _owner != address(this));
244   owner_= _owner;
245  }
246 
247  function buyTokens(address _beneficiary) internal
248  {
249   require(_beneficiary != address(0));
250   uint nowTime= now;
251   require((nowTime >= start_) && (nowTime <= (start_ + period_ * 1 days)));
252   require(ethtotal_ < hardcap_);
253   uint256 weiAmount = msg.value;
254   require(weiAmount != 0);
255 
256   uint256 tokenAmount = weiAmount.mul(rate_);
257 
258   mint(_beneficiary, tokenAmount, percent_);
259 
260   emit TokensPurchased(msg.sender, _beneficiary, weiAmount, tokenAmount);
261 
262   ethbalances_[_beneficiary] = ethbalances_[_beneficiary].add(weiAmount);
263   ethtotal_ = ethtotal_.add(weiAmount);
264 
265  }
266 
267  function refund(uint256 _amount) external returns(uint256)
268  {
269   uint nowTime= now;
270   require((nowTime > (start_ + period_ * 1 days)) && (ethtotal_ < softcap_));
271 
272   uint256 tokenAmount = balances_[msg.sender];
273   uint256 weiAmount = ethbalances_[msg.sender];
274   require((_amount > 0) && (_amount <= weiAmount) && (_amount <= address(this).balance));
275 
276   if(tokenAmount > 0)
277   {
278    if(tokenAmount <= totalSupply_) { totalSupply_ = totalSupply_.sub(tokenAmount); }
279    balances_[msg.sender] = 0;
280    emit Transfer(msg.sender, address(0), tokenAmount);
281   }
282 
283   ethbalances_[msg.sender]=ethbalances_[msg.sender].sub(_amount);
284   msg.sender.transfer(_amount);
285   emit RefundEvent(msg.sender, _amount);
286   if(ethtotal_ >= _amount) { ethtotal_-= _amount; }
287 
288   return _amount;
289  }
290 
291  function finishICO(uint256 _amount) external returns(uint256)
292  {
293   require(msg.sender == owner_);
294   uint nowTime= now;
295   require((nowTime >= start_) && (ethtotal_ >= softcap_));
296   require(_amount <= address(this).balance);
297   emit FinishEvent(_amount);
298   msg.sender.transfer(_amount);
299 
300   return _amount;
301  }
302 
303  function abalance(address _owner) public view returns (uint256) { return _owner.balance; }
304 
305 }