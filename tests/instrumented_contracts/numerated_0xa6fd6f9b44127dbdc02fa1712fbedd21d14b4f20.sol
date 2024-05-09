1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }  
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20   
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a * b;
23         assert(a == 0 || c / a == b);
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 }
32 
33 contract BCE {
34     
35     using SafeMath for uint256;
36     
37     uint public constant _totalSupply = 21000000;
38     
39     string public constant symbol = "BCE";
40     string public constant name = "Bitcoin Ether";
41     uint8 public constant decimals = 18;
42     
43     // 1 ether = 500 gigs
44     uint256 public constant RATE = 500; 
45     
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48     
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51     
52     function BCEToken() public {
53         balances[msg.sender] = _totalSupply;
54     }
55     
56     function totalSupply() public pure returns (uint256) {
57         return _totalSupply;
58     }
59     
60     
61     function balanceOf(address _owner) public constant returns (uint256 balance){
62         return balances[_owner];
63     }
64     function transfer(address _to, uint256 _value) internal returns (bool success) {
65 		require(_to != 0x0);
66         require(balances[msg.sender] >= _value && _value > 0);
67         balances[msg.sender] = balances[msg.sender].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
73 		require(_to != 0x0);
74         require(allowed [_from][msg.sender] >= 0 && balances[_from] >= _value && _value > 0);
75         balances[_from] = balances[_from].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78         Transfer(_from, _to, _value);
79         return true;
80         
81     }
82     function approve(address _spender, uint256 _value) public returns (bool success){
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
88         return allowed[_owner][_spender];
89     }
90     
91 
92 }