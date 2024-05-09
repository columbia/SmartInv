1 pragma solidity 0.4.20;
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
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 
217 
218 contract DeneumToken is StandardToken {
219     string public name = "Deneum";
220     string public symbol = "DNM";
221     uint8 public decimals = 2;
222     bool public mintingFinished = false;
223     mapping (address => bool) owners;
224     mapping (address => bool) minters;
225 
226     event Mint(address indexed to, uint256 amount);
227     event MintFinished();
228     event OwnerAdded(address indexed newOwner);
229     event OwnerRemoved(address indexed removedOwner);
230     event MinterAdded(address indexed newMinter);
231     event MinterRemoved(address indexed removedMinter);
232     event Burn(address indexed burner, uint256 value);
233 
234     function DeneumToken() public {
235         owners[msg.sender] = true;
236     }
237 
238     /**
239      * @dev Function to mint tokens
240      * @param _to The address that will receive the minted tokens.
241      * @param _amount The amount of tokens to mint.
242      * @return A boolean that indicates if the operation was successful.
243      */
244     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
245         require(!mintingFinished);
246         totalSupply_ = totalSupply_.add(_amount);
247         balances[_to] = balances[_to].add(_amount);
248         Mint(_to, _amount);
249         Transfer(address(0), _to, _amount);
250         return true;
251     }
252 
253     /**
254      * @dev Function to stop minting new tokens.
255      * @return True if the operation was successful.
256      */
257     function finishMinting() onlyOwner public returns (bool) {
258         require(!mintingFinished);
259         mintingFinished = true;
260         MintFinished();
261         return true;
262     }
263 
264     /**
265      * @dev Burns a specific amount of tokens.
266      * @param _value The amount of token to be burned.
267      */
268     function burn(uint256 _value) public {
269         require(_value <= balances[msg.sender]);
270         // no need to require value <= totalSupply, since that would imply the
271         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
272 
273         address burner = msg.sender;
274         balances[burner] = balances[burner].sub(_value);
275         totalSupply_ = totalSupply_.sub(_value);
276         Burn(burner, _value);
277         Transfer(burner, address(0), _value);
278     }
279 
280     /**
281      * @dev Adds administrative role to address
282      * @param _address The address that will get administrative privileges
283      */
284     function addOwner(address _address) onlyOwner public {
285         owners[_address] = true;
286         OwnerAdded(_address);
287     }
288 
289     /**
290      * @dev Removes administrative role from address
291      * @param _address The address to remove administrative privileges from
292      */
293     function delOwner(address _address) onlyOwner public {
294         owners[_address] = false;
295         OwnerRemoved(_address);
296     }
297 
298     /**
299      * @dev Throws if called by any account other than the owner.
300      */
301     modifier onlyOwner() {
302         require(owners[msg.sender]);
303         _;
304     }
305 
306     /**
307      * @dev Adds minter role to address (able to create new tokens)
308      * @param _address The address that will get minter privileges
309      */
310     function addMinter(address _address) onlyOwner public {
311         minters[_address] = true;
312         MinterAdded(_address);
313     }
314 
315     /**
316      * @dev Removes minter role from address
317      * @param _address The address to remove minter privileges
318      */
319     function delMinter(address _address) onlyOwner public {
320         minters[_address] = false;
321         MinterRemoved(_address);
322     }
323 
324     /**
325      * @dev Throws if called by any account other than the minter.
326      */
327     modifier onlyMinter() {
328         require(minters[msg.sender]);
329         _;
330     }
331 }