1 // File: contracts/lib/SafeMath.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 
12 
13 /**
14  * @title SafeMath
15  * @author DODO Breeder
16  *
17  * @notice Math operations with safety checks that revert on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "MUL_ERROR");
27 
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0, "DIVIDING_ERROR");
33         return a / b;
34     }
35 
36     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 quotient = div(a, b);
38         uint256 remainder = a - quotient * b;
39         if (remainder > 0) {
40             return quotient + 1;
41         } else {
42             return quotient;
43         }
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SUB_ERROR");
48         return a - b;
49     }
50 
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "ADD_ERROR");
54         return c;
55     }
56 
57     function sqrt(uint256 x) internal pure returns (uint256 y) {
58         uint256 z = x / 2 + 1;
59         y = x;
60         while (z < y) {
61             y = z;
62             z = (x / z + z) / 2;
63         }
64     }
65 }
66 
67 // File: contracts/lib/InitializableOwnable.sol
68 
69 
70 /**
71  * @title Ownable
72  * @author DODO Breeder
73  *
74  * @notice Ownership related functions
75  */
76 contract InitializableOwnable {
77     address public _OWNER_;
78     address public _NEW_OWNER_;
79     bool internal _INITIALIZED_;
80 
81     // ============ Events ============
82 
83     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     // ============ Modifiers ============
88 
89     modifier notInitialized() {
90         require(!_INITIALIZED_, "DODO_INITIALIZED");
91         _;
92     }
93 
94     modifier onlyOwner() {
95         require(msg.sender == _OWNER_, "NOT_OWNER");
96         _;
97     }
98 
99     // ============ Functions ============
100 
101     function initOwner(address newOwner) public notInitialized {
102         _INITIALIZED_ = true;
103         _OWNER_ = newOwner;
104     }
105 
106     function transferOwnership(address newOwner) public onlyOwner {
107         emit OwnershipTransferPrepared(_OWNER_, newOwner);
108         _NEW_OWNER_ = newOwner;
109     }
110 
111     function claimOwnership() public {
112         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
113         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
114         _OWNER_ = _NEW_OWNER_;
115         _NEW_OWNER_ = address(0);
116     }
117 }
118 
119 // File: contracts/external/ERC20/CustomMintableERC20.sol
120 
121 contract CustomMintableERC20 is InitializableOwnable {
122     using SafeMath for uint256;
123 
124     string public name;
125     uint8 public decimals;
126     string public symbol;
127     uint256 public totalSupply;
128 
129     uint256 public tradeBurnRatio;
130     uint256 public tradeFeeRatio;
131     address public team;
132 
133     mapping(address => uint256) balances;
134     mapping(address => mapping(address => uint256)) internal allowed;
135 
136     event Transfer(address indexed from, address indexed to, uint256 amount);
137     event Approval(address indexed owner, address indexed spender, uint256 amount);
138     event Mint(address indexed user, uint256 value);
139     event Burn(address indexed user, uint256 value);
140 
141     event ChangeTeam(address oldTeam, address newTeam);
142 
143 
144     function init(
145         address _creator,
146         uint256 _initSupply,
147         string memory _name,
148         string memory _symbol,
149         uint8 _decimals,
150         uint256 _tradeBurnRatio,
151         uint256 _tradeFeeRatio,
152         address _team
153     ) public {
154         initOwner(_creator);
155         name = _name;
156         symbol = _symbol;
157         decimals = _decimals;
158         totalSupply = _initSupply;
159         balances[_creator] = _initSupply;
160         require(_tradeBurnRatio >= 0 && _tradeBurnRatio <= 5000, "TRADE_BURN_RATIO_INVALID");
161         require(_tradeFeeRatio >= 0 && _tradeFeeRatio <= 5000, "TRADE_FEE_RATIO_INVALID");
162         tradeBurnRatio = _tradeBurnRatio;
163         tradeFeeRatio = _tradeFeeRatio;
164         team = _team;
165         emit Transfer(address(0), _creator, _initSupply);
166     }
167 
168     function transfer(address to, uint256 amount) public returns (bool) {
169         _transfer(msg.sender,to,amount);
170         return true;
171     }
172 
173     function balanceOf(address owner) public view returns (uint256 balance) {
174         return balances[owner];
175     }
176 
177     function transferFrom(
178         address from,
179         address to,
180         uint256 amount
181     ) public returns (bool) {
182         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
183         _transfer(from,to,amount);
184         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
185         return true;
186     }
187 
188     function approve(address spender, uint256 amount) public returns (bool) {
189         allowed[msg.sender][spender] = amount;
190         emit Approval(msg.sender, spender, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view returns (uint256) {
195         return allowed[owner][spender];
196     }
197 
198 
199     function _transfer(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206         require(balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
207 
208         balances[sender] = balances[sender].sub(amount);
209 
210         uint256 burnAmount;
211         uint256 feeAmount;
212         if(tradeBurnRatio > 0) {
213             burnAmount = amount.mul(tradeBurnRatio).div(10000);
214             balances[address(0)] = balances[address(0)].add(burnAmount);
215             emit Transfer(sender, address(0), burnAmount);
216         }
217 
218         if(tradeFeeRatio > 0) {
219             feeAmount = amount.mul(tradeFeeRatio).div(10000);
220             balances[team] = balances[team].add(feeAmount);
221             emit Transfer(sender, team, feeAmount);
222         }
223         
224         uint256 receiveAmount = amount.sub(burnAmount).sub(feeAmount);
225         balances[recipient] = balances[recipient].add(receiveAmount);
226 
227         emit Transfer(sender, recipient, receiveAmount);
228     }
229 
230     function burn(uint256 value) external {
231         require(balances[msg.sender] >= value, "VALUE_NOT_ENOUGH");
232 
233         balances[msg.sender] = balances[msg.sender].sub(value);
234         totalSupply = totalSupply.sub(value);
235         emit Burn(msg.sender, value);
236         emit Transfer(msg.sender, address(0), value);
237     }
238 
239     //=================== Ownable ======================
240     function mint(address user, uint256 value) external onlyOwner {
241         require(user == _OWNER_, "NOT_OWNER");
242         
243         balances[user] = balances[user].add(value);
244         totalSupply = totalSupply.add(value);
245         emit Mint(user, value);
246         emit Transfer(address(0), user, value);
247     }
248 
249     function changeTeamAccount(address newTeam) external onlyOwner {
250         require(tradeFeeRatio > 0, "NOT_TRADE_FEE_TOKEN");
251         emit ChangeTeam(team,newTeam);
252         team = newTeam;
253     }
254 
255     function abandonOwnership(address zeroAddress) external onlyOwner {
256         require(zeroAddress == address(0), "NOT_ZERO_ADDRESS");
257         emit OwnershipTransferred(_OWNER_, address(0));
258         _OWNER_ = address(0);
259     }
260 }