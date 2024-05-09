1 pragma solidity ^0.4.11;
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
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract UnityCoin {
48            
49     using SafeMath for uint256;
50     
51     string public constant name = "Unity Coin";
52     string public constant symbol = "UNT";
53     uint8 public constant decimals = 18;
54     /* The initially supply is 100,000,000 UNT with 18 decimals */
55     uint256 public constant initialSupply = 100000000000000000000000000;
56 
57     address public owner;
58     mapping(address => uint256) public balances;
59     mapping(address => mapping (address => uint256)) public allowed;
60     uint256 public RATE = 0;
61 	bool canBuy = false;
62 
63 	event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed from, address indexed to, uint256 value);
65 	
66     function UnityCoin() {
67         owner = msg.sender;
68         balances[owner] = initialSupply;
69     }
70     
71    function () payable {
72         convertTokens();
73     }
74     
75 	/* from begin January to end January   around 1 cent per token*/
76     /* from begin Febuary to end Febuary   around 5 cent per token*/
77     /* before and after ..... nothing  */
78     function convertTokens() payable {
79         require(msg.value > 0);
80 		
81 		canBuy = false;        
82         if (now > 1512968674 && now < 1517356800 ) {
83             RATE = 75000;
84             canBuy = true;
85         }
86         if (now >= 15173568001 && now < 1519776000 ) {
87             RATE = 37500;
88             canBuy = true;
89         }
90         if (canBuy) {
91 			uint256 tokens = msg.value.mul(RATE);
92 			balances[msg.sender] = balances[msg.sender].add(tokens);
93 			balances[owner] = balances[owner].sub(tokens);
94 			owner.transfer(msg.value);
95 		}
96     }
97 
98     /* Transfer the balance from the sender's address to the address _to */
99     function transfer(address _to, uint _value) returns (bool success) {
100         if (balances[msg.sender] >= _value
101             && _value > 0
102             && balances[_to] + _value > balances[_to]) {
103             Transfer(msg.sender, _to, _value);
104             return true;
105         } else {
106             return false;
107         }
108     }
109 
110     /* Withdraws to address _to form the address _from up to the amount _value */
111     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
112         if (balances[_from] >= _value
113             && allowed[_from][msg.sender] >= _value
114             && _value > 0
115             && balances[_to] + _value > balances[_to]) {
116 			
117             balances[_from] = balances[_from].sub(_value);
118             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119             balances[_to] = balances[_to].add(_value);
120             Transfer(_from, _to, _value);
121             return true;
122         } else {
123             return false;
124         }
125     }
126 
127     /* Allows _spender to withdraw the _allowance amount form sender */
128     function approve(address _spender, uint256 _allowance) returns (bool success) {
129         if (balances[msg.sender] >= _allowance) {
130             allowed[msg.sender][_spender] = _allowance;
131             Approval(msg.sender, _spender, _allowance);
132             return true;
133         } else {
134             return false;
135         }
136     }
137 
138     /* Checks how much _spender can withdraw from _owner */
139     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
140         return allowed[_owner][_spender];
141     }
142 
143     function totalSupply() constant returns (uint256 totalSupply) {
144         return initialSupply;
145     }
146 
147     function balanceOf(address _address) constant returns (uint256 balance) {
148         return balances[_address];
149     }
150 }