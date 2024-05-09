1 /*
2     Implements MilitaryToken™. The true cryptocurrency token for 
3     www.MilitaryToken.io "Blockchain for a better world".
4     
5     All of the following might at times be used to refer to this coin: "MILS", 
6     "MILs", "MIL$", "$MILS", "$MILs", "$MIL$", "MilitaryToken". In social 
7     settings we prefer the text "MILs" but in formal listings "MILS" and "$MILS" 
8     are the best symbols. In the Solidity code, the official symbol can be found 
9     below which is "MILS". 
10   
11     Portions of this code fall under the following license where noted as from
12     "OpenZepplin":
13 
14     The MIT License (MIT)
15 
16     Copyright (c) 2016 Smart Contract Solutions, Inc.
17 
18     Permission is hereby granted, free of charge, to any person obtaining
19     a copy of this software and associated documentation files (the
20     "Software"), to deal in the Software without restriction, including
21     without limitation the rights to use, copy, modify, merge, publish,
22     distribute, sublicense, and/or sell copies of the Software, and to
23     permit persons to whom the Software is furnished to do so, subject to
24     the following conditions:
25 
26     The above copyright notice and this permission notice shall be included
27     in all copies or substantial portions of the Software.
28 
29     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
30     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
31     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
32     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
33     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
34     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
35     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
36 
37 */
38 
39 pragma solidity 0.4.24;
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
45  * @dev see https://github.com/ethereum/EIPs/issues/179
46  */
47 contract ERC20Basic {
48     function totalSupply() public view returns (uint256);
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
58  */
59 library SafeMath {
60 
61     /**
62     * @dev Multiplies two numbers, throws on overflow.
63     */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65         if (a == 0) {
66         return 0;
67         }
68         c = a * b;
69         assert(c / a == b);
70         return c;
71     }
72 
73     /**
74     * @dev Integer division of two numbers, truncating the quotient.
75     */
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a / b;
78     }
79 
80     /**
81     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82     */
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         assert(b <= a);
85         return a - b;
86     }
87 
88     /**
89     * @dev Adds two numbers, throws on overflow.
90     */
91     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92         c = a + b;
93         assert(c >= a);
94         return c;
95     }
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
102  */
103 contract BasicToken is ERC20Basic {
104     using SafeMath for uint256;
105 
106     mapping(address => uint256) balances;
107 
108     uint256 totalSupply_;
109 
110     /**
111     * @dev total number of tokens in existence
112     */
113     function totalSupply() public view returns (uint256) {
114         return totalSupply_;
115     }
116 
117     /**
118     * @dev transfer token for a specified address
119     * @param _to The address to transfer to.
120     * @param _value The amount to be transferred.
121     */
122     function transfer(address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[msg.sender]);
125 
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         emit Transfer(msg.sender, _to, _value);
129         return true;
130     }
131 
132     /**
133     * @dev Gets the balance of the specified address.
134     * @param _owner The address to query the the balance of.
135     * @return An uint256 representing the amount owned by the passed address.
136     */
137     function balanceOf(address _owner) public view returns (uint256) {
138         return balances[_owner];
139     }
140 
141 }
142 
143 /**
144  * @title ERC20 interface
145  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149     function allowance(address owner, address spender) public view returns (uint256);
150     function transferFrom(address from, address to, uint256 value) public returns (bool);
151     function approve(address spender, uint256 value) public returns (bool);
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165     mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168     /**
169     * @dev Transfer tokens from one address to another
170     * @param _from address The address which you want to send tokens from
171     * @param _to address The address which you want to transfer to
172     * @param _value uint256 the amount of tokens to be transferred
173     */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188     *
189     * Beware that changing an allowance with this method brings the risk that someone may use both the old
190     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193     * @param _spender The address which will spend the funds.
194     * @param _value The amount of tokens to be spent.
195     */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203     * @dev Function to check the amount of tokens that an owner allowed to a spender.
204     * @param _owner address The address which owns the funds.
205     * @param _spender address The address which will spend the funds.
206     * @return A uint256 specifying the amount of tokens still available for the spender.
207     */
208     function allowance(address _owner, address _spender) public view returns (uint256) {
209         return allowed[_owner][_spender];
210     }
211 
212     /**
213     * @dev Increase the amount of tokens that an owner allowed to a spender.
214     *
215     * approve should be called when allowed[_spender] == 0. To increment
216     * allowed value is better to use this function to avoid 2 calls (and wait until
217     * the first transaction is mined)
218     * From MonolithDAO Token.sol
219     * @param _spender The address which will spend the funds.
220     * @param _addedValue The amount of tokens to increase the allowance by.
221     */
222     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228     /**
229     * @dev Decrease the amount of tokens that an owner allowed to a spender.
230     *
231     * approve should be called when allowed[_spender] == 0. To decrement
232     * allowed value is better to use this function to avoid 2 calls (and wait until
233     * the first transaction is mined)
234     * From MonolithDAO Token.sol
235     * @param _spender The address which will spend the funds.
236     * @param _subtractedValue The amount of tokens to decrease the allowance by.
237     */
238     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239         uint oldValue = allowed[msg.sender][_spender];
240         if (_subtractedValue > oldValue) {
241             allowed[msg.sender][_spender] = 0;
242         } else {
243             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244         }
245         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 }
249 
250 /**
251  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
252  */
253 
254 /**
255  * @title Ownable
256  * @dev The Ownable contract has an owner address, and provides basic authorization control
257  * functions, this simplifies the implementation of "user permissions".
258  */
259 contract Ownable {
260   
261   address public owner;
262 
263   event OwnershipTransferred(
264     address indexed previousOwner,
265     address indexed newOwner
266   );
267 
268   /**
269    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
270    * account.
271    */
272   constructor() public {
273     owner = msg.sender;
274   }
275 
276   /**
277    * @dev Throws if called by any account other than the owner.
278    */
279   modifier onlyOwner() {
280     require(msg.sender == owner);
281     _;
282   }
283 
284   /**
285    * @dev Allows the current owner to transfer control of the contract to a newOwner.
286    * @param _newOwner The address to transfer ownership to.
287    */
288   function transferOwnership(address _newOwner) public onlyOwner {
289     _transferOwnership(_newOwner);
290   }
291 
292   /**
293    * @dev Transfers control of the contract to a newOwner.
294    * @param _newOwner The address to transfer ownership to.
295    */
296   function _transferOwnership(address _newOwner) internal {
297     require(_newOwner != address(0));
298     emit OwnershipTransferred(owner, _newOwner);
299     owner = _newOwner;
300   }
301 }
302 
303 
304 /**
305  * @title Burnable Token
306  * @dev Token that can be irreversibly burned (destroyed).
307  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
308  */
309 contract BurnableToken is BasicToken {
310 
311     event Burn(address indexed burner, uint256 value);
312 
313     /**
314     * @dev Burns a specific amount of tokens.
315     * @param _value The amount of token to be burned.
316     */
317     function burn(uint256 _value) public {
318         _burn(msg.sender, _value);
319     }
320 
321     function _burn(address _who, uint256 _value) internal {
322         require(_value <= balances[_who]);
323         // no need to require value <= totalSupply, since that would imply the
324         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
325 
326         balances[_who] = balances[_who].sub(_value);
327         totalSupply_ = totalSupply_.sub(_value);
328         emit Burn(_who, _value);
329         emit Transfer(_who, address(0), _value);
330     }
331 }
332 
333 contract MilitaryToken is Ownable, BurnableToken, StandardToken {
334     string public name = "MilitaryToken";
335     string public symbol = "MILS";
336     uint public decimals = 18;
337     uint public INITIAL_SUPPLY = 400000000 * 1 ether;
338 
339     constructor() public {
340         totalSupply_ = INITIAL_SUPPLY;
341         balances[msg.sender] = INITIAL_SUPPLY;
342     }
343 }