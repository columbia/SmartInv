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
88 contract TydoPreIco is Owned {
89 
90   using SafeMath for uint256;
91 
92   uint256 public constant COINS_PER_ETH = 12000;
93   uint256 public constant bonus = 25;
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
104   AbstractERC20 public token;
105 
106   //event Debug(string _msg, address _addr);
107   //event Debug(string _msg, uint256 _val);
108   event SaleStart();
109   event SaleClosedSuccess(uint256 _tokenSold);
110   event SaleClosedFail(uint256 _tokenSold);
111 
112   constructor(address _coinToken) Owned() public {
113     token = AbstractERC20(_coinToken);
114   }
115 
116   function tokensLeft() public view returns (uint256 allowed) {
117     return token.allowance(address(owner), address(this));
118   }
119 
120   function () payable public {
121 
122     if ((state == 3 || state == 4) && msg.value == 0) {
123       return withdrawTokens();
124     } else if (state == 2 && msg.value == 0) {
125       return refund();
126     } else {
127       return buy();
128     }
129   }
130 
131   function buy() payable public {
132 
133     require (canBuy());
134     uint amount = msg.value.mul(COINS_PER_ETH).div(1 ether).mul(tokenDecMult);
135     amount = addBonus(amount);
136     //emit Debug("buy amount", amount);
137     require(amount > 0, 'amount must be positive');
138     token.transferFrom(address(owner), address(this), amount);
139     //emit Debug('transfered ', amount);
140     balances[msg.sender] = balances[msg.sender].add(amount);
141     ethBalances[msg.sender] += msg.value;
142     ethCollected = ethCollected.add(msg.value);
143     tokenSold = tokenSold.add(amount);
144   }
145 
146   function addBonus(uint256 amount) internal pure returns(uint256 _newAmount) {
147     
148     uint256 mult = bonus.add(100);
149     //emit Debug('mult ', mult);
150     amount = amount.mul(mult).div(100);
151     return amount;
152   }
153 
154   function canBuy() public constant returns(bool _canBuy) {
155     return state == 1;
156   }
157   
158   function refund() public {
159 
160     require(state == 2);
161 
162     uint256 tokenAmount = balances[msg.sender];
163     require(tokenAmount > 0);
164     uint256 weiAmount = ethBalances[msg.sender];
165 
166     msg.sender.transfer(weiAmount);
167     token.transfer(owner, balances[msg.sender]);
168     ethBalances[msg.sender] = 0;
169     balances[msg.sender] = 0;
170     ethCollected = ethCollected.sub(weiAmount);
171   }
172  
173   function withdraw() ownerOnly public {
174     
175     require(state == 3);
176     owner.transfer(ethCollected);
177     ethCollected = 0;
178     state = 4;
179   }
180 
181   function withdrawTokens() public {
182     require(state == 3 || state ==4);
183     require(balances[msg.sender] > 0);
184     token.transfer(msg.sender, balances[msg.sender]);
185   }
186 
187   function open() ownerOnly public {
188     require(state == 0);
189     state = 1;
190     emit SaleStart();
191   }
192 
193   function closeSuccess() ownerOnly public {
194 
195     require(state == 1);
196     state = 3;
197     emit SaleClosedSuccess(tokenSold);
198   }
199 
200   function closeFail() ownerOnly public {
201 
202     require(state == 1);
203     state = 2;
204     emit SaleClosedFail(tokenSold);
205   }
206 }