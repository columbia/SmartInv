1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Funds Gateway contract
6 //
7 // ----------------------------------------------------------------------------
8 
9 contract Owned {
10 
11   address public owner;
12   address public newOwner;
13 
14 
15   event OwnershipTransferProposed(address indexed _from, address indexed _to);
16   event OwnershipTransferConfirmed(address indexed _from, address indexed _to);
17 
18 
19   modifier onlyOwner {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   function Owned() public{
26     owner = msg.sender;
27   }
28 
29 
30   function transferOwnership(address _newOwner) onlyOwner public{
31     require(_newOwner != owner);
32     OwnershipTransferProposed(owner, _newOwner);
33     newOwner = _newOwner;
34   }
35 
36 
37   function confirmOwnership() public{
38     assert(msg.sender == newOwner);
39     OwnershipTransferConfirmed(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 contract Gateway is Owned{
47 
48   address public targetWallet;
49   address public whitelistWallet;
50 
51 
52   bool public gatewayOpened = false;
53 
54     
55   mapping(address => bool) public whitelist;
56 
57   
58   event TargetWalletUpdated(address _newWallet);
59   event WhitelistWalletUpdated(address _newWhitelistWallet);
60   event GatewayStatusUpdated(bool _status);
61   event WhitelistUpdated(address indexed _participant, bool _status);
62   event PassedGateway(address _participant, uint _value);
63   
64 
65   function Gateway() public{
66     targetWallet = owner;
67     whitelistWallet = owner;
68     newOwner = address(0x0);
69   }
70 
71   
72   function () payable public{
73     passGateway();
74   }
75 
76 
77   function addToWhitelist(address _participant) external{
78     require(msg.sender == whitelistWallet || msg.sender == owner);
79     whitelist[_participant] = true;
80     WhitelistUpdated(_participant, true);
81   }  
82 
83 
84   function addToWhitelistMultiple(address[] _participants) external{
85     require(msg.sender == whitelistWallet || msg.sender == owner);
86     for (uint i = 0; i < _participants.length; i++) {
87       whitelist[_participants[i]] = true;
88       WhitelistUpdated(_participants[i], true);
89     }
90   }
91 
92 
93   function removeFromWhitelist(address _participant) external{
94     require(msg.sender == whitelistWallet || msg.sender == owner);
95     whitelist[_participant] = false;
96     WhitelistUpdated(_participant, false);
97   }  
98 
99 
100   function removeFromWhitelistMultiple(address[] _participants) external{
101     require(msg.sender == whitelistWallet || msg.sender == owner);
102     for (uint i = 0; i < _participants.length; i++) {
103       whitelist[_participants[i]] = false;
104       WhitelistUpdated(_participants[i], false);
105     }
106   }
107 
108 
109   function setTargetWallet(address _wallet) onlyOwner external{
110     require(_wallet != address(0x0));
111     targetWallet = _wallet;
112     TargetWalletUpdated(_wallet);
113   }
114   
115 
116   function setWhitelistWallet(address _wallet) onlyOwner external{
117     whitelistWallet = _wallet;
118     WhitelistWalletUpdated(_wallet);
119   }
120 
121 
122   function openGateway() onlyOwner external{
123     require(!gatewayOpened);
124     gatewayOpened = true;
125     
126     GatewayStatusUpdated(true);
127   }
128 
129 
130   function closeGateway() onlyOwner external{
131     require(gatewayOpened);
132     gatewayOpened = false;
133     
134     GatewayStatusUpdated(false);
135   }
136 
137 
138   function passGateway() private{
139 
140     require(gatewayOpened);
141     require(whitelist[msg.sender]);
142 
143 	  // sends Eth forward; covers edge case of mining/selfdestructing Eth to the contract address
144     targetWallet.transfer(this.balance);
145 
146     // log event
147     PassedGateway(msg.sender, msg.value);
148   }
149   
150 }