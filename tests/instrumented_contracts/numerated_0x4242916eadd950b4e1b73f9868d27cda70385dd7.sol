1 pragma solidity ^0.5.10;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15 
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0, "SafeMath: division by zero");
32         uint256 c = a / b;
33 
34         return c;
35     }
36 }
37 
38 interface IERC20 {
39   function totalSupply() external view returns (uint256);
40   function balanceOf(address who) external view returns (uint256);
41   function allowance(address owner, address spender) external view returns (uint256);
42   function transfer(address to, uint256 value) external returns (bool);
43   function approve(address spender, uint256 value) external returns (bool);
44   function transferFrom(address from, address to, uint256 value) external returns (bool);
45 
46   event Transfer(address indexed from, address indexed to, uint256 value);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract ERC20Detailed is IERC20 {
51 
52   uint8 public _Tokendecimals;
53   string public _Tokenname;
54   string public _Tokensymbol;
55 
56   constructor(string memory name, string memory symbol, uint8 decimals) public {
57    
58     _Tokendecimals = decimals;
59     _Tokenname = name;
60     _Tokensymbol = symbol;
61     
62   }
63 
64   function name() public view returns(string memory) {
65     return _Tokenname;
66   }
67 
68   function symbol() public view returns(string memory) {
69     return _Tokensymbol;
70   }
71 
72   function decimals() public view returns(uint8) {
73     return _Tokendecimals;
74   }
75 }
76 
77 contract MoonFarm is ERC20Detailed {
78 
79     using SafeMath for uint256;
80 
81     uint256 constant public BASE_PRICE = 22180326050792;
82     uint256 constant public FINAL_PRICE = 66540978152376;
83     uint256 constant public HARDCAP = 13455.93 ether;
84 
85     uint256 public fStage;
86     uint256 public end;
87     uint256 public totalUsers;
88     uint256 public totalDeposit;
89     bool public ended;
90     bool public reached;
91     address[] public shareholders;
92 
93     address payable public _owner = 0xb7E4B48aBafA0197dEb58aA4D68906B7411e3DA3;
94 
95     mapping (address => uint256) public _MOONFARMTokenBalances;
96     mapping (address => mapping (address => uint256)) public _allowed;
97     string constant tokenName = "moon.farm";
98     string constant tokenSymbol = "MOONFARM";
99     uint8  constant tokenDecimals = 18;
100     uint256 _totalSupply;
101 
102     struct User {
103         bool isClaimed;
104         uint256 claimed;
105         uint256 deposited_amount;
106         uint256 token_amount;
107         address referrer;
108         uint256 bonus;
109     }
110 
111     mapping (address => User) public users;
112 
113     event Newbie(address user);
114     event NewDeposit(address indexed user, uint256 amount);
115     event Claimed(address indexed user, uint256 amount);
116     event RefBonus(address indexed referrer, address indexed referral, uint256 amount);
117 
118     constructor () public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals){
119         fStage = now + 10 days;
120         end = now + 25 days;
121 
122         ended = false;
123         reached = false;
124         _totalSupply = 0;
125     }
126 
127     modifier onlyOwner() {
128         require(msg.sender == _owner, "Not Owner");
129         _;
130     }
131 
132     function isEnded() public view returns(bool) {
133         return (now >= end || totalDeposit >= HARDCAP) ? true: false;
134     }
135 
136     function buy(address referrer) external payable {
137         require(!isEnded(), "ICO Already Ended");
138         purchaseTokens(msg.sender, msg.value, referrer);
139     }
140 
141     
142     function purchaseTokens(address _sender, uint256 _incoming, address referrer) internal {
143         uint256 _tokens = calcTokenAmount(_incoming);
144         User storage user = users[_sender];
145 
146         if (user.referrer == address(0) && users[referrer].deposited_amount > 0 && referrer != msg.sender) {
147             user.referrer = referrer;
148         }
149 
150         if (user.referrer != address(0)) {
151 
152             address upline = user.referrer;
153             
154 			if (upline != address(0)) {
155 				uint256 _amount = _tokens.mul(5).div(100);
156 				users[upline].bonus = users[upline].bonus.add(_amount);
157                 _totalSupply = _totalSupply.add(_amount);
158 				emit RefBonus(upline, msg.sender, _amount);
159 			}
160         }
161 
162         if(user.deposited_amount > 0) {
163             user.deposited_amount = user.deposited_amount.add(_incoming);
164             user.token_amount = user.token_amount.add(_tokens);
165         } else {
166             user.deposited_amount = _incoming;
167             user.token_amount = _tokens;
168             totalUsers = totalUsers.add(1);
169             shareholders.push(_sender);
170 
171             emit Newbie(_sender);
172         }
173 
174         totalDeposit = totalDeposit.add(_incoming);
175         _totalSupply = _totalSupply.add(_tokens);
176 
177         emit NewDeposit(_sender, _incoming);
178         emit Transfer(address(0), address(this), _tokens);
179     }
180 
181     function claim() external {
182         require(isEnded(), "ICO is still being holding");
183         User storage user = users[msg.sender];
184         require(user.token_amount > 0, "Invalid User");
185         require(!user.isClaimed, "Already claimed");
186 
187         uint256 totalAmount;
188         uint256 referralBonus = getUserReferralBonus(msg.sender);
189         if (referralBonus > 0) {
190             totalAmount = user.token_amount.add(referralBonus);
191             user.bonus = 0;
192         }
193 
194         _MOONFARMTokenBalances[msg.sender] = totalAmount;
195 
196         user.isClaimed = true;
197         user.claimed = now;
198 
199         emit Claimed(msg.sender, totalAmount);
200         emit Transfer(address(this), msg.sender, totalAmount);
201     }
202 
203     function calcDepositAmount(uint256 _tokens) public view returns (uint256) {
204         uint256 ethAmount = 0;
205         if(now <= fStage) {
206             ethAmount = _tokens.mul(BASE_PRICE).mul(100).div(1 ether).div(110);
207         } else {
208             ethAmount = _tokens.mul(FINAL_PRICE).div(1 ether);
209         }
210         return ethAmount;
211     }
212 
213     function calcTokenAmount(uint256 _incoming) public view returns (uint256) {
214         uint256 _tokens = 0;
215         if(now <= fStage) {
216             _tokens = _incoming.mul(1 ether).div(BASE_PRICE);
217             _tokens = _tokens.mul(110).div(100);
218         } else {
219             _tokens = _incoming.mul(1 ether).div(FINAL_PRICE);
220         }
221 
222         return _tokens;
223     }
224 
225     function getUserReferrer(address userAddress) public view returns(address) {
226         return users[userAddress].referrer;
227     }
228 
229     function getUserReferralBonus(address userAddress) public view returns(uint256) {
230         return users[userAddress].bonus;
231     }
232 
233     function getUserAvailable(address userAddress) public view returns(uint256) {
234         (uint256 tokenBalance, bool isClaimed) = checkTokenBalance(userAddress);
235         return getUserReferralBonus(userAddress).add(tokenBalance);
236     }
237 
238     function checkTokenBalance(address _sender) public view returns (uint256, bool) {
239         User storage user = users[_sender];
240 
241         return (user.token_amount, user.isClaimed);
242     }
243 
244     function withdraw_eth() external onlyOwner returns (bool) {
245         require(isEnded(), "ICO is still being holding");
246         require(address(this).balance > 0, "Invalid Balance of Eth");
247 
248         (bool success, ) = _owner.call.value(address(this).balance)("");
249         return success;
250     }
251 
252     function totalSupply() public view returns (uint256) {
253         return _totalSupply;
254     }
255 
256     function balanceOf(address owner) public view returns (uint256) {
257         return _MOONFARMTokenBalances[owner];
258     }
259 
260 
261     function transfer(address to, uint256 value) public returns (bool) {
262         require(value <= _MOONFARMTokenBalances[msg.sender]);
263         require(to != address(0));
264 
265         _MOONFARMTokenBalances[msg.sender] = _MOONFARMTokenBalances[msg.sender].sub(value);
266         _MOONFARMTokenBalances[to] = _MOONFARMTokenBalances[to].add(value);
267 
268         emit Transfer(msg.sender, to, value);
269         return true;
270     }
271 
272 
273     function allowance(address owner, address spender) public view returns (uint256) {
274         return _allowed[owner][spender];
275     }
276 
277 
278     function approve(address spender, uint256 value) public returns (bool) {
279         require(spender != address(0));
280         _allowed[msg.sender][spender] = value;
281         emit Approval(msg.sender, spender, value);
282         return true;
283     }
284 
285     function transferFrom(address from, address to, uint256 value) public returns (bool) {
286         require(value <= _MOONFARMTokenBalances[from]);
287         require(value <= _allowed[from][msg.sender]);
288         require(to != address(0));
289 
290         _MOONFARMTokenBalances[from] = _MOONFARMTokenBalances[from].sub(value);
291 
292         _MOONFARMTokenBalances[to] = _MOONFARMTokenBalances[to].add(value);
293 
294         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
295 
296         emit Transfer(from, to, value);
297 
298         return true;
299     }
300 
301     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
302         require(spender != address(0));
303         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
304         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
305         return true;
306     }
307 
308     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
309         require(spender != address(0));
310         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
311         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
312         return true;
313     }
314 }