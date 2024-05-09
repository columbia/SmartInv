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
44     uint public _totalSupply;
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address who) public constant returns (uint);
47     function transfer(address to, uint value) public;
48     event Transfer(address indexed from, address indexed to, uint value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52     function allowance(address owner, address spender) public constant returns (uint);
53     function transferFrom(address from, address to, uint value) public;
54     function approve(address spender, uint value) public;
55     event Approval(address indexed owner, address indexed spender, uint value);
56 }
57  
58 
59 
60 contract ERCToken is ERC20{
61     using SafeMath for uint;
62     
63 
64     address public platformAdmin;
65     
66     
67     modifier onlyOwner() {
68         require(msg.sender == platformAdmin);
69         _;
70     }
71     
72     
73 
74     constructor(string _tokenName, string _tokenSymbol,uint256 _decimals,uint _initialSupply) public {
75         platformAdmin = msg.sender;
76         _totalSupply = _initialSupply * 10 ** uint256(_decimals); 
77         decimals=_decimals;
78         name = _tokenName;
79         symbol = _tokenSymbol;
80         balances[msg.sender]=_totalSupply;
81     }
82     
83 
84   
85     
86     
87      function totalSupply() public constant returns (uint){
88          return _totalSupply;
89      }
90      
91       function balanceOf(address _owner) constant returns (uint256 balance) {
92             return balances[_owner];
93           }
94   
95         function approve(address _spender, uint _value) {
96             allowed[msg.sender][_spender] = _value;
97             Approval(msg.sender, _spender, _value);
98         }
99         
100       
101         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102           return allowed[_owner][_spender];
103         }
104         
105         
106        function transfer(address _to, uint _value) public {
107        
108             require(balances[msg.sender] >= _value);
109             require(balances[_to].add(_value) > balances[_to]);
110             balances[msg.sender]=balances[msg.sender].sub(_value);
111             balances[_to]=balances[_to].add(_value);
112             Transfer(msg.sender, _to, _value);
113         }
114    
115         function transferFrom(address _from, address _to, uint256 _value) public  {
116          
117             require(balances[_from] >= _value);
118             require(allowed[_from][msg.sender] >= _value);
119             require(balances[_to] + _value > balances[_to]);
120           
121             balances[_to]=balances[_to].add(_value);
122             balances[_from]=balances[_from].sub(_value);
123             allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
124             Transfer(_from, _to, _value);
125         }
126     
127 }