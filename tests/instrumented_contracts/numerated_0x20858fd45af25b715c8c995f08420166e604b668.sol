1 /**
2 * OasisToken (OASIS) is the official token of a neural interface project Oasis.
3 * The OasisToken contract complies with the ERC20 standard.
4 * Web: http://oasis.ac
5 * Mail: info@oasis.ac
6 * Facebook: http://fb.me/Oasis.ac.neuro
7 * Twitter: @oasis_ac
8 */
9 
10 pragma solidity ^0.4.21;
11 
12 
13 library SafeMath {
14 
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     return a / b;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract ERC20Basic {
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   uint256 totalSupply_;
60 
61   function totalSupply() public view returns (uint256) {
62     return totalSupply_;
63   }
64 
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value <= balances[msg.sender]);
68 
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     emit Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function balanceOf(address _owner) public view returns (uint256) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 contract StandardToken is ERC20, BasicToken {
82 
83   mapping (address => mapping (address => uint256)) internal allowed;
84 
85   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[_from]);
88     require(_value <= allowed[_from][msg.sender]);
89 
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93     emit Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   function approve(address _spender, uint256 _value) public returns (bool) {
98     allowed[msg.sender][_spender] = _value;
99     emit Approval(msg.sender, _spender, _value);
100     return true;
101   }
102 
103   function allowance(address _owner, address _spender) public view returns (uint256) {
104     return allowed[_owner][_spender];
105   }
106 
107   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
108     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
109     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
114     uint oldValue = allowed[msg.sender][_spender];
115     if (_subtractedValue > oldValue) {
116       allowed[msg.sender][_spender] = 0;
117     } else {
118       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
119     }
120     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124 }
125 
126 contract OasisToken is StandardToken {
127 
128   string public constant name = "OasisToken";
129   string public constant symbol = "OASIS";
130   uint8 public constant decimals = 3;
131 
132   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
133 
134   function OasisToken() public {
135     totalSupply_ = INITIAL_SUPPLY; 
136     balances[msg.sender] = INITIAL_SUPPLY;
137     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
138   }
139 
140 }