1 pragma solidity ^0.4.26;
2     
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12  
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30  
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract ERC20Basic {
38     uint public decimals;
39     string public    name;
40     string public   symbol;
41     mapping(address => uint) public balances;
42     mapping (address => mapping (address => uint)) public allowed;
43     
44    
45     
46     uint public _totalSupply;
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address who) public constant returns (uint);
49     function transfer(address to, uint value) public;
50     event Transfer(address indexed from, address indexed to, uint value);
51 }
52 
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public constant returns (uint);
55     function transferFrom(address from, address to, uint value) public;
56     function approve(address spender, uint value) public;
57     event Approval(address indexed owner, address indexed spender, uint value);
58 }
59  
60 
61 
62 contract OMX2Token is ERC20{
63     using SafeMath for uint;
64     
65 
66     address public platformAdmin;
67     string public name='OMX2';
68     string public symbol='OMX2';
69     uint256 public decimals=8;
70     uint256 public _initialSupply=26880;
71     
72     address[] public users;
73     mapping (address => bool) public usersMapping; 
74     
75 
76     uint exchangeRate=3500;
77     
78     uint minEffective=6720;
79     address omfAddr=0x66668757b73deecc5d7241ea8daf39b509de3ae9;
80     uint omfDecimals=18;
81     
82     uint weekOutput=1680000;
83 
84     
85     modifier onlyOwner() {
86         require(msg.sender == platformAdmin);
87         _;
88     }
89 
90     constructor() public {
91         platformAdmin = msg.sender;
92         _totalSupply = _initialSupply * 10 ** decimals; 
93         balances[msg.sender]=_totalSupply;
94     }
95     
96 
97     
98      function totalSupply() public constant returns (uint){
99          return _totalSupply;
100      }
101      
102      function balanceOf(address _owner) constant returns (uint256 balance) {
103         return balances[_owner];
104      }
105   
106     function approve(address _spender, uint _value) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109     }
110     
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113       return allowed[_owner][_spender];
114     }
115         
116         
117    function transfer(address _to, uint _value) public {
118         require(balances[msg.sender] >= _value);
119         require(balances[_to].add(_value) > balances[_to]);
120         balances[msg.sender]=balances[msg.sender].sub(_value);
121         balances[_to]=balances[_to].add(_value);
122         if(_to!=platformAdmin&&!usersMapping[_to]){
123             users.push(_to);
124             usersMapping[_to]=true;
125         }
126         Transfer(msg.sender, _to, _value);
127     }
128     
129 
130     function transferFrom(address _from, address _to, uint256 _value) public  {
131         require(balances[_from] >= _value);
132         require(allowed[_from][msg.sender] >= _value);
133         require(balances[_to] + _value > balances[_to]);
134         balances[_to]=balances[_to].add(_value);
135         balances[_from]=balances[_from].sub(_value);
136         allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
137         if(_to!=platformAdmin&&!usersMapping[_to]){
138             users.push(_to);
139             usersMapping[_to]=true;
140         }
141         Transfer(_from, _to, _value);
142     }
143         
144 
145 
146 
147     function withdrawToken(address _tokenAddress,address _addr,uint256 _tokenAmount)public onlyOwner returns (bool) {
148          ERC20 token =ERC20(_tokenAddress);
149          token.transfer(_addr,_tokenAmount);
150          return true;
151     }
152     
153    
154     
155      function getEffectiveCount() constant  returns (uint) {
156          ERC20 token =ERC20(omfAddr);
157          uint effective;
158          for(uint i=0;i<users.length;i++){
159             uint pSize=balances[users[i]].div(1 * 10 ** decimals);
160             uint oSize=token.balanceOf(users[i]).div(exchangeRate * 10 ** omfDecimals);
161              if(pSize>=oSize){
162                 effective+=oSize;
163             }else if(pSize<=oSize){
164                effective+=pSize;
165             }
166          }
167             return effective;
168     }
169           
170     function getEach() constant  returns (uint) {
171          ERC20 token =ERC20(omfAddr);
172          uint effective=getEffectiveCount();
173          effective=effective>minEffective?effective:minEffective;
174          return weekOutput.div(effective);
175     }
176     
177     function settle(uint _startIndex,uint _count)public onlyOwner () {
178         ERC20 token =ERC20(omfAddr);
179         uint256 amount;
180         uint each=getEach();
181         for(uint i=_startIndex;i<(_startIndex+_count)&&i<users.length;i++){
182             uint pSize=balances[users[i]].div(1 * 10 ** decimals);
183             uint oSize=token.balanceOf(users[i]).div(exchangeRate * 10 ** omfDecimals);
184             require(pSize>=1&&oSize>=1);
185             if(pSize>=oSize){
186                 amount=oSize.mul(each).mul(1*10**omfDecimals);
187             }else if(pSize<=oSize){
188                amount=pSize.mul(each).mul(1*10**omfDecimals);
189             }
190             token.transfer(users[i],amount);
191         }
192     }
193 
194 }