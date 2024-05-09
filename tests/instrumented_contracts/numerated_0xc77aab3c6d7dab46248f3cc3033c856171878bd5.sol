1 //Team Token Locking Contract
2 pragma solidity ^0.4.16;
3 
4 /**
5  * token contract functions
6 */
7 contract Token {
8     function balanceOf(address who) external view returns (uint256);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function transfer(address to, uint256 value) external returns (bool);
11     function approve(address spender, uint256 value) external returns (bool);
12     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14 }
15 
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     require(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a / b;
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     require(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     require(c >= a);
39     return c;
40   }
41 
42   function ceil(uint256 a, uint256 m) internal constant returns (uint256) {
43     uint256 c = add(a,m);
44     uint256 d = sub(c,1);
45     return mul(div(d,m),m);
46   }
47 }
48 
49 contract owned {
50         address public owner;
51 
52         function owned() public {
53             owner = msg.sender;
54         }
55 
56         modifier onlyOwner {
57             require(msg.sender == owner);
58             _;
59         }
60 
61         function transferOwnership(address newOwner) onlyOwner public {
62             owner = newOwner;
63         }
64 }
65 
66 contract lockToken is owned{
67     using SafeMath for uint256;
68     
69     /*
70      * deposit vars
71     */
72     struct Items {
73         address tokenAddress;
74         address withdrawalAddress;
75         uint256 tokenAmount;
76         uint256 unlockTime;
77         bool withdrawn;
78     }
79     
80     uint256 public depositId;
81     uint256[] public allDepositIds;
82     mapping (address => uint256[]) public depositsByWithdrawalAddress;
83     mapping (uint256 => Items) public lockedToken;
84     mapping (address => mapping(address => uint256)) public walletTokenBalance;
85     
86     event LogWithdrawal(address SentToAddress, uint256 AmountTransferred);
87     
88     /**
89      *lock tokens
90     */
91     function lockTokens(address _tokenAddress, address _withdrawalAddress, uint256 _amount, uint256 _unlockTime) public returns (uint256 _id) {
92         require(_amount > 0);
93         require(_unlockTime < 10000000000);
94         
95         //update balance in address
96         walletTokenBalance[_tokenAddress][_withdrawalAddress] = walletTokenBalance[_tokenAddress][_withdrawalAddress].add(_amount);
97         
98         _id = ++depositId;
99         lockedToken[_id].tokenAddress = _tokenAddress;
100         lockedToken[_id].withdrawalAddress = _withdrawalAddress;
101         lockedToken[_id].tokenAmount = _amount;
102         lockedToken[_id].unlockTime = _unlockTime;
103         lockedToken[_id].withdrawn = false;
104         
105         allDepositIds.push(_id);
106         depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
107         
108         // transfer tokens into contract
109         require(Token(_tokenAddress).transferFrom(msg.sender, this, _amount));
110     }
111     
112     /**
113      *Create multiple locks
114     */
115     function createMultipleLocks(address _tokenAddress, address _withdrawalAddress, uint256[] _amounts, uint256[] _unlockTimes) public returns (uint256 _id) {
116         require(_amounts.length > 0);
117         require(_amounts.length == _unlockTimes.length);
118         
119         uint256 i;
120         for(i=0; i<_amounts.length; i++){
121             require(_amounts[i] > 0);
122             require(_unlockTimes[i] < 10000000000);
123             
124             //update balance in address
125             walletTokenBalance[_tokenAddress][_withdrawalAddress] = walletTokenBalance[_tokenAddress][_withdrawalAddress].add(_amounts[i]);
126             
127             _id = ++depositId;
128             lockedToken[_id].tokenAddress = _tokenAddress;
129             lockedToken[_id].withdrawalAddress = _withdrawalAddress;
130             lockedToken[_id].tokenAmount = _amounts[i];
131             lockedToken[_id].unlockTime = _unlockTimes[i];
132             lockedToken[_id].withdrawn = false;
133             
134             allDepositIds.push(_id);
135             depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
136             
137             //transfer tokens into contract
138             require(Token(_tokenAddress).transferFrom(msg.sender, this, _amounts[i]));
139         }
140     }
141     
142     /**
143      *Extend lock Duration
144     */
145     function extendLockDuration(uint256 _id, uint256 _unlockTime) public {
146         require(_unlockTime < 10000000000);
147         require(_unlockTime > lockedToken[_id].unlockTime);
148         require(!lockedToken[_id].withdrawn);
149         require(msg.sender == lockedToken[_id].withdrawalAddress);
150         
151         //set new unlock time
152         lockedToken[_id].unlockTime = _unlockTime;
153     }
154     
155     /**
156      *transfer locked tokens
157     */
158     function transferLocks(uint256 _id, address _receiverAddress) public {
159         require(!lockedToken[_id].withdrawn);
160         require(msg.sender == lockedToken[_id].withdrawalAddress);
161         
162         //decrease sender's token balance
163         walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
164         
165         //increase receiver's token balance
166         walletTokenBalance[lockedToken[_id].tokenAddress][_receiverAddress] = walletTokenBalance[lockedToken[_id].tokenAddress][_receiverAddress].add(lockedToken[_id].tokenAmount);
167         
168         //remove this id from sender address
169         uint256 j;
170         uint256 arrLength = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length;
171         for (j=0; j<arrLength; j++) {
172             if (depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] == _id) {
173                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][arrLength - 1];
174                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length--;
175                 break;
176             }
177         }
178         
179         //Assign this id to receiver address
180         lockedToken[_id].withdrawalAddress = _receiverAddress;
181         depositsByWithdrawalAddress[_receiverAddress].push(_id);
182     }
183     
184     /**
185      *withdraw tokens
186     */
187     function withdrawTokens(uint256 _id) public {
188         require(block.timestamp >= lockedToken[_id].unlockTime);
189         require(msg.sender == lockedToken[_id].withdrawalAddress);
190         require(!lockedToken[_id].withdrawn);
191         
192         
193         lockedToken[_id].withdrawn = true;
194         
195         //update balance in address
196         walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
197         
198         //remove this id from this address
199         uint256 j;
200         uint256 arrLength = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length;
201         for (j=0; j<arrLength; j++) {
202             if (depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] == _id) {
203                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][arrLength - 1];
204                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length--;
205                 break;
206             }
207         }
208         
209         // transfer tokens to wallet address
210         require(Token(lockedToken[_id].tokenAddress).transfer(msg.sender, lockedToken[_id].tokenAmount));
211         LogWithdrawal(msg.sender, lockedToken[_id].tokenAmount);
212     }
213 
214      /*get total token balance in contract*/
215     function getTotalTokenBalance(address _tokenAddress) view public returns (uint256)
216     {
217        return Token(_tokenAddress).balanceOf(this);
218     }
219     
220     /*get total token balance by address*/
221     function getTokenBalanceByAddress(address _tokenAddress, address _walletAddress) view public returns (uint256)
222     {
223        return walletTokenBalance[_tokenAddress][_walletAddress];
224     }
225     
226     /*get allDepositIds*/
227     function getAllDepositIds() view public returns (uint256[])
228     {
229         return allDepositIds;
230     }
231     
232     /*get getDepositDetails*/
233     function getDepositDetails(uint256 _id) view public returns (address _tokenAddress, address _withdrawalAddress, uint256 _tokenAmount, uint256 _unlockTime, bool _withdrawn)
234     {
235         return(lockedToken[_id].tokenAddress,lockedToken[_id].withdrawalAddress,lockedToken[_id].tokenAmount,
236         lockedToken[_id].unlockTime,lockedToken[_id].withdrawn);
237     }
238     
239     /*get DepositsByWithdrawalAddress*/
240     function getDepositsByWithdrawalAddress(address _withdrawalAddress) view public returns (uint256[])
241     {
242         return depositsByWithdrawalAddress[_withdrawalAddress];
243     }
244     
245 }