1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         // Solidity only automatically asserts when dividing by 0
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43 
44         return c;
45     }
46 
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 }
56 
57 contract Ownable{
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     constructor () internal {
63         _owner = msg.sender;
64         emit OwnershipTransferred(address(0), msg.sender);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(isOwner(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function isOwner() public view returns (bool) {
77         return msg.sender == _owner;
78     }
79 
80     function renounceOwnership() public onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     function transferOwnership(address newOwner) public onlyOwner {
86         _transferOwnership(newOwner);
87     }
88 
89     function _transferOwnership(address newOwner) internal {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 contract ERC20 is Ownable {
97     using SafeMath for uint256;
98 
99     mapping (address => uint256) private _balances;
100 
101     mapping (address => mapping (address => uint256)) private _allowances;
102 
103     // Addresses that will not be taxed
104     struct ExcludeAddress {bool isExist;}
105 
106     mapping (address => ExcludeAddress) public excludeSendersAddresses;
107     mapping (address => ExcludeAddress) public excludeRecipientsAddresses;
108 
109     address serviceWallet;
110 
111     uint taxPercent = 4;
112 
113     // Token params
114     string public constant name = "UniDexGas.com";
115     string public constant symbol = "UNDG";
116     uint public constant decimals = 18;
117     uint constant total = 10000;
118     uint256 private _totalSupply;
119     // -- Token params
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
137         _taxTransfer(msg.sender, recipient, amount);
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
151         _taxTransfer(sender, recipient, amount);
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
191      function _taxTransfer(address _sender, address _recipient, uint256 _amount) internal returns (bool) {
192 
193        if(!excludeSendersAddresses[_sender].isExist && !excludeRecipientsAddresses[_recipient].isExist){
194         uint _taxedAmount = _amount.mul(taxPercent).div(100);
195         uint _transferedAmount = _amount.sub(_taxedAmount);
196 
197         _transfer(_sender, serviceWallet, _taxedAmount); // tax to serviceWallet
198         _transfer(_sender, _recipient, _transferedAmount); // amount - tax to recipient
199        } else {
200         _transfer(_sender, _recipient, _amount);
201        }
202 
203         return true;
204     }
205 
206 
207 
208     // OWNER utils
209     function setAddressToExcludeRecipients (address addr) public onlyOwner {
210         excludeRecipientsAddresses[addr] = ExcludeAddress({isExist:true});
211     }
212 
213     function setAddressToExcludeSenders (address addr) public onlyOwner {
214         excludeSendersAddresses[addr] = ExcludeAddress({isExist:true});
215     }
216 
217     function removeAddressFromExcludes (address addr) public onlyOwner {
218         excludeSendersAddresses[addr] = ExcludeAddress({isExist:false});
219         excludeRecipientsAddresses[addr] = ExcludeAddress({isExist:false});
220     }
221 
222     function changePercentOfTax(uint percent) public onlyOwner {
223         taxPercent = percent;
224     }
225 
226     function changeServiceWallet(address addr) public onlyOwner {
227         serviceWallet = addr;
228     }
229 }
230 
231 
232 contract Crowdsale {
233     address payable owner;
234     address me = address(this);
235     uint sat = 1e18;
236 
237     // *** Config ***
238     uint startIco = 1610632800;
239     uint stopIco = startIco + 72 hours;
240     
241     uint percentSell = 35;
242     uint manualSaleAmount = 0 * sat;
243     
244     uint countIfUNDB = 700000; // 1ETH -> 7 UNDG
245     uint countIfOther = 650000; // 1 ETH -> 6.5 UNDG
246     
247     uint maxTokensToOnceHand = 130 * sat; // ~20 ETH for 14.01.2021 
248     address undbAddress = 0xd03B6ae96CaE26b743A6207DceE7Cbe60a425c70;
249     uint undbMinBalance = 1e17; //0.1 UNDB
250     // --- Config ---
251 
252 
253     uint priceDecimals = 1e5; // realPrice = Price / priceDecimals
254     ERC20 UNDB = ERC20(undbAddress);
255     ERC20 token = new ERC20();
256 
257     constructor() public {
258         owner = msg.sender;
259         token.setAddressToExcludeRecipients(owner);
260         token.setAddressToExcludeSenders(owner);
261         token.changeServiceWallet(owner);
262         token.setAddressToExcludeSenders(address(this));
263         token.transferOwnership(owner);
264         token.transfer(owner, token.totalSupply() / 100 * (100 - percentSell) + manualSaleAmount);
265     }
266 
267     function() external payable {
268         require(startIco < now && now < stopIco, "Period error");
269         uint amount = msg.value * getPrice() / priceDecimals;
270         require(token.balanceOf(msg.sender) + amount <= maxTokensToOnceHand, "The purchase limit of 130 tokens has been exceeded");
271         require(amount <= token.balanceOf(address(this)), "Infucient token balance in ICO");
272         token.transfer(msg.sender, amount);
273     }
274 
275 
276     // OWNER ONLY
277     function manualGetETH() public payable {
278         require(msg.sender == owner, "You is not owner");
279         owner.transfer(address(this).balance);
280     }
281 
282     function getLeftTokens() public {
283         require(msg.sender == owner, "You is not owner");
284         token.transfer(owner, token.balanceOf(address(this)));
285     }
286     //--- OWNER ONLY
287 
288     function getPrice() public view returns (uint) {
289         return (UNDB.balanceOf(msg.sender) >= undbMinBalance ? countIfUNDB : countIfOther);
290     }
291 
292     // Utils
293     function getStartICO() public view returns (uint) {
294         return (startIco - now) / 60;
295     }
296     function getOwner() public view returns (address) {
297         return owner;
298     }
299 
300     function getStopIco() public view returns(uint){
301         return (stopIco - now) / 60;
302     }
303     function tokenAddress() public view returns (address){
304         return address(token);
305     }
306     function IcoDeposit() public view returns(uint){
307         return token.balanceOf(address(this)) / sat;
308     }
309     function myBalancex10() public view returns(uint){
310         return token.balanceOf(msg.sender) / 1e17;
311     }
312 }