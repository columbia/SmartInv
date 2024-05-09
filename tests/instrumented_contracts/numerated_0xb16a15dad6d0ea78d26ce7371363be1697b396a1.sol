1 pragma solidity ^0.4.16;
2 
3     /// PUNYA USAHA DAN INGIN MENGEMBANGKAN USAHA ANDA DENGAN MEMBUAT COIN BERBASIS ETHEREUM (ERC20) ? SILAHKAN CONTACT KAMI VIA SMS / WA 082280037283 ATAU 082353636798 ///
4     
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_value > 0);
48     require(_to != address(0));
49     require(_value <= balances[msg.sender]);
50 
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) public view returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) internal allowed;
75 
76 
77   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78     require(_value > 0);
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     require(_value > 0);
92     allowed[msg.sender][_spender] = _value;
93     Approval(msg.sender, _spender, _value);
94     return true;
95   }
96 
97   function allowance(address _owner, address _spender) public view returns (uint256) {
98     return allowed[_owner][_spender];
99   }
100 
101   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102     require(_addedValue > 0);
103     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109     require(_subtractedValue > 0);
110     uint oldValue = allowed[msg.sender][_spender];
111     if (_subtractedValue > oldValue) {
112       allowed[msg.sender][_spender] = 0;
113     } else {
114       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
115     }
116     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120 }
121 
122 contract BurnableToken is BasicToken {
123 
124   event Burn(address indexed burner, uint256 value);
125 
126   function burn(uint256 _value) public {
127     require(_value > 0);
128     require(_value <= balances[msg.sender]);
129 
130     address burner = msg.sender;
131     balances[burner] = balances[burner].sub(_value);
132     totalSupply = totalSupply.sub(_value);
133     Burn(burner, _value);
134   }
135 }
136 
137 
138 contract MizuCoin is StandardToken, BurnableToken {
139 
140   string public constant name = "MizuCoin"; 
141   string public constant symbol = "MZU"; 
142   uint8 public constant decimals = 18; 
143 
144   uint256 public constant INITIAL_SUPPLY = 2500000000 * (10 ** uint256(decimals));
145 
146   function MizuCoin() public {
147     totalSupply = INITIAL_SUPPLY;
148     balances[msg.sender] = INITIAL_SUPPLY;
149     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
150   }
151 
152 }