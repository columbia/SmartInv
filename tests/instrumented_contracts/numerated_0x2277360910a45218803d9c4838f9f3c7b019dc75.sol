1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, July 4, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.18;
6 
7 // ----------------------------------------------------------------------------------------------
8 // DOLO by DOLO Limited.
9 // An ERC20 standard
10 //
11 // author: DOLO Team
12 
13 contract ERC20Interface {
14     function totalSupply() public constant returns (uint256 _totalSupply);
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16     function transfer(address _to, uint256 _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18     function approve(address _spender, uint256 _value) public returns (bool success);
19     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 contract DOLO is ERC20Interface {
25     uint256 public constant decimals = 8;
26 
27     string public constant symbol = "DOLO";
28     string public constant name = "DOLO";
29 
30     uint256 public _totalSupply = 10 ** 19; 
31 
32     // Owner of this contract
33     address public owner;
34 
35     // Balances DOLO for each account
36     mapping(address => uint256) private balances;
37 
38     // Owner of account approves the transfer of an amount to another account
39     mapping(address => mapping (address => uint256)) private allowed;
40 
41     // List of approved investors
42     mapping(address => bool) private approvedInvestorList;
43 
44     // deposit
45     mapping(address => uint256) private deposit;
46 
47 
48     // totalTokenSold
49     uint256 public totalTokenSold = 0;
50 
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
63     /// @dev Constructor
64     function DOLO()
65         public {
66         owner = msg.sender;
67         balances[owner] = _totalSupply;
68     }
69 
70     /// @dev Gets totalSupply
71     /// @return Total supply
72     function totalSupply()
73         public
74         constant
75         returns (uint256) {
76         return _totalSupply;
77     }
78 
79 
80     /// @dev Gets account's balance
81     /// @param _addr Address of the account
82     /// @return Account balance
83     function balanceOf(address _addr)
84         public
85         constant
86         returns (uint256) {
87         return balances[_addr];
88     }
89 
90     /// @dev check address is approved investor
91     /// @param _addr address
92     function isApprovedInvestor(address _addr)
93         public
94         constant
95         returns (bool) {
96         return approvedInvestorList[_addr];
97     }
98 
99     /// @dev get ETH deposit
100     /// @param _addr address get deposit
101     /// @return amount deposit of an buyer
102     function getDeposit(address _addr)
103         public
104         constant
105         returns(uint256){
106         return deposit[_addr];
107 	}
108 
109 
110     /// @dev Transfers the balance from msg.sender to an account
111     /// @param _to Recipient address
112     /// @param _amount Transfered amount in unit
113     /// @return Transfer status
114     function transfer(address _to, uint256 _amount)
115         public
116 
117         returns (bool) {
118         // if sender's balance has enough unit and amount >= 0,
119         //      and the sum is not overflow,
120         // then DOLO transfer
121         if ( (balances[msg.sender] >= _amount) &&
122              (_amount >= 0) &&
123              (balances[_to] + _amount > balances[_to]) ) {
124 
125             balances[msg.sender] -= _amount;
126             balances[_to] += _amount;
127             Transfer(msg.sender, _to, _amount);
128             return true;
129         } else {
130             return false;
131         }
132     }
133 
134     // Send _value amount of tokens from address _from to address _to
135     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
136     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
137     // fees in sub-currencies; the command should fail unless the _from account has
138     // deliberately authorized the sender of the message via some mechanism; we propose
139     // these standardized APIs for approval:
140     function transferFrom(
141         address _from,
142         address _to,
143         uint256 _amount
144     )
145     public
146 
147     returns (bool success) {
148         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
149             balances[_from] -= _amount;
150             allowed[_from][msg.sender] -= _amount;
151             balances[_to] += _amount;
152             Transfer(_from, _to, _amount);
153             return true;
154         } else {
155             return false;
156         }
157     }
158 
159     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
160     // If this function is called again it overwrites the current allowance with _value.
161     function approve(address _spender, uint256 _amount)
162         public
163 
164         returns (bool success) {
165         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
166         allowed[msg.sender][_spender] = _amount;
167         Approval(msg.sender, _spender, _amount);
168         return true;
169     }
170 
171     // get allowance
172     function allowance(address _owner, address _spender)
173         public
174         constant
175         returns (uint256 remaining) {
176         return allowed[_owner][_spender];
177     }
178 
179     function () public payable{
180         revert();
181     }
182 
183 }