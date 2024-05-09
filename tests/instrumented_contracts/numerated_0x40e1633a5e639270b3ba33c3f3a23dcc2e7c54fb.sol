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
119 contract HKTToken is StandardToken {
120 
121   address public administror;
122   string public name = "HKT Token";
123   string public symbol = "HKT";
124   uint8 public decimals = 8;
125   uint256 public INITIAL_SUPPLY = 30000000000*10**8;
126   mapping (address => uint256) public frozenAccount;
127 
128   // 事件
129   event Transfer(address indexed from, address indexed to, uint256 value);
130   event Burn(address indexed target, uint256 value);
131 
132   constructor() public {
133     totalSupply_ = INITIAL_SUPPLY;
134     administror = msg.sender;
135     balances[msg.sender] = INITIAL_SUPPLY;
136   }
137 
138   // 增发
139   function SEOS(uint256 _amount) public returns (bool) {
140     require(msg.sender == administror);
141     balances[msg.sender] = balances[msg.sender].add(_amount);
142     totalSupply_ = totalSupply_.add(_amount);
143     INITIAL_SUPPLY = totalSupply_;
144     return true;
145   }
146 
147   // 锁定帐户
148   function freezeAccount(address _target, uint _timestamp) public returns (bool) {
149     require(msg.sender == administror);
150     require(_target != address(0));
151     frozenAccount[_target] = _timestamp;
152     return true;
153   }
154 
155   // 批量锁定帐户
156   function multiFreezeAccount(address[] _targets, uint _timestamp) public returns (bool) {
157     require(msg.sender == administror);
158     uint256 len = _targets.length;
159     require(len > 0);
160     for (uint256 i = 0; i < len; i = i.add(1)) {
161       address _target = _targets[i];
162       require(_target != address(0));
163       frozenAccount[_target] = _timestamp;
164     }
165     return true;
166   }
167 
168   // 转帐
169   function transfer(address _target, uint256 _amount) public returns (bool) {
170     require(now > frozenAccount[msg.sender]);
171     require(_target != address(0));
172     require(balances[msg.sender] >= _amount);
173     balances[_target] = balances[_target].add(_amount);
174     balances[msg.sender] = balances[msg.sender].sub(_amount);
175 
176     emit Transfer(msg.sender, _target, _amount);
177 
178     return true;
179   }
180 
181   // 批量转帐
182   function multiTransfer(address[] _targets, uint256[] _amounts) public returns (bool) {
183     require(now > frozenAccount[msg.sender]);
184     uint256 len = _targets.length;
185     require(len > 0);
186     uint256 totalAmount = 0;
187     for (uint256 i = 0; i < len; i = i.add(1)) {
188       totalAmount = totalAmount.add(_amounts[i]);
189     }
190     require(balances[msg.sender] >= totalAmount);
191     for (uint256 j = 0; j < len; j = j.add(1)) {
192       address _target = _targets[j];
193       uint256 _amount = _amounts[j];
194       require(_target != address(0));
195       balances[_target] = balances[_target].add(_amount);
196       balances[msg.sender] = balances[msg.sender].sub(_amount);
197 
198       emit Transfer(msg.sender, _target, _amount);
199     }
200   }
201 
202   // 燃烧
203   function burn(address _target, uint256 _amount) public returns (bool) {
204     require(msg.sender == administror);
205     require(_target != address(0));
206     require(balances[_target] >= _amount);
207     balances[_target] = balances[_target].sub(_amount);
208     totalSupply_ = totalSupply_.sub(_amount);
209     INITIAL_SUPPLY = totalSupply_;
210 
211     emit Burn(_target, _amount);
212 
213     return true;
214   }
215 
216   // 查询帐户是否被锁定
217   function frozenOf(address _target) public view returns (uint256) {
218     require(_target != address(0));
219     return frozenAccount[_target];
220   }
221 }