1 // This is the smart contract for LydianCoin (LDN)
2 // LydianCoin is a utility token engineered to meet the digital marketing needs of the crypto and blockchain space. 
3 
4 //Please see - https://lydian.io, for more details
5 //The whitepaper is available here - ldn.im/whitepaper
6 
7 
8 
9 // Abstract contract for the full ERC 20 Token standard
10 // https://github.com/ethereum/EIPs/issues/20
11 pragma solidity ^0.4.18;
12 
13 
14 contract EIP20Interface {
15     
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name  
48     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 /*
53 Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
54 .*/
55 
56 contract LydianCoin is EIP20Interface {
57 
58     uint256 constant private MAX_UINT256 = 2**256 - 1;
59     mapping (address => uint256) public balances;
60     mapping (address => mapping (address => uint256)) public allowed;
61    
62     string public name = "LydianCoin";                 
63     uint8 public decimals = 8;                //Decimals.
64     string public symbol = "LDN";                 
65     uint256 initialAmount = 40000000000000000;
66     
67     
68     function LydianCoin(
69     ) public {
70         balances[0x15C89975217025E0a9385648acAD26b84Eb0E767] = initialAmount;               // Give the creator all initial tokens
71         totalSupply = initialAmount;                     
72     }
73 
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         require(balances[msg.sender] >= _value);
76         balances[msg.sender] -= _value;
77         balances[_to] += _value;
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         uint256 allowance = allowed[_from][msg.sender];
84         require(balances[_from] >= _value && allowance >= _value);
85         balances[_to] += _value;
86         balances[_from] -= _value;
87         if (allowance < MAX_UINT256) {
88             allowed[_from][msg.sender] -= _value;
89         }
90         Transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
105         return allowed[_owner][_spender];
106     }   
107 }