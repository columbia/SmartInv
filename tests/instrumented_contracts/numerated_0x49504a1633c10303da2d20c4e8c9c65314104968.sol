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
48 contract futurechain is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "futurechain";
52 
53     // Symbol of token
54     string public constant symbol = "AFCC";
55     uint8 public constant decimals = 8;
56     uint public Totalsupply = 1000000000 * 10 ** 8 ;
57     //uint256 public Max_Mintable = 888888888 * 10 ** 8 ;
58     address public owner;  // Owner of this contract
59     uint256 no_of_tokens;
60     address public controllar_account;
61     mapping(address => uint) balances;
62     mapping(address => mapping(address => uint)) allowed;
63 
64 
65      modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69     
70      modifier onlycontrollarAccount {
71         require(msg.sender == controllar_account);
72         _;
73     }
74     
75 
76     constructor() public
77     {
78         owner = msg.sender;
79          balances[owner] = Totalsupply;  
80         emit Transfer(0, owner, balances[owner]);
81        
82     }
83   
84   
85   function set_centralAccount(address contoller_Acccount) external onlyOwner
86     {
87         controllar_account = contoller_Acccount;
88     }
89   
90     // what is the total supply of the ech tokens
91      function totalSupply() public view returns (uint256 total_Supply) {
92          total_Supply = Totalsupply;
93      }
94      
95       // what is the total supply of the ech tokens
96      function currentSupply() public view returns (uint256 current_Supply) {
97          current_Supply = Totalsupply.sub(balances[owner]);
98      }
99     
100     // What is the balance of a particular account?
101      function balanceOf(address _owner)public view returns (uint256 balance) {
102          return balances[_owner];
103      }
104     
105     // Send _value amount of tokens from address _from to address _to
106      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
107      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
108      // fees in sub-currencies; the command should fail unless the _from account has
109      // deliberately authorized the sender of the message via some mechanism; we propose
110      // these standardized APIs for approval:
111      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
112      require( _to != 0x0);
113      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
114      balances[_from] = (balances[_from]).sub(_amount);
115      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
116      balances[_to] = (balances[_to]).add(_amount);
117      emit Transfer(_from, _to, _amount);
118      return true;
119          }
120     
121    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
122      // If this function is called again it overwrites the current allowance with _value.
123      function approve(address _spender, uint256 _amount)public returns (bool success) {
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
135      // Transfer the balance from owner's account to another account
136      function transfer(address _to, uint256 _amount)public returns (bool success) {
137         require( _to != 0x0);
138         require(balances[msg.sender] >= _amount && _amount >= 0);
139         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
140         balances[_to] = (balances[_to]).add(_amount);
141         emit Transfer(msg.sender, _to, _amount);
142              return true;
143          }
144       function Controller(address _from,address _to,uint256 _amount) external onlycontrollarAccount returns(bool success) {
145         require( _to != 0x0); 
146         require (balances[_from] >= _amount && _amount > 0);
147         balances[_from] = (balances[_from]).sub(_amount);
148         balances[_to] = (balances[_to]).add(_amount);
149         emit Transfer(_from, _to, _amount);
150         return true;
151     }
152     
153      //In case the ownership needs to be transferred
154 	function transferOwnership(address newOwner)public onlyOwner
155 	{
156 	    require( newOwner != 0x0);
157 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
158 	    balances[owner] = 0;
159 	    owner = newOwner;
160 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
161 	}
162   
163 
164 }