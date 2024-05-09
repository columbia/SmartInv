1 pragma solidity 0.4.24;
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
47 contract BNTE is ERC20 { 
48     using SafeMath for uint256;
49     //--- Token configurations ----// 
50     string public constant name = "Bountie";
51     string public constant symbol = "BNTE";
52     uint8 public constant decimals = 18;
53     uint256 public constant basePrice = 6500;
54     uint public maxCap = 20000 ether;
55     
56     //--- Token allocations -------//
57     uint256 public _totalsupply;
58     uint256 public mintedTokens;
59     uint256 public ETHcollected;
60 
61     //--- Address -----------------//
62     address public owner;
63     address public ethFundMain;
64     address public novumAddress;
65    
66     //--- Milestones --------------//
67     uint256 public presale1_startdate = 1537675200; // 23-9-2018
68     uint256 public presale2_startdate = 1538712000; // 5-10-2018
69     uint256 public presale3_startdate = 1539662400; // 16-10-2018
70     uint256 public ico_startdate = 1540612800; // 27-10-2018
71     uint256 public ico_enddate = 1541563200; // 7-11-2018
72     
73     //--- Variables ---------------//
74     bool public lockstatus = true;
75     bool public stopped = false;
76     
77     mapping(address => uint256) balances;
78     mapping(address => mapping(address => uint256)) allowed;
79     event Mint(address indexed from, address indexed to, uint256 amount);
80     event Burn(address indexed from, uint256 amount);
81     
82     //ok
83     modifier onlyOwner() {
84         require (msg.sender == owner);
85         _;
86     }
87 
88     //ok
89     modifier onlyManual() {
90         require(now < ico_enddate);
91         _;
92     }
93 
94     //ok
95     modifier onlyICO() {
96         require(now >= presale1_startdate && now < ico_enddate);
97         _;
98     }
99 
100     //ok
101     modifier onlyFinishedICO() {
102         require(now >= ico_enddate);
103         _;
104     }
105     
106     //ok
107     constructor() public
108     {
109         owner = msg.sender;
110         ethFundMain = 0xDEe3a6b14ef8E21B9df09a059186292C9472045D;
111         novumAddress = 0xDEe3a6b14ef8E21B9df09a059186292C9472045D;
112     }
113 
114     //ok
115     function totalSupply() public view returns (uint256 total_Supply) {
116         total_Supply = _totalsupply;
117     }
118     
119     //ok
120     function balanceOf(address _owner)public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124     //ok
125     function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO returns (bool success)  {
126         require( _to != 0x0);
127         require(!lockstatus);
128         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
129         balances[_from] = (balances[_from]).sub(_amount);
130         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
131         balances[_to] = (balances[_to]).add(_amount);
132         emit Transfer(_from, _to, _amount);
133         return true;
134     }
135     
136     //ok
137     function approve(address _spender, uint256 _amount)public onlyFinishedICO returns (bool success)  {
138         require(!lockstatus);
139         require( _spender != 0x0);
140         allowed[msg.sender][_spender] = _amount;
141         emit Approval(msg.sender, _spender, _amount);
142         return true;
143     }
144   
145     //ok
146     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
147         require( _owner != 0x0 && _spender !=0x0);
148         return allowed[_owner][_spender];
149     }
150 
151     //ok
152     function transfer(address _to, uint256 _amount)public onlyFinishedICO returns (bool success) {
153         require(!lockstatus);
154         require( _to != 0x0);
155         require(balances[msg.sender] >= _amount && _amount >= 0);
156         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
157         balances[_to] = (balances[_to]).add(_amount);
158         emit Transfer(msg.sender, _to, _amount);
159         return true;
160     }
161     //ok
162     function burn(uint256 value) public onlyOwner returns (bool success) {
163         uint256 _value = value * 10 ** 18;
164         require(balances[msg.sender] >= _value);   
165         balances[msg.sender] = (balances[msg.sender]).sub(_value);            
166         _totalsupply = _totalsupply.sub(_value);                     
167         emit Burn(msg.sender, _value);
168         return true;
169     }
170     //ok
171     // function burnFrom(address _from, uint256 value) public onlyOwner returns (bool success) {
172     //     uint256 _value = value * 10 ** 18;
173     //     require(balances[_from] >= _value);                
174     //     require(_value <= allowed[_from][msg.sender]);    
175     //     balances[_from] = (balances[_from]).sub(_value);                         
176     //     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);             
177     //     _totalsupply = _totalsupply.sub(_value);                             
178     //     emit Burn(_from, _value);
179     //     return true;
180     // }
181 
182     //ok
183     function stopTransferToken() external onlyOwner onlyFinishedICO {
184         require(!lockstatus);
185         lockstatus = true;
186     }
187 
188     //ok
189     function startTransferToken() external onlyOwner onlyFinishedICO {
190         require(lockstatus);
191         lockstatus = false;
192     }
193 
194     //ok
195     function manualMint(address receiver, uint256 _tokenQuantity) external onlyOwner onlyManual {
196         uint256 tokenQuantity = _tokenQuantity * 10 ** 18;
197         uint256 tokenPrice = calculatePrice();
198         uint256 ethAmount = tokenQuantity.div(tokenPrice);
199         ETHcollected = ETHcollected.add(ethAmount);
200         require(ETHcollected <= maxCap);
201         mintContract(owner, receiver, tokenQuantity);
202     }
203 
204     //ok
205     function () public payable onlyICO {
206         require(msg.value != 0 && msg.sender != 0x0);
207         require(!stopped && msg.sender != owner);
208         uint256 tokenPrice = calculatePrice();
209         uint256 tokenQuantity = (msg.value).mul(tokenPrice);
210         ETHcollected = ETHcollected.add(msg.value);
211         require(ETHcollected <= maxCap);
212         mintContract(address(this), msg.sender, tokenQuantity);
213     }
214 
215     //ok
216     function mintContract(address from, address receiver, uint256 tokenQuantity) private {
217         require(tokenQuantity > 0);
218         mintedTokens = mintedTokens.add(tokenQuantity);
219         uint256 novumShare = tokenQuantity * 4 / 65;
220         uint256 userManagement = tokenQuantity * 31 / 65;
221         balances[novumAddress] = balances[novumAddress].add(novumShare);
222         balances[owner] = balances[owner].add(userManagement);
223         _totalsupply = _totalsupply.add(tokenQuantity * 100 / 65);
224         balances[receiver] = balances[receiver].add(tokenQuantity);
225         emit Mint(from, receiver, tokenQuantity);
226         emit Transfer(0, receiver, tokenQuantity);
227         emit Mint(from, novumAddress, novumShare);
228         emit Transfer(0, novumAddress, novumShare);
229         emit Mint(from, owner, userManagement);
230         emit Transfer(0, owner, userManagement);
231     }
232     
233     //ok
234     function calculatePrice() private view returns (uint256){
235         uint256 price_token = basePrice;
236          
237         if(now < presale1_startdate) {
238             require(ETHcollected < 10000 ether);
239             price_token = basePrice * 6 / 5;   
240         }
241         else  if (now < presale2_startdate) {
242             require(ETHcollected < 11739 ether);
243             price_token = basePrice * 23 / 20;   
244         }
245         else if (now < presale3_startdate) {
246             require(ETHcollected < 13557 ether);
247             price_token = basePrice * 11 / 10;
248         }
249         else if (now < ico_startdate) {
250             require(ETHcollected < 15462 ether);
251             price_token = basePrice * 21 / 20;
252         }
253         else {
254             require(ETHcollected < maxCap);
255             price_token = basePrice;
256         }
257         return price_token;
258     }
259     
260     //ok
261     function CrowdSale_Halt() external onlyOwner onlyICO {
262         require(!stopped);
263         stopped = true;
264     }
265 
266     //ok
267     function CrowdSale_Resume() external onlyOwner onlyICO {
268         require(stopped);
269         stopped = false;
270     }
271     //ok
272     function CrowdSale_Change_ReceiveWallet(address New_Wallet_Address) external onlyOwner {
273         require(New_Wallet_Address != 0x0);
274         ethFundMain = New_Wallet_Address;
275     }
276 
277     //ok
278 	function CrowdSale_AssignOwnership(address newOwner) public onlyOwner {
279 	    require(newOwner != 0x0);
280 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
281 	    balances[owner] = 0;
282 	    owner = newOwner;
283 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
284 	}
285 
286     //ok
287     function forwardFunds() external onlyOwner { 
288         address myAddress = this;
289         ethFundMain.transfer(myAddress.balance);
290     }
291 
292     //ok
293     // function increaseMaxCap(uint256 value) public onlyOwner returns(bool) {
294     //     maxCap = maxCap.add(value * 10 ** 18);
295     //     return true;
296     // }
297     
298     //ok
299     function modify_NovumAddress(address newAddress) public onlyOwner returns(bool) {
300         require(newAddress != 0x0 && novumAddress != newAddress);
301         uint256 novumBalance = balances[novumAddress];
302         address oldAddress = novumAddress;
303         balances[newAddress] = (balances[newAddress]).add(novumBalance);
304         balances[novumAddress] = 0;
305         novumAddress = newAddress;
306         emit Transfer(oldAddress, newAddress, novumBalance);
307         return true;
308     }
309     //ok
310     // function modify_Presale1StartDate(uint256 newDate) public onlyOwner returns(bool) {
311     //     presale1_startdate = newDate;
312     //     return true;
313     // }
314     // //ok
315     // function modify_Presale2StartDate(uint256 newDate) public onlyOwner returns(bool) {
316     //     presale2_startdate = newDate;
317     //     return true;
318     // }
319     // //ok
320     // function modify_Presale3StartDate(uint256 newDate) public onlyOwner returns(bool) {
321     //     presale3_startdate = newDate;
322     //     return true;
323     // }
324     // //ok
325     // function modify_ICOStartDate(uint256 newDate) public onlyOwner returns(bool) {
326     //     ico_startdate = newDate;
327     //     return true;
328     // }
329     // //ok
330     // function modify_ICOEndDate(uint256 newDate) public onlyOwner returns(bool) {
331     //     ico_enddate = newDate;
332     //     return true;
333     // }
334 }