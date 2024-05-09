1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library SafeMath {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24         
25 }
26 
27 interface ItokenRecipient { 
28     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external returns (bool); 
29 }
30 
31 interface IERC20Token {
32     function totalSupply() external view returns (uint256 supply);
33     function transfer(address _to, uint256 _value) external  returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
35     function balanceOf(address _owner) external view returns (uint256 balance);
36     function approve(address _spender, uint256 _value) external returns (bool success);
37     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
38 }
39 
40 contract Ownable {
41 
42     address private owner;
43     
44     event OwnerSet(address indexed oldOwner, address indexed newOwner);
45     
46     modifier onlyOwner() {
47         require(msg.sender == owner, "Caller is not owner");
48         _;
49     }
50 
51     constructor() {
52         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
53         emit OwnerSet(address(0), owner);
54     }
55 
56 
57     function changeOwner(address newOwner) public onlyOwner {
58         emit OwnerSet(owner, newOwner);
59         owner = newOwner;
60     }
61 
62     function getOwner() external view returns (address) {
63         return owner;
64     }
65 }
66 
67 contract StandardToken is IERC20Token {
68     
69     using SafeMath for uint256;
70     mapping (address => uint256) public balances;
71     mapping (address => mapping (address => uint256)) public allowed;
72     uint256 public _totalSupply;
73     
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     
77     function totalSupply() override public view returns (uint256 supply) {
78         return _totalSupply;
79     }
80 
81     function transfer(address _to, uint256 _value) override virtual public returns (bool success) {
82         require(_to != address(0x0), "Use burn function instead");                              
83 		require(_value >= 0, "Invalid amount"); 
84 		require(balances[msg.sender] >= _value, "Not enough balance");
85 		balances[msg.sender] = balances[msg.sender].sub(_value);
86 		balances[_to] = balances[_to].add(_value);
87 		emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) override virtual public returns (bool success) {
92         require(_to != address(0x0), "Use burn function instead");                               
93 		require(_value >= 0, "Invalid amount"); 
94 		require(balances[_from] >= _value, "Not enough balance");
95 		require(allowed[_from][msg.sender] >= _value, "You need to increase allowance");
96 		balances[_from] = balances[_from].sub(_value);
97 		balances[_to] = balances[_to].add(_value);
98 		emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function balanceOf(address _owner) override public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) override public returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) override public view returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115     
116 }
117 
118 contract POLCToken is Ownable, StandardToken {
119 
120     using SafeMath for uint256;
121     string public name = "Polka City";
122     uint8 public decimals = 18;
123     string public symbol = "POLC";
124 
125     // Time lock for progressive release of team, marketing and platform balances
126     struct TimeLock {
127         uint256 totalAmount;
128         uint256 lockedBalance;
129         uint128 baseDate;
130         uint64 step;
131         uint64 tokensStep;
132     }
133     mapping (address => TimeLock) public timeLocks; 
134 
135     // Prevent Bots - If true, limits transactions to 1 transfer per block (whitelisted can execute multiple transactions)
136     bool public limitTransactions;
137     mapping (address => bool) public contractsWhiteList;
138     mapping (address => uint) public lastTXBlock;
139     event Burn(address indexed from, uint256 value);
140 
141 // token sale
142 
143     // Wallet for the tokens to be sold, and receive ETH
144     address payable public salesWallet;
145     uint256 public soldOnCSale;
146     uint256 public constant CROWDSALE_START = 1613926800;
147     uint256 public constant CROWDSALE_END = 1614556740;
148     uint256 public constant CSALE_WEI_FACTOR = 15000;
149     uint256 public constant CSALE_HARDCAP = 7500000 ether;
150     
151     constructor() {
152         _totalSupply = 250000000 ether;
153         
154         // Base date to calculate team, marketing and platform tokens lock
155         uint256 lockStartDate = 1613494800;
156         
157         // Team wallet - 10000000 tokens
158         // 0 tokens free, 10000000 tokens locked - progressive release of 5% every 30 days (after 180 days of waiting period)
159         address team = 0x4ef5B3d10fD217AC7ddE4DDee5bF319c5c356723;
160         balances[team] = 10000000 ether;
161         timeLocks[team] = TimeLock(10000000 ether, 10000000 ether, uint128(lockStartDate + (180 days)), 30 days, 500000);
162         emit Transfer(address(0x0), team, balances[team]);
163 
164         // Marketing wallet - 5000000 tokens
165         // 1000000 tokens free, 4000000 tokens locked - progressive release of 5% every 30 days
166         address marketingWallet = 0x056F878d4Ac07E66C9a46a8db4918E827c6fD71c;
167         balances[marketingWallet] = 5000000 ether;
168         timeLocks[marketingWallet] = TimeLock(4000000 ether, 4000000 ether, uint128(lockStartDate), 30 days, 200000);
169         emit Transfer(address(0x0), marketingWallet, balances[marketingWallet]);
170         
171         // Private sale wallet - 2500000 tokens
172         address privateWallet = 0xED854fCF86efD8473F174d6dE60c8A5EBDdCc37A;
173         balances[privateWallet] = 2500000 ether;
174         emit Transfer(address(0x0), privateWallet, balances[privateWallet]);
175         
176         // Sales wallet, holds Pre-Sale balance - 7500000 tokens
177         salesWallet = payable(0x4bb74E94c1EB133a6868C53aA4f6BD437F99c347);
178         balances[salesWallet] = 7500000 ether;
179         emit Transfer(address(0x0), salesWallet, balances[salesWallet]);
180         
181         // Exchanges - 25000000 tokens
182         address exchanges = 0xE50d4358425a93702988eCd8B66c2EAD8b41CE5d;  
183         balances[exchanges] = 25000000 ether;
184         emit Transfer(address(0x0), exchanges, balances[exchanges]);
185         
186         // Platform wallet - 200000000 tokens
187         // 50000000 tokens free, 150000000 tokens locked - progressive release of 25000000 every 90 days
188         address platformWallet = 0xAD334543437EF71642Ee59285bAf2F4DAcBA613F;
189         balances[platformWallet] = 200000000 ether;
190         timeLocks[platformWallet] = TimeLock(150000000 ether, 150000000 ether, uint128(lockStartDate), 90 days, 25000000);
191         emit Transfer(address(0x0), platformWallet, balances[platformWallet]);
192         
193 
194 
195     }
196     
197     function transfer(address _to, uint256 _value) override public returns (bool success) {
198         require(checkTransferLimit(), "Transfers are limited to 1 per block");
199         require(_value <= (balances[msg.sender] - timeLocks[msg.sender].lockedBalance));
200         return super.transfer(_to, _value);
201     }
202     
203     function transferFrom(address _from, address _to, uint256 _value) override public returns (bool success) {
204         require(checkTransferLimit(), "Transfers are limited to 1 per block");
205         require(_value <= (balances[_from] - timeLocks[_from].lockedBalance));
206         return super.transferFrom(_from, _to, _value);
207     }
208     
209     function burn(uint256 _value) public returns (bool success) {
210         require(balances[msg.sender] >= _value, "Not enough balance");
211 		require(_value >= 0, "Invalid amount"); 
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         _totalSupply = _totalSupply.sub(_value);
214         emit Burn(msg.sender, _value);
215         return true;
216     }
217     
218     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
219         allowed[msg.sender][_spender] = _value;
220         emit Approval(msg.sender, _spender, _value);
221         ItokenRecipient recipient = ItokenRecipient(_spender);
222         require(recipient.receiveApproval(msg.sender, _value, address(this), _extraData));
223         return true;
224     }
225     
226 
227     function releaseTokens(address _account) public {
228         uint256 timeDiff = block.timestamp - uint256(timeLocks[_account].baseDate);
229         require(timeDiff > uint256(timeLocks[_account].step), "Unlock point not reached yet");
230         uint256 steps = (timeDiff / uint256(timeLocks[_account].step));
231         uint256 unlockableAmount = ((uint256(timeLocks[_account].tokensStep) * 1 ether) * steps);
232         if (unlockableAmount >=  timeLocks[_account].totalAmount) {
233             timeLocks[_account].lockedBalance = 0;
234         } else {
235             timeLocks[_account].lockedBalance = timeLocks[_account].totalAmount - unlockableAmount;
236         }
237     }
238        
239     function checkTransferLimit() internal returns (bool txAllowed) {
240         address _caller = msg.sender;
241         if (limitTransactions == true && contractsWhiteList[_caller] != true) {
242             if (lastTXBlock[_caller] == block.number) {
243                 return false;
244             } else {
245                 lastTXBlock[_caller] = block.number;
246                 return true;
247             }
248         } else {
249             return true;
250         }
251     }
252     
253     function enableTXLimit() public onlyOwner {
254         limitTransactions = true;
255     }
256     
257     function disableTXLimit() public onlyOwner {
258         limitTransactions = false;
259     }
260     
261     function includeWhiteList(address _contractAddress) public onlyOwner {
262         contractsWhiteList[_contractAddress] = true;
263     }
264     
265     function removeWhiteList(address _contractAddress) public onlyOwner {
266         contractsWhiteList[_contractAddress] = false;
267     }
268     
269     function getLockedBalance(address _wallet) public view returns (uint256 lockedBalance) {
270         return timeLocks[_wallet].lockedBalance;
271     }
272     
273     function buy() public payable {
274         require((block.timestamp > CROWDSALE_START) && (block.timestamp < CROWDSALE_END), "Contract is not selling tokens");
275         uint weiValue = msg.value;
276         require(weiValue >= (5 * (10 ** 16)), "Minimum amount is 0.05 eth");
277         require(weiValue <= (20 ether), "Maximum amount is 20 eth");
278         uint amount = CSALE_WEI_FACTOR * weiValue;
279         require((soldOnCSale) <= (CSALE_HARDCAP), "That quantity is not available");
280         soldOnCSale += amount;
281         balances[salesWallet] = balances[salesWallet].sub(amount);
282         balances[msg.sender] = balances[msg.sender].add(amount);
283         require(salesWallet.send(weiValue));
284         emit Transfer(salesWallet, msg.sender, amount);
285 
286     }
287     
288     function burnUnsold() public onlyOwner {
289         require(block.timestamp > CROWDSALE_END);
290         uint currentBalance = balances[salesWallet];
291         balances[salesWallet] = 0;
292         _totalSupply = _totalSupply.sub(currentBalance);
293         emit Burn(salesWallet, currentBalance);
294     }
295 }