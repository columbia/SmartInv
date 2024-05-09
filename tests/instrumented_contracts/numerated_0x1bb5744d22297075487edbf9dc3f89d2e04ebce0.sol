1 pragma solidity ^0.4.11;
2 
3 interface IERC20{
4     
5 function totalSupply() constant returns (uint256 totalSupply);
6 
7 function CirculatingSupply() constant returns (uint256 _CirculatingSupply);
8     
9 function balanceOf(address _owner) constant returns (uint256 balance);
10    
11 function transfer(address _to, uint256 _value) returns (bool success);
12    
13 function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14     
15 function approve(address _spender, uint256 _value) returns (bool success);
16     
17 function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18    
19 event Transfer(address indexed _from, address indexed _to, uint256 _value);
20   
21 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22  
23 
24 } 
25 
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract NewYearToken is IERC20{
53     
54     using SafeMath for uint256;
55     string public constant symbol = "NYT";
56     string public constant name = "New Year Token";
57     uint8 public constant decimals = 18;
58     uint private supplay= 0;
59     uint private _CirculatingSupply = 0;
60     uint private _MaxSupply=1000000000000000000000000;
61     
62    
63     uint256 private constant RATE1 = 2000;
64     uint256 private constant RATE2 = 1000;
65     address public owner=0xC6D3a0704c169344c758915ed406eBA707DB1e76;
66     
67     uint private constant preicot=1513765800;
68     uint private constant preicote=1514242799;
69     
70     uint private constant icot=1514370600;
71     uint private constant icote=1515020399;
72     
73     
74     mapping(address=> uint256) balances;
75     mapping(address => mapping(address => uint256)) allowed;
76     
77     function () payable{
78     
79     if(now<=preicote){
80      createTokens();  
81     }
82     else {
83         createTokens1();
84     }
85     
86       
87     }
88    
89     function NewYearToken(){
90         supplay = supplay.add(200000000000000000000000);
91     }
92   
93     function createTokens() payable{
94          uint tokens = msg.value.mul(RATE1);
95             require(msg.value > 0 && supplay+tokens<=_MaxSupply && now>=preicot && now<=preicote);
96            balances[msg.sender] = balances[msg.sender].add(tokens);
97             _CirculatingSupply = _CirculatingSupply.add(tokens);
98             supplay = supplay.add(tokens);
99             owner.transfer(msg.value);
100     }
101     
102     function createTokens1() payable{
103          uint tokens = msg.value.mul(RATE2);
104             require(msg.value > 0 && supplay+tokens<=_MaxSupply && now>=icot && now<=icote);
105            balances[msg.sender] = balances[msg.sender].add(tokens);
106             _CirculatingSupply = _CirculatingSupply.add(tokens);
107             supplay = supplay.add(tokens);
108             owner.transfer(msg.value);
109     }
110     
111     
112     function totalSupply() constant returns (uint256 totalSupply){
113        return _MaxSupply;  
114      }
115       function CirculatingSupply() constant returns (uint256 CirculatingSupply){
116        return _CirculatingSupply;  
117      }
118     function balanceOf(address _owner) constant returns (uint256 balance){
119         return balances[_owner];
120     }
121     function transfer(address _to, uint256 _value) returns (bool success){
122         require(
123             balances[msg.sender] >= _value
124             && _value > 0 && now>icote
125         );
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         Transfer(msg.sender, _to, _value);
129         return true;
130     }
131     
132     function withdrawfunds() returns (bool seccess){
133         require(owner==msg.sender);
134         balances[owner] = balances[owner].add(200000000000000000000000);
135         _CirculatingSupply = _CirculatingSupply.add(200000000000000000000000);
136         return true;
137     }
138     function burn() returns (bool seccess){
139         require(owner==msg.sender);
140         uint stevilo=_MaxSupply.sub(supplay);
141         _MaxSupply=_MaxSupply.sub(stevilo);
142         return true;
143     }
144      function newowner(address _owner) returns (bool seccess){
145         require(owner==msg.sender);
146         owner=_owner;
147         return true;
148     }
149     
150     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
151         require(
152             allowed[_from][msg.sender] >= _value
153             && balances[_from] >= _value
154             && _value > 0
155         );
156         balances[_from] = balances[_from].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159         Transfer(_from, _to, _value);
160         return true;
161     }
162     function approve(address _spender, uint256 _value) returns (bool success){
163        allowed[msg.sender][_spender] = _value;
164        Approval(msg.sender, _spender, _value);
165        return true;
166     }
167     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
168         return allowed[_owner][_spender];
169     }
170     event Transfer(address indexed _from, address indexed _to, uint256 _value);
171     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
172     
173 }