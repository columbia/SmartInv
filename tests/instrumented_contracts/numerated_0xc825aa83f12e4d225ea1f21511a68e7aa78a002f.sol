1 pragma solidity ^0.4.18;
2 
3 // If you wanna escape this contract REALLY FAST
4 // 1. open MEW/METAMASK
5 // 2. Put this as data: 0xb1e35242
6 // 3. send 150000+ gas
7 // That calls the getMeOutOfHere() method
8 
9 contract PowhCoin3 {
10     uint256 constant PRECISION = 0x10000000000000000; // 2^64
11     int constant CRRN = 1;
12     int constant CRRD = 2;
13     int constant LOGC = -0x296ABF784A358468C;
14 
15     string constant public name = "PowhCoin3";
16     string constant public symbol = "POWH3";
17 
18     uint8 constant public decimals = 18;
19     uint256 public totalSupply;
20 
21     // amount of shares for each address (scaled number)
22     mapping(address => uint256) public balanceOfOld;
23 
24     // allowance map, see erc20
25     mapping(address => mapping(address => uint256)) public allowance;
26 
27     // amount payed out for each address (scaled number)
28     mapping(address => int256) payouts;
29 
30     // sum of all payouts (scaled number)
31     int256 totalPayouts;
32 
33     // amount earned for each share (scaled number)
34     uint256 earningsPerShare;
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39     function PowhCoin3() public {
40     }
41 
42     function balanceOf(address _owner) public constant returns (uint256 balance) {
43         return balanceOfOld[_owner];
44     }
45 
46     function withdraw(uint tokenCount) public returns (bool) {
47         var balance = dividends(msg.sender);
48         payouts[msg.sender] += (int256) (balance * PRECISION);
49         totalPayouts += (int256) (balance * PRECISION);
50         msg.sender.transfer(balance);
51         return true;
52     }
53 
54     function sellMyTokensDaddy() public {
55         var balance = balanceOf(msg.sender);
56         transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
57     }
58 
59     function getMeOutOfHere() public {
60         sellMyTokensDaddy();
61         withdraw(1); // parameter is ignored
62     }
63 
64     function fund() public payable returns (bool) {
65         if (msg.value > 0.000001 ether)
66             buy();
67         else
68             return false;
69 
70         return true;
71     }
72 
73     function buyPrice() public constant returns (uint) {
74         return getTokensForEther(1 finney);
75     }
76 
77     function sellPrice() public constant returns (uint) {
78         return getEtherForTokens(1 finney);
79     }
80 
81     function transferTokens(address _from, address _to, uint256 _value) internal {
82         if (balanceOfOld[_from] < _value)
83             revert();
84         if (_to == address(this)) {
85             sell(_value);
86         } else {
87             int256 payoutDiff = (int256) (earningsPerShare * _value);
88             balanceOfOld[_from] -= _value;
89             balanceOfOld[_to] += _value;
90             payouts[_from] -= payoutDiff;
91             payouts[_to] += payoutDiff;
92         }
93         Transfer(_from, _to, _value);
94     }
95 
96     function transfer(address _to, uint256 _value) public {
97         transferTokens(msg.sender, _to,  _value);
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) public {
101         var _allowance = allowance[_from][msg.sender];
102         if (_allowance < _value)
103             revert();
104         allowance[_from][msg.sender] = _allowance - _value;
105         transferTokens(_from, _to, _value);
106     }
107 
108     function approve(address _spender, uint256 _value) public {
109         // To change the approve amount you first have to reduce the addresses`
110         //  allowance to zero by calling `approve(_spender, 0)` if it is not
111         //  already 0 to mitigate the race condition described here:
112         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
114         allowance[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116     }
117 
118     function dividends(address _owner) public constant returns (uint256 amount) {
119         return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
120     }
121 
122     function withdrawOld(address to) public {
123         var balance = dividends(msg.sender);
124         payouts[msg.sender] += (int256) (balance * PRECISION);
125         totalPayouts += (int256) (balance * PRECISION);
126         to.transfer(balance);
127     }
128 
129     function balance() internal constant returns (uint256 amount) {
130         return this.balance - msg.value;
131     }
132 
133     function reserve() public constant returns (uint256 amount) {
134         return balance() - ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
135     }
136 
137     function buy() internal {
138         if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
139             revert();
140         var sender = msg.sender;
141         // 5 % of the amount is used to pay holders.
142         var fee = (uint)(msg.value / 10);
143 
144         // compute number of bought tokens
145         var numEther = msg.value - fee;
146         var numTokens = getTokensForEther(numEther);
147 
148         var buyerfee = fee * PRECISION;
149         if (totalSupply > 0) {
150             // compute how the fee distributed to previous holders and buyer.
151             // The buyer already gets a part of the fee as if he would buy each token separately.
152             var holderreward =
153                 (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
154                 * (uint)(CRRD) / (uint)(CRRD-CRRN);
155             var holderfee = fee * holderreward;
156             buyerfee -= holderfee;
157 
158             // Fee is distributed to all existing tokens before buying
159             var feePerShare = holderfee / totalSupply;
160             earningsPerShare += feePerShare;
161         }
162         // add numTokens to total supply
163         totalSupply += numTokens;
164         // add numTokens to balance
165         balanceOfOld[sender] += numTokens;
166         // fix payouts so that sender doesn't get old earnings for the new tokens.
167         // also add its buyerfee
168         var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
169         payouts[sender] += payoutDiff;
170         totalPayouts += payoutDiff;
171     }
172 
173     function sell(uint256 amount) internal {
174         var numEthers = getEtherForTokens(amount);
175         // remove tokens
176         totalSupply -= amount;
177         balanceOfOld[msg.sender] -= amount;
178 
179         // fix payouts and put the ethers in payout
180         var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
181         payouts[msg.sender] -= payoutDiff;
182         totalPayouts -= payoutDiff;
183     }
184 
185     function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
186         return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
187     }
188 
189     function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
190         if (tokens == totalSupply)
191             return reserve();
192         return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
193     }
194 
195     int256 constant one       = 0x10000000000000000;
196     uint256 constant sqrt2    = 0x16a09e667f3bcc908;
197     uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
198     int256 constant ln2       = 0x0b17217f7d1cf79ac;
199     int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
200     int256 constant c1        = 0x1ffffffffff9dac9b;
201     int256 constant c3        = 0x0aaaaaaac16877908;
202     int256 constant c5        = 0x0666664e5e9fa0c99;
203     int256 constant c7        = 0x049254026a7630acf;
204     int256 constant c9        = 0x038bd75ed37753d68;
205     int256 constant c11       = 0x03284a0c14610924f;
206 
207     function fixedLog(uint256 a) internal pure returns (int256 log) {
208         int32 scale = 0;
209         while (a > sqrt2) {
210             a /= 2;
211             scale++;
212         }
213         while (a <= sqrtdot5) {
214             a *= 2;
215             scale--;
216         }
217         int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
218         // The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
219         // approximates the function log(1+x)-log(1-x)
220         // Hence R(s) = log((1+s)/(1-s)) = log(a)
221         var z = (s*s) / one;
222         return scale * ln2 +
223             (s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
224                 /one))/one))/one))/one))/one);
225     }
226 
227     int256 constant c2 =  0x02aaaaaaaaa015db0;
228     int256 constant c4 = -0x000b60b60808399d1;
229     int256 constant c6 =  0x0000455956bccdd06;
230     int256 constant c8 = -0x000001b893ad04b3a;
231 
232     function fixedExp(int256 a) internal pure returns (uint256 exp) {
233         int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
234         a -= scale*ln2;
235         // The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
236         // approximates the function x*(exp(x)+1)/(exp(x)-1)
237         // Hence exp(x) = (R(x)+x)/(R(x)-x)
238         int256 z = (a*a) / one;
239         int256 R = ((int256)(2) * one) +
240             (z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
241         exp = (uint256) (((R + a) * one) / (R - a));
242         if (scale >= 0)
243             exp <<= scale;
244         else
245             exp >>= -scale;
246         return exp;
247     }
248 
249     function () payable public {
250         if (msg.value > 0)
251             buy();
252         else
253             withdrawOld(msg.sender);
254     }
255 }