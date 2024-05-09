1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * See https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address _who) public view returns (uint256);
9   function transfer(address _to, uint256 _value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 
15 
16 
17 
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 
39 /**
40  * @title ValorTimelock
41  * @dev ValorTimelock is a VALOR token holder contract that will allow a
42  * beneficiary to extract the tokens after a given release time and includes an
43  * emergency exit mechanism which can be activated by owner (Smart Valor) to immediately
44  * recover funds towards beneficiary
45  */
46 contract ValorTimelock{
47 
48 
49     event EmergencyRelease(
50         address from,
51         address to,
52         uint256 value
53     );
54 
55     // ERC20 basic token contract being held
56     ERC20 public token;
57 
58     // beneficiary of tokens after they are released
59     address public beneficiary;
60 
61     // timestamp when token release is enabled
62     uint256 public releaseTime;
63 
64     //admin address
65     address public owner;
66 
67     /**
68      * @dev the duration arg is the number of seconds the fund is locked since creation
69      * @param _token the token managed by this contract
70      * @param _beneficiary the address which will receive the locked funds at due time
71      * @param _admin the account which can activate the emergency release
72      * @param _duration locking period in secs
73      */
74     constructor(ERC20 _token, address _beneficiary, address _admin, uint256 _duration )
75     public {
76         token = _token;
77         beneficiary = _beneficiary;
78         releaseTime = block.timestamp + _duration;//watchout, no safe math
79         owner = _admin;
80     }
81 
82 
83     /**
84     * @dev it releases all tokens held by this contract to beneficiary.
85     */
86     function release() external {
87         uint256 balance = token.balanceOf(address(this));
88         partialRelease(balance);
89     }
90 
91     /**
92     * @dev it releases some tokens held by this contract to beneficiary.
93     * @param _amount the number of tokens to be sent to beneficiary
94     */
95     function partialRelease(uint256 _amount) public {
96 
97         //check time is done
98         //according to 15sec rule, this contract can tolerate a drift of 15sec
99         //so that the use of block.timestamp can be considered safe
100         require(block.timestamp >= releaseTime);
101 
102         uint256 balance = token.balanceOf(address(this));
103         require(balance >= _amount);
104         require(_amount > 0);
105 
106         require(token.transfer(beneficiary, _amount));
107     }
108 
109 
110     /**
111     * @dev it releases all tokens held by this contract to beneficiary. This
112     * can be used by owner only and it works anytime
113     */
114     function emergencyRelease() external{
115         require(msg.sender == owner);
116         uint256 amount = token.balanceOf(address(this));
117         require(amount > 0);
118         require(token.transfer(beneficiary, amount));
119         emit EmergencyRelease(msg.sender, beneficiary, amount);
120     }
121 
122 }