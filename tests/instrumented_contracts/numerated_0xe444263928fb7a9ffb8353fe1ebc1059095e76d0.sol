1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner {
67     if (newOwner != address(0)) {
68       owner = newOwner;
69     }
70   }
71 
72 }
73 
74 
75 contract ERC20Basic {
76   uint256 public totalSupply;
77   function balanceOf(address who) constant returns (uint256);
78   function transfer(address to, uint256 value) returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) returns (bool) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of. 
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant returns (uint256);
112   function transferFrom(address from, address to, uint256 value) returns (bool);
113   function approve(address spender, uint256 value) returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amout of tokens to be transfered
127    */
128   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
129     var _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133 
134     balances[_to] = balances[_to].add(_value);
135     balances[_from] = balances[_from].sub(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) returns (bool) {
147 
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender, 0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifing the amount of tokens still avaible for the spender.
164    */
165   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169 }
170 
171 
172 /**
173  * @title Mintable token
174  * @dev Simple ERC20 Token example, with mintable token creation
175  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
176  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
177  */
178 
179 contract MintableToken is StandardToken, Ownable {
180   event Mint(address indexed to, uint256 amount);
181   event MintFinished();
182 
183   bool public mintingFinished = false;
184 
185 
186   modifier canMint() {
187     require(!mintingFinished);
188     _;
189   }
190 
191   /**
192    * @dev Function to mint tokens
193    * @param _to The address that will recieve the minted tokens.
194    * @param _amount The amount of tokens to mint.
195    * @return A boolean that indicates if the operation was successful.
196    */
197   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
198     totalSupply = totalSupply.add(_amount);
199     balances[_to] = balances[_to].add(_amount);
200     Mint(_to, _amount);
201     return true;
202   }
203 
204   /**
205    * @dev Function to stop minting new tokens.
206    * @return True if the operation was successful.
207    */
208   function finishMinting() onlyOwner returns (bool) {
209     mintingFinished = true;
210     MintFinished();
211     return true;
212   }
213 }
214 
215 contract IouRootsPresaleToken is MintableToken {
216 
217     string public name;
218     
219     string public symbol;
220     
221     uint8 public decimals;
222 
223     // This is not a ROOT token.
224     // This token is used for the preallocation of the ROOT token, that will be issued later.
225     // Only Owner can transfer balances and mint ROOTS without payment.
226     // Owner can finalize the contract by `finishMinting` transaction
227     function IouRootsPresaleToken(string _name, string _symbol, uint8 _decimals) {
228         name = _name;
229         symbol = _symbol;
230         decimals = _decimals;
231     }
232 
233     function transfer(address _to, uint _value) onlyOwner returns (bool) {
234         return super.transfer(_to, _value);
235     }
236 
237     function transferFrom(address _from, address _to, uint _value) onlyOwner returns (bool) {
238         return super.transferFrom(_from, _to, _value);
239     }
240 }