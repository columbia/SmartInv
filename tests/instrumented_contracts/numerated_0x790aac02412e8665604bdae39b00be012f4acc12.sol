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
99   function merge() public returns (bool success);
100   uint public lastRewardAmount;
101 
102   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
103 
104   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
105 
106 }
107 
108 /*
109 The owner (or anyone) will deposit tokens in here
110 The owner calls the multisend method to send out payments
111 */
112 contract MintHelper is Ownable {
113 
114   using SafeMath for uint;
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
165 
166 
167     function proxyMint(uint256 nonce, bytes32 challenge_digest )
168     public onlyOwner
169     returns (bool)
170     {
171       //identify the rewards that will be won and how to split them up
172       uint totalReward = ERC918Interface(mintableToken).getMiningReward();
173 
174       uint minterReward = totalReward.mul(minterFeePercent).div(100);
175       uint payoutReward = totalReward.sub(minterReward);
176 
177       // get paid in new tokens
178       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));
179 
180       //transfer the tokens to the correct wallets
181       require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
182       require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));
183 
184       return true;
185 
186     }
187 
188 
189     function proxyMergeMint(uint256 nonce, bytes32 challenge_digest, address[] tokens)
190     public onlyOwner
191     returns (bool)
192     {
193       //identify the rewards that will be won and how to split them up
194       uint totalReward = ERC918Interface(mintableToken).getMiningReward();
195 
196       uint minterReward = totalReward.mul(minterFeePercent).div(100);
197       uint payoutReward = totalReward.sub(minterReward);
198 
199       // get paid in new tokens
200       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));
201       //transfer the tokens to the correct wallets
202       require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
203       require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));
204 
205       uint256 i = 0;
206       while (i < tokens.length) {
207          address mergedToken = tokens[i];
208          if(ERC918Interface(mergedToken).merge())
209          {
210             uint merge_totalReward = ERC918Interface(mergedToken).lastRewardAmount();
211             uint merge_minterReward = merge_totalReward.mul(minterFeePercent).div(100);
212             uint merge_payoutReward = merge_totalReward.sub(merge_minterReward);
213 
214             // get paid in new tokens
215             //transfer the tokens to the correct wallets
216             require(ERC20Interface(mergedToken).transfer(minterWallet, merge_minterReward));
217             require(ERC20Interface(mergedToken).transfer(payoutsWallet, merge_payoutReward));
218          }
219          i+=1;
220       }
221 
222 
223       return true;
224 
225     }
226 
227 
228 
229     //withdraw any eth inside
230     function withdraw()
231     public onlyOwner
232     {
233         msg.sender.transfer(this.balance);
234     }
235 
236     //send tokens out
237     function send(address _tokenAddr, address dest, uint value)
238     public onlyOwner
239     returns (bool)
240     {
241      return ERC20Interface(_tokenAddr).transfer(dest, value);
242     }
243 
244  
245 
246 
247 }