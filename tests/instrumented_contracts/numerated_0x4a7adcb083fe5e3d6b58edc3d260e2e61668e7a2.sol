1 /*
2 LOCAL LIMIT TRADING ON UNISWAP
3 
4 https://tradebutler.tools
5 
6 Trade Butler is a local bot application for convenient trading on UNISWAP. 
7 Limit orders, stop orders, trailing stops and buys and other features
8 that are usually available on traditional exchanges.
9 
10 You can download the bot and start trading at the above website.
11 */
12 
13 pragma solidity ^0.5.1;
14 
15 library SafeMath {
16 
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27 
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         return mod(a, b, "SafeMath: modulo by zero");
61     }
62 
63     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b != 0, errorMessage);
65         return a % b;
66     }
67 }
68 
69 contract Ownable{
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () internal {
75         _owner = msg.sender;
76         emit OwnershipTransferred(address(0), msg.sender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(isOwner(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function isOwner() public view returns (bool) {
89         return msg.sender == _owner;
90     }
91 
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97     function transferOwnership(address newOwner) public onlyOwner {
98         _transferOwnership(newOwner);
99     }
100 
101     function _transferOwnership(address newOwner) internal {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 contract ERC20 is Ownable{
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowances;
114 
115     string public constant name = "Trade Butler Bot";
116     string public constant symbol = "TBB";
117     uint public constant decimals = 18;
118     uint constant total = 2000;
119     uint256 private _totalSupply;
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 
124     constructor() public {
125         _mint(msg.sender, total * 10**decimals);
126     }
127 
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply;
130     }
131 
132     function balanceOf(address account) public view returns (uint256) {
133         return _balances[account];
134     }
135 
136     function transfer(address recipient, uint256 amount) public returns (bool) {
137         _transfer(msg.sender, recipient, amount);
138         return true;
139     }
140 
141     function allowance(address owner, address spender) public view returns (uint256) {
142         return _allowances[owner][spender];
143     }
144 
145     function approve(address spender, uint256 amount) public returns (bool) {
146         _approve(msg.sender, spender, amount);
147         return true;
148     }
149 
150     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
151         _transfer(sender, recipient, amount);
152         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
153         return true;
154     }
155 
156     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
157         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
158         return true;
159     }
160 
161     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
162         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
163         return true;
164     }
165 
166     function _transfer(address sender, address recipient, uint256 amount) internal {
167         require(sender != address(0), "ERC20: transfer from the zero address");
168         require(recipient != address(0), "ERC20: transfer to the zero address");
169 
170         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
171         _balances[recipient] = _balances[recipient].add(amount);
172         emit Transfer(sender, recipient, amount);
173     }
174 
175     function _mint(address account, uint256 amount) internal {
176         require(account != address(0), "ERC20: mint to the zero address");
177 
178         _totalSupply = _totalSupply.add(amount);
179         _balances[account] = _balances[account].add(amount);
180         emit Transfer(address(0), account, amount);
181     }
182 
183     function _approve(address owner, address spender, uint256 amount) internal {
184         require(owner != address(0), "ERC20: approve from the zero address");
185         require(spender != address(0), "ERC20: approve to the zero address");
186 
187         _allowances[owner][spender] = amount;
188         emit Approval(owner, spender, amount);
189     }
190 
191 }
192 
193 
194 contract Presale {
195     address payable owner;
196     address me = address(this);
197     
198     // *** Config ***
199     uint startPresale = 1608397200; // unix timestamp for presale to go live - 19-12-2020 17:00:00 UTC
200     uint percentSell = 50;          // 1,000 token presale
201     uint256 pricePresale = 3;       // 0.3 ETH
202     uint256 maxPerWallet = 6 ether; // Max 6 ETH per Wallet
203     // --- Config ---
204 
205     ERC20 token = new ERC20();
206     
207     constructor() public {
208         owner = msg.sender;
209         token.transfer(owner, token.totalSupply() / 100 * (100 - percentSell));
210     }
211 
212     function() external payable {
213         require(startPresale <= now, "Presale has not yet started");
214         uint amount = msg.value / pricePresale * 10;
215         require(amount <= token.balanceOf(address(this)), "Insufficient token balance in ICO");
216         require((amount + token.balanceOf(address(msg.sender)) <= (maxPerWallet / pricePresale * 10) ), "Over Max Per Wallet");
217         token.transfer(msg.sender, amount);
218     }
219     
220     function manualGetETH() public payable {
221         require(msg.sender == owner, "You are not the owner!");
222         owner.transfer(address(this).balance);
223     }
224     
225     function getLeftTokens() public {
226         require(msg.sender == owner, "You are not the owner!");
227         token.transfer(owner, token.balanceOf(address(this)));
228     }
229     
230     
231     // Utils
232     function getStartICO() public view returns (uint) {
233         return startPresale - now;
234     }
235     function tokenAddress() public view returns (address){
236         return address(token);
237     }
238     function ICO_deposit() public view returns(uint){
239         return token.balanceOf(address(this));
240     }
241     function myBalance() public view returns(uint){
242         return token.balanceOf(msg.sender);
243     }
244 }