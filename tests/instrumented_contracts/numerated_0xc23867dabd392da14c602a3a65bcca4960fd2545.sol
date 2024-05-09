1 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 pragma solidity ^0.4.21;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
18 pragma solidity ^0.4.21;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     if (a == 0) {
32       return 0;
33     }
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
68 pragma solidity ^0.4.21;
69 
70 
71 
72 
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
120 pragma solidity ^0.4.21;
121 
122 
123 
124 
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  */
129 contract ERC20 is ERC20Basic {
130   function allowance(address owner, address spender) public view returns (uint256);
131   function transferFrom(address from, address to, uint256 value) public returns (bool);
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
137 pragma solidity ^0.4.21;
138 
139 
140 
141 
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     emit Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256) {
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
209   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 //File: contracts\ARTIDToken.sol
239 /**
240  * @title ParkinGO token
241  *
242  * @version 1.0
243  * @author ParkinGO
244  */
245 pragma solidity ^0.4.21;
246 
247 
248 
249 
250 
251 contract ARTIDToken is StandardToken {
252     using SafeMath for uint256;
253     
254     string public constant name = "ARTIDToken";
255     string public constant symbol = "ARTID";
256     uint8 public constant decimals = 18;
257     uint256 public constant INITIAL_SUPPLY = 120e6 * 1e18;
258     uint256 public constant Wallet_Initial_Supply = 12e6 * 1e18;
259     address public constant Wallet1 =address(0x5593105770Cd53802c067734d7e321E22E08C9a4);
260     //
261     address public constant Wallet2 =address(0x7003D8df7b38f4c758975fD4800574Fecc0DA7cd);
262     //
263     address public constant Wallet3 =address(0xDfdAA3B74fcc65b9E90d5922a74F8140A2b67d0f);
264     //
265     address public constant Wallet4 =address(0x0141f8d84F25739e426fd19783A1eC3A1f5a35e0);
266     //
267     address public constant Wallet5 =address(0x8863F676474C65E9B85dc2B7fEe16188503AE790);
268     //
269     address public constant Wallet6 =address(0xAbF2e86c69648E9ed6CD284f4f82dF3f9df7a3DD);
270     //
271     address public constant Wallet7 =address(0x66348c99019D6c21fe7c4f954Fd5A5Cb0b41aa2c);
272     //
273     address public constant Wallet8 =address(0x3257b7eBB5e52c67cdd0C1112b28db362b7463cD);
274     //
275     address public constant Wallet9 =address(0x0c26122396a4Bd59d855f19b69dADBa3B19BA4D7);
276     //
277     address public constant Wallet10=address(0x5b38E7b2C9aC03fA53E96220DCd299E3B47e1624);
278 
279     /**
280      * @dev Constructor of ArtToken that instantiates a new Mintable Pausable Token
281      */
282     constructor() public {
283         totalSupply_ = INITIAL_SUPPLY;
284         balances[Wallet1] = Wallet_Initial_Supply;
285         emit Transfer(0x0, Wallet1, Wallet_Initial_Supply);
286         balances[Wallet2] = Wallet_Initial_Supply;
287         emit Transfer(0x0, Wallet2, Wallet_Initial_Supply);
288         balances[Wallet3] = Wallet_Initial_Supply;
289         emit Transfer(0x0, Wallet3, Wallet_Initial_Supply);
290         balances[Wallet4] = Wallet_Initial_Supply;
291         emit Transfer(0x0, Wallet4, Wallet_Initial_Supply);
292         balances[Wallet5] = Wallet_Initial_Supply;
293         emit Transfer(0x0, Wallet5, Wallet_Initial_Supply);
294         balances[Wallet6] = Wallet_Initial_Supply;
295         emit Transfer(0x0, Wallet6, Wallet_Initial_Supply);
296         balances[Wallet7] = Wallet_Initial_Supply;
297         emit Transfer(0x0, Wallet7, Wallet_Initial_Supply);
298         balances[Wallet8] = Wallet_Initial_Supply;
299         emit Transfer(0x0, Wallet8, Wallet_Initial_Supply);
300         balances[Wallet9] = Wallet_Initial_Supply;
301         emit Transfer(0x0, Wallet9, Wallet_Initial_Supply);
302         balances[Wallet10] = Wallet_Initial_Supply;
303         emit Transfer(0x0, Wallet10, Wallet_Initial_Supply);
304 
305     }
306 
307 }