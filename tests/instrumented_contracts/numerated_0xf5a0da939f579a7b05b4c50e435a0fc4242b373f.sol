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
48 contract Hedger is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "Hedger";
52 
53     // Symbol of token
54     string public constant symbol = "HDR";
55     uint8 public constant decimals = 18;
56     uint public Totalsupply;
57     address public owner;  // Owner of this contract
58     uint256 no_of_tokens;
59     mapping(address => uint) balances;
60     mapping(address => mapping(address => uint)) allowed;
61 
62 
63      modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67     
68     
69 
70     constructor() public
71     {
72         owner = msg.sender;
73        
74     }
75   
76     //mint the tokens, can be called only by owner. total supply also increases
77     function mintTokens(address seller, uint256 _amount) external onlyOwner{
78         require(_amount > 0);
79         require( seller != 0x0 && _amount > 0);
80         balances[seller] = (balances[seller]).add(_amount);
81         Totalsupply = (Totalsupply).add(_amount);
82         emit Transfer(0, seller, _amount);
83        }
84     
85  
86     
87      //burn the tokens. total supply also decreasees
88     function burnTokens(uint256 _amount) public returns (bool success){
89         require(balances[msg.sender] >= _amount);
90         require( _amount > 0);
91         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
92         Totalsupply = Totalsupply.sub(_amount);
93         emit Transfer(msg.sender, 0, _amount);
94         return true;
95     }
96     
97    
98     // what is the total supply of the ech tokens
99      function totalSupply() public view returns (uint256 total_Supply) {
100          total_Supply = Totalsupply;
101      }
102     
103     // What is the balance of a particular account?
104      function balanceOf(address _owner)public view returns (uint256 balance) {
105          return balances[_owner];
106      }
107     
108     // Send _value amount of tokens from address _from to address _to
109      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
110      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
111      // fees in sub-currencies; the command should fail unless the _from account has
112      // deliberately authorized the sender of the message via some mechanism; we propose
113      // these standardized APIs for approval:
114      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
115      require( _to != 0x0);
116      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
117      balances[_from] = (balances[_from]).sub(_amount);
118      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
119      balances[_to] = (balances[_to]).add(_amount);
120      emit Transfer(_from, _to, _amount);
121      return true;
122          }
123     
124    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
125      // If this function is called again it overwrites the current allowance with _value.
126      function approve(address _spender, uint256 _amount)public returns (bool success) {
127          require( _spender != 0x0);
128          allowed[msg.sender][_spender] = _amount;
129          emit Approval(msg.sender, _spender, _amount);
130          return true;
131      }
132   
133      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
134          require( _owner != 0x0 && _spender !=0x0);
135          return allowed[_owner][_spender];
136    }
137 
138      // Transfer the balance from owner's account to another account
139      function transfer(address _to, uint256 _amount)public returns (bool success) {
140         require( _to != 0x0);
141         require(balances[msg.sender] >= _amount && _amount >= 0);
142         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
143         balances[_to] = (balances[_to]).add(_amount);
144         emit Transfer(msg.sender, _to, _amount);
145              return true;
146          }
147     
148       //In case the ownership needs to be transferred
149 	function transferOwnership(address newOwner) external onlyOwner
150 	{
151 	    require( newOwner != 0x0);
152 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
153 	    balances[owner] = 0;
154 	    owner = newOwner;
155 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
156 	}
157   
158 
159 }