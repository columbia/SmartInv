1 pragma solidity ^0.4.11;
2 /*
3 Token Contract with batch assignments
4 
5 ERC-20 Token Standar Compliant - ConsenSys
6 
7 Contract developer: Fares A. Akel C.
8 f.antonio.akel@gmail.com
9 MIT PGP KEY ID: 078E41CB
10 */
11 
12 /**
13  * @title SafeMath by OpenZeppelin
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract admined { //This token contract is administered
31     address public admin; //Admin address is public
32 
33     function admined() internal {
34         admin = msg.sender; //Set initial admin to contract creator
35         Admined(admin);
36     }
37 
38     modifier onlyAdmin() { //A modifier to define admin-only functions
39         require(msg.sender == admin);
40         _;
41     }
42 
43     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
44         admin = _newAdmin;
45         TransferAdminship(admin);
46     }
47 
48 
49     //All admin actions have a log for public review
50     event SetLock(uint timeInMins);
51     event TransferAdminship(address newAdminister);
52     event Admined(address administer);
53 
54 }
55 
56 contract Token is admined {
57 
58     uint256 public totalSupply;
59     mapping (address => uint256) balances; //Balances mapping
60     mapping (address => mapping (address => uint256)) allowed; //Allowance mapping
61 
62     function balanceOf(address _owner) public constant returns (uint256 bal) {
63         return balances[_owner];
64     }
65 
66     function transfer(address _to, uint256 _value) public returns (bool success) {
67         require(balances[msg.sender] >= _value);
68         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
69         balances[_to] = SafeMath.add(balances[_to], _value);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
76         balances[_to] = SafeMath.add(balances[_to], _value);
77         balances[_from] = SafeMath.sub(balances[_from], _value);
78         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
79         Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
90         return allowed[_owner][_spender];
91     }
92 
93     //This is an especial Admin-only function to make massive tokens assignments
94     //It is optimized to waste the less gass possible
95     //It mint the tokens to distribute
96     function batch(address[] data,uint256 amount) onlyAdmin public { //It takes an array of addresses and an amount
97         uint256 length = data.length;
98         for (uint i=0; i<length; i++) { //It moves over the array
99             transfer(data[i],amount); //Add an amount to the target address
100         }
101     }
102 
103     //Events to log transactions
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 }
107 
108 contract Asset is admined, Token {
109 
110     string public name;
111     uint8 public decimals = 18;
112     string public symbol;
113     string public version = '0.1';
114 
115     function Asset(
116         string _tokenName,
117         string _tokenSymbol,
118         uint256 _initialAmount
119         ) public {
120         balances[msg.sender] = _initialAmount;
121         totalSupply = _initialAmount; //Total supply is the initial amount at Asset
122         name = _tokenName; //Name set on deployment
123         symbol = _tokenSymbol; //Simbol set on deployment
124         Transfer(0, this, _initialAmount);
125         Transfer(this, msg.sender, _initialAmount);
126     }
127 
128     function() public {
129         revert();
130     }
131 
132 }