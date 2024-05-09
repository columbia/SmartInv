1 pragma solidity ^0.4.0;
2 
3 /**
4  * Author: Nick Johnson <arachnid at notdot.net>
5  * 
6  * WARNING: This contract is new and thus-far only lightly tested. I'm fairly
7  * confident it operates as described, but you may want to assure yourself of
8  * its correctness - or wait for others to do so for you - before you trust your
9  * ether to it. No guarantees, express or implied, are provided - use at your
10  * own risk.
11  * 
12  * @dev Ether vault contract. Stores ether with a 'time lock' on withdrawals,
13  *      giving a user the chance to reclaim funds if an account is compromised.
14  *      A recovery address has the ability to immediately destroy the wallet and
15  *      send its funds to a new contract (such as a new vault, if the wallet)
16  *      associated with this one is compromised or lost). A cold wallet or
17  *      secure brain wallet should typically be used for this purpose.
18  * 
19  * Setup:
20  *   To set up a vault, first create a cold wallet or secure brain wallet to use
21  *   as a recovery key, and get its address. Then, deploy this vault contract
22  *   with the address of the recovery key, and a time delay (in seconds) to
23  *   impose on withdrawals.
24  * 
25  * Deposits:
26  *   Simply deposit funds into this contract by sending them to them. This
27  *   contract only uses the minimum gas stipend, so it's safe to use with
28  *   sites that "don't support smart contracts".
29  * 
30  * Withdrawals:
31  *   Call unvault() with the amount you wish to withdraw (in wei - one ether is
32  *   1e18 wei). After the time delay you specified when you created the wallet,
33  *   you can call withdraw() to receive the funds.
34  * 
35  * Vacations:
36  *   If you anticipate not having access to the recovery key for some period,
37  *   you can call `lock()` with a period (in seconds) that the funds should be
38  *   unavailable for; this will prohibit any withdrawals completing during that
39  *   period. If a withdrawal is outstanding, it will be postponed until the
40  *   end of this period, too.
41  * 
42  * Recovery:
43  *   If your hotwallet is every compromised, or you detect an unauthorized
44  *   `Unvault()` event, use your recovery key to call the `recover()` function
45  *   with the address you want funds sent to. The funds will be immediately
46  *   sent to this address (with no delay) and the contract will self destruct.
47  * 
48  *   For safety, you may wish to prepare a new vault (with a new recovery key)
49  *   and send your funds directly to that.
50  */
51 contract Vault {
52     /**
53      * @dev Owner of the vault.
54      */
55     address public owner;
56     
57     /**
58      * @dev Recovery address for this vault.
59      */
60     address public recovery;
61 
62     /**
63      * @dev Minimum interval between making an unvault call and allowing a
64      *      withdrawal.
65      */
66     uint public withdrawDelay;
67 
68     /**
69      * @dev Earliest time at which a withdrawal can be made.
70      *      Valid iff withdrawAmount > 0.
71      */
72     uint public withdrawTime;
73     
74     /**
75      * @dev Amount requested to be withdrawn.
76      */
77     uint public withdrawAmount;
78 
79     
80     modifier only_owner() {
81         if(msg.sender != owner) throw;
82         _;
83     }
84     
85     modifier only_recovery() {
86         if(msg.sender != recovery) throw;
87         _;
88     }
89 
90     /**
91      * @dev Withdrawal request made
92      */
93     event Unvault(uint amount, uint when);
94     
95     /**
96      * @dev Recovery key used to send all funds to `address`.
97      */
98     event Recover(address target, uint value);
99     
100     /**
101      * @dev Funds deposited.
102      */
103     event Deposit(address from, uint value);
104     
105     /**
106      * @dev Funds withdrawn.
107      */
108     event Withdraw(address to, uint value);
109 
110     /**
111      * @dev Constructor.
112      * @param _recovery The address of the recovery account.
113      * @param _withdrawDelay The time (in seconds) between an unvault request
114      *        and the earliest time a withdrawal can be made.
115      */
116     function Vault(address _recovery, uint _withdrawDelay) {
117         owner = msg.sender;
118         recovery = _recovery;
119         withdrawDelay = _withdrawDelay;
120     }
121     
122     function max(uint a, uint b) internal returns (uint) {
123         if(a > b)
124             return a;
125         return b;
126     }
127     
128     /**
129      * @dev Request withdrawal of funds from the vault. Starts a timer for when
130      *      funds can be withdrawn. Increases to the amount will reset the
131      *      timer, but decreases can be made without changing it.
132      * @param amount The amount requested for withdrawal.
133      */
134     function unvault(uint amount) only_owner {
135         if(amount > this.balance)
136             throw;
137             
138         // Update the withdraw time if we're withdrawing more than previously.
139         if(amount > withdrawAmount)
140             withdrawTime = max(withdrawTime, block.timestamp + withdrawDelay);
141         
142         withdrawAmount = amount;
143         Unvault(amount, withdrawTime);
144     }
145     
146     /**
147      * @dev Withdraw funds. Valid only after `unvault` has been called and the
148      *      required interval has elapsed.
149      */
150     function withdraw() only_owner {
151         if(block.timestamp < withdrawTime || withdrawAmount == 0)
152             throw;
153         
154         uint amount = withdrawAmount;
155         withdrawAmount = 0;
156 
157         if(!owner.send(amount))
158             throw;
159 
160         Withdraw(owner, amount);
161     }
162     
163     /**
164      * @dev Use the recovery address to send all funds to the nominated address
165      *      and self-destruct this vault.
166      * @param target The target address to send funds to.
167      */
168     function recover(address target) only_recovery {
169         Recover(target, this.balance);
170         selfdestruct(target);
171     }
172     
173     /**
174      * @dev Permits locking funds for longer than the default duration; useful
175      *      if you will not have access to your recovery key for a while.
176      */
177     function lock(uint duration) only_owner {
178         withdrawTime = max(withdrawTime, block.timestamp + duration);
179     }
180     
181     function() payable {
182         if(msg.value > 0)
183             Deposit(msg.sender, msg.value);
184     }
185 }