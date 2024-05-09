1 pragma solidity 0.5.5;
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
45 contract ITCO is ERC20 { 
46     using SafeMath for uint256;
47     //--- Token configurations ----// 
48     string private constant _name = "IT Coin";
49     string private constant _symbol = "ITCO";
50     uint8 private constant _decimals = 18;
51     uint256 private constant _maxCap = 10000000000 ether;
52     
53     //--- Token allocations -------//
54     uint256 private _totalsupply;
55 
56     //--- Address -----------------//
57     address private _owner;
58     address payable private _ethFundMain;
59     
60     //--- Variables ---------------//
61     bool private _lockToken = false;
62     
63     mapping(address => uint256) private balances;
64     mapping(address => mapping(address => uint256)) private allowed;
65     mapping(address => bool) private locked;
66     
67     event Mint(address indexed from, address indexed to, uint256 amount);
68     event Burn(address indexed from, uint256 amount);
69     event ChangeReceiveWallet(address indexed newAddress);
70     event ChangeOwnerShip(address indexed newOwner);
71     event ChangeLockStatusFrom(address indexed investor, bool locked);
72     event ChangeTokenLockStatus(bool locked);
73     event ChangeAllowICOStatus(bool allow);
74     
75     modifier onlyOwner() {
76         require(msg.sender == _owner, "Only owner is allowed");
77         _;
78     }
79     
80     modifier onlyUnlockToken() {
81         require(!_lockToken, "Token locked");
82         _;
83     }
84 
85     constructor() public
86     {
87         _owner = msg.sender;
88     }
89     
90     function name() public pure returns (string memory) {
91         return _name;
92     }
93     
94     function symbol() public pure returns (string memory) {
95         return _symbol;
96     }
97     
98     function decimals() public pure returns (uint8) {
99         return _decimals;
100     }
101     
102     function maxCap() public pure returns (uint256) {
103         return _maxCap;
104     }
105     
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     function ethFundMain() public view returns (address) {
111         return _ethFundMain;
112     }
113    
114     function lockToken() public view returns (bool) {
115         return _lockToken;
116     }
117    
118     function lockStatusOf(address investor) public view returns (bool) {
119         return locked[investor];
120     }
121 
122     function totalSupply() public view returns (uint256) {
123         return _totalsupply;
124     }
125     
126     function balanceOf(address investor) public view returns (uint256) {
127         return balances[investor];
128     }
129     
130     function approve(address _spender, uint256 _amount) public onlyUnlockToken returns (bool)  {
131         require( _spender != address(0), "Address can not be 0x0");
132         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
133         require(!locked[msg.sender], "Sender address is locked");
134         allowed[msg.sender][_spender] = _amount;
135         emit Approval(msg.sender, _spender, _amount);
136         return true;
137     }
138   
139     function allowance(address _from, address _spender) public view returns (uint256) {
140         return allowed[_from][_spender];
141     }
142 
143     function transfer(address _to, uint256 _amount) public onlyUnlockToken returns (bool) {
144         require( _to != address(0), "Receiver can not be 0x0");
145         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
146         require(!locked[msg.sender], "Sender address is locked");
147         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
148         balances[_to] = (balances[_to]).add(_amount);
149         emit Transfer(msg.sender, _to, _amount);
150         return true;
151     }
152     
153     function transferFrom( address _from, address _to, uint256 _amount ) public onlyUnlockToken returns (bool)  {
154         require( _to != address(0), "Receiver can not be 0x0");
155         require(balances[_from] >= _amount, "Source's balance is not enough");
156         require(allowed[_from][msg.sender] >= _amount, "Allowance is not enough");
157         require(!locked[_from], "From address is locked");
158         balances[_from] = (balances[_from]).sub(_amount);
159         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
160         balances[_to] = (balances[_to]).add(_amount);
161         emit Transfer(_from, _to, _amount);
162         return true;
163     }
164 
165     function burn(uint256 _value) public onlyOwner returns (bool) {
166         require(balances[msg.sender] >= _value, "Balance does not have enough tokens");   
167         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
168         _totalsupply = _totalsupply.sub(_value);                     
169         emit Burn(msg.sender, _value);
170         return true;
171     }
172 
173     function stopTransferToken() external onlyOwner {
174         _lockToken = true;
175         emit ChangeTokenLockStatus(true);
176     }
177 
178     function startTransferToken() external onlyOwner {
179         _lockToken = false;
180         emit ChangeTokenLockStatus(false);
181     }
182 
183     function () external payable {
184 
185     }
186 
187     function manualMint(address receiver, uint256 _value) public onlyOwner{
188         uint256 value = _value.mul(10 ** 18);
189         mint(_owner, receiver, value);
190     }
191 
192     function mint(address from, address receiver, uint256 value) internal {
193         require(receiver != address(0), "Address can not be 0x0");
194         require(value > 0, "Value should larger than 0");
195         balances[receiver] = balances[receiver].add(value);
196         _totalsupply = _totalsupply.add(value);
197         require(_totalsupply <= _maxCap, "CrowdSale hit max cap");
198         emit Mint(from, receiver, value);
199         emit Transfer(address(0), receiver, value);
200     }
201  
202 	function assignOwnership(address newOwner) external onlyOwner {
203 	    require(newOwner != address(0), "Address can not be 0x0");
204 	    _owner = newOwner;
205 	    emit ChangeOwnerShip(newOwner);
206 	}
207 
208     function changeReceiveWallet(address payable newAddress) external onlyOwner {
209         require(newAddress != address(0), "Address can not be 0x0");
210         _ethFundMain = newAddress;
211         emit ChangeReceiveWallet(newAddress);
212     }
213 
214     function forwardFunds() external onlyOwner {
215         require(_ethFundMain != address(0));
216         _ethFundMain.transfer(address(this).balance);
217     }
218 
219     function haltTokenTransferFromAddress(address investor) external onlyOwner {
220         locked[investor] = true;
221         emit ChangeLockStatusFrom(investor, true);
222     }
223 
224     function resumeTokenTransferFromAddress(address investor) external onlyOwner {
225         locked[investor] = false;
226         emit ChangeLockStatusFrom(investor, false);
227     }
228 }