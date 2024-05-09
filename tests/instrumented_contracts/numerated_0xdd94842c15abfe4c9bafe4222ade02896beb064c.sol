1 pragma solidity 0.5.4;
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
45 contract WGP is ERC20 { 
46     using SafeMath for uint256;
47     //--- Token configurations ----// 
48     string private constant _name = "W GREEN PAY";
49     string private constant _symbol = "WGP";
50     uint8 private constant _decimals = 18;
51     uint256 private constant _maxCap = 600000000 ether;
52     uint256 private _icoStartDate = 1538366400;   // 01-10-2018 12:00 GMT+8
53     uint256 private _icoEndDate = 1539489600;     // 14-10-2018 12:00 GMT+8
54     
55     //--- Token allocations -------//
56     uint256 private _totalsupply;
57 
58     //--- Address -----------------//
59     address private _owner;
60     address payable private _ethFundMain;
61    
62     //--- Variables ---------------//
63     bool private _lockToken = false;
64     bool private _allowICO = true;
65     
66     mapping(address => uint256) private balances;
67     mapping(address => mapping(address => uint256)) private allowed;
68     mapping(address => bool) private locked;
69     
70     event Mint(address indexed from, address indexed to, uint256 amount);
71     event Burn(address indexed from, uint256 amount);
72     event ChangeReceiveWallet(address indexed newAddress);
73     event ChangeOwnerShip(address indexed newOwner);
74     event ChangeLockStatusFrom(address indexed investor, bool locked);
75     event ChangeTokenLockStatus(bool locked);
76     event ChangeAllowICOStatus(bool allow);
77     
78     modifier onlyOwner() {
79         require(msg.sender == _owner, "Only owner is allowed");
80         _;
81     }
82 
83     modifier onlyICO() {
84         require(now >= _icoStartDate && now < _icoEndDate, "CrowdSale is not running");
85         _;
86     }
87 
88     modifier onlyFinishedICO() {
89         require(now >= _icoEndDate, "CrowdSale is running");
90         _;
91     }
92     
93     modifier onlyAllowICO() {
94         require(_allowICO, "ICO stopped");
95         _;
96     }
97     
98     modifier onlyUnlockToken() {
99         require(!_lockToken, "Token locked");
100         _;
101     }
102 
103     constructor() public
104     {
105         _owner = msg.sender;
106     }
107     
108     function name() public pure returns (string memory) {
109         return _name;
110     }
111     
112     function symbol() public pure returns (string memory) {
113         return _symbol;
114     }
115     
116     function decimals() public pure returns (uint8) {
117         return _decimals;
118     }
119     
120     function maxCap() public pure returns (uint256) {
121         return _maxCap;
122     }
123     
124     function owner() public view returns (address) {
125         return _owner;
126     }
127     
128     function ethFundMain() public view returns (address) {
129         return _ethFundMain;
130     }
131     
132     function icoStartDate() public view returns (uint256) {
133         return _icoStartDate;
134     }
135     
136     function icoEndDate() public view returns (uint256) {
137         return _icoEndDate;
138     }
139     
140     function lockToken() public view returns (bool) {
141         return _lockToken;
142     }
143     
144     function allowICO() public view returns (bool) {
145         return _allowICO;
146     }
147     
148     function lockStatusOf(address investor) public view returns (bool) {
149         return locked[investor];
150     }
151 
152     function totalSupply() public view returns (uint256) {
153         return _totalsupply;
154     }
155     
156     function balanceOf(address investor) public view returns (uint256) {
157         return balances[investor];
158     }
159     
160     function approve(address _spender, uint256 _amount) public onlyFinishedICO onlyUnlockToken returns (bool)  {
161         require( _spender != address(0), "Address can not be 0x0");
162         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
163         require(!locked[msg.sender], "Sender address is locked");
164         require(!locked[_spender], "Spender address is locked");
165         allowed[msg.sender][_spender] = _amount;
166         emit Approval(msg.sender, _spender, _amount);
167         return true;
168     }
169   
170     function allowance(address _from, address _spender) public view returns (uint256) {
171         return allowed[_from][_spender];
172     }
173 
174     function transfer(address _to, uint256 _amount) public onlyFinishedICO onlyUnlockToken returns (bool) {
175         require( _to != address(0), "Receiver can not be 0x0");
176         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
177         require(!locked[msg.sender], "Sender address is locked");
178         require(!locked[_to], "Receiver address is locked");
179         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
180         balances[_to] = (balances[_to]).add(_amount);
181         emit Transfer(msg.sender, _to, _amount);
182         return true;
183     }
184     
185     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO onlyUnlockToken returns (bool)  {
186         require( _to != address(0), "Receiver can not be 0x0");
187         require(balances[_from] >= _amount, "Source's balance is not enough");
188         require(allowed[_from][msg.sender] >= _amount, "Allowance is not enough");
189         require(!locked[_from], "From address is locked");
190         require(!locked[_to], "Receiver address is locked");
191         balances[_from] = (balances[_from]).sub(_amount);
192         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
193         balances[_to] = (balances[_to]).add(_amount);
194         emit Transfer(_from, _to, _amount);
195         return true;
196     }
197 
198     function burn(uint256 _value) public onlyOwner returns (bool) {
199         require(balances[msg.sender] >= _value, "Balance does not have enough tokens");   
200         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
201         _totalsupply = _totalsupply.sub(_value);                     
202         emit Burn(msg.sender, _value);
203         return true;
204     }
205 
206     function stopTransferToken() external onlyOwner onlyFinishedICO {
207         _lockToken = true;
208         emit ChangeTokenLockStatus(true);
209     }
210 
211     function startTransferToken() external onlyOwner onlyFinishedICO {
212         _lockToken = false;
213         emit ChangeTokenLockStatus(false);
214     }
215 
216     function () external payable onlyICO onlyAllowICO {
217         
218     }
219 
220     function manualMint(address receiver, uint256 _value) public onlyOwner{
221         uint256 value = _value.mul(10 ** 18);
222         mint(_owner, receiver, value);
223     }
224 
225     function mint(address from, address receiver, uint256 value) internal {
226         require(receiver != address(0), "Address can not be 0x0");
227         require(value > 0, "Value should larger than 0");
228         balances[receiver] = balances[receiver].add(value);
229         _totalsupply = _totalsupply.add(value);
230         require(_totalsupply <= _maxCap, "CrowdSale hit max cap");
231         emit Mint(from, receiver, value);
232         emit Transfer(address(0), receiver, value);
233     }
234     
235     function haltCrowdSale() external onlyOwner {
236         _allowICO = false;
237         emit ChangeAllowICOStatus(false);
238     }
239 
240     function resumeCrowdSale() external onlyOwner {
241         _allowICO = true;
242         emit ChangeAllowICOStatus(true);
243     }
244 
245     function changeReceiveWallet(address payable newAddress) external onlyOwner {
246         require(newAddress != address(0), "Address can not be 0x0");
247         _ethFundMain = newAddress;
248         emit ChangeReceiveWallet(newAddress);
249     }
250 
251 	function assignOwnership(address newOwner) external onlyOwner {
252 	    require(newOwner != address(0), "Address can not be 0x0");
253 	    _owner = newOwner;
254 	    emit ChangeOwnerShip(newOwner);
255 	}
256 
257     function forwardFunds() external onlyOwner {
258         require(_ethFundMain != address(0));
259         _ethFundMain.transfer(address(this).balance);
260     }
261 
262     function haltTokenTransferFromAddress(address investor) external onlyOwner {
263         locked[investor] = true;
264         emit ChangeLockStatusFrom(investor, true);
265     }
266 
267     function resumeTokenTransferFromAddress(address investor) external onlyOwner {
268         locked[investor] = false;
269         emit ChangeLockStatusFrom(investor, false);
270     }
271 }