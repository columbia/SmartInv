1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4     constructor() public {
5         owner = msg.sender;
6     }
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11     function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 contract BillionRewardsToken is owned {
16     string public constant name = "BillionRewardsToken";
17     string public constant symbol = "BILREW";
18     uint public constant decimals = 8;
19     uint constant ONETOKEN = 10 ** uint(decimals);
20     uint constant MILLION = 1000000; 
21     uint public totalSupply;
22     uint public Devs_Supply;
23     uint public Bounty_Supply;
24     bool public Dev_TokenReleased = false;                     
25     uint public Token_ExchangeValue;                             
26     bool public Accept_Payment;
27     bool public Token_Unlocked;
28     uint public Eth_Collected;
29     uint public Sold_Token;
30     uint public Burnt_Token;
31     address public etherWallet = 0xacEF4B8808a78BF70dbC39B8A2274d8BbfF2dB28;
32     constructor() public {
33         Accept_Payment = true;
34         Token_Unlocked = true;
35         Token_ExchangeValue = 1999995 * ONETOKEN;
36         totalSupply = 550000 * MILLION * ONETOKEN;                        
37         Devs_Supply = 10000 * MILLION * ONETOKEN;                       
38         Bounty_Supply = 40000 * MILLION * ONETOKEN;               
39         totalSupply -= Devs_Supply + Bounty_Supply; 
40         balanceOf[msg.sender] = totalSupply;                            
41     }
42     
43     mapping (address => uint256) public balanceOf;
44     mapping (address => uint256) public selfdrop_cap;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Burn(address indexed from, uint256 value);
48     
49     modifier notLocked{
50         require(Token_Unlocked == true || msg.sender == owner);
51         _;
52     }
53     modifier buyingToken{
54         require(Accept_Payment == true);
55         require(msg.sender != owner);
56         require(selfdrop_cap[msg.sender] + msg.value <= .1 ether);
57         _;
58     }
59     function unlockDevSupply() onlyOwner public {
60         require(now > 1640995200);                              
61         require(Dev_TokenReleased == false);       
62         balanceOf[owner] += Devs_Supply;
63         totalSupply += Devs_Supply;          
64         emit Transfer(0, this, Devs_Supply);
65         emit Transfer(this, owner, Devs_Supply);
66         Devs_Supply = 0;                                         
67         Dev_TokenReleased = true; 
68     }
69     function send_bounty_token(address target, uint256 reward) onlyOwner public {
70         require(Bounty_Supply >= reward);
71         balanceOf[target] += reward;
72         totalSupply += reward;
73         emit Transfer(0, this, reward);
74         emit Transfer(this, target, reward);
75         Bounty_Supply -= reward;
76     }
77     function mint(address target, uint256 token) onlyOwner public {
78         balanceOf[target] += token;
79         totalSupply += token;
80         emit Transfer(0, this, token);
81         emit Transfer(this, target, token);
82     }
83     function burn(uint256 _value) public returns (bool success) {
84         require(balanceOf[msg.sender] >= _value);   
85         balanceOf[msg.sender] -= _value;            
86         totalSupply -= _value;
87         Burnt_Token += _value;
88         emit Burn(msg.sender, _value);
89         return true;
90     }
91     function _transferBilrew(address _from, address _to, uint _value) internal {
92         require(_to != 0x0);
93         require(balanceOf[_from] >= _value);
94         require(balanceOf[_to] + _value > balanceOf[_to]);
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         balanceOf[_from] -= _value;
97         balanceOf[_to] += _value;
98         emit Transfer(_from, _to, _value);
99         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
100     }
101     function transfer(address _to, uint256 _value) notLocked public {
102         _transferBilrew(msg.sender, _to, _value);
103     }
104     function _transfer(address _from, address _to, uint _value) internal {
105         require (_to != 0x0);                               
106         require (balanceOf[_from] >= _value); 
107         require (balanceOf[_to] + _value >= balanceOf[_to]);
108         balanceOf[_from] -= _value;
109         balanceOf[_to] += _value;
110         emit Transfer(_from, _to, _value);
111     }
112     function() payable buyingToken public {
113         require(msg.value > 0 ether);
114         require(msg.value <= .1 ether);
115         uint sendToken = (msg.value / .01 ether) * Token_ExchangeValue;
116         selfdrop_cap[msg.sender] += msg.value;
117         _transfer(owner, msg.sender, sendToken);
118         uint returnBonus = computeReturnBonus(msg.value);
119         if(returnBonus != 0)
120         {
121             msg.sender.transfer(returnBonus);
122         }
123         etherWallet.transfer(this.balance);
124         Eth_Collected += msg.value - returnBonus;
125         Sold_Token += sendToken;          
126     }
127     function computeReturnBonus(uint256 amount) internal constant returns (uint256) {
128         uint256 bonus = 0;
129         if(amount >= .01 ether && amount < .025 ether)
130         {
131             bonus = (amount * 10) / 100;
132         }
133         else if(amount >= .025 ether && amount < .05 ether)
134         {
135             bonus = (amount * 25) / 100;
136         }
137         else  if(amount >= .05 ether && amount < .1 ether)
138         {
139             bonus = (amount * 50) / 100;
140         }
141         else if (amount >= .1 ether)
142         {
143             bonus = (amount * 70) / 100;
144         }
145         return bonus;
146     }
147     function withdrawEther() onlyOwner public{
148         owner.transfer(this.balance);
149     }
150     
151     function setAcceptPayment(bool status) onlyOwner public {
152         Accept_Payment = status;
153     }
154     function setTokenTransfer(bool status) onlyOwner public {
155         Token_Unlocked = status;
156     }
157     
158 }