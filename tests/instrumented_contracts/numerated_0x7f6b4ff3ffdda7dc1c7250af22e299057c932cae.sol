1 pragma solidity ^0.4.24;
2 // Contract is owned by CryptX Financial 
3 // Owner ethereum address is 0x5F96FEC8db3548e0FC24C1ABe8C1a1eABd2Fad91
4 //Safe math ensures that the mathematical operations work as intended
5 contract SafeMath {                 
6     function safeAdd(uint a, uint b) public pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) public pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) public pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 // ERC20 Contract Interface for interacting with the Contract
25 contract Interface { 
26     
27     // Shows the total supply of token on the ethereum blockchain
28     function Supply() public constant returns (uint);
29     
30     // Shows the token balance of the ethereum wallet address if any
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     
33     // Transfering the token to any ethereum wallet address
34     function transfer(address to, uint tokens) public returns (bool success);
35     
36     // This generates a public event on the ethereum blockchain for transfer notification
37     event Transfer(address indexed from, address indexed to, uint tokens);
38 
39 }
40 // CRYPTXFINANCIALToken contract
41 contract CRYPTXFINANCIALToken is Interface, SafeMath {
42     string public symbol;
43     string public name;
44     uint8 public decimals;
45     uint public totalSupply;
46     address owner;
47 
48     mapping(address => uint) public balanceOf; // this creates an array of all the balances
49     mapping (address => bool) public frozenAccount; // this creates an array of all frozen ethereum wallet address
50 
51     event Burn(address indexed from, uint256 value); // This generates a public event on the ethereum blockchain for burn notification
52     event FrozenFunds(address target, bool frozen);  // This generates a public event on the ethereum blockchain for freeze notification
53 
54     constructor() public {
55         symbol = "CRYPTX";
56         name = "CRYPTX FINANCIAL Token";
57         decimals = 18;
58         owner = msg.sender; // Assigns the contract depoloyer as the contract owner
59         totalSupply = 250000000000000000000000000; // Total number of tokens minted
60         balanceOf[0x393869c02e4281144eDa540b35F306686D6DBc5c] = 162500000000000000000000000; // Number of tokens for the crowd sale
61         balanceOf[0xd74Ac74CF89B3F4d6B0306fA044a81061E71ba35] = 87500000000000000000000000; // Number of tokens retained 
62         emit Transfer(address(0), 0x393869c02e4281144eDa540b35F306686D6DBc5c, 162500000000000000000000000);
63         emit Transfer(address(0), 0xd74Ac74CF89B3F4d6B0306fA044a81061E71ba35, 87500000000000000000000000);
64     }
65 
66     // Shows the total supply of token on the ethereum blockchain
67     function Supply() public constant returns (uint) {
68         return totalSupply  - balanceOf[address(0)]; // totalSupply excluding the burnt tokens
69     }
70 
71     // Shows the token balance of the ethereum wallet address if any 
72     function balanceOf(address tokenOwner) public constant returns (uint balance) {
73         return balanceOf[tokenOwner];  // ethereum wallet address is passed as argument
74     }
75 
76     // Transfering the token to any ERC20 wallet address
77     function transfer(address to, uint tokens) public returns (bool success) {
78         require(to != 0x0); // Use burn function to do this 
79         require(tokens > 0); // No 0 value transactions allowed
80         require(!frozenAccount[msg.sender]); // Cannot send from a frozen wallet address
81         require(!frozenAccount[to]); // Cannot send to a frozen wallet address
82         require(balanceOf[msg.sender] >= tokens); // Check if enough balance is there from the sender
83         require(safeAdd(balanceOf[to], tokens) > balanceOf[to]); // Cannot send 0 tokens
84         uint256 previousBalances = safeAdd(balanceOf[msg.sender], balanceOf[to]); 
85         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], tokens); // Subract tokens from the sender wallet address
86         balanceOf[to] = safeAdd(balanceOf[to], tokens); // Add the tokens to receiver wallet address
87         emit Transfer(msg.sender, to, tokens); 
88         require(balanceOf[msg.sender] + balanceOf[to] == previousBalances); // Checks intergrity of the Transfer
89         return true; // Transfer done
90     }
91 
92     // Not allowing a particular ethereum wallet address to send or receive tokens in case of blacklisting reactively
93     function freezeAccount(address target, bool freeze)  public {
94         require(msg.sender == owner); // Only the contract owner can freeze an ethereum wallet
95         frozenAccount[target] = freeze; // Freezes the target ethereum wallet
96         emit FrozenFunds(target, freeze); 
97     }
98 
99     // Makes the token unusable
100      function burn(uint256 amount) public returns (bool success) {
101         require(balanceOf[msg.sender] >= amount); // Checks if the particular ethereum wallet address has enough tokens to Burn
102         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], amount); // Subract the tokens to be burnt from the user ethereum wallet address
103         totalSupply = safeSub(totalSupply, amount); // Subract the tokens burnt from the total Supply
104         emit Burn(msg.sender, amount); 
105         return true; // tokens burnt successfully
106     }
107 
108     // Cannot accept ethereum 
109     //Please dont send ethereum to this contract address
110     function () public payable {
111         revert();
112     }
113 
114 }