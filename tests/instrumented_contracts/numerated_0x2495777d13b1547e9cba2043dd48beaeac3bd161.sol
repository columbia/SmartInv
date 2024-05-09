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
48 contract REGO is ERC20
49 {using SafeMath for uint256;
50    string public constant symbol = "REGO";
51      string public constant name = "REGO";
52      uint public constant decimals = 5;
53      uint256 _totalSupply = 55000000 * 10 ** 5; // 55 Million Total Supply including 5 decimal
54      
55      // Owner of this contract
56      address public owner;
57      
58      bool public burnTokenStatus;
59   // Balances for each account
60      mapping(address => uint256) balances;
61   
62      // Owner of account approves the transfer of an amount to another account
63      mapping(address => mapping (address => uint256)) allowed;
64   
65      // Functions with this modifier can only be executed by the owner
66      modifier onlyOwner() {
67          require (msg.sender == owner);
68          _;
69      }
70   
71      // Constructor
72      function REGO () public {
73          owner = msg.sender;
74          balances[owner] = _totalSupply;
75          emit Transfer(0, owner, _totalSupply);
76      }
77    
78    //Burning tokens
79     function burntokens(uint256 tokens) external onlyOwner {
80          require(!burnTokenStatus);
81          require( tokens <= balances[owner]);
82          burnTokenStatus = true;
83          _totalSupply = (_totalSupply).sub(tokens);
84          balances[owner] = balances[owner].sub(tokens);
85          emit Transfer(owner, 0, tokens);
86      }
87   
88     // what is the total supply of the ech tokens
89      function totalSupply() public view returns (uint256 total_Supply) {
90          total_Supply = _totalSupply;
91      }
92        // What is the balance of a particular account?
93      function balanceOf(address _owner)public view returns (uint256 balance) {
94          return balances[_owner];
95      }
96   
97      // Transfer the balance from owner's account to another account
98      function transfer(address _to, uint256 _amount)public returns (bool ok) {
99         require( _to != 0x0);
100         require(balances[msg.sender] >= _amount && _amount >= 0);
101         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
102         balances[_to] = (balances[_to]).add(_amount);
103         emit Transfer(msg.sender, _to, _amount);
104              return true;
105          }
106          
107     // Send _value amount of tokens from address _from to address _to
108      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
109      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
110      // fees in sub-currencies; the command should fail unless the _from account has
111      // deliberately authorized the sender of the message via some mechanism; we propose
112      // these standardized APIs for approval:
113      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {
114      require( _to != 0x0);
115      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
116      balances[_from] = (balances[_from]).sub(_amount);
117      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
118      balances[_to] = (balances[_to]).add(_amount);
119      emit Transfer(_from, _to, _amount);
120      return true;
121          }
122  
123      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
124      // If this function is called again it overwrites the current allowance with _value.
125      function approve(address _spender, uint256 _amount)public returns (bool ok) {
126          require( _spender != 0x0);
127          allowed[msg.sender][_spender] = _amount;
128          emit Approval(msg.sender, _spender, _amount);
129          return true;
130      }
131   
132      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
133          require( _owner != 0x0 && _spender !=0x0);
134          return allowed[_owner][_spender];
135    }
136         
137     //In case the ownership needs to be transferred
138 	function transferOwnership(address newOwner) external onlyOwner
139 	{
140 	    require( newOwner != 0x0);
141 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
142 	    balances[owner] = 0;
143 	    owner = newOwner;
144 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
145 	}
146 	
147   
148 
149 }