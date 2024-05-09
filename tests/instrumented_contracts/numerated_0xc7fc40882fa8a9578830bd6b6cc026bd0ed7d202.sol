1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract MultiOwnable {
11     address[] public owners;
12 
13     function ownersCount() public view returns(uint256) {
14         return owners.length;
15     }
16 
17     event OwnerAdded(address indexed owner);
18     event OwnerRemoved(address indexed owner);
19 
20     constructor() public {
21         owners.push(msg.sender);
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner(msg.sender));
29         _;
30     }
31 
32     function isOwner(address addr) public view returns (bool) {
33         bool _isOwner = false;
34         for (uint i=0; i<owners.length; i++) {
35             if (addr == owners[i]) {
36                 _isOwner = true;
37                 break;
38             }
39         }
40         return _isOwner;
41     }
42 
43     function addOwner(address owner) public onlyOwner {
44         require(owner != address(0));
45         require(!isOwner(owner));
46         owners.push(owner);
47         emit OwnerAdded(owner);
48     }
49     function removeOwner(address owner) public onlyOwner {
50         require(owner != address(0));
51         require(owner != msg.sender);
52         bool wasDeleted = false;
53         for (uint i=0; i<owners.length; i++) {
54             if (owners[i] == owner) {
55                 if (i < owners.length-1) {
56                     owners[i] = owners[owners.length-1];
57                 }
58                 owners.length--;
59                 wasDeleted = true;
60             }
61         }
62         require(wasDeleted);
63         emit OwnerRemoved(owner);
64     }
65 
66 }
67 
68 contract AigoTokensale is MultiOwnable {
69 
70   struct InvestorPayment {
71     uint256 time;
72     uint256 value;
73     uint8 currency;
74     uint256 tokens;
75   }
76 
77   struct Investor {
78     bool isActive;
79     InvestorPayment[] payments;
80     bool needUpdate;
81   }
82 
83   event InvestorAdded(address indexed investor);
84   event TokensaleFinishTimeChanged(uint256 oldTime, uint256 newTime);
85   event Payment(address indexed investor, uint256 value, uint8 currency);
86   event Delivered(address indexed investor, uint256 amount);
87   event TokensaleFinished(uint256 tokensSold, uint256 tokensReturned);
88 
89   ERC20Basic public token;
90   uint256 public finishTime;
91   address vaultWallet;
92 
93   UserWallet[] public investorList;
94   mapping(address => Investor) investors;
95 
96   function investorsCount() public view returns (uint256) {
97     return investorList.length;
98   }
99   function investorInfo(address investorAddress) public view returns (bool, bool, uint256, uint256) {
100     Investor storage investor = investors[investorAddress];
101     uint256 investorTokens = 0;
102     for (uint i=0; i<investor.payments.length; i++) {
103       investorTokens += investor.payments[i].tokens;
104     }
105     return (investor.isActive, investor.needUpdate, investor.payments.length, investorTokens);
106   }
107   function investorPayment(address investor, uint index) public view returns (uint256,  uint256, uint8, uint256) {
108     InvestorPayment storage payment = investors[investor].payments[index];
109     return (payment.time, payment.value, payment.currency, payment.tokens);
110   }
111   function totalTokens() public view returns (uint256) {
112     return token.balanceOf(this);
113   }
114 
115   constructor(ERC20Basic _token, uint256 _finishTime, address _vaultWallet) MultiOwnable() public {
116     require(_token != address(0));
117     require(_finishTime > now);
118     require(_vaultWallet != address(0));
119     token = _token;
120     finishTime = _finishTime;
121     vaultWallet = _vaultWallet;
122   }
123 
124   function setFinishTime(uint256 _finishTime) public onlyOwner {
125     uint256 oldTime = finishTime;
126     finishTime = _finishTime;
127     emit TokensaleFinishTimeChanged(oldTime, finishTime);
128   }
129 
130   function postWalletPayment(uint256 value) public {
131     require(now < finishTime);
132     Investor storage investor = investors[msg.sender];
133     require(investor.isActive);
134     investor.payments.push(InvestorPayment(now, value, 0, 0));
135     investor.needUpdate = true;
136     emit Payment(msg.sender, value, 0);
137   }
138 
139   function postExternalPayment(address investorAddress, uint256 time, uint256 value, uint8 currency, uint256 tokenAmount) public onlyOwner {
140     require(investorAddress != address(0));
141     require(time <= now);
142     require(now < finishTime);
143     Investor storage investor = investors[investorAddress];
144     require(investor.isActive);
145     investor.payments.push(InvestorPayment(time, value, currency, tokenAmount));
146     emit Payment(msg.sender, value, currency);
147   }
148 
149   function updateTokenAmount(address investorAddress, uint256 paymentIndex, uint256 tokenAmount) public onlyOwner {
150     Investor storage investor = investors[investorAddress];
151     require(investor.isActive);
152     investor.needUpdate = false;
153     investor.payments[paymentIndex].tokens = tokenAmount;
154   }
155 
156   function addInvestor(address _payoutAddress) public onlyOwner {
157     UserWallet wallet = new UserWallet(_payoutAddress, vaultWallet);
158     investorList.push(wallet);
159     investors[wallet].isActive = true;
160     emit InvestorAdded(wallet);
161   }
162 
163   function deliverTokens(uint limit) public onlyOwner {
164     require(now > finishTime);
165     uint counter = 0;
166     uint256 tokensDelivered = 0;
167     for (uint i = 0; i < investorList.length && counter < limit; i++) {
168       UserWallet investorAddress = investorList[i];
169       Investor storage investor = investors[investorAddress];
170       require(!investor.needUpdate);
171       uint256 investorTokens = 0;
172       for (uint j=0; j<investor.payments.length; j++) {
173         investorTokens += investor.payments[j].tokens;
174       }
175       if (investor.isActive) {
176         counter = counter + 1;
177         require(token.transfer(investorAddress, investorTokens));
178         investorAddress.onDelivery();
179         investor.isActive = false;
180         emit Delivered(investorAddress, investorTokens);
181       }
182       tokensDelivered = tokensDelivered + investorTokens;
183     }
184     if (counter < limit) {
185       uint256 tokensLeft = token.balanceOf(this);
186       if (tokensLeft > 0) {
187         require(token.transfer(vaultWallet, tokensLeft));
188       }
189       emit TokensaleFinished(tokensDelivered, tokensLeft);
190     }
191   }
192 
193 }
194 
195 library SafeMath {
196 
197   /**
198   * @dev Multiplies two numbers, throws on overflow.
199   */
200   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
201     if (a == 0) {
202       return 0;
203     }
204     c = a * b;
205     assert(c / a == b);
206     return c;
207   }
208 
209   /**
210   * @dev Integer division of two numbers, truncating the quotient.
211   */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     // assert(b > 0); // Solidity automatically throws when dividing by 0
214     // uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216     return a / b;
217   }
218 
219   /**
220   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221   */
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226 
227   /**
228   * @dev Adds two numbers, throws on overflow.
229   */
230   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
231     c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }
236 
237 contract UserWallet {
238     using SafeMath for uint256;
239 
240     address public payoutWallet;
241     address public vaultWallet;
242     AigoTokensale public tokensale;
243 
244     constructor(address _payoutWallet, address _vaultWallet) public {
245       require(_vaultWallet != address(0));
246       payoutWallet = _payoutWallet;
247       vaultWallet = _vaultWallet;
248       tokensale = AigoTokensale(msg.sender);
249     }
250 
251     function onDelivery() public {
252         require(msg.sender == address(tokensale));
253         if (payoutWallet != address(0)) {
254             ERC20Basic token = tokensale.token();
255             uint256 balance = token.balanceOf(this);
256             require(token.transfer(payoutWallet, balance));
257         }
258     }
259 
260     function setPayoutWallet(address _payoutWallet) public {
261         require(tokensale.isOwner(msg.sender));
262         payoutWallet = _payoutWallet;
263         if (payoutWallet != address(0)) {
264             ERC20Basic token = tokensale.token();
265             uint256 balance = token.balanceOf(this);
266             if (balance > 0) {
267                 require(token.transfer(payoutWallet, balance));
268             }
269         }
270     }
271 
272     function() public payable {
273         tokensale.postWalletPayment(msg.value);
274         vaultWallet.transfer(msg.value);
275     }
276 
277 }