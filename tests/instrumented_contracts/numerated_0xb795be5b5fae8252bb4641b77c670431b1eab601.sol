1 pragma solidity ^0.5.7;
2 
3 /*
4 --------------------------------------------------------------------------------
5 Waste Chain Coin Smart Contract
6 
7 Credit	: Rejean Leclerc 
8 Mail 	: rejean.leclerc123@gmail.com
9 
10 --------------------------------------------------------------------------------
11 */
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract WasteChainCoin {
40            
41     using SafeMath for uint256;
42     
43     string public constant name = "Waste Chain Coin";
44     string public constant symbol = "WCC";
45     uint8 public constant decimals = 18;
46     /* The initially/total supply is 10,000,000,000 WCC with 18 decimals */
47     uint256 public constant _totalSupply  = 10000000000000000000000000000;
48     
49     address payable owner;
50     mapping(address => uint256) public balances;
51     mapping(address => mapping (address => uint256)) public allowed;
52     uint256 public RATE = 0;
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed from, address indexed to, uint256 value);
56 	
57 	constructor() public {
58 	    owner = msg.sender; 
59         balances[owner] = _totalSupply;	    
60 	}
61     
62    function () external payable {
63         convertTokens();
64     }
65     
66     function convertTokens() public payable {
67         require(msg.value > 0);
68 		
69         RATE = 18000;
70 	    uint256 tokens = msg.value.mul(RATE);
71     	balances[msg.sender] = balances[msg.sender].add(tokens);
72 	    balances[owner] = balances[owner].sub(tokens);
73     	owner.transfer(msg.value);
74     }
75 
76     /* Transfer the balance from the sender's address to the address _to */
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         if (balances[msg.sender] >= _value
79             && _value > 0
80             && balances[_to] + _value > balances[_to]) {
81               balances[msg.sender] = balances[msg.sender].sub(_value);
82               balances[_to] = balances[_to].add(_value);
83               emit Transfer(msg.sender, _to, _value);
84               return true;
85         } else {
86             return false;
87         }
88     }
89 
90     /* Withdraws to address _to form the address _from up to the amount _value */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         if (balances[_from] >= _value
93             && allowed[_from][msg.sender] >= _value
94             && _value > 0
95             && balances[_to] + _value > balances[_to]) {
96               balances[_from] = balances[_from].sub(_value);
97               allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98               balances[_to] = balances[_to].add(_value);
99               emit Transfer(_from, _to, _value);
100               return true;
101         } else {
102             return false;
103         }
104     }
105 
106     /* Allows _spender to withdraw the _allowance amount form sender */
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108         if (balances[msg.sender] >= _value) {
109             allowed[msg.sender][_spender] = _value;
110             emit Approval(msg.sender, _spender, _value);
111             return true;
112         } else {
113             return false;
114         }
115     }
116 
117     /* Checks how much _spender can withdraw from _owner */
118     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122    function balanceOf(address _address) public view returns (uint256 balance) {
123         return balances[_address];
124     }
125     
126     function totalSupply() public view returns (uint256 totalSupply) {
127         return _totalSupply;
128     }
129 }