1 /*
2 * Copyright © 2017 NYX. All rights reserved.
3 */
4 pragma solidity ^0.4.15;
5 
6 contract NYXAccount {	
7     /// This will allow you to transfer money to Emergency account
8     /// if you loose access to your Owner and Resque account's private key/passwords.
9     /// This variable is set by Authority contract after passing decentralized identification by evaluating you against the photo file hash of which saved in your NYX Account.
10     /// Your emergency account hash should contain hash of the pair <your secret phrase> + <your Emergency account's address>.
11     /// This way your hash is said to be "signed" with your secret phrase.
12 	bytes32 emergencyHash;
13 	/// Authority contract address, which is allowed to set your Emergency account (see variable above)
14     address authority;
15     /// Your Owner account by which this instance of NYX Account is created and run
16     address public owner;
17     /// Hash of address of your Resque account
18     bytes32 resqueHash;
19     /// Hash of your secret key phrase
20     bytes32 keywordHash;
21     /// This will be hashes of photo files of your people to which you wish grant access
22     /// to this NYX Account. Up to 10 persons allowed. You must provide one
23     /// of photo files, hash of which is saved to this variable upon NYX Account creation.
24     /// The person to be identified must be a person in the photo provided.
25     bytes32[10] photoHashes;
26     /// The datetime value when transfer to Resque account was first time requested.
27     /// When you request withdrawal to your Resque account first time, only this variable set. No actual transfer happens.
28     /// Transfer will be executed after 1 day of "quarantine". Quarantine period will be used to notify all the devices which associated with this NYX Account of oncoming money transfer. After 1 day of quarantine second request will execute actual transfer.
29     uint resqueRequestTime;
30     /// The datetime value when your emergency account is set by Authority contract.
31     /// When you request withdrawal to your emergency account first time, only this variable set. No actual transfer happens.    
32     /// Transfer will be executed after 1 day of "quarantine". Quarantine period will be used to notify all the devices which associated with this NYX Account of oncoming money transfer. After 1 day of quarantine second request will execute actual transfer.
33     uint authorityRequestTime;
34     /// Keeps datetime of last outgoing transaction of this NYX Account. Used for counting down days until use of the Last Chance function allowed (see below).
35 	uint lastExpenseTime;
36 	/// Enables/disables Last Chance function. By default disabled.
37 	bool public lastChanceEnabled = false;
38 	/// Whether knowing Resque account's address is required to use Last Chance function? By default - yes, it's required to know address of Resque account.
39 	bool lastChanceUseResqueAccountAddress = true;
40 	/* 
41 	* Part of Decentralized NYX identification logic.
42 	* Places NYX identification request in the blockchain.
43 	* Others will watch for it and take part in identification process.
44 	* The part handling these events to be done.
45 	* swarmLinkPhoto: photo.pdf file of owner of this NYX Account. keccak256(keccak256(photo.pdf)) must exist in this NYX Account.
46 	* swarmLinkVideo: video file provided by owner of this NYX Account for identification against swarmLinkPhoto
47 	*/
48     event NYXDecentralizedIdentificationRequest(string swarmLinkPhoto, string swarmLinkVideo);
49 	
50     /// Enumerates states of NYX Account
51     enum Stages {
52         Normal, // Everything is ok, this account is running by your managing (owning) account (address)
53         ResqueRequested, // You have lost access to your managing account and  requested to transfer all the balance to your Resque account
54         AuthorityRequested // You have lost access to both your Managing and Resque accounts. Authority contract set Emergency account provided by you, to transfer balance to the Emergency account. For using this state your secret phrase must be available.
55     }
56     /// Defaults to Normal stage
57     Stages stage = Stages.Normal;
58 
59     /* Constructor taking
60     * resqueAccountHash: keccak256(address resqueAccount);
61     * authorityAccount: address of authorityAccount that will set data for withdrawing to Emergency account
62     * kwHash: keccak256("your keyword phrase");
63     * photoHshs: array of keccak256(keccak256(data_of_yourphoto.pdf)) - hashes of photo files taken for this NYX Account. 
64     */
65     function NYXAccount(bytes32 resqueAccountHash, address authorityAccount, bytes32 kwHash, bytes32[10] photoHshs) {
66         owner = msg.sender;
67         resqueHash = resqueAccountHash;
68         authority = authorityAccount;
69         keywordHash = kwHash;
70         // save photo hashes as state forever
71         uint8 x = 0;
72         while(x < photoHshs.length)
73         {
74             photoHashes[x] = photoHshs[x];
75             x++;
76         }
77     }
78     /// Modifiers
79     modifier onlyByResque()
80     {
81         require(keccak256(msg.sender) == resqueHash);
82         _;
83     }
84     modifier onlyByAuthority()
85     {
86         require(msg.sender == authority);
87         _;
88     }
89     modifier onlyByOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93     modifier onlyByEmergency(string keywordPhrase) {
94         require(keccak256(keywordPhrase, msg.sender) == emergencyHash);
95         _;
96     }
97 
98     // Switch on/off Last Chance function
99 	function toggleLastChance(bool useResqueAccountAddress) onlyByOwner()
100 	{
101 	    // Only allowed in normal stage to prevent changing this by stolen Owner's account
102 	    require(stage == Stages.Normal);
103 	    // Toggle Last Chance function flag
104 		lastChanceEnabled = !lastChanceEnabled;
105 		// If set to true knowing of Resque address (not key or password) will be required to use Last Chance function
106 		lastChanceUseResqueAccountAddress = useResqueAccountAddress;
107 	}
108 	
109 	// Standard transfer Ether using Owner account
110     function transferByOwner(address recipient, uint amount) onlyByOwner() payable {
111         // Only in Normal stage possible
112         require(stage == Stages.Normal);
113         // Amount must not exeed this.balance
114         require(amount <= this.balance);
115 		// Require valid address to transfer
116 		require(recipient != address(0x0));
117 		
118         recipient.transfer(amount);
119         // This is used by Last Chance function
120 		lastExpenseTime = now;
121     }
122 
123     /// Withdraw to Resque Account in case of loosing Owner account access
124     function withdrawByResque() onlyByResque() {
125         // If not already requested (see below)
126         if(stage != Stages.ResqueRequested)
127         {
128             // Set time for counting down a quarantine period
129             resqueRequestTime = now;
130             // Change stage that it'll not be possible to use Owner account to transfer money
131             stage = Stages.ResqueRequested;
132             return;
133         }
134         // Check for being in quarantine period
135         else if(now <= resqueRequestTime + 1 minutes)
136         {
137             return;
138         }
139         // Come here after quarantine
140         require(stage == Stages.ResqueRequested);
141         msg.sender.transfer(this.balance);
142     }
143 
144     /* 
145     * Setting Emergency Account in case of loosing access to Owner and Resque accounts
146     * emergencyAccountHash: keccak256("your keyword phrase", address ResqueAccount)
147     * photoHash: keccak256("one_of_your_photofile.pdf_data_passed_to_constructor_of_this_NYX_Account_upon_creation")
148     */
149     function setEmergencyAccount(bytes32 emergencyAccountHash, bytes32 photoHash) onlyByAuthority() {
150         require(photoHash != 0x0 && emergencyAccountHash != 0x0);
151         /// First check that photoHash is one of those that exist in this NYX Account
152         uint8 x = 0;
153         bool authorized = false;
154         while(x < photoHashes.length)
155         {
156             if(photoHashes[x] == keccak256(photoHash))
157             {
158                 // Photo found, continue
159                 authorized = true;
160                 break;
161             }
162             x++;
163         }
164         require(authorized);
165         /// Set count down time for quarantine period
166         authorityRequestTime = now;
167         /// Change stage in order to protect from withdrawing by Owner's or Resque's accounts 
168         stage = Stages.AuthorityRequested;
169         /// Set supplied hash that will be used to withdraw to Emergency account after quarantine
170 		emergencyHash = emergencyAccountHash;
171     }
172    
173     /// Withdraw to Emergency Account after loosing access to both Owner and Resque accounts
174 	function withdrawByEmergency(string keyword) onlyByEmergency(keyword)
175 	{
176 		require(now > authorityRequestTime + 1 days);
177 		require(keccak256(keyword) == keywordHash);
178 		require(stage == Stages.AuthorityRequested);
179 		
180 		msg.sender.transfer(this.balance);
181 	}
182 
183     /*
184     * Allows optionally unauthorized withdrawal to any address after loosing 
185     * all authorization assets such as keyword phrase, photo files, private keys/passwords
186     */
187 	function lastChance(address recipient, address resqueAccount)
188 	{
189 	    /// Last Chance works only if was previosly enabled AND after 2 months since last outgoing transaction
190 		if(!lastChanceEnabled || now <= lastExpenseTime + 1 minutes)
191 			return;
192 		/// If use of Resque address was required	
193 		if(lastChanceUseResqueAccountAddress)
194 			require(keccak256(resqueAccount) == resqueHash);
195 			
196 		recipient.transfer(this.balance);			
197 	}	
198 	
199     /// Fallback for receiving plain transactions
200     function() payable
201     {
202         /// Refuse accepting funds in abnormal state
203         require(stage == Stages.Normal);
204     }
205 }