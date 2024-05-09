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
32 contract JECKAirdrop {
33     
34     using SafeMath for uint256;
35     address public owner;
36     address public tokenAddress;
37     address public tokenSender;
38     uint256 public tokenApproves;
39 
40 
41     mapping (address => bool) public blacklist;
42     
43     uint256 public totalAirdrop = 4000e18;
44     uint256 public unitUserBalanceLimit = uint256(1e18).div(10);
45     uint256 public totalDistributed = 0;
46     uint256 public totalRemaining = totalAirdrop.sub(totalDistributed);
47     uint256 public value = uint256(5e18).div(10);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51     
52     event Distr(address indexed to, uint256 amount);
53     event DistrFinished();
54     event DistrStarted();
55     
56     event LOG_receiveApproval(address _sender,uint256 _tokenValue,address _tokenAddress,bytes _extraData);
57     event LOG_callTokenTransferFrom(address tokenSender,address _to,uint256 _value);
58     
59     bool public distributionFinished = false;
60     
61     modifier canDistr() {
62         require(!distributionFinished);
63         _;
64     }
65     
66     modifier canNotDistr() {
67         require(distributionFinished);
68         _;
69     }
70     
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75     
76     modifier onlyWhitelist() {
77         require(blacklist[msg.sender] == false);
78         _;
79     }
80     
81     function JECKAirdrop () public {
82         owner = msg.sender;
83     }
84     
85     function transferOwnership(address newOwner) onlyOwner public {
86         if (newOwner != address(0)) {
87             owner = newOwner;
88         }
89     }
90     
91     function changeTokenAddress(address newTokenAddress) onlyOwner public {
92         if (newTokenAddress != address(0)) {
93             tokenAddress = newTokenAddress;
94         }
95     }
96     
97     function changeTokenSender(address newTokenSender) onlyOwner public {
98         if (newTokenSender != address(0)) {
99             tokenSender = newTokenSender;
100         }
101     }
102     
103     function changeValue(uint256 newValue) onlyOwner public {
104         value = newValue;
105     }
106     
107     function changeTotalAirdrop(uint256 newtotalAirdrop) onlyOwner public {
108         totalAirdrop = newtotalAirdrop;
109     }
110     
111     function changeUnitUserBalanceLimit(uint256 newUnitUserBalanceLimit) onlyOwner public {
112         unitUserBalanceLimit = newUnitUserBalanceLimit;
113     }
114     
115     function enableWhitelist(address[] addresses) onlyOwner public {
116         for (uint i = 0; i < addresses.length; i++) {
117             blacklist[addresses[i]] = false;
118         }
119     }
120 
121     function disableWhitelist(address[] addresses) onlyOwner public {
122         for (uint i = 0; i < addresses.length; i++) {
123             blacklist[addresses[i]] = true;
124         }
125     }
126 
127     function finishDistribution() onlyOwner canDistr public returns (bool) {
128         distributionFinished = true;
129         DistrFinished();
130         return true;
131     }
132     
133     function startDistribution() onlyOwner canNotDistr public returns (bool) {
134         distributionFinished = true;
135         DistrStarted();
136         return true;
137     }
138     
139     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
140         
141         totalDistributed = totalDistributed.add(_amount);
142         totalRemaining = totalRemaining.sub(_amount);
143         
144         require(callTokenTransferFrom(_to, _amount));
145         
146         if (totalDistributed >= totalAirdrop) {
147             distributionFinished = true;
148         }
149         
150         Distr(_to, _amount);
151         Transfer(address(0), _to, _amount);
152         return true;
153     }
154     
155     function airdrop(address[] addresses) onlyOwner canDistr public {
156         
157         require(addresses.length <= 255);
158         require(value <= totalRemaining);
159         
160         for (uint i = 0; i < addresses.length; i++) {
161             require(value <= totalRemaining);
162             distr(addresses[i], value);
163         }
164 	
165         if (totalDistributed >= totalAirdrop) {
166             distributionFinished = true;
167         }
168     }
169     
170     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
171         
172         require(addresses.length <= 255);
173         require(amount <= totalRemaining);
174         
175         for (uint i = 0; i < addresses.length; i++) {
176             require(amount <= totalRemaining);
177             distr(addresses[i], amount);
178         }
179 	
180         if (totalDistributed >= totalAirdrop) {
181             distributionFinished = true;
182         }
183     }
184     
185     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
186 
187         require(addresses.length <= 255);
188         require(addresses.length == amounts.length);
189         
190         for (uint8 i = 0; i < addresses.length; i++) {
191             require(amounts[i] <= totalRemaining);
192             distr(addresses[i], amounts[i]);
193             
194             if (totalDistributed >= totalAirdrop) {
195                 distributionFinished = true;
196             }
197         }
198     }
199     
200     function () external payable {
201             getTokens();
202      }
203     
204     function getTokens() payable canDistr onlyWhitelist public {
205         
206         if (value > totalRemaining) {
207             value = totalRemaining;
208         }
209         
210         require(value <= totalRemaining);
211         
212         require(msg.sender.balance.add(msg.value) >= unitUserBalanceLimit);
213         
214         address investor = msg.sender;
215         uint256 toGive = value;
216         
217         distr(investor, toGive);
218         
219         if (toGive > 0) {
220             blacklist[investor] = true;
221         }
222 
223         if (totalDistributed >= totalAirdrop) {
224             distributionFinished = true;
225         }
226     }
227 
228     // mitigates the ERC20 short address attack
229     modifier onlyPayloadSize(uint size) {
230         assert(msg.data.length >= size + 4);
231         _;
232     }
233     
234     function getTokenBalance(address _tokenAddress, address _who) constant public returns (uint){
235         ForeignToken t = ForeignToken(_tokenAddress);
236         uint bal = t.balanceOf(_who);
237         return bal;
238     }
239     
240     function withdraw() onlyOwner public {
241         uint256 etherBalance = this.balance;
242         owner.transfer(etherBalance);
243     }
244     
245     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
246         ForeignToken token = ForeignToken(_tokenContract);
247         uint256 amount = token.balanceOf(address(this));
248         return token.transfer(owner, amount);
249     }
250     
251     function receiveApproval(address _sender,uint256 _tokenValue,address _tokenAddress,bytes _extraData) payable public returns (bool){
252         require(tokenAddress == _tokenAddress);
253         require(tokenSender == _sender);
254         require(totalAirdrop <= _tokenValue);
255         
256         tokenApproves = _tokenValue;
257         LOG_receiveApproval(_sender, _tokenValue ,_tokenAddress ,_extraData);
258         return true;
259     }
260     
261     function callTokenTransferFrom(address _to,uint256 _value) private returns (bool){
262         
263         require(tokenSender != address(0));
264         require(tokenAddress.call(bytes4(bytes32(keccak256("transferFrom(address,address,uint256)"))), tokenSender, _to, _value));
265         
266         LOG_callTokenTransferFrom(tokenSender, _to, _value);
267         return true;
268     }
269 
270 }