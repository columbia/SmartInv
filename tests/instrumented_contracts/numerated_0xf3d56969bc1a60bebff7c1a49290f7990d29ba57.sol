1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-04
3  * Official Coin of Black Dog Dark Net Market
4 */
5 
6 pragma solidity ^0.4.25;
7 
8 interface IERC20 {
9     function totalSupply() constant returns (uint256 totalSupply);
10     function balanceOf(address _owner) constant returns (uint256 balance);
11     function transfer(address _to, uint256 _value) returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
13     function approve(address _spender, uint256 _value) returns (bool success);
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a / b;
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract owned {
44         address public owner;
45 
46         constructor () public {
47             owner = msg.sender;
48         }
49 
50         modifier onlyOwner {
51             require(msg.sender == owner);
52             _;
53         }
54 
55         function transferOwnership(address newOwner) onlyOwner {
56             owner = newOwner;
57         }
58 }
59 
60 contract BlackDog is owned,IERC20{
61     
62     using SafeMath for uint256;
63     
64     uint256 public constant _totalSupply = 666666666000000000000000000;
65  
66     string public constant symbol = 'DOG';
67 
68     string public constant name = 'Black Dog';
69     
70     uint8 public constant decimals = 18;
71     
72     mapping(address => uint256) public balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 
75     constructor() public {
76         balances[msg.sender] = _totalSupply;
77     }
78     
79     function totalSupply() constant returns (uint256 totalSupply) {
80         return _totalSupply;
81     }
82    
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86     
87     function transfer(address _to, uint256 _value) returns (bool success) {
88         require(
89             balances[msg.sender] >= _value
90             && _value > 0
91         );
92         
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
100         require(
101             allowed[_from][msg.sender] >= _value
102             && balances[_from] >= _value
103             && _value > 0  
104         );
105         balances[_from] = balances[_from].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function approve(address _spender, uint256 _value) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121     
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124 
125 }