1 pragma solidity ^0.4.9;
2 
3 /**
4  * @title ERC20
5  */
6 contract ERC20 {
7     function totalSupply() constant returns (uint256 totalSupply);
8     function balanceOf(address _owner) constant returns (uint256 balance);
9     function transfer(address _to, uint256 _value) returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11     function approve(address _spender, uint256 _value) returns (bool success);
12     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
13     
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 
19 /**
20  * @title LegendsToken
21  */
22 contract LegendsToken is ERC20 {
23     string public name = 'VIP';             //The Token's name: e.g. DigixDAO Tokens
24     uint8 public decimals = 18;             // 1Token ¨= 1$ (1ETH ¨= 10$)
25     string public symbol = 'VIP';           //An identifier: e.g. REP
26     string public version = 'VIP_0.1';
27 
28     mapping (address => uint) ownerVIP;
29     mapping (address => mapping (address => uint)) allowed;
30     uint public totalVIP;
31     uint public start;
32 
33     address public legendsCrowdfund;
34 
35     bool public testing;
36 
37     modifier fromCrowdfund() {
38         if (msg.sender != legendsCrowdfund) {
39             throw;
40         }
41         _;
42     }
43 
44     modifier isActive() {
45         if (block.timestamp < start) {
46             throw;
47         }
48         _;
49     }
50 
51     modifier isNotActive() {
52         if (!testing && block.timestamp >= start) {
53             throw;
54         }
55         _;
56     }
57 
58     modifier recipientIsValid(address recipient) {
59         if (recipient == 0 || recipient == address(this)) {
60             throw;
61         }
62         _;
63     }
64 
65     modifier allowanceIsZero(address spender, uint value) {
66         // To change the approve amount you first have to reduce the addresses´
67         // allowance to zero by calling `approve(_spender,0)` if it is not
68         // already 0 to mitigate the race condition described here:
69         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70         if ((value != 0) && (allowed[msg.sender][spender] != 0)) {
71             throw;
72         }
73         _;
74     }
75 
76     /**
77      * @dev Tokens have been added to an address by the crowdfunding contract.
78      * @param recipient Address receiving the VIP.
79      * @param VIP Amount of VIP added.
80      */
81     event TokensAdded(address indexed recipient, uint VIP);
82 
83     /**
84      * @dev Constructor.
85      * @param _legendsCrowdfund Address of crowdfund contract.
86      * @param _preallocation Address to receive the pre-allocation.
87      * @param _start Timestamp when the token becomes active.
88      */
89     function LegendsToken(address _legendsCrowdfund, address _preallocation, uint _start, bool _testing) {
90         legendsCrowdfund = _legendsCrowdfund;
91         start = _start;
92         testing = _testing;
93         totalVIP = ownerVIP[_preallocation] = 25000 ether;
94     }
95 
96     /**
97      * @dev Add to token balance on address. Must be from crowdfund.
98      * @param recipient Address to add tokens to.
99      * @return VIP Amount of VIP to add.
100      */
101     function addTokens(address recipient, uint VIP) external isNotActive fromCrowdfund {
102         ownerVIP[recipient] += VIP;
103         totalVIP += VIP;
104         TokensAdded(recipient, VIP);
105     }
106 
107     /**
108      * @dev Implements ERC20 totalSupply()
109      */
110     function totalSupply() constant returns (uint256 totalSupply) {
111         totalSupply = totalVIP;
112     }
113 
114     /**
115      * @dev Implements ERC20 balanceOf()
116      */
117     function balanceOf(address _owner) constant returns (uint256 balance) {
118         balance = ownerVIP[_owner];
119     }
120 
121     /**
122      * @dev Implements ERC20 transfer()
123      */
124     function transfer(address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
125         if (ownerVIP[msg.sender] >= _value) {
126             ownerVIP[msg.sender] -= _value;
127             ownerVIP[_to] += _value;
128             Transfer(msg.sender, _to, _value);
129             return true;
130         } else {
131             return false;
132         }
133     }
134 
135     /**
136      * @dev Implements ERC20 transferFrom()
137      */
138     function transferFrom(address _from, address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
139         if (allowed[_from][msg.sender] >= _value && ownerVIP[_from] >= _value) {
140             ownerVIP[_to] += _value;
141             ownerVIP[_from] -= _value;
142             allowed[_from][msg.sender] -= _value;
143             Transfer(_from, _to, _value);
144             return true;
145         } else {
146             return false;
147         }
148     }
149 
150     /**
151      * @dev Implements ERC20 approve()
152      */
153     function approve(address _spender, uint256 _value) isActive allowanceIsZero(_spender, _value) returns (bool success) {
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     /**
160      * @dev Implements ERC20 allowance()
161      */
162     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
163         remaining = allowed[_owner][_spender];
164     }
165 
166     /**
167      * @dev Direct Buy
168      */
169     function () payable {
170         LegendsCrowdfund(legendsCrowdfund).purchaseMembership.value(msg.value)(msg.sender);
171     }
172 
173 }
174 
175 
176 
177 /**
178  * @title LegendsCrowdfund
179  */
180 contract LegendsCrowdfund {
181 
182     address public creator;
183     address public exitAddress;
184 
185     uint public start;
186     uint public limitVIP;
187 
188     LegendsToken public legendsToken;
189 
190     mapping (address => uint) public recipientETH;
191     mapping (address => uint) public recipientVIP;
192 
193     uint public totalETH;
194     uint public totalVIP;
195 
196     event VIPPurchase(address indexed sender, address indexed recipient, uint ETH, uint VIP);
197 
198     modifier saleActive() {
199         if (address(legendsToken) == 0) {
200             throw;
201         }
202         if (block.timestamp < start) {
203             throw;
204         }
205         _;
206     }
207 
208     modifier hasValue() {
209         if (msg.value == 0) {
210             throw;
211         }
212         _;
213     }
214 
215     modifier recipientIsValid(address recipient) {
216         if (recipient == 0 || recipient == address(this)) {
217             throw;
218         }
219         _;
220     }
221 
222     modifier isCreator() {
223         if (msg.sender != creator) {
224             throw;
225         }
226         _;
227     }
228 
229     modifier tokenContractNotSet() {
230         if (address(legendsToken) != 0) {
231             throw;
232         }
233         _;
234     }
235 
236     /**
237      * @dev Constructor.
238      * @param _exitAddress Address that all ETH should be forwarded to.
239      * @param _start Timestamp of when the crowdsale will start.
240      * @param _limitVIP Maximum amount of VIP that can be allocated in total. Denominated in wei.
241      */
242     function LegendsCrowdfund(address _exitAddress, uint _start, uint _limitVIP) {
243         creator = msg.sender;
244         exitAddress = _exitAddress;
245         start = _start;
246         limitVIP = _limitVIP;
247     }
248 
249     /**
250      * @dev Set the address of the token contract. Must be called by creator of this. Can only be set once.
251      * @param _legendsToken Address of the token contract.
252      */
253     function setTokenContract(LegendsToken _legendsToken) external isCreator tokenContractNotSet {
254         legendsToken = _legendsToken;
255     }
256 
257     /**
258      * @dev Forward Ether to the exit address. Store all ETH and VIP information in public state and logs.
259      * @param recipient Address that tokens should be attributed to.
260      */
261     function purchaseMembership(address recipient) external payable saleActive hasValue recipientIsValid(recipient) {
262 
263         // Attempt to send the ETH to the exit address.
264         if (!exitAddress.send(msg.value)) {
265             throw;
266         }
267 
268         // Update ETH amounts.
269         recipientETH[recipient] += msg.value;
270         totalETH += msg.value;
271 
272         // Calculate VIP amount.
273         uint VIP = msg.value * 10;  // $1 / VIP based on $10 / ETH value.
274 
275         // Are we in the pre-sale?
276         if (block.timestamp - start < 2 weeks) {
277             VIP = (VIP * 10) / 9;   // 10% discount.
278         }
279 
280         // Update VIP amounts.
281         recipientVIP[recipient] += VIP;
282         totalVIP += VIP;
283 
284         // Check we have not exceeded the maximum VIP.
285         if (totalVIP > limitVIP) {
286             throw;
287         }
288 
289         // Tell the token contract about the increase.
290         legendsToken.addTokens(recipient, VIP);
291 
292         // Log this purchase.
293         VIPPurchase(msg.sender, recipient, msg.value, VIP);
294     }
295 
296 }