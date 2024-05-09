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
47   //function transferOwnership(address newOwner) public onlyOwner {
48   function transferOwnership(address newOwner) public {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53   
54   function getOwner() view public returns (address){
55     return owner;
56   }
57   
58 
59 }
60 
61 
62 
63 contract BitLoanex is Ownable {
64 
65   using SafeMath for uint256;
66   
67   string public constant name = "Bitloanex";
68   string public constant symbol = "BTLX";
69   uint8 public constant decimals = 8;
70 
71   uint256 public rate;
72   uint256 public constant CAP = 126000;
73   uint256 public constant START = 1514160000;
74   uint256 public DAYS = 30;
75   uint256 public days_interval = 3;
76   uint[9] public deadlines = [START, START.add(1* days_interval * 1 days), START.add(2* days_interval * 1 days), START.add(3* days_interval * 1 days), START.add(4* days_interval * 1 days), START.add(5* days_interval * 1 days), START.add(6* days_interval * 1 days), START.add(7* days_interval * 1 days), START.add(8* days_interval * 1 days)  ];
77   uint[9] public rates = [2000, 1800, 1650, 1550, 1450, 1350, 1250, 1150, 1100];
78   bool public initialized = true;
79   uint256 public raisedAmount = 0;
80   uint256 public constant INITIAL_SUPPLY = 10000000000000000;
81   uint256 public totalSupply;
82   address[] public investors;
83   uint[] public timeBought;
84   
85   mapping(address => uint256) balances;
86   mapping (address => mapping (address => uint256)) internal allowed;
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89   event BoughtTokens(address indexed to, uint256 value);
90   
91   function BitLoanex() public {
92     totalSupply = INITIAL_SUPPLY;
93     balances[msg.sender] = INITIAL_SUPPLY;
94   }
95 
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107 
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125 
126   function approve(address _spender, uint256 _value) public returns (bool) {
127     allowed[msg.sender][_spender] = _value;
128     Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132 
133   function allowance(address _owner, address _spender) public view returns (uint256) {
134     return allowed[_owner][_spender];
135   }
136 
137   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144     uint oldValue = allowed[msg.sender][_spender];
145     if (_subtractedValue > oldValue) {
146       allowed[msg.sender][_spender] = 0;
147     } else {
148       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149     }
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154   modifier whenSaleActive() {
155   assert(isActive());
156   _;
157   }
158 
159 
160 
161   function initialize(bool _val) public onlyOwner {
162       
163     initialized = _val;
164 
165   }
166 
167 
168   function isActive() public constant returns (bool) {
169     return(
170       initialized == true &&
171       now >= START &&
172       now <= START.add(DAYS * 1 days) &&
173       goalReached() == false
174     );
175   }
176 
177   function goalReached() private constant returns (bool) {
178     return (raisedAmount >= CAP * 1 ether);
179   }
180 
181   function () public payable {
182 
183     buyTokens();
184 
185   }
186 
187   function buyTokens() public payable {
188       
189     require(initialized && now <= START.add(DAYS * 1 days));
190     
191     uint256 weiAmount = msg.value;
192     uint256 tokens = weiAmount.mul(getRate());
193     
194     tokens = tokens.div(1 ether);
195     
196     BoughtTokens(msg.sender, tokens);
197 
198     balances[msg.sender] = balances[msg.sender].add(tokens);
199     balances[owner] = balances[owner].sub(tokens);
200     totalSupply.sub(tokens);
201 
202     timeBought.push(now) -1;
203     
204     raisedAmount = raisedAmount.add(msg.value);
205     
206     investors.push(msg.sender) -1;
207     //owner.transfer(msg.value);
208   }
209   
210   function tokenBoughtPerTime(uint _time) public view returns (uint256) {
211     uint256 num = 0;
212     for(var i = 0; i < timeBought.length; i++){
213           if(_time<=timeBought[i]){
214               num++;
215           }
216     }
217     return num;
218   }
219   
220   function getInvestors() view public returns (address[])
221   {
222       return investors;
223   }
224 
225   function tokenAvailable() public constant returns (uint256){
226      return totalSupply;
227   }
228   
229   function setRate(uint256 _rate) public onlyOwner
230   {
231       rate = _rate;
232   }
233   
234   function setInterval(uint256 _rate) public onlyOwner
235   {
236       days_interval = _rate;
237   }
238   
239   function setDays(uint256 _day) public onlyOwner
240   {
241       DAYS = _day;
242   }
243 
244   function getRate() public constant returns (uint256){
245       
246       if(rate > 0) return rate;
247       
248       for(var i = 0; i < deadlines.length; i++)
249           if(now<deadlines[i])
250               return rates[i-1];
251       return rates[rates.length-1];//should never be returned, but to be sure to not divide by 0
252   }
253   
254   function destroy() public onlyOwner {
255     selfdestruct(owner);
256   }
257 
258 
259 }