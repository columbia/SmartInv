1 // SPDX-License-Identifier: Ulicense
2 pragma solidity 0.8.2;
3 
4 // Presale and good ERC20 contracts interaction interface
5 interface IContracts {
6     function transfer(address, uint256) external returns (bool);
7 }
8 
9 // Broken ERC20 transfer for rescue ERC20 tokens
10 interface IErc20 {
11     function balanceOf(address) external returns (uint256);
12 
13     // some tokens (like USDT) not return bool as standard require
14     function transfer(address, uint256) external;
15 }
16 
17 /// @title Uniqly vesting contract
18 /// Users from external list (not presale contracts)
19 /// @author rav3n_pl
20 contract UniqVestingSE {
21     // user is eligible to receive bonus NFT tokens (default=0)
22     mapping(address => uint256) internal _bonus;
23 
24     /// it will be used by future contract
25     function bonus(address user) external view returns (uint256) {
26         return _bonus[user];
27     }
28 
29     // always true, for ABI/backend compatibility
30     function initialized(address) external pure returns (bool) {
31         return true;
32     }
33 
34     // total amount of token bought by presale contracts (default=0)
35     mapping(address => uint256) internal _tokensTotal;
36 
37     function tokensTotal(address user) external view returns (uint256) {
38         return _tokensTotal[user];
39     }
40 
41     // percentage already withdrawn by user (default=0)
42     mapping(address => uint256) internal _pctWithdrawn;
43 
44     function pctWithdrawn(address user) external view returns (uint256) {
45         return _pctWithdrawn[user];
46     }
47 
48     /// ERC20 token contract address
49     address public immutable token;
50 
51     /// timestamp that users can start withdrawals
52     uint256 public immutable dateStart;
53     /// address of contract owner
54     address public owner;
55 
56     // Manually disable adding investors to match main contract date
57     bool addDisabled;
58 
59     function closeAdd() external onlyOwner {
60         addDisabled = true;
61     }
62 
63     /**
64     @dev contract constructor
65     @param _token address of ERC20 token contract
66     @param _dateStart uint256 timestamp from when users can start withdrawing tokens 
67     */
68     constructor(address _token, uint256 _dateStart) {
69         token = _token;
70         dateStart = _dateStart;
71         owner = msg.sender;
72     }
73 
74     // for ABI/backend compatibility
75     function calc() external view returns (uint256) {
76         return _tokensTotal[msg.sender];
77     }
78 
79     /**
80     @dev Number of tokens eligible to withdraw
81     @return number of tokens available for user
82      */
83     function balanceOf(address user) external view returns (uint256) {
84         return (_tokensTotal[user] * (100 - _pctWithdrawn[user])) / 100;
85     }
86 
87     /**
88     @dev user call this function to withdraw tokens
89     @return bool true if any token transfer made
90     */
91     function claim() external returns (bool) {
92         // can't work before timestamp
93         require(block.timestamp > dateStart, "Initial vesting in progress");
94 
95         // initial percent is 20
96         uint256 pct = 20;
97         uint256 time = dateStart + 1 weeks;
98         // every week to date
99         while (time < block.timestamp) {
100             pct += 4;
101             // can't be more than 100
102             if (pct == 100) {
103                 break;
104             }
105             time += 1 weeks;
106         }
107         // do we have any % of tokens to withdraw?
108         if (pct > _pctWithdrawn[msg.sender]) {
109             uint256 thisTime = pct - _pctWithdrawn[msg.sender];
110             // is user a patient one?
111             // you've got a prize/s in near future!
112             if (pct > 59) {
113                 // 60% for 1st bonus, even when initial 20% claimed
114                 // but no bonus at all if claimed more than 20%
115                 if (_pctWithdrawn[msg.sender] < 21) {
116                     _bonus[msg.sender] = 1;
117                     // second bonus after 100% and max 20% withdrawn
118                     if (pct == 100 && thisTime > 79) {
119                         _bonus[msg.sender] = 2;
120                     }
121                 }
122             }
123             // how many tokens it would be...
124             uint256 amt = (_tokensTotal[msg.sender] * thisTime) / 100;
125             // yes, no reentrance please
126             _pctWithdrawn[msg.sender] += thisTime;
127             // transfer tokens counted
128             return IContracts(token).transfer(msg.sender, amt);
129         }
130         // did nothing
131         return false;
132     }
133 
134     modifier onlyOwner {
135         require(msg.sender == owner, "Only for Owner");
136         _;
137     }
138 
139     // change ownership in two steps to be sure about owner address
140     address public newOwner;
141 
142     // only current owner can delegate new one
143     function giveOwnership(address _newOwner) external onlyOwner {
144         newOwner = _newOwner;
145     }
146 
147     // new owner need to accept ownership
148     function acceptOwnership() external {
149         require(msg.sender == newOwner, "You are not New Owner");
150         newOwner = address(0);
151         owner = msg.sender;
152     }
153 
154     /**
155     @dev Add investor to vesting contract that not used collection contract
156     @param addr - address to add
157     @param amount - tokens due
158     */
159     function addInvestor(address addr, uint256 amount) external onlyOwner {
160         require(!addDisabled, "Too late do add investors");
161         _addInvestor(addr, amount);
162     }
163 
164     /**
165     @dev Add investors in bulk
166     @param addr table of addresses
167     @param amount table of amounts
168     */
169     function addInvestors(address[] calldata addr, uint256[] calldata amount)
170         external
171         onlyOwner
172     {
173         require(!addDisabled, "Too late do add investors");
174         require(addr.length == amount.length, "Data length not match");
175         for (uint256 i = 0; i < addr.length; i++) {
176             _addInvestor(addr[i], amount[i]);
177         }
178     }
179 
180     // internal function adding investors
181     function _addInvestor(address addr, uint256 amt) internal {
182         require(_tokensTotal[addr] == 0, "Address already on list");
183         _tokensTotal[addr] = amt;
184     }
185 
186     /**
187     @dev Function to recover accidentally send ERC20 tokens
188     @param _token ERC20 token address
189     */
190     function rescueERC20(address _token) external onlyOwner {
191         uint256 amt = IErc20(_token).balanceOf(address(this));
192         require(amt > 0, "Nothing to rescue");
193         IErc20(_token).transfer(owner, amt);
194     }
195 }