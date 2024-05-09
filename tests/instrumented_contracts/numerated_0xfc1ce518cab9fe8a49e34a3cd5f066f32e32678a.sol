1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns (uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 // ERC20代币
23 contract Token {
24     function totalSupply() public constant returns (uint256 supply);
25 
26     function balanceOf(address _owner) public constant returns (uint256 balance);
27 
28     function transfer(address _to, uint256 _value) public returns (bool success);
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31 
32     function approve(address _spender, uint256 _value) public returns (bool success);
33 
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37 
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     uint public decimals;
41     string public symbol;
42     string public name;
43 }
44 
45 contract EKTSale is SafeMath {
46     Token public token;
47     address public owner;
48     bool public stopped;
49 
50     // 阶段
51     uint private constant BEFORE_SALE = 0;
52     uint private constant IN_SALE = 1;
53     uint private constant FINISHED = 2;
54 
55     // ICO总代币数量
56     uint public totalQuantity =  1.5 * 10000 * 10000 * 100000000;
57 
58     // 已卖出代币数量
59     uint public saleQuantity = 0;
60 
61     // 收入的ETH数量
62     uint public ethQuantity = 0;
63 
64     // 提现的代币数量
65     uint public withdrawQuantity = 0;
66 
67     // ICO最小以太值
68     uint public minEth = 0.1 ether;
69 
70     // ICO最大以太值
71     uint public maxEth = 1000 ether;
72 
73     // 开始时间 2017-12-24 19:00:00
74     uint public openTime = 1514113200;
75     // 结束时间 2018-01-05 19:00:00
76     uint public closeTime = 1515150000;
77     // 价格
78     uint public price = 5696;
79 
80     modifier isOwner {
81         assert(owner == msg.sender);
82         _;
83     }
84 
85     modifier validAddress(address _address) {
86         assert(0x0 != _address);
87         _;
88     }
89 
90     modifier validPeriod {
91         assert(now >= openTime && now < closeTime);
92         _;
93     }
94 
95     modifier validQuantity {
96         assert(totalQuantity >= saleQuantity);
97         _;
98     }
99 
100     modifier validEth {
101         assert(msg.value >= minEth && msg.value <= maxEth);
102         _;
103     }
104 
105     event Buy(address indexed sender, uint eth, uint token);
106     event SaleStop();
107 
108     function EKTSale(address _token)
109         public
110         validAddress(_token)
111     {
112         owner = msg.sender;
113         token = Token(_token);
114     }
115 
116 
117     function setPrice(uint _price)
118         public
119         isOwner
120         returns(bool)
121     {
122         assert(_price > 0);
123         price = _price;
124         return true;
125     }
126 
127     function ()
128         public
129         payable
130     {
131         buy();
132     }
133 
134     function buy()
135         public
136         payable
137         validAddress(token)      // 代币是否已设置
138         validEth        // 以太是否足够
139         validPeriod     // 是否在ICO期间
140         validQuantity   // 代币是否已卖完
141     {
142         uint eth = msg.value;
143 
144         // 计算代币数量
145         uint quantity = eth * price / 10 ** 10;
146 
147         // 是否超出剩余代币
148         uint leftQuantity = safeSub(totalQuantity, saleQuantity);
149         if (quantity > leftQuantity) {
150             quantity = leftQuantity;
151         }
152 
153         saleQuantity = safeAdd(saleQuantity, quantity);
154         ethQuantity = safeAdd(ethQuantity, eth);
155 
156         // 发送代币
157         require(token.transfer(msg.sender, quantity));
158 
159         // 生成日志
160         Buy(msg.sender, eth, quantity);
161     }
162 
163     function withdraw(uint amount)
164         public
165         isOwner
166     {
167         uint period = getPeriod();
168         require(period == FINISHED);
169 
170         require(this.balance >= amount);
171         msg.sender.transfer(amount);
172     }
173 
174     function withdrawToken(uint amount)
175         public
176         isOwner
177     {
178         uint period = getPeriod();
179         require(period == FINISHED);
180 
181         withdrawQuantity += safeAdd(withdrawQuantity, amount);
182         require(token.transfer(msg.sender, amount));
183     }
184 
185     function getPeriod()
186         public
187         constant
188         returns (uint)
189     {
190         if (stopped) {
191             return FINISHED;
192         }
193 
194         if (now < openTime) {
195             return BEFORE_SALE;
196         }
197 
198         if (totalQuantity == saleQuantity) {
199             return FINISHED;
200         }
201 
202         if (now >= openTime && now < closeTime) {
203             return IN_SALE;
204         }
205 
206         return FINISHED;
207     }
208 
209     function stopSale()
210         public
211         isOwner
212         returns (bool)
213     {
214         stopped = true;
215         SaleStop();
216         return true;
217     }
218 
219 
220 }