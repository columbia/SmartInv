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
18     return 0;
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
70     }
71     
72     function Bitway() public {
73         owner = msg.sender;
74     }
75     
76    
77     function createTokens() public payable {
78         require(msg.value > 0);
79         require(totalSupply < maxSupply);
80         uint256 tokens = msg.value.mul(RATE);
81         balances[msg.sender] = balances[msg.sender].add(tokens);
82         totalSupply = totalSupply.add(tokens);
83         owner.transfer(msg.value);
84     }
85     
86     
87     
88     function totalSupply() public constant returns (uint256){
89         return totalSupply;
90     }
91 
92   
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96     
97     function transfer(address _to, uint256 _value) public returns (bool) {
98         require(_to != address(0));
99         require(_value <= balances[msg.sender]);
100 
101         // SafeMath.sub will throw if there is not enough balance.
102         balances[msg.sender] = balances[msg.sender].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         Transfer(msg.sender, _to, _value);
105         return true;
106     }
107     
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109         require(
110         allowed[_from][msg.sender] >= _value
111         && balances[_from] >= _value
112         && _value > 0
113         );
114 
115         balances[_from] = balances[_from].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118         Transfer(_from, _to, _value);
119         return true;
120     }
121     
122     function approve(address _spender, uint256 _value) public returns (bool) {
123         allowed[msg.sender][_spender] = _value;
124         Approval(msg.sender, _spender, _value);
125         return true;
126     }
127    
128     function allowance(address _owner, address _spender) public view returns (uint256) {
129         return allowed[_owner][_spender];
130     }
131     
132     event Transfer(address indexed _from, address indexed _to, uint256 _value);
133 
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135     
136 }