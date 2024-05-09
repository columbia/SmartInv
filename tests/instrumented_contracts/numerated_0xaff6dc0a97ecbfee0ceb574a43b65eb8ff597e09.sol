1 pragma solidity ^0.4.18;
2 
3 /*
4 --------------------------------------------------------------------------------
5 Unity Coin Smart Contract
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
39 contract UnityCoin {
40            
41     using SafeMath for uint256;
42     
43     string public constant name = "Unity Coin";
44     string public constant symbol = "UNT";
45     uint8 public constant decimals = 18;
46     /* The initially/total supply is 100,000,000 UNT with 18 decimals */
47     uint256 public constant _totalSupply  = 100000000000000000000000000;
48     
49     address public owner;
50     mapping(address => uint256) public balances;
51     mapping(address => mapping (address => uint256)) public allowed;
52     uint256 public RATE = 0;
53 	bool canBuy = false;
54 
55 	event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed from, address indexed to, uint256 value);
57 	
58     function UnityCoin() public {
59         owner = msg.sender;
60         balances[owner] = _totalSupply;
61     }
62     
63    function () public payable {
64         convertTokens();
65     }
66     
67 	/* from 12/12/2017 to 31/01/2018   */
68     /* from 31/01/2018 to 01/03/2018   */
69     /* before and after ..... nothing  */
70     function convertTokens() public payable {
71         require(msg.value > 0);
72 		
73 		canBuy = false;        
74         if (now > 1512968674 && now < 1517356800 ) {
75             RATE = 100000;
76             canBuy = true;
77         }
78         if (now >= 1517356800 && now < 1519776000 ) {
79             RATE = 50000;
80             canBuy = true;
81         }
82         if (canBuy) {
83 			uint256 tokens = msg.value.mul(RATE);
84 			balances[msg.sender] = balances[msg.sender].add(tokens);
85 			balances[owner] = balances[owner].sub(tokens);
86 			owner.transfer(msg.value);
87 		}
88     }
89 
90     /* Transfer the balance from the sender's address to the address _to */
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         if (balances[msg.sender] >= _value
93             && _value > 0
94             && balances[_to] + _value > balances[_to]) {
95 			balances[msg.sender] = balances[msg.sender].sub(_value);
96             balances[_to] = balances[_to].add(_value);
97             Transfer(msg.sender, _to, _value);
98             return true;
99         } else {
100             return false;
101         }
102     }
103 
104     /* Withdraws to address _to form the address _from up to the amount _value */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         if (balances[_from] >= _value
107             && allowed[_from][msg.sender] >= _value
108             && _value > 0
109             && balances[_to] + _value > balances[_to]) {
110             balances[_from] = balances[_from].sub(_value);
111             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112             balances[_to] = balances[_to].add(_value);
113             Transfer(_from, _to, _value);
114             return true;
115         } else {
116             return false;
117         }
118     }
119 
120     /* Allows _spender to withdraw the _allowance amount form sender */
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         if (balances[msg.sender] >= _value) {
123             allowed[msg.sender][_spender] = _value;
124             Approval(msg.sender, _spender, _value);
125             return true;
126         } else {
127             return false;
128         }
129     }
130 
131     /* Checks how much _spender can withdraw from _owner */
132     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
133         return allowed[_owner][_spender];
134     }
135 
136    function balanceOf(address _address) public constant returns (uint256 balance) {
137         return balances[_address];
138     }
139     
140     function totalSupply() public constant returns (uint256 totalSupply) {
141         return _totalSupply;
142     }
143     
144 }