1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract SinoeCoin is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner;
45 
46     mapping (address => uint256) balances; 
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     string public constant name = "SinoeCoin";
50     string public constant symbol = "Sinoe";
51     uint public constant decimals = 18;
52     uint256 _Rate = 10 ** decimals;
53     
54     uint256 public totalSupply = 100000000000 * _Rate;
55 
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 
59     event Burn(address indexed burner, uint256 val);
60     event Increase(address indexed increaser,uint256 val);
61     
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     modifier onlyPayloadSize(uint size) {
68         assert(msg.data.length >= size + 4);
69         _;
70     }
71 
72      function SinoeCoin () public {
73         owner = msg.sender;
74         balances[owner] = totalSupply;
75     }
76 
77     function transferOwnership(address newOwner) onlyOwner public {
78         if (newOwner != address(0) && newOwner != owner){//1 && newOwner != owner2) {
79              owner = newOwner;   
80         }
81     }
82 
83     function balanceOf(address _owner) constant public returns (uint256) {
84 	    return balances[_owner];
85     }
86 
87     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
88 
89         require(_to != address(0));
90         require(_amount <= balances[msg.sender]);
91         balances[msg.sender] = balances[msg.sender].sub(_amount);
92         balances[_to] = balances[_to].add(_amount);
93         Transfer(msg.sender, _to, _amount);
94         return true;
95     }
96   
97     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
98 
99         require(_to != address(0));
100         require(_amount <= balances[_from]);
101         require(_amount <= allowed[_from][msg.sender]);
102         
103         balances[_from] = balances[_from].sub(_amount);
104         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
105         balances[_to] = balances[_to].add(_amount);
106         Transfer(_from, _to, _amount);
107         return true;
108     }
109 
110     function approve(address _spender, uint256 _value) public returns (bool success) {
111         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) constant public returns (uint256) {
118         return allowed[_owner][_spender];
119     }
120 
121     function burn(uint256 _value) onlyOwner public {
122         if(_value<_Rate){
123             _value = _value*_Rate;
124         }
125         require(_value <= balances[msg.sender]);
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         totalSupply = totalSupply.sub(_value);
128         Increase(msg.sender, _value);
129     }
130 
131     function increase(uint256 _value) onlyOwner public {
132         if(_value < _Rate){
133             _value = _value*_Rate;
134         }
135         balances[msg.sender] = balances[msg.sender].add(_value);
136         totalSupply = totalSupply.add(_value);
137         Increase(msg.sender, _value);
138     }
139 }