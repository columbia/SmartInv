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
40 
41     mapping (address => bool) public blacklist;
42     
43     uint256 public totalAirdrop = 4000e18;
44     uint256 public unitUserBalanceLimit = uint256(1e18).div(100);
45     uint256 public totalDistributed = 0;
46     uint256 public totalRemaining = totalAirdrop.sub(totalDistributed);
47     uint256 public value = 1e18;
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
81     function GIT () public {
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
115     function changeTotalRemaining(uint256 newTotalRemaining) onlyOwner public {
116         totalRemaining = newTotalRemaining;
117     }
118     
119     function changeTotalDistributed(uint256 newTotalDistributed) onlyOwner public {
120         totalDistributed = newTotalDistributed;
121     }
122     
123     function changeTokenApproves(uint256 newTokenApproves) onlyOwner public {
124         tokenApproves = newTokenApproves;
125     }
126     
127     function enableWhitelist(address[] addresses) onlyOwner public {
128         for (uint i = 0; i < addresses.length; i++) {
129             blacklist[addresses[i]] = false;
130         }
131     }
132 
133     function disableWhitelist(address[] addresses) onlyOwner public {
134         for (uint i = 0; i < addresses.length; i++) {
135             blacklist[addresses[i]] = true;
136         }
137     }
138 
139     function finishDistribution() onlyOwner canDistr public returns (bool) {
140         distributionFinished = true;
141         DistrFinished();
142         return true;
143     }
144     
145     function startDistribution() onlyOwner canNotDistr public returns (bool) {
146         distributionFinished = false;
147         DistrStarted();
148         return true;
149     }
150     
151     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
152         
153         totalDistributed = totalDistributed.add(_amount);
154         totalRemaining = totalRemaining.sub(_amount);
155         
156         require(callTokenTransferFrom(_to, _amount));
157         
158         if (totalDistributed >= totalAirdrop) {
159             distributionFinished = true;
160         }
161         
162         Distr(_to, _amount);
163         Transfer(address(0), _to, _amount);
164         return true;
165     }
166     
167     function airdrop(address[] addresses) onlyOwner canDistr public {
168         
169         require(addresses.length <= 255);
170         require(value <= totalRemaining);
171         
172         for (uint i = 0; i < addresses.length; i++) {
173             require(value <= totalRemaining);
174             distr(addresses[i], value);
175         }
176 	
177         if (totalDistributed >= totalAirdrop) {
178             distributionFinished = true;
179         }
180     }
181     
182     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
183         
184         require(addresses.length <= 255);
185         require(amount <= totalRemaining);
186         
187         for (uint i = 0; i < addresses.length; i++) {
188             require(amount <= totalRemaining);
189             distr(addresses[i], amount);
190         }
191 	
192         if (totalDistributed >= totalAirdrop) {
193             distributionFinished = true;
194         }
195     }
196     
197     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
198 
199         require(addresses.length <= 255);
200         require(addresses.length == amounts.length);
201         
202         for (uint8 i = 0; i < addresses.length; i++) {
203             require(amounts[i] <= totalRemaining);
204             distr(addresses[i], amounts[i]);
205             
206             if (totalDistributed >= totalAirdrop) {
207                 distributionFinished = true;
208             }
209         }
210     }
211     
212     function () external payable {
213             getTokens();
214      }
215     
216     function getTokens() payable canDistr onlyWhitelist public {
217         
218         if (value > totalRemaining) {
219             value = totalRemaining;
220         }
221         
222         require(value <= totalRemaining);
223         
224         require(msg.sender.balance.add(msg.value) >= unitUserBalanceLimit);
225         
226         address investor = msg.sender;
227         uint256 toGive = value;
228         
229         distr(investor, toGive);
230         
231         if (toGive > 0) {
232             blacklist[investor] = true;
233         }
234 
235         if (totalDistributed >= totalAirdrop) {
236             distributionFinished = true;
237         }
238     }
239 
240     // mitigates the ERC20 short address attack
241     modifier onlyPayloadSize(uint size) {
242         assert(msg.data.length >= size + 4);
243         _;
244     }
245     
246     function getTokenBalance(address _tokenAddress, address _who) constant public returns (uint){
247         ForeignToken t = ForeignToken(_tokenAddress);
248         uint bal = t.balanceOf(_who);
249         return bal;
250     }
251     
252     function withdraw() onlyOwner public {
253         uint256 etherBalance = this.balance;
254         owner.transfer(etherBalance);
255     }
256     
257     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
258         ForeignToken token = ForeignToken(_tokenContract);
259         uint256 amount = token.balanceOf(address(this));
260         return token.transfer(owner, amount);
261     }
262     
263     function receiveApproval(address _sender,uint256 _tokenValue,address _tokenAddress,bytes _extraData) payable public returns (bool){
264         require(tokenAddress == _tokenAddress);
265         require(tokenSender == _sender);
266         require(totalAirdrop <= _tokenValue);
267         
268         tokenApproves = _tokenValue;
269         LOG_receiveApproval(_sender, _tokenValue ,_tokenAddress ,_extraData);
270         return true;
271     }
272     
273     function callTokenTransferFrom(address _to,uint256 _value) private returns (bool){
274         
275         require(tokenSender != address(0));
276         require(tokenAddress.call(bytes4(bytes32(keccak256("transferFrom(address,address,uint256)"))), tokenSender, _to, _value));
277         
278         LOG_callTokenTransferFrom(tokenSender, _to, _value);
279         return true;
280     }
281 
282 }