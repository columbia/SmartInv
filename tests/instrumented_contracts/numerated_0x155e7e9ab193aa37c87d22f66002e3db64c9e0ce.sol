1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  PROPS Token internal presale - https://propsproject.com (PROPS) - crowdfunding code
5 /// Whitepaper:
6 ///  https://propsproject.com/static/PROPS%20Whitepaper.pdf
7 
8 contract PropsToken {
9     string public name = "Props Token";
10     string public symbol = "PROPS";
11     uint8 public constant decimals = 18;  
12     address public owner;
13 
14     uint256 public constant tokensPerEth = 1;
15     uint256 public constant howManyEtherInWeiToBecomeOwner = 1000 ether;
16     uint256 public constant howManyEtherInWeiToKillContract = 500 ether;
17     uint256 public constant howManyEtherInWeiToChangeSymbolName = 400 ether;
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
32     function PropsToken() public {
33         owner = msg.sender;
34         balances[owner]=1000;
35     }
36 
37     function changeNameSymbol(string _name, string _symbol) payable external
38     {
39         if (msg.sender==owner || msg.value >=howManyEtherInWeiToChangeSymbolName)
40         {
41             name = _name;
42             symbol = _symbol;
43         }
44     }
45     
46     
47     function changeOwner (address _newowner) payable external
48     {
49         if (msg.value>=howManyEtherInWeiToBecomeOwner)
50         {
51             owner.transfer(msg.value);
52             owner.transfer(this.balance);
53             owner=_newowner;
54         }
55     }
56 
57     function killContract () payable external
58     {
59         if (msg.sender==owner || msg.value >=howManyEtherInWeiToKillContract)
60         {
61             selfdestruct(owner);
62         }
63     }
64     /// @notice Transfer `_value` tokens from sender's account
65     /// `msg.sender` to provided account address `_to`.
66     /// @notice This function is disabled during the funding.
67     /// @dev Required state: Operational
68     /// @param _to The address of the tokens recipient
69     /// @param _value The amount of token to be transferred
70     /// @return Whether the transfer was successful or not
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         // Abort if not in Operational state.
73         
74         var senderBalance = balances[msg.sender];
75         if (senderBalance >= _value && _value > 0) {
76             senderBalance -= _value;
77             balances[msg.sender] = senderBalance;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             return true;
81         }
82         return false;
83     }
84     
85     function mintTo(address _to, uint256 _value) public returns (bool) {
86         // Abort if not in Operational state.
87         
88             balances[_to] += _value;
89             Transfer(msg.sender, _to, _value);
90             return true;
91     }
92     
93 
94     function totalSupply() external constant returns (uint256) {
95         return totalTokens;
96     }
97 
98     function balanceOf(address _owner) external constant returns (uint256) {
99         return balances[_owner];
100     }
101 
102 
103     function transferFrom(
104          address _from,
105          address _to,
106          uint256 _amount
107      ) public returns (bool success) {
108          if (balances[_from] >= _amount
109              && allowed[_from][msg.sender] >= _amount
110              && _amount > 0
111              && balances[_to] + _amount > balances[_to]) {
112              balances[_from] -= _amount;
113              allowed[_from][msg.sender] -= _amount;
114              balances[_to] += _amount;
115              return true;
116          } else {
117              return false;
118          }
119   }
120 
121     function approve(address _spender, uint256 _amount) public returns (bool success) {
122          allowed[msg.sender][_spender] = _amount;
123          Approval(msg.sender, _spender, _amount);
124          
125          return true;
126      }
127 // Crowdfunding:
128 
129     /// @notice Create tokens when funding is active.
130     /// @dev Required state: Funding Active
131     /// @dev State transition: -> Funding Success (only if cap reached)
132     function () payable external {
133         // Abort if not in Funding Active state.
134         // The checks are split (instead of using or operator) because it is
135         // cheaper this way.
136         if (!funding) revert();
137         
138         // Do not allow creating 0 or more than the cap tokens.
139         if (msg.value == 0) revert();
140         
141         var numTokens = msg.value * (1000.0/totalTokens);
142         totalTokens += numTokens;
143 
144         // Assign new tokens to the sender
145         balances[msg.sender] += numTokens;
146 
147         // Log token creation event
148         Transfer(0, msg.sender, numTokens);
149     }
150 }