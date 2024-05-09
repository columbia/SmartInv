1 pragma solidity ^0.4.18;
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
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner public {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 contract ERC20Interface {
68      function totalSupply() public constant returns (uint);
69      function balanceOf(address tokenOwner) public constant returns (uint balance);
70      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
71      function transfer(address to, uint tokens) public returns (bool success);
72      function approve(address spender, uint tokens) public returns (bool success);
73      function transferFrom(address from, address to, uint tokens) public returns (bool success);
74      event Transfer(address indexed from, address indexed to, uint tokens);
75      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 }
77 
78 contract HypeRideToken is ERC20Interface,Ownable {
79 
80    using SafeMath for uint256;
81    
82    string public name;
83    string public symbol;
84    uint256 public decimals;
85 
86    uint256 public _totalSupply;
87    mapping(address => uint256) tokenBalances;
88    address ownerWallet;
89    // Owner of account approves the transfer of an amount to another account
90    mapping (address => mapping (address => uint256)) allowed;
91    
92    /**
93    * @dev Contructor that gives msg.sender all of existing tokens.
94    */
95     function HypeRideToken(address wallet) public {
96         owner = msg.sender;
97         ownerWallet = wallet;
98         name  = "HYPERIDE";
99         symbol = "HYPE";
100         decimals = 18;
101         _totalSupply = 150000000 * 10 ** uint(decimals);
102         tokenBalances[wallet] = _totalSupply;   //Since we divided the token into 10^18 parts
103     }
104     
105      // Get the token balance for account `tokenOwner`
106      function balanceOf(address tokenOwner) public constant returns (uint balance) {
107          return tokenBalances[tokenOwner];
108      }
109   
110      // Transfer the balance from owner's account to another account
111      function transfer(address to, uint tokens) public returns (bool success) {
112          require(to != address(0));
113          require(tokens <= tokenBalances[msg.sender]);
114          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
115          tokenBalances[to] = tokenBalances[to].add(tokens);
116          Transfer(msg.sender, to, tokens);
117          return true;
118      }
119   
120      /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= tokenBalances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     tokenBalances[_from] = tokenBalances[_from].sub(_value);
132     tokenBalances[_to] = tokenBalances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137   
138      /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
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
154          return _totalSupply  - tokenBalances[address(0)];
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
182    * @param _spender The address which will spend the funds.
183    * @param _subtractedValue The amount of tokens to decrease the allowance by.
184    */
185   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196      
197      // ------------------------------------------------------------------------
198      // Don't accept ETH
199      // ------------------------------------------------------------------------
200      function () public payable {
201          revert();
202      }
203  
204  
205      // ------------------------------------------------------------------------
206      // Owner can transfer out any accidentally sent ERC20 tokens
207      // ------------------------------------------------------------------------
208      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
209          return ERC20Interface(tokenAddress).transfer(owner, tokens);
210      }
211      
212      //only to be used by the ICO
213      
214      function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
215       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
216       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
217       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
218       Transfer(wallet, buyer, tokenAmount); 
219       _totalSupply = _totalSupply.sub(tokenAmount);
220     }
221 }