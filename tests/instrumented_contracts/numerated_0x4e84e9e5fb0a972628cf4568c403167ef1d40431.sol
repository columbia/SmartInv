1 pragma solidity ^0.4.19;
2 
3 /**
4  * ERC 20 token
5  * https://github.com/ethereum/EIPs/issues/20
6  */
7 interface Token {
8 
9     /// @return total amount of tokens
10     /// function totalSupply() public constant returns (uint256 supply);
11     /// do not declare totalSupply() here, see https://github.com/OpenZeppelin/zeppelin-solidity/issues/434
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 }
45 
46 
47 /** @title PROVISIONAL SMART CONTRACT for Fluzcoin (FFC) **/
48 
49 contract Fluzcoin is Token {
50 
51     string public constant name = "Fluzcoin";
52     string public constant symbol = "FFC";
53     uint8 public constant decimals = 18;
54     uint256 public constant totalSupply = 3223000000 * 10**18;
55 
56     uint public launched = 0; // Time of locking distribution and retiring founder; 0 means not launched
57     address public founder = 0xCB7ECAB8EEDd4b53d0F48E421D56fBA262AF57FC; // Founder's address
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60     
61     bool public transfersAreLocked = true;
62 
63     function Fluzcoin() public {
64         balances[founder] = totalSupply;
65         Transfer(0x0, founder, totalSupply);
66     }
67     
68     /**
69      * Modifier to check whether transfers are unlocked or the owner is sending
70      */
71     modifier canTransfer() {
72         require(msg.sender == founder || !transfersAreLocked);
73         _;
74     }
75     
76     /**
77      * Modifier to allow only founder to transfer
78      */
79     modifier onlyFounder() {
80         require(msg.sender == founder);
81         _;
82     }
83 
84     /**
85      * Transfer with checking if it's allowed
86      */
87     function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {
88         if (balances[msg.sender] < _value) {
89             return false;
90         }
91         balances[msg.sender] -= _value;
92         balances[_to] += _value;
93         Transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Transfer with checking if it's allowed
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {
101         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
102             return false;
103         }
104         allowed[_from][msg.sender] -= _value;
105         balances[_from] -= _value;
106         balances[_to] += _value;
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Default balanceOf function
113      */
114     function balanceOf(address _owner) public constant returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118     /**
119      * Default approval function
120      */
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     /**
128      * Get user allowance
129      */
130     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133 
134     /**
135      * Launch and retire the founder 
136      */
137     function launch() public onlyFounder {
138         launched = block.timestamp;
139         founder = 0x0;
140     }
141     
142     /**
143      * Change transfer locking state
144      */
145     function changeTransferLock(bool locked) public onlyFounder {
146         transfersAreLocked = locked;
147     }
148 
149     function() public { // no direct purchases
150         revert();
151     }
152 
153 }