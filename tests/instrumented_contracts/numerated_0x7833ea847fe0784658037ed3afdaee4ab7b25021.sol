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
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender)
117     public view returns (uint256);
118 
119   function transferFrom(address from, address to, uint256 value)
120     public returns (bool);
121 
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(
150     address _from,
151     address _to,
152     uint256 _value
153   )
154     public
155     returns (bool)
156   {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(
191     address _owner,
192     address _spender
193    )
194     public
195     view
196     returns (uint256)
197   {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(
212     address _spender,
213     uint _addedValue
214   )
215     public
216     returns (bool)
217   {
218     allowed[msg.sender][_spender] = (
219       allowed[msg.sender][_spender].add(_addedValue));
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(
235     address _spender,
236     uint _subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 /* 父类:账户管理员 */
254 contract owned {
255 
256     address public owner;
257 
258     function owned() public {
259         owner = msg.sender;
260     }
261 
262     /* modifier是修改标志 */
263     modifier onlyOwner {
264         require(msg.sender == owner);
265         _;
266     }
267 
268     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
269     function transferOwnership(address newOwner) onlyOwner public {
270         owner = newOwner;
271     }   
272 }
273 
274 /* 子类:代币发行 */
275 contract GoalToken is owned, StandardToken {
276 
277     string public name = "Galaxy Overall Application Homeland";
278     
279     string public symbol = "Goal";
280 
281     uint8 public decimals = 5;
282     
283     /* 构造函数 */
284     function GoalToken() public {
285         //发行量：2.1亿（小数位：5）
286         totalSupply_ = 21 * 1000 * 10000 * 100000;
287 	    balances[msg.sender] = totalSupply_;
288     }
289     
290     /* 查看余额 
291     function balanceOf(address _owner) public view returns (uint256) {
292         //return balances[_owner].add(freezes[_owner]);
293         //冻结部分不作为余额展示出来， 可通过freezeof查看被冻结部分金额
294         return balances[_owner];
295     }*/
296     
297     /* 查看被冻结部分金额
298     function freezeof(address _owner) public view returns (uint256) {
299         return freezes[_owner];
300     } */
301     
302     /* 从给定地址上解冻代币， 释放给定代币数量到给定的目标地址
303 	function freeTokens(address _owner, address _target, uint256 amount) onlyOwner public returns (bool){
304 	    require(_owner != address(0));
305 	    require(_target != address(0));
306     
307 		require(amount <= freezes[_owner]); //确保要释放的数量少于或等于被锁定的数量
308 		require(amount >=0); 
309 		
310 		freezes[_owner] = freezes[_owner].sub(amount);
311 		balances[_target] = balances[_target].add(amount);
312 		
313 		emit FreeFunds(_target, amount);
314 		return true;
315 	} */
316 	
317 	/* 锁定指定数量的代币
318 	function freezeTokens(address _owner, uint256 amount) onlyOwner public returns (bool){
319 	    require(_owner != address(0));
320     
321 		require(amount <= balances[_owner]); //确保要锁定的数量大于或等于余额
322 		require(amount >= 0); 
323 	
324 		balances[_owner] = balances[_owner].sub(amount);
325 		freezes[_owner] = freezes[_owner].add(amount);
326 		
327 		emit FreezeFunds(_owner, amount);
328 		return true;
329 	} */
330     
331     /* 收回以太币
332 	function withdrawEther(uint256 amount) onlyOwner public{
333 		msg.sender.transfer(amount);
334 	} */
335 	
336 	/* 可以接受以太币
337 	function() payable public {
338     } */
339 }