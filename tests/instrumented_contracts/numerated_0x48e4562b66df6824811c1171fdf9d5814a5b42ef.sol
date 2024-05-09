1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(owner, address(0));
56         owner = address(0);
57     }
58 }
59 
60 contract Pausable is Ownable {
61     bool public paused;
62     
63     event Paused(address account);
64     event Unpaused(address account);
65 
66     constructor() internal {
67         paused = false;
68     }
69 
70     modifier whenNotPaused() {
71         require(!paused);
72         _;
73     }
74 
75     modifier whenPaused() {
76         require(paused);
77         _;
78     }
79 
80     function pause() public onlyOwner whenNotPaused {
81         paused = true;
82         emit Paused(msg.sender);
83     }
84 
85     function unpause() public onlyOwner whenPaused {
86         paused = false;
87         emit Unpaused(msg.sender);
88     }
89 }
90 
91 contract BaseToken is Pausable {
92     using SafeMath for uint256;
93 
94     string constant public name = '华夏以太坊基金';
95     string constant public symbol = 'HXETH';
96     uint8 constant public decimals = 0;
97     uint256 public totalSupply = 0;
98     uint256 constant public _totalLimit = 100000000000000;
99 
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106     function _transfer(address from, address to, uint value) internal {
107         require(to != address(0));
108         balanceOf[from] = balanceOf[from].sub(value);
109         balanceOf[to] = balanceOf[to].add(value);
110         emit Transfer(from, to, value);
111     }
112 
113     function _mint(address account, uint256 value) internal {
114         require(account != address(0));
115         totalSupply = totalSupply.add(value);
116         require(_totalLimit >= totalSupply);
117         balanceOf[account] = balanceOf[account].add(value);
118         emit Transfer(address(0), account, value);
119     }
120 
121     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
124     }
125 
126     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
127         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
128         _transfer(from, to, value);
129         return true;
130     }
131 
132     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
133         require(spender != address(0));
134         allowance[msg.sender][spender] = value;
135         emit Approval(msg.sender, spender, value);
136         return true;
137     }
138 
139     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
140         require(spender != address(0));
141         allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);
142         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
143         return true;
144     }
145 
146     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
147         require(spender != address(0));
148         allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);
149         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
150         return true;
151     }
152 }
153 
154 contract BurnToken is BaseToken {
155     event Burn(address indexed from, uint256 value);
156 
157     function burn(uint256 value) public whenNotPaused returns (bool) {
158         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
159         totalSupply = totalSupply.sub(value);
160         emit Burn(msg.sender, value);
161         return true;
162     }
163 
164     function burnFrom(address from, uint256 value) public whenNotPaused returns (bool) {
165         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
166         balanceOf[from] = balanceOf[from].sub(value);
167         totalSupply = totalSupply.sub(value);
168         emit Burn(from, value);
169         return true;
170     }
171 }
172 
173 contract InvestToken is BaseToken {
174     uint256 constant public investMax = 0;
175     uint256 public investTotal = 0;
176     uint256 public investEther = 0;
177     uint256 public investMin = 0;
178     uint256 public investRatio = 0;
179     uint256 public investBegintime = 1554726130;
180     uint256 public investEndtime = 1554726130;
181     address public investHolder = 0xbCADE28d8C2F22345165f0e07C94A600f6C4e925;
182 
183     event Invest(address indexed from, uint256 indexed ratio, uint256 value, uint256 tokenValue);
184     event Withdraw(address indexed from, address indexed holder, uint256 value);
185     event InvestSetting(uint256 investMin, uint256 investRatio, uint256 investBegintime, uint256 investEndtime, address investHolder);
186 
187     function invest() public payable {
188         require(block.timestamp >= investBegintime && block.timestamp <= investEndtime);
189         require(msg.value >= investMin);
190         uint256 tokenValue = (msg.value * investRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
191         require(tokenValue > 0);
192         investTotal = investTotal.add(tokenValue);
193         if (investMax > 0 && investTotal > investMax) {
194             revert();
195         }
196         investEther = investEther.add(msg.value);
197         _mint(msg.sender, tokenValue);
198         emit Invest(msg.sender, investRatio, msg.value, tokenValue);
199     }
200 
201     function withdraw() public {
202         uint256 balance = address(this).balance;
203         investHolder.transfer(balance);
204         emit Withdraw(msg.sender, investHolder, balance);
205     }
206 
207     function changeInvestSetting(uint256 newInvestMin, uint256 newInvestRatio, uint256 newInvestBegintime, uint256 newInvestEndtime, address newInvestHolder) public onlyOwner {
208         require(newInvestRatio <= 999999999);
209         investMin = newInvestMin;
210         investRatio = newInvestRatio;
211         investBegintime = newInvestBegintime;
212         investEndtime = newInvestEndtime;
213         investHolder = newInvestHolder;
214         emit InvestSetting(newInvestMin, newInvestRatio, newInvestBegintime, newInvestEndtime, newInvestHolder);
215     }
216 }
217 
218 contract CustomToken is BaseToken, BurnToken, InvestToken {
219     constructor() public {
220 
221         owner = 0xbCADE28d8C2F22345165f0e07C94A600f6C4e925;
222     }
223 
224     function() public payable {
225         invest();
226     }
227 }