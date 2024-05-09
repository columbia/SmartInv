1 pragma solidity ^0.4.24;
2 
3 contract ERC20Token{
4     //ERC20 base standard
5     uint256 public totalSupply;
6     
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     
15     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16     
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract Owned{
22     address public owner;
23     address public newOwner;
24 
25     event OwnerUpdate(address _prevOwner, address _newOwner);
26 
27     /**
28         @dev constructor
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     // allows execution by the owner only
35     modifier onlyOwner {
36         assert(msg.sender == owner);
37         _;
38     }
39 
40     /**
41         @dev allows transferring the contract ownership
42         the new owner still need to accept the transfer
43         can only be called by the contract owner
44 
45         @param _newOwner    new contract owner
46     */
47     function transferOwnership(address _newOwner) public onlyOwner {
48         require(_newOwner != owner);
49         newOwner = _newOwner;
50     }
51 
52     /**
53         @dev used by a new owner to accept an ownership transfer
54     */
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 /*
64     Overflow protected math functions
65 */
66 contract SafeMath {
67     /**
68         constructor
69     */
70     constructor() public{
71     }
72 
73        // Check if it is safe to add two numbers
74     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint c = a + b;
76         assert(c >= a && c >= b);
77         return c;
78     }
79 
80     // Check if it is safe to subtract two numbers
81     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint c = a - b;
83         assert(b <= a && c <= a);
84         return c;
85     }
86 
87     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint c = a * b;
89         assert(a == 0 || (c / a) == b);
90         return c;
91     }
92 
93 }
94 
95 contract MANXERC20 is SafeMath, ERC20Token, Owned {
96     string public constant name = 'MacroChain Computing And Networking System';                              // Set the token name for display
97     string public constant symbol = 'MANX';                                  // Set the token symbol for display
98     uint8 public constant decimals = 18;                                     // Set the number of decimals for display
99     uint256 public constant INITIAL_SUPPLY = 10000000000 * 10 ** uint256(decimals);
100     uint256 public totalSupply;
101     string public version = '2';
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104     
105     modifier rejectTokensToContract(address _to) {
106         require(_to != address(this));
107         _;
108     }
109     
110     constructor() public {
111         totalSupply = INITIAL_SUPPLY;                              // Set the total supply
112         balances[msg.sender] = INITIAL_SUPPLY;                     // Creator address is assigned all
113         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
114     }
115     
116     function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public returns (bool success) {
117         require(_to != address(0));
118         require(_value <= balances[msg.sender]);
119 
120         balances[msg.sender] = safeSub(balances[msg.sender], _value);
121         balances[_to] = safeAdd(balances[_to], _value);
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public returns (bool success) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = safeSub(balances[_from],_value);
132         balances[_to] = safeAdd(balances[_to],_value);
133         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function approve(address _spender, uint256 _value) public returns (bool success) {
139         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144     
145     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
146       return allowed[_owner][_spender];
147     }
148     
149     function balanceOf(address _owner) public view returns (uint256 balance) {
150         return balances[_owner];
151     }
152     
153     function approveAndCallN(address _spender, uint256 _value, uint256 _extraNum) public returns (bool success) {
154         allowed[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156 
157         //to avoid the EVM decoding bug, the passed value set to a number
158         if(!_spender.call(abi.encodeWithSelector(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,uint256)"))), msg.sender, _value, this, _extraNum))) { revert(); }
159         return true;
160     }
161     
162     function claimTokens(address _token) onlyOwner public {
163         require(_token != address(0));
164 
165         ERC20Token token = ERC20Token(_token);
166         uint balance = token.balanceOf(address(this));
167         token.transfer(owner, balance);
168     }
169 
170 
171 }