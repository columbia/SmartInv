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
14 contract ContractTST is ERC20Interface {
15     uint256 public constant decimals = 5;
16 
17     string public constant symbol = "TST";
18     string public constant name = "TST Tokens";
19 
20     uint256 public _totalSupply = formatDecimals(500000000000); // total supply is 10 billion
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
42     // format decimals.
43     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
44         return _value * 10 ** decimals;
45     }
46 
47     /**
48      * @dev Fix for the ERC20 short address attack.
49      */
50     modifier onlyPayloadSize(uint size) {
51       if(msg.data.length < size + 4) {
52         revert();
53       }
54       _;
55     }
56 
57 
58 
59     /// @dev Constructor
60     function ContractTST()
61         public {
62         owner = msg.sender;
63         balances[owner] = _totalSupply;
64     }
65 
66     /// @dev Gets totalSupply
67     /// @return Total supply
68     function totalSupply()
69         public
70         constant
71         returns (uint256) {
72         return _totalSupply;
73     }
74 
75 
76 
77 
78 
79     /// @dev Gets account's balance
80     /// @param _addr Address of the account
81     /// @return Account balance
82     function balanceOf(address _addr)
83         public
84         constant
85         returns (uint256) {
86         return balances[_addr];
87     }
88 
89     /// @dev check address is approved investor
90     /// @param _addr address
91     function isApprovedInvestor(address _addr)
92         public
93         constant
94         returns (bool) {
95         return approvedInvestorList[_addr];
96     }
97 
98     /// @dev get ETH deposit
99     /// @param _addr address get deposit
100     /// @return amount deposit of an buyer
101     function getDeposit(address _addr)
102         public
103         constant
104         returns(uint256){
105         return deposit[_addr];
106 }
107 
108 
109     /// @dev Transfers the balance from msg.sender to an account
110     /// @param _to Recipient address
111     /// @param _amount Transfered amount in unit
112     /// @return Transfer status
113     function transfer(address _to, uint256 _amount)
114         public
115 
116         returns (bool) {
117         // if sender's balance has enough unit and amount >= 0,
118         //      and the sum is not overflow,
119         // then do transfer
120         if ( (balances[msg.sender] >= _amount) &&
121              (_amount >= 0) &&
122              (balances[_to] + _amount > balances[_to]) ) {
123 
124             balances[msg.sender] -= _amount;
125             balances[_to] += _amount;
126             emit Transfer(msg.sender, _to, _amount);
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     // Send _value amount of tokens from address _from to address _to
134     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
135     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
136     // fees in sub-currencies; the command should fail unless the _from account has
137     // deliberately authorized the sender of the message via some mechanism; we propose
138     // these standardized APIs for approval:
139     function transferFrom(
140         address _from,
141         address _to,
142         uint256 _amount
143     )
144     public
145 
146     returns (bool success) {
147         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
148             balances[_from] -= _amount;
149             allowed[_from][msg.sender] -= _amount;
150             balances[_to] += _amount;
151             emit Transfer(_from, _to, _amount);
152             return true;
153         } else {
154             return false;
155         }
156     }
157 
158     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
159     // If this function is called again it overwrites the current allowance with _value.
160     function approve(address _spender, uint256 _amount)
161         public
162 
163         returns (bool success) {
164         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
165         allowed[msg.sender][_spender] = _amount;
166         emit Approval(msg.sender, _spender, _amount);
167         return true;
168     }
169 
170     // get allowance
171     function allowance(address _owner, address _spender)
172         public
173         constant
174         returns (uint256 remaining) {
175         return allowed[_owner][_spender];
176     }
177 
178     function () public payable{
179         revert();
180     }
181 
182 }