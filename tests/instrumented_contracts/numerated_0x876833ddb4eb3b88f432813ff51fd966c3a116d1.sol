1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35   address public tech;
36   
37   constructor() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45   
46   modifier onlyTech() {
47     require(msg.sender == tech);
48     _;
49   }
50   
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     owner = newOwner;
54   }
55   
56   function transferTech(address newTech) public onlyOwner {
57     require(newTech != address(0));
58     tech = newTech;
59   }
60 }
61 
62 contract ERC20NonTransfer {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract BergCoin is ERC20NonTransfer, Ownable {
69   using SafeMath for uint256;
70   address public trade;
71   address public withdrawal;
72   mapping(address => uint256) balances;
73   string public name = "Berg";
74   string public symbol = "BERG";
75   uint256 totalSupply_;
76   uint8 public constant decimals = 18;
77   enum States {
78     Sale,
79     Stop
80   }
81   States public state;        
82   uint256 public price;
83   uint256 public min_amount;
84 
85   constructor() public {
86     totalSupply_ = 0;
87     state = States.Sale;
88     price = 2472383427000000;
89     min_amount = 0;
90     owner = msg.sender;
91     withdrawal = 0x8F28FDc5ee8256Ca656654FDFd3142D00cC7C81a;
92     tech = 0x8F28FDc5ee8256Ca656654FDFd3142D00cC7C81a;
93     trade = 0x5072C2dE837D83784ffBD1831c288D1Bd7C151c8;
94   }
95 
96   modifier requireState(States _requiredState) {
97     require(state == _requiredState);
98     _;
99   }
100   
101   function changeTrade(address _address)
102   onlyTech
103   public
104   {
105     trade = _address;
106   }
107   
108   function changeWithdrawal(address _address)
109   onlyTech
110   public
111   {
112     withdrawal = _address;
113   }
114   
115   function requestPayout(uint256 _amount, address _address)
116   onlyTech
117   public
118   {
119     _address.transfer(_amount);
120   }
121   
122   modifier minAmount(uint256 amount) {
123     require(amount >= min_amount);
124     _;
125   }
126   
127   function changePrice(uint256 _new_price)
128   onlyTech
129   public 
130   {
131     price = _new_price;
132   }
133   
134   function changeMinAmount(uint256 _new_min_amount)
135   onlyTech
136   public 
137   {
138     min_amount = _new_min_amount;
139   }
140   
141   function changeState(States _newState)
142   onlyTech
143   public
144   {
145     state = _newState;
146   }
147   
148   function() payable
149   requireState(States.Sale)
150   minAmount(msg.value)
151   public
152   {
153     uint256 _get = msg.value.mul(975).div(1000);
154     uint256 _coinIncrease = _get.mul((10 ** uint256(decimals))).div(price);
155     totalSupply_ = totalSupply_.add(_coinIncrease);
156     balances[msg.sender] = balances[msg.sender].add(_coinIncrease);
157     withdrawal.transfer(msg.value.sub(_get));
158     trade.transfer(_get);
159     emit Transfer(address(0), msg.sender, _coinIncrease);
160   }
161   
162   function decreaseTokens(address _address, uint256 _amount) 
163   onlyTech
164   public {
165     balances[_address] = balances[_address].sub(_amount);
166     totalSupply_ = totalSupply_.sub(_amount);
167   }
168   
169   function decreaseTokensMulti(address[] _address, uint256[] _amount) 
170   onlyTech
171   public {
172       for(uint i = 0; i < _address.length; i++){
173         balances[_address[i]] = balances[_address[i]].sub(_amount[i]);
174         totalSupply_ = totalSupply_.sub(_amount[i]);
175       }
176   }
177   
178   function totalSupply() public view returns (uint256) {
179     return totalSupply_;
180   }
181 
182   function balanceOf(address _owner) public view returns (uint256 balance) {
183     return balances[_owner];
184   }
185 
186   function addTokens(address _address, uint256 _amount) 
187   onlyTech
188   public {
189     totalSupply_ = totalSupply_.add(_amount);
190     balances[_address] = balances[_address].add(_amount);
191     emit Transfer(address(0), _address, _amount);
192   }
193   
194   function addTokensMulti(address[] _address, uint256[] _amount) 
195   onlyTech
196   public {
197       for(uint i = 0; i < _address.length; i++){
198         totalSupply_ = totalSupply_.add(_amount[i]);
199         balances[_address[i]] = balances[_address[i]].add(_amount[i]);
200         emit Transfer(address(0), _address[i], _amount[i]);
201       }
202   }
203 }