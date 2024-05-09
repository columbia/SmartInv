1 pragma solidity 0.5.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     require(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20 {
35   function totalSupply()public view returns (uint256 total_Supply);
36   function balanceOf(address who)public view returns (uint256);
37   function allowance(address owner, address spender)public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value)public returns (bool ok);
39   function approve(address spender, uint256 value)public returns (bool ok);
40   function transfer(address to, uint256 value)public returns (bool ok);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract WOWX is ERC20 { 
46     using SafeMath for uint256;
47     //--- Token configurations ----// 
48     string private constant _name = "WOWX Token";
49     string private constant _symbol = "WOWX";
50     uint8 private constant _decimals = 18;
51     uint256 private constant _maxCap = 185000000 ether;
52 
53     //--- Milestones --------------//
54     uint256 private _icoStartDate = 1551412800;   // 01-03-2019 12:00 GMT+8
55     uint256 private _icoEndDate = 1561867200;     // 30-06-2019 12:00 GMT+8
56     
57     //--- Token allocations -------//
58     uint256 private _totalsupply;
59 
60     //--- Address -----------------//
61     address private _owner;
62     address private _walletWowX;
63     address payable private _ethFundMain;
64     
65     //--- Variables ---------------//
66     bool private _lockToken = true;
67     bool private _allowICO = true;
68     
69     mapping(address => uint256) private balances;
70     mapping(address => mapping(address => uint256)) private allowed;
71     mapping(address => bool) private locked;
72     
73     event Mint(address indexed from, address indexed to, uint256 amount);
74     event Burn(address indexed from, uint256 amount);
75     event ChangeReceiveWallet(address indexed newAddress);
76     event ChangeOwnerShip(address indexed newOwner);
77     event ChangeWowxWallet(address indexed newAddress);
78     event ChangeLockStatusFrom(address indexed investor, bool locked);
79     event ChangeTokenLockStatus(bool locked);
80     event ChangeAllowICOStatus(bool allow);
81     
82     modifier onlyOwner() {
83         require(msg.sender == _owner, "Only owner is allowed");
84         _;
85     }
86 
87     modifier onlyICO() {
88         require(now >= _icoStartDate && now < _icoEndDate, "CrowdSale is not running");
89         _;
90     }
91 
92     modifier onlyFinishedICO() {
93         require(now >= _icoEndDate, "CrowdSale is running");
94         _;
95     }
96     
97     modifier onlyAllowICO() {
98         require(_allowICO, "ICO stopped");
99         _;
100     }
101     
102     modifier onlyUnlockToken() {
103         require(!_lockToken, "Token locked");
104         _;
105     }
106 
107     constructor() public
108     {
109         _owner = msg.sender;
110     }
111     
112     function name() public pure returns (string memory) {
113         return _name;
114     }
115     
116     function symbol() public pure returns (string memory) {
117         return _symbol;
118     }
119     
120     function decimals() public pure returns (uint8) {
121         return _decimals;
122     }
123     
124     function maxCap() public pure returns (uint256) {
125         return _maxCap;
126     }
127     
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     function walletWowX() public view returns (address) {
133         return _walletWowX;
134     }
135     
136     function ethFundMain() public view returns (address) {
137         return _ethFundMain;
138     }
139     
140     function icoStartDate() public view returns (uint256) {
141         return _icoStartDate;
142     }
143     
144     function icoEndDate() public view returns (uint256) {
145         return _icoEndDate;
146     }
147     
148     function lockToken() public view returns (bool) {
149         return _lockToken;
150     }
151     
152     function allowICO() public view returns (bool) {
153         return _allowICO;
154     }
155     
156     function lockStatusFrom(address investor) public view returns (bool) {
157         return locked[investor];
158     }
159 
160     function totalSupply() public view returns (uint256) {
161         return _totalsupply;
162     }
163     
164     function balanceOf(address investor) public view returns (uint256) {
165         return balances[investor];
166     }
167     
168     function approve(address _spender, uint256 _amount) public onlyFinishedICO onlyUnlockToken returns (bool)  {
169         require( _spender != address(0), "Address can not be 0x0");
170         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
171         require(!locked[msg.sender], "Sender address is locked");
172         require(!locked[_spender], "Sender address is locked");
173         allowed[msg.sender][_spender] = _amount;
174         emit Approval(msg.sender, _spender, _amount);
175         return true;
176     }
177   
178     function allowance(address _from, address _spender) public view returns (uint256) {
179         return allowed[_from][_spender];
180     }
181 
182     function transfer(address _to, uint256 _amount) public onlyFinishedICO onlyUnlockToken returns (bool) {
183         require( _to != address(0), "Receiver can not be 0x0");
184         require(!locked[msg.sender], "Sender address is locked");
185         require(!locked[_to], "Receiver address is locked");
186         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
187         balances[_to] = (balances[_to]).add(_amount);
188         emit Transfer(msg.sender, _to, _amount);
189         return true;
190     }
191     
192     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO onlyUnlockToken returns (bool)  {
193         require( _to != address(0), "Receiver can not be 0x0");
194         require(!locked[_from], "From address is locked");
195         require(!locked[_to], "Receiver address is locked");
196         balances[_from] = (balances[_from]).sub(_amount);
197         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
198         balances[_to] = (balances[_to]).add(_amount);
199         emit Transfer(_from, _to, _amount);
200         return true;
201     }
202 
203     function burn(uint256 _value) public onlyOwner returns (bool) {
204         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
205         _totalsupply = _totalsupply.sub(_value);                     
206         emit Burn(msg.sender, _value);
207         return true;
208     }
209 
210     function stopTransferToken() external onlyOwner onlyFinishedICO {
211         _lockToken = true;
212         emit ChangeTokenLockStatus(true);
213     }
214 
215     function startTransferToken() external onlyOwner onlyFinishedICO {
216         _lockToken = false;
217         emit ChangeTokenLockStatus(false);
218     }
219 
220     function () external payable onlyICO onlyAllowICO {
221         
222     }
223 
224     function manualMint(address receiver, uint256 _value) public onlyOwner{
225         mint(_owner, receiver, _value);
226     }
227 
228     function mint(address from, address receiver, uint256 value) internal {
229         require(receiver != address(0), "Address can not be 0x0");
230         require(_walletWowX != address(0), "Address can not be 0x0");
231         require(value > 0, "Value should larger than 0");
232         balances[receiver] = balances[receiver].add(value);
233         uint256 wowxShare = value;
234         balances[_walletWowX] = balances[_walletWowX] + wowxShare;
235         _totalsupply = _totalsupply.add(value).add(wowxShare);
236         require(_totalsupply <= _maxCap, "CrowdSale hit max cap");
237         emit Mint(from, receiver, value);
238         emit Transfer(address(0), receiver, value);
239         emit Mint(from, _walletWowX, wowxShare);
240         emit Transfer(address(0), _walletWowX, wowxShare);
241     }
242     
243     function haltCrowdSale() external onlyOwner {
244         _allowICO = false;
245         emit ChangeAllowICOStatus(false);
246     }
247 
248     function resumeCrowdSale() external onlyOwner {
249         _allowICO = true;
250         emit ChangeAllowICOStatus(true);
251     }
252 
253     function changeReceiveWallet(address payable newAddress) external onlyOwner {
254         require(newAddress != address(0), "Address can not be 0x0");
255         _ethFundMain = newAddress;
256         emit ChangeReceiveWallet(newAddress);
257     }
258 
259     function setWowxWallet(address newAddress) external onlyOwner {
260         require(newAddress != address(0), "Address can not be 0x0");
261         uint256 _wowxBalance = balances[_walletWowX];
262         balances[newAddress] = (balances[newAddress]).add(_wowxBalance);
263         balances[_walletWowX] = 0;
264         emit Transfer(_walletWowX, newAddress, _wowxBalance);
265 	    _walletWowX = newAddress;
266 	    emit ChangeWowxWallet(newAddress);
267     }
268 
269 	function assignOwnership(address newOwner) external onlyOwner {
270 	    require(newOwner != address(0), "Address can not be 0x0");
271 	    _owner = newOwner;
272 	    emit ChangeOwnerShip(newOwner);
273 	}
274 
275     function forwardFunds() external onlyOwner {
276         require(_ethFundMain != address(0));
277         _ethFundMain.transfer(address(this).balance);
278     }
279 
280     function haltTokenTransferFromAddress(address investor) external onlyOwner {
281         locked[investor] = true;
282         emit ChangeLockStatusFrom(investor, true);
283     }
284 
285     function resumeTokenTransferFromAddress(address investor) external onlyOwner {
286         locked[investor] = false;
287         emit ChangeLockStatusFrom(investor, false);
288     }
289 }