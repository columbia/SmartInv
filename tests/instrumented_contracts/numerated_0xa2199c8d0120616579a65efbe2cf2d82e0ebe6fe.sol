1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   uint256 totalSupply_;
43 
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) public view returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74 
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79 
80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87   function approve(address _spender, uint256 _value) public returns (bool) {
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender) public view returns (uint256) {
94     return allowed[_owner][_spender];
95   }
96 
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104     uint oldValue = allowed[msg.sender][_spender];
105     if (_subtractedValue > oldValue) {
106       allowed[msg.sender][_spender] = 0;
107     } else {
108       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109     }
110     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 
114 }
115 
116 contract StandardTokenDeployable is StandardToken {
117   string public name; 
118   string public symbol;
119   uint public decimals;
120   
121 
122   function StandardTokenDeployable(
123     string _name,
124     string _symbol,
125     uint _decimals,
126     uint _intialSupply,
127     address _owner
128   ) public {
129     name = _name;
130     symbol = _symbol;
131     decimals = _decimals;
132 
133     uint intialSupply = _intialSupply * (10 ** decimals);
134     totalSupply_ = intialSupply;
135     balances[_owner] = intialSupply;
136   }
137 }