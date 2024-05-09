1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() public constant returns (uint256 totalSup);
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success); 
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract Joe2 is IERC20 {
15     
16     using SafeMath for uint256;
17     
18     uint public constant _totalSupply = 2100000000e18;
19     //starting supply of Token
20     
21     string public constant symbol = "JOE2";
22     string public constant name = "JOE2 Token";
23     uint8 public constant decimals = 18;
24     
25     mapping(address => uint256) balances;
26     mapping(address => mapping(address => uint256)) allowed;
27     
28     function Joe2() public{
29         balances[msg.sender] = _totalSupply;
30     }
31 
32     function totalSupply() public constant returns (uint256 totalSup) {
33         return _totalSupply;
34     }
35     
36     function balanceOf(address _owner) public constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39     
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         require(
42             balances[msg.sender] >= _value
43             && _value > 0
44         );
45         balances[msg.sender] = balances[msg.sender].sub(_value);
46         balances[_to] = balances[_to].add(_value);
47         Transfer(msg.sender, _to, _value);
48         return true;
49     }
50     
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(
53             allowed[_from][msg.sender] >= _value  
54             && balances[_from] >= _value
55             && _value > 0
56         );
57         balances[_from] = balances[_from].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
60         Transfer(_from, _to, _value);
61         return true;
62     }
63     
64     function approve(address _spender, uint256 _value) public returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69     
70     function allowance(address _owner, address _spender) public constant returns (uint256 remaing) {
71         return allowed[_owner][_spender];
72     }
73     
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77 }
78 
79 /**
80  * @title SafeMath
81  * @dev Math operations with safety checks that throw on error
82  */
83 library SafeMath {
84   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85     if (a == 0) {
86       return 0;
87     }
88     uint256 c = a * b;
89     assert(c / a == b);
90     return c;
91   }
92 
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return c;
98   }
99 
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }