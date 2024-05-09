1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // FPC ERC20 Contract
5 //
6 // author: FairPlayChain Team
7 
8 contract ERC20Interface {
9     function totalSupply() public constant returns (uint256 _totalSupply);
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 contract ContractFPC is ERC20Interface {
20     uint256 public constant decimals = 8;
21 
22     string public constant symbol = "FPC";
23     string public constant name = "FairPlayChain Tokens";
24 
25     uint256 public _totalSupply = formatDecimals(10000000000); // total supply is 10 billion
26 
27     // Owner of this contract
28     address public owner;
29 
30     // Balances AAC for each account
31     mapping(address => uint256) private balances;
32 
33     // Owner of account approves the transfer of an amount to another account
34     mapping(address => mapping (address => uint256)) private allowed;
35 
36     // List of approved investors
37     mapping(address => bool) private approvedInvestorList;
38 
39     // deposit
40     mapping(address => uint256) private deposit;
41 
42 
43     // totalTokenSold
44     uint256 public totalTokenSold = 0;
45 
46 
47     // format decimals.
48     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
49         return _value * 10 ** decimals;
50     }
51 
52     /**
53      * @dev Fix for the ERC20 short address attack.
54      */
55     modifier onlyPayloadSize(uint size) {
56       if(msg.data.length < size + 4) {
57         revert();
58       }
59       _;
60     }
61 
62 
63 
64     /// @dev Constructor
65     function ContractFPC()
66         public {
67         owner = msg.sender;
68         balances[owner] = _totalSupply;
69     }
70 
71     /// @dev Gets totalSupply
72     /// @return Total supply
73     function totalSupply()
74         public
75         constant
76         returns (uint256) {
77         return _totalSupply;
78     }
79 
80 
81 
82 
83 
84     /// @dev Gets account's balance
85     /// @param _addr Address of the account
86     /// @return Account balance
87     function balanceOf(address _addr)
88         public
89         constant
90         returns (uint256) {
91         return balances[_addr];
92     }
93 
94     /// @dev check address is approved investor
95     /// @param _addr address
96     function isApprovedInvestor(address _addr)
97         public
98         constant
99         returns (bool) {
100         return approvedInvestorList[_addr];
101     }
102 
103     /// @dev get ETH deposit
104     /// @param _addr address get deposit
105     /// @return amount deposit of an buyer
106     function getDeposit(address _addr)
107         public
108         constant
109         returns(uint256){
110         return deposit[_addr];
111 }
112 
113 
114     /// @dev Transfers the balance from msg.sender to an account
115     /// @param _to Recipient address
116     /// @param _amount Transfered amount in unit
117     /// @return Transfer status
118     function transfer(address _to, uint256 _amount)
119         public
120 
121         returns (bool) {
122         // if sender's balance has enough unit and amount >= 0,
123         //      and the sum is not overflow,
124         // then do transfer
125         if ( (balances[msg.sender] >= _amount) &&
126              (_amount >= 0) &&
127              (balances[_to] + _amount > balances[_to]) ) {
128 
129             balances[msg.sender] -= _amount;
130             balances[_to] += _amount;
131             emit Transfer(msg.sender, _to, _amount);
132             return true;
133         } else {
134             return false;
135         }
136     }
137 
138     // Send _value amount of tokens from address _from to address _to
139     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
140     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
141     // fees in sub-currencies; the command should fail unless the _from account has
142     // deliberately authorized the sender of the message via some mechanism; we propose
143     // these standardized APIs for approval:
144     function transferFrom(
145         address _from,
146         address _to,
147         uint256 _amount
148     )
149     public
150 
151     returns (bool success) {
152         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
153             balances[_from] -= _amount;
154             allowed[_from][msg.sender] -= _amount;
155             balances[_to] += _amount;
156             emit Transfer(_from, _to, _amount);
157             return true;
158         } else {
159             return false;
160         }
161     }
162 
163     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
164     // If this function is called again it overwrites the current allowance with _value.
165     function approve(address _spender, uint256 _amount)
166         public
167 
168         returns (bool success) {
169         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
170         allowed[msg.sender][_spender] = _amount;
171         emit Approval(msg.sender, _spender, _amount);
172         return true;
173     }
174 
175     // get allowance
176     function allowance(address _owner, address _spender)
177         public
178         constant
179         returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183     function () public payable{
184         revert();
185     }
186 
187 }