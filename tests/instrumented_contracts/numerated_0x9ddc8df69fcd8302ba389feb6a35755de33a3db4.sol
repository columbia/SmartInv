1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // YACHT by YACHT Limited.
5 // An ERC20 standard
6 //
7 // author: YACHT Team
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
20 contract YACHT is ERC20Interface {
21     uint256 public constant decimals = 5;
22 
23     string public constant symbol = "YACHT";
24     string public constant name = "YACHT";
25 
26     uint256 public _totalSupply = 10 ** 13; // total supply is 10^13 unit, equivalent to 10^9 YACHT
27 
28     // Owner of this contract
29     address public owner;
30 
31     // Balances YACHT for each account
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
47 
48     /**
49      * @dev Fix for the ERC20 short address attack.
50      */
51     modifier onlyPayloadSize(uint size) {
52       if(msg.data.length < size + 4) {
53         revert();
54       }
55       _;
56     }
57 
58 
59 
60     /// @dev Constructor
61     function YACHT()
62         public {
63         owner = msg.sender;
64         balances[owner] = _totalSupply;
65     }
66 
67     /// @dev Gets totalSupply
68     /// @return Total supply
69     function totalSupply()
70         public
71         constant
72         returns (uint256) {
73         return _totalSupply;
74     }
75 
76 
77 
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
107 }
108 
109 
110     /// @dev Transfers the balance from msg.sender to an account
111     /// @param _to Recipient address
112     /// @param _amount Transfered amount in unit
113     /// @return Transfer status
114     function transfer(address _to, uint256 _amount)
115     
116         public
117 
118         returns (bool) {
119         // if sender's balance has enough unit and amount >= 0,
120         //      and the sum is not overflow,
121         // then do transfer
122         require(_to != address(0));
123         require(_amount <= balances[msg.sender]);
124         if ( (balances[msg.sender] >= _amount) &&
125              (_amount >= 0) &&
126              (balances[_to] + _amount > balances[_to]) ) {
127 
128             balances[msg.sender] -= _amount;
129             balances[_to] += _amount;
130             Transfer(msg.sender, _to, _amount);
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     // Send _value amount of tokens from address _from to address _to
138     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
139     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
140     // fees in sub-currencies; the command should fail unless the _from account has
141     // deliberately authorized the sender of the message via some mechanism; we propose
142     // these standardized APIs for approval:
143     function transferFrom(
144         address _from,
145         address _to,
146         uint256 _amount
147     )
148     public
149 
150     returns (bool success) {
151         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
152             balances[_from] -= _amount;
153             allowed[_from][msg.sender] -= _amount;
154             balances[_to] += _amount;
155             Transfer(_from, _to, _amount);
156             return true;
157         } else {
158             return false;
159         }
160     }
161 
162     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
163     // If this function is called again it overwrites the current allowance with _value.
164     function approve(address _spender, uint256 _amount)
165         public
166 
167         returns (bool success) {
168         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
169         allowed[msg.sender][_spender] = _amount;
170         Approval(msg.sender, _spender, _amount);
171         return true;
172     }
173 
174     // get allowance
175     function allowance(address _owner, address _spender)
176         public
177         constant
178         returns (uint256 remaining) {
179         return allowed[_owner][_spender];
180     }
181 
182     function () public payable{
183         revert();
184     }
185 
186 }