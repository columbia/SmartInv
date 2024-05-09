1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.3;
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
31 interface IstakeContract { 
32     function createStake(address _wallet, uint8 _timeFrame, uint256 _value) external returns (bool); 
33 }
34 
35 interface IERC20Token {
36     function totalSupply() external view returns (uint256 supply);
37     function transfer(address _to, uint256 _value) external  returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
39     function balanceOf(address _owner) external view returns (uint256 balance);
40     function approve(address _spender, uint256 _value) external returns (bool success);
41     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
42 }
43 
44 contract Ownable {
45 
46     address private owner;
47     
48     event OwnerSet(address indexed oldOwner, address indexed newOwner);
49     
50     modifier onlyOwner() {
51         require(msg.sender == owner, "Caller is not owner");
52         _;
53     }
54 
55     constructor() {
56         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
57         emit OwnerSet(address(0), owner);
58     }
59 
60 
61     function changeOwner(address newOwner) public onlyOwner {
62         emit OwnerSet(owner, newOwner);
63         owner = newOwner;
64     }
65 
66     function getOwner() external view returns (address) {
67         return owner;
68     }
69 }
70 
71 contract StandardToken is IERC20Token {
72     
73     using SafeMath for uint256;
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public _totalSupply;
77     
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     
81     function totalSupply() override public view returns (uint256 supply) {
82         return _totalSupply;
83     }
84 
85     function transfer(address _to, uint256 _value) override virtual public returns (bool success) {
86         require(_to != address(0x0), "Use burn function instead");                               // Prevent transfer to 0x0 address. Use burn() instead
87 		require(_value >= 0, "Invalid amount"); 
88 		require(balances[msg.sender] >= _value, "Not enough balance");
89 		balances[msg.sender] = balances[msg.sender].sub(_value);
90 		balances[_to] = balances[_to].add(_value);
91 		emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) override virtual public returns (bool success) {
96         require(_to != address(0x0), "Use burn function instead");                               // Prevent transfer to 0x0 address. Use burn() instead
97 		require(_value >= 0, "Invalid amount"); 
98 		require(balances[_from] >= _value, "Not enough balance");
99 		require(allowed[_from][msg.sender] >= _value, "You need to increase allowance");
100 		balances[_from] = balances[_from].sub(_value);
101 		balances[_to] = balances[_to].add(_value);
102 		emit Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function balanceOf(address _owner) override public view returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     function approve(address _spender, uint256 _value) override public returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function allowance(address _owner, address _spender) override public view returns (uint256 remaining) {
117         return allowed[_owner][_spender];
118     }
119     
120 }
121 
122 contract YUIToken is Ownable, StandardToken {
123 
124     using SafeMath for uint256;
125     string public name;
126     uint8 public decimals;
127     string public symbol;
128     address public stakeContract;
129     address public crowdSaleContract;
130     uint256 public soldTokensUnlockTime;
131     mapping (address => uint256) frozenBalances;
132     mapping (address => uint256) timelock;
133     
134     event Burn(address indexed from, uint256 value);
135     event StakeContractSet(address indexed contractAddress);
136 
137     
138     constructor() {
139         name = "YUI Token";
140         decimals = 18;
141         symbol = "YUI";
142         stakeContract = address(0x0);
143         crowdSaleContract = 0x5530AF4758A33bE9Fd62165ef543b5E2e6742953;                 // contract for ICO tokens
144         address teamWallet =  0x07B8DcbDF4d52B9C1f4251373A289D803Cc670f8;               // wallet for team tokens
145         address privateSaleWallet = 0xC5f1f4fdbFAb7F73CfC814d72408B648059514A0;         // wallet for private sale tokens
146         address marketingWallet = 0x5e0e67AA4f29aD2920Fa8BFe3ae38B52D4f2ceb1;           // wallet for marketing
147         address exchangesLiquidity = 0x7e47b3C642A72520fF7DbFDc052535A0c804fC3C;        // add liquidity to exchanges
148         address stakeWallet = 0x16B92c0473C0491D1509c447285B7c925355e3D3;               // tokens for the stake contract
149         uint256 teamReleaseTime = 1620324000;                                           // lock team tokens for 6 months
150         uint256 marketingReleaseTime = 1612548000;                                      // lock marketing tokens - 1k tokens for 3 months
151         uint256 stakesReleaseTime = 1606586400;                                         // lock stakeContract tokens - 7.5k tokens for 3 weeks
152 
153         balances[teamWallet] = 3000 ether;
154         emit Transfer(address(0x0), teamWallet, (3000 ether));
155         frozenBalances[teamWallet] = 3000 ether;
156         timelock[teamWallet] = teamReleaseTime;
157         
158         balances[stakeWallet] = 7500 ether;
159         emit Transfer(address(0x0), address(stakeWallet), (7500 ether));
160         frozenBalances[stakeWallet] = 7500 ether;
161         timelock[stakeWallet] = stakesReleaseTime;
162         
163         balances[marketingWallet] = 2000 ether;
164         emit Transfer(address(0x0), address(marketingWallet), (2000 ether));
165         frozenBalances[marketingWallet] = 1000 ether;
166         timelock[marketingWallet] = marketingReleaseTime;
167         
168         balances[privateSaleWallet] = 1500 ether;
169         emit Transfer(address(0x0), address(privateSaleWallet), (1500 ether));
170         
171         balances[crowdSaleContract] = 5000 ether;
172         emit Transfer(address(0x0), address(crowdSaleContract), (5000 ether));
173 
174         balances[exchangesLiquidity] = 9000 ether;
175         emit Transfer(address(0x0), address(exchangesLiquidity), (9000 ether));
176 
177         _totalSupply = 28000 ether;
178         
179         soldTokensUnlockTime = 1605636300;
180 
181     }
182     
183     function frozenBalanceOf(address _owner) public view returns (uint256 balance) {
184         return frozenBalances[_owner];
185     }
186     
187     function unlockTimeOf(address _owner) public view returns (uint256 time) {
188         return timelock[_owner];
189     }
190     
191     function transfer(address _to, uint256 _value) override public  returns (bool success) {
192         require(txAllowed(msg.sender, _value), "Crowdsale tokens are still frozen");
193         return super.transfer(_to, _value);
194     }
195     
196     function transferFrom(address _from, address _to, uint256 _value) override public returns (bool success) {
197         require(txAllowed(msg.sender, _value), "Crowdsale tokens are still frozen");
198         return super.transferFrom(_from, _to, _value);
199     }
200     
201     function setStakeContract(address _contractAddress) onlyOwner public {
202         stakeContract = _contractAddress;
203         emit StakeContractSet(_contractAddress);
204     }
205     
206     function setCrowdSaleContract(address _contractAddress) onlyOwner public {
207         crowdSaleContract = _contractAddress;
208     }
209     
210         // Tokens sold by crowdsale contract will be frozen ultil crowdsale ends
211     function txAllowed(address sender, uint256 amount) private returns (bool isAllowed) {
212         if (timelock[sender] > block.timestamp) {
213             return isBalanceFree(sender, amount);
214         } else {
215             if (frozenBalances[sender] > 0) frozenBalances[sender] = 0;
216             return true;
217         }
218         
219     }
220     
221     function isBalanceFree(address sender, uint256 amount) private view returns (bool isfree) {
222         if (amount <= (balances[sender] - frozenBalances[sender])) {
223             return true;
224         } else {
225             return false;
226         }
227     }
228     
229     function burn(uint256 _value) public returns (bool success) {
230         require(balances[msg.sender] >= _value, "Not enough balance");
231 		require(_value >= 0, "Invalid amount"); 
232         balances[msg.sender] = balances[msg.sender].sub(_value);
233         _totalSupply = _totalSupply.sub(_value);
234         emit Burn(msg.sender, _value);
235         return true;
236     }
237 
238     function approveStake(uint8 _timeFrame, uint256 _value) public returns (bool success) {
239         require(stakeContract != address(0x0));
240         allowed[msg.sender][stakeContract] = _value;
241         emit Approval(msg.sender, stakeContract, _value);
242         IstakeContract recipient = IstakeContract(stakeContract);
243         require(recipient.createStake(msg.sender, _timeFrame, _value));
244         return true;
245     }
246     
247     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         ItokenRecipient recipient = ItokenRecipient(_spender);
251         require(recipient.receiveApproval(msg.sender, _value, address(this), _extraData));
252         return true;
253     }
254     
255     function tokensSold(address buyer, uint256 amount) public returns (bool success) {
256         require(msg.sender == crowdSaleContract);
257         frozenBalances[buyer] += amount;
258         if (timelock[buyer] == 0 ) timelock[buyer] = soldTokensUnlockTime;
259         return super.transfer(buyer, amount);
260     }
261     
262 
263 }