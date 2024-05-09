1 /* Orgon.Sale */
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
151 contract OrgonSale {
152 using SafeMath for uint256;
153     /* Start OrgonMarket */
154     function OrgonSale (OrgonToken _orgonToken) public {
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
169         currentMarket = orgonToken.balanceOf (this);   
170         if (currentMarket == 0) revert (); 
171         
172         uint256 toBuy;
173         if (msg.value < ethBound1) {
174             toBuy = msg.value.mul(price);
175             require (orgonToken.transfer (msg.sender, toBuy));
176             
177         }
178         else if (msg.value < ethBound2) {
179             toBuy = msg.value.mul(price1);
180             require (orgonToken.transfer (msg.sender, toBuy));
181         }    
182         else if (msg.value < ethBound3) {
183             toBuy = msg.value.mul(price2);
184             require (orgonToken.transfer (msg.sender, toBuy));
185         }    
186         else {
187             toBuy = msg.value.mul(price3);
188             require (orgonToken.transfer (msg.sender, toBuy));
189         }  
190         return true;
191     }  
192     
193     function countTokens (uint256 _value) public view returns (uint256 tokens, uint256 _currentMarket){
194         require (_value > 0);
195         
196         uint256 currentMarket;
197         currentMarket = orgonToken.balanceOf (this);   
198         if (currentMarket == 0) revert (); 
199         
200         uint256 toBuy;
201         if (_value < ethBound1) {
202             toBuy = _value.mul(price);
203             return (toBuy,currentMarket);
204         }
205         else if (_value < ethBound2) {
206             toBuy = _value.mul(price1);
207             return (toBuy,currentMarket);
208         }    
209         else if (_value < ethBound3) {
210             toBuy = _value.mul(price2);
211            return (toBuy,currentMarket);
212         }    
213         else {
214             toBuy = _value.mul(price3);
215             return (toBuy,currentMarket);
216         }  
217         return (0,currentMarket);
218     }  
219     
220     
221     function sendTokens (address _to, uint256 _amount) public returns (bool success){
222         
223         require (msg.sender == owner);
224         require (_to != address(this));
225         require (_amount > 0);
226         require (orgonToken.transfer (_to, _amount));
227         return true;
228         
229     }
230     
231     function sendETH (address _to, uint256 _amount) public returns (bool success){
232         
233         require (msg.sender == owner);
234         require (_to != address(this));
235         require (_amount > 0);
236         _to.transfer (_amount);
237         return true;
238         
239     }
240      
241     function setPrice(uint256 _newPrice) public {
242         require (msg.sender == owner);
243         require (_newPrice > 0);
244         price = _newPrice;
245     }
246     function setPrice1(uint256 _newPrice, uint256 _bound1) public {
247         require (msg.sender == owner);
248         require (_newPrice > 0 && _newPrice > price);
249         price1 = _newPrice;
250         bound1 = _bound1;
251         ethBound1 = bound1.div(price);
252     }
253      function setPrice2(uint256 _newPrice, uint256 _bound2) public {
254         require (msg.sender == owner);
255         require (_newPrice > 0 && _newPrice > price1 && _bound2 > bound1);
256         price2 = _newPrice;
257         bound2 = _bound2;
258         ethBound2 = bound2.div(price1);
259     }
260      function setPrice3(uint256 _newPrice, uint256 _bound3) public {
261         require (msg.sender == owner);
262         require (_newPrice > 0 && _newPrice > price2 && _bound3 > bound2);
263         price3 = _newPrice;
264         bound3 = _bound3;
265         ethBound3 = bound3.div(price2);
266     }
267     
268     /** Set new owner for the smart contract.
269  * May only be called by smart contract owner.
270  * @param _newOwner address of new owner of the smart contract */
271  
272 /* *********************************************** */
273 function setOwner (address _newOwner) public {
274  
275     require (msg.sender == owner);
276     require (_newOwner != address(this));
277     require (_newOwner != address(0x0));
278     
279     owner = _newOwner;
280     
281 }
282  
283  
284 /* *********************************************** */    
285     function getPrice() view public returns (uint256 _price){ return price; }
286     function getPrice1() view public returns (uint256 _price1){ return price1; }
287     function getPrice2() view public returns (uint256 _price2){ return price2; }
288     function getPrice3() view public returns (uint256 _price3){ return price3; }
289     
290     function getBound1() view public returns (uint256 _bound1){ return bound1; }
291     function getBound2() view public returns (uint256 _bound2){ return bound2; }
292     function getBound3() view public returns (uint256 _bound3){ return bound3; }
293     
294     function getEthBound1() view public returns (uint256 _bound1){ return ethBound1; }
295     function getEthBound2() view public returns (uint256 _bound2){ return ethBound2; }
296     function getEthBound3() view public returns (uint256 _bound3){ return ethBound3; }
297     
298     function theOwner() view public returns (address _owner){ return owner; }
299     
300     /** Total number of tokens in circulation */
301     uint256 private price;
302     uint256 private price1;
303     uint256 private price2;
304     uint256 private price3;
305     
306     uint256 private bound1;
307     uint256 private bound2;
308     uint256 private bound3;
309     
310     uint256 private ethBound1;
311     uint256 private ethBound2;
312     uint256 private ethBound3;
313     
314     /** Owner of the smart contract */
315     address private  owner;
316     
317     /**
318     * Orgon Token smart contract.
319     */
320     OrgonToken internal orgonToken;
321 }