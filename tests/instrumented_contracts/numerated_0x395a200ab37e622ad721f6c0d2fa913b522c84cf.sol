1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal pure returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 contract Ownable {
32   address public owner;
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   constructor() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner public {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Interface {
69      function totalSupply() public constant returns (uint);
70      function balanceOf(address tokenOwner) public constant returns (uint balance);
71      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
72      function transfer(address to, uint tokens) public returns (bool success);
73      function approve(address spender, uint tokens) public returns (bool success);
74      function transferFrom(address from, address to, uint tokens) public returns (bool success);
75      function mint(address from, address to, uint tokens) public;
76      event Transfer(address indexed from, address indexed to, uint tokens);
77      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78 }
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract RADION is ERC20Interface,Ownable {
85 
86    using SafeMath for uint256;
87    
88    string public name;
89    string public symbol;
90    uint256 public decimals;
91 
92    uint256 public _totalSupply;
93    mapping(address => uint256) tokenBalances;
94    address musicContract;
95    address advertisementContract;
96    address sale;
97    address wallet;
98 
99    // Owner of account approves the transfer of an amount to another account
100    mapping (address => mapping (address => uint256)) allowed;
101    
102     // whitelisted addresses are those that have registered on the website
103     mapping(address=>bool) whiteListedAddresses;
104    
105    /**
106    * @dev Contructor that gives msg.sender all of existing tokens.
107    */
108     constructor(address _wallet) public {
109         owner = msg.sender;
110         wallet = _wallet;
111         name  = "RADION";
112         symbol = "RADIO";
113         decimals = 18;
114         _totalSupply = 55000000 * 10 ** uint(decimals);
115         tokenBalances[wallet] = _totalSupply;   //Since we divided the token into 10^18 parts
116     }
117     
118      // Get the token balance for account `tokenOwner`
119      function balanceOf(address tokenOwner) public constant returns (uint balance) {
120          return tokenBalances[tokenOwner];
121      }
122   
123      // Transfer the balance from owner's account to another account
124      function transfer(address to, uint tokens) public returns (bool success) {
125          require(to != address(0));
126          require(tokens <= tokenBalances[msg.sender]);
127          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
128          tokenBalances[to] = tokenBalances[to].add(tokens);
129          emit Transfer(msg.sender, to, tokens);
130          return true;
131      }
132   
133      /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= tokenBalances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     tokenBalances[_from] = tokenBalances[_from].sub(_value);
145     tokenBalances[_to] = tokenBalances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149   }
150   
151      /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163      // ------------------------------------------------------------------------
164      // Total supply
165      // ------------------------------------------------------------------------
166      function totalSupply() public constant returns (uint) {
167          return _totalSupply  - tokenBalances[address(0)];
168      }
169      
170     
171      
172      // ------------------------------------------------------------------------
173      // Returns the amount of tokens approved by the owner that can be
174      // transferred to the spender's account
175      // ------------------------------------------------------------------------
176      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
177          return allowed[tokenOwner][spender];
178      }
179      
180      /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    *
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209      //only to be used by the ICO
210      
211     function mint(address sender, address receiver, uint256 tokenAmount) public {
212       require(msg.sender == musicContract || msg.sender == advertisementContract);
213       require(tokenBalances[sender] >= tokenAmount);               // checks if it has enough to sell
214       tokenBalances[receiver] = tokenBalances[receiver].add(tokenAmount);                  // adds the amount to buyer's balance
215       tokenBalances[sender] = tokenBalances[sender].sub(tokenAmount);                        // subtracts amount from seller's balance
216       emit Transfer(sender, receiver, tokenAmount); 
217     }
218     
219     function setAddresses(address music, address advertisement,address _sale) public onlyOwner
220     {
221        musicContract = music;
222        advertisementContract = advertisement;
223        sale = _sale;
224     }
225 
226      function () public payable {
227         revert();
228      }
229  
230     function buy(address beneficiary, uint ethAmountSent, uint rate) public onlyOwner
231     {
232         require(beneficiary != 0x0 && whiteListedAddresses[beneficiary] == true);
233         require(ethAmountSent>0);
234         uint weiAmount = ethAmountSent;
235         uint tokens = weiAmount.mul(rate);
236         
237         require(tokenBalances[wallet] >= tokens);               // checks if it has enough to sell
238         tokenBalances[beneficiary] = tokenBalances[beneficiary].add(tokens);                  // adds the amount to buyer's balance
239         tokenBalances[wallet] = tokenBalances[wallet].sub(tokens);                        // subtracts amount from seller's balance
240         emit Transfer(wallet, beneficiary, tokens); 
241     }
242  
243      // ------------------------------------------------------------------------
244      // Owner can transfer out any accidentally sent ERC20 tokens
245      // ------------------------------------------------------------------------
246      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
247          return ERC20Interface(tokenAddress).transfer(owner, tokens);
248      }
249 
250     function addAddressToWhiteList(address whitelistaddress) public onlyOwner
251     {
252         whiteListedAddresses[whitelistaddress] = true;
253     }
254     
255     function checkIfAddressIsWhitelisted(address whitelistaddress) public onlyOwner constant returns (bool)
256     {
257         if (whiteListedAddresses[whitelistaddress] == true)
258             return true;
259         return false; 
260     }
261 }