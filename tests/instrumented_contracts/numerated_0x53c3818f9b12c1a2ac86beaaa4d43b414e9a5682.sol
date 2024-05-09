1 /*
2 Capital Technologies & Research - Capital GAS (CALLG)
3 */
4 pragma solidity ^0.4.19;
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83     /// Total amount of tokens
84   uint256 public totalSupply;
85   
86   function balanceOf(address _owner) public view returns (uint256 balance);
87   
88   function transfer(address _to, uint256 _amount) public returns (bool success);
89   
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99   
100   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
101   
102   function approve(address _spender, uint256 _amount) public returns (bool success);
103   
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   //balance in each address account
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _amount The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _amount) public returns (bool success) {
123     require(_to != address(0));
124     require(balances[msg.sender] >= _amount && _amount > 0
125         && balances[_to].add(_amount) > balances[_to]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_amount);
129     balances[_to] = balances[_to].add(_amount);
130     emit Transfer(msg.sender, _to, _amount);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  */
151 contract StandardToken is ERC20, BasicToken {
152   
153   
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _amount uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
164     require(_to != address(0));
165     require(balances[_from] >= _amount);
166     require(allowed[_from][msg.sender] >= _amount);
167     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
168 
169     balances[_from] = balances[_from].sub(_amount);
170     balances[_to] = balances[_to].add(_amount);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
172     emit Transfer(_from, _to, _amount);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _amount The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _amount) public returns (bool success) {
187     allowed[msg.sender][_spender] = _amount;
188     emit Approval(msg.sender, _spender, _amount);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 
202 }
203 
204 /**
205  * @title Burnable Token
206  * @dev Token that can be irreversibly burned (destroyed).
207  */
208 contract BurnableToken is StandardToken, Ownable {
209 
210     event Burn(address indexed burner, uint256 value);
211 
212     /**
213      * @dev Burns a specific amount of tokens.
214      * @param _value The amount of token to be burned.
215      */
216     function burn(uint256 _value) public onlyOwner{
217         require(_value <= balances[msg.sender]);
218         // no need to require value <= totalSupply, since that would imply the
219         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
220 
221         balances[msg.sender] = balances[msg.sender].sub(_value);
222         totalSupply = totalSupply.sub(_value);
223         emit Burn(msg.sender, _value);
224     }
225 }
226 /**
227  * @title CAPITAL GAS (CALLG) Token
228  * @dev Token representing CALLG.
229  */
230  contract CALLGToken is BurnableToken {
231      string public name;
232      string public symbol;
233      uint256 public totalSupply;
234      uint8 public decimals = 18 ;
235      /**
236      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
237      */
238      function () public payable {
239          revert();
240      }
241      
242      /**
243      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
244      * @param initialSupply The initial supply of tokens which will be fixed through out
245      * @param tokenName The name of the token
246      * @param tokenSymbol The symboll of the token
247      */
248      function CALLGToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
249          totalSupply = initialSupply.mul( 10 ** uint256(decimals));
250          name = tokenName;
251          symbol = tokenSymbol;
252          balances[msg.sender] = totalSupply;
253          
254          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
255          emit Transfer(address(0), msg.sender, totalSupply);
256      }
257      
258      /**
259      *@dev helper method to get token details, name, symbol and totalSupply in one go
260      */
261     function getTokenDetail() public view returns (string, string, uint256) {
262 	    return (name, symbol, totalSupply);
263     }
264  }