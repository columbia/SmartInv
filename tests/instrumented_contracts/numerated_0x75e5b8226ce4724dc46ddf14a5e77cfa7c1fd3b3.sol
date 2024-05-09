1 pragma solidity ^0.4.16;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) constant returns (uint256);
7   function transfer(address to, uint256 value) returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) constant returns (uint256);
13   function transferFrom(address from, address to, uint256 value) returns (bool);
14   function approve(address spender, uint256 value) returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17  
18 
19 library SafeMath {
20     
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26  
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31  
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36  
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43  
44 contract BasicToken is ERC20Basic {
45     
46   using SafeMath for uint256;
47  
48   mapping(address => uint256) balances;
49  
50   function transfer(address _to, uint256 _value) returns (bool) {
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56  
57   function balanceOf(address _owner) constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 }
61  
62 contract StandardToken is ERC20, BasicToken {
63  
64   mapping (address => mapping (address => uint256)) allowed;
65  
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67     var _allowance = allowed[_from][msg.sender];
68 
69     balances[_to] = balances[_to].add(_value);
70     balances[_from] = balances[_from].sub(_value);
71     allowed[_from][msg.sender] = _allowance.sub(_value);
72     Transfer(_from, _to, _value);
73     return true;
74   }
75  
76   function approve(address _spender, uint256 _value) returns (bool) {
77  
78     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79  
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84  
85   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 }
89  
90 contract Ownable {
91     
92   address public owner;
93  
94   function Ownable() {
95     owner = msg.sender;
96   }
97  
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102  
103   function transferOwnership(address newOwner) onlyOwner {
104     require(newOwner != address(0));      
105     owner = newOwner;
106   }
107 }
108  
109 contract BurnableToken is StandardToken {
110  
111   function burn(uint _value) public {
112     require(_value > 0);
113     address burner = msg.sender;
114     balances[burner] = balances[burner].sub(_value);
115     totalSupply = totalSupply.sub(_value);
116     Burn(burner, _value);
117   }
118  
119   event Burn(address indexed burner, uint indexed value);
120 }
121  
122 contract MimimimiCoinToken is BurnableToken {
123     
124   string public constant name = "Mimimimi Coin Token";
125    
126   string public constant symbol = "MIMIMIMI";
127     
128   uint32 public constant decimals = 18;
129  
130   uint256 public INITIAL_SUPPLY = 300000000 * 1 ether;
131  
132   function MimimimiCoinToken() {
133     totalSupply = INITIAL_SUPPLY;
134     balances[msg.sender] = INITIAL_SUPPLY;
135   }
136 }
137  
138 contract Crowdsale is Ownable {
139     
140   using SafeMath for uint;
141     
142   address multisig;
143  
144   uint restrictedPercent;
145  
146   address restricted;
147  
148   MimimimiCoinToken public token = new MimimimiCoinToken();
149  
150   uint start;
151     
152   uint period;
153  
154   uint rate;
155  
156   function Crowdsale() {
157     multisig = 0x3fAc6495118F82a1a20DA26DC90E4957e6730aeE;
158     restricted = 0x3fAc6495118F82a1a20DA26DC90E4957e6730aeE;
159     restrictedPercent = 10;
160     rate = 100000000000000000000;
161     start = 1559347200;
162     period = 365;
163   }
164  
165   modifier saleIsOn() {
166     require(now > start && now < start + period * 1 days);
167     _;
168   }
169  
170   function createTokens() saleIsOn payable {
171     multisig.transfer(msg.value);
172     uint tokens = rate.mul(msg.value).div(1 ether);
173     uint bonusTokens = 0;
174     if(now < start + (period * 1 days).div(4)) {
175       bonusTokens = tokens.div(4);
176     } else if(now >= start + (period * 1 days).div(4) && now < start + (period * 1 days).div(4).mul(2)) {
177       bonusTokens = tokens.div(10);
178     } else if(now >= start + (period * 1 days).div(4).mul(2) && now < start + (period * 1 days).div(4).mul(3)) {
179       bonusTokens = tokens.div(20);
180     }
181     uint tokensWithBonus = tokens.add(bonusTokens);
182     token.transfer(msg.sender, tokensWithBonus);
183     uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);
184     token.transfer(restricted, restrictedTokens);
185   }
186  
187   function() external payable {
188     createTokens();
189   }
190 }