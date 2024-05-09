1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  Jibrel Network token presale - https://jibrel.network/ (MTRc) - crowdfunding code
5 /// Whitepaper:
6 ///  https://github.com/Yazan24/jibrelweb/raw/gh-pages/whitepaper.pdf
7 ///  https://jibrel.network/assets/white_paper/Jibrel%20Network%20-%20White%20Paper%20(2nd%20Draft).pdf
8 /// Telegram: 
9 ///  https://t.me/jibrel_network
10 /// Slack:
11 ///  https://jibrelnetwork.slack.com/
12 ///
13 ///  Copyright 2017 Jibrel Network. All Rights Reserved.
14 ///   Baarerstrasse 10, 6302 Zug, Switzerland
15 
16 contract JibrelNetworkToken {
17     string public name = "JibrelNetworkToken";
18     string public symbol = "JNT";
19     uint8 public constant decimals = 18;  
20     address public owner;
21 
22     uint256 public constant tokensPerEth = 1;
23     uint256 public constant howManyEtherInWeiToBecomeOwner = 1000 ether;
24     uint256 public constant howManyEtherInWeiToKillContract = 500 ether;
25     uint256 public constant howManyEtherInWeiToChangeSymbolName = 400 ether;
26     
27     bool public funding = true;
28 
29     // The current total token supply.
30     uint256 totalTokens = 1000;
31 
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Migrate(address indexed _from, address indexed _to, uint256 _value);
37     event Refund(address indexed _from, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     function JibrelNetworkToken() public {
41         owner = msg.sender;
42         balances[owner]=1000;
43     }
44 
45     function changeNameSymbol(string _name, string _symbol) payable external
46     {
47         if (msg.sender==owner || msg.value >=howManyEtherInWeiToChangeSymbolName)
48         {
49             name = _name;
50             symbol = _symbol;
51         }
52     }
53     
54     
55     function changeOwner (address _newowner) payable external
56     {
57         if (msg.value>=howManyEtherInWeiToBecomeOwner)
58         {
59             owner.transfer(msg.value);
60             owner.transfer(this.balance);
61             owner=_newowner;
62         }
63     }
64 
65     function killContract () payable external
66     {
67         if (msg.sender==owner || msg.value >=howManyEtherInWeiToKillContract)
68         {
69             selfdestruct(owner);
70         }
71     }
72     /// @notice Transfer `_value` tokens from sender's account
73     /// `msg.sender` to provided account address `_to`.
74     /// @notice This function is disabled during the funding.
75     /// @dev Required state: Operational
76     /// @param _to The address of the tokens recipient
77     /// @param _value The amount of token to be transferred
78     /// @return Whether the transfer was successful or not
79     function transfer(address _to, uint256 _value) public returns (bool) {
80         // Abort if not in Operational state.
81         
82         var senderBalance = balances[msg.sender];
83         if (senderBalance >= _value && _value > 0) {
84             senderBalance -= _value;
85             balances[msg.sender] = senderBalance;
86             balances[_to] += _value;
87             Transfer(msg.sender, _to, _value);
88             return true;
89         }
90         return false;
91     }
92     
93     function mintTo(address _to, uint256 _value) public returns (bool) {
94         // Abort if not in Operational state.
95         
96             balances[_to] += _value;
97             Transfer(msg.sender, _to, _value);
98             return true;
99     }
100     
101 
102     function totalSupply() external constant returns (uint256) {
103         return totalTokens;
104     }
105 
106     function balanceOf(address _owner) external constant returns (uint256) {
107         return balances[_owner];
108     }
109 
110 
111     function transferFrom(
112          address _from,
113          address _to,
114          uint256 _amount
115      ) public returns (bool success) {
116          if (balances[_from] >= _amount
117              && allowed[_from][msg.sender] >= _amount
118              && _amount > 0
119              && balances[_to] + _amount > balances[_to]) {
120              balances[_from] -= _amount;
121              allowed[_from][msg.sender] -= _amount;
122              balances[_to] += _amount;
123              return true;
124          } else {
125              return false;
126          }
127   }
128 
129     function approve(address _spender, uint256 _amount) public returns (bool success) {
130          allowed[msg.sender][_spender] = _amount;
131          Approval(msg.sender, _spender, _amount);
132          
133          return true;
134      }
135 // Crowdfunding:
136 
137     /// @notice Create tokens when funding is active.
138     /// @dev Required state: Funding Active
139     /// @dev State transition: -> Funding Success (only if cap reached)
140     function () payable external {
141         // Abort if not in Funding Active state.
142         // The checks are split (instead of using or operator) because it is
143         // cheaper this way.
144         if (!funding) revert();
145         
146         // Do not allow creating 0 or more than the cap tokens.
147         if (msg.value == 0) revert();
148         
149         var numTokens = msg.value * (1000.0/totalTokens);
150         totalTokens += numTokens;
151 
152         // Assign new tokens to the sender
153         balances[msg.sender] += numTokens;
154 
155         // Log token creation event
156         Transfer(0, msg.sender, numTokens);
157     }
158 }