1 pragma solidity ^0.4.21; 
2 
3 
4 contract OwnableContract {
5  
6     address superOwner;
7 		
8 	function OwnableContract() public { 
9         superOwner = msg.sender;  
10     }
11 	
12 	modifier onlyOwner() {
13         require(msg.sender == superOwner);
14         _;
15     } 
16     
17     function viewSuperOwner() public view returns (address owner) {
18         return superOwner;
19     }
20     
21 	function changeOwner(address newOwner) onlyOwner public {
22         superOwner = newOwner;
23     }
24 }
25 
26 contract EIP20Interface {
27     /* This is a slight change to the ERC20 base standard.
28     function totalSupply() constant returns (uint256 supply);
29     is replaced with:
30     uint256 public totalSupply;
31     This automatically creates a getter function for the totalSupply.
32     This is moved to the base contract since public getter functions are not
33     currently recognised as an implementation of the matching abstract
34     function by the compiler.
35     */
36     /// total amount of tokens
37     uint256 public totalSupply;
38     //How many decimals to show.
39     uint256 public decimals;
40     
41     /// @param _owner The address from which the balance will be retrieved
42     /// @return The balance
43     function balanceOf(address _owner) public view returns (uint256 balance);
44 
45     /// @notice send `_value` token to `_to` from `msg.sender`
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transfer(address _to, uint256 _value) public returns (bool success);
50 
51     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
52     /// @param _from The address of the sender
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
57 
58     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
59     /// @param _spender The address of the account able to transfer the tokens
60     /// @param _value The amount of tokens to be approved for transfer
61     /// @return Whether the approval was successful or not
62     function approve(address _spender, uint256 _value) public returns (bool success);
63 
64     /// @param _owner The address of the account owning tokens
65     /// @param _spender The address of the account able to transfer the tokens
66     /// @return Amount of remaining tokens allowed to spent
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
68 
69     // solhint-disable-next-line no-simple-event-func-name  
70     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 contract LightAirdrop is OwnableContract{ 
75      
76  
77     function LightAirdrop() public { 
78     }
79      
80     function performEqual(address tokenAddress, address[] tos, uint256 amount) onlyOwner public {
81         
82         EIP20Interface tokenContract = EIP20Interface(tokenAddress);
83         
84         uint256 i = 0;
85         uint256 n = tos.length;
86         for( ; i<n; i++) {
87             tokenContract.transfer(tos[i], amount);
88         }
89     }
90     
91     function performDifferent(address tokenAddress, address[] tos, uint256[] amounts) onlyOwner public {
92         
93         EIP20Interface tokenContract = EIP20Interface(tokenAddress);
94         
95         uint256 i = 0;
96         uint256 n = tos.length;
97         for( ; i<n; i++) {
98             tokenContract.transfer(tos[i], amounts[i]);
99         }
100     }
101     
102     function withdraw(address tokenAddress) onlyOwner public { 
103         EIP20Interface tokenContract = EIP20Interface(tokenAddress);
104         tokenContract.transfer(msg.sender, tokenContract.balanceOf(address(this))); 
105     }
106 }