1 pragma solidity ^0.4.15;
2 
3 contract Factory{
4     
5     //Adress of creator
6     address private creator;
7 
8     // Addresses of owners
9     address[] public owners = [0x6CAa636cFFbCbb2043A3322c04dE3f26b1fa6555, 0xbc2d90C2D3A87ba3fC8B23aA951A9936A6D68121, 0x680d821fFE703762E7755c52C2a5E8556519EEDc];
10 
11     //List of deployed Forwarders
12     address[] public deployed_forwarders;
13     
14     //Get number of forwarders created
15     uint public forwarders_count = 0;
16     
17     //Last forwarder create
18     address public last_forwarder_created;
19   
20     //Only owners can generate a forwarder
21     modifier onlyOwnerOrCreator {
22       require(msg.sender == owners[0] || msg.sender == owners[1] || msg.sender == owners[2] || msg.sender == creator);
23       _;
24     }
25     
26     event ForwarderCreated(address to);
27   
28     //Constructor
29     constructor() public {
30         creator = msg.sender;
31     }
32   
33     //Create new Forwarder
34     function create_forwarder() public onlyOwnerOrCreator {
35         address new_forwarder = new Forwarder();
36         deployed_forwarders.push(new_forwarder);
37         last_forwarder_created = new_forwarder;
38         forwarders_count += 1;
39         
40         emit ForwarderCreated(new_forwarder);
41     }
42     
43     //Get deployed forwarders
44     function get_deployed_forwarders() public view returns (address[]) {
45         return deployed_forwarders;
46     }
47 
48 }
49 
50 contract Forwarder {
51     
52   // Address to which any funds sent to this contract will be forwarded
53   address private parentAddress = 0x7aeCf441966CA8486F4cBAa62fa9eF2D557f9ba7;
54   
55   // Addresses of people who can flush ethers and tokenContractAddress
56   address[] private owners = [0x6CAa636cFFbCbb2043A3322c04dE3f26b1fa6555, 0xbc2d90C2D3A87ba3fC8B23aA951A9936A6D68121, 0x680d821fFE703762E7755c52C2a5E8556519EEDc];
57   
58   event ForwarderDeposited(address from, uint value, bytes data);
59 
60   /**
61    * Create the contract.
62    */
63   constructor() public {
64 
65   }
66 
67   /**
68    * Modifier that will execute internal code block only if the sender is among owners.
69    */
70   modifier onlyOwner {
71     require(msg.sender == owners[0] || msg.sender == owners[1] || msg.sender == owners[2]);
72     _;
73   }
74 
75   /**
76    * Default function; Gets called when Ether is deposited, and forwards it to the parent address
77    */
78   function() public payable {
79     // throws on failure
80     parentAddress.transfer(msg.value);
81     // Fire off the deposited event if we can forward it
82     emit ForwarderDeposited(msg.sender, msg.value, msg.data);
83   }
84 
85 
86   /**
87    * Execute a token transfer of the full balance from the forwarder token to the parent address
88    * @param tokenContractAddress the address of the erc20 token contract
89    */
90   function flushTokens(address tokenContractAddress) public onlyOwner {
91     ERC20Interface instance = ERC20Interface(tokenContractAddress);
92     address forwarderAddress = address(this);
93     uint forwarderBalance = instance.balanceOf(forwarderAddress);
94     if (forwarderBalance == 0) {
95       return;
96     }
97     if (!instance.transfer(parentAddress, forwarderBalance)) {
98       revert();
99     }
100   }
101 
102   /**
103    * It is possible that funds were sent to this address before the contract was deployed.
104    * We can flush those funds to the parent address.
105    */
106   function flush() public onlyOwner {
107     // throws on failure
108     uint my_balance = address(this).balance;
109     if (my_balance == 0){
110         return;
111     } else {
112         parentAddress.transfer(address(this).balance);
113     }
114   }
115 }
116 
117 contract ERC20Interface {
118   // Send _value amount of tokens to address _to
119   function transfer(address _to, uint256 _value) public returns (bool success);
120   // Get the account balance of another account with address _owner
121   function balanceOf(address _owner) public constant returns (uint256 balance);
122 }