1 pragma solidity ^0.4.23;
2 
3 contract SafeMath {
4     
5     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
8         require(x <= MAX_UINT256 - y);
9         return x + y;
10     }
11 
12     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
13         require(x >= y);
14         return x - y;
15     }
16 
17     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
18         if (y == 0) {
19             return 0;
20         }
21         require(x <= (MAX_UINT256 / y));
22         return x * y;
23     }
24 }
25 
26 contract Owned {
27     address public owner;
28     address public newOwner;
29 
30     constructor() public{
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         assert(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address _newOwner) public onlyOwner {
40         require(_newOwner != owner);
41         newOwner = _newOwner;
42     }
43 
44     function acceptOwnership() public {
45         require(msg.sender == newOwner);
46         emit OwnerUpdate(owner, newOwner);
47         owner = newOwner;
48         newOwner = 0x0;
49     }
50 
51     event OwnerUpdate(address _prevOwner, address _newOwner);
52 }
53 
54 contract ERC20TokenInterface {
55   function totalSupply() public constant returns (uint256 _totalSupply);
56   function balanceOf(address _owner) public constant returns (uint256 balance);
57   function transfer(address _to, uint256 _value) public returns (bool success);
58   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
59   function approve(address _spender, uint256 _value) public returns (bool success);
60   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
61 
62   event Transfer(address indexed _from, address indexed _to, uint256 _value);
63   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 }
65 
66 contract TokenRecipientInterface {
67   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
68 }
69 
70 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned {
71 
72     /* Public variables of the token */
73     string public standard;
74     string public name;
75     string public symbol;
76     uint8 public decimals;
77 
78     address public beerContract;
79 
80     /* Private variables of the token */
81     uint256 supply = 0;
82     uint256 burnt = 0;
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowances;
85 
86     event Mint(address indexed _to, uint256 _value);
87     event Burn(address indexed _from, uint _value);
88 
89     /* Returns total supply of issued tokens */
90     function totalSupply() constant public returns (uint256) {
91         return supply;
92     }
93 
94     /* Returns balance of address */
95     function balanceOf(address _owner) constant public returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     /* Transfers tokens from your address to other */
100     function transfer(address _to, uint256 _value) public returns (bool success) {
101         require(_to != 0x0 && _to != address(this));
102         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
103         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
104         emit Transfer(msg.sender, _to, _value);                              // Raise Transfer event
105         return true;
106     }
107 
108     /* Approve other address to spend tokens on your account */
109     function approve(address _spender, uint256 _value) public returns (bool success) {
110         allowances[msg.sender][_spender] = _value;        // Set allowance
111         emit Approval(msg.sender, _spender, _value);           // Raise Approval event
112         return true;
113     }
114 
115     /* Approve and then communicate the approved contract in a single tx */
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
117         TokenRecipientInterface spender = TokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
118         approve(_spender, _value);                                              // Set approval to contract for _value
119         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
120         return true;
121     }
122 
123     /* A contract attempts to get the coins */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
125         require(_to != 0x0 && _to != address(this));
126         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
127         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
128         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
129         emit Transfer(_from, _to, _value);                                                   // Raise Transfer event
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
134         return allowances[_owner][_spender];
135     }
136 
137     function mint(address _to, uint256 _amount) public {
138         require(msg.sender == beerContract);
139         supply = safeAdd(supply, _amount);
140         balances[_to] = safeAdd(balances[_to], _amount);
141         emit Mint(_to, _amount);
142         emit Transfer(0x0, _to, _amount);
143     }
144 
145     function burn(address _burnee, uint _amount) public {
146         require(msg.sender == beerContract);
147         balances[_burnee] = safeSub(balanceOf(_burnee), _amount);
148         supply = safeSub(supply, _amount);
149         burnt = safeAdd(burnt, _amount);
150         emit Burn(_burnee, _amount);
151         emit Transfer(_burnee, 0x0, _amount);
152     }
153     
154     function setbeerContract(address _beerContract) onlyOwner public {
155         beerContract = _beerContract;
156     }
157     
158     function getBurnAmount() public view returns(uint256 burnAmount){
159       return burnt;
160     }
161 
162     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
163         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
164     }
165 }
166 
167 contract MihCoinToken is ERC20Token {
168 
169   /* Initializes contract */
170   constructor() public{ 
171     standard = "MihCoin token v1.0";
172     name = "MHCToken";
173     symbol = "MHC";
174     decimals = 18;
175     /* Change before start*/
176     beerContract = 0x0;  
177   }
178 }