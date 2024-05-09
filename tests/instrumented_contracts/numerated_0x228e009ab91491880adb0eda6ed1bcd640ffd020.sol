1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 _totalSupply);
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract GUS is ERC20Interface {
15     uint256 public constant decimals = 5;
16 
17     string public constant symbol = "GUS";
18     string public constant name = "GuessChain";
19 
20     uint256 public _totalSupply = 10 ** 14; 
21 
22     // Owner of this contract
23     address public owner;
24 
25     // Balances AAC for each account
26     mapping(address => uint256) private balances;
27 
28     // Owner of account approves the transfer of an amount to another account
29     mapping(address => mapping (address => uint256)) private allowed;
30 
31     // List of approved investors
32     mapping(address => bool) private approvedInvestorList;
33 
34     // deposit
35     mapping(address => uint256) private deposit;
36 
37 
38     // totalTokenSold
39     uint256 public totalTokenSold = 0;
40 
41 
42     /**
43      * @dev Fix for the ERC20 short address attack.
44      */
45     modifier onlyPayloadSize(uint size) {
46       if(msg.data.length < size + 4) {
47         revert();
48       }
49       _;
50     }
51 
52 
53 
54     /// @dev Constructor
55     function GUS()
56         public {
57         owner = msg.sender;
58         balances[owner] = _totalSupply;
59     }
60 
61     /// @dev Gets totalSupply
62     /// @return Total supply
63     function totalSupply()
64         public
65         constant
66         returns (uint256) {
67         return _totalSupply;
68     }
69 
70 
71 
72 
73 
74     /// @dev Gets account's balance
75     /// @param _addr Address of the account
76     /// @return Account balance
77     function balanceOf(address _addr)
78         public
79         constant
80         returns (uint256) {
81         return balances[_addr];
82     }
83 
84     /// @dev check address is approved investor
85     /// @param _addr address
86     function isApprovedInvestor(address _addr)
87         public
88         constant
89         returns (bool) {
90         return approvedInvestorList[_addr];
91     }
92 
93     /// @dev get ETH deposit
94     /// @param _addr address get deposit
95     /// @return amount deposit of an buyer
96     function getDeposit(address _addr)
97         public
98         constant
99         returns(uint256){
100         return deposit[_addr];
101 }
102 
103 
104     /// @dev Transfers the balance from msg.sender to an account
105     /// @param _to Recipient address
106     /// @param _amount Transfered amount in unit
107     /// @return Transfer status
108     function transfer(address _to, uint256 _amount)
109         public
110 
111         returns (bool) {
112         // if sender's balance has enough unit and amount >= 0,
113         //      and the sum is not overflow,
114         // then do transfer
115         if ( (balances[msg.sender] >= _amount) &&
116              (_amount >= 0) &&
117              (balances[_to] + _amount > balances[_to]) ) {
118 
119             balances[msg.sender] -= _amount;
120             balances[_to] += _amount;
121             Transfer(msg.sender, _to, _amount);
122             return true;
123         } else {
124             return false;
125         }
126     }
127 
128     // Send _value amount of tokens from address _from to address _to
129     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
130     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
131     // fees in sub-currencies; the command should fail unless the _from account has
132     // deliberately authorized the sender of the message via some mechanism; we propose
133     // these standardized APIs for approval:
134     function transferFrom(
135         address _from,
136         address _to,
137         uint256 _amount
138     )
139     public
140 
141     returns (bool success) {
142         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
143             balances[_from] -= _amount;
144             allowed[_from][msg.sender] -= _amount;
145             balances[_to] += _amount;
146             Transfer(_from, _to, _amount);
147             return true;
148         } else {
149             return false;
150         }
151     }
152 
153     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
154     // If this function is called again it overwrites the current allowance with _value.
155     function approve(address _spender, uint256 _amount)
156         public
157 
158         returns (bool success) {
159         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
160         allowed[msg.sender][_spender] = _amount;
161         Approval(msg.sender, _spender, _amount);
162         return true;
163     }
164 
165     // get allowance
166     function allowance(address _owner, address _spender)
167         public
168         constant
169         returns (uint256 remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     function () public payable{
174         revert();
175     }
176 
177 }