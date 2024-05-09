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
73 
74 }
75 
76 contract ERC20Interface {
77      function totalSupply() public constant returns (uint);
78      function balanceOf(address tokenOwner) public constant returns (uint balance);
79      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
80      function transfer(address to, uint tokens) public returns (bool success);
81      function approve(address spender, uint tokens) public returns (bool success);
82      function transferFrom(address from, address to, uint tokens) public returns (bool success);
83      event Transfer(address indexed from, address indexed to, uint tokens);
84      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85 }
86 
87 contract HashcoCoin is ERC20Interface,Ownable {
88 
89    using SafeMath for uint256;
90    
91    string public name;
92    string public symbol;
93    uint256 public decimals;
94 
95    uint256 public _totalSupply;
96    mapping(address => uint256) tokenBalances;
97    address ownerWallet;
98    // Owner of account approves the transfer of an amount to another account
99    mapping (address => mapping (address => uint256)) allowed;
100    
101    /**
102    * @dev Contructor that gives msg.sender all of existing tokens.
103    */
104     function HashcoCoin(address wallet) public {
105         owner = msg.sender;
106         ownerWallet = wallet;
107         name  = "HashcoCoin";
108         symbol = "HCC";
109         decimals = 18;
110         _totalSupply = 60000000 * 10 ** uint(decimals);
111         tokenBalances[wallet] = _totalSupply;   //Since we divided the token into 10^18 parts
112     }
113     
114      // Get the token balance for account `tokenOwner`
115      function balanceOf(address tokenOwner) public constant returns (uint balance) {
116          return tokenBalances[tokenOwner];
117      }
118   
119      // Transfer the balance from owner's account to another account
120      function transfer(address to, uint tokens) public returns (bool success) {
121          require(to != address(0));
122          require(tokens <= tokenBalances[msg.sender]);
123          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
124          tokenBalances[to] = tokenBalances[to].add(tokens);
125          Transfer(msg.sender, to, tokens);
126          return true;
127      }
128   
129      /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= tokenBalances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     tokenBalances[_from] = tokenBalances[_from].sub(_value);
141     tokenBalances[_to] = tokenBalances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146   
147      /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159      // ------------------------------------------------------------------------
160      // Total supply
161      // ------------------------------------------------------------------------
162      function totalSupply() public constant returns (uint) {
163          return _totalSupply  - tokenBalances[address(0)];
164      }
165      
166     
167      
168      // ------------------------------------------------------------------------
169      // Returns the amount of tokens approved by the owner that can be
170      // transferred to the spender's account
171      // ------------------------------------------------------------------------
172      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
173          return allowed[tokenOwner][spender];
174      }
175      
176      /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * @param _spender The address which will spend the funds.
192    * @param _subtractedValue The amount of tokens to decrease the allowance by.
193    */
194   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
195     uint oldValue = allowed[msg.sender][_spender];
196     if (_subtractedValue > oldValue) {
197       allowed[msg.sender][_spender] = 0;
198     } else {
199       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200     }
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205      
206      // ------------------------------------------------------------------------
207      // Don't accept ETH
208      // ------------------------------------------------------------------------
209      function () public payable {
210          revert();
211      }
212  
213  
214      // ------------------------------------------------------------------------
215      // Owner can transfer out any accidentally sent ERC20 tokens
216      // ------------------------------------------------------------------------
217      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
218          return ERC20Interface(tokenAddress).transfer(owner, tokens);
219      }
220      
221      //only to be used by the ICO
222      
223      function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
224       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
225       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
226       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
227       Transfer(wallet, buyer, tokenAmount); 
228       _totalSupply = _totalSupply.sub(tokenAmount);
229     }
230 }