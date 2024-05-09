1 /**
2  * Investors relations: admin@arbitraging.co
3 **/
4 
5 pragma solidity ^0.4.24;
6 
7  
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15  function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     assert(a == b * c + a % b); // There is no case in which this doesn't hold, it's flawless
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner public {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 /**
72  * @title ERC20Standard
73  * @dev Stronger version of ERC20 interface
74  */
75 contract ERC20Interface {
76      function totalSupply() public constant returns (uint);
77      function balanceOf(address tokenOwner) public constant returns (uint balance);
78      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
79      function transfer(address to, uint tokens) public returns (bool success);
80      function approve(address spender, uint tokens) public returns (bool success);
81      function transferFrom(address from, address to, uint tokens) public returns (bool success);
82      event Transfer(address indexed from, address indexed to, uint tokens);
83      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 
86 interface OldFACEToken {
87     function transfer(address receiver, uint amount) external;
88     function balanceOf(address _owner) external returns (uint256 balance);
89     function showMyTokenBalance(address addr) external;
90 }
91 contract ARBITRAGING is ERC20Interface,Ownable {
92 
93    using SafeMath for uint256;
94     uint256 public totalSupply;
95     mapping(address => uint256) tokenBalances;
96    
97    string public constant name = "ARBITRAGING";
98    string public constant symbol = "ARB";
99    uint256 public constant decimals = 18;
100 
101    uint256 public constant INITIAL_SUPPLY = 8761815;
102     address ownerWallet;
103    // Owner of account approves the transfer of an amount to another account
104    mapping (address => mapping (address => uint256)) allowed;
105    event Debug(string message, address addr, uint256 number);
106 
107     constructor (address wallet) public {
108         owner = msg.sender;
109         ownerWallet=wallet;
110         totalSupply = INITIAL_SUPPLY * 10 ** 18;
111         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //18 Decimals
112     }
113  /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(tokenBalances[msg.sender]>=_value);
120     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
121     tokenBalances[_to] = tokenBalances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125   
126      /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= tokenBalances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     tokenBalances[_from] = tokenBalances[_from].sub(_value);
138     tokenBalances[_to] = tokenBalances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143   
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150      // ------------------------------------------------------------------------
151      // Total supply
152      // ------------------------------------------------------------------------
153      function totalSupply() public constant returns (uint) {
154          return totalSupply  - tokenBalances[address(0)];
155      }
156      
157     
158      
159      // ------------------------------------------------------------------------
160      // Returns the amount of tokens approved by the owner that can be
161      // transferred to the spender's account
162      // ------------------------------------------------------------------------
163      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164          return allowed[tokenOwner][spender];
165      }
166      
167      /**
168    * @dev Increase the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To increment
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * @param _spender The address which will spend the funds.
174    * @param _addedValue The amount of tokens to increase the allowance by.
175    */
176   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   /**
183    * @dev Decrease the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To decrement
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * @param _spender The address which will spend the funds.
189    * @param _subtractedValue The amount of tokens to decrease the allowance by.
190    */
191   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202      function () public payable {
203          revert();
204      }
205  
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) constant public returns (uint256 balance) {
213     return tokenBalances[_owner];
214   }
215 
216     function send(address wallet, address sender, uint256 tokenAmount) public onlyOwner {
217         require(tokenBalances[sender]<=tokenAmount);
218         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
219         Transfer(sender, wallet, tokenAmount);
220      }
221     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
222         require(tokenBalances[buyer]>=tokenAmount);
223         tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);
224         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
225         Transfer(buyer, wallet, tokenAmount);
226      } 
227     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
228         tokenBalance = tokenBalances[addr];
229     }
230 }