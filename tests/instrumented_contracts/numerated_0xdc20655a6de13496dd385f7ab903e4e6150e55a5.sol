1 pragma solidity ^0.4.18;
2 
3 	library SafeMath {
4 	    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 	        if (a == 0) {
6 	            return 0;
7 	        }
8 	        uint256 c = a * b;
9 	        assert(c / a == b);
10 	        return c;
11 	    }
12 
13 	    function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 	        // assert(b > 0); // Solidity automatically throws when dividing by 0
15 	        uint256 c = a / b;
16 	        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17 	        return c;
18 	    }
19 
20 	    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 	        assert(b <= a);
22 	        return a - b;
23 	    }
24 
25 	    function add(uint256 a, uint256 b) internal pure returns (uint256) {
26 	        uint256 c = a + b;
27 	        assert(c >= a);
28 	        return c;
29 	    }
30 	}
31 
32 	library SafeBonus {
33 	    using SafeMath for uint256;
34 
35 	    function addBonus(uint256 value, uint256 percentages) internal pure returns (uint256) {
36 	        return value.add(value.mul(percentages).div(100));
37 	    }
38 	}
39 
40 	contract Ownable {
41 	    address public owner;
42 
43 
44 	    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47 	    /**
48 	     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49 	     * account.
50 	     */
51 	    function Ownable() public {
52 	        owner = msg.sender;
53 	    }
54 
55 
56 	    /**
57 	     * @dev Throws if called by any account other than the owner.
58 	     */
59 	    modifier onlyOwner() {
60 	        require(msg.sender == owner);
61 	        _;
62 	    }
63 
64 
65 	    /**
66 	     * @dev Allows the current owner to transfer control of the contract to a newOwner.
67 	     * @param newOwner The address to transfer ownership to.
68 	     */
69 	    function transferOwnership(address newOwner) public onlyOwner {
70 	        require(newOwner != address(0));
71 	        OwnershipTransferred(owner, newOwner);
72 	        owner = newOwner;
73 	    }
74 	}
75 
76 	interface token {
77 	    function transfer(address receiver, uint amount) public;
78 	}
79 
80 	contract VesaStage2PreICO is Ownable {
81 	    using SafeMath for uint256;
82 	    using SafeBonus for uint256;
83 
84 	    address public beneficiary;
85 	    uint8 public durationInDays = 31;
86 	    uint public fundingGoal = 100 ether;
87 	    uint public fundingGoalHardCap = 10000 ether;
88 	    uint public amountRaised;
89 	    uint public start;
90 	    uint public deadline;
91 	    uint public bonusPrice = 164285714300000; // 0.0001642857143 ETH
92 	    uint public bonusPriceDeltaPerHour = 3571428573000; // 0.000003571428573 ETH
93 	    uint public bonusPeriodDurationInHours = 10;
94 	    uint public price = 200000000000000; // 0.0002 ETH
95 	    uint public minSum = 200000000000000000; // 0.2 ETH
96 	    token public tokenReward;
97 	    mapping(address => uint256) public balanceOf;
98 	    bool public fundingGoalReached = false;
99 	    bool public crowdsaleClosed = false;
100 	    bool public allowRefund = false;
101 
102 	    event GoalReached(address recipient, uint totalAmountRaised);
103 	    event FundTransfer(address backer, uint amount, bool isContribution);
104 	    event BeneficiaryChanged(address indexed previousBeneficiary, address indexed newBeneficiary);
105 
106 	    /**
107 	     * Constructor function
108 	     *
109 	     * Setup the owner
110 	     */
111 	    function VesaStage2PreICO() public {
112 	        beneficiary = 0x2bF8AeE3845af10f2bbEBbCF53EBd887c5021d14;
113 	        start = 1522155600;
114 	        deadline = start + durationInDays * 1 days;
115 	        tokenReward = token(0xb1c74c1D82824428e484072069041deD079eD921);
116 	    }
117 
118 	    modifier afterDeadline() {
119 	        if (now >= deadline) 
120 	            _;
121 	    }
122 
123 	    function getPrice() public view returns (uint) {
124 	        require(!crowdsaleClosed);
125 	        if ( now >= (start + bonusPeriodDurationInHours.mul(1 hours))) {
126 	            return price;
127 	        } else {
128 	            uint hoursLeft = now.sub(start).div(1 hours);
129 	            return bonusPrice.add(bonusPriceDeltaPerHour.mul(hoursLeft));
130 	        }
131 	    }
132 
133 	    function getBonus(uint amount) public view returns (uint) {
134 	        require(!crowdsaleClosed);
135 
136 	        if (amount < 2857142857000000000) {return 0;}                                        // < 2.857142857
137 	        if (amount >= 2857142857000000000 && amount < 7142857143000000000) {return 35;}      // 2.857142857-7,142857143 ETH
138 	        if (amount >= 7142857143000000000 && amount < 14285714290000000000) {return 42;}     // 7,142857143-14,28571429 ETH
139 	        if (amount >= 14285714290000000000 && amount < 25000000000000000000) {return 47;}    // 14,28571429-25 ETH
140 	        if (amount >= 25000000000000000000 && amount < 85000000000000000000) {return 55;}    // 25-85 ETH
141 	        if (amount >= 85000000000000000000 && amount < 285000000000000000000) {return 65;}   // 85-285 ETH
142 	        if (amount >= 285000000000000000000) {return 75;}                                    // >285 ETH
143 	    }
144 
145 	    /**
146 	     * Fallback function
147 	     *
148 	     * The function without name is the default function that is called whenever anyone sends funds to a contract
149 	     */
150 	    function () public payable {
151 	        require(!crowdsaleClosed);
152 	        require(now > start);
153 	        require(msg.value > minSum);
154 	        uint amount = msg.value;
155 	        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
156 	        amountRaised = amountRaised.add(amount);
157 
158 	        uint currentPrice = getPrice();
159 	        uint currentBonus = getBonus(amount);
160 
161 	        uint tokensToTransfer = amount.mul(10 ** 18).div(currentPrice);
162 	        uint tokensToTransferWithBonuses = tokensToTransfer.addBonus(currentBonus);
163 
164 	        tokenReward.transfer(msg.sender, tokensToTransferWithBonuses);
165 	        FundTransfer(msg.sender, amount, true);
166 	    }
167 
168 	    /**
169 	     * Check if goal was reached
170 	     *
171 	     * Checks if the goal or time limit has been reached and ends the campaign
172 	     */
173 	    function checkGoalReached() public afterDeadline {
174 	        if (amountRaised >= fundingGoal){
175 	            fundingGoalReached = true;
176 	            GoalReached(beneficiary, amountRaised);
177 	        }
178 	        crowdsaleClosed = true;
179 	    }
180 
181 	    /**
182 	     * Withdraw the funds
183 	     *
184 	     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
185 	     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
186 	     * the amount they contributed.
187 	     */
188 	    function safeWithdrawal() public afterDeadline {
189 	        if (allowRefund) {
190 	            uint amount = balanceOf[msg.sender];
191 	            balanceOf[msg.sender] = 0;
192 	            if (amount > 0) {
193 	                if (msg.sender.send(amount)) {
194 	                    FundTransfer(msg.sender, amount, false);
195 	                } else {
196 	                    balanceOf[msg.sender] = amount;
197 	                }
198 	            }
199 	        }
200 
201 	        if (beneficiary == msg.sender) {
202 	            if (beneficiary.send(amountRaised)) {
203 	                FundTransfer(beneficiary, amountRaised, false);
204 	                crowdsaleClosed = true;
205 	            } else {
206 	                //If we fail to send the funds to beneficiary, unlock funders balance
207 	                fundingGoalReached = false;
208 	            }
209 	        }
210 	    }
211 
212 	    function tokensWithdrawal(address receiver, uint amount) public onlyOwner {
213 	        tokenReward.transfer(receiver, amount);
214 	    }
215 
216 	    function initializeRefund() public afterDeadline onlyOwner {
217 	    	allowRefund = true;
218 	    }
219 
220 	    function changeBeneficiary(address newBeneficiary) public onlyOwner {
221 	        require(newBeneficiary != address(0));
222 	        BeneficiaryChanged(beneficiary, newBeneficiary);
223 	        beneficiary = newBeneficiary;
224 	    }
225 
226 	}