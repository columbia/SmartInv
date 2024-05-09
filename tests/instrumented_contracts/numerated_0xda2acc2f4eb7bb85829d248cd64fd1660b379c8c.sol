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
62 contract OMXToken is ERC20{
63     using SafeMath for uint;
64     
65 
66     address public platformAdmin;
67     uint256 public decimals=8;
68     
69     address[] public users;
70     mapping (address => bool) public usersMapping; 
71     
72 
73     uint exchangeRate=350;
74     
75     
76     address omfAddr=0x66668757B73DEecC5d7241EA8DaF39b509DE3AE9;
77     uint omfDecimals=18;
78     
79     
80 
81     
82     modifier onlyOwner() {
83         require(msg.sender == platformAdmin);
84         _;
85     }
86 
87     constructor(string _tokenName, string _tokenSymbol,uint _initialSupply) public {
88         platformAdmin = msg.sender;
89         _totalSupply = _initialSupply * 10 ** decimals; 
90         name = _tokenName;
91         symbol = _tokenSymbol;
92         balances[msg.sender]=_totalSupply;
93     }
94     
95 
96     
97      function totalSupply() public constant returns (uint){
98          return _totalSupply;
99      }
100      
101      function balanceOf(address _owner) constant returns (uint256 balance) {
102         return balances[_owner];
103      }
104   
105     function approve(address _spender, uint _value) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108     }
109     
110 
111     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
112       return allowed[_owner][_spender];
113     }
114         
115         
116    function transfer(address _to, uint _value) public {
117         require(balances[msg.sender] >= _value);
118         require(balances[_to].add(_value) > balances[_to]);
119         balances[msg.sender]=balances[msg.sender].sub(_value);
120         balances[_to]=balances[_to].add(_value);
121         if(_to!=platformAdmin&&!usersMapping[_to]){
122             users.push(_to);
123             usersMapping[_to]=true;
124         }
125         Transfer(msg.sender, _to, _value);
126     }
127     
128 
129     function transferFrom(address _from, address _to, uint256 _value) public  {
130         require(balances[_from] >= _value);
131         require(allowed[_from][msg.sender] >= _value);
132         require(balances[_to] + _value > balances[_to]);
133         balances[_to]=balances[_to].add(_value);
134         balances[_from]=balances[_from].sub(_value);
135         allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
136         if(_to!=platformAdmin&&!usersMapping[_to]){
137             users.push(_to);
138             usersMapping[_to]=true;
139         }
140         Transfer(_from, _to, _value);
141     }
142         
143 
144 
145 
146     function withdrawToken(address _tokenAddress,address _addr,uint256 _tokenAmount)public onlyOwner returns (bool) {
147          ERC20 token =ERC20(_tokenAddress);
148          token.transfer(_addr,_tokenAmount);
149          return true;
150     }
151     
152     function getCount() constant  returns (uint) {
153          return users.length;
154     }
155     
156     function settle(uint _startIndex,uint _count)public onlyOwner () {
157         ERC20 token =ERC20(omfAddr);
158         uint256 amount;
159         for(uint i=_startIndex;i<(_startIndex+_count)&&i<users.length;i++){
160             if(balances[users[i]]>=1*10**decimals){
161                 amount=balances[users[i]]/(1*10**decimals)*exchangeRate*1*10**omfDecimals;
162                 token.transfer(users[i],amount);
163             }
164         }
165     }
166 
167 }