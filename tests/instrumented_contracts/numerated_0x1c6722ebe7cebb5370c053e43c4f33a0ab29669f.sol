1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address _who) public view returns (uint256);
64   function transfer(address _to, uint256 _value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 is ERC20Basic {
75   function allowance(address _owner, address _spender)
76     public view returns (uint256);
77 
78   function transferFrom(address _from, address _to, uint256 _value)
79     public returns (bool);
80 
81   function approve(address _spender, uint256 _value) public returns (bool);
82   event Approval(
83     address indexed owner,
84     address indexed spender,
85     uint256 value
86   );
87 }
88 
89 
90 
91 contract Vesting {
92 
93     using SafeMath for uint256;
94 
95     ERC20 public mycroToken;
96 
97     event LogFreezedTokensToInvestor(address _investorAddress, uint256 _tokenAmount, uint256 _daysToFreeze);
98     event LogUpdatedTokensToInvestor(address _investorAddress, uint256 _tokenAmount);
99     event LogWithdraw(address _investorAddress, uint256 _tokenAmount);
100 
101     constructor(address _token) public {
102         mycroToken = ERC20(_token);
103     }
104 
105     mapping (address => Investor) public investors;
106 
107     struct Investor {
108         uint256 tokenAmount;
109         uint256 frozenPeriod;
110         bool isInvestor;
111     }
112 
113 
114     /**
115         @param _investorAddress the address of the investor
116         @param _tokenAmount the amount of tokens an investor will receive
117         @param _daysToFreeze the number of the days token would be freezed to withrow, e.c. 3 => 3 days
118      */
119     function freezeTokensToInvestor(address _investorAddress, uint256 _tokenAmount, uint256 _daysToFreeze) public returns (bool) {
120         require(_investorAddress != address(0));
121         require(_tokenAmount != 0);
122         require(!investors[_investorAddress].isInvestor);
123 
124         _daysToFreeze = _daysToFreeze.mul(1 days); // converts days into seconds
125         
126         investors[_investorAddress] = Investor({tokenAmount: _tokenAmount, frozenPeriod: now.add(_daysToFreeze), isInvestor: true});
127         
128         require(mycroToken.transferFrom(msg.sender, address(this), _tokenAmount));
129         emit LogFreezedTokensToInvestor(_investorAddress, _tokenAmount, _daysToFreeze);
130 
131         return true;
132     }
133 
134      function updateTokensToInvestor(address _investorAddress, uint256 _tokenAmount) public returns(bool) {
135         require(investors[_investorAddress].isInvestor);
136         Investor storage currentInvestor = investors[_investorAddress];
137         currentInvestor.tokenAmount = currentInvestor.tokenAmount.add(_tokenAmount);
138 
139         require(mycroToken.transferFrom(msg.sender, address(this), _tokenAmount));
140         emit LogUpdatedTokensToInvestor(_investorAddress, _tokenAmount);
141 
142         return true;
143     }
144 
145     function withdraw(uint256 _tokenAmount) public {
146         address investorAddress = msg.sender;
147         Investor storage currentInvestor = investors[investorAddress];
148         
149         require(currentInvestor.isInvestor);
150         require(now >= currentInvestor.frozenPeriod);
151         require(_tokenAmount <= currentInvestor.tokenAmount);
152 
153         currentInvestor.tokenAmount = currentInvestor.tokenAmount.sub(_tokenAmount);
154         require(mycroToken.transfer(investorAddress, _tokenAmount));
155         emit LogWithdraw(investorAddress, _tokenAmount);
156     }
157 
158 
159 
160 }