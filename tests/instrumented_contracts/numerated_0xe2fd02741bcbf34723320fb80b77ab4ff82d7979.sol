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
33 contract BCEToken {
34     
35     using SafeMath for uint256;
36     
37     uint public constant _totalSupply = 21000000; // FOR SUPPLY = 0, DELETE "constant"
38     
39     string public constant symbol = "BCE";
40     string public constant name = "Bitcoin Ether";
41     uint8 public constant decimals = 18;
42 	uint256 public constant totalSupply = _totalSupply * 10 ** uint256(decimals);
43     
44     // 1 ether = 500 gigs
45     uint256 public constant RATE = 500; 
46     
47     //FOR INITIAL SUPPLY = 0:
48     //address public owner;
49     
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52     
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     
56     //FOR INITIAL SUPPLY = 0:
57     /*
58 		 function () public payable {
59         createTokens();
60     	} 
61 	*/
62     
63     function GigsToken() public {
64         balances[msg.sender] = totalSupply;
65         
66         //FOR INITIAL SUPPLY = 0:
67         //owner = msg.sender;
68     }
69     
70     //FOR INITIAL SUPPLY = 0:
71     /*
72 		 function createTokens() public payable {
73         require(msg.value > 0);
74         uint256 tokens = msg.value.mul(RATE);
75         balances[msg.sender] = balances[msg.sender].add(tokens);
76         _totalSupply = _totalSupply.add(tokens);
77         owner.transfer(msg.value);
78     	} 
79 	*/
80     
81     function balanceOf(address _owner) public constant returns (uint256 balance){
82         return balances[_owner];
83     }
84     function transfer(address _to, uint256 _value) internal returns (bool success) {
85 		 require(_to != 0x0);
86         require(balances[msg.sender] >= _value && _value > 0);
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
93 		 require(_to != 0x0);
94         require(allowed [_from][msg.sender] >= 0 && balances[_from] >= _value && _value > 0);
95         balances[_from] = balances[_from].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98         Transfer(_from, _to, _value);
99         return true;
100         
101     }
102     function approve(address _spender, uint256 _value) public returns (bool success){
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
108         return allowed[_owner][_spender];
109     }
110     
111 
112 }