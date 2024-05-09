1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/MyanmarDonations.sol
18 
19 // ----------------------------------------------------------------------------
20 // MyanmarDonations - Donations Contract to help people due to Myanmar flood
21 //
22 // Copyright (c) 2018 InfoCorp Technologies Pte Ltd.
23 // http://www.sentinel-chain.org/
24 //
25 // The MIT Licence.
26 // ----------------------------------------------------------------------------
27 
28 pragma solidity ^0.4.24;
29 
30 
31 contract MyanmarDonations{
32 
33     // SENC Token Address
34     address public SENC_CONTRACT_ADDRESS = 0xA13f0743951B4f6E3e3AA039f682E17279f52bc3;
35     // Donation Wallet Address
36     address public donationWallet;
37     // Foundation Wallet Address
38     address public foundationWallet;
39     // Start time for donation campaign
40     uint256 public startDate;
41     // End time for donation campaign
42     uint256 public endDate;
43     // SENC-ETH pegged rate based on EOD rate of the 8nd August from coingecko in Wei
44     uint256 public sencEthRate;
45 
46     // Ether hard cap
47     uint256 public ETHER_HARD_CAP;
48     // InfoCorp committed ETH donation amount
49     uint256 public INFOCORP_DONATION;
50     // Total Ether hard cap to receive
51     uint256 public TOTAL_ETHER_HARD_CAP;
52     // Total of SENC collected at the end of the donation
53     uint256 public totalSencCollected;
54     // Marks the end of the donation.
55     bool public finalized = false;
56 
57     uint256 public sencHardCap;
58 
59     modifier onlyDonationAddress() {
60         require(msg.sender == donationWallet);
61         _;
62     }
63 
64     constructor(                           
65                 address _donationWallet, //0xB4ea16258020993520F59cC786c80175C1b807D7
66                 address _foundationWallet, //0x2c76E65d3b3E38602CAa2fAB56e0640D0182D8F8
67                 uint256 _startDate, //1534125600 [2018-08-13 10:00:00 (GMT +8)]
68                 uint256 _endDate, //1534327200 [2018-08-15 18:00:00 (GMT +8)]
69                 uint256 _sencEthRate, // 40187198103877
70                 uint256 _etherHardCap,
71                 uint256 _infocorpDonation
72                 ) public {
73         donationWallet = _donationWallet;
74         foundationWallet = _foundationWallet;
75         startDate = _startDate;
76         endDate = _endDate;
77         sencEthRate = _sencEthRate;
78         ETHER_HARD_CAP = _etherHardCap;
79         sencHardCap = ETHER_HARD_CAP * 10 ** 18 / sencEthRate;
80         INFOCORP_DONATION = _infocorpDonation;
81 
82         TOTAL_ETHER_HARD_CAP = ETHER_HARD_CAP + INFOCORP_DONATION;
83     }
84 
85     /// @notice Receive initial funds.
86     function() public payable {
87         require(msg.value == TOTAL_ETHER_HARD_CAP);
88         require(
89             address(this).balance <= TOTAL_ETHER_HARD_CAP,
90             "Contract balance hardcap reachead"
91         );
92     }
93 
94     /**
95      * @notice The `finalize()` should only be called after donation
96      * hard cap reached or the campaign reached the final day.
97      */
98     function finalize() public onlyDonationAddress returns (bool) {
99         require(getSencBalance() >= sencHardCap || now >= endDate, "SENC hard cap rached OR End date reached");
100         require(!finalized, "Donation not already finalized");
101         // The Ether balance collected in Wei
102         totalSencCollected = getSencBalance();
103         if (totalSencCollected >= sencHardCap) {
104             // Transfer of donations to the donations address
105             donationWallet.transfer(address(this).balance);
106         } else {
107             uint256 totalDonatedEthers = convertToEther(totalSencCollected) + INFOCORP_DONATION;
108             // Transfer of donations to the donations address
109             donationWallet.transfer(totalDonatedEthers);
110             // Transfer ETH remaining to foundation
111             claimTokens(address(0), foundationWallet);
112         }
113         // Transfer SENC to foundation
114         claimTokens(SENC_CONTRACT_ADDRESS, foundationWallet);
115         finalized = true;
116         return finalized;
117     }
118 
119     /**
120      * @notice The `claimTokens()` should only be called after donation
121      * ends or if a security issue is found.
122      * @param _to the recipient that receives the tokens.
123      */
124     function claimTokens(address _token, address _to) public onlyDonationAddress {
125         require(_to != address(0), "Wallet format error");
126         if (_token == address(0)) {
127             _to.transfer(address(this).balance);
128             return;
129         }
130 
131         ERC20Basic token = ERC20Basic(_token);
132         uint256 balance = token.balanceOf(this);
133         require(token.transfer(_to, balance), "Token transfer unsuccessful");
134     }
135 
136     /// @notice The `sencToken()` is the getter for the SENC Token.
137     function sencToken() public view returns (ERC20Basic) {
138         return ERC20Basic(SENC_CONTRACT_ADDRESS);
139     }
140 
141     /// @notice The `getSencBalance()` retrieve the SENC balance of the contract in Wei.
142     function getSencBalance() public view returns (uint256) {
143         return sencToken().balanceOf(address(this));
144     }
145 
146     /// @notice The `getTotalDonations()` retrieve the Ether balance collected so far in Wei.
147     function getTotalDonations() public view returns (uint256) {
148         return convertToEther(finalized ? totalSencCollected : getSencBalance());
149     }
150     
151     /// @notice The `setEndDate()` changes unit timestamp on wich de donations ends.
152     function setEndDate(uint256 _endDate) external onlyDonationAddress returns (bool){
153         endDate = _endDate;
154         return true;
155     }
156 
157     /**
158      * @notice The `convertToEther()` converts value of SENC Tokens to Ether based on pegged rate.
159      * @param _value the amount of SENC to be converted.
160      */
161     function convertToEther(uint256 _value) public view returns (uint256) {
162         return _value * sencEthRate / 10 ** 18;
163     }
164 
165 }