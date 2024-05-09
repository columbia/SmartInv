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
15   function approve(address spender, uint256 value) public returns (bool);
16   
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 library SafeMath {
26 
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     return a / b;
39   }
40 
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract TokenBasic is ERC20 {
54     
55   using SafeMath for uint256;
56 
57   mapping (address => mapping (address => uint256)) internal allowed;    
58   mapping(address => uint256) balances;
59 
60   uint256 totalSupply_;
61 
62   
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     emit Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   function balanceOf(address _owner) public view returns (uint256) {
78     return balances[_owner];
79   }         
80  
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     emit Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   
88   function allowance(
89     address _owner,
90     address _spender
91    )
92     public
93     view
94     returns (uint256)
95   {
96     return allowed[_owner][_spender];
97   }
98 
99   function increaseApproval(
100     address _spender,
101     uint256 _addedValue
102   )
103     public
104     returns (bool)
105   {
106     allowed[msg.sender][_spender] = (
107       allowed[msg.sender][_spender].add(_addedValue));
108     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112   function decreaseApproval(
113     address _spender,
114     uint256 _subtractedValue
115   )
116     public
117     returns (bool)
118   {
119     uint256 oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124     }
125     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129 }
130 
131 /**
132  * @title IDLV
133 */
134 contract IDLV is TokenBasic {
135 
136   string public constant name = "DeliveryI Token";	
137   string public constant symbol = "IDLV";		    
138   uint8 public constant decimals = 18;
139   uint256 public constant INITIAL_SUPPLY = 30000000000 * (10 ** uint256(decimals));
140 
141   constructor() public {
142     totalSupply_ = INITIAL_SUPPLY;
143     balances[msg.sender] = INITIAL_SUPPLY;
144     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
145   }
146 
147 }