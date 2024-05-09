1 pragma solidity ^0.4.8;
2 
3 
4 /**
5  * @title ERC20
6  */
7 contract ERC20 {
8     function totalSupply() constant returns (uint256 totalSupply);
9     function balanceOf(address _owner) constant returns (uint256 balance);
10     function transfer(address _to, uint256 _value) returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12     function approve(address _spender, uint256 _value) returns (bool success);
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14     
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 
20 /**
21  * @title MainstreetToken
22  */
23 contract MainstreetToken is ERC20 {
24     
25     mapping (address => uint) ownerMIT;
26     mapping (address => mapping (address => uint)) allowed;
27     uint public totalMIT;
28     uint public start;
29     
30     address public mainstreetCrowdfund;
31 
32     address public intellisys;
33     
34     bool public testing;
35 
36     modifier fromCrowdfund() {
37         if (msg.sender != mainstreetCrowdfund) {
38             throw;
39         }
40         _;
41     }
42     
43     modifier isActive() {
44         if (block.timestamp < start) {
45             throw;
46         }
47         _;
48     }
49 
50     modifier isNotActive() {
51         if (!testing && block.timestamp >= start) {
52             throw;
53         }
54         _;
55     }
56 
57     modifier recipientIsValid(address recipient) {
58         if (recipient == 0 || recipient == address(this)) {
59             throw;
60         }
61         _;
62     }
63 
64     modifier senderHasSufficient(uint MIT) {
65         if (ownerMIT[msg.sender] < MIT) {
66             throw;
67         }
68         _;
69     }
70 
71     modifier transferApproved(address from, uint MIT) {
72         if (allowed[from][msg.sender] < MIT || ownerMIT[from] < MIT) {
73             throw;
74         }
75         _;
76     }
77 
78     modifier allowanceIsZero(address spender, uint value) {
79         // To change the approve amount you first have to reduce the addresses´
80         // allowance to zero by calling `approve(_spender,0)` if it is not
81         // already 0 to mitigate the race condition described here:
82         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83         if ((value != 0) && (allowed[msg.sender][spender] != 0)) {
84             throw;
85         }
86         _;
87     }
88 
89     /**
90      * @dev Tokens have been added to an address by the crowdfunding contract.
91      * @param recipient Address receiving the MIT.
92      * @param MIT Amount of MIT added.
93      */
94     event TokensAdded(address indexed recipient, uint MIT);
95 
96     /**
97      * @dev Constructor.
98      * @param _mainstreetCrowdfund Address of crowdfund contract.
99      * @param _intellisys Address to receive intellisys' tokens.
100      * @param _start Timestamp when the token becomes active.
101      */
102     function MainstreetToken(address _mainstreetCrowdfund, address _intellisys, uint _start, bool _testing) {
103         mainstreetCrowdfund = _mainstreetCrowdfund;
104         intellisys = _intellisys;
105         start = _start;
106         testing = _testing;
107     }
108     
109     /**
110      * @dev Add to token balance on address. Must be from crowdfund.
111      * @param recipient Address to add tokens to.
112      * @return MIT Amount of MIT to add.
113      */
114     function addTokens(address recipient, uint MIT) external isNotActive fromCrowdfund {
115         ownerMIT[recipient] += MIT;
116         uint intellisysMIT = MIT / 10;
117         ownerMIT[intellisys] += intellisysMIT;
118         totalMIT += MIT + intellisysMIT;
119         TokensAdded(recipient, MIT);
120         TokensAdded(intellisys, intellisysMIT);
121     }
122 
123     /**
124      * @dev Implements ERC20 totalSupply()
125      */
126     function totalSupply() constant returns (uint256 totalSupply) {
127         totalSupply = totalMIT;
128     }
129 
130     /**
131      * @dev Implements ERC20 balanceOf()
132      */
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         balance = ownerMIT[_owner];
135     }
136 
137     /**
138      * @dev Implements ERC20 transfer()
139      */
140     function transfer(address _to, uint256 _value) isActive recipientIsValid(_to) senderHasSufficient(_value) returns (bool success) {
141         ownerMIT[msg.sender] -= _value;
142         ownerMIT[_to] += _value;
143         Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Implements ERC20 transferFrom()
149      */
150     function transferFrom(address _from, address _to, uint256 _value) isActive recipientIsValid(_to) transferApproved(_from, _value) returns (bool success) {
151         ownerMIT[_to] += _value;
152         ownerMIT[_from] -= _value;
153         allowed[_from][msg.sender] -= _value;
154         Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * @dev Implements ERC20 approve()
160      */
161     function approve(address _spender, uint256 _value) isActive allowanceIsZero(_spender, _value) returns (bool success) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Implements ERC20 allowance()
169      */
170     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
171         remaining = allowed[_owner][_spender];
172     }
173 
174 }
175 
176 
177 /**
178  * @title MainstreetCrowdfund
179  */
180 contract MainstreetCrowdfund {
181     
182     uint public start;
183     uint public end;
184 
185     mapping (address => uint) public senderETH;
186     mapping (address => uint) public senderMIT;
187     mapping (address => uint) public recipientETH;
188     mapping (address => uint) public recipientMIT;
189     mapping (address => uint) public recipientExtraMIT;
190 
191     uint public totalETH;
192     uint public limitETH;
193 
194     uint public bonus1StartETH;
195     uint public bonus2StartETH;
196 
197     mapping (address => bool) public whitelistedAddresses;
198     
199     address public exitAddress;
200     address public creator;
201 
202     MainstreetToken public mainstreetToken;
203 
204     event MITPurchase(address indexed sender, address indexed recipient, uint ETH, uint MIT);
205 
206     modifier saleActive() {
207         if (address(mainstreetToken) == 0) {
208             throw;
209         }
210         if (block.timestamp < start || block.timestamp >= end) {
211             throw;
212         }
213         if (totalETH + msg.value > limitETH) {
214             throw;
215         }
216         _;
217     }
218 
219     modifier hasValue() {
220         if (msg.value == 0) {
221             throw;
222         }
223         _;
224     }
225     
226     modifier senderIsWhitelisted() {
227         if (whitelistedAddresses[msg.sender] != true) {
228             throw;
229         }
230         _;
231     }
232 
233     modifier recipientIsValid(address recipient) {
234         if (recipient == 0 || recipient == address(this)) {
235             throw;
236         }
237         _;
238     }
239 
240     modifier isCreator() {
241         if (msg.sender != creator) {
242             throw;
243         }
244         _;
245     }
246 
247     modifier tokenContractNotSet() {
248         if (address(mainstreetToken) != 0) {
249             throw;
250         }
251         _;
252     }
253 
254     /**
255      * @dev Constructor.
256      * @param _start Timestamp of when the crowdsale will start.
257      * @param _end Timestamp of when the crowdsale will end.
258      * @param _limitETH Maximum amount of ETH that can be sent to the contract in total. Denominated in wei.
259      * @param _bonus1StartETH Amount of Ether (denominated in wei) that is required to qualify for the first bonus.
260      * @param _bonus1StartETH Amount of Ether (denominated in wei) that is required to qualify for the second bonus.
261      * @param _exitAddress Address that all ETH should be forwarded to.
262      * @param whitelist1 First address that can send ETH.
263      * @param whitelist2 Second address that can send ETH.
264      * @param whitelist3 Third address that can send ETH.
265      */
266     function MainstreetCrowdfund(uint _start, uint _end, uint _limitETH, uint _bonus1StartETH, uint _bonus2StartETH, address _exitAddress, address whitelist1, address whitelist2, address whitelist3) {
267         creator = msg.sender;
268         start = _start;
269         end = _end;
270         limitETH = _limitETH;
271         bonus1StartETH = _bonus1StartETH;
272         bonus2StartETH = _bonus2StartETH;
273 
274         whitelistedAddresses[whitelist1] = true;
275         whitelistedAddresses[whitelist2] = true;
276         whitelistedAddresses[whitelist3] = true;
277         exitAddress = _exitAddress;
278     }
279     
280     /**
281      * @dev Set the address of the token contract. Must be called by creator of this. Can only be set once.
282      * @param _mainstreetToken Address of the token contract.
283      */
284     function setTokenContract(MainstreetToken _mainstreetToken) external isCreator tokenContractNotSet {
285         mainstreetToken = _mainstreetToken;
286     }
287 
288     /**
289      * @dev Forward Ether to the exit address. Store all ETH and MIT information in public state and logs.
290      * @param recipient Address that tokens should be attributed to.
291      * @return MIT Amount of MIT purchased. This does not include the per-recipient quantity bonus.
292      */
293     function purchaseMIT(address recipient) external senderIsWhitelisted payable saleActive hasValue recipientIsValid(recipient) returns (uint increaseMIT) {
294         
295         // Attempt to send the ETH to the exit address.
296         if (!exitAddress.send(msg.value)) {
297             throw;
298         }
299         
300         // Update ETH amounts.
301         senderETH[msg.sender] += msg.value;
302         recipientETH[recipient] += msg.value;
303         totalETH += msg.value;
304 
305         // Calculate MIT purchased directly in this transaction.
306         uint MIT = msg.value * 10;   // $1 / MIT based on $10 / ETH value
307 
308         // Calculate time-based bonus.
309         if (block.timestamp - start < 1 weeks) {
310             MIT += MIT / 10;    // 10% bonus
311         }
312         else if (block.timestamp - start < 5 weeks) {
313             MIT += MIT / 20;    // 5% bonus
314         }
315 
316         // Record directly-purchased MIT.
317         senderMIT[msg.sender] += MIT;
318         recipientMIT[recipient] += MIT;
319 
320         // Store previous value-based bonus for this address.
321         uint oldExtra = recipientExtraMIT[recipient];
322 
323         // Calculate new value-based bonus.
324         if (recipientETH[recipient] >= bonus2StartETH) {
325             recipientExtraMIT[recipient] = (recipientMIT[recipient] * 8) / 100;      // 8% bonus
326         }
327         else if (recipientETH[recipient] >= bonus1StartETH) {
328             recipientExtraMIT[recipient] = (recipientMIT[recipient] * 4) / 100;      // 4% bonus
329         }
330 
331         // Calculate MIT increase for this address from this transaction.
332         increaseMIT = MIT + (recipientExtraMIT[recipient] - oldExtra);
333 
334         // Tell the token contract about the increase.
335         mainstreetToken.addTokens(recipient, increaseMIT);
336 
337         // Log this purchase.
338         MITPurchase(msg.sender, recipient, msg.value, increaseMIT);
339     }
340 
341 }