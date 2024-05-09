1 /**
2  *  The Peurcoin token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  *  The owner's shareholder of tokens is locked for three year and not all tokens
4  *  being sold during or after the crowdsale,reserved token will be use only for loyalty program.
5  *  Author: Nancy Abrianna
6  *  Internal audit: Felix Norge, John Dewitt
7  *  Audit: Smart Contract Consultant
8  **/
9 
10 pragma solidity ^0.4.15;
11 
12 
13 /**
14  * ERC 20 token
15  *
16  * https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20Basic {
19   uint256 public totalSupply;
20   function balanceOf(address who) constant returns (uint256);
21   function transfer(address to, uint256 value) returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 /**
26  * ERC 20 token
27  *
28  * https://github.com/ethereum/EIPs/issues/20
29  */
30 contract ERC20 is ERC20Basic {
31   function allowance(address owner, address spender) constant returns (uint256);
32   function transferFrom(address from, address to, uint256 value) returns (bool);
33   function approve(address spender, uint256 value) returns (bool);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 /**
38  * Overflow aware uint math functions.
39  *
40  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
41  */
42 library SafeMath {
43   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a * b;
45     assert(a == 0 || c / a == b);
46     return c;
47   }
48 
49   function div(uint256 a, uint256 b) internal constant returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   function add(uint256 a, uint256 b) internal constant returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 /**
69  * ERC 20 token
70  *
71  * https://github.com/ethereum/EIPs/issues/20
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) returns (bool) {
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) constant returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99 }
100 
101 /**
102  * ERC 20 token
103  *
104  * https://github.com/ethereum/EIPs/issues/20
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amout of tokens to be transfered
116    */
117   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
118     var _allowance = allowed[_from][msg.sender];
119 
120     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
121     // require (_value <= _allowance);
122 
123     balances[_to] = balances[_to].add(_value);
124     balances[_from] = balances[_from].sub(_value);
125     allowed[_from][msg.sender] = _allowance.sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) returns (bool) {
136 
137     // To change the approve amount you first have to reduce the addresses`
138     //  allowance to zero by calling `approve(_spender, 0)` if it is not
139     //  already 0 to mitigate the race condition described here:
140     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
142 
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifing the amount of tokens still avaible for the spender.
153    */
154   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 contract Ownable {
161   address public owner;
162 
163 
164   /**
165    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166    * account.
167    */
168   function Ownable() {
169     owner = msg.sender;
170   }
171 
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181 
182   /**
183    * @dev Allows the current owner to transfer control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function transferOwnership(address newOwner) onlyOwner {
187     if (newOwner != address(0)) {
188       owner = newOwner;
189     }
190   }
191 
192 }
193 
194 
195 contract PeurToken is StandardToken, Ownable {
196   string public constant name = "Peurcoin";
197   string public constant symbol = "PURC";
198   uint8 public constant decimals = 8;
199   uint256 public constant INITIAL_SUPPLY = 200000000 * 10 ** uint256(decimals); // 200.000.000 Tokens
200  // replace with your fund collection multisig address
201   address public constant multisig = 0x0;
202 
203 
204   // 1 ether = 8.000 Peur tokens
205   uint public constant PRICE = 8000;
206   
207   function PeurToken() {
208       totalSupply = INITIAL_SUPPLY;
209       balances[msg.sender] = INITIAL_SUPPLY;
210       owner = msg.sender;
211   }
212 }
213 
214 /**
215  * 130.000.000 PURC tokens distributed for ICO 
216  *  42.300.000 PURC tokens distributed for loyalty program
217  *  17.500.000 PURC tokens distributed for peur marketplace department
218  *   5.200.000 PURC tokens distributed for bounty campaign
219  *   5.000.000 PURC tokens distributed for shareholder
220  * Overall, 200.000.000 PURC tokens fixed supply 
221  * All crowdsale depositors must have read the legal agreement.
222  * They give their crowdsale Ethereum source address on the website.
223  * This is confirmed by having them signing the terms of service on the website.
224  */