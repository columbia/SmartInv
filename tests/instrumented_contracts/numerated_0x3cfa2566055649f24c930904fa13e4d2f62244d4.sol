1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   uint256 totalSupply_;
65 
66   /**
67   * @dev total number of tokens in existence
68   */
69   function totalSupply() public view returns (uint256) {
70     return totalSupply_;
71   }
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[msg.sender]);
81 
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     emit Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) public view returns (uint256) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     emit Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public view returns (uint256) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * @dev Increase the amount of tokens that an owner allowed to a spender.
150    *
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _addedValue The amount of tokens to increase the allowance by.
157    */
158   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   /**
165    * @dev Decrease the amount of tokens that an owner allowed to a spender.
166    *
167    * approve should be called when allowed[_spender] == 0. To decrement
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _subtractedValue The amount of tokens to decrease the allowance by.
173    */
174   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 contract Umint21 is StandardToken {
188 
189   string public constant name = "UMINT21"; // solium-disable-line uppercase
190   string public constant symbol = "UM21"; // solium-disable-line uppercase
191   uint8 public constant decimals = 3; // solium-disable-line uppercase
192 
193   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
194 
195   /**
196    * @dev Constructor that gives msg.sender all of existing tokens.
197    */
198   function Umint21() public {
199     totalSupply_ = INITIAL_SUPPLY;
200     balances[msg.sender] = INITIAL_SUPPLY;
201     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
202   }
203 
204 }
205 
206 //Code derived from OpenZeppelin / Zeppelin-Solidity library
207 /**The MIT License (MIT)
208 *
209 *Copyright (c) 2016 Smart Contract Solutions, Inc.
210 *
211 *Permission is hereby granted, free of charge, to any person obtaining
212 *a copy of this software and associated documentation files (the
213 *"Software"), to deal in the Software without restriction, including
214 *without limitation the rights to use, copy, modify, merge, publish,
215 *distribute, sublicense, and/or sell copies of the Software, and to
216 *permit persons to whom the Software is furnished to do so, subject to
217 *the following conditions:
218 *
219 *The above copyright notice and this permission notice shall be included
220 *in all copies or substantial portions of the Software.
221 *
222 *THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
223 *OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
224 *MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
225 *IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
226 *CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
227 *TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
228 *SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
229 */
230 
231 //Code customized, compiled, and deployed by uMINT.io