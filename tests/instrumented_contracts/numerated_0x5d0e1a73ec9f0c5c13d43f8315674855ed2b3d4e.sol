1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     function mul(uint256 a, uint256 b) internal  returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal  returns (uint256) {
10         assert(b > 0);
11         uint256 c = a / b;
12         return c;
13     }
14     function sub(uint256 a, uint256 b) internal   returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18     function add(uint256 a, uint256 b) internal  returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23     function pow( uint256 a , uint8 b ) internal returns ( uint256 ){
24         uint256 c;
25         c = a ** b;
26         return c;
27     }
28 }
29 contract owned {
30     bool public OwnerDefined = false;
31     address public owner;
32     event OwnerEvents(address _addr, uint8 action);
33     function owned()
34         internal
35     {
36         require(OwnerDefined == false);
37         owner = msg.sender;
38         OwnerDefined = true;
39         OwnerEvents(msg.sender,1);
40     }
41 }
42 contract ERC20Token is owned, SafeMath{
43     bool public tokenState;
44     string public name = "8SM";
45     string public symbol = "8SM";
46     uint256 public decimals = 8;
47     uint256 public totalSupply = mul(25,pow(10,15));
48     mapping(address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52     function init()
53         external
54     returns ( bool ){
55         require(tokenState == false);
56         owned;
57         tokenState = true;
58         balances[this] = totalSupply;
59         allowed[this][owner] = totalSupply;
60         return true;
61     }
62     function transfer(address _to, uint256 _value)
63         public
64     returns ( bool ) {
65         require(tokenState == true);
66         require(_to != address(0));
67         require(_value <= balances[msg.sender]);
68         balances[msg.sender] = sub(balances[msg.sender],_value);
69         balances[_to] = add(balances[_to],_value);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73     function transferFrom(address _from, address _to, uint256 _value)
74         public
75     {
76         require(_to != address(0));
77         require(_value <= balances[_from]);
78         require(_value <= allowed[_from][msg.sender]);
79         balances[_from] = sub(balances[_from],_value);
80         balances[_to] = add(balances[_to],_value);
81         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
82         Transfer(_from, _to, _value);
83     }
84     function balanceOf(address _owner)
85         external
86         constant
87     returns (uint256) {
88         require(tokenState == true);
89         return balances[_owner];
90     }
91     function approve(address _spender, uint256 _value)
92         external
93     returns (bool success) {
94         require(tokenState == true);
95         require(_spender != address(0));
96         require(msg.sender == owner);
97         allowed[msg.sender][_spender] = mul(_value, 100000000);
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101     function allowance(address _owner, address _spender)
102         external
103         constant
104     returns (uint256 remaining) {
105         require(tokenState == true);
106         return allowed[_owner][_spender];
107     }
108     function changeOwner()
109         external
110     returns ( bool ){
111         require(owner == msg.sender);
112         require(tokenState == true);
113         allowed[this][owner] = 0;
114         owner = msg.sender;
115         allowed[this][msg.sender] = balances[this];
116         return true;
117     }
118 }
119 contract disburseToken is SafeMath{
120     ERC20Token token;
121     bool public state;
122     address public tokenAddress; 
123     address public owner;
124     address public from;
125     uint256 public staticblock = 5760;
126     function init(address _addr,address _from) external returns(bool){
127         require(state == false);
128         state = true;
129         tokenAddress = _addr;
130         token = ERC20Token(_addr);
131         owner = msg.sender;
132         from = _from;
133         return true;
134     }
135     function changeOwner(address _addr) external returns (bool){
136         require(state == true);
137         owner = _addr;
138         return true;
139     }
140     function disburse (address char) returns ( bool ){
141         require(state == true);
142         require(owner == msg.sender);
143         uint256 e = sub(block.number,mul(div(block.number,staticblock),staticblock));
144         token.transferFrom(from,char,mul(e,4340277));
145         return true;
146     }
147 }