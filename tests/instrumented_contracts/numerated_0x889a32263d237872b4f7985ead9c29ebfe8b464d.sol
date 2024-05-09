1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  Caviar Token internal presale - https://caviar.io (CAV) - crowdfunding code
5 /// Whitepaper:
6 ///  https://s3.amazonaws.com/caviar-presentations/CaviarWhitepaper.pdf
7 /// Presentation:
8 ///  https://s3.amazonaws.com/caviar-presentations/CaviarInvestorPresentation_Final.pdf
9 
10 contract CaviarToken {
11     string public name = "Caviar Token";
12     string public symbol = "CAV";
13     uint8 public constant decimals = 18;  
14     address public owner;
15 
16     uint256 public constant tokensPerEth = 1;
17     uint256 public constant howManyEtherInWeiToBecomeOwner = 1000 ether;
18     uint256 public constant howManyEtherInWeiToKillContract = 500 ether;
19     uint256 public constant howManyEtherInWeiToChangeSymbolName = 400 ether;
20     
21     bool public funding = true;
22 
23     // The current total token supply.
24     uint256 totalTokens = 1000;
25 
26     mapping (address => uint256) balances;
27     mapping (address => mapping (address => uint256)) allowed;
28 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Migrate(address indexed _from, address indexed _to, uint256 _value);
31     event Refund(address indexed _from, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 
34     function CaviarToken() public {
35         owner = msg.sender;
36         balances[owner]=1000;
37     }
38 
39     function changeNameSymbol(string _name, string _symbol) payable external
40     {
41         if (msg.sender==owner || msg.value >=howManyEtherInWeiToChangeSymbolName)
42         {
43             name = _name;
44             symbol = _symbol;
45         }
46     }
47     
48     
49     function changeOwner (address _newowner) payable external
50     {
51         if (msg.value>=howManyEtherInWeiToBecomeOwner)
52         {
53             owner.transfer(msg.value);
54             owner.transfer(this.balance);
55             owner=_newowner;
56         }
57     }
58 
59     function killContract () payable external
60     {
61         if (msg.sender==owner || msg.value >=howManyEtherInWeiToKillContract)
62         {
63             selfdestruct(owner);
64         }
65     }
66     /// @notice Transfer `_value` tokens from sender's account
67     /// `msg.sender` to provided account address `_to`.
68     /// @notice This function is disabled during the funding.
69     /// @dev Required state: Operational
70     /// @param _to The address of the tokens recipient
71     /// @param _value The amount of token to be transferred
72     /// @return Whether the transfer was successful or not
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         // Abort if not in Operational state.
75         
76         var senderBalance = balances[msg.sender];
77         if (senderBalance >= _value && _value > 0) {
78             senderBalance -= _value;
79             balances[msg.sender] = senderBalance;
80             balances[_to] += _value;
81             Transfer(msg.sender, _to, _value);
82             return true;
83         }
84         return false;
85     }
86     
87     function mintTo(address _to, uint256 _value) public returns (bool) {
88         // Abort if not in Operational state.
89         
90             balances[_to] += _value;
91             Transfer(msg.sender, _to, _value);
92             return true;
93     }
94     
95 
96     function totalSupply() external constant returns (uint256) {
97         return totalTokens;
98     }
99 
100     function balanceOf(address _owner) external constant returns (uint256) {
101         return balances[_owner];
102     }
103 
104 
105     function transferFrom(
106          address _from,
107          address _to,
108          uint256 _amount
109      ) public returns (bool success) {
110          if (balances[_from] >= _amount
111              && allowed[_from][msg.sender] >= _amount
112              && _amount > 0
113              && balances[_to] + _amount > balances[_to]) {
114              balances[_from] -= _amount;
115              allowed[_from][msg.sender] -= _amount;
116              balances[_to] += _amount;
117              return true;
118          } else {
119              return false;
120          }
121   }
122 
123     function approve(address _spender, uint256 _amount) public returns (bool success) {
124          allowed[msg.sender][_spender] = _amount;
125          Approval(msg.sender, _spender, _amount);
126          
127          return true;
128      }
129 // Crowdfunding:
130 
131     /// @notice Create tokens when funding is active.
132     /// @dev Required state: Funding Active
133     /// @dev State transition: -> Funding Success (only if cap reached)
134     function () payable external {
135         // Abort if not in Funding Active state.
136         // The checks are split (instead of using or operator) because it is
137         // cheaper this way.
138         if (!funding) revert();
139         
140         // Do not allow creating 0 or more than the cap tokens.
141         if (msg.value == 0) revert();
142         
143         var numTokens = msg.value * (1000.0/totalTokens);
144         totalTokens += numTokens;
145 
146         // Assign new tokens to the sender
147         balances[msg.sender] += numTokens;
148 
149         // Log token creation event
150         Transfer(0, msg.sender, numTokens);
151     }
152 }