1 pragma solidity ^0.4.23;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function safeMul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint a, uint b) internal pure returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint a, uint b) internal pure returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function safePerc(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(a >= 0);
49     uint256 c = (a * b) / 100;
50     return c;
51   }
52   
53     /**
54 	  * @dev Multiplies two numbers, throws on overflow.
55 	*/
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     if (a == 0) {
58       return 0;
59     }
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 
94 contract CSC {
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 
98 
99   using SafeMath for uint256;
100   	string public name;
101     string public symbol;
102     uint8 public decimals;
103     uint256 public totalSupply;
104 	address public owner;
105 
106     mapping (address => uint256) private balances;
107     mapping (address => uint256[2]) private lockedBalances;
108     mapping (address => mapping (address => uint256)) internal allowed;
109     /* External Functions */
110     
111     constructor(
112         uint256 _initialAmount,
113         string _tokenName,
114         uint8 _decimalUnits,
115         string _tokenSymbol,
116         address _owner,
117         address[] _lockedAddress,
118         uint256[] _lockedBalances,
119         uint256[] _lockedTimes
120     ) public {
121         balances[_owner] = _initialAmount;                   // Give the owner all initial tokens
122         totalSupply = _initialAmount;                        // Update total supply
123         name = _tokenName;                                   // Set the name for display purposes
124         decimals = _decimalUnits;                            // Amount of decimals for display purposes
125         symbol = _tokenSymbol;                               // Set the symbol for display purposes
126         owner = _owner;                                      // set owner
127         for(uint i = 0;i < _lockedAddress.length;i++){
128             lockedBalances[_lockedAddress[i]][0] = _lockedBalances[i];
129             lockedBalances[_lockedAddress[i]][1] = _lockedTimes[i];
130         }
131     }
132     /* External Functions */
133      /*DirectDrop and AirDrop*/
134 
135     
136         
137     /*With permission, destory token from an address and minus total amount.*/
138     function burnFrom(address _who,uint256 _value)public returns (bool){
139         require(msg.sender == owner);
140         assert(balances[_who] >= _value);
141         totalSupply -= _value;
142         balances[_who] -= _value;
143         lockedBalances[_who][0] = 0;
144         lockedBalances[_who][1] = 0;
145         return true;
146     }
147     /*With permission, creating coin.*/
148     function makeCoin(uint256 _value)public returns (bool){
149         require(msg.sender == owner);
150         totalSupply += _value;
151         balances[owner] += _value;
152         return true;
153     }
154        /*With permission, withdraw ETH to owner address from smart contract.*/
155     function withdraw() public{
156         require(msg.sender == owner);
157         msg.sender.transfer(address(this).balance);
158     }
159     /*With permission, withdraw ETH to an address from smart contract.*/
160     function withdrawTo(address _to) public{
161         require(msg.sender == owner);
162         address(_to).transfer(address(this).balance);
163     }
164     function checkValue(address _from,uint256 _value) private view{
165         if(lockedBalances[_from][1] >= now) {
166             require(balances[_from].sub(lockedBalances[_from][0]) >= _value);
167         } else {
168             require(balances[_from] >= _value);
169         }
170     }
171   /**
172   * @dev transfer token for a specified address
173   * @param _to The address to transfer to.
174   * @param _value The amount to be transferred.
175   */
176   function transfer(address _to, uint256 _value) public returns (bool) { 
177     
178     require(_to != address(0));
179 
180     checkValue(msg.sender,_value);
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197 
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     //Before ICO finish, only own could transfer.
208 
209     require(_to != address(0));
210 
211     checkValue(_from,_value);
212 
213     require(_value <= allowed[_from][msg.sender]);
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     emit Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(address _owner, address _spender) public view returns (uint256) {
244     return allowed[_owner][_spender];
245   }
246 
247   /**
248    * @dev Increase the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _addedValue The amount of tokens to increase the allowance by.
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
274     uint oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 }