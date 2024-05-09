1 pragma solidity ^0.4.9;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 /**
16  * @title MainstreetToken
17  */
18 contract MainstreetToken is ERC20 {
19     string public name = 'Mainstreet Token';             //The Token's name: e.g. DigixDAO Tokens
20     uint8 public decimals = 18;             // 1Token ¨= 1$ (1ETH ¨= 10$)
21     string public symbol = 'MIT';           //An identifier: e.g. REP
22     string public version = 'MIT_0.1';
23 
24     mapping (address => uint) ownerMIT;
25     mapping (address => mapping (address => uint)) allowed;
26     uint public totalMIT;
27     uint public start;
28 
29     address public mainstreetCrowdfund;
30 
31     address public intellisys;
32 
33     bool public testing;
34 
35     modifier fromCrowdfund() {
36         if (msg.sender != mainstreetCrowdfund) {
37             throw;
38         }
39         _;
40     }
41 
42     modifier isActive() {
43         if (block.timestamp < start) {
44             throw;
45         }
46         _;
47     }
48 
49     modifier isNotActive() {
50         if (!testing && block.timestamp >= start) {
51             throw;
52         }
53         _;
54     }
55 
56     modifier recipientIsValid(address recipient) {
57         if (recipient == 0 || recipient == address(this)) {
58             throw;
59         }
60         _;
61     }
62 
63     modifier allowanceIsZero(address spender, uint value) {
64         // To change the approve amount you first have to reduce the addresses´
65         // allowance to zero by calling `approve(_spender,0)` if it is not
66         // already 0 to mitigate the race condition described here:
67         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68         if ((value != 0) && (allowed[msg.sender][spender] != 0)) {
69             throw;
70         }
71         _;
72     }
73 
74     /**
75      * @dev Constructor.
76      * @param _mainstreetCrowdfund Address of crowdfund contract.
77      * @param _intellisys Address to receive intellisys' tokens.
78      * @param _start Timestamp when the token becomes active.
79      */
80     function MainstreetToken(address _mainstreetCrowdfund, address _intellisys, uint _start, bool _testing) {
81         mainstreetCrowdfund = _mainstreetCrowdfund;
82         intellisys = _intellisys;
83         start = _start;
84         testing = _testing;
85     }
86 
87     /**
88      * @dev Add to token balance on address. Must be from crowdfund.
89      * @param recipient Address to add tokens to.
90      * @return MIT Amount of MIT to add.
91      */
92     function addTokens(address recipient, uint MIT) external isNotActive fromCrowdfund {
93         ownerMIT[recipient] += MIT;
94         uint intellisysMIT = MIT / 10;
95         ownerMIT[intellisys] += intellisysMIT;
96         totalMIT += MIT + intellisysMIT;
97         Transfer(0x0, recipient, MIT);
98         Transfer(0x0, intellisys, intellisysMIT);
99     }
100 
101     /**
102      * @dev Implements ERC20 totalSupply()
103      */
104     function totalSupply() constant returns (uint256 totalSupply) {
105         totalSupply = totalMIT;
106     }
107 
108     /**
109      * @dev Implements ERC20 balanceOf()
110      */
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112         balance = ownerMIT[_owner];
113     }
114 
115     /**
116      * @dev Implements ERC20 transfer()
117      */
118     function transfer(address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
119         if (ownerMIT[msg.sender] >= _value) {
120             ownerMIT[msg.sender] -= _value;
121             ownerMIT[_to] += _value;
122             Transfer(msg.sender, _to, _value);
123             return true;
124         } else {
125             return false;
126         }
127     }
128 
129     /**
130      * @dev Implements ERC20 transferFrom()
131      */
132     function transferFrom(address _from, address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
133         if (allowed[_from][msg.sender] >= _value && ownerMIT[_from] >= _value) {
134             ownerMIT[_to] += _value;
135             ownerMIT[_from] -= _value;
136             allowed[_from][msg.sender] -= _value;
137             Transfer(_from, _to, _value);
138             return true;
139         } else {
140             return false;
141         }
142     }
143 
144     /**
145      * @dev Implements ERC20 approve()
146      */
147     function approve(address _spender, uint256 _value) isActive allowanceIsZero(_spender, _value) returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Implements ERC20 allowance()
155      */
156     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
157         remaining = allowed[_owner][_spender];
158     }
159 }
160 
161 
162 /**
163  * @title MainstreetCrowdfund
164  */
165 contract MainstreetCrowdfund {
166 
167     uint public start;
168     uint public end;
169 
170     mapping (address => uint) public senderETH;
171     mapping (address => uint) public senderMIT;
172     mapping (address => uint) public recipientETH;
173     mapping (address => uint) public recipientMIT;
174     mapping (address => uint) public recipientExtraMIT;
175 
176     uint public totalETH;
177     uint public limitETH;
178 
179     uint public bonus1StartETH;
180     uint public bonus2StartETH;
181 
182     mapping (address => bool) public whitelistedAddresses;
183 
184     address public exitAddress;
185     address public creator;
186 
187     MainstreetToken public mainstreetToken;
188 
189     event MITPurchase(address indexed sender, address indexed recipient, uint ETH, uint MIT);
190 
191     modifier saleActive() {
192         if (address(mainstreetToken) == 0) {
193             throw;
194         }
195         if (block.timestamp < start || block.timestamp >= end) {
196             throw;
197         }
198         if (totalETH + msg.value > limitETH) {
199             throw;
200         }
201         _;
202     }
203 
204     modifier hasValue() {
205         if (msg.value == 0) {
206             throw;
207         }
208         _;
209     }
210 
211     modifier senderIsWhitelisted() {
212         if (whitelistedAddresses[msg.sender] != true) {
213             throw;
214         }
215         _;
216     }
217 
218     modifier recipientIsValid(address recipient) {
219         if (recipient == 0 || recipient == address(this)) {
220             throw;
221         }
222         _;
223     }
224 
225     modifier isCreator() {
226         if (msg.sender != creator) {
227             throw;
228         }
229         _;
230     }
231 
232     modifier tokenContractNotSet() {
233         if (address(mainstreetToken) != 0) {
234             throw;
235         }
236         _;
237     }
238 
239     /**
240      * @dev Constructor.
241      * @param _start Timestamp of when the crowdsale will start.
242      * @param _end Timestamp of when the crowdsale will end.
243      * @param _limitETH Maximum amount of ETH that can be sent to the contract in total. Denominated in wei.
244      * @param _bonus1StartETH Amount of Ether (denominated in wei) that is required to qualify for the first bonus.
245      * @param _bonus1StartETH Amount of Ether (denominated in wei) that is required to qualify for the second bonus.
246      * @param _exitAddress Address that all ETH should be forwarded to.
247      * @param whitelist1 First address that can send ETH.
248      * @param whitelist2 Second address that can send ETH.
249      * @param whitelist3 Third address that can send ETH.
250      */
251     function MainstreetCrowdfund(uint _start, uint _end, uint _limitETH, uint _bonus1StartETH, uint _bonus2StartETH, address _exitAddress, address whitelist1, address whitelist2, address whitelist3) {
252         creator = msg.sender;
253         start = _start;
254         end = _end;
255         limitETH = _limitETH;
256         bonus1StartETH = _bonus1StartETH;
257         bonus2StartETH = _bonus2StartETH;
258 
259         whitelistedAddresses[whitelist1] = true;
260         whitelistedAddresses[whitelist2] = true;
261         whitelistedAddresses[whitelist3] = true;
262         exitAddress = _exitAddress;
263     }
264 
265     /**
266      * @dev Set the address of the token contract. Must be called by creator of this. Can only be set once.
267      * @param _mainstreetToken Address of the token contract.
268      */
269     function setTokenContract(MainstreetToken _mainstreetToken) external isCreator tokenContractNotSet {
270         mainstreetToken = _mainstreetToken;
271     }
272 
273     /**
274      * @dev Forward Ether to the exit address. Store all ETH and MIT information in public state and logs.
275      * @param recipient Address that tokens should be attributed to.
276      * @return MIT Amount of MIT purchased. This does not include the per-recipient quantity bonus.
277      */
278     function purchaseMIT(address recipient) external senderIsWhitelisted payable saleActive hasValue recipientIsValid(recipient) returns (uint increaseMIT) {
279 
280         // Attempt to send the ETH to the exit address.
281         if (!exitAddress.send(msg.value)) {
282             throw;
283         }
284 
285         // Update ETH amounts.
286         senderETH[msg.sender] += msg.value;
287         recipientETH[recipient] += msg.value;
288         totalETH += msg.value;
289 
290         // Calculate MIT purchased directly in this transaction.
291         uint MIT = msg.value * 10;   // $1 / MIT based on $10 / ETH value
292 
293         // Calculate time-based bonus.
294         if (block.timestamp - start < 2 weeks) {
295             MIT += MIT / 10;    // 10% bonus
296         }
297         else if (block.timestamp - start < 5 weeks) {
298             MIT += MIT / 20;    // 5% bonus
299         }
300 
301         // Record directly-purchased MIT.
302         senderMIT[msg.sender] += MIT;
303         recipientMIT[recipient] += MIT;
304 
305         // Store previous value-based bonus for this address.
306         uint oldExtra = recipientExtraMIT[recipient];
307 
308         // Calculate new value-based bonus.
309         if (recipientETH[recipient] >= bonus2StartETH) {
310             recipientExtraMIT[recipient] = (recipientMIT[recipient] * 75) / 1000;      // 7.5% bonus
311         }
312         else if (recipientETH[recipient] >= bonus1StartETH) {
313             recipientExtraMIT[recipient] = (recipientMIT[recipient] * 375) / 10000;      // 3.75% bonus
314         }
315 
316         // Calculate MIT increase for this address from this transaction.
317         increaseMIT = MIT + (recipientExtraMIT[recipient] - oldExtra);
318 
319         // Tell the token contract about the increase.
320         mainstreetToken.addTokens(recipient, increaseMIT);
321 
322         // Log this purchase.
323         MITPurchase(msg.sender, recipient, msg.value, increaseMIT);
324     }
325 
326 }