1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.8;
3 //ERC20 Interface
4 interface ERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address, uint256) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address, uint256) external returns (bool);
10     function transferFrom(address, address, uint256) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13     }
14 
15 interface PerlinDAO {
16     function isPerlinDAO() external view returns (bool);
17 }
18 
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31         return c;
32     }
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b > 0, errorMessage);
38         uint256 c = a / b;
39         return c;
40     }
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 }
50     //======================================PERLIN=========================================//
51 contract Perlin is ERC20 {
52     using SafeMath for uint256;
53 
54     // ERC-20 Parameters
55     string public name; string public symbol;
56     uint256 public decimals; uint256 public override totalSupply;
57 
58     // ERC-20 Mappings
59     mapping(address => uint256) private _balances;
60     mapping(address => mapping(address => uint256)) private _allowances;
61 
62     // Parameters
63     uint256 one;
64     bool public emitting;
65     uint256 public emissionCurve;
66     uint256 baseline;
67     uint256 public totalCap;
68     uint256 public secondsPerEra;
69     uint256 public currentEra;
70     uint256 public nextEraTime;
71 
72     address public incentiveAddress;
73     address public DAO;
74     address public perlin1;
75     address public burnAddress;
76 
77     // Events
78     event NewCurve(address indexed DAO, uint256 newCurve);
79     event NewIncentiveAddress(address indexed DAO, address newIncentiveAddress);
80     event NewDuration(address indexed DAO, uint256 newDuration);
81     event NewDAO(address indexed DAO, address newOwner);
82     event NewEra(uint256 currentEra, uint256 nextEraTime, uint256 emission);
83 
84     // Only DAO can execute
85     modifier onlyDAO() {
86         require(msg.sender == DAO, "Must be DAO");
87         _;
88     }
89 
90     //=====================================CREATION=========================================//
91     // Constructor
92     constructor() public {
93         name = 'Perlin';
94         symbol = 'PERL';
95         decimals = 18;
96         one = 10 ** decimals;
97         totalSupply = 0;
98         totalCap = 3 * 10**9 * one; // 3 billion
99         emissionCurve = 2048;
100         emitting = false;
101         currentEra = 1;
102         secondsPerEra = 86400;
103         nextEraTime = now + secondsPerEra;
104         DAO = 0x3F2a2c502E575f2fd4053c76f4E21623143518d8;
105         perlin1 = 0xb5A73f5Fc8BbdbcE59bfD01CA8d35062e0dad801;
106         baseline = 1033200000 * one; // Perlin1 Inital Supply
107         burnAddress = 0x0000000000000000000000000000000000000001;
108     }
109 
110     //========================================ERC20=========================================//
111     function balanceOf(address account) public view override returns (uint256) {
112         return _balances[account];
113     }
114     function allowance(address owner, address spender) public view virtual override returns (uint256) {
115         return _allowances[owner][spender];
116     }
117     // ERC20 Transfer function
118     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
119         _transfer(msg.sender, recipient, amount);
120         return true;
121     }
122     // ERC20 Approve, change allowance functions
123     function approve(address spender, uint256 amount) public virtual override returns (bool) {
124         _approve(msg.sender, spender, amount);
125         return true;
126     }
127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
128         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
129         return true;
130     }
131     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
132         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
133         return true;
134     }
135     function _approve(address owner, address spender, uint256 amount) internal virtual {
136         require(owner != address(0), "ERC20: approve from the zero address");
137         require(spender != address(0), "ERC20: approve to the zero address");
138         _allowances[owner][spender] = amount;
139         emit Approval(owner, spender, amount);
140     }
141     
142     // ERC20 TransferFrom function
143     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(sender, recipient, amount);
145         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
146         return true;
147     }
148 
149     // Internal transfer function
150     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
151         require(sender != address(0), "ERC20: transfer from the zero address");
152         require(recipient != address(0), "ERC20: transfer to the zero address");
153         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
154         _balances[recipient] = _balances[recipient].add(amount);
155         _checkEmission();
156         emit Transfer(sender, recipient, amount);
157     }
158     // Internal mint (upgrading and daily emissions)
159     function _mint(address account, uint256 amount) internal virtual {
160         require(account != address(0), "ERC20: mint to the zero address");
161         totalSupply = totalSupply.add(amount);
162         require(totalSupply <= totalCap, "Must not mint more than the cap");
163         _balances[account] = _balances[account].add(amount);
164         emit Transfer(address(0), account, amount);
165     }
166     // Burn supply
167     function burn(uint256 amount) public virtual {
168         _burn(msg.sender, amount);
169     }
170     function burnFrom(address account, uint256 amount) public virtual {
171         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "ERC20: burn amount exceeds allowance");
172         _approve(account, msg.sender, decreasedAllowance);
173         _burn(account, amount);
174     }
175     function _burn(address account, uint256 amount) internal virtual {
176         require(account != address(0), "ERC20: burn from the zero address");
177         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
178         totalSupply = totalSupply.sub(amount);
179         emit Transfer(account, address(0), amount);
180     }
181 
182     //=========================================DAO=========================================//
183     // Can start
184     function daoStartEmissions() public onlyDAO {
185         emitting = true;
186     }
187     // Can stop
188     function daoStopEmissions() public onlyDAO {
189         emitting = false;
190     }
191     // Can change emissionCurve
192     function daoChangeEmissionCurve(uint256 newCurve) public onlyDAO {
193         emissionCurve = newCurve;
194         emit NewCurve(msg.sender, newCurve);
195     }
196     // Can change daily time
197     function daoChangeEraDuration(uint256 newDuration) public onlyDAO {
198         require(newDuration >= 100, "Must be greater than 100 seconds");
199         secondsPerEra = newDuration;
200         emit NewDuration(msg.sender, newDuration);
201     }
202     // Can change Incentive Address
203     function daoChangeIncentiveAddress(address newIncentiveAddress) public onlyDAO {
204         incentiveAddress = newIncentiveAddress;
205         emit NewIncentiveAddress(msg.sender, newIncentiveAddress);
206     }
207     // Can change DAO
208     function daoChange(address newDAO) public onlyDAO {
209         if (isContract(newDAO)) {
210             require(PerlinDAO(newDAO).isPerlinDAO(), "Must be DAO");
211         }
212         DAO = newDAO;
213         emit NewDAO(msg.sender, newDAO);
214     }
215     function isContract(address account) internal view returns (bool) {
216         uint256 size;
217         // solhint-disable-next-line no-inline-assembly
218         assembly { size := extcodesize(account) }
219         return size > 0;
220     }
221 
222     // Can purge DAO
223     function daoPurge() public onlyDAO {
224         DAO = address(0);
225         emit NewDAO(msg.sender, address(0));
226     }
227 
228     //======================================EMISSION========================================//
229     // Internal - Update emission function
230     function _checkEmission() private {
231         if ((now >= nextEraTime) && emitting) {                                            // If new Era and allowed to emit
232             currentEra = currentEra.add(1);                                                // Increment Era
233             nextEraTime = now.add(secondsPerEra);                                          // Set next Era time
234             uint256 _emission = getDailyEmission();                                        // Get Daily Dmission
235             _mint(incentiveAddress, _emission);                                            // Mint to the Incentive Address
236             emit NewEra(currentEra, nextEraTime, _emission);                               // Emit Event
237         }
238     }
239     // Calculate Daily Emission
240     function getDailyEmission() public view returns (uint256) {
241         // emission = (adjustedCap - totalSupply) / emissionCurve
242         // adjustedCap = totalCap * (totalSupply / 1bn)
243         uint adjustedCap = (totalCap.mul(totalSupply)).div(baseline);
244         return (adjustedCap.sub(totalSupply)).div(emissionCurve);
245     }
246     //======================================UPGRADE========================================//
247     // Old Owners to Upgrade
248     function upgrade() public {
249         uint balance = ERC20(perlin1).balanceOf(msg.sender);
250         require(ERC20(perlin1).transferFrom(msg.sender, burnAddress, balance));
251         uint factor = 10**9;   // perlin1 had 9 decimals
252         _mint(msg.sender, balance.mul(factor));  // Correct ratio 1 : 10**9
253     }
254 }