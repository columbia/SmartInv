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
66 contract HGTToken is ERC20{
67     using SafeMath for uint;
68     
69 
70     address public platformAdmin;
71     string public name='HG token';
72     string public symbol='HGT';
73     uint256 public decimals=8;
74     uint256 public _initialSupply=5000;
75     
76     
77 
78  
79     address omx2Addr=0x4d5C98Ee20470a66364D83D90156652c260f3334;
80     uint omx2Decimals=8;
81     
82     address omxS2Addr=0xac395d704bc60cF28d83dF090Fb19F7410EE44E1;
83     uint omxS2SDecimals=8;
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
123     
124         Transfer(msg.sender, _to, _value);
125     }
126     
127 
128     function transferFrom(address _from, address _to, uint256 _value) public  {
129         require(balances[_from] >= _value);
130         require(allowed[_from][msg.sender] >= _value);
131         require(balances[_to] + _value > balances[_to]);
132         balances[_to]=balances[_to].add(_value);
133         balances[_from]=balances[_from].sub(_value);
134         allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
135      
136         Transfer(_from, _to, _value);
137     }
138         
139 
140 
141 
142     function withdrawToken(address _tokenAddress,address _addr,uint256 _tokenAmount)public onlyOwner returns (bool) {
143          ERC20 token =ERC20(_tokenAddress);
144          token.transfer(_addr,_tokenAmount);
145          return true;
146     }
147     
148    
149     
150      function getX2Count(address _userAddr) constant  returns (uint) {
151          ERC20 x2token =ERC20(omx2Addr);
152          uint256 x2Balance=x2token.balanceOf(_userAddr).div(1 * 10 ** omx2Decimals);
153          return x2Balance;
154     }
155     
156     function getXS2Count(address _userAddr) constant  returns (uint) {
157          ERC20 xS2token =ERC20(omxS2Addr);
158          uint256 xS2Balance=xS2token.balanceOf(_userAddr).div(1 * 10 ** omxS2SDecimals);
159          return xS2Balance;
160     }
161           
162     function getEach(address _userAddr) constant  returns (uint) {
163          ERC20 x2token =ERC20(omx2Addr);
164          ERC20 xS2token =ERC20(omxS2Addr);
165          
166          uint256 x2Balance=getX2Count(_userAddr);
167          uint256 xS2Balance=getXS2Count(_userAddr);
168          
169          if(x2Balance<1||xS2Balance<1){
170              return 0;
171          }else{
172             if(x2Balance>=xS2Balance){
173                 return xS2Balance;
174             }else{
175                 return x2Balance;
176             }
177          }
178     }
179     
180     function distribution(address[] _addrs)public onlyOwner () {
181         for(uint i=0;i<_addrs.length;i++){
182             uint each=getEach(_addrs[i]);
183             if(each>0){
184                 transfer(_addrs[i],each.mul(1 * 10 ** decimals));
185             }
186         }
187     }
188 
189 }