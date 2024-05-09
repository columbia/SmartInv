1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint256 a, uint256 b) internal pure returns(uint256) {
24         assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      */
33     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns(uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47      /**
48      * @dev x to the power of y 
49      */
50     function pwr(uint256 x, uint256 y)
51         internal 
52         pure 
53         returns (uint256)
54     {
55         if (x==0)
56             return (0);
57         else if (y==0)
58             return (1);
59         else{
60             uint256 z = x;
61             for (uint256 i = 1; i < y; i++)
62                 z = mul(z,x);
63             return (z);
64         }
65     }
66 }
67 
68 interface shareProfit {
69     function increaseProfit() external payable returns(bool);
70 }
71 
72 contract RTB2 is shareProfit {
73     using SafeMath for uint256;
74 
75     uint8 public decimals = 0;
76     uint256 public totalSupply = 700;                                            
77     uint256 public totalSold = 0;
78     uint256 public constant price = 1 ether;
79     string public name = "Retro Block Token 2";
80     string public symbol = "RTB2";
81     address public owner;
82     address public finance;
83     
84     mapping (address=>uint256) received;
85     uint256 profit;
86     address public jackpot;
87     shareProfit public shareContract;
88     mapping (address=>uint256) changeProfit;
89 
90     mapping (address=>uint256) balances;
91     mapping (address=>mapping (address=>uint256)) allowed;
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     event AddProfit(address indexed _from, uint256 _value, uint256 _newProfit);
96     event Withdraw(address indexed _addr, uint256 _value);
97     
98     modifier onlyOwner() {
99         require(msg.sender == owner, "only owner");
100         _;
101     }
102     
103     modifier onlyHuman() {
104         address _addr = msg.sender;
105         uint256 _codeLength;
106         
107         assembly {_codeLength := extcodesize(_addr)}
108         require(_codeLength == 0, "sorry humans only");
109         _;
110     }
111     
112     constructor(address _shareAddr) public {
113         owner = msg.sender;
114         finance = 0x28Dd611d5d2cAA117239bD3f3A548DcE5Fa873b0;
115         jackpot = 0x119ea7f823588D2Db81d86cEFe4F3BE25e4C34DC;
116         shareContract = shareProfit(_shareAddr);
117         balances[this] = 700;
118     }
119 
120     function() public payable {
121         require(msg.value > 0, "Amount must be provided");
122         profit = msg.value.div(totalSupply).add(profit);
123         emit AddProfit(msg.sender, msg.value, profit);
124     }
125     
126     function increaseProfit() external payable returns(bool){
127         if(msg.value > 0){
128             profit = msg.value.div(totalSupply).add(profit);
129             emit AddProfit(msg.sender, msg.value, profit);
130             return true;
131         }else{
132             return false;
133         }
134     }
135     
136     function totalSupply() external view returns (uint256){
137         return totalSupply;
138     }
139 
140     function balanceOf(address _owner) external view returns (uint256) {
141         return balances[_owner];
142     }
143 
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         require(_value > 0 && allowed[msg.sender][_spender] == 0);
146         allowed[msg.sender][_spender] = _value;
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
152         require(_value <= allowed[_from][msg.sender]);
153         allowed[_from][msg.sender] -= _value;
154         return _transfer(_from, _to, _value);
155     }
156 
157     function allowance(address _owner, address _spender) external view returns (uint256) {
158         return allowed[_owner][_spender];
159     }
160     
161     function transfer(address _to, uint256 _value) external returns (bool) {
162         return _transfer(msg.sender, _to, _value);
163     }
164 
165     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
166         require(_to != address(0), "Receiver address cannot be null");
167         require(_from != _to);
168         require(_value > 0 && _value <= balances[_from]);
169         uint256 newToVal = balances[_to] + _value;
170         assert(newToVal >= balances[_to]);
171         uint256 newFromVal = balances[_from] - _value;
172         balances[_to] = newToVal;
173         balances[_from] =  newFromVal;
174         uint256 temp = _value.mul(profit);
175         changeProfit[_from] = changeProfit[_from].add(temp);
176         received[_to] = received[_to].add(temp);
177         emit Transfer(_from, _to, _value);
178         return true;
179     }
180     
181     function buy(uint256 _amount) external onlyHuman payable{
182         require(_amount > 0);
183         uint256 _money = _amount.mul(price);
184         require(msg.value == _money);
185         require(balances[this] >= _amount);
186         require((totalSupply - totalSold) >= _amount, "Sold out");
187         _transfer(this, msg.sender, _amount);
188         finance.transfer(_money.mul(60).div(100));
189         jackpot.transfer(_money.mul(20).div(100));
190         shareContract.increaseProfit.value(_money.mul(20).div(100))();
191         totalSold += _amount;
192     }
193 
194     function withdraw() external {
195         uint256 value = getProfit(msg.sender);
196         require(value > 0, "No cash available");
197         emit Withdraw(msg.sender, value);
198         received[msg.sender] = received[msg.sender].add(value);
199         msg.sender.transfer(value);
200     } 
201 
202     function devWithdraw() public onlyOwner{
203         uint256 value = getProfit(this);
204         emit Withdraw(msg.sender, value);
205         received[this] = received[this].add(value);
206         owner.transfer(value);
207     }
208 
209     function getProfit(address _addr) public view returns(uint256){
210         return profit.mul(balances[_addr]).add(changeProfit[_addr]).sub(received[_addr]);
211     }
212     
213     function setJackpot(address _addr) public onlyOwner{
214         jackpot = _addr;
215     }
216     
217     function setShare(address _addr) public onlyOwner{
218         shareContract = shareProfit(_addr);
219     }
220     
221     function setFinance(address _addr) public onlyOwner{
222         finance = _addr;
223     }
224 
225 }