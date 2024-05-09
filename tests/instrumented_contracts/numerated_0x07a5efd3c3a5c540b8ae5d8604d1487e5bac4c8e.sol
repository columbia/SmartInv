1 // https://www.howeycoins.com/index.html
2 //
3 // Participate in the ICO by sending ETH to this contract. 1 ETH = 10 HOW
4 //
5 //
6 // DON'T MISS THIS EXCLUSIVE OPPORTUNITY TO PARTICIPATE IN 
7 // HOWEYCOINS TRAVEL NETWORK NOW!
8 //
9 //
10 // Combining the two most growth-oriented segments of the digital economy –
11 // blockchain technology and travel, HoweyCoin is the newest and only coin offering
12 // that captures the magic of coin trading profits AND the excitement and
13 // guaranteed returns of the travel industry. HoweyCoins will partner with all
14 // segments of the travel industry (air, hotel, car rental, and luxury segments),
15 // earning coins you can trade for profit instead of points. Massive potential
16 // upside benefits like:
17 // 
18 // HoweyCoins are officially registered with the U.S. government;
19 // HoweyCoins will trade on an SEC-compliant exchange where you can buy and sell
20 // them for profit;
21 // HoweyCoins can be used with existing points programs;
22 // HoweyCoins can be exchanged for cryptocurrencies and cash;
23 // HoweyCoins can be spent at any participating airline or hotel;
24 // HoweyCoins can also be redeemed for merchandise.
25 //
26 // Beware of scams. This is the real HoweyCoin ICO.
27 pragma solidity ^0.4.24;
28 
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     require(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a / b;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     require(c >= a);
51     return c;
52   }
53 }
54 
55 interface ERC20 {
56   event Transfer(address indexed from, address indexed to, uint256 value);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59   function transfer(address _to, uint256 _value) external returns (bool success);
60   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
61   function balanceOf(address _owner) external view returns (uint256 balance);
62   function approve(address _spender, uint256 _value) external returns (bool success);
63   function allowance(address _owner, address _spender) external view returns (uint256 remaining);
64 }
65 
66 contract ERC223Receiver {
67   function tokenFallback(address _sender, address _origin,
68                          uint _value, bytes _data) external returns (bool ok);
69 }
70 
71 // HoweyCoins are the cryptocurrency for the travel industry at exactly the right time. 
72 //
73 // To participate in the ICO, simply send ETH to this contract, or call
74 // buyAtPrice with the current price.
75 contract HoweyCoin is ERC20 {
76   using SafeMath for uint256;
77 
78   mapping (address => uint256) balances;
79   mapping (address => mapping (address => uint256)) allowed;
80 
81   address public owner;
82   uint256 public tokensPerWei;
83 
84   string public name;
85   string public symbol;
86   uint256 public totalSupply;
87   function decimals() public pure returns (uint8) { return 18; }
88 
89 
90   constructor(string _name, string _symbol, uint256 _totalSupplyTokens) public {
91     owner = msg.sender;
92     tokensPerWei = 10;
93     name = _name;
94     symbol = _symbol;
95     totalSupply = _totalSupplyTokens * (10 ** uint(decimals()));
96     balances[msg.sender] = totalSupply;
97     emit Transfer(address(0), msg.sender, totalSupply);
98   }
99 
100   function () public payable {
101     buyAtPrice(tokensPerWei);
102   }
103 
104   // Buy the tokens at the expected price or fail.
105   // This prevents the owner from changing the price during a purchase.
106   function buyAtPrice(uint256 _tokensPerWei)
107       public payable returns (bool success) {
108     require(_tokensPerWei == tokensPerWei);
109 
110     address to = msg.sender;
111     uint256 amount = msg.value * tokensPerWei;
112     balances[owner] = balances[owner].sub(amount);
113     balances[to] = balances[to].add(amount);
114     emit Transfer(owner, to, amount);
115     return true;
116   }
117 
118   function transfer(address _to, uint256 _value) external returns (bool success) {
119     return _transfer(_to, _value);
120   }
121 
122   function transfer(address _to, uint _value, bytes _data) external returns (bool success) {
123     _transfer(_to, _value);
124     if (_isContract(_to)) {
125       return _contractFallback(msg.sender, _to, _value, _data);
126     }
127     return true;
128   }
129 
130   function transferFrom(address _from, address _to, uint _value, bytes _data)
131       external returns (bool success) {
132     _transferFrom(_from, _to, _value);
133     if (_isContract(_to)) {
134       return _contractFallback(_from, _to, _value, _data);
135     }
136     return true;
137   }
138 
139   function transferFrom(address _from, address _to, uint _value)
140       external returns (bool success) {
141     return _transferFrom(_from, _to, _value);
142   }
143 
144   function balanceOf(address _owner) external view returns (uint256 balance) {
145     return balances[_owner];
146   }
147 
148   function approve(address _spender, uint256 _value) external returns (bool success) {
149     allowed[msg.sender][_spender] = _value;
150     emit Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158   function increaseApproval(address _spender, uint _addedValue) 
159       external returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval(address _spender, uint _subtractedValue) 
166     external returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   function transferMany(address [] _dests, uint256 [] _amounts) public {
178     require(_dests.length == _amounts.length);
179     for (uint i = 0; i < _dests.length; ++i) {
180       require(_transfer(_dests[i], _amounts[i]));
181     }
182   }
183 
184   function setPrice(uint256 _tokensPerWei) public {
185     require(msg.sender == owner);
186     tokensPerWei = _tokensPerWei;
187   }
188 
189   function withdrawTokens(address tokenAddress) public {
190     require(msg.sender == owner);
191     if (tokenAddress == address(0)) {
192       owner.transfer(address(this).balance);
193     } else {
194       ERC20 tok = ERC20(tokenAddress);
195       tok.transfer(owner, tok.balanceOf(this));
196     }
197   }  
198 
199   function _isContract(address _addr) internal view returns (bool is_contract) {
200     uint length;
201     assembly {
202       length := extcodesize(_addr)
203     }
204     return length > 0;
205   }
206 
207   function _contractFallback(address _origin, address _to, uint _value, bytes _data)
208       internal returns (bool success) {
209     ERC223Receiver reciever = ERC223Receiver(_to);
210     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
211   }
212 
213   function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool success) {
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     emit Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   function _transfer(address _to, uint256 _value) internal returns (bool success) {
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     emit Transfer(msg.sender, _to, _value);
226     return true;
227   }
228 }