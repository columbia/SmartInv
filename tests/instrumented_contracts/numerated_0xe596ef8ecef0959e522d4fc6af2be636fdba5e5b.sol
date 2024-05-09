1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-22
3 */
4 
5 //Team Tenset
6 pragma solidity ^0.4.22;
7 
8 /**
9  * token contract functions
10 */
11 contract Token {
12     function balanceOf(address who) external view returns (uint256);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function transfer(address to, uint256 value) external returns (bool);
15     function approve(address spender, uint256 value) external returns (bool);
16     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 }
19 
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         require(c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal constant returns (uint256) {
31         uint256 c = a / b;
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36         require(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal constant returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a);
43         return c;
44     }
45 
46     function ceil(uint256 a, uint256 m) internal constant returns (uint256) {
47         uint256 c = add(a,m);
48         uint256 d = sub(c,1);
49         return mul(div(d,m),m);
50     }
51 }
52 
53 contract owned {
54     address public owner;
55 
56     function owned() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner public {
66         owner = newOwner;
67     }
68 }
69 
70 contract lockToken is owned{
71     using SafeMath for uint256;
72 
73     /*
74      * deposit vars
75     */
76     struct Items {
77         address tokenAddress;
78         address withdrawalAddress;
79         uint256 tokenAmount;
80         uint256 unlockTime;
81         bool withdrawn;
82     }
83 
84     uint256 public depositId;
85     uint256[] public allDepositIds;
86     mapping (address => uint256[]) public depositsByWithdrawalAddress;
87     mapping (uint256 => Items) public lockedToken;
88     mapping (address => mapping(address => uint256)) public walletTokenBalance;
89 
90     event LogWithdrawal(address SentToAddress, uint256 AmountTransferred);
91 
92 
93     function _decreaseAmountFee(uint256 _oldAmount) private view returns(uint256 _newAmount) {
94         uint256 scaledFee = 2;
95         uint256 scalledPercentage = 100;
96         return _oldAmount.mul(scaledFee).div(scalledPercentage); // 2/100
97     }
98 
99     /**
100      *lock tokens
101     */
102     function lockTokens(address _tokenAddress, address _withdrawalAddress, uint256 _amount, uint256 _unlockTime) public returns (uint256 _id) {
103         require(_amount > 0);
104         require(_unlockTime < 10000000000);
105 
106         //update balance in address
107         uint256 tensetFixedBalance = _amount.sub(_decreaseAmountFee(_amount));
108         walletTokenBalance[_tokenAddress][_withdrawalAddress] = walletTokenBalance[_tokenAddress][_withdrawalAddress].add(tensetFixedBalance);
109 
110         _id = ++depositId;
111         lockedToken[_id].tokenAddress = _tokenAddress;
112         lockedToken[_id].withdrawalAddress = _withdrawalAddress;
113         lockedToken[_id].tokenAmount = tensetFixedBalance;
114         lockedToken[_id].unlockTime = _unlockTime;
115         lockedToken[_id].withdrawn = false;
116 
117         allDepositIds.push(_id);
118         depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
119 
120         // transfer tokens into contract
121         require(Token(_tokenAddress).transferFrom(msg.sender, this, _amount));
122     }
123 
124     /**
125      *Create multiple locks
126     */
127     function createMultipleLocks(address _tokenAddress, address _withdrawalAddress, uint256[] _amounts, uint256[] _unlockTimes) public returns (uint256 _id) {
128         require(_amounts.length > 0);
129         require(_amounts.length == _unlockTimes.length);
130 
131         uint256 i;
132         for(i=0; i<_amounts.length; i++){
133             require(_amounts[i] > 0);
134             require(_unlockTimes[i] < 10000000000);
135 
136             //update balance in address
137             walletTokenBalance[_tokenAddress][_withdrawalAddress] = walletTokenBalance[_tokenAddress][_withdrawalAddress].add(_amounts[i]);
138 
139             _id = ++depositId;
140             lockedToken[_id].tokenAddress = _tokenAddress;
141             lockedToken[_id].withdrawalAddress = _withdrawalAddress;
142             lockedToken[_id].tokenAmount = _amounts[i];
143             lockedToken[_id].unlockTime = _unlockTimes[i];
144             lockedToken[_id].withdrawn = false;
145 
146             allDepositIds.push(_id);
147             depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
148 
149             //transfer tokens into contract
150             require(Token(_tokenAddress).transferFrom(msg.sender, this, _amounts[i]));
151         }
152     }
153 
154     /**
155      *Extend lock Duration
156     */
157     function extendLockDuration(uint256 _id, uint256 _unlockTime) public {
158         require(_unlockTime < 10000000000);
159         require(_unlockTime > lockedToken[_id].unlockTime);
160         require(!lockedToken[_id].withdrawn);
161         require(msg.sender == lockedToken[_id].withdrawalAddress);
162 
163         //set new unlock time
164         lockedToken[_id].unlockTime = _unlockTime;
165     }
166 
167     /**
168      *transfer locked tokens
169     */
170     function transferLocks(uint256 _id, address _receiverAddress) public {
171         require(!lockedToken[_id].withdrawn);
172         require(msg.sender == lockedToken[_id].withdrawalAddress);
173 
174         //decrease sender's token balance
175         walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
176 
177         //increase receiver's token balance
178         walletTokenBalance[lockedToken[_id].tokenAddress][_receiverAddress] = walletTokenBalance[lockedToken[_id].tokenAddress][_receiverAddress].add(lockedToken[_id].tokenAmount);
179 
180         //remove this id from sender address
181         uint256 j;
182         uint256 arrLength = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length;
183         for (j=0; j<arrLength; j++) {
184             if (depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] == _id) {
185                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][arrLength - 1];
186                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length--;
187                 break;
188             }
189         }
190 
191         //Assign this id to receiver address
192         lockedToken[_id].withdrawalAddress = _receiverAddress;
193         depositsByWithdrawalAddress[_receiverAddress].push(_id);
194     }
195 
196     /**
197      *withdraw tokens
198     */
199     function withdrawTokens(uint256 _id) public {
200         require(block.timestamp >= lockedToken[_id].unlockTime);
201         require(msg.sender == lockedToken[_id].withdrawalAddress);
202         require(!lockedToken[_id].withdrawn);
203 
204 
205         lockedToken[_id].withdrawn = true;
206 
207         //update balance in address
208         walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
209 
210         //remove this id from this address
211         uint256 j;
212         uint256 arrLength = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length;
213         for (j=0; j<arrLength; j++) {
214             if (depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] == _id) {
215                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][arrLength - 1];
216                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length--;
217                 break;
218             }
219         }
220 
221         // transfer tokens to wallet address
222         require(Token(lockedToken[_id].tokenAddress).transfer(msg.sender, lockedToken[_id].tokenAmount));
223         LogWithdrawal(msg.sender, lockedToken[_id].tokenAmount);
224     }
225 
226     /*get total token balance in contract*/
227     function getTotalTokenBalance(address _tokenAddress) view public returns (uint256)
228     {
229         return Token(_tokenAddress).balanceOf(this);
230     }
231 
232     /*get total token balance by address*/
233     function getTokenBalanceByAddress(address _tokenAddress, address _walletAddress) view public returns (uint256)
234     {
235         return walletTokenBalance[_tokenAddress][_walletAddress];
236     }
237 
238     /*get allDepositIds*/
239     function getAllDepositIds() view public returns (uint256[])
240     {
241         return allDepositIds;
242     }
243 
244     /*get getDepositDetails*/
245     function getDepositDetails(uint256 _id) view public returns (address _tokenAddress, address _withdrawalAddress, uint256 _tokenAmount, uint256 _unlockTime, bool _withdrawn)
246     {
247         return(lockedToken[_id].tokenAddress,lockedToken[_id].withdrawalAddress,lockedToken[_id].tokenAmount,
248         lockedToken[_id].unlockTime,lockedToken[_id].withdrawn);
249     }
250 
251     /*get DepositsByWithdrawalAddress*/
252     function getDepositsByWithdrawalAddress(address _withdrawalAddress) view public returns (uint256[])
253     {
254         return depositsByWithdrawalAddress[_withdrawalAddress];
255     }
256 
257 }