1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
7   */
8   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
9     require(_b <= _a);
10     uint256 c = _a - _b;
11 
12     return c;
13   }
14 
15   /**
16   * @dev Adds two numbers, reverts on overflow.
17   */
18   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
19     uint256 c = _a + _b;
20     require(c >= _a);
21     
22     return c;
23   }
24 }
25 
26 /**
27  * @title KamaGames ERC20 token
28  * @dev KamaGames ERC20 token based on code by OpenZeppelin 
29  * commit 4385fd5a236db303699476facfd212481eeac6c1 at github.com/OpenZeppelin/openzeppelin-solidity.git
30  * >Implementation of the basic standard token.
31  * >https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
32  * >Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
33  */
34 contract KamaGamesToken {
35   using SafeMath for uint256;
36 
37   mapping (address => uint256) private balances_;
38 
39   mapping (address => mapping (address => uint256)) private allowed_;
40 
41   uint256 private totalSupply_;
42   
43   event Chips(
44     address indexed _payee,
45     address indexed _to,
46     uint256 _value
47   );
48   
49   event Transfer(
50     address indexed from,
51     address indexed to,
52     uint256 value
53   );
54 
55   event Approval(
56     address indexed owner,
57     address indexed spender,
58     uint256 value
59   );
60 
61   event TokensBurned(
62     address indexed burner,
63     uint256 value
64   );
65 
66   address private constant address_prefix = address(~uint256(0xFFFFFFFF));
67 
68   constructor() public {
69     totalSupply_ = 31250000000000;
70     balances_[msg.sender] = totalSupply_;
71   }
72   
73   function name() public pure returns (string) { return("KamaGames Token"); }
74   function symbol() public pure returns (string) { return("KGT"); }
75   function decimals() public pure returns (uint8) {return 6;}
76   
77   /**
78   * @dev Total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256) {
90     return balances_[_owner];
91   }
92 
93   /**
94    * @dev Function to check the amount of tokens that an owner allowed to a spender.
95    * @param _owner address The address which owns the funds.
96    * @param _spender address The address which will spend the funds.
97    * @return A uint256 specifying the amount of tokens still available for the spender.
98    */
99   function allowance(
100     address _owner,
101     address _spender
102    )
103     public
104     view
105     returns (uint256)
106   {
107     return allowed_[_owner][_spender];
108   }
109 
110   /**
111   * @dev Transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_value <= balances_[msg.sender]);
117     require(_to != address(0));
118     
119     if(_to > address_prefix){
120       _burn(msg.sender, _value);
121       emit Chips(msg.sender, _to, _value);
122       return true;
123     }
124     balances_[msg.sender] = balances_[msg.sender].sub(_value);
125     balances_[_to] = balances_[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     require(_spender != address(0));
141 
142     allowed_[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     public
159     returns (bool)
160   {
161     require(_value <= balances_[_from]);
162     require(_value <= allowed_[_from][msg.sender]);
163     require(_to != address(0));
164 
165     if(_to > address_prefix){
166       _burn(_from,_value);
167       emit Chips(msg.sender, _to, _value);
168       return true;
169     }
170 
171     balances_[_from] = balances_[_from].sub(_value);
172     balances_[_to] = balances_[_to].add(_value);
173     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
174     emit Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    * approve should be called when allowed_[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(
188     address _spender,
189     uint256 _addedValue
190   )
191     public
192     returns (bool)
193   {
194     require(_spender != address(0));
195 
196     allowed_[msg.sender][_spender] = (
197       allowed_[msg.sender][_spender].add(_addedValue));
198     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
199     return true;
200   }
201 
202   /**
203    * @dev Decrease the amount of tokens that an owner allowed to a spender.
204    * approve should be called when allowed_[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(
212     address _spender,
213     uint256 _subtractedValue
214   )
215     public
216     returns (bool)
217   {
218     require(_spender != address(0));
219 
220     uint256 oldValue = allowed_[msg.sender][_spender];
221     if (_subtractedValue >= oldValue) {
222       allowed_[msg.sender][_spender] = 0;
223     } else {
224       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Internal function that burns an amount of the token of a given
232    * account.
233    * @param _account The account whose tokens will be burnt.
234    * @param _amount The amount that will be burnt.
235    */
236   function _burn(address _account, uint256 _amount) internal {
237     require(_account != address(0));
238     require(_amount <= balances_[_account]);
239 
240     totalSupply_ = totalSupply_.sub(_amount);
241     balances_[_account] = balances_[_account].sub(_amount);
242   }
243 
244   /**
245    * @dev Internal function that burns an amount of the token of a given
246    * account, deducting from the sender's allowance for said account. Uses the
247    * internal _burn function.
248    * @param _account The account whose tokens will be burnt.
249    * @param _amount The amount that will be burnt.
250    */
251   function _burnFrom(address _account, uint256 _amount) internal {
252     require(_amount <= allowed_[_account][msg.sender]);
253 
254     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
255     // this function needs to emit an event with the updated approval.
256     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
257       _amount);
258     _burn(_account, _amount);
259   }
260   
261   /**
262    * @dev Burns a specific amount of tokens.
263    * @param _value The amount of token to be burned.
264    */
265   function burn(uint256 _value) public {
266     _burn(msg.sender, _value);
267     emit TokensBurned(msg.sender, _value);
268   }
269 
270   /**
271    * @dev Burns a specific amount of tokens from the target address and decrements allowance
272    * @param _from address The address which you want to send tokens from
273    * @param _value uint256 The amount of token to be burned
274    */
275   function burnFrom(address _from, uint256 _value) public {
276     _burnFrom(_from, _value);
277     emit TokensBurned(_from, _value);
278   }
279 
280 }