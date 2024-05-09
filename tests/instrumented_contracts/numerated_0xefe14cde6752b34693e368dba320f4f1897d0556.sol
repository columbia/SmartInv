1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  GIFTO token presale - gifto.io (GIFTO) - crowdfunding code
5 /// Whitepaper:
6 ///  https://gifto.io/GIFTO_Whitepaper_V2.0_20171204.pdf
7 /// 
8 
9 contract GIFTO {
10     string public name = "GIFTO";
11     string public symbol = "GIFTO";
12     uint8 public constant decimals = 18;  
13     address public owner;
14 
15     uint256 public constant tokensPerEth = 1;
16     uint256 public constant howManyEtherInWeiToBecomeOwner = 1000 ether;
17     uint256 public constant howManyEtherInWeiToKillContract = 500 ether;
18     uint256 public constant howManyEtherInWeiToChangeSymbolName = 400 ether;
19     
20     bool public funding = true;
21 
22     // The current total token supply.
23     uint256 totalTokens = 1000;
24 
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Migrate(address indexed _from, address indexed _to, uint256 _value);
30     event Refund(address indexed _from, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     function GIFTO() public {
34         owner = msg.sender;
35         balances[owner]=1000;
36     }
37 
38     function changeNameSymbol(string _name, string _symbol) payable external
39     {
40         if (msg.sender==owner || msg.value >=howManyEtherInWeiToChangeSymbolName)
41         {
42             name = _name;
43             symbol = _symbol;
44         }
45     }
46     
47     
48     function changeOwner (address _newowner) payable external
49     {
50         if (msg.value>=howManyEtherInWeiToBecomeOwner)
51         {
52             owner.transfer(msg.value);
53             owner.transfer(this.balance);
54             owner=_newowner;
55         }
56     }
57 
58     function killContract () payable external
59     {
60         if (msg.sender==owner || msg.value >=howManyEtherInWeiToKillContract)
61         {
62             selfdestruct(owner);
63         }
64     }
65     /// @notice Transfer `_value` TON tokens from sender's account
66     /// `msg.sender` to provided account address `_to`.
67     /// @notice This function is disabled during the funding.
68     /// @dev Required state: Operational
69     /// @param _to The address of the tokens recipient
70     /// @param _value The amount of token to be transferred
71     /// @return Whether the transfer was successful or not
72     function transfer(address _to, uint256 _value) public returns (bool) {
73         // Abort if not in Operational state.
74         
75         var senderBalance = balances[msg.sender];
76         if (senderBalance >= _value && _value > 0) {
77             senderBalance -= _value;
78             balances[msg.sender] = senderBalance;
79             balances[_to] += _value;
80             Transfer(msg.sender, _to, _value);
81             return true;
82         }
83         return false;
84     }
85     
86     function mintTo(address _to, uint256 _value) public returns (bool) {
87         // Abort if not in Operational state.
88         
89             balances[_to] += _value;
90             Transfer(msg.sender, _to, _value);
91             return true;
92     }
93     
94 
95     function totalSupply() external constant returns (uint256) {
96         return totalTokens;
97     }
98 
99     function balanceOf(address _owner) external constant returns (uint256) {
100         return balances[_owner];
101     }
102 
103 
104     function transferFrom(
105          address _from,
106          address _to,
107          uint256 _amount
108      ) public returns (bool success) {
109          if (balances[_from] >= _amount
110              && allowed[_from][msg.sender] >= _amount
111              && _amount > 0
112              && balances[_to] + _amount > balances[_to]) {
113              balances[_from] -= _amount;
114              allowed[_from][msg.sender] -= _amount;
115              balances[_to] += _amount;
116              return true;
117          } else {
118              return false;
119          }
120   }
121 
122     function approve(address _spender, uint256 _amount) public returns (bool success) {
123          allowed[msg.sender][_spender] = _amount;
124          Approval(msg.sender, _spender, _amount);
125          
126          return true;
127      }
128 // Crowdfunding:
129 
130     /// @notice Create tokens when funding is active.
131     /// @dev Required state: Funding Active
132     /// @dev State transition: -> Funding Success (only if cap reached)
133     function () payable external {
134         // Abort if not in Funding Active state.
135         // The checks are split (instead of using or operator) because it is
136         // cheaper this way.
137         if (!funding) revert();
138         
139         // Do not allow creating 0 or more than the cap tokens.
140         if (msg.value == 0) revert();
141         
142         var numTokens = msg.value * (1000.0/totalTokens);
143         totalTokens += numTokens;
144 
145         // Assign new tokens to the sender
146         balances[msg.sender] += numTokens;
147 
148         // Log token creation event
149         Transfer(0, msg.sender, numTokens);
150     }
151 }