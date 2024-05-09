1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.8.2;
4 
5 //ERC20 functions for fallback tokens recovery
6 abstract contract IERC20 {
7     function balanceOf(address _owner)
8         external
9         virtual
10         returns (uint256 balance);
11 
12     function transfer(address _to, uint256 _value) external virtual;
13     // can not 'returns (bool success);' because of USDT
14     // and other tokens that not follow ERC20 spec fully.
15 }
16 
17 //Uniqly presale contract
18 contract UniqlyPresale4 {
19     // presale target - close presale when reached
20     uint256 public immutable presaleLimit;
21 
22     // minimum pay-in per user
23     uint256 public immutable minPerUser;
24 
25     // maximum pay-in per user
26     uint256 public immutable maxPerUser;
27 
28     // timestamp ending presale
29     uint256 public immutable presaleEnd;
30 
31     // failsafe time - fail if not properly closed after presaleEnd
32     uint256 constant failSafeTime = 2 weeks;
33 
34     // owner address - will receive ETH if success
35     address public owner;
36 
37     //constructor
38     constructor(
39         uint256 _presaleLimit, //maximum amount to be collected
40         uint256 _minPerUser, //minimum buy-in per user
41         uint256 _maxPerUser, //maximum buy-in per user
42         uint256 _presaleEnd, //unix timestamp of presale round end
43         address _owner //privileged address
44     ) {
45         presaleLimit = _presaleLimit;
46         minPerUser = _minPerUser;
47         maxPerUser = _maxPerUser;
48         presaleEnd = _presaleEnd;
49         owner = _owner;
50     }
51 
52     //flags need for logic (false is default)
53     bool presaleEnded;
54     bool presaleFailed;
55     bool presaleStarted;
56 
57     // list of user balances (zero is default)
58     mapping(address => uint256) private balances;
59 
60     // join presale - just send ETH to contract,
61     // remember to check GAS LIMIT > 70000!
62     receive() external payable {
63         // only if not ended
64         require(presaleStarted, "Presale not started");
65         require(!presaleEnded, "Presale ended");
66         // only if within time limit
67         require(block.timestamp < presaleEnd, "Presale time's up");
68 
69         // record new user balance if possible
70         uint256 amount = msg.value + balances[msg.sender];
71         require(amount >= minPerUser, "Below buy-in");
72         require(amount <= maxPerUser, "Over buy-in");
73         balances[msg.sender] = amount;
74 
75         // end presale if reached limit
76         if (collected() >= presaleLimit) {
77             presaleEnded = true;
78         }
79     }
80 
81     function start() external {
82         require(msg.sender == owner, "Only for Owner");
83         presaleStarted = true;
84     }
85 
86     // check balance of any user
87     function balanceOf(address user) external view returns (uint256) {
88         return balances[user];
89     }
90 
91     // return balance of caller
92     function balanceOf() external view returns (uint256) {
93         return balances[msg.sender];
94     }
95 
96     // total ETH on this contract
97     function collected() public view returns (uint256) {
98         return address(this).balance;
99     }
100 
101     // withdraw ETH from contract
102     // can be used by user and owner
103     // return false if nothing to do
104     function withdraw() external returns (bool) {
105         if (!presaleEnded) {
106             // end and fail presale if failsafe time passed
107             if (block.timestamp > presaleEnd + failSafeTime) {
108                 presaleEnded = true;
109                 presaleFailed = true;
110                 // don't return true, you can withdraw in this call
111             }
112         }
113         // owner withdraw - presale succeed ?
114         else if (msg.sender == owner && !presaleFailed) {
115             send(owner, address(this).balance);
116             return true;
117         }
118 
119         // presale failed, withdraw to calling user
120         if (presaleFailed) {
121             uint256 amount = balances[msg.sender];
122             balances[msg.sender] = 0;
123             send(msg.sender, amount);
124             return true;
125         }
126 
127         // did nothing
128         return false;
129     }
130 
131     //send ETH from contract to address or contract
132     function send(address user, uint256 amount) private {
133         bool success = false;
134         (success, ) = address(user).call{value: amount}("");
135         require(success, "ETH send failed");
136     }
137 
138     // withdraw any ERC20 token send accidentally on this contract address to contract owner
139     function withdrawAnyERC20(IERC20 token) external {
140         uint256 amount = token.balanceOf(address(this));
141         require(amount > 0, "No tokens to withdraw");
142         token.transfer(owner, amount);
143     }
144 
145     // change ownership in two steps to be sure about owner address
146     address public newOwner;
147 
148     // only current owner can delegate new one
149     function giveOwnership(address _newOwner) external {
150         require(msg.sender == owner, "Only for Owner");
151         newOwner = _newOwner;
152     }
153 
154     // new owner need to accept ownership
155     function acceptOwnership() external {
156         require(msg.sender == newOwner, "Ure not New Owner");
157         newOwner = address(0x0);
158         owner = msg.sender;
159     }
160 }