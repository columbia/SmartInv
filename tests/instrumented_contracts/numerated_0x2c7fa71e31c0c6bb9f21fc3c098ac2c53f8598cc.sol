1 pragma solidity 0.4.25;
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
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37   function totalSupply()public view returns (uint256 total_Supply);
38   function balanceOf(address who)public view returns (uint256);
39   function allowance(address owner, address spender)public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value)public returns (bool ok);
41   function approve(address spender, uint256 value)public returns (bool ok);
42   function transfer(address to, uint256 value)public returns (bool ok);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract NEXXO is ERC20 { 
48     using SafeMath for uint256;
49     //--- Token configurations ----// 
50     string public constant name = "NEXXO";
51     string public constant symbol = "NEXXO";
52     uint8 public constant decimals = 18;
53     uint public maxCap = 100000000000 ether;
54     
55     //--- Token allocations -------//
56     uint256 public _totalsupply;
57     uint256 public mintedTokens;
58 
59     //--- Address -----------------//
60     address public owner;
61     address public ethFundMain;
62    
63     //--- Milestones --------------//
64     uint256 public presaleStartDate = 1540958400; // 31-10-2018
65     uint256 public icoStartDate = 1543636800; // 01-12-2018
66     uint256 public icoEndDate = 1546228800; // 31-12-2018
67     
68     //--- Variables ---------------//
69     bool public lockstatus = true;
70     bool public stopped = false;
71     
72     mapping(address => uint256) public balances;
73     mapping(address => mapping(address => uint256)) public allowed;
74     mapping(address => bool) public locked;
75     event Mint(address indexed from, address indexed to, uint256 amount);
76     event Burn(address indexed from, uint256 amount);
77     
78     modifier onlyOwner() {
79         require(msg.sender == owner, "Only owner is allowed");
80         _;
81     }
82 
83     modifier onlyICO() {
84         require(now >= icoStartDate && now < icoEndDate, "CrowdSale is not running");
85         _;
86     }
87 
88     modifier onlyFinishedICO() {
89         require(now >= icoEndDate, "CrowdSale is running");
90         _;
91     }
92 
93     constructor() public
94     {
95         owner = msg.sender;
96         ethFundMain = 0x657Eb3CE439CA61e58FF6Cb106df2e962C5e7890;
97     }
98 
99     function totalSupply() public view returns (uint256 total_Supply) {
100         total_Supply = _totalsupply;
101     }
102     
103     function balanceOf(address _owner)public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO returns (bool success)  {
108         require( _to != 0x0, "Receiver can not be 0x0");
109         require(!lockstatus, "Token is locked now");
110         require(balances[_from] >= _amount, "Source's balance is not enough");
111         require(allowed[_from][msg.sender] >= _amount, "Allowance is not enough");
112         require(!locked[_from], "From address is locked");
113         balances[_from] = (balances[_from]).sub(_amount);
114         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
115         balances[_to] = (balances[_to]).add(_amount);
116         emit Transfer(_from, _to, _amount);
117         return true;
118     }
119     
120     function approve(address _spender, uint256 _amount)public onlyFinishedICO returns (bool success)  {
121         require(!lockstatus, "Token is locked now");
122         require( _spender != 0x0, "Address can not be 0x0");
123         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
124         require(!locked[msg.sender], "Sender address is locked");
125         allowed[msg.sender][_spender] = _amount;
126         emit Approval(msg.sender, _spender, _amount);
127         return true;
128     }
129   
130     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133 
134     function transfer(address _to, uint256 _amount)public onlyFinishedICO returns (bool success) {
135         require(!lockstatus, "Token is locked now");
136         require( _to != 0x0, "Receiver can not be 0x0");
137         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
138         require(!locked[msg.sender], "Sender address is locked");
139         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
140         balances[_to] = (balances[_to]).add(_amount);
141         emit Transfer(msg.sender, _to, _amount);
142         return true;
143     }
144 
145     function burn(uint256 value) public onlyOwner returns (bool success) {
146         uint256 _value = value * 10 ** 18;
147         require(balances[msg.sender] >= _value, "Balance does not have enough tokens");   
148         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
149         _totalsupply = _totalsupply.sub(_value);                     
150         emit Burn(msg.sender, _value);
151         return true;
152     }
153 
154     function stopTransferToken() external onlyOwner onlyFinishedICO {
155         require(!lockstatus, "Token is locked");
156         lockstatus = true;
157     }
158 
159     function startTransferToken() external onlyOwner onlyFinishedICO {
160         require(lockstatus, "Token is transferable");
161         lockstatus = false;
162     }
163 
164     function () public payable onlyICO{
165         require(!stopped, "CrowdSale is stopping");
166     }
167 
168     function manualMint(address receiver, uint256 _value) public onlyOwner{
169         require(!stopped, "CrowdSale is stopping");
170         uint256 value = _value.mul(10 ** 18);
171         mint(owner, receiver, value);
172     }
173 
174     function mint(address from, address receiver, uint256 value) internal {
175         require(receiver != 0x0, "Address can not be 0x0");
176         require(value > 0, "Value should larger than 0");
177         balances[receiver] = balances[receiver].add(value);
178         _totalsupply = _totalsupply.add(value);
179         mintedTokens = mintedTokens.add(value);
180         require(_totalsupply < maxCap, "CrowdSale hit max cap");
181         emit Mint(from, receiver, value);
182         emit Transfer(0, receiver, value);
183     }
184     
185     function haltCrowdSale() external onlyOwner onlyICO {
186         require(!stopped, "CrowdSale is stopping");
187         stopped = true;
188     }
189 
190     function resumeCrowdSale() external onlyOwner onlyICO {
191         require(stopped, "CrowdSale is running");
192         stopped = false;
193     }
194 
195     function changeReceiveWallet(address newAddress) external onlyOwner {
196         require(newAddress != 0x0, "Address can not be 0x0");
197         ethFundMain = newAddress;
198     }
199 
200 	function assignOwnership(address newOwner) external onlyOwner {
201 	    require(newOwner != 0x0, "Address can not be 0x0");
202 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
203 	    balances[owner] = 0;
204 	    owner = newOwner;
205 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
206 	}
207 
208     function forwardFunds() external onlyOwner { 
209         address myAddress = this;
210         ethFundMain.transfer(myAddress.balance);
211     }
212 
213     function haltTokenTransferFromAddress(address investor) external onlyOwner {
214         locked[investor] = true;
215     }
216 
217     function resumeTokenTransferFromAddress(address investor) external onlyOwner {
218         locked[investor] = false;
219     }
220 }