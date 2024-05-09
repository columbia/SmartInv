1 pragma solidity 0.5.7;
2 // ----------------------------------------------------------------------------
3 // 'FLT' 'FLAToken' token contract
4 //
5 // Symbol            : FLT
6 // Name              : FLAToken
7 // Total supply      : 75,000,00.000000000000000000
8 // Decimals          : 18
9 //
10 // The real cryptocurrency :D
11 //
12 // (c) FLAToken 2019. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20 
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25 
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         if(a == 0) {
28             return 0;
29         }
30         c = a * b;
31         require(c / a == b);
32     }
33 
34     function div(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 
39     function mod(uint a, uint b) internal pure returns (uint c) {
40         require(b != 0);
41         c = a % b;
42     }
43 }
44 
45 contract ERC20Interface {
46     function totalSupply() public view returns (uint);
47     function balanceOf(address tokenOwner) public view returns (uint balance);
48     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
59 }
60 
61 contract Owned {
62     address payable public owner;
63     address payable public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address payable _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79 
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82 
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 contract FLAToken is ERC20Interface, Owned {
90     using SafeMath for uint;
91 
92     string public symbol;
93     string public name;
94     string public version = 'FLT1.0';
95     uint8 public decimals;
96     uint public tokenSold;
97     uint _totalSupply;
98     uint _unitsOneEthCanBuy;
99     uint _bonusEachTarget;
100     uint _bonusAmount;
101     bool _salesOpen;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106     struct Topic {
107         address sender;
108         string argument;
109         uint likes;
110         uint dislikes;
111         bool isValue;
112     }
113     uint _tokensToSendTopic;
114 
115     mapping(bytes32 => Topic) topics;
116     bytes32[] topicsList;
117 
118     event Upvote(bytes32 topicKey, uint likes);
119     event Downvote(bytes32 topicKey, uint dislikes);
120     event NewTopic(bytes32 topicKey);
121 
122     constructor() public {
123         symbol = "FLT";
124         name = "FLAToken";
125         decimals = 18;
126         _totalSupply = 75000000 * 10**uint(decimals);
127         _unitsOneEthCanBuy = 3750;
128         _tokensToSendTopic = 1 * 10**uint(decimals);
129         _bonusEachTarget = 1000000000000000000; //1 ETH
130         _bonusAmount = 100 * 10**uint(decimals);
131         tokenSold = 0;
132         balances[owner] = _totalSupply;
133         emit Transfer(address(0), owner, _totalSupply);
134         _salesOpen = true;
135     }
136 
137     function totalSupply() public view returns (uint) {
138         return _totalSupply;
139     }
140 
141     function availableSupply() public view returns (uint) {
142         return balances[owner];
143     }
144 
145     function balanceOf(address tokenOwner) public view returns (uint balance) {
146         return balances[tokenOwner];
147     }
148 
149     function unitsOneEthCanBuy() public view returns (uint) {
150         return _calculateUnitsOneEthCanBuy();
151     }
152 
153     function setUnitsOneEthCanBuy(uint tokens) public onlyOwner {
154         _unitsOneEthCanBuy = tokens;
155     }
156 
157     function _calculateUnitsOneEthCanBuy() private view returns (uint tokens){
158         if(tokenSold > 60000000 * 10**uint(decimals)) {
159             return 500;
160         } else if (tokenSold > 45000000 * 10**uint(decimals)) {
161             return 1500;
162         } else if (tokenSold > 30000000 * 10**uint(decimals)) {
163             return 2500;
164         } else if (tokenSold > 15000000 * 10**uint(decimals)) {
165             return 3000;
166         }
167 
168         return _unitsOneEthCanBuy;
169     }
170 
171     function closeICO() public onlyOwner {
172         _salesOpen = false;
173         balances[owner] = 0;
174     }
175 
176     function transfer(address to, uint tokens) public returns (bool success) {
177         require(tokens > 0);
178 
179         balances[msg.sender] = balances[msg.sender].sub(tokens);
180         balances[to] = balances[to].add(tokens);
181 
182         emit Transfer(msg.sender, to, tokens);
183         return true;
184     }
185 
186     function approve(address spender, uint tokens) public returns (bool success) {
187         require((tokens == 0) || (allowed[msg.sender][spender] == 0));
188 
189         allowed[msg.sender][spender] = tokens;
190         emit Approval(msg.sender, spender, tokens);
191 
192         return true;
193     }
194 
195     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
196         require(tokens > 0);
197 
198         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
199         balances[from] = balances[from].sub(tokens);
200         balances[to] = balances[to].add(tokens);
201         emit Transfer(from, to, tokens);
202 
203         return true;
204     }
205 
206     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
207         return allowed[tokenOwner][spender];
208     }
209 
210     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213 
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
215         return true;
216     }
217 
218     function buy() external payable {
219         require(msg.value > 0 && _salesOpen);
220 
221         uint amount = msg.value.mul(_calculateUnitsOneEthCanBuy());
222         if(msg.value >= _bonusEachTarget) {
223             amount = amount.add(_bonusAmount.mul(msg.value.div(_bonusEachTarget)));
224         }
225         require(amount > 0 && balances[owner] >= amount);
226 
227         balances[owner] = balances[owner].sub(amount);
228         balances[msg.sender] = balances[msg.sender].add(amount);
229 
230         tokenSold = tokenSold.add(amount);
231 
232         emit Transfer(owner, msg.sender, amount);
233 
234         owner.transfer(msg.value);
235     }
236 
237     function () external payable {
238         revert();
239     }
240 
241     function newTopic(bytes32 topicKey, string memory argument) public returns(bool success) {
242         require(!topics[topicKey].isValue);
243 
244         balances[msg.sender] = balances[msg.sender].sub(_tokensToSendTopic);
245         balances[owner] = balances[owner].add(_tokensToSendTopic);
246 
247         emit Transfer(msg.sender, owner, _tokensToSendTopic);
248 
249         topics[topicKey].argument = argument;
250         topics[topicKey].sender = msg.sender;
251         topics[topicKey].likes = 0;
252         topics[topicKey].dislikes = 0;
253         topics[topicKey].isValue = true;
254 
255         topicsList.push(topicKey);
256 
257         emit NewTopic(topicKey);
258 
259         return true;
260     }
261 
262     function getTopic(bytes32 topicKey) public view returns (string memory argument, address sender, uint likes, uint dislikes) {
263         Topic memory t = topics[topicKey];
264         require(t.isValue);
265 
266         return(t.argument, t.sender, t.likes, t.dislikes);
267     }
268 
269      function getTopicsCount() public view returns (uint topicsCount) {
270         return topicsList.length;
271     }
272 
273     function getTopicAtIndex(uint row) public view returns (bytes32 key, string memory arg, address sender, uint likes, uint dislikes) {
274         Topic memory t = topics[topicsList[row]];
275         require(t.isValue);
276 
277         return(topicsList[row], t.argument, t.sender, t.likes, t.dislikes);
278     }
279 
280     function upvote(bytes32 topicKey, uint tokens) public returns (bool success) {
281         require(tokens > 0);
282 
283         Topic storage t = topics[topicKey];
284         require(t.isValue && t.sender != msg.sender);
285 
286         balances[msg.sender] = balances[msg.sender].sub(tokens);
287         balances[t.sender] = balances[t.sender].add(tokens);
288 
289         emit Transfer(msg.sender, t.sender, tokens);
290 
291         t.likes = t.likes.add(tokens);
292 
293         emit Upvote(topicKey, t.likes);
294 
295         return true;
296     }
297 
298     function downvote(bytes32 topicKey, uint tokens) public returns (bool success) {
299         require(tokens > 0);
300 
301         Topic storage t = topics[topicKey];
302         require(t.isValue && t.sender != msg.sender);
303 
304         balances[msg.sender] = balances[msg.sender].sub(tokens);
305         balances[t.sender] = balances[t.sender].add(tokens);
306 
307         emit Transfer(msg.sender, t.sender, tokens);
308 
309         t.dislikes = t.dislikes.add(tokens);
310 
311         emit Downvote(topicKey, t.dislikes);
312 
313         return true;
314     }
315 }