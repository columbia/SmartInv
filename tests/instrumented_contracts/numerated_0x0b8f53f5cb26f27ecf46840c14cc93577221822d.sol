1 /**
2   Do you have any questions or suggestions? Emails us @ support@netsolar.tech
3   
4                  _______  _______________________________________  .____       _____ __________ 
5                  \      \ \_   _____/\__    ___/   _____/\_____  \ |    |     /  _  \\______   \
6                  /   |   \ |    __)_   |    |  \_____  \  /   |   \|    |    /  /_\  \|       _/
7                 /    |    \|        \  |    |  /        \/    |    \    |___/    |    \    |   \
8                 \____|__  /_______  /  |____| /_______  /\_______  /_______ \____|__  /____|_  /
9                         \/        \/                  \/         \/        \/       \/       \/ 
10                  _______  ________________________      __________ __________ ____  __.         
11                  \      \ \_   _____/\__    ___/  \    /  \_____  \\______   \    |/ _|         
12                  /   |   \ |    __)_   |    |  \   \/\/   //   |   \|       _/      <           
13                 /    |    \|        \  |    |   \        //    |    \    |   \    |  \          
14                 \____|__  /_______  /  |____|    \__/\  / \_______  /____|_  /____|__ \         
15                         \/        \/                  \/          \/       \/        \/ 
16 */
17 
18 pragma solidity ^0.4.24;
19  
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27  function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59     
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77          if(msg.sender != owner){
78             revert();
79          }
80          else{
81             require(newOwner != address(0));
82             OwnershipTransferred(owner, newOwner);
83             owner = newOwner;
84          }
85              
86     }
87 
88 }
89 
90 /**
91  * @title ERC20Standard
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Interface {
96      function totalSupply() public constant returns (uint);
97      function balanceOf(address tokenOwner) public constant returns (uint balance);
98      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
99      function transfer(address to, uint tokens) public returns (bool success);
100      function approve(address spender, uint tokens) public returns (bool success);
101      function transferFrom(address from, address to, uint tokens) public returns (bool success);
102      event Transfer(address indexed from, address indexed to, uint tokens);
103      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
104 }
105 
106 contract Netsolar is ERC20Interface,Ownable {
107 
108    using SafeMath for uint256;
109     uint256 public totalSupply;
110     mapping(address => uint256) tokenBalances;
111    
112    string public constant name = "Netsolar";
113    string public constant symbol = "NSN";
114    uint256 public constant decimals = 0;
115 
116    uint256 public constant INITIAL_SUPPLY = 3000000000;
117     address ownerWallet;
118    // Owner of account approves the transfer of an amount to another account
119    mapping (address => mapping (address => uint256)) allowed;
120    event Debug(string message, address addr, uint256 number);
121 
122     function NSN (address wallet) onlyOwner public {
123         if(msg.sender != owner){
124             revert();
125          }
126         else{
127         ownerWallet=wallet;
128         totalSupply = 3000000000;
129         tokenBalances[wallet] = 3000000000;   //Since we divided the token into 10^18 parts
130         }
131     }
132     
133  /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(tokenBalances[msg.sender]>=_value);
140     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
141     tokenBalances[_to] = tokenBalances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145   
146   
147      /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= tokenBalances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     tokenBalances[_from] = tokenBalances[_from].sub(_value);
159     tokenBalances[_to] = tokenBalances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     Transfer(_from, _to, _value);
162     return true;
163   }
164  
165     uint price = 0.000001 ether;
166     function() public payable {
167         
168         uint toMint = msg.value/price;
169         //totalSupply += toMint;
170         tokenBalances[msg.sender]+=toMint;
171         Transfer(0,msg.sender,toMint);
172         
173      }     
174      /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190      // ------------------------------------------------------------------------
191      // Total supply
192      // ------------------------------------------------------------------------
193      function totalSupply() public constant returns (uint) {
194          return totalSupply  - tokenBalances[address(0)];
195      }
196      
197      // ------------------------------------------------------------------------
198      // Returns the amount of tokens approved by the owner that can be
199      // transferred to the spender's account
200      // ------------------------------------------------------------------------
201      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
202          return allowed[tokenOwner][spender];
203      }
204      // ------------------------------------------------------------------------
205      // Accept ETH
206      // ------------------------------------------------------------------------
207    function withdraw() onlyOwner public {
208         if(msg.sender != owner){
209             revert();
210          }
211          else{
212         uint256 etherBalance = this.balance;
213         owner.transfer(etherBalance);
214          }
215     }
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) constant public returns (uint256 balance) {
222     return tokenBalances[_owner];
223   }
224 
225     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
226         require(tokenBalances[buyer]<=tokenAmount);
227         tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);
228         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
229         Transfer(buyer, wallet, tokenAmount);
230      }
231     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
232         tokenBalance = tokenBalances[addr];
233     }
234 }