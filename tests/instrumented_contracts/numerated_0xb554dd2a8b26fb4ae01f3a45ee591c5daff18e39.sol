1 pragma solidity ^0.5.1;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal pure returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   
14   function div(uint a, uint b) internal pure returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal pure returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal pure returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract owned {
34     address payable public owner;
35     address payable public reclaimablePocket; //**this will hold any of this contract token that is sent to this contract by mistake, and can be claimed back
36     address payable public teamWallet;
37     constructor(address payable _reclaimablePocket, address payable _teamWallet) public {
38         owner = msg.sender;
39         reclaimablePocket = _reclaimablePocket;
40         teamWallet = _teamWallet;
41     }
42     modifier onlyOwner {
43         require(msg.sender == owner);
44         _;
45     }
46     modifier onlyTeam {
47         require(msg.sender == teamWallet || msg.sender == owner);
48         _;
49     }
50     function transferOwnership(address payable newOwner) onlyOwner public { owner = newOwner; }
51     function changeRecPocket(address payable _newRecPocket) onlyTeam public { reclaimablePocket = _newRecPocket;}
52     function changeTeamWallet(address payable _newTeamWallet) onlyOwner public { teamWallet = _newTeamWallet;}
53 }
54 
55 interface ERC20 {
56     function transferFrom(address _from, address _to, uint _value) external returns (bool); //3rd party transfer
57     function approve(address _spender, uint _value) external returns (bool); //set allowance
58     function allowance(address _owner, address _spender) external view returns (uint); //get allowance value
59     event Approval(address indexed _owner, address indexed _spender, uint _value); //emits approval activities
60 }
61 interface ERC223 {
62     function transfer(address _to, uint _value, bytes calldata _data) external returns (bool);
63     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
64 }
65 interface ERC223ReceivingContract { function tokenFallback(address _from, uint _value, bytes calldata _data) external; }
66 
67 contract Token is ERC20, ERC223, owned {
68     
69     using SafeMath for uint;
70     
71     string internal _symbol;
72     string internal _name;
73     uint256 internal _decimals = 18;
74     string public version = "1.0.0";
75     uint internal _totalSupply;
76     mapping (address => uint) internal _balanceOf;
77     mapping (address => mapping (address => uint)) internal _allowances;
78 
79     //Configurables
80     uint256 public tokensSold = 0;
81     uint256 public remainingTokens;
82     //uint256 public teamReserve;
83     uint256 public buyPrice;    //eth per Token
84     
85     constructor(string memory name, string memory symbol, uint totalSupply) public {
86         _symbol = symbol;
87         _name = name;
88         _totalSupply = totalSupply * 10 ** uint256(_decimals);  // Update total supply with the decimal amount
89     }
90     
91     function name() public view returns (string memory) { return _name; }
92     function symbol() public view returns (string memory) { return _symbol; }
93     function decimals() public view returns (uint256) { return _decimals; }
94     function totalSupply() public view returns (uint) { return _totalSupply; }
95     function balanceOf(address _addr) public view returns (uint);
96     function transfer(address _to, uint _value) public returns (bool);
97     event Transfer(address indexed _from, address indexed _to, uint _value);
98     // To emit direct purchase of token transaction from contract.
99     event purchaseInvoice(address indexed _buyer, uint _tokenReceived, uint _weiSent, uint _weiCost, uint _weiReturned );
100 }
101 
102 contract SiBiCryptToken is Token {
103    
104     /**
105      * @dev enum of current crowd sale state
106      **/
107      enum Stages {none, icoStart, icoPaused, icoResumed, icoEnd} 
108      Stages currentStage;
109     bool payingDividends;
110     uint256 freezeTimeStart;
111     uint256 constant freezePeriod = 1 * 1 days;
112     
113     function balanceOf(address _addr) public view returns (uint) {
114         return _balanceOf[_addr];
115     }
116     
117     modifier checkICOStatus(){
118         require(currentStage == Stages.icoPaused || currentStage == Stages.icoEnd, "Pls, try again after ICO");
119         _;
120     }
121     modifier isPayingDividends(){
122         if(payingDividends && now >= (freezeTimeStart+freezePeriod)){
123             payingDividends = false;
124         }
125         require(!payingDividends, "Dividends is being dispatch, pls try later");
126         _;
127     }
128     function payOutDividends() public onlyOwner returns(bool){
129         payingDividends = true;
130         freezeTimeStart = now;
131         return true;
132     }
133     event thirdPartyTransfer( address indexed _from, address indexed _to, uint _value, address indexed _sentBy ) ;
134     event returnedWei(address indexed _fromContract, address indexed _toSender, uint _value);
135 
136     function transfer(address _to, uint _value) public returns (bool) {
137         bytes memory empty ;
138         transfer(_to, _value, empty);
139         return true;
140     }
141 
142     function transfer(address _to, uint _value, bytes memory _data) public returns (bool) {
143         _transfer(msg.sender, _to, _value);
144         if(isContract(_to)){
145             if(_to == address(this)){
146                 _transfer(address(this), reclaimablePocket, _value);
147             }
148             else
149             {
150                 ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
151                     _contract.tokenFallback(msg.sender, _value, _data);
152             }
153         }
154         emit Transfer(msg.sender, _to, _value, _data);
155         return true;
156     }
157 
158     function isContract(address _addr) public view returns (bool) {
159         uint codeSize;
160         assembly {
161             codeSize := extcodesize(_addr)
162         }
163         return codeSize > 0;
164     }
165 
166     function transferFrom(address _from, address _to, uint _value) public checkICOStatus returns (bool) {
167         require (_value > 0 && _allowances[_from][msg.sender] >= _value, "insufficient allowance");
168         _transfer(_from, _to, _value);
169         _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
170         emit thirdPartyTransfer(_from, _to, _value, msg.sender);
171         return true;
172     }
173     
174     /**
175      * Internal transfer, only can be called by this contract
176      */
177     function _transfer(address _from, address _to, uint _value) internal checkICOStatus isPayingDividends {
178         require(_to != address(0x0), "invalid 'to' address"); // Prevent transfer to 0x0 address. Use burn() instead
179         require(_balanceOf[_from] >= _value, "insufficient funds"); // Check if the sender has enough
180         require(_balanceOf[_to] + _value > _balanceOf[_to], "overflow err"); // Check for overflows
181         uint previousBalances = _balanceOf[_from] + _balanceOf[_to]; // Save this for an assertion in the future
182         // Subtract from the sender
183         _balanceOf[_from] = _balanceOf[_from].sub(_value); 
184         _balanceOf[_to] = _balanceOf[_to].add(_value); // Add the same to the recipient
185         emit Transfer(_from, _to, _value);
186 
187         // Asserts are used to use static analysis to find bugs in your code. They should never fail
188         assert(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
189     }
190     
191     function approve(address _spender, uint _value) public returns (bool) {
192         require(_balanceOf[msg.sender]>=_value);
193         _allowances[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197     
198     function allowance(address _owner, address _spender) public view returns (uint) {
199         return _allowances[_owner][_spender];
200     }
201 }
202 
203 
204 
205 contract SiBiCryptICO is SiBiCryptToken {
206     
207   
208     /**
209      * @dev constructor of CrowdsaleToken
210      **/
211       /* Initializes contract with initial supply tokens and sharesPercent to the creator _owner of the contract */
212     constructor(
213             string memory tokenName, string memory tokenSymbol, uint256 initialSupply, address payable _reclaimablePocket, address payable _teamWallet 
214         ) Token(tokenName, tokenSymbol, initialSupply) owned(_reclaimablePocket, _teamWallet) public {
215         uint toOwnerWallet = (_totalSupply*40)/100;
216         uint toTeam = (_totalSupply*15)/100;
217          _balanceOf[msg.sender] += toOwnerWallet;
218          _balanceOf[teamWallet] += toTeam;
219          emit Transfer(address(this),msg.sender,toOwnerWallet);
220         emit Transfer(address(this),teamWallet,toTeam);
221          tokensSold += toOwnerWallet.add(toTeam);
222          remainingTokens = _totalSupply.sub(tokensSold);
223          currentStage = Stages.none;
224          payingDividends = false;
225     }
226     
227   
228     /// @param newBuyPrice Price users can buy token from the contract
229     function setPrices(uint256 newBuyPrice) onlyOwner public {
230         buyPrice = newBuyPrice;   //ETH per Token
231     }
232     /**
233      * @dev fallback function to send ether to for Crowd sale
234      **/
235     function () external payable {
236         require(currentStage == Stages.icoStart || currentStage == Stages.icoResumed, "Oops! ICO is not running");
237         require(msg.value > 0);
238         require(remainingTokens > 0, "Tokens sold out! you may proceed to buy from Token holders");
239         
240         uint256 weiAmount = msg.value; // Calculate tokens to sell
241         uint256 tokens = (weiAmount.div(buyPrice)).mul(1*10**18);
242         uint256 returnWei;
243         
244         if(tokens > remainingTokens){
245             uint256 newTokens = remainingTokens;
246             uint256 newWei = (newTokens.mul(buyPrice)).div(1*10**18);
247             returnWei = weiAmount.sub(newWei);
248             weiAmount = newWei;
249             tokens = newTokens;
250         }
251         
252         tokensSold = tokensSold.add(tokens); // Increment raised amount
253         remainingTokens = remainingTokens.sub(tokens); //decrease remaining token
254         if(returnWei > 0){
255             msg.sender.transfer(returnWei);
256             emit returnedWei(address(this), msg.sender, returnWei);
257         }
258         
259         _balanceOf[msg.sender] = _balanceOf[msg.sender].add(tokens);
260         emit Transfer(address(this), msg.sender, tokens);
261         emit purchaseInvoice(msg.sender, tokens, msg.value, weiAmount, returnWei);
262        
263         owner.transfer(weiAmount); // Send money for project execution
264         if(remainingTokens == 0 ){pauseIco();}
265     }
266     
267     /**
268      * @dev startIco starts the public ICO
269      **/
270     function startIco() public onlyOwner  returns(bool) {
271         require(currentStage != Stages.icoEnd, "Oops! ICO has been finalized.");
272         require(currentStage == Stages.none, "ICO is running already");
273         currentStage = Stages.icoStart;
274         return true;
275     }
276     
277     function pauseIco() internal {
278         require(currentStage != Stages.icoEnd, "Oops! ICO has been finalized.");
279         currentStage = Stages.icoPaused;
280         owner.transfer(address(this).balance);
281     }
282     
283     function resumeIco() public onlyOwner returns(bool) {
284         require(currentStage == Stages.icoPaused, "call denied");
285         currentStage = Stages.icoResumed;
286         return true;
287     }
288     
289     function ICO_State() public view returns(string memory) {
290         if(currentStage == Stages.none) return "Initializing...";
291         if(currentStage == Stages.icoPaused) return "Paused!";
292         if(currentStage == Stages.icoEnd) return "ICO Stopped!";
293         else return "ICO is running...";
294     }
295     
296 
297     /**
298      * @dev endIco closes down the ICO 
299      **/
300     function endIco() internal {
301         currentStage = Stages.icoEnd;
302         // Transfer any remaining tokens
303         if(remainingTokens > 0){
304             _balanceOf[owner] = _balanceOf[owner].add(remainingTokens);
305         }
306         // transfer any remaining ETH balance in the contract to the owner
307         owner.transfer(address(this).balance); 
308     }
309 
310     /**
311      * @dev finalizeIco closes down the ICO and sets needed varriables
312      **/
313     function finalizeIco() public onlyOwner returns(Stages){
314         require(currentStage != Stages.icoEnd );
315         if(currentStage == Stages.icoPaused){
316             endIco();
317             return currentStage;
318         }
319         else{
320             pauseIco();
321             return currentStage;
322         }
323     }
324 }
325 
326 
327 
328 /**
329  * ******************************************************************************************************************
330  * If you find this code useful or helpful, please give a tip @ 0x15f26bA042233BC6e31e961195fFACAC7F63E97E Thanks!***
331  * ******************************************************************************************************************
332 **/