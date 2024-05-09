1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36   contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address _owner)public view returns (uint256 balance);
39   function allowance(address _owner, address _spender)public view returns (uint remaining);
40   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
41   function approve(address _spender, uint _amount)public returns (bool ok);
42   function transfer(address _to, uint _amount)public returns (bool ok);
43   event Transfer(address indexed _from, address indexed _to, uint _amount);
44   event Approval(address indexed _owner, address indexed _spender, uint _amount);
45 }
46 
47 
48 contract OFNOG is ERC20
49 {using SafeMath for uint256;
50    string public constant symbol = "OFNOG";
51      string public constant name = "OFNOG";
52      uint public constant decimals = 18;
53      uint256 public _totalSupply = 500000000 * 10 ** 18; // 500 Million Total Supply including 18 decimal
54      
55      // Owner of this contract
56      address public owner;
57      
58     // Balances for each account
59      mapping(address => uint256) balances;
60   
61      // Owner of account approves the transfer of an amount to another account
62      mapping(address => mapping (address => uint256)) allowed;
63   
64      // Functions with this modifier can only be executed by the owner
65      modifier onlyOwner() {
66          require (msg.sender == owner);
67          _;
68      }
69   
70      // Constructor
71      function OFNOG () public {
72          owner = msg.sender;
73          balances[owner] = _totalSupply;
74        emit Transfer(0, owner, _totalSupply);
75      }
76    
77    //Burning tokens
78     function burntokens(uint256 tokens) external onlyOwner {
79          require( tokens <= balances[owner]);
80          _totalSupply = (_totalSupply).sub(tokens);
81          balances[owner] = balances[owner].sub(tokens);
82           emit Transfer(owner, 0, tokens);
83      }
84   
85     // what is the total supply of the ech tokens
86      function totalSupply() public view returns (uint256 total_Supply) {
87          total_Supply = _totalSupply;
88      }
89        // What is the balance of a particular account?
90      function balanceOf(address _owner)public view returns (uint256 balance) {
91          return balances[_owner];
92      }
93   
94      // Transfer the balance from owner's account to another account
95      function transfer(address _to, uint256 _amount)public returns (bool ok) {
96         require( _to != 0x0);
97         require(balances[msg.sender] >= _amount && _amount >= 0);
98         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
99         balances[_to] = (balances[_to]).add(_amount);
100         emit Transfer(msg.sender, _to, _amount);
101              return true;
102          }
103          
104     // Send _value amount of tokens from address _from to address _to
105      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
106      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
107      // fees in sub-currencies; the command should fail unless the _from account has
108      // deliberately authorized the sender of the message via some mechanism; we propose
109      // these standardized APIs for approval:
110      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {
111      require( _to != 0x0);
112      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
113      balances[_from] = (balances[_from]).sub(_amount);
114      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
115      balances[_to] = (balances[_to]).add(_amount);
116      emit Transfer(_from, _to, _amount);
117      return true;
118     }
119  
120      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121      // If this function is called again it overwrites the current allowance with _value.
122      function approve(address _spender, uint256 _amount)public returns (bool ok) {
123          require( _spender != 0x0);
124          allowed[msg.sender][_spender] = _amount;
125       emit Approval(msg.sender, _spender, _amount);
126          return true;
127      }
128   
129      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
130          require( _owner != 0x0 && _spender !=0x0);
131          return allowed[_owner][_spender];
132    }
133         
134     //In case the ownership needs to be transferred
135 	function transferOwnership(address newOwner) external onlyOwner
136 	{
137 	    require( newOwner != 0x0);
138 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
139 	    balances[owner] = 0;
140 	    owner = newOwner;
141 	 emit Transfer(msg.sender, newOwner, balances[newOwner]);
142 	}
143 }