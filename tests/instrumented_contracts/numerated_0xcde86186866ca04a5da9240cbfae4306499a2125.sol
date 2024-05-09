1 pragma solidity 0.4.18;
2 
3 /**
4  * Contract "Math"
5  * Purpose: Math operations with safety checks
6  * Status : Complete
7  * 
8  */
9 contract Math {
10 
11     /**
12     * Multiplication with safety check
13     */
14     function Mul(uint a, uint b) pure internal returns (uint) {
15       uint c = a * b;
16       //check result should not be other wise until a=0
17       assert(a == 0 || c / a == b);
18       return c;
19     }
20 
21     /**
22     * Division with safety check
23     */
24     function Div(uint a, uint b) pure internal returns (uint) {
25       //overflow check; b must not be 0
26       assert(b > 0);
27       uint c = a / b;
28       assert(a == b * c + a % b);
29       return c;
30     }
31 
32     /**
33     * Subtraction with safety check
34     */
35     function Sub(uint a, uint b) pure internal returns (uint) {
36       //b must be greater that a as we need to store value in unsigned integer
37       assert(b <= a);
38       return a - b;
39     }
40 
41     /**
42     * Addition with safety check
43     */
44     function Add(uint a, uint b) pure internal returns (uint) {
45       uint c = a + b;
46       //result must be greater as a or b can not be negative
47       assert(c>=a && c>=b);
48       return c;
49     }
50 }
51 
52   contract ERC20 {
53   function totalSupply()public view returns (uint total_Supply);
54   function balanceOf(address who)public view returns (uint256);
55   function allowance(address owner, address spender)public view returns (uint);
56   function transferFrom(address from, address to, uint value)public returns (bool ok);
57   function approve(address spender, uint value)public returns (bool ok);
58   function transfer(address to, uint value)public returns (bool ok);
59   event Transfer(address indexed from, address indexed to, uint value);
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 
64 contract etherecash is ERC20,Math
65 {
66    string public constant symbol = "ECH";
67      string public constant name = "EtherEcash";
68      uint public constant decimals = 18;
69      uint256 _totalSupply = Mul(360000000,(10 **decimals));
70      
71      // Owner of this contract
72      address public owner;
73   
74      // Balances for each account
75      mapping(address => uint256) balances;
76   
77      // Owner of account approves the transfer of an amount to another account
78      mapping(address => mapping (address => uint256)) allowed;
79   
80      // Functions with this modifier can only be executed by the owner
81      modifier onlyOwner() {
82          if (msg.sender != owner) {
83              revert();
84          }
85          _;
86      }
87   
88      // Constructor
89      function etherecash() public {
90          owner = msg.sender;
91          balances[owner] = _totalSupply;
92      }
93   
94     // what is the total supply of the ech tokens
95      function totalSupply() public view returns (uint256 total_Supply) {
96          total_Supply = _totalSupply;
97      }
98   
99      // What is the balance of a particular account?
100      function balanceOf(address _owner)public view returns (uint256 balance) {
101          return balances[_owner];
102      }
103   
104      // Transfer the balance from owner's account to another account
105      function transfer(address _to, uint256 _amount)public returns (bool success) {
106          if (balances[msg.sender] >= _amount 
107              && _amount > 0
108              && balances[_to] + _amount > balances[_to]) {
109              balances[msg.sender] = Sub(balances[msg.sender], _amount);
110              balances[_to] = Add(balances[_to], _amount);
111              Transfer(msg.sender, _to, _amount);
112              return true;
113          } else {
114              return false;
115          }
116      }
117   
118      // Send _value amount of tokens from address _from to address _to
119      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
120      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
121      // fees in sub-currencies; the command should fail unless the _from account has
122      // deliberately authorized the sender of the message via some mechanism; we propose
123      // these standardized APIs for approval:
124      function transferFrom(
125          address _from,
126          address _to,
127          uint256 _amount
128      )public returns (bool success) {
129          if (balances[_from] >= _amount
130              && allowed[_from][msg.sender] >= _amount
131              && _amount > 0
132              && balances[_to] + _amount > balances[_to]) {
133              balances[_from] = Sub(balances[_from], _amount);
134              allowed[_from][msg.sender] = Sub(allowed[_from][msg.sender], _amount);
135              balances[_to] = Add(balances[_to], _amount);
136              Transfer(_from, _to, _amount);
137              return true;
138          } else {
139              return false;
140          }
141      }
142  
143      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
144      // If this function is called again it overwrites the current allowance with _value.
145      function approve(address _spender, uint256 _amount)public returns (bool success) {
146          allowed[msg.sender][_spender] = _amount;
147          Approval(msg.sender, _spender, _amount);
148          return true;
149      }
150   
151      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
152          return allowed[_owner][_spender];
153    }
154      
155 
156 	//In case the ownership needs to be transferred
157 	function transferOwnership(address newOwner)public onlyOwner
158 	{
159 	    balances[newOwner] = Add(balances[newOwner],balances[owner]);
160 	    balances[owner] = 0;
161 	    owner = newOwner;
162 	}
163 
164 }