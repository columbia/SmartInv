1 pragma solidity ^0.4.17;
2 
3 contract ETHTest01Token{
4     mapping (address => uint256) balances;
5     address public owner;
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     // total amount of tokens
10     uint256 public totalSupply;
11     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
12     mapping (address => mapping (address => uint256)) allowed;
13     constructor() public {
14         owner = 0xF48be01754b8FC91a48D193D0194bBd4f8e2DB6b;          // Set owner of contract
15         name = "ETHTest01";                                   // Set the name for display purposes
16         symbol = "ETHTest01";                                           // Set the symbol for display purposes
17         decimals = 18;                                            // Amount of decimals for display purposes
18         totalSupply = 10000000000000000000000000000;               // Total supply
19         balances[owner] = totalSupply;
20     }
21 
22     /// @return The totalSupply
23     function totalSupply() public constant returns (uint256) {
24         return totalSupply;
25     }
26 
27     /// @param _owner The address from which the balance will be retrieved
28     /// @return The balance
29     function balanceOf(address _owner) public constant returns (uint256 balance) {
30         return balances[_owner];
31     }
32 
33     /// @notice send `_value` token to `_to` from `msg.sender`
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transfer(address _to, uint256 _value) public returns (bool success) {
38         require(balances[msg.sender] >= _value);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         emit Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
46     /// @param _from The address of the sender
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(balances[_from] >= _value);                 // Check if the sender has enough
52         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
53         require(_value <= allowed[_from][msg.sender]);      // Check allowance
54         balances[_from] -= _value;
55         balances[_to] += _value;
56         allowed[_from][msg.sender] -= _value;
57         emit Transfer(_from, _to, _value);
58         return true;
59     }
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of tokens to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     /// @param _owner The address of the account owning tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @return Amount of remaining tokens allowed to spent
74     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }
77 
78     /* This unnamed function is called whenever someone tries to send ether to it */
79     function () private {
80         revert();     // Prevents accidental sending of ether
81     }
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }