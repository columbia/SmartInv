1 /* 
2 
3 NETWORK SMART CONTRACT
4 https://joinnet.work
5 
6 Powered by PROOF CAPITAL GROUP
7 Developed by @cryptocreater
8 Audited by Techrate.Org
9 
10  ########################################
11  ########################################
12  ### ATTENTION!                       ###
13  ### To avoid OUT OF GAS error, make  ###
14  ### sure that fee GAS limit make at  ###
15  ### least 250'000 GAS!               ###
16  ### The amount of GAS is indicated   ###
17  ### with a margin, in fact, the      ###
18  ### transaction fee should be less,  ###
19  ### up to 80'000 GAS.                ###
20  ########################################
21  ########################################
22 
23 BASIC CONDITIONS.
24 1.  The Network smart contract does not have a beneficiary or other affiliated persons receiving an individual reward over standart Network marketing.
25 2.  You can exchange Ethereum (ETH) for Network tokens (NET) only after receiving a registration transfer from the address previously registered on the Network smart contract.
26 3.  The linking of the subscriber (referral) address is carried out by transferring to it any number of NET, provided that no one has done this yet, and the referral link cannot be changed under any circumstances, except for the situation described in p.4.
27 4.  Important! If at the time of accrual of the referral reward the balance of the address is less than 0.0625 NET, the referrer address of the referral chain lower address will be replaced with the address of a higher referral chain address. In other words, the subordinate address will be moved to upstream address in the referral chain. This action is irreversible and affects only the referral chain and the associated marketing conditions of the Network smart contract.
28 5.  The exchange of NET for ETH is carried out by making an ETH deposit to the Network smart contract address and NET issuing.
29 6.  The minimum exchange amount is 1 GWEI (0.000000001 ETH).
30 7.  The exchange rate of NET for ETH at the time of exchange is calculated by the formula:
31         R = E / S
32         where
33         R - exchange rate NET for ETH;
34         E - the total amount of ETH deposit placed on the balance of the Network smart contract;
35         S - the total emission of NET.
36 8.  At the time of depositing (exchanging) ETH for the Network smart contract, the current rate is calculated and 70% of the received amount is NET issued to the address from which ETH deposit was placed (transferred), and the remaining amount is distributed according to the referral chain ten levels up, starting from 15% for the address of the first level and further with a decrease in the amount of issue and accrual of NET by half at each next level.
37 9.  To receive a reward from the referral chain, the address balance must have at least 0.0625 NET to receive rewards from the first lower level with a doubling for each subsequent level in depth to the tenth level. Thus, in order to receive a reward from 10 levels, the address must have at least 32 NET. The amount of the referral reward received depends on the balance of the address at the time of calculation. If the balance of the address is greater than or equal to the total potential amount of NET issue according to the placed ETH deposit, the full amount of remuneration is accrued according to the Network marketing, otherwise the remuneration is calculated using the formula:
38         R = B / D * E
39         where
40         R - received remuneration;
41         B - address balance;
42         D - amount of potentially issued NET per placed ETH deposit;
43         E - total amount of remuneration by level according to Network Marketing.
44 10.  For the missed or reduced reward, NET are not issued, thereby increasing the ratio of the total amount of ETH deposit to the total number of NET.
45 12.  The reverse exchange (return) of the deposit is carried out by transferring NET to the address of the Network smart contract, while ETH deposit will be returned to the address that sent the tokens at the rate according to the formula specified in p.7.
46 13.  NET tokens received at the address of the smart contract are destroyed, thereby providing a positive growth trend in the exchange rate of NET for ETH, except for the situation described in p.14.
47 14.  From the launch of Network smart contract until the total emission of 50 NET is reached, the exchange rate is fixed at 1 NET = 1 ETH by issuing the missed and unreceived reward on the balance of the Network smart contract. When the total token emission of 50 NET is reached, all NET on the balance of the smart contract are destroyed (burned) and a dynamic token exchange rate is established.
48 15.  Any address that is the only address with a positive NET balance can reset it's balance, the balance of Network smart contract, withdraw all deposited ETH on the smart contract by using RESTART function. In this case, the exchange rate will return to 1:1 and will be fixed until the emission of 50 NET is reached.
49 17.  For ease of use, the RATE function of smart contract displays the exchange rate of 1 NET for 1 ETH multiplied by 1'000'000 due to the lack of the ability to display floating point numbers in the Ethereum EVM, is for informational purposes only and is not used in calculating actual values within the smart contract marketing and functionality.
50 18.  NET supports all the generally accepted functions and properties of the ERC20 standard on the Ethereum blockchain, incl. transfers, storage and decentralized applications.
51 
52 (c) 2020 PROOF CAPITAL GROUP
53 
54 */
55 
56 pragma solidity 0.6.6;
57 interface IERC20 {
58     event Transfer(address indexed from, address indexed to, uint256 amount);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60     function totalSupply() external view returns (uint256);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 }
67 contract ERC20 is IERC20 {
68     event CheckOut(address indexed account, uint256 ethers);
69     mapping (address => uint256) private _balances;
70     mapping (address => mapping (address => uint256)) private _allowances;
71     uint256 private _totalSupply;
72     string private _name = "Network";
73     string private _symbol = "NET";
74     uint8 private _decimals = 18;
75     function safeAdd(uint256 a, uint256 b) private pure returns (uint256) {
76     	require(a + b > a, "Addition overflow");
77     	return a + b;
78     }
79     function safeSub(uint256 a, uint256 b) private pure returns (uint256) {
80     	require(a >= b, "Substruction overflow");
81     	return a - b;
82     }
83     function name() public view returns (string memory) {
84         return _name;
85     }    
86     function symbol() public view returns (string memory) {
87         return _symbol;
88     }    
89     function decimals() public view returns (uint8) {
90         return _decimals;
91     }
92     function totalSupply() public view override returns (uint256) {
93         return _totalSupply;
94     }
95     function balanceOf(address account) public view override returns (uint256) {
96         return _balances[account];
97     }
98     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
99         _transfer(msg.sender, recipient, amount);
100         return true;
101     }
102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
103         return _allowances[owner][spender];
104     }
105     function approve(address spender, uint256 amount) public virtual override returns (bool) {
106         _approve(msg.sender, spender, amount);
107         return true;
108     }
109     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
110         _transfer(sender, recipient, amount);
111         _approve(sender, msg.sender, safeSub(_allowances[sender][msg.sender], amount));
112         return true;
113     }
114     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
115         require(addedValue > 0, "Zero amount");
116         _approve(msg.sender, spender, safeAdd(_allowances[msg.sender][spender], addedValue));
117         return true;
118     }
119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
120         require(_allowances[msg.sender][spender] >= subtractedValue, "Exceed amount");
121         _approve(msg.sender, spender, safeSub(_allowances[msg.sender][spender], subtractedValue));
122         return true;
123     }
124     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
125         require(amount > 0, "Zero amount");
126         require(sender != address(0), "Zero sender");
127         require(recipient != address(0), "Zero recipient");
128         uint256 _value = tokenTransfer(sender, recipient, amount);
129         if(_value > 0) {
130             _balances[sender] = safeSub(_balances[sender], amount);
131             _totalSupply = safeSub(_totalSupply, amount);
132             emit CheckOut(sender, _value);
133             emit Transfer(sender, address(0), amount);
134             payable(sender).transfer(_value);
135         } else {
136         	_balances[sender] = safeSub(_balances[sender], amount);
137             _balances[recipient] = safeAdd(_balances[recipient], amount);
138             emit Transfer(sender, recipient, amount);
139         }
140     }
141     function _mint(address account, uint256 amount) internal virtual {
142         require(amount > 0, "Zero amount");
143         require(account != address(0), "Zero TO address");
144         _totalSupply = safeAdd(_totalSupply, amount);
145         _balances[account] = safeAdd(_balances[account], amount);
146         emit Transfer(address(0), account, amount);
147     }
148     function _charge(address account, uint256 amount, bool charge) internal virtual {
149         if(charge) {
150         	_balances[account] = safeAdd(_balances[account], amount);
151             emit Transfer(address(0), account, amount);
152         } else {
153         	_totalSupply = safeAdd(_totalSupply, amount);
154         }
155     }
156     function _burn(address account, uint256 amount) internal virtual {
157         require(amount > 0, "Zero amount");
158         require(account != address(0), "Zero acount");
159         _balances[account] = safeSub(_balances[account], amount);
160         _totalSupply = safeSub(_totalSupply, amount);
161         emit Transfer(account, address(0), amount);
162     }
163     function _approve(address owner, address spender, uint256 amount) internal virtual {
164         require(owner != address(0), "Zero owner");
165         require(spender != address(0), "Zero spender");
166         _allowances[owner][spender] = amount;
167         emit Approval(owner, spender, amount);
168     }
169     function tokenTransfer(address from, address to, uint256 amount) internal virtual returns (uint256) { }
170 }
171 contract Network is ERC20 {
172     event CheckIn(address indexed account, uint256 ethers);
173     event Missed(address indexed account, uint8 level, uint256 tokens);
174     event Compression(address indexed account, address indexed previous, address indexed current);
175     event Restart(address indexed account, uint256 tokens, uint256 ethers);
176     event RateUp(uint32 timestamp, uint256 rate);
177     address private smart;
178     mapping(address => address) public referrers;
179     uint128 public raisup = 5 * 1e19;
180     constructor() public {
181         smart = address(this);
182         referrers[msg.sender] = smart;
183         referrers[smart] = smart;
184     }
185     function tokenTransfer(address _from, address _to, uint256 _amount) internal override returns (uint256) {
186         if(_to == smart) {
187             return _amount * smart.balance / totalSupply();
188         } else {
189             if(referrers[_to] == address(0)) referrers[_to] = _from;
190             return 0;
191         }
192     }
193     receive() payable external {
194         require(referrers[msg.sender] != address(0), "Zero referrer");
195         require(msg.value >= 1e9, "Little amount");
196         uint256 _cap = smart.balance - msg.value;
197         uint256 _payout = _cap > 0 ? msg.value * totalSupply() / _cap : msg.value;
198         reward(msg.sender, referrers[msg.sender], _payout);
199     }
200     function reward(address _account, address _referrer, uint256 _payout) private {
201         uint128 _minimum = 625 * 1e14;
202         uint256 _charged;
203         uint256 _purchase = _payout * 7 / 10;
204         uint256 _profit = _payout - _purchase;
205         uint256 _reward = _profit / 2;
206         emit CheckIn(msg.sender, msg.value);
207         _mint(msg.sender, _purchase);
208         for(uint8 _level = 1; _level < 11; _level++) {
209             if(_referrer != smart) {
210                 uint256 _balance = balanceOf(_referrer);
211                 if(_balance >= _minimum) {
212                     _account = _referrer;
213                     uint256 _reward_ = _balance > _payout ? _reward : _reward * _balance / _payout;
214                     _profit -= _reward_;
215                     _charged += _reward_;
216                     _charge(_referrer, _reward_, true);
217                     if(_reward > _reward_) emit Missed(_referrer, _level,  _reward - _reward_);
218                 } else {
219                     if(_balance < 625 * 1e14) {
220                         address _upreferrer = referrers[_referrer];
221                         if(_upreferrer != smart) {
222                             emit Compression(_account, referrers[_account], _upreferrer);
223                             referrers[_account] = _upreferrer;
224                         }
225                     } else {
226                         _account = _referrer;
227                         emit Missed(_referrer, _level, _reward);
228                     }
229                 }
230             } else {
231                 _level = 11;
232             }
233             _referrer = referrers[_referrer];
234             _reward /= 2;
235             _minimum *= 2;
236         }
237         if(_charged > 0) _charge(address(0), _charged, false);
238         if(raisup > 0) {
239             if(_profit > 0) _mint(smart, _profit);
240             if(totalSupply() >= raisup) {
241                 raisup = 0;
242                 _burn(smart, balanceOf(smart));
243             }
244         } else {
245             emit RateUp(uint32(block.timestamp), this.rate());
246         }
247     }
248     function restart() external {
249         require(balanceOf(msg.sender) + balanceOf(smart) == totalSupply(), "Not alone");
250         if(balanceOf(msg.sender) > 0) _burn(msg.sender, balanceOf(msg.sender));
251         if(balanceOf(smart) > 0) _burn(smart, balanceOf(smart));
252         raisup = 5 * 1e19;
253         emit Restart(msg.sender, balanceOf(msg.sender) + balanceOf(smart), smart.balance);
254         payable(msg.sender).transfer(smart.balance);
255     }
256     function burn(uint256 _value) external {
257         _burn(msg.sender, _value);
258     }
259     function rate() external view returns (uint256) {
260         return totalSupply() > 0 && smart.balance > 0 ? smart.balance * 1e6 / totalSupply() : 1e6; 
261     }
262     function cap() external view returns (uint256) {
263         return smart.balance > 0 ? smart.balance : 0;
264     }
265 }