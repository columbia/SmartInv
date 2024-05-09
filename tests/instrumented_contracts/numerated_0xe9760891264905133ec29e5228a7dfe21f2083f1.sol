1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title A standard interface for tokens.
55  */
56 interface ERC20 {
57 
58   /**
59    * @dev Returns the name of the token.
60    */
61   function name()
62     external
63     view
64     returns (string _name);
65 
66   /**
67    * @dev Returns the symbol of the token.
68    */
69   function symbol()
70     external
71     view
72     returns (string _symbol);
73 
74   /**
75    * @dev Returns the number of decimals the token uses.
76    */
77   function decimals()
78     external
79     view
80     returns (uint8 _decimals);
81 
82   /**
83    * @dev Returns the total token supply.
84    */
85   function totalSupply()
86     external
87     view
88     returns (uint256 _totalSupply);
89 
90   /**
91    * @dev Returns the account balance of another account with address _owner.
92    * @param _owner The address from which the balance will be retrieved.
93    */
94   function balanceOf(
95     address _owner
96   )
97     external
98     view
99     returns (uint256 _balance);
100 
101   /**
102    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
103    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
104    * @param _to The address of the recipient.
105    * @param _value The amount of token to be transferred.
106    */
107   function transfer(
108     address _to,
109     uint256 _value
110   )
111     external
112     returns (bool _success);
113 
114   /**
115    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
116    * Transfer event.
117    * @param _from The address of the sender.
118    * @param _to The address of the recipient.
119    * @param _value The amount of token to be transferred.
120    */
121   function transferFrom(
122     address _from,
123     address _to,
124     uint256 _value
125   )
126     external
127     returns (bool _success);
128 
129   /**
130    * @dev Allows _spender to withdraw from your account multiple times, up to
131    * the _value amount. If this function is called again it overwrites the current
132    * allowance with _value.
133    * @param _spender The address of the account able to transfer the tokens.
134    * @param _value The amount of tokens to be approved for transfer.
135    */
136   function approve(
137     address _spender,
138     uint256 _value
139   )
140     external
141     returns (bool _success);
142 
143   /**
144    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
145    * @param _owner The address of the account owning tokens.
146    * @param _spender The address of the account able to transfer the tokens.
147    */
148   function allowance(
149     address _owner,
150     address _spender
151   )
152     external
153     view
154     returns (uint256 _remaining);
155 
156   /**
157    * @dev Triggers when tokens are transferred, including zero value transfers.
158    */
159   event Transfer(
160     address indexed _from,
161     address indexed _to,
162     uint256 _value
163   );
164 
165   /**
166    * @dev Triggers on any successful call to approve(address _spender, uint256 _value).
167    */
168   event Approval(
169     address indexed _owner,
170     address indexed _spender,
171     uint256 _value
172   );
173 
174 }
175 
176 contract Token is ERC20
177 {
178   using SafeMath for uint256;
179 
180   /**
181    * Token name.
182    */
183   string internal tokenName;
184 
185   /**
186    * Token symbol.
187    */
188   string internal tokenSymbol;
189 
190   /**
191    * Number of decimals.
192    */
193   uint8 internal tokenDecimals;
194 
195   /**
196    * Total supply of tokens.
197    */
198   uint256 internal tokenTotalSupply;
199 
200   /**
201    * Balance information map.
202    */
203   mapping (address => uint256) internal balances;
204 
205   /**
206    * Token allowance mapping.
207    */
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210   /**
211    * @dev Trigger when tokens are transferred, including zero value transfers.
212    */
213   event Transfer(
214     address indexed _from,
215     address indexed _to,
216     uint256 _value
217   );
218 
219   /**
220    * @dev Trigger on any successful call to approve(address _spender, uint256 _value).
221    */
222   event Approval(
223     address indexed _owner,
224     address indexed _spender,
225     uint256 _value
226   );
227 
228   /**
229    * @dev Returns the name of the token.
230    */
231   function name()
232     external
233     view
234     returns (string _name)
235   {
236     _name = tokenName;
237   }
238 
239   /**
240    * @dev Returns the symbol of the token.
241    */
242   function symbol()
243     external
244     view
245     returns (string _symbol)
246   {
247     _symbol = tokenSymbol;
248   }
249 
250   /**
251    * @dev Returns the number of decimals the token uses.
252    */
253   function decimals()
254     external
255     view
256     returns (uint8 _decimals)
257   {
258     _decimals = tokenDecimals;
259   }
260 
261   /**
262    * @dev Returns the total token supply.
263    */
264   function totalSupply()
265     external
266     view
267     returns (uint256 _totalSupply)
268   {
269     _totalSupply = tokenTotalSupply;
270   }
271 
272   /**
273    * @dev Returns the account balance of another account with address _owner.
274    * @param _owner The address from which the balance will be retrieved.
275    */
276   function balanceOf(
277     address _owner
278   )
279     external
280     view
281     returns (uint256 _balance)
282   {
283     _balance = balances[_owner];
284   }
285 
286   /**
287    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
288    * function SHOULD throw if the _from account balance does not have enough tokens to spend.
289    * @param _to The address of the recipient.
290    * @param _value The amount of token to be transferred.
291    */
292   function transfer(
293     address _to,
294     uint256 _value
295   )
296     public
297     returns (bool _success)
298   {
299     require(_value <= balances[msg.sender]);
300 
301     balances[msg.sender] = balances[msg.sender].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303 
304     emit Transfer(msg.sender, _to, _value);
305     _success = true;
306   }
307 
308   /**
309    * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
310    * this function is called again it overwrites the current allowance with _value.
311    * @param _spender The address of the account able to transfer the tokens.
312    * @param _value The amount of tokens to be approved for transfer.
313    */
314   function approve(
315     address _spender,
316     uint256 _value
317   )
318     public
319     returns (bool _success)
320   {
321     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
322 
323     allowed[msg.sender][_spender] = _value;
324 
325     emit Approval(msg.sender, _spender, _value);
326     _success = true;
327   }
328 
329   /**
330    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
331    * @param _owner The address of the account owning tokens.
332    * @param _spender The address of the account able to transfer the tokens.
333    */
334   function allowance(
335     address _owner,
336     address _spender
337   )
338     external
339     view
340     returns (uint256 _remaining)
341   {
342     _remaining = allowed[_owner][_spender];
343   }
344 
345   /**
346    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
347    * Transfer event.
348    * @param _from The address of the sender.
349    * @param _to The address of the recipient.
350    * @param _value The amount of token to be transferred.
351    */
352   function transferFrom(
353     address _from,
354     address _to,
355     uint256 _value
356   )
357     public
358     returns (bool _success)
359   {
360     require(_value <= balances[_from]);
361     require(_value <= allowed[_from][msg.sender]);
362 
363     balances[_from] = balances[_from].sub(_value);
364     balances[_to] = balances[_to].add(_value);
365     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
366 
367     emit Transfer(_from, _to, _value);
368     _success = true;
369   }
370 
371 }
372 
373 contract CYC is Token {
374 
375   constructor()
376     public
377   {
378     tokenName = "ChangeYourCoin";
379     tokenSymbol = "CYC";
380     tokenDecimals = 0;
381     tokenTotalSupply = 15000000;
382     balances[msg.sender] = tokenTotalSupply;
383   }
384 }