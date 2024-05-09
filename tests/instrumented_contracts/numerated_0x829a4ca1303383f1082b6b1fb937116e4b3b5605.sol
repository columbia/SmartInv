1 library SafeMath {
2 
3   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
4     if (a == 0) {
5       return 0;
6     }
7     c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     // uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return a / b;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20Basic {
32   function totalSupply() public view returns (uint256);
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   uint256 totalSupply_;
44 
45   function totalSupply() public view returns (uint256) {
46     return totalSupply_;
47   }
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) internal allowed;
75 
76   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[_from]);
79     require(_value <= allowed[_from][msg.sender]);
80 
81     balances[_from] = balances[_from].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84     emit Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     allowed[msg.sender][_spender] = _value;
90     emit Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function allowance(address _owner, address _spender) public view returns (uint256) {
95     return allowed[_owner][_spender];
96   }
97 
98   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 }
115 
116 contract WATT is StandardToken {
117 
118     string public constant name = "WorkChain App Token";
119     string public constant symbol = "WATT";
120     uint8 public constant decimals = 18;
121 
122     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
123 
124     constructor() public {
125         totalSupply_ = INITIAL_SUPPLY;
126         balances[msg.sender] = INITIAL_SUPPLY;
127         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
128     }
129 }