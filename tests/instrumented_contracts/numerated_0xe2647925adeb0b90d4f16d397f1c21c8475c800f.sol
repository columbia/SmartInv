1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     if (_a == 0) {
10       return 0;
11     }
12 
13     c = _a * _b;
14     assert(c / _a == _b);
15     return c;
16   }
17 
18   /**
19   * Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     return _a / _b;
23   }
24 
25   /**
26   * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     assert(_b <= _a);
30     return _a - _b;
31   }
32 
33   /**
34   *  Adds two numbers, throws on overflow.
35   */
36   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
37     c = _a + _b;
38     assert(c >= _a);
39     return c;
40   }
41 }
42 
43 contract ERC20 {
44   uint256 public totalSupply;
45 
46   function balanceOf(address _who) public view returns (uint256);
47 
48   function allowance(address _owner, address _spender) public view returns (uint256);
49 
50   function transfer(address _to, uint256 _value) public returns (bool);
51 
52   function approve(address _spender, uint256 _value) public returns (bool);
53 
54   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
55 
56   event Transfer( address indexed from, address indexed to,  uint256 value);
57 
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 
60   event Burn(address indexed from, uint256 value);
61 }
62 
63 
64 contract StandardToken is ERC20 {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68   mapping (address => mapping (address => uint256)) internal allowed;
69   mapping(string => address) username;
70   
71 
72   mapping(address => uint256) allowedMiner;
73   mapping(bytes32 => uint256) tradeID;
74 
75   //setting
76   bool public enable = true;
77   bytes32 public uniqueStr = 0x736363745f756e697175655f6964000000000000000000000000000000000000;
78   address public admin = 0x441b8F00004620F4D39359D1f0C20Ae971988DE8;
79   address public admin0x0 = 0x441b8F00004620F4D39359D1f0C20Ae971988DE8;
80   address public commonAdmin = 0x441b8F00004620F4D39359D1f0C20Ae971988DE8;
81   address public feeBank = 0x17C71f69972536a552B4b43f7F7187FcF530140c;
82   uint256 public systemFee = 4000;
83 
84 
85   /**
86   * Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94   /**
95    *  Function to check the amount of tokens that an owner allowed to a spender.
96    * @param _owner address The address which owns the funds.
97    * @param _spender address The address which will spend the funds.
98    * @return A uint256 specifying the amount of tokens still available for the spender.
99    */
100   function allowance(address _owner, address _spender) public view returns (uint256){
101     return allowed[_owner][_spender];
102   }
103 
104   /**
105   * Transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(enable == true);
111     require(_value <= balances[msg.sender]);
112     require(_to != address(0));
113 
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     allowed[msg.sender][_spender] = _value;
122     emit Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   /**
127    *  Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135     require(_to != address(0));
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * Increase the amount of tokens that an owner allowed to a spender.
146    * approve should be called when allowed[_spender] == 0. To increment
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * @param _spender The address which will spend the funds.
150    * @param _addedValue The amount of tokens to increase the allowance by.
151    */
152   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
153     allowed[msg.sender][_spender] = (
154     allowed[msg.sender][_spender].add(_addedValue));
155     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   /**
160    *  Decrease the amount of tokens that an owner allowed to a spender.
161    * approve should be called when allowed[_spender] == 0. To decrement
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * @param _spender The address which will spend the funds.
165    * @param _subtractedValue The amount of tokens to decrease the allowance by.
166    */
167   function decreaseApproval(address _spender,  uint256 _subtractedValue) public returns (bool) {
168     uint256 oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue >= oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178    /**
179      * Destroy tokens
180      *
181      * Remove `_value` tokens from the system irreversibly
182      *
183      * @param _value the amount of money to burn
184      */
185     function burn(uint256 _value) public returns (bool success) {
186         require(balances[msg.sender] >= _value);
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         totalSupply = totalSupply.sub(_value);
189         emit Burn(msg.sender, _value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) public returns (bool success) {
202         require(balances[_from] >= _value);
203         require(_value <= allowed[_from][msg.sender]);
204         balances[_from] = balances[_from].sub(_value);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206         totalSupply = totalSupply.sub(_value);
207         emit Burn(_from, _value);
208         return true;
209     }
210 
211     //Other
212     function setAdmin(address _address) public {
213         require(msg.sender == admin);
214         admin = _address;
215     }
216     
217     function setAdmin0x0(address _address) public {
218         require(msg.sender == admin);
219         admin0x0 = _address;
220     }
221     
222     function setCommonAdmin(address _address) public {
223         require(msg.sender == admin);
224         commonAdmin = _address;
225     }
226 
227     function setSystemFee(uint256 _value) public {
228         require(msg.sender == commonAdmin);
229         systemFee = _value;
230     }
231 
232     function setFeeBank(address _address) public {
233         require(msg.sender == commonAdmin);
234         feeBank = _address;
235     }
236     
237     function setEnable(bool _status) public {
238         require(msg.sender == commonAdmin);
239         enable = _status;
240     }
241 
242     function setUsername(address _address, string _username) public {
243         require(msg.sender == commonAdmin);
244         username[_username] = _address;
245     }
246 
247     function addMiner(address _address) public {
248         require(msg.sender == commonAdmin);
249         allowedMiner[_address] = 1;
250     }
251 
252     function removeMiner(address _address) public {
253         require(msg.sender == commonAdmin);
254         allowedMiner[_address] = 0;
255     }
256 
257     function checkTradeID(bytes32 _tid) public view returns (uint256){
258         return tradeID[_tid];
259     }
260 
261     function getMinerStatus(address _owner) public view returns (uint256) {
262         return allowedMiner[_owner];
263     }
264 
265     function getUsername(string _username) public view returns (address) {
266         return username[_username];
267     }
268 
269     function transferBySystem(uint256 _expire, bytes32 _tid, address _from, address _to, uint256 _value, uint8 _v, bytes32 _r, bytes32 _s) public returns (bool) {
270         require(allowedMiner[msg.sender] == 1);
271         require(tradeID[_tid] == 0);
272         require(_from != _to);
273         
274         //check exipre
275         uint256 maxExpire = _expire.add(86400);
276         require(maxExpire >= block.timestamp);
277         
278         //check value
279         uint256 totalPay = _value.add(systemFee);
280         require(balances[_from] >= totalPay);
281 
282         //create hash
283         bytes32 hash = keccak256(
284           abi.encodePacked(_expire, uniqueStr, _tid, _from, _to, _value)
285         );
286 
287         //check hash isValid
288         address theAddress = ecrecover(hash, _v, _r, _s);
289         require(theAddress == _from);
290         
291         //set tradeID
292         tradeID[_tid] = 1;
293         
294         //sub value
295         balances[_from] = balances[_from].sub(totalPay);
296 
297         //add fee
298         balances[feeBank] = balances[feeBank].add(systemFee);
299 
300         //add value
301         balances[_to] = balances[_to].add(_value);
302 
303         emit Transfer(_from, _to, _value);
304         emit Transfer(_from, feeBank, systemFee);
305 
306         return true;
307     }
308     
309     function draw0x0(address _to, uint256 _value) public returns (bool) {
310         require(msg.sender == admin0x0);
311         require(_value <= balances[address(0)]);
312     
313         balances[address(0)] = balances[address(0)].sub(_value);
314         balances[_to] = balances[_to].add(_value);
315         emit Transfer(address(0), _to, _value);
316 
317         return true;
318     }
319 
320     function doAirdrop(address[] _dests, uint256[] _values) public returns (bool) {
321         require(_dests.length == _values.length);
322 
323         uint256 i = 0;
324         while (i < _dests.length) {
325             require(balances[msg.sender] >= _values[i]);
326             require(_dests[i] != address(0));
327 
328             balances[msg.sender] = balances[msg.sender].sub(_values[i]);
329             balances[_dests[i]] = balances[_dests[i]].add(_values[i]);
330             emit Transfer(msg.sender, _dests[i], _values[i]);
331 
332             i += 1;
333         }
334 
335         return true;
336     }
337 
338 }
339 
340 contract SCCTERC20 is StandardToken {
341     // Public variables of the token
342     string public name = "Smart Cash Coin Tether";
343     string public symbol = "SCCT";
344     uint8 constant public decimals = 4;
345     uint256 constant public initialSupply = 100000000;
346 
347     constructor() public {
348         totalSupply = initialSupply * 10 ** uint256(decimals);
349         balances[msg.sender] = totalSupply;
350         allowedMiner[0x222dAa632Af2D8EB82e091318A6bC7404E3cC980] = 1;
351         allowedMiner[0x887f8EEB3F011ddC9C38580De7380b3c033483Ad] = 1;
352         emit Transfer(address(0), msg.sender, totalSupply);
353     }
354 }