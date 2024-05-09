1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   
12   function allowance(address owner, address spender)
13     public view returns (uint256);
14 
15   function transferFrom(address from, address to, uint256 value)
16     public returns (bool);
17 
18   function approve(address spender, uint256 value) public returns (bool);
19   
20   event Transfer(address indexed from, address indexed to, uint256 value);
21   event Approval(
22     address indexed owner,
23     address indexed spender,
24     uint256 value
25   );
26 }
27 
28 library SafeMath {
29 
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     if (a == 0) {
32       return 0;
33     }
34 
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     return a / b;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract TokenBasic is ERC20 {
57     
58   using SafeMath for uint256;
59 
60   mapping (address => mapping (address => uint256)) internal allowed;    
61   mapping(address => uint256) balances;
62 
63   uint256 totalSupply_;
64 
65   
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   function balanceOf(address _owner) public view returns (uint256) {
81     return balances[_owner];
82   }         
83  
84   function transferFrom(
85     address _from,
86     address _to,
87     uint256 _value
88   )
89     public
90     returns (bool)
91   {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     emit Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   
110   function allowance(
111     address _owner,
112     address _spender
113    )
114     public
115     view
116     returns (uint256)
117   {
118     return allowed[_owner][_spender];
119   }
120 
121   function increaseApproval(
122     address _spender,
123     uint256 _addedValue
124   )
125     public
126     returns (bool)
127   {
128     allowed[msg.sender][_spender] = (
129       allowed[msg.sender][_spender].add(_addedValue));
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   function decreaseApproval(
135     address _spender,
136     uint256 _subtractedValue
137   )
138     public
139     returns (bool)
140   {
141     uint256 oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151 }
152 
153 /**
154  * @title KDLV
155 */
156 contract KDLV is TokenBasic {
157 
158   string public constant name = "DeliveryK Token";	
159   string public constant symbol = "KDLV";		    
160   uint8 public constant decimals = 18;
161   uint256 public constant INITIAL_SUPPLY = 30000000000 * (10 ** uint256(decimals));
162 
163   constructor() public {
164     totalSupply_ = INITIAL_SUPPLY;
165     balances[msg.sender] = INITIAL_SUPPLY;
166     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
167   }
168 
169 }