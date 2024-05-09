1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 /*************************************************************************
9  * import "../common/Owned.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "./IOwned.sol" : start
14  *************************************************************************/
15 
16 /**@dev Simple interface to Owned base class */
17 contract IOwned {
18     function owner() public constant returns (address) {}
19     function transferOwnership(address _newOwner) public;
20 }/*************************************************************************
21  * import "./IOwned.sol" : end
22  *************************************************************************/
23 
24 contract Owned is IOwned {
25     address public owner;        
26 
27     function Owned() public {
28         owner = msg.sender;
29     }
30 
31     // allows execution by the owner only
32     modifier ownerOnly {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     /**@dev allows transferring the contract ownership. */
38     function transferOwnership(address _newOwner) public ownerOnly {
39         require(_newOwner != owner);
40         owner = _newOwner;
41     }
42 }
43 /*************************************************************************
44  * import "../common/Owned.sol" : end
45  *************************************************************************/
46 /*************************************************************************
47  * import "../token/IERC20Token.sol" : start
48  *************************************************************************/
49 
50 /**@dev ERC20 compliant token interface. 
51 https://theethereum.wiki/w/index.php/ERC20_Token_Standard 
52 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md */
53 contract IERC20Token {
54 
55     // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
56     function name() public constant returns (string _name) { _name; }
57     function symbol() public constant returns (string _symbol) { _symbol; }
58     function decimals() public constant returns (uint8 _decimals) { _decimals; }
59     
60     function totalSupply() public constant returns (uint total) {total;}
61     function balanceOf(address _owner) public constant returns (uint balance) {_owner; balance;}    
62     function allowance(address _owner, address _spender) public constant returns (uint remaining) {_owner; _spender; remaining;}
63 
64     function transfer(address _to, uint _value) public returns (bool success);
65     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
66     function approve(address _spender, uint _value) public returns (bool success);
67     
68 
69     event Transfer(address indexed _from, address indexed _to, uint _value);
70     event Approval(address indexed _owner, address indexed _spender, uint _value);
71 }
72 /*************************************************************************
73  * import "../token/IERC20Token.sol" : end
74  *************************************************************************/
75 
76 /**@dev This contract holds tokens and unlock at specific dates.
77 unlockDates - array of UNIX timestamps when unlock happens
78 unlockAmounts - total amount of tokens that are unlocked on that date, the last element should equal to 0
79 For example, if 
80 1st tranche unlocks 10 tokens, 
81 2nd unlocks 15 tokens more
82 3rd unlocks 30 tokens more
83 4th unlocks 40 tokens more - all the rest 
84 then unlockAmounts should be [10, 25, 55, 95]
85  */
86 contract CustomTrancheWallet is Owned {
87 
88     IERC20Token public token;
89     address public beneficiary;
90     uint256 public initialFunds; //initial funds at the moment of lock 
91     bool public locked; //true if funds are locked
92     uint256[] public unlockDates;
93     uint256[] public unlockAmounts;
94     uint256 public alreadyWithdrawn; //amount of tokens already withdrawn
95 
96     function CustomTrancheWallet(
97         IERC20Token _token, 
98         address _beneficiary, 
99         uint256[] _unlockDates, 
100         uint256[] _unlockAmounts
101     ) 
102     public 
103     {
104         token = _token;
105         beneficiary = _beneficiary;
106         unlockDates = _unlockDates;
107         unlockAmounts = _unlockAmounts;
108 
109         require(paramsValid());
110     }
111 
112     /**@dev Returns total number of scheduled unlocks */
113     function unlocksCount() public constant returns(uint256) {
114         return unlockDates.length;
115     }
116 
117     /**@dev Returns amount of tokens available for withdraw */
118     function getAvailableAmount() public constant returns(uint256) {
119         if (!locked) {
120             return token.balanceOf(this);
121         } else {
122             return amountToWithdrawOnDate(now) - alreadyWithdrawn;
123         }
124     }    
125 
126     /**@dev Returns how many token can be withdrawn on specific date */
127     function amountToWithdrawOnDate(uint256 currentDate) public constant returns (uint256) {
128         for (uint256 i = unlockDates.length; i != 0; --i) {
129             if (currentDate > unlockDates[i - 1]) {
130                 return unlockAmounts[i - 1];
131             }
132         }
133         return 0;
134     }
135 
136     /**@dev Returns true if params are valid */
137     function paramsValid() public constant returns (bool) {        
138         if (unlockDates.length == 0 || unlockDates.length != unlockAmounts.length) {
139             return false;
140         }        
141 
142         for (uint256 i = 0; i < unlockAmounts.length - 1; ++i) {
143             if (unlockAmounts[i] >= unlockAmounts[i + 1]) {
144                 return false;
145             }
146             if (unlockDates[i] >= unlockDates[i + 1]) {
147                 return false;
148             }
149         }
150         return true;
151     }
152 
153     /**@dev Sends available amount to stored beneficiary */
154     function sendToBeneficiary() public {
155         uint256 amount = getAvailableAmount();
156         alreadyWithdrawn += amount;
157         require(token.transfer(beneficiary, amount));
158     }
159 
160     /**@dev Locks tokens according to stored schedule */
161     function lock() public ownerOnly {
162         require(!locked);
163         require(token.balanceOf(this) == unlockAmounts[unlockAmounts.length - 1]);
164 
165         locked = true;
166     }
167 
168     /**@dev Changes unlock schedule, can be called only by the owner and if funds are not locked*/
169     function setParams(        
170         uint256[] _unlockDates, 
171         uint256[] _unlockAmounts
172     ) 
173     public 
174     ownerOnly 
175     {
176         require(!locked);        
177 
178         unlockDates = _unlockDates;
179         unlockAmounts = _unlockAmounts;
180 
181         require(paramsValid());
182     }    
183 
184     /**@dev Sets new beneficiary, can be called only by the owner */
185     function setBeneficiary(address _beneficiary) public ownerOnly {
186         beneficiary = _beneficiary;
187     }
188 }