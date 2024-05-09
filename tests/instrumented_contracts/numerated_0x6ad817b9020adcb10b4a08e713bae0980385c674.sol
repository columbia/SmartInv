1 pragma solidity ^0.4.20;
2 //**양종만**정병두**//180419~
3 /*모든 행위는 1wei단위로 되기때문에 주의해야됨
4 ex :
5 총 발행 토큰 111
6 소수점18자리로 했을때 토탈 토큰 111 000 000 000 000 000 000(wei단위임)
7 1토큰 전송
8 남은 토큰 110999999999999999999
9 토큰Value * 10 ** uint256(소수점자리수)로 미리 계산하면 1토큰 전송시 110 000 000 000 000 000 000
10 */
11 //기본 소수점 자리 18 / 변경되면 payable , transfer에서 달라질수 있으니 주의
12 //들어오는 이더리움 단위는 1ETH=1000000000000000000Wei 이더 소수점 단위18이기 때문에 소수점 단위가18이 아니면 payable, transfer 함수 주의 해야됨
13 //** public이 들어간 변수,함수는 일반 사용자들도 볼수있음**//
14 contract TokenERC20
15 {
16   //토큰 이름
17   string public name;
18   //토큰 심볼(단위)
19   string public symbol;
20   //토큰 단위 소수점 표현
21   uint8 public decimals;
22   //wei 단위를 편하게 하기 위한 변수
23   uint256 _decimals;
24   //이더*2=토큰
25   uint256 public tokenReward;
26   //총 토큰 발행 갯수
27   uint256 public totalSupply;
28   //토큰 admin
29   address public owner;
30   //토큰 상태 (text로 보여주기 위한것) ex :  private ,  public , test , demo
31   string public status;
32   //이더 입금 제한 타임스탬프 (시작시간) // http://www.4webhelp.net/us/timestamp.php 에서 확인가능
33   uint256 public start_token_time;
34   //이더 입금 제한 타임스탬프 (종료시간)
35   uint256 public stop_token_time;
36   ///////GMB 토큰은 3자끼리 토큰 이동을 미지원 할것이기 때문에 추가함!!
37   uint256 public transferLock;
38 
39   //owner인지 검사하는 부분
40   modifier isOwner
41   {
42     assert(owner == msg.sender);
43     _;
44   }
45 
46   //외부에서 호출할수 있게 하는것(MIST UI로 확인가능)
47   mapping (address => uint256) public balanceOf;
48 
49   //이벤트 기록을 위한것
50   event Transfer(address indexed from, address indexed to, uint256 value);
51   event token_Burn(address indexed from, uint256 value);
52   event token_Add(address indexed from, uint256 value);
53   event Deposit(address _sender, uint amount ,string status);
54   event change_Owner(string newOwner);
55   event change_Status(string newStatus);
56   event change_Name(string newName);
57   event change_Symbol(string newSymbol);
58   event change_TokenReward(uint256 newTokenReward);
59   event change_Time_Stamp(uint256 change_start_time_stamp,uint256 change_stop_time_stamp);
60 
61   //토큰 초기화 함수
62   function TokenERC20() public
63   {
64     //토큰 이름 초기화
65     name = "GMB";
66     //토큰 심볼(단위) 초기화
67     symbol = "MAS";
68     //소수점 자리 초기화
69     decimals = 18;
70     //wei 단위를 편하게 하기 위한 변수
71     _decimals = 10 ** uint256(decimals);
72     //ETH , 토큰 환산비율
73     tokenReward = 0;
74     //토큰 발행 갯수 초기화
75     totalSupply =  _decimals * 10000000000; //1백억개
76     //토큰 상태 초기화
77     status = "Private";
78     //타임스탬프 초기화 (시작시간) 2018.1.1 00:00:00 (Gmt+9)
79     start_token_time = 1514732400;
80     //타임스탬프 초기화 (종료시간)  2018.12.31 23:59:59 (Gmt+9)
81     stop_token_time = 1546268399;
82     //토큰 관리자 지갑 주소 초기화
83     owner = msg.sender;
84     //발행된 토큰갯수를 토큰생성지갑에 입력
85     balanceOf[msg.sender] = totalSupply;
86     ///////GMB 토큰은 제3자끼리 토큰 이동을 미지원 할것이기 때문에 추가함!!
87     transferLock = 1; //0일때만 transfer 가능
88   }
89   //*이더 받으면 토큰 전송*//
90   function() payable public
91   {
92     //환산값 변수
93     uint256 cal;
94     //이더 입금 제한 타임스탬프 (시작시간)
95     require(start_token_time < block.timestamp);
96     //이더 입금 제한 타임스탬프 (종료시간)
97     require(stop_token_time > block.timestamp);
98     //ETH보낸사람,ETH코인수 이벤트에 기록
99     emit Deposit(msg.sender, msg.value, status);
100     //토큰=이더*2
101     cal = (msg.value)*tokenReward;
102     //토큰 지갑에서 남아있는 토큰수가 보내려는 토큰보다 많은지 검사
103     require(balanceOf[owner] >= cal);
104     //오버플로어 검사
105     require(balanceOf[msg.sender] + cal >= balanceOf[msg.sender]);
106     //토큰지갑에서 차감
107     balanceOf[owner] -= cal;
108     //받는 사람지갑에 토큰 저장
109     balanceOf[msg.sender] += cal;
110     //이벤트 기록을 남김
111     emit Transfer(owner, msg.sender, cal);
112   }
113   //*토큰 전송*// ex : 1토큰 추가시 1 000 000 000 000 000 000(Mist UI 관리자 페이지에서도 동일, Mist UI 일반 사용자 보내기에서는 1)
114   function transfer(address _to, uint256 _value) public
115   {
116     ///////GMB 토큰은 제3자끼리 토큰 이동을 미지원 할것이기 때문에 추가함!!
117     require(transferLock == 0); //0일때만 transfer 가능
118     //토큰 지갑에서 남아있는 토큰수가 보내려는 토큰보다 많은지 검사
119     require(balanceOf[msg.sender] >= _value);
120     //오버플로어 검사
121     require((balanceOf[_to] + _value) >= balanceOf[_to]);
122     //토큰지갑에서 차감
123     balanceOf[msg.sender] -= _value;
124     //받는 사람지갑에 토큰 저장
125     balanceOf[_to] += _value;
126     //이벤트 기록을 남김
127     emit Transfer(msg.sender, _to, _value);
128   }
129   //*토큰 전송 geth에서 편하게 보내기위해 __decimals을 붙여줌*// ex : 1토큰 전송시 1
130   function admin_transfer(address _to, uint256 _value) public isOwner
131   {
132     //tokenValue = _value;
133     //토큰 지갑에서 남아있는 토큰수가 보내려는 토큰보다 많은지 검사
134     require(balanceOf[msg.sender] >= _value*_decimals);
135     //오버플로어 검사
136     require(balanceOf[_to] + (_value *_decimals)>= balanceOf[_to]);
137     //토큰지갑에서 차감
138     balanceOf[msg.sender] -= _value*_decimals;
139     //받는 사람지갑에 토큰 저장
140     balanceOf[_to] += _value*_decimals;
141     //이벤트 기록을 남김
142     emit Transfer(msg.sender, _to, _value*_decimals);
143   }
144   //*지갑에서 지갑으로 토큰 이동* 회수용// ex : 1토큰 회수시 1
145   function admin_from_To_transfer(address _from, address _to, uint256 _value) public isOwner
146   {
147     //tokenValue = _value;
148     //토큰 지갑에서 남아있는 토큰수가 보내려는 토큰보다 많은지 검사
149     require(balanceOf[_from] >= _value*_decimals);
150     //오버플로어 검사
151     require(balanceOf[_to] + (_value *_decimals)>= balanceOf[_to]);
152     //토큰지갑에서 차감
153     balanceOf[_from] -= _value*_decimals;
154     //받는 사람지갑에 토큰 저장
155     balanceOf[_to] += _value*_decimals;
156     //이벤트 기록을 남김
157     emit Transfer(_from, _to, _value*_decimals);
158   }
159   //*총 발행 토큰 소각*// ex : 1토큰 소각시 1
160   function admin_token_burn(uint256 _value) public isOwner returns (bool success)
161   {
162     //남아있는 토큰수보다 소각하려는 토큰수가 많은지 검사
163     require(balanceOf[msg.sender] >= _value*_decimals);
164     //토큰 지갑에서 차감
165     balanceOf[msg.sender] -= _value*_decimals;
166     //총 발행 토큰에서 차감
167     totalSupply -= _value*_decimals;
168     //이벤트 기록을 남김
169     emit token_Burn(msg.sender, _value*_decimals);
170     return true;
171   }
172   //*총 발행 토큰 추가*// ex : 1토큰 추가시 1
173   function admin_token_add(uint256 _value) public  isOwner returns (bool success)
174   {
175     require(balanceOf[msg.sender] >= _value*_decimals);
176     //토큰 지갑에서 더함
177     balanceOf[msg.sender] += _value*_decimals;
178     //총 발행 토큰에서 더함
179     totalSupply += _value*_decimals;
180     //이벤트 기록을 남김
181     emit token_Add(msg.sender, _value*_decimals);
182     return true;
183   }
184   //*이름 변경*//  ***토큰으로 등록된 후에는 이더스캔에서 반영이 안됨(컨트랙트 등록 상태에서는 괜찮음)***
185   function change_name(string _tokenName) public isOwner returns (bool success)
186   {
187     //name 변경해준다
188     name = _tokenName;
189     //이벤트 기록을 남김
190     emit change_Name(name);
191     return true;
192   }
193   //*심볼 변경*//  ***토큰으로 등록된 후에는 이더스캔에서 반영이 안됨(컨트랙트 등록 상태에서는 괜찮음)***
194   function change_symbol(string _symbol) public isOwner returns (bool success)
195   {
196     //symbol 변경해준다
197     symbol = _symbol;
198     //이벤트 기록을 남김
199     emit change_Symbol(symbol);
200     return true;
201   }
202   //*status변경*//
203   function change_status(string _status) public isOwner returns (bool success)
204   {
205     //status 변경해준다
206     status = _status;
207     //이벤트 기록을 남김
208     emit change_Status(status);
209     return true;
210   }
211   //*배율 변경*//
212   function change_tokenReward(uint256 _tokenReward) public isOwner returns (bool success)
213   {
214     //tokenReward 변경해준다
215     tokenReward = _tokenReward;
216     //이벤트 기록을 남김
217     emit change_TokenReward(tokenReward);
218     return true;
219   }
220   //*ETH출금*//
221   function ETH_withdraw(uint256 amount) public isOwner returns(bool)
222   {
223     //소수점까지 출금해야되기 때문에 wei단위로 출금 //1ETH 출금시 1 000 000 000 000 000 000 입력 해야됨
224     owner.transfer(amount);
225     //출금하는건 일반 사용자가 알아야될 필요가 없기때문에 emit 이벤트를 실행하지 않음
226     return true;
227   }
228   //*time_stamp변경*//
229   function change_time_stamp(uint256 _start_token_time,uint256 _stop_token_time) public isOwner returns (bool success)
230   {
231     //start_token_time을 변경해준다
232     start_token_time = _start_token_time;
233     //stop_token_time을 변경해준다
234     stop_token_time = _stop_token_time;
235 
236     //이벤트 기록을 남김
237     emit change_Time_Stamp(start_token_time,stop_token_time);
238     return true;
239   }
240   //*owner변경*//
241   function change_owner(address to_owner) public isOwner returns (bool success)
242   {
243     //owner를 변경해준다
244     owner = to_owner;
245     //이벤트 기록을 남김
246     emit change_Owner("Owner_change");
247     return true;
248   }
249   //*transferLock변경*// 0일때만 lock 풀림
250   function setTransferLock(uint256 transferLock_status) public isOwner returns (bool success)
251   {
252     //transferLock 변경해준다
253     transferLock = transferLock_status;
254     //transferLock은 일반 사용자가 알아야될 필요가 없기때문에 emit 이벤트를 실행하지 않음
255     return true;
256   }
257   //*time_stamp변경,status 변경*//
258   function change_time_stamp_status(uint256 _start_token_time,uint256 _stop_token_time,string _status) public isOwner returns (bool success)
259   {
260     //start_token_time을 변경해준다
261     start_token_time = _start_token_time;
262     //stop_token_time을 변경해준다
263     stop_token_time = _stop_token_time;
264     //status 변경해준다
265     status = _status;
266     //이벤트 기록을 남김
267     emit change_Time_Stamp(start_token_time,stop_token_time);
268     //이벤트 기록을 남김
269     emit change_Status(status);
270     return true;
271   }
272 }