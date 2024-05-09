1 pragma solidity ^0.4.19;
2 contract ETHRoyale {
3     address devAccount = 0x50334D202f61F80384C065BE6537DD3d609FF9Ab; //Dev address to send dev fee (0.75%) to.
4     uint masterBalance; //uint var for total real balance of contract
5     uint masterApparentBalance; //var for total apparent balance of contract (real balance + all fake interest collected)
6     
7     //Array log of current participants
8     address[] public participants;
9     mapping (address => uint) participantsArrayLocation;
10     uint participantsCount;
11     
12     //Boolean to check if deposits are enabled
13     bool isDisabled;
14 	bool hasStarted;
15 	
16     //Track deposit times
17     uint blockHeightStart;
18     bool isStart;
19     event Deposit(uint _valu);
20 	
21     //Mappings to link account values and dates of last interest claim with an Ethereum address
22     mapping (address => uint) accountBalance;
23     mapping (address => uint) realAccountBalance;
24     mapping (address => uint) depositBlockheight;
25     
26     //Check individual account balance and return balance associated with that address
27     function checkAccBalance() public view returns (uint) {
28         address _owner = msg.sender;
29         return (accountBalance[_owner]);
30     }
31     
32     //Check actual balance of all wallets
33     function checkGlobalBalance() public view returns (uint) {
34         return masterBalance;
35     }
36     
37 	//Check game status
38 	function checkGameStatus() public view returns (bool) {
39         return (isStart);
40     }
41     function checkDisabledStatus() public view returns (bool) {
42         return (isDisabled);
43     }
44 	
45     //Check interest due
46     function checkInterest() public view returns (uint) {
47         address _owner = msg.sender;
48         uint _interest;
49         if (isStart) {
50             if (blockHeightStart > depositBlockheight[_owner]) {
51 		        _interest = ((accountBalance[_owner] * (block.number - blockHeightStart) / 2000));
52 		    } else {
53 		        _interest = ((accountBalance[_owner] * (block.number - depositBlockheight[_owner]) / 2000));
54 		    }
55 		return _interest;
56         }else {
57 			return 0;
58         }
59     }
60 	
61     //Check interest due + balance
62     function checkWithdrawalAmount() public view returns (uint) {
63         address _owner = msg.sender;
64         uint _interest;
65 		if (isStart) {
66 		    if (blockHeightStart > depositBlockheight[_owner]) {
67 		        _interest = ((accountBalance[_owner] * (block.number - blockHeightStart) / 2000));
68 		    } else {
69 		        _interest = ((accountBalance[_owner] * (block.number - depositBlockheight[_owner]) / 2000));
70 		    }
71 	    return (accountBalance[_owner] + _interest);
72 		} else {
73 			return accountBalance[_owner];
74 		}
75     }
76     //check number of participants
77     function numberParticipants() public view returns (uint) {
78         return participantsCount;
79     }
80     
81     //Take deposit of funds
82     function deposit() payable public {
83         address _owner = msg.sender;
84         uint _amt = msg.value;         
85         require (!isDisabled && _amt >= 10000000000000000 && isNotContract(_owner));
86         if (accountBalance[_owner] == 0) { //If account is a new player, add them to mappings and arrays
87             participants.push(_owner);
88             participantsArrayLocation[_owner] = participants.length - 1;
89             depositBlockheight[_owner] = block.number;
90             participantsCount++;
91 			if (participantsCount > 4) { //If game has 5 or more players, interest can start.
92 				isStart = true;
93 				blockHeightStart = block.number;
94 				hasStarted = true;
95 			}
96         }
97         else {
98             isStart = false;
99             blockHeightStart = 0;
100         }
101 		Deposit(_amt);
102         //add deposit to amounts
103         accountBalance[_owner] += _amt;
104         realAccountBalance[_owner] += _amt;
105         masterBalance += _amt;
106         masterApparentBalance += _amt;
107     }
108     
109     //Retrieve interest earned since last interest collection
110     function collectInterest(address _owner) internal {
111         require (isStart);
112         uint blockHeight; 
113         //Require 5 or more players for interest to be collected to make trolling difficult
114         if (depositBlockheight[_owner] < blockHeightStart) {
115             blockHeight = blockHeightStart;
116         }
117         else {
118             blockHeight = depositBlockheight[_owner];
119         }
120         //Add 0.05% interest for every block (approx 14.2 sec https://etherscan.io/chart/blocktime) since last interest collection/deposit
121         uint _tempInterest = accountBalance[_owner] * (block.number - blockHeight) / 2000;
122         accountBalance[_owner] += _tempInterest;
123         masterApparentBalance += _tempInterest;
124 		//Set time since interest last collected
125 		depositBlockheight[_owner] = block.number;
126 	}
127 
128     //Allow withdrawal of funds and if funds left in contract are less than withdrawal requested and greater or = to account balance, contract balance will be cleared
129     function withdraw(uint _amount) public  {
130         address _owner = msg.sender; 
131 		uint _amt = _amount;
132         uint _devFee;
133         require (accountBalance[_owner] > 0 && _amt > 0 && isNotContract(_owner));
134         if (isStart) { //Collect interest due if game has started
135         collectInterest(msg.sender);
136         }
137 		require (_amt <= accountBalance[_owner]);
138         if (accountBalance[_owner] == _amount || accountBalance[_owner] - _amount < 10000000000000000) { //Check if sender is withdrawing their entire balance or will leave less than 0.01ETH
139 			_amt = accountBalance[_owner];
140 			if (_amt > masterBalance) { //If contract balance is lower than account balance, withdraw account balance.
141 				_amt = masterBalance;
142 			}	
143             _devFee = _amt / 133; //Take 0.75% dev fee
144             _amt -= _devFee;
145             masterApparentBalance -= _devFee;
146             masterBalance -= _devFee;
147             accountBalance[_owner] -= _devFee;
148             masterBalance -= _amt;
149             masterApparentBalance -= _amt;
150             //Delete sender address from mappings and arrays if they are withdrawing their entire balance
151             delete accountBalance[_owner];
152             delete depositBlockheight[_owner];
153             delete participants[participantsArrayLocation[_owner]];
154 			delete participantsArrayLocation[_owner];
155             delete realAccountBalance[_owner];
156             participantsCount--;
157             if (participantsCount < 5) { //If there are less than 5 people, stop the game.
158                 isStart = false;
159 				if (participantsCount < 3 && hasStarted) { //If there are less than 3 players and the game was started earlier, disable deposits until there are no players left
160 					isDisabled = true;
161 				}
162 				if (participantsCount == 0) { //Enable deposits if there are no players currently deposited
163 					isDisabled = false;
164 					hasStarted = false;
165 				}	
166             }
167         }
168         else if (accountBalance[_owner] > _amount){ //Check that account has enough balance to withdraw
169 			if (_amt > masterBalance) {
170 				_amt = masterBalance;
171 			}	
172             _devFee = _amt / 133; //Take 0.75% of withdrawal for dev fee and subtract withdrawal amount from all balances
173             _amt -= _devFee;
174             masterApparentBalance -= _devFee;
175             masterBalance -= _devFee;
176             accountBalance[_owner] -= _devFee;
177             accountBalance[_owner] -= _amt;
178             realAccountBalance[_owner] -= _amt;
179             masterBalance -= _amt;
180             masterApparentBalance -= _amt;
181         }
182 		Deposit(_amt);
183         devAccount.transfer(_devFee);
184         _owner.transfer(_amt);
185     }
186 	
187 	//Check if sender address is a contract for security purposes.
188 	function isNotContract(address addr) internal view returns (bool) {
189 		uint size;
190 		assembly { size := extcodesize(addr) }
191 		return (!(size > 0));
192 	}
193 }