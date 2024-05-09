1 /*
2 1. All rights to the smart contract, the PGCT tokens and the receipts are owned by the Golden Currency Group. 
3 
4 2. The PGCT token is a transitional token of the crowdfunding campaign. 
5 Token is not a security and does not provide any profit payment for its owners or any rights similar to shareholders rights. 
6 The PGCT Token is to be exchanged for the future Golden Currency token, 
7 which will be released as part of the main round of the ICO campaign. 
8 Future Golden Currency token is planned to become a security token, providing additional incentives for project contributors (like dividends and buyback), 
9 yet it will be realized only in case all legal procedures are fulfilled, 
10 Golden Currency Group does not ensure it becoming a security token and disclaims all liability relating thereto. 
11 
12 3. The PGCT-future Golden Currency token exchange procedure will include the mandatory KYC process, 
13 the exchange will be refused for those who do not pass the KYC procedure. 
14 The exchange will be refused for residents of countries who are legally prohibited from participating in such crowdfunding campaigns.
15 */
16 
17 pragma solidity ^0.4.21;
18 
19 contract ERC20Basic {
20   function totalSupply() public view returns (uint256);
21   function balanceOf(address who) public view returns (uint256);
22   function transfer(address to, uint256 value) public returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25  
26 library SafeMath {
27 
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     return a / b;
39   }
40 
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52  
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58   mapping(address => bool   ) isInvestor;
59   address[] public arrInvestors;
60   
61   uint256 totalSupply_;
62 
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   function addInvestor(address _newInvestor) internal {
68     if (!isInvestor[_newInvestor]){
69        isInvestor[_newInvestor] = true;
70        arrInvestors.push(_newInvestor);
71     }  
72       
73   }
74     function getInvestorsCount() public view returns(uint256) {
75         return arrInvestors.length;
76         
77     }
78 
79 /*
80 minimun one token to transfer
81 or only all rest
82 */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     if (balances[msg.sender] >= 1 ether){
85         require(_value >= 1 ether);     // minimun one token to transfer
86     } else {
87         require(_value == balances[msg.sender]); //only all rest
88     }
89     
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     addInvestor(_to);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100 
101     function transferToken(address _to, uint256 _value) public returns (bool) {
102         return transfer(_to, _value.mul(1 ether));
103     }
104 
105 
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112  
113 
114 contract BurnableToken is BasicToken {
115 
116   event Burn(address indexed burner, uint256 value);
117 
118   function burn(uint256 _value) public {
119     _burn(msg.sender, _value);
120   }
121 
122   function _burn(address _who, uint256 _value) internal {
123     require(_value <= balances[_who]);
124     balances[_who] = balances[_who].sub(_value);
125     totalSupply_ = totalSupply_.sub(_value);
126     emit Burn(_who, _value);
127     emit Transfer(_who, address(0), _value);
128   }
129 }
130 
131 
132 contract GoldenCurrencyToken is BurnableToken {
133   string public constant name = "Pre-ICO Golden Currency Token";
134   string public constant symbol = "PGCT";
135   uint32 public constant decimals = 18;
136   uint256 public INITIAL_SUPPLY = 7600000 * 1 ether;
137 
138   function GoldenCurrencyToken() public {
139     totalSupply_ = INITIAL_SUPPLY;
140     balances[msg.sender] = INITIAL_SUPPLY;      
141   }
142 }