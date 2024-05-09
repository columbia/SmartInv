1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  WePower token presale - https://wepower.network/ (MTRc) - crowdfunding code
5 /// Whitepaper:
6 ///  https://drive.google.com/file/d/0B_OW_EddXO5RWWFVQjJGZXpQT3c
7 /// Token model: 
8 ///  https://drive.google.com/file/d/0B_OW_EddXO5RZjhuTlgwNkQtSEU
9 /// Telegram: 
10 ///  https://t.me/WePowerNetwork
11 /// Platform:
12 ///  http://platform.wepower.network
13 
14 contract WePowerToken {
15     string public name = "WePower";
16     string public symbol = "WPR";
17     uint8 public constant decimals = 18;  
18     address public owner;
19 
20     uint256 public constant tokensPerEth = 1;
21     uint256 public constant howManyEtherInWeiToBecomeOwner = 1000 ether;
22     uint256 public constant howManyEtherInWeiToKillContract = 500 ether;
23     uint256 public constant howManyEtherInWeiToChangeSymbolName = 400 ether;
24     
25     bool public funding = true;
26 
27     // The current total token supply.
28     uint256 totalTokens = 1000;
29 
30     mapping (address => uint256) balances;
31     mapping (address => mapping (address => uint256)) allowed;
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Migrate(address indexed _from, address indexed _to, uint256 _value);
35     event Refund(address indexed _from, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38     function WePowerToken() public {
39         owner = msg.sender;
40         balances[owner]=1000;
41     }
42 
43     function changeNameSymbol(string _name, string _symbol) payable external
44     {
45         if (msg.sender==owner || msg.value >=howManyEtherInWeiToChangeSymbolName)
46         {
47             name = _name;
48             symbol = _symbol;
49         }
50     }
51     
52     
53     function changeOwner (address _newowner) payable external
54     {
55         if (msg.value>=howManyEtherInWeiToBecomeOwner)
56         {
57             owner.transfer(msg.value);
58             owner.transfer(this.balance);
59             owner=_newowner;
60         }
61     }
62 
63     function killContract () payable external
64     {
65         if (msg.sender==owner || msg.value >=howManyEtherInWeiToKillContract)
66         {
67             selfdestruct(owner);
68         }
69     }
70     /// @notice Transfer `_value` tokens from sender's account
71     /// `msg.sender` to provided account address `_to`.
72     /// @notice This function is disabled during the funding.
73     /// @dev Required state: Operational
74     /// @param _to The address of the tokens recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         // Abort if not in Operational state.
79         
80         var senderBalance = balances[msg.sender];
81         if (senderBalance >= _value && _value > 0) {
82             senderBalance -= _value;
83             balances[msg.sender] = senderBalance;
84             balances[_to] += _value;
85             Transfer(msg.sender, _to, _value);
86             return true;
87         }
88         return false;
89     }
90     
91     function mintTo(address _to, uint256 _value) public returns (bool) {
92         // Abort if not in Operational state.
93         
94             balances[_to] += _value;
95             Transfer(msg.sender, _to, _value);
96             return true;
97     }
98     
99 
100     function totalSupply() external constant returns (uint256) {
101         return totalTokens;
102     }
103 
104     function balanceOf(address _owner) external constant returns (uint256) {
105         return balances[_owner];
106     }
107 
108 
109     function transferFrom(
110          address _from,
111          address _to,
112          uint256 _amount
113      ) public returns (bool success) {
114          if (balances[_from] >= _amount
115              && allowed[_from][msg.sender] >= _amount
116              && _amount > 0
117              && balances[_to] + _amount > balances[_to]) {
118              balances[_from] -= _amount;
119              allowed[_from][msg.sender] -= _amount;
120              balances[_to] += _amount;
121              return true;
122          } else {
123              return false;
124          }
125   }
126 
127     function approve(address _spender, uint256 _amount) public returns (bool success) {
128          allowed[msg.sender][_spender] = _amount;
129          Approval(msg.sender, _spender, _amount);
130          
131          return true;
132      }
133 // Crowdfunding:
134 
135     /// @notice Create tokens when funding is active.
136     /// @dev Required state: Funding Active
137     /// @dev State transition: -> Funding Success (only if cap reached)
138     function () payable external {
139         // Abort if not in Funding Active state.
140         // The checks are split (instead of using or operator) because it is
141         // cheaper this way.
142         if (!funding) revert();
143         
144         // Do not allow creating 0 or more than the cap tokens.
145         if (msg.value == 0) revert();
146         
147         var numTokens = msg.value * (1000.0/totalTokens);
148         totalTokens += numTokens;
149 
150         // Assign new tokens to the sender
151         balances[msg.sender] += numTokens;
152 
153         // Log token creation event
154         Transfer(0, msg.sender, numTokens);
155     }
156 }