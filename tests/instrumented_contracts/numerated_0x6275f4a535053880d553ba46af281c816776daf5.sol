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
48 contract SoarUSD is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "SoarUSD";
52 
53     // Symbol of token
54     string public constant symbol = "SoarUSD";
55     uint8 public constant decimals = 5;
56     uint public Totalsupply;
57     address public owner;  // Owner of this contract
58     address public central_account;
59     uint256 no_of_tokens;
60     bool stopped = false;
61     mapping(address => uint) balances;
62     mapping(address => mapping(address => uint)) allowed;
63 
64 
65      modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69     
70      modifier onlycentralAccount {
71         require(msg.sender == central_account);
72         _;
73     }
74 
75 
76     constructor() public
77     {
78         owner = msg.sender;
79        
80     }
81   
82     
83     //mint the tokens, can be called only by owner. total supply also increases
84     function mintTokens(address seller, uint256 _amount) external onlyOwner{
85       //  require(Maxsupply >= (Totalsupply + _amount) && _amount > 0);
86         require( seller != 0x0 && _amount > 0);
87         balances[seller] = (balances[seller]).add(_amount);
88         Totalsupply = (Totalsupply).add(_amount);
89         emit Transfer(0, seller, _amount);
90        }
91     
92     function set_centralAccount(address _central_Acccount) external onlyOwner
93     {
94         require(_central_Acccount != 0x0);
95         central_account = _central_Acccount;
96     }
97     
98      //burn the tokens, can be called only by owner. total supply also decreasees
99     function burnTokens(address seller,uint256 _amount) external onlyOwner{
100         require(balances[seller] >= _amount);
101         require( seller != 0x0 && _amount > 0);
102         balances[seller] = (balances[seller]).sub(_amount);
103         Totalsupply = Totalsupply.sub(_amount);
104         emit Transfer(seller, 0, _amount);
105     }
106     
107    
108     // what is the total supply of the ech tokens
109      function totalSupply() public view returns (uint256 total_Supply) {
110          total_Supply = Totalsupply;
111      }
112     
113     // What is the balance of a particular account?
114      function balanceOf(address _owner)public view returns (uint256 balance) {
115          return balances[_owner];
116      }
117     
118     // Send _value amount of tokens from address _from to address _to
119      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
120      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
121      // fees in sub-currencies; the command should fail unless the _from account has
122      // deliberately authorized the sender of the message via some mechanism; we propose
123      // these standardized APIs for approval:
124      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
125      require( _to != 0x0);
126      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
127      balances[_from] = (balances[_from]).sub(_amount);
128      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
129      balances[_to] = (balances[_to]).add(_amount);
130      emit Transfer(_from, _to, _amount);
131      return true;
132          }
133     
134    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
135      // If this function is called again it overwrites the current allowance with _value.
136      function approve(address _spender, uint256 _amount)public returns (bool success) {
137          require( _spender != 0x0);
138          allowed[msg.sender][_spender] = _amount;
139          emit Approval(msg.sender, _spender, _amount);
140          return true;
141      }
142   
143      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
144          require( _owner != 0x0 && _spender !=0x0);
145          return allowed[_owner][_spender];
146    }
147 
148      // Transfer the balance from owner's account to another account
149      function transfer(address _to, uint256 _amount)public returns (bool success) {
150         require( _to != 0x0);
151         require(balances[msg.sender] >= _amount && _amount >= 0);
152         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
153         balances[_to] = (balances[_to]).add(_amount);
154         emit Transfer(msg.sender, _to, _amount);
155              return true;
156          }
157     
158       
159          // Transfer the balance from central  account to another account
160     function TransferBy(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {
161         require( _to != 0x0 && _from !=0x0); 
162         require (balances[_from] >= _amount && _amount > 0);
163         balances[_from] = (balances[_from]).sub(_amount);
164         balances[_to] = (balances[_to]).add(_amount);
165         emit Transfer(_from, _to, _amount);
166         return true;
167     }
168 
169 }