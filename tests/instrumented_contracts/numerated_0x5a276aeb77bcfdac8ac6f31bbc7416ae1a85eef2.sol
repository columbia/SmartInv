1 pragma solidity 0.4.24;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     // solhint-disable-next-line no-simple-event-func-name
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract LoveToken is EIP20Interface {
51 
52     uint256 constant private MAX_UINT256 = 2**256 - 1;
53     
54     mapping (address => mapping (address => uint256)) public allowed;
55     
56     string public name = "Love";
57     uint8 public decimals = 0;
58     string public symbol = "LOVE";
59 
60     constructor() public {
61         totalSupply = MAX_UINT256;
62     }
63 
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         uint256 allowance = allowed[_from][msg.sender];
71         
72         if (allowance < MAX_UINT256) {
73             allowed[_from][msg.sender] -= _value;
74         }
75         
76         emit Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function balanceOf(address _owner) public view returns (uint256 balance) {
81         return MAX_UINT256;
82     }
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         emit Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
91         return allowed[_owner][_spender];
92     }
93 }