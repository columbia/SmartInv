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
119 // File: contracts/external/ERC20/CustomERC20.sol
120 
121 
122 contract CustomERC20 is InitializableOwnable {
123     using SafeMath for uint256;
124 
125     string public name;
126     uint8 public decimals;
127     string public symbol;
128     uint256 public totalSupply;
129 
130     uint256 public tradeBurnRatio;
131     uint256 public tradeFeeRatio;
132     address public team;
133 
134     mapping(address => uint256) balances;
135     mapping(address => mapping(address => uint256)) internal allowed;
136 
137     event Transfer(address indexed from, address indexed to, uint256 amount);
138     event Approval(address indexed owner, address indexed spender, uint256 amount);
139 
140     event ChangeTeam(address oldTeam, address newTeam);
141 
142 
143     function init(
144         address _creator,
145         uint256 _totalSupply,
146         string memory _name,
147         string memory _symbol,
148         uint8 _decimals,
149         uint256 _tradeBurnRatio,
150         uint256 _tradeFeeRatio,
151         address _team
152     ) public {
153         initOwner(_creator);
154         name = _name;
155         symbol = _symbol;
156         decimals = _decimals;
157         totalSupply = _totalSupply;
158         balances[_creator] = _totalSupply;
159         require(_tradeBurnRatio >= 0 && _tradeBurnRatio <= 5000, "TRADE_BURN_RATIO_INVALID");
160         require(_tradeFeeRatio >= 0 && _tradeFeeRatio <= 5000, "TRADE_FEE_RATIO_INVALID");
161         tradeBurnRatio = _tradeBurnRatio;
162         tradeFeeRatio = _tradeFeeRatio;
163         team = _team;
164         emit Transfer(address(0), _creator, _totalSupply);
165     }
166 
167     function transfer(address to, uint256 amount) public returns (bool) {
168         _transfer(msg.sender,to,amount);
169         return true;
170     }
171 
172     function balanceOf(address owner) public view returns (uint256 balance) {
173         return balances[owner];
174     }
175 
176     function transferFrom(
177         address from,
178         address to,
179         uint256 amount
180     ) public returns (bool) {
181         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
182         _transfer(from,to,amount);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
184         return true;
185     }
186 
187     function approve(address spender, uint256 amount) public returns (bool) {
188         allowed[msg.sender][spender] = amount;
189         emit Approval(msg.sender, spender, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view returns (uint256) {
194         return allowed[owner][spender];
195     }
196 
197 
198     function _transfer(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) internal virtual {
203         require(sender != address(0), "ERC20: transfer from the zero address");
204         require(recipient != address(0), "ERC20: transfer to the zero address");
205         require(balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
206 
207         balances[sender] = balances[sender].sub(amount);
208 
209         uint256 burnAmount;
210         uint256 feeAmount;
211         if(tradeBurnRatio > 0) {
212             burnAmount = amount.mul(tradeBurnRatio).div(10000);
213             balances[address(0)] = balances[address(0)].add(burnAmount);
214             emit Transfer(sender, address(0), burnAmount);
215         }
216 
217         if(tradeFeeRatio > 0) {
218             feeAmount = amount.mul(tradeFeeRatio).div(10000);
219             balances[team] = balances[team].add(feeAmount);
220             emit Transfer(sender, team, feeAmount);
221         }
222         
223         uint256 receiveAmount = amount.sub(burnAmount).sub(feeAmount);
224         balances[recipient] = balances[recipient].add(receiveAmount);
225 
226         emit Transfer(sender, recipient, receiveAmount);
227     }
228 
229 
230     //=================== Ownable ======================
231     function changeTeamAccount(address newTeam) external onlyOwner {
232         require(tradeFeeRatio > 0, "NOT_TRADE_FEE_TOKEN");
233         emit ChangeTeam(team,newTeam);
234         team = newTeam;
235     }
236 
237     function abandonOwnership(address zeroAddress) external onlyOwner {
238         require(zeroAddress == address(0), "NOT_ZERO_ADDRESS");
239         emit OwnershipTransferred(_OWNER_, address(0));
240         _OWNER_ = address(0);
241     }
242 }