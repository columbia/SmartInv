1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
7     // benefit is lost if 'b' is also tested.
8     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9     if (a == 0) {
10       return 0;
11     }
12 
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract ERC20Basic {
39   function totalSupply() public view returns (uint256);
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender)
47     public view returns (uint256);
48 
49   function transferFrom(address from, address to, uint256 value)
50     public returns (bool);
51 
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(
54     address indexed owner,
55     address indexed spender,
56     uint256 value
57   );
58 }
59 
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62   // timestamp when token release is enabled
63   uint256 public releaseTime = 1536917418;
64   address owner;
65   
66   mapping(address => uint256) balances;
67 
68   uint256 totalSupply_;
69 
70   function totalSupply() public view returns (uint256) {
71     return totalSupply_;
72   }
73     
74     function BasicToken() {
75         owner  = msg.sender;
76     }
77 
78     modifier notPaused {
79         require(now > releaseTime  || msg.sender == owner);
80         _;
81     }
82     
83   function transfer(address _to, uint256 _value) public notPaused  returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public view returns (uint256) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   function transferFrom(
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     public
109     returns (bool)
110   {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114     
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     
120    
121      return true;   
122  
123    
124   }
125 
126   function approve(address _spender, uint256 _value) public returns (bool) {
127     allowed[msg.sender][_spender] = _value;
128     emit Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   function allowance(
133     address _owner,
134     address _spender
135    )
136     public
137     view
138     returns (uint256)
139   {
140     return allowed[_owner][_spender];
141   }
142 
143   function increaseApproval(
144     address _spender,
145     uint256 _addedValue
146   )
147     public
148     returns (bool)
149   {
150     allowed[msg.sender][_spender] = (
151       allowed[msg.sender][_spender].add(_addedValue));
152     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156   function decreaseApproval(
157     address _spender,
158     uint256 _subtractedValue
159   )
160     public
161     returns (bool)
162   {
163     uint256 oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 contract WEBN is StandardToken {
176 
177   string public constant name = "WEBN"; 
178   string public constant symbol = "WEBN"; 
179   uint8 public constant decimals = 8; 
180 
181   uint256 public constant INITIAL_SUPPLY = 6000000000 * (10 ** uint256(decimals));
182 
183   constructor() public {
184     totalSupply_ = INITIAL_SUPPLY;
185     balances[msg.sender] = INITIAL_SUPPLY;
186     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
187   }
188 
189 }