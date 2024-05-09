1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) constant returns (uint256);
33   function transfer(address to, uint256 value);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 /**
38  * @title Basic token
39  * @dev Basic version of StandardToken, with no allowances. 
40  */
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) {
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55   }
56 
57   /**
58   * @dev Gets the balance of the specified address.
59   * @param _owner The address to query the the balance of. 
60   * @return An uint256 representing the amount owned by the passed address.
61   */
62   function balanceOf(address _owner) constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value);
76   function approve(address spender, uint256 value);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) allowed;
83 
84 
85   /**
86    * @dev Transfer tokens from one address to another
87    * @param _from address The address which you want to send tokens from
88    * @param _to address The address which you want to transfer to
89    * @param _value uint256 the amout of tokens to be transfered
90    */
91   function transferFrom(address _from, address _to, uint256 _value) {
92     var _allowance = allowed[_from][msg.sender];
93 
94     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
95     // if (_value > _allowance) throw;
96 
97     balances[_to] = balances[_to].add(_value);
98     balances[_from] = balances[_from].sub(_value);
99     allowed[_from][msg.sender] = _allowance.sub(_value);
100     Transfer(_from, _to, _value);
101   }
102 
103   /**
104    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    * @param _spender The address which will spend the funds.
106    * @param _value The amount of tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) {
109 
110     // To change the approve amount you first have to reduce the addresses`
111     //  allowance to zero by calling `approve(_spender, 0)` if it is not
112     //  already 0 to mitigate the race condition described here:
113     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
115 
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118   }
119 
120   /**
121    * @dev Function to check the amount of tokens that an owner allowed to a spender.
122    * @param _owner address The address which owns the funds.
123    * @param _spender address The address which will spend the funds.
124    * @return A uint256 specifing the amount of tokens still avaible for the spender.
125    */
126   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127     return allowed[_owner][_spender];
128   }
129 
130 }
131 
132 /**
133  * @title Ownable
134  * @dev The Ownable contract has an owner address, and provides basic authorization control 
135  * functions, this simplifies the implementation of "user permissions". 
136  */
137 contract Ownable {
138   address public owner;
139 
140 
141   /** 
142    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
143    * account.
144    */
145   function Ownable() {
146     owner = msg.sender;
147   }
148 
149 
150   /**
151    * @dev Throws if called by any account other than the owner. 
152    */
153   modifier onlyOwner() {
154     if (msg.sender != owner) {
155       throw;
156     }
157     _;
158   }
159 
160 
161   /**
162    * @dev Allows the current owner to transfer control of the contract to a newOwner.
163    * @param newOwner The address to transfer ownership to. 
164    */
165   function transferOwnership(address newOwner) onlyOwner {
166     if (newOwner != address(0)) {
167       owner = newOwner;
168     }
169   }
170 
171 }
172 
173 contract MintableToken is StandardToken, Ownable {
174   event Mint(address indexed to, uint256 amount);
175   event MintFinished();
176 
177   bool public mintingFinished = false;
178 
179 
180   modifier canMint() {
181     if(mintingFinished) throw;
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
207 }
208 
209 contract BitplusToken is MintableToken {
210 
211   string public name = "BitplusToken";
212   string public symbol = "BPNT";
213   uint256 public decimals = 18;
214 
215   /**
216    * @dev Contructor.
217    */
218   function BitplusToken() {
219     totalSupply = 0;
220   }
221 
222 }