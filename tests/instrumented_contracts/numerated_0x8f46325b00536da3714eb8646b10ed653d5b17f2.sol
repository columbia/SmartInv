1 //////// This is the official eUSD smart contract.
2 //// The eUSD token contract utilizes the eFIAT protocol - a not-for-profit,
3 //// fully transparent, publicly auditable protocol designed to migrate fiat
4 //// currencies to the Ethereum blockchain without banks, escrow accounts or reserves.
5 
6 //// The eFIAT protocol relies on Proof of Burn, meaning any eUSD can only
7 //// be created by burning Ether at market value. Because Ether is denominated also
8 //// in USD value, the burning of Ether can be regarded as burning of US Dollars,
9 //// where Ether serves only as the medium of value transfer and verifiable proof
10 //// that actual value has ben permanently migrated and not replicated. This means
11 //// eUSD can never be used to redeem any Ether burned in the eUSD creation process!
12 
13 // This program is free software: you can redistribute it and/or modify
14 // it under the terms of the GNU General Public License as published by
15 // the Free Software Foundation, either version 3 of the License, or
16 // (at your option) any later version.
17 
18 // This program is distributed in the hope that it will be useful,
19 // but WITHOUT ANY WARRANTY; without even the implied warranty of
20 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
21 // GNU General Public License for more details.
22 
23 // You should have received a copy of the GNU General Public License
24 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
25 
26 pragma solidity ^0.4.24;
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
47    */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to relinquish control of the contract.
62    */
63   function renounceOwnership() public onlyOwner {
64     emit OwnershipRenounced(owner);
65     owner = address(0);
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address _newOwner) public onlyOwner {
73     _transferOwnership(_newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address _newOwner) internal {
81     require(_newOwner != address(0));
82     emit OwnershipTransferred(owner, _newOwner);
83     owner = _newOwner;
84   }
85 }
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, throws on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
96     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (a == 0) {
100       return 0;
101     }
102 
103     c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     // uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return a / b;
116   }
117 
118   /**
119   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
130     c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 
137 contract ERC20 {
138     function totalSupply() public view returns (uint256);
139     function balanceOf(address who) public view returns (uint256);
140     function transfer(address to, uint256 value) public returns (bool);
141     function allowance(address owner, address spender) public view returns (uint256);
142     function transferFrom(address from, address to, uint256 value) public returns (bool);
143     function approve(address spender, uint256 value) public returns (bool);
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 }
147 
148 contract Oracle {
149     function callOracle(address _src, uint256 _amount) public;
150 }
151 
152 /**
153  * @title eUSD
154  */
155 contract eUSD is Ownable, ERC20 {
156     using SafeMath for uint256;
157 
158     string public name = "ETHUSD";
159     string public symbol = "EUSD";
160     uint8 public decimals = 18;
161 
162     uint256 totalSupply_;
163 
164     mapping(address => uint256) balances;
165     mapping(address => mapping (address => uint256)) internal allowed;
166 
167     Oracle oracle;
168 
169     event Mint(address indexed to, uint256 amount);
170 
171     /**
172     * @dev fallback function which receives ether and sends it to oracle
173     **/
174     function () payable public {
175         require(address(oracle) != address(0));
176         require(msg.value >= 20 finney); //0.02 ETH
177         address(oracle).transfer(address(this).balance);
178         oracle.callOracle(msg.sender, msg.value);
179     }
180 
181     /**
182     * @dev set new oracle address
183     * @param _oracle The new oracle contract address.
184     */
185     function setOracle(address _oracle) public onlyOwner {
186         oracle = Oracle(_oracle);
187     }
188 
189     /**
190     * @dev callback function - oracle sends amount of eUSD tokens to mint
191     * @param _src Mint eUSD tokens to address.
192     * @param _amount Amount of minted eUSD tokens
193     */
194     function calculatedTokens(address _src, uint256 _amount) public {
195         require(msg.sender == address(oracle));
196         mint(_src, _amount);
197     }
198 
199     /**
200     * @dev transfer eUSD token for a specified address
201     * @param _to The address to transfer to.
202     * @param _value The amount of eUSD tokens to be spent.
203     */
204     function transfer(address _to, uint256 _value) public returns (bool) {
205         require(_to != address(0));
206         require(_value <= balances[msg.sender]);
207 
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         emit Transfer(msg.sender, _to, _value);
211         return true;
212     }
213 
214     /**
215    * @dev Transfer eUSD tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of eUSD tokens to be transferred
219    */
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
221         require(_to != address(0));
222         require(_value <= balances[_from]);
223         require(_value <= allowed[_from][msg.sender]);
224 
225         balances[_from] = balances[_from].sub(_value);
226         balances[_to] = balances[_to].add(_value);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228         emit Transfer(_from, _to, _value);
229         return true;
230     }
231 
232     /**
233      * @dev Approve the passed address to spend the specified amount of eUSD tokens on behalf of msg.sender.
234      *
235      * Beware that changing an allowance with this method brings the risk that someone may use both the old
236      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards.
238      * @param _spender The address which will spend the funds.
239      * @param _value The amount of eUSD tokens to be spent.
240      */
241     function approve(address _spender, uint256 _value) public returns (bool) {
242         allowed[msg.sender][_spender] = _value;
243         emit Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 
247     /**
248      * @dev Increase the amount of eUSD tokens that an owner allowed to a spender.
249      *
250      * approve should be called when allowed[_spender] == 0. To increment
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * @param _spender The address which will spend the funds.
254      * @param _addedValue The amount of eUSD tokens to increase the allowance by.
255      */
256     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
258         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259         return true;
260     }
261 
262     /**
263      * @dev Decrease the amount of eUSD tokens that an owner allowed to a spender.
264      *
265      * approve should be called when allowed[_spender] == 0. To decrement
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * @param _spender The address which will spend the funds.
270      * @param _subtractedValue The amount of eUSD tokens to decrease the allowance by.
271      */
272     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273         uint oldValue = allowed[msg.sender][_spender];
274         if (_subtractedValue > oldValue) {
275             allowed[msg.sender][_spender] = 0;
276         } else {
277             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278         }
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283     /**
284    * @dev Function to mint eUSD tokens
285    * @param _to The address that will receive minted eUSD tokens.
286    * @param _amount The amount of eUSD tokens to mint.
287    */
288     function mint(address _to, uint256 _amount) private returns (bool){
289         totalSupply_ = totalSupply_.add(_amount);
290         balances[_to] = balances[_to].add(_amount);
291         emit Mint(_to, _amount);
292         emit Transfer(address(0), _to, _amount);
293         return true;
294     }
295 
296     /**
297     * @dev Gets the balance of the specified address.
298     * @param _owner The address to query the the balance of.
299     */
300     function balanceOf(address _owner) public view returns (uint256) {
301         return balances[_owner];
302     }
303 
304     /**
305     * @dev total number of tokens in existence
306     */
307     function totalSupply() public view returns (uint256) {
308         return totalSupply_;
309     }
310 
311     /**
312      * @dev Function to check the amount of tokens that an owner allowed to a spender.
313      * @param _owner address The address which owns the funds.
314      * @param _spender address The address which will spend the funds.
315      */
316     function allowance(address _owner, address _spender) public view returns (uint256) {
317         return allowed[_owner][_spender];
318     }
319 }