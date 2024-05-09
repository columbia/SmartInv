1 // contracts/Funding.sol
2 pragma solidity ^0.4.19;
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40   mapping(address => uint256) balances;
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_value > 0);
43     require(_to != address(0));
44     require(_value <= balances[msg.sender]);
45 
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51   function balanceOf(address _owner) public view returns (uint256 balance) {
52     return balances[_owner];
53   }
54 }
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public view returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract StandardToken is ERC20, BasicToken {
63   mapping (address => mapping (address => uint256)) internal allowed;
64   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
65     require(_value > 0);
66     require(_to != address(0));
67     require(_value <= balances[_from]);
68     require(_value <= allowed[_from][msg.sender]);
69 
70     balances[_from] = balances[_from].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77   function approve(address _spender, uint256 _value) public returns (bool) {
78     require(_value > 0);
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84   function allowance(address _owner, address _spender) public view returns (uint256) {
85     return allowed[_owner][_spender];
86   }
87 
88   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
89     require(_addedValue > 0);
90     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
91     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
92     return true;
93   }
94 
95   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
96     require(_subtractedValue > 0);
97     uint oldValue = allowed[msg.sender][_spender];
98     if (_subtractedValue > oldValue) {
99       allowed[msg.sender][_spender] = 0;
100     } else {
101       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
102     }
103     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107 }
108 
109 contract BurnableToken is BasicToken {
110   event Burn(address indexed burner, uint256 value);
111   function burn(uint256 _value) public {
112     require(_value > 0);
113     require(_value <= balances[msg.sender]);
114 
115     address burner = msg.sender;
116     balances[burner] = balances[burner].sub(_value);
117     totalSupply = totalSupply.sub(_value);
118     Burn(burner, _value);
119   }
120 }
121 
122 contract Funding is StandardToken, BurnableToken {
123   string public constant name = "HolographicPictureChain"; 
124   string public constant symbol = "HOLOP"; 
125   uint8 public constant decimals = 18; 
126   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
127   function Funding() public {
128     totalSupply = INITIAL_SUPPLY;
129     balances[msg.sender] = INITIAL_SUPPLY;
130     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
131   }
132 }