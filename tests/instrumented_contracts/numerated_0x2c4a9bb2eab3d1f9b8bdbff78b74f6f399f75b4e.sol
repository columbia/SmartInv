1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20Basic {
80     /// Total amount of tokens
81   uint256 public totalSupply;
82   
83   function balanceOf(address _owner) public view returns (uint256 balance);
84   
85   function transfer(address _to, uint256 _amount) public returns (bool success);
86   
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
96   
97   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
98   
99   function approve(address _spender, uint256 _amount) public returns (bool success);
100   
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   //balance in each address account
112   mapping(address => uint256) balances;
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _amount The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _amount) public returns (bool success) {
120     require(_to != address(0));
121     require(balances[msg.sender] >= _amount && _amount > 0
122         && balances[_to].add(_amount) > balances[_to]);
123 
124     // SafeMath.sub will throw if there is not enough balance.
125     balances[msg.sender] = balances[msg.sender].sub(_amount);
126     balances[_to] = balances[_to].add(_amount);
127     emit Transfer(msg.sender, _to, _amount);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) public view returns (uint256 balance) {
137     return balances[_owner];
138   }
139 
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  */
148 contract StandardToken is ERC20, BasicToken {
149   
150   
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _amount uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
161     require(_to != address(0));
162     require(balances[_from] >= _amount);
163     require(allowed[_from][msg.sender] >= _amount);
164     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
165 
166     balances[_from] = balances[_from].sub(_amount);
167     balances[_to] = balances[_to].add(_amount);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
169     emit Transfer(_from, _to, _amount);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _amount The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _amount) public returns (bool success) {
184     allowed[msg.sender][_spender] = _amount;
185     emit Approval(msg.sender, _spender, _amount);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199 }
200 
201 /**
202  * @title Burnable Token
203  * @dev Token that can be irreversibly burned (destroyed).
204  */
205 contract BurnableToken is StandardToken, Ownable {
206 
207     event Burn(address indexed burner, uint256 value);
208 
209     /**
210      * @dev Burns a specific amount of tokens.
211      * @param _value The amount of token to be burned.
212      */
213     function burn(uint256 _value) public onlyOwner{
214         require(_value <= balances[msg.sender]);
215         // no need to require value <= totalSupply, since that would imply the
216         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
217 
218         balances[msg.sender] = balances[msg.sender].sub(_value);
219         totalSupply = totalSupply.sub(_value);
220         emit Burn(msg.sender, _value);
221     }
222 }
223 /**
224  * @title Ezcash Token
225  * @dev Token representing EZE.
226  */
227  contract Ezcash is BurnableToken {
228      string public name ;
229      string public symbol ;
230      uint8 public decimals = 18;
231      
232      /**
233      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
234      */
235      function ()public payable {
236          revert();
237      }
238      
239      /**
240      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
241      */
242      constructor(address wallet) public 
243      {
244          owner = wallet;
245          totalSupply = uint(15000000000).mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
246          name = "ezcash";
247          symbol = "EZE";
248          balances[wallet] = totalSupply;
249          
250          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
251          emit Transfer(address(0), msg.sender, totalSupply);
252      }
253      
254      /**
255      *@dev helper method to get token details, name, symbol and totalSupply in one go
256      */
257     function getTokenDetail() public view returns (string, string, uint256) {
258 	    return (name, symbol, totalSupply);
259     }
260  }