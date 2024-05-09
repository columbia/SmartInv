1 pragma solidity ^0.4.24;
2 
3 
4 
5 // ---------- ---------- ---------- ---------- ----------
6 // Token Name: Daethereum
7 // Token Symbol: DTHR
8 // Total Supply: 100,000,000
9 // Decimals: 8
10 // Token Type: ERC20
11 // Pragma Solidity: v0.4.24+commit.e67f0147
12 // (c) Dae Platform.
13 // ---------- ---------- ---------- ---------- ----------
14 
15 
16 
17 contract ERC20Basic {
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender)
26     public view returns (uint256);
27 
28   function transferFrom(address from, address to, uint256 value)
29     public returns (bool);
30 
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 library SafeMath {
41 
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     if (a == 0) {
44       return 0;
45     }
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     return a / b;
52   }
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 
65 contract Ownable {
66   address public owner;
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72   constructor() public {
73     owner = msg.sender;
74   }
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84   function renounceOwnership() public onlyOwner {
85     emit OwnershipRenounced(owner);
86     owner = address(0);
87   }
88 }
89 
90 contract BasicToken is ERC20Basic, Ownable {
91   using SafeMath for uint256;
92   mapping(address => uint256) balances;
93   uint256 totalSupply_;
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 }
109 
110 
111 contract StandardToken is ERC20, BasicToken {
112   mapping (address => mapping (address => uint256)) internal allowed;
113   function transferFrom(
114     address _from,
115     address _to,
116     uint256 _value
117   )
118     public
119     returns (bool)
120   {
121     require(_to != address(0));
122     require(_value <= balances[_from]);
123     require(_value <= allowed[_from][msg.sender]);
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     emit Transfer(_from, _to, _value);
128     return true;
129   }
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     emit Approval(msg.sender, _spender, _value);
133     return true;
134   }
135   function allowance(
136     address _owner,
137     address _spender
138    )
139     public
140     view
141     returns (uint256)
142   {
143     return allowed[_owner][_spender];
144   }
145   function increaseApproval(
146     address _spender,
147     uint _addedValue
148   )
149     public
150     returns (bool)
151   {
152     allowed[msg.sender][_spender] = (
153       allowed[msg.sender][_spender].add(_addedValue));
154     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155     return true;
156   }
157   function decreaseApproval(
158     address _spender,
159     uint _subtractedValue
160   )
161     public
162     returns (bool)
163   {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 }
174 
175 contract Daethereum is StandardToken {
176   string public constant name = "Daethereum";
177   string public constant symbol = "DTHR";
178   uint32 public constant decimals = 8;
179   uint256 public INITIAL_SUPPLY = 100000000 * 10 ** 8;
180   constructor() public {
181     totalSupply_ = INITIAL_SUPPLY;
182     balances[msg.sender] = INITIAL_SUPPLY;
183     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
184   }
185 }