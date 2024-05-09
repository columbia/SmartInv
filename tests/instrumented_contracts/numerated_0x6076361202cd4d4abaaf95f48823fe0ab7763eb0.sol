1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     // uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   function totalSupply() public view returns (uint256) {
55     return totalSupply_;
56   }
57 
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     emit Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   function balanceOf(address _owner) public view returns (uint256) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) internal allowed;
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     emit Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) public view returns (uint256) {
97     return allowed[_owner][_spender];
98   }
99 
100   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
101     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
102     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 
106   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
107     uint oldValue = allowed[msg.sender][_spender];
108     if (_subtractedValue > oldValue) {
109       allowed[msg.sender][_spender] = 0;
110     } else {
111       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112     }
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117 }
118 
119 contract GPC is StandardToken {
120 
121   address public administror;
122   string public name = "Global-Pay Coin";
123   string public symbol = "GPC";
124   uint8 public decimals = 18;
125   uint256 public INITIAL_SUPPLY = 1000000000*10**18;
126   mapping (address => uint256) public frozenAccount;
127   bool public exchangeFlag = true;
128   uint256 public minWei = 1;
129   uint256 public maxWei = 200*10**18;
130   uint256 public maxRaiseAmount = 2000*10**18;
131   uint256 public raisedAmount = 0;
132   uint256 public raiseRatio = 10000;
133 
134   // 事件
135   event Transfer(address indexed from, address indexed to, uint256 value);
136   event Burn(address indexed target, uint256 value);
137 
138   constructor() public {
139     totalSupply_ = INITIAL_SUPPLY;
140     administror = msg.sender;
141     balances[msg.sender] = INITIAL_SUPPLY;
142   }
143 
144   // 自动兑换
145   function() public payable {
146     require(msg.value > 0);
147     if (exchangeFlag) {
148       if (msg.value >= minWei && msg.value <= maxWei) {
149         if (raisedAmount < maxRaiseAmount) {
150           uint256 valueNeed = msg.value;
151           raisedAmount = raisedAmount.add(msg.value);
152           if (raisedAmount >= maxRaiseAmount) {
153             exchangeFlag = false;
154           }
155           uint256 _value = valueNeed.mul(raiseRatio);
156           require(balances[administror] >= _value);
157           balances[administror] = balances[administror].sub(_value);
158           balances[msg.sender] = balances[msg.sender].add(_value);
159         }
160       } else {
161         msg.sender.transfer(msg.value);
162       }
163     } else {
164       msg.sender.transfer(msg.value);
165     }
166   }
167 
168   // 提款
169   function withdraw(uint256 _amount) public returns (bool) {
170     require(msg.sender == administror);
171     msg.sender.transfer(_amount);
172     return true;
173   }
174 
175   // 增发
176   function SEOS(uint256 _amount) public returns (bool) {
177     require(msg.sender == administror);
178     balances[msg.sender] = balances[msg.sender].add(_amount);
179     totalSupply_ = totalSupply_.add(_amount);
180     INITIAL_SUPPLY = totalSupply_;
181     return true;
182   }
183 
184   // 锁定帐户
185   function freezeAccount(address _target, uint _timestamp) public returns (bool) {
186     require(msg.sender == administror);
187     require(_target != address(0));
188     frozenAccount[_target] = _timestamp;
189     return true;
190   }
191 
192   // 批量锁定帐户
193   function multiFreezeAccount(address[] _targets, uint _timestamp) public returns (bool) {
194     require(msg.sender == administror);
195     uint256 len = _targets.length;
196     require(len > 0);
197     for (uint256 i = 0; i < len; i = i.add(1)) {
198       address _target = _targets[i];
199       require(_target != address(0));
200       frozenAccount[_target] = _timestamp;
201     }
202     return true;
203   }
204 
205   // 转帐
206   function transfer(address _target, uint256 _amount) public returns (bool) {
207     require(now > frozenAccount[msg.sender]);
208     require(_target != address(0));
209     require(balances[msg.sender] >= _amount);
210     balances[_target] = balances[_target].add(_amount);
211     balances[msg.sender] = balances[msg.sender].sub(_amount);
212 
213     emit Transfer(msg.sender, _target, _amount);
214 
215     return true;
216   }
217 
218   // 批量转帐
219   function multiTransfer(address[] _targets, uint256[] _amounts) public returns (bool) {
220     require(now > frozenAccount[msg.sender]);
221     uint256 len = _targets.length;
222     require(len > 0);
223     uint256 totalAmount = 0;
224     for (uint256 i = 0; i < len; i = i.add(1)) {
225       totalAmount = totalAmount.add(_amounts[i]);
226     }
227     require(balances[msg.sender] >= totalAmount);
228     for (uint256 j = 0; j < len; j = j.add(1)) {
229       address _target = _targets[j];
230       uint256 _amount = _amounts[j];
231       require(_target != address(0));
232       balances[_target] = balances[_target].add(_amount);
233       balances[msg.sender] = balances[msg.sender].sub(_amount);
234 
235       emit Transfer(msg.sender, _target, _amount);
236     }
237   }
238 
239   // 燃烧
240   function burn(address _target, uint256 _amount) public returns (bool) {
241     require(msg.sender == administror);
242     require(_target != address(0));
243     require(balances[_target] >= _amount);
244     balances[_target] = balances[_target].sub(_amount);
245     totalSupply_ = totalSupply_.sub(_amount);
246     INITIAL_SUPPLY = totalSupply_;
247 
248     emit Burn(_target, _amount);
249 
250     return true;
251   }
252 
253   // 查询帐户是否被锁定
254   function frozenOf(address _target) public view returns (uint256) {
255     require(_target != address(0));
256     return frozenAccount[_target];
257   }
258 
259   // 修改是否开启兑换
260   function setExchangeFlag(bool _flag) public returns (bool) {
261     require(msg.sender == administror);
262     exchangeFlag = _flag;
263     return true;
264   }
265 
266   // 修改总体募集上限
267   function setMaxRaiseAmount(uint256 _amount) public returns (bool) {
268     require(msg.sender == administror);
269     maxRaiseAmount = _amount;
270     return true;
271   }
272 
273   // 修改兑换比例
274   function setRaiseRatio(uint256 _ratio) public returns (bool) {
275     require(msg.sender == administror);
276     raiseRatio = _ratio;
277     return true;
278   }
279 }