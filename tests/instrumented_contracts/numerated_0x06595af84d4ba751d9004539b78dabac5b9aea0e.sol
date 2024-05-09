1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-04
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 
8 
9 library SafeMath {
10 
11     function add(uint a, uint b) internal pure returns (uint c) {
12 
13         c = a + b;
14 
15         require(c >= a);
16 
17     }
18 
19     function sub(uint a, uint b) internal pure returns (uint c) {
20 
21         require(b <= a);
22 
23         c = a - b;
24 
25     }
26 
27     function mul(uint a, uint b) internal pure returns (uint c) {
28 
29         c = a * b;
30 
31         require(a == 0 || c / a == b);
32 
33     }
34 
35     function div(uint a, uint b) internal pure returns (uint c) {
36 
37         require(b > 0);
38 
39         c = a / b;
40 
41     }
42 
43 }
44 
45 contract Ownable {
46 
47 
48 
49   address public owner;
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     if (msg.sender != owner) {
66       throw;
67     }
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner {
77     if (newOwner != address(0)) {
78       owner = newOwner;
79     }
80   }
81 
82 }
83 
84 
85 contract ERC20Interface {
86     function totalSupply() public constant returns (uint);
87     function balanceOf(address tokenOwner) public constant returns (uint balance);
88     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
89     function transfer(address to, uint tokens) public returns (bool success);
90     function approve(address spender, uint tokens) public returns (bool success);
91     function transferFrom(address from, address to, uint tokens) public returns (bool success);
92 
93     event Transfer(address indexed from, address indexed to, uint tokens);
94     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
95 }
96 
97 contract ERC918Interface {
98   function totalSupply() public constant returns (uint);
99   function getMiningDifficulty() public constant returns (uint);
100   function getMiningTarget() public constant returns (uint);
101   function getMiningReward() public constant returns (uint);
102   function balanceOf(address tokenOwner) public constant returns (uint balance);
103   function merge() public returns (bool success);
104   uint public lastRewardAmount;
105 
106   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
107 
108   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
109 
110 }
111 
112 /*
113 The owner (or anyone) will deposit tokens in here
114 The owner calls the multisend method to send out payments
115 */
116 contract MintHelper is Ownable {
117 
118   using SafeMath for uint;
119 
120     address public mintableToken;
121 
122     address public payoutsWallet;
123     address public minterWallet;
124 
125     uint public minterFeePercent;
126 
127 
128     function MintHelper(address mToken, address pWallet, address mWallet)
129     {
130       mintableToken = mToken;
131       payoutsWallet = pWallet;
132       minterWallet = mWallet;
133       minterFeePercent = 6;
134     }
135 
136     function setMintableToken(address mToken)
137     public onlyOwner
138     returns (bool)
139     {
140       mintableToken = mToken;
141       return true;
142     }
143 
144     function setPayoutsWallet(address pWallet)
145     public onlyOwner
146     returns (bool)
147     {
148       payoutsWallet = pWallet;
149       return true;
150     }
151 
152     function setMinterWallet(address mWallet)
153     public onlyOwner
154     returns (bool)
155     {
156       minterWallet = mWallet;
157       return true;
158     }
159 
160     function setMinterFeePercent(uint fee)
161     public onlyOwner
162     returns (bool)
163     {
164       require(fee >= 0 && fee <= 100);
165       minterFeePercent = fee;
166       return true;
167     }
168 
169 
170 
171     function proxyMint(uint256 nonce, bytes32 challenge_digest )
172     public onlyOwner
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
193     function proxyMergeMint(uint256 nonce, bytes32 challenge_digest, address[] tokens)
194     public onlyOwner
195     returns (bool)
196     {
197       //identify the rewards that will be won and how to split them up
198       uint totalReward = ERC918Interface(mintableToken).getMiningReward();
199 
200       uint minterReward = totalReward.mul(minterFeePercent).div(100);
201       uint payoutReward = totalReward.sub(minterReward);
202 
203       // get paid in new tokens
204       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest));
205       //transfer the tokens to the correct wallets
206       require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
207       require(ERC20Interface(mintableToken).transfer(payoutsWallet, payoutReward));
208 
209       uint256 i = 0;
210       while (i < tokens.length) {
211          address mergedToken = tokens[i];
212          if(ERC918Interface(mergedToken).merge())
213          {
214             uint merge_totalReward = ERC918Interface(mergedToken).lastRewardAmount();
215             uint merge_minterReward = merge_totalReward.mul(minterFeePercent).div(100);
216             uint merge_payoutReward = merge_totalReward.sub(merge_minterReward);
217 
218             // get paid in new tokens
219             //transfer the tokens to the correct wallets
220             require(ERC20Interface(mergedToken).transfer(minterWallet, merge_minterReward));
221             require(ERC20Interface(mergedToken).transfer(payoutsWallet, merge_payoutReward));
222          }
223          i+=1;
224       }
225 
226 
227       return true;
228 
229     }
230 
231 
232 
233     //withdraw any eth inside
234     function withdraw()
235     public onlyOwner
236     {
237         msg.sender.transfer(this.balance);
238     }
239 
240     //send tokens out
241     function send(address _tokenAddr, address dest, uint value)
242     public onlyOwner
243     returns (bool)
244     {
245      return ERC20Interface(_tokenAddr).transfer(dest, value);
246     }
247 
248  
249 
250 
251 }