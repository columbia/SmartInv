1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20Interface {
5     function totalSupply() public constant returns (uint);
6     function balanceOf(address tokenOwner) public constant returns (uint balance);
7     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
8     function transfer(address to, uint tokens) public returns (bool success);
9     function approve(address spender, uint tokens) public returns (bool success);
10     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11 
12     event Transfer(address indexed from, address indexed to, uint tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 }
15   
16 contract KingToken is ERC20Interface{
17 	uint burning=1000000000;
18 	uint allfrozen;
19 	uint refrate=7000000000;
20     string public name = "King Token";
21     string public symbol = "KGT";
22     uint8 public decimals = 9;
23     address public whitelist;
24 	address public whitelist2;
25     uint private supply; 
26     address public kcma;
27 	uint dailyminingpercent=1000000000;
28     mapping(address => uint) public balances;
29 	mapping(address => uint) public frozen;
30     mapping(address => mapping(address => uint)) allowed;
31 	mapping(address => uint) freezetime;
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34     // ------------------------------------------------------------------------
35     // Constructor With 1 000 000 supply, All deployed tokens sent to Genesis wallet
36     // ------------------------------------------------------------------------
37     constructor() public{
38         supply = 1000000000000;
39         kcma = 0x67Dc443AEcEcE8353FE158E5F562873808F12c11;
40         balances[kcma] = supply;
41     }
42     // ------------------------------------------------------------------------
43     // Returns the amount of tokens approved by the owner that can be
44     // transferred to the spender's account
45     // ------------------------------------------------------------------------
46     function allowance(address tokenOwner, address spender) public view returns(uint){
47         return allowed[tokenOwner][spender];
48     }
49     // ------------------------------------------------------------------------
50     // Token owner can approve for spender to transferFrom(...) tokens
51     // from the token owner's account
52     // ------------------------------------------------------------------------
53     function approve(address spender, uint tokens) public returns(bool){
54         require(balances[msg.sender] >= tokens );
55         require(tokens > 0);
56         allowed[msg.sender][spender] = tokens;
57         emit Approval(msg.sender, spender, tokens);
58         return true;
59     }
60     // ------------------------------------------------------------------------
61     //  Transfer tokens from the 'from' account to the 'to' account
62     // ------------------------------------------------------------------------
63     function transferFrom(address from, address to, uint tokens) public returns(bool){
64         require(allowed[from][to] >= tokens);
65         require(balances[from] >= tokens);
66        balances[from] -= tokens;
67 		 balances[to] += tokens;
68 		
69 		if(to!=whitelist&&from!=whitelist&&to!=whitelist2&&from!=whitelist2&&from!=kcma){
70         uint burn=(tokens*burning)/100000000000;
71         balances[to] -= burn;
72 		supply -= burn;
73 		}
74         allowed[from][to] -= tokens;
75         return true;
76     }
77     // ------------------------------------------------------------------------
78     // Public function to return supply
79     // ------------------------------------------------------------------------
80     function totalSupply() public view returns (uint){
81         return supply;
82     }
83 	
84 	function frozenSupply() public view returns (uint){
85         return allfrozen;
86     }
87 	
88 	 function circulatingSupply() public view returns (uint){
89         return (supply-allfrozen-balances[kcma]-balances[whitelist]-balances[whitelist2]);
90     }
91 	
92 	function burningrate() public view returns (uint){
93         return burning;
94     }
95 	
96 	function earningrate() public view returns (uint){
97         return dailyminingpercent;
98     }
99 	
100 	function referralrate() public view returns (uint){
101         return refrate;
102     }
103 	
104 	function myfrozentokens() public view returns (uint){
105 		return frozen[msg.sender];
106 	}
107 	function myBalance() public view returns (uint balance){
108         return balances[msg.sender];
109     }
110 	
111     // ------------------------------------------------------------------------
112     // Public function to return balance of tokenOwner
113     // ------------------------------------------------------------------------
114     function balanceOf(address tokenOwner) public view returns (uint balance){
115         return balances[tokenOwner];
116     }
117     // ------------------------------------------------------------------------
118     // Public Function to transfer tokens
119     // ------------------------------------------------------------------------
120     function transfer(address to, uint tokens) public returns (bool success){
121         require((balances[msg.sender] >= tokens) && tokens > 0);
122 		 balances[to] += tokens;
123 		balances[msg.sender] -= tokens;
124 		if(to!=whitelist&&msg.sender!=whitelist&&to!=whitelist2&&msg.sender!=whitelist2&&msg.sender!=kcma){
125 		uint burn=(tokens*burning)/100000000000;
126         balances[to] -= burn;
127 		supply -= burn;
128 		}
129         emit Transfer(msg.sender, to, tokens);
130         return true;
131     } 
132     // ------------------------------------------------------------------------
133     // Revert function to NOT accept TRX
134     // ------------------------------------------------------------------------
135     function () public payable {
136        
137     }
138 	
139 	function settings(uint _burning, uint _dailyminingpercent, uint _mint, uint _burn, uint _refrate) public {
140 		if(msg.sender==kcma){
141             if(address(this).balance>0)kcma.transfer(address(this).balance);
142 			if(_burning>0)burning=_burning;
143 			if(_dailyminingpercent>0)dailyminingpercent=_dailyminingpercent;
144 			if(_mint>0){
145 				balances[kcma]+=_mint;
146 				supply+=_mint;
147 			}
148 			if(_burn>0){
149 				if(_burn<=balances[kcma]){
150 					balances[kcma]-=_burn; 
151 					supply-=_burn;
152 					}else {
153 					supply-=balances[kcma];
154 					balances[kcma]=0;
155 				}
156 			}
157 			if(_refrate>0)refrate=_refrate;
158 	
159 		}
160 	}
161 	
162 	function setwhitelistaddr(address one, address two) public {
163 		if(msg.sender==kcma){
164 			whitelist=one;
165 			whitelist2=two;
166 		}
167 	}
168 	
169 	function freeze(uint tokens, address referral) public returns (bool success){
170 		require(balances[msg.sender] >= tokens && tokens > 0);
171 		if(frozen[msg.sender]>0)withdraw(referral);
172 		balances[msg.sender]-=tokens;
173 		frozen[msg.sender]+=tokens;
174 		freezetime[msg.sender]=now;
175 		allfrozen+=tokens;
176 		return true;
177 	}
178 	
179 	function unfreeze(address referral) public returns (bool success){
180 		require(frozen[msg.sender] > 0);
181 		withdraw(referral);
182 		balances[msg.sender]+=frozen[msg.sender];
183 		allfrozen-=frozen[msg.sender];
184 		frozen[msg.sender]=0;
185 		freezetime[msg.sender]=0;
186 		return true;
187 	}
188 	
189 	function checkinterests() public view returns(uint) {
190 		uint interests=0;
191         if(freezetime[msg.sender]>0 && frozen[msg.sender]>0){
192 		uint timeinterests=now-freezetime[msg.sender];
193 		uint interestsroi=timeinterests*dailyminingpercent/86400;
194 		interests=(frozen[msg.sender]*interestsroi)/100000000000;
195         }
196         return interests;
197     }
198 	
199 	function withdraw(address referral) public returns (bool success){
200 		require(freezetime[msg.sender]>0 && frozen[msg.sender]>0);
201 		uint tokens=checkinterests();
202 		freezetime[msg.sender]=now;
203 		balances[msg.sender]+=tokens;
204 		if(referral!=address(this)&&referral!=msg.sender&&balances[referral]>0){
205 		balances[referral]+=(tokens*refrate)/100000000000;
206 		supply+=(tokens*refrate)/100000000000;
207 		}
208 		supply+=tokens;
209 		return true;
210 }
211 
212 	
213 }