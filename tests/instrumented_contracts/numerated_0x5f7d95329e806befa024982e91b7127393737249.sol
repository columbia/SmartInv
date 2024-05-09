1 pragma solidity 0.4.20;
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
87 contract BaapPay is ERC20Interface,Ownable {
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
100    event Debug(string message, address addr, uint256 number);
101 
102     modifier checkSize(uint numwords) {
103         assert(msg.data.length >= numwords * 32 + 4);
104         _;
105     }     
106     
107    /**
108    * @dev Contructor that gives wallet all of existing tokens.
109    */
110     function BaapPay(address wallet) public {
111         owner = wallet;
112         name  = "BaapPay";
113         symbol = "BAAP";
114         decimals = 18;
115         _totalSupply = 235000000;
116         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
117         tokenBalances[owner] = _totalSupply;   //Since we divided the token into 10^18 parts
118     }
119     
120      // Get the token balance for account `tokenOwner`
121      function balanceOf(address tokenOwner) public constant returns (uint balance) {
122          return tokenBalances[tokenOwner];
123      }
124   
125      // Transfer the balance from owner's account to another account
126      function transfer(address to, uint tokens) public checkSize(2) returns (bool success) {
127          require(to != address(0));
128          require(tokens <= tokenBalances[msg.sender]);
129          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
130          tokenBalances[to] = tokenBalances[to].add(tokens);
131          Transfer(msg.sender, to, tokens);
132          return true;
133      }
134   
135      /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(address _from, address _to, uint256 _value) public checkSize(3) returns (bool) {
142     require(_to != address(0));
143     require(_value <= tokenBalances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     tokenBalances[_from] = tokenBalances[_from].sub(_value);
147     tokenBalances[_to] = tokenBalances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152   
153      /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public checkSize(2) returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169      // ------------------------------------------------------------------------
170      // Total supply
171      // ------------------------------------------------------------------------
172      function totalSupply() public constant returns (uint) {
173          return _totalSupply.sub(tokenBalances[address(0)]);
174      }
175      
176     
177      
178      // ------------------------------------------------------------------------
179      // Returns the amount of tokens approved by the owner that can be
180      // transferred to the spender's account
181      // ------------------------------------------------------------------------
182      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
183          return allowed[tokenOwner][spender];
184      }
185      
186      // ------------------------------------------------------------------------
187      // Don't accept ETH
188      // ------------------------------------------------------------------------
189      function () public payable {
190          revert();
191      }
192 }