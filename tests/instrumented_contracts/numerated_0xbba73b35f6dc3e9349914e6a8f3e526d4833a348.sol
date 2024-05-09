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
44     address[] users;
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
62 contract YXToken is ERC20{
63     using SafeMath for uint;
64     
65 
66     address public platformAdmin;
67     
68 
69 
70     modifier onlyOwner() {
71         require(msg.sender == platformAdmin);
72         _;
73     }
74 
75     constructor(string _tokenName, string _tokenSymbol,uint256 _decimals,uint _initialSupply) public {
76         platformAdmin = msg.sender;
77         _totalSupply = _initialSupply * 10 ** uint256(_decimals); 
78         decimals=_decimals;
79         name = _tokenName;
80         symbol = _tokenSymbol;
81         balances[msg.sender]=_totalSupply;
82     }
83     
84 
85   
86     
87     
88      function totalSupply() public constant returns (uint){
89          return _totalSupply;
90      }
91      
92       function balanceOf(address _owner) constant returns (uint256 balance) {
93             return balances[_owner];
94           }
95   
96         function approve(address _spender, uint _value) {
97             allowed[msg.sender][_spender] = _value;
98             Approval(msg.sender, _spender, _value);
99         }
100         
101       
102         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103           return allowed[_owner][_spender];
104         }
105         
106         
107        function transfer(address _to, uint _value) public {
108             require(balances[msg.sender] >= _value);
109             require(balances[_to].add(_value) > balances[_to]);
110             balances[msg.sender]=balances[msg.sender].sub(_value);
111             balances[_to]=balances[_to].add(_value);
112             Transfer(msg.sender, _to, _value);
113         }
114    
115         function transferFrom(address _from, address _to, uint256 _value) public  {
116             require(balances[_from] >= _value);
117             require(allowed[_from][msg.sender] >= _value);
118             require(balances[_to] + _value > balances[_to]);
119           
120             balances[_to]=balances[_to].add(_value);
121             balances[_from]=balances[_from].sub(_value);
122             allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
123             Transfer(_from, _to, _value);
124         }
125         
126  
127     
128 }