1 pragma solidity ^0.4.19;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
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
41         function owned() {
42             owner = msg.sender;
43         }
44 
45         modifier onlyOwner {
46             require(msg.sender == owner);
47             _;
48         }
49 
50         function transferOwnership(address newOwner) onlyOwner {
51             owner = newOwner;
52         }
53 }
54 
55 contract HashBux is owned,IERC20{
56     
57     using SafeMath for uint256;
58     
59     uint256 public _totalSupply = 80000000;
60  
61     string public symbol = 'HASH';
62 
63     string public name = 'HashBux';
64     
65     uint8 public decimals = 0;
66     
67     mapping(address => uint256) public balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 
70     function HashBux() {
71         balances[msg.sender] = _totalSupply;
72     }
73     
74     // HashBux-specific
75    function mine( uint256 newTokens ) public onlyOwner {
76         require(newTokens + _totalSupply <= 4000000000);
77     
78         _totalSupply = _totalSupply.add(newTokens);
79         balances[owner] = balances[owner].add(newTokens);
80         Transfer(this, owner, newTokens);
81    }
82     
83     function totalSupply() constant returns (uint256 totalSupply) {
84         return _totalSupply;
85     }
86    
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90     
91     function transfer(address _to, uint256 _value) returns (bool success) {
92         require(
93             balances[msg.sender] >= _value
94             && _value > 0
95         );
96         
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104         require(
105             allowed[_from][msg.sender] >= _value
106             && balances[_from] >= _value
107             && _value > 0  
108         );
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125     
126     event Transfer(address indexed _from, address indexed _to, uint256 _value);
127     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
128 
129 }