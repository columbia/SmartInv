1 pragma solidity >0.4.23 <0.5.0;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
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
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47   mapping(address => uint256) balances;
48   uint256 totalSupply_;
49   function totalSupply() public view returns (uint256) {
50     return totalSupply_;
51   }
52 
53 
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57 
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     emit Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64 
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71   mapping (address => mapping (address => uint256)) internal allowed;
72   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[_from]);
75     require(_value <= allowed[_from][msg.sender]);
76     balances[_from] = balances[_from].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79     emit Transfer(_from, _to, _value);
80     return true;
81   }
82 
83   function approve(address _spender, uint256 _value) public returns (bool) {
84     allowed[msg.sender][_spender] = _value;
85     emit Approval(msg.sender, _spender, _value);
86     return true;
87   }
88 
89   function allowance(address _owner, address _spender) public view returns (uint256) {
90     return allowed[_owner][_spender];
91   }
92 
93   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
94     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
95     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96     return true;
97   }
98 
99   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
100     uint oldValue = allowed[msg.sender][_spender];
101     if (_subtractedValue > oldValue) {
102       allowed[msg.sender][_spender] = 0;
103     } else {
104       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
105     }
106     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 }
110 
111 /**
112  * Detailed
113  */
114 contract DetailedToken is StandardToken {
115     string public constant  name = "zen and cosmos repair";
116     string public constant  symbol = "ZEN";
117     uint8 public constant decimals = 18;
118     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
119     address public holder = 0x49A1c9bB3D7B2AcA989d12A964C842B529813841;
120     address public owner = 0x49A1c9bB3D7B2AcA989d12A964C842B529813841;
121     
122     string public statement = "zen and cosmos repair";
123     
124     modifier onlyOwner() {
125         require(msg.sender == owner, "Only owner can do this.");
126         _;
127     }
128     event TransferOwner(address newOwner, address lastOwner);
129     
130     function changeStatement(string newStatement) public onlyOwner returns (bool) {
131         statement = newStatement;
132     }
133     
134     function transferOwner(address newOwner) public onlyOwner returns (bool) {
135         owner = newOwner;
136         emit TransferOwner(newOwner, msg.sender);
137     }
138     
139     constructor() public {
140         totalSupply_ = INITIAL_SUPPLY;
141         balances[holder] = INITIAL_SUPPLY;
142         emit Transfer(0x0, holder, INITIAL_SUPPLY);
143     }
144 }