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
29 /**
30  * support ERC677
31  * reference: https://github.com/ethereum/EIPs/issues/677
32  * |--------------|            |-----------------------|            |-------------------------|
33  * |    Sender    |            | ERC677SenderInterface |            | ERC677ReceiverInterface |
34  * |--------------|            |-----------------------|            |-------------------------|
35  *        |       transferAndCall()        |                                      |
36  *        |------------------------------->|            tokenFallback()           |
37  *        |                                |------------------------------------->|
38  *        |                                |                                      |
39  */
40 contract ERC677ReceiverInterface {
41     function tokenFallback(address _sender, uint256 _value, bytes _extraData) 
42         public returns (bool);
43 }
44 
45 contract ERC677SenderInterface {
46     function transferAndCall(address _recipient, uint256 _value, bytes _extraData) 
47         public returns (bool);
48 }
49 
50 /**
51  *    __             ___      _       
52  *   /__\_ _  __ _  / __\___ (_)_ __  
53  *  /_\/ _` |/ _` |/ /  / _ \| | '_ \ 
54  * //_| (_| | (_| / /__| (_) | | | | |
55  * \__/\__, |\__, \____/\___/|_|_| |_|
56  *     |___/ |___/                    
57  * Egg Coin is an internal token that play game developed by LEGG team.
58  * Actually, this token has no total supply limit, when minting, the total supply will increase.
59  * */
60 
61 contract EggCoin is ERC20Interface, ERC677SenderInterface {
62     
63     using SafeMath for *;
64     
65     constructor()
66         public
67     {
68         owner_ = msg.sender;
69         // no supply any token after deploying contract.
70         totalSupply_ = 0;
71     }
72     
73     address public owner_;
74     
75     string public name = "Egg Coin";
76     string public symbol = "EGG";
77     uint8 public decimals = 18;
78     
79     mapping(address => uint256) private balances_;
80     mapping(address => mapping(address => uint256)) private allowed_;
81     uint256 private totalSupply_;
82  
83     /**
84      *                   _ _  __ _               
85      *   /\/\   ___   __| (_)/ _(_) ___ _ __ ___ 
86      *  /    \ / _ \ / _` | | |_| |/ _ \ '__/ __|
87      * / /\/\ \ (_) | (_| | |  _| |  __/ |  \__ \
88      * \/    \/\___/ \__,_|_|_| |_|\___|_|  |___/
89      * 
90      * */   
91      
92     modifier onlyOwner(
93         address _address
94     )
95     {
96         require(_address == owner_, "This action not allowed because of permission.");
97         _;
98     }
99     
100     /**
101      *     __                 _       
102      *    /__\_   _____ _ __ | |_ ___   
103      *   /_\ \ \ / / _ \ '_ \| __/ __|
104      *  //__  \ V /  __/ | | | |_\__ \
105      *  \__/   \_/ \___|_| |_|\__|___/
106      * */
107     event Mint(
108         address miner,
109         uint256 totalSupply
110     );
111     
112     event TransferOwnership(
113         address newOwner
114     );
115     
116     /**
117      *      __  __    ___ ____   ___      ___                 _   _                 
118      *     /__\/__\  / __\___ \ / _ \    / __\   _ _ __   ___| |_(_) ___  _ __  ___  
119      *    /_\ / \// / /    __) | | | |  / _\| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
120      *   //__/ _  \/ /___ / __/| |_| | / /  | |_| | | | | (__| |_| | (_) | | | \__ \
121      *   \__/\/ \_/\____/|_____|\___/  \/    \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
122      *  ERC20 Functions
123      * */
124      
125     function totalSupply()
126         view
127         public
128         returns
129         (uint256)
130     {
131         return totalSupply_;
132     }
133     
134     function balanceOf(
135         address _address
136     )
137         view
138         public 
139         returns
140         (uint256)
141     {
142         return balances_[_address];
143     }
144     
145     function allowance(
146         address _who,
147         address _spender
148     )
149         view
150         public
151         returns
152         (uint256)
153     {
154         return allowed_[_who][_spender];
155     }
156     
157     function transfer(
158         address _to,
159         uint256 _value
160     )
161         public
162         returns
163         (bool)
164     {
165         require(balances_[msg.sender] >= _value, "Insufficient balance");
166         require(_to != address(0), "Don't burn the token please!");
167         
168         balances_[msg.sender] = balances_[msg.sender].sub(_value);
169         balances_[_to] = balances_[_to].add(_value);
170         
171         emit Transfer(
172             msg.sender,
173             _to,
174             _value
175         );
176         
177         return true;
178     }
179     
180     function approve(
181         address _spender, 
182         uint256 _value
183     ) 
184         public 
185         returns 
186         (bool)
187     {
188         allowed_[msg.sender][_spender] = _value;
189         emit Approval(
190             msg.sender,
191             _spender,
192             _value
193         );
194         
195         return true;
196     }
197     
198     function transferFrom(
199         address _from, 
200         address _to,
201         uint256 _value
202     ) 
203         public 
204         returns 
205         (bool)
206     {
207         require(balances_[_from] >= _value, "Owner Insufficient balance");
208         require(allowed_[_from][msg.sender] >= _value, "Spender Insufficient balance");
209         require(_to != address(0), "Don't burn the coin.");
210         
211         balances_[_from] = balances_[_from].sub(_value);
212         balances_[_to] = balances_[_to].add(_value);
213         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
214         
215         emit Transfer(
216             _from,
217             _to,
218             _value
219         );
220         
221         return true;
222     }
223     
224     function increaseApproval(
225         address _spender,
226         uint256 _addValue
227     )
228         public
229         returns
230         (bool)
231     {
232         allowed_[msg.sender][_spender] = 
233             allowed_[msg.sender][_spender].add(_addValue);
234         
235         emit Approval(
236             msg.sender,
237             _spender,
238             allowed_[msg.sender][_spender]
239         );
240         
241         return true;
242     }
243     
244     function decreaseApproval(
245         address _spender,
246         uint256 _substractValue
247     )
248         public
249         returns
250         (bool)
251     {
252         uint256 _oldValue = allowed_[msg.sender][_spender];
253         if(_oldValue >= _substractValue) {
254             allowed_[msg.sender][_spender] = _oldValue.sub(_substractValue);
255         } 
256         else {
257             allowed_[msg.sender][_spender] = 0;    
258         }
259         
260         emit Approval(
261             msg.sender,
262             _spender,
263             allowed_[msg.sender][_spender]
264         );
265         
266         return true;
267     }
268     
269     /**
270      * @dev ERC677 support
271      * 
272      * */
273     function transferAndCall(address _recipient,
274                     uint256 _value,
275                     bytes _extraData)
276         public
277         returns
278         (bool)
279     {
280         transfer(_recipient, _value);
281         if(isContract(_recipient)) {
282             require(ERC677ReceiverInterface(_recipient).tokenFallback(msg.sender, _value, _extraData));
283         }
284         return true;
285     }
286     
287     function isContract(address _addr) private view returns (bool) {
288         uint len;
289         assembly {
290             len := extcodesize(_addr)
291         }
292         return len > 0;
293     }
294     
295     /**
296      
297      *    ___                                            _       
298      *   /___\__      ___ __   ___ _ __       ___  _ __ | |_   _ 
299      *  //  //\ \ /\ / / '_ \ / _ \ '__|____ / _ \| '_ \| | | | |
300      * / \_//  \ V  V /| | | |  __/ | |_____| (_) | | | | | |_| |
301      * \___/    \_/\_/ |_| |_|\___|_|        \___/|_| |_|_|\__, |
302      *                                                     |___/                                               
303      * The functions that owner can call.
304      */
305      
306     function transferOwnership(
307         address _newOwner
308     )
309         public
310         onlyOwner(msg.sender)
311     {
312         owner_ = _newOwner;
313         emit TransferOwnership(_newOwner);
314     }
315     
316     function mint(
317         uint256 _amount
318     )
319         public
320         onlyOwner(msg.sender)
321     {
322         totalSupply_ = totalSupply_.add(_amount);
323         balances_[msg.sender] = balances_[msg.sender].add(_amount);
324         emit Transfer(
325             address(0),
326             msg.sender,
327             _amount
328         );
329     }
330 }
331 
332 /**
333  *   __        __                      _   _     
334     / _\ __ _ / _| ___ _ __ ___   __ _| |_| |__  
335     \ \ / _` | |_ / _ \ '_ ` _ \ / _` | __| '_ \ 
336     _\ \ (_| |  _|  __/ | | | | | (_| | |_| | | |
337     \__/\__,_|_|  \___|_| |_| |_|\__,_|\__|_| |_|
338       
339     SafeMath library, thanks to openzeppelin solidity.
340     https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
341  * */
342 
343 library SafeMath {
344 
345   /**
346   * @dev Multiplies two numbers, reverts on overflow.
347   */
348   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
349     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350     // benefit is lost if 'b' is also tested.
351     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
352     if (_a == 0) {
353       return 0;
354     }
355 
356     uint256 c = _a * _b;
357     require(c / _a == _b);
358 
359     return c;
360   }
361 
362   /**
363   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
364   */
365   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
366     require(_b > 0); // Solidity only automatically asserts when dividing by 0
367     uint256 c = _a / _b;
368     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
369 
370     return c;
371   }
372 
373   /**
374   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
375   */
376   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
377     require(_b <= _a);
378     uint256 c = _a - _b;
379 
380     return c;
381   }
382 
383   /**
384   * @dev Adds two numbers, reverts on overflow.
385   */
386   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
387     uint256 c = _a + _b;
388     require(c >= _a);
389 
390     return c;
391   }
392 
393   /**
394   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
395   * reverts when dividing by zero.
396   */
397   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
398     require(b != 0);
399     return a % b;
400   }
401 }