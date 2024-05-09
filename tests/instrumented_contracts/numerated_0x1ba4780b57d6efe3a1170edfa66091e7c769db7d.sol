1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.18;
7 
8 contract EIP20Interface {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public view returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     // solhint-disable-next-line no-simple-event-func-name  
50     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 contract Clen is EIP20Interface {
55 
56     uint256 constant private MAX_UINT256 = 2**256 - 1;
57     mapping (address => uint256) public balances;
58     mapping (address => mapping (address => uint256)) public allowed;
59     /*
60     NOTE:
61     The following variables are OPTIONAL vanities. One does not have to include them.
62     They allow one to customise the token contract & in no way influences the core functionality.
63     Some wallets/interfaces might not even bother to look at this information.
64     */
65     string public name;                   //fancy name: eg Simon Bucks
66     uint8 public decimals;                //How many decimals to show.
67     string public symbol;                 //An identifier: eg SBX
68 
69     function Clen(
70         uint256 _initialAmount,
71         string _tokenName,
72         uint8 _decimalUnits,
73         string _tokenSymbol
74     ) public {
75         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
76         totalSupply = _initialAmount;                        // Update total supply
77         name = _tokenName;                                   // Set the name for display purposes
78         decimals = _decimalUnits;                            // Amount of decimals for display purposes
79         symbol = _tokenSymbol;                               // Set the symbol for display purposes
80     }
81 
82     //수신자(_to) 로 해당금액(_value)를 송금. 송금이 성공하면 TRUE를 반환하고, 실패하면 FALSE를 반환.
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         require(balances[msg.sender] >= _value);
85         balances[msg.sender] -= _value;
86         balances[_to] += _value;
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90     //송신자(_from)주소에서 수신자(_to) 주소로 해당금액(_value)을 송금. 송금이 성공하면 TRUE를 반환하고, 실패하면 FALSE를 반환.
91     //transferFrom이 성공하려면 먼저 approve 인터페이스를 사용하여 일정금액을 인출할수 있도록 허락하여야 함.
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         uint256 allowance = allowed[_from][msg.sender];
94         require(balances[_from] >= _value && allowance >= _value);
95         balances[_to] += _value;
96         balances[_from] -= _value;
97         if (allowance < MAX_UINT256) {
98             allowed[_from][msg.sender] -= _value;
99         }
100         Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     //owner가 보유한 토큰잔액을 반환
105     function balanceOf(address _owner) public view returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     //송신자(msg.sender)가 보유한 토큰에서 일정금액(_value)만큼의 토큰을 인출할수 있는 권한을 수신자(_spender)에게 부여.
110     function approve(address _spender, uint256 _value) public returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     //토큰 소유자(_owner)가 토큰 수신자(_spender)에게 인출을 허락한 토큰이 얼마인지를 반환.
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }   
120 }