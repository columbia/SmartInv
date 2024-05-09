1 pragma solidity ^0.4.18;
2 
3 contract FortuneToken {
4     address public admin;
5 
6     uint ethereumTokenInitValue = 5 ether;
7 
8     uint fortuneInitValue = 1 ether;
9 
10     struct EtherFortuneToken {
11         address owner;
12         uint price;
13     }
14 
15     struct Fortune {
16         address owner;
17         address buyer1;
18         address buyer2;
19         uint price;
20         uint buyers;
21     }
22 
23     EtherFortuneToken private EthereumToken;
24 
25     Fortune[] private fortunes;
26 
27     modifier onlyDev() {
28     require(msg.sender == admin);
29     _;
30     }
31 
32     function FortuneToken() public {
33       admin = msg.sender;
34 
35       Fortune memory _fortune = Fortune({
36           owner: address(this),
37           buyer1: address(0),
38           buyer2: address(0),
39           price: fortuneInitValue,
40           buyers: 0
41       });
42 
43       fortunes.push(_fortune);
44 
45       EtherFortuneToken memory _fortuneEthereumToken = EtherFortuneToken({
46           owner: address(this),
47           price: ethereumTokenInitValue
48       });
49 
50       EthereumToken = _fortuneEthereumToken;
51     }
52 
53     function getFortune(uint id) public view returns (address owner, address buyer1, address buyer2, uint price, uint buyers) {
54         Fortune storage _fortune = fortunes[id];
55         owner = _fortune.owner;
56         buyer1 = _fortune.buyer1;
57         buyer2 = _fortune.buyer2;
58         price = _fortune.price;
59         buyers = _fortune.buyers;
60     }
61 
62     function payFortune(uint id) public payable{
63         Fortune storage _fortune = fortunes[id];
64         require(_fortune.buyer1 == address(0) || _fortune.buyer2 == address(0));
65         require(msg.value == _fortune.price);
66         if (_fortune.buyer1 == address(0)) {
67             _fortune.buyer1 = msg.sender;
68             _fortune.buyers++;
69         } else {
70             _fortune.buyer2 = msg.sender;
71             Fortune memory newFortune1 = Fortune({
72                 owner: _fortune.buyer1,
73                 buyer1: address(0),
74                 buyer2: address(0),
75                 price: SafeMath.div(SafeMath.mul(_fortune.price, 100), 90),
76                 buyers: 0
77             });
78             Fortune memory newFortune2 = Fortune({
79                 owner: _fortune.buyer2,
80                 buyer1: address(0),
81                 buyer2: address(0),
82                 price: SafeMath.div(SafeMath.mul(_fortune.price, 100), 90),
83                 buyers: 0
84             });
85             fortunes.push(newFortune1);
86             fortunes.push(newFortune2);
87             _fortune.buyers++;
88         }
89         if (_fortune.owner != address(this)) {
90             uint256 payment = SafeMath.div(SafeMath.mul(_fortune.price, 90), 100);
91             _fortune.owner.transfer(payment);
92         }
93         if (EthereumToken.owner != address(this)) {
94             uint256 paymentEthereumTokenFortune = SafeMath.div(SafeMath.mul(_fortune.price, 5), 100);
95             EthereumToken.owner.transfer(paymentEthereumTokenFortune);
96         }
97 
98 
99 
100     }
101 
102     function buyEthereumToken() public payable {
103         require(EthereumToken.price == msg.value);
104         require(EthereumToken.owner != msg.sender);
105         address newOwner = msg.sender;
106         if (EthereumToken.owner != address(this)) {
107             uint256 payment = SafeMath.div(SafeMath.mul(EthereumToken.price, 90), 100);
108             EthereumToken.owner.transfer(payment);
109         }
110         EthereumToken.owner = newOwner;
111         EthereumToken.price = SafeMath.div(SafeMath.mul(EthereumToken.price, 120), 90);
112 
113     }
114 
115     function getEthereumToken() public view returns (address owner, uint price) {
116         EtherFortuneToken storage _fortuneEthereumToken = EthereumToken;
117         owner = _fortuneEthereumToken.owner;
118         price = _fortuneEthereumToken.price;
119     }
120 
121     function totalFortunes() public view returns (uint) {
122         return fortunes.length;
123     }
124 
125     function getBalance() public view returns (uint) {
126         return this.balance;
127     }
128 
129     function withdraw(address _to) public onlyDev{
130         if (_to != address(0)) {
131             _to.transfer(this.balance);
132         } else {
133             admin.transfer(this.balance);
134         }
135     }
136 
137 
138 
139 }
140 
141 
142 
143 
144 
145 library SafeMath {
146 
147   /**
148   * @dev Multiplies two numbers, throws on overflow.
149   */
150   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151     if (a == 0) {
152       return 0;
153     }
154     uint256 c = a * b;
155     assert(c / a == b);
156     return c;
157   }
158 
159   /**
160   * @dev Integer division of two numbers, truncating the quotient.
161   */
162   function div(uint256 a, uint256 b) internal pure returns (uint256) {
163     // assert(b > 0); // Solidity automatically throws when dividing by 0
164     uint256 c = a / b;
165     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166     return c;
167   }
168 
169   /**
170   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171   */
172   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173     assert(b <= a);
174     return a - b;
175   }
176 
177   /**
178   * @dev Adds two numbers, throws on overflow.
179   */
180   function add(uint256 a, uint256 b) internal pure returns (uint256) {
181     uint256 c = a + b;
182     assert(c >= a);
183     return c;
184   }
185 }