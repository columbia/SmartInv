1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 //import './SafeMath.sol';
16 
17 /**
18  * Math operations with safety checks
19  */
20 library SafeMath {
21   function mul(uint a, uint b) internal returns (uint) {
22     uint c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint a, uint b) internal returns (uint) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint a, uint b) internal returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint a, uint b) internal returns (uint) {
40     uint c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a >= b ? a : b;
47   }
48 
49   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a < b ? a : b;
51   }
52 
53   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a >= b ? a : b;
55   }
56 
57   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a < b ? a : b;
59   }
60 
61   function assert(bool assertion) internal {
62     if (!assertion) {
63       throw;
64     }
65   }
66 }
67 
68 contract BITBIX is ERC20Basic {
69     
70     using SafeMath for uint256;
71     
72     //                                  30,000,000.00000000
73     uint public  _totalSupply = 3000000000000000; 
74     
75     // name and branding
76     string public constant name = "BITBIX";
77     string public constant symbol = "BBX";
78     uint8 public constant decimals = 8;
79     
80     
81     address public owner;
82     
83     mapping(address => uint256) balances; 
84     mapping(address => mapping(address => uint256)) allowed;
85     
86    
87     function BITBIX() 
88     { 
89         balances[msg.sender] = _totalSupply; 
90         owner = msg.sender;
91         
92     } 
93     
94   
95     function totalSupply() constant returns (uint256 totalSupply) 
96     {
97         return _totalSupply; 
98     } 
99     
100     function balanceOf(address _owner) constant returns (uint256 balance) 
101     {
102         return balances[_owner]; 
103     }
104     
105     function transfer(address _to, uint256 _value) returns (bool success) 
106     {
107         require(
108             balances[msg.sender] >= _value 
109             && _value > 0 
110             ); 
111             
112         balances[msg.sender] = balances[msg.sender].sub(_value); 
113         balances[_to] = balances[_to].add(_value); 
114         
115         Transfer(msg.sender, _to, _value); 
116         return true; 
117     }
118     
119     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
120         require(
121             allowed[_from][msg.sender] >= _value
122             && balances[_from] >= _value
123             && _value > 0
124             );
125             balances[_from] = balances[_from].sub(_value);
126             balances[_to] = balances[_to].add(_value);
127             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128             Transfer(_from,_to,_value);
129             return true;
130     }
131     
132     function approve(address _spender, uint256 _value) returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137     
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139         return allowed[_owner][_spender];
140     }
141     
142     event Transfer(address indexed _from, address indexed _to, uint256 _value);
143     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
144 }