1 pragma solidity ^0.4.18;
2 
3 /**
4  * Copyright 2018, Flowchain.co
5  *
6  * The Flowchain tokens smart contract
7  */
8  
9 contract Mintable {
10     function mintToken(address to, uint amount) external returns (bool success);  
11     function setupMintableAddress(address _mintable) public returns (bool success);
12 }
13 
14 contract ApproveAndCallReceiver {
15     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData);    
16 }
17 
18 contract Token {
19 
20     /// The total amount of tokens
21     uint256 public totalSupply;
22 
23     /// @param _owner The address from which the balance will be retrieved
24     /// @return The balance
25     function balanceOf(address _owner) public view returns (uint256 balance);
26 
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34     /// @param _from The address of the sender
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39 
40     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @param _value The amount of wei to be approved for transfer
43     /// @return Whether the approval was successful or not
44     function approve(address _spender, uint256 _value) public returns (bool success);
45 
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
50 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 contract StandardToken is Token {
56 
57     uint256 constant private MAX_UINT256 = 2**256 - 1;
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         require(balances[msg.sender] >= _value);
63         // Not overflow
64         require(balances[_to] + _value >= balances[_to]);
65         balances[msg.sender] -= _value;
66         balances[_to] += _value;
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         uint256 allowance = allowed[_from][msg.sender];
73         require(balances[_from] >= _value && allowance >= _value);
74         // Not overflow
75         require(balances[_to] + _value >= balances[_to]);          
76         balances[_to] += _value;    
77         balances[_from] -= _value;
78         if (allowance < MAX_UINT256) {
79             allowed[_from][msg.sender] -= _value;
80         }  
81 
82         Transfer(_from, _to, _value);
83         return true; 
84     }
85 
86     function balanceOf(address _owner) public view returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
97       return allowed[_owner][_spender];
98     }
99 }
100 
101 
102 //name this contract whatever you'd like
103 contract FlowchainToken is StandardToken, Mintable {
104 
105     /* Public variables of the token */
106     string public name = "FlowchainCoin";
107     string public symbol = "FLC";    
108     uint8 public decimals = 18;
109     string public version = "1.0";
110     address public mintableAddress;
111     address public multiSigWallet;    
112     address public creator;
113 
114     function() payable { revert(); }
115 
116     function FlowchainToken() public {
117         // 1 billion tokens + 18 decimals
118         totalSupply = 10**27;                   
119         creator = msg.sender;
120         mintableAddress = 0x9581973c54fce63d0f5c4c706020028af20ff723;
121         multiSigWallet = 0x9581973c54fce63d0f5c4c706020028af20ff723;        
122         // Give the multisig wallet all initial tokens
123         balances[multiSigWallet] = totalSupply;  
124         Transfer(0x0, multiSigWallet, totalSupply);
125     }
126 
127     function setupMintableAddress(address _mintable) public returns (bool success) {
128         require(msg.sender == creator);    
129         mintableAddress = _mintable;
130         return true;
131     }
132 
133     /// @dev Mint an amount of tokens and transfer to the backer
134     /// @param to The address of the backer who will receive the tokens
135     /// @param amount The amount of rewarded tokens
136     /// @return The result of token transfer
137     function mintToken(address to, uint256 amount) external returns (bool success) {
138         require(msg.sender == mintableAddress);
139         require(balances[multiSigWallet] >= amount);
140         balances[multiSigWallet] -= amount;
141         balances[to] += amount;
142         Transfer(multiSigWallet, to, amount);
143         return true;
144     }
145 
146     /// @dev This function makes it easy to get the creator of the tokens
147     /// @return The address of token creator
148     function getCreator() constant returns (address) {
149         return creator;
150     }
151 
152     /// @dev This function makes it easy to get the mintableAddress
153     /// @return The address of token creator
154     function getMintableAddress() constant returns (address) {
155         return mintableAddress;
156     }
157 
158     /* Approves and then calls the receiving contract */
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool success) {
160         allowed[msg.sender][_spender] = _value;
161         Approval(msg.sender, _spender, _value);
162 
163         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
164 
165         ApproveAndCallReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
166 
167         return true;
168     }
169 }