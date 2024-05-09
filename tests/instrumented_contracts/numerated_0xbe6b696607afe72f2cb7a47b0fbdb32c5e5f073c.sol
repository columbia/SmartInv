1 pragma solidity ^0.4.24;
2 
3 interface ierc20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address _who) external view returns (uint256);
7 
8   function allowance(address _owner, address _spender)
9     external view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) external returns (bool);
12 
13   function approve(address _spender, uint256 _value)
14     external returns (bool);
15 
16   function transferFrom(address _from, address _to, uint256 _value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library safemath {
33 
34   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     if (_a == 0) {
36       return 0;
37     }
38 
39     uint256 c = _a * _b;
40     require(c / _a == _b);
41 
42     return c;
43   }
44 
45   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     require(_b > 0); // Solidity only automatically asserts when dividing by 0
47     uint256 c = _a / _b;
48     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
49 
50     return c;
51   }
52 
53   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     require(_b <= _a);
55     uint256 c = _a - _b;
56 
57     return c;
58   }
59  
60   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     uint256 c = _a + _b;
62     require(c >= _a);
63 
64     return c;
65   }
66 
67   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68     require(b != 0);
69     return a % b;
70   }
71 }
72 
73 contract erc20 is ierc20 {
74   using safemath for uint256;
75 
76   mapping (address => uint256) private balances_;
77 
78   mapping (address => mapping (address => uint256)) private allowed_;
79 
80   uint256 private totalSupply_;
81 
82 
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87 
88   function balanceOf(address _owner) public view returns (uint256) {
89     return balances_[_owner];
90   }
91 
92   function allowance(
93     address _owner,
94     address _spender
95    )
96     public
97     view
98     returns (uint256)
99   {
100     return allowed_[_owner][_spender];
101   }
102 
103 
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_value <= balances_[msg.sender]);
106     require(_to != address(0));
107 
108     balances_[msg.sender] = balances_[msg.sender].sub(_value);
109     balances_[_to] = balances_[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114 
115   function approve(address _spender, uint256 _value) public returns (bool) {
116     allowed_[msg.sender][_spender] = _value;
117     emit Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121 
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     public
128     returns (bool)
129   {
130     require(_value <= balances_[_from]);
131     require(_value <= allowed_[_from][msg.sender]);
132     require(_to != address(0));
133 
134     balances_[_from] = balances_[_from].sub(_value);
135     balances_[_to] = balances_[_to].add(_value);
136     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
141 
142   function increaseApproval(
143     address _spender,
144     uint256 _addedValue
145   )
146     public
147     returns (bool)
148   {
149     allowed_[msg.sender][_spender] = (
150       allowed_[msg.sender][_spender].add(_addedValue));
151     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
152     return true;
153   }
154 
155   function decreaseApproval(
156     address _spender,
157     uint256 _subtractedValue
158   )
159     public
160     returns (bool)
161   {
162     uint256 oldValue = allowed_[msg.sender][_spender];
163     if (_subtractedValue >= oldValue) {
164       allowed_[msg.sender][_spender] = 0;
165     } else {
166       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
169     return true;
170   }
171 
172   function _mint(address _account, uint256 _amount) internal {
173     require(_account != 0);
174     totalSupply_ = totalSupply_.add(_amount);
175     balances_[_account] = balances_[_account].add(_amount);
176     emit Transfer(address(0), _account, _amount);
177   }
178 
179   function _burn(address _account, uint256 _amount) internal {
180     require(_account != 0);
181     require(_amount <= balances_[_account]);
182 
183     totalSupply_ = totalSupply_.sub(_amount);
184     balances_[_account] = balances_[_account].sub(_amount);
185     emit Transfer(_account, address(0), _amount);
186   }
187 
188   function _burnFrom(address _account, uint256 _amount) internal {
189     require(_amount <= allowed_[_account][msg.sender]);
190     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
191       _amount);
192     _burn(_account, _amount);
193   }
194 }
195 
196 contract TroyCash is erc20 {
197 
198   string public constant name = "TroyCash";
199   string public constant symbol = "TCC";
200   uint8 public constant decimals = 18;
201 
202   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
203 
204   /**
205    * @dev Constructor that gives msg.sender all of existing tokens.
206    */
207   constructor() public {
208     _mint(msg.sender, INITIAL_SUPPLY);
209   }
210 
211 }