1 /*___________________________________________________________________
2   _      _                                        ______           
3   |  |  /          /                                /              
4 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
5   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
6 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
7 
8     
9     
10     ██╗   ██╗███╗   ██╗██╗    ████████╗ ██████╗ ██████╗ ██╗ █████╗ 
11     ██║   ██║████╗  ██║██║    ╚══██╔══╝██╔═══██╗██╔══██╗██║██╔══██╗
12     ██║   ██║██╔██╗ ██║██║       ██║   ██║   ██║██████╔╝██║███████║
13     ██║   ██║██║╚██╗██║██║       ██║   ██║   ██║██╔═══╝ ██║██╔══██║
14     ╚██████╔╝██║ ╚████║██║       ██║   ╚██████╔╝██║     ██║██║  ██║
15      ╚═════╝ ╚═╝  ╚═══╝╚═╝       ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝
16                                                                    
17                                                                    
18 
19 === 'UniTopia' Token contract with following features ===
20     => ERC20 Compliance
21     => Higher degree of control by owner - safeguard functionality
22     => SafeMath implementation 
23     => Burnable and no-minting 
24     => multi token tranfer
25     => approve and call fallback
26 
27 
28 ======================= Quick Stats ===================
29     => Name        : UniTopia
30     => Symbol      : uTOPIA
31     => Total supply: 1,000,000 (1 Million)
32     => Decimals    : 18
33 
34 
35 ============= Independant Audit of the code ============
36     => Multiple Freelancers Auditors
37     => Community Audit by Bug Bounty program
38 
39 
40 -------------------------------------------------------------------
41  Copyright (c) 2020 onwards UniTopia Network. ( https://unitopia.network )
42  Contract designed with ❤ by EtherAuthority ( https://EtherAuthority.io )
43 -------------------------------------------------------------------
44 */
45 
46 
47 pragma solidity 0.5.16;
48 
49 
50 
51 //*******************************************************************//
52 //------------------------ SafeMath Library -------------------------//
53 //*******************************************************************//
54 
55 library SafeMath {
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     require(c / a == b);
62     return c;
63   }
64 
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a / b;
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78     return c;
79   }
80 
81   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
82     uint256 c = add(a,m);
83     uint256 d = sub(c,1);
84     return mul(div(d,m),m);
85   }
86 }
87 
88 
89 
90 //*******************************************************************//
91 //--------------------- ApproveAndCallFallBack ----------------------//
92 //*******************************************************************//
93 interface ApproveAndCallFallBack {
94     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
95 }
96 
97 
98 
99 //*******************************************************************//
100 //------------------ Contract to Manage Ownership -------------------//
101 //*******************************************************************//
102 contract owned {
103     address  payable public owner;
104     address payable internal newOwner;
105 
106     event OwnershipTransferred(address indexed _from, address indexed _to);
107 
108     constructor() public {
109         owner = msg.sender;
110         emit OwnershipTransferred(address(0), owner);
111     }
112 
113     modifier onlyOwner {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     function transferOwnership(address payable _newOwner) public onlyOwner {
119         newOwner = _newOwner;
120     }
121 
122     //this flow is to prevent transferring ownership to wrong wallet by mistake
123     function acceptOwnership() public {
124         require(msg.sender == newOwner);
125         emit OwnershipTransferred(owner, newOwner);
126         owner = newOwner;
127         newOwner = address(0);
128     }
129 }
130 
131 
132 
133 //****************************************************************************//
134 //---------------------        MAIN CODE STARTS HERE     ---------------------//
135 //****************************************************************************//
136 contract UniTopia is owned {
137 
138 
139 
140   /*===============================
141   =         DATA STORAGE          =
142   ===============================*/    
143 
144   using SafeMath for uint256;
145   bool public safeGuard=false;
146 
147   string public constant name  = "UniTopia";
148   string public constant symbol = "uTOPIA";
149   uint8 public constant decimals = 18;
150   
151   uint256 public _totalSupply;
152   uint256 public tokenPrice;
153   uint256 public soldTokens;
154   uint256 public preMintedToken;
155   
156   mapping(address=>uint256) public Pool;
157   mapping (address => uint256) private balances;
158   mapping (address => mapping (address => uint256)) private allowed;
159   
160   event Transfer(address indexed from, address indexed to, uint256 value);
161   event TransferPoolamount(address _from, address _to, uint256 _ether);
162   event Approval(address _from, address _spender, uint256 _tokenAmt);
163   
164   
165   
166   
167   /**
168    * Contract creator should provide total supply (without decimals) and token price, while deploying the smart contract. 
169    */
170   constructor(uint256 _supply,uint256 _price,uint256 _premint) public {
171      _totalSupply= _supply * (10 ** 18);
172      tokenPrice=_price;
173      soldTokens=_premint* (10 ** 18);
174     balances[msg.sender] = _premint* (10 ** 18);
175     emit Transfer(address(0), msg.sender, _premint* (10 ** 18));
176   }
177   
178   
179   /**
180    * Users get tokens immediately according to ether contributed.
181    */
182   function buyToken() payable public returns(bool)
183   {
184       require(msg.value!=0,"Invalid Amount");
185       
186       uint256 one=10**18/tokenPrice;
187       
188       uint256 tknAmount=one*msg.value;
189       
190       require(soldTokens.add(tknAmount)<=_totalSupply,"Token Not Available");
191       
192       balances[msg.sender]+=tknAmount;
193       //_totalSupply-=tknAmount;
194       Pool[owner]+=msg.value;
195       soldTokens+=tknAmount;
196       
197       emit Transfer(address(this),msg.sender,tknAmount);
198   }
199   
200   
201   /**
202    * owner can withdraw the fund anytime.
203    */
204   function withDraw() public onlyOwner{
205       
206       require(Pool[owner]!=0,"No Ether Available");
207       owner.transfer(Pool[owner]);
208       
209       emit TransferPoolamount(address(this),owner,Pool[owner]);
210       Pool[owner]=0;
211   }
212   
213   
214   /**
215    *Owner can chaneg teh token price anytime.
216    */
217   
218   function changeTokenPrice(uint256 _price) public onlyOwner{
219       require(_price!=0);
220       tokenPrice=_price;
221   }
222   
223 
224   /**
225    * when safeGuard is true, then only token transfer will start. 
226    * once token transfer will be started, then it will not even reverted by owner.
227    */
228   function transfer(address to, uint256 value) public returns (bool) {
229     require(safeGuard==true,'Transfer Is Not Available');
230     require(value <= balances[msg.sender]);
231     require(to != address(0));
232 
233     balances[msg.sender] = balances[msg.sender].sub(value);
234     balances[to] = balances[to].add(value);
235 
236     emit Transfer(msg.sender, to, value);
237     return true;
238   }
239   
240   
241   /**
242    * when safeGuard is true, then only token transfer will start. 
243    * once token transfer will be started, then it will not even reverted by owner.
244    */
245   function transferFrom(address from, address to, uint256 value) public returns (bool) {
246     require(safeGuard==true,'Transfer Is Not Available');
247     require(value <= balances[from]);
248     require(value <= allowed[from][msg.sender]);
249     require(to != address(0));
250     
251     balances[from] = balances[from].sub(value);
252     balances[to] = balances[to].add(value);
253     
254     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
255     
256     emit Transfer(from, to, value);
257     return true;
258   }
259 
260 
261   /**
262    * user can transfer tokens in bulk. 
263    * maximum 150 at a time.
264    */
265   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
266     uint256 arrayLength = receivers.length;
267     require(arrayLength <= 150, 'Too many addresses');
268     for (uint256 i = 0; i < arrayLength; i++) {
269       transfer(receivers[i], amounts[i]);
270     }
271   }
272   
273   
274   /**
275    * approve token spending to any third party.
276    * approved user or contract can spend toknes.
277    */
278   function approve(address spender, uint256 value) public returns (bool) {
279     require(spender != address(0));
280     allowed[msg.sender][spender] = value;
281     emit Approval(msg.sender, spender, value);
282     return true;
283   }
284 
285   
286   /**
287    * This function allows user to approve and at the same time call any other smart contract function and do any code execution.
288    */
289   function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
290     allowed[msg.sender][spender] = tokens;
291     emit Approval(msg.sender, spender, tokens);
292     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
293     return true;
294     }
295 
296   
297   /**
298    * Increase allowance.
299    */
300   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
301     require(spender != address(0));
302     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
303     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
304     return true;
305   }
306   
307   
308   
309   /**
310    * decrease allowance.
311    */
312   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
313     require(spender != address(0));
314     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
315     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
316     return true;
317   }
318 
319   
320   /**
321    * anyone can burn the tokens. and it will decrease the total supply of the tokens.
322    */
323   function burn(uint256 amount) external {
324     require(amount != 0);
325     require(amount <= balances[msg.sender]);
326     _totalSupply = _totalSupply.sub(amount);
327     balances[msg.sender] = balances[msg.sender].sub(amount);
328     emit Transfer(msg.sender, address(0), amount);
329   }
330   
331   
332   
333   /**
334    * only owner can change thi safeGuard status to true. 
335    * It will start the token transfer. and once it is started, it can not be stoped.
336    */
337   function changeSafeGuard() public onlyOwner{
338       safeGuard=true;
339   }
340   
341   
342   
343   /*===============================
344     =       VIEW FUNCTIONS        =
345     ===============================*/
346   function tokenSold() public view returns(uint256)
347   {
348       return soldTokens;
349   }
350   
351   function totalEther() public view returns(uint256)
352   {
353       return Pool[owner];
354   }
355   
356   function availableToken() public view returns(uint256)
357   {
358       return _totalSupply.sub(soldTokens);
359   }
360 
361   function totalSupply() public view returns (uint256) {
362     return _totalSupply;
363   }
364 
365   function balanceOf(address player) public view returns (uint256) {
366     return balances[player];
367   }
368   
369   function allowance(address player, address spender) public view returns (uint256) {
370     return allowed[player][spender];
371   }
372 
373 }