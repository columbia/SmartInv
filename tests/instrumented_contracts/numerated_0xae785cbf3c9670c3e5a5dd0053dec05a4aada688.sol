1 pragma solidity ^0.4.23;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
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
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender)
72     public view returns (uint256);
73 
74   function transferFrom(address from, address to, uint256 value)
75     public returns (bool);
76 
77   function approve(address spender, uint256 value) public returns (bool);
78   event Approval(
79     address indexed owner,
80     address indexed spender,
81     uint256 value
82   );
83 }
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   uint256 totalSupply_;
95 
96   /**
97   * @dev total number of tokens in existence
98   */
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender]);
111 
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     emit Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152     public
153     returns (bool)
154   {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(
210     address _spender,
211     uint _addedValue
212   )
213     public
214     returns (bool)
215   {
216     allowed[msg.sender][_spender] = (
217       allowed[msg.sender][_spender].add(_addedValue));
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseApproval(
233     address _spender,
234     uint _subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 /*
252 The Supreme Organ and Principle Master Trustee of “The NExT Foundation Trust”, 
253 a Supra Inter-Vivos Special Purpose Investment Foundation Trust, Settled in 
254 the Isle of Man has commissioned SovTech to originate and create a NExT Coin 
255 Smart-Contract Blockchain under the International Collective ICON “NTX” and 
256 all-inclusive collective Brand Name of The ‘NExT’ Ecosystem, ‘NExT’ Labs, 
257 ‘NExT’ Finance, NExT Financial, ‘NExT’ Liquid, ‘NExT’ Trade, ‘NExT Securities, 
258 ‘NExT’ Cryptos, ‘NExT’ Exchange, ‘NExT’ Coin, ‘NExT’ Emporium, and ‘NExT’ Labs 
259 Media…with a Max Issuance of 105,000,000,000 NTX COINs to be re-entrusted to 
260 The NExT Foundation Trust at a zero nominal value so that The NExT Foundation 
261 Trust under law and obligation will further allot, assign and send, (“AJA 
262 Apostille – Authenticate, Legalize and Notarize”) the 371 subscribers in ratio 
263 and proportion their Prestigiously Subscribed NTX Coins Wallets as per their 
264 individual ‘Public Key’ as original first issue registered hereto submitted 
265 and attached marked Annexure NTX 105B dated 28 June 2018.
266 */
267 
268 contract NExT is StandardToken {
269   string public constant name = 'NExT';
270   string public constant symbol = 'NTX';
271   uint8 public constant decimals = 0;
272   uint256 public totalSupply = 105000000000;
273   constructor(){
274     balances[msg.sender] = totalSupply;
275   }
276 }