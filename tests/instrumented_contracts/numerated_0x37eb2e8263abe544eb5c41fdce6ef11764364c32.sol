1 pragma solidity ^0.4.9;
2 
3 
4 /***
5  * VIP Token and Crowdfunding contracts.
6  */
7 
8 
9 /**
10  * @title ERC20
11  */
12 contract ERC20 {
13     function totalSupply() constant returns (uint256 totalSupply);
14     function balanceOf(address _owner) constant returns (uint256 balance);
15     function transfer(address _to, uint256 _value) returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
17     function approve(address _spender, uint256 _value) returns (bool success);
18     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 /**
25  * @title LegendsCrowdfund
26  */
27 contract LegendsCrowdfund {
28 
29     address public creator;
30     address public exitAddress;
31 
32     uint public start;
33     uint public limitVIP;
34 
35     LegendsToken public legendsToken;
36 
37     mapping (address => uint) public recipientETH;
38     mapping (address => uint) public recipientVIP;
39 
40     uint public totalETH;
41     uint public totalVIP;
42 
43     event VIPPurchase(address indexed sender, address indexed recipient, uint ETH, uint VIP);
44 
45     modifier saleActive() {
46         if (address(legendsToken) == 0) {
47             throw;
48         }
49         if (block.timestamp < start) {
50             throw;
51         }
52         _;
53     }
54 
55     modifier hasValue() {
56         if (msg.value == 0) {
57             throw;
58         }
59         _;
60     }
61 
62     modifier recipientIsValid(address recipient) {
63         if (recipient == 0 || recipient == address(this)) {
64             throw;
65         }
66         _;
67     }
68 
69     modifier isCreator() {
70         if (msg.sender != creator) {
71             throw;
72         }
73         _;
74     }
75 
76     modifier tokenContractNotSet() {
77         if (address(legendsToken) != 0) {
78             throw;
79         }
80         _;
81     }
82 
83     /**
84      * @dev Constructor.
85      * @param _exitAddress Address that all ETH should be forwarded to.
86      * @param _start Timestamp of when the crowdsale will start.
87      * @param _limitVIP Maximum amount of VIP that can be allocated in total. Denominated in wei.
88      */
89     function LegendsCrowdfund(address _exitAddress, uint _start, uint _limitVIP) {
90         creator = msg.sender;
91         exitAddress = _exitAddress;
92         start = _start;
93         limitVIP = _limitVIP;
94     }
95 
96     /**
97      * @dev Set the address of the token contract. Must be called by creator of this. Can only be set once.
98      * @param _legendsToken Address of the token contract.
99      */
100     function setTokenContract(LegendsToken _legendsToken) external isCreator tokenContractNotSet {
101         legendsToken = _legendsToken;
102     }
103 
104     /**
105      * @dev Forward Ether to the exit address. Store all ETH and VIP information in public state and logs.
106      * @param recipient Address that tokens should be attributed to.
107      */
108     function purchaseMembership(address sender, address recipient) external payable saleActive hasValue recipientIsValid(recipient) {
109 
110         if (msg.sender != address(legendsToken)) {
111             throw;
112         }
113         // Attempt to send the ETH to the exit address.
114         if (!exitAddress.send(msg.value)) {
115             throw;
116         }
117 
118         // Update ETH amounts.
119         recipientETH[recipient] += msg.value;
120         totalETH += msg.value;
121 
122         // Calculate VIP amount.
123         uint VIP = msg.value * 10;  // $1 / VIP based on $10 / ETH value.
124 
125         // Are we in the pre-sale?
126         if (block.timestamp - start < 2 weeks) {
127             VIP = (VIP * 10) / 9;   // 10% discount.
128         }
129 
130         // Update VIP amounts.
131         recipientVIP[recipient] += VIP;
132         totalVIP += VIP;
133 
134         // Check we have not exceeded the maximum VIP.
135         if (totalVIP > limitVIP) {
136             throw;
137         }
138 
139         // Tell the token contract about the increase.
140         legendsToken.addTokens(recipient, VIP);
141 
142         // Log this purchase.
143         VIPPurchase(sender, recipient, msg.value, VIP);
144     }
145 
146 }
147 
148 
149 /**
150  * @title LegendsToken
151  */
152 contract LegendsToken is ERC20 {
153     string public name = 'VIP';             //The Token's name: e.g. DigixDAO Tokens
154     uint8 public decimals = 18;             // 1Token ¨= 1$ (1ETH ¨= 10$)
155     string public symbol = 'VIP';           //An identifier: e.g. REP
156     string public version = 'VIP_0.1';
157 
158     mapping (address => uint) ownerVIP;
159     mapping (address => mapping (address => uint)) allowed;
160     uint public totalVIP;
161     uint public start;
162 
163     address public legendsCrowdfund;
164 
165     bool public testing;
166 
167     modifier fromCrowdfund() {
168         if (msg.sender != legendsCrowdfund) {
169             throw;
170         }
171         _;
172     }
173 
174     modifier isActive() {
175         if (block.timestamp < start) {
176             throw;
177         }
178         _;
179     }
180 
181     modifier isNotActive() {
182         if (!testing && block.timestamp >= start) {
183             throw;
184         }
185         _;
186     }
187 
188     modifier recipientIsValid(address recipient) {
189         if (recipient == 0 || recipient == address(this)) {
190             throw;
191         }
192         _;
193     }
194 
195     modifier allowanceIsZero(address spender, uint value) {
196         // To change the approve amount you first have to reduce the addresses´
197         // allowance to zero by calling `approve(_spender,0)` if it is not
198         // already 0 to mitigate the race condition described here:
199         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200         if ((value != 0) && (allowed[msg.sender][spender] != 0)) {
201             throw;
202         }
203         _;
204     }
205 
206     /**
207      * @dev Constructor.
208      * @param _legendsCrowdfund Address of crowdfund contract.
209      * @param _preallocation Address to receive the pre-allocation.
210      * @param _start Timestamp when the token becomes active.
211      */
212     function LegendsToken(address _legendsCrowdfund, address _preallocation, uint _start, bool _testing) {
213         legendsCrowdfund = _legendsCrowdfund;
214         start = _start;
215         testing = _testing;
216         totalVIP = ownerVIP[_preallocation] = 25000 ether;
217     }
218 
219     /**
220      * @dev Add to token balance on address. Must be from crowdfund.
221      * @param recipient Address to add tokens to.
222      * @return VIP Amount of VIP to add.
223      */
224     function addTokens(address recipient, uint VIP) external isNotActive fromCrowdfund {
225         ownerVIP[recipient] += VIP;
226         totalVIP += VIP;
227         Transfer(0x0, recipient, VIP);
228     }
229 
230     /**
231      * @dev Implements ERC20 totalSupply()
232      */
233     function totalSupply() constant returns (uint256 totalSupply) {
234         totalSupply = totalVIP;
235     }
236 
237     /**
238      * @dev Implements ERC20 balanceOf()
239      */
240     function balanceOf(address _owner) constant returns (uint256 balance) {
241         balance = ownerVIP[_owner];
242     }
243 
244     /**
245      * @dev Implements ERC20 transfer()
246      */
247     function transfer(address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
248         if (ownerVIP[msg.sender] >= _value) {
249             ownerVIP[msg.sender] -= _value;
250             ownerVIP[_to] += _value;
251             Transfer(msg.sender, _to, _value);
252             return true;
253         } else {
254             return false;
255         }
256     }
257 
258     /**
259      * @dev Implements ERC20 transferFrom()
260      */
261     function transferFrom(address _from, address _to, uint256 _value) isActive recipientIsValid(_to) returns (bool success) {
262         if (allowed[_from][msg.sender] >= _value && ownerVIP[_from] >= _value) {
263             ownerVIP[_to] += _value;
264             ownerVIP[_from] -= _value;
265             allowed[_from][msg.sender] -= _value;
266             Transfer(_from, _to, _value);
267             return true;
268         } else {
269             return false;
270         }
271     }
272 
273     /**
274      * @dev Implements ERC20 approve()
275      */
276     function approve(address _spender, uint256 _value) isActive allowanceIsZero(_spender, _value) returns (bool success) {
277         allowed[msg.sender][_spender] = _value;
278         Approval(msg.sender, _spender, _value);
279         return true;
280     }
281 
282     /**
283      * @dev Implements ERC20 allowance()
284      */
285     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
286         remaining = allowed[_owner][_spender];
287     }
288 
289     /**
290      * @dev Direct Buy
291      */
292     function () payable {
293         LegendsCrowdfund(legendsCrowdfund).purchaseMembership.value(msg.value)(msg.sender, msg.sender);
294     }
295 
296     /**
297      * @dev Proxy Buy
298      */
299     function purchaseMembership(address recipient) payable {
300         LegendsCrowdfund(legendsCrowdfund).purchaseMembership.value(msg.value)(msg.sender, recipient);
301     }
302 
303 }