1 /*
2 This file is TopTenCoinToken Contract
3 */
4 
5 pragma solidity ^0.5.1;
6 
7 /**
8  * @title ERC20Basic
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return a * b;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a / b;
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 
54 }
55 
56 /**
57  * @title Basic token
58  */
59 contract BasicToken is ERC20Basic {
60 
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     emit Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) public view returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  */
91 contract StandardToken is ERC20, BasicToken {
92 
93   mapping (address => mapping (address => uint256)) allowed;
94 
95   /**
96    * @dev Transfer tokens from one address to another
97    * @param _from address The address which you want to send tokens from
98    * @param _to address The address which you want to transfer to
99    * @param _value uint256 The amout of tokens to be transfered
100    */
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     uint256 _allowance = allowed[_from][msg.sender];
103 
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     emit Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) public returns (bool) {
117 
118     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
119 
120     allowed[msg.sender][_spender] = _value;
121     emit Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifing the amount of tokens still available for the spender.
130    */
131   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
132     return allowed[_owner][_spender];
133   }
134 
135 }
136 
137 /**
138  * @title Ownable
139  */
140 contract Ownable {
141 
142   address public owner;
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146    * account.
147    */
148   constructor () public {
149     owner = msg.sender;
150   }
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160   /**
161    * @dev Allows the current owner to transfer control of the contract to a newOwner.
162    * @param newOwner The address to transfer ownership to.
163    */
164   function transferOwnership(address newOwner) public onlyOwner {
165     require(newOwner != address(0));
166     owner = newOwner;
167   }
168 
169 }
170 
171 /**
172  * @title Mintable token
173  */
174 contract MintableToken is StandardToken, Ownable {
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
191   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
192     totalSupply = totalSupply.add(_amount);
193     balances[_to] = balances[_to].add(_amount);
194     emit Transfer(address(0), _to, _amount);
195     return true;
196   }
197 
198   /**
199    * @dev Function to stop minting new tokens.
200    * @return A boolean that indicates if the operation was successful.
201    */
202   function finishMinting() public onlyOwner returns (bool) {
203     mintingFinished = true;
204     emit MintFinished();
205     return true;
206   }
207 
208 }
209 
210 contract TopTenCoinToken is MintableToken {
211 
212     string public constant name = "Top Ten Coin";
213 
214     string public constant symbol = "TPT";
215 
216     uint32 public constant decimals = 8;
217 
218 }