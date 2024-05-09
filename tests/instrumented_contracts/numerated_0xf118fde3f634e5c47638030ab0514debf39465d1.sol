1 pragma solidity ^0.4.18;
2 
3 
4 
5 library SafeMath {
6 
7     function add(uint a, uint b) internal pure returns (uint c) {
8 
9         c = a + b;
10 
11         require(c >= a);
12 
13     }
14 
15     function sub(uint a, uint b) internal pure returns (uint c) {
16 
17         require(b <= a);
18 
19         c = a - b;
20 
21     }
22 
23     function mul(uint a, uint b) internal pure returns (uint c) {
24 
25         c = a * b;
26 
27         require(a == 0 || c / a == b);
28 
29     }
30 
31     function div(uint a, uint b) internal pure returns (uint c) {
32 
33         require(b > 0);
34 
35         c = a / b;
36 
37     }
38 
39 }
40 
41 contract Ownable {
42 
43 
44 
45   address public owner;
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     if (msg.sender != owner) {
62       throw;
63     }
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner {
73     if (newOwner != address(0)) {
74       owner = newOwner;
75     }
76   }
77 
78 }
79 
80 
81 contract ERC20Interface {
82     function totalSupply() public constant returns (uint);
83     function balanceOf(address tokenOwner) public constant returns (uint balance);
84     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
85     function transfer(address to, uint tokens) public returns (bool success);
86     function approve(address spender, uint tokens) public returns (bool success);
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 contract ERC918Interface {
94   function totalSupply() public constant returns (uint);
95   function getMiningDifficulty() public constant returns (uint);
96   function getMiningTarget() public constant returns (uint);
97   function getMiningReward() public constant returns (uint);
98   function balanceOf(address tokenOwner) public constant returns (uint balance);
99 
100   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
101 
102   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
103 
104 }
105 
106 /*
107 The owner (or anyone) will deposit tokens in here
108 The owner calls the multisend method to send out payments
109 */
110 contract MintHelper is Ownable {
111 
112   using SafeMath for uint;
113 
114     address public mintableToken;
115 
116     address public payoutsWallet;
117     address public minterWallet;
118 
119     uint public minterFeePercent;
120 
121 
122     function MintHelper(address mToken, address pWallet, address mWallet)
123     {
124       mintableToken = mToken;
125       payoutsWallet = pWallet;
126       minterWallet = mWallet;
127       minterFeePercent = 5;
128     }
129 
130     function setMintableToken(address mToken)
131     public onlyOwner
132     returns (bool)
133     {
134       mintableToken = mToken;
135       return true;
136     }
137 
138     function setPayoutsWallet(address pWallet)
139     public onlyOwner
140     returns (bool)
141     {
142       payoutsWallet = pWallet;
143       return true;
144     }
145 
146     function setMinterWallet(address mWallet)
147     public onlyOwner
148     returns (bool)
149     {
150       minterWallet = mWallet;
151       return true;
152     }
153 
154     function setMinterFeePercent(uint fee)
155     public onlyOwner
156     returns (bool)
157     {
158       require(fee >= 0 && fee <= 100);
159       minterFeePercent = fee;
160       return true;
161     }
162 
163 
164 
165     function proxyMint(uint256 nonce, bytes32 challenge_digest )
166     public onlyOwner
167     returns (bool)
168     {
169       //identify the rewards that will be won and how to split them up
170       uint totalReward = ERC918Interface(mintableToken).getMiningReward();
171 
172       uint minterReward = totalReward.mul(minterFeePercent).div(100);
173       uint payoutReward = totalReward.sub(minterReward);
174 
175       // get paid in new tokens
176       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));
177 
178       //transfer the tokens to the correct wallets
179       require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
180       require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));
181 
182       return true;
183 
184     }
185 
186 
187 
188     //withdraw any eth inside
189     function withdraw()
190     public onlyOwner
191     {
192         msg.sender.transfer(this.balance);
193     }
194 
195     //send tokens out
196     function send(address _tokenAddr, address dest, uint value)
197     public onlyOwner
198     returns (bool)
199     {
200      return ERC20Interface(_tokenAddr).transfer(dest, value);
201     }
202 
203  
204 
205 
206 }