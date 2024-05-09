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
32 contract ERC20 {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 
40 contract Ownable {
41   address public owner;
42   address public tech;
43   
44   constructor() public {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   
53   modifier onlyTech() {
54     require(msg.sender == tech);
55     _;
56   }
57   
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     owner = newOwner;
61   }
62   
63   function transferTech(address newTech) public onlyOwner {
64     require(newTech != address(0));
65     tech = newTech;
66   }
67 }
68 
69 contract Stelz is ERC20, Ownable {
70   using SafeMath for uint256;
71 
72   string public constant name = "STELZ";
73   string public constant symbol = "STELZ";
74   uint8 public constant decimals = 5;
75   uint256 public constant initial_supply = 300000000 * (10 ** uint256(decimals));
76 
77   mapping (address => uint256) balances;
78 
79   uint256 totalSupply_;
80   uint256 wei_price;
81   uint256 min_amount;
82   enum States {
83     Sale,
84     Stop
85   }
86   States public state;
87   
88   constructor() public {
89     owner = msg.sender;
90     tech = msg.sender;
91     totalSupply_ = initial_supply;
92     balances[owner] = initial_supply;
93     wei_price = 1754385960; // equal to 0.1usd per stelz
94     min_amount = 1754385964912000000; // equal to 1000usd
95     state = States.Sale;
96     emit Transfer(0x0, owner, initial_supply);
97   }
98 
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102   
103   function price() public view returns (uint256) {
104     return wei_price;
105   }
106   
107   function minAmount() public view returns (uint256) {
108     return min_amount;
109   }
110 
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     uint256 _balance = balances[msg.sender];
115     require(_value <= _balance);
116 
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119 
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   function balanceOf(address _owner) public view returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128   function changePrice(uint256 _new_price) public onlyTech {
129     wei_price = _new_price;
130   }
131   
132   function changeMinAmount(uint256 _new_min_amount) public onlyTech {
133     min_amount = _new_min_amount;
134   }
135   
136   modifier checkMinAmount(uint256 amount) {
137     require(amount >= min_amount);
138     _;
139   }
140   
141   modifier requireState(States _requiredState) {
142     require(state == _requiredState);
143     _;
144   }
145   
146   function changeState(States _newState)
147   onlyTech
148   public
149   {
150     state = _newState;
151   }
152   
153   function transferMany(address[] recipients, uint256[] values) public {
154     for (uint256 i = 0; i < recipients.length; i++) {
155       require(balances[msg.sender] >= values[i]);
156       require(recipients[i] != address(0));
157       balances[msg.sender] = balances[msg.sender].sub(values[i]);
158       balances[recipients[i]] = balances[recipients[i]].add(values[i]);
159       emit Transfer(msg.sender, recipients[i], values[i]);
160     }
161   }
162   
163   function requestPayout(uint256 _amount)
164   onlyOwner
165   public
166   {
167     msg.sender.transfer(_amount);
168   }
169   
170   function() payable
171   checkMinAmount(msg.value)
172   requireState(States.Sale)
173   public
174   {
175     uint256 _coinIncrease = msg.value.div(wei_price);
176     require(balances[owner] >= _coinIncrease);
177     balances[owner] = balances[owner].sub(_coinIncrease);
178     balances[msg.sender] = balances[msg.sender].add(_coinIncrease);
179     emit Transfer(owner, msg.sender, _coinIncrease);
180   }
181 }