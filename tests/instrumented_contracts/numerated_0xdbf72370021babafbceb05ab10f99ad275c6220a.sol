1 pragma solidity ^0.4.25;
2 
3 /**
4  * Team Token Lockup
5 */
6 
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
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     require(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a / b;
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     require(c >= a);
39     return c;
40   }
41 
42   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
43     uint256 c = add(a,m);
44     uint256 d = sub(c,1);
45     return mul(div(d,m),m);
46   }
47 }
48 
49 contract owned {
50         address public owner;
51 
52         constructor() public {
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
89      * Constrctor function
90     */
91     constructor() public {
92         
93     }
94     
95     /**
96      *lock tokens
97     */
98     function lockTokens(address _tokenAddress, uint256 _amount, uint256 _unlockTime) public returns (uint256 _id) {
99         require(_amount > 0, 'token amount is Zero');
100         require(_unlockTime < 10000000000, 'Enter an unix timestamp in seconds, not miliseconds');
101         require(Token(_tokenAddress).approve(this, _amount), 'Approve tokens failed');
102         require(Token(_tokenAddress).transferFrom(msg.sender, this, _amount), 'Transfer of tokens failed');
103         
104         //update balance in address
105         walletTokenBalance[_tokenAddress][msg.sender] = walletTokenBalance[_tokenAddress][msg.sender].add(_amount);
106         
107         address _withdrawalAddress = msg.sender;
108         _id = ++depositId;
109         lockedToken[_id].tokenAddress = _tokenAddress;
110         lockedToken[_id].withdrawalAddress = _withdrawalAddress;
111         lockedToken[_id].tokenAmount = _amount;
112         lockedToken[_id].unlockTime = _unlockTime;
113         lockedToken[_id].withdrawn = false;
114         
115         allDepositIds.push(_id);
116         depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
117     }
118     
119     /**
120      *withdraw tokens
121     */
122     function withdrawTokens(uint256 _id) public {
123         require(block.timestamp >= lockedToken[_id].unlockTime, 'Tokens are locked');
124         require(msg.sender == lockedToken[_id].withdrawalAddress, 'Can withdraw by withdrawal Address only');
125         require(!lockedToken[_id].withdrawn, 'Tokens already withdrawn');
126         require(Token(lockedToken[_id].tokenAddress).transfer(msg.sender, lockedToken[_id].tokenAmount), 'Transfer of tokens failed');
127         
128         lockedToken[_id].withdrawn = true;
129         
130         //update balance in address
131         walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
132         
133         //remove this id from this address
134         uint256 i; uint256 j;
135         for(j=0; j<depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length; j++){
136             if(depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] == _id){
137                 for (i = j; i<depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length-1; i++){
138                     depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][i] = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][i+1];
139                 }
140                 depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length--;
141                 break;
142             }
143         }
144         emit LogWithdrawal(msg.sender, lockedToken[_id].tokenAmount);
145     }
146 
147      /*get total token balance in contract*/
148     function getTotalTokenBalance(address _tokenAddress) view public returns (uint256)
149     {
150        return Token(_tokenAddress).balanceOf(this);
151     }
152     
153     /*get total token balance by address*/
154     function getTokenBalanceByAddress(address _tokenAddress, address _walletAddress) view public returns (uint256)
155     {
156        return walletTokenBalance[_tokenAddress][_walletAddress];
157     }
158     
159     /*get allDepositIds*/
160     function getAllDepositIds() view public returns (uint256[])
161     {
162         return allDepositIds;
163     }
164     
165     /*get getDepositDetails*/
166     function getDepositDetails(uint256 _id) view public returns (address, address, uint256, uint256, bool)
167     {
168         return(lockedToken[_id].tokenAddress,lockedToken[_id].withdrawalAddress,lockedToken[_id].tokenAmount,
169         lockedToken[_id].unlockTime,lockedToken[_id].withdrawn);
170     }
171     
172     /*get DepositsByWithdrawalAddress*/
173     function getDepositsByWithdrawalAddress(address _withdrawalAddress) view public returns (uint256[])
174     {
175         return depositsByWithdrawalAddress[_withdrawalAddress];
176     }
177     
178 }