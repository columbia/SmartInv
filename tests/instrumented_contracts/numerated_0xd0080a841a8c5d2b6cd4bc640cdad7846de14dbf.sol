1 /**
2 This is the source of a special time-locked token for the FTV Coin Deluxe.
3 If you hold a balance of the token and you wan to convert it to the FTV token, wait until the lockup period is over
4  and then transfer any amount to yourself.
5  it will convert the token to the real FTV Token at 0xf91254fe7e6e9f5986a0b41da45a8a2549f1871b
6 **/
7 pragma solidity ^0.4.11;
8 
9 contract ERC20Basic {
10     uint256 public totalSupply;
11     function balanceOf(address who) public constant returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a * b;
19         assert(a == 0 || c / a == b);
20         return c;
21     }
22 
23     function div(uint256 a, uint256 b) internal constant returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function add(uint256 a, uint256 b) internal constant returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40 }
41 
42 contract BasicToken is ERC20Basic {
43     using SafeMath for uint256;
44 
45     mapping(address => uint256) balances;
46 
47     /**
48     * @dev transfer token for a specified address
49     * @param _to The address to transfer to.
50     * @param _value The amount to be transferred.
51     */
52     function transfer(address _to, uint256 _value) public returns (bool) {
53         require(_to != address(0));
54 
55         // SafeMath.sub will throw if there is not enough balance.
56         balances[msg.sender] = balances[msg.sender].sub(_value);
57         balances[_to] = balances[_to].add(_value);
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     /**
63     * @dev Gets the balance of the specified address.
64     * @param _owner The address to query the the balance of.
65     * @return An uint256 representing the amount owned by the passed address.
66     */
67     function balanceOf(address _owner) public constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71 }
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public constant returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract FtvTimelockFactory is BasicToken {
80 
81     ERC20 public token;
82     address public tokenAssignmentControl;
83 
84     constructor (ERC20 _token, address _tokenAssignmentControl) {
85         token = _token;
86         tokenAssignmentControl = _tokenAssignmentControl;
87     }
88     string public constant name = "Your Timelocked FTV Deluxe Tokens";
89 
90     string public constant symbol = "TLFTV";
91 
92     uint8 public constant decimals = 18;
93 
94     mapping(address => uint256) public releaseTimes;
95 
96 
97     function assignBalance(address _holder, uint256 _releaseTime, uint256 _amount) public {
98         require(_amount > 0);
99         require(msg.sender == tokenAssignmentControl);
100         //only allowed if not already assigned
101         require(releaseTimes[_holder] == 0);
102         totalSupply += _amount;
103         require(totalSupply <= token.balanceOf(this));
104         releaseTimes[_holder] = _releaseTime;
105         balances[_holder] = balances[_holder].add(_amount);
106         emit Transfer(0x0, _holder, _amount);
107     }
108 
109     function transfer(address _holder, uint256) public returns (bool) {
110         //this transfer function ignores value, it will just trigger release
111         require(_holder == msg.sender, "you can only send to self to unlock the tokens to the real FTV coin");
112         release(msg.sender);
113         return true;
114     }
115 
116     /**
117         * @notice Transfers tokens held by timelock to beneficiary. can be called any time after releaseTime
118         */
119     function release(address _holder) public {
120         require(releaseTimes[_holder] < now, "release time is not met yet");
121         uint256 amount = balanceOf(_holder);
122         totalSupply -= amount;
123         token.transfer(_holder, amount);
124         emit Transfer(_holder, 0x0, amount);
125     }
126 
127 }