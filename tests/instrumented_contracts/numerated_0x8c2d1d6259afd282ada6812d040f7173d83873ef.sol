1 /*
2 This Contract is free software: you can redistribute it and/or
3 modify it under the terms of the GNU lesser General Public License as published
4 by the Free Software Foundation, either version 3 of the License, or
5 (at your option) any later version.
6 This Contract is distributed WITHOUT ANY WARRANTY; without even the implied warranty of
7 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
8 GNU lesser General Public License for more details.
9 You should have received a copy of the GNU lesser General Public License
10 <http://www.gnu.org/licenses/>.
11 */
12 
13 pragma solidity ^0.4.18;
14 
15 contract InterfaceERC20Token
16 {
17     function balanceOf (address tokenOwner) public constant returns (uint balance);
18     function transfer (address to, uint tokens) public returns (bool success);
19     function allowance (address _owner, address _spender) public constant returns (uint remaining);
20     function transferFrom (address _from, address _to, uint _value) public returns (bool success);
21 }
22 
23 contract LittleStoreERC20Token
24 {
25 
26     mapping (address => bool) public agents;
27     address public addressERC20Token;
28     InterfaceERC20Token internal ERC20Token;
29 
30     bool public sale;
31     uint public price;
32     uint public bonusLine;
33     uint public bonusSize;
34 
35     event ChangePermission (address indexed _called, address indexed _to, bool _permission);
36     event ChangeSaleSettings (address indexed _called, address indexed _token, uint _price, uint _bonusLine, uint _bonusSize);
37     event Buy (address indexed _called, address indexed _token, uint _count, uint _bonusCount, uint _value);
38     event Donate (address indexed _from, uint _value);
39 
40     function LittleStoreERC20Token () public
41     {
42         agents[msg.sender] = true;
43         sale = true;
44     }
45 
46     modifier onlyAdministrators ()
47     {
48         require (agents[msg.sender]);
49         _;
50     }
51 
52     function changePermission (address _agent, bool _permission) public onlyAdministrators ()
53     {
54         if (msg.sender != _agent)
55         {
56             agents[_agent] = _permission;
57             ChangePermission (msg.sender, _agent, _permission);
58         }
59     }
60 
61     function changeSaleSettings (address _addressERC20Token, uint _priceGwei, uint _bonusLine, uint _bonusSize) public onlyAdministrators ()
62     {
63         addressERC20Token = _addressERC20Token;
64         ERC20Token = InterfaceERC20Token (_addressERC20Token);
65         price = _priceGwei * 1000000000; //calculation of gwei in wei
66         bonusLine = _bonusLine;
67         bonusSize = _bonusSize;
68         ChangeSaleSettings (msg.sender, _addressERC20Token, _priceGwei * 1000000000, _bonusLine, _bonusSize);
69     }
70 
71     function saleValve (bool _sale) public onlyAdministrators ()
72     {
73         sale = _sale;
74     }
75 
76     function allowanceTransfer () public onlyAdministrators ()
77     {
78         ERC20Token.transferFrom (msg.sender, this, ERC20Token.allowance (msg.sender, this));
79     }
80 
81     function withdrawalToken (address _to) public onlyAdministrators ()
82     {
83         ERC20Token.transfer (_to, ERC20Token.balanceOf (this));
84     }
85 
86     function withdrawal (address _to) public onlyAdministrators ()
87     {
88         _to.transfer (this.balance);
89     }
90     
91     function destroy (address _to) public onlyAdministrators ()
92     {
93         withdrawalToken (_to);
94         selfdestruct (_to);
95     }
96 
97     function totalSale () public constant returns (uint)
98     {
99         return ERC20Token.balanceOf (this); 
100     }
101 
102     function () payable
103     {
104        Donate (msg.sender, msg.value);
105     }
106 
107     function buy () payable
108     {
109         uint thisBalance = ERC20Token.balanceOf (this);
110         require (thisBalance > 0 && sale);
111         
112         uint countToken;
113         uint countBonusToken;
114         
115         countToken = msg.value / price;
116         require (countToken > 0);
117         
118         if (thisBalance > countToken)
119         {
120             thisBalance -= countToken;
121             countBonusToken = (countToken / bonusLine) * bonusSize;
122             
123             if (countBonusToken > 0 && thisBalance <= countBonusToken)
124             {
125                 countBonusToken = thisBalance;
126             }
127         }
128         else
129         {
130             countToken = thisBalance;
131         }
132             
133         require (ERC20Token.transfer (msg.sender, countToken + countBonusToken));
134         msg.sender.transfer (msg.value - (countToken * price));
135         Buy (msg.sender, addressERC20Token, countToken, countBonusToken, msg.value);
136     }
137 }