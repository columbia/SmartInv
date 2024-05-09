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
66 contract MBTCToken is ERC20{
67     using SafeMath for uint;
68     
69 
70     address public platformAdmin;
71     string public name='Mbit Coin';
72     string public symbol='MBTC';
73     uint256 public decimals=8;
74     uint256 public _initialSupply=210000000;
75     
76 
77     
78     
79     modifier onlyOwner() {
80         require(msg.sender == platformAdmin);
81         _;
82     }
83 
84     constructor() public {
85         platformAdmin = msg.sender;
86         _totalSupply = _initialSupply * 10 ** decimals; 
87         balances[msg.sender]=_totalSupply;
88     }
89     
90 
91     
92      function totalSupply() public constant returns (uint){
93          return _totalSupply;
94      }
95      
96      function balanceOf(address _owner) constant returns (uint256 balance) {
97         return balances[_owner];
98      }
99   
100     function approve(address _spender, uint _value) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103     }
104     
105 
106     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
107       return allowed[_owner][_spender];
108     }
109         
110         
111    function transfer(address _to, uint _value) public {
112         require(balances[msg.sender] >= _value);
113         require(balances[_to].add(_value) > balances[_to]);
114         balances[msg.sender]=balances[msg.sender].sub(_value);
115         balances[_to]=balances[_to].add(_value);
116         Transfer(msg.sender, _to, _value);
117     }
118     
119 
120     function transferFrom(address _from, address _to, uint256 _value) public  {
121         require(allowed[_from][msg.sender] >= _value);
122         require(balances[_to] + _value > balances[_to]);
123         balances[_to]=balances[_to].add(_value);
124         balances[_from]=balances[_from].sub(_value);
125         allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127     }
128         
129 
130       
131 
132 
133     function withdrawToken(address _tokenAddress,address _addr,uint256 _tokenAmount)public onlyOwner returns (bool) {
134          ERC20 token =ERC20(_tokenAddress);
135          token.transfer(_addr,_tokenAmount);
136          return true;
137     }
138     
139 
140     
141    function multiTransfer( address[] _tos, uint256[] _values)public returns (bool) {
142         require(_tos.length == _values.length);
143         uint256 len = _tos.length;
144 
145         for (uint256 j = 0; j < len; j++) {
146             address _to = _tos[j];
147             balances[_to] = balances[_to].add(_values[j]);
148             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
149             emit Transfer(msg.sender, _to, _values[j]);
150         }
151         return true;
152     }
153 }