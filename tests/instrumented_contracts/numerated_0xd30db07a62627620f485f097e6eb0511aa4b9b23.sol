1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 
24 contract ExtFueldToken {
25     using SafeMath for uint256;
26 // ownable
27     address public owner;
28     address public mainContract;
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36     function transferOwnership(address newOwner) onlyOwner public {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 // self transfer
43     mapping(address => uint256) balances;
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     function transfer(address _to, uint256 _value) public returns (bool) {
46         require(_to != address(0));
47         balances[msg.sender] = balances[msg.sender].sub(_value);
48         balances[_to] = balances[_to].add(_value);
49         Transfer(msg.sender, _to, _value);
50         return true;
51     }
52     function balanceOf(address _owner) public constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56 // allowed transfer
57     mapping (address => mapping (address => uint256)) allowed;
58     event Approval(address indexed owner_, address indexed spender, uint256 value);
59     function approve(address _spender, uint256 _value) public returns (bool) {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
65         return allowed[_owner][_spender];
66     }
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69         uint256 _allowance = allowed[_from][msg.sender];
70         balances[_from] = balances[_from].sub(_value);
71         balances[_to] = balances[_to].add(_value);
72         allowed[_from][msg.sender] = _allowance.sub(_value);
73         Transfer(_from, _to, _value);
74         return true;
75     }
76     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
77         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
78         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
79         return true;
80     }
81     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
82         uint oldValue = allowed[msg.sender][_spender];
83         if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0; } 
84         else {allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue); }
85         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86         return true;
87     }
88 
89 // mintable
90     uint256 public totalSupply = 13500000; // minting in constructor
91 // sale
92     mapping (address => uint256) public privatePreICOdepositors;
93     mapping (address => uint256) public preICOdepositors;
94     mapping (address => uint256) public ICOdepositors;
95     mapping (address => uint256) public ICObalances;
96     mapping (address => uint256) public depositorCurrency;
97     
98     uint256 constant public maxPreICOSupply = 13500000; // including free bonus tokens
99     uint256 constant public maxPreICOandICOSupply = 13500000;
100     uint256 public startTimePrivatePreICO = 0;
101     uint256 public startTimePreICO = 0;
102     uint256 public startTimeICO = 0;
103     uint256 public soldTokenCount = 0;
104     uint256 public cap = 0;
105     uint256 public capPreICO = 0;
106     uint256 public capPreICOTrasferred = 0;
107     uint256 public capETH = 0;
108 
109     // sale
110     event SaleStatus(string indexed status, uint256 indexed _date);
111 
112     function startPrivatePreICO() onlyOwner public {
113         require(startTimeICO == 0 && startTimePreICO == 0);
114         startTimePreICO = now;
115         startTimePrivatePreICO = startTimePreICO;
116         SaleStatus('Private Pre ICO started', startTimePreICO);
117     }
118     
119     function startPreICO() onlyOwner public {
120         require(startTimeICO == 0 && startTimePreICO == 0);
121         startTimePreICO = now;
122         SaleStatus('Public Pre ICO started', startTimePreICO);
123     }
124 
125     function startICO() onlyOwner public {
126         require(startTimeICO == 0 && startTimePreICO == 0);
127         startTimeICO = now;
128         SaleStatus('start ICO', startTimePreICO);
129     }
130 
131     function stopSale() onlyOwner public {
132         require(startTimeICO > 0 || startTimePreICO > 0);
133         if (startTimeICO > 0){
134             SaleStatus('ICO stopped', now);
135         }
136         else{
137             capPreICO = 0;
138             SaleStatus('Pre ICO stopped', now);
139         }
140         startTimeICO = 0;
141         startTimePreICO = 0;
142         startTimePrivatePreICO = 0;
143     }
144 
145     event ExtTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 currencyCode, uint256 amount);
146     function buyTokens(address beneficiary_, uint256 fiatAmount_, uint256 currencyCode_, uint256 amountETH_, uint256 tokensAmount_) onlyOwner public { 
147         require(startTimeICO > 0 || startTimePreICO > 0);
148         require(msg.sender != address(0));
149         
150         address depositor = beneficiary_;
151         uint256 deposit = fiatAmount_;
152         uint256 currencyCode = currencyCode_;
153         uint256 amountETH = amountETH_;
154         uint256 tokens = tokensAmount_;
155 
156         balances[owner] = balances[owner].sub(tokens);
157         balances[depositor] = balances[depositor].add(tokens);
158         depositorCurrency[depositor] = currencyCode;
159         soldTokenCount = soldTokenCount.add(tokens);
160         capETH = capETH.add(amountETH);
161         if (startTimeICO > 0){
162             ICObalances[depositor] = ICObalances[depositor].add(tokens);
163         }
164 
165         if (startTimeICO > 0){
166             ICOdepositors[depositor] = ICOdepositors[depositor].add(deposit);
167         }
168         else{
169             if(startTimePrivatePreICO > 0) {
170                 privatePreICOdepositors[depositor] = privatePreICOdepositors[depositor].add(deposit);
171             }
172             else {
173                 preICOdepositors[depositor] = preICOdepositors[depositor].add(deposit);
174             }
175         }
176         cap = cap.add(deposit);
177         if(startTimePreICO > 0) {
178             capPreICO = capPreICO.add(deposit);
179         }
180 
181         FueldToken FueldTokenExt = FueldToken(mainContract);
182         FueldTokenExt.extBuyTokens(depositor, tokens, amountETH); 
183         ExtTokenPurchase(owner, depositor, deposit, currencyCode, tokens);
184     }
185 
186     event FixSale(uint256 fixTime);
187     bool public fixSaleCompleted = false;
188     function fixSale() onlyOwner public {
189         require(startTimeICO == 0 && startTimePreICO == 0);
190         uint256 currentTime = now;
191         soldTokenCount = 0;
192         fixSaleCompleted = true;
193         FixSale(currentTime);
194     }
195 
196 // burnable
197     event Burn(address indexed burner, uint indexed value);
198     function burn(uint _value) onlyOwner public {
199         require(fixSaleCompleted == true);
200         require(_value > 0);
201         address burner = msg.sender;
202         balances[burner] = balances[burner].sub(_value);
203         totalSupply = totalSupply.sub(_value);
204         fixSaleCompleted = false;
205         Burn(burner, _value);
206     }
207 
208 // constructor
209     string constant public name = "EXTFUELD";
210     string constant public symbol = "EFL";
211     uint32 constant public decimals = 18;
212 
213     function setMainContractAddress(address mainContract_) onlyOwner public {
214         mainContract = mainContract_;
215     }
216 
217     function ExtFueldToken() public {
218         owner = msg.sender;
219         balances[owner] = totalSupply;
220     }
221 }
222 
223 contract FueldToken{
224     function extBuyTokens(address beneficiary_, uint256 tokensAmount_, uint256 amountETH_) public { 
225         require(beneficiary_ != address(0));
226         require(tokensAmount_ != 0);
227         require(amountETH_ != 0);
228     }
229 }