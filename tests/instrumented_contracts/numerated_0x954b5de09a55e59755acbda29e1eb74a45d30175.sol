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
47 /** @title FluzFluz (FLUZ contract) **/
48 
49 contract Fluz is Token {
50 
51     string public constant name = "FluzFluz";
52     string public constant symbol = "FLUZ";
53     uint8 public constant decimals = 18;
54     uint256 public constant totalSupply = 204780000 * 10**18;
55 
56     uint public launched = 0; // Time of locking distribution and retiring founder; 0 means not launched
57     address public founder = 0x81D5ce5Bf1F4F0a576De11Fd9631e789D72c9BdE; // Founder's address
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60     
61     bool public transfersAreLocked = true;
62 
63     function Fluz() public {
64         balances[founder] = totalSupply;
65     }
66     
67     /**
68      * Modifier to check whether transfers are unlocked or the owner is sending
69      */
70     modifier canTransfer() {
71         require(msg.sender == founder || !transfersAreLocked);
72         _;
73     }
74     
75     /**
76      * Modifier to allow only founder to transfer
77      */
78     modifier onlyFounder() {
79         require(msg.sender == founder);
80         _;
81     }
82 
83     /**
84      * Transfer with checking if it's allowed
85      */
86     function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {
87         if (balances[msg.sender] < _value) {
88             return false;
89         }
90         balances[msg.sender] -= _value;
91         balances[_to] += _value;
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Transfer with checking if it's allowed
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {
100         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
101             return false;
102         }
103         allowed[_from][msg.sender] -= _value;
104         balances[_from] -= _value;
105         balances[_to] += _value;
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Default balanceOf function
112      */
113     function balanceOf(address _owner) public constant returns (uint256 balance) {
114         return balances[_owner];
115     }
116 
117     /**
118      * Default approval function
119      */
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     /**
127      * Get user allowance
128      */
129     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
130         return allowed[_owner][_spender];
131     }
132 
133     /**
134      * Launch and retire the founder 
135      */
136     function launch() public onlyFounder {
137         launched = block.timestamp;
138         founder = 0x0;
139     }
140     
141     /**
142      * Change transfer locking state
143      */
144     function changeTransferLock(bool locked) public onlyFounder {
145         transfersAreLocked = locked;
146     }
147 
148     function() public { // no direct purchases
149         revert();
150     }
151 
152 }