1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
5     if (_a == 0) {
6       return 0;
7     }
8     uint256 c = _a * _b;
9     require(c / _a == _b);
10     return c;
11   }
12 
13   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     require(_b > 0);
15     uint256 c = _a / _b;
16     return c;
17   }
18 
19   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     require(_b <= _a);
21     uint256 c = _a - _b;
22     return c;
23   }
24 
25   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
26     uint256 c = _a + _b;
27     require(c >= _a);
28     return c;
29   }
30 }
31 
32 contract ERC20 {
33   function totalSupply() public view returns (uint256);
34 
35   function balanceOf(address _who) public view returns (uint256);
36 
37   function allowance(address _owner, address _spender) public view returns (uint256);
38 
39   function transfer(address _to, uint256 _value) public returns (bool);
40 
41   function approve(address _spender, uint256 _value) public returns (bool);
42 
43   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
44 
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract StandardToken is ERC20 {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   mapping(address => mapping (address => uint256)) internal allowed;
56 
57   uint256 totalSupply_;
58 
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63   function balanceOf(address _owner) public view returns (uint256) {
64     return balances[_owner];
65   }
66 
67   function allowance(address _owner, address _spender) public view returns (uint256) {
68     return allowed[_owner][_spender];
69   }
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_value <= balances[msg.sender]);
73     require(_to != address(0));
74 
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     emit Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     require(_value <= balances[_from]);
89     require(_value <= allowed[_from][msg.sender]);
90     require(_to != address(0));
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95     emit Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
100     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
101     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
106     uint256 oldValue = allowed[msg.sender][_spender];
107     if (_subtractedValue >= oldValue) {
108       allowed[msg.sender][_spender] = 0;
109     } else {
110       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111     }
112     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 }
116 
117 contract Ownable {
118   address public owner;
119 
120   event OwnershipRenounced(address indexed previousOwner);
121 
122   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124   constructor() public {
125     owner = msg.sender;
126   }
127 
128   modifier onlyOwner() {
129     require(msg.sender == owner);
130     _;
131   }
132 
133   function renounceOwnership() public onlyOwner {
134     emit OwnershipRenounced(owner);
135     owner = address(0);
136   }
137 
138   function transferOwnership(address _newOwner) public onlyOwner {
139     _transferOwnership(_newOwner);
140   }
141 
142   function _transferOwnership(address _newOwner) internal {
143     require(_newOwner != address(0));
144     emit OwnershipTransferred(owner, _newOwner);
145     owner = _newOwner;
146   }
147 }
148 
149 contract Pausable is Ownable {
150   event Pause();
151   
152   event Unpause();
153 
154   bool public paused = false;
155 
156   modifier whenNotPaused() {
157     require(!paused);
158     _;
159   }
160 
161   modifier whenPaused() {
162     require(paused);
163     _;
164   }
165 
166   function pause() public onlyOwner whenNotPaused {
167     paused = true;
168     emit Pause();
169   }
170 
171   function unpause() public onlyOwner whenPaused {
172     paused = false;
173     emit Unpause();
174   }
175 }
176 
177 contract PausableToken is StandardToken, Pausable {
178   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
179     return super.transfer(_to, _value);
180   }
181 
182   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
183     return super.transferFrom(_from, _to, _value);
184   }
185 
186   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
187     return super.approve(_spender, _value);
188   }
189 
190   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
191     return super.increaseApproval(_spender, _addedValue);
192   }
193 
194   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
195     return super.decreaseApproval(_spender, _subtractedValue);
196   }
197 }
198 
199 contract HiBTCToken is PausableToken {
200   string public constant name = "HiBTCToken";
201   string public constant symbol = "HIBT";
202   uint8 public constant decimals = 18;
203   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
204 
205   constructor() public {
206     totalSupply_ = INITIAL_SUPPLY;
207     balances[msg.sender] = INITIAL_SUPPLY;
208     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
209   }
210 }