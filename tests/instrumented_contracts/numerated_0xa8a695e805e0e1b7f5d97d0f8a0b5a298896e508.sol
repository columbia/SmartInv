1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-10
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 contract ERC20Interface { 
8     function totalSupply() public constant returns (uint256 _totalSupply);
9     function balanceOf(address _owner) public constant returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract BTGS is ERC20Interface {
19     uint256 public constant decimals = 18;
20 
21     string public constant symbol = "BTGS";
22     string public constant name = "BitDogToken";
23 
24     uint256 public _totalSupply = 500000000000000000000000000; 
25 
26     // Owner of this contract
27     address public owner;
28 
29     // Balances LIBC for each account
30     mapping(address => uint256) private balances;
31 
32     // Owner of account approves the transfer of an amount to another account
33     mapping(address => mapping (address => uint256)) private allowed;
34 
35     // List of approved investors
36     mapping(address => bool) private approvedInvestorList;
37 
38     // deposit
39     mapping(address => uint256) private deposit;
40 
41 
42     // totalTokenSold
43     uint256 public totalTokenSold = 0;
44 
45 
46     /**
47      * @dev Fix for the ERC20 short address attack.
48      */
49     modifier onlyPayloadSize(uint size) {
50       if(msg.data.length < size + 4) {
51         revert();
52       }
53       _;
54     }
55 
56 
57 
58     /// @dev Constructor
59     function BTGS()
60         public {
61         owner = msg.sender;
62         balances[owner] = _totalSupply;
63     }
64 
65     /// @dev Gets totalSupply
66     /// @return Total supply
67     function totalSupply()
68         public
69         constant
70         returns (uint256) {
71         return _totalSupply;
72     }
73 
74 
75 
76 
77 
78     /// @dev Gets account's balance
79     /// @param _addr Address of the account
80     /// @return Account balance
81     function balanceOf(address _addr)
82         public
83         constant
84         returns (uint256) {
85         return balances[_addr];
86     }
87 
88     /// @dev check address is approved investor
89     /// @param _addr address
90     function isApprovedInvestor(address _addr)
91         public
92         constant
93         returns (bool) {
94         return approvedInvestorList[_addr];
95     }
96 
97     /// @dev get ETH deposit
98     /// @param _addr address get deposit
99     /// @return amount deposit of an buyer
100     function getDeposit(address _addr)
101         public
102         constant
103         returns(uint256){
104         return deposit[_addr];
105 }
106 
107 
108     /// @dev Transfers the balance from msg.sender to an account
109     /// @param _to Recipient address
110     /// @param _amount Transfered amount in unit
111     /// @return Transfer status
112     function transfer(address _to, uint256 _amount)
113         public
114 
115         returns (bool) {
116         // if sender's balance has enough unit and amount >= 0,
117         //      and the sum is not overflow,
118         // then do transfer
119         
120         require(_to != address(0));
121         require(_amount <= balances[msg.sender]);
122         require(_amount >= 0);
123         if ( (balances[msg.sender] >= _amount) &&
124              (_amount >= 0) &&
125              (balances[_to] + _amount > balances[_to]) ) {
126 
127             balances[msg.sender] -= _amount;
128             balances[_to] += _amount;
129             Transfer(msg.sender, _to, _amount);
130             return true;
131         } else {
132             return false;
133         }
134     }
135 
136     // Send _value amount of tokens from address _from to address _to
137     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
138     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
139     // fees in sub-currencies; the command should fail unless the _from account has
140     // deliberately authorized the sender of the message via some mechanism; we propose
141     // these standardized APIs for approval:
142     function transferFrom(
143         address _from,
144         address _to,
145         uint256 _amount
146     )
147     public
148 
149     returns (bool success) {
150         require(_to != address(0));
151         require(_amount <= balances[msg.sender]);
152         require(_amount >= 0);
153         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
154             balances[_from] -= _amount;
155             allowed[_from][msg.sender] -= _amount;
156             balances[_to] += _amount;
157             Transfer(_from, _to, _amount);
158             return true;
159         } else {
160             return false;
161         }
162     }
163 
164     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
165     // If this function is called again it overwrites the current allowance with _value.
166     function approve(address _spender, uint256 _amount)
167         public
168 
169         returns (bool success) {
170         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
171         allowed[msg.sender][_spender] = _amount;
172         Approval(msg.sender, _spender, _amount);
173         return true;
174     }
175 
176     // get allowance
177     function allowance(address _owner, address _spender)
178         public
179         constant
180         returns (uint256 remaining) {
181         return allowed[_owner][_spender];
182     }
183 
184     function () public payable{
185         revert();
186     }
187 
188 }