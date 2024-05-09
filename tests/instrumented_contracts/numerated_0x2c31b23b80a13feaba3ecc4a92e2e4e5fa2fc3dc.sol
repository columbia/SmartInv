1 pragma solidity ^0.4.24;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 contract Token {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 contract Erc2Vite {
52     
53     mapping (address => string) public records;
54     
55     address public destoryAddr = 0x1111111111111111111111111111111111111111;
56 
57     uint256 public defaultCode = 203226;
58     
59     address public viteTokenAddress = 0x0;
60 	address public owner			= 0x0;
61 	
62 	uint public bindId = 0;
63 	event Bind(uint bindId, address indexed _ethAddr, string _viteAddr, uint256 amount, uint256 _invitationCode);
64 	
65 	/*
66 	 * public functions
67 	 */
68 	/// @dev Initialize the contract
69 	/// @param _viteTokenAddress ViteToken ERC20 token address
70 	/// @param _owner the owner of the contract
71 	function Erc2Vite(address _viteTokenAddress, address _owner) {
72 		require(_viteTokenAddress != address(0));
73 		require(_owner != address(0));
74 
75 		viteTokenAddress = _viteTokenAddress;
76 		owner = _owner;
77 	}
78     
79     function bind(string _viteAddr, uint256 _invitationCode) public {
80 
81         require(bytes(_viteAddr).length == 55);
82         
83         var viteToken = Token(viteTokenAddress);
84         uint256 apprAmount = viteToken.allowance(msg.sender, address(this));
85         require(apprAmount > 0);
86         
87         require(viteToken.transferFrom(msg.sender, destoryAddr, apprAmount));
88         
89         records[msg.sender] = _viteAddr;
90 
91         if(_invitationCode == 0) {
92             _invitationCode = defaultCode;
93         }
94         
95         emit Bind(
96             bindId++,
97             msg.sender,
98             _viteAddr,
99             apprAmount,
100             _invitationCode
101         );
102     }
103     
104     function () public payable {
105         revert();
106     }
107     
108     function destory() public {
109         require(msg.sender == owner);
110         selfdestruct(owner);
111     }
112     
113 }