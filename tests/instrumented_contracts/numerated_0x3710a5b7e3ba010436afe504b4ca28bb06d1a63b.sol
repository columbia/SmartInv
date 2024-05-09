1 pragma solidity 0.4.21;
2 
3 /**
4 * @title SafeMath by OpenZeppelin (commit: 5daaf60)
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) 
16             return 0;
17 
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
25     */
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     /**
32     * @dev Adds two numbers, throws on overflow.
33     */
34     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
35         c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 interface Token {
42     function transfer(address to, uint256 value) external returns (bool success);
43     function burn(uint256 amount) external;
44     function balanceOf(address owner) external returns (uint256 balance);
45 }
46 
47 contract Crowdsale {
48     address public owner;                       // Address of the contract owner
49     address public fundRaiser;                  // Address which can withraw funds raised
50     uint256 public amountRaisedInWei;           // Total amount of ether raised in wei
51     uint256 public tokensSold;                  // Total number of tokens sold
52     uint256 public tokensClaimed;               // Total Number of tokens claimed by participants
53     uint256 public icoDeadline;                 // Duration this ICO will end
54     uint256 public tokensClaimableAfter;        // Duration after tokens will be claimable
55     uint256 public tokensPerWei;                // How many token a buyer gets per wei 
56     Token public tokenReward;                   // Token being distributed 
57 
58     // Map of crowdsale participants, address as key and Participant structure as value
59     mapping(address => Participant) public participants;    
60 
61     // This is a type for a single Participant
62     struct Participant {
63         bool whitelisted;
64         uint256 tokens;
65         bool tokensClaimed;
66     }
67 
68     event FundTransfer(address to, uint amount);
69 
70     modifier afterIcoDeadline() { if (now >= icoDeadline) _; }
71     modifier afterTokensClaimableDeadline() { if (now >= tokensClaimableAfter) _; }
72     modifier onlyOwner() { require(msg.sender == owner); _; }
73 
74     /**
75      * Constructor function
76      */
77     function Crowdsale(
78         address fundRaiserAccount,
79         uint256 durationOfIcoInDays,
80         uint256 durationTokensClaimableAfterInDays,
81         uint256 tokensForOneWei,
82         address addressOfToken
83     ) 
84         public
85     {
86         owner = msg.sender;
87         fundRaiser = fundRaiserAccount;
88         icoDeadline = now + durationOfIcoInDays * 1 days;
89         tokensClaimableAfter = now + durationTokensClaimableAfterInDays * 1 days;
90         tokensPerWei = tokensForOneWei;
91         tokenReward = Token(addressOfToken);
92     }
93 
94     /**
95      * Fallback function: Buy token
96      * The function without name is the default function that is called whenever anyone sends funds to a contract.
97      * Reserves a number tokens per participant by multiplying tokensPerWei and sent ether in wei.
98      * This function is able to buy token when the following four cases are all met:
99      *      - Before ICO deadline
100      *      - Payer address is whitelisted in this contract
101      *      - Sent ether is equal or bigger than minimum transaction (0.05 ether) 
102      *      - There are enough tokens to sell in this contract (tokens balance of contract minus tokensSold)
103      */
104     function() payable public {
105         require(now < icoDeadline);
106         require(participants[msg.sender].whitelisted);             
107         require(msg.value >= 0.01 ether); 
108         uint256 tokensToBuy = SafeMath.mul(msg.value, tokensPerWei);
109         require(tokensToBuy <= SafeMath.sub(tokenReward.balanceOf(this), tokensSold));
110         participants[msg.sender].tokens = SafeMath.add(participants[msg.sender].tokens, tokensToBuy);      
111         amountRaisedInWei = SafeMath.add(amountRaisedInWei, msg.value);
112         tokensSold = SafeMath.add(tokensSold, tokensToBuy);
113     }
114     
115     /**
116     * Add single address into the whitelist. 
117     * Note: Use this function for a single address to save transaction fee
118     */ 
119     function addToWhitelist(address addr) onlyOwner public {
120         participants[addr].whitelisted = true;   
121     }
122 
123     /**
124     * Remove single address from the whitelist. 
125     * Note: Use this function for a single address to save transaction fee
126     */ 
127     function removeFromWhitelist(address addr) onlyOwner public {
128         participants[addr].whitelisted = false;   
129     }
130 
131     /**
132     * Add multiple addresses into the whitelist. 
133     * Note: Use this function for more than one address to save transaction fee
134     */ 
135     function addAddressesToWhitelist(address[] addresses) onlyOwner public {
136         for (uint i = 0; i < addresses.length; i++) {
137             participants[addresses[i]].whitelisted = true;   
138         }
139     }
140 
141     /**
142     * Remove multiple addresses from the whitelist
143     * Note: Use this function for more than one address to save transaction fee
144     */ 
145     function removeAddressesFromWhitelist(address[] addresses) onlyOwner public {
146         for (uint i = 0; i < addresses.length; i++) {
147             participants[addresses[i]].whitelisted = false;   
148         }
149     }
150 
151     // ----------- After ICO Deadline ------------
152 
153     /**
154     * Fundraiser address claims the raised funds after ICO deadline
155     */ 
156     function withdrawFunds() afterIcoDeadline public {
157         require(fundRaiser == msg.sender);
158         fundRaiser.transfer(address(this).balance);
159         emit FundTransfer(fundRaiser, address(this).balance);        
160     }
161 
162     /**
163     * Transfer unsold tokens after ICO deadline
164     * Note: This function is designed to transfer unsold Pre-ICO tokens into Final-ICO contract.
165     */ 
166     function transferUnsoldTokens(address toAddress) onlyOwner afterIcoDeadline public {
167         uint256 tokensUnclaimed = SafeMath.sub(tokensSold, tokensClaimed);
168         uint256 unsoldTokens = SafeMath.sub(tokenReward.balanceOf(this), tokensUnclaimed);
169         tokenReward.transfer(toAddress, unsoldTokens);
170     }
171 
172     // ----------- After Tokens Claimable Duration ------------
173 
174     /**
175     * Each participant will be able to claim his tokens after duration tokensClaimableAfter
176     */ 
177     function withdrawTokens() afterTokensClaimableDeadline public {
178         require(participants[msg.sender].whitelisted);                
179         require(!participants[msg.sender].tokensClaimed);        
180         participants[msg.sender].tokensClaimed = true;
181         uint256 tokens = participants[msg.sender].tokens;
182         tokenReward.transfer(msg.sender, tokens); 
183         tokensClaimed = SafeMath.add(tokensClaimed, tokens);
184     }
185 }