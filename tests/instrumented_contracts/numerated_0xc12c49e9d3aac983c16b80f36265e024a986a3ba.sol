1 pragma solidity ^0.5.1;
2 
3 contract Token {
4 
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     event Transfer_data( address indexed _to, uint256 _value,string data);
7     event data_Marketplace(string data);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success) {
10         //Default assumes totalSupply can't be over max (2^256 - 1).
11         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
12         //Replace the if with this one instead.
13         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
14         if (balances[msg.sender] >= _value && _value > 0) {
15             balances[msg.sender] -= _value;
16             balances[_to] += _value;
17             emit Transfer(msg.sender, _to, _value);
18             return true;
19         } else { return false; }
20     }
21 
22    function transfer_data( address _to,uint256 _value,string memory data) public returns (bool success) {
23         //Default assumes totalSupply can't be over max (2^256 - 1).
24         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
25         //Replace the if with this one instead.
26         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
27         if (balances[msg.sender] >= _value && _value > 0) {
28             balances[msg.sender] -= _value;
29             balances[fundsWallet] += _value;
30             emit Transfer_data(_to, _value, data);
31             return true;
32         } else { return false; }
33     }
34     
35      function marketplace( string memory data) public returns (bool success) {
36         //Default assumes totalSupply can't be over max (2^256 - 1).
37         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
38         //Replace the if with this one instead.
39         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
40         if (balances[msg.sender] >= 1 && 1 > 0) {
41             balances[msg.sender] -= 1;
42             balances[fundsWallet] += 1;
43             emit data_Marketplace(data);
44             return true;
45         } else { return false; }
46     }
47     
48      
49 
50 
51     function balanceOf(address _owner) public view returns (uint256 balance) {
52         return balances[_owner];
53     }
54     
55     function mybalance() public view returns (uint256 balance) {
56         return balances[fundsWallet];
57     }
58 
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 
64 
65 
66     /* Public variables of the token */
67 
68     /*
69     NOTE:
70     The following variables are OPTIONAL vanities. One does not have to include them.
71     They allow one to customise the token contract & in no way influences the core functionality.
72     Some wallets/interfaces might not even bother to look at this information.
73     */
74     string public name;                   // Token Name
75     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
76     string public symbol;                 // An identifier: eg SBX, XPR etc..
77     string public version = 'H1.0'; 
78     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
79     address payable fundsWallet;           // Where should the raised ETH go?
80 
81     // This is a constructor function 
82     // which means the following function name has to match the contract name declared above
83     constructor () public {
84         balances[msg.sender] = 1000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
85         totalSupply = 1000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
86         name = "Kaus-0.0.1";                                   // Set the name for display purposes (CHANGE THIS)
87         decimals = 0;                                               // Amount of decimals for display purposes (CHANGE THIS)
88         symbol = "KAUS";                                             // Set the symbol for display purposes (CHANGE THIS)
89         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
90     }
91 
92    
93     
94 }