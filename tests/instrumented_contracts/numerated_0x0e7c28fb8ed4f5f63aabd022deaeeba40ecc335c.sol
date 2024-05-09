1 pragma solidity ^0.4.26;
2 
3 contract EtherCenter {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     modifier onlyBagholders() {
8         require(myTokens() > 0);
9         _;
10     }
11 
12     modifier onlyAdministrator(){
13         address _customerAddress = msg.sender;
14         require(administrators[keccak256(abi.encodePacked(_customerAddress))]);
15         _;
16     }
17 
18     modifier onlyValidAddress(address _to){
19         require(_to != address(0x0000000000000000000000000000000000000000));
20         _;
21     }
22 
23     /*==============================
24     =            EVENTS            =
25     ==============================*/
26     event onTokenPurchase(
27         address indexed customerAddress,
28         uint256 incomingEthereum,
29         uint256 tokensMinted
30     );
31 
32     event onTokenSell(
33         address indexed customerAddress,
34         uint256 tokensBurned,
35         uint256 ethereumEarned
36     );
37 
38     // ERC20
39     event Transfer(
40         address indexed from,
41         address indexed to,
42         uint256 tokens
43     );
44 
45     /*=====================================
46     =            CONFIGURABLES            =
47     =====================================*/
48     string public name = "EtherCenter";
49     string public symbol = "EC";
50     uint8 constant public decimals = 18;
51     uint8 constant internal realRate_ = 98;
52     uint8 constant internal valueChange_ = 5 ;
53     uint256 constant internal tokenPriceInitial_ = 0.001 ether;
54     uint256 constant internal defaultValue = 10**18;
55     address constant internal admin_ = address(0xaD5874D6A14CC9963FC303F745f454Ef3A6E9BEb);
56 
57    /*================================
58     =            DATASETS            =
59     ================================*/
60     // amount of shares for each address (scaled number)
61     mapping(address => uint256) internal tokenBalanceLedger_;
62     mapping(address => uint256) internal payoutsTo_;
63     uint256 internal tokenSupply_ = 0;
64     uint256 internal ethereumBuy_ = 0;
65 
66     mapping(bytes32 => bool) public administrators; 
67 
68     /*=======================================
69     =            PUBLIC FUNCTIONS            =
70     =======================================*/
71     /*
72     * -- APPLICATION ENTRY POINTS --
73     */
74     constructor()
75         public
76     {
77         // add administrators here
78         administrators[keccak256(abi.encode(admin_))] = true;
79     }
80 
81     function buy()
82         public
83         payable
84     {
85         ethereumBuy_ = msg.value;
86         purchaseTokens(msg.value);
87         ethereumBuy_ = 0;
88     }
89 
90     function exit()
91         public
92     {
93         // get token count for caller & sell them all
94         address _customerAddress = msg.sender;
95         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
96         if(_tokens > 0) sell(_tokens);
97     }
98 
99     function sell(uint256 _amountOfTokens)
100         onlyBagholders()
101         public
102     {
103         // setup data
104         address _customerAddress = msg.sender;
105         // russian hackers BTFO
106         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
107         uint256 _tokens = _amountOfTokens;
108         uint256 _ethereum = tokensToEthereum_(_tokens);
109         uint256 _realEthereum = SafeMath.div(SafeMath.mul(_ethereum, realRate_), 100);
110         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _realEthereum);
111 
112         // burn the sold tokens
113         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
114         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
115 
116         _customerAddress.transfer(_realEthereum);
117         admin_.transfer(_taxedEthereum);
118 
119         // fire event
120         emit onTokenSell(_customerAddress, _tokens, _realEthereum);
121     }
122 
123     function transfer(address _toAddress, uint256 _amountOfTokens)
124         onlyValidAddress(_toAddress)
125         onlyBagholders()
126         public
127         returns(bool)
128     {
129         // setup
130         address _customerAddress = msg.sender;
131         uint256 _taxedTokens = SafeMath.div(SafeMath.mul(_amountOfTokens, valueChange_), 100);
132         require(SafeMath.add(_amountOfTokens, _taxedTokens) <= tokenBalanceLedger_[_customerAddress]);
133         uint256 _realTokens = SafeMath.add(_amountOfTokens, _taxedTokens);
134 
135         // exchange tokens
136         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _realTokens);
137         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
138         tokenSupply_ -= _taxedTokens;
139 
140         // fire event
141         emit Transfer(_customerAddress, _toAddress, _realTokens);
142         
143         // ERC20
144         return true;
145        
146     }
147 
148     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
149     /**
150      * In case one of us dies, we need to replace ourselves.
151      */
152     function setAdministrator(bytes32 _identifier, bool _status)
153         onlyAdministrator()
154         public
155     {
156         administrators[_identifier] = _status;
157     }
158 
159     /**
160      * If we want to rebrand, we can.
161      */
162     function setName(string memory _name)
163         onlyAdministrator()
164         public
165     {
166         name = _name;
167     }
168 
169     /**
170      * If we want to rebrand, we can.
171      */
172     function setSymbol(string memory _symbol)
173         onlyAdministrator()
174         public
175     {
176         symbol = _symbol;
177     }
178 
179     /*----------  HELPERS AND CALCULATORS  ----------*/
180     /**
181      * Method to view the current Ethereum stored in the contract
182      * Example: totalEthereumBalance()
183      */
184     function totalEthereumBalance()
185         public
186         view
187         returns(uint)
188     {
189         return address(this).balance;
190     }
191 
192     /**
193      * Retrieve the total token supply.
194      */
195     function totalSupply()
196         public
197         view
198         returns(uint256)
199     {
200         return tokenSupply_;
201     }
202 
203     /**
204      * Retrieve the tokens owned by the caller.
205      */
206     function myTokens()
207         public
208         view
209         returns(uint256)
210     {
211         address _customerAddress = msg.sender;
212         return balanceOf(_customerAddress);
213     }
214 
215     /**
216      * Retrieve the token balance of any single address.
217      */
218     function balanceOf(address _customerAddress)
219         view
220         public
221         returns(uint256)
222     {
223         return tokenBalanceLedger_[_customerAddress];
224     }
225 
226     /**
227      * Return the buy price of 1 individual token.
228      */
229     function sellPrice()
230         public
231         view
232         returns(uint256)
233     {
234         uint256 _ethereum = guaranteePrice_();
235         uint256 _sellEthereum = SafeMath.div(SafeMath.mul(
236                                     SafeMath.div(SafeMath.mul(_ethereum,
237                                         SafeMath.sub(100, valueChange_)), 100), realRate_), 100);
238         return _sellEthereum;
239     }
240 
241     /**
242      * Return the sell price of 1 individual token.
243      */
244     function buyPrice()
245         public
246         view
247         returns(uint256)
248     {
249         uint256 _ethereum = guaranteePrice_();
250         uint256 _buyEthereum = SafeMath.div(SafeMath.mul(_ethereum, SafeMath.add(100, valueChange_)), realRate_);
251         return _buyEthereum;
252     }
253 
254     /**
255      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
256      */
257     function calculateTokensReceived(uint256 _ethereumToSpend)
258         public
259         view
260         returns(uint256)
261     {
262         uint256 _amountOfTokens = ethereumToTokens_(_ethereumToSpend);
263         uint256 _realTokens = SafeMath.div(SafeMath.mul(_amountOfTokens, realRate_), 100);
264         return _realTokens;
265     }
266     
267     /**
268      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
269      */
270     function calculateEthereumReceived(uint256 _tokensToSell)
271         public
272         view
273         returns(uint256)
274     {
275         require(_tokensToSell <= tokenSupply_);
276         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
277         uint256 _realEthereum = SafeMath.div(SafeMath.mul(_ethereum, realRate_), 100);
278         return _realEthereum;
279     }
280 
281  /*==========================================
282     =            INTERNAL FUNCTIONS            =
283     ==========================================*/
284     function purchaseTokens(uint256 _incomingEthereum)
285         internal
286     {
287         // data setup
288         address _customerAddress = msg.sender;
289         // Amount of tokens can buy
290         uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum);
291         uint256 _realTokens = SafeMath.div(SafeMath.mul(_amountOfTokens, realRate_), 100);
292         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _realTokens);
293         // Require for the number Token is buying
294         require(_realTokens > 0 && _realTokens <= 3000*defaultValue && (SafeMath.add(_realTokens, tokenSupply_) > tokenSupply_));
295 
296         // update circulating supply & the ledger address for the customer
297         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _realTokens);
298         tokenBalanceLedger_[admin_] = SafeMath.add(tokenBalanceLedger_[admin_], _taxedTokens);
299         // update system
300         tokenSupply_ += _amountOfTokens;
301     
302         payoutsTo_[_customerAddress] += SafeMath.div(_realTokens, defaultValue);
303 
304         emit onTokenPurchase(_customerAddress, _incomingEthereum, _realTokens);
305     }
306 
307     /**
308      * Calculate Token price based on an amount of incoming ethereum
309      */
310     function ethereumToTokens_(uint256 _ethereum)
311         internal
312         view
313         returns(uint256)
314     {
315         // Check guaranteePrice
316         uint256 _guarantee = guaranteePrice_();
317         uint256 _tokensReceived = 
318         (
319             SafeMath.div(_ethereum*defaultValue, SafeMath.div(SafeMath.mul(_guarantee, SafeMath.add(100, valueChange_)), 100))
320         );
321         return _tokensReceived;
322     }
323     
324     /**
325      * Calculate token sell value.
326      */
327     function tokensToEthereum_(uint256 _tokens)
328         internal
329         view
330         returns(uint256)
331     {
332         // Check guaranteePrice
333         uint256 _guarantee = guaranteePrice_();
334         uint256 _etherReceived =
335         (
336             SafeMath.div(SafeMath.mul(_tokens, SafeMath.div(SafeMath.mul(_guarantee, SafeMath.sub(100, valueChange_)), 100)), defaultValue)
337         );
338         return _etherReceived;
339     }
340     
341     function guaranteePrice_()
342         internal
343         view
344         returns(uint256)
345     {
346         uint256 _guarantee = 0;
347         if (tokenSupply_ == 0){
348             _guarantee = tokenPriceInitial_;
349         } else
350             _guarantee = SafeMath.div((address(this).balance - ethereumBuy_)*defaultValue, tokenSupply_);
351         return _guarantee;
352     }
353 }
354 
355 /**
356  * @title SafeMath
357  * @dev Math operations with safety checks that throw on error
358  */
359 library SafeMath {
360 
361     /**
362     * @dev Multiplies two numbers, throws on overflow.
363     */
364     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
365         if (a == 0) {
366             return 0;
367         }
368         uint256 c = a * b;
369         assert(c / a == b);
370         return c;
371     }
372 
373     /**
374     * @dev Integer division of two numbers, truncating the quotient.
375     */
376     function div(uint256 a, uint256 b) internal pure returns (uint256) {
377         assert(b > 0); // Solidity automatically throws when dividing by 0
378         uint256 c = a / b;
379         assert(a == b * c + a % b); // There is no case in which this doesn't hold
380         return c;
381     }
382 
383     /**
384     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
385     */
386     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387         assert(b <= a);
388         return a - b;
389     }
390 
391     /**
392     * @dev Adds two numbers, throws on overflow.
393     */
394     function add(uint256 a, uint256 b) internal pure returns (uint256) {
395         uint256 c = a + b;
396         assert(c >= a);
397         return c;
398     }
399 }