1 pragma solidity ^0.4.6;
2 
3 /*
4   MiniMeToken contract taken from https://github.com/Giveth/minime/
5 
6  */
7 
8 
9 /// @dev The token controller contract must implement these functions
10 contract TokenController {
11     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
12     /// @param _owner The address that sent the ether to create tokens
13     /// @return True if the ether is accepted, false if it throws
14     function proxyPayment(address _owner) payable returns(bool);
15 
16     /// @notice Notifies the controller about a token transfer allowing the
17     ///  controller to react if desired
18     /// @param _from The origin of the transfer
19     /// @param _to The destination of the transfer
20     /// @param _amount The amount of the transfer
21     /// @return False if the controller does not authorize the transfer
22     function onTransfer(address _from, address _to, uint _amount) returns(bool);
23 
24     /// @notice Notifies the controller about an approval allowing the
25     ///  controller to react if desired
26     /// @param _owner The address that calls `approve()`
27     /// @param _spender The spender in the `approve()` call
28     /// @param _amount The amount in the `approve()` call
29     /// @return False if the controller does not authorize the approval
30     function onApprove(address _owner, address _spender, uint _amount)
31         returns(bool);
32 }
33 
34 // Minime interface
35 contract MiniMeToken {
36 
37 
38     /// @notice Generates `_amount` tokens that are assigned to `_owner`
39     /// @param _owner The address that will be assigned the new tokens
40     /// @param _amount The quantity of tokens generated
41     /// @return True if the tokens are generated correctly
42     function generateTokens(address _owner, uint _amount
43     ) returns (bool);
44 
45 
46 }
47 
48 
49 
50 // Taken from Zeppelin's standard contracts.
51 contract ERC20 {
52   uint public totalSupply;
53   function balanceOf(address who) constant returns (uint);
54   function allowance(address owner, address spender) constant returns (uint);
55 
56   function transfer(address to, uint value) returns (bool ok);
57   function transferFrom(address from, address to, uint value) returns (bool ok);
58   function approve(address spender, uint value) returns (bool ok);
59   event Transfer(address indexed from, address indexed to, uint value);
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 contract SWTConverter is TokenController {
64 
65     MiniMeToken public tokenContract;   // The new token
66     ERC20 public arcToken;              // The ARC token address
67 
68     function SWTConverter(
69         address _tokenAddress,          // the new MiniMe token address
70         address _arctokenaddress        // the original ARC token address
71     ) {
72         tokenContract = MiniMeToken(_tokenAddress); // The Deployed Token Contract
73         arcToken = ERC20(_arctokenaddress);
74     }
75 
76 /////////////////
77 // TokenController interface
78 /////////////////
79 
80 
81  function proxyPayment(address _owner) payable returns(bool) {
82         return false;
83     }
84 
85 /// @notice Notifies the controller about a transfer, for this SWTConverter all
86 ///  transfers are allowed by default and no extra notifications are needed
87 /// @param _from The origin of the transfer
88 /// @param _to The destination of the transfer
89 /// @param _amount The amount of the transfer
90 /// @return False if the controller does not authorize the transfer
91     function onTransfer(address _from, address _to, uint _amount) returns(bool) {
92         return true;
93     }
94 
95 /// @notice Notifies the controller about an approval, for this SWTConverter all
96 ///  approvals are allowed by default and no extra notifications are needed
97 /// @param _owner The address that calls `approve()`
98 /// @param _spender The spender in the `approve()` call
99 /// @param _amount The amount in the `approve()` call
100 /// @return False if the controller does not authorize the approval
101     function onApprove(address _owner, address _spender, uint _amount)
102         returns(bool)
103     {
104         return true;
105     }
106 
107 
108 /// @notice converts ARC tokens to new SWT tokens and forwards ARC to the vault address.
109 /// @param _amount The amount of ARC to convert to SWT
110  function convert(uint _amount){
111 
112         // transfer ARC to the vault address. caller needs to have an allowance from
113         // this controller contract for _amount before calling this or the transferFrom will fail.
114         if (!arcToken.transferFrom(msg.sender, 0x0, _amount)) {
115             throw;
116         }
117 
118         // mint new SWT tokens
119         if (!tokenContract.generateTokens(msg.sender, _amount)) {
120             throw;
121         }
122     }
123 
124 
125 }