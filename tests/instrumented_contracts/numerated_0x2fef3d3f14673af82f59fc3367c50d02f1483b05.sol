1 // Version 0.1
2 // This swap contract was created by Attores and released under a GPL license
3 // Visit attores.com for more contracts and Smart contract as a Service 
4 
5 // This is the standard token interface
6 contract TokenInterface {
7 
8   struct User {
9     bool locked;
10     uint256 balance;
11     uint256 badges;
12     mapping (address => uint256) allowed;
13   }
14 
15   mapping (address => User) users;
16   mapping (address => uint256) balances;
17   mapping (address => mapping (address => uint256)) allowed;
18   mapping (address => bool) seller;
19 
20   address config;
21   address owner;
22   address dao;
23   bool locked;
24 
25   /// @return total amount of tokens
26   uint256 public totalSupply;
27   uint256 public totalBadges;
28 
29   /// @param _owner The address from which the balance will be retrieved
30   /// @return The balance
31   function balanceOf(address _owner) constant returns (uint256 balance);
32 
33   /// @param _owner The address from which the badge count will be retrieved
34   /// @return The badges count
35   function badgesOf(address _owner) constant returns (uint256 badge);
36 
37   /// @notice send `_value` tokens to `_to` from `msg.sender`
38   /// @param _to The address of the recipient
39   /// @param _value The amount of tokens to be transfered
40   /// @return Whether the transfer was successful or not
41   function transfer(address _to, uint256 _value) returns (bool success);
42 
43   /// @notice send `_value` badges to `_to` from `msg.sender`
44   /// @param _to The address of the recipient
45   /// @param _value The amount of tokens to be transfered
46   /// @return Whether the transfer was successful or not
47   function sendBadge(address _to, uint256 _value) returns (bool success);
48 
49   /// @notice send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`
50   /// @param _from The address of the sender
51   /// @param _to The address of the recipient
52   /// @param _value The amount of tokens to be transfered
53   /// @return Whether the transfer was successful or not
54   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
55 
56   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on its behalf
57   /// @param _spender The address of the account able to transfer the tokens
58   /// @param _value The amount of tokens to be approved for transfer
59   /// @return Whether the approval was successful or not
60   function approve(address _spender, uint256 _value) returns (bool success);
61 
62   /// @param _owner The address of the account owning tokens
63   /// @param _spender The address of the account able to transfer the tokens
64   /// @return Amount of remaining tokens of _owner that _spender is allowed to spend
65   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
66 
67   /// @notice mint `_amount` of tokens to `_owner`
68   /// @param _owner The address of the account receiving the tokens
69   /// @param _amount The amount of tokens to mint
70   /// @return Whether or not minting was successful
71   function mint(address _owner, uint256 _amount) returns (bool success);
72 
73   /// @notice mintBadge Mint `_amount` badges to `_owner`
74   /// @param _owner The address of the account receiving the tokens
75   /// @param _amount The amount of tokens to mint
76   /// @return Whether or not minting was successful
77   function mintBadge(address _owner, uint256 _amount) returns (bool success);
78 
79   function registerDao(address _dao) returns (bool success);
80 
81   function registerSeller(address _tokensales) returns (bool success);
82 
83   event Transfer(address indexed _from, address indexed _to, uint256 _value);
84   event SendBadge(address indexed _from, address indexed _to, uint256 _amount);
85   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 }
87 
88 // Actual swap contract written by Attores
89 contract swap{
90     address public beneficiary;
91     TokenInterface public tokenObj;
92     uint public price_token;
93     uint256 public WEI_PER_FINNEY = 1000000000000000;
94     uint public BILLION = 1000000000;
95     uint public expiryDate;
96     
97     // Constructor function for this contract. Called during contract creation
98     function swap(address sendEtherTo, address adddressOfToken, uint tokenPriceInFinney_1000FinneyIs_1Ether, uint durationInDays){
99         beneficiary = sendEtherTo;
100         tokenObj = TokenInterface(adddressOfToken);
101         price_token = tokenPriceInFinney_1000FinneyIs_1Ether * WEI_PER_FINNEY;
102         expiryDate = now + durationInDays * 1 days;
103     }
104     
105     // This function is called every time some one sends ether to this contract
106     function(){
107         if (now >= expiryDate) throw;
108         // Dividing by Billion here to cater for the decimal places
109         var tokens_to_send = (msg.value * BILLION) / price_token;
110         uint balance = tokenObj.balanceOf(this);
111         address payee = msg.sender;
112         if (balance >= tokens_to_send){
113             tokenObj.transfer(msg.sender, tokens_to_send);
114             beneficiary.send(msg.value);    
115         } else {
116             tokenObj.transfer(msg.sender, balance);
117             uint amountReturned = ((tokens_to_send - balance) * price_token) / BILLION;
118             payee.send(amountReturned);
119             beneficiary.send(msg.value - amountReturned);
120         }
121     }
122     
123     modifier afterExpiry() { if (now >= expiryDate) _ }
124     
125     //This function checks if the expiry date has passed and if it has, then returns the tokens to the beneficiary
126     function checkExpiry() afterExpiry{
127         uint balance = tokenObj.balanceOf(this);
128         tokenObj.transfer(beneficiary, balance);
129     }
130 }