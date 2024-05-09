1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 
41 
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 
57 
58 
59 
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 
119 
120 
121 /**
122  * @title Ownable
123  * @dev The Ownable contract has an owner address, and provides basic authorization control
124  * functions, this simplifies the implementation of "user permissions".
125  */
126 contract Ownable {
127   address public owner;
128 
129 
130   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132 
133   /**
134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135    * account.
136    */
137   function Ownable() public {
138     owner = msg.sender;
139   }
140 
141 
142   /**
143    * @dev Throws if called by any account other than the owner.
144    */
145   modifier onlyOwner() {
146     require(msg.sender == owner);
147     _;
148   }
149 
150 
151   /**
152    * @dev Allows the current owner to transfer control of the contract to a newOwner.
153    * @param newOwner The address to transfer ownership to.
154    */
155   function transferOwnership(address newOwner) public onlyOwner {
156     require(newOwner != address(0));
157     OwnershipTransferred(owner, newOwner);
158     owner = newOwner;
159   }
160 
161 }
162 
163 
164 
165 
166 
167 
168 
169 
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
177  */
178 contract StandardToken is ERC20, BasicToken {
179 
180   mapping (address => mapping (address => uint256)) internal allowed;
181 
182 
183   /**
184    * @dev Transfer tokens from one address to another
185    * @param _from address The address which you want to send tokens from
186    * @param _to address The address which you want to transfer to
187    * @param _value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[_from]);
192     require(_value <= allowed[_from][msg.sender]);
193 
194     balances[_from] = balances[_from].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
197     Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    *
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) public returns (bool) {
212     allowed[msg.sender][_spender] = _value;
213     Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(address _owner, address _spender) public view returns (uint256) {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _addedValue The amount of tokens to increase the allowance by.
236    */
237   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
238     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
239     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243   /**
244    * @dev Decrease the amount of tokens that an owner allowed to a spender.
245    *
246    * approve should be called when allowed[_spender] == 0. To decrement
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _subtractedValue The amount of tokens to decrease the allowance by.
252    */
253   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264 }
265 
266 
267 
268 
269 
270 
271 
272 contract Seed is StandardToken, Ownable {
273     string public name = "Seed";
274     string public sybmol = "Seed";
275     address public flowerContract;
276 
277     function Seed(uint initSupply) public {
278         totalSupply = initSupply*(10**18);
279         balances[msg.sender] = totalSupply;
280     }
281 
282     function setFlowerContract(address flower) onlyOwner public {
283         require(flowerContract == 0);
284         flowerContract = flower;
285     }
286 
287     function transformSeedToFlower(address user, uint seed) public {
288         require(msg.sender != 0);
289         require(msg.sender == flowerContract);
290         require(balances[user] >= seed*(10**18));
291 
292         balances[user] -= seed*(10**18);
293         balances[msg.sender] += seed*(10**18);
294     }
295 
296     event WithdrawFee(uint balance);
297     /**
298         将现金提取到owner地址
299      */
300     function withdrawFee() public onlyOwner {
301         require(this.balance > 0);
302         owner.transfer(this.balance);
303         WithdrawFee(this.balance);
304     }
305 }