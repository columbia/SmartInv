1 //SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.8.6;
3 
4 //Uniqly FanadisePresale contract
5 contract FanadisePresale42 {
6     // presale target - close contract when passed
7     uint256 public immutable presaleLimit;
8 
9     // minimum pay-in per user
10     uint256 public immutable minPerUser;
11 
12     // maximum pay-in per user
13     uint256 public immutable maxPerUser;
14 
15     // timestamp ending presale
16     uint256 public immutable presaleEnd;
17 
18     // failsafe time - fail if not properly closed after presaleEnd
19     uint256 constant failSafeTime = 2 weeks;
20 
21     // owner address - will receive ETH if success
22     address public owner;
23 
24     //constructor
25     constructor(
26         uint256 _presaleLimit, //maximum amount to be collected
27         uint256 _minPerUser, //minimum buy-in per user
28         uint256 _maxPerUser, //maximum buy-in per user
29         uint256 _presaleEnd, //unix timestamp of presale round end
30         address _owner //privileged address
31     ) {
32         presaleLimit = _presaleLimit;
33         minPerUser = _minPerUser;
34         maxPerUser = _maxPerUser;
35         presaleEnd = _presaleEnd;
36         owner = _owner;
37     }
38 
39     //flags need for logic (false is default)
40     bool presaleEnded;
41     bool presaleFailed;
42     bool presaleStarted;
43 
44     // list of user balances (zero is default)
45     mapping(address => uint256) private balances;
46 
47     // join presale - just send ETH to contract,
48     // remember to check GAS LIMIT > 70000!
49     receive() external payable {
50         // only if not ended
51         require(presaleStarted, "Presale not started");
52         require(!presaleEnded, "Presale ended");
53         // only if within time limit
54         require(block.timestamp < presaleEnd, "Presale time's up");
55 
56         // record new user balance if possible
57         uint256 amount = msg.value + balances[msg.sender];
58         require(amount >= minPerUser, "Below buy-in");
59         require(amount <= maxPerUser, "Over buy-in");
60         balances[msg.sender] = amount;
61 
62         // end presale if reached limit
63         if (collected() >= presaleLimit) {
64             presaleEnded = true;
65         }
66     }
67 
68     function start() external {
69         require(msg.sender == owner, "Only for Owner");
70         presaleStarted = true;
71     }
72 
73     // check balance of any user
74     function balanceOf(address user) external view returns (uint256) {
75         return balances[user];
76     }
77 
78     // return balance of caller
79     function balanceOf() external view returns (uint256) {
80         return balances[msg.sender];
81     }
82 
83     // total ETH on this contract
84     function collected() public view returns (uint256) {
85         return address(this).balance;
86     }
87 
88     // withdraw ETH from contract
89     // can be used by user and owner
90     // return false if nothing to do
91     function withdraw() external returns (bool) {
92         if (!presaleEnded) {
93             // end and fail presale if failsafe time passed
94             if (block.timestamp > presaleEnd + failSafeTime) {
95                 presaleEnded = true;
96                 presaleFailed = true;
97                 // don't return true, you can withdraw in this call
98             }
99         }
100         // owner withdraw - presale succeed ?
101         else if (msg.sender == owner && !presaleFailed) {
102             send(owner, address(this).balance);
103             return true;
104         }
105 
106         // presale failed, withdraw to calling user
107         if (presaleFailed) {
108             uint256 amount = balances[msg.sender];
109             balances[msg.sender] = 0;
110             send(msg.sender, amount);
111             return true;
112         }
113 
114         // did nothing
115         return false;
116     }
117 
118     //send ETH from contract to address or contract
119     function send(address user, uint256 amount) private {
120         bool success = false;
121         (success, ) = address(user).call{value: amount}("");
122         require(success, "ETH send failed");
123     }
124 
125     // withdraw any ERC20 token send accidentally on this contract address to contract owner
126     function withdrawAnyERC20(IERC20 token) external {
127         uint256 amount = token.balanceOf(address(this));
128         require(amount > 0, "No tokens to withdraw");
129         token.transfer(owner, amount);
130     }
131 
132     // change ownership in two steps to be sure about owner address
133     address public newOwner;
134 
135     // only current owner can delegate new one
136     function giveOwnership(address _newOwner) external {
137         require(msg.sender == owner, "Only for Owner");
138         newOwner = _newOwner;
139     }
140 
141     // new owner need to accept ownership
142     function acceptOwnership() external {
143         require(msg.sender == newOwner, "Ure not New Owner");
144         newOwner = address(0x0);
145         owner = msg.sender;
146     }
147 }
148 
149 //ERC20 functions for fallback tokens recovery
150 interface IERC20 {
151     function balanceOf(address _owner) external returns (uint256 balance);
152 
153     function transfer(address _to, uint256 _value) external;
154     // can not 'returns (bool success);' because of USDT
155     // and other tokens that not follow ERC20 spec fully.
156 }