1 pragma solidity ^0.4.25;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public view returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public view returns (uint256 balance);
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public returns (bool success);
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     
39 }
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 contract StandardToken is Token {
68     using SafeMath for uint256;
69 
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         require(_to != address(0));
72     
73         // SafeMath.sub will throw if there is not enough balance.
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         emit Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         require(_to != address(0));
82     
83         balances[_from] = balances[_from].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86         emit Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function balanceOf(address _owner) public constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) public returns (bool success) {
95         require(_value == 0 || allowed[msg.sender][_spender] == 0);
96         allowed[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107     uint256 public totalSupply;
108 }
109 
110 
111 //name this contract whatever you'd like
112 contract ERC20Token is StandardToken {
113 
114     function () public{
115         //if ether is sent to this address, send it back.
116         revert();
117     }
118 
119     /* Public variables of the token */
120 
121     /*
122     NOTE:
123     The following variables are OPTIONAL vanities. One does not have to include them.
124     They allow one to customise the token contract & in no way influences the core functionality.
125     Some wallets/interfaces might not even bother to look at this information.
126     */
127     string public name;                   //fancy name: eg Simon Bucks
128     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
129     string public symbol;                 //An identifier: eg SBX
130     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
131 
132 //
133 // CHANGE THESE VALUES FOR YOUR TOKEN
134 //
135 
136 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
137 
138     constructor() public {
139         balances[msg.sender] = 5515335275000;               // Give the creator all initial tokens (100000 for example)
140         totalSupply = 5515335275000;                        // Update total supply (100000 for example)
141         name = "dietbitcoin";                                   // Set the name for display purposes
142         decimals = 2;                            // Amount of decimals for display purposes
143         symbol = "DDX";                               // Set the symbol for display purposes
144     }
145 
146     /* Approves and then calls the receiving contract */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150 
151         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
152         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
153         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
154         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
155         return true;
156     }
157 }