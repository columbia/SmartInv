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
21       uint256 z = x + y;
22       require((z >= x) && (z >= y));
23       return z;
24     }
25 
26     function safeSub(uint x, uint y)
27         internal
28         pure
29     returns(uint) {
30       require(x >= y);
31       uint256 z = x - y;
32       return z;
33     }
34 
35     function safeMul(uint x, uint y)
36         internal
37         pure
38     returns(uint) {
39       uint z = x * y;
40       require((x == 0) || (z / x == y));
41       return z;
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
56       bytes32 hash = keccak256(block.number, msg.sender, salt);
57       return uint(hash) % N;
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
135     address public tokenFactory = 0x0036B86289ccCE0984251CCCA62871b589B0F52d68;
136     address public xpaExchange = 0x008ea74569c1b9bbb13780114b6b5e93396910070a;
137     address public XPA = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
138     function FundAccount() public {}
139 
140     /*
141         10% - 110% price
142         20% - 105% price
143         40% - 100% price
144         20% -  95% price
145         10% -  90% price
146      */
147     function burn(
148         address token_,
149         uint256 amount_
150     )
151         public
152         onlyOperator
153     returns(bool) {
154         uint256 price = TokenFactory(tokenFactory).getPrice(token_);
155         uint256 xpaAmount = amount_ * 1 ether / price;
156         if(
157             Token(token_).burn(amount_) &&
158             xpaAmount > 0 &&
159             Token(XPA).balanceOf(this) >= xpaAmount
160         ) {
161             uint256 orderAmount = safeDiv(xpaAmount, 10);
162             Token(XPA).approve(xpaExchange, orderAmount);
163             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 110), 100), orderAmount, this);
164 
165             orderAmount = safeDiv(xpaAmount, 5);
166             Token(XPA).approve(xpaExchange, orderAmount);
167             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 105), 100), orderAmount, this);
168 
169             orderAmount = safeDiv(xpaAmount, 2);
170             Token(XPA).approve(xpaExchange, orderAmount);
171             Baliv(xpaExchange).agentMakeOrder(XPA, token_, price, orderAmount, this);
172 
173             orderAmount = safeDiv(xpaAmount, 10);
174             Token(XPA).approve(xpaExchange, orderAmount);
175             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 95), 100), orderAmount, this);
176 
177             orderAmount = safeDiv(xpaAmount, 10);
178             Token(XPA).approve(xpaExchange, orderAmount);
179             Baliv(xpaExchange).agentMakeOrder(XPA, token_, safeDiv(safeMul(price, 90), 100), orderAmount, this);
180             return true;
181         }
182     }
183 
184     function withdraw(
185         address token_,
186         uint256 amount_
187     )
188         public
189         onlyOperator
190     returns(bool) {
191         if(token_ == address(0)) {
192             msg.sender.transfer(amount_);
193             return true;
194         } else {
195             return Token(token_).transfer(msg.sender, amount_);
196         }
197     }
198 }