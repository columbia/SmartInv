1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // Owned contract
27 // ----------------------------------------------------------------------------
28 contract Owned {
29     address public owner;
30     address public newOwner;
31 
32     event OwnershipTransferred(address indexed _from, address indexed _to);
33 
34     modifier onlyOwner {
35         require(msg.sender == owner, "ONLY OWNER IS ALLOWED");
36         _;
37     }
38 
39     function transferOwnership(address _newOwner) public onlyOwner {
40         newOwner = _newOwner;
41     }
42     function acceptOwnership() public {
43         require(msg.sender == newOwner);
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 contract IBelottoToken{
51     function transfer(address to, uint tokens) public returns (bool success);
52     function burn(uint256 _value) public;
53     function balanceOf(address tokenOwner) public constant returns (uint balance);
54 }
55 
56 /**
57  * @title BelottoCrowdsale
58  * @dev BelottoCrowdsale accepting contributions only within a time frame.
59  */
60 contract BelottoCrowdsale is Owned {
61   using SafeMath for uint256; 
62   uint256 public presaleopeningTime;
63   uint256 public presaleclosingTime;
64   uint256 public saleopeningTime;
65   uint256 public saleclosingTime;
66   uint256 public secondsaleopeningTime;
67   uint256 public secondsaleclosingTime;
68   address public reserverWallet;    // Address where reserve tokens will be sent
69   address public bountyWallet;      // Address where bounty tokens will be sent
70   address public teamsWallet;       // Address where team's tokens will be sent
71   address public fundsWallet;       // Address where funds are collected
72   uint256 public fundsRaised;         // Amount of total fundsRaised
73   uint256 public preSaleTokens;
74   uint256 public saleTokens;
75   uint256 public teamAdvTokens;
76   uint256 public reserveTokens;
77   uint256 public bountyTokens;
78   uint256 public hardCap;
79   uint256 public minTxSize;
80   uint256 public maxTxSize;
81   bool    public presaleOpen;
82   bool    public firstsaleOpen;
83   bool    public secondsaleOpen;
84   mapping(address => uint) preSaleFunds;
85   mapping(address => uint) firstSaleFunds;
86   mapping(address => uint) secondSaleFunds;
87   struct Funds {
88     address spender;
89     uint256 amount;
90     uint256 time;
91     }
92     Funds[]  preSaleFundsArray;
93     Funds[]  firstSaleFundsArray;
94     Funds[]  secondSaleFundsArray;
95   
96   IBelottoToken public token;
97   
98   event Burn(address indexed burner, uint256 value);
99   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
100   /** @dev Reverts if not in crowdsale time range. */
101   modifier onlyWhilePreSaleOpen {
102     require(now >= presaleopeningTime && now <= presaleclosingTime, "Pre Sale Close");
103     _;
104   }
105   
106   modifier onlyWhileFirstSaleOpen {
107     require(now >= saleopeningTime && now <= saleclosingTime, "First Sale Close");
108     _;
109   }
110   
111   modifier onlyWhileSecondSaleOpen {
112     require(now >= secondsaleopeningTime && now <= secondsaleclosingTime, "Second Sale Close");
113     _;
114   }
115   
116   function totalRemainingTokens() public view returns(uint256 remainingTokens){
117     return token.balanceOf(this);      
118   }
119   
120   function BelottoCrowdsale(uint256 _preST, uint256 _saleT, uint256 _teamAdvT, uint256 _reserveT, uint256 _bountyT, address _reserverWallet, 
121                             address _bountyWallet, address _teamsWallet, address _fundsWallet, address _tokenContractAdd, address _owner) 
122                             public {
123     
124     
125     _setWallets(_reserverWallet,_bountyWallet,_teamsWallet,_fundsWallet);
126     _setMoreDetails(_preST,_saleT,_teamAdvT,_reserveT,_bountyT,_owner);
127     _setTimes();
128     
129     // takes an address of the existing token contract as parameter
130     token = IBelottoToken(_tokenContractAdd);
131   }
132   
133   function _setTimes() internal{
134     presaleopeningTime    = 1524873600; // 28th April 2018 00:00:00 GMT 
135     presaleclosingTime    = 1527379199; // 26th May 2018 23:59:59 GMT   
136     saleopeningTime       = 1527724800; // 31st May 2018 00:00:00 GMT 
137     saleclosingTime       = 1532908799; // 29th July 2018 23:59:59 GMT
138     secondsaleopeningTime = 1532908800; // 30th July 2018 00:00:00 GMT
139     secondsaleclosingTime = 1535673599; // 30th August 2018 23:59:59 GMT
140   }
141   
142   function _setWallets(address _reserverWallet, address _bountyWallet, address _teamsWallet, address _fundsWallet) internal{
143     reserverWallet        = _reserverWallet;
144     bountyWallet          = _bountyWallet;
145     teamsWallet           = _teamsWallet;
146     fundsWallet           = _fundsWallet;
147   }
148   
149   function _setMoreDetails(uint256 _preST, uint256 _saleT, uint256 _teamAdvT, uint256 _reserveT, uint256 _bountyT, address _owner) internal{
150     preSaleTokens         = _preST * 10**uint(18);
151     saleTokens            = _saleT * 10**uint(18);
152     teamAdvTokens         = _teamAdvT * 10**uint(18);
153     reserveTokens         = _reserveT * 10**uint(18);
154     bountyTokens          = _bountyT * 10**uint(18);
155     hardCap               = 16000 * 10**(uint(18));   //in start only, it'll be set by Owner
156     minTxSize             = 100000000000000000; // in wei's. (0,1 ETH)
157     maxTxSize             = 200000000000000000000; // in wei's. (200 ETH)
158     owner = _owner;
159   }
160   
161   function TokenAllocate(address _wallet,uint256 _amount) internal returns (bool success) {
162       uint256 tokenAmount = _amount;
163       token.transfer(_wallet,tokenAmount);
164       return true;
165   }
166   
167   function startSecondSale() public onlyOwner{
168       presaleOpen = false;
169       firstsaleOpen  = false;
170       secondsaleOpen = true;
171   }
172   
173   
174   function stopSecondSale() public onlyOwner{
175       presaleOpen = false;
176       firstsaleOpen = false;
177       secondsaleOpen = false;
178       if(teamAdvTokens >= 0 && bountyTokens >=0){
179           TokenAllocate(teamsWallet,teamAdvTokens);
180           teamAdvTokens = 0;
181           TokenAllocate(bountyWallet,bountyTokens);
182           bountyTokens = 0;
183       }
184   }
185 
186   function _checkOpenings(uint256 _weiAmount) internal{
187       if((fundsRaised + _weiAmount >= hardCap)){
188             presaleOpen = false;
189             firstsaleOpen  = false;
190             secondsaleOpen = true;
191       }
192       else if(secondsaleOpen){
193           presaleOpen = false;
194           firstsaleOpen  = false;
195           secondsaleOpen = true;
196       }
197       else if(now >= presaleopeningTime && now <= presaleclosingTime){
198           presaleOpen = true;
199           firstsaleOpen = false;
200           secondsaleOpen = false;
201           if(reserveTokens >= 0){
202             if(TokenAllocate(reserverWallet,reserveTokens)){
203                 reserveTokens = 0;
204             }
205           }
206       }
207       else if(now >= saleopeningTime && now <= saleclosingTime){
208           presaleOpen = false;
209           firstsaleOpen = true;
210           secondsaleOpen = false;
211       }
212       else if(now >= secondsaleopeningTime && now <= secondsaleclosingTime){
213             presaleOpen = false;
214             firstsaleOpen  = false;
215             secondsaleOpen = true;
216       }
217       else{
218           presaleOpen = false;
219           firstsaleOpen = false;
220           secondsaleOpen = false;
221           if(teamAdvTokens >= 0 && bountyTokens >=0){
222             TokenAllocate(teamsWallet,teamAdvTokens);
223             teamAdvTokens = 0;
224             TokenAllocate(bountyWallet,bountyTokens);
225             bountyTokens = 0;
226           }
227       }
228   }
229   
230   function () external payable {
231     buyTokens(msg.sender);
232   }
233 
234   function buyTokens(address _beneficiary) public payable {
235     
236     uint256 ethers = msg.value;
237     
238     _preValidatePurchase(_beneficiary, ethers);
239     
240     _checkOpenings(ethers);
241     
242     _setFunds(_beneficiary,ethers);
243     
244     // update state of wei's raised during complete ICO
245     fundsRaised = fundsRaised.add(ethers);
246     //sjfhj
247     _forwardFunds(_beneficiary); 
248   }
249   
250   function _setFunds(address _beneficiary, uint256 _ethers) internal{
251       if(presaleOpen){
252           preSaleFundsArray.push(Funds(_beneficiary,_ethers, now));
253       }
254       else if(firstsaleOpen){
255           firstSaleFundsArray.push(Funds(_beneficiary,_ethers, now));
256       }
257       else if(secondsaleOpen){
258           secondSaleFundsArray.push(Funds(_beneficiary,_ethers, now));
259       }
260   }
261   
262   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{
263    require(_beneficiary != address(0), "WRONG Address");
264    require(_weiAmount != 0, "Insufficient funds");
265    require(_weiAmount >= minTxSize  && _weiAmount <= maxTxSize ,"FUNDS should be MIN 0,1 ETH and Max 200 ETH");
266   }
267   
268   function TotalSpenders() public view returns (uint256 preSaleSpenders,uint256 firstSaleSpenders,uint256 secondSaleSpenders){
269       return ((preSaleFundsArray.length),(firstSaleFundsArray.length),(secondSaleFundsArray.length));
270   }
271   
272   function _forwardFunds(address _beneficiary) internal {
273     fundsWallet.transfer(msg.value);
274   }
275   
276   function preSaleDelivery(address _beneficiary, uint256 _tokenAmount) public onlyOwner{
277       _checkOpenings(0);
278       require(!presaleOpen, "Pre-Sale is NOT CLOSE ");
279       require(preSaleTokens >= _tokenAmount,"NO Pre-SALE Tokens Available");
280       token.transfer(_beneficiary,_tokenAmount);
281       preSaleTokens = preSaleTokens.sub(_tokenAmount);
282   }
283   
284   function firstSaleDelivery(address _beneficiary, uint256 _tokenAmount) public onlyOwner{
285       require(!presaleOpen && !firstsaleOpen, "First Sale is NOT CLOSE");
286       if(saleTokens <= _tokenAmount && preSaleTokens >= _tokenAmount){
287           saleTokens = saleTokens.add(_tokenAmount);
288           preSaleTokens = preSaleTokens.sub(_tokenAmount);
289       }
290       token.transfer(_beneficiary,_tokenAmount);
291       saleTokens = saleTokens.sub(_tokenAmount);
292   }
293   
294   function secondSaleDelivery(address _beneficiary, uint256 _tokenAmount) public onlyOwner{
295       require(!presaleOpen && !firstsaleOpen && !secondsaleOpen, "Second Sale is NOT CLOSE");
296       require(saleTokens >= _tokenAmount,"NO Sale Tokens Available");
297       token.transfer(_beneficiary,_tokenAmount);
298       saleTokens = saleTokens.sub(_tokenAmount);
299   }
300   
301   /**
302    * @dev Burns a specific amount of tokens.
303    * @param _value The amount of token to be burned.
304    */
305   function burnTokens(uint256 _value) public onlyOwner {
306       token.burn(_value);
307   }
308  
309   function preSaleSpenderTxDetails(uint _index) public view returns(address spender, uint256 amount, uint256 time){
310       return (preSaleFundsArray[_index].spender,preSaleFundsArray[_index].amount,preSaleFundsArray[_index].time);
311   }
312   
313   function firstSaleSpenderTxDetails(uint _index) public view returns(address spender, uint256 amount, uint256 time){
314       return (firstSaleFundsArray[_index].spender,firstSaleFundsArray[_index].amount,firstSaleFundsArray[_index].time);
315   }
316   
317   function secSaleSpenderTxDetails(uint _index) public view returns(address spender, uint256 amount, uint256 time){
318       return (secondSaleFundsArray[_index].spender,secondSaleFundsArray[_index].amount,secondSaleFundsArray[_index].time);
319   }
320   
321   
322   function transferRemainingTokens(address _to,uint256 _tokens) public onlyOwner {
323       require(!presaleOpen && !firstsaleOpen && !secondsaleOpen);
324       uint myBalance = token.balanceOf(this); 
325       require(myBalance >= _tokens);
326       token.transfer(_to,_tokens);
327   }
328   
329   function updateHardCap(uint256 _hardCap)public onlyOwner {
330       hardCap = _hardCap * 10**uint(18);
331   }
332 }