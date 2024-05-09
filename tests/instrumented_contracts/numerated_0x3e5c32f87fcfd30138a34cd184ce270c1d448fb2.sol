1 pragma solidity ^0.4.24;
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
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     if (msg.sender != owner) {
61       throw;
62     }
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner {
72     if (newOwner != address(0)) {
73       owner = newOwner;
74     }
75   }
76 
77 }
78 
79 
80 contract ERC20Interface {
81     function totalSupply() public constant returns (uint);
82     function balanceOf(address tokenOwner) public constant returns (uint balance);
83     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
84     function transfer(address to, uint tokens) public returns (bool success);
85     function approve(address spender, uint tokens) public returns (bool success);
86     function transferFrom(address from, address to, uint tokens) public returns (bool success);
87 
88     event Transfer(address indexed from, address indexed to, uint tokens);
89     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
90 }
91 
92 contract ERC918Interface {
93   function totalSupply() public constant returns (uint);
94   function getMiningDifficulty() public constant returns (uint);
95   function getMiningTarget() public constant returns (uint);
96   function getMiningReward() public constant returns (uint);
97   function balanceOf(address tokenOwner) public constant returns (uint balance);
98 
99   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
100 
101   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
102 
103 }
104 
105 /*
106 The owner (or anyone) will deposit tokens in here
107 The owner calls the multisend method to send out payments
108 */
109 contract MintHelper is Ownable {
110 
111   using SafeMath for uint;
112 
113     string public name;
114 
115 
116     address public mintableToken;
117 
118     address public payoutsWallet;
119     address public minterWallet;
120 
121     uint public minterFeePercent;
122 
123 
124     function MintHelper(address mToken, address pWallet, address mWallet)
125     {
126       mintableToken = mToken;
127       payoutsWallet = pWallet;
128       minterWallet = mWallet;
129       minterFeePercent = 5;
130     }
131 
132     function setMintableToken(address mToken)
133     public onlyOwner
134     returns (bool)
135     {
136       mintableToken = mToken;
137       return true;
138     }
139 
140     function setPayoutsWallet(address pWallet)
141     public onlyOwner
142     returns (bool)
143     {
144       payoutsWallet = pWallet;
145       return true;
146     }
147 
148     function setMinterWallet(address mWallet)
149     public onlyOwner
150     returns (bool)
151     {
152       minterWallet = mWallet;
153       return true;
154     }
155 
156     function setMinterFeePercent(uint fee)
157     public onlyOwner
158     returns (bool)
159     {
160       require(fee >= 0 && fee <= 100);
161       minterFeePercent = fee;
162       return true;
163     }
164 
165     function setName(string newName)
166     public onlyOwner
167     returns (bool)
168     {
169       name = newName;
170       return true;
171     }
172 
173     function proxyMint(uint256 nonce, bytes32 challenge_digest )
174 //    public onlyOwner  //does not need to be only owner, owner will get paid
175     returns (bool)
176     {
177       //identify the rewards that will be won and how to split them up
178       uint totalReward = ERC918Interface(mintableToken).getMiningReward();
179 
180       uint minterReward = totalReward.mul(minterFeePercent).div(100);
181       uint payoutReward = totalReward.sub(minterReward);
182 
183       // get paid in new tokens
184       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));
185 
186       //transfer the tokens to the correct wallets
187       require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
188       require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));
189 
190       return true;
191 
192     }
193 
194 
195 
196     //withdraw any eth inside
197     function withdraw()
198     public onlyOwner
199     {
200         msg.sender.transfer(this.balance);
201     }
202 
203     //send tokens out
204     function send(address _tokenAddr, address dest, uint value)
205     public onlyOwner
206     returns (bool)
207     {
208      return ERC20Interface(_tokenAddr).transfer(dest, value);
209     }
210 }