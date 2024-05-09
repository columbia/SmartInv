1 pragma solidity ^0.4.16; 
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; } 
4 
5 contract Rapide { 
6     // 변수 선언 
7     string public name; 
8     string public symbol; 
9     uint8 public decimals = 18; 
10     // 18소수 점 이하는 강력하게 제안된 기본 값이므로 변경하지 마십시오. 
11     uint256 public totalSupply; 
12 
13     // 모든 균형을 갖춘 배열을 생성합니다. 
14     mapping (address => uint256) public balanceOf; 
15     mapping (address => mapping (address => uint256)) public allowance; 
16 
17     // 이것은 블록체인에서 클라이언트에게 알려주는 공개 이벤트를 생성합니다 
18     event Transfer(address indexed from, address indexed to, uint256 value); 
19 
20     // 소각된 양을 알립니다. 
21     event Burn(address indexed from, uint256 value); 
22 
23     /** 
24      * 생성자 함수 
25      * 
26      * 계약서 작성자에게 초기 공급 토큰과의 계약을 초기화합니다. 
27      */ 
28     function Rapide( 
29         uint256 initialSupply, 
30         string tokenName, 
31         string tokenSymbol 
32     ) public { 
33         totalSupply = initialSupply * 10 ** uint256(decimals);  // 총 공급액을 소수로 업데이트합니다. 
34         balanceOf[msg.sender] = totalSupply;                    // 총 발행량 
35         name = tokenName;                                       // 토큰 이름 
36         symbol = tokenSymbol;                                   // 토큰 심볼 (EX: BTC, ETH, LTC) 
37     } 
38 
39     /** 
40      * 내부 전송, 이 계약으로만 호출할 수 있습니다. 
41      */ 
42     function _transfer(address _from, address _to, uint _value) internal { 
43         // Prevent transfer to 0x0 address. Use burn() instead 
44         require(_to != 0x0); 
45         // 발신자 점검 
46         require(balanceOf[_from] >= _value); 
47         // 오버플로 확인 
48         require(balanceOf[_to] + _value > balanceOf[_to]); 
49         // 미래의 주장을 위해 이것을 저장하십시오 
50         uint previousBalances = balanceOf[_from] + balanceOf[_to]; 
51         // 발신자에서 차감 
52         balanceOf[_from] -= _value; 
53         // 받는 사람에게 같은 것을 추가하십시오. 
54         balanceOf[_to] += _value; 
55         Transfer(_from, _to, _value); 
56         // 정적 분석을 사용하여 코드에서 버그를 찾을 때 사용합니다. 이 시스템은 실패하지 않습니다. 
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
58     } 
59 
60     /** 
61      * 토큰 전송 
62      * @ _to 받는 사람의 주소에 대한 매개 변수 
63      * @ _value 전송할 금액을 정하다. 
64      */ 
65     function transfer(address _to, uint256 _value) public { 
66         _transfer(msg.sender, _to, _value); 
67     } 
68 
69     /** 
70      * _from  보낸 사람의 주소 
71      * _to    받는 사람의 주소 
72      * _value 전송할 금액 
73      */ 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { 
75         require(_value <= allowance[_from][msg.sender]);     // 허용량 체크 
76         allowance[_from][msg.sender] -= _value; 
77         _transfer(_from, _to, _value); 
78         return true; 
79     } 
80 
81     /** 
82      * 다른 주소에 대한 허용량 설정 
83      * _spender 지출 할 수있는 주소 
84      * _value   그들이 쓸 수 있는 지출 할 수있는 최대 금액 
85      */ 
86     function approve(address _spender, uint256 _value) public 
87         returns (bool success) { 
88         allowance[msg.sender][_spender] = _value; 
89         return true; 
90     } 
91 
92     /** 
93      * 다른 주소에 대한 허용치 설정 및 알림 
94      * @param _spender   지출 할 수있는 주소 
95      * @param _value     그들이 쓸 수 있는 지출 할 수있는 최대 금액 
96      * @param _extraData 승인 된 계약서에 보낼 추가 정보 
97      */ 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
99         public 
100         returns (bool success) { 
101         tokenRecipient spender = tokenRecipient(_spender); 
102         if (approve(_spender, _value)) { 
103             spender.receiveApproval(msg.sender, _value, this, _extraData); 
104             return true; 
105         } 
106     } 
107 
108     /** 
109      * 토큰 파괴 
110      * @param _value 소각되는 금액 
111      */ 
112     function burn(uint256 _value) public returns (bool success) { 
113         require(balanceOf[msg.sender] >= _value);   // 보낸 사람이 충분히 있는지 확인하십시오. 
114         balanceOf[msg.sender] -= _value;            // 발신자에게서 뺍니다. 
115         totalSupply -= _value;                      // 총 발행량 업데이트 
116         Burn(msg.sender, _value); 
117         return true; 
118     } 
119 
120   /** 
121      * 다른 계정에서 토큰 삭제 
122      * @param _from 발신자 주소 
123      * @param _value 소각되는 금액 
124      */ 
125     function burnFrom(address _from, uint256 _value) public returns (bool success) { 
126         require(balanceOf[_from] >= _value);                // 목표 잔액이 충분한 지 확인하십시오. 
127         require(_value <= allowance[_from][msg.sender]);    // 수당 확인 
128         balanceOf[_from] -= _value;                         // 목표 잔액에서 차감 
129         allowance[_from][msg.sender] -= _value;             // 발송인의 허용량에서 차감 
130         totalSupply -= _value;                              // 총 발행량 업데이트 
131         Burn(_from, _value); 
132         return true; 
133     } 
134 }