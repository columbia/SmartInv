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
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
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
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function balanceOf(address _owner) public view returns (uint256 balance) {
56     return balances[_owner];
57   }
58 }
59 
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract StandardToken is ERC20, BasicToken {
68   mapping (address => mapping (address => uint256)) internal allowed;
69 
70   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[_from]);
73     require(_value <= allowed[_from][msg.sender]);
74 
75     balances[_from] = balances[_from].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79     return true;
80   }
81 
82   function approve(address _spender, uint256 _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   function allowance(address _owner, address _spender) public view returns (uint256) {
89     return allowed[_owner][_spender];
90   }
91 
92 
93   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
94     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
95     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 }
110 
111 contract ElPasoToken is StandardToken {
112 
113   string public constant name = "El Paso Coin";
114   string public constant symbol = "EPC";
115   uint8 public constant decimals = 18;
116 
117 
118   uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals));
119 
120   function ElPasoToken() public {
121     totalSupply = INITIAL_SUPPLY;
122     balances[msg.sender] = INITIAL_SUPPLY;
123   }
124 }