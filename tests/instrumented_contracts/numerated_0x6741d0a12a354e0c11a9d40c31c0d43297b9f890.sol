1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns(uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256){
12     if(a==0){
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256){
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256){
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41   mapping(address => uint256) internal balances;
42   uint256 internal totalSupply_;
43   
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   function transfer (address _to, uint256 _value) public returns (bool){
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns(uint256 balance){
60     return balances[_owner];
61   }
62 }
63 
64 contract BurnableToken is BasicToken {
65   event Burn(address indexed burner, uint256 value);
66 
67   function burn(uint256 _value) public {
68     _burn(msg.sender, _value);
69   }
70 
71   function _burn(address _who, uint256 _value) internal {
72     require(_value <= balances[_who]);
73     balances[_who] = balances[_who].sub(_value);
74     totalSupply_ = totalSupply_.sub(_value);
75     
76     emit Burn(_who, _value);
77     emit Transfer(_who, address(0), _value);
78   }
79 }
80 
81 contract DRToken is BurnableToken {
82   string public constant name = "DrawingRun";
83   string public constant symbol = "DR";
84   uint8 public constant decimals = 18;
85   uint256 public totalSupply;
86 
87   constructor() public{
88     totalSupply = 30000000000 * 10**uint256(decimals);
89     balances[msg.sender] = totalSupply;
90   }
91 }
92 
93 contract Ownable {
94   address public owner;
95 
96   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97  
98   constructor() public {
99     owner = msg.sender;
100   }
101 
102   modifier onlyOwner {
103     require(msg.sender == owner);
104     _;
105   }
106 
107   function transferOwnership(address newOwner) public onlyOwner {
108     require(newOwner != address(0));
109     owner = newOwner;
110     emit OwnershipTransferred(owner, newOwner);
111   }
112 }
113 
114 contract DRCrowdsale is Ownable {
115   using SafeMath for uint256;
116 
117   DRToken public token;  //跑图币合约地址 
118   address public wallet;  //众筹钱包地址 
119   
120   uint256 public saleStart;  //众筹开始时间，用来设置单价自动增长 
121   uint256 public saleEnd;  //众筹结束时间，需要手动设置才能开始或暂停众筹项目 
122   uint256 public price = 2; //token单价，以0.00002ETH起价 (目前相当于0.077元)
123   uint256 public constant increasedPrice = 2;  //0.00002ETH (每十天自动增加increasedPrice)
124   uint256 public constant rate = 100000;  //以太坊币和跑图币的兑换比率 
125   uint256 public tokens;
126 
127   constructor(address _token, address _wallet) public {
128     require(_token != address(0));
129     require(_wallet != address(0));
130     token = DRToken(_token);
131     wallet = _wallet;
132     saleStart = now;
133     saleEnd = now;
134   }
135   
136   //设置结束时间，用来开始或暂停合约执行 
137   function setSaleEnd(uint256 newSaleEnd) onlyOwner public {
138     saleEnd = newSaleEnd;
139   }
140   
141   function getTokenBalance(address _token) public view onlyOwner returns (uint256){
142       return token.balanceOf(_token);
143   }
144   //获取当前合约执行状态 
145   function getStatus() public view onlyOwner returns(bool){
146       return now < saleEnd;
147   }
148 
149   function _buyTokens() internal {
150     //每隔十天，token单价自动增加（价格自动递增，任何人不能进行人工干预。合约暂停时，单价不递增）
151     if(now.sub(saleStart) > 10 * 24 * 3600){ //需要有人购买后才会激活
152         saleStart = now;
153         price = price.add(increasedPrice);
154     }
155     require(price >= increasedPrice);
156     uint256 weiAmount = msg.value;
157     tokens = weiAmount.mul(rate).div(price);
158     bool success = token.transfer(msg.sender, tokens);
159     require(success);
160     wallet.transfer(msg.value);
161   }
162 
163   //在向合约转账时，自动购买跑图币
164   function () public payable{
165     require(msg.sender != address(0));
166     require(msg.value > 0);
167     require(now < saleEnd);
168 
169     _buyTokens();
170   }
171 
172   function burningTokens() public onlyOwner{
173     if(now > saleEnd){
174       token.burn(tokens);
175     }
176   }
177 }