1 pragma solidity 0.5.8;
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
45 contract KOZJIN is ERC20 { 
46     using SafeMath for uint256;
47     //--- Token configurations ----// 
48     string private constant _name = "KOZJIN Token";
49     string private constant _symbol = "KOZ";
50     uint8 private constant _decimals = 18;
51     uint256 private constant _maxCap = 300000000 ether;
52     uint256 private _icoStartDate = 1560744000;   // 17-06-2019 12:00 GMT+8
53     uint256 private _icoEndDate = 1562558400;     // 08-07-2019 12:00 GMT+8
54     
55     //--- Token allocations -------//
56     uint256 private _totalsupply;
57 
58     //--- Address -----------------//
59     address private _owner;
60     address payable private _ethFundMain;
61    
62     //--- Variables ---------------//
63     bool private _lockToken = true;
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
176         require(!locked[msg.sender], "Sender address is locked");
177         require(!locked[_to], "Receiver address is locked");
178         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
179         balances[_to] = (balances[_to]).add(_amount);
180         emit Transfer(msg.sender, _to, _amount);
181         return true;
182     }
183     
184     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO onlyUnlockToken returns (bool)  {
185         require( _to != address(0), "Receiver can not be 0x0");
186         require(!locked[_from], "From address is locked");
187         require(!locked[_to], "Receiver address is locked");
188         balances[_from] = (balances[_from]).sub(_amount);
189         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
190         balances[_to] = (balances[_to]).add(_amount);
191         emit Transfer(_from, _to, _amount);
192         return true;
193     }
194 
195     function burn(uint256 _value) public onlyOwner returns (bool) {
196         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
197         _totalsupply = _totalsupply.sub(_value);                     
198         emit Burn(msg.sender, _value);
199         return true;
200     }
201 
202     function stopTransferToken() external onlyOwner {
203         _lockToken = true;
204         emit ChangeTokenLockStatus(true);
205     }
206 
207     function startTransferToken() external onlyOwner {
208         _lockToken = false;
209         emit ChangeTokenLockStatus(false);
210     }
211 
212     function () external payable onlyICO onlyAllowICO {
213         
214     }
215 
216     function manualMint(address receiver, uint256 _value) public onlyOwner{
217         uint256 value = _value.mul(10 ** 18);
218         mint(_owner, receiver, value);
219     }
220 
221     function mint(address from, address receiver, uint256 value) internal {
222         require(receiver != address(0), "Address can not be 0x0");
223         require(value > 0, "Value should larger than 0");
224         balances[receiver] = balances[receiver].add(value);
225         _totalsupply = _totalsupply.add(value);
226         require(_totalsupply <= _maxCap, "CrowdSale hit max cap");
227         emit Mint(from, receiver, value);
228         emit Transfer(address(0), receiver, value);
229     }
230     
231     function haltCrowdSale() external onlyOwner {
232         _allowICO = false;
233         emit ChangeAllowICOStatus(false);
234     }
235 
236     function resumeCrowdSale() external onlyOwner {
237         _allowICO = true;
238         emit ChangeAllowICOStatus(true);
239     }
240 
241     function changeReceiveWallet(address payable newAddress) external onlyOwner {
242         require(newAddress != address(0), "Address can not be 0x0");
243         _ethFundMain = newAddress;
244         emit ChangeReceiveWallet(newAddress);
245     }
246 
247 	function assignOwnership(address newOwner) external onlyOwner {
248 	    require(newOwner != address(0), "Address can not be 0x0");
249 	    _owner = newOwner;
250 	    emit ChangeOwnerShip(newOwner);
251 	}
252 
253     function forwardFunds() external onlyOwner {
254         require(_ethFundMain != address(0));
255         _ethFundMain.transfer(address(this).balance);
256     }
257 
258     function haltTokenTransferFromAddress(address investor) external onlyOwner {
259         locked[investor] = true;
260         emit ChangeLockStatusFrom(investor, true);
261     }
262 
263     function resumeTokenTransferFromAddress(address investor) external onlyOwner {
264         locked[investor] = false;
265         emit ChangeLockStatusFrom(investor, false);
266     }
267 }