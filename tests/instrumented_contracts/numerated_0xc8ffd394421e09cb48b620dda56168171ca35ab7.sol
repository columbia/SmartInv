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
68      uint8 public constant decimals = 18;
69      uint256 _totalSupply = Mul(360000000,(10 **18));
70      
71      // Owner of this contract
72      address public owner;
73      
74      address central_account;
75   
76      // Balances for each account
77      mapping(address => uint256) balances;
78   
79      // Owner of account approves the transfer of an amount to another account
80      mapping(address => mapping (address => uint256)) allowed;
81      
82      
83   
84      // Functions with this modifier can only be executed by the owner
85      modifier onlyOwner() {
86          require (msg.sender == owner);
87          _;
88      }
89       modifier onlycentralAccount {
90         require(msg.sender == central_account);
91         _;
92     }
93   
94      // Constructor
95      function etherecash() public {
96          owner = msg.sender;
97          balances[owner] = _totalSupply;
98      }
99   
100   function set_centralAccount(address central_Acccount) external onlyOwner
101     {
102         require(central_Acccount != 0x0);
103         central_account = central_Acccount;
104     }
105     
106     // what is the total supply of the ech tokens
107      function totalSupply() public view returns (uint256 total_Supply) {
108          total_Supply = _totalSupply;
109      }
110   
111      // What is the balance of a particular account?
112      function balanceOf(address _owner)public view returns (uint256 balance) {
113          return balances[_owner];
114      }
115   
116      // Transfer the balance from owner's account to another account
117      function transfer(address _to, uint256 _amount)public returns (bool success) {
118          require( _to != 0x0);
119          require(balances[msg.sender] >= _amount 
120              && _amount >= 0
121              && balances[_to] + _amount >= balances[_to]);
122            balances[msg.sender] = Sub(balances[msg.sender], _amount);
123              balances[_to] = Add(balances[_to], _amount);
124              Transfer(msg.sender, _to, _amount);
125              return true;
126         
127      }
128   
129      // Send _value amount of tokens from address _from to address _to
130      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
131      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
132      // fees in sub-currencies; the command should fail unless the _from account has
133      // deliberately authorized the sender of the message via some mechanism; we propose
134      // these standardized APIs for approval:
135      function transferFrom(
136          address _from,
137          address _to,
138          uint256 _amount
139      )public returns (bool success) {
140         require(_to != 0x0); 
141          require(balances[_from] >= _amount
142              && allowed[_from][msg.sender] >= _amount
143              && _amount >= 0
144              && balances[_to] + _amount >= balances[_to]);
145         balances[_from] = Sub(balances[_from], _amount);
146              allowed[_from][msg.sender] = Sub(allowed[_from][msg.sender], _amount);
147              balances[_to] = Add(balances[_to], _amount);
148              Transfer(_from, _to, _amount);
149              return true;
150              }
151  
152      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
153      // If this function is called again it overwrites the current allowance with _value.
154      function approve(address _spender, uint256 _amount)public returns (bool success) {
155          allowed[msg.sender][_spender] = _amount;
156          Approval(msg.sender, _spender, _amount);
157          return true;
158      }
159   
160      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
161          return allowed[_owner][_spender];
162    }
163    
164    event check1(uint taxtoken, uint totalToken);
165    event check2(uint comtoken, uint totalToken);
166    //  0.01 % = 1 and 100% = 10000
167     function zero_fee_transaction(address _from, address _to, uint256 _amount, uint tax) external onlycentralAccount returns(bool success) {
168         require(_to != 0x0 && tax >=0);
169 
170       uint256 taxToken = Div((Mul(tax,  _amount)), 10000); 
171       uint256 totalToken = Add(_amount, taxToken);
172       check1(taxToken,totalToken);
173        require (balances[_from] >= totalToken  &&
174             totalToken > 0 &&
175             balances[_to] + totalToken > balances[_to]);
176             balances[_from] = Sub(balances[_from], totalToken);
177             balances[_to] = Add(balances[_to], _amount);
178             balances[owner] = Add(balances[owner], taxToken);
179             Transfer(_from, _to, _amount);
180             Transfer(_from, owner, taxToken);
181             return true;
182            }
183 
184    // .01 % = 1 and 100% = 10000
185     function com_fee_transaction(address _from,address _to,address _taxCollector, uint256 _amount, uint commision) external onlycentralAccount returns(bool success) {
186       require(_to != 0x0 && _taxCollector != 0x0 && commision >=0); 
187       uint256 comToken = Div((Mul(commision,  _amount)), 10000); 
188       uint256 totalToken = Sub(_amount, comToken);
189        check1(comToken,totalToken);
190       require (balances[_from] >= _amount &&
191             totalToken >=0 &&
192         balances[_to] + totalToken > balances[_to]);
193            balances[_from] = Sub(balances[_from], _amount);
194            balances[_to] = Add(balances[_to], totalToken);
195             balances[_taxCollector] = Add(balances[_taxCollector], comToken);
196             Transfer(_from, _to, totalToken);
197             Transfer(_from, _taxCollector, comToken);
198             return true;
199        }
200 
201  
202     
203 	//In case the ownership needs to be transferred
204 	function transferOwnership(address newOwner)public onlyOwner
205 	{
206 	    require( newOwner != 0x0);
207 	    balances[newOwner] = Add(balances[newOwner],balances[owner]);
208 	    balances[owner] = 0;
209 	    owner = newOwner;
210 	}
211 
212 }