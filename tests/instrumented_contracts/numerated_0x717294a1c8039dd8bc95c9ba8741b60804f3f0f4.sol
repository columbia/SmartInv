1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32  
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public constant returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, require mintingFinished before start transfers
63  */
64 contract BasicToken is ERC20Basic {
65     
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69   bool public mintingFinished = false;
70 
71   mapping(address => uint256) releaseTime;
72   // Only after finishMinting and checks for bounty accounts time restrictions
73   modifier timeAllowed() {
74     require(mintingFinished);
75     require(now > releaseTime[msg.sender]); //finishSale + releasedays * 1 days
76     _;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public timeAllowed returns (bool) {
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of. 
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100   // release time of freezed account
101   function releaseAt(address _owner) public constant returns (uint256 date) {
102     return releaseTime[_owner];
103   }
104   // change restricted releaseXX account
105   function changeReleaseAccount(address _owner, address _newowner) public returns (bool) {
106     require(releaseTime[_owner] != 0 );
107     require(releaseTime[_newowner] == 0 );
108     balances[_newowner] = balances[_owner];
109     releaseTime[_newowner] = releaseTime[_owner];
110     balances[_owner] = 0;
111     releaseTime[_owner] = 0;
112     return true;
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amout of tokens to be transfered
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(mintingFinished);
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public timeAllowed returns (bool) {
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender, 0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
159 
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifing the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183     
184   address public owner;
185 
186   /**
187    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188    * account.
189    */
190   function Ownable() public {
191     owner = msg.sender;
192   }
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) public onlyOwner {
207     require(newOwner != address(0));
208     owner = newOwner;
209   }
210 
211 }
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221     
222   event Mint(address indexed to, uint256 amount);
223   event UnMint(address indexed from, uint256 amount);
224   event MintFinished();
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
235    * @param _releaseTime The (optional) freeze time for bounty accounts.
236    * @return A boolean that indicates if the operation was successful.
237    */
238   function mint(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint returns (bool) {
239     totalSupply = totalSupply.add(_amount);
240     balances[_to] = balances[_to].add(_amount);
241     if ( _releaseTime > 0 ) {
242         releaseTime[_to] = _releaseTime;
243     }
244     Mint(_to, _amount);
245     return true;
246   }
247   // drain tokens with refund
248   function unMint(address _from) public onlyOwner returns (bool) {
249     totalSupply = totalSupply.sub(balances[_from]);
250     UnMint(_from, balances[_from]);
251     balances[_from] = 0;
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() public onlyOwner returns (bool) {
260     mintingFinished = true;
261     MintFinished();
262     return true;
263   }
264   
265 }
266 
267 
268 contract ArconaToken is MintableToken {
269     
270     string public constant name = "Arcona Distribution Contract";
271     string public constant symbol = "Arcona";
272     uint32 public constant decimals = 3; // 0.001
273    
274 }