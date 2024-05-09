1 pragma solidity ^0.4.11;
2 
3  
4  
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12  function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) onlyOwner public {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 contract ERC20Interface {
69      function totalSupply() public constant returns (uint);
70      function balanceOf(address tokenOwner) public constant returns (uint balance);
71      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
72      function transfer(address to, uint tokens) public returns (bool success);
73      function approve(address spender, uint tokens) public returns (bool success);
74      function transferFrom(address from, address to, uint tokens) public returns (bool success);
75      event Transfer(address indexed from, address indexed to, uint tokens);
76      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
77 }
78 
79 contract ThingschainToken is ERC20Interface,Ownable {
80 
81    using SafeMath for uint256;
82    
83    string public name;
84    string public symbol;
85    uint256 public decimals;
86 
87    uint256 public _totalSupply;
88    mapping(address => uint256) tokenBalances;
89    address ownerWallet;
90    // Owner of account approves the transfer of an amount to another account
91    mapping (address => mapping (address => uint256)) allowed;
92    
93    /**
94    * @dev Contructor that gives msg.sender all of existing tokens.
95    */
96     function ThingschainToken(address wallet) public {
97         owner = msg.sender;
98         ownerWallet = wallet;
99         name  = "Thingschain";
100         symbol = "TIC";
101         decimals = 8;
102         _totalSupply = 100000000000 * 10 ** uint(decimals);
103         tokenBalances[wallet] = _totalSupply;   //Since we divided the token into 10^18 parts
104     }
105     
106      // Get the token balance for account `tokenOwner`
107      function balanceOf(address tokenOwner) public constant returns (uint balance) {
108          return tokenBalances[tokenOwner];
109      }
110   
111      // Transfer the balance from owner's account to another account
112      function transfer(address to, uint tokens) public returns (bool success) {
113          require(to != address(0));
114          require(tokens <= tokenBalances[msg.sender]);
115          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
116          tokenBalances[to] = tokenBalances[to].add(tokens);
117          Transfer(msg.sender, to, tokens);
118          return true;
119      }
120   
121      /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= tokenBalances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131 
132     tokenBalances[_from] = tokenBalances[_from].sub(_value);
133     tokenBalances[_to] = tokenBalances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     Transfer(_from, _to, _value);
136     return true;
137   }
138   
139      /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151      // ------------------------------------------------------------------------
152      // Total supply
153      // ------------------------------------------------------------------------
154      function totalSupply() public constant returns (uint) {
155          return _totalSupply  - tokenBalances[address(0)];
156      }
157      
158     
159      
160      // ------------------------------------------------------------------------
161      // Returns the amount of tokens approved by the owner that can be
162      // transferred to the spender's account
163      // ------------------------------------------------------------------------
164      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
165          return allowed[tokenOwner][spender];
166      }
167      
168      /**
169    * @dev Increase the amount of tokens that an owner allowed to a spender.
170    *
171    * @param _spender The address which will spend the funds.
172    * @param _addedValue The amount of tokens to increase the allowance by.
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   /**
181    * @dev Decrease the amount of tokens that an owner allowed to a spender.
182    *
183    * @param _spender The address which will spend the funds.
184    * @param _subtractedValue The amount of tokens to decrease the allowance by.
185    */
186   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
187     uint oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197      
198      // ------------------------------------------------------------------------
199      // Don't accept ETH
200      // ------------------------------------------------------------------------
201      function () public payable {
202          revert();
203      }
204  
205  
206      // ------------------------------------------------------------------------
207      // Owner can transfer out any accidentally sent ERC20 tokens
208      // ------------------------------------------------------------------------
209      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
210          return ERC20Interface(tokenAddress).transfer(owner, tokens);
211      }
212      
213      //only to be used by the ICO
214      
215      function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
216       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
217       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
218       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
219       Transfer(wallet, buyer, tokenAmount); 
220       _totalSupply = _totalSupply.sub(tokenAmount);
221     }
222 }