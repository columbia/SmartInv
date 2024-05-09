1 pragma solidity ^ 0.4.15;
2 
3 /**
4 *library name : SafeMath
5 *purpose : be the library for the smart contract for the swap between the godz and ether
6 *goal : to achieve the secure basic math operations
7 */
8 library SafeMath {
9 
10   /*function name : mul*/
11   /*purpose : be the funcion for safe multiplicate*/
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     /*assert(a == 0 || c / a == b);*/
15     return c;
16   }
17 
18   /*function name : div*/
19   /*purpose : be the funcion for safe division*/
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   /*function name : sub*/
26   /*purpose : be the funcion for safe substract*/
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     /*assert(b <= a);*/
29     return a - b;
30   }
31 
32   /*function name : add*/
33   /*purpose : be the funcion for safe sum*/
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     /*assert(c >= a);*/
37     return c;
38   }
39 }
40 
41 /**
42 *contract name : ReentryProtected
43 */
44 contract ReentryProtected{
45     /*The reentry protection state mutex.*/
46     bool __reMutex;
47 
48     /**
49     *This modifier can be used on functions with external calls to
50     *prevent reentry attacks.
51     *Constraints:
52     *Protected functions must have only one point of exit.
53     *Protected functions cannot use the `return` keyword
54     *Protected functions return values must be through return parameters.
55     */
56     modifier preventReentry() {
57         require(!__reMutex);
58         __reMutex = true;
59         _;
60         delete __reMutex;
61         return;
62     }
63 
64     /**
65     *This modifier can be applied to public access state mutation functions
66     *to protect against reentry if a `preventReentry` function has already
67     *set the mutex. This prevents the contract from being reenter under a
68     *different memory context which can break state variable integrity.
69     */
70     modifier noReentry() {
71         require(!__reMutex);
72         _;
73     }
74 }
75 
76 /**
77 *contract name : GodzSwapGodzEtherCompliance
78 *purpose : be the smart contract for compliance of the greater than usd5000
79 */
80 contract GodzSwapGodzEtherCompliance{
81     //address of the owner of the contract
82     address public owner;
83     
84     /*structure for store the sale*/
85     struct GodzBuyAccounts
86     {
87         uint256 amount;/*amount sent*/
88         address account;/*account that sent*/
89         uint sendGodz;/*if send the godz back*/
90     }
91 
92     /*mapping of the acounts that send more than usd5000*/
93     mapping(uint=>GodzBuyAccounts) public accountsHolding;
94     
95     /*index of the account information*/
96     uint public indexAccount = 0;
97 
98     /*account information*/
99     address public swapContract;/*address of the swap contract*/
100 
101 
102     /*function name : GodzSwapGodzEtherCompliance*/
103     /*purpose : be the constructor and the setter of the owner*/
104     /*goal : to set the owner of the contract*/    
105     function GodzSwapGodzEtherCompliance()
106     {
107         /*sets the owner of the contract than compliance with the greater than usd5000 maximiun*/
108         owner = msg.sender;
109     }
110 
111     /*function name : setHolderInformation*/
112     /*purpose : be the setter of the swap contract and wallet holder*/
113     /*goal : to set de swap contract address and the wallet holder address*/    
114     function setHolderInformation(address _swapContract)
115     {    
116         /*if the owner is setting the information of the holder and the swap*/
117         if (msg.sender==owner)
118         {
119             /*address of the swap contract*/
120             swapContract = _swapContract;
121         }
122     }
123 
124     /*function name : SaveAccountBuyingGodz*/
125     /*purpose : be the safe function that map the account that send it*/
126     /*goal : to store the account information*/
127     function SaveAccountBuyingGodz(address account, uint256 amount) public returns (bool success) 
128     {
129         /*if the sender is the swapContract*/
130         if (msg.sender==swapContract)
131         {
132             /*increment the index*/
133             indexAccount += 1;
134             /*store the account informacion*/
135             accountsHolding[indexAccount].account = account;
136             accountsHolding[indexAccount].amount = amount;
137             accountsHolding[indexAccount].sendGodz = 0;
138             /*transfer the ether to the wallet holder*/
139             /*account save was completed*/
140             return true;
141         }
142         else
143         {
144             return false;
145         }
146     }
147 
148     /*function name : setSendGodz*/
149     /*purpose : be the flag update for the compliance account*/
150     /*goal : to get the flag on the account*/
151     function setSendGodz(uint index) public 
152     {
153         if (owner == msg.sender)
154         {
155             accountsHolding[index].sendGodz = 1;
156         }
157     }
158 
159     /*function name : getAccountInformation*/
160     /*purpose : be the getter of the information of the account*/
161     /*goal : to get the amount and the acount of a compliance account*/
162     function getAccountInformation(uint index) public returns (address account, uint256 amount, uint sendGodz)
163     {
164         /*return the account of a compliance*/
165         return (accountsHolding[index].account, accountsHolding[index].amount, accountsHolding[index].sendGodz);
166     }
167 }
168 
169 /**
170 *contract name : GodzSwapGodzEther
171 *purpose : be the smart contract for the swap between the godz and ether
172 *goal : to achieve the swap transfers
173 */
174 contract GodzSwapGodzEther  is ReentryProtected{
175     address public seller;/*address of the owner of the contract creation*/
176     address public tokenContract;/*address of the erc20 token smart contract for the swap*/
177     address public complianceContract;/*compliance contract*/
178     address public complianceWallet;/*compliance wallet address*/
179     uint256 public sellPrice;/*value price of the swap*/
180     uint256 public sellQuantity;/*quantity value of the swap*/
181 
182     /*function name : GodzSwapGodzEther*/
183     /*purpose : be the constructor of the swap smart contract*/
184     /*goal : register the basic information of the swap smart contract*/
185     function GodzSwapGodzEther(
186     address token,
187     address complianceC,
188     address complianceW
189     ){
190         tokenContract = token;
191         /*owner of the quantity of supply of the erc20 token*/
192         seller = msg.sender;
193         /*swap price of the token supply*/
194         sellPrice = 0.00625 * 1 ether;
195         /*total quantity to swap*/
196         sellQuantity = SafeMath.mul(210000000, 1 ether);
197         /*compliance contract store accounts*/
198         complianceContract = complianceC;
199         /*compliance wallet holder*/
200         complianceWallet = complianceW;
201     }
202 
203     /*function name : () payable*/
204     /*purpose : be the swap executor*/
205     /*goal : to transfer the godz to the investor and the ether to the owner of the godz*/
206     function() payable preventReentry
207     {
208         /*address of the buyer*/
209         address buyer = msg.sender;
210 
211         /*value paid and receive on the swap call*/
212         uint256 valuePaid = msg.value;
213 
214         /*set the quantity of godz on behalf of the ether that is send to this function*/
215   		  uint256 buyQuantity = SafeMath.mul((SafeMath.div(valuePaid, sellPrice)), 1 ether);
216 
217         /*gets the balance of the owner of the godz*/
218         uint256 balanceSeller = Token(tokenContract).balanceOf(seller);
219 
220         /*get the allowance of the owner of the godz*/
221   		uint256 balanceAllowed = Token(tokenContract).allowance(seller,this);
222 
223         if (seller!=buyer) /*if the seller of godz on swap is different than the investor buying*/
224         {
225             /*if the balance and the allowance match a valid quantity swap*/
226       		if ((balanceAllowed >= buyQuantity) && (balanceSeller >= buyQuantity))
227             {
228                 /*if the msg.value(ether sent) is greater than compliance, store it and sent to the wallet holder*/
229                 if (valuePaid>(20 * 1 ether))
230                 {
231                     /*transfer the value(ether) to the compliance holder wallet*/
232                     complianceWallet.transfer(valuePaid);
233                     /*save the account information*/
234                     require(GodzSwapGodzEtherCompliance(complianceContract).SaveAccountBuyingGodz(buyer, valuePaid));
235                 }
236                 else
237                 {
238                     /*transfer the ether inside to the seller of the godz*/
239                     seller.transfer(valuePaid);
240                     /*call the transferfrom function of the erc20 token smart contract*/
241                     require(Token(tokenContract).transferFrom(seller, buyer, buyQuantity));
242                 }
243             }
244             else/*if not a valid match between allowance and balance of the owner of godz, return the ether*/
245             {
246                 /*send back the ether received*/
247                 buyer.transfer(valuePaid);
248             }
249         }
250     }
251 
252     /*function name : safeWithdrawal*/
253     /*purpose : be the safe withrow function in case of the contract keep ether inside*/
254     /*goal : to transfer the ether to the owner of the swap contract*/
255     function safeWithdrawal()
256     {
257         /*requires that the contract call is the owner of the swap contract*/
258         /*require(seller == msg.sender);*/
259         /*if the seller of the godz is the call contract address*/
260         if (seller == msg.sender)
261         {
262             /*transfer the ether inside to the seller of the godz*/
263             seller.transfer(this.balance);
264         }
265     }
266 }
267 
268 /**
269 *contract name : tokenRecipient
270 */
271 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
272 
273 /**
274 *contract name : Token
275 */
276 contract Token {
277     /*using the secure math library for basic math operations*/
278     using SafeMath for uint256;
279 
280     /* Public variables of the token */
281     string public standard = 'DSCS.GODZ.TOKEN';
282     string public name;
283     string public symbol;
284     uint8 public decimals;
285     uint256 public totalSupply;
286 
287     /* This creates an array with all balances */
288     mapping (address => uint256) public balanceOf;
289     mapping (address => mapping (address => uint256)) public allowance;
290 
291     /* This generates a public event on the blockchain that will notify clients */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /* Initializes contract with initial supply tokens to the creator of the contract */
295     function Token(
296         uint256 initialSupply,
297         string tokenName,
298         uint8 decimalUnits,
299         string tokenSymbol
300         ) {
301         balanceOf[msg.sender] = initialSupply;                  /* Give the creator all initial tokens*/
302         totalSupply = initialSupply;                            /* Update total supply*/
303         name = tokenName;                                       /* Set the name for display purposes*/
304         symbol = tokenSymbol;                                   /* Set the symbol for display purposes*/
305         decimals = decimalUnits;                                /* Amount of decimals for display purposes*/
306     }
307 
308     /* Send coins */
309     function transfer(address _to, uint256 _value) {
310         if (_to == 0x0) revert();                               /* Prevent transfer to 0x0 address. Use burn() instead*/
311         if (balanceOf[msg.sender] < _value) revert();           /* Check if the sender has enough*/
312         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); /* Check for overflows*/
313         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                        /* Subtract from the sender*/
314         balanceOf[_to] = balanceOf[_to].add(_value);                               /* Add the same to the recipient*/
315         Transfer(msg.sender, _to, _value);                      /* Notify anyone listening that this transfer took place*/
316     }
317 
318     /* Allow another contract to spend some tokens in your behalf */
319     function approve(address _spender, uint256 _value)
320         returns (bool success) {
321         allowance[msg.sender][_spender] = _value;
322         return true;
323     }
324 
325     /* Approve and then communicate the approved contract in a single tx */
326     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
327         returns (bool success) {
328         tokenRecipient spender = tokenRecipient(_spender);
329         if (approve(_spender, _value)) {
330             spender.receiveApproval(msg.sender, _value, this, _extraData);
331             return true;
332         }
333     }
334 
335     /* A contract attempts to get the coins but transfer from the origin*/
336     function transferFromOrigin(address _to, uint256 _value)  returns (bool success) {
337         address origin = tx.origin;
338         if (origin == 0x0) revert();
339         if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/
340         if (balanceOf[origin] < _value) revert();                /* Check if the sender has enough*/
341         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/
342         balanceOf[origin] = balanceOf[origin].sub(_value);       /* Subtract from the sender*/
343         balanceOf[_to] = balanceOf[_to].add(_value);             /* Add the same to the recipient*/
344         return true;
345     }
346 
347     /* A contract attempts to get the coins */
348     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
349         if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/
350         if (balanceOf[_from] < _value) revert();                 /* Check if the sender has enough*/
351         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/
352         if (_value > allowance[_from][msg.sender]) revert();     /* Check allowance*/
353         balanceOf[_from] = balanceOf[_from].sub(_value);                              /* Subtract from the sender*/
354         balanceOf[_to] = balanceOf[_to].add(_value);                                /* Add the same to the recipient*/
355         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
356         Transfer(_from, _to, _value);
357         return true;
358     }
359 
360 }