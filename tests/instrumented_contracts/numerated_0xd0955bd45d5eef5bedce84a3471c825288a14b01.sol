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
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
72 contract RTB1 is shareProfit{
73     using SafeMath for uint256;
74 
75     uint8 public decimals = 0;
76     uint256 public totalSupply = 300;
77     uint256 public totalSold = 0;
78     uint256 public price = 1 ether;
79     string public name = "Retro Block Token 1";
80     string public symbol = "RTB1";
81     address public owner;
82     address public finance;
83     
84     mapping (address=>uint256) received;
85     uint256 profit;
86     address public jackpot;
87     mapping (address=>uint256) changeProfit;
88 
89     mapping (address=>uint256) balances;
90     mapping (address=>mapping (address=>uint256)) allowed;
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     event AddProfit(address indexed _from, uint256 _value, uint256 _newProfit);
95     event Withdraw(address indexed _addr, uint256 _value);
96     
97     modifier onlyOwner() {
98         require(msg.sender == owner, "only owner");
99         _;
100     }
101     
102     modifier onlyHuman() {
103         address _addr = msg.sender;
104         uint256 _codeLength;
105         
106         assembly {_codeLength := extcodesize(_addr)}
107         require(_codeLength == 0, "sorry humans only");
108         _;
109     }
110     
111     constructor() public {
112         owner = msg.sender;
113         finance = 0x28Dd611d5d2cAA117239bD3f3A548DcE5Fa873b0;
114         jackpot = 0x119ea7f823588D2Db81d86cEFe4F3BE25e4C34DC;
115         balances[this] = 300;
116     }
117 
118     function() public payable {
119         if(msg.value > 0){
120             profit = msg.value.div(totalSupply).add(profit);
121             emit AddProfit(msg.sender, msg.value, profit);
122         }
123     }
124     
125     function increaseProfit() external payable returns(bool){
126         if(msg.value > 0){
127             profit = msg.value.div(totalSupply).add(profit);
128             emit AddProfit(msg.sender, msg.value, profit);
129             return true;
130         }else{
131             return false;
132         }
133     }
134     
135     function totalSupply() external view returns (uint256){
136         return totalSupply;
137     }
138 
139     function balanceOf(address _owner) external view returns (uint256) {
140         return balances[_owner];
141     }
142 
143     function approve(address _spender, uint256 _value) public returns (bool) {
144         require(_value > 0 && allowed[msg.sender][_spender] == 0);
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
151         require(_value <= allowed[_from][msg.sender]);
152         allowed[_from][msg.sender] -= _value;
153         return _transfer(_from, _to, _value);
154     }
155 
156     function allowance(address _owner, address _spender) external view returns (uint256) {
157         return allowed[_owner][_spender];
158     }
159     
160     function transfer(address _to, uint256 _value) external returns (bool) {
161         return _transfer(msg.sender, _to, _value);
162     }
163 
164     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
165         require(_to != address(0), "Receiver address cannot be null");
166         require(_value > 0 && _value <= balances[_from]);
167         uint256 newToVal = balances[_to] + _value;
168         assert(newToVal >= balances[_to]);
169         uint256 newFromVal = balances[_from] - _value;
170         balances[_from] =  newFromVal;
171         balances[_to] = newToVal;
172         uint256 temp = _value.mul(profit);
173         changeProfit[_from] = changeProfit[_from].add(temp);
174         received[_to] = received[_to].add(temp);
175         emit Transfer(_from, _to, _value);
176         return true;
177     }
178     
179     function buy(uint256 _amount) external onlyHuman payable{
180         require(_amount > 0);
181         uint256 _money = _amount.mul(price);
182         require(msg.value == _money);
183         require(balances[this] >= _amount);
184         require((totalSupply - totalSold) >= _amount, "Sold out");
185         finance.transfer(_money.mul(80).div(100));
186         _transfer(this, msg.sender, _amount);
187         jackpot.transfer(_money.mul(20).div(100));
188         totalSold += _amount;
189     }
190 
191     function withdraw() external {
192         uint256 value = getProfit(msg.sender);
193         require(value > 0, "No cash available");
194         emit Withdraw(msg.sender, value);
195         received[msg.sender] = received[msg.sender].add(value);
196         msg.sender.transfer(value);
197     }
198 
199     function getProfit(address _addr) public view returns(uint256){
200         return profit.mul(balances[_addr]).add(changeProfit[_addr]).sub(received[_addr]);
201     }
202     
203     function setJackpot(address _addr) public onlyOwner{
204         jackpot = _addr;
205     }
206     
207     function setFinance(address _addr) public onlyOwner{
208         finance = _addr;
209     }
210 }