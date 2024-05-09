1 /**
2  * Investors relations:  You cant afford it 
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
96 contract WHALE is ERC20Interface,Ownable {
97 
98    using SafeMath for uint256;
99     uint256 public totalSupply;
100     mapping(address => uint256) tokenBalances;
101    
102    string public constant name = "WHALE";
103    string public constant symbol = "WHALE";
104    uint256 public constant decimals = 18;
105 
106    uint256 public constant INITIAL_SUPPLY = 337000;
107     address ownerWallet;
108    // Owner of account approves the transfer of an amount to another account
109    mapping (address => mapping (address => uint256)) allowed;
110    event Debug(string message, address addr, uint256 number);
111 
112     function WHALE(address wallet) public {
113         owner = msg.sender;
114         ownerWallet=wallet;
115         totalSupply = INITIAL_SUPPLY * 10 ** 18;
116         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
117     }
118  /**
119   * @dev transfer token for a specified address
120   * @param _to The address to transfer to.
121   * @param _value The amount to be transferred.
122   */
123   function transfer(address _to, uint256 _value) public returns (bool) {
124     require(tokenBalances[msg.sender]>=_value);
125     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
126     tokenBalances[_to] = tokenBalances[_to].add(_value);
127     Transfer(msg.sender, _to, _value);
128     return true;
129   }
130   
131   
132      /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= tokenBalances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142 
143     tokenBalances[_from] = tokenBalances[_from].sub(_value);
144     tokenBalances[_to] = tokenBalances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149   
150      /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166      // ------------------------------------------------------------------------
167      // Total supply
168      // ------------------------------------------------------------------------
169      function totalSupply() public constant returns (uint) {
170          return totalSupply  - tokenBalances[address(0)];
171      }
172      
173     
174      
175      // ------------------------------------------------------------------------
176      // Returns the amount of tokens approved by the owner that can be
177      // transferred to the spender's account
178      // ------------------------------------------------------------------------
179      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
180          return allowed[tokenOwner][spender];
181      }
182      
183      /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220      
221      // ------------------------------------------------------------------------
222      // Don't accept ETH
223      // ------------------------------------------------------------------------
224      function () public payable {
225          revert();
226      }
227  
228 
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param _owner The address to query the the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address _owner) constant public returns (uint256 balance) {
235     return tokenBalances[_owner];
236   }
237 
238     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
239         require(tokenBalances[buyer]>=tokenAmount);
240         tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);
241         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
242         Transfer(buyer, wallet, tokenAmount);
243      }
244     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
245         tokenBalance = tokenBalances[addr];
246     }
247 }