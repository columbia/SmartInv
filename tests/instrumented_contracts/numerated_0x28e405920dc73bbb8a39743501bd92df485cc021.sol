1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     /// Total amount of tokens
44   uint256 public totalSupply;
45   
46   function balanceOf(address _owner) public view returns (uint256);
47   
48   function transfer(address _to, uint256 _amount) public returns (bool);
49   
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address _owner, address _spender) public view returns (uint256);
59   
60   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool);
61   
62   function approve(address _spender, uint256 _amount) public returns (bool);
63   
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   //balance in each address account
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _amount The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _amount) public returns (bool) {
83     require(_to != address(0));
84     require(balances[msg.sender] >= _amount && _amount > 0
85         && balances[_to].add(_amount) > balances[_to]);
86 
87     // SafeMath.sub will throw if there is not enough balance.
88     balances[msg.sender] = balances[msg.sender].sub(_amount);
89     balances[_to] = balances[_to].add(_amount);
90     Transfer(msg.sender, _to, _amount);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  */
111 contract StandardToken is ERC20, BasicToken {
112   
113   
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _amount uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
124     require(_to != address(0));
125     require(balances[_from] >= _amount);
126     require(allowed[_from][msg.sender] >= _amount);
127     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
128 
129     balances[_from] = balances[_from].sub(_amount);
130     balances[_to] = balances[_to].add(_amount);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
132     Transfer(_from, _to, _amount);
133     return true;
134   }
135 
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _amount The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _amount) public returns (bool) {
147     allowed[msg.sender][_spender] = _amount;
148     Approval(msg.sender, _spender, _amount);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifying the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) public view returns (uint256) {
159     return allowed[_owner][_spender];
160   }
161 
162 }
163 /**
164  * @title Burnable Token
165  * @dev Token that can be irreversibly burned (destroyed).
166  */
167 contract BurnableToken is StandardToken {
168 
169     event Burn(address indexed burner, uint256 value);
170 
171     /**
172      * @dev Burns a specific amount of tokens.
173      * @param _value The amount of token to be burned.
174      */
175     function burn(uint256 _value) public {
176         require(_value <= balances[msg.sender]);
177         // no need to require value <= totalSupply, since that would imply the
178         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
179 
180         balances[msg.sender] = balances[msg.sender].sub(_value);
181         totalSupply = totalSupply.sub(_value);
182         Burn(msg.sender, _value);
183     }
184 }
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable()public {
200     owner = msg.sender;
201   }
202 
203 
204   /**
205    * @dev Throws if called by any account other than the owner.
206    */
207   modifier onlyOwner() {
208     require(msg.sender == owner);
209     _;
210   }
211 
212 
213   /**
214    * @dev Allows the current owner to transfer control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function transferOwnership(address newOwner)public onlyOwner {
218     if (newOwner != address(0)) {
219       owner = newOwner;
220     }
221   }
222 }
223 /**
224  * @title VTOS Token
225  * @dev Token representing VTOS.
226  */
227  contract VTOSToken is BurnableToken, Ownable {
228      string public name ;
229      string public symbol ;
230      uint8 public decimals = 18 ;
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
241      * @param initialSupply The initial supply of tokens which will be fixed through out
242      * @param tokenName The name of the token
243      * @param tokenSymbol The symboll of the token
244      */
245      function VTOSToken(
246             uint256 initialSupply,
247             string tokenName,
248             string tokenSymbol
249          ) public {
250          totalSupply = initialSupply * 10 ** uint256(decimals); //Update total supply with the decimal amount
251          name = tokenName;
252          symbol = tokenSymbol;
253          balances[msg.sender] = totalSupply;
254          
255          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
256          Transfer(address(0), msg.sender, totalSupply);
257      }
258      
259      /**
260      * @dev allows token holders to send tokens to multiple addresses from one single transaction
261      * Beware that sending tokens to large number of addresses in one transaction might exceed gas limit of the 
262      * transaction or even for the entire block. Not putting any restriction on the number of addresses which are
263      * allowed per transaction. But it should be taken into account while creating dapps.
264      * @param dests The addresses to whom user wants to send tokens
265      * @param values The number of tokens to be sent to each address
266      */
267      function multiSend(address[]dests, uint[]values)public{
268         require(dests.length==values.length);
269         uint256 i = 0;
270         while (i < dests.length) {
271            transfer(dests[i], values[i]);
272            i += 1;
273         }
274      }
275      
276      /**
277      *@dev helper method to get token details, name, symbol and totalSupply in one go
278      */
279     function getTokenDetail() public view returns (string, string, uint256) {
280 	    return (name, symbol, totalSupply);
281     }
282  }