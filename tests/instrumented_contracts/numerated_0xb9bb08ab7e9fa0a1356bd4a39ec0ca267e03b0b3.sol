1 pragma solidity ^0.4.23;
2 /*
3  * Ownable
4  *
5  * Base contract with an owner.
6  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
7  */
8 contract Ownable {
9   address public owner;
10   
11   constructor(){ 
12     owner = msg.sender;
13   }
14 
15   modifier onlyOwner() {
16     if (msg.sender != owner) {
17       revert();
18     }
19     _;
20   }
21   //transfer owner to another address
22   function transferOwnership(address _newOwner) onlyOwner {
23     if (_newOwner != address(0)) {
24       owner = _newOwner;
25     }
26   }
27 }
28 
29 /**
30  * Math operations with safety checks
31  */
32 contract SafeMath {
33   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
40     assert(b > 0);
41     uint256 c = a / b;
42     assert(a == b * c + a % b);
43     return c;
44   }
45 
46   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
52     uint256 c = a + b;
53     assert(c>=a && c>=b);
54     return c;
55   }
56 
57   function assert(bool assertion) internal {
58     if (!assertion) {
59       revert();
60     }
61   }
62 }
63 
64 contract Token {
65 
66   uint256 public totalSupply;
67   function balanceOf(address _owner) constant returns (uint256 balance);
68 
69   function transfer(address _to, uint256 _value) returns (bool success);
70 
71   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
72 
73   function approve(address _spender, uint256 _value) returns (bool success);
74 
75   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
76 
77   event Transfer(address indexed _from, address indexed _to, uint256 _value);
78   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 contract StandardToken is Token ,SafeMath{
82 
83    /**
84    *
85    * Fix for the ERC20 short address attack
86    *
87    * http://vessenes.com/the-erc20-short-address-attack-explained/
88    */
89   modifier onlyPayloadSize(uint size) {   
90      if(msg.data.length != size + 4) {
91        revert();
92      }
93      _;
94   }
95 
96   //transfer lock flag
97   bool transferLock = true;
98   //transfer modifier
99   modifier canTransfer() {
100     if (transferLock) {
101       revert();
102     }
103     _;
104   }
105 
106   mapping (address => uint256) balances;
107   mapping (address => mapping (address => uint256)) allowed;
108   
109   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
110     
111     balances[msg.sender] = safeSub(balances[msg.sender], _value);
112     balances[_to] = safeAdd(balances[_to], _value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) canTransfer returns (bool success) {
118     uint256 _allowance = allowed[_from][msg.sender];
119     allowed[_from][msg.sender] = safeSub(_allowance, _value);
120     balances[_from] = safeSub(balances[_from], _value);
121     balances[_to] = safeAdd(balances[_to], _value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125   function balanceOf(address _owner) constant returns (uint256 balance) {
126       return balances[_owner];
127   }
128 
129    function approve(address _spender, uint256 _value) canTransfer returns (bool success) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   function allowance(address _owner, address _spender) constant returns (uint remaining) {
143     return allowed[_owner][_spender];
144   }
145 }
146 
147 contract PAIStandardToken is StandardToken,Ownable{
148 
149   /* Public variables of the token */
150 
151   string public name;                   // name: eg pchain
152   uint256 public decimals;              //How many decimals to show.
153   string public symbol;                 //An identifier: eg PAI
154   address public wallet;                //ETH wallet address
155   uint public start;                    //crowd sale start time
156   uint public end;                      //Crowd sale first phase end time
157   uint public deadline;                 // Crowd sale deadline time
158 
159 
160   uint256 public teamShare = 25;        //Team share
161   uint256 public foundationShare = 25;  //Foundation share
162   uint256 public posShare = 15;         //POS share
163   uint256 public saleShare = 35;     //Private share
164   
165   
166   address internal saleAddr;                                 //private sale wallet address
167   uint256 public crowdETHTotal = 0;                 //The ETH amount of current crowdsale
168   mapping (address => uint256) public crowdETHs;    //record user's balance of crowdsale
169   uint256 public crowdPrice = 10000;                //crowdsale price 1(ETH):10000(PAI)
170   uint256 public crowdTarget = 5000 ether;          //The total ETH of crowdsale
171   bool public reflectSwitch = false;                // Whether to allow user to reflect PAI
172   bool public blacklistSwitch = true;               // Whether to allow owner to set blacklist
173   mapping(address => string) public reflects;       // reflect token to PAI address
174   
175 
176   event PurchaseSuccess(address indexed _addr, uint256 _weiAmount,uint256 _crowdsaleEth,uint256 _balance);
177   event EthSweepSuccess(address indexed _addr, uint256 _value);
178   event SetReflectSwitchEvent(bool _b);
179   event ReflectEvent(address indexed _addr,string _paiAddr);
180   event BlacklistEvent(address indexed _addr,uint256 _b);
181   event SetTransferLockEvent(bool _b);
182   event CloseBlacklistSwitchEvent(bool _b);
183 
184   constructor(
185       address _wallet,
186       uint _s,
187       uint _e,
188       uint _d,
189       address _teamAddr,
190       address _fundationAddr,
191       address _saleAddr,
192       address _posAddr
193       ) {
194       totalSupply = 2100000000000000000000000000;       // Update total supply
195       name = "PCHAIN";                  // Set the name for display purposes
196       decimals = 18;           // Amount of decimals for display purposes
197       symbol = "PAI";              // Set the symbol for display purposes
198       wallet = _wallet;                   // Set ETH wallet address
199       start = _s;                         // Set start time for crowsale
200       end = _e;                           // Set Crowd sale first phase end time
201       deadline = _d;                      // Set Crowd sale deadline time
202       saleAddr = _saleAddr; // Set sale account address
203 
204       balances[_teamAddr] = safeMul(safeDiv(totalSupply,100),teamShare); //Team balance
205       balances[_fundationAddr] = safeMul(safeDiv(totalSupply,100),foundationShare); //Foundation balance
206       balances[_posAddr] = safeMul(safeDiv(totalSupply,100),posShare); //POS balance
207       balances[_saleAddr] = safeMul(safeDiv(totalSupply,100),saleShare) ; //Sale balance  
208       Transfer(address(0), _teamAddr,  balances[_teamAddr]);
209       Transfer(address(0), _fundationAddr,  balances[_fundationAddr]);
210       Transfer(address(0), _posAddr,  balances[_posAddr]);
211       Transfer(address(0), _saleAddr,  balances[_saleAddr]);
212   }
213   //set transfer lock
214   function setTransferLock(bool _lock) onlyOwner{
215       transferLock = _lock;
216       SetTransferLockEvent(_lock);
217   }
218   //Permanently turn off the blacklist switch 
219   function closeBlacklistSwitch() onlyOwner{
220     blacklistSwitch = false;
221     CloseBlacklistSwitchEvent(false);
222   }
223   //set blacklist
224   function setBlacklist(address _addr) onlyOwner{
225       require(blacklistSwitch);
226       uint256 tokenAmount = balances[_addr];             //calculate user token amount
227       balances[_addr] = 0;//clear user‘s PAI balance
228       balances[saleAddr] = safeAdd(balances[saleAddr],tokenAmount);  //add PAI tokenAmount to Sale
229       Transfer(_addr, saleAddr, tokenAmount);
230       BlacklistEvent(_addr,tokenAmount);
231   } 
232 
233   //set reflect switch
234   function setReflectSwitch(bool _s) onlyOwner{
235       reflectSwitch = _s;
236       SetReflectSwitchEvent(_s);
237   }
238   function reflect(string _paiAddress){
239       require(reflectSwitch);
240       reflects[msg.sender] = _paiAddress;
241       ReflectEvent(msg.sender,_paiAddress);
242   }
243 
244   function purchase() payable{
245       require(block.timestamp <= deadline);                                 //the timestamp must be less than the deadline time
246       require(tx.gasprice <= 60000000000);
247       require(block.timestamp >= start);                                //the timestamp must be greater than the start time
248       uint256 weiAmount = msg.value;                                    // The amount purchased by the current user
249       require(weiAmount >= 0.1 ether);
250       crowdETHTotal = safeAdd(crowdETHTotal,weiAmount);                 // Calculate the total amount purchased by all users
251       require(crowdETHTotal <= crowdTarget);                            // The total amount is less than or equal to the target amount
252       uint256 userETHTotal = safeAdd(crowdETHs[msg.sender],weiAmount);  // Calculate the total amount purchased by the current user
253       if(block.timestamp <= end){                                       // whether the current timestamp is in the first phase
254         require(userETHTotal <= 0.4 ether);                             // whether the total amount purchased by the current user is less than 0.4ETH
255       }else{
256         require(userETHTotal <= 10 ether);                              // whether the total amount purchased by the current user is less than 10ETH
257       }      
258       
259       crowdETHs[msg.sender] = userETHTotal;                             // Record the total amount purchased by the current user
260 
261       uint256 tokenAmount = safeMul(weiAmount,crowdPrice);             //calculate user token amount
262       balances[msg.sender] = safeAdd(tokenAmount,balances[msg.sender]);//recharge user‘s PAI balance
263       balances[saleAddr] = safeSub(balances[saleAddr],tokenAmount);  //sub PAI tokenAmount from  Sale
264       wallet.transfer(weiAmount);
265       Transfer(saleAddr, msg.sender, tokenAmount);
266       PurchaseSuccess(msg.sender,weiAmount,crowdETHs[msg.sender],tokenAmount); 
267   }
268 
269   function () payable{
270       purchase();
271   }
272 }