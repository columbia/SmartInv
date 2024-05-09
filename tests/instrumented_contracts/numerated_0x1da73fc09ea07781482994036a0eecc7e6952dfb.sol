1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34   
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract AbstractERC20 {
46 
47   uint256 public totalSupply;
48 
49   event Transfer(address indexed _from, address indexed _to, uint256 _value);
50   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52   function balanceOf(address _owner) public constant returns (uint256 balance);
53   function transfer(address _to, uint256 _value) public returns (bool success);
54   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
55   function approve(address _spender, uint256 _value) public returns (bool success);
56   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
57 }
58 
59 contract Owned {
60 
61   address public owner;
62   address public newOwner;
63 
64   event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
65 
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   modifier ownerOnly {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   function transferOwnership(address _newOwner) public ownerOnly {
76     require(_newOwner != owner);
77     newOwner = _newOwner;
78   }
79 
80   function acceptOwnership() public {
81     require(msg.sender == newOwner);
82     emit OwnerUpdate(owner, newOwner);
83     owner = newOwner;
84     newOwner = address(0);
85   }
86 }
87 
88 contract TydoIco is Owned {
89 
90   using SafeMath for uint256;
91 
92   uint256 public constant COINS_PER_ETH = 12000;
93   //uint256 public constant bonus = 25;
94   mapping (address => uint256) public balances;
95   mapping (address => uint256) ethBalances;
96   uint256 public ethCollected;
97   uint256 public tokenSold;
98   uint256 constant tokenDecMult = 1 ether;
99   uint8 public state = 0; // 0 - not started yet
100                           // 1 - running
101                           // 2 - closed mannually and not success
102                           // 3 - closed and target reached success
103                           // 4 - success & funds withdrawed
104 
105   //uint256 public bonusEnd_1 = 1530335295;
106   uint256[] public bonuses;
107   uint256[] public bonusEnds;
108 
109   AbstractERC20 public token;
110 
111   //event Debug(string _msg, address _addr);
112   //event Debug(string _msg, uint256 _val);
113   event SaleStart();
114   event SaleClosedSuccess(uint256 _tokenSold);
115   event SaleClosedFail(uint256 _tokenSold);
116 
117   constructor(address _coinToken, uint256[] _bonuses, uint256[] _bonusEnds) Owned() public {
118     require(_bonuses.length == _bonusEnds.length);
119     for(uint8 i = 0; i < _bonuses.length; i++) {
120       require(_bonuses[i] > 0);
121       //require(_bonusEnds[i] > block.timestamp);
122       if (i > 0) {
123         //require(_bonusEnds[i] > _bonusEnds[i - 1]);
124       }
125     }
126     bonuses = _bonuses;
127     bonusEnds = _bonusEnds;
128 
129     token = AbstractERC20(_coinToken);
130   }
131 
132   function tokensLeft() public view returns (uint256 allowed) {
133     return token.allowance(address(owner), address(this));
134   }
135 
136   function () payable public {
137 
138     if ((state == 3 || state == 4) && msg.value == 0) {
139       return withdrawTokens();
140     } else if (state == 2 && msg.value == 0) {
141       return refund();
142     } else {
143       return buy();
144     }
145   }
146 
147   function buy() payable public {
148 
149     require (canBuy());
150     uint amount = msg.value.mul(COINS_PER_ETH).div(1 ether).mul(tokenDecMult);
151     amount = addBonus(amount);
152     //emit Debug("buy amount", amount);
153     require(amount > 0, 'amount must be positive');
154     token.transferFrom(address(owner), address(this), amount);
155     //emit Debug('transfered ', amount);
156     balances[msg.sender] = balances[msg.sender].add(amount);
157     ethBalances[msg.sender] += msg.value;
158     ethCollected = ethCollected.add(msg.value);
159     tokenSold = tokenSold.add(amount);
160   }
161 
162   function getBonus() public view returns(uint256 _currentBonus) {
163   
164     uint256 curTime = block.timestamp;
165     for(uint8 i = 0; i < bonuses.length; i++) {
166       if(bonusEnds[i] > curTime) {
167         return bonuses[i];
168       }
169     }
170     return 0;
171   }
172 
173   function addBonus(uint256 amount) internal view returns(uint256 _newAmount) {
174    
175     uint256 bonus = getBonus();
176     uint256 mult = bonus.add(100);
177     //emit Debug('mult ', mult);
178     amount = amount.mul(mult).div(100);
179     return amount;
180   }
181 
182   function canBuy() public constant returns(bool _canBuy) {
183     return state == 1;
184   }
185   
186   function refund() public {
187 
188     require(state == 2);
189 
190     uint256 tokenAmount = balances[msg.sender];
191     require(tokenAmount > 0);
192     uint256 weiAmount = ethBalances[msg.sender];
193 
194     msg.sender.transfer(weiAmount);
195     token.transfer(owner, balances[msg.sender]);
196     ethBalances[msg.sender] = 0;
197     balances[msg.sender] = 0;
198     ethCollected = ethCollected.sub(weiAmount);
199   }
200  
201   function withdraw() ownerOnly public {
202     
203     require(state == 3);
204     owner.transfer(ethCollected);
205     ethCollected = 0;
206     state = 4;
207   }
208 
209   function withdrawTokens() public {
210     require(state == 3 || state ==4);
211     require(balances[msg.sender] > 0);
212     token.transfer(msg.sender, balances[msg.sender]);
213   }
214 
215   function open() ownerOnly public {
216     require(state == 0);
217     state = 1;
218     emit SaleStart();
219   }
220 
221   function closeSuccess() ownerOnly public {
222 
223     require(state == 1);
224     state = 3;
225     emit SaleClosedSuccess(tokenSold);
226   }
227 
228   function closeFail() ownerOnly public {
229 
230     require(state == 1);
231     state = 2;
232     emit SaleClosedFail(tokenSold);
233   }
234 }