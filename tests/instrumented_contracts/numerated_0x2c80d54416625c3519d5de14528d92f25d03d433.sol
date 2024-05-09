1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Acute Angle Coin by TTC Limited.
5 // An ERC20 standard
6 //
7 // author: TTC Team
8 
9 contract ERC20Interface {
10     function totalSupply() public constant returns (uint256 _totalSupply);
11     function balanceOf(address _owner) public constant returns (uint256 balance);
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 contract TTC is ERC20Interface {
21     uint256 public constant decimals = 5;
22 
23     string public constant symbol = "TTC";
24     string public constant name = "TTC";
25 
26     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 TTC
27 
28     // Owner of this contract
29     address public owner;
30 
31     // Balances TTC for each account
32     mapping(address => uint256) private balances;
33 
34     // Owner of account approves the transfer of an amount to another account
35     mapping(address => mapping (address => uint256)) private allowed;
36 
37     // List of approved investors
38     mapping(address => bool) private approvedInvestorList;
39 
40     // deposit
41     mapping(address => uint256) private deposit;
42 
43 
44     // totalTokenSold
45     uint256 public totalTokenSold = 0;
46 
47     // tradable
48     bool public tradable = false;
49 
50     /**
51      * Functions with this modifier can only be executed by the owner
52      */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58 
59     /**
60      * @dev Fix for the ERC20 short address attack.
61      */
62     modifier onlyPayloadSize(uint size) {
63       if(msg.data.length < size + 4) {
64         revert();
65       }
66       _;
67     }
68 
69 
70 
71     /// @dev Constructor
72     function TTC()
73         public {
74         owner = msg.sender;
75     }
76 
77     /// @dev Gets totalSupply
78     /// @return Total supply
79     function totalSupply()
80         public
81         constant
82         returns (uint256) {
83         return _totalSupply;
84     }
85 
86 
87 
88     function turnOnTradable()
89         public
90         onlyOwner{
91         tradable = true;
92     }
93 
94 
95     /// @dev Gets account's balance
96     /// @param _addr Address of the account
97     /// @return Account balance
98     function balanceOf(address _addr)
99         public
100         constant
101         returns (uint256) {
102         return balances[_addr];
103     }
104 
105     /// @dev check address is approved investor
106     /// @param _addr address
107     function isApprovedInvestor(address _addr)
108         public
109         constant
110         returns (bool) {
111         return approvedInvestorList[_addr];
112     }
113 
114     /// @dev get ETH deposit
115     /// @param _addr address get deposit
116     /// @return amount deposit of an buyer
117     function getDeposit(address _addr)
118         public
119         constant
120         returns(uint256){
121         return deposit[_addr];
122 }
123 
124 
125     /// @dev Transfers the balance from msg.sender to an account
126     /// @param _to Recipient address
127     /// @param _amount Transfered amount in unit
128     /// @return Transfer status
129     function transfer(address _to, uint256 _amount)
130         public
131 
132         returns (bool) {
133         // if sender's balance has enough unit and amount >= 0,
134         //      and the sum is not overflow,
135         // then do transfer
136         if ( (balances[msg.sender] >= _amount) &&
137              (_amount >= 0) &&
138              (balances[_to] + _amount > balances[_to]) ) {
139 
140             balances[msg.sender] -= _amount;
141             balances[_to] += _amount;
142             Transfer(msg.sender, _to, _amount);
143             return true;
144         } else {
145             return false;
146         }
147     }
148 
149     // Send _value amount of tokens from address _from to address _to
150     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
151     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
152     // fees in sub-currencies; the command should fail unless the _from account has
153     // deliberately authorized the sender of the message via some mechanism; we propose
154     // these standardized APIs for approval:
155     function transferFrom(
156         address _from,
157         address _to,
158         uint256 _amount
159     )
160     public
161 
162     returns (bool success) {
163         if (balances[_from] >= _amount
164             && allowed[_from][msg.sender] >= _amount
165             && _amount > 0
166             && balances[_to] + _amount > balances[_to]) {
167             balances[_from] -= _amount;
168             allowed[_from][msg.sender] -= _amount;
169             balances[_to] += _amount;
170             Transfer(_from, _to, _amount);
171             return true;
172         } else {
173             return false;
174         }
175     }
176 
177     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
178     // If this function is called again it overwrites the current allowance with _value.
179     function approve(address _spender, uint256 _amount)
180         public
181 
182         returns (bool success) {
183         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
184         allowed[msg.sender][_spender] = _amount;
185         Approval(msg.sender, _spender, _amount);
186         return true;
187     }
188 
189     // get allowance
190     function allowance(address _owner, address _spender)
191         public
192         constant
193         returns (uint256 remaining) {
194         return allowed[_owner][_spender];
195     }
196 
197     function () public payable{
198         revert();
199     }
200 
201 }