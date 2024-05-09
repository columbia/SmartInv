1 pragma solidity ^0.4.11;
2 contract ShowCoinToken{
3     mapping (address => uint256) balances;
4     address public owner;
5     address public lockOwner;
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public lockAmount ;
10     uint256 public startTime ;
11     // total amount of tokens
12     uint256 public totalSupply;
13     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
14     mapping (address => mapping (address => uint256)) allowed;
15     function ShowCoinToken() public {
16         owner = 0xd32c3c303BD6bd65066C1373720b5442A414f9CC;          // Set owner of contract
17         lockOwner = 0xC9BA6e5Eda033c66D34ab64d02d14590963Ce0c2;
18         startTime = 1514649600;
19         name = "ShowCoin";                                   // Set the name for display purposes
20         symbol = "Show";                                           // Set the symbol for display purposes
21         decimals = 18;                                            // Amount of decimals for display purposes
22         totalSupply = 10000000000000000000000000000;               // Total supply
23         balances[owner] = totalSupply * 90 /100 ;
24         balances[0x7b9b375B036dF9482033Aa7fee9273c78F40Aa85]=20000000000000000;
25         lockAmount = totalSupply / 10 ;
26     }
27 
28     /// @param _owner The address from which the balance will be retrieved
29     /// @return The balance
30     function balanceOf(address _owner) public constant returns (uint256 balance) {
31         return balances[_owner];
32     }
33 
34     /// @notice send `_value` token to `_to` from `msg.sender`
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transfer(address _to, uint256 _value) public returns (bool success) {
39         require(_value > 0 );                                      // Check send token value > 0;
40         require(balances[msg.sender] >= _value);
41         balances[msg.sender] -= _value;
42         balances[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45     }
46 
47     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(balances[_from] >= _value);                 // Check if the sender has enough
54         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
55         require(_value <= allowed[_from][msg.sender]);      // Check allowance
56         balances[_from] -= _value;
57         balances[_to] += _value;
58         allowed[_from][_to] -= _value;
59         Transfer(_from, _to, _value);
60         return true;
61     }
62 
63     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @param _value The amount of tokens to be approved for transfer
66     /// @return Whether the approval was successful or not
67     function approve(address _spender, uint256 _value) public returns (bool success) {
68         require(balances[msg.sender] >= _value);
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     /// @param _owner The address of the account owning tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @return Amount of remaining tokens allowed to spent
77     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
78         return allowed[_owner][_spender];
79     }
80 
81     /* This unnamed function is called whenever someone tries to send ether to it */
82     function () private {
83         revert();     // Prevents accidental sending of ether
84     }
85 
86     function releaseToken() public{
87         require(now >= startTime +2 years);
88         uint256 i = ((now  - startTime -2 years) / (0.5 years));
89         uint256  releasevalue = totalSupply /40 ;
90         require(lockAmount > (4 - i - 1) * releasevalue);
91         lockAmount -= releasevalue ;
92         balances[lockOwner] +=  releasevalue ;
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }