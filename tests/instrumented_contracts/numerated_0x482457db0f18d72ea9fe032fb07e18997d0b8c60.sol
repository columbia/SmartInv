1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         assert(owner == msg.sender);
13         _;
14     }
15 
16     function transferOwnership(address candidate) external onlyOwner {
17         owner = candidate;
18     }
19 }
20 
21 
22 contract SafeMath {
23     function safeMul(uint a, uint b) pure internal returns (uint) {
24         uint c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function safeDiv(uint a, uint b) pure internal returns (uint) {
30         uint c = a / b;
31         assert(b == 0);
32         return c;
33     }
34 
35     function safeSub(uint a, uint b) pure internal returns (uint) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function safeAdd(uint a, uint b) pure internal returns (uint) {
41         uint c = a + b;
42         assert(c >= a && c >= b);
43         return c;
44     }
45 }
46 
47 
48 contract VBToken is SafeMath, owned {
49 
50     string public name = "VBToken";        //  token name
51     string public symbol = "VB";      //  token symbol
52     uint public decimals = 8;           //  token digit
53 
54     mapping (address => uint) public balanceOf;
55     mapping (address => mapping (address => uint)) public allowance;
56 
57     uint public totalSupply = 0;
58 
59 
60     address private addressTeam = 0x5b1FcBA12b4757549bf5d0550af253DE5E0F73c5;
61 
62 
63     address private addressFund = 0xA703356488F7335269e5860ca41f787dFF50b76C;
64 
65 
66     address private addressPopular = 0x1db0304A3f2a861e7Ab8B7305AF1dC1ee4c3e94d;
67 
68 
69     address private addressVip = 0x6e41aA4d64F9f4a190a9AF2292F815259BAef65c;
70 
71 
72     uint constant valueTotal = 10 * 10000 * 10000 * 10 ** 8;  
73     uint constant valueTeam = valueTotal / 100 * 20;   
74     uint constant valueFund = valueTotal / 100 * 30; 
75     uint constant valuePopular = valueTotal / 100 * 20; 
76     uint constant valueSale = valueTotal / 100 * 20;  
77     uint constant valueVip = valueTotal / 100 * 10;   
78 
79     bool public saleStopped = false;
80 
81     uint private constant BEFORE_SALE = 0;
82     uint private constant IN_SALE = 1;
83     uint private constant FINISHED = 2;
84 
85     uint public minEth = 0.01 ether;
86 
87     uint public maxEth = 1000 ether;
88 
89     //2018-03-31 23:00:00
90     uint public openTime = 1522508400;
91     //2018-06-30 23:00:00
92     uint public closeTime = 1530370800;
93 
94     uint public price = 2500;
95 
96     uint public saleQuantity = 0;
97 
98     uint public ethQuantity = 0;
99 
100     uint public withdrawQuantity = 0;
101 
102 
103     modifier validAddress(address _address) {
104         assert(0x0 != _address);
105         _;
106     }
107 
108     modifier validEth {
109         assert(msg.value >= minEth && msg.value <= maxEth);
110         _;
111     }
112 
113     modifier validPeriod {
114         assert(now >= openTime && now < closeTime);
115         _;
116     }
117 
118     modifier validQuantity {
119         assert(valueSale >= saleQuantity);
120         _;
121     }
122 
123     modifier validStatue {
124         assert(saleStopped == false);
125         _;
126     }
127 
128     function setOpenTime(uint newOpenTime) public onlyOwner {
129         openTime = newOpenTime;
130     }
131 
132     function setCloseTime(uint newCloseTime) public onlyOwner {
133         closeTime = newCloseTime;
134     }
135 
136     function setPrice(uint newPrice) public onlyOwner {
137         price = newPrice;
138     }
139 
140     function VBToken()
141         public
142     {
143         owner = msg.sender;
144         totalSupply = valueTotal;
145 
146         // ICO
147         balanceOf[this] = valueSale;
148         Transfer(0x0, this, valueSale);
149 
150         // Simu
151         balanceOf[addressVip] = valueVip;
152         Transfer(0x0, addressVip, valueVip);
153 
154         // Found
155         balanceOf[addressFund] = valueFund;
156         Transfer(0x0, addressFund, valueFund);
157 
158         // valuePopular
159         balanceOf[addressPopular] = valuePopular;
160         Transfer(0x0, addressPopular, valuePopular);
161 
162         // 团队
163         balanceOf[addressTeam] = valueTeam;
164         Transfer(0x0, addressTeam, valueTeam);
165     }
166 
167     function transfer(address _to, uint _value)
168         public
169         validAddress(_to)
170         returns (bool success)
171     {
172         require(balanceOf[msg.sender] >= _value);
173         require(balanceOf[_to] + _value >= balanceOf[_to]);
174         require(validTransfer(_value));
175         balanceOf[msg.sender] -= _value;
176         balanceOf[_to] += _value;
177         Transfer(msg.sender, _to, _value);
178         return true;
179     }
180 
181     function transferInner(address _to, uint _value)
182         private
183         returns (bool success)
184     {
185         balanceOf[this] -= _value;
186         balanceOf[_to] += _value;
187         Transfer(this, _to, _value);
188         return true;
189     }
190 
191 
192     function transferFrom(address _from, address _to, uint _value)
193         public
194         validAddress(_from)
195         validAddress(_to)
196         returns (bool success)
197     {
198         require(balanceOf[_from] >= _value);
199         require(balanceOf[_to] + _value >= balanceOf[_to]);
200         require(allowance[_from][msg.sender] >= _value);
201         require(validTransfer(_value));
202         balanceOf[_to] += _value;
203         balanceOf[_from] -= _value;
204         allowance[_from][msg.sender] -= _value;
205         Transfer(_from, _to, _value);
206         return true;
207     }
208 
209     function batchtransfer(address[] _to, uint256[] _amount) public returns(bool success) {
210         for(uint i = 0; i < _to.length; i++){
211             require(transfer(_to[i], _amount[i]));
212         }
213         return true;
214     }
215 
216     function approve(address _spender, uint _value)
217         public
218         validAddress(_spender)
219         returns (bool success)
220     {
221         require(_value == 0 || allowance[msg.sender][_spender] == 0);
222         allowance[msg.sender][_spender] = _value;
223         Approval(msg.sender, _spender, _value);
224         return true;
225     }
226 
227     function validTransfer(uint _value)
228         pure private
229         returns (bool)
230     {
231         if (_value == 0)
232             return false;
233 
234         return true;
235     }
236 
237     function ()
238         public
239         payable
240     {
241         buy();
242     }
243 
244     function buy()
245         public
246         payable
247         validEth        
248         validPeriod     
249         validQuantity   
250         validStatue     
251     {
252         uint eth = msg.value;
253 
254         uint quantity = eth * price / 10 ** 10;
255 
256         uint leftQuantity = safeSub(valueSale, saleQuantity);
257         if (quantity > leftQuantity) {
258             quantity = leftQuantity;
259         }
260 
261         saleQuantity = safeAdd(saleQuantity, quantity);
262         ethQuantity = safeAdd(ethQuantity, eth);
263 
264         require(transferInner(msg.sender, quantity));
265 
266         Buy(msg.sender, eth, quantity);
267 
268     }
269 
270     function stopSale()
271         public
272         onlyOwner
273         returns (bool)
274     {
275         assert(!saleStopped);
276         saleStopped = true;
277         StopSale();
278         return true;
279     }
280 
281     function getPeriod()
282         public
283         constant
284         returns (uint)
285     {
286         if (saleStopped) {
287             return FINISHED;
288         }
289 
290         if (now < openTime) {
291             return BEFORE_SALE;
292         }
293 
294         if (valueSale == saleQuantity) {
295             return FINISHED;
296         }
297 
298         if (now >= openTime && now < closeTime) {
299             return IN_SALE;
300         }
301 
302         return FINISHED;
303     }
304 
305 
306     function withdraw(uint amount)
307         public
308         onlyOwner
309     {
310         uint period = getPeriod();
311         require(period == FINISHED);
312 
313         require(this.balance >= amount);
314         msg.sender.transfer(amount);
315     }
316 
317     function withdrawToken(uint amount)
318         public
319         onlyOwner
320     {
321         uint period = getPeriod();
322         require(period == FINISHED);
323 
324         withdrawQuantity += safeAdd(withdrawQuantity, amount);
325         require(transferInner(msg.sender, amount));
326     }
327 
328 
329 
330     event Transfer(address indexed _from, address indexed _to, uint _value);
331     event Approval(address indexed _owner, address indexed _spender, uint _value);
332     event Buy(address indexed sender, uint eth, uint token);
333     event StopSale();
334 }