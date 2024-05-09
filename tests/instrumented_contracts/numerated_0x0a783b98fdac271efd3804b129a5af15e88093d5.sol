1 /*
2 The goico_kasko2go Contract is free software: you can redistribute it and/or
3 modify it under the terms of the GNU lesser General Public License as published
4 by the Free Software Foundation, either version 3 of the License, or
5 (at your option) any later version.
6 
7 The goico_kasko2go Contract is distributed in the hope that it will be useful,
8 but WITHOUT ANY WARRANTY; without even the implied warranty of
9 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
10 GNU lesser General Public License for more details.
11 
12 You should have received a copy of the GNU lesser General Public License
13 along with the goico_kasko2go Contract. If not, see <http://www.gnu.org/licenses/>.
14 
15 @author Ilya Svirin <i.svirin@prover.io>
16 */
17 
18 pragma solidity ^0.4.19;
19 
20 contract owned {
21 
22     address public owner;
23     address public candidate;
24 
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(owner == msg.sender);
31         _;
32     }
33 
34     function changeOwner(address _owner) onlyOwner public {
35         candidate = _owner;
36     }
37 
38     function confirmOwner() public {
39         require(candidate == msg.sender);
40         owner = candidate;
41         delete candidate;
42     }
43 }
44 
45 contract BaseERC20 {
46     function balanceOf(address who) public constant returns (uint);
47     function transfer(address to, uint value) public;
48 }
49 
50 contract Token is owned {
51 
52     string  public standard = 'Token 0.1';
53     string  public name     = '_K2G';
54     string  public symbol   = '_K2G';
55     uint8   public decimals = 8;
56 
57     uint                      public totalSupply;
58     mapping (address => uint) public balanceOf;
59 
60     uint                      public numberOfInvestors;
61     mapping (address => bool) public investors;
62     mapping (address => uint) public depositedCPT;
63     mapping (address => uint) public depositedWei;
64 
65     event Transfer(address indexed from, address indexed to, uint value);
66 
67     enum State {
68         NotStarted,
69         Started,
70         Finished
71     }
72 
73     address public backend;
74     address public cryptaurToken = 0x88d50B466BE55222019D71F9E8fAe17f5f45FCA1;
75     uint    public tokenPriceInWei;
76     State   public state;
77 
78     event Mint(address indexed minter, uint tokens, bytes32 originalTxHash);
79 
80     constructor() public owned() {}
81 
82     function startCrowdsale() public onlyOwner {
83         require(state==State.NotStarted);
84         state=State.Started;
85     }
86 
87     function finishCrowdsale() public onlyOwner {
88         require(state==State.Started);
89         state=State.Finished;
90     }
91 
92     function changeBackend(address _backend) public onlyOwner {
93         backend = _backend;
94     }
95 
96     function setTokenPriceInWei(uint _tokenPriceInWei) public {
97         require(msg.sender == owner || msg.sender == backend);
98         tokenPriceInWei = _tokenPriceInWei;
99     }
100 
101     function () payable public {
102         require(state==State.Started);
103         uint tokens = msg.value / tokenPriceInWei * 100000000;
104         require(balanceOf[msg.sender] + tokens > balanceOf[msg.sender]); // overflow
105         require(tokens > 0);
106         depositedWei[msg.sender]+=msg.value;
107         balanceOf[msg.sender] += tokens;
108         if (!investors[msg.sender]) {
109             investors[msg.sender] = true;
110             ++numberOfInvestors;
111         }
112         emit Transfer(this, msg.sender, tokens);
113         totalSupply += tokens;
114     }
115 
116     function depositCPT(address _who, uint _valueCPT, bytes32 _originalTxHash) public {
117         require(msg.sender == backend || msg.sender == owner);
118         require(state==State.Started);
119         // decimals in K2G and PROOF are the same and equal 8
120         uint tokens = (_valueCPT * 10000) / 238894; // 1 K2G = 23,8894 CPT
121         depositedCPT[_who]+=_valueCPT;
122         require(balanceOf[_who] + tokens > balanceOf[_who]); // overflow
123         require(tokens > 0);
124         balanceOf[_who] += tokens;
125         totalSupply += tokens;
126         if (!investors[_who]) {
127             investors[_who] = true;
128             ++numberOfInvestors;
129         }
130         emit Transfer(this, _who, tokens);
131         emit Mint(_who, tokens, _originalTxHash);
132     }
133 
134     function withdraw() public onlyOwner {
135         require(msg.sender.call.gas(3000000).value(address(this).balance)());
136         uint balance = BaseERC20(cryptaurToken).balanceOf(this);
137         BaseERC20(cryptaurToken).transfer(msg.sender, balance);
138     }
139 
140     // untistupids function
141     function transferAnyTokens(address _erc20, address _receiver, uint _amount) public onlyOwner {
142         BaseERC20(_erc20).transfer(_receiver, _amount);
143     }
144 }