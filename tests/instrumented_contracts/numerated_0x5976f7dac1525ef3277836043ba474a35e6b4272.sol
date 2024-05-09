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
30 contract Ownable {
31   address public owner;
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 }
50 
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) public view returns (uint256);
60   function transferFrom(address from, address to, uint256 value) public returns (bool);
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
114     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
115     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 
119   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
120     uint oldValue = allowed[msg.sender][_spender];
121     if (_subtractedValue > oldValue) {
122       allowed[msg.sender][_spender] = 0;
123     } else {
124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
125     }
126     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 }
130 
131 contract BurnableToken is BasicToken {
132 
133   event Burn(address indexed burner, uint256 value);
134 
135   function burn(uint256 _value) public {
136     require(_value <= balances[msg.sender]);
137 
138     address burner = msg.sender;
139     balances[burner] = balances[burner].sub(_value);
140     totalSupply = totalSupply.sub(_value);
141     Burn(burner, _value);
142   }
143 }
144 
145 contract MintableToken is StandardToken, Ownable {
146   event Mint(address indexed to, uint256 amount);
147   event MintFinished();
148 
149   bool public mintingFinished = false;
150 
151 
152   modifier canMint() {
153     require(!mintingFinished);
154     _;
155   }
156 
157   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
158     totalSupply = totalSupply.add(_amount);
159     balances[_to] = balances[_to].add(_amount);
160     Mint(_to, _amount);
161     Transfer(address(0), _to, _amount);
162     return true;
163   }
164 
165   function finishMinting() onlyOwner canMint public returns (bool) {
166     mintingFinished = true;
167     MintFinished();
168     return true;
169   }
170 }
171 
172 contract FilmscoinToken is MintableToken, BurnableToken {
173   string public name = 'Filmscoin';
174   string public symbol = 'FLMC';
175   uint8 public decimals = 0;
176   uint public totalSupply = 31000000;
177 
178   function FilmscoinToken() public {
179     balances[msg.sender] = totalSupply;
180   }
181 }