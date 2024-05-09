1 pragma solidity ^0.5.1;
2 
3 library IterableMapping {
4   struct itmap
5   {
6     mapping(address => IndexValue) data;
7     KeyFlag[] keys;
8     uint size;
9   }
10   struct IndexValue { uint keyIndex; uint value; }
11   struct KeyFlag { address key; bool deleted; }
12   function insert(itmap storage self, address key, uint value) public returns (bool replaced)
13   {
14     uint keyIndex = self.data[key].keyIndex;
15     self.data[key].value = value;
16     if (keyIndex > 0)
17       return true;
18     else
19     {
20       keyIndex = self.keys.length++;
21       self.data[key].keyIndex = keyIndex + 1;
22       self.keys[keyIndex].key = key;
23       self.size++;
24       return false;
25     }
26   }
27   function remove(itmap storage self, address key) public returns (bool success)
28   {
29     uint keyIndex = self.data[key].keyIndex;
30     if (keyIndex == 0)
31       return false;
32     delete self.data[key];
33     self.keys[keyIndex - 1].deleted = true;
34     self.size --;
35   }
36   function contains(itmap storage self, address key) public view returns (bool)
37   {
38     return self.data[key].keyIndex > 0;
39   }
40   function iterate_start(itmap storage self) public view returns (uint keyIndex)
41   {
42     return iterate_next(self, uint(-1));
43   }
44   function iterate_valid(itmap storage self, uint keyIndex) public view returns (bool)
45   {
46     return keyIndex < self.keys.length;
47   }
48   function iterate_next(itmap storage self, uint keyIndex) public view returns (uint r_keyIndex)
49   {
50     keyIndex++;
51     while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
52       keyIndex++;
53     return keyIndex;
54   }
55   function iterate_get(itmap storage self, uint keyIndex) public view returns (address key, uint value)
56   {
57     key = self.keys[keyIndex].key;
58     value = self.data[key].value;
59   }
60   function iterate_getValue(itmap storage self, address key) public view returns (uint value) {
61       return self.data[key].value;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     c = _a * _b;
83     assert(c / _a == _b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     assert(_b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = _a / _b;
93     assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
94     return _a / _b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     assert(_b <= _a);
102     return _a - _b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
109     c = _a + _b;
110     assert(c >= _a);
111     return c;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134   IterableMapping.itmap balances;
135 
136   uint256 internal totalSupply_;
137 
138   /**
139   * @dev Total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return totalSupply_;
143   }
144 
145   /**
146   * @dev Transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151       
152     require(_value <= IterableMapping.iterate_getValue(balances, msg.sender));
153     require(_to != address(0));
154     
155     IterableMapping.insert(balances, msg.sender, IterableMapping.iterate_getValue(balances, msg.sender).sub(_value));
156     IterableMapping.insert(balances, _to, IterableMapping.iterate_getValue(balances, _to).add(_value));
157     emit Transfer(msg.sender, _to, _value);
158     return true;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address.
163   * @param _owner The address to query the the balance of.
164   * @return An uint256 representing the amount owned by the passed address.
165   */
166   function balanceOf(address _owner) public view returns (uint256) {
167       return IterableMapping.iterate_getValue(balances, _owner);
168   }
169 
170 }
171 
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address _owner, address _spender)
180     public view returns (uint256);
181 
182   function transferFrom(address _from, address _to, uint256 _value)
183     public returns (bool);
184 
185   function approve(address _spender, uint256 _value) public returns (bool);
186   event Approval(
187     address indexed owner,
188     address indexed spender,
189     uint256 value
190   );
191 }
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/issues/20
198  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(
212     address _from,
213     address _to,
214     uint256 _value
215   )
216     public
217     returns (bool)
218   {
219       
220     require(_value <= IterableMapping.iterate_getValue(balances, _from));
221     // require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223     require(_to != address(0));
224 
225     IterableMapping.insert(balances, _from, IterableMapping.iterate_getValue(balances, _from).sub(_value));
226     IterableMapping.insert(balances, _to, IterableMapping.iterate_getValue(balances, _to).add(_value));
227     // balances[_from] = balances[_from].sub(_value);
228     // balances[_to] = balances[_to].add(_value);
229     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244     allowed[msg.sender][_spender] = _value;
245     emit Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(
256     address _owner,
257     address _spender
258    )
259     public
260     view
261     returns (uint256)
262   {
263     return allowed[_owner][_spender];
264   }
265 
266   /**
267    * @dev Increase the amount of tokens that an owner allowed to a spender.
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    */
275   function increaseApproval(
276     address _spender,
277     uint256 _addedValue
278   )
279     public
280     returns (bool)
281   {
282     allowed[msg.sender][_spender] = (
283       allowed[msg.sender][_spender].add(_addedValue));
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(
298     address _spender,
299     uint256 _subtractedValue
300   )
301     public
302     returns (bool)
303   {
304     uint256 oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue >= oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 contract IBRIDGE is StandardToken {
317     
318     string public name = "Bridge Protocol";
319     string public symbol = "BGPT";
320     uint8 public decimals = 18;
321     uint256 public INITIAL_SUPPLY = 10000000000 ether;
322 
323     constructor () public {
324     	totalSupply_ = INITIAL_SUPPLY;
325     	IterableMapping.insert(balances, tx.origin, INITIAL_SUPPLY);
326     }
327     
328     function balancesStart() public view returns(uint256) {
329         return IterableMapping.iterate_start(balances);
330     }
331     
332     function balancesGetBool(uint256 num) public view returns(bool){
333         return IterableMapping.iterate_valid(balances, num);
334     }
335     
336     function balancesGetNext(uint256 num) public view returns(uint256) {
337         return IterableMapping.iterate_next(balances, num);
338     }
339     
340     function balancesGetValue(uint256 num) public view returns(address, uint256) {
341         address key;                            
342         uint256 value;                          
343         (key, value) = IterableMapping.iterate_get(balances, num);
344         return (key, value);
345     }
346     
347 }