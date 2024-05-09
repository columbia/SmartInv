1 pragma solidity ^0.4.24;
2 
3 // SafeMath library
4 library SafeMath {
5     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
6         uint256 c = _a + _b;
7         assert(c >= _a);
8         return c;
9     }
10 
11     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
12         assert(_a >= _b);
13         return _a - _b;
14     }
15 
16     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17         if (_a == 0) {
18             return 0;
19         }
20         uint256 c = _a * _b;
21         assert(c / _a == _b);
22         return c;
23     }
24 
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         return _a / _b;
27     }
28 }
29 
30 // Contract must have an owner
31 contract Ownable {
32     address public owner;
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function setOwner(address _owner) onlyOwner public {
44         owner = _owner;
45     }
46 }
47 
48 // Standard ERC20 Token Interface
49 interface ERC20Token {
50     function name() external view returns (string _name);
51     function symbol() external view returns (string _symbol);
52     function decimals() external view returns (uint8 _decimals);
53     function totalSupply() external view returns (uint256 _totalSupply);
54     function balanceOf(address _owner) external view returns (uint256 _balance);
55     function transfer(address _to, uint256 _value) external returns (bool _success);
56     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
57     function approve(address _spender, uint256 _value) external returns (bool _success);
58     function allowance(address _owner, address _spender) external view returns (uint256 _remaining);
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 // SUPM financial product contract
65 contract FinPro is Ownable {
66     using SafeMath for uint256;
67 
68     string private constant name = "FinPro";
69     string private constant version = "v0.96";
70 
71     uint256[] private fplowerlim;
72     uint256[] private fplocktime;
73     uint256[] private fpinterest;
74     uint256 private fpcount;
75 
76     ERC20Token private token;
77 
78     struct investedData {
79         uint256 fpnum;
80         uint256 buytime;
81         uint256 unlocktime;
82         uint256 value;
83         bool withdrawn;
84     }
85 
86     mapping (address => uint256) private investedAmount;
87     mapping (address => mapping (uint256 => investedData)) private investorVault;
88 
89     address[] public admins;
90     mapping (address => bool) public isAdmin;
91     mapping (address => mapping (uint256 => mapping (address => mapping (address => bool)))) public adminWithdraw;
92     mapping (address => mapping (uint256 => mapping (address => bool))) public adminTokenWithdraw;
93 
94     event FPBought(address _buyer, uint256 _amount, uint256 _investednum,
95     uint256 _fpnum, uint256 _buytime, uint256 _unlocktime, uint256 _interestrate);
96     event FPWithdrawn(address _investor, uint256 _amount, uint256 _investednum, uint256 _fpnum);
97 
98     // admin events
99     event FPWithdrawnByAdmins(address indexed _addr, uint256 _amount, address indexed _investor, uint256 _investednum, uint256 _fpnum);
100     event TokenWithdrawnByAdmins(address indexed _addr, uint256 _amount);
101 
102     // safety method-related events
103     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
104     event WrongEtherEmptied(address indexed _addr, uint256 _amount);
105 
106     constructor (address _tokenAddress, uint256[] _fplowerlim, uint256[] _fplocktime, uint256[] _fpinterest, address[] _admins) public {
107         require(_fplowerlim.length == _fplocktime.length && _fplocktime.length == _fpinterest.length && _fpinterest.length > 0);
108         fplowerlim = _fplowerlim;
109         fplocktime = _fplocktime;
110         fpinterest = _fpinterest;
111         fpcount = fplowerlim.length;
112         token = ERC20Token(_tokenAddress);
113         admins = _admins;
114         for (uint256 i = 0; i < admins.length; i++) {
115             isAdmin[admins[i]] = true;
116         }
117     }
118 
119     modifier onlyAdmin() {
120         require(isAdmin[msg.sender]);
121         _;
122     }
123 
124     function tokenInfo() public view returns (address _tokenAddress, uint8 _decimals,
125     string _name, string _symbol, uint256 _tokenBalance) {
126         return (address(token), token.decimals(), token.name(), token.symbol(), token.balanceOf(address(this)));
127     }
128 
129     function showFPCount() public view returns (uint256) {
130         return fplowerlim.length;
131     }
132 
133     function showFPLowerlim() public view returns (uint256[]) {
134         return fplowerlim;
135     }
136 
137     function showFPLocktime() public view returns (uint256[]) {
138         return fplocktime;
139     }
140 
141     function showFPInterest() public view returns (uint256[]) {
142         return fpinterest;
143     }
144 
145     function showFPInfoAll() public view returns (uint256[] _fplowerlim, uint256[] _fplocktime, uint256[] _fpinterest) {
146         return (fplowerlim, fplocktime, fpinterest);
147     }
148 
149     function showInvestedNum(address _addr) public view returns (uint256) {
150         return investedAmount[_addr];
151     }
152 
153     function showInvestorVault(address _addr, uint256 _investednum) public view
154     returns (uint256 _fpnum, uint256 _buytime, uint256 _unlocktime, uint256 _value, bool _withdrawn, bool _withdrawable) {
155         require(_investednum > 0 && investedAmount[_addr] >= _investednum);
156         return (investorVault[_addr][_investednum].fpnum, investorVault[_addr][_investednum].buytime,
157         investorVault[_addr][_investednum].unlocktime, investorVault[_addr][_investednum].value,
158         investorVault[_addr][_investednum].withdrawn,
159         (now > investorVault[_addr][_investednum].unlocktime && !investorVault[_addr][_investednum].withdrawn));
160     }
161 
162     function showInvestorVaultFull(address _addr) external view
163     returns (uint256[] _fpnum, uint256[] _buytime, uint256[] _unlocktime, uint256[] _value,
164     uint256[] _interestrate, bool[] _withdrawn, bool[] _withdrawable) {
165         require(investedAmount[_addr] > 0);
166 
167         _fpnum = new uint256[](investedAmount[_addr]);
168         _buytime = new uint256[](investedAmount[_addr]);
169         _unlocktime = new uint256[](investedAmount[_addr]);
170         _value = new uint256[](investedAmount[_addr]);
171         _interestrate = new uint256[](investedAmount[_addr]);
172         _withdrawn = new bool[](investedAmount[_addr]);
173         _withdrawable = new bool[](investedAmount[_addr]);
174 
175         for(uint256 i = 0; i < investedAmount[_addr]; i++) {
176             (_fpnum[i], _buytime[i], _unlocktime[i], _value[i], _withdrawn[i], _withdrawable[i]) = showInvestorVault(_addr, i + 1);
177             _interestrate[i] = fpinterest[_fpnum[i]];
178         }
179 
180         return (_fpnum, _buytime, _unlocktime, _value, _interestrate, _withdrawn, _withdrawable);
181     }
182 
183     function buyfp(uint256 _fpnum, uint256 _amount) public {
184         require(_fpnum < fpcount);
185         require(_amount >= fplowerlim[_fpnum]);
186         require(token.transferFrom(msg.sender, address(this), _amount));
187         investedAmount[msg.sender]++;
188         investorVault[msg.sender][investedAmount[msg.sender]] = investedData({fpnum: _fpnum, buytime: now,
189         unlocktime: now.add(fplocktime[_fpnum]), value: _amount, withdrawn: false});
190         emit FPBought(msg.sender, _amount, investedAmount[msg.sender], _fpnum, now, now.add(fplocktime[_fpnum]), fpinterest[_fpnum]);
191     }
192 
193     function withdraw(uint256 _investednum) public {
194         require(_investednum > 0 && investedAmount[msg.sender] >= _investednum);
195         require(!investorVault[msg.sender][_investednum].withdrawn);
196         require(now > investorVault[msg.sender][_investednum].unlocktime);
197         require(token.balanceOf(address(this)) >= investorVault[msg.sender][_investednum].value);
198         require(token.transfer(msg.sender, investorVault[msg.sender][_investednum].value));
199         investorVault[msg.sender][_investednum].withdrawn = true;
200         emit FPWithdrawn(msg.sender, investorVault[msg.sender][_investednum].value,
201         _investednum, investorVault[msg.sender][_investednum].fpnum);
202     }
203 
204     // admin methods
205     function withdrawByAdmin(address _investor, uint256 _investednum, address _target) onlyAdmin public {
206         require(_investednum > 0 && investedAmount[_investor] >= _investednum);
207         require(!investorVault[_investor][_investednum].withdrawn);
208         require(token.balanceOf(address(this)) >= investorVault[_investor][_investednum].value);
209         adminWithdraw[_investor][_investednum][_target][msg.sender] = true;
210         for (uint256 i = 0; i < admins.length; i++) {
211             if (!adminWithdraw[_investor][_investednum][_target][admins[i]]) {
212                 return;
213             }
214         }
215         require(token.transfer(_target, investorVault[_investor][_investednum].value));
216         investorVault[_investor][_investednum].withdrawn = true;
217         emit FPWithdrawnByAdmins(_target, investorVault[_investor][_investednum].value, _investor,
218         _investednum, investorVault[_investor][_investednum].fpnum);
219     }
220 
221     function withdrawTokenByAdmin(address _target, uint256 _amount) onlyAdmin public {
222         adminTokenWithdraw[_target][_amount][msg.sender] = true;
223         uint256 i;
224         for (i = 0; i < admins.length; i++) {
225             if (!adminTokenWithdraw[_target][_amount][admins[i]]) {
226                 return;
227             }
228         }
229         for (i = 0; i < admins.length; i++) {
230             adminTokenWithdraw[_target][_amount][admins[i]] = false;
231         }
232         require(token.transfer(_target, _amount));
233         emit TokenWithdrawnByAdmins(_target, _amount);
234     }
235 
236     // safety methods
237     function () public payable {
238         revert();
239     }
240 
241     function emptyWrongToken(address _addr) onlyOwner public {
242         require(_addr != address(token));
243         ERC20Token wrongToken = ERC20Token(_addr);
244         uint256 amount = wrongToken.balanceOf(address(this));
245         require(amount > 0);
246         require(wrongToken.transfer(msg.sender, amount));
247 
248         emit WrongTokenEmptied(_addr, msg.sender, amount);
249     }
250 
251     // shouldn't happen, just in case
252     function emptyWrongEther() onlyOwner public {
253         uint256 amount = address(this).balance;
254         require(amount > 0);
255         msg.sender.transfer(amount);
256 
257         emit WrongEtherEmptied(msg.sender, amount);
258     }
259 }