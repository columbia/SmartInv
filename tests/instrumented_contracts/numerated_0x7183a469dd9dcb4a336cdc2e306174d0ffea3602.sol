1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5     function owned() public {owner = msg.sender;}
6     modifier onlyOwner { require(msg.sender == owner); _;}
7     function transferOwnership(address newOwner) onlyOwner public {owner = newOwner;}
8 }
9 
10 contract EmtCrowdfund is owned {
11     string public name;
12     string public symbol;
13     uint8 public decimals = 8;
14     uint256 public totalSupply;
15     uint256 public tokenPrice;
16     uint public minBuyAmount = 700000000000000000;       // 0.7 eth
17     uint public maxBuyAmount = 13000000000000000000;     // 13 eth
18     uint public bonusPercent = 20;
19 
20     mapping (address => uint256) public balanceOf;
21     mapping (address => bool) public frozenAccount;
22     mapping (address => uint[]) public paymentHistory;
23     mapping (address => mapping (uint => uint)) public paymentDetail;
24 
25     event Transfer(address indexed from, address indexed to, uint value);
26     event Burn(address indexed from, uint value);
27     event FrozenFunds(address target, bool frozen);
28 
29     function EmtCrowdfund(
30         uint256 initialSupply,
31         uint256 _tokenPrice,
32         string tokenName,
33         string tokenSymbol
34     ) public {
35         tokenPrice = _tokenPrice / 10 ** uint256(decimals);
36         totalSupply = initialSupply * 10 ** uint256(decimals);
37         name = tokenName;
38         symbol = tokenSymbol;
39     }
40 
41     function _transfer(address _from, address _to, uint _value) internal {
42         require (_to != 0x0);
43         require (balanceOf[_from] >= _value);
44         require (balanceOf[_to] + _value >= balanceOf[_to]);
45         require(!frozenAccount[_from]);
46         require(!frozenAccount[_to]);
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50     }
51 
52     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
53     /// @param target Address to be frozen
54     /// @param freeze either to freeze it or not
55     function freezeAccount(address target, bool freeze) onlyOwner public {
56         frozenAccount[target] = freeze;
57         emit FrozenFunds(target, freeze);
58     }
59 
60     /**
61      * @notice Transfer tokens
62      * @param _to The address of the recipient
63      * @param _value the amount to send
64      */
65     function transfer(address _to, uint _value) public {
66         _transfer(msg.sender, _to, _value);
67     }
68 
69     /**
70      * @notice Destroy tokens from other account
71      * @param _from the address of the owner
72      * @param _value the amount of money to burn
73      */
74     function burnFrom(address _from, uint _value) public onlyOwner returns (bool success) {
75         require(balanceOf[_from] >= _value);
76         balanceOf[_from] -= _value;
77         totalSupply -= _value;
78         emit Burn(_from, _value);
79         return true;
80     }
81 
82     /** @notice Allow users to buy tokens for eth
83     *   @param _tokenPrice Price the users can buy
84     */
85     function setPrices(uint256 _tokenPrice) onlyOwner public {
86         tokenPrice = _tokenPrice;
87     }
88 
89     function setBuyLimits(uint _min, uint _max) onlyOwner public {
90         minBuyAmount = _min;
91         maxBuyAmount = _max;
92     }
93 
94     function setBonus(uint _percent) onlyOwner public {
95         bonusPercent = _percent;
96     }
97 
98     function() payable public{
99         buy();
100     }
101 
102     /// @notice Buy tokens from contract by sending ether
103     function buy() payable public {
104 
105         uint now_ = now;
106 
107         if(minBuyAmount > 0){
108             require(msg.value >= minBuyAmount);
109         }
110 
111         if(maxBuyAmount > 0){
112             require(msg.value <= maxBuyAmount);
113 
114             if(paymentHistory[msg.sender].length > 0){
115                 uint lastTotal = 0;
116                 uint thisDay = now_ - 86400;
117 
118                 for (uint i = 0; i < paymentHistory[msg.sender].length; i++) {
119                     if(paymentHistory[msg.sender][i] >= thisDay){
120                         lastTotal += paymentDetail[msg.sender][paymentHistory[msg.sender][i]];
121                     }
122                 }
123 
124                 require(lastTotal <= maxBuyAmount);
125             }
126         }
127 
128         uint amount = msg.value / tokenPrice;
129 
130         if(bonusPercent > 0){
131             uint bonusAmount = amount / 100 * bonusPercent;
132             amount += bonusAmount;
133         }
134 
135         require (totalSupply >= amount);
136         require(!frozenAccount[msg.sender]);
137         totalSupply -= amount;
138         balanceOf[msg.sender] += amount;
139 
140         paymentHistory[msg.sender].push(now_);
141         paymentDetail[msg.sender][now_] = amount;
142 
143         emit Transfer(address(0), msg.sender, amount);
144     }
145 
146     /**
147     * @notice Manual transfer for investors who paid from payment cards
148     * @param _to the address of the receiver
149     * @param _value the amount of tokens
150     */
151     function manualTransfer(address _to, uint _value) public onlyOwner returns (bool success) {
152         require (totalSupply >= _value);
153         require(!frozenAccount[_to]);
154         totalSupply -= _value;
155         balanceOf[_to] += _value;
156         emit Transfer(address(0), _to, _value);
157         return true;
158     }
159 
160     /// @notice Withdraw ether to owner account
161     function withdrawAll() onlyOwner public {
162         owner.transfer(address(this).balance);
163     }
164 }