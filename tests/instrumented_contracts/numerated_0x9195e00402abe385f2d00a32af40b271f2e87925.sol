1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Crowdsale
5  * @dev Crowdsale is a base contract for managing a token crowdsale.
6  * Crowdsales have a start and end timestamps, where investors can make
7  * token purchases and the crowdsale will assign them tokens based
8  * on a token per ETH rate. Funds collected are forwarded to a wallet
9  * as they arrive.
10  */
11  
12  
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20  function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Standard
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Interface {
81      function totalSupply() public constant returns (uint);
82      function balanceOf(address tokenOwner) public constant returns (uint balance);
83      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
84      function transfer(address to, uint tokens) public returns (bool success);
85      function approve(address spender, uint tokens) public returns (bool success);
86      function transferFrom(address from, address to, uint tokens) public returns (bool success);
87      event Transfer(address indexed from, address indexed to, uint tokens);
88      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
89 }
90 contract EtheeraToken is ERC20Interface,Ownable {
91 
92     using SafeMath for uint256;
93    
94     mapping(address => uint256) tokenBalances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 
98     string public constant name = "ETHEERA";
99     string public constant symbol = "ETA";
100     uint256 public constant decimals = 18;
101 
102    uint256 public constant INITIAL_SUPPLY = 75000000000;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(tokenBalances[msg.sender]>=_value);
111     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
112     tokenBalances[_to] = tokenBalances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) constant public returns (uint256 balance) {
123     return tokenBalances[_owner];
124   }
125   
126   
127      /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= tokenBalances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     tokenBalances[_from] = tokenBalances[_from].sub(_value);
139     tokenBalances[_to] = tokenBalances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144   
145      /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161      // ------------------------------------------------------------------------
162      // Total supply
163      // ------------------------------------------------------------------------
164      function totalSupply() public constant returns (uint) {
165          return totalSupply  - tokenBalances[address(0)];
166      }
167      
168     
169      
170      // ------------------------------------------------------------------------
171      // Returns the amount of tokens approved by the owner that can be
172      // transferred to the spender's account
173      // ------------------------------------------------------------------------
174      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
175          return allowed[tokenOwner][spender];
176      }
177      
178      /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215      
216      // ------------------------------------------------------------------------
217      // Don't accept ETH
218      // ------------------------------------------------------------------------
219      function () public payable {
220          revert();
221      }   
222 
223 
224   
225    event Debug(string message, address addr, uint256 number);
226    /**
227    * @dev Contructor that gives msg.sender all of existing tokens.
228    */
229     function EtheeraToken(address wallet) public {
230         owner = msg.sender;
231         totalSupply = INITIAL_SUPPLY * 10 ** 18;
232         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
233     }
234 
235     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
236       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
237       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
238       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
239       Transfer(wallet, buyer, tokenAmount); 
240       totalSupply = totalSupply.sub(tokenAmount); 
241     }
242     
243    
244 }