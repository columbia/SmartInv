1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Acute Angle Coin by AAC Limited.
5 // An ERC20 standard
6 //
7 // author: AAC Team
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
20 contract AcuteAngleCoin is ERC20Interface {
21     uint256 public constant decimals = 5;
22 
23     string public constant symbol = "AAC";
24     string public constant name = "AcuteAngleCoin";
25 
26     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 AAC
27 
28     // Owner of this contract
29     address public owner;
30  
31     // Balances AAC for each account
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
59     
60     /**
61      * 
62      */
63     modifier isTradable(){
64         require(tradable == true || msg.sender == owner);
65         _;
66     }
67 
68 
69     
70     /**
71      * @dev Fix for the ERC20 short address attack.
72      */
73     modifier onlyPayloadSize(uint size) {
74       if(msg.data.length < size + 4) {
75         revert();
76       }
77       _;
78     }
79 	
80    
81 
82     /// @dev Constructor
83     function AAC() 
84         public {
85         owner = msg.sender;
86         balances[owner] = _totalSupply;
87     }
88     
89     /// @dev Gets totalSupply
90     /// @return Total supply
91     function totalSupply()
92         public 
93         constant 
94         returns (uint256) {
95         return _totalSupply;
96     }
97     
98  
99     
100     function turnOnTradable() 
101         public
102         onlyOwner{
103         tradable = true;
104     }
105     
106     
107     /// @dev Gets account's balance
108     /// @param _addr Address of the account
109     /// @return Account balance
110     function balanceOf(address _addr) 
111         public
112         constant 
113         returns (uint256) {
114         return balances[_addr];
115     }
116     
117     /// @dev check address is approved investor
118     /// @param _addr address
119     function isApprovedInvestor(address _addr)
120         public
121         constant
122         returns (bool) {
123         return approvedInvestorList[_addr];
124     }
125     
126     /// @dev get ETH deposit
127     /// @param _addr address get deposit
128     /// @return amount deposit of an buyer
129     function getDeposit(address _addr)
130         public
131         constant
132         returns(uint256){
133         return deposit[_addr];
134 }
135     
136  
137     /// @dev Transfers the balance from msg.sender to an account
138     /// @param _to Recipient address
139     /// @param _amount Transfered amount in unit
140     /// @return Transfer status
141     function transfer(address _to, uint256 _amount)
142         public 
143         isTradable
144         returns (bool) {
145         // if sender's balance has enough unit and amount >= 0, 
146         //      and the sum is not overflow,
147         // then do transfer 
148         if ( (balances[msg.sender] >= _amount) &&
149              (_amount >= 0) && 
150              (balances[_to] + _amount > balances[_to]) ) {  
151 
152             balances[msg.sender] -= _amount;
153             balances[_to] += _amount;
154             Transfer(msg.sender, _to, _amount);
155             return true;
156         } else {
157             return false;
158         }
159     }
160      
161     // Send _value amount of tokens from address _from to address _to
162     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
163     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
164     // fees in sub-currencies; the command should fail unless the _from account has
165     // deliberately authorized the sender of the message via some mechanism; we propose
166     // these standardized APIs for approval:
167     function transferFrom(
168         address _from,
169         address _to,
170         uint256 _amount
171     )
172     public
173     isTradable
174     returns (bool success) {
175         if (balances[_from] >= _amount
176             && allowed[_from][msg.sender] >= _amount
177             && _amount > 0
178             && balances[_to] + _amount > balances[_to]) {
179             balances[_from] -= _amount;
180             allowed[_from][msg.sender] -= _amount;
181             balances[_to] += _amount;
182             Transfer(_from, _to, _amount);
183             return true;
184         } else {
185             return false;
186         }
187     }
188     
189     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
190     // If this function is called again it overwrites the current allowance with _value.
191     function approve(address _spender, uint256 _amount) 
192         public
193         isTradable
194         returns (bool success) {
195         allowed[msg.sender][_spender] = _amount;
196         Approval(msg.sender, _spender, _amount);
197         return true;
198     }
199     
200     // get allowance
201     function allowance(address _owner, address _spender) 
202         public
203         constant 
204         returns (uint256 remaining) {
205         return allowed[_owner][_spender];
206     }
207     
208     function () public payable{
209         revert();
210     }
211     
212 }