1 pragma solidity ^0.4.0;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         require(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         require(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a && c >= b);
28         return c;
29     }
30 
31     function safeSqrt(uint256 x) internal pure returns (uint256 y) {
32         uint256 z = (x + 1) / 2;
33         y = x;
34         while (z < y) {
35             y = z;
36             z = (x / z + z) / 2;
37         }
38         require(safeMul(y, y) <= x);
39     }
40 }
41 
42 contract CrossroadsCoin is SafeMath {
43     address public owner;
44     string public name;
45     string public symbol;
46     uint8 public constant decimals = 18;
47     uint16 public constant exchangeRate = 10000; // handling fee, 1/10000
48 
49     uint256 public initialRate; // initial ether to CRC rate
50     uint256 public minRate; // min ether to CRC rate, minRate should no more than initial rate
51 
52     // rate curve: rate(x) = initialRate - x / k, x represent address(this).balance
53     // k should meet minRate = initialRate - destEtherNum / k
54     // so k value is destEtherNum / (initialRate - minRate)
55     uint256 public destEtherNum; // when contract receive destEtherNum ether, all CRC released
56     uint256 public k;
57 
58     // supply curve: totalSupply = initialRate * x - x^2/(2*k);
59     // so, while x reach to destEtherNum, the totalSupply = destEtherNum * (initialRate + minRate) / 2
60     uint256 public totalSupply = 0; // current supply is 0
61 
62     /* This creates an array with all balances */
63     mapping(address => uint256) public balanceOf;
64     mapping(address => mapping(address => uint256)) public allowance;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     event Approve(address indexed from, address indexed to, uint256 value);
69 
70     event Exchange(address indexed who, uint256 value); // use ether exchange CRC
71 
72     event Redeem(address indexed who, uint256 value); // use CRC redeem ether
73 
74 
75     // can accept ether, exchange CRC to msg.sender
76     function() public payable {
77         require(address(this).balance <= destEtherNum);
78         uint256 newSupply = calSupply(address(this).balance);
79         uint256 returnCRCNum = SafeMath.safeSub(newSupply, totalSupply);
80         totalSupply = newSupply;
81         if (msg.sender != owner) {
82             uint256 fee = SafeMath.safeDiv(returnCRCNum, exchangeRate);
83             balanceOf[owner] = SafeMath.safeAdd(balanceOf[owner],
84                 fee);
85             emit Transfer(msg.sender, owner, fee);
86             returnCRCNum = SafeMath.safeSub(returnCRCNum, fee);
87         }
88         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender],
89             returnCRCNum);
90         emit Exchange(msg.sender, returnCRCNum);
91         emit Transfer(address(0x0), msg.sender, returnCRCNum);
92     }
93 
94     // rate curve: rate(x) = initialRate - x / k, x represent address(this).balance
95     function calRate() public view returns (uint256){
96         uint256 x = address(this).balance;
97         return SafeMath.safeSub(initialRate, SafeMath.safeDiv(x, k));
98     }
99 
100     // x represent address(this).balance
101     // totalSupply = initialRate * x - x^2/(2*k)
102     function calSupply(uint256 x) public view returns (uint256){
103         uint256 opt1 = SafeMath.safeMul(initialRate, x);
104         uint256 opt2 = SafeMath.safeDiv(SafeMath.safeMul(x, x),
105             SafeMath.safeMul(2, k));
106         return SafeMath.safeSub(opt1, opt2);
107     }
108 
109     // because totalSupply = initialRate * x - x^2/(2*k), x represent address(this).balance
110     // so, x = initialRate * k - sqrt((initialRate * k)^2 - 2 * k * totalSupply)
111     function calEtherNumBySupply(uint256 y) public view returns (uint256){
112         uint256 opt1 = SafeMath.safeMul(initialRate, k);
113         uint256 sqrtOpt1 = SafeMath.safeMul(opt1, opt1);
114         uint256 sqrtOpt2 = SafeMath.safeMul(2, SafeMath.safeMul(k, y));
115         uint256 sqrtRes = SafeMath.safeSqrt(SafeMath.safeSub(sqrtOpt1, sqrtOpt2));
116         return SafeMath.safeSub(SafeMath.safeMul(initialRate, k), sqrtRes);
117     }
118 
119     /* Initializes contract with initial supply tokens to the creator of the contract */
120     constructor(uint256 _initialRate, uint256 _minRate, uint256 _destEtherNum) public {
121         owner = msg.sender;
122         name = "CrossroadsCoin";
123         symbol = "CRC";
124         // set exchangeRate
125         require(_minRate <= _initialRate);
126         require(_destEtherNum > 0);
127         initialRate = _initialRate;
128         minRate = _minRate;
129         destEtherNum = _destEtherNum;
130         k = SafeMath.safeDiv(_destEtherNum, SafeMath.safeSub(_initialRate, _minRate));
131     }
132 
133     /* Send coins */
134     function transfer(address _to, uint256 _value)
135     public {
136         // Prevent transfer to 0x0 address.
137         require(_to != 0x0);
138         require(_value > 0);
139         // Check if the sender has enough
140         require(balanceOf[msg.sender] >= _value);
141         // Check for overflows
142         require(balanceOf[_to] + _value > balanceOf[_to]);
143         if (_to == address(this)) {
144             redeem(_value);
145         } else {
146             // Add the _value to the recipient
147             balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
148         }
149         // Subtract from the sender
150         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
151         // Notify anyone listening that this transfer took place
152         emit Transfer(msg.sender, _to, _value);
153     }
154 
155     /* Allow another contract to spend some tokens in your behalf */
156     function approve(address _spender, uint256 _value)
157     public returns (bool success) {
158         require(_value > 0);
159         allowance[msg.sender][_spender] = _value;
160         return true;
161     }
162 
163 
164     /* A contract attempts to get the coins */
165     function transferFrom(address _from, address _to, uint256 _value)
166     public returns (bool success) {
167         // Prevent transfer to 0x0 address.
168         require(_to != 0x0);
169         require(_value > 0);
170         // Check if the sender has enough
171         require(balanceOf[_from] >= _value);
172         // Check for overflows
173         require(balanceOf[_to] + _value > balanceOf[_to]);
174         // Check allowance
175         require(_value <= allowance[_from][msg.sender]);
176         if (_to == address(this)) {
177             redeem(_value);
178         } else {
179             // Add the _value to the recipient
180             balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
181         }
182         // Subtract from the sender
183         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
184         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     function redeem(uint256 _value) private {
190         if (msg.sender != owner) {
191             uint256 fee = SafeMath.safeDiv(_value, exchangeRate);
192             balanceOf[owner] = SafeMath.safeAdd(balanceOf[owner], fee);
193             emit Transfer(msg.sender, owner, fee);
194             _value = SafeMath.safeSub(_value, fee);
195         }
196         uint256 newSupply = SafeMath.safeSub(totalSupply, _value);
197         require(newSupply >= 0);
198         uint256 newEtherNum = calEtherNumBySupply(newSupply);
199         uint256 etherBalance = address(this).balance;
200         require(newEtherNum <= etherBalance);
201         uint256 redeemEtherNum = SafeMath.safeSub(etherBalance, newEtherNum);
202         msg.sender.transfer(redeemEtherNum);
203         totalSupply = newSupply;
204         emit Redeem(msg.sender, redeemEtherNum);
205     }
206 }