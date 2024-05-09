1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function add(uint a, uint b) internal pure returns (uint c) {
6 
7         c = a + b;
8 
9         require(c >= a);
10 
11     }
12 
13     function sub(uint a, uint b) internal pure returns (uint c) {
14 
15         require(b <= a);
16 
17         c = a - b;
18 
19     }
20 
21     function mul(uint a, uint b) internal pure returns (uint c) {
22 
23         c = a * b;
24 
25         require(a == 0 || c / a == b);
26 
27     }
28 
29     function div(uint a, uint b) internal pure returns (uint c) {
30 
31         require(b > 0);
32 
33         c = a / b;
34 
35     }
36 
37 }
38 
39 contract Ownable {
40 
41 
42 
43   address public owner;
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     if (msg.sender != owner) {
59       throw;
60     }
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner {
70     if (newOwner != address(0)) {
71       owner = newOwner;
72     }
73   }
74 
75 }
76 
77 
78 contract ERC20Interface {
79     function totalSupply() public constant returns (uint);
80     function balanceOf(address tokenOwner) public constant returns (uint balance);
81     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
82     function transfer(address to, uint tokens) public returns (bool success);
83     function approve(address spender, uint tokens) public returns (bool success);
84     function transferFrom(address from, address to, uint tokens) public returns (bool success);
85 
86     event Transfer(address indexed from, address indexed to, uint tokens);
87     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
88 }
89 
90 contract ERC918Interface {
91   function totalSupply() public constant returns (uint);
92   function getMiningDifficulty() public constant returns (uint);
93   function getMiningTarget() public constant returns (uint);
94   function getMiningReward() public constant returns (uint);
95   function balanceOf(address tokenOwner) public constant returns (uint balance);
96 
97   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
98 
99   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
100 
101 }
102 
103 /*
104 The owner (or anyone) will deposit tokens in here
105 The owner calls the multisend method to send out payments
106 */
107 contract MintHelper is Ownable {
108 
109   using SafeMath for uint;
110 
111     string public name;
112 
113 
114     address public mintableToken;
115 
116     address public payoutsWallet;
117     address public minterWallet;
118 
119     uint public minterFeePercent;
120 
121 
122     constructor(address mToken, address pWallet, address mWallet)
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
163     function setName(string newName)
164     public onlyOwner
165     returns (bool)
166     {
167       name = newName;
168       return true;
169     }
170 
171     function proxyMint(uint256 nonce, bytes32 challenge_digest )
172 //    public onlyOwner  //does not need to be only owner, owner will get paid
173     returns (bool)
174     {
175       //identify the rewards that will be won and how to split them up
176       uint totalReward = ERC918Interface(mintableToken).getMiningReward();
177 
178       uint minterReward = totalReward.mul(minterFeePercent).div(100);
179       uint payoutReward = totalReward.sub(minterReward);
180 
181       // get paid in new tokens
182       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));
183 
184       //transfer the tokens to the correct wallets
185       require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
186       require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));
187 
188       return true;
189 
190     }
191 
192 
193 
194     //withdraw any eth inside
195     function withdraw()
196     public onlyOwner
197     {
198         msg.sender.transfer(this.balance);
199     }
200 
201     //send tokens out
202     function send(address _tokenAddr, address dest, uint value)
203     public onlyOwner
204     returns (bool)
205     {
206      return ERC20Interface(_tokenAddr).transfer(dest, value);
207     }
208 
209 
210 
211 
212 }