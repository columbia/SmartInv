1 pragma solidity ^0.4.24;
2 
3  
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11  function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   function transferOwnership(address newOwner) onlyOwner public {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 /**
63  * @title ERC20Standard
64  * @dev Strong version of ERC20 interface
65  */
66 contract ERC20Interface {
67      function totalSupply() public constant returns (uint);
68      function balanceOf(address tokenOwner) public constant returns (uint balance);
69      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
70      function transfer(address to, uint tokens) public returns (bool success);
71      function approve(address spender, uint tokens) public returns (bool success);
72      function transferFrom(address from, address to, uint tokens) public returns (bool success);
73      event Transfer(address indexed from, address indexed to, uint tokens);
74      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 contract EasyAuto is ERC20Interface,Ownable {
77 
78    using SafeMath for uint256;
79     uint256 public totalSupply;
80     mapping(address => uint256) tokenBalances;
81    
82    string public constant name = "EasyAuto";
83    string public constant symbol = "EASY";
84    uint256 public constant decimals = 18;
85 
86    uint256 public constant INITIAL_SUPPLY = 1000000000;
87     address ownerWallet;
88    // Owner of account approves the transfer of an amount to another account
89    mapping (address => mapping (address => uint256)) allowed;
90    event Debug(string message, address addr, uint256 number);
91 
92     function EasyAuto (address wallet) public {
93         owner = msg.sender;
94         ownerWallet=wallet;
95         totalSupply = INITIAL_SUPPLY * 10 ** 18;
96         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
97     }
98  /**
99  * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(tokenBalances[msg.sender]>=_value);
105     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
106     tokenBalances[_to] = tokenBalances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110   
111   
112      /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= tokenBalances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     tokenBalances[_from] = tokenBalances[_from].sub(_value);
124     tokenBalances[_to] = tokenBalances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129   
130      /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146      // ------------------------------------------------------------------------
147      // Total supply
148      // ------------------------------------------------------------------------
149      function totalSupply() public constant returns (uint) {
150          return totalSupply  - tokenBalances[address(0)];
151      }
152      
153     
154      
155      // ------------------------------------------------------------------------
156      // Returns the amount of tokens approved by the owner that can be
157      // transferred to the spender's account
158      // ------------------------------------------------------------------------
159      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
160          return allowed[tokenOwner][spender];
161      }
162      
163      /**
164    * @dev Increase the amount of tokens that an owner allowed to a spender.
165    *
166    * approve should be called when allowed[_spender] == 0. To increment
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    * From MonolithDAO Token.sol
170    * @param _spender The address which will spend the funds.
171    * @param _addedValue The amount of tokens to increase the allowance by.
172    */
173   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179   /**
180    * @dev Decrease the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To decrement
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _subtractedValue The amount of tokens to decrease the allowance by.
188    */
189   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190     uint oldValue = allowed[msg.sender][_spender];
191     if (_subtractedValue > oldValue) {
192       allowed[msg.sender][_spender] = 0;
193     } else {
194       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195     }
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200      
201      // ------------------------------------------------------------------------
202      // Don't accept ETH
203      // ------------------------------------------------------------------------
204      function () public payable {
205          revert();
206      }
207  
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) constant public returns (uint256 balance) {
215     return tokenBalances[_owner];
216   }
217 
218     function Return(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
219         require(tokenBalances[buyer]<=tokenAmount);
220         tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);
221         tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);
222         Transfer(buyer, wallet, tokenAmount);
223      }
224     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
225         tokenBalance = tokenBalances[addr];
226     }
227 }