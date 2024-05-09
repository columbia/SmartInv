1 pragma solidity 0.4.23;
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
48 contract Healthureum is ERC20
49 {
50     using SafeMath for uint256;
51    string public constant symbol = "HHEM";
52      string public constant name = "Healthureum";
53      uint public constant decimals = 18;
54      uint256 _totalSupply = 150000000 * 10 ** 18; // 150 Million Total Supply including 18 decimal
55      
56      // Owner of this contract
57      address public owner;
58      
59     // Balances for each account
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
72     constructor() public {
73         owner = msg.sender;
74         balances[owner] = _totalSupply;
75         emit Transfer(0, owner, _totalSupply);
76      }
77    
78    //Burning tokens
79     function burntokens(uint256 tokens) external onlyOwner {
80         require( tokens <= balances[owner]);
81         _totalSupply = (_totalSupply).sub(tokens);
82         balances[owner] = balances[owner].sub(tokens);
83         emit Transfer(owner, 0, tokens);
84      }
85   
86     // what is the total supply of the ech tokens
87      function totalSupply() public view returns (uint256 total_Supply) {
88          total_Supply = _totalSupply;
89      }
90        // What is the balance of a particular account?
91      function balanceOf(address _owner)public view returns (uint256 balance) {
92          return balances[_owner];
93      }
94   
95      // Transfer the balance from owner's account to another account
96      function transfer(address _to, uint256 _amount)public returns (bool ok) {
97         require( _to != 0x0);
98         require(balances[msg.sender] >= _amount && _amount >= 0);
99         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
100         balances[_to] = (balances[_to]).add(_amount);
101         emit Transfer(msg.sender, _to, _amount);
102              return true;
103          }
104          
105     // Send _value amount of tokens from address _from to address _to
106      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
107      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
108      // fees in sub-currencies; the command should fail unless the _from account has
109      // deliberately authorized the sender of the message via some mechanism; we propose
110      // these standardized APIs for approval:
111      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {
112      require( _to != 0x0);
113      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
114      balances[_from] = (balances[_from]).sub(_amount);
115      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
116      balances[_to] = (balances[_to]).add(_amount);
117      emit Transfer(_from, _to, _amount);
118      return true;
119          }
120  
121      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
122      // If this function is called again it overwrites the current allowance with _value.
123      function approve(address _spender, uint256 _amount) public returns (bool ok) {
124          require( _spender != 0x0);
125          allowed[msg.sender][_spender] = _amount;
126          emit Approval(msg.sender, _spender, _amount);
127          return true;
128      }
129   
130      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
131          require( _owner != 0x0 && _spender !=0x0);
132          return allowed[_owner][_spender];
133    }
134         
135     //In case the ownership needs to be transferred
136 	function transferOwnership(address newOwner) external onlyOwner
137 	{
138 	    require( newOwner != 0x0);
139 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
140 	    balances[owner] = 0;
141 	    owner = newOwner;
142 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
143 	}
144 }