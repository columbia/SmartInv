1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) pure internal returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) pure internal returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) public constant returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 
39 
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   function transfer(address _to, uint256 _value) public returns (bool) {
46     require(_to != address(0));
47     require(_value <= balances[msg.sender]);
48 
49     // SafeMath.sub will throw if there is not enough balance.
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   function balanceOf(address _owner) public constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amount of tokens to be transferred
81    */
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[_from]);
85     require(_value <= allowed[_from][msg.sender]);
86 
87     balances[_from] = balances[_from].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101 
102   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105 
106 
107   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
108     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
109     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
114     uint oldValue = allowed[msg.sender][_spender];
115     if (_subtractedValue > oldValue) {
116       allowed[msg.sender][_spender] = 0;
117     } else {
118       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
119     }
120     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124 }
125 
126 
127 
128 contract TTCoin is StandardToken {
129 
130   string public constant name = "TTCoin";
131   string public constant symbol = "TTC";
132   uint8 public constant decimals = 4;
133 
134   uint256 public constant INITIAL_SUPPLY = 15000000 * (10 ** uint256(decimals));
135 
136 
137   function TTCoin() public {
138     totalSupply = INITIAL_SUPPLY;
139     balances[msg.sender] = INITIAL_SUPPLY;
140   }
141 
142 }