1 /*
2 This file is part of the RUSGASCrowdsale Contract.
3 This file is RusgasToken Contract
4 
5 The RusgasToken Contract is free software: you can redistribute it and/or
6 modify it under the terms of the GNU lesser General Public License as published
7 by the Free Software Foundation, either version 3 of the License, or
8 (at your option) any later version.
9 
10 The RusgasToken Contract is distributed in the hope that it will be useful,
11 but WITHOUT ANY WARRANTY; without even the implied warranty of
12 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
13 GNU lesser General Public License for more details.
14 
15 You should have received a copy of the GNU lesser General Public License
16 along with the RusgasToken Contract. If not, see <http://www.gnu.org/licenses/>.
17 
18 @author Anatolii Chernov <office@nice-design.com.ua>
19 */
20 
21 pragma solidity ^0.4.18;
22 
23 contract AbstractRusgasBalances {
24     mapping(address => bool) public oldBalances;
25 }
26 
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public constant returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public constant returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 library SafeMath {
55 
56   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal constant returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal constant returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87 
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public constant returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is ERC20, BasicToken {
123 
124   mapping (address => mapping (address => uint256)) allowed;
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amout of tokens to be transfered
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     var _allowance = allowed[_from][msg.sender];
134 
135     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
136     // require (_value <= _allowance);
137 
138     balances[_to] = balances[_to].add(_value);
139     balances[_from] = balances[_from].sub(_value);
140     allowed[_from][msg.sender] = _allowance.sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) public returns (bool) {
151 
152     // To change the approve amount you first have to reduce the addresses`
153     // allowance to zero by calling `approve(_spender, 0)` if it is not
154     // already 0 to mitigate the race condition described here:
155     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
157 
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifing the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173 }
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181 
182   address public owner;
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   function Ownable() public {
189     owner = msg.sender;
190   }
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200   /**
201    * @dev Allows the current owner to transfer control of the contract to a newOwner.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function transferOwnership(address newOwner) public onlyOwner {
205     require(newOwner != address(0));
206     owner = newOwner;
207   }
208 
209 }
210 
211 /**
212  * @title Mintable token
213  * @dev Simple ERC20 Token example, with mintable token creation
214  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
215  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
216  */
217 
218 contract MintableToken is StandardToken, Ownable {
219 
220   event Mint(address indexed to, uint256 amount);
221 
222   event MintFinished();
223 
224   bool public mintingFinished = false;
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will recieve the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
238     totalSupply = totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     //Mint(_to, _amount);
241     Transfer(address(0), _to, _amount);
242     return true;
243   }
244 
245   /**
246    * @dev Function to stop minting new tokens.
247    * @return True if the operation was successful.
248    */
249   function finishMinting() public onlyOwner returns (bool) {
250     mintingFinished = true;
251     MintFinished();
252     return true;
253   }
254 
255 }
256 
257 contract RusgasToken is MintableToken {
258 
259     string public constant name = "Rusgas";
260 
261     string public constant symbol = "RGS";
262 
263     uint32 public constant decimals = 8;
264 
265 }