1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
11   */
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16 
17   /**
18   * @dev Adds two numbers, throws on overflow.
19   */
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Moneda {
28     using SafeMath for uint256;
29     
30     string constant public standard = "ERC20";
31     string constant public name = "Moneda Token";
32     string constant public symbol = "MND";
33     uint8 constant public decimals = 18;
34     
35     uint256 private _totalSupply = 400000000e18; // Total supply tokens 400mil
36     uint256 constant public preICOLimit = 20000000e18; // Pre-ICO limit 5%, 20mil
37     uint256 constant public icoLimit = 250000000e18; // ICO limit 62.5%, 250mil
38     uint256 constant public companyReserve = 80000000e18; // Company Reserve 20%, 80mil
39     uint256 constant public teamReserve = 40000000e18; // Team Reserve 10%, 40mil
40     uint256 constant public giveawayReserve = 10000000e18; // referral and giving away 2.5%, 10mil
41 
42     uint256 public preICOEnds = 1525132799; // Monday, April 30, 2018 11:59:59 PM
43     uint256 public icoStarts = 1526342400; // Tuesday, May 15, 2018 12:00:00 AM
44     uint256 public icoEnds = 1531699199; // Sunday, July 15, 2018 11:59:59 PM
45     
46     uint256 constant public startTime = 1532822400; // Two weeks after ICO ends, Sunday, July 29, 2018 12:00:00 AM
47     uint256 constant public teamCompanyLock = 1563148800; // One Year after ICO Ends, Reserve Tokens of company and team becomes transferable.  Monday, July 15, 2019 12:00:00 AM
48 
49     address public ownerAddr;
50     address public companyAddr;
51     address public giveawayAddr;
52     bool public burned;
53 
54     // Array with all balances
55     mapping (address => uint256) public balances;
56     mapping (address => mapping (address => uint256)) internal allowed;
57 
58     // Public event on the blockchain that will notify clients
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61     event Burned(uint256 amount);
62     
63     // Initializes contract with initial supply tokens to the creator of the contract
64     function Moneda(address _ownerAddr, address _companyAddr, address _giveawayAddr) public {
65         ownerAddr = _ownerAddr;
66         companyAddr = _companyAddr;
67         giveawayAddr = _giveawayAddr;
68         balances[ownerAddr] = _totalSupply; // Give the owner all initial tokens
69     }
70     
71     // Gets the total token supply
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     // Gets the balance of the specified address.
77     function balanceOf(address who) public view returns (uint256) {
78         return balances[who];
79     }
80     
81     // Function to check the amount of tokens that an owner allowed to a spender.
82     function allowance(address owner, address spender) public view returns (uint256) {
83         return allowed[owner][spender];
84     }
85     
86     // Transfer some of your tokens to another address
87     function transfer(address to, uint256 value) public returns (bool) {
88         require(now >= startTime); // Check if one month lock is passed
89         require(value > 0);
90 
91         if (msg.sender == ownerAddr || msg.sender == companyAddr)
92                 require(now >= teamCompanyLock);
93                 
94         balances[msg.sender] = balances[msg.sender].sub(value);
95         balances[to] = balances[to].add(value);
96         emit Transfer(msg.sender, to, value);
97         return true;
98     }
99     
100     // Transfer tokens from one address to another
101     function transferFrom(address from, address to, uint256 value) public returns (bool) {
102         require(value > 0);
103         require(to != address(0));
104         require(value <= balances[from]);
105         require(value <= allowed[from][msg.sender]);
106         
107         if (now < icoEnds)  // Check if the crowdsale is already over
108             require(from == ownerAddr);
109 
110         if (msg.sender == ownerAddr || msg.sender == companyAddr)
111             require(now >= teamCompanyLock);
112             
113         balances[from] = balances[from].sub(value);
114         balances[to] = balances[to].add(value);
115         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
116         emit Transfer(from, to, value);
117         return true;
118     }
119     
120     //Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
121     function approve(address spender, uint256 value) public returns (bool) {
122         require((value == 0) || (allowed[msg.sender][spender] == 0));
123         allowed[msg.sender][spender] = value;
124         emit Approval(msg.sender, spender, value);
125         return true;
126     }
127 
128    // Called when ICO is closed. Burns the remaining tokens except the tokens reserved:
129     // Anybody may burn the tokens after ICO ended, but only once (in case the owner holds more tokens in the future).
130     // this ensures that the owner will not posses a majority of the tokens.
131     function burn() public {
132         // Make sure it's after ICO and hasn't been called before.
133         require(!burned && now > icoEnds);
134         uint256 totalReserve = teamReserve.add(companyReserve);
135         uint256 difference = balances[ownerAddr].sub(totalReserve);
136         balances[ownerAddr] = teamReserve;
137         balances[companyAddr] = companyReserve;
138         balances[giveawayAddr] = giveawayReserve;
139         _totalSupply = _totalSupply.sub(difference);
140         burned = true;
141         emit Burned(difference);
142     }
143 }