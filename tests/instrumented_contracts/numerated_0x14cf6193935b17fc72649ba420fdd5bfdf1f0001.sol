1 /*
2 This file is part of the Open Longevity Contract.
3 
4 The Open Longevity Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The Open Longevity Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the Open Longevity Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@nordavind.ru>
18 */
19 
20 
21 pragma solidity ^0.4.10;
22 
23 contract owned {
24 
25     address public owner;
26     address public newOwner;
27 
28     function owned() payable {
29         owner = msg.sender;
30     }
31     
32     modifier onlyOwner {
33         require(owner == msg.sender);
34         _;
35     }
36 
37     function changeOwner(address _owner) onlyOwner public {
38         require(_owner != 0);
39         newOwner = _owner;
40     }
41     
42     function confirmOwner() public {
43         require(newOwner == msg.sender);
44         owner = newOwner;
45         delete newOwner;
46     }
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 {
54     uint public totalSupply;
55     function balanceOf(address who) constant returns (uint);
56     function transfer(address to, uint value);
57     function allowance(address owner, address spender) constant returns (uint);
58     function transferFrom(address from, address to, uint value);
59     function approve(address spender, uint value);
60     event Approval(address indexed owner, address indexed spender, uint value);
61     event Transfer(address indexed from, address indexed to, uint value);
62 }
63 
64 /**
65  * @title Know your customer contract
66  */
67 contract KYC is owned {
68 
69     mapping (address => bool) public known;
70     address                   public confirmer;
71 
72     function setConfirmer(address _confirmer) public onlyOwner {
73         confirmer = _confirmer;
74     }
75 
76     function setToKnown(address _who) public {
77         require(msg.sender == confirmer || msg.sender == owner);
78         known[_who] = true;
79     }
80 }
81 
82 contract Presale is KYC, ERC20 {
83 
84     uint    public etherPrice;
85     address public presaleOwner;
86     uint    public totalLimitUSD;
87     uint    public collectedUSD;
88 
89     enum State { Disabled, Presale, Finished }
90     event NewState(State state);
91     State   public state;
92     uint    public presaleStartTime;
93     uint    public ppFinishTime;
94     uint    public presaleFinishTime;
95 
96     struct Investor {
97         uint256 amountTokens;
98         uint    amountWei;
99     }
100     mapping (address => Investor) public investors;
101     mapping (uint => address)     public investorsIter;
102     uint                          public numberOfInvestors;
103     
104     function () payable public {
105         require(state == State.Presale);
106         require(now < presaleFinishTime);
107         require(now > ppFinishTime || known[msg.sender]);
108 
109         uint valueWei = msg.value;
110         uint valueUSD = valueWei * etherPrice / 1000000000000000000;
111         if (collectedUSD + valueUSD > totalLimitUSD) { // don't need so much ether
112             valueUSD = totalLimitUSD - collectedUSD;
113             valueWei = valueUSD * 1000000000000000000 / etherPrice;
114             require(msg.sender.call.gas(3000000).value(msg.value - valueWei)());
115             collectedUSD = totalLimitUSD; // to be sure!
116         } else {
117             collectedUSD += valueUSD;
118         }
119 
120         uint256 tokensPer10USD = 100;
121         if (now <= ppFinishTime) {
122             if (valueUSD >= 100000) {
123                 tokensPer10USD = 200;
124             } else {
125                 tokensPer10USD = 175;
126             }
127         } else {
128             if (valueUSD >= 100000) {
129                 tokensPer10USD = 150;
130             } else {
131                 tokensPer10USD = 130;
132             }
133         }
134 
135         uint256 tokens = tokensPer10USD * valueUSD / 10;
136         require(tokens > 0);
137 
138         Investor storage inv = investors[msg.sender];
139         if (inv.amountWei == 0) { // new investor
140             investorsIter[numberOfInvestors++] = msg.sender;
141         }
142         require(inv.amountTokens + tokens > inv.amountTokens); // overflow
143         inv.amountTokens += tokens;
144         inv.amountWei += valueWei;
145         totalSupply += tokens;
146         Transfer(this, msg.sender, tokens);
147     }
148     
149     function startPresale(address _presaleOwner, uint _etherPrice) public onlyOwner {
150         require(state == State.Disabled);
151         presaleStartTime = now;
152         presaleOwner = _presaleOwner;
153         etherPrice = _etherPrice;
154         ppFinishTime = now + 3 days;
155         presaleFinishTime = ppFinishTime + 60 days;
156         state = State.Presale;
157         totalLimitUSD = 500000;
158         NewState(state);
159     }
160     
161     function timeToFinishPresale() public constant returns(uint t) {
162         require(state == State.Presale);
163         if (now > presaleFinishTime) {
164             t = 0;
165         } else {
166             t = presaleFinishTime - now;
167         }
168     }
169     
170     function finishPresale() public onlyOwner {
171         require(state == State.Presale);
172         require(now >= presaleFinishTime || collectedUSD == totalLimitUSD);
173         require(presaleOwner.call.gas(3000000).value(this.balance)());
174         state = State.Finished;
175         NewState(state);
176     }
177     
178     function withdraw() public onlyOwner {
179         require(presaleOwner.call.gas(3000000).value(this.balance)());
180     }
181 }
182 
183 contract PresaleToken is Presale {
184     
185     string  public standard    = 'Token 0.1';
186     string  public name        = 'OpenLongevity';
187     string  public symbol      = "YEAR";
188     uint8   public decimals    = 0;
189 
190     function PresaleToken() payable public Presale() {}
191 
192     function balanceOf(address _who) constant public returns (uint) {
193         return investors[_who].amountTokens;
194     }
195 
196     function transfer(address, uint256) public {revert();}
197     function transferFrom(address, address, uint256) public {revert();}
198     function approve(address, uint256) public {revert();}
199     function allowance(address, address) public constant returns (uint256) {revert();}
200 }
201 
202 contract OpenLongevityPresale is PresaleToken {
203 
204     function OpenLongevityPresale() payable public PresaleToken() {}
205 
206     function killMe() public onlyOwner {
207         selfdestruct(owner);
208     }
209 }