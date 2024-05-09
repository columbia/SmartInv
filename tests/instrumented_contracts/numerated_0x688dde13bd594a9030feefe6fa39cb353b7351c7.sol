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
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20 {
35     
36   function totalSupply()public view returns (uint256 total_Supply);
37   function balanceOf(address who)public view returns (uint256);
38   function allowance(address owner, address spender)public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value)public returns (bool ok);
40   function approve(address spender, uint256 value)public returns (bool ok);
41   function transfer(address to, uint256 value)public returns (bool ok);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 //--- Upgraded tokens must extend UpgradeAgent ----//
47 contract UpgradeAgent {
48   address public oldAddress;
49   function isUpgradeAgent() public pure returns (bool) {
50     return true;
51   }
52   function upgradeFrom(address _from, uint256 _value) public;
53 }
54 
55 contract CVEN is ERC20 { 
56     using SafeMath for uint256;
57     //--- Token configurations ----// 
58     string public constant name = "Concordia Ventures Stablecoin";
59     string public constant symbol = "CVEN";
60     uint8 public constant decimals = 18;
61     
62     //--- Token allocations -------//
63     uint256 public _totalsupply;
64     uint256 public mintedTokens;
65     uint256 public totalUpgraded;
66 
67     //--- Address -----------------//
68     address public owner;
69     address public ethFundMain;
70     UpgradeAgent public upgradeAgent;
71     
72     //--- Variables ---------------//
73     bool public lockstatus = false;
74     bool public stopped = false;
75     
76     mapping(address => uint256) public balances;
77     mapping(address => mapping(address => uint256)) public allowed;
78     mapping(address => bool) public locked;
79     event Mint(address indexed from, address indexed to, uint256 amount);
80     event Burn(address indexed from, uint256 amount);
81     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
82     event UpgradeAgentSet(address agent);
83 
84     modifier onlyOwner() {
85         require(msg.sender == owner, "Only owner is allowed");
86         _;
87     }
88 
89     constructor() public
90     {
91         owner = msg.sender;
92         ethFundMain = 0x657Eb3CE439CA61e58FF6Cb106df2e962C5e7890;
93     }
94 
95     function totalSupply() public view returns (uint256 total_Supply) {
96         total_Supply = _totalsupply;
97     }
98     
99     function balanceOf(address _owner)public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function transfer(address _to, uint256 _amount)public returns (bool success) {
104         require(!lockstatus, "Token is locked now");
105         require( _to != 0x0, "Receiver can not be 0x0");
106         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
107         require(!locked[msg.sender], "Sender address is locked");
108         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
109         balances[_to] = (balances[_to]).add(_amount);
110         emit Transfer(msg.sender, _to, _amount);
111         return true;
112     }
113 
114     function transferFrom( address _from, address _to, uint256 _amount ) public returns (bool success)  {
115         require( _to != 0x0, "Receiver can not be 0x0");
116         require(!lockstatus, "Token is locked now");
117         require(balances[_from] >= _amount, "Source balance is not enough");
118         require(allowed[_from][msg.sender] >= _amount, "Allowance is not enough");
119         require(!locked[_from], "From address is locked");
120         balances[_from] = (balances[_from]).sub(_amount);
121         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
122         balances[_to] = (balances[_to]).add(_amount);
123         emit Transfer(_from, _to, _amount);
124         return true;
125     }
126     
127     function approve(address _spender, uint256 _amount)public returns (bool success)  {
128         require(!lockstatus, "Token is locked now");
129         require( _spender != 0x0, "Address can not be 0x0");
130         require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
131         require(!locked[msg.sender], "Sender address is locked");
132         allowed[msg.sender][_spender] = _amount;
133         emit Approval(msg.sender, _spender, _amount);
134         return true;
135     }
136   
137     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
138         return allowed[_owner][_spender];
139     }
140 
141     function burn(uint256 _value) public returns (bool success) {
142         require(balances[msg.sender] >= _value, "Balance does not have enough tokens");
143         require(!locked[msg.sender], "Sender address is locked");   
144         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
145         _totalsupply = _totalsupply.sub(_value);                     
146         emit Burn(msg.sender, _value);
147         return true;
148     }
149 
150     function burnFrom(address from, uint256 _value) public returns (bool success) {
151         require(balances[from] >= _value, "Source balance does not have enough tokens");
152         require(allowed[from][msg.sender] >= _value, "Source balance does not have enough tokens");
153         require(!locked[from], "Source address is locked");   
154         balances[from] = (balances[from]).sub(_value);
155         allowed[from][msg.sender] = (allowed[from][msg.sender]).sub(_value);            
156         _totalsupply = _totalsupply.sub(_value);                     
157         emit Burn(from, _value);
158         return true;
159     }
160 
161     function stopTransferToken() external onlyOwner {
162         require(!lockstatus, "Token is locked");
163         lockstatus = true;
164     }
165 
166     function startTransferToken() external onlyOwner {
167         require(lockstatus, "Token is transferable");
168         lockstatus = false;
169     }
170 
171     function () public payable {
172         require(!stopped, "CrowdSale is stopping");
173         mint(this, msg.sender, msg.value);
174     }
175 
176     function manualMint(address receiver, uint256 _value) public onlyOwner{
177         require(!stopped, "CrowdSale is stopping");
178         mint(owner, receiver, _value);
179     }
180 
181     function mint(address from, address receiver, uint256 value) internal {
182         require(receiver != 0x0, "Address can not be 0x0");
183         require(value > 0, "Value should larger than 0");
184         balances[receiver] = balances[receiver].add(value);
185         _totalsupply = _totalsupply.add(value);
186         mintedTokens = mintedTokens.add(value);
187         emit Mint(from, receiver, value);
188         emit Transfer(0, receiver, value);
189     }
190     
191     function haltMintToken() external onlyOwner {
192         require(!stopped, "Minting is stopping");
193         stopped = true;
194     }
195 
196     function resumeMintToken() external onlyOwner {
197         require(stopped, "Minting is running");
198         stopped = false;
199     }
200 
201     function changeReceiveWallet(address newAddress) external onlyOwner {
202         require(newAddress != 0x0, "Address can not be 0x0");
203         ethFundMain = newAddress;
204     }
205 
206 	function assignOwnership(address newOwner) external onlyOwner {
207 	    require(newOwner != 0x0, "Address can not be 0x0");
208 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
209 	    balances[owner] = 0;
210 	    owner = newOwner;
211 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
212 	}
213 
214     function forwardFunds() external onlyOwner { 
215         address myAddress = this;
216         ethFundMain.transfer(myAddress.balance);
217     }
218 
219     function withdrawTokens() external onlyOwner {
220         uint256 value = balances[this];
221         balances[owner] = (balances[owner]).add(value);
222         balances[this] = 0;
223         emit Transfer(this, owner, value);
224     }
225 
226     function haltTokenTransferFromAddress(address investor) external onlyOwner {
227         locked[investor] = true;
228     }
229 
230     function resumeTokenTransferFromAddress(address investor) external onlyOwner {
231         locked[investor] = false;
232     }
233 
234     function setUpgradeAgent(address agent) external onlyOwner{
235         require(agent != 0x0, "Upgrade agent can not be zero");
236         require(totalUpgraded == 0, "Token are upgrading");
237         upgradeAgent = UpgradeAgent(agent);
238         require(upgradeAgent.isUpgradeAgent(), "The address is not upgrade agent");
239         require(upgradeAgent.oldAddress() == address(this), "This is not right agent");
240         emit UpgradeAgentSet(upgradeAgent);
241     }
242 
243     function upgrade(uint256 value) public {
244         require (value != 0, "Value can not be zero");
245         require(balances[msg.sender] >= value, "Balance is not enough");
246         require(address(upgradeAgent) != 0x0, "Upgrade agent is not set");
247         balances[msg.sender] = (balances[msg.sender]).sub(value);
248         _totalsupply = _totalsupply.sub(value);
249         totalUpgraded = totalUpgraded.add(value);
250         upgradeAgent.upgradeFrom(msg.sender, value);
251         emit Upgrade(msg.sender, upgradeAgent, value);
252         emit Transfer(msg.sender, 0, value);
253     }
254 }