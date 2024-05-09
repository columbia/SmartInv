1 //pragma solidity ^0.3.6;
2 contract Token {
3 	function balanceOf(address user) constant returns (uint256 balance);
4 	function transfer(address receiver, uint amount) returns(bool);
5 }
6 
7 // A Sub crowdfunding contract. Its only purpose is to redirect ether it receives to the 
8 // main crowdfunding contract. This mecanism is usefull to know the sponsor to
9 // reward for an indirect donation. You can't give for someone else when you give through
10 // these contracts
11 contract AltCrowdfunding {
12 	
13 	Crowdfunding mainCf ;                                       // Referenre to the main crowdfunding contract
14 	
15 	function AltCrowdfunding(address cf){						// Construct the altContract with a reference to the main one
16 		mainCf = Crowdfunding(cf);
17 	}
18 	
19 	function(){
20 		mainCf.giveFor.value(msg.value)(msg.sender);			// Relay Ether sent to the main crowndfunding contract
21 	}
22 	
23 }
24 
25 contract Crowdfunding {
26 
27 	struct Backer {
28 		uint weiGiven;										// Amount of Ether given
29 		uint ungivenNxc ;                                 	// (pending) If the first goal of the crowdfunding is not reached yet the NxC are stored here
30 	}
31 	
32 	struct Sponsor {
33 	    uint nxcDirected;                                   // How much milli Nxc this sponsor sold for us
34 	    uint earnedNexium;                                  // How much milli Nxc this sponsor earned by solding Nexiums for us
35 	    address sponsorAddress;                             // Where Nexiums earned by a sponsor are sent
36 	    uint sponsorBonus;
37 	    uint backerBonus;
38 	}
39 	
40     //Every public variable can be read by everyone from the blockchain
41 	
42 	Token 	public nexium;                                  // Nexium contract reference
43 	address public owner;					               	// Contract admin (beyond the void)
44 	address public beyond;					            	// Address that will receive ether when the first step is be reached
45 	address public bitCrystalEscrow;   						// Our escrow for Bitcrystals (ie EverdreamSoft)
46 	uint 	public startingEtherValue;						// How much milli Nxc are sent by ether
47 	uint 	public stepEtherValue;					        // For every stage of the crowdfunding, the number of Nexium sent by ether is decreased by this number
48 	uint    public collectedEth;                            // Collected ether in wei
49 	uint 	public nxcSold;                                 // How much milli Nxc were sold 
50 	uint 	public perStageNxc;                             // How much milli Nxc we much sell for each stage
51 	uint 	public nxcPerBcy;                         		// How much milli Nxc we give for each Bitcrystal
52     uint 	public collectedBcy;                            // Collected Bitcrystals
53 	uint 	public minInvest;				            	// Minimum to invest (in wei)
54 	uint 	public startDate;    							// crowndfunding startdate                               
55 	uint 	public endDate;									// crowndfunding enddate 
56 	bool 	public isLimitReached;                          // Tell if the first stage of the CrowdFunding is reached, false when not set
57 	
58 	address[] public backerList;							// Addresses of all backers
59 	address[] public altList;					     		// List of alternative contracts for sponsoring (useless for this contract)
60 	mapping(address => Sponsor) public sponsorList;	        // The sponsor linked to an alternative contract
61 	mapping(address => Backer) public backers;            	// The Backer for a given address
62 
63 	modifier onlyBy(address a){
64 		if (msg.sender != a) throw;                         // Auth modifier, if the msg.sender isn't the expected address, throw.
65 		_
66 	}
67 	
68 	event Gave(address);									// 
69 	
70 //--------------------------------------\\
71 	
72 	function Crowdfunding() {
73 		
74 		// Constructor of the contract. set the different variables
75 		
76 		nexium = Token(0x45e42d659d9f9466cd5df622506033145a9b89bc); 	// Nexium contract address
77 		beyond = 0x89E7a245d5267ECd5Bf4cA4C1d9D4D5A14bbd130 ;
78 		owner = msg.sender;
79 		minInvest = 10 finney;
80 		startingEtherValue = 700*1000;
81 		stepEtherValue = 25*1000;
82 		nxcPerBcy = 14;
83 		perStageNxc = 5000000 * 1000;
84 		startDate = 1478012400 ;
85 		endDate = 1480604400 ;
86 		bitCrystalEscrow = 0x72037bf2a3fc312cde40c7f7cd7d2cef3ad8c193;
87 	} 
88 
89 //--------------------------------------\\
90 	
91 	// Use this function to buy Nexiums for someone (can be you of course)
92 	function giveFor(address beneficiary){
93 		if (msg.value < minInvest) throw;                                      // Throw when the minimum to invest isn't reached
94 		if (endDate < now || (now < startDate && now > startDate - 3 hours )) throw;        // Check if the crowdfunding is started and not already over
95 		
96 		// Computing the current amount of Nxc we send per ether. 
97 		uint currentEtherValue = getCurrEthValue();
98 		
99 		//it's possible to invest before the begining of the crowdfunding but the price is x10.
100 		//Allow backers to test the contract before the begining.
101 		if(now < startDate) currentEtherValue /= 10;
102 		
103 		// Computing the number of milli Nxc we will send to the beneficiary
104 		uint givenNxc = (msg.value * currentEtherValue)/(1 ether);
105 		nxcSold += givenNxc;                                                   //Updating the sold Nxc amount
106 		if (nxcSold >= perStageNxc) isLimitReached = true ; 
107 		
108 		Sponsor sp = sponsorList[msg.sender];
109 		
110 		//Check if the user gives through a sponsor contract
111 		if (sp.sponsorAddress != 0x0000000000000000000000000000000000000000) {
112 		    sp.nxcDirected += givenNxc;                                        // Update the number of milli Nxc this sponsor sold for us
113 		    
114 		    // This part compute the bonus rate NxC the sponsor will have depending on the total of Nxc he sold.
115 		    uint bonusRate = sp.nxcDirected / 80000000;
116 		    if (bonusRate > sp.sponsorBonus) bonusRate = sp.sponsorBonus;
117 		    
118 		    // Giving to the sponsor the amount of Nxc he earned by this last donation
119 		    uint sponsorNxc = (sp.nxcDirected * bonusRate)/100 - sp.earnedNexium;
120 			if (!giveNxc(sp.sponsorAddress, sponsorNxc))throw;
121 			
122 			
123 			sp.earnedNexium += sponsorNxc;                                     // Update the number of milli Nxc this sponsor earned
124 			givenNxc = (givenNxc*(100 + sp.backerBonus))/100;                  // Increase by x% the number of Nxc we will give to the backer
125 		}
126 		
127 		if (!giveNxc(beneficiary, givenNxc))throw;                             // Give to the Backer the Nxc he just earned
128 		
129 		// Add the new Backer to the list, if he gave for the first time
130 		Backer backer = backers[beneficiary];
131 		if (backer.weiGiven == 0){
132 			backerList[backerList.length++] = beneficiary;
133 		}
134 		backer.weiGiven += msg.value;                                          // Update the gave wei of this Backer
135 		collectedEth += msg.value;                                             // Update the total wei collcted during the crowdfunding     
136 		Gave(beneficiary);                                                     // Trigger an event 
137 	}
138 	
139 	
140 	// If you gave ether before the first stage is reached you might have some ungiven
141 	// Nxc for your address. This function, if called, will give you the nexiums you didn't
142 	// received. /!\ Nexium bonuses for your partner rank will not be given during the crowdfunding
143 	function claimNxc(){
144 	    if (!isLimitReached) throw;
145 	    address to = msg.sender;
146 	    nexium.transfer(to, backers[to].ungivenNxc);
147 	    backers[to].ungivenNxc = 0;
148 	}
149 	
150 	// This function can be called after the crowdfunding if the first goal is not reached
151 	// It gives back the ethers of the specified address
152 	function getBackEther(){
153 	    getBackEtherFor(msg.sender);
154 	}
155 	
156 	function getBackEtherFor(address account){
157 	    if (now > endDate && !isLimitReached){
158 	        uint sentBack = backers[account].weiGiven;
159 	        backers[account].weiGiven = 0;                                     // No DAO style re entrance ;)
160 	        if(!account.send(sentBack))throw;
161 	    } else throw ;
162 	}
163 	
164 	// The anonymous function automatically make a donation for the person who gave ethers
165 	function(){
166 		giveFor(msg.sender);
167 	}
168 	
169 //--------------------------------------\\
170 
171     //Create a new sponsoring contract 
172 	function addAlt(address sponsor, uint _sponsorBonus, uint _backerBonus)
173 	onlyBy(owner){
174 	    if (_sponsorBonus > 10 || _backerBonus > 10 || _sponsorBonus + _backerBonus > 15) throw;
175 		altList[altList.length++] = address(new AltCrowdfunding(this));
176 		sponsorList[altList[altList.length -1]] = Sponsor(0, 0, sponsor, _sponsorBonus, _backerBonus);
177 	}
178 	
179 	// Set the value of BCY gave by the SOG network. Only our BCY escrow can modify it.
180     function setBCY(uint newValue)
181     onlyBy(bitCrystalEscrow){
182         if (now < startDate || now > endDate) throw;
183         if (newValue != 0 && newValue < 714285714) collectedBcy = newValue; // 714285714 * 14 ~= 10 000 000 000 mili Nxc maximum to avoid wrong value
184         else throw;
185     }
186     
187     // If the minimum goal is reached, beyond the void can have the ethers stored on the contract
188     function withdrawEther(address to, uint amount)
189     onlyBy(owner){
190         if (!isLimitReached) throw;
191         var r = to.send(amount);
192     }
193     
194     function withdrawNxc(address to, uint amount)
195     onlyBy(owner){
196         nexium.transfer(to, amount);
197     }
198     
199     //If there are still Nexiums or Ethers on the contract after 100 days after the end of the crowdfunding
200     //This function send all of it to the multi sig of the beyond the void team (emergency case)
201     function blackBox(){
202         if (now < endDate + 100 days)throw;
203         nexium.transfer(beyond, nexium.balanceOf(this));
204         var r = beyond.send(this.balance);
205     }
206 	
207 	// Each time this contract send Nxc this function is called. It check if
208 	// the minimum goal is reached before sending any nexiums out.
209 	function giveNxc(address to, uint amount) internal returns (bool){
210 	    bool res;
211 	    if (isLimitReached){
212 	        if (nexium.transfer(to, amount)){
213 	            // If there is some ungiven Nxc remaining for this address, send it.
214 	            if (backers[to].ungivenNxc != 0){
215 	                 res = nexium.transfer(to, backers[to].ungivenNxc); 
216 	                 backers[to].ungivenNxc = 0;
217 	            } else {
218 	                res = true;
219 	            }
220 	        } else {
221 	            res = false;
222 	        }
223 		// If the limit is not reached yet, the nexiums are not sent but stored in the contract waiting this goal being reached.
224 		// They are released when the same backer gives ether while the limit is reached, or by claiming them after the minimal goal is reached .
225 	    } else {
226 	        backers[to].ungivenNxc += amount;
227 	        res = true;
228 	    }
229 	    return res;
230 	}
231 	
232 	//--------------------------------------\\
233 	
234 	function getCurrEthValue() returns(uint){
235 	    return  startingEtherValue - stepEtherValue * ((nxcSold + collectedBcy * nxcPerBcy)/perStageNxc);
236 	}
237 	
238 }