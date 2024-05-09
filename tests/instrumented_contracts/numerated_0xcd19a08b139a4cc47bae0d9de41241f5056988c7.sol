1 pragma solidity ^0.4.18;
2 
3 
4     contract ERC20 {
5     function totalSupply() public constant returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     function transferFrom(address from, address to, uint256 value) public returns (bool);
9     function allowance(address owner, address spender) public view returns (uint256);
10     function approve(address spender, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13     }
14 
15     library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c; 
41     }
42     }
43 
44 
45     contract Bitway is ERC20 {
46     
47     using SafeMath for uint256;
48     
49     
50     uint256 public totalSupply = 0;
51     uint256 public maxSupply = 22000000 * 10 ** uint256(decimals);
52     
53     string public constant symbol = "BTW";
54     string public constant name = "Bitway";
55     uint256 public constant decimals = 18;
56     
57     
58     
59     uint256 public constant RATE = 10000;
60     address public owner;
61     
62    
63     mapping(address => uint256) balances;
64     mapping(address => mapping(address => uint256)) allowed;
65     
66     
67     
68     function () public payable {
69         createTokens();
70         
71     }
72     
73     function Bitway() public {
74         owner = msg.sender;
75         
76     }
77     
78    
79     function createTokens() public payable {
80         require(msg.value > 0);
81         require(totalSupply < maxSupply);
82         uint256 tokens = msg.value.mul(RATE);
83         balances[msg.sender] = balances[msg.sender].add(tokens);
84         totalSupply = totalSupply.add(tokens);
85         
86     }
87     
88     
89     
90     function totalSupply() public constant returns (uint256){
91         return totalSupply;
92     }
93 
94   
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98     
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109     
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111         require(
112         allowed[_from][msg.sender] >= _value
113         && balances[_from] >= _value
114         && _value > 0
115         );
116 
117         balances[_from] = balances[_from].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120         Transfer(_from, _to, _value);
121         return true;
122     }
123     
124     function approve(address _spender, uint256 _value) public returns (bool) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129    
130     function allowance(address _owner, address _spender) public view returns (uint256) {
131         return allowed[_owner][_spender];
132     }
133     
134     event Transfer(address indexed _from, address indexed _to, uint256 _value);
135 
136     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
137     
138 }