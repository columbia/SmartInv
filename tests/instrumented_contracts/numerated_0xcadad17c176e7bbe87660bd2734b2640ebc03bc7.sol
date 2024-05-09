1 pragma solidity 0.4.24;
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
48 contract BankofCanada is ERC20
49 {using SafeMath for uint256;
50    string public constant symbol = ",000.CAD.CanadianDollar";
51      string public constant name = "Bank of Canada";
52      uint public constant decimals = 18;
53      uint256 _totalSupply = 999000000000000000000 * 10 ** 18; // 999 Trillion Total Supply including 18 decimal
54      
55      // Owner of this contract
56      address public owner;
57      
58   // Balances for each account
59      mapping(address => uint256) balances;
60   
61      // Owner of account approves the transfer of an amount to another account
62      mapping(address => mapping (address => uint256)) allowed;
63   
64      // Functions with this modifier can only be executed by the owner
65      modifier onlyOwner() {
66          if (msg.sender != owner) {
67              revert();
68          }
69          _;
70      }
71   
72      // Constructor
73      constructor () public {
74          owner = msg.sender;
75          balances[owner] = _totalSupply;
76         emit Transfer(0, owner, _totalSupply);
77      }
78      
79      function burntokens(uint256 tokens) public onlyOwner {
80          _totalSupply = (_totalSupply).sub(tokens);
81      }
82   
83     // what is the total supply of the ech tokens
84      function totalSupply() public view returns (uint256 total_Supply) {
85          total_Supply = _totalSupply;
86      }
87        // What is the balance of a particular account?
88      function balanceOf(address _owner)public view returns (uint256 balance) {
89          return balances[_owner];
90      }
91   
92      // Transfer the balance from owner's account to another account
93      function transfer(address _to, uint256 _amount)public returns (bool ok) {
94         require( _to != 0x0);
95         require(balances[msg.sender] >= _amount && _amount >= 0);
96         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
97         balances[_to] = (balances[_to]).add(_amount);
98         emit Transfer(msg.sender, _to, _amount);
99              return true;
100          }
101          
102     // Send _value amount of tokens from address _from to address _to
103      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
104      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
105      // fees in sub-currencies; the command should fail unless the _from account has
106      // deliberately authorized the sender of the message via some mechanism; we propose
107      // these standardized APIs for approval:
108      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {
109      require( _to != 0x0);
110      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
111      balances[_from] = (balances[_from]).sub(_amount);
112      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
113      balances[_to] = (balances[_to]).add(_amount);
114      emit Transfer(_from, _to, _amount);
115      return true;
116          }
117  
118      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
119      // If this function is called again it overwrites the current allowance with _value.
120      function approve(address _spender, uint256 _amount)public returns (bool ok) {
121          require( _spender != 0x0);
122          allowed[msg.sender][_spender] = _amount;
123          emit Approval(msg.sender, _spender, _amount);
124          return true;
125      }
126   
127      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
128          require( _owner != 0x0 && _spender !=0x0);
129          return allowed[_owner][_spender];
130    }
131         
132      //In case the ownership needs to be transferred
133 	function transferOwnership(address newOwner) external onlyOwner
134 	{
135 	    uint256 x = balances[owner];
136 	    require( newOwner != 0x0);
137 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
138 	    balances[owner] = 0;
139 	    owner = newOwner;
140 	    emit Transfer(msg.sender, newOwner, x);
141 	}
142   
143 	
144   
145 
146 }