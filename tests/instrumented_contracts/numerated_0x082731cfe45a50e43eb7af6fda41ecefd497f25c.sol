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
37     uint public _totalSupply = 0; 
38     
39     string public constant symbol = "BCE";
40     string public constant name = "Bitcoin Ether";
41     uint8 public constant decimals = 18;
42 	uint256 public totalSupply = _totalSupply * 10 ** uint256(decimals);
43     
44     // 1 ether = 500 bitcoin ethers
45     uint256 public constant RATE = 500; 
46     
47     address public owner;
48     
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51     
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     
55 	function () public payable {
56         createTokens();
57     } 
58     
59     function BCEToken() public {
60         owner = msg.sender;
61     }
62     
63 	function createTokens() public payable {
64 	    require(_totalSupply <= 21000000); // Max Bitcoin Ethers in circulation = 21 mil. 
65         require(msg.value > 0);
66         uint256 tokens = msg.value.mul(RATE);
67         balances[msg.sender] = balances[msg.sender].add(tokens);
68         _totalSupply = _totalSupply.add(tokens);
69         owner.transfer(msg.value);
70     } 
71     
72     function balanceOf(address _owner) public constant returns (uint256 balance){
73         return balances[_owner];
74     }
75     
76     function transfer(address _to, uint256 _value) internal returns (bool success) {
77 		require(_to != 0x0);
78         require(balances[msg.sender] >= _value && _value > 0);
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84     
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
86 		require(_to != 0x0);
87         require(allowed [_from][msg.sender] >= 0 && balances[_from] >= _value && _value > 0);
88         balances[_from] = balances[_from].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94     
95     function approve(address _spender, uint256 _value) public returns (bool success){
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100     
101     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
102         return allowed[_owner][_spender];
103     }
104 }