1 pragma solidity ^0.4.16;
2 
3 /// @title SafeMath
4 /// @dev Math operations with safety checks that throw on error
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract IOwned {
30     function owner() public constant returns (address) { owner; }
31 }
32 
33 contract Owned is IOwned {
34     address public owner;
35 
36     function Owned() {
37         owner = msg.sender;
38     }
39     modifier onlyOwner {
40         assert(msg.sender == owner);
41         _;
42     }
43 }
44 
45 /// @title B2BK (B2BX) contract interface
46 contract IB2BKToken {
47     function totalSupply() public constant returns (uint256) { totalSupply; }
48     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
49 
50     function transfer(address _to, uint256 _value) public returns (bool success);
51 
52     event Buy(address indexed _from, address indexed _to, uint256 _rate, uint256 _value);
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event FundTransfer(address indexed backer, uint amount, bool isContribution);
55     event UpdateRate(uint256 _rate);
56     event Finalize(address indexed _from, uint256 _value);
57     event Burn(address indexed _from, uint256 _value);
58 }
59 
60 /// @title B2BK (B2BX) contract - integration code for KICKICO.
61 contract B2BKToken is IB2BKToken, Owned {
62     using SafeMath for uint256;
63  
64     string public constant name = "B2BX KICKICO";
65     string public constant symbol = "B2BK";
66     uint8 public constant decimals = 18;
67 
68     uint256 public totalSupply = 0;
69     // Total number of tokens available for BUY.
70     uint256 public constant totalMaxBuy = 5000000 ether;
71 
72     // The total number of ETH.
73     uint256 public totalETH = 0;
74 
75     address public wallet;
76     uint256 public rate = 0;
77 
78     // The flag indicates is in transfers state.
79     bool public transfers = false;
80     // The flag indicates is in BUY state.
81     bool public finalized = false;
82 
83     mapping (address => uint256) public balanceOf;
84 
85     /// @notice B2BK Project - Initializing.
86     /// @dev Constructor.
87     function B2BKToken(address _wallet, uint256 _rate) validAddress(_wallet) {
88         wallet = _wallet;
89         rate = _rate;
90     }
91 
92     modifier validAddress(address _address) {
93         assert(_address != 0x0);
94         _;
95     }
96 
97     modifier transfersAllowed {
98         require(transfers);
99         _;
100     }
101 
102     modifier isFinalized {
103         require(finalized);
104         _;
105     }
106 
107     modifier isNotFinalized {
108         require(!finalized);
109         _;
110     }
111 
112     /// @notice This function is disabled. Addresses having B2BK tokens automatically receive an equal number of B2BX tokens.
113     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
114         return false;
115     }
116 
117     /// @notice This function if anybody sends ETH directly to this contract, consider he is getting B2BK.
118     function () payable {
119         buy(msg.sender);
120     }
121 
122     /// @notice This function sends B2BK tokens to the specified address when sending ETH
123     /// @param _to Address of the recipient
124     function buy(address _to) public validAddress(_to) isNotFinalized payable {
125         uint256 _amount = msg.value;
126 
127         assert(_amount > 0);
128 
129         uint256 _tokens = _amount.mul(rate);
130 
131         assert(totalSupply.add(_tokens) <= totalMaxBuy);
132 
133         totalSupply = totalSupply.add(_tokens);
134         totalETH = totalETH.add(_amount);
135 
136         balanceOf[_to] = balanceOf[_to].add(_tokens);
137 
138         wallet.transfer(_amount);
139 
140         Buy(msg.sender, _to, rate, _tokens);
141         Transfer(this, _to, _tokens);
142         FundTransfer(msg.sender, _amount, true);
143     }
144 
145     /// @notice This function updates rates.
146     function updateRate(uint256 _rate) external isNotFinalized onlyOwner {
147         rate = _rate;
148 
149         UpdateRate(rate);
150     }
151 
152     /// @notice This function completes BUY tokens.
153     function finalize() external isNotFinalized onlyOwner {
154         finalized = true;
155 
156         Finalize(msg.sender, totalSupply);
157     }
158 
159     /// @notice This function burns all B2BK tokens on the address that caused this function.
160     function burn() external isFinalized {
161         uint256 _balance = balanceOf[msg.sender];
162 
163         assert(_balance > 0);
164 
165         totalSupply = totalSupply.sub(_balance);
166         balanceOf[msg.sender] = 0;
167 
168         Burn(msg.sender, _balance);
169     }
170 }