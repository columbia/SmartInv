1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   /**
62   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 contract ERC20Basic {
80   function totalSupply() public view returns (uint256);
81   function balanceOf(address who) public view returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     // SafeMath.sub will throw if there is not enough balance.
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256 balance) {
121     return balances[_owner];
122   }
123 
124 }
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) public view returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     emit Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     emit Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 contract MintableToken is StandardToken, Ownable {
219   event Mint(address indexed to, uint256 amount);
220   event MintFinished();
221 
222   bool public mintingFinished = false;
223 
224 
225   modifier canMint() {
226     require(!mintingFinished);
227     _;
228   }
229 
230   /**
231    * @dev Function to mint tokens
232    * @param _to The address that will receive the minted tokens.
233    * @param _amount The amount of tokens to mint.
234    * @return A boolean that indicates if the operation was successful.
235    */
236   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
237     totalSupply_ = totalSupply_.add(_amount);
238     balances[_to] = balances[_to].add(_amount);
239     emit Mint(_to, _amount);
240     emit Transfer(address(0), _to, _amount);
241     return true;
242   }
243 
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248   function finishMinting() onlyOwner canMint public returns (bool) {
249     mintingFinished = true;
250     emit MintFinished();
251     return true;
252   }
253 }
254 contract BurnableToken is MintableToken {
255 
256   event Burn(address indexed burner, uint256 value);
257 
258   /**
259    * @dev Burns a specific amount of tokens.
260    * @param _value The amount of token to be burned.
261    */
262   function burn(uint256 _value) public {
263     require(_value <= balances[msg.sender]);
264     // no need to require value <= totalSupply, since that would imply the
265     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
266 
267     address burner = msg.sender;
268     balances[burner] = balances[burner].sub(_value);
269     totalSupply_ = totalSupply_.sub(_value);
270     emit Burn(burner, _value);
271     emit Transfer(burner, address(0), _value);
272   }
273 }
274 
275 contract PPToken is BurnableToken{
276     using SafeMath for uint256;
277     
278     string public constant name = "PayPortalToken";
279     
280     string public constant symbol = "PPTL";
281     
282     uint32 public constant decimals = 18;
283     
284     uint256 public freezTime;
285     
286     address internal saleAgent;
287     
288     mapping(address => uint256) preSaleBalances;
289     
290     event PreSaleTransfer(address indexed from, address indexed to, uint256 value);
291     
292     
293     function PPToken(uint256 initialSupply, uint256 _freezTime) public{
294         require(initialSupply > 0 && now <= _freezTime);
295         totalSupply_ = initialSupply * 10 ** uint256(decimals);
296         balances[owner] = totalSupply_;
297         emit Mint(owner, totalSupply_);
298         emit Transfer(0x0, owner, totalSupply_);
299         freezTime = _freezTime;
300         saleAgent = owner;
301     }
302     /*
303     function PPToken() public{
304         uint256 initialSupply = 20000;
305         uint256 _freezTime = now + (10 minutes);
306         
307         require(initialSupply > 0 && now <= _freezTime);
308         totalSupply_ = initialSupply * 10 ** uint256(decimals);
309         balances[owner] = totalSupply_;
310         emit Mint(owner, totalSupply_);
311         emit Transfer(0x0, owner, totalSupply_);
312         freezTime = _freezTime;
313         saleAgent = owner;
314     }
315     */
316     modifier onlySaleAgent() {
317         require(msg.sender == saleAgent);
318         _;
319     }
320     
321     function burnRemain() public onlySaleAgent {
322         uint256 _remSupply = balances[owner];
323         balances[owner] = 0;
324         totalSupply_ = totalSupply_.sub(_remSupply);
325 
326         emit Burn(owner, _remSupply);
327         emit Transfer(owner, address(0), _remSupply);
328         
329         mintingFinished = true;
330         emit MintFinished();
331     }
332     
333     function setSaleAgent(address _saleAgent) public onlyOwner{
334         require(_saleAgent != address(0));
335         saleAgent = _saleAgent;
336     }
337     function setFreezTime(uint256 _freezTime) public onlyOwner{
338         freezTime = _freezTime;
339     }
340     function saleTokens(address _to, uint256 _value) public onlySaleAgent returns (bool)
341     {
342         require(_to != address(0));
343         require(_value <= balances[owner]);
344     
345         // SafeMath.sub will throw if there is not enough balance.
346         balances[owner] = balances[owner].sub(_value);
347         
348         if(now > freezTime){
349             balances[_to] = balances[_to].add(_value);
350         }
351         else{
352             preSaleBalances[_to] = preSaleBalances[_to].add(_value);
353         }
354         emit Transfer(msg.sender, _to, _value);
355         return true;
356     }
357     
358     function preSaleBalancesOf(address _owner) public view returns (uint256)
359     {
360         return preSaleBalances[_owner];
361     }
362     
363     function transferPreSaleBalance(address _to, uint256 _value)public returns (bool){
364         require(now > freezTime);
365         require(_to != address(0));
366         require(_value <= preSaleBalances[msg.sender]);
367         preSaleBalances[msg.sender] = preSaleBalances[msg.sender].sub(_value);
368         balances[_to] = balances[_to].add(_value);
369         emit Transfer(msg.sender, _to, _value);
370         return true;
371     }
372 }