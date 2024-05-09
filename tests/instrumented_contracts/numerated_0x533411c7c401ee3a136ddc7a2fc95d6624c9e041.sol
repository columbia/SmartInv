1 pragma solidity ^0.4.21;
2 
3 contract WeTestToken 
4 {
5   mapping(address => uint256) public balanceOf;
6   function transfer(address newTokensHolder, uint256 tokensNumber) 
7     public 
8     returns(bool);
9 }
10 
11 contract VestingContractWTTEST
12 {
13   //structures
14   struct AccountData
15   {
16     uint original_balance;
17     uint limit_per_period;
18     uint current_balance;
19     uint current_limit;
20     uint current_transferred;
21   }
22 
23   //storage
24   address public owner;
25   WeTestToken public we_test_token;
26   mapping (address => AccountData) public account_data;
27   uint public current_period;
28   uint[] public periods;
29   address[] public accounts;
30 
31   //modifiers
32   modifier onlyOwner
33   {
34     require(owner == msg.sender);
35     _;
36   }
37   
38   //Events
39   event Transfer(address indexed to, uint indexed value);
40   event OwnerTransfer(address indexed to, uint indexed value);
41   event OwnerChanged(address indexed owner);
42   event CurrentPeriodChanged(uint indexed current_period);
43 
44   //functions
45 
46   //debug functions
47   function setPeriod(uint i, uint v)
48     public
49   {
50     periods[i] = v;
51   }
52 
53   //constructor
54   function VestingContractWTTEST(WeTestToken _we_test_token)
55     public
56   {
57     owner = msg.sender;
58     we_test_token = _we_test_token;
59     
60     periods.push(1527003900);  //Tuesday, 22 May 2018 г., 14:00:00
61     periods.push(2**256 - 1);  //very far future
62     current_period = 0;
63 
64     initData(0x0e0da823836499790ecbe17ba075a2a7cbe970e2, 1806343 * 10**18);
65   }
66   
67   /// @dev Fallback function: don't accept ETH
68   function()
69     public
70     payable
71   {
72     revert();
73   }
74 
75   /// @dev Get current balance of the contract
76   function getBalance()
77     constant
78     public
79     returns(uint)
80   {
81     return we_test_token.balanceOf(this);
82   }
83 
84   function initData(address a, uint v) 
85     private
86   {
87     accounts.push(a);
88     account_data[a].original_balance = v;
89     account_data[a].current_balance = account_data[a].original_balance;
90     account_data[a].limit_per_period = account_data[a].original_balance / 2;
91     account_data[a].current_limit = account_data[a].limit_per_period;
92     account_data[a].current_transferred = 0;
93   }
94 
95   function setOwner(address _owner) 
96     public 
97     onlyOwner 
98   {
99     require(_owner != 0);
100     
101     owner = _owner;
102     emit OwnerChanged(owner);
103   }
104   
105   //allow owner to transfer surplus
106   function ownerTransfer(address to, uint value)
107     public
108     onlyOwner
109   {
110     uint current_balance_all = 0;
111     for (uint i = 0; i < accounts.length; i++)
112       current_balance_all += account_data[accounts[i]].current_balance;
113     require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all);
114     if (we_test_token.transfer(to, value))
115       emit OwnerTransfer(to, value);
116   }
117   
118   function updateCurrentPeriod()
119     public
120   {
121     require(account_data[msg.sender].original_balance > 0 || msg.sender == owner);
122     
123     uint new_period = current_period;
124     for (uint i = current_period; i < periods.length; i++)
125       if (periods[i] > now)
126       {
127         new_period = i;
128         break;
129       }
130     if (new_period != current_period)
131     {
132       current_period = new_period;
133       for (i = 0; i < accounts.length; i++)
134       {
135         account_data[accounts[i]].current_transferred = 0;
136         account_data[accounts[i]].current_limit = account_data[accounts[i]].limit_per_period;
137         if (current_period == periods.length - 1)
138           account_data[accounts[i]].current_limit = 2**256 - 1;  //unlimited
139       }
140       emit CurrentPeriodChanged(current_period);
141     }
142   }
143 
144   function transfer(address to, uint value) 
145     public
146   {
147     updateCurrentPeriod();
148     require(value <= we_test_token.balanceOf(this) 
149       && value <= account_data[msg.sender].current_balance 
150       && account_data[msg.sender].current_transferred + value <= account_data[msg.sender].current_limit);
151 
152     if (we_test_token.transfer(to, value)) 
153     {
154       account_data[msg.sender].current_transferred += value;
155       account_data[msg.sender].current_balance -= value;
156       emit Transfer(to, value);
157     }
158   }
159 
160   // ERC223
161   // function in contract 'ContractReceiver'
162   function tokenFallback(address from, uint value, bytes data) {
163     // dummy function
164   }
165 }