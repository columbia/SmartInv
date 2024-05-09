1 pragma solidity ^0.4.0;
2 
3 
4   /**
5   * @dev Multiplies two numbers, reverts on overflow.
6   */    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
7     // benefit is lost if 'b' is also tested.
8     // @dev See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9 
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 library SafeMath {
18 
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a / b;
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_value > 0);
53     require(_to != address(0));
54     require(_value <= balances[msg.sender]);
55 
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(address _owner) public view returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
81 
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_value > 0);
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     require(_value > 0);
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256) {
103     return allowed[_owner][_spender];
104   }
105 
106   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
107     require(_addedValue > 0);
108     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
109     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
114     require(_subtractedValue > 0);
115     uint oldValue = allowed[msg.sender][_spender];
116     if (_subtractedValue > oldValue) {
117       allowed[msg.sender][_spender] = 0;
118     } else {
119       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120     }
121     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125 }
126 
127 contract BurnableToken is BasicToken {
128 
129   event Burn(address indexed burner, uint256 value);
130 
131   function burn(uint256 _value) public {
132     require(_value > 0);
133     require(_value <= balances[msg.sender]);
134 
135     address burner = msg.sender;
136     balances[burner] = balances[burner].sub(_value);
137     totalSupply = totalSupply.sub(_value);
138     Burn(burner, _value);
139   }
140 }
141 
142 
143 contract LitbinexCoin is StandardToken, BurnableToken {
144 
145   string public constant name = "Litbinex Coin"; 
146   string public constant symbol = "LTB"; 
147   uint8 public constant decimals = 18; 
148 
149   uint256 public constant INITIAL_SUPPLY = 9725636997 * (10 ** uint256(decimals));
150 
151   function LitbinexCoin() public {
152     totalSupply = INITIAL_SUPPLY;
153     balances[msg.sender] = INITIAL_SUPPLY;
154     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
155   }
156 
157 }