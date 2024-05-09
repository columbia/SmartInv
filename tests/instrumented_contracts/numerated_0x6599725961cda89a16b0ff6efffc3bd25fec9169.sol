1 pragma solidity ^0.4.21 ;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 contract Ownable {
19   address public owner;
20 
21 
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() public {
30     owner = msg.sender;
31   }
32 
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     emit Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     emit Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifying the amount of tokens still available for the spender.
160    */
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166    * @dev Increase the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To increment
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _addedValue The amount of tokens to increase the allowance by.
174    */
175   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   /**
182    * @dev Decrease the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To decrement
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _subtractedValue The amount of tokens to decrease the allowance by.
190    */
191   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202 }
203 
204 
205 contract OG is Ownable , StandardToken {
206 ////////////////////////////////
207   string public constant name = "OnlyGame Token";
208   string public constant symbol = "OG";
209   uint8 public constant decimals = 18;
210   uint256 public constant totalsum =  1000000000 * 10 ** uint256(decimals);
211   ////////////////////////////////
212   address public crowdSaleAddress;
213   bool public locked;
214 ////////////////////////////////
215   uint256 public __price = (1 ether / 20000  )   ;
216 ////////////////////////////////
217   function OG() public {
218       crowdSaleAddress = msg.sender;
219        unlock(); 
220       totalSupply = totalsum;  // Update total supply with the decimal amount * 10 ** uint256(decimals)
221       balances[msg.sender] = totalSupply; 
222   }
223 ////////////////////////////////
224   // allow burning of tokens only by authorized users 
225   modifier onlyAuthorized() {
226       if (msg.sender != owner && msg.sender != crowdSaleAddress) 
227           revert();
228       _;
229   }
230 ////////////////////////////////
231   function priceof() public view returns(uint256) {
232     return __price;
233   }
234 ////////////////////////////////
235   function updateCrowdsaleAddress(address _crowdSaleAddress) public onlyOwner() {
236     require(_crowdSaleAddress != address(0));
237     crowdSaleAddress = _crowdSaleAddress; 
238   }
239 ////////////////////////////////
240   function updatePrice(uint256 price_) public onlyOwner() {
241     require( price_ > 0);
242     __price = price_; 
243   }
244 ////////////////////////////////
245   function unlock() public onlyAuthorized {
246       locked = false;
247   }
248   function lock() public onlyAuthorized {
249       locked = true;
250   }
251 ////////////////////////////////
252   function toEthers(uint256 tokens) public view returns(uint256) {
253     return tokens.mul(__price) / ( 10 ** uint256(decimals));
254   }
255   function fromEthers(uint256 ethers) public view returns(uint256) {
256     return ethers.div(__price) * 10 ** uint256(decimals);
257   }
258 ////////////////////////////////
259   function returnTokens(address _member, uint256 _value) public onlyAuthorized returns(bool) {
260         balances[_member] = balances[_member].sub(_value);
261         balances[crowdSaleAddress] = balances[crowdSaleAddress].add(_value);
262         emit  Transfer(_member, crowdSaleAddress, _value);
263         return true;
264   }
265 ////////////////////////////////
266   function buyOwn(address recipient, uint256 ethers) public payable onlyOwner returns(bool) {
267     return mint(recipient, fromEthers(ethers));
268   }
269   function mint(address to, uint256 amount) public onlyOwner returns(bool)  {
270     require(to != address(0) && amount > 0);
271     totalSupply = totalSupply.add(amount);
272     balances[to] = balances[to].add(amount );
273     emit Transfer(address(0), to, amount);
274     return true;
275   }
276   function burn(address from, uint256 amount) public onlyOwner returns(bool) {
277     require(from != address(0) && amount > 0);
278     balances[from] = balances[from].sub(amount );
279     totalSupply = totalSupply.sub(amount );
280     emit Transfer(from, address(0), amount );
281     return true;
282   }
283   function sell(address recipient, uint256 tokens) public payable onlyOwner returns(bool) {
284     burn(recipient, tokens);
285     recipient.transfer(toEthers(tokens));
286   }
287 ////////////////////////////////
288   function mintbuy(address to, uint256 amount) public  returns(bool)  {
289     require(to != address(0) && amount > 0);
290     totalSupply = totalSupply.add(amount );
291     balances[to] = balances[to].add(amount );
292     emit Transfer(address(0), to, amount );
293     return true;
294   }
295    function buy(address recipient) public payable returns(bool) {
296     return mintbuy(recipient, fromEthers(msg.value));
297   }
298 
299 ////////////////////////////////
300   function() public payable {
301     buy(msg.sender);
302   }
303 
304  
305 }