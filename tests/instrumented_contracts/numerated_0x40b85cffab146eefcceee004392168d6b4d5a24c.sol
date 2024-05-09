1 pragma solidity ^0.4.23;
2 /**
3 * @title Ownable
4 * @dev The Ownable contract has an owner address, and provides basic authorization
5 control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9 address public owner;
10 event OwnershipRenounced(address indexed previousOwner);
11 event OwnershipTransferred(
12 address indexed previousOwner,
13 address indexed newOwner
14 );
15 /**
16 * @dev The Ownable constructor sets the original `owner` of the contract to the
17 sender
18 * account.
19 */
20 constructor() public {
21 owner = msg.sender;
22 }
23 /**
24 * @dev Throws if called by any account other than the owner.
25 */
26 modifier onlyOwner() {
27 require(msg.sender == owner);
28 _;
29 }
30 /**
31 * @dev Allows the current owner to transfer control of the contract to a newOwner.
32 * @param newOwner The address to transfer ownership to.
33 */
34 function transferOwnership(address newOwner) public onlyOwner {
35 require(newOwner != address(0));
36 emit OwnershipTransferred(owner, newOwner);
37 owner = newOwner;
38 }
39 /**
40 * @dev Allows the current owner to relinquish control of the contract.
41 */
42 function renounceOwnership() public onlyOwner {
43 emit OwnershipRenounced(owner);
44 owner = address(0);
45 }
46 }
47 /**
48 * @title SafeMath
49 * @dev Math operations with safety checks that throw on error
50 */
51 library SafeMath {
52 /**
53 * @dev Multiplies two numbers, throws on overflow.
54 */
55 function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56 if (a == 0) {
57 return 0;
58 }
59 c = a * b;
60 assert(c / a == b);
61 return c;
62 }
63 /**
64 * @dev Integer division of two numbers, truncating the quotient.
65 */
66 function div(uint256 a, uint256 b) internal pure returns (uint256) {
67 // assert(b > 0); // Solidity automatically throws when dividing by 0
68 // uint256 c = a / b;
69 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 return a / b;
71 }
72 /**
73 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than
74 minuend).
75 */
76 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77 assert(b <= a);
78 return a - b;
79 }
80 /**
81 * @dev Adds two numbers, throws on overflow.
82 */
83 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84 c = a + b;
85 assert(c >= a);
86 return c;
87 }
88 }
89 /**
90 * @title ERC20Basic
91 * @dev Simpler version of ERC20 interface
92 * @dev see https://github.com/ethereum/EIPs/issues/179
93 */
94 contract ERC20Basic {
95 function totalSupply() public view returns (uint256);
96 function balanceOf(address who) public view returns (uint256);
97 function transfer(address to, uint256 value) public returns (bool);
98 event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 /**
101 * @title ERC20 interface
102 * @dev see https://github.com/ethereum/EIPs/issues/20
103 */
104 contract ERC20 is ERC20Basic {
105 function allowance(address owner, address spender) public view returns (uint256);
106 function transferFrom(address from, address to, uint256 value) public returns
107 (bool);
108 function approve(address spender, uint256 value) public returns (bool);
109 event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 contract BasicToken is ERC20Basic {
112 using SafeMath for uint256;
113 mapping(address => uint256) balances;
114 uint256 totalSupply_;
115 /**
116 * @dev total number of tokens in existence
117 */
118 function totalSupply() public view returns (uint256) {
119 return totalSupply_;
120 }
121 /**
122 * @dev transfer token for a specified address
123 * @param _to The address to transfer to.
124 * @param _value The amount to be transferred.
125 */
126 function transfer(address _to, uint256 _value) public returns (bool) {
127 require(_to != address(0));
128 require(_value <= balances[msg.sender]);
129 balances[msg.sender] = balances[msg.sender].sub(_value);
130 balances[_to] = balances[_to].add(_value);
131 emit Transfer(msg.sender, _to, _value);
132 return true;
133 }
134 /**
135 * @dev Gets the balance of the specified address.
136 * @param _owner The address to query the the balance of.
137 * @return An uint256 representing the amount owned by the passed address.
138 */
139 function balanceOf(address _owner) public view returns (uint256) {
140 return balances[_owner];
141 }
142 }
143 /**
144 * @title Standard ERC20 token
145 *
146 * @dev Implementation of the basic standard token.
147 * @dev https://github.com/ethereum/EIPs/issues/20
148 * @dev Based on code by FirstBlood:
149 https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150 */
151 contract StandardToken is ERC20, BasicToken {
152 mapping (address => mapping (address => uint256)) internal allowed;
153 /**
154 * @dev Transfer tokens from one address to another
155 * @param _from address The address which you want to send tokens from
156 * @param _to address The address which you want to transfer to
157 * @param _value uint256 the amount of tokens to be transferred
158 */
159 function transferFrom(address _from, address _to, uint256 _value) public returns
160 (bool) {
161 require(_to != address(0));
162 require(_value <= balances[_from]);
163 require(_value <= allowed[_from][msg.sender]);
164 balances[_from] = balances[_from].sub(_value);
165 balances[_to] = balances[_to].add(_value);
166 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167 emit Transfer(_from, _to, _value);
168 return true;
169 }
170 /**
171 * @dev Approve the passed address to spend the specified amount of tokens on behalf
172 of msg.sender.
173 *
174 * Beware that changing an allowance with this method brings the risk that someone
175 may use both the old
176 * and the new allowance by unfortunate transaction ordering. One possible solution
177 to mitigate this
178 * race condition is to first reduce the spender's allowance to 0 and set the
179 desired value afterwards:
180 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181 * @param _spender The address which will spend the funds.
182 * @param _value The amount of tokens to be spent.
183 */
184 function approve(address _spender, uint256 _value) public returns (bool) {
185 require((_value == 0 ) || (allowed[msg.sender][_spender] == 0));
186 allowed[msg.sender][_spender] = _value;
187 emit Approval(msg.sender, _spender, _value);
188 return true;
189 }
190 /**
191 * @dev Function to check the amount of tokens that an owner allowed to a spender.
192 * @param _owner address The address which owns the funds.
193 * @param _spender address The address which will spend the funds.
194 * @return A uint256 specifying the amount of tokens still available for the
195 spender.
196 */
197 function allowance(address _owner, address _spender) public view returns (uint256) {
198 return allowed[_owner][_spender];
199 }
200 /**
201 * @dev Increase the amount of tokens that an owner allowed to a spender.
202 *
203 * approve should be called when allowed[_spender] == 0. To increment
204 * allowed value is better to use this function to avoid 2 calls (and wait until
205 * the first transaction is mined)
206 * From MonolithDAO Token.sol
207 * @param _spender The address which will spend the funds.
208 * @param _addedValue The amount of tokens to increase the allowance by.
209 */
210 function increaseApproval(address _spender, uint _addedValue) public returns (bool)
211 {
212 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 return true;
215 }
216 /**
217 * @dev Decrease the amount of tokens that an owner allowed to a spender.
218 *
219 * approve should be called when allowed[_spender] == 0. To decrement
220 * allowed value is better to use this function to avoid 2 calls (and wait until
221 * the first transaction is mined)
222 * From MonolithDAO Token.sol
223 * @param _spender The address which will spend the funds.
224 * @param _subtractedValue The amount of tokens to decrease the allowance by.
225 */
226 function decreaseApproval(address _spender, uint _subtractedValue) public returns
227 (bool) {
228 uint oldValue = allowed[msg.sender][_spender];
229 if (_subtractedValue > oldValue) {
230 allowed[msg.sender][_spender] = 0;
231 } else {
232 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233 }
234 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235 return true;
236 }
237 }
238 contract ADRToken is StandardToken{
239 string public constant name = "ADR Token"; // solium-disable-line uppercase
240 string public constant symbol = "ADR"; // solium-disable-line uppercase
241 uint8 public constant decimals = 18; // solium-disable-line uppercase
242 uint256 public constant INITIAL_SUPPLY = 1000000000000000000000000000;
243 uint256 public constant MAX_SUPPLY = 100 * 10000 * 10000 * (10 **
244 uint256(decimals));
245 /**
246 * @dev Constructor that gives msg.sender all of existing tokens.
247 */
248 constructor() ADRToken() public {
249 totalSupply_ = INITIAL_SUPPLY;
250 balances[msg.sender] = INITIAL_SUPPLY;
251 emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
252 }
253 
254 /**
255 * The fallback function.
256 */
257 function() payable public {
258 revert();
259 }
260 }