1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Nginx by NGX Limited.
5 // An ERC20 standard
6 //
7 // author: Nginx Team
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
20 contract NGX is ERC20Interface {
21     uint256 public constant decimals = 5;
22 
23     string public constant symbol = "NGX";
24     string public constant name = "Nginx";
25 
26     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 NGX
27 
28     // Owner of this contract
29     address public owner;
30 
31     // Balances NGX for each account
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
59     /// @dev Constructor
60     function NGX()
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
76     /// @dev Gets account's balance
77     /// @param _addr Address of the account
78     /// @return Account balance
79     function balanceOf(address _addr)
80         public
81         constant
82         returns (uint256) {
83         return balances[_addr];
84     }
85 
86     /// @dev check address is approved investor
87     /// @param _addr address
88     function isApprovedInvestor(address _addr)
89         public
90         constant
91         returns (bool) {
92         return approvedInvestorList[_addr];
93     }
94 
95     /// @dev get ETH deposit
96     /// @param _addr address get deposit
97     /// @return amount deposit of an buyer
98     function getDeposit(address _addr)
99         public
100         constant
101         returns(uint256){
102         return deposit[_addr];
103 	}
104 
105 
106     /// @dev Transfers the balance from msg.sender to an account
107     /// @param _to Recipient address
108     /// @param _amount Transfered amount in unit
109     /// @return Transfer status
110     function transfer(address _to, uint256 _amount)
111         public
112 
113         returns (bool) {
114         // if sender's balance has enough unit and amount >= 0,
115         //      and the sum is not overflow,
116         // then do transfer
117         if ( (balances[msg.sender] >= _amount) &&
118              (_amount >= 0) &&
119              (balances[_to] + _amount > balances[_to]) ) {
120 
121             balances[msg.sender] -= _amount;
122             balances[_to] += _amount;
123             Transfer(msg.sender, _to, _amount);
124             return true;
125         } else {
126             return false;
127         }
128     }
129 
130     // Send _value amount of tokens from address _from to address _to
131     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
132     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
133     // fees in sub-currencies; the command should fail unless the _from account has
134     // deliberately authorized the sender of the message via some mechanism; we propose
135     // these standardized APIs for approval:
136     function transferFrom(
137         address _from,
138         address _to,
139         uint256 _amount
140     )
141     public
142 
143     returns (bool success) {
144         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
145             balances[_from] -= _amount;
146             allowed[_from][msg.sender] -= _amount;
147             balances[_to] += _amount;
148             Transfer(_from, _to, _amount);
149             return true;
150         } else {
151             return false;
152         }
153     }
154 
155     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
156     // If this function is called again it overwrites the current allowance with _value.
157     function approve(address _spender, uint256 _amount)
158         public
159 
160         returns (bool success) {
161         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
162         allowed[msg.sender][_spender] = _amount;
163         Approval(msg.sender, _spender, _amount);
164         return true;
165     }
166 
167     // get allowance
168     function allowance(address _owner, address _spender)
169         public
170         constant
171         returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175     function () public payable{
176         revert();
177     }
178 
179 }