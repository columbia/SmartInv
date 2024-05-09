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
14 contract LIBC is ERC20Interface {
15     uint256 public constant decimals = 5;
16 
17     string public constant symbol = "LIBC";
18     string public constant name = "LibraCoin";
19 
20     uint256 public _totalSupply = 60000000000000; 
21 
22     // Owner of this contract
23     address public owner;
24 
25     // Balances LIBC for each account
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
55     function LIBC()
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
115         
116         require(_to != address(0));
117         require(_amount <= balances[msg.sender]);
118         require(_amount >= 0);
119         if ( (balances[msg.sender] >= _amount) &&
120              (_amount >= 0) &&
121              (balances[_to] + _amount > balances[_to]) ) {
122 
123             balances[msg.sender] -= _amount;
124             balances[_to] += _amount;
125             Transfer(msg.sender, _to, _amount);
126             return true;
127         } else {
128             return false;
129         }
130     }
131 
132     // Send _value amount of tokens from address _from to address _to
133     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
134     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
135     // fees in sub-currencies; the command should fail unless the _from account has
136     // deliberately authorized the sender of the message via some mechanism; we propose
137     // these standardized APIs for approval:
138     function transferFrom(
139         address _from,
140         address _to,
141         uint256 _amount
142     )
143     public
144 
145     returns (bool success) {
146         require(_to != address(0));
147         require(_amount <= balances[msg.sender]);
148         require(_amount >= 0);
149         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
150             balances[_from] -= _amount;
151             allowed[_from][msg.sender] -= _amount;
152             balances[_to] += _amount;
153             Transfer(_from, _to, _amount);
154             return true;
155         } else {
156             return false;
157         }
158     }
159 
160     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
161     // If this function is called again it overwrites the current allowance with _value.
162     function approve(address _spender, uint256 _amount)
163         public
164 
165         returns (bool success) {
166         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
167         allowed[msg.sender][_spender] = _amount;
168         Approval(msg.sender, _spender, _amount);
169         return true;
170     }
171 
172     // get allowance
173     function allowance(address _owner, address _spender)
174         public
175         constant
176         returns (uint256 remaining) {
177         return allowed[_owner][_spender];
178     }
179 
180     function () public payable{
181         revert();
182     }
183 
184 }