1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 contract ERC20 {
32   function totalSupply()public view returns (uint total_Supply);
33   function balanceOf(address who)public view returns (uint256);
34   function allowance(address owner, address spender)public view returns (uint);
35   function transferFrom(address from, address to, uint value)public returns (bool ok);
36   function approve(address spender, uint value)public returns (bool ok);
37   function transfer(address to, uint value)public returns (bool ok);
38   event Transfer(address indexed from, address indexed to, uint value);
39   event Approval(address indexed owner, address indexed spender, uint value);
40 }
41 contract BEEFToken is ERC20
42 { using SafeMath for uint256;
43     // Name of the token
44     string public constant name = "BEEF Token";
45     // Symbol of token
46     string public constant symbol = "BEEF";
47     uint8 public constant decimals = 8;
48     uint public Totalsupply;
49     uint256 public Max_Mintable = 888888888 * 10 ** 8 ;
50     address public owner;  // Owner of this contract
51     uint256 no_of_tokens;
52     mapping(address => uint) balances;
53     mapping(address => mapping(address => uint)) allowed;
54      modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58     
59     
60     constructor() public
61     {
62         owner = msg.sender;
63        
64     }
65   
66     //mint the tokens, can be called only by owner. total supply also increases
67     function mintTokens(address seller, uint256 _amount) external onlyOwner{
68         require(Max_Mintable >= (Totalsupply + _amount) && _amount > 0);
69         require( seller != 0x0 && _amount > 0);
70         balances[seller] = (balances[seller]).add(_amount);
71         Totalsupply = (Totalsupply).add(_amount);
72         emit Transfer(0, seller, _amount);
73        }
74     
75  
76     
77    
78     // what is the total supply of the ech tokens
79      function totalSupply() public view returns (uint256 total_Supply) {
80          total_Supply = Totalsupply;
81      }
82     
83     // What is the balance of a particular account?
84      function balanceOf(address _owner)public view returns (uint256 balance) {
85          return balances[_owner];
86      }
87     
88     // Send _value amount of tokens from address _from to address _to
89      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
90      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
91      // fees in sub-currencies; the command should fail unless the _from account has
92      // deliberately authorized the sender of the message via some mechanism; we propose
93      // these standardized APIs for approval:
94      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
95      require( _to != 0x0);
96      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
97      balances[_from] = (balances[_from]).sub(_amount);
98      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
99      balances[_to] = (balances[_to]).add(_amount);
100      emit Transfer(_from, _to, _amount);
101      return true;
102          }
103     
104    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
105      // If this function is called again it overwrites the current allowance with _value.
106      function approve(address _spender, uint256 _amount)public returns (bool success) {
107          require( _spender != 0x0);
108          allowed[msg.sender][_spender] = _amount;
109          emit Approval(msg.sender, _spender, _amount);
110          return true;
111      }
112   
113      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
114          require( _owner != 0x0 && _spender !=0x0);
115          return allowed[_owner][_spender];
116    }
117      // Transfer the balance from owner's account to another account
118      function transfer(address _to, uint256 _amount)public returns (bool success) {
119         require( _to != 0x0);
120         require(balances[msg.sender] >= _amount && _amount >= 0);
121         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
122         balances[_to] = (balances[_to]).add(_amount);
123         emit Transfer(msg.sender, _to, _amount);
124              return true;
125          }
126     
127   
128 }