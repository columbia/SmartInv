1 pragma solidity ^0.4.25;
2  contract Token{
3      uint256 public totalSupply;
4      
5     function balanceOf(address _owner) public  view returns (uint256 balance);
6 
7     function  transfer(address _to, uint256 _value) public  returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value)  public returns   
10     (bool success);
11 
12     function approve(address _spender, uint256 _value) public  returns (bool success);
13 
14     function allowance(address _owner, address _spender) public view returns 
15     (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18  
19     event Approval(address indexed _owner, address indexed _spender, uint256 
20     _value);
21 }
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a / b;
34         return c;
35     }
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract StandardToken is Token {
48     using SafeMath for uint256;
49     function transfer(address _to, uint256 _value) public  returns (bool success) {
50         require(_to != address(0));
51         require(balances[msg.sender] >= _value);   
52         balances[msg.sender] = balances[msg.sender].sub(_value);
53         balances[_to] = balances[_to].add(_value);
54         emit Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58 
59     function transferFrom(address _from, address _to, uint256 _value) public  returns 
60     (bool success) {
61         require(_to != address(0));
62         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
63         balances[_to] = balances[_to].add(_value);
64         balances[_from] = balances[_from].sub(_value); 
65         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
66         emit Transfer(_from, _to, _value);
67         return true;
68     }
69     function balanceOf(address _owner) public  view  returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73 
74     function approve(address _spender, uint256 _value) public  returns (bool success)   
75     {
76         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
77         allowed[msg.sender][_spender] = _value;
78         emit Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender)  public  view returns (uint256 remaining) {
83         return allowed[_owner][_spender];
84     }
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 }
88 
89 contract QaMzyeToken is StandardToken { 
90 
91   
92  string public name = "QaMzyeToken";
93 
94    
95  string public symbol = "QMY";
96 
97    
98  uint8 public decimals = 18;
99 
100    
101  uint256 public INITIAL_SUPPLY = 520000000 * (10 ** 18);
102 
103     
104 
105  constructor() public 
106  {
107  
108       totalSupply = INITIAL_SUPPLY;
109     
110       balances[msg.sender] = INITIAL_SUPPLY;
111    
112       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
113   
114   }
115 
116  
117 
118     /* Approves and then calls the receiving contract */
119     
120     function  approveAndCall (address  _spender, uint256  _value, bytes memory _extraData) public  returns (bool success) {
121         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
122         allowed[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124       if(
125           !_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData))
126         ) { revert();}
127         return true;
128     }
129 
130 }