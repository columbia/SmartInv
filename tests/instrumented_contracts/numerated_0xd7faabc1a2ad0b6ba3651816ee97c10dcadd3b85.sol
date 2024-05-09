1 pragma solidity ^0.4.8;
2 
3 // 소유자 관리용 계약
4 contract Owned {
5     // 상태 변수
6     address public owner; // 소유자 주소
7 
8     // 소유자 변경 시 이벤트
9     event TransferOwnership(address oldaddr, address newaddr);
10 
11     // 소유자 한정 메서드용 수식자
12     modifier onlyOwner() { if (msg.sender != owner) return; _; }
13 
14     // 생성자
15     function Owned() public {
16         owner = msg.sender; // 처음에 계약을 생성한 주소를 소유자로 한다
17     }
18     
19     // (1) 소유자 변경
20     function transferOwnership(address _new) onlyOwner public {
21         address oldaddr = owner;
22         owner = _new;
23         emit TransferOwnership(oldaddr, owner);
24     }
25 }
26 
27 // (2) 회원 관리용 계약
28 contract Members is Owned {
29     // (3) 상태 변수 선언
30     address public coin; // 토큰(가상 화폐) 주소
31     MemberStatus[] public status; // 회원 등급 배열
32     mapping(address => History) public tradingHistory; // 회원별 거래 이력
33      
34     // (4) 회원 등급용 구조체
35     struct MemberStatus {
36         string name; // 등급명
37         uint256 times; // 최저 거래 회수
38         uint256 sum; // 최저 거래 금액
39         int8 rate; // 캐시백 비율
40     }
41     // 거래 이력용 구조체
42     struct History {
43         uint256 times; // 거래 회수
44         uint256 sum; // 거래 금액
45         uint256 statusIndex; // 등급 인덱스
46     }
47  
48     // (5) 토큰 한정 메서드용 수식자
49     modifier onlyCoin() { if (msg.sender == coin) _; }
50      
51     // (6) 토큰 주소 설정
52     function setCoin(address _addr) onlyOwner public {
53         coin = _addr;
54     }
55      
56     // (7) 회원 등급 추가
57     function pushStatus(string _name, uint256 _times, uint256 _sum, int8 _rate) onlyOwner public {
58         status.push(MemberStatus({
59             name: _name,
60             times: _times,
61             sum: _sum,
62             rate: _rate
63         }));
64     }
65  
66     // (8) 회원 등급 내용 변경
67     function editStatus(uint256 _index, string _name, uint256 _times, uint256 _sum, int8 _rate) onlyOwner public {
68         if (_index < status.length) {
69             status[_index].name = _name;
70             status[_index].times = _times;
71             status[_index].sum = _sum;
72             status[_index].rate = _rate;
73         }
74     }
75      
76     // (9) 거래 내역 갱신
77     function updateHistory(address _member, uint256 _value) onlyCoin public {
78         tradingHistory[_member].times += 1;
79         tradingHistory[_member].sum += _value;
80         // 새로운 회원 등급 결정(거래마다 실행)
81         uint256 index;
82         int8 tmprate;
83         for (uint i = 0; i < status.length; i++) {
84             // 최저 거래 횟수, 최저 거래 금액 충족 시 가장 캐시백 비율이 좋은 등급으로 설정
85             if (tradingHistory[_member].times >= status[i].times &&
86                 tradingHistory[_member].sum >= status[i].sum &&
87                 tmprate < status[i].rate) {
88                 index = i;
89             }
90         }
91         tradingHistory[_member].statusIndex = index;
92     }
93 
94     // (10) 캐시백 비율 획득(회원의 등급에 해당하는 비율 확인)
95     function getCashbackRate(address _member) public constant returns (int8 rate){
96         rate = status[tradingHistory[_member].statusIndex].rate;
97     }
98 }
99      
100 // (11) 회원 관리 기능이 구현된 가상 화폐
101 contract OreOreCoin is Owned{
102     // 상태 변수 선언
103     string public name; // 토큰 이름
104     string public symbol; // 토큰 단위
105     uint8 public decimals; // 소수점 이하 자릿수
106     uint256 public totalSupply; // 토큰 총량
107     mapping (address => uint256) public balanceOf; // 각 주소의 잔고
108     mapping (address => int8) public blackList; // 블랙리스트
109     mapping (address => Members) public members; // 각 주소의 회원 정보
110      
111     // 이벤트 알림
112     event Transfer(address indexed from, address indexed to, uint256 value);
113     event Blacklisted(address indexed target);
114     event DeleteFromBlacklist(address indexed target);
115     event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint256 value);
116     event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint256 value);
117     event Cashback(address indexed from, address indexed to, uint256 value);
118      
119     // 생성자
120     function OreOreCoin(uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
121         balanceOf[msg.sender] = _supply;
122         name = _name;
123         symbol = _symbol;
124         decimals = _decimals;
125         totalSupply = _supply;
126     }
127  
128     // 주소를 블랙리스트에 등록
129     function blacklisting(address _addr) onlyOwner public {
130         blackList[_addr] = 1;
131         emit Blacklisted(_addr);
132     }
133  
134     // 주소를 블랙리스트에서 해제
135     function deleteFromBlacklist(address _addr) onlyOwner public {
136         blackList[_addr] = -1;
137         emit DeleteFromBlacklist(_addr);
138     }
139  
140     // 회원 관리 계약 설정
141     function setMembers(Members _members) public {
142         members[msg.sender] = Members(_members);
143     }
144  
145     // 송금
146     function transfer(address _to, uint256 _value)  public{
147         // 부정 송금 확인
148         if (balanceOf[msg.sender] < _value) return;
149         if (balanceOf[_to] + _value < balanceOf[_to]) return;
150 
151         // 블랙리스트에 존재하는 계정은 입출금 불가
152         if (blackList[msg.sender] > 0) {
153             emit RejectedPaymentFromBlacklistedAddr(msg.sender, _to, _value);
154         } else if (blackList[_to] > 0) {
155             emit RejectedPaymentToBlacklistedAddr(msg.sender, _to, _value);
156         } else {
157             // (12) 캐시백 금액을 계산(각 대상의 비율을 사용)
158             uint256 cashback = 0;
159             if(members[_to] > address(0)) {
160                 cashback = _value / 100 * uint256(members[_to].getCashbackRate(msg.sender));
161                 members[_to].updateHistory(msg.sender, _value);
162             }
163  
164             balanceOf[msg.sender] -= (_value - cashback);
165             balanceOf[_to] += (_value - cashback);
166  
167             emit Transfer(msg.sender, _to, _value);
168             emit Cashback(_to, msg.sender, cashback);
169         }
170     }
171 }