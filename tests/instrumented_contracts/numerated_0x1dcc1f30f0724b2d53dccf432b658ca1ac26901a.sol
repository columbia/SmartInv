1 pragma solidity 0.4.24;
2 
3 /*
4     Copyright 2018, Vicent Nos & Mireia Puig
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 */
19 
20 
21 /**
22  * @title OpenZeppelin SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25  library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return a / b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 /**
73  * @title OpenZeppelin Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78   address public owner;
79 
80   event OwnershipRenounced(address indexed previousOwner);
81   event OwnershipTransferred(
82     address indexed previousOwner,
83     address indexed newOwner
84   );
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipRenounced(owner);
110     owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address _newOwner) public onlyOwner {
118     _transferOwnership(_newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address _newOwner) internal {
126     require(_newOwner != address(0));
127     emit OwnershipTransferred(owner, _newOwner);
128     owner = _newOwner;
129   }
130 }
131 
132 
133 //////////////////////////////////////////////////////////////
134 //                                                          //
135 //          Zironex, Open End Crypto Fund ERC20             //
136 //                                                          //
137 //////////////////////////////////////////////////////////////
138 
139 contract ZironexERC20 is Ownable {
140 
141   using SafeMath for uint256;
142 
143   mapping (address => uint256) public balances;
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147   /* Public variables for the ERC20 token */
148   string public constant standard = "ERC20 Zironex";
149   uint8 public constant decimals = 18; // hardcoded to be a constant
150   uint256 public totalSupply = 10000000000000000000000000;
151   string public name = "Ziron";
152   string public symbol = "ZNX";
153 
154   event Transfer(address indexed from, address indexed to, uint256 value);
155   event Approval(address indexed owner, address indexed spender, uint256 value);
156 
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     // SafeMath.sub will throw if there is not enough balance.
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167 
168     balances[_to] = balances[_to].add(_value);
169 
170     emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180 
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183 
184     emit Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   function allowance(address _owner, address _spender) public view returns (uint256) {
195     return allowed[_owner][_spender];
196   }
197 
198   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207         allowed[msg.sender][_spender] = 0;
208     } else {
209         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /* Approve and then communicate the approved contract in a single tx */
216   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
217     tokenRecipient spender = tokenRecipient(_spender);
218 
219     if (approve(_spender, _value)) {
220         spender.receiveApproval(msg.sender, _value, this, _extraData);
221         return true;
222     }
223   }
224 }
225 
226 
227 interface tokenRecipient {
228     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
229 }
230 
231 
232 contract Zironex is ZironexERC20 {
233 
234   // Constant to simplify conversion of token amounts into integer form
235     uint256 public tokenUnit = uint256(10)**decimals;
236 
237   //Declare logging events
238     event LogDeposit(address sender, uint amount);
239 
240   /* Initializes contract with initial supply tokens to the creator of the contract */
241     constructor(
242       address contractOwner
243 
244         ) public {
245         owner = contractOwner; // set owner address
246         balances[contractOwner] = balances[contractOwner].add(totalSupply); // set owner balance
247     }
248 }