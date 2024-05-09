1 /**
2  *Submitted for verification at Etherscan.io on 2018-09-24
3 */
4 
5 pragma solidity 0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40   contract ERC20 {
41   function totalSupply()public view returns (uint total_Supply);
42   function balanceOf(address _owner)public view returns (uint256 balance);
43   function allowance(address _owner, address _spender)public view returns (uint remaining);
44   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
45   function approve(address _spender, uint _amount)public returns (bool ok);
46   function transfer(address _to, uint _amount)public returns (bool ok);
47   event Transfer(address indexed _from, address indexed _to, uint _amount);
48   event Approval(address indexed _owner, address indexed _spender, uint _amount);
49 }
50 
51 
52 contract UlsterBankCertifiedDeposit is ERC20
53 {using SafeMath for uint256;
54    string public constant symbol = ".EURO..";
55      string public constant name = "Ulster Bank Certified Deposit-Subsidiaries: Ulster Bank Ireland Limited";
56      uint public constant decimals = 18;
57      uint256 _totalSupply = 999000000000000000000 * 10 ** 18; // 999 Trillion Total Supply including 18 decimal
58      
59      // Owner of this contract
60      address public owner;
61      
62   // Balances for each account
63      mapping(address => uint256) balances;
64   
65      // Owner of account approves the transfer of an amount to another account
66      mapping(address => mapping (address => uint256)) allowed;
67   
68      // Functions with this modifier can only be executed by the owner
69      modifier onlyOwner() {
70          if (msg.sender != owner) {
71              revert();
72          }
73          _;
74      }
75   
76      // Constructor
77      constructor () public {
78          owner = msg.sender;
79          balances[owner] = _totalSupply;
80         emit Transfer(0, owner, _totalSupply);
81      }
82      
83      function burntokens(uint256 tokens) public onlyOwner {
84          _totalSupply = (_totalSupply).sub(tokens);
85      }
86   
87     // what is the total supply of the ech tokens
88      function totalSupply() public view returns (uint256 total_Supply) {
89          total_Supply = _totalSupply;
90      }
91        // What is the balance of a particular account?
92      function balanceOf(address _owner)public view returns (uint256 balance) {
93          return balances[_owner];
94      }
95   
96      // Transfer the balance from owner's account to another account
97      function transfer(address _to, uint256 _amount)public returns (bool ok) {
98         require( _to != 0x0);
99         require(balances[msg.sender] >= _amount && _amount >= 0);
100         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
101         balances[_to] = (balances[_to]).add(_amount);
102         emit Transfer(msg.sender, _to, _amount);
103              return true;
104          }
105          
106     // Send _value amount of tokens from address _from to address _to
107      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109      // fees in sub-currencies; the command should fail unless the _from account has
110      // deliberately authorized the sender of the message via some mechanism; we propose
111      // these standardized APIs for approval:
112      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {
113      require( _to != 0x0);
114      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
115      balances[_from] = (balances[_from]).sub(_amount);
116      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
117      balances[_to] = (balances[_to]).add(_amount);
118      emit Transfer(_from, _to, _amount);
119      return true;
120          }
121  
122      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
123      // If this function is called again it overwrites the current allowance with _value.
124      function approve(address _spender, uint256 _amount)public returns (bool ok) {
125          require( _spender != 0x0);
126          allowed[msg.sender][_spender] = _amount;
127          emit Approval(msg.sender, _spender, _amount);
128          return true;
129      }
130   
131      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
132          require( _owner != 0x0 && _spender !=0x0);
133          return allowed[_owner][_spender];
134    }
135         
136      //In case the ownership needs to be transferred
137 	function transferOwnership(address newOwner) external onlyOwner
138 	{
139 	    uint256 x = balances[owner];
140 	    require( newOwner != 0x0);
141 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
142 	    balances[owner] = 0;
143 	    owner = newOwner;
144 	    emit Transfer(msg.sender, newOwner, x);
145 	}
146   
147 	
148   
149 
150 }