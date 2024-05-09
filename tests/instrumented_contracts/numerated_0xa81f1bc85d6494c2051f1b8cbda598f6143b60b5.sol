1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Interface{ //제 3자 송금기능은 빠진 컨트랙트로 기본적인 인터페이스를 선언하는것!
5   function totalSupply() public view returns (uint);
6   //발행한 전체 토큰의 자산이 얼마인가?, 리턴값 : 전체 토큰 발행량
7   function balanceOf(address who) public view returns (uint);
8   //who 주소의 계정에 자산이 얼마 있는가?, 리턴값 : 계정에 보유한 토큰 수
9   function transfer(address to, uint value) public returns (bool);
10   //내가 가진 토큰 value 개를 to 에게 보내라. 여기서 '나' 는 가스를 소모하여 transfer 함수를 호출한 계정입니다. , 리턴값 : 성공/실패
11   event Transfer(address indexed from, address indexed to, uint value);
12   //이벤트는 외부에서 호출하는 함수가 아닌 소스 내부에서 호출되는 이벤트 함수입니다.
13   //ERC20 에 따르면 '토큰이 이동할 때에는 반드시 Transfer 이벤트를 발생시켜라.' 라고 규정 짓고 있습니다.
14 }
15 
16 
17 contract ERC20 is ERC20Interface{
18   // 제3자의 송금기능을 추가한 컨트랙트를 선언 하는 것!
19   function allowance(address owner, address spender) public view returns (uint);
20   // owner 가 spender 에게 인출을 허락한 토큰의 개수는 몇개인가? , 리턴값 : 허용된 토큰의 개수
21   function transferFrom(address from, address to, uint value) public returns (bool);
22   // from 의 계좌에서 value 개의 토큰을 to 에게 보내라. 단, 이 함수는 approve 함수를 통해 인출할 권리를 받은 spender 만 실행할 수 있다. , 리턴값: 성공/실패
23   function approve (address spender, uint value) public returns (bool);
24   // spender 에게 value 만큼의 토큰을 인출할 권리를 부여한다. 이 함수를 이용할 때는 반드시 Approval 이벤트 함수를 호출해야 한다. , 리턴값: 성공/실패
25   event Approval (address indexed owner, address indexed spender, uint value);
26   // owner가 spender에게 인출을 용한 value개수를 블록체인상에 영구적으로 기록한다. => 검색가능.
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that revert on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, reverts on overflow.
37   */
38   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (_a == 0) {
43       return 0;
44     }
45 
46     uint256 c = _a * _b;
47     require(c / _a == _b);
48 
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
54   */
55   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     require(_b > 0); // Solidity only automatically asserts when dividing by 0
57     uint256 c = _a / _b;
58     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
59 
60     return c;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     require(_b <= _a);
68     uint256 c = _a - _b;
69 
70     return c;
71   }
72 
73   /**
74   * @dev Adds two numbers, reverts on overflow.
75   */
76   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
77     uint256 c = _a + _b;
78     require(c >= _a);
79 
80     return c;
81   }
82 
83   /**
84   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
85   * reverts when dividing by zero.
86   */
87   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b != 0);
89     return a % b;
90   }
91 }
92 
93 //해당 컨트랙트는 인터페이스에서 선언한 함수들의 기능을 구현해준다.
94 contract BasicToken is ERC20Interface{
95   using SafeMath for uint256;
96 //using A for B : B 자료형에 A 라이브러리 함수를 붙여라.
97 //dot(.)으로 호출 할수 있게됨.
98 //ex) using SafeMath for uint256 이면 uint256자료형에 SafeMath 라이브러리 함수를 .을 이용해 사용가능하다는 뜻 => a.add(1) ,b.sub(2)를 사용가능하게 함.
99 
100   mapping (address => uint256) balances;
101 
102 
103   uint totalSupply_;
104 
105 // 토큰의 총 발행량을 구하는 함수.
106   function totalSupply() public view returns (uint){
107     return totalSupply_;
108   }
109 
110   function transfer(address _to, uint _value) public returns (bool){
111     require (_to != address(0));
112     // address(0)은 값이 없다는 것.
113     // require란 참이면 실행하는 것.
114     require (_value <= balances[msg.sender]);
115     // 함수를 호출한 '나'의 토큰 잔고가 보내는 토큰의 개수보다 크거나 같을때 실행.
116 
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     //sub는 뺄셈. , 보낸 토큰개수만큼 뺀다.
119     balances[_to] = balances[_to].add(_value);
120     //add는 덧셈. , 받은 토큰개수 만큼 더한다.
121 
122     emit Transfer(msg.sender,_to,_value);
123     // Transfer라는 이벤트를 실행하여 이더리움 블록체인상에 거래내역을 기록한다. 물론, 등록됬으므로 검색 가능.
124     return true; //모든것이 실행되면 참을 출력.
125 
126   }
127 
128   function balanceOf(address _owner) public view returns(uint balance){
129     return balances[_owner];
130   }
131 
132 
133 
134 }
135 
136 
137 contract StandardToken is ERC20, BasicToken{
138   //ERC20에 선언된 인터페이스를 구현하는 컨트랙트.
139 
140   mapping (address => mapping (address => uint)) internal allowed;
141   // allowed 매핑은 '누가','누구에게','얼마의' 인출권한을 줄지를 저장하는 것. ex) allowed[누가][누구에게] = 얼마;
142 
143   function transferFrom(address _from, address _to, uint _value) public returns (bool){
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147     //보내려는 토큰개수가 계좌주인 _from이 돈을 빼려는 msg.sender에게 허용한 개수보다 작거나 같으면 참.
148     //_fromr에게 인출권한을 받은 msg.sender가 가스비를 소모함.
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from,_to,_value);
154     return true;
155 
156   }
157 
158   function approve(address _spender, uint _value) public returns (bool){
159     allowed[msg.sender][_spender] = _value;
160     //msg.sender의 계좌에서 _value 만큼 인출해 갈 수 있는 권리를 _spender 에게 부여한다.
161     emit Approval(msg.sender,_spender,_value);
162     return true;
163   }
164 
165   function allowance(address _owner, address _spender) public view returns (uint){
166     return allowed[_owner][_spender];
167   }
168 
169   // 권한을 부여하는사람이 권한을 받는사람에게 허용하는 값을 바꾸려고할때,
170   // 채굴순서에의해 코드의 실행순서가 뒤바뀔 수 있다.
171   // 그렇게 되면 허용값을 10을줬다가 생각이 바껴서 1을 주게되면
172   // 권한을 받은사람은 그것을 눈치채고, 11을 지불할 수 있다.
173   // 그런 문제점을 보안하기 위해서 밑의 함수를 추가하였다.
174   /* function increaseApproval(address _spender, uint _addedValue) public returns(bool){
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender,_spender,allowed[msg.sender][_spender]);
177     return true;
178 
179   }
180 
181   function decreaseApproval(address _spender, uint _substractedValue) public returns (bool){
182     oldValue = allowed[msg.sender][_spender];
183     if (_substractedValue > oldValue){
184       allowed[msg.sender][_spender] = 0;
185     }
186     else {
187       allowed[msg.sender][_spender] = oldValue.sub(_substractedValue);
188     }
189 
190 
191     Approval(msg.sender,_spender, allowed[msg.sender][_spender]);
192 
193     return true;
194 
195   } */
196 
197 }
198 
199 
200 contract CreateToken is StandardToken{
201 
202   string public constant name = "JHT";
203   string public constant symbol = "JHT";
204   uint8 public constant decimals = 18;
205 
206   //uint256 public constant INITIAL_SUPPLY =            10000000000 * (10**uint(decimals));
207   uint256 public constant INITIAL_SUPPLY =  4000000000 * (10**uint(decimals));
208   
209   constructor() public{
210     totalSupply_ = INITIAL_SUPPLY;
211     balances[msg.sender] = INITIAL_SUPPLY;
212     emit Transfer(0x0,msg.sender,INITIAL_SUPPLY);
213 
214   }
215 }
216 // 이더스캔에 코드배포시 optimization,컨트랙트네임,컴파일버전등 리믹스와 똑같이 해줄것! , 버전2.0에서 할것.