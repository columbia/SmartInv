1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath32 {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
61     if (a == 0) {
62       return 0;
63     }
64     uint32 c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint32 a, uint32 b) internal pure returns (uint32) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint32 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint32 a, uint32 b) internal pure returns (uint32) {
91     uint32 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath8 {
103 
104   /**
105   * @dev Multiplies two numbers, throws on overflow.
106   */
107   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
108     if (a == 0) {
109       return 0;
110     }
111     uint8 c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint8 a, uint8 b) internal pure returns (uint8) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint8 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint8 a, uint8 b) internal pure returns (uint8) {
138     uint8 c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
143 
144 
145 /**
146  * @title Ownable
147  * @dev The Ownable contract has an owner address, and provides basic authorization control
148  * functions, this simplifies the implementation of "user permissions".
149  */
150 contract Ownable {
151   address public owner;
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() public {
160     owner = msg.sender;
161   }
162 
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address newOwner) public onlyOwner {
178     require(newOwner != address(0));
179     OwnershipTransferred(owner, newOwner);
180     owner = newOwner;
181   }
182 
183 }
184 contract ERC20Basic {
185   uint256 public totalSupply;
186   function balanceOf(address who) public constant returns (uint256);
187   function transfer(address to, uint256 value) public returns (bool);
188   event Transfer(address indexed from, address indexed to, uint256 value);
189 }
190 
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193   mapping(address => uint256) balances;
194   
195 
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value > 0 && _value <= balances[msg.sender]);
199     
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     
203     emit Transfer(msg.sender, _to, _value);
204     return true;
205   }
206   
207   function balanceOf(address _owner) public constant returns (uint256 balance) {
208     return balances[_owner];
209   }
210 }
211 
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender) public constant returns (uint256);
214   function transferFrom(address from, address to, uint256 value) public returns (bool);
215   function approve(address spender, uint256 value) public returns (bool);
216   event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 contract StandardToken is ERC20, BasicToken {
220   mapping (address => mapping (address => uint256)) internal allowed;
221   
222   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223     require(_to != address(0));
224     require(_value > 0 && _value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233   
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239   
240   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
241     return allowed[_owner][_spender];
242   }
243 }
244 
245 contract Pausable is Ownable {
246   event Pause();
247   event Unpause();
248   bool public paused = false;
249  
250   modifier whenNotPaused() {
251     require(!paused);
252     _;
253   }
254   
255   modifier whenPaused() {
256     require(paused);
257     _;
258   }
259  
260   function pause() onlyOwner whenNotPaused public {
261     paused = true;
262     Pause();
263   }
264   
265   function unpause() onlyOwner whenPaused public {
266     paused = false;
267     Unpause();
268   }
269 }
270 
271 contract PausableToken is StandardToken, Pausable {
272   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
273     return super.transfer(_to, _value);
274   }
275   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
276     return super.transferFrom(_from, _to, _value);
277   }
278   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
279     return super.approve(_spender, _value);
280   }
281 }
282 /**
283  * 
284  * @author uchiha-itachi@mail.com
285  * 
286  */
287 contract S3DContract is Ownable, PausableToken {
288     
289     modifier shareholderOnly {
290         require(balances[msg.sender] > 0);
291         _;
292     }
293     
294     modifier acceptDividend {
295         require(address(this).balance >= 1 ether);
296         require(block.number - lastDivideBlock >= freezenBlocks);
297         _;
298     }
299     
300     using SafeMath for uint256;
301     
302     string public name = 'Share of Lottery Token';
303     string public symbol = 'SLT';
304     string public version = '1.0.2';
305     uint8 public decimals = 0;
306     bool public ico = true;
307     uint256 public ico_price = 0.1 ether;
308     uint8 public ico_percent = 20;
309     uint256 public ico_amount = 0;
310     uint256 public initShares ;
311     uint256 public totalShare = 0;
312     
313     event ReciveEth(address _from, uint amount);
314     event SendBouns(uint _amount);
315     event MyProfitRecord(address _addr, uint _amount);
316     
317     event ReciveFound(address _from, uint amount);
318     event TransferFound(address _to, uint amount);
319     event TransferShareFail(address _to, uint amount);
320     
321     uint256 lastDivideBlock;
322     uint freezenBlocks =  5990;
323     
324     address[] accounts;
325     
326     constructor (uint256 initialSupply) public {
327         totalSupply = initialSupply * 10 ** uint256(decimals);
328         initShares = totalSupply;
329         balances[msg.sender] = totalSupply;
330         accounts.push(msg.sender);
331     }
332     
333     function setIcoPrice(uint256 _price) external onlyOwner {
334         require(_price > 0);
335         ico_price = _price;
336     }
337     
338     
339     function setIcoStatus(bool _flag) external onlyOwner {
340         ico = _flag;
341     }
342     
343     // Sell Shares
344     function buy() external payable {
345         require(ico);
346         require(msg.value > 0 && msg.value % ico_price == 0);
347         uint256 shares = msg.value.div(ico_price);
348         require(ico_amount.add(shares) <= initShares.div(100).mul(ico_percent));
349         
350         emit ReciveFound(msg.sender, msg.value);
351         balances[msg.sender] = balances[msg.sender].add(shares);
352         totalSupply = totalSupply.add(shares.mul(10 ** decimals));
353         ico_amount = ico_amount.add(shares);
354         owner.transfer(msg.value);
355         emit TransferFound(owner, msg.value);
356     }
357     
358     // Cash Desk
359     function () public payable {
360         emit ReciveEth(msg.sender, msg.value);
361     }
362     
363     function sendBouns() external acceptDividend shareholderOnly {
364         _sendBonus();
365         
366     }
367     
368     // dispatch bouns
369     function _sendBonus() internal {
370         // caculate bouns
371         lastDivideBlock = block.number;
372         uint256 total = address(this).balance;
373         address[] memory _accounts = accounts;
374         // do
375         for (uint i =0; i < _accounts.length; i++) {
376             if (balances[_accounts[i]] > 0) {
377                 uint256 interest = total.div(totalSupply).mul(balances[_accounts[i]]);
378                 if (interest > 0) {
379                     if (_accounts[i].send(interest)) {
380                         emit MyProfitRecord(_accounts[i], interest);
381                     }
382                 }
383             }
384         }
385         totalShare.add(total);
386         emit SendBouns(total);
387     }
388     
389     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
390         if (super.transfer(_to, _value)) {
391             _addAccount(_to);
392         }
393     }
394     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
395         if  (super.transferFrom(_from, _to, _value)) {
396             _addAccount(_to);
397         }
398     }
399     
400     function _addAccount(address _addr) internal returns(bool) {
401         address[] memory _accounts = accounts;
402         for (uint i = 0; i < _accounts.length; i++) {
403             if (_accounts[i] == _addr) {
404                 return false;
405             }
406         }
407         accounts.push(_addr);
408         return true;
409     }
410     
411     
412     function addAccount(address _addr) external onlyOwner {
413         _addAccount(_addr);
414     }
415 }