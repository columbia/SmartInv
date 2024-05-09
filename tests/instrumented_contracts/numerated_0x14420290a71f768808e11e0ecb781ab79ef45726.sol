1 pragma solidity ^0.4.11;
2 
3   contract ERC20Interface {
4       function totalSupply() constant returns (uint256 totalSupply);
5    
6       function balanceOf(address _owner) constant returns (uint256 balance);
7    
8       function transfer(address _to, uint256 _value) returns (bool success);
9    
10       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11    
12       function approve(address _spender, uint256 _value) returns (bool success);
13    
14       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15    
16       event Transfer(address indexed _from, address indexed _to, uint256 _value);
17    
18       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19   }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal constant returns (uint256) {
33      // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50    
51   contract PostbaseToken is ERC20Interface {
52        using SafeMath for uint256;
53 
54       string public constant symbol = "PB2";
55       string public constant name = "Postbase PB2";
56       uint8 public constant decimals = 8;
57       uint256 _totalSupply = 10000000000000000;
58       
59       address public owner;
60       mapping(address => uint256) balances;
61       mapping(address => mapping (address => uint256)) allowed;
62    
63       // Constructor
64       function PostbaseToken() {
65           owner = msg.sender;
66           balances[owner] = _totalSupply;
67       }
68    
69       function totalSupply() constant returns (uint256 totalSupply) {
70           totalSupply = _totalSupply;
71       }
72    
73       function balanceOf(address _owner) constant returns (uint256 balance) {
74           return balances[_owner];
75       }
76    
77       function transfer(address _to, uint256 _amount) returns (bool success) {
78           
79               balances[msg.sender] = balances[msg.sender].sub(_amount);
80               balances[_to] = balances[_to].add(_amount);
81               Transfer(msg.sender, _to, _amount);
82               return true;
83           
84       }
85    
86       function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
87          
88           var _allowance = allowed[_from][msg.sender];
89 	        balances[_to] = balances[_to].add(_amount);
90     	    balances[_from] = balances[_from].sub(_amount);
91 	        allowed[_from][msg.sender] = _allowance.sub(_amount);
92 	        Transfer(_from, _to, _amount);
93           return true;
94      }
95   
96      function approve(address _spender, uint256 _amount) returns (bool success) {
97          allowed[msg.sender][_spender] = _amount;
98          Approval(msg.sender, _spender, _amount);
99          return true;
100      }
101   
102      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103          return allowed[_owner][_spender];
104      }
105  }