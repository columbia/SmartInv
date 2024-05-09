1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-21
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
48     uint public _totalSupply;
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address who) public constant returns (uint);
51     function transfer(address to, uint value) public;
52     event Transfer(address indexed from, address indexed to, uint value);
53 }
54 
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public constant returns (uint);
57     function transferFrom(address from, address to, uint value) public;
58     function approve(address spender, uint value) public;
59     event Approval(address indexed owner, address indexed spender, uint value);
60 }
61  
62 
63 
64 contract ERCToken is ERC20{
65     using SafeMath for uint;
66     
67 
68     address public platformAdmin;
69     
70     
71     constructor(string _tokenName, string _tokenSymbol,uint256 _decimals,uint _initialSupply) public {
72         platformAdmin = msg.sender;
73         _totalSupply = _initialSupply * 10 ** uint256(_decimals); 
74         decimals=_decimals;
75         name = _tokenName;
76         symbol = _tokenSymbol;
77         balances[msg.sender]=_totalSupply;
78     }
79     
80 
81   
82     
83     
84      function totalSupply() public constant returns (uint){
85          return _totalSupply;
86      }
87      
88       function balanceOf(address _owner) constant returns (uint256 balance) {
89             return balances[_owner];
90           }
91   
92         function approve(address _spender, uint _value) {
93             allowed[msg.sender][_spender] = _value;
94             Approval(msg.sender, _spender, _value);
95         }
96         
97       
98         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99           return allowed[_owner][_spender];
100         }
101         
102         
103        function transfer(address _to, uint _value) public {
104        
105             require(balances[msg.sender] >= _value);
106             require(balances[_to].add(_value) > balances[_to]);
107             balances[msg.sender]=balances[msg.sender].sub(_value);
108             balances[_to]=balances[_to].add(_value);
109             Transfer(msg.sender, _to, _value);
110         }
111    
112         function transferFrom(address _from, address _to, uint256 _value) public  {
113          
114             require(balances[_from] >= _value);
115             require(allowed[_from][msg.sender] >= _value);
116             require(balances[_to] + _value > balances[_to]);
117           
118             balances[_to]=balances[_to].add(_value);
119             balances[_from]=balances[_from].sub(_value);
120             allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
121             Transfer(_from, _to, _value);
122         }
123     
124 }