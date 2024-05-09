1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Constant {
34     function balanceOf( address who ) view public returns (uint value);
35 }
36 contract ERC20Stateful {
37     function transfer( address to, uint value) public returns (bool ok);
38 }
39 contract ERC20Events {
40     event Transfer(address indexed from, address indexed to, uint value);
41 }
42 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
43 
44 contract Owned {
45     address public owner;
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner,"owner only");
53         _;
54     }
55 
56     function transferOwnership(address newOwner) public onlyOwner {
57         owner = newOwner;
58     }
59 }
60 
61 contract WhitelistSale is Owned {
62 
63     ERC20 public blocToken;
64 
65     uint256 public blocPerEth;
66     
67     bool running;
68 
69     mapping(address => bool) public whitelisted;
70 
71     mapping(address => uint256) public bought;
72     
73     mapping(address => uint256) public userLimitAmount;
74     
75     mapping(address => bool) public whitelistUserGettedBloc;
76         
77     mapping(address => bool) public whitelistUserGettedEthBack;
78     
79     uint256 rebackRate; // 0-10000
80     uint256 constant MaxRate = 10000; 
81     address public receiver;
82     address[] private whitelistUsers;
83     uint256 constant public maxGasPrice = 50000000000;
84 
85     event LogWithdrawal(uint256 _value);
86     event LogBought(uint orderInMana);
87     // event LogUserAdded(address user);
88     event LogUserRemoved(address user);
89 
90     constructor(
91         address _receiver
92     ) public Owned()
93     {
94         blocToken;
95         receiver         = _receiver;
96         blocPerEth       = 0;
97         whitelistUsers   = new address[](0);
98         rebackRate       = 0;
99         running          = true;
100     }
101     
102     function getRebackRate() public view returns (uint256 rate) {
103         return rebackRate;
104     }
105     
106     function changePerEthToBlocNumber(uint256 _value)  public onlyOwner {
107         require(_value > 0,"ratio must > 0");
108         blocPerEth = _value;
109     }
110     
111     function changeRebackRate(uint256 _rate)  public onlyOwner {
112         require(_rate > 0,"refundrate must > 0");
113         require(_rate < MaxRate,"refundrate must < 10000");
114         rebackRate = _rate;
115     }
116     
117     function changeBlocTokenAdress(ERC20 _tokenContractAddress)  public onlyOwner {
118         blocToken = _tokenContractAddress;
119     }
120     
121     function withdrawEth(uint256 _value)  public onlyOwner {
122         require(receiver != address(0),"receiver not set");
123         receiver.transfer(_value);
124     }
125 
126     function withdrawBloc(uint256 _value)  public onlyOwner  returns (bool ok) {
127         require(blocToken != address(0),"token contract not set");
128         return withdrawToken(blocToken, _value);
129     }
130 
131     function withdrawToken(address _token, uint256 _value) private onlyOwner  returns (bool ok) {
132         bool result = ERC20(_token).transfer(owner,_value);
133         if (result) emit LogWithdrawal(_value);
134         return result;
135     }
136 
137     function changeReceiver(address _receiver) public onlyOwner {
138         require(_receiver != address(0),"empty receiver");
139         receiver = _receiver;
140     }
141     
142     function changeBlocPerEth(uint256 _value) public onlyOwner {
143         require(_value != 0,"ratio should > 0");
144         blocPerEth = _value;
145     }
146     
147     function changeRuningState(bool _value) public onlyOwner {
148         running = _value;
149     }
150     
151     modifier onlyIsRuning {
152         require(running,"KYC over");
153         _;
154     }
155 
156     function buy() private onlyIsRuning {
157         require(whitelisted[msg.sender],"not whitelisted");
158         require(whitelistUserGettedBloc[msg.sender] == false,"token already sent");
159         require(msg.value >= 0.2 ether,"must greater or equal to 0.2 eth");
160 
161         uint256 allowedForSender = SafeMath.sub(userLimitAmount[msg.sender], bought[msg.sender]);
162         if (msg.value > allowedForSender) revert("over limit amount");
163         // receiver.transfer(msg.value);
164         bought[msg.sender] = SafeMath.add(bought[msg.sender], msg.value);
165     }
166     
167     function transferBlocToUser(address userAddress) public onlyOwner {
168         require(rebackRate < MaxRate,"refundrate overflow");
169         require(blocPerEth > 0,"token ratio not set");
170         require(whitelistUserGettedBloc[userAddress] == false,"token already sent");
171         require(bought[userAddress] > 0,"not bought");
172              
173         uint256 bountPerEth = SafeMath.mul( blocPerEth , (MaxRate - rebackRate));
174         uint orderInBloc = SafeMath.mul(SafeMath.div(bought[userAddress],MaxRate),bountPerEth) ;
175             
176         uint256 balanceInBloc = blocToken.balanceOf(address(this));
177         if (orderInBloc > balanceInBloc) revert("not enough token");
178         if (blocToken.transfer(userAddress, orderInBloc)) whitelistUserGettedBloc[userAddress] = true;
179     }
180     
181     function transferEthBackToUser(address userAddress) public onlyOwner {
182         require(rebackRate > 0,"refundrate not set");
183         require(whitelistUserGettedEthBack[userAddress] == false,"token already sent");
184         require(bought[userAddress] > 0,"not bought");
185              
186         uint backEthNumber = SafeMath.mul(SafeMath.div(bought[userAddress],MaxRate),rebackRate) ;
187         whitelistUserGettedEthBack[userAddress] = true;
188         userAddress.transfer(backEthNumber);
189     }
190     
191 
192     function addUser(address user,uint amount) public onlyOwner onlyIsRuning {
193         if (whitelisted[user] == true) {
194             if (userLimitAmount[user] != amount) {
195                 userLimitAmount[user] = amount;
196             }
197             return;
198         }
199         
200         whitelisted[user] = true;
201         whitelistUsers.push(user);
202         userLimitAmount[user] = amount;
203         whitelistUserGettedBloc[user] = false;
204         whitelistUserGettedEthBack[user] = false;
205         // emit LogUserAdded(user);
206     }
207 
208     function removeUser(address user) public onlyOwner onlyIsRuning {
209         whitelisted[user] = false;
210         emit LogUserRemoved(user);
211     }
212 
213     function addManyUsers(address[] users,uint[] amounts) public onlyOwner onlyIsRuning {
214         require(users.length < 10000,"list too long");
215         require(users.length == amounts.length, "users' length != amounts' length");
216         
217         for (uint index = 0; index < users.length; index++) {
218             addUser(users[index],amounts[index]);
219         }
220     }
221 
222     function() public payable onlyIsRuning {
223         require(tx.gasprice <= maxGasPrice,"gas price must not greater than 50GWei");
224         buy();
225     }
226     
227     function getWhiteUsers() public view onlyOwner returns(address[] whitelistUsersResult) {
228         return whitelistUsers;
229     }
230 
231 
232     function getWhiteUsersFrom(uint index, uint size) public view onlyOwner returns(address[] whitelistUsersResult) {
233         address[] memory slice = new address[](size);
234         uint idx = 0;
235         for (uint i = index; idx < size && i < whitelistUsers.length; i++) {
236             slice[idx] = whitelistUsers[i];
237             idx++;
238         }
239         return slice;
240     }
241 }