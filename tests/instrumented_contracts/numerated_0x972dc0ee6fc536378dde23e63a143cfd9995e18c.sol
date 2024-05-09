1 pragma solidity ^0.4.24;
2 
3 /*
4 https://donutchain.io/
5 
6   WARNING
7 
8   All users are forbidden to interact with this contract 
9   if this contract is inconflict with user’s local regulations and laws.  
10 
11   DonutChain - is a game designed to explore human behavior 
12   via  token redistribution through open source smart contract code and pre-defined rules.
13   
14   This system is for internal use only 
15   and all could be lost  by sending anything to this contract address.
16   
17   No one can change anything once the contract has been deployed.
18 */
19 
20 /**
21  * @title Standard ERC20 token
22  *
23  * @dev Implementation of the basic standard token.
24  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
25  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
26  */
27 contract ERC20 {
28 
29   using SafeMath for uint256;
30 
31   event Transfer(
32     address indexed from,
33     address indexed to,
34     uint256 value
35   );
36 
37   event Approval(
38     address indexed owner,
39     address indexed spender,
40     uint256 value
41   );
42   
43   mapping (address => uint256) private balances_;
44 
45   mapping (address => mapping (address => uint256)) private allowed_;
46 
47   uint256 private totalSupply_;
48 
49   /**
50   * @dev Total number of tokens in existence
51   */
52   function totalSupply() public view returns (uint256) {
53     return totalSupply_;
54   }
55 
56   /**
57   * @dev Gets the balance of the specified address.
58   * @param _owner The address to query the the balance of.
59   * @return An uint256 representing the amount owned by the passed address.
60   */
61   function balanceOf(address _owner) public view returns (uint256) {
62     return balances_[_owner];
63   }
64 
65   /**
66    * @dev Function to check the amount of tokens that an owner allowed to a spender.
67    * @param _owner address The address which owns the funds.
68    * @param _spender address The address which will spend the funds.
69    * @return A uint256 specifying the amount of tokens still available for the spender.
70    */
71   function allowance(
72     address _owner,
73     address _spender
74    )
75     external
76     view
77     returns (uint256)
78   {
79     return allowed_[_owner][_spender];
80   }
81 
82   /**
83   * @dev Transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) external returns (bool) {
88     require(_value <= balances_[msg.sender]);
89     require(_to != address(0));
90 
91     balances_[msg.sender] = balances_[msg.sender].sub(_value);
92     balances_[_to] = balances_[_to].add(_value);
93     emit Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    * Beware that changing an allowance with this method brings the risk that someone may use both the old
100    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
101    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
102    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103    * @param _spender The address which will spend the funds.
104    * @param _value The amount of tokens to be spent.
105    */
106   function approve(address _spender, uint256 _value) external returns (bool) {
107     allowed_[msg.sender][_spender] = _value;
108     emit Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(
119     address _from,
120     address _to,
121     uint256 _value
122   )
123     external
124     returns (bool)
125   {
126     require(_value <= balances_[_from]);
127     require(_value <= allowed_[_from][msg.sender]);
128     require(_to != address(0));
129 
130     balances_[_from] = balances_[_from].sub(_value);
131     balances_[_to] = balances_[_to].add(_value);
132     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Increase the amount of tokens that an owner allowed to a spender.
139    * approve should be called when allowed_[_spender] == 0. To increment
140    * allowed value is better to use this function to avoid 2 calls (and wait until
141    * the first transaction is mined)
142    * From MonolithDAO Token.sol
143    * @param _spender The address which will spend the funds.
144    * @param _addedValue The amount of tokens to increase the allowance by.
145    */
146   function increaseApproval(
147     address _spender,
148     uint256 _addedValue
149   )
150     external
151     returns (bool)
152   {
153     allowed_[msg.sender][_spender] = (
154       allowed_[msg.sender][_spender].add(_addedValue));
155     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
156     return true;
157   }
158 
159   /**
160    * @dev Decrease the amount of tokens that an owner allowed to a spender.
161    * approve should be called when allowed_[_spender] == 0. To decrement
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    * @param _spender The address which will spend the funds.
166    * @param _subtractedValue The amount of tokens to decrease the allowance by.
167    */
168   function decreaseApproval(
169     address _spender,
170     uint256 _subtractedValue
171   )
172     external
173     returns (bool)
174   {
175     uint256 oldValue = allowed_[msg.sender][_spender];
176     if (_subtractedValue >= oldValue) {
177       allowed_[msg.sender][_spender] = 0;
178     } else {
179       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
182     return true;
183   }
184 
185   /**
186    * @dev Internal function that mints an amount of the token and assigns it to
187    * an account. This encapsulates the modification of balances such that the
188    * proper events are emitted.
189    * @param _account The account that will receive the created tokens.
190    * @param _amount The amount that will be created.
191    */
192   function _mint(address _account, uint256 _amount) internal {
193     require(_account != 0);
194     totalSupply_ = totalSupply_.add(_amount);
195     balances_[_account] = balances_[_account].add(_amount);
196     emit Transfer(address(0), _account, _amount);
197   }
198 
199   /**
200    * @dev Internal function that burns an amount of the token of a given
201    * account.
202    * @param _account The account whose tokens will be burnt.
203    * @param _amount The amount that will be burnt.
204    */
205   function _burn(address _account, uint256 _amount) internal {
206     require(_account != 0);
207     require(_amount <= balances_[_account]);
208 
209     totalSupply_ = totalSupply_.sub(_amount);
210     balances_[_account] = balances_[_account].sub(_amount);
211     emit Transfer(_account, address(0), _amount);
212   }
213 
214 }
215 
216 contract DonutChain is ERC20 {
217     
218   event TokensBurned(address indexed burner, uint256 value);
219   event Mint(address indexed to, uint256 amount);
220   event MintFinished();
221   uint8  public constant decimals = 0;
222   string public constant name = "donutchain.io token #1";
223   string public constant symbol = "DNT1";
224   bool public flag = true;
225   uint256 public endBlock;
226   uint256 public mainGift;
227   uint256 public amount = 0.001 ether;
228   uint256 public increment = 0.000001 ether;
229   address public donee;
230 
231   constructor() public {
232     endBlock = block.number + 24 * 60 * 4;
233   }
234   function() external payable {
235     require(flag);
236     flag = false;
237     if (endBlock > block.number) {
238       require(msg.value >= amount);
239       uint256 tokenAmount =  msg.value / amount;
240       uint256 change = msg.value - tokenAmount * amount;
241         if (change > 0 )
242           msg.sender.transfer(change);
243         if (msg.data.length == 20) {
244           address refAddress = bToAddress(bytes(msg.data));
245           refAddress.transfer(msg.value / 10); // 10%
246         } 
247           mainGift += msg.value / 5; // 20%
248           donee = msg.sender;
249           endBlock = block.number + 24 * 60 * 4; // ~24h
250           amount += increment * tokenAmount;
251           _mint(msg.sender, tokenAmount);
252           emit Mint(msg.sender, tokenAmount);
253           flag = true;
254         } else {
255           msg.sender.transfer(msg.value);
256           emit MintFinished();
257           selfdestruct(donee);
258         }
259   }
260   /**  
261    * @dev Function to check the amount of ether per a token.
262    * @return A uint256 specifying the amount of ether per a token available for gift.
263    */
264 
265   function etherPerToken() public view returns (uint256) {
266     uint256 sideETH = address(this).balance - mainGift;
267     if (totalSupply() == 0)
268         return 0;
269     return sideETH / totalSupply();
270   }
271 
272   /**  
273    * @dev Function to calculate size of a gift for token owner.
274    * @param _who address The address of a token owner.
275    * @return A uint256 specifying the amount of gift in ether.
276    */
277   function giftAmount(address _who) external view returns (uint256) {
278     return etherPerToken() * balanceOf(_who);
279   }
280   
281   /**
282   * @dev Transfer gift from contract to tokens owner.
283   * @param _amount The amount of gift.
284   */
285   function transferGift(uint256 _amount) external {
286     require(balanceOf(msg.sender) >= _amount);
287     uint256 ept = etherPerToken();
288     _burn(msg.sender, _amount);
289     emit TokensBurned(msg.sender, _amount);
290     msg.sender.transfer(_amount * ept);
291   }
292 
293   function bToAddress(
294     bytes _bytesData
295   )
296     internal
297     pure
298     returns(address _refAddress) 
299   {
300     assembly {
301       _refAddress := mload(add(_bytesData,0x14))
302     }
303     return _refAddress;
304   }
305 
306 }
307 
308 /**
309  * @title SafeMath
310  * @dev Math operations with safety checks that revert on error
311  */
312 library SafeMath {
313 
314   /**
315   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
316   */
317   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
318     require(_b <= _a);
319     uint256 c = _a - _b;
320 
321     return c;
322   }
323 
324   /**
325   * @dev Adds two numbers, reverts on overflow.
326   */
327   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
328     uint256 c = _a + _b;
329     require(c >= _a);
330 
331     return c;
332   }
333 }