1 pragma solidity ^0.4.25;
2 
3 contract ERC20Interface{ 
4     
5     function totalSupply() public view returns (uint);
6     function balanceOf(address who) public view returns (uint);
7     function transfer(address to, uint value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10 }
11 
12 contract ERC20 is ERC20Interface{
13 
14     function allowance(address owner, address spender) public view returns (uint);
15     function transferFrom(address from, address to, uint value) public returns (bool);
16     function approve (address spender, uint value) public returns (bool);
17     event Approval (address indexed owner, address indexed spender, uint value);
18 
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, reverts on overflow.
29   */
30   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (_a == 0) {
35       return 0;
36     }
37 
38     uint256 c = _a * _b;
39     require(c / _a == _b);
40 
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
46   */
47   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     require(_b > 0); // Solidity only automatically asserts when dividing by 0
49     uint256 c = _a / _b;
50     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     require(_b <= _a);
59     uint256 c = _a - _b;
60 
61     return c;
62   }
63 
64   /**
65   * @dev Adds two numbers, reverts on overflow.
66   */
67   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
68     uint256 c = _a + _b;
69     require(c >= _a);
70 
71     return c;
72   }
73 
74   /**
75   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
76   * reverts when dividing by zero.
77   */
78   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b != 0);
80     return a % b;
81   }
82 }
83 
84 //해당 컨트랙트는 인터페이스에서 선언한 함수들의 기능을 구현해준다.
85 contract BasicToken is ERC20Interface{
86     using SafeMath for uint256;
87     //using A for B : B 자료형에 A 라이브러리 함수를 붙여라.
88     //dot(.)으로 호출 할수 있게됨.
89     //ex) using SafeMath for uint256 이면 uint256자료형에 SafeMath 라이브러리 함수를 .을 이용해 사용가능하다는 뜻 => a.add(1) ,b.sub(2)를 사용가능하게 함.
90 
91     mapping (address => uint256) balances;
92 
93 
94     uint totalSupply_;
95 
96 // 토큰의 총 발행량을 구하는 함수.
97   function totalSupply() public view returns (uint){
98     return totalSupply_;
99   }
100 
101   function transfer(address _to, uint _value) public returns (bool){
102     require (_to != address(0));
103     // address(0)은 값이 없다는 것.
104     // require란 참이면 실행하는 것.
105     require (_value <= balances[msg.sender]);
106     // 함수를 호출한 '나'의 토큰 잔고가 보내는 토큰의 개수보다 크거나 같을때 실행.
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     //sub는 뺄셈. , 보낸 토큰개수만큼 뺀다.
110     balances[_to] = balances[_to].add(_value);
111     //add는 덧셈. , 받은 토큰개수 만큼 더한다.
112 
113     emit Transfer(msg.sender,_to,_value);
114     // Transfer라는 이벤트를 실행하여 이더리움 블록체인상에 거래내역을 기록한다. 물론, 등록됬으므로 검색 가능.
115     return true; //모든것이 실행되면 참을 출력.
116 
117   }
118 
119   function balanceOf(address _owner) public view returns(uint balance){
120     return balances[_owner];
121   }
122 
123 }
124 
125 contract StandardToken is ERC20, BasicToken{
126   //ERC20에 선언된 인터페이스를 구현하는 컨트랙트.
127 
128   mapping (address => mapping (address => uint)) internal allowed;
129   // allowed 매핑은 '누가','누구에게','얼마의' 인출권한을 줄지를 저장하는 것. ex) allowed[누가][누구에게] = 얼마;
130 
131   function transferFrom(address _from, address _to, uint _value) public returns (bool){
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135     //보내려는 토큰개수가 계좌주인 _from이 돈을 빼려는 msg.sender에게 허용한 개수보다 작거나 같으면 참.
136     //_fromr에게 인출권한을 받은 msg.sender가 가스비를 소모함.
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from,_to,_value);
142     return true;
143 
144   }
145 
146   function approve(address _spender, uint _value) public returns (bool){
147     allowed[msg.sender][_spender] = _value;
148     //msg.sender의 계좌에서 _value 만큼 인출해 갈 수 있는 권리를 _spender 에게 부여한다.
149     emit Approval(msg.sender,_spender,_value);
150     return true;
151   }
152 
153   function allowance(address _owner, address _spender) public view returns (uint){
154     return allowed[_owner][_spender];
155   }
156 
157 }
158 
159 contract CreateToken is StandardToken{
160 
161   string public constant name = "JHTK";
162   string public constant symbol = "JHTK";
163   uint8 public constant decimals = 18;
164 
165   uint256 public constant INITIAL_SUPPLY =            4000000000 * (10**uint256(decimals));
166 
167   constructor() public{
168     totalSupply_ = INITIAL_SUPPLY;
169     balances[msg.sender] = INITIAL_SUPPLY;
170     emit Transfer(0x0,msg.sender,INITIAL_SUPPLY);
171   }
172 }