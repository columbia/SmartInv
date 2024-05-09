1 pragma solidity ^0.4.23;
2 
3 contract ERC20Interface {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender) public view returns (uint256);
9 
10   function transfer(address _to, uint256 _value) public returns (bool);
11 
12   function approve(address _spender, uint256 _value) public returns (bool);
13 
14   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16   event Transfer(
17     address indexed from,
18     address indexed to,
19     uint256 value
20   );
21 
22   event Approval(
23     address indexed owner,
24     address indexed spender,
25     uint256 value
26   );
27 }
28 
29 contract EggPreSale {
30     mapping(address => uint256) userEthIn_;
31     mapping(uint256 => transaction) transactions_;
32     uint256 weiRaised_;
33     uint256 usdRaised_ = 0;
34     
35     // wallet is offical wallet to receive the fund.
36     address public wallet_;
37     
38     // owner is the trading bot of egg presale.
39     address public owner_;
40     
41     // store the egg coin that will be sold
42     address public eggCoinFundWallet_;
43     
44     uint256 public maxTransactionId_ = 0;
45     
46     // 1 USD to 25 Egg.
47     uint256 public exchangeRate_ = 25;
48     
49     
50     
51     ERC20Interface eggCoin_;
52     
53     // The user who can join egg presale.
54     mapping(address => bool) whiteList_;
55     
56     // The officer who can manage whitelist.
57     mapping(address => bool) whiteListManager_;
58     
59     constructor(
60         address _wallet,
61         address _eggCoinFundWallet,
62         ERC20Interface _eggCoin
63     )
64         public
65     {
66         owner_ = msg.sender;
67         whiteListManager_[owner_] = true;
68         whiteList_[owner_] = true;
69 
70         wallet_ = _wallet;
71         eggCoinFundWallet_ = _eggCoinFundWallet;
72         eggCoin_ = _eggCoin;
73     }
74     
75     /**
76      *    __                 _       
77      *   /__\_   _____ _ __ | |_ ___ 
78      *  /_\ \ \ / / _ \ '_ \| __/ __|
79      * //__  \ V /  __/ | | | |_\__ \
80      * \__/   \_/ \___|_| |_|\__|___/                       
81      */
82     
83     event EthIn(
84         uint256 transactionId,
85         uint256 ethIn,
86         address indexed buyer
87     );
88     
89     event EggDistribute(
90         uint256 transactionId,
91         uint256 eggAmount,
92         address indexed receiver
93     );
94     
95     event addToWhiteList(
96         address indexed buyer
97     );
98     
99     event removeFromWhiteList(
100         address indexed buyer
101     );
102     
103      /**
104      *                   _ _  __ _           
105      *   /\/\   ___   __| (_)/ _(_) ___ _ __ 
106      *  /    \ / _ \ / _` | | |_| |/ _ \ '__|
107      * / /\/\ \ (_) | (_| | |  _| |  __/ |   
108      * \/    \/\___/ \__,_|_|_| |_|\___|_|                                  
109      */
110     
111     modifier onlyOwner(
112         address _address
113     )
114     {
115         require(_address == owner_, "This actions is not allowed because of permission.");
116         _;
117     }
118     
119     modifier investmentFilter(
120         uint256 _ethIn
121     )
122     {
123         require(_ethIn >= 1000000000000000000, "The minimum ETH must over 1 ETH.");
124         _;
125     }
126     
127     modifier onlyWhiteListed(
128         address _address    
129     )
130     {
131         require(whiteList_[_address] == true, "Hmm... You should be added to whitelist first.");
132         _;
133     }
134     
135     modifier onlyWhiteListManager(
136         address _address
137     )
138     {
139         require(whiteListManager_[_address] == true, "Oh!!! Are you hacker?");
140         _;
141     }
142    
143     modifier onlyNotSoldOut()
144     {
145         require(eggCoin_.allowance(eggCoinFundWallet_, this) > 0, "The eggs has been sold out.");
146         _;
147     }
148 
149     function()
150         payable
151         public
152         onlyNotSoldOut
153         onlyWhiteListed(msg.sender)
154         investmentFilter(msg.value)
155     {
156         // get how much ETH user send into contract.
157         uint256 _ethIn = msg.value;
158         
159         maxTransactionId_ = maxTransactionId_ + 1;
160         uint256 _transactionId = maxTransactionId_;
161         
162         transactions_[_transactionId].ethIn = _ethIn;
163         transactions_[_transactionId].buyer = msg.sender;
164         transactions_[_transactionId].eggDistributed = false;
165         transactions_[_transactionId].blockNumber = block.number;
166         
167         emit EthIn(
168             _transactionId,
169             _ethIn,
170             msg.sender
171         );
172     }
173     
174     function distributeEgg(
175         uint256 _transactionId,
176         uint256 _ethToUsdRate
177     )
178         public
179         onlyOwner(msg.sender)
180     {
181         // avoid double distributing
182         bool _eggDistributed = transactions_[_transactionId].eggDistributed;
183         require(_eggDistributed == false, "Egg has been distributed");
184         
185         uint256 _userEthIn = transactions_[_transactionId].ethIn;
186         
187         uint256 _exchageRate = exchangeRate_;
188         
189         
190         uint256 _fee = calculateFee(_ethToUsdRate);
191         _userEthIn = _userEthIn - _fee;
192         
193         address _buyer = transactions_[_transactionId].buyer;
194         
195         uint256 _eggInContract = eggCoin_.allowance(eggCoinFundWallet_, this);
196         
197         uint256 _eggToDistribute = ((_ethToUsdRate * _userEthIn) * _exchageRate) / 1000;
198         
199         if(_eggInContract < _eggToDistribute) {
200             
201             uint256 _refundEgg = _eggToDistribute - _eggInContract;
202             // origin statement: refund = refundEgg * 1000 / _exchageRate / _ethToUsdRate;
203             // the parameter: _ethToUsdRate = 25
204             uint256 _refund = ((_refundEgg * 40) / _ethToUsdRate);
205             _userEthIn = _userEthIn - _refund;
206             
207             transactions_[_transactionId].ethIn = _userEthIn;
208             _buyer.transfer(_refund);
209             
210             _eggToDistribute = _eggInContract;
211         }
212         
213         // origin statement: _ethToUsdRate * (_userEthIn + _fee) / 1000 / 1000000000000000000;
214         
215         uint256 _usdSendIn = (_ethToUsdRate * (_userEthIn + _fee)) / 1000000000000000000000;
216         usdRaised_ = _usdSendIn + usdRaised_;
217         weiRaised_ = weiRaised_ + _userEthIn;
218         
219         // egg to buyer
220         eggCoin_.transferFrom(eggCoinFundWallet_, _buyer, _eggToDistribute);
221         
222         transactions_[_transactionId].eggReceived = _eggToDistribute;
223         transactions_[_transactionId].exchangeRate = _ethToUsdRate;
224         
225         // send pre sale funding to official wallet
226         wallet_.transfer(_userEthIn);
227         
228         // egg distribution fee to owner.
229         owner_.transfer(_fee);
230         
231         transactions_[_transactionId].eggDistributed = true;
232         
233         emit EggDistribute(
234             _transactionId,
235             _eggToDistribute,
236             _buyer
237         );
238     }
239     
240     function calculateFee(
241         uint256 _ethToUsdRate
242     )
243         pure
244         internal
245         returns(uint256)
246     {
247         // confiscating 0.03 USD from user as fee.
248         uint256 _fee = 30000000000000000000 / (_ethToUsdRate);
249         return _fee;
250     }
251     
252     function getTransaction(
253         uint256 transactionId    
254     )
255         view
256         public
257         returns(
258             uint256,
259             address,
260             bool,
261             uint256,
262             uint256
263         )
264     {
265         uint256 _transactionId = transactionId;
266         return (
267             transactions_[_transactionId].ethIn,
268             transactions_[_transactionId].buyer,
269             transactions_[_transactionId].eggDistributed,
270             transactions_[_transactionId].blockNumber,
271             transactions_[_transactionId].exchangeRate
272         );
273     }
274     
275     function getWeiRaised()
276         view
277         public
278         returns
279         (uint256)
280     {
281         return weiRaised_;
282     }
283     
284     function getUsdRaised()
285         view
286         public
287         returns
288         (uint256)
289     {
290         return usdRaised_;
291     }
292    
293     /**
294      *    ___                                            _       
295      *   /___\__      ___ __   ___ _ __       ___  _ __ | |_   _ 
296      *  //  //\ \ /\ / / '_ \ / _ \ '__|____ / _ \| '_ \| | | | |
297      * / \_//  \ V  V /| | | |  __/ | |_____| (_) | | | | | |_| |
298      * \___/    \_/\_/ |_| |_|\___|_|        \___/|_| |_|_|\__, |
299      *                                                     |___/ 
300      * */
301      
302     function addWhiteListManager(
303         address _address
304     ) 
305         onlyOwner(msg.sender)
306         public
307     {
308         whiteListManager_[_address] = true;
309     }
310     
311     function removeWhiteListManager(
312         address _address
313     )
314         onlyOwner(msg.sender)
315         public
316     {
317         whiteListManager_[_address] = false;
318     }
319     
320     /**
321      *  __    __ _     _ _         __ _     _                                                       _       
322      * / / /\ \ \ |__ (_) |_ ___  / /(_)___| |_  /\/\   __ _ _ __   __ _  ___ _ __       ___  _ __ | |_   _ 
323      * \ \/  \/ / '_ \| | __/ _ \/ / | / __| __|/    \ / _` | '_ \ / _` |/ _ \ '__|____ / _ \| '_ \| | | | |
324      *  \  /\  /| | | | | ||  __/ /__| \__ \ |_/ /\/\ \ (_| | | | | (_| |  __/ | |_____| (_) | | | | | |_| |
325      *   \/  \/ |_| |_|_|\__\___\____/_|___/\__\/    \/\__,_|_| |_|\__, |\___|_|        \___/|_| |_|_|\__, |
326      *                                                             |___/                              |___/ 
327      * */
328     
329     function addBuyerToWhiteList(
330         address _address
331     )
332         onlyWhiteListManager(msg.sender)
333         public
334     {
335         whiteList_[_address] = true;
336         emit addToWhiteList(_address);
337     }
338     
339     function removeBuyerFromWhiteList(
340         address _address
341     )
342         onlyWhiteListManager(msg.sender)
343         public
344     {
345         whiteList_[_address] = false;
346         emit removeFromWhiteList(_address);
347     }
348      
349     /**
350      *  __ _                   _                  
351      * / _\ |_ _ __ _   _  ___| |_ _   _ _ __ ___ 
352      * \ \| __| '__| | | |/ __| __| | | | '__/ _ \
353      * _\ \ |_| |  | |_| | (__| |_| |_| | | |  __/
354      * \__/\__|_|   \__,_|\___|\__|\__,_|_|  \___|
355      */
356      
357     struct transaction
358     {
359         uint256 ethIn;
360         uint256 eggReceived;
361         address buyer;
362         bool eggDistributed;
363         uint256 blockNumber;
364         uint256 exchangeRate;
365     }
366 }