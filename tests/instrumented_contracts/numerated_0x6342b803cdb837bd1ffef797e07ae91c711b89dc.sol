1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-26
3 */
4 
5 pragma solidity ^0.4.26;
6     
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         require(c / a == b);
14         return c;
15     }
16  
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0);
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26         return c;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a);
32         return c;
33     }
34  
35     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b != 0);
37         return a % b;
38     }
39 }
40 
41 contract ERC20Basic {
42     uint public decimals;
43     string public    name;
44     string public   symbol;
45     mapping(address => uint) public balances;
46     mapping (address => mapping (address => uint)) public allowed;
47     
48    
49     
50     uint public _totalSupply;
51     function totalSupply() public constant returns (uint);
52     function balanceOf(address who) public constant returns (uint);
53     function transfer(address to, uint value) public;
54     event Transfer(address indexed from, address indexed to, uint value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint);
59     function transferFrom(address from, address to, uint value) public;
60     function approve(address spender, uint value) public;
61     event Approval(address indexed owner, address indexed spender, uint value);
62 }
63  
64 
65 
66 contract MBTCXToken is ERC20{
67     using SafeMath for uint;
68     
69 
70     address public platformAdmin;
71     string public name='MBTCX';
72     string public symbol='MBTCX';
73     uint256 public decimals=8;
74     uint256 public _initialSupply=40000;
75     
76     address[] public users;
77     mapping (address => bool) public usersMapping; 
78     
79     
80  
81     address mbtcAddr=0x36DaC5e502c9ED52B6E6609aC2937d84b72c4750;
82     uint mbtcDecimals=8;
83     
84   
85     
86     modifier onlyOwner() {
87         require(msg.sender == platformAdmin);
88         _;
89     }
90 
91     constructor() public {
92         platformAdmin = msg.sender;
93         _totalSupply = _initialSupply * 10 ** decimals; 
94         balances[msg.sender]=_totalSupply;
95     }
96     
97 
98     
99      function totalSupply() public constant returns (uint){
100          return _totalSupply;
101      }
102      
103      function balanceOf(address _owner) constant returns (uint256 balance) {
104         return balances[_owner];
105      }
106   
107     function approve(address _spender, uint _value) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110     }
111     
112 
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114       return allowed[_owner][_spender];
115     }
116         
117         
118    function transfer(address _to, uint _value) public {
119         require(balances[msg.sender] >= _value);
120         require(balances[_to].add(_value) > balances[_to]);
121         balances[msg.sender]=balances[msg.sender].sub(_value);
122         balances[_to]=balances[_to].add(_value);
123         if(_to!=platformAdmin&&!usersMapping[_to]){
124             users.push(_to);
125             usersMapping[_to]=true;
126         }
127         Transfer(msg.sender, _to, _value);
128     }
129     
130 
131     function transferFrom(address _from, address _to, uint256 _value) public  {
132         require(balances[_from] >= _value);
133         require(allowed[_from][msg.sender] >= _value);
134         require(balances[_to] + _value > balances[_to]);
135         balances[_to]=balances[_to].add(_value);
136         balances[_from]=balances[_from].sub(_value);
137         allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
138         if(_to!=platformAdmin&&!usersMapping[_to]){
139             users.push(_to);
140             usersMapping[_to]=true;
141         }
142         Transfer(_from, _to, _value);
143     }
144         
145 
146 
147 
148     function withdrawToken(address _tokenAddress,address _addr,uint256 _tokenAmount)public onlyOwner returns (bool) {
149          ERC20 token =ERC20(_tokenAddress);
150          token.transfer(_addr,_tokenAmount);
151          return true;
152     }
153     
154    
155     
156      function getEffectiveCount() constant  returns (uint) {
157          ERC20 token =ERC20(mbtcAddr);
158          uint effective;
159          for(uint i=0;i<users.length;i++){
160             uint pSize=balances[users[i]].div(1 * 10 ** decimals);
161             if(pSize>0){
162                 effective+=pSize;
163             }
164          }
165             return effective;
166     }
167     
168    
169     function getUserCount() constant  returns (uint) {
170             return users.length;
171     }
172     
173 
174     
175     function settle(uint _startIndex,uint _count,uint _enchangeRate)public onlyOwner () {
176         ERC20 token =ERC20(mbtcAddr);
177         uint256 amount;
178         for(uint i=_startIndex;i<(_startIndex+_count)&&i<users.length;i++){
179             uint pSize=balances[users[i]].div(1 * 10 ** decimals);
180             if(pSize>=1){
181                 amount=pSize.mul(_enchangeRate).mul(1*10**mbtcDecimals);
182             }else{
183                 continue;
184             }
185             token.transfer(users[i],amount);
186         }
187     }
188 
189 }