1 /* Orgon.Sale2 */
2 pragma solidity ^0.4.21; //v8 
3 library SafeMath {
4  
5   /**
6    * Add two uint256 values, throw in case of overflow.
7    * @param x first value to add
8    * @param y second value to add
9    * @return x + y
10    */
11   function add (uint256 x, uint256 y) internal pure returns (uint256 z) {
12     z = x + y;
13     require(z >= x);
14     return z;
15   }
16 
17   /**
18    * Subtract one uint256 value from another, throw in case of underflow.
19    * @param x value to subtract from
20    * @param y value to subtract
21    * @return x - y
22    */
23   function sub (uint256 x, uint256 y) internal pure returns (uint256 z) {
24     require (x >= y);
25     z = x - y;
26     return z;
27   }
28 
29 /**
30   * @dev Multiplies two numbers, reverts on overflow.
31   */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33    
34     if (a == 0) return 0;
35     c = a * b;
36     require(c / a == b);
37     return c;
38   }
39   
40    /**
41   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     require(b > 0); // Solidity only automatically asserts when dividing by 0
45     c = a / b;
46     return c;
47   }
48 }    
49     
50 contract OrgonToken {
51 
52   /**
53    * Get total number of tokens in circulation.
54    *
55    * @return total number of tokens in circulation
56    */
57   function totalSupply () public view returns (uint256 supply);
58 
59   /**
60    * Get number of tokens currently belonging to given owner.
61    *
62    * @param _owner address to get number of tokens currently belonging to the
63    *        owner of
64    * @return number of tokens currently belonging to the owner of given address
65    */
66   function balanceOf (address _owner) public view returns (uint256 balance);
67   
68   function theOwner () public view returns (address);
69 
70   /**
71    * Transfer given number of tokens from message sender to given recipient.
72    *
73    * @param _to address to transfer tokens to the owner of
74    * @param _value number of tokens to transfer to the owner of given address
75    * @return true if tokens were transferred successfully, false otherwise
76    */
77 
78  /**
79    * Transfer given number of tokens from message sender to given recipient.
80    *
81    * @param _to address to transfer tokens to the owner of
82    * @param _value number of tokens to transfer to the owner of given address
83    * @return true if tokens were transferred successfully, false otherwise
84    */
85   function transfer (address _to, uint256 _value)
86   public returns (bool success);
87   
88   /**
89    * Transfer given number of tokens from given owner to given recipient.
90    *
91    * @param _from address to transfer tokens from the owner of
92    * @param _to address to transfer tokens to the owner of
93    * @param _value number of tokens to transfer from given owner to given
94    *        recipient
95    * @return true if tokens were transferred successfully, false otherwise
96    */
97   function transferFrom (address _from, address _to, uint256 _value)
98   public returns (bool success);
99 
100   /**
101    * Allow given spender to transfer given number of tokens from message sender.
102    *
103    * @param _spender address to allow the owner of to transfer tokens from
104    *        message sender
105    * @param _value number of tokens to allow to transfer
106    * @return true if token transfer was successfully approved, false otherwise
107    */
108   function approve (address _spender, uint256 _value)
109   public returns (bool success);
110 
111   /**
112    * Tell how many tokens given spender is currently allowed to transfer from
113    * given owner.
114    *
115    * @param _owner address to get number of tokens allowed to be transferred
116    *        from the owner of
117    * @param _spender address to get number of tokens allowed to be transferred
118    *        by the owner of
119    * @return number of tokens given spender is currently allowed to transfer
120    *         from given owner
121    */
122   function allowance (address _owner, address _spender)
123   public view returns (uint256 remaining);
124 
125 /* Owner of the smart contract */
126 //address public owner;
127 
128   /**
129    * Logged when tokens were transferred from one owner to another.
130    *
131    * @param _from address of the owner, tokens were transferred from
132    * @param _to address of the owner, tokens were transferred to
133    * @param _value number of tokens transferred
134    */
135   event Transfer (address indexed _from, address indexed _to, uint256 _value);
136 
137   /**
138    * Logged when owner approved his tokens to be transferred by some spender.
139    *
140    * @param _owner owner who approved his tokens to be transferred
141    * @param _spender spender who were allowed to transfer the tokens belonging
142    *        to the owner
143    * @param _value number of tokens belonging to the owner, approved to be
144    *        transferred by the spender
145    */
146   event Approval (
147     address indexed _owner, address indexed _spender, uint256 _value);
148 }
149 
150 
151 contract OrgonSale2 {
152 using SafeMath for uint256;
153     /* Start OrgonMarket */
154     function OrgonSale2 (OrgonToken _orgonToken) public {
155         orgonToken = _orgonToken;
156         owner = msg.sender;
157     }
158     
159     /* Recive ETH */
160     function () public payable {
161         require (msg.data.length == 0);
162         buyTokens ();
163     }
164     
165     function buyTokens () public payable returns (bool success){
166         require (msg.value > 0);
167         
168         uint256 currentMarket;
169         currentMarket = orgonToken.balanceOf (address(this));   
170         if (currentMarket == 0) revert (); 
171         require (orgonToken.transfer (msg.sender, countTokens(msg.value)));
172         return true;
173     }  
174     
175     function countTokens (uint256 _value) public view returns (uint256 _tokens){
176        
177         uint256 toBuy;
178         if (_value < weiBound1) {
179             toBuy = _value.mul(tokensPerWei);
180             _tokens = toBuy;
181         }
182         else if (_value < weiBound2) {
183             toBuy = _value.mul(tokensPerWei);
184             _tokens = toBuy.mul(orgonBonus1);
185             _tokens = _tokens.div(100);
186         }    
187         else if (_value < weiBound3) {
188             toBuy = _value.mul(tokensPerWei);
189             _tokens = toBuy.mul(orgonBonus2);
190             _tokens = _tokens.div(100);
191         }
192         else if (_value < weiBound4) {
193             toBuy = _value.mul(tokensPerWei);
194             _tokens = toBuy.mul(orgonBonus3);
195             _tokens = _tokens.div(100);
196         }
197         else if (_value < weiBound5) {
198             toBuy = _value.mul(tokensPerWei);
199             _tokens = toBuy.mul(orgonBonus4);
200             _tokens = _tokens.div(100);
201         }
202         else if (_value < weiBound6) {
203             toBuy = _value.mul(tokensPerWei);
204             _tokens = toBuy.mul(orgonBonus5);
205             _tokens = _tokens.div(100);
206         }
207         else {
208             toBuy = _value.mul(tokensPerWei);
209             _tokens = toBuy.mul(orgonBonus6);
210             _tokens = _tokens.div(100);
211         }
212         return (_tokens);
213     }  
214     
215     function countTokensE18 (uint256 _value) public view returns (uint256 _tokens){
216         return countTokens(_value.mul(10**18))/(10**18);
217     }    
218     
219     function sendTokens (address _to, uint256 _amount) public returns (bool success){
220         
221         require (msg.sender == owner);
222         require (_to != address(this));
223         require (_amount > 0);
224         require (orgonToken.transfer (_to, _amount));
225         return true;
226         
227     }
228     
229     function sendETH (address _to, uint256 _amount) public returns (bool success){
230         
231         require (msg.sender == owner);
232         require (_to != address(this));
233         require (_amount > 0);
234         _to.transfer (_amount);
235         return true;
236         
237     }
238      
239     function setPriceAndBonus(uint256 _newTokensPerWei, uint256 _newWeiBound1, uint256 _newOrgonBonus1, uint256 _newWeiBound2, uint256 _newOrgonBonus2, uint256 _newWeiBound3, uint256 _newOrgonBonus3, uint256 _newWeiBound4, uint256 _newOrgonBonus4, uint256 _newWeiBound5, uint256 _newOrgonBonus5, uint256 _newWeiBound6, uint256 _newOrgonBonus6  ) public {
240         require (msg.sender == owner);
241         require (_newTokensPerWei > 0);
242         require (_newWeiBound1 < _newWeiBound2 && _newWeiBound2 < _newWeiBound3 &&_newWeiBound3 < _newWeiBound4 &&_newWeiBound4 < _newWeiBound5 &&_newWeiBound5 < _newWeiBound6);
243         tokensPerWei = _newTokensPerWei;
244         weiBound1 = _newWeiBound1;
245         weiBound2 = _newWeiBound2;
246         weiBound3 = _newWeiBound3;
247         weiBound4 = _newWeiBound4;
248         weiBound5 = _newWeiBound5;
249         weiBound6 = _newWeiBound6;
250         orgonBonus1 = _newOrgonBonus1;
251         orgonBonus2 = _newOrgonBonus2;
252         orgonBonus3 = _newOrgonBonus3;
253         orgonBonus4 = _newOrgonBonus4;
254         orgonBonus5 = _newOrgonBonus5;
255         orgonBonus6 = _newOrgonBonus6;
256     }
257     
258     function setPriceAndBonusETH(uint256 _tokensPerWei, uint256 _newEthBound1, uint256 _newOrgonBonus1, uint256 _newEthBound2, uint256 _newOrgonBonus2, uint256 _newEthBound3, uint256 _newOrgonBonus3, uint256 _newEthBound4, uint256 _newOrgonBonus4, uint256 _newEthBound5, uint256 _newOrgonBonus5, uint256 _newEthBound6, uint256 _newOrgonBonus6  ) public {
259         require (msg.sender == owner);
260         require (_tokensPerWei > 0);
261         require (_newEthBound1 < _newEthBound2 && _newEthBound2 < _newEthBound3 &&_newEthBound3 < _newEthBound4 &&_newEthBound4 < _newEthBound5 &&_newEthBound5 < _newEthBound6);
262         tokensPerWei = _tokensPerWei;
263         weiBound1 = _newEthBound1.mul(1000000000000000000);
264         weiBound2 = _newEthBound2.mul(1000000000000000000);
265         weiBound3 = _newEthBound3.mul(1000000000000000000);
266         weiBound4 = _newEthBound4.mul(1000000000000000000);
267         weiBound5 = _newEthBound5.mul(1000000000000000000);
268         weiBound6 = _newEthBound6.mul(1000000000000000000);
269         orgonBonus1 = _newOrgonBonus1;
270         orgonBonus2 = _newOrgonBonus2;
271         orgonBonus3 = _newOrgonBonus3;
272         orgonBonus4 = _newOrgonBonus4;
273         orgonBonus5 = _newOrgonBonus5;
274         orgonBonus6 = _newOrgonBonus6;
275     }    
276     
277     function setPriceAndBonusFinney(uint256 _newTokensPerWei, uint256 _newFinneyBound1, uint256 _newOrgonBonus1, uint256 _newFinneyBound2, uint256 _newOrgonBonus2, uint256 _newFinneyBound3, uint256 _newOrgonBonus3, uint256 _newFinneyBound4, uint256 _newOrgonBonus4, uint256 _newFinneyBound5, uint256 _newOrgonBonus5, uint256 _newFinneyBound6, uint256 _newOrgonBonus6  ) public {
278         require (msg.sender == owner);
279         require (_newTokensPerWei > 0);
280         require (_newFinneyBound1 < _newFinneyBound2 && _newFinneyBound2 < _newFinneyBound3 &&_newFinneyBound3 < _newFinneyBound4 &&_newFinneyBound4 < _newFinneyBound5 &&_newFinneyBound5 < _newFinneyBound6);
281         tokensPerWei = _newTokensPerWei;
282         weiBound1 = _newFinneyBound1.mul(1000000000000000);
283         weiBound2 = _newFinneyBound2.mul(1000000000000000);
284         weiBound3 = _newFinneyBound3.mul(1000000000000000);
285         weiBound4 = _newFinneyBound4.mul(1000000000000000);
286         weiBound5 = _newFinneyBound5.mul(1000000000000000);
287         weiBound6 = _newFinneyBound6.mul(1000000000000000);
288         orgonBonus1 = _newOrgonBonus1;
289         orgonBonus2 = _newOrgonBonus2;
290         orgonBonus3 = _newOrgonBonus3;
291         orgonBonus4 = _newOrgonBonus4;
292         orgonBonus5 = _newOrgonBonus5;
293         orgonBonus6 = _newOrgonBonus6;
294     } 
295     
296  /** Set new owner for the smart contract.
297  * May only be called by smart contract owner.
298  * @param _newOwner address of new owner of the smart contract 
299  **/
300     function setOwner (address _newOwner) public {
301         require (msg.sender == owner);
302         require (_newOwner != address(this));
303         require (_newOwner != address(0x0));
304         
305         owner = _newOwner;
306 }
307  
308 /* *********************************************** */    
309     function getCurrentMarket() view public returns (uint256){ return orgonToken.balanceOf(address(this)); } 
310     
311     function getCurrentMarketE18() view public returns (uint256, uint256){
312         uint256 bal;
313         bal = orgonToken.balanceOf(address(this));
314         return (bal/1000000000000000000, bal%1000000000000000000);
315     } 
316     
317     function getTotalSupply() view public returns (uint256){ return orgonToken.totalSupply(); }
318     
319     function getTotalSupplyE18() view public returns (uint256){
320         return orgonToken.totalSupply()/1000000000000000000;
321     }
322     
323     function getETHbalance() view public returns (uint256, uint256) {
324         uint256 bal;
325         bal = address(this).balance;
326         return (bal/1000000000000000000,bal%1000000000000000000);
327     }
328     
329     function getTokensPerETH() view public returns (uint256){ return tokensPerWei; }
330     
331     function theOwner() view public returns (address _owner){ return owner; }
332    
333     function getEthBonus() view public returns (uint256 eth_1Bound, uint256 Bonus1,
334                                                 uint256 eth_2Bound, uint256 Bonus2,
335                                                 uint256 eth_3Bound, uint256 Bonus3,
336                                                 uint256 eth_4Bound, uint256 Bonus4,
337                                                 uint256 eth_5Bound, uint256 Bonus5,
338                                                 uint256 eth_6Bound, uint256 Bonus6) {
339         eth_1Bound = weiBound1.div(1000000000000000000);
340         eth_2Bound = weiBound2.div(1000000000000000000);
341         eth_3Bound = weiBound3.div(1000000000000000000);
342         eth_4Bound = weiBound4.div(1000000000000000000);
343         eth_5Bound = weiBound5.div(1000000000000000000);
344         eth_6Bound = weiBound6.div(1000000000000000000);
345         return (eth_1Bound, orgonBonus1, eth_2Bound, orgonBonus2, eth_3Bound, orgonBonus3,
346                 eth_4Bound, orgonBonus4, eth_5Bound, orgonBonus5, eth_6Bound, orgonBonus6);
347     }
348     
349     function getFinneyBonus() view public returns (uint256 finney_1Bound, uint256 Bonus1,
350                                                 uint256 finney_2Bound, uint256 Bonus2,
351                                                 uint256 finney_3Bound, uint256 Bonus3,
352                                                 uint256 finney_4Bound, uint256 Bonus4,
353                                                 uint256 finney_5Bound, uint256 Bonus5,
354                                                 uint256 finney_6Bound, uint256 Bonus6) {
355         finney_1Bound = weiBound1.div(1000000000000000);
356         finney_2Bound = weiBound2.div(1000000000000000);
357         finney_3Bound = weiBound3.div(1000000000000000);
358         finney_4Bound = weiBound4.div(1000000000000000);
359         finney_5Bound = weiBound5.div(1000000000000000);
360         finney_6Bound = weiBound6.div(1000000000000000);
361         return (finney_1Bound, orgonBonus1, finney_2Bound, orgonBonus2, finney_3Bound, orgonBonus3,
362                 finney_4Bound, orgonBonus4, finney_5Bound, orgonBonus5, finney_6Bound, orgonBonus6);
363     }
364    
365    function getWeiBonus() view public returns (uint256 wei_1Bound, uint256 Bonus1,
366                                                 uint256 wei_2Bound, uint256 Bonus2,
367                                                 uint256 wei_3Bound, uint256 Bonus3,
368                                                 uint256 wei_4Bound, uint256 Bonus4,
369                                                 uint256 wei_5Bound, uint256 Bonus5,
370                                                 uint256 wei_6Bound, uint256 Bonus6) {
371         return (weiBound1, orgonBonus1, weiBound2, orgonBonus2, weiBound3, orgonBonus3,
372                 weiBound4, orgonBonus4, weiBound5, orgonBonus5, weiBound6, orgonBonus6);
373     }
374    
375     
376     uint256 private tokensPerWei;
377     uint256 private orgonBonus1;
378     uint256 private orgonBonus2;
379     uint256 private orgonBonus3;
380     uint256 private orgonBonus4;
381     uint256 private orgonBonus5;
382     uint256 private orgonBonus6;
383     
384     uint256 private weiBound1;
385     uint256 private weiBound2;
386     uint256 private weiBound3;
387     uint256 private weiBound4;
388     uint256 private weiBound5;
389     uint256 private weiBound6;
390     
391     /** Owner of the smart contract */
392     address private  owner;
393     
394     /**
395     * Orgon Token smart contract.
396     */
397     OrgonToken private orgonToken;
398 }