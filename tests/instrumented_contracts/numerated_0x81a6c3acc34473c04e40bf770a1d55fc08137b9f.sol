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
47 contract WGP is ERC20 { 
48     using SafeMath for uint256;
49     //--- Token configurations ----// 
50     string public constant name = "W GREEN PAY";
51     string public constant symbol = "WGP";
52     uint8 public constant decimals = 18;
53     uint public maxCap = 1000000000 ether;
54     
55     //--- Token allocations -------//
56     uint256 public _totalsupply;
57     uint256 public mintedTokens;
58 
59     //--- Address -----------------//
60     address public owner; //Management
61     address public ethFundMain;
62    
63     //--- Milestones --------------//
64     uint256 public icoStartDate = 1538366400; // 01-10-2018 12:00 pm
65     uint256 public icoEndDate = 1539489600; // 14-10-2018 12:00 pm
66     
67     //--- Variables ---------------//
68     bool public lockstatus = true;
69     bool public stopped = false;
70     
71     mapping(address => uint256) public balances;
72     mapping(address => mapping(address => uint256)) public allowed;
73     event Mint(address indexed from, address indexed to, uint256 amount);
74     event Burn(address indexed from, uint256 amount);
75     
76     modifier onlyOwner() {
77         require (msg.sender == owner);
78         _;
79     }
80 
81     modifier onlyICO() {
82         require(now >= icoStartDate && now < icoEndDate);
83         _;
84     }
85 
86     modifier onlyFinishedICO() {
87         require(now >= icoEndDate);
88         _;
89     }
90     
91     constructor() public
92     {
93         owner = msg.sender;
94         ethFundMain = 0x67fd4721d490A5E609cF8e09FCE0a217b91F1546;
95     }
96 
97     function () public payable onlyICO {
98         
99     }
100 
101     function totalSupply() public view returns (uint256 total_Supply) {
102         total_Supply = _totalsupply;
103     }
104     
105     function balanceOf(address _owner)public view returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO returns (bool success)  {
110         require( _to != 0x0);
111         require(!lockstatus);
112         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
113         balances[_from] = (balances[_from]).sub(_amount);
114         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
115         balances[_to] = (balances[_to]).add(_amount);
116         emit Transfer(_from, _to, _amount);
117         return true;
118     }
119     
120     function approve(address _spender, uint256 _amount)public onlyFinishedICO returns (bool success)  {
121         require(!lockstatus);
122         require( _spender != 0x0);
123         require(balances[msg.sender] >= _amount);
124         allowed[msg.sender][_spender] = _amount;
125         emit Approval(msg.sender, _spender, _amount);
126         return true;
127     }
128   
129     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
130         require( _owner != 0x0 && _spender !=0x0);
131         return allowed[_owner][_spender];
132     }
133 
134     function transfer(address _to, uint256 _amount)public onlyFinishedICO returns (bool success) {
135         require(!lockstatus);
136         require( _to != 0x0);
137         require(balances[msg.sender] >= _amount && _amount >= 0);
138         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
139         balances[_to] = (balances[_to]).add(_amount);
140         emit Transfer(msg.sender, _to, _amount);
141         return true;
142     }
143 
144     function burn(uint256 value) public onlyOwner returns (bool success) {
145         uint256 _value = value.mul(10 ** 18);
146         require(balances[msg.sender] >= _value);   
147         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
148         _totalsupply = _totalsupply.sub(_value);                     
149         emit Burn(msg.sender, _value);
150         return true;
151     }
152 
153     function stopTransferToken() external onlyOwner onlyFinishedICO {
154         require(!lockstatus);
155         lockstatus = true;
156     }
157 
158     function startTransferToken() external onlyOwner onlyFinishedICO {
159         require(lockstatus);
160         lockstatus = false;
161     }
162 
163     function manualMint(address receiver, uint256 _value) public onlyOwner returns (bool){
164         uint256 value = _value.mul(10 ** 18);
165         require(receiver != 0x0 && _value > 0);
166 
167         balances[receiver] = balances[receiver].add(value);
168         _totalsupply = _totalsupply.add(value);
169         mintedTokens = mintedTokens.add(value);
170 
171         require(_totalsupply <= maxCap);
172         emit Mint(owner, receiver, value);
173         emit Transfer(0, receiver, value);
174     }
175     
176     function haltCrowdSale() external onlyOwner onlyICO {
177         require(!stopped);
178         stopped = true;
179     }
180 
181     function resumeCrowdSale() external onlyOwner onlyICO {
182         require(stopped);
183         stopped = false;
184     }
185     
186     function changeReceiveWallet(address newAddress) external onlyOwner {
187         require(newAddress != 0x0);
188         ethFundMain = newAddress;
189     }
190 
191 	function assignOwnership(address newOwner) public onlyOwner {
192 	    require(newOwner != 0x0);
193 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
194 	    balances[owner] = 0;
195 	    owner = newOwner;
196 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
197 	}
198 
199     function forwardFunds() external onlyOwner { 
200         address myAddress = this;
201         ethFundMain.transfer(myAddress.balance);
202     }
203 }
204 
205 contract WgpHolder {
206     WGP public wgp;
207     address public owner;
208     address public recipient;
209     uint256 public releaseDate;
210 
211     modifier onlyOwner() {
212         require(msg.sender == owner);
213         _;
214     }
215 
216     constructor() public {
217         wgp = WGP(0xf9918ce795c6CDEA4875a906512BbC15a7d61Abd);
218         owner = msg.sender;
219     }
220 
221     function setReleaseDate(uint256 newReleaseDate) external onlyOwner {
222         require(newReleaseDate > now);
223         releaseDate = newReleaseDate;
224     }
225 
226     function setWgpRecipient(address newRecipient) external onlyOwner {
227         require(newRecipient != 0x0);
228         recipient = newRecipient;
229     }
230 
231     function releaseWgp() external onlyOwner {
232         require(recipient != 0x0 && releaseDate != 0 && now > releaseDate);
233         uint256 balance = wgp.balanceOf(address(this));
234         wgp.transfer(recipient, balance);
235     }
236     
237     function changeOwnerShip(address newOwner) external onlyOwner {
238         require(newOwner != 0x0);
239         owner = newOwner;
240     }
241 }