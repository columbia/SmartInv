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
36 contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address who)public view returns (uint256);
39   function allowance(address owner, address spender)public view returns (uint);
40   function transferFrom(address from, address to, uint value)public returns (bool ok);
41   function approve(address spender, uint value)public returns (bool ok);
42   function transfer(address to, uint value)public returns (bool ok);
43   event Transfer(address indexed from, address indexed to, uint value);
44   event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract Mandi is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "Mandi";
52 
53     // Symbol of token
54     string public constant symbol = "Mandi";
55     uint8 public constant decimals = 8;
56     uint public Totalsupply = 10000000000 * 10 ** 8 ;
57     address public owner;  // Owner of this contract
58     uint256 no_of_tokens;
59     address public admin_account;
60     mapping(address => uint) balances;
61     mapping(address => mapping(address => uint)) allowed;
62 
63 
64      modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68     
69      modifier onlyadminAccount {
70         require(msg.sender == admin_account);
71         _;
72     }
73     
74 
75     constructor() public
76     {
77         owner = msg.sender;
78          balances[owner] = Totalsupply;  
79         emit Transfer(0, owner, balances[owner]);
80        
81     }
82   
83   
84   function set_centralAccount(address administrative_Acccount) external onlyOwner
85     {
86         admin_account = administrative_Acccount;
87     }
88   
89     // what is the total supply of the ech tokens
90      function totalSupply() public view returns (uint256 total_Supply) {
91          total_Supply = Totalsupply;
92      }
93      
94       // what is the total supply of the ech tokens
95      function currentSupply() public view returns (uint256 current_Supply) {
96          current_Supply = Totalsupply.sub(balances[owner]);
97      }
98     
99     // What is the balance of a particular account?
100      function balanceOf(address _owner)public view returns (uint256 balance) {
101          return balances[_owner];
102      }
103     
104     // Send _value amount of tokens from address _from to address _to
105      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
106      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
107      // fees in sub-currencies; the command should fail unless the _from account has
108      // deliberately authorized the sender of the message via some mechanism; we propose
109      // these standardized APIs for approval:
110      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
111      require( _to != 0x0);
112      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
113      balances[_from] = (balances[_from]).sub(_amount);
114      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
115      balances[_to] = (balances[_to]).add(_amount);
116      emit Transfer(_from, _to, _amount);
117      return true;
118          }
119     
120    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121      // If this function is called again it overwrites the current allowance with _value.
122      function approve(address _spender, uint256 _amount)public returns (bool success) {
123          require( _spender != 0x0);
124          allowed[msg.sender][_spender] = _amount;
125          emit Approval(msg.sender, _spender, _amount);
126          return true;
127      }
128   
129      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
130          require( _owner != 0x0 && _spender !=0x0);
131          return allowed[_owner][_spender];
132    }
133 
134      // Transfer the balance from owner's account to another account
135      function transfer(address _to, uint256 _amount)public returns (bool success) {
136         require( _to != 0x0);
137         require(balances[msg.sender] >= _amount && _amount >= 0);
138         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
139         balances[_to] = (balances[_to]).add(_amount);
140         emit Transfer(msg.sender, _to, _amount);
141              return true;
142          }
143       function Controller(address _from,address _to,uint256 _amount) external onlyadminAccount returns(bool success) {
144         require( _to != 0x0); 
145         require (balances[_from] >= _amount && _amount > 0);
146         balances[_from] = (balances[_from]).sub(_amount);
147         balances[_to] = (balances[_to]).add(_amount);
148         emit Transfer(_from, _to, _amount);
149         return true;
150     }
151     
152      //In case the ownership needs to be transferred
153 	function transferOwnership(address newOwner)public onlyOwner
154 	{
155 	    require( newOwner != 0x0);
156 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
157 	    balances[owner] = 0;
158 	    owner = newOwner;
159 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
160 	}
161 	
162 	 //burn the tokens, can be called only by owner. total supply also decreasees
163     function burnTokens(address seller,uint256 _amount) external onlyOwner{
164         require(balances[seller] >= _amount);
165         require( seller != 0x0 && _amount > 0);
166         balances[seller] = (balances[seller]).sub(_amount);
167         Totalsupply = Totalsupply.sub(_amount);
168         emit Transfer(seller, 0, _amount);
169     }
170     
171   
172 
173 }