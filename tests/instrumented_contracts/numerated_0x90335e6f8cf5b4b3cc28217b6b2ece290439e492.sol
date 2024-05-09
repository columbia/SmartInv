1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 /**
15  * @title Basic token
16  * @dev Basic version of StandardToken, with no allowances.
17  */
18 contract BasicToken is ERC20Basic {
19   using SafeMath for uint256;
20 
21   mapping(address => uint256) balances;
22 
23   uint256 totalSupply_;
24 
25   /**
26   * @dev total number of tokens in existence
27   */
28   function totalSupply() public view returns (uint256) {
29     return totalSupply_;
30   }
31 
32   /**
33   * @dev transfer token for a specified address
34   * @param _to The address to transfer to.
35   * @param _value The amount to be transferred.
36   */
37   function transfer(address _to, uint256 _value) public returns (bool) {
38     require(_to != address(0));
39     require(_value <= balances[msg.sender]);
40 
41     // SafeMath.sub will throw if there is not enough balance.
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param _owner The address to query the the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address _owner) public view returns (uint256 balance) {
54     return balances[_owner];
55   }
56 
57 }
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) public view returns (uint256);
64   function transferFrom(address from, address to, uint256 value) public returns (bool);
65   function approve(address spender, uint256 value) public returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 /**
69  * @title Standard ERC20 token
70  *
71  * @dev Implementation of the basic standard token.
72  * @dev https://github.com/ethereum/EIPs/issues/20
73  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
74  */
75 contract StandardToken is ERC20, BasicToken {
76 
77   mapping (address => mapping (address => uint256)) internal allowed;
78 
79 
80   /**
81    * @dev Transfer tokens from one address to another
82    * @param _from address The address which you want to send tokens from
83    * @param _to address The address which you want to transfer to
84    * @param _value uint256 the amount of tokens to be transferred
85    */
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[_from]);
89     require(_value <= allowed[_from][msg.sender]);
90 
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
100    *
101    * Beware that changing an allowance with this method brings the risk that someone may use both the old
102    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
103    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
104    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105    * @param _spender The address which will spend the funds.
106    * @param _value The amount of tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) public returns (bool) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifying the amount of tokens still available for the spender.
119    */
120   function allowance(address _owner, address _spender) public view returns (uint256) {
121     return allowed[_owner][_spender];
122   }
123 
124   /**
125    * @dev Increase the amount of tokens that an owner allowed to a spender.
126    *
127    * approve should be called when allowed[_spender] == 0. To increment
128    * allowed value is better to use this function to avoid 2 calls (and wait until
129    * the first transaction is mined)
130    * From MonolithDAO Token.sol
131    * @param _spender The address which will spend the funds.
132    * @param _addedValue The amount of tokens to increase the allowance by.
133    */
134   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140   /**
141    * @dev Decrease the amount of tokens that an owner allowed to a spender.
142    *
143    * approve should be called when allowed[_spender] == 0. To decrement
144    * allowed value is better to use this function to avoid 2 calls (and wait until
145    * the first transaction is mined)
146    * From MonolithDAO Token.sol
147    * @param _spender The address which will spend the funds.
148    * @param _subtractedValue The amount of tokens to decrease the allowance by.
149    */
150   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
151     uint oldValue = allowed[msg.sender][_spender];
152     if (_subtractedValue > oldValue) {
153       allowed[msg.sender][_spender] = 0;
154     } else {
155       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156     }
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161 }
162 library SafeMath {
163 
164   /**
165   * @dev Multiplies two numbers, throws on overflow.
166   */
167   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168     if (a == 0) {
169       return 0;
170     }
171     uint256 c = a * b;
172     assert(c / a == b);
173     return c;
174   }
175 
176   /**
177   * @dev Integer division of two numbers, truncating the quotient.
178   */
179   function div(uint256 a, uint256 b) internal pure returns (uint256) {
180     // assert(b > 0); // Solidity automatically throws when dividing by 0
181     uint256 c = a / b;
182     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183     return c;
184   }
185 
186   /**
187   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
188   */
189   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190     assert(b <= a);
191     return a - b;
192   }
193 
194   /**
195   * @dev Adds two numbers, throws on overflow.
196   */
197   function add(uint256 a, uint256 b) internal pure returns (uint256) {
198     uint256 c = a + b;
199     assert(c >= a);
200     return c;
201   }
202 }
203 
204 contract DragonCoin is StandardToken {
205     using SafeMath for uint256;
206     
207     event Mint(address indexed to, uint256 value);
208     event Burn(address indexed burner, uint256 value);
209     
210     string public name = "DragonGameCoin"; 
211     string public symbol = "DGC";
212     uint public decimals = 18;
213     uint public INITIAL_SUPPLY = 1000000 * (10 ** decimals);     
214     uint public MAX_SUPPLY = 10 * 100000000 * (10 ** decimals); 
215     address public ceo;
216     address public coo;
217     address public cfo;
218 
219     function DragonCoin() {
220         totalSupply_ = INITIAL_SUPPLY;
221         balances[msg.sender] = INITIAL_SUPPLY;
222         ceo = msg.sender;
223         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
224     }
225     
226     function setCEO(address newCEO) public onlyCEO{
227         require(newCEO != address(0));
228         
229         ceo = newCEO;
230     }
231     
232     function setCOO(address newCOO) public onlyCEO{
233         require(newCOO != address(0));
234         
235         coo = newCOO;
236     }
237     
238     function setCFO(address newCFO) public onlyCEO{
239         require(newCFO != address(0));
240         
241         cfo = newCFO;
242     }
243     
244     function mint(uint256 value) public onlyCFO returns (bool) {
245         require(totalSupply_.add(value) <= MAX_SUPPLY);
246         
247         balances[cfo] = balances[cfo].add(value);
248         totalSupply_ = totalSupply_.add(value);
249         
250         // mint event
251         Mint(cfo, value);
252         Transfer(0x0, cfo, value);
253         return true;
254     }
255     
256     function burn(uint256 value) public onlyCOO returns (bool) {
257         require(balances[coo] >= value); 
258         
259         balances[coo] = balances[coo].sub(value);
260         totalSupply_ = totalSupply_.sub(value);
261         
262         // burn event
263         Burn(coo, value);
264         Transfer(coo, 0x0, value);
265         return true;
266     }
267     
268     
269     /// @dev Access modifier for CEO-only functionality
270     modifier onlyCEO() {
271         require(msg.sender == ceo);
272         _;
273     }
274     
275     /// @dev Access modifier for CFO-only functionality
276     modifier onlyCFO() {
277         require(msg.sender == cfo);
278         _;
279     }
280     
281     /// @dev Access modifier for COO-only functionality
282     modifier onlyCOO() {
283         require(msg.sender == coo);
284         _;
285     }
286     
287     
288 }