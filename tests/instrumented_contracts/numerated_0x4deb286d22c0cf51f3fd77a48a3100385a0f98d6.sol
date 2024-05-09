1 pragma solidity ^0.4.9;
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
19 /**
20  * @title LegendsCrowdfund
21  */
22 contract LegendsCrowdfund {
23 
24     address public creator;
25     address public exitAddress;
26 
27     uint public start;
28     uint public limitVIP;
29 
30     LegendsToken public legendsToken;
31 
32     mapping (address => uint) public recipientETH;
33     mapping (address => uint) public recipientVIP;
34 
35     uint public totalETH;
36     uint public totalVIP;
37 
38     event VIPPurchase(address indexed sender, address indexed recipient, uint ETH, uint VIP);
39 
40     modifier saleActive() {
41         if (address(legendsToken) == 0) {
42             throw;
43         }
44         if (block.timestamp < start) {
45             throw;
46         }
47         _;
48     }
49 
50     modifier hasValue() {
51         if (msg.value == 0) {
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
64     modifier isCreator() {
65         if (msg.sender != creator) {
66             throw;
67         }
68         _;
69     }
70 
71     modifier tokenContractNotSet() {
72         if (address(legendsToken) != 0) {
73             throw;
74         }
75         _;
76     }
77 
78     /**
79      * @dev Constructor.
80      * @param _exitAddress Address that all ETH should be forwarded to.
81      * @param _start Timestamp of when the crowdsale will start.
82      * @param _limitVIP Maximum amount of VIP that can be allocated in total. Denominated in wei.
83      */
84     function LegendsCrowdfund(address _exitAddress, uint _start, uint _limitVIP) {
85         creator = msg.sender;
86         exitAddress = _exitAddress;
87         start = _start;
88         limitVIP = _limitVIP;
89     }
90 
91     /**
92      * @dev Set the address of the token contract. Must be called by creator of this. Can only be set once.
93      * @param _legendsToken Address of the token contract.
94      */
95     function setTokenContract(LegendsToken _legendsToken) external isCreator tokenContractNotSet {
96         legendsToken = _legendsToken;
97     }
98 
99     /**
100      * @dev Forward Ether to the exit address. Store all ETH and VIP information in public state and logs.
101      * @param recipient Address that tokens should be attributed to.
102      */
103     function purchaseMembership(address sender, address recipient) external payable saleActive hasValue recipientIsValid(recipient) {
104 
105         if (msg.sender != address(legendsToken)) {
106             throw;
107         }
108         // Attempt to send the ETH to the exit address.
109         if (!exitAddress.send(msg.value)) {
110             throw;
111         }
112 
113         // Update ETH amounts.
114         recipientETH[recipient] += msg.value;
115         totalETH += msg.value;
116 
117         // Calculate VIP amount.
118         uint VIP = msg.value * 10;  // $1 / VIP based on $10 / ETH value.
119 
120         // Are we in the pre-sale?
121         if (block.timestamp - start < 2 weeks) {
122             VIP = (VIP * 10) / 9;   // 10% discount.
123         }
124 
125         // Update VIP amounts.
126         recipientVIP[recipient] += VIP;
127         totalVIP += VIP;
128 
129         // Check we have not exceeded the maximum VIP.
130         if (totalVIP > limitVIP) {
131             throw;
132         }
133 
134         // Tell the token contract about the increase.
135         legendsToken.addTokens(recipient, VIP);
136 
137         // Log this purchase.
138         VIPPurchase(sender, recipient, msg.value, VIP);
139     }
140 
141 }
142 
143 
144 /**
145  * @title LegendsToken
146  */
147 contract LegendsToken is ERC20 {
148     string public name = 'VIP';             //The Token's name: e.g. DigixDAO Tokens
149     uint8 public decimals = 18;             // 1Token ¨= 1$ (1ETH ¨= 10$)
150     string public symbol = 'VIP';           //An identifier: e.g. REP
151     string public version = 'VIP_0.1';
152 
153     mapping (address => uint) ownerVIP;
154     mapping (address => mapping (address => uint)) allowed;
155     uint public totalVIP;
156     uint public start;
157 
158     address public legendsCrowdfund;
159 
160     bool public testing;
161 
162     modifier fromCrowdfund() {
163         if (msg.sender != legendsCrowdfund) {
164             throw;
165         }
166         _;
167     }
168 
169     modifier isActive() {
170         if (block.timestamp < start) {
171             throw;
172         }
173         _;
174     }
175 
176     modifier isNotActive() {
177         if (!testing && block.timestamp >= start) {
178             throw;
179         }
180         _;
181     }
182 
183     modifier recipientIsValid(address recipient) {
184         if (recipient == 0 || recipient == address(this)) {
185             throw;
186         }
187         _;
188     }
189 
190     modifier allowanceIsZero(address spender, uint value) {
191         // To change the approve amount you first have to reduce the addresses´
192         // allowance to zero by calling `approve(_spender,0)` if it is not
193         // already 0 to mitigate the race condition described here:
194         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195         if ((value != 0) && (allowed[msg.sender][spender] != 0)) {
196             throw;
197         }
198         _;
199     }
200 
201     /**
202      * @dev Constructor.
203      * @param _legendsCrowdfund Address of crowdfund contract.
204      * @param _preallocation Address to receive the pre-allocation.
205      * @param _start Timestamp when the token becomes active.
206      */
207     function LegendsToken(address _legendsCrowdfund, address _preallocation, uint _start, bool _testing) {
208         legendsCrowdfund = _legendsCrowdfund;
209         start = _start;
210         testing = _testing;
211         totalVIP = ownerVIP[_preallocation] = 25000 ether;
212     }
213 
214     /**
215      * @dev Add to token balance on address. Must be from crowdfund.
216      * @param recipient Address to add tokens to.
217      * @return VIP Amount of VIP to add.
218      */
219     function addTokens(address recipient, uint VIP) external isNotActive fromCrowdfund {
220         ownerVIP[recipient] += VIP;
221         totalVIP += VIP;
222         Transfer(0x0, recipient, VIP);
223     }
224 
225     /**
226      * @dev Implements ERC20 totalSupply()
227      */
228     function totalSupply() constant returns (uint256 totalSupply) {
229         totalSupply = totalVIP;
230     }
231 
232     /**
233      * @dev Implements ERC20 balanceOf()
234      */
235     function balanceOf(address _owner) constant returns (uint256 balance) {
236         balance = ownerVIP[_owner];
237     }
238 
239     /**
240      * @dev Implements ERC20 transfer()
241      */
242     function transfer(address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
243         if (ownerVIP[msg.sender] >= _value) {
244             ownerVIP[msg.sender] -= _value;
245             ownerVIP[_to] += _value;
246             Transfer(msg.sender, _to, _value);
247             return true;
248         } else {
249             return false;
250         }
251     }
252 
253     /**
254      * @dev Implements ERC20 transferFrom()
255      */
256     function transferFrom(address _from, address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
257         if (allowed[_from][msg.sender] >= _value && ownerVIP[_from] >= _value) {
258             ownerVIP[_to] += _value;
259             ownerVIP[_from] -= _value;
260             allowed[_from][msg.sender] -= _value;
261             Transfer(_from, _to, _value);
262             return true;
263         } else {
264             return false;
265         }
266     }
267 
268     /**
269      * @dev Implements ERC20 approve()
270      */
271     function approve(address _spender, uint256 _value) isActive allowanceIsZero(_spender, _value) returns (bool success) {
272         allowed[msg.sender][_spender] = _value;
273         Approval(msg.sender, _spender, _value);
274         return true;
275     }
276 
277     /**
278      * @dev Implements ERC20 allowance()
279      */
280     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
281         remaining = allowed[_owner][_spender];
282     }
283 
284     /**
285      * @dev Direct Buy
286      */
287     function () payable {
288         LegendsCrowdfund(legendsCrowdfund).purchaseMembership.value(msg.value)(msg.sender, msg.sender);
289     }
290 
291     /**
292      * @dev Proxy Buy
293      */
294     function purchaseMembership(address recipient) payable {
295         LegendsCrowdfund(legendsCrowdfund).purchaseMembership.value(msg.value)(msg.sender, recipient);
296     }
297 
298 }