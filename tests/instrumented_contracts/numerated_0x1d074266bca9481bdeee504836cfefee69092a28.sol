1 pragma solidity ^0.4.21;
2 pragma experimental "v0.5.0";
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract SmartInvestmentFundToken {
35     using SafeMath for uint256;
36 
37     /* Map all our our balances for issued tokens */
38     mapping (address => uint256) balances;
39 
40     /* Map between users and their approval addresses and amounts */
41     mapping(address => mapping (address => uint256)) allowed;
42 
43     /* The name of the contract */
44     string public name = "Smart Investment Fund Token v2";
45 
46     /* The symbol for the contract */
47     string public symbol = "XSFT";
48 
49     /* How many DPs are in use in this contract */
50     uint8 public decimals = 6;
51 
52     /* Defines the current supply of the token in its own units */
53     uint256 public totalSupply = 722935000000;
54 
55     /* Our transfer event to fire whenever we shift XSFT around */
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     
58     /* Our approval event when one user approves another to control */
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     /* Create a new instance of this fund with links to other contracts that are required. */
62     function SmartInvestmentFundToken (address _tokenConvertor) public {
63 		// Give the 0x00 address the fulll supply and allow the token convertor to transfer it
64         balances[0] = totalSupply;
65         allowed[0][_tokenConvertor] = totalSupply;
66         emit Approval(0, _tokenConvertor, totalSupply);
67     }
68 
69     modifier onlyPayloadSize(uint numwords) {
70         assert(msg.data.length == numwords * 32 + 4);
71         _;
72     } 
73     
74     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
75     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3) returns (bool) {
76         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
77             balances[_from] = balances[_from].sub(_amount);
78             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
79             balances[_to] = balances[_to].add(_amount);
80             emit Transfer(_from, _to, _amount);
81             return true;
82         }
83         return false;
84     }
85 
86     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
87     function approve(address _spender, uint256 _amount) public onlyPayloadSize(2) returns (bool success) {
88         allowed[msg.sender][_spender] = _amount;
89         emit Approval(msg.sender, _spender, _amount);
90         return true;
91     }
92 
93     /* Gets the current allowance that has been approved for the specified spender of the owner address */
94     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     /* Gets the balance of a specified account */
99     function balanceOf(address _owner) public constant returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     /* Transfer the balance from owner's account to another account */
104     function transfer(address _to, uint256 _amount) public onlyPayloadSize(2) returns (bool) {
105         /* Check if sender has balance and for overflows */
106         if (balances[msg.sender] < _amount || balances[_to].add(_amount) < balances[_to])
107             return false;
108 
109         /* Add and subtract new balances */
110         balances[msg.sender] = balances[msg.sender].sub(_amount);
111         balances[_to] = balances[_to].add(_amount);
112 
113         /* Fire notification event */
114         emit Transfer(msg.sender, _to, _amount);
115         return true;
116     }
117 }