1 pragma solidity ^0.4.16;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner()  {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         if (newOwner != address(0)) {
18             owner = newOwner;
19         }
20     }
21 
22 }
23 
24 contract SafeMath {
25     function safeSub(uint a, uint b) pure internal returns (uint) {
26         sAssert(b <= a);
27         return a - b;
28     }
29 
30     function safeAdd(uint a, uint b) pure internal returns (uint) {
31         uint c = a + b;
32         sAssert(c>=a && c>=b);
33         return c;
34     }
35 
36     function sAssert(bool assertion) internal pure {
37         if (!assertion) {
38             revert();
39         }
40     }
41 }
42 
43 
44 contract ERC20 {
45     uint public totalSupply;
46     function balanceOf(address who) public constant returns (uint);
47     function allowance(address owner, address spender) public constant returns (uint);
48 
49     function transfer(address toAcct, uint value) public returns (bool ok);
50     function transferFrom(address fromAcct, address toAcct, uint value) public returns (bool ok);
51     function approve(address spender, uint value) public returns (bool ok);
52     event Transfer(address indexed fromAcct, address indexed toAcct, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 }
55 
56 contract StandardToken is ERC20, SafeMath {
57 
58     mapping(address => uint) balances;
59     mapping (address => mapping (address => uint)) allowed;
60     mapping (address => bool) public frozenAccount;
61     event FrozenFunds(address target, bool frozen);
62     event Burn(address indexed fromAcct, uint256 value);
63 
64     function transfer(address _toAcct, uint _value) public returns (bool success) {
65         balances[msg.sender] = safeSub(balances[msg.sender], _value);
66         balances[_toAcct] = safeAdd(balances[_toAcct], _value);
67         Transfer(msg.sender, _toAcct, _value);
68         return true;
69     }
70 
71     function transferFrom(address _fromAcct, address _toAcct, uint _value) public returns (bool success) {
72         var _allowance = allowed[_fromAcct][msg.sender];
73         balances[_toAcct] = safeAdd(balances[_toAcct], _value);
74         balances[_fromAcct] = safeSub(balances[_fromAcct], _value);
75         allowed[_fromAcct][msg.sender] = safeSub(_allowance, _value);
76         Transfer(_fromAcct, _toAcct, _value);
77         return true;
78     }
79 
80     function balanceOf(address _owner) public constant returns (uint balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint _value) public  returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
91         return allowed[_owner][_spender];
92     }
93     
94     function burn(uint256 _value) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], _value); // Subtract from the sender
96         totalSupply = safeSub(totalSupply,_value); // Updates totalSupply
97         Burn(msg.sender, _value);
98         return true;
99     }
100     
101     
102 
103 }
104 
105 contract TCCCoin is Ownable, StandardToken {
106 
107     string public name;
108     string public symbol;
109     uint public decimals;                  
110     uint public totalSupply;  
111 
112 
113     /// @notice Initializes the contract and allocates all initial tokens to the owner and agreement account
114     function TCCCoin() public {
115     totalSupply = 100 * (10**6) * (10**6);
116         balances[msg.sender] = totalSupply;
117         name = "TCC";
118         symbol = "TCC";
119         decimals = 6;
120     }
121 
122     function () payable public{
123     }
124 
125     /// @notice To transfer token contract ownership
126     /// @param _newOwner The address of the new owner of this contract
127     function transferOwnership(address _newOwner) public onlyOwner {
128         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
129         balances[owner] = 0;
130         Ownable.transferOwnership(_newOwner);
131     }
132 
133     // Owner can transfer out any ERC20 tokens sent in by mistake
134     function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success)
135     {
136         return ERC20(tokenAddress).transfer(owner, amount);
137     }
138     
139     function freezeAccount(address target, bool freeze) public onlyOwner  {
140         frozenAccount[target] = freeze;
141         FrozenFunds(target, freeze);
142     }
143     
144     function mintToken(address _toAcct, uint256 _value) public onlyOwner  {
145         balances[_toAcct] = safeAdd(balances[_toAcct], _value);
146         totalSupply = safeAdd(totalSupply, _value);
147         Transfer(0, this, _value);
148         Transfer(this, _toAcct, _value);
149     }
150 
151 }