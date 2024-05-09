1 pragma solidity 0.5.2;
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
45 contract BNTE is ERC20 { 
46     using SafeMath for uint256;
47     //--- Token configurations ----// 
48     string public constant name = "Bountie";
49     string public constant symbol = "BNTE";
50     uint8 public constant decimals = 18;
51     uint256 public constant basePrice = 6500;
52     uint public maxCap = 20000 ether;
53     
54     //--- Token allocations -------//
55     uint256 public _totalsupply;
56     uint256 public mintedTokens;
57     uint256 public ETHcollected;
58 
59     //--- Address -----------------//
60     address public owner;
61     address payable public ethFundMain;
62     address public novumAddress;
63    
64     //--- Milestones --------------//
65     uint256 public presale1_startdate = 1537675200; // 23-9-2018
66     uint256 public presale2_startdate = 1538712000; // 5-10-2018
67     uint256 public presale3_startdate = 1539662400; // 16-10-2018
68     uint256 public ico_startdate = 1540612800; // 27-10-2018
69     uint256 public ico_enddate = 1541563200; // 7-11-2018
70     
71     //--- Variables ---------------//
72     bool public lockstatus = true;
73     bool public stopped = false;
74     
75     mapping(address => uint256) balances;
76     mapping(address => mapping(address => uint256)) allowed;
77     event Mint(address indexed from, address indexed to, uint256 amount);
78     event Burn(address indexed from, uint256 amount);
79     
80     modifier onlyOwner() {
81         require (msg.sender == owner);
82         _;
83     }
84 
85     modifier onlyICO() {
86         require(now >= presale1_startdate && now < ico_enddate);
87         _;
88     }
89 
90     modifier onlyFinishedICO() {
91         require(now >= ico_enddate);
92         _;
93     }
94     
95     constructor() public
96     {
97         owner = msg.sender;
98         ethFundMain = 0xDEe3a6b14ef8E21B9df09a059186292C9472045D;
99         novumAddress = 0xDEe3a6b14ef8E21B9df09a059186292C9472045D;
100     }
101 
102     function totalSupply() public view returns (uint256 total_Supply) {
103         total_Supply = _totalsupply;
104     }
105     
106     function balanceOf(address _owner)public view returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO returns (bool success)  {
111         require( _to != address(0));
112         require(!lockstatus);
113         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
114         balances[_from] = (balances[_from]).sub(_amount);
115         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
116         balances[_to] = (balances[_to]).add(_amount);
117         emit Transfer(_from, _to, _amount);
118         return true;
119     }
120     
121     function approve(address _spender, uint256 _amount)public onlyFinishedICO returns (bool success)  {
122         require(!lockstatus);
123         require( _spender != address(0));
124         allowed[msg.sender][_spender] = _amount;
125         emit Approval(msg.sender, _spender, _amount);
126         return true;
127     }
128 
129     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
130         require( _owner != address(0) && _spender != address(0));
131         return allowed[_owner][_spender];
132     }
133 
134 
135     function transfer(address _to, uint256 _amount)public onlyFinishedICO returns (bool success) {
136         require(!lockstatus);
137         require( _to != address(0));
138         require(balances[msg.sender] >= _amount && _amount >= 0);
139         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
140         balances[_to] = (balances[_to]).add(_amount);
141         emit Transfer(msg.sender, _to, _amount);
142         return true;
143     }
144 
145     function burn(uint256 value) public onlyOwner returns (bool success) {
146         uint256 _value = value * 10 ** 18;
147         require(balances[msg.sender] >= _value);   
148         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
149         _totalsupply = _totalsupply.sub(_value);                     
150         emit Burn(msg.sender, _value);
151         return true;
152     }
153     
154     function stopTransferToken() external onlyOwner onlyFinishedICO {
155         require(!lockstatus);
156         lockstatus = true;
157     }
158 
159     function startTransferToken() external onlyOwner onlyFinishedICO {
160         require(lockstatus);
161         lockstatus = false;
162     }
163 
164     function manualMint(address receiver, uint256 _tokenQuantity) external onlyOwner{
165         uint256 tokenQuantity = _tokenQuantity * 10 ** 18;
166         uint256 tokenPrice = calculatePrice();
167         uint256 ethAmount = tokenQuantity.div(tokenPrice);
168         ETHcollected = ETHcollected.add(ethAmount);
169         require(ETHcollected <= maxCap);
170         mintContract(owner, receiver, tokenQuantity);
171     }
172 
173     function () external payable onlyICO {
174         require(msg.value != 0 && msg.sender != address(0));
175         require(!stopped && msg.sender != owner);
176         uint256 tokenPrice = calculatePrice();
177         uint256 tokenQuantity = (msg.value).mul(tokenPrice);
178         ETHcollected = ETHcollected.add(msg.value);
179         require(ETHcollected <= maxCap);
180         mintContract(address(this), msg.sender, tokenQuantity);
181     }
182 
183     function mintContract(address from, address receiver, uint256 tokenQuantity) private {
184         require(tokenQuantity > 0);
185         mintedTokens = mintedTokens.add(tokenQuantity);
186         uint256 novumShare = tokenQuantity * 4 / 65;
187         uint256 userManagement = tokenQuantity * 31 / 65;
188         balances[novumAddress] = balances[novumAddress].add(novumShare);
189         balances[owner] = balances[owner].add(userManagement);
190         _totalsupply = _totalsupply.add(tokenQuantity * 100 / 65);
191         balances[receiver] = balances[receiver].add(tokenQuantity);
192         emit Mint(from, receiver, tokenQuantity);
193         emit Transfer(address(0), receiver, tokenQuantity);
194         emit Mint(from, novumAddress, novumShare);
195         emit Transfer(address(0), novumAddress, novumShare);
196         emit Mint(from, owner, userManagement);
197         emit Transfer(address(0), owner, userManagement);
198     }
199     
200     function calculatePrice() private view returns (uint256){
201         uint256 price_token = basePrice;
202          
203         if(now < presale1_startdate) {
204             require(ETHcollected < 10000 ether);
205             price_token = basePrice * 6 / 5;   
206         }
207         else  if (now < presale2_startdate) {
208             require(ETHcollected < 11739 ether);
209             price_token = basePrice * 23 / 20;   
210         }
211         else if (now < presale3_startdate) {
212             require(ETHcollected < 13557 ether);
213             price_token = basePrice * 11 / 10;
214         }
215         else if (now < ico_startdate) {
216             require(ETHcollected < 15462 ether);
217             price_token = basePrice * 21 / 20;
218         }
219         else {
220             require(ETHcollected < maxCap);
221             price_token = basePrice;
222         }
223         return price_token;
224     }
225     
226     function CrowdSale_Halt() external onlyOwner onlyICO {
227         require(!stopped);
228         stopped = true;
229     }
230 
231 
232     function CrowdSale_Resume() external onlyOwner onlyICO {
233         require(stopped);
234         stopped = false;
235     }
236 
237     function CrowdSale_Change_ReceiveWallet(address payable New_Wallet_Address) external onlyOwner {
238         require(New_Wallet_Address != address(0));
239         ethFundMain = New_Wallet_Address;
240     }
241 
242 	function CrowdSale_AssignOwnership(address newOwner) public onlyOwner {
243 	    require(newOwner != address(0));
244 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
245 	    balances[owner] = 0;
246 	    owner = newOwner;
247 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
248 	}
249 
250     function forwardFunds() external onlyOwner { 
251         address myAddress = address(this);
252         ethFundMain.transfer(myAddress.balance);
253     }
254 
255     function modify_NovumAddress(address newAddress) public onlyOwner returns(bool) {
256         require(newAddress != address(0) && novumAddress != newAddress);
257         uint256 novumBalance = balances[novumAddress];
258         address oldAddress = novumAddress;
259         balances[newAddress] = (balances[newAddress]).add(novumBalance);
260         balances[novumAddress] = 0;
261         novumAddress = newAddress;
262         emit Transfer(oldAddress, newAddress, novumBalance);
263         return true;
264     }
265 }