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
18     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract admined { //This token contract is administered
31     address public admin; //Admin address is public
32     uint public lockThreshold; //Lock tiime is public
33     address public allowedAddr; //There can be an address that can use the token during a lock, its public
34 
35     function admined() internal {
36         admin = msg.sender; //Set initial admin to contract creator
37         Admined(admin);
38     }
39 
40     modifier onlyAdmin() { //A modifier to define admin-only functions
41         require(msg.sender == admin);
42         _;
43     }
44 
45     modifier endOfLock() { //A modifier to lock transactions until finish of time (or being allowed)
46         require(now > lockThreshold || msg.sender == allowedAddr);
47         _;
48     }
49 
50     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
51         admin = _newAdmin;
52         TransferAdminship(admin);
53     }
54 
55     function addAllowedToTransfer (address _allowedAddr) onlyAdmin public { //Here the special address that can transfer during a lock is set
56         allowedAddr = _allowedAddr;
57         AddAllowedToTransfer (allowedAddr);
58     }
59 
60     function setLock(uint _timeInMins) onlyAdmin public { //Only the admin can set a lock on transfers
61         require(_timeInMins > 0);
62         uint mins = _timeInMins * 1 minutes;
63         lockThreshold = SafeMath.add(now,mins);
64         SetLock(lockThreshold);
65     }
66 
67     //All admin actions have a log for public review
68     event SetLock(uint timeInMins);
69     event AddAllowedToTransfer (address allowedAddress);
70     event TransferAdminship(address newAdminister);
71     event Admined(address administer);
72 
73 }
74 
75 contract Token is admined {
76 
77     uint256 public totalSupply;
78     mapping (address => uint256) balances; //Balances mapping
79     mapping (address => mapping (address => uint256)) allowed; //Allowance mapping
80 
81     function balanceOf(address _owner) public constant returns (uint256 bal) {
82         return balances[_owner];
83     }
84 
85     function transfer(address _to, uint256 _value) endOfLock public returns (bool success) {
86         require(balances[msg.sender] >= _value);
87         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
88         balances[_to] = SafeMath.add(balances[_to], _value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) endOfLock public returns (bool success) {
94         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
95         balances[_to] = SafeMath.add(balances[_to], _value);
96         balances[_from] = SafeMath.sub(balances[_from], _value);
97         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function approve(address _spender, uint256 _value) endOfLock public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111 
112     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin endOfLock public {
113         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
114         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
115         Transfer(0, this, _mintedAmount);
116         Transfer(this, _target, _mintedAmount);
117     }
118 
119     function burnToken(address _target, uint256 _burnedAmount) onlyAdmin endOfLock public {
120         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
121         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
122         Burned(_target, _burnedAmount);
123     }
124     //This is an especial Admin-only function to make massive tokens assignments
125     function batch(address[] data,uint256 amount) onlyAdmin public { //It takes an array of addresses and an amount
126         require(balances[this] >= data.length*amount); //The contract must hold the needed tokens
127         for (uint i=0; i<data.length; i++) { //It moves over the array
128             address target = data[i]; //Take an address
129             balances[target] = SafeMath.add(balances[target], amount); //Add an amount to the target address
130             balances[this] = SafeMath.sub(balances[this], amount); //Sub that amount from the contract
131             allowed[this][msg.sender] = SafeMath.sub(allowed[this][msg.sender], amount); //Sub allowance from the contract creator over the contract
132             Transfer(this, target, amount); //log every transfer
133         }
134     }
135 
136     //Events to log transactions
137     event Transfer(address indexed _from, address indexed _to, uint256 _value);
138     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
139     event Burned(address indexed _target, uint256 _value);
140 }
141 
142 contract Asset is admined, Token {
143 
144     string public name;
145     uint8 public decimals = 18;
146     string public symbol;
147     string public version = '0.1';
148     uint256 initialAmount = 80000000000000000000000000; //80Million tonkens to be created
149 
150     function Asset(
151         string _tokenName,
152         string _tokenSymbol
153         ) public {
154         balances[this] = 79920000000000000000000000; // Initial 99.9% stay on the contract
155         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 80000000000000000000000; //Initial 0.1% for contract writer
156         allowed[this][msg.sender] = 79920000000000000000000000; //Set allowance for the contract creator/administer over the contract holded amount
157         totalSupply = initialAmount; //Total supply is the initial amount at Asset
158         name = _tokenName; //Name set on deployment
159         symbol = _tokenSymbol; //Simbol set on deployment
160         Transfer(0, this, initialAmount);
161         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, 80000000000000000000000);
162         Approval(this, msg.sender, 79920000000000000000000000);
163     }
164 
165     function() {
166         revert();
167     }
168 
169 }