1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-01
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-12-31
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2018-08-01 - Adopted from 0x1fa301a740b039e08f88389ef561c4126f652ed0
11 */
12 
13 pragma solidity 0.5.12;
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract  ERC20 {
49   function totalSupply()public view returns (uint total_Supply);
50   function balanceOf(address who)public view returns (uint256);
51   function allowance(address owner, address spender)public view returns (uint);
52   function transferFrom(address from, address to, uint value)public returns (bool ok);
53   function approve(address spender, uint value)public returns (bool ok);
54   function transfer(address to, uint value)public returns (bool ok);
55   event Transfer(address indexed from, address indexed to, uint value);
56   event Approval(address indexed owner, address indexed spender, uint value);
57 }
58 
59 
60 contract Mandi is ERC20
61 { using SafeMath for uint256;
62     // Name of the token
63     string private constant _name = "Mandi";
64 
65     // Symbol of token
66     string private constant _symbol = "Mandi";
67     uint8 private constant _decimals = 8;
68     uint public Totalsupply = 10000000000 * 10 ** 8 ;
69     address public owner;  // Owner of this contract
70     uint256 no_of_tokens;
71     address public admin_account;
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     event ChangeOwnerShip(address indexed newOwner);
76     event ChangeAdmin(address indexed administrative_Acccount);
77 
78 
79     modifier onlyOwner() {
80         require(msg.sender == owner, "Only Owner is allowed");
81         _;
82     }
83 
84      modifier onlyadminAccount {
85         require(msg.sender == admin_account, "Only Admin is allowed");
86         _;
87     }
88 
89 
90     constructor() public
91     {
92         owner = msg.sender;
93         balances[owner] = Totalsupply;  
94         emit Transfer(address(0), owner, balances[owner]);
95 
96     }
97 
98        function name() public pure returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public pure returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public pure returns (uint8) {
107         return _decimals;
108     }
109 
110 
111 
112   // Adding new Admin , can be done only by Owner of the contract
113      function set_centralAccount(address administrative_Acccount) external onlyOwner
114      {
115         require( administrative_Acccount != address(0), "Address can not be 0x0");
116 	    uint256 _previousAdminBalance = balances[admin_account];
117 	    balances[administrative_Acccount] = (balances[administrative_Acccount]).add(balances[admin_account]);
118 	    balances[admin_account] = 0;
119 	    admin_account = administrative_Acccount;
120 	    emit ChangeAdmin(administrative_Acccount);
121 	    emit Transfer(msg.sender, administrative_Acccount, _previousAdminBalance);
122      }
123 
124     // what is the total supply of the ech tokens
125      function totalSupply() public view returns (uint256 total_Supply) {
126          total_Supply = Totalsupply;
127      }
128 
129       // what is the total supply of the Mandi token
130      function currentSupply() public view returns (uint256 current_Supply) {
131          current_Supply = Totalsupply.sub(balances[owner]);
132      }
133 
134     // What is the balance of a particular account?
135      function balanceOf(address _owner)public view returns (uint256 balance) {
136          return balances[_owner];
137      }
138 
139     // Send _value amount of tokens from address _from to address _to
140      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
141      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
142      // fees in sub-currencies; the command should fail unless the _from account has
143      // deliberately authorized the sender of the message via some mechanism; we propose
144      // these standardized APIs for approval:
145      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
146      require( _to != address(0), "Receiver can not be 0x0");
147      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
148      balances[_from] = (balances[_from]).sub(_amount);
149      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
150      balances[_to] = (balances[_to]).add(_amount);
151      emit Transfer(_from, _to, _amount);
152      return true;
153          }
154 
155    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
156      // If this function is called again it overwrites the current allowance with _value.
157      function approve(address _spender, uint256 _amount)public returns (bool success) {
158          require( _spender != address(0), "Address can not be 0x0");
159          allowed[msg.sender][_spender] = _amount;
160          emit Approval(msg.sender, _spender, _amount);
161          return true;
162      }
163 
164      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
165          require( _owner != address(0) && _spender !=address(0));
166          return allowed[_owner][_spender];
167    }
168 
169      // Transfer the balance from owner's account to another account
170      function transfer(address _to, uint256 _amount)public returns (bool success) {
171         require( _to != address(0), "Address can not be 0x0");
172         require(balances[msg.sender] >= _amount && _amount >= 0);
173         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
174         balances[_to] = (balances[_to]).add(_amount);
175         emit Transfer(msg.sender, _to, _amount);
176              return true;
177          }
178 
179     //In case the ownership needs to be transferred
180 	function transferOwnership(address newOwner) external onlyOwner
181 	{
182 	    require( newOwner != address(0), "Address can not be 0x0");
183 	    uint256 _previousOwnerBalance = balances[owner];
184 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
185 	    balances[owner] = 0;
186 	    owner = newOwner;
187 	    emit ChangeOwnerShip(newOwner);
188 	    emit Transfer(msg.sender, newOwner, _previousOwnerBalance);
189 	}
190 }