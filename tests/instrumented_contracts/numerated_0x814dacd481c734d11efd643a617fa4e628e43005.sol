1 pragma solidity ^0.4.21;
2 
3 interface Token {
4     function totalSupply() constant external returns (uint256 ts);
5     function balanceOf(address _owner) constant external returns (uint256 balance);
6     function transfer(address _to, uint256 _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
10     function burn(uint256 amount) external returns (bool success);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract SafeMath {
17     function safeAdd(uint x, uint y)
18         internal
19         pure
20     returns(uint) {
21         uint256 z = x + y;
22         require((z >= x) && (z >= y));
23         return z;
24     }
25 
26     function safeSub(uint x, uint y)
27         internal
28         pure
29     returns(uint) {
30         require(x >= y);
31         uint256 z = x - y;
32         return z;
33     }
34 
35     function safeMul(uint x, uint y)
36         internal
37         pure
38     returns(uint) {
39         uint z = x * y;
40         require((x == 0) || (z / x == y));
41         return z;
42     }
43     
44     function safeDiv(uint x, uint y)
45         internal
46         pure
47     returns(uint) {
48         require(y > 0);
49         return x / y;
50     }
51 
52     function random(uint N, uint salt)
53         internal
54         view
55     returns(uint) {
56         bytes32 hash = keccak256(block.number, msg.sender, salt);
57         return uint(hash) % N;
58     }
59 }
60 
61 interface Baliv {
62     function agentMakeOrder(address fromToken, address toToken, uint256 price, uint256 amount, address representor) external payable returns(bool);
63     function userTakeOrder(address fromToken, address toToken, uint256 price, uint256 amount, address representor) external payable returns(bool);
64     function getPrice(address fromToken_, address toToken_) external view returns(uint256);
65 }
66 
67 interface TokenFactory {
68     function getPrice(address token_) external view returns(uint256);
69 }
70 
71 contract Authorization {
72     mapping(address => bool) internal authbook;
73     address[] public operators;
74     address owner;
75 
76     function Authorization()
77         public
78     {
79         owner = msg.sender;
80         assignOperator(msg.sender);
81     }
82 
83     modifier onlyOwner
84     {
85         assert(msg.sender == owner);
86         _;
87     }
88     modifier onlyOperator
89     {
90         assert(checkOperator(msg.sender));
91         _;
92     }
93 
94     function transferOwnership(address newOwner_)
95         onlyOwner
96         public
97     {
98         owner = newOwner_;
99     }
100     
101     function assignOperator(address user_)
102         public
103         onlyOwner
104     {
105         if(user_ != address(0) && !authbook[user_]) {
106             authbook[user_] = true;
107             operators.push(user_);
108         }
109     }
110     
111     function dismissOperator(address user_)
112         public
113         onlyOwner
114     {
115         delete authbook[user_];
116         for(uint i = 0; i < operators.length; i++) {
117             if(operators[i] == user_) {
118                 operators[i] = operators[operators.length - 1];
119                 operators.length -= 1;
120             }
121         }
122     }
123     
124     function checkOperator(address user_)
125         public
126         view
127     returns(bool) {
128         return authbook[user_];
129     }
130 }
131 
132 contract FundAccount is Authorization, SafeMath {
133     string public version = "0.5.0";
134 
135     address public tokenFactory = 0x001393F1fb2E243Ee68Efe172eBb6831772633A926;
136     address public xpaExchange = 0x008ea74569c1b9bbb13780114b6b5e93396910070a;
137     address public XPA = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
138     
139     function FundAccount(
140         address XPAAddr, 
141         address balivAddr, 
142         address factoryAddr
143     ) public {
144         XPA = XPAAddr;
145         xpaExchange = balivAddr;
146         tokenFactory = factoryAddr;
147     }
148 
149     /*
150         10% - 110% price
151         20% - 105% price
152         40% - 100% price
153         20% -  95% price
154         10% -  90% price
155      */
156     function burn(
157         address token_,
158         uint256 amount_
159     )
160         public
161         onlyOperator
162     returns(bool) {
163         uint256 price = TokenFactory(tokenFactory).getPrice(token_);
164         uint256 xpaAmount = amount_ * 1 ether / price;
165         if(
166             Token(token_).burn(amount_) &&
167             xpaAmount > 0 &&
168             Token(XPA).balanceOf(this) >= xpaAmount
169         ) {
170             uint256 orderAmount = safeDiv(xpaAmount, 10);
171             Token(XPA).approve(xpaExchange, orderAmount);
172             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 110), 100), orderAmount, this);
173 
174             orderAmount = safeDiv(xpaAmount, 5);
175             Token(XPA).approve(xpaExchange, orderAmount);
176             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 105), 100), orderAmount, this);
177 
178             orderAmount = safeDiv(xpaAmount, 2);
179             Token(XPA).approve(xpaExchange, orderAmount);
180             Baliv(xpaExchange).agentMakeOrder(XPA, token_, price, orderAmount, this);
181 
182             orderAmount = safeDiv(xpaAmount, 10);
183             Token(XPA).approve(xpaExchange, orderAmount);
184             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 95), 100), orderAmount, this);
185 
186             orderAmount = safeDiv(xpaAmount, 10);
187             Token(XPA).approve(xpaExchange, orderAmount);
188             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 90), 100), orderAmount, this);
189             return true;
190         }
191     }
192 
193     function withdraw(
194         address token_,
195         uint256 amount_
196     )
197         public
198         onlyOperator
199     returns(bool) {
200         if(token_ == address(0)) {
201             msg.sender.transfer(amount_);
202             return true;
203         } else {
204             return Token(token_).transfer(msg.sender, amount_);
205         }
206     }
207 }