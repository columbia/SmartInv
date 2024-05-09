1 pragma solidity 0.4.20;
2 
3 contract PapereumTokenBridge {
4     function makeNonFungible(uint256 amount, address owner) public;
5     function token() public returns (PapereumToken);
6 }
7 
8 
9 contract PapereumToken {
10 
11     string public name = "Papereum";
12     string public symbol = "PPRM";
13     uint256 public decimals = 0; // Papereum tokens are not divisible
14     uint256 public totalSupply = 100000; // Only 100 000 Non-divisable pieces of Art
15 
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     bool public isTradable = false;
23 
24     address public owner = address(0);
25     PapereumTokenBridge public bridge;
26 
27     function PapereumToken() public {
28         owner = msg.sender;
29         balanceOf[owner] = totalSupply;
30         Transfer(address(0), owner, totalSupply);
31     }
32 
33     function setBridge(address _bridge) public {
34         require(msg.sender == owner);
35         require(isTradable);
36         require(_bridge != address(0));
37         require(bridge == address(0));
38         bridge = PapereumTokenBridge(_bridge);
39         require(bridge.token() == this);
40     }
41 
42     function transfer(address _to, uint256 _value) public returns (bool success) {
43         require(isTradable || msg.sender == owner);
44         require(_to != address(0));
45         require(balanceOf[msg.sender] >= _value);
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47         balanceOf[msg.sender] -= _value;
48         balanceOf[_to] += _value;
49         if (_to == address(bridge)) {
50             bridge.makeNonFungible(_value, msg.sender);
51         }
52         Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         require(isTradable);
58         require(_to != address(0));
59         require(balanceOf[_from] >= _value);
60         require(balanceOf[_to] + _value >= balanceOf[_to]);
61         require(allowance[_from][msg.sender] >= _value);
62         balanceOf[_from] -= _value;
63         balanceOf[_to] += _value;
64         allowance[_from][msg.sender] -= _value;
65         if (_to == address(bridge)) {
66             bridge.makeNonFungible(_value, msg.sender); // Caller takes ownership of trackable tokens
67         }
68         Transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool) {
73         allowance[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
79         require(allowance[msg.sender][_spender] + _addedValue >= allowance[msg.sender][_spender]);
80         allowance[msg.sender][_spender] = allowance[msg.sender][_spender] + _addedValue;
81         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
82         return true;
83     }
84 
85     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
86         uint oldValue = allowance[msg.sender][_spender];
87         if (_subtractedValue > oldValue) {
88             allowance[msg.sender][_spender] = 0;
89         } else {
90             allowance[msg.sender][_spender] = oldValue - _subtractedValue;
91         }
92         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
93         return true;
94     }
95 
96     function burn(address newOwner) public returns (bool success) {
97         require(msg.sender == owner);
98         require(!isTradable);
99         require(newOwner != address(0));
100         uint256 value = balanceOf[owner];
101         balanceOf[owner] = 0;
102         totalSupply -= value;
103         isTradable = true;
104         Transfer(owner, address(0), value);
105         owner = newOwner;
106         return true;
107     }
108 
109     function transferOwnership(address newOwner) public {
110         require(msg.sender == owner);
111         require(newOwner != address(0));
112         owner = newOwner;
113     }
114 
115 }
116 
117 
118 contract PapereumCrowdsale {
119     // Wallet where all ether will be
120     address public constant WALLET = 0xE77E35a07794761277870521C80d1cA257383292;
121     // Wallet for team tokens
122     address public constant TEAM_WALLET = 0x5C31f06b4AAC5D5c84Fd7735971B951d7E5104A0;
123     // Wallet for media support tokens
124     address public constant MEDIA_SUPPORT_WALLET = 0x8E6618e41879d8BE1F7a0E658294E8A1359e4383;
125 
126     uint256 public constant ICO_TOKENS = 93000;
127     uint32 public constant ICO_TOKENS_PERCENT = 93;
128     uint32 public constant TEAM_TOKENS_PERCENT = 2;
129     uint32 public constant MEDIA_SUPPORT_PERCENT = 5;
130     uint256 public constant START_TIME = 1518998400; // 2018/02/19 00:00 UTC +0
131     uint256 public constant END_TIME = 1525046400; // 2018/04/30 00:00 UTC +0
132     uint256 public constant RATE = 1e16; // 100 tokens costs 1 ether
133 
134     // The token being sold
135     PapereumToken public token;
136     // amount of raised money in wei
137     uint256 public weiRaised;
138     bool public isFinalized = false;
139     address private tokenMinter;
140     address public owner;
141     uint256 private icoBalance = ICO_TOKENS;
142 
143     event Progress(uint256 tokensSold, uint256 weiRaised);
144 
145     event Finalized();
146     /**
147     * When there no tokens left to mint and token minter tries to manually mint tokens
148     * this event is raised to signal how many tokens we have to charge back to purchaser
149     */
150     event ManualTokenMintRequiresRefund(address indexed purchaser, uint256 value);
151 
152     function PapereumCrowdsale() public {
153         token = new PapereumToken();
154         owner = msg.sender;
155         tokenMinter = msg.sender;
156     }
157 
158     // fallback function can be used to buy tokens or claim refund
159     function () external payable {
160         buyTokens(msg.sender);
161     }
162 
163     function assignTokens(address[] _receivers, uint256[] _amounts) external {
164         require(msg.sender == tokenMinter || msg.sender == owner);
165         require(_receivers.length > 0 && _receivers.length <= 100);
166         require(_receivers.length == _amounts.length);
167         require(!isFinalized);
168         for (uint256 i = 0; i < _receivers.length; i++) {
169             address receiver = _receivers[i];
170             uint256 amount = _amounts[i];
171 
172             require(receiver != address(0));
173             require(amount > 0);
174 
175             uint256 excess = appendContribution(receiver, amount);
176 
177             if (excess > 0) {
178                 ManualTokenMintRequiresRefund(receiver, excess);
179             }
180         }
181         Progress(ICO_TOKENS - icoBalance, weiRaised);
182     }
183 
184     function buyTokens(address beneficiary) private {
185         require(beneficiary != address(0));
186         require(validPurchase());
187 
188         uint256 weiReceived = msg.value;
189 
190         uint256 tokens;
191         uint256 refund;
192         (tokens, refund) = calculateTokens(weiReceived);
193 
194         uint256 excess = appendContribution(beneficiary, tokens);
195         refund += (excess > 0 ? ((excess * weiReceived) / tokens) : 0);
196 
197         tokens -= excess;
198         weiReceived -= refund;
199         weiRaised += weiReceived;
200 
201         if (refund > 0) {
202             msg.sender.transfer(refund);
203         }
204 
205         WALLET.transfer(weiReceived);
206         Progress(ICO_TOKENS - icoBalance, weiRaised);
207     }
208 
209     /**
210     * @dev Must be called after crowdsale ends, to do some extra finalization
211     * work. Calls the contract's finalization function.
212     */
213     function finalize() public {
214         require(msg.sender == owner);
215         require(!isFinalized);
216         require(getNow() > END_TIME || icoBalance == 0);
217         isFinalized = true;
218 
219         uint256 totalSoldTokens = ICO_TOKENS - icoBalance;
220 
221         uint256 teamTokens = (TEAM_TOKENS_PERCENT * totalSoldTokens) / ICO_TOKENS_PERCENT;
222         token.transfer(TEAM_WALLET, teamTokens);
223         uint256 mediaTokens = (MEDIA_SUPPORT_PERCENT * totalSoldTokens) / ICO_TOKENS_PERCENT;
224         token.transfer(MEDIA_SUPPORT_WALLET, mediaTokens);
225 
226         token.burn(owner);
227 
228         Finalized();
229     }
230 
231     function setTokenMinter(address _tokenMinter) public {
232         require(msg.sender == owner);
233         require(_tokenMinter != address(0));
234         tokenMinter = _tokenMinter;
235     }
236 
237     function getNow() internal view returns (uint256) {
238         return now;
239     }
240 
241     function calculateTokens(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 refundWei) {
242         tokens = _weiAmount / RATE;
243         refundWei = _weiAmount - (tokens * RATE);
244         uint256 now_ = getNow();
245         uint256 bonus = 0;
246 
247         if (now_ < 1519603200) { // 26-02-2018
248             if (tokens >= 2000) bonus = 30;
249             else if (tokens >= 500) bonus = 25;
250             else if (tokens >= 50) bonus = 20;
251             else if (tokens >= 10) bonus = 10;
252         } else if (now_ < 1521417600) { // 19-03-2018
253             if (tokens >= 10) bonus = 7;
254         } else if (now_ < 1522627200) { // 02-04-2018
255             if (tokens >= 10) bonus = 5;
256         } else if (now_ < 1523232000) { // 09-04-2018
257             if (tokens >= 10) bonus = 3;
258         }
259 
260         tokens += (tokens * bonus) / 100; // with totalSupply <= 100000 and decimals=0 no need in SafeMath
261     }
262 
263     function appendContribution(address _beneficiary, uint256 _tokens) internal returns (uint256 excess) {
264         excess = 0;
265         require(_tokens >= 10);
266         if (_tokens > icoBalance) {
267             excess = icoBalance - _tokens;
268             _tokens = icoBalance;
269         }
270         if (_tokens > 0) {
271             icoBalance -= _tokens;
272             token.transfer(_beneficiary, _tokens);
273         }
274     }
275 
276     // @return true if the transaction can buy tokens
277     function validPurchase() internal view returns (bool) {
278         bool withinPeriod = getNow() >= START_TIME && getNow() <= END_TIME;
279         bool nonZeroPurchase = msg.value != 0;
280         bool canTransfer = icoBalance > 0;
281         return withinPeriod && nonZeroPurchase && canTransfer;
282     }
283 
284     function transferOwnership(address newOwner) public {
285         require(msg.sender == owner);
286         require(newOwner != address(0));
287         owner = newOwner;
288     }
289 }