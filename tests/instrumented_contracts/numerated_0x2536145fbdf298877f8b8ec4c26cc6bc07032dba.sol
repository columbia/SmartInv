1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function approve(address spender, uint256 value) returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30     
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54   
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken. 
60  */
61 contract BasicToken is ERC20Basic {
62     
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) returns (bool) {
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of. 
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) constant returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
99 
100   /**
101    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) returns (bool) {
106 
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling `approve(_spender, 0)` if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifing the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127 
128 }
129 
130 /**
131  * @title Ownable
132  * @dev The Ownable contract has an owner address, and provides basic authorization control
133  * functions, this simplifies the implementation of "user permissions".
134  */
135 contract Ownable {
136     
137   address public owner;
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   function Ownable() {
144     owner = msg.sender;
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155   /**
156    * @dev Allows the current owner to transfer control of the contract to a newOwner.
157    * @param newOwner The address to transfer ownership to.
158    */
159   function transferOwnership(address newOwner) onlyOwner {
160     require(newOwner != address(0));      
161     owner = newOwner;
162   }
163 
164 }
165 
166 /**
167  * @title Mintable token
168  * @dev Simple ERC20 Token example, with mintable token creation
169  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
170  */
171 
172 contract MintableToken is StandardToken, Ownable {
173     
174   event Mint(address indexed to, uint256 amount);
175   
176   event MintFinished();
177 
178   bool public mintingFinished = false;
179 
180   modifier canMint() {
181     require(!mintingFinished);
182     _;
183   }
184 
185   /**
186    * @dev Function to mint tokens
187    * @param _to The address that will recieve the minted tokens.
188    * @param _amount The amount of tokens to mint.
189    * @return A boolean that indicates if the operation was successful.
190    */
191   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
192     totalSupply = totalSupply.add(_amount);
193     balances[_to] = balances[_to].add(_amount);
194     Mint(_to, _amount);
195     return true;
196   }
197 
198   /**
199    * @dev Function to stop minting new tokens.
200    * @return True if the operation was successful.
201    */
202   function finishMinting() onlyOwner returns (bool) {
203     mintingFinished = true;
204     MintFinished();
205     return true;
206   }
207   
208 }
209 
210 contract Veritium is MintableToken {
211     
212     string public constant name = "Veritium";
213     
214     string public constant symbol = "VRTM";
215     
216     uint32 public constant decimals = 18;
217     
218 }