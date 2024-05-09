1 pragma solidity ^0.4.15;
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
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   function Ownable() public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52   
53   function getOwner() view public returns (address){
54     return owner;
55   }
56   
57 
58 }
59 
60 
61 
62 contract BitLoanex is Ownable {
63 
64   using SafeMath for uint256;
65   
66   string public constant name = "Bitloanex";
67   string public constant symbol = "BTLX";
68   uint8 public constant decimals = 8;
69 
70   uint256 public rate;
71   uint256 public constant CAP = 126000;
72   uint256 public constant START = 1514160000;
73   uint256 public DAYS = 30;
74   uint256 public days_interval = 4;
75   uint[9] public deadlines = [START, START.add(1* days_interval * 1 days), START.add(2* days_interval * 1 days), START.add(3* days_interval * 1 days), START.add(4* days_interval * 1 days), START.add(5* days_interval * 1 days), START.add(6* days_interval * 1 days), START.add(7* days_interval * 1 days), START.add(8* days_interval * 1 days)  ];
76   uint[9] public rates = [2000 ,1900, 1800, 1700, 1600, 1500, 1400, 1300, 1200];
77   bool public initialized = true;
78   uint256 public raisedAmount = 0;
79   uint256 public constant INITIAL_SUPPLY = 10000000000000000;
80   uint256 public totalSupply;
81   address[] public investors;
82 
83   mapping(address => uint256) balances;
84   mapping (address => mapping (address => uint256)) internal allowed;
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87   event BoughtTokens(address indexed to, uint256 value);
88   
89   function BitLoanex() public {
90     totalSupply = INITIAL_SUPPLY;
91     balances[msg.sender] = INITIAL_SUPPLY;
92   }
93 
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105 
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123 
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130 
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   modifier whenSaleActive() {
153   assert(isActive());
154   _;
155   }
156 
157 
158 
159   function initialize(bool _val) public onlyOwner {
160       
161     initialized = _val;
162 
163   }
164 
165 
166   function isActive() public constant returns (bool) {
167     return(
168       initialized == true &&
169       now >= START &&
170       now <= START.add(DAYS * 1 days) &&
171       goalReached() == false
172     );
173   }
174 
175   function goalReached() private constant returns (bool) {
176     return (raisedAmount >= CAP * 1 ether);
177   }
178 
179   function () public payable {
180 
181     buyTokens();
182 
183   }
184 
185   function buyTokens() public payable {
186       
187     require(initialized && now <= START.add(DAYS * 1 days));
188     
189     uint256 weiAmount = msg.value;
190     uint256 tokens = weiAmount.mul(getRate());
191     
192     tokens = tokens.div(1 ether);
193     
194     BoughtTokens(msg.sender, tokens);
195 
196     balances[msg.sender] = balances[msg.sender].add(tokens);
197     balances[owner] = balances[owner].sub(tokens);
198     totalSupply.sub(tokens);
199 
200     raisedAmount = raisedAmount.add(msg.value);
201     
202     investors.push(msg.sender) -1;
203     //owner.transfer(msg.value);
204   }
205   
206   function getInvestors() view public returns (address[])
207   {
208       return investors;
209   }
210 
211   function tokenAvailable() public constant returns (uint256){
212      return totalSupply;
213   }
214   
215   function setRate(uint256 _rate) public onlyOwner
216   {
217       rate = _rate;
218   }
219   
220   function setDays(uint256 _day) public onlyOwner
221   {
222       DAYS = _day;
223   }
224 
225   function getRate() public constant returns (uint256){
226       
227       if(rate > 0) return rate;
228       
229       for(var i = 0; i < deadlines.length; i++)
230           if(now<deadlines[i])
231               return rates[i];
232       return rates[rates.length-1];//should never be returned, but to be sure to not divide by 0
233   }
234   
235   function destroy() public onlyOwner {
236     selfdestruct(owner);
237   }
238 
239 
240 }