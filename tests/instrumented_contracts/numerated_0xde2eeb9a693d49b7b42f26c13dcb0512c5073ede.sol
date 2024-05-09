1 pragma solidity ^0.4.24;
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
25   constructor() public{
26     owner = msg.sender;
27   }
28 
29 
30   function transferOwnership(address _newOwner) onlyOwner public{
31     require(_newOwner != owner);
32     emit OwnershipTransferProposed(owner, _newOwner);
33     newOwner = _newOwner;
34   }
35 
36 
37   function confirmOwnership() public{
38     assert(msg.sender == newOwner);
39     emit OwnershipTransferConfirmed(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46   //from ERC20 standard
47 contract ERC20Interface {
48     function totalSupply() public constant returns (uint);
49     function balanceOf(address tokenOwner) public constant returns (uint balance);
50     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
51     function transfer(address to, uint tokens) public returns (bool success);
52     function approve(address spender, uint tokens) public returns (bool success);
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 }
58 
59 
60 contract Gateway is Owned {
61 
62   address public targetWallet;
63   address public whitelistWallet;
64 
65 
66   bool public gatewayOpened = false;
67 
68     
69   mapping(address => bool) public whitelist;
70 
71   
72   event TargetWalletUpdated(address _newWallet);
73   event WhitelistWalletUpdated(address _newWhitelistWallet);
74   event GatewayStatusUpdated(bool _status);
75   event WhitelistUpdated(address indexed _participant, bool _status);
76   event PassedGateway(address _participant, uint _value);
77   
78 
79   constructor() public{
80     targetWallet = owner;
81     whitelistWallet = owner;
82     newOwner = address(0x0);
83   }
84 
85   
86   function () payable public{
87     passGateway();
88   }
89 
90 
91   function addToWhitelist(address _participant) external{
92     require(msg.sender == whitelistWallet || msg.sender == owner);
93     whitelist[_participant] = true;
94     emit WhitelistUpdated(_participant, true);
95   }  
96 
97 
98   function addToWhitelistMultiple(address[] _participants) external{
99     require(msg.sender == whitelistWallet || msg.sender == owner);
100     for (uint i = 0; i < _participants.length; i++) {
101       whitelist[_participants[i]] = true;
102       emit WhitelistUpdated(_participants[i], true);
103     }
104   }
105 
106 
107   function removeFromWhitelist(address _participant) external{
108     require(msg.sender == whitelistWallet || msg.sender == owner);
109     whitelist[_participant] = false;
110     emit WhitelistUpdated(_participant, false);
111   }  
112 
113 
114   function removeFromWhitelistMultiple(address[] _participants) external{
115     require(msg.sender == whitelistWallet || msg.sender == owner);
116     for (uint i = 0; i < _participants.length; i++) {
117       whitelist[_participants[i]] = false;
118       emit WhitelistUpdated(_participants[i], false);
119     }
120   }
121 
122 
123   function setTargetWallet(address _wallet) onlyOwner external{
124     require(_wallet != address(0x0));
125     targetWallet = _wallet;
126     emit TargetWalletUpdated(_wallet);
127   }
128   
129 
130   function setWhitelistWallet(address _wallet) onlyOwner external{
131     whitelistWallet = _wallet;
132     emit WhitelistWalletUpdated(_wallet);
133   }
134 
135 
136   function openGateway() onlyOwner external{
137     require(!gatewayOpened);
138     gatewayOpened = true;
139     
140     emit GatewayStatusUpdated(true);
141   }
142 
143 
144   function closeGateway() onlyOwner external{
145     require(gatewayOpened);
146     gatewayOpened = false;
147     
148     emit GatewayStatusUpdated(false);
149   }
150 
151 
152   function passGateway() private{
153 
154     require(gatewayOpened);
155     require(whitelist[msg.sender]);
156 
157 	  // sends Eth forward; covers edge case of mining/selfdestructing Eth to the contract address
158 	  // note: address uses a different "transfer" than ERC20.
159     address(targetWallet).transfer(address(this).balance);
160 
161     // log event
162     emit PassedGateway(msg.sender, msg.value);
163   }
164   
165   
166   
167       
168   //from ERC20 standard
169   //Used if someone sends tokens to the bouncer contract.
170   function transferAnyERC20Token(
171     address tokenAddress,
172     uint256 tokens
173   )
174     public
175     onlyOwner
176     returns (bool success)
177   {
178     return ERC20Interface(tokenAddress).transfer(owner, tokens);
179   }
180   
181 }