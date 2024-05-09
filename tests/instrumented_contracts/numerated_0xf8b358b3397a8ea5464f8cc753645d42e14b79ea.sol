1 pragma solidity ^0.4.19;
2 
3 
4 contract OwnableToken {
5     mapping (address => bool) owners;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8     event OwnershipExtended(address indexed host, address indexed guest);
9 
10     modifier onlyOwner() {
11         require(owners[msg.sender]);
12         _;
13     }
14 
15     function OwnableToken() public {
16         owners[msg.sender] = true;
17     }
18 
19     function addOwner(address guest) public onlyOwner {
20         require(guest != address(0));
21         owners[guest] = true;
22         emit OwnershipExtended(msg.sender, guest);
23     }
24 
25     function transferOwnership(address newOwner) public onlyOwner {
26         require(newOwner != address(0));
27         owners[newOwner] = true;
28         delete owners[msg.sender];
29         emit OwnershipTransferred(msg.sender, newOwner);
30     }
31 }
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) internal allowed;
162 
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174 
175     balances[_from] = balances[_from].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178     Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184    *
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(address _owner, address _spender) public view returns (uint256) {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
219     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
234   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 
248 contract ABL is StandardToken, OwnableToken {
249     using SafeMath for uint256;
250 
251     // Token Distribution Rate
252     uint256 public constant SUM = 400000000;   // totalSupply
253     uint256 public constant DISTRIBUTION = 221450000; // distribution
254     uint256 public constant DEVELOPERS = 178550000;   // developer
255 
256     // Token Information
257     string public constant name = "Airbloc";
258     string public constant symbol = "ABL";
259     uint256 public constant decimals = 18;
260     uint256 public totalSupply = SUM.mul(10 ** uint256(decimals));
261 
262     // token is non-transferable until owner calls unlock()
263     // (to prevent OTC before the token to be listed on exchanges)
264     bool isTransferable = false;
265 
266     function ABL(
267         address _dtb,
268         address _dev
269         ) public {
270         require(_dtb != address(0));
271         require(_dev != address(0));
272         require(DISTRIBUTION + DEVELOPERS == SUM);
273 
274         balances[_dtb] = DISTRIBUTION.mul(10 ** uint256(decimals));
275         emit Transfer(address(0), _dtb, balances[_dtb]);
276 
277         balances[_dev] = DEVELOPERS.mul(10 ** uint256(decimals));
278         emit Transfer(address(0), _dev, balances[_dev]);
279     }
280 
281     function unlock() external onlyOwner {
282         isTransferable = true;
283     }
284 
285     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
286         require(isTransferable || owners[msg.sender]);
287         return super.transferFrom(_from, _to, _value);
288     }
289 
290     function transfer(address _to, uint256 _value) public returns (bool) {
291         require(isTransferable || owners[msg.sender]);
292         return super.transfer(_to, _value);
293     }
294 
295 //////////////////////
296 //  mint and burn   //
297 //////////////////////
298     function mint(
299         address _to,
300         uint256 _amount
301         ) onlyOwner public returns (bool) {
302         require(_to != address(0));
303         require(_amount >= 0);
304 
305         uint256 amount = _amount.mul(10 ** uint256(decimals));
306 
307         totalSupply = totalSupply.add(amount);
308         balances[_to] = balances[_to].add(amount);
309 
310         emit Mint(_to, amount);
311         emit Transfer(address(0), _to, amount);
312 
313         return true;
314     }
315 
316     function burn(
317         uint256 _amount
318         ) onlyOwner public {
319         require(_amount >= 0);
320         require(_amount <= balances[msg.sender]);
321 
322         totalSupply = totalSupply.sub(_amount.mul(10 ** uint256(decimals)));
323         balances[msg.sender] = balances[msg.sender].sub(_amount.mul(10 ** uint256(decimals)));
324 
325         emit Burn(msg.sender, _amount.mul(10 ** uint256(decimals)));
326         emit Transfer(msg.sender, address(0), _amount.mul(10 ** uint256(decimals)));
327     }
328 
329     event Mint(address indexed _to, uint256 _amount);
330     event Burn(address indexed _from, uint256 _amount);
331 }