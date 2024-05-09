1 /*
2 
3 Mainstreet MITs Explanatory Language
4 
5 Each Subscriber to the Fund will execute a subscription agreement and agree the
6 terms of a partnership agreement relating to the Fund. On acceptance of its
7 subscription by the Fund, execution of the partnership agreement and entry on
8 the Fund's limited partner records, a subscriber will become a Limited Partner
9 in the Fund.
10 
11 Each Limited Partner will be issued with a certain number of Tokens by the Fund
12 in return for its subscription in the Fund.
13 
14 Limited Partners, as part of the subscription process, will have provided to
15 the Fund all necessary due diligence and "know your client" information to
16 enable the Fund to discharge its regulatory obligations.
17 
18 Although the Tokens issued to Limited Partners are operationally transferable,
19 either peer-to-peer or though a variety of Blockchain-enabled exchanges, it is
20 only the beneficial entitlement/ownership of the Tokens that is capable of being
21 transferred using such peer-to-peer networks or Blockchain exchanges.
22 
23 It is only once a person is registered as a Limited Partner of the Fund that
24 such person becomes fully entitled to the rights associated with the Token and
25 the rights of a Limited Partner in the Fund.
26 
27 If a Transferee wishes to perfect its legal ownership as a Limited Partner in
28 the Fund, the Transferee must register with the Fund, execute a subscription
29 agreement and/or such other documentation as the general partner of the Fund
30 shall require and provide all necessary "know your client" and due diligence
31 information that will permit the Fund to register the Transferee as a Limited
32 Partner in the Fund in substitution for the Transferor of the Tokens.
33 
34 The registered Limited Partner to which such Token was originally issued remains
35 the legal holder of the Limited Partner interest in the Fund and retains the
36 entitlement to all distributions and profit realisation in respect of the Token. 
37 The arrangements governing the transfer of the Token from Transferor to
38 Transferee may oblige the Transferor to account for any such benefits to the
39 Transferee, but the Fund is only legally obliged to deal with the registered
40 Limited Partner of the Fund to which the relevant Tokens relate.
41 
42 It is therefore incumbent on any Transferee/purchaser of Tokens to register with
43 the Fund as a Limited Partner as soon as possible.  Please contact the General
44 Partner to discuss the requirements to effect such registration.
45 
46 */
47 
48 pragma solidity ^0.4.9;
49 
50 contract ERC20 {
51     function totalSupply() constant returns (uint256 totalSupply);
52     function balanceOf(address _owner) constant returns (uint256 balance);
53     function transfer(address _to, uint256 _value) returns (bool success);
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
55     function approve(address _spender, uint256 _value) returns (bool success);
56     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 /**
63  * @title MainstreetToken
64  */
65 contract MainstreetToken is ERC20 {
66     string public name = 'Mainstreet Token';             //The Token's name: e.g. DigixDAO Tokens
67     uint8 public decimals = 18;             // 1Token ¨= 1$ (1ETH ¨= 10$)
68     string public symbol = 'MIT';           //An identifier: e.g. REP
69     string public version = 'MIT_0.1';
70 
71     mapping (address => uint) ownerMIT;
72     mapping (address => mapping (address => uint)) allowed;
73     uint public totalMIT;
74     uint public start;
75 
76     address public mainstreetCrowdfund;
77 
78     address public intellisys;
79 
80     bool public testing;
81 
82     modifier fromCrowdfund() {
83         if (msg.sender != mainstreetCrowdfund) {
84             throw;
85         }
86         _;
87     }
88 
89     modifier isActive() {
90         if (block.timestamp < start) {
91             throw;
92         }
93         _;
94     }
95 
96     modifier isNotActive() {
97         if (!testing && block.timestamp >= start) {
98             throw;
99         }
100         _;
101     }
102 
103     modifier recipientIsValid(address recipient) {
104         if (recipient == 0 || recipient == address(this)) {
105             throw;
106         }
107         _;
108     }
109 
110     modifier allowanceIsZero(address spender, uint value) {
111         // To change the approve amount you first have to reduce the addresses´
112         // allowance to zero by calling `approve(_spender,0)` if it is not
113         // already 0 to mitigate the race condition described here:
114         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115         if ((value != 0) && (allowed[msg.sender][spender] != 0)) {
116             throw;
117         }
118         _;
119     }
120 
121     /**
122      * @dev Constructor.
123      * @param _mainstreetCrowdfund Address of crowdfund contract.
124      * @param _intellisys Address to receive intellisys' tokens.
125      * @param _start Timestamp when the token becomes active.
126      */
127     function MainstreetToken(address _mainstreetCrowdfund, address _intellisys, uint _start, bool _testing) {
128         mainstreetCrowdfund = _mainstreetCrowdfund;
129         intellisys = _intellisys;
130         start = _start;
131         testing = _testing;
132     }
133 
134     /**
135      * @dev Add to token balance on address. Must be from crowdfund.
136      * @param recipient Address to add tokens to.
137      * @return MIT Amount of MIT to add.
138      */
139     function addTokens(address recipient, uint MIT) external isNotActive fromCrowdfund {
140         ownerMIT[recipient] += MIT;
141         uint intellisysMIT = MIT / 10;
142         ownerMIT[intellisys] += intellisysMIT;
143         totalMIT += MIT + intellisysMIT;
144         Transfer(0x0, recipient, MIT);
145         Transfer(0x0, intellisys, intellisysMIT);
146     }
147 
148     /**
149      * @dev Implements ERC20 totalSupply()
150      */
151     function totalSupply() constant returns (uint256 totalSupply) {
152         totalSupply = totalMIT;
153     }
154 
155     /**
156      * @dev Implements ERC20 balanceOf()
157      */
158     function balanceOf(address _owner) constant returns (uint256 balance) {
159         balance = ownerMIT[_owner];
160     }
161 
162     /**
163      * @dev Implements ERC20 transfer()
164      */
165     function transfer(address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
166         if (ownerMIT[msg.sender] >= _value) {
167             ownerMIT[msg.sender] -= _value;
168             ownerMIT[_to] += _value;
169             Transfer(msg.sender, _to, _value);
170             return true;
171         } else {
172             return false;
173         }
174     }
175 
176     /**
177      * @dev Implements ERC20 transferFrom()
178      */
179     function transferFrom(address _from, address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
180         if (allowed[_from][msg.sender] >= _value && ownerMIT[_from] >= _value) {
181             ownerMIT[_to] += _value;
182             ownerMIT[_from] -= _value;
183             allowed[_from][msg.sender] -= _value;
184             Transfer(_from, _to, _value);
185             return true;
186         } else {
187             return false;
188         }
189     }
190 
191     /**
192      * @dev Implements ERC20 approve()
193      */
194     function approve(address _spender, uint256 _value) isActive allowanceIsZero(_spender, _value) returns (bool success) {
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201      * @dev Implements ERC20 allowance()
202      */
203     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204         remaining = allowed[_owner][_spender];
205     }
206 }
207 
208 
209 /**
210  * @title MainstreetCrowdfund
211  */
212 contract MainstreetCrowdfund {
213 
214     uint public start;
215     uint public end;
216 
217     mapping (address => uint) public senderETH;
218     mapping (address => uint) public senderMIT;
219     mapping (address => uint) public recipientETH;
220     mapping (address => uint) public recipientMIT;
221     mapping (address => uint) public recipientExtraMIT;
222 
223     uint public totalETH;
224     uint public limitETH;
225 
226     uint public bonus1StartETH;
227     uint public bonus2StartETH;
228 
229     mapping (address => bool) public whitelistedAddresses;
230 
231     address public exitAddress;
232     address public creator;
233 
234     MainstreetToken public mainstreetToken;
235 
236     event MITPurchase(address indexed sender, address indexed recipient, uint ETH, uint MIT);
237 
238     modifier saleActive() {
239         if (address(mainstreetToken) == 0) {
240             throw;
241         }
242         if (block.timestamp < start || block.timestamp >= end) {
243             throw;
244         }
245         if (totalETH + msg.value > limitETH) {
246             throw;
247         }
248         _;
249     }
250 
251     modifier hasValue() {
252         if (msg.value == 0) {
253             throw;
254         }
255         _;
256     }
257 
258     modifier senderIsWhitelisted() {
259         if (whitelistedAddresses[msg.sender] != true) {
260             throw;
261         }
262         _;
263     }
264 
265     modifier recipientIsValid(address recipient) {
266         if (recipient == 0 || recipient == address(this)) {
267             throw;
268         }
269         _;
270     }
271 
272     modifier isCreator() {
273         if (msg.sender != creator) {
274             throw;
275         }
276         _;
277     }
278 
279     modifier tokenContractNotSet() {
280         if (address(mainstreetToken) != 0) {
281             throw;
282         }
283         _;
284     }
285 
286     /**
287      * @dev Constructor.
288      * @param _start Timestamp of when the crowdsale will start.
289      * @param _end Timestamp of when the crowdsale will end.
290      * @param _limitETH Maximum amount of ETH that can be sent to the contract in total. Denominated in wei.
291      * @param _bonus1StartETH Amount of Ether (denominated in wei) that is required to qualify for the first bonus.
292      * @param _bonus1StartETH Amount of Ether (denominated in wei) that is required to qualify for the second bonus.
293      * @param _exitAddress Address that all ETH should be forwarded to.
294      * @param whitelist1 First address that can send ETH.
295      * @param whitelist2 Second address that can send ETH.
296      * @param whitelist3 Third address that can send ETH.
297      */
298     function MainstreetCrowdfund(uint _start, uint _end, uint _limitETH, uint _bonus1StartETH, uint _bonus2StartETH, address _exitAddress, address whitelist1, address whitelist2, address whitelist3) {
299         creator = msg.sender;
300         start = _start;
301         end = _end;
302         limitETH = _limitETH;
303         bonus1StartETH = _bonus1StartETH;
304         bonus2StartETH = _bonus2StartETH;
305 
306         whitelistedAddresses[whitelist1] = true;
307         whitelistedAddresses[whitelist2] = true;
308         whitelistedAddresses[whitelist3] = true;
309         exitAddress = _exitAddress;
310     }
311 
312     /**
313      * @dev Set the address of the token contract. Must be called by creator of this. Can only be set once.
314      * @param _mainstreetToken Address of the token contract.
315      */
316     function setTokenContract(MainstreetToken _mainstreetToken) external isCreator tokenContractNotSet {
317         mainstreetToken = _mainstreetToken;
318     }
319 
320     /**
321      * @dev Forward Ether to the exit address. Store all ETH and MIT information in public state and logs.
322      * @param recipient Address that tokens should be attributed to.
323      * @return MIT Amount of MIT purchased. This does not include the per-recipient quantity bonus.
324      */
325     function purchaseMIT(address recipient) external senderIsWhitelisted payable saleActive hasValue recipientIsValid(recipient) returns (uint increaseMIT) {
326 
327         // Attempt to send the ETH to the exit address.
328         if (!exitAddress.send(msg.value)) {
329             throw;
330         }
331 
332         // Update ETH amounts.
333         senderETH[msg.sender] += msg.value;
334         recipientETH[recipient] += msg.value;
335         totalETH += msg.value;
336 
337         // Calculate MIT purchased directly in this transaction.
338         uint MIT = msg.value * 12;   // $1 / MIT based on $12 / ETH value
339 
340         // Calculate time-based bonus.
341         if (block.timestamp - start < 2 weeks) {
342             MIT += MIT / 10;    // 10% bonus
343         }
344         else if (block.timestamp - start < 5 weeks) {
345             MIT += MIT / 20;    // 5% bonus
346         }
347 
348         // Record directly-purchased MIT.
349         senderMIT[msg.sender] += MIT;
350         recipientMIT[recipient] += MIT;
351 
352         // Store previous value-based bonus for this address.
353         uint oldExtra = recipientExtraMIT[recipient];
354 
355         // Calculate new value-based bonus.
356         if (recipientETH[recipient] >= bonus2StartETH) {
357             recipientExtraMIT[recipient] = (recipientMIT[recipient] * 75) / 1000;      // 7.5% bonus
358         }
359         else if (recipientETH[recipient] >= bonus1StartETH) {
360             recipientExtraMIT[recipient] = (recipientMIT[recipient] * 375) / 10000;      // 3.75% bonus
361         }
362 
363         // Calculate MIT increase for this address from this transaction.
364         increaseMIT = MIT + (recipientExtraMIT[recipient] - oldExtra);
365 
366         // Tell the token contract about the increase.
367         mainstreetToken.addTokens(recipient, increaseMIT);
368 
369         // Log this purchase.
370         MITPurchase(msg.sender, recipient, msg.value, increaseMIT);
371     }
372 
373 }