1 pragma solidity ^0.4.21;
2 
3 contract StandardToken {
4 
5     event Transfer(address indexed from, address indexed to, uint256 value);
6     event Approval(address indexed owner, address indexed spender, uint256 value);
7     event Issuance(address indexed to, uint256 value);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success) {
10         require(balances[msg.sender] >= _value);
11         balances[msg.sender] -= _value;
12         balances[_to] += _value;
13         emit Transfer(msg.sender, _to, _value);
14         return true;
15     }
16 
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
18         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
19         balances[_to] += _value;
20         balances[_from] -= _value;
21         allowed[_from][msg.sender] -= _value;
22         emit Transfer(_from, _to, _value);
23         return true;
24     }
25 
26     function balanceOf(address _owner) constant public returns (uint256 balance) {
27         return balances[_owner];
28     }
29 
30     function approve(address _spender, uint256 _value) public returns (bool success) {
31         allowed[msg.sender][_spender] = _value;
32         emit Approval(msg.sender, _spender, _value);
33         return true;
34     }
35 
36     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
37       return allowed[_owner][_spender];
38     }
39 
40     mapping (address => uint256) balances;
41     mapping (address => mapping (address => uint256)) allowed;
42 
43     uint public totalSupply;
44 }
45 
46 contract MintableToken is StandardToken {
47     address public owner;
48 
49     bool public isMinted = false;
50 
51     function mint(address _to) public {
52         assert(msg.sender == owner && !isMinted);
53 
54         balances[_to] = totalSupply;
55         isMinted = true;
56     }
57 }
58 
59 contract SafeNetToken is MintableToken {
60     string public name = 'SafeNet Token';
61     string public symbol = 'SNT';
62     uint8 public decimals = 18;
63 
64     function SafeNetToken(uint _totalSupply) public {
65         owner = msg.sender;
66         totalSupply = _totalSupply;
67     }
68 }
69 
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     if (a == 0) {
77       return 0;
78     }
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 contract Treaties {
113     using SafeMath for uint;
114 
115     SafeNetToken public token; 
116 
117     address public creator;
118     bool public creatorInited = false;
119 
120     address public wallet;
121 
122     uint public walletPercentage = 100;
123 
124     address[] public owners;
125     address[] public teams;
126     address[] public investors;
127 
128     mapping (address => bool) public inList;
129 
130     uint public tokensInUse = 0;
131 
132     mapping (address => uint) public refunds;
133 
134     struct Request {
135         uint8 rType; // 0 - owner, 1 - team, 2 - investor(eth), 3 - investor(fiat), 4 - new percentage
136         address beneficiary;
137         string treatyHash;
138         uint tokensAmount;
139         uint ethAmount;
140         uint percentage;
141 
142         uint8 isConfirmed; // 0 - pending, 1 - declined, 2 - accepted
143         address[] ownersConfirm;
144     }
145 
146     Request[] public requests;
147 
148     modifier onlyOwner() {
149         for (uint i = 0; i < owners.length; i++) {
150             if (owners[i] == msg.sender) {
151                 _;
152             }
153         }
154     }   
155 
156     event NewRequest(uint8 rType, address beneficiary, string treatyHash, uint tokensAmount, uint ethAmount, uint percentage, uint id);
157     event RequestConfirmed(uint id);
158     event RequestDeclined(uint id);
159     event RefundsCalculated();
160 
161     function Treaties(address _wallet, SafeNetToken _token) public {
162         creator = msg.sender;
163         token = _token;
164         wallet = _wallet;
165     }
166 
167     function() external payable {
168         splitProfit(msg.value);
169     }
170 
171     // after mint
172     function initCreator(uint _tokensAmount) public {
173         assert(msg.sender == creator && !creatorInited);
174 
175         owners.push(creator);
176         assert(token.transfer(creator, _tokensAmount));
177         tokensInUse += _tokensAmount;
178         inList[creator] = true;
179         creatorInited = true;
180     }
181 
182 
183     function createTreatyRequest(uint8 _rType, string _treatyHash, uint _tokensAmount) public {
184         require(_rType <= 1);
185 
186         requests.push(Request({
187             rType: _rType,
188             beneficiary: msg.sender,
189             treatyHash: _treatyHash,
190             tokensAmount: _tokensAmount,
191             ethAmount: 0,
192             percentage: 0,
193             isConfirmed: 0,
194             ownersConfirm: new address[](0)
195             }));
196 
197         emit NewRequest(_rType, msg.sender, _treatyHash, _tokensAmount, 0, 0, requests.length - 1);
198     }
199 
200     function createEthInvestorRequest(uint _tokensAmount) public payable {
201         assert(msg.value > 0);
202 
203         requests.push(Request({
204             rType: 2,
205             beneficiary: msg.sender,
206             treatyHash: '',
207             tokensAmount: _tokensAmount,
208             ethAmount: msg.value,
209             percentage: 0,
210             isConfirmed: 0,
211             ownersConfirm: new address[](0)
212             }));
213 
214         emit NewRequest(2, msg.sender, "", _tokensAmount, msg.value, 0, requests.length - 1);
215     }
216 
217     function removeEthInvestorRequest(uint id) public {
218         require(id < requests.length);
219         assert(requests[id].isConfirmed == 0 && requests[id].rType == 2);
220         assert(requests[id].beneficiary == msg.sender);
221 
222         requests[id].isConfirmed = 1;
223         assert(msg.sender.send(requests[id].ethAmount));
224         emit RequestDeclined(id);
225     }
226 
227     function createFiatInvestorRequest(uint _tokensAmount) public {
228         requests.push(Request({
229             rType: 3,
230             beneficiary: msg.sender,
231             treatyHash: '',
232             tokensAmount: _tokensAmount,
233             ethAmount: 0,
234             percentage: 0,
235             isConfirmed: 0,
236             ownersConfirm: new address[](0)
237             }));
238 
239         emit NewRequest(3, msg.sender, "", _tokensAmount, 0, 0, requests.length - 1);
240     }
241 
242     function createPercentageRequest(uint _percentage) public onlyOwner {
243         require(_percentage <= 100);
244 
245         requests.push(Request({
246             rType: 4,
247             beneficiary: msg.sender,
248             treatyHash: '',
249             tokensAmount: 0,
250             ethAmount: 0,
251             percentage: _percentage,
252             isConfirmed: 0,
253             ownersConfirm: new address[](0)
254             }));
255 
256         emit NewRequest(4, msg.sender, "", 0, 0, _percentage, requests.length - 1);
257     }
258 
259 
260     function confirmRequest(uint id) public onlyOwner {
261         require(id < requests.length);
262         assert(requests[id].isConfirmed == 0);
263 
264         uint tokensConfirmed = 0;
265         for (uint i = 0; i < requests[id].ownersConfirm.length; i++) {
266             assert(requests[id].ownersConfirm[i] != msg.sender);
267             tokensConfirmed += token.balanceOf(requests[id].ownersConfirm[i]);
268         }
269 
270         requests[id].ownersConfirm.push(msg.sender);
271         tokensConfirmed += token.balanceOf(msg.sender);
272 
273         uint tokensInOwners = 0;
274         for (i = 0; i < owners.length; i++) {
275             tokensInOwners += token.balanceOf(owners[i]);
276         }
277 
278         if (tokensConfirmed > tokensInOwners / 2) {
279             if (requests[id].rType == 4) {
280                 walletPercentage = requests[id].percentage;
281 
282             } else {
283                 if (!inList[requests[id].beneficiary]) {
284                     if (requests[id].rType == 0) {
285                         owners.push(requests[id].beneficiary);
286                         token.transfer(creator, requests[id].tokensAmount / 10);
287                     }
288                     if (requests[id].rType == 1) {
289                         teams.push(requests[id].beneficiary);
290                     }
291                     if (requests[id].rType == 2 || requests[id].rType == 3) {
292                         investors.push(requests[id].beneficiary);
293                     }
294                     inList[requests[id].beneficiary] = true;
295                 }
296 
297                 if (requests[id].rType == 2) {
298                     assert(wallet.send(requests[id].ethAmount));
299                 }
300 
301                 token.transfer(requests[id].beneficiary, requests[id].tokensAmount);
302                 tokensInUse += requests[id].tokensAmount;
303             }
304 
305             requests[id].isConfirmed = 2;
306             emit RequestConfirmed(id);
307         }
308     }
309 
310     function rejectRequest(uint id) public onlyOwner {
311         require(id < requests.length);
312         assert(requests[id].isConfirmed == 0);
313 
314         for (uint i = 0; i < requests[id].ownersConfirm.length; i++) {
315             if (requests[id].ownersConfirm[i] == msg.sender) {
316                 requests[id].ownersConfirm[i] = requests[id].ownersConfirm[requests[id].ownersConfirm.length - 1];
317                 requests[id].ownersConfirm.length--;
318                 break;
319             }
320         }
321     }
322 
323 
324     function splitProfit(uint profit) internal {
325         uint rest = profit;
326         uint refund;
327         address addr;
328         for (uint i = 0; i < owners.length; i++) {
329             addr = owners[i];
330             refund = profit.mul(token.balanceOf(addr)).mul(100 - walletPercentage).div(100).div(tokensInUse);
331             refunds[addr] += refund;
332             rest -= refund;
333         }
334         for (i = 0; i < teams.length; i++) {
335             addr = teams[i];
336             refund = profit.mul(token.balanceOf(addr)).mul(100 - walletPercentage).div(100).div(tokensInUse);
337             refunds[addr] += refund;
338             rest -= refund;
339         }
340         for (i = 0; i < investors.length; i++) {
341             addr = investors[i];
342             refund = profit.mul(token.balanceOf(addr)).mul(100 - walletPercentage).div(100).div(tokensInUse);
343             refunds[addr] += refund;
344             rest -= refund;
345         }
346 
347         assert(wallet.send(rest));
348         emit RefundsCalculated();
349     }
350 
351     function withdrawRefunds() public {
352         assert(refunds[msg.sender] > 0);
353         uint refund = refunds[msg.sender];
354         refunds[msg.sender] = 0;
355         assert(msg.sender.send(refund));
356     }
357 }