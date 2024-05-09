1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply = 0;
6   function balanceOf(address who) constant returns (uint256);
7   function transfer(address to, uint256 value) returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   function transfer(address _to, uint256 _value) returns (bool) {
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   function balanceOf(address _owner) constant returns (uint256 balance) {
50     return balances[_owner];
51   }
52 }
53 
54 
55 contract Ownable {
56   address public owner;
57 
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 }
67 
68 
69 
70 contract AKM is BasicToken, Ownable {
71   using SafeMath for uint256;
72   
73   string public constant name = "AKM coin";
74   string public constant symbol = "AKM";
75   uint256 public constant decimals = 8;
76   
77   uint256 public tokenPerWai = (10 ** (18 - decimals) * 1 wei) / 1250;
78   uint256 public token = 10 ** decimals;
79   uint256 public constant INITIAL_SUPPLY = 2800000;
80   
81   uint256 public creationTime;
82   bool public is_started_bonuses = false;
83   bool public is_started_payouts = true;
84   
85   function emissionPay(uint256 _ammount) private {
86     uint256 ownBonus = _ammount.div(100).mul(25);
87     totalSupply = totalSupply.add(_ammount.add(ownBonus));
88     
89     balances[msg.sender] = balances[msg.sender].add(_ammount);
90     balances[owner] = balances[owner].add(ownBonus);
91     
92     if(msg.value > 10 ether) 
93       Transfer(0, msg.sender, _ammount);
94     Transfer(this, owner, ownBonus);
95     Transfer(this, msg.sender, _ammount);
96   }
97   
98   function extraEmission(uint256 _ammount) public onlyOwner {
99     _ammount = _ammount.mul(token);
100     totalSupply = totalSupply.add(_ammount);
101     balances[owner] = balances[owner].add(_ammount);
102     Transfer(this, owner, _ammount);
103   }
104 
105   
106   function AKM() {
107     totalSupply = INITIAL_SUPPLY.mul(token);
108     balances[owner] = totalSupply;
109   }
110   
111   function startBonuses() public onlyOwner {
112     if(!is_started_bonuses) {
113       creationTime = now;
114       is_started_bonuses = true;
115     }
116   }
117   
118   function startPayouts() public onlyOwner {
119     is_started_payouts = true;
120   }
121   
122   function stopPayouts() public onlyOwner {
123     is_started_payouts = false;
124   }
125   
126   function setTokensPerEther(uint256 _value) public onlyOwner {
127      require(_value > 0);
128      tokenPerWai = (10 ** 10 * 1 wei) / _value;
129   }
130   
131   function getBonusPercent() private constant returns(uint256) {
132     if(!is_started_bonuses) return 100;
133     uint256 diff = now.sub(creationTime);
134     uint256 diff_weeks = diff.div(1 weeks);
135     if(diff_weeks < 1) // 0 ... 1 week
136       return 130;
137     else if(diff_weeks < 2)// 1 ... 2 week
138       return 125;
139     else if(diff_weeks < 3)// 2 ... 3 week
140       return 120;
141     else if(diff_weeks < 4)// 3 ... 4 week
142       return 115;
143     else if(diff_weeks < 5)// 4 ... 5 week
144       return 110;
145     else {
146       is_started_bonuses = false;
147       return 100;
148     }
149   }
150   
151   
152   function() payable {
153     assert(is_started_payouts);
154     uint256 amount = msg.value.div(tokenPerWai);
155     amount = amount.div(100).mul(getBonusPercent());
156     emissionPay(amount);
157     owner.transfer(msg.value);
158   }
159 }