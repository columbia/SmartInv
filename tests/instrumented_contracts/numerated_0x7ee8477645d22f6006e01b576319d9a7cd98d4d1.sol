1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) returns (bool) {
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   /**
54   * @dev Gets the balance of the specified address.
55   * @param _owner The address to query the the balance of. 
56   * @return An uint256 representing the amount owned by the passed address.
57   */
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amout of tokens to be transfered
81    */
82   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83     var _allowance = allowed[_from][msg.sender];
84 
85     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86     // require (_value <= _allowance);
87 
88     balances[_to] = balances[_to].add(_value);
89     balances[_from] = balances[_from].sub(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * @param _spender The address which will spend the funds.
98    * @param _value The amount of tokens to be spent.
99    */
100   function approve(address _spender, uint256 _value) returns (bool) {
101 
102     // To change the approve amount you first have to reduce the addresses`
103     //  allowance to zero by calling `approve(_spender, 0)` if it is not
104     //  already 0 to mitigate the race condition described here:
105     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifing the amount of tokens still avaible for the spender.
118    */
119   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123 }
124 
125 contract Ownable {
126   address public owner;
127 
128 
129   /**
130    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131    * account.
132    */
133   function Ownable() {
134     owner = msg.sender;
135   }
136 
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) onlyOwner {
152     if (newOwner != address(0)) {
153       owner = newOwner;
154     }
155   }
156 
157 }
158 
159 contract MintableToken is StandardToken, Ownable {
160   event Mint(address indexed to, uint256 amount);
161   event MintFinished();
162 
163   bool public mintingFinished = false;
164 
165 
166   modifier canMint() {
167     require(!mintingFinished);
168     _;
169   }
170 
171   /**
172    * @dev Function to mint tokens
173    * @param _to The address that will recieve the minted tokens.
174    * @param _amount The amount of tokens to mint.
175    * @return A boolean that indicates if the operation was successful.
176    */
177   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
178     totalSupply = totalSupply.add(_amount);
179     balances[_to] = balances[_to].add(_amount);
180     Mint(_to, _amount);
181     return true;
182   }
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner returns (bool) {
189     mintingFinished = true;
190     MintFinished();
191     return true;
192   }
193 }
194 
195 contract VanilCoin is MintableToken {
196   	
197 	string public name = "Vanil";
198   	string public symbol = "VAN";
199   	uint256 public decimals = 18;
200   
201   	// tokens locked for one week after ICO, 8 Oct 2017, 0:0:0 GMT: 1507420800
202   	uint public releaseTime = 1507420800;
203   
204 	modifier canTransfer(address _sender, uint256 _value) {
205 		require(_value <= transferableTokens(_sender, now));
206 	   	_;
207 	}
208 	
209 	function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
210 		return super.transfer(_to, _value);
211 	}
212 	
213 	function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
214 		return super.transferFrom(_from, _to, _value);
215 	}
216 	
217 	function transferableTokens(address holder, uint time) constant public returns (uint256) {
218 		
219 		uint256 result = 0;
220 				
221 		if(time > releaseTime){
222 			result = balanceOf(holder);
223 		}
224 		
225 		return result;
226 	}
227 	
228 }