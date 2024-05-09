1 /*
2 This is the DevCash Token Contract
3 
4 DevCash Implements the ERC20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 
6 DevCash will be distributed through bounties at "Blockchain Developers United" and affiliated meetups. www.blockchaindevsunited.com
7 
8 Devcash is intended to incentivize proper Blockchain developer training, grant access to developer resources, and act a medium of exchange in the developer marketplace
9 
10 DevCash is cash for the developer economy
11 
12 The smart contract code can be viewed here: https://github.com/BlockchainDevelopersUnited/DevCash-ERC20
13 
14 For more info about DevCash, visit https://dev.cash
15 .*/
16 
17 pragma solidity ^0.4.8;
18 
19 contract EIP20Interface {
20   
21     /// total amount of tokens
22     uint256 public totalSupply;
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) public view returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) public returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 
57 contract DevCash is EIP20Interface {
58 
59     uint256 constant MAX_UINT256 = 2**256 - 1;
60 
61 
62     string public name;
63     uint8 public decimals;
64     string public symbol;
65 
66      function DevCash(
67 
68         ) public {
69         totalSupply = 21*10**8*10**8;               //DevCash totalSupply
70         balances[msg.sender] = totalSupply;         //Allocate DevCash to contract deployer
71         name = "DevCash";
72         decimals = 8;                               //Amount of decimals for display purposes
73         symbol = "DCASH";
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(balances[msg.sender] >= _value);
78         balances[msg.sender] -= _value;
79         balances[_to] += _value;
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         uint256 allowance = allowed[_from][msg.sender];
86         require(balances[_from] >= _value && allowance >= _value);
87         balances[_to] += _value;
88         balances[_from] -= _value;
89         if (allowance < MAX_UINT256) {
90             allowed[_from][msg.sender] -= _value;
91         }
92         Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function balanceOf(address _owner) view public returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender)
107     view public returns (uint256 remaining) {
108       return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113 }