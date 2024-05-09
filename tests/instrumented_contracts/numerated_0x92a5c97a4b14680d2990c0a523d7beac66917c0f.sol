1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  *  EasyInvest7 V2 Contract
6  *  - GAIN 7% PER 24 HOURS
7  *  - Principal withdrawal anytime
8  *  - The balance of the contract can not greater than 200eth
9  *
10  *
11  * How to use:
12  *  1. Send amount of ether to make an investment, max 50eth
13  *  2a. Get your profit and your principal by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
14  *  OR
15  *  2b. Send more ether to reinvest AND get your profit at the same time
16  *
17  * RECOMMENDED GAS LIMIT: 150000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  *
20  * www.easyinvest7.biz
21  *
22  */
23 contract EasyInvestV2 {
24     using SafeMath              for *;
25 
26     string constant public name = "EasyInvest7";
27     string constant public symbol = "EasyInvest7";
28     
29     uint256 _maxInvest = 5e19;
30     uint256 _maxBalance = 2e20; 
31 
32     address public promoAddr_ = address(0x81eCf0979668D3C6a812B404215B53310f14f451);
33     
34     // records amounts invested
35     mapping (address => uint256) public invested;
36     // records time at which investments were made
37     mapping (address => uint256) public atTime;
38     
39     uint256 public NowETHINVESTED = 0;
40     uint256 public AllINVESTORS = 0;
41     uint256 public AllETHINVESTED = 0;
42 
43     // this function called every time anyone sends a transaction to this contract
44     function () external payable {
45         
46         uint256 realBalance = getBalance().sub(msg.value);
47         
48         require(msg.value <= _maxInvest  , "invest amount error, please set the exact amount");
49         require(realBalance < _maxBalance  , "max balance, can't invest");
50         
51         uint256 more_ = 0;
52         uint256 amount_ = msg.value;
53         if (amount_.add(realBalance) > _maxBalance && amount_ > 0) {
54             more_ = amount_.add(realBalance).sub(_maxBalance);
55             amount_ = amount_.sub(more_);
56             
57             msg.sender.transfer(more_);
58         }
59         
60         if (amount_.add(invested[msg.sender]) > _maxInvest && amount_ > 0) {
61             more_ = amount_.add(invested[msg.sender]).sub(_maxInvest);
62             amount_ = amount_.sub(more_);
63             
64             msg.sender.transfer(more_);
65         }
66 
67         // if sender (aka YOU) is invested more than 0 ether
68         if (invested[msg.sender] != 0) {
69             // calculate profit amount as such:
70             // amount = (amount invested) * 7% * (times since last transaction) / 24 hours
71             uint256 amount = invested[msg.sender] * 7 / 100 * (now - atTime[msg.sender]) / 24 hours;
72 
73             // send calculated amount of ether directly to sender (aka YOU)
74             msg.sender.transfer(amount);
75         } else {
76             if (atTime[msg.sender] == 0) {
77                 AllINVESTORS += 1;
78             }
79         }
80 
81         // record time and invested amount (msg.value) of this transaction
82         if (msg.value == 0 && invested[msg.sender] != 0) {
83             msg.sender.transfer(invested[msg.sender]);
84             NowETHINVESTED = NowETHINVESTED.sub(invested[msg.sender]);
85             
86             atTime[msg.sender] = now;
87             invested[msg.sender] = 0;
88             
89         } else {
90             atTime[msg.sender] = now;
91             invested[msg.sender] += amount_;
92             NowETHINVESTED = NowETHINVESTED.add(amount_);
93             AllETHINVESTED = AllETHINVESTED.add(amount_);
94         }
95         
96         if (amount_ > 1e14) {
97             promoAddr_.transfer(amount_.mul(2).div(100));
98         }
99     }
100     
101     function getBalance() public view returns (uint256){
102         return address(this).balance;
103     }
104     
105 
106 }
107 
108 /***********************************************************
109  * @title SafeMath v0.1.9
110  * @dev Math operations with safety checks that throw on error
111  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
112  * - added sqrt
113  * - added sq
114  * - added pwr 
115  * - changed asserts to requires with error log outputs
116  * - removed div, its useless
117  ***********************************************************/
118  library SafeMath {
119     /**
120     * @dev Multiplies two numbers, throws on overflow.
121     */
122     function mul(uint256 a, uint256 b) 
123         internal 
124         pure 
125         returns (uint256 c) 
126     {
127         if (a == 0) {
128             return 0;
129         }
130         c = a * b;
131         require(c / a == b, "SafeMath mul failed");
132         return c;
133     }
134 
135     /**
136     * @dev Integer division of two numbers, truncating the quotient.
137     */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         // assert(b > 0); // Solidity automatically throws when dividing by 0
140         uint256 c = a / b;
141         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142         return c;
143     }
144     
145     /**
146     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
147     */
148     function sub(uint256 a, uint256 b)
149         internal
150         pure
151         returns (uint256) 
152     {
153         require(b <= a, "SafeMath sub failed");
154         return a - b;
155     }
156 
157     /**
158     * @dev Adds two numbers, throws on overflow.
159     */
160     function add(uint256 a, uint256 b)
161         internal
162         pure
163         returns (uint256 c) 
164     {
165         c = a + b;
166         require(c >= a, "SafeMath add failed");
167         return c;
168     }
169     
170     /**
171      * @dev gives square root of given x.
172      */
173     function sqrt(uint256 x)
174         internal
175         pure
176         returns (uint256 y) 
177     {
178         uint256 z = ((add(x,1)) / 2);
179         y = x;
180         while (z < y) 
181         {
182             y = z;
183             z = ((add((x / z),z)) / 2);
184         }
185     }
186     
187     /**
188      * @dev gives square. multiplies x by x
189      */
190     function sq(uint256 x)
191         internal
192         pure
193         returns (uint256)
194     {
195         return (mul(x,x));
196     }
197     
198     /**
199      * @dev x to the power of y 
200      */
201     function pwr(uint256 x, uint256 y)
202         internal 
203         pure 
204         returns (uint256)
205     {
206         if (x==0)
207             return (0);
208         else if (y==0)
209             return (1);
210         else 
211         {
212             uint256 z = x;
213             for (uint256 i=1; i < y; i++)
214                 z = mul(z,x);
215             return (z);
216         }
217     }
218 }