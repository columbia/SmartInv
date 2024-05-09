1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ================= ERC20 Token Contract start =========================
26 /*
27  * ERC20 interface
28  * see https://github.com/ethereum/EIPs/issues/20
29  */
30 contract ERC20 {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37     
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 // Evabot interface
43 contract Evabot {
44     function increasePendingTokenBalance(address _user, uint256 _amount) public;
45 }
46 
47 // Evotexchange interface
48 contract EvotExchange {
49     function increaseEthBalance(address _user, uint256 _amount) public;
50     function increaseTokenBalance(address _user, uint256 _amount) public;
51 }
52 
53 // wallet contract
54 contract Evoai {
55   
56   using SafeMath for uint256;
57   address private admin; //the admin address
58   address private evabot_contract; //evabot contract address
59   address private exchange_contract; //exchange contract address
60   address private tokenEVOT; // EVOT contract
61   uint256 public feeETH; // ETH fee value
62   uint256 public feeEVOT; //EVOAI fee value
63   uint256 public totalEthFee; // total acount ether fee
64   uint256 public totalTokenFee; // total account token fee
65   mapping (address => uint256) public tokenBalance; //mapping of token address
66   mapping (address => uint256) public etherBalance; //mapping of ether address
67   
68   //events
69   event Deposit(uint256 types, address user, uint256 amount); // type 0 is ether, 1 is token
70   event Withdraw(uint256 types, address user, uint256 amount); // type 0 is ether, 1 is token
71   event Transfered(uint256 types, address _from, uint256 amount, address _to);// type 0 is ether, 1 is token
72   
73   // constructor
74   constructor() public {
75     admin = msg.sender;
76     totalEthFee = 0; // init with zero (contract fee)
77     totalTokenFee = 0; // init the token fee
78   }
79 
80   modifier onlyAdmin {
81     require(msg.sender == admin);
82     _;
83   }
84   
85   // set the EVOT token contract address
86   function setTokenAddress(address _token) onlyAdmin() public {
87       tokenEVOT = _token;
88   }
89   
90   // set evabot contract address to interact with that
91   function setEvabotContractAddress(address _token) onlyAdmin() public {
92       evabot_contract = _token;
93   }
94   
95   // set evabot contract address to interact with that
96   function setExchangeContractAddress(address _token) onlyAdmin() public {
97       exchange_contract = _token;
98   }
99   
100   // set initial fee
101   function setETHFee(uint256 amount) onlyAdmin() public {
102     feeETH = amount;
103   }
104   
105   // set initial token fee
106   function setTokenFee(uint256 amount) onlyAdmin() public {
107     feeEVOT = amount;
108   }
109   
110   //change the admin account
111   function changeAdmin(address admin_) onlyAdmin() public {
112     admin = admin_;
113   }
114 
115   // ether deposit
116   function deposit() payable public {
117     totalEthFee = totalEthFee.add(feeETH);
118     etherBalance[msg.sender] = (etherBalance[msg.sender]).add(msg.value.sub(feeETH));
119     emit Deposit(0, msg.sender, msg.value); // 0 is ether deposit
120   }
121 
122   function() payable public {
123       
124   }
125   
126   // withdraw ether
127   function withdraw(uint256 amount) public {
128     require(etherBalance[msg.sender] >= amount);
129     etherBalance[msg.sender] = etherBalance[msg.sender].sub(amount);
130     msg.sender.transfer(amount);
131     emit Withdraw(0, msg.sender, amount); // 0 is ether withdraw
132   }
133 
134   // deposit token
135   function depositToken(uint256 amount) public {
136     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
137     if (!ERC20(tokenEVOT).transferFrom(msg.sender, this, amount)) revert();
138     totalTokenFee = totalTokenFee.add(feeEVOT);
139     tokenBalance[msg.sender] = tokenBalance[msg.sender].add(amount.sub(feeEVOT));
140     emit Deposit(1, msg.sender, amount); // 1 is token deposit
141   }
142 
143   // withdraw token
144   function withdrawToken(uint256 amount) public {
145     require(tokenBalance[msg.sender] >= amount);
146     tokenBalance[msg.sender] = tokenBalance[msg.sender].sub(amount);
147     if (!ERC20(tokenEVOT).transfer(msg.sender, amount)) revert();
148     emit Withdraw(1, msg.sender, amount); // 1 is token withdraw
149   }
150 
151   // ether transfer
152   function transferETH(uint256 amount) public {
153     require(etherBalance[msg.sender] >= amount);
154     etherBalance[msg.sender] = etherBalance[msg.sender].sub(amount);
155     exchange_contract.transfer(amount);
156     EvotExchange(exchange_contract).increaseEthBalance(msg.sender, amount);
157     emit Transfered(0, msg.sender, amount, msg.sender);
158   }
159 
160   // transfer token
161   function transferToken(address _receiver, uint256 amount) public {
162     if (tokenEVOT==0) revert();
163     require(tokenBalance[msg.sender] >= amount);
164     tokenBalance[msg.sender] = tokenBalance[msg.sender].sub(amount);
165     if (!ERC20(tokenEVOT).transfer(_receiver, amount)) revert();
166     if (_receiver == evabot_contract)
167         Evabot(evabot_contract).increasePendingTokenBalance(msg.sender, amount);
168     if (_receiver == exchange_contract)
169         EvotExchange(exchange_contract).increaseTokenBalance(msg.sender, amount);
170     emit Transfered(1, msg.sender, amount, msg.sender);
171   }
172   
173   // received ether from evabot_contract
174   function recevedEthFromEvabot(address _user, uint256 _amount) public {
175     require(msg.sender == evabot_contract);
176     etherBalance[_user] = etherBalance[_user].add(_amount);
177   }
178   
179   // received token from evabot_contract
180   function recevedTokenFromEvabot(address _user, uint256 _amount) public {
181     require(msg.sender == evabot_contract);
182     tokenBalance[_user] = tokenBalance[_user].add(_amount);
183   }
184   
185   // received ether from exchange contract
186   function recevedEthFromExchange(address _user, uint256 _amount) public {
187     require(msg.sender == exchange_contract);
188     etherBalance[_user] = etherBalance[_user].add(_amount);
189   }
190   
191   // withdraw ether fee
192   function feeWithdrawEthAmount(uint256 amount) onlyAdmin() public {
193     require(totalEthFee >= amount);
194     totalEthFee = totalEthFee.sub(amount);
195     msg.sender.transfer(amount);
196   }
197 
198   // withrawall ether fee.
199   function feeWithdrawEthAll() onlyAdmin() public {
200     if (totalEthFee == 0) revert();
201     totalEthFee = 0;
202     msg.sender.transfer(totalEthFee);
203   }
204 
205   // withdraw token fee
206   function feeWithdrawTokenAmount(uint256 amount) onlyAdmin() public {
207     require(totalTokenFee >= amount);
208     if (!ERC20(tokenEVOT).transfer(msg.sender, amount)) revert();
209     totalTokenFee = totalTokenFee.sub(amount);
210   }
211 
212   // withdraw all token fee
213   function feeWithdrawTokenAll() onlyAdmin() public {
214     if (totalTokenFee == 0) revert();
215     if (!ERC20(tokenEVOT).transfer(msg.sender, totalTokenFee)) revert();
216     totalTokenFee = 0;
217   }
218   
219   // withraw all ether on the contract
220   function withrawAllEthOnContract() onlyAdmin() public {
221     msg.sender.transfer(address(this).balance);
222   }
223   
224   // withrawall token on the contract
225   function withdrawAllTokensOnContract(uint256 _balance) onlyAdmin() public {
226     if (!ERC20(tokenEVOT).transfer(msg.sender, _balance)) revert();
227   }
228 
229   // get token contract address
230   function getEvotTokenAddress() public constant returns (address) {
231     return tokenEVOT;    
232   }
233   
234   // get evabot contract
235   function getEvabotContractAddress() public constant returns (address) {
236     return evabot_contract;
237   }
238   
239   // get exchange contract
240   function getExchangeContractAddress() public constant returns (address) {
241     return exchange_contract;
242   }
243   
244   // get token balance by user address
245   function balanceOfToken(address user) public constant returns (uint256) {
246     return tokenBalance[user];
247   }
248 
249   // get ether balance by user address
250   function balanceOfETH(address user) public constant returns (uint256) {
251     return etherBalance[user];
252   }
253 
254   // get ether contract fee
255   function balanceOfContractFeeEth() public constant returns (uint256) {
256     return totalEthFee;
257   }
258 
259   // get token contract fee
260   function balanceOfContractFeeToken() public constant returns (uint256) {
261     return totalTokenFee;
262   }
263   
264   // get current ETH fee
265   function getCurrentEthFee() public constant returns (uint256) {
266       return feeETH;
267   }
268   
269   // get current token fee
270   function getCurrentTokenFee() public constant returns (uint256) {
271       return feeEVOT;
272   }
273 }