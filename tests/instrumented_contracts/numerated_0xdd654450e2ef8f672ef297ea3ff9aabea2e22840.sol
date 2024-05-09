1 pragma solidity ^0.4.21;
2 
3 contract ABXToken 
4 {
5   mapping(address => uint256) public balanceOf;
6   function transfer(address newTokensHolder, uint256 tokensNumber) 
7     public 
8     returns(bool);
9 }
10 
11 contract VestingContractABX
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
25   ABXToken public abx_token;
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
54   function VestingContractABX(ABXToken _abx_token)
55     public
56   {
57     owner = msg.sender;
58     abx_token = _abx_token;
59     
60     periods.push(1524355200);  //2018-04-22
61     periods.push(1526947200);  //2018-05-22
62     periods.push(2**256 - 1);  //very far future
63     current_period = 0;
64     
65     initData(0xB99f9Ff7349A74f74Ee78bA76F692381925B4372, 192998805 * 10**16);
66     initData(0x6f15F81d3726dEc1c7D8db7c7C139de5B8a5DCdA, 50000 * 10**18);
67     initData(0x0339Db6d5827cFf0271a5bd3EEe991bE1DCe2AD9, 50000 * 10**18);
68     initData(0x4477A5b0Bd59E4661008D07938293e61A95cbC9D, 25725 * 10**18);
69     initData(0x1c8dBee998C6B905B46e517Cf5A6E935673b7c8F, 33650 * 10**18);
70     initData(0xF3E33Ee85414Cb9b2D1EcFf9508BD24285fD3194, 46350 * 10**18);
71     initData(0x70d370528cd58A2531Db49e477964D760cf9fE56, 413950 * 10**18);
72     initData(0xd2A64d99025b1b0B0Eb8C65d7a89AD6444842E60, 500000 * 10**18);
73     initData(0xf8767ced61c1f86f5572e64289247b1c86083ef1, 33333333 * 10**16);
74   }
75   
76   /// @dev Fallback function: don't accept ETH
77   function()
78     public
79     payable
80   {
81     revert();
82   }
83 
84   /// @dev Get current balance of the contract
85   function getBalance()
86     constant
87     public
88     returns(uint)
89   {
90     return abx_token.balanceOf(this);
91   }
92 
93   function initData(address a, uint v) 
94     private
95   {
96     accounts.push(a);
97     account_data[a].original_balance = v;
98     account_data[a].current_balance = account_data[a].original_balance;
99     account_data[a].limit_per_period = account_data[a].original_balance / 3;
100     account_data[a].current_limit = account_data[a].limit_per_period;
101     account_data[a].current_transferred = 0;
102   }
103 
104   function setOwner(address _owner) 
105     public 
106     onlyOwner 
107   {
108     require(_owner != 0);
109     
110     owner = _owner;
111     emit OwnerChanged(owner);
112   }
113   
114   //allow owner to transfer surplus
115   function ownerTransfer(address to, uint value)
116     public
117     onlyOwner
118   {
119     uint current_balance_all = 0;
120     for (uint i = 0; i < accounts.length; i++)
121       current_balance_all += account_data[accounts[i]].current_balance;
122     require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all);
123     if (abx_token.transfer(to, value))
124       emit OwnerTransfer(to, value);
125   }
126   
127   function updateCurrentPeriod()
128     public
129   {
130     require(account_data[msg.sender].original_balance > 0 || msg.sender == owner);
131     
132     uint new_period = current_period;
133     for (uint i = current_period; i < periods.length; i++)
134       if (periods[i] > now)
135       {
136         new_period = i;
137         break;
138       }
139     if (new_period != current_period)
140     {
141       current_period = new_period;
142       for (i = 0; i < accounts.length; i++)
143       {
144         account_data[accounts[i]].current_transferred = 0;
145         account_data[accounts[i]].current_limit = account_data[accounts[i]].limit_per_period;
146         if (current_period == periods.length - 1)
147           account_data[accounts[i]].current_limit = 2**256 - 1;  //unlimited
148       }
149       emit CurrentPeriodChanged(current_period);
150     }
151   }
152 
153   function transfer(address to, uint value) 
154     public
155   {
156     updateCurrentPeriod();
157     require(value <= abx_token.balanceOf(this) 
158       && value <= account_data[msg.sender].current_balance 
159       && account_data[msg.sender].current_transferred + value <= account_data[msg.sender].current_limit);
160 
161     if (abx_token.transfer(to, value)) 
162     {
163       account_data[msg.sender].current_transferred += value;
164       account_data[msg.sender].current_balance -= value;
165       emit Transfer(to, value);
166     }
167   }
168 }