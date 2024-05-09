1 pragma solidity ^0.4.24;
2 
3 //------------------------------------------------------------------------------------------------
4 // ERC20 Standard Token Implementation, based on ERC Standard:
5 // https://github.com/ethereum/EIPs/issues/20
6 // Copyright 2017 SoftChain Foundation Ltd.
7 //------------------------------------------------------------------------------------------------
8 
9 //------------------------------------------------------------------------------------------------
10 // LICENSE
11 //
12 // This file is part of SoftChain.
13 // 
14 // SoftChain is free software: you can redistribute it and/or modify
15 // it under the terms of the GNU General Public License as published by
16 // the Free Software Foundation, either version 3 of the License, or
17 // (at your option) any later version.
18 // 
19 // BattleDrome is distributed in the hope that it will be useful,
20 // but WITHOUT ANY WARRANTY; without even the implied warranty of
21 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
22 // GNU General Public License for more details.
23 // 
24 // You should have received a copy of the GNU General Public License
25 // along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.
26 //------------------------------------------------------------------------------------------------
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
38     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (_a == 0) {
42       return 0;
43     }
44 
45     c = _a * _b;
46     assert(c / _a == _b);
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers, truncating the quotient.
52   */
53   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     // assert(_b > 0); // Solidity automatically throws when dividing by 0
55     // uint256 c = _a / _b;
56     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
57     return _a / _b;
58   }
59 
60   /**
61   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62   */
63   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     assert(_b <= _a);
65     return _a - _b;
66   }
67 
68   /**
69   * @dev Adds two numbers, throws on overflow.
70   */
71   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
72     c = _a + _b;
73     assert(c >= _a);
74     return c;
75   }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * See https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address _who) public view returns (uint256);
86   function transfer(address _to, uint256 _value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) internal balances;
98 
99   uint256 internal totalSupply_;
100 
101   /**
102   * @dev Total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev Transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_value <= balances[msg.sender]);
115     require(_to != address(0));
116 
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     emit Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139   function allowance(address _owner, address _spender)
140     public view returns (uint256);
141 
142   function transferFrom(address _from, address _to, uint256 _value)
143     public returns (bool);
144 
145   function approve(address _spender, uint256 _value) public returns (bool);
146   event Approval(
147     address indexed owner,
148     address indexed spender,
149     uint256 value
150   );
151 }
152 
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     public
170     returns (bool)
171   {
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174     require(_to != address(0));
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     emit Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(
205     address _owner,
206     address _spender
207    )
208     public
209     view
210     returns (uint256)
211   {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint256 _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (
232       allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint256 _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue >= oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 contract SoftChainCoin is StandardToken{
266   string public name = 'SoftChainCoin';
267   string public symbol = 'SCC';
268   uint8 public decimals = 18;
269 
270   uint256 public constant INITIAL_SUPPLY = 600000000000000000000000000;
271 
272   constructor() public {
273     totalSupply_ = INITIAL_SUPPLY;
274     balances[msg.sender] = INITIAL_SUPPLY;
275   }
276 }