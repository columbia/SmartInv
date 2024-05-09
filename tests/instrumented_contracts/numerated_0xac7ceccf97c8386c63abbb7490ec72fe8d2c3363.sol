1 pragma solidity ^0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal constant returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract BasicAccountInfo {
33     using SafeMath for uint;
34 
35     address constant public creatorAddress = 0xcDee178ed5B1968549810A237767ec388a3f83ba;
36     address constant public ecologyAddress = 0xe87C12E6971AAf04DB471e5f93629C8B6F31b8C2;
37     address constant public investorAddress = 0x660363e67485D2B51C071f42421b3DD134D3A835;
38     address constant public partnerAddress = 0xabcf257c90dfE5E3b5Fcd777797213F36F9aB25e;
39 
40     struct BasicAccount {
41         uint256 initialBalance;
42         uint256 frozenBalance;
43         uint256 availableBalance;
44     }
45 
46     mapping (address => BasicAccount) public accountInfoMap;
47 
48     uint8 private frozenRatio = 60;
49     uint8 private frozenRatioUnit = 100;
50 
51     address public owner;   //contract create by owner
52 
53     function BasicAccountInfo(uint8 _decimal) public {
54         owner = msg.sender;
55 
56         initialCreatorAccount(_decimal);
57         initialEcologyAccount(_decimal);
58         initialInvestorAccount(_decimal);
59         initialPartnerAccount(_decimal);
60     }
61 
62     function initialCreatorAccount(uint8 _decimal) private {
63         uint256 creatorInitialBalance = 37500000 * (10**(uint256(_decimal)));
64         uint256 creatorFrozenBalance = creatorInitialBalance * uint256(frozenRatio) / uint256(frozenRatioUnit);
65         uint256 creatorAvailableBalance = creatorInitialBalance - creatorFrozenBalance;
66 
67         accountInfoMap[creatorAddress] = BasicAccount(creatorInitialBalance, creatorFrozenBalance, creatorAvailableBalance);
68     }
69 
70     function initialEcologyAccount(uint8 _decimal) private {
71         uint256 ecologyInitialBalance = 25000000 * (10**(uint256(_decimal)));
72         uint256 ecologyFrozenBalance = ecologyInitialBalance * uint256(frozenRatio) / uint256(frozenRatioUnit);
73         uint256 ecologyAvailableBalance = ecologyInitialBalance - ecologyFrozenBalance;
74 
75         accountInfoMap[ecologyAddress] = BasicAccount(ecologyInitialBalance, ecologyFrozenBalance, ecologyAvailableBalance);
76     }
77 
78     function initialInvestorAccount(uint8 _decimal) private {
79         uint256 investorInitialBalance = 37500000 * (10**(uint256(_decimal)));
80         uint256 investorFrozenBalance = investorInitialBalance * uint256(frozenRatio) / uint256(frozenRatioUnit);
81         uint256 investorAvailableBalance = investorInitialBalance - investorFrozenBalance;
82 
83         accountInfoMap[investorAddress] = BasicAccount(investorInitialBalance, investorFrozenBalance, investorAvailableBalance);
84     }
85 
86     function initialPartnerAccount(uint8 _decimal) private {
87         uint256 partnerInitialBalance = 25000000 * (10**(uint256(_decimal)));
88         uint256 partnerFrozenBalance = partnerInitialBalance * uint256(frozenRatio) / uint256(frozenRatioUnit);
89         uint256 partnerAvailableBalance = partnerInitialBalance - partnerFrozenBalance;
90 
91         accountInfoMap[partnerAddress] = BasicAccount(partnerInitialBalance, partnerFrozenBalance, partnerAvailableBalance);
92     }
93 
94     function getTotalFrozenBalance() public view returns (uint256 totalFrozenBalance) {
95         return accountInfoMap[creatorAddress].frozenBalance + accountInfoMap[ecologyAddress].frozenBalance +
96                         accountInfoMap[investorAddress].frozenBalance + accountInfoMap[partnerAddress].frozenBalance;
97     }
98 
99     function getInitialBalanceByAddress(address _address) public view returns (uint256 initialBalance) {
100         BasicAccount basicAccount = accountInfoMap[_address];
101         return basicAccount.initialBalance;
102     }
103 
104     function getAvailableBalanceByAddress(address _address) public view returns (uint256 availableBalance) {
105         BasicAccount basicAccount = accountInfoMap[_address];
106         return basicAccount.availableBalance;
107     }
108 
109     function getFrozenBalanceByAddress(address _address) public view returns (uint256 frozenBalance) {
110         BasicAccount basicAccount = accountInfoMap[_address];
111         return basicAccount.frozenBalance;
112     }
113 
114     function releaseFrozenBalance() public {
115         require(owner == msg.sender);
116 
117         accountInfoMap[creatorAddress].availableBalance = accountInfoMap[creatorAddress].availableBalance.add(accountInfoMap[creatorAddress].frozenBalance);
118         accountInfoMap[ecologyAddress].availableBalance = accountInfoMap[ecologyAddress].availableBalance.add(accountInfoMap[ecologyAddress].frozenBalance);
119         accountInfoMap[investorAddress].availableBalance = accountInfoMap[investorAddress].availableBalance.add(accountInfoMap[investorAddress].frozenBalance);
120         accountInfoMap[partnerAddress].availableBalance = accountInfoMap[partnerAddress].availableBalance.add(accountInfoMap[partnerAddress].frozenBalance);
121 
122         accountInfoMap[creatorAddress].frozenBalance = 0;
123         accountInfoMap[ecologyAddress].frozenBalance = 0;
124         accountInfoMap[investorAddress].frozenBalance = 0;
125         accountInfoMap[partnerAddress].frozenBalance = 0;
126     }
127 }
128 
129 contract ERC20Interface {
130     uint256 public totalSupply;
131 
132     function balanceOf(address _owner) public view returns (uint256 balance);
133     function transfer(address _to, uint256 _value) public returns (bool success);
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
135     function approve(address _spender, uint256 _value) public returns (bool success);
136     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
137 
138     event Transfer(address indexed _from, address indexed _to, uint256 _value);
139     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
140 }
141 
142 contract ERC20 is ERC20Interface {
143     using SafeMath for uint;
144 
145     uint256 constant private MAX_UINT256 = 2**256 - 1;
146     mapping (address => uint256) private balances;
147     mapping (address => mapping (address => uint256)) public allowed;
148     uint256 public totalAvailable;
149 
150     bool public transfersEnabled;
151     BasicAccountInfo private basicAccountInfo;
152     address public owner;   //contract create by owner
153 
154     bool public released;
155     uint256 public frozenTime;  //second
156     uint256 public releaseTime;  //second
157     uint256 constant private frozenPeriod = 100;  //days
158     
159     event Release(address indexed _owner);
160 
161     function ERC20(uint8 decimals) public {
162         totalSupply = 250000000 * (10**(uint256(decimals)));
163         transfersEnabled = true;
164         released = false;
165 
166         owner = msg.sender;
167         basicAccountInfo = new BasicAccountInfo(decimals);
168 
169         InitialBasicBalance();
170         initialFrozenTime();
171     }
172 
173     function InitialBasicBalance() private {
174         totalAvailable = totalSupply - basicAccountInfo.getTotalFrozenBalance();
175         balances[owner] = totalSupply.div(2);
176         
177         balances[basicAccountInfo.creatorAddress()] = basicAccountInfo.getAvailableBalanceByAddress(basicAccountInfo.creatorAddress());
178         balances[basicAccountInfo.ecologyAddress()] = basicAccountInfo.getAvailableBalanceByAddress(basicAccountInfo.ecologyAddress());
179         balances[basicAccountInfo.investorAddress()] =basicAccountInfo.getAvailableBalanceByAddress(basicAccountInfo.investorAddress());
180         balances[basicAccountInfo.partnerAddress()] = basicAccountInfo.getAvailableBalanceByAddress(basicAccountInfo.partnerAddress());
181     }
182 
183     function releaseBasicAccount() private {
184         balances[basicAccountInfo.creatorAddress()] += basicAccountInfo.getFrozenBalanceByAddress(basicAccountInfo.creatorAddress());
185         balances[basicAccountInfo.ecologyAddress()] += basicAccountInfo.getFrozenBalanceByAddress(basicAccountInfo.ecologyAddress());
186         balances[basicAccountInfo.investorAddress()] +=basicAccountInfo.getFrozenBalanceByAddress(basicAccountInfo.investorAddress());
187         balances[basicAccountInfo.partnerAddress()] += basicAccountInfo.getFrozenBalanceByAddress(basicAccountInfo.partnerAddress());
188 
189         totalAvailable += basicAccountInfo.getTotalFrozenBalance();
190     }
191 
192     function releaseToken() public returns (bool) {
193         require(owner == msg.sender);
194 
195         if(released){
196             return false;
197         }
198 
199         if(block.timestamp > releaseTime) {
200             releaseBasicAccount();
201             basicAccountInfo.releaseFrozenBalance();
202             released = true;
203             emit Release(owner);
204             return true;
205         }
206 
207         return false;
208     }
209 
210     function getFrozenBalanceByAddress(address _address) public view returns (uint256 frozenBalance) {
211         return basicAccountInfo.getFrozenBalanceByAddress(_address);
212     }
213 
214     function getInitialBalanceByAddress(address _address) public view returns (uint256 initialBalance) {
215         return basicAccountInfo.getInitialBalanceByAddress(_address);
216     }
217 
218     function getTotalFrozenBalance() public view returns (uint256 totalFrozenBalance) {
219         return basicAccountInfo.getTotalFrozenBalance();
220     }
221 
222     function transfer(address _to, uint256 _value) public returns (bool success) {
223         require(transfersEnabled);
224 
225         require(_to != 0x0);
226         require(balances[msg.sender] >= _value);
227         require((balances[_to] + _value )> balances[_to]);
228 
229         balances[msg.sender] = balances[msg.sender].sub(_value);
230         balances[_to] = balances[_to].add(_value);
231 
232         emit Transfer(msg.sender, _to, _value);
233 
234         return true;
235     }
236 
237     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
238         require(transfersEnabled);
239         require(_from != 0x0);
240         require(_to != 0x0);
241 
242         uint256 allowance = allowed[_from][msg.sender];
243         require(balances[_from] >= _value && allowance >= _value);
244 
245         balances[_to] = balances[_to].add(_value);
246         balances[_from] = balances[_from].sub(_value);
247 
248         if (allowance < MAX_UINT256) {
249             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250         }
251 
252         emit Transfer(_from, _to, _value);
253         return true;
254     }
255 
256     function balanceOf(address _owner) public view returns (uint256 balance) {
257         return balances[_owner];
258     }
259 
260     function approve(address _spender, uint256 _value) public returns (bool success) {
261         allowed[msg.sender][_spender] = _value;
262         emit Approval(msg.sender, _spender, _value);
263         return true;
264     }
265 
266     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
267         return allowed[_owner][_spender];
268     }
269 
270     function enableTransfers(bool _transfersEnabled) {
271         require(owner == msg.sender);
272         transfersEnabled = _transfersEnabled;
273     }
274 
275     function initialFrozenTime() private {
276         frozenTime = block.timestamp;
277         uint256 secondsPerDay = 3600 * 24;
278         releaseTime = frozenPeriod * secondsPerDay  + frozenTime;
279     }
280 }
281 
282 contract BiTianToken is ERC20 {
283     string public name = "Bitian Token";
284     string public symbol = "BTT";
285     string public version = '1.0.0';
286     uint8 public decimals = 18;
287 
288     /**
289      * @dev Function to check the amount of tokens that an owner allowed to a spender.
290      */
291     function BiTianToken() ERC20(decimals) {
292     }
293 }