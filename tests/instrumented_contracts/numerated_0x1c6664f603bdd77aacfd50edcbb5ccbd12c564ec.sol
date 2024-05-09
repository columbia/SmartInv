1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10   address public owner;
11   event OwnershipTransferred (address indexed _from, address indexed _to);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public{
18     owner = msg.sender;
19     OwnershipTransferred(address(0), owner);
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     owner = newOwner;
37     OwnershipTransferred(owner,newOwner);
38   }
39 }
40 
41 /**
42  * @title Token
43  * @dev API interface for interacting with the Token contract 
44  */
45 interface Token {
46   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
47   function balanceOf(address _owner) constant external returns (uint256 balance);
48   function transfer(address to, uint256 value) external returns (bool);
49   function approve(address spender, uint256 value) external returns (bool); 
50 }
51 
52 /**
53  * @title AirDropRedeemAFTK Ver 1.0
54  * @dev This contract can be used for Airdrop or token redumption for AFTK Token
55  *
56  */
57 contract AirDropRedeemAFTK2 is Ownable {
58 
59   Token token;
60   mapping(address => uint256) public redeemBalanceOf; 
61   event BalanceSet(address indexed beneficiary, uint256 value);
62   event Redeemed(address indexed beneficiary, uint256 value);
63   event BalanceCleared(address indexed beneficiary, uint256 value);
64   event TokenSendStart(address indexed beneficiary, uint256 value);
65   event TransferredToken(address indexed to, uint256 value);
66   event FailedTransfer(address indexed to, uint256 value);
67 
68   function AirDropRedeemAFTK2() public {
69       address _tokenAddr = 0x7fa2f70bd4c4120fdd539ebd55c04118ba336b9e;
70       token = Token(_tokenAddr);
71   }
72 
73   /**
74   * @dev admin can allocate tokens for redemption
75   * @param dests -> array of addresses to which tokens will be allocated
76   * @param values -> array of number of tokens to be allocated for the index above
77   */
78   function setBalances(address[] dests, uint256[] values) onlyOwner public {
79     uint256 i = 0; 
80     while (i < dests.length){
81         if(dests[i] != address(0)) 
82         {
83             uint256 toSend = values[i] * 10**18;
84             redeemBalanceOf[dests[i]] += toSend;
85             BalanceSet(dests[i],values[i]);
86         }
87         i++;
88     } 
89   }
90   
91  
92  /**
93   * @dev Send approved tokens to one address
94   * @param dests -> address where you want to send tokens
95   * @param quantity -> number of tokens to send
96   */
97  function sendTokensToOne(address dests, uint256 quantity)  public payable onlyOwner returns (uint) {
98     
99 	TokenSendStart(dests,quantity * 10**18);
100 	token.approve(dests, quantity * 10**18);
101 	require(token.transferFrom(owner , dests ,quantity * 10**18));
102     return token.balanceOf(dests);
103 	
104   }
105   
106  /**
107   * @dev Send approved tokens to two addresses
108   * @param dests1 -> address where you want to send tokens
109   * @param dests2 -> address where you want to send tokens
110   * @param quantity -> number of tokens to send
111   */
112  function sendTokensToTwo(address dests1, address dests2, uint256 quantity)  public payable onlyOwner returns (uint) {
113     
114 	TokenSendStart(dests1,quantity * 10**18);
115 	token.approve(dests1, quantity * 10**18);
116 	require(token.transferFrom(owner , dests1 ,quantity * 10**18));
117 	
118 	TokenSendStart(dests2,quantity * 10**18);
119 	token.approve(dests2, quantity * 10**18);
120 	require(token.transferFrom(owner , dests2 ,quantity * 10**18));
121     
122 	
123 	return token.balanceOf(dests2);
124 	
125   }
126   
127  /**
128   * @dev Send approved tokens to five addresses
129   * @param dests1 -> address where you want to send tokens
130   * @param dests2 -> address where you want to send tokens
131   * @param dests3 -> address where you want to send tokens
132   * @param dests4 -> address where you want to send tokens
133   * @param dests5 -> address where you want to send tokens
134   * @param quantity -> number of tokens to send
135   */
136  function sendTokensToFive(address dests1, address dests2, address dests3, address dests4, address dests5, uint256 quantity)  public payable onlyOwner returns (uint) {
137     
138 	TokenSendStart(dests1,quantity * 10**18);
139 	token.approve(dests1, quantity * 10**18);
140 	require(token.transferFrom(owner , dests1 ,quantity * 10**18));
141 	
142 	TokenSendStart(dests2,quantity * 10**18);
143 	token.approve(dests2, quantity * 10**18);
144 	require(token.transferFrom(owner , dests2 ,quantity * 10**18));
145 	
146 	
147 	TokenSendStart(dests3,quantity * 10**18);
148 	token.approve(dests3, quantity * 10**18);
149 	require(token.transferFrom(owner , dests3 ,quantity * 10**18));
150 	
151 	
152 	TokenSendStart(dests4,quantity * 10**18);
153 	token.approve(dests4, quantity * 10**18);
154 	require(token.transferFrom(owner , dests4 ,quantity * 10**18));
155 	
156 	
157 	TokenSendStart(dests5,quantity * 10**18);
158 	token.approve(dests5, quantity * 10**18);
159 	require(token.transferFrom(owner , dests5 ,quantity * 10**18));
160     
161 	return token.balanceOf(dests5);
162 	
163   }
164   
165  /**
166   * @dev Send approved tokens to seven addresses
167   * @param dests1 -> address where you want to send tokens
168   * @param dests2 -> address where you want to send tokens
169   * @param dests3 -> address where you want to send tokens
170   * @param dests4 -> address where you want to send tokens
171   * @param dests5 -> address where you want to send tokens
172   * @param dests6 -> address where you want to send tokens
173   * @param dests7 -> address where you want to send tokens
174   * @param quantity -> number of tokens to send
175   */
176  function sendTokensToSeven(address dests1, address dests2, address dests3, address dests4, address dests5, 
177  address dests6, address dests7,  uint256 quantity)  public payable onlyOwner returns (uint) {
178     
179 	TokenSendStart(dests1,quantity * 10**18);
180 	token.approve(dests1, quantity * 10**18);
181 	require(token.transferFrom(owner , dests1 ,quantity * 10**18));
182 	
183 	TokenSendStart(dests2,quantity * 10**18);
184 	token.approve(dests2, quantity * 10**18);
185 	require(token.transferFrom(owner , dests2 ,quantity * 10**18));
186 	
187 	
188 	TokenSendStart(dests3,quantity * 10**18);
189 	token.approve(dests3, quantity * 10**18);
190 	require(token.transferFrom(owner , dests3 ,quantity * 10**18));
191 	
192 	
193 	TokenSendStart(dests4,quantity * 10**18);
194 	token.approve(dests4, quantity * 10**18);
195 	require(token.transferFrom(owner , dests4 ,quantity * 10**18));
196 	
197 	
198 	TokenSendStart(dests5,quantity * 10**18);
199 	token.approve(dests5, quantity * 10**18);
200 	require(token.transferFrom(owner , dests5 ,quantity * 10**18));
201 	
202 	TokenSendStart(dests6,quantity * 10**18);
203 	token.approve(dests6, quantity * 10**18);
204 	require(token.transferFrom(owner , dests6 ,quantity * 10**18));
205     
206 	
207 	TokenSendStart(dests7,quantity * 10**18);
208 	token.approve(dests7, quantity * 10**18);
209 	require(token.transferFrom(owner , dests7 ,quantity * 10**18));
210 	
211 	
212 	return token.balanceOf(dests7);
213 	
214   }
215   
216  /**
217   * @dev users redeem already allocated tokens manually
218   * @param quantity -> number of tokens to redeem
219   */
220   function redeem(uint256 quantity) external{
221       uint256 baseUnits = quantity * 10**18;
222       uint256 senderEligibility = redeemBalanceOf[msg.sender];
223       uint256 tokensAvailable = token.balanceOf(this);
224       require(senderEligibility >= baseUnits);
225       require( tokensAvailable >= baseUnits);
226       if(token.transferFrom(owner, msg.sender,baseUnits)){
227         redeemBalanceOf[msg.sender] -= baseUnits;
228         Redeemed(msg.sender,quantity);
229       }
230   }
231 
232   /**
233   * @dev admin can remove the allocated tokens
234   * @param dests -> array of addresses from where token allocation has to be removed
235   * @param values -> array of number of tokens to be removed for the index above
236   */
237   function removeBalances(address[] dests, uint256[] values) onlyOwner public {
238     uint256 i = 0; 
239     while (i < dests.length){
240         if(dests[i] != address(0)) 
241         {
242             uint256 toRevoke = values[i] * 10**18;
243             if(redeemBalanceOf[dests[i]]>=toRevoke)
244             {
245                 redeemBalanceOf[dests[i]] -= toRevoke;
246                 BalanceCleared(dests[i],values[i]);
247             }
248         }
249         i++;
250     }
251   }
252   
253  
254  /**
255   * @dev admin can destroy this contract
256   */
257   function destroy() onlyOwner public { uint256 tokensAvailable = token.balanceOf(this); require (tokensAvailable > 0); token.transfer(owner, tokensAvailable);  selfdestruct(owner);  } 
258 }