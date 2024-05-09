1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 if (a == 0) {
7 return 0;
8 }
9 uint256 c = a * b;
10 assert(c / a == b);
11 return c;
12 }
13 
14 function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 // assert(b > 0); // Solidity automatically throws when dividing by 0
16 uint256 c = a / b;
17 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18 return c;
19 }
20 
21 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22 assert(b <= a);
23 return a - b;
24 }
25 
26 function add(uint256 a, uint256 b) internal pure returns (uint256) {
27 uint256 c = a + b;
28 assert(c >= a);
29 return c;
30 }
31 }
32 contract Ownable {
33 address public owner;
34 
35 
36 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39 /**
40 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41 * account.
42 */
43 function Ownable() public {
44 owner = msg.sender;
45 }
46 
47 
48 /**
49 * @dev Throws if called by any account other than the owner.
50 */
51 modifier onlyOwner() {
52 require(msg.sender == owner);
53 _;
54 }
55 
56 
57 /**
58 * @dev Allows the current owner to transfer control of the contract to a newOwner.
59 * @param newOwner The address to transfer ownership to.
60 */
61 function transferOwnership(address newOwner) public onlyOwner {
62 require(newOwner != address(0));
63 OwnershipTransferred(owner, newOwner);
64 owner = newOwner;
65 }
66 
67 }
68 
69 
70 /**
71 * @title ERC20Basic
72 * @dev Simpler version of ERC20 interface
73 */
74 contract ERC20Basic {
75 uint256 public totalSupply;
76 function balanceOf(address who) public view returns (uint256);
77 function transfer(address to, uint256 value) public returns (bool);
78 event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 contract ERC20 is ERC20Basic {
82 function allowance(address owner, address spender) public view returns (uint256);
83 function transferFrom(address from, address to, uint256 value) public returns (bool);
84 function approve(address spender, uint256 value) public returns (bool);
85 event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 contract BasicToken is ERC20Basic {
88 using SafeMath for uint256;
89 
90 mapping(address => uint256) balances;
91 
92 /**
93 * @dev transfer token for a specified address
94 * @param _to The address to transfer to.
95 * @param _value The amount to be transferred.
96 */
97 function transfer(address _to, uint256 _value) public returns (bool) {
98 require(_to != address(0));
99 require(_value <= balances[msg.sender]);
100 
101 // SafeMath.sub will throw if there is not enough balance.
102 balances[msg.sender] = balances[msg.sender].sub(_value);
103 balances[_to] = balances[_to].add(_value);
104 Transfer(msg.sender, _to, _value);
105 return true;
106 }
107 
108 /**
109 * @dev Gets the balance of the specified address.
110 * @param _owner The address to query the the balance of.
111 * @return An uint256 representing the amount owned by the passed address.
112 */
113 function balanceOf(address _owner) public view returns (uint256 balance) {
114 return balances[_owner];
115 }
116 
117 
118 
119 
120 
121 
122 }
123 
124 contract StandardToken is ERC20, BasicToken {
125 
126 mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129 
130 
131 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132 require(_to != address(0));
133 require(_value <= balances[_from]);
134 require(_value <= allowed[_from][msg.sender]);
135 
136 balances[_from] = balances[_from].sub(_value);
137 balances[_to] = balances[_to].add(_value);
138 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139 Transfer(_from, _to, _value);
140 return true;
141 }
142 
143 /**
144 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145 *
146 * Beware that changing an allowance with this method brings the risk that someone may use both the old
147 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150 * @param _spender The address which will spend the funds.
151 * @param _value The amount of tokens to be spent.
152 */
153 function approve(address _spender, uint256 _value) public returns (bool) {
154 allowed[msg.sender][_spender] = _value;
155 Approval(msg.sender, _spender, _value);
156 return true;
157 }
158 
159 /**
160 * @dev Function to check the amount of tokens that an owner allowed to a spender.
161 * @param _owner address The address which owns the funds.
162 * @param _spender address The address which will spend the funds.
163 * @return A uint256 specifying the amount of tokens still available for the spender.
164 */
165 function allowance(address _owner, address _spender) public view returns (uint256) {
166 return allowed[_owner][_spender];
167 }
168 
169 /**
170 * approve should be called when allowed[_spender] == 0. To increment
171 * allowed value is better to use this function to avoid 2 calls (and wait until
172 * the first transaction is mined)
173 * From MonolithDAO Token.sol
174 */
175 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
176 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178 return true;
179 }
180 
181 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
182 uint oldValue = allowed[msg.sender][_spender];
183 if (_subtractedValue > oldValue) {
184 allowed[msg.sender][_spender] = 0;
185 } else {
186 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187 }
188 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189 return true;
190 }
191 
192 }
193 /**
194 * @title SimpleToken
195 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
196 * Note they can later distribute these tokens as they wish using `transfer` and other
197 * `StandardToken` functions.
198 */
199 contract IranCoinToken is StandardToken, Ownable {
200 
201 string public constant name = "Zarig";
202 string public constant symbol = "ICD";
203 uint8 public constant decimals = 18;
204 uint256 public constant rewards = 8000000 * (10 ** uint256(decimals));
205 uint256 public constant INITIAL_SUPPLY = 17000000 * (10 ** uint256(decimals));
206 
207 /**
208 * @dev Constructor that gives msg.sender all of existing tokens.
209 */
210 function IranCoinToken() public {
211 totalSupply == INITIAL_SUPPLY.add(rewards);
212 balances[msg.sender] = INITIAL_SUPPLY;
213 }
214 }