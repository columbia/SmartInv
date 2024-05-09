1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a / b;
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract owned {
39         address public owner;
40 
41         constructor() public {
42             owner = 0x953600669b794BB7a2E0Bc6C5a7f5fA96c3c1928;
43         }
44 
45         modifier onlyOwner {
46             require(msg.sender == owner);
47             _;
48         }
49 
50         function transferOwnership(address newOwner) onlyOwner public {
51             owner = newOwner;
52         }
53 }
54 
55 contract EzyStayz is owned,IERC20{
56     
57     using SafeMath for uint256;
58     
59     uint256 public _totalSupply = 40000000000000000000000;
60  
61     string public constant symbol = 'EZY';
62 
63     string public constant name = 'EzyStayz';
64     
65     uint8 public constant decimals = 14;
66     
67     mapping(address => uint256) public balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 
70     constructor() public {
71         balances[msg.sender] = _totalSupply;
72     }
73     
74     function totalSupply() constant public returns (uint256 totSupply) {
75         return _totalSupply;
76     }
77    
78     function balanceOf(address _owner) constant public returns (uint256 balance) {
79         return balances[_owner];
80     }
81     
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         require(
84             balances[msg.sender] >= _value
85             && _value > 0
86         );
87         
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         require(
96             allowed[_from][msg.sender] >= _value
97             && balances[_from] >= _value
98             && _value > 0  
99         );
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103         emit Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         emit Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116     
117     /**
118      * @dev Burns a specific amount of tokens.
119      */
120     function burn(uint256 _value) public {
121         _burn(msg.sender, _value);
122     }
123    
124     function _burn(address account, uint256 value) internal {
125         require(account != 0);
126         require(value <= balances[account]);
127     
128         _totalSupply = _totalSupply.sub(value);
129         balances[account] = balances[account].sub(value);
130         emit Transfer(account, address(0), value);
131     }
132     
133     event Transfer(address indexed _from, address indexed _to, uint256 _value);
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135 
136 }