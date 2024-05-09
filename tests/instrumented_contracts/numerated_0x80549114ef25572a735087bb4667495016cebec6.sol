1 pragma solidity ^0.4.24;
2 
3 /*
4 --------------------------------------------------------------------------------
5 TradeAds Coin Smart Contract
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
39 contract TradeAdsCoin {
40            
41     using SafeMath for uint256;
42     
43     string public constant name = "TradeAds Coin";
44     string public constant symbol = "TRD";
45     uint8 public constant decimals = 18;
46     /* The initially/total supply is 100,000,000 TRD with 18 decimals */
47     uint256 public constant _totalSupply  = 100000000000000000000000000;
48     
49     address public owner;
50     mapping(address => uint256) public balances;
51     mapping(address => mapping (address => uint256)) public allowed;
52     
53 	event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed from, address indexed to, uint256 value);
55 	
56     function TradeAdsCoin() public {
57         owner = msg.sender;
58         balances[owner] = _totalSupply;
59     }
60     
61    function () public payable {
62         tTokens();
63     }
64     
65 	function tTokens() public payable {
66         require(msg.value > 0);
67 		balances[msg.sender] = balances[msg.sender].add(msg.value);
68 		balances[owner] = balances[owner].sub(msg.value);
69 		owner.transfer(msg.value);
70     }
71 
72     /* Transfer the balance from the sender's address to the address _to */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         if (balances[msg.sender] >= _value
75             && _value > 0
76             && balances[_to] + _value > balances[_to]) {
77 			balances[msg.sender] = balances[msg.sender].sub(_value);
78             balances[_to] = balances[_to].add(_value);
79             Transfer(msg.sender, _to, _value);
80             return true;
81         } else {
82             return false;
83         }
84     }
85 
86     /* Withdraws to address _to form the address _from up to the amount _value */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         if (balances[_from] >= _value
89             && allowed[_from][msg.sender] >= _value
90             && _value > 0
91             && balances[_to] + _value > balances[_to]) {
92             balances[_from] = balances[_from].sub(_value);
93             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94             balances[_to] = balances[_to].add(_value);
95             Transfer(_from, _to, _value);
96             return true;
97         } else {
98             return false;
99         }
100     }
101 
102     /* Allows _spender to withdraw the _allowance amount form sender */
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104         if (balances[msg.sender] >= _value) {
105             allowed[msg.sender][_spender] = _value;
106             Approval(msg.sender, _spender, _value);
107             return true;
108         } else {
109             return false;
110         }
111     }
112 
113     /* Checks how much _spender can withdraw from _owner */
114     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118    function balanceOf(address _address) public constant returns (uint256 balance) {
119         return balances[_address];
120     }
121     
122     function totalSupply() public constant returns (uint256 totalSupply) {
123         return _totalSupply;
124     }
125     
126 }