1 /**
2  * Enjoy your tokens!
3 **/
4 
5 pragma solidity ^0.4.18;
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
96 interface OldXRPCToken {
97     function transfer(address receiver, uint amount) external;
98     function balanceOf(address _owner) external returns (uint256 balance);
99     function mint(address wallet, address buyer, uint256 tokenAmount) external;
100     function showMyTokenBalance(address addr) external;
101 }
102 contract CryptoBonesToken is ERC20Interface,Ownable {
103 
104    using SafeMath for uint256;
105     uint256 public totalSupply;
106     mapping(address => uint256) tokenBalances;
107    
108    string public constant name = "CryptoBones";
109    string public constant symbol = "CBT";
110    uint256 public constant decimals = 18;
111 
112    uint256 public constant INITIAL_SUPPLY = 10000000;
113     address ownerWallet;
114    // Owner of account approves the transfer of an amount to another account
115    mapping (address => mapping (address => uint256)) allowed;
116    event Debug(string message, address addr, uint256 number);
117 
118     function ARBITRAGEToken(address wallet) public {
119         owner = msg.sender;
120         ownerWallet=wallet;
121         totalSupply = INITIAL_SUPPLY * 10 ** 18;
122         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
123     }
124  /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(tokenBalances[msg.sender]>=_value);
131     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
132     tokenBalances[_to] = tokenBalances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136   
137   
138      /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= tokenBalances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     tokenBalances[_from] = tokenBalances[_from].sub(_value);
150     tokenBalances[_to] = tokenBalances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155   
156      /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172      // ------------------------------------------------------------------------
173      // Total supply
174      // ------------------------------------------------------------------------
175      function totalSupply() public constant returns (uint) {
176          return totalSupply  - tokenBalances[address(0)];
177      }
178      
179     
180      
181      // ------------------------------------------------------------------------
182      // Returns the amount of tokens approved by the owner that can be
183      // transferred to the spender's account
184      // ------------------------------------------------------------------------
185      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186          return allowed[tokenOwner][spender];
187      }
188      
189      /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226      
227      // ------------------------------------------------------------------------
228      // Don't accept ETH
229      // ------------------------------------------------------------------------
230      function () public payable {
231          revert();
232      }
233  
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param _owner The address to query the the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address _owner) constant public returns (uint256 balance) {
241     return tokenBalances[_owner];
242   }
243 
244     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
245       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
246       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
247       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
248       Transfer(wallet, buyer, tokenAmount); 
249       totalSupply=totalSupply.sub(tokenAmount);
250     }
251     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
252         require(tokenBalances[buyer]>=tokenAmount);
253         tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);
254         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
255         Transfer(buyer, wallet, tokenAmount);
256         totalSupply=totalSupply.add(tokenAmount);
257      }
258     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
259         tokenBalance = tokenBalances[addr];
260     }
261 }