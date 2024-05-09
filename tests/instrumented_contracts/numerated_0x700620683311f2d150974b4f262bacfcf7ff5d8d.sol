1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.10;
7 
8 /*************************************************************************
9  * import "./TrancheWallet.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "../common/Owned.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "./IOwned.sol" : start
18  *************************************************************************/
19 
20 /**@dev Simple interface to Owned base class */
21 contract IOwned {
22     function owner() public constant returns (address) {}
23     function transferOwnership(address _newOwner) public;
24 }/*************************************************************************
25  * import "./IOwned.sol" : end
26  *************************************************************************/
27 
28 contract Owned is IOwned {
29     address public owner;        
30 
31     function Owned() public {
32         owner = msg.sender;
33     }
34 
35     // allows execution by the owner only
36     modifier ownerOnly {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     /**@dev allows transferring the contract ownership. */
42     function transferOwnership(address _newOwner) public ownerOnly {
43         require(_newOwner != owner);
44         owner = _newOwner;
45     }
46 }
47 /*************************************************************************
48  * import "../common/Owned.sol" : end
49  *************************************************************************/
50 
51 /**@dev Distributes some amount of currency in small portions available to withdraw once in a period */
52 contract TrancheWallet is Owned {
53     address public beneficiary;         //funds are to withdraw to this account
54     uint256 public tranchePeriodInDays; //one tranche 'cooldown' time
55     uint256 public trancheAmountPct;    //one tranche amount 
56         
57     uint256 public lockStart;           //when funds were locked
58     uint256 public completeUnlockTime;  //when funds are unlocked completely
59     uint256 public initialFunds;        //funds to divide into tranches
60     uint256 public tranchesSent;        //tranches already sent to beneficiary
61 
62     event Withdraw(uint256 amount, uint256 tranches);
63 
64     function TrancheWallet(
65         address _beneficiary, 
66         uint256 _tranchePeriodInDays,
67         uint256 _trancheAmountPct        
68         ) 
69     {
70         beneficiary = _beneficiary;
71         tranchePeriodInDays = _tranchePeriodInDays;
72         trancheAmountPct = _trancheAmountPct;
73         tranchesSent = 0;
74         completeUnlockTime = 0;
75     }
76 
77     /**@dev Sets new beneficiary to receive funds */
78     function setBeneficiary(address newBeneficiary) public ownerOnly {
79         beneficiary = newBeneficiary;
80     }
81 
82     //Locks all funds on account so that it's possible to withdraw only specific tranche amount.
83     //Funds will be unlocked completely in a given amount of days 
84     //Can be made only one time
85     function lock(uint256 lockPeriodInDays) public ownerOnly {
86         require(lockStart == 0);
87 
88         initialFunds = currentBalance();//this.balance;
89         lockStart = now;
90         completeUnlockTime = lockPeriodInDays * 1 days + lockStart;
91     }
92 
93     /**@dev Sends available tranches to beneficiary account*/
94     function sendToBeneficiary() {
95         uint256 amountToWithdraw;
96         uint256 tranchesToSend;
97         (amountToWithdraw, tranchesToSend) = amountAvailableToWithdraw();
98 
99         require(amountToWithdraw > 0);
100 
101         tranchesSent += tranchesToSend;
102         doTransfer(amountToWithdraw);
103 
104         Withdraw(amountToWithdraw, tranchesSent);
105     }
106 
107     /**@dev Calculates available amount to withdraw */
108     function amountAvailableToWithdraw() constant returns (uint256 amount, uint256 tranches) {        
109         if (currentBalance() > 0) {
110             if(now > completeUnlockTime) {
111                 //withdraw everything
112                 amount = currentBalance();
113                 tranches = 0;
114             } else {
115                 //withdraw tranche                
116                 uint256 periodsSinceLock = (now - lockStart) / (tranchePeriodInDays * 1 days);
117                 tranches = periodsSinceLock - tranchesSent + 1;                
118                 amount = tranches * oneTrancheAmount();
119 
120                 //check if exceeding current limit
121                 if(amount > currentBalance()) {
122                     amount = currentBalance();
123                     tranches = amount / oneTrancheAmount();
124                 }
125             }
126         } else {
127             amount = 0;
128             tranches = 0;
129         }
130     }
131 
132     /**@dev Returns the size of one tranche */
133     function oneTrancheAmount() constant returns(uint256) {
134         return trancheAmountPct * initialFunds / 100; 
135     }
136 
137     /**@dev Returns current balance to be distributed to portions*/
138     function currentBalance() internal constant returns(uint256);
139 
140     /**@dev Transfers given amount of currency to the beneficiary */
141     function doTransfer(uint256 amount) internal;
142 }
143 /*************************************************************************
144  * import "./TrancheWallet.sol" : end
145  *************************************************************************/
146 /*************************************************************************
147  * import "../token/IERC20Token.sol" : start
148  *************************************************************************/
149 
150 contract IERC20Token {
151 
152     // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
153     function name() public constant returns (string _name) { _name; }
154     function symbol() public constant returns (string _symbol) { _symbol; }
155     function decimals() public constant returns (uint8 _decimals) { _decimals; }
156     
157     function totalSupply() public constant returns (uint total) {total;}
158     function balanceOf(address _owner) public constant returns (uint balance) {_owner; balance;}    
159     function allowance(address _owner, address _spender) public constant returns (uint remaining) {_owner; _spender; remaining;}
160 
161     function transfer(address _to, uint _value) public returns (bool success);
162     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
163     function approve(address _spender, uint _value) public returns (bool success);
164     
165 
166     event Transfer(address indexed _from, address indexed _to, uint _value);
167     event Approval(address indexed _owner, address indexed _spender, uint _value);
168 }
169 /*************************************************************************
170  * import "../token/IERC20Token.sol" : end
171  *************************************************************************/
172 
173 /**@dev Wallet that contains some amount of tokens and allows to withdraw it in small portions */
174 contract TokenTrancheWallet is TrancheWallet {
175 
176     /**@dev Token to be stored */
177     IERC20Token public token;
178 
179     function TokenTrancheWallet(
180         IERC20Token _token,
181         address _beneficiary, 
182         uint256 _tranchePeriodInDays,
183         uint256 _trancheAmountPct
184         ) TrancheWallet(_beneficiary, _tranchePeriodInDays, _trancheAmountPct) 
185     {
186         token = _token;
187     }
188 
189     /**@dev Returns current balance to be distributed to portions*/
190     function currentBalance() internal constant returns(uint256) {
191         return token.balanceOf(this);
192     }
193 
194     /**@dev Transfers given amount of currency to the beneficiary */
195     function doTransfer(uint256 amount) internal {
196         require(token.transfer(beneficiary, amount));
197     }
198 }