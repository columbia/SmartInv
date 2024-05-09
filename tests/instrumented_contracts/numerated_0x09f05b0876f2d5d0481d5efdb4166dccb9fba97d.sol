1 pragma solidity ^0.4.24;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   constructor() public {
6     owner = msg.sender;
7   }
8   modifier onlyOwner() {
9     require(msg.sender == owner,"Have no legal powerd");
10     _;
11   }
12   function transferOwnership(address newOwner) public onlyOwner {
13     require(newOwner != address(0));
14     emit OwnershipTransferred(owner, newOwner);
15     owner = newOwner;
16   }
17 }
18 contract ERC20Interface {
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 }
21 contract VoterFactory is Ownable{
22     using SafeMath for uint256; //uint256 library
23     mapping(address=>uint) total; //player total Voter
24     mapping(address=>mapping(uint=>uint)) totalForVoter;
25     mapping(address=>uint) balances;//player gamcoin 
26     mapping(address=>uint) playerP;//player PID
27     mapping(uint=>address) playerA;//PID to player address
28     mapping(address=>mapping(uint=>uint)) playerV;//player=>voterID=>voters
29     mapping(address=>uint) playerEth;//player=>ETHER
30     mapping(address=>address) referees;//player=>referees
31     mapping(address=>address[]) totalReferees;//referees=>totalplayer
32     mapping(address=>uint) isCreated;
33     
34     
35     event NewVoter(uint _id,uint256 _name,uint _value,uint _vectoryvalue);// new model event
36     event GiveVoter(address indexed _fromaddress,uint _toid,uint _number);// voter event
37     event gameover(bool isReady);//gameover
38     event NewPlayer(uint _id,address indexed _address);//createPlayer
39     event restart(bool isReady,uint _RID);//reboot
40     event EgiveToVoterOnlyowner(uint _toid,uint _number);
41     event EgetPlayerCoin(address indexed _address,uint256 _number,bool _bool);
42     event Ewithdraw(uint _ether);
43     event EsetFee(uint _time,uint _fee);
44     event Ebuygamecoin(uint _time,uint _number,address indexed _address);
45     event EgetEveryDayEarnings(uint _time,uint _number,uint _totalplayers,address _address);
46     
47     struct Voter{
48         uint id;
49         uint256 name;
50         uint value;
51         address[] pa;
52         uint totalplayer;
53     }
54     struct Winner{
55         uint256 name;
56         uint value;
57     }
58     Winner[] public winners;
59     Voter[] public voters;
60     Voter[] voterss;
61     uint public RID=0;
62     uint public totalRef;
63     uint public totalplayers;//total player
64     uint public ids=0;//total model
65     uint public fee = 340000000000000;//gamcoin fee
66     uint public createTime = now;//create Time
67     uint public shutTime = 0 minutes;//shutdown time
68     uint public decimals = 18; 
69     bool public started = false;
70     uint public EthOther = 100000000000000000000;
71     uint public EthOtherfee = 10000;
72     address public winnerOfplayer;
73     address[]  public _addrs;
74     ERC20Interface CDS;
75 }
76 contract VoterServiceImpl is VoterFactory{
77     function _createPlayer(address _address) internal {
78         playerA[totalplayers] = _address;
79         playerP[_address] = totalplayers;
80         totalplayers=totalplayers.add(1);
81         _addrs.push(_address);
82         emit NewPlayer(totalplayers-1,_address);
83     }
84     function _getEarnings(address _address,uint _playerTotal,uint _value,uint _oldvalue) internal {
85         uint proportion = _playerTotal.div(_oldvalue);
86         uint surplus = (_value.div(2)).add(_value.div(5));
87         balances[_address] = balances[_address].add(proportion.mul(_value.sub(surplus)));
88         totalRef = totalRef.add(proportion.mul(_value.sub(surplus)));
89     }
90     function _shutDown() internal{
91         require(now>=(createTime+shutTime),"Not over yet");
92         if(balances[owner]!=0){
93             uint256  vectoryId=0;
94             if(ids!=0){
95                 for(uint256 i=0;i<ids;i=i.add(1)){
96                     if(voters[i].value>voters[vectoryId].value){
97                         vectoryId=i;
98                     }
99                 }
100                 winners.push(Winner(voters[vectoryId].name,voters[vectoryId].value));
101                 uint vectoryValue = balances[owner];
102                 uint oldvalue = voters[vectoryId].value;
103                 for(uint256 k=0;k<voters[vectoryId].totalplayer;k=k.add(1)){
104                     address add = voters[vectoryId].pa[k];
105                     uint playerTotal = playerV[add][vectoryId];
106                     _getEarnings(add,playerTotal,vectoryValue,oldvalue);
107                 }
108                 for(uint256 j=0;j<ids;j=j.add(1)){
109                 voters[j].value=0;
110                 }
111             }
112             if(totalplayers!=0){
113                 for(uint256 s=0;s<totalplayers;s=s.add(1)){
114                     total[playerA[s]]=0;
115                     playerP[playerA[s]]=0;
116                     for(uint256 n=0;n<ids;n=n.add(1)){
117                         playerV[playerA[s]][n]=0;
118                     }
119                     playerEth[playerA[s]]=0;
120                     referees[playerA[s]];
121                     totalReferees[playerA[s]];
122                     playerA[s]=0;
123                 }
124             }
125             balances[winnerOfplayer] = balances[winnerOfplayer].add(vectoryValue.div(50));
126         }
127         totalplayers=0;
128         ids=0;
129         EthOtherfee=10000;
130         EthOther=100000000000000000000;
131         winnerOfplayer = owner;
132         voters = voterss;
133         balances[owner]=0;
134         started=false;
135     }
136     function _createVoter(uint256 _str) internal onlyOwner{
137         address[] memory p;
138         voters.push(Voter(ids,_str,0,p,0));
139         ids=ids.add(1);
140     }
141 }
142 
143 
144 contract Voterplayer is VoterServiceImpl{
145     function giveToVoter(uint _value,uint _id) public {
146         require(started);
147         require(msg.sender!=owner);
148         uint time = createTime.add(shutTime);
149         require(now<time);
150         require(_id<=ids);
151         require(msg.sender!=owner,"owner Can't vote");
152         require(balances[msg.sender]>=_value,"balances too low");
153         balances[msg.sender]=balances[msg.sender].sub(_value);
154         totalForVoter[msg.sender][_id]=totalForVoter[msg.sender][_id].add(_value);
155         if(playerV[msg.sender][_id]==0){
156             voters[_id].pa.push(msg.sender);
157             voters[_id].totalplayer=voters[_id].totalplayer.add(1);
158         }
159         if(referees[msg.sender]!=0){
160             balances[referees[msg.sender]] = balances[referees[msg.sender]].add(_value.mul(1).div(10));
161             totalRef = totalRef.add(_value.mul(1).div(10));
162         }
163         total[msg.sender]=total[msg.sender].add(_value);
164         balances[owner]=balances[owner].add(_value);
165         voters[_id].value=voters[_id].value.add(_value);
166         playerV[msg.sender][_id] = playerV[msg.sender][_id].add(_value);
167         emit GiveVoter(msg.sender,_id,_value);
168         return;
169     }
170     function createAllVoter(uint256[] _voter) public onlyOwner{
171         for(uint i=0;i<_voter.length;i=i.add(1)){
172              createVoter(_voter[i]);
173         }
174     }
175     function giveToVoterOnlyowner(uint _value,uint _id) public onlyOwner{
176         require(started);
177         voters[_id].value=voters[_id].value.add(_value);
178         balances[owner]=balances[owner].add(_value);
179         emit EgiveToVoterOnlyowner(_id,_value);
180     }
181     function getaddresstotal(uint _id) public view returns(uint){
182         return voters[_id].totalplayer;
183     }
184     function getTotalForVoter(address _address,uint _id) view public returns(uint){
185         return totalForVoter[_address][_id];
186     } 
187     function getTotalVoter(address _address) view public returns(uint totals){
188         return total[_address];
189     }
190     function balanceOf(address _address) view public returns(uint balance){
191         return balances[_address];
192     }
193     function refereesOf(address _address) view public returns(address[]){
194         return totalReferees[_address];
195     }
196     function getAllPlayer() view public returns(address[]){
197         return _addrs;
198     }
199     function buyGameCoin(uint256 _number,address _address) public payable{
200         require(started);
201         require(msg.sender!=owner);
202         uint256  coinfee = _number.div(10).mul(fee);
203         require(msg.value>=coinfee);
204         if(msg.sender!=_address&&referees[msg.sender]==0){
205             require(balances[_address]>0);
206             balances[_address] = balances[_address].add((_number.mul(30).div(100)).mul(1).div(10));
207             totalRef = totalRef.add(_number.mul(10).div(100));
208             referees[msg.sender] = _address;
209             totalReferees[_address].push(msg.sender);
210         }else if(msg.sender==_address&&referees[msg.sender]!=0){
211             balances[referees[msg.sender]] = balances[referees[msg.sender]].add((_number.mul(30).div(100)).mul(1).div(10));
212             totalRef = totalRef.add((_number.mul(30).div(100)).mul(1).div(10));
213         }
214         total[msg.sender] = total[msg.sender].add(_number.mul(30).div(100));
215         if(isCreated[msg.sender]==0){
216             isCreated[msg.sender] = 1;
217             _createPlayer(msg.sender);
218         }
219         balances[msg.sender]=balances[msg.sender].add(_number.mul(70).div(100));
220         balances[owner] = balances[owner].add(_number.mul(30).div(100));
221         if(playerEth[owner]>=EthOther){
222             EthOtherfee=EthOtherfee.mul(2);
223             EthOther = EthOther.mul(3);
224         }
225         fee=fee.add(fee.div(EthOtherfee.mul(1000)).mul((msg.value.sub(msg.value%1000000000000000)).div(1000000000000000)));
226         playerEth[owner] = playerEth[owner].add(msg.value);
227         msg.sender.transfer(msg.value.sub(coinfee));
228         owner.transfer(coinfee);
229         shutTime = shutTime.add(_number.div(10));
230         winnerOfplayer = msg.sender;
231         emit Ebuygamecoin(now,_number,_address);
232     }
233     function getPlayerCoin(uint256 _number) external {
234         require(balances[msg.sender]>=_number);
235         balances[msg.sender] = balances[msg.sender].sub(_number);
236         uint256 _token = _number.div(10).mul(10**decimals);
237         require(CDS.transferFrom(owner,msg.sender,_token));
238         emit EgetPlayerCoin(msg.sender,_number,true);
239     }
240     function createVoter(uint256 _name) public onlyOwner{
241         _createVoter(_name);
242         emit NewVoter(ids-1,_name,0,0);
243     }
244     function startGame(uint _time,address _address,uint256 _decimals) public onlyOwner{
245         require(!started);
246         require(_address!=address(0));
247         CDS=ERC20Interface(_address);
248         decimals=_decimals;
249         createTime=now;
250         shutTime= _time;
251         RID=RID.add(1);
252         started=true;
253         totalRef=0;
254         emit restart(started,RID);
255     }
256     function setTime(uint _time) public onlyOwner{
257         require(started);
258         shutTime= _time;
259     }
260     function setFee(uint _fee) public onlyOwner{
261         fee=_fee;
262         emit EsetFee(now,_fee);
263     }
264     function gameOver() public onlyOwner{
265         _shutDown();
266         emit gameover(true);
267     }
268     function withdraw() external onlyOwner {
269         address myAddress = address(this);
270         owner.transfer(myAddress.balance);
271         emit Ewithdraw(myAddress.balance);
272     }
273     function setCDStokenAddress(address _address,uint256 _decimals) public onlyOwner{
274        require(_address!=address(0));
275         decimals=_decimals;
276         CDS=ERC20Interface(_address);
277     }
278     
279     function getEveryDayEarnings(address _address,uint256 _number) public onlyOwner{
280         require(balances[owner]>=_number);
281         totalRef=totalRef.add(_number.mul(2));
282         balances[_address]=balances[_address].add(_number);
283         if(totalplayers!=0){
284                 for(uint256 s=0;s<totalplayers;s=s.add(1)){
285                     if(total[playerA[s]]==0){
286                         continue;
287                     }
288                     balances[playerA[s]] = balances[playerA[s]].add(_number.mul(total[playerA[s]]).div(balances[owner]));
289                 }
290             }
291         emit EgetEveryDayEarnings(now,_number,totalplayers,_address);
292     }
293     
294 }
295 library SafeMath {
296   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297     if (a == 0) {
298       return 0;
299     }
300     uint256 c = a * b;
301     assert(c / a == b);
302     return c;
303   }
304   function div(uint256 a, uint256 b) internal pure returns (uint256) {
305     uint256 c = a / b;
306     return c;
307   }
308   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309     assert(b <= a);
310     return a - b;
311   }
312   function add(uint256 a, uint256 b) internal pure returns (uint256) {
313     uint256 c = a + b;
314     assert(c >= a);
315     return c;
316   }
317 }