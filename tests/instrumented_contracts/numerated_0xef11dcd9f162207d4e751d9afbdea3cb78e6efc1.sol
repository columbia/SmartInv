1 pragma solidity 0.4.19;
2 /// @title ERC223 interface
3 interface ERC223 {
4 
5     function totalSupply() public view returns (uint);
6     function name() public view returns (string);
7     function symbol() public view returns (string);
8     function decimals() public view returns (uint8);
9     function balanceOf(address _owner) public view returns (uint);
10     function transfer(address _to, uint _value) public returns (bool);
11     function transfer(address _to, uint _value, bytes _data) public returns (bool);
12 
13     event Transfer(address indexed _from, address indexed _to, uint indexed _value, bytes _data);
14 }
15 
16 /// @title Interface for the contract that will work with ERC223 tokens.
17 interface ERC223ReceivingContract { 
18     /**
19      * @dev Standard ERC223 function that will handle incoming token transfers.
20      *
21      * @param _from  Token sender address.
22      * @param _value Amount of tokens.
23      * @param _data  Transaction data.
24      */
25     function tokenFallback(address _from, uint _value, bytes _data) public;
26 }
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 
70 
71 /**
72  * @title Vesting of DGTX tokens
73  * @dev Vesting contract allows to lock in DGTX tokens and withdraw them according to the predefined scheme.
74  *   The planned amount to lock-in is 100,000,000 DGTX.
75  * @author SmartDec
76  */
77 contract Vesting is Ownable, ERC223ReceivingContract {
78     address public token;
79     uint public totalTokens = 0;
80     uint public constant FIRST_UNLOCK = 1531612800; // 15 July 2018 00:00 GMT
81     uint public constant TOTAL_TOKENS = 100000000 * (uint(10) ** 18); // 100 000 000 DGTX tokens
82     bool public tokenReceived = false;
83 
84     event Withdraw(address _to, uint _value);
85 
86     /**
87      * @param _token token that will be received by vesting
88      */
89     function Vesting(address _token) public Ownable() {
90         token = _token;
91     }
92 
93     /**
94      * @dev Function to receive ERC223 tokens. Receives tokens once.
95      *   Checks that transfered amount is exactly as planned (100 000 000 DGTX)
96      * @param _value Number of transfered tokens in 10**(decimal)th
97      */
98     function tokenFallback(address, uint _value, bytes) public {
99         require(!tokenReceived);
100         require(msg.sender == token);
101         require(_value == TOTAL_TOKENS);
102         tokenReceived = true;
103     }
104 
105     /**
106      * @dev withdraw less or equals than available tokens. Throws if there are not enough tokens available.
107      * @param _amount amount of tokens to withdraw.
108      */
109     function withdraw(uint _amount) public onlyOwner {
110         uint availableTokens = ERC223(token).balanceOf(this) - lockedAmount();
111         require(_amount <= availableTokens);
112         ERC223(token).transfer(msg.sender, _amount);
113         Withdraw(msg.sender, _amount);
114     }
115 
116     /**
117      * @dev withdraw all available tokens.
118      */
119     function withdrawAll() public onlyOwner {
120         uint availableTokens = ERC223(token).balanceOf(this) - lockedAmount();
121         ERC223(token).transfer(msg.sender, availableTokens);
122         Withdraw(msg.sender, availableTokens);
123     }
124     
125     /**
126      * @dev Internal function that tells how many tokens are locked at the moment.
127      * @return {
128      *    "lockedTokens": "amount of locked tokens"
129      * }
130      */
131     function lockedAmount() internal view returns (uint) {
132         if (now < FIRST_UNLOCK) {
133             return TOTAL_TOKENS;  
134         }
135 
136         uint quarters = (now - FIRST_UNLOCK) / 0.25 years; // quarters past
137         uint effectiveQuarters = quarters <= 12 ? quarters : 12; // all tokens unlocked in 3 years after FIRST_UNLOCK
138         uint locked = TOTAL_TOKENS * (7500 - effectiveQuarters * 625) / 10000; // unlocks 25% plus 6.25% per quarter
139 
140         return locked;
141     }
142 }