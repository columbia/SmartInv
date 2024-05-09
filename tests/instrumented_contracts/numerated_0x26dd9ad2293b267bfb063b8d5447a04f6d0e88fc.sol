1 pragma solidity ^0.4.24;
2 
3 // Safe Math library
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10 
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a / b;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 // ERC20 contracts from openzeppelin https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts/token/ERC20
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender)
42     public view returns (uint256);
43 
44   function transferFrom(address from, address to, uint256 value)
45     public returns (bool);
46 
47   function approve(address spender, uint256 value) public returns (bool);
48   event Approval(
49     address indexed owner,
50     address indexed spender,
51     uint256 value
52   );
53 }
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) internal balances;
59 
60   uint256 internal totalSupply_;
61 
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   function transfer(address _to, uint256 _value) public returns (bool) {
67     require(_value <= balances[msg.sender]);
68     require(_to != address(0));
69 
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     emit Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   function balanceOf(address _owner) public view returns (uint256) {
77     return balances[_owner];
78   }
79 
80 }
81 
82 contract StandardToken is ERC20, BasicToken {
83 
84   mapping (address => mapping (address => uint256)) internal allowed;
85 
86   function transferFrom(
87     address _from,
88     address _to,
89     uint256 _value
90   )
91     public
92     returns (bool)
93   {
94     require(_value <= balances[_from]);
95     require(_value <= allowed[_from][msg.sender]);
96     require(_to != address(0));
97 
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     emit Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function approve(address _spender, uint256 _value) public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function allowance(
112     address _owner,
113     address _spender
114    )
115     public
116     view
117     returns (uint256)
118   {
119     return allowed[_owner][_spender];
120   }
121   
122   function increaseApproval(
123     address _spender,
124     uint256 _addedValue
125   )
126     public
127     returns (bool)
128   {
129     allowed[msg.sender][_spender] = (
130       allowed[msg.sender][_spender].add(_addedValue));
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval(
136     address _spender,
137     uint256 _subtractedValue
138   )
139     public
140     returns (bool)
141   {
142     uint256 oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue >= oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152 }
153 
154 contract MagicRewardToken is StandardToken {
155     string public constant name = "Magic Reward Token";
156     string public constant symbol = "MRT";
157     uint8 public constant decimals = 8;
158     
159     // starting with 100k tokens on company account
160     uint256 public constant cap = 10000 * 10**8;
161     
162     constructor() public {
163         totalSupply_ = cap;
164         balances[msg.sender] = cap;
165     }
166 }