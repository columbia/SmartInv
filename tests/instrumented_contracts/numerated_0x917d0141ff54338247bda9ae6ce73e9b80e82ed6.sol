1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     constructor () internal {
44         _owner = msg.sender;
45         emit OwnershipTransferred(address(0), _owner);
46     }
47 
48     /**
49      * @return the address of the owner.
50      */
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(isOwner());
60         _;
61     }
62 
63     /**
64      * @return true if `msg.sender` is the owner of the contract.
65      */
66     function isOwner() public view returns (bool) {
67         return msg.sender == _owner;
68     }
69 
70     /**
71      * @dev Allows the current owner to relinquish control of the contract.
72      * @notice Renouncing to ownership will leave the contract without an owner.
73      * It will not be possible to call the functions with the `onlyOwner`
74      * modifier anymore.
75      */
76     function renounceOwnership() public onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Allows the current owner to transfer control of the contract to a newOwner.
83      * @param newOwner The address to transfer ownership to.
84      */
85     function transferOwnership(address newOwner) public onlyOwner {
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function _transferOwnership(address newOwner) internal {
94         require(newOwner != address(0));
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 // File: contracts/DIP_Team_Transfer.sol
101 
102 contract DIP_Team_Transfer is Ownable {
103 
104     uint256 constant DIP = 10**18;
105     IERC20 public DIP_Token;
106 
107     event LogTokensSent(address receiver, uint256 amount);
108 
109     address Pool_B = 0x36500E8366b0477fe68842271Efb1Bb31D9a102B; // Team & Early Contributors
110     address Pool_C = 0xF27daB6Bf108c8Ba6EA81F66ef336Df4f1F975b3; // Founders
111 
112     struct grant {
113         address pool;
114         uint256 amount;
115     }
116 
117     mapping (address => grant) teamTokens;
118 
119     function () external {
120         getMyTokens();
121     }
122 
123     function getMyTokens() public {
124         grant memory myGrant;
125         uint256 amount;
126         myGrant = teamTokens[msg.sender];
127         amount = myGrant.amount;
128         myGrant.amount = 0;
129         require(amount > 0, "No Tokens available at address");
130         teamTokens[msg.sender] = grant(myGrant.pool, 0);
131         DIP_Token.transferFrom(myGrant.pool, msg.sender, amount);
132         emit LogTokensSent(msg.sender, amount);
133     }
134 
135     constructor () public Ownable() {
136 
137         DIP_Token = IERC20(0xc719d010B63E5bbF2C0551872CD5316ED26AcD83);
138 
139         teamTokens[0x0024df2bE7524b132Ced68Ca2906eD1D9CdAbDA4] = grant(Pool_B, 84000 * DIP);    
140         teamTokens[0x025f020e2C1e540c3fBe3E80C23Cb192dFb65514] = grant(Pool_B, 2957000 * DIP);  
141         teamTokens[0x1FeA19BA0Cd8e068Fb1C538B2C3a700965d1952e] = grant(Pool_B, 119000 * DIP);   
142         teamTokens[0x2718874048aBcCEbE24693e689D31B011c6101EA] = grant(Pool_B, 314000 * DIP);   
143         teamTokens[0x317c250bFF0AC2b1913Aa6F2d6C609e4bE1AaeE0] = grant(Pool_B, 100000 * DIP);   
144         teamTokens[0x398c901146F569Bf5FCd70375311eFa02E119aF8] = grant(Pool_B, 588000 * DIP);   
145         teamTokens[0x4E268abEDa13152E60722035328E83f28eed0275] = grant(Pool_B, 314000 * DIP);   
146         teamTokens[0x5509cE67333342e7758bF845A0897b51E062f502] = grant(Pool_B, 115000 * DIP);   
147         teamTokens[0x559F1a36Ea6435f22EF814a654645051b1639c9d] = grant(Pool_B, 30000 * DIP);    
148         teamTokens[0x5A6189cE8e6Ae1c86098af24103CA77D386Ae643] = grant(Pool_B, 5782000 * DIP);  
149         teamTokens[0x63CE9f57E2e4B41d3451DEc20dDB89143fD755bB] = grant(Pool_B, 115000 * DIP);   
150         teamTokens[0x6D970711335B3d3AC8Ee1bB88D7b3780bf580e5b] = grant(Pool_B, 46000 * DIP);    
151         teamTokens[0x842d48Ebb8E8043A98Cd176368F39d777d1fF78E] = grant(Pool_B, 19000 * DIP);    
152         teamTokens[0x8567104a7b6EA93a87c551F5D00ABB222EdB45d2] = grant(Pool_B, 46000 * DIP);    
153         teamTokens[0x886ed4Bb4Db7d160C25942dD9E5e1668cdA646D8] = grant(Pool_B, 250000 * DIP);   
154         teamTokens[0x98eA564573dE3AbD60181Df8b491C24C45b77e37] = grant(Pool_B, 115000 * DIP);   
155         teamTokens[0x9B8242f93dB16185bb6719C3831f768a261E5d55] = grant(Pool_B, 600000 * DIP);   
156         teamTokens[0xaC97d99B1cCdAE787B5022fE323C1079dbe41ccC] = grant(Pool_B, 115000 * DIP);   
157         teamTokens[0xB2Dc68B318eCEC2acf5f098D57775c90541612E2] = grant(Pool_B, 7227000 * DIP);  
158         teamTokens[0xb7686e8b325f39A6A62Ea1ea81fd29F50C7737ab] = grant(Pool_B, 115000 * DIP);   
159         teamTokens[0xba034d25a226705A84Ffe716eEEC90C1aD2aFE00] = grant(Pool_B, 115000 * DIP);   
160         teamTokens[0xC370D781D734222A8863053A8C5A7afF87b0896a] = grant(Pool_B, 100000 * DIP);   
161         teamTokens[0xCA0B0cA0d90e5008c31167FFb9a38fdA33aa36a8] = grant(Pool_B, 115000 * DIP);   
162         teamTokens[0xE2E5f8e18dD933aFbD61d81Fd188fB2637A2DaB6] = grant(Pool_B, 621000 * DIP);   
163         teamTokens[0xe5759a0d285BB2D14B82111532cf1c660Fe57481] = grant(Pool_B, 115000 * DIP);
164         teamTokens[0xF8cB04BfC21ebBc63E7eB49c9f8edF2E97707eE5] = grant(Pool_B, 314000 * DIP);
165         teamTokens[0x9Cfa308021E68576263Ac39E3c39A63f2b3f4556] = grant(Pool_B, 30000 * DIP);
166         teamTokens[0x9d20e78e40a9Cf59b535114F8D881f72984280a1] = grant(Pool_B, 33000 * DIP);
167         teamTokens[0xE113127804Ae2383f63Fe8cE31B212D5CB85113d] = grant(Pool_B, 1909000 * DIP);
168 
169         teamTokens[0x2EE8619CCa46c44cDD5C527FBa68E1f7E5F3478a] = grant(Pool_C, 33333333333333333333333333);
170         teamTokens[0xa8e679191AE2C669F4550db7f52b20CF3d19c069] = grant(Pool_C, 33333333333333333333333333); 
171         teamTokens[0xbC6b0862e6394067DC5Be2147c4de35DeB4424fE] = grant(Pool_C, 33333333333333333333333333); 
172 
173     }
174 
175     function cleanUp () public onlyOwner {
176         selfdestruct(address (uint160(owner())));
177     }
178 }