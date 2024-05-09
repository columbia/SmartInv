1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract GIT {
33     
34     using SafeMath for uint256;
35     address public owner;
36     address public tokenAddress;
37     address public tokenSender;
38     uint256 public tokenApproves;
39 
40     mapping (address => uint256) balances;
41 
42     uint256 public totalExchange = 200000e18;
43     uint256 public totalDistributed = 0;
44     uint256 public totalRemaining = totalExchange.sub(totalDistributed);
45 
46     uint256 constant public unitEthWei = 1e18;
47     uint256 public unitsOneEthCanBuy = 250e18;
48     uint256 public unitsUserCanBuyLimitEth = 4e18;
49     uint256 public unitsUserCanBuyLimit = (unitsUserCanBuyLimitEth.div(unitEthWei)).mul(unitsOneEthCanBuy);
50 
51     event ExchangeFinished();
52     event ExchangeStarted();
53     
54     
55     event LOG_receiveApproval(address _sender,uint256 _tokenValue,address _tokenAddress,bytes _extraData);
56     event LOG_callTokenTransferFrom(address tokenSender,address _to,uint256 _value);
57     event LOG_exchange(address _to, uint256 amount);
58     
59     bool public exchangeFinished = false;
60     
61     modifier canExchange() {
62         require(!exchangeFinished);
63         _;
64     }
65     
66     modifier canNotExchange() {
67         require(exchangeFinished);
68         _;
69     }
70     
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75     
76     function GIT () public {
77         owner = msg.sender;
78     }
79     
80     function transferOwnership(address newOwner) onlyOwner public {
81         if (newOwner != address(0)) {
82             owner = newOwner;
83         }
84     }
85     
86     function changeTokenAddress(address newTokenAddress) onlyOwner public {
87         if (newTokenAddress != address(0)) {
88             tokenAddress = newTokenAddress;
89         }
90     }
91     
92     function changeTokenSender(address newTokenSender) onlyOwner public {
93         if (newTokenSender != address(0)) {
94             tokenSender = newTokenSender;
95         }
96     }
97     
98     function changeUnitsOneEthCanBuy(uint256 newUnitsOneEthCanBuy) onlyOwner public {
99         unitsOneEthCanBuy = newUnitsOneEthCanBuy;
100     }
101     
102     function changeUnitsUserCanBuyLimitEth(uint256 newUnitsUserCanBuyLimitEth) onlyOwner public {
103         unitsUserCanBuyLimitEth = newUnitsUserCanBuyLimitEth;
104     }
105     
106     function changeTotalExchange(uint256 newTotalExchange) onlyOwner public {
107         totalExchange = newTotalExchange;
108     }
109     
110     function changeTokenApproves(uint256 newTokenApproves) onlyOwner public {
111         tokenApproves = newTokenApproves;
112     }
113     
114     function changeTotalDistributed(uint256 newTotalDistributed) onlyOwner public {
115         totalDistributed = newTotalDistributed;
116     }
117     
118     function changeTotalRemaining(uint256 newTotalRemaining) onlyOwner public {
119         totalRemaining = newTotalRemaining;
120     }
121     
122     function changeUnitsUserCanBuyLimit(uint256 newUnitsUserCanBuyLimit) onlyOwner public {
123         unitsUserCanBuyLimit = newUnitsUserCanBuyLimit;
124     }
125     
126     function finishExchange() onlyOwner canExchange public returns (bool) {
127         exchangeFinished = true;
128         ExchangeFinished();
129         return true;
130     }
131     
132     function startExchange() onlyOwner canNotExchange public returns (bool) {
133         exchangeFinished = false;
134         ExchangeStarted();
135         return true;
136     }
137     
138     function () external payable {
139             exchangeTokens();
140      }
141     
142     function exchangeTokens() payable canExchange public {
143         
144         require(exchange());
145 
146         if (totalDistributed >= totalExchange) {
147             exchangeFinished = true;
148         }
149         
150     }
151     
152     function getTokenBalance(address _tokenAddress, address _who) constant public returns (uint256){
153         ForeignToken t = ForeignToken(_tokenAddress);
154         uint bal = t.balanceOf(_who);
155         return bal;
156     }
157     
158     function withdraw() onlyOwner public {
159         uint256 etherBalance = this.balance;
160         owner.transfer(etherBalance);
161     }
162     
163     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
164         ForeignToken token = ForeignToken(_tokenContract);
165         uint256 amount = token.balanceOf(address(this));
166         return token.transfer(owner, amount);
167     }
168     
169     function receiveApproval(address _sender,uint256 _tokenValue,address _tokenAddress,bytes _extraData) public returns (bool){
170         require(tokenAddress == _tokenAddress);
171         require(tokenSender == _sender);
172         require(totalExchange <= _tokenValue);
173         
174         tokenApproves = _tokenValue;
175         LOG_receiveApproval(_sender, _tokenValue ,_tokenAddress ,_extraData);
176         return true;
177     }
178     
179     function callTokenTransferFrom(address _to,uint256 _value) private returns (bool){
180         
181         require(tokenSender != address(0));
182         require(tokenAddress.call(bytes4(bytes32(keccak256("transferFrom(address,address,uint256)"))), tokenSender, _to, _value));
183         
184         LOG_callTokenTransferFrom(tokenSender, _to, _value);
185         return true;
186     }
187     
188     function exchange() payable canExchange public returns (bool) {
189         
190         uint256 amount = 0;
191         if(msg.value == 0){
192             return false;
193         }
194         
195         address _to = msg.sender;
196         
197         amount = msg.value.mul(unitsOneEthCanBuy.div(unitEthWei));
198         require(amount.add(balances[msg.sender]) <= unitsUserCanBuyLimit);
199         
200         totalDistributed = totalDistributed.add(amount);
201         totalRemaining = totalRemaining.sub(amount);
202         
203         require(callTokenTransferFrom(_to, amount));
204         
205         balances[msg.sender] = amount.add(balances[msg.sender]);
206         
207         if (totalDistributed >= totalExchange) {
208             exchangeFinished = true;
209         }
210         
211         LOG_exchange(_to, amount);
212         return true;
213     }
214 
215 }