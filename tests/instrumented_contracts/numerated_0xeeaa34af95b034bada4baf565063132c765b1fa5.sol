1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract ERC20Basic {
38   uint256 public totalSupply;
39   function balanceOf(address who) public constant returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 contract ERC20 is ERC20Basic {
45   function allowance(address owner, address spender) public constant returns (uint256);
46   function transferFrom(address from, address to, uint256 value) public returns (bool);
47   function approve(address spender, uint256 value) public returns (bool);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   function balanceOf(address _owner) public constant returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71 }
72 
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) internal allowed;
77 
78 
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[_from]);
82     require(_value <= allowed[_from][msg.sender]);
83 
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function approve(address _spender, uint256 _value) public returns (bool) {
92     allowed[msg.sender][_spender] = _value;
93     Approval(msg.sender, _spender, _value);
94     return true;
95   }
96 
97   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98     return allowed[_owner][_spender];
99   }
100 
101   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118 }
119 
120 contract OLCF is StandardToken {
121 
122   string public constant name = "OLCF";
123   string public constant symbol = "OLCF";
124   uint8 public constant decimals = 18;
125 
126   uint256 public constant INITIAL_SUPPLY = 6900000000 * (10 ** uint256(decimals));
127 
128 
129   function OLCF() public {
130     totalSupply = INITIAL_SUPPLY;
131     balances[msg.sender] = INITIAL_SUPPLY;
132     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
133   }
134 
135 }