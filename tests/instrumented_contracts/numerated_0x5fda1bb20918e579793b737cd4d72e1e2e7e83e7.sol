1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20 
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53 
54    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b != 0, errorMessage);
56         return a % b;
57     }
58 }
59 
60 contract Ownable {
61     address public owner;
62     address public newowner;
63     address public admin;
64     address public dev;
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74     
75     modifier onlyNewOwner {
76         require(msg.sender == newowner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newowner = _newOwner;
82     }
83     
84     function takeOwnership() public onlyNewOwner {
85         owner = newowner;
86     }    
87     
88     function setAdmin(address _admin) public onlyOwner {
89         admin = _admin;
90     }
91 
92     function setDev(address _dev) public onlyOwner {
93         dev = _dev;
94     }
95     
96     modifier onlyAdmin {
97         require(msg.sender == admin || msg.sender == owner);
98         _;
99     }
100     
101     modifier onlyDev {
102         require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
103         _;
104     }
105 }
106 
107 abstract contract ContractConn{
108     function transfer(address _to, uint _value) virtual public;
109     function transferFrom(address _from, address _to, uint _value) virtual public;
110     function balanceOf(address who) virtual public view returns (uint);
111     function burn(uint256 _value) virtual public returns(bool);
112 }
113 
114 contract Pledge is Ownable {
115 
116     using SafeMath for uint256;
117     
118     struct PledgeInfo {
119         uint256 id;
120         address pledgeor;
121         string  coinType;
122         uint256 amount;
123         uint256 pledgeTime;
124         uint256 pledgeBlock;
125         uint256 ExpireBlock;
126         bool    isValid;
127     }
128     
129     ContractConn public zild;
130     
131     uint256 public pledgeBlock = 90000;
132     uint256 public pledgeBlockChange = 0;
133     uint256 public changePledgeTime;
134     bool    public needChangeTime = false; 
135 	uint256 public burnCount = 0;
136     uint256 public totalPledge;
137     
138     mapping(address => PledgeInfo[]) public zild_pledge;
139     mapping(address => uint256) public user_pledge_amount;
140 
141     event SetPledgeBlock(uint256 pblock,address indexed who,uint256 time);
142     event EffectPledgeBlock(uint256 pblock,address indexed who,uint256 time);
143     event WithdrawZILD(address indexed to,uint256 pamount,uint256 time);
144     event NeedBurnPledge(address indexed to,uint256 pleid,uint256 pamount);
145     event BurnPledge(address  indexed from,uint256 pleid,uint256 pamount);
146     event PledgeZILD(address indexed from,uint256 pleid,uint256 pamount,uint256 bblock,uint256 eblock,uint256 time);
147     
148     constructor(address _zild) public {
149         zild = ContractConn(_zild);
150     }
151 
152     function setpledgeblock(uint256 _block) public onlyAdmin {
153         require(_block > 0,"Pledge: New pledge time must be greater than 0");
154         pledgeBlockChange = _block;
155         changePledgeTime = block.number;
156         needChangeTime = true;
157         emit SetPledgeBlock(_block,msg.sender,now);
158     }
159 
160     function effectblockchange() public onlyAdmin {
161         require(needChangeTime,"Pledge: No new deposit time are set");
162         uint256 currentTime = block.number;
163         uint256 effectTime = changePledgeTime.add(pledgeBlock);
164         if (currentTime < effectTime) return;
165         pledgeBlock = pledgeBlockChange;
166         needChangeTime = false;
167         emit EffectPledgeBlock(pledgeBlockChange,msg.sender,now);
168     }
169     
170 
171     function burn(uint256 _amount) public onlyAdmin returns(bool) {
172         require(_amount > 0 || _amount < burnCount, "pledgeBurn：The amount exceeds the amount that should be burned");
173         zild.burn(_amount);
174         burnCount = burnCount.sub(_amount);
175         emit BurnPledge(address(msg.sender),_amount,now);
176         return true;
177     }
178 
179     function pledgeZILD(uint256 _amount) public returns(uint256){
180         zild.transferFrom(address(msg.sender), address(this), _amount);
181         uint256 length = zild_pledge[msg.sender].length;
182         zild_pledge[msg.sender].push(
183             PledgeInfo({
184                 id: length,
185                 pledgeor: msg.sender,
186                 coinType: "zild",
187                 amount: _amount,
188                 pledgeTime: now,
189                 pledgeBlock: block.number,
190                 ExpireBlock: block.number.add(pledgeBlock),
191                 isValid: true
192             })
193         );
194         user_pledge_amount[msg.sender] = user_pledge_amount[msg.sender].add(_amount); 
195         totalPledge = totalPledge.add(_amount);
196         emit PledgeZILD(msg.sender,length,_amount,block.number,block.number.add(pledgeBlock),now);
197         return length;
198     }
199 
200     function invalidPledge(address _user, uint256 _id) public onlyDev {
201         require(zild_pledge[_user].length > _id);
202         zild_pledge[_user][_id].isValid = false;
203     }
204     
205     function validPledge(address _user, uint256 _id) public onlyAdmin{
206         require(zild_pledge[_user].length > _id);
207         zild_pledge[_user][_id].isValid = true;
208     }
209     
210     function pledgeCount(address _user)  view public returns(uint256) {
211         require(msg.sender == _user || msg.sender == owner, "Pledge: Only check your own pledge records");
212         return zild_pledge[_user].length;
213     }
214  
215      function pledgeAmount(address _user)  view public returns(uint256) {
216         require(msg.sender == _user || msg.sender == owner, "Pledge: Only check your own pledge records");
217         return user_pledge_amount[_user];
218     }
219     
220     function clearInvalidOrder(address _user, uint256 _pledgeId) public onlyAdmin{
221         PledgeInfo memory pledgeInfo = zild_pledge[address(_user)][_pledgeId];
222         if(!pledgeInfo.isValid) {
223             burnCount = burnCount.add(pledgeInfo.amount);
224             user_pledge_amount[_user] = user_pledge_amount[_user].sub(pledgeInfo.amount); 
225             totalPledge = totalPledge.sub(pledgeInfo.amount);
226             zild_pledge[address(_user)][_pledgeId].amount = 0;
227             emit NeedBurnPledge(_user,_pledgeId,pledgeInfo.amount);
228         }
229     }
230  
231     function withdrawZILD(uint256 _pledgeId) public returns(bool){
232         PledgeInfo memory info = zild_pledge[msg.sender][_pledgeId]; 
233         require(block.number > info.ExpireBlock, "The withdrawal block has not arrived!");
234         require(info.isValid, "The withdrawal pledge has been breached!");
235         zild.transfer(msg.sender,info.amount);
236         user_pledge_amount[msg.sender] = user_pledge_amount[msg.sender].sub(info.amount); 
237         totalPledge = totalPledge.sub(info.amount);
238         zild_pledge[msg.sender][_pledgeId].amount = 0;
239         emit WithdrawZILD(msg.sender,zild_pledge[msg.sender][_pledgeId].amount,now);
240         return true;
241     }
242 }