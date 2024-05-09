1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Description: This code is for creating a token contract
5  * This contract is mintable, pausable, burnable, administered, admin-transferrable and 
6  * has safety Maths and security operations checks done and yet have been kept short and simple
7  * It has got 3 contracts
8  * 1. Manager Contract - This contract gives a user the power to manage the token functions
9  * 2. ERC20 Standard Contract - It implements ERC20 pre requisites
10  * 3. WIMT Token Contract - It is a custom contract that inherits from the above two contracts
11  * This source code was tested with Remix and solidity compiler version 0.4.21
12  * The source code was adapted and modified by wims.io
13  * source : https://github.com/tintinweb/smart-contract-sanctuary/blob/master/contracts/ropsten/46/46b8357a9a9361258358308d3668e2072d6732a9_AxelToken.sol
14  */
15 
16  /**
17  * @notice Manager contract
18  */
19  
20 contract Manager
21 {
22     address public contractManager; //address to manage the token contract
23     
24     bool public paused = false; // Indicates whether the token contract is paused or not.
25 	
26 	event NewContractManager(address newManagerAddress); //Will display change of token manager
27 
28     /**
29     * @notice Function constructor for contract Manager with no parameters
30     * 
31     */
32     function Manager() public
33 	{
34         contractManager = msg.sender; //address that creates contracts will manage it
35     }
36 
37 	/**
38 	* @notice onlyManager restrict management operations to the Manager of contract
39 	*/
40     modifier onlyManager()
41 	{
42         require(msg.sender == contractManager); 
43         _;
44     }
45     
46 	/**
47 	* @notice Manager set a new manager
48 	*/
49     function newManager(address newManagerAddress) public onlyManager 
50 	{
51 		require(newManagerAddress != 0);
52 		
53         contractManager = newManagerAddress;
54 		
55 		emit NewContractManager(newManagerAddress);
56 
57     }
58     
59     /**
60      * @dev Event fired when the token contracts gets paused.
61      */
62     event Pause();
63 
64     /**
65      * @notice Event fired when the token contracts gets unpaused.
66      */
67     event Unpause();
68 
69     /**
70      * @notice Allows a function to be called only when the token contract is not paused.
71      */
72     modifier whenNotPaused() {
73         require(!paused);
74         _;
75     }
76 
77     /**
78      * @dev Pauses the token contract.
79      */
80     function pause() public onlyManager whenNotPaused {
81         paused = true;
82         emit Pause();
83     }
84 
85     /**
86      * @notice Unpauses the token contract.
87      */
88     function unpause() public onlyManager {
89         require(paused);
90 
91         paused = false;
92         emit Unpause();
93     }
94 
95 
96 }
97 
98 /**
99  *@notice ERC20 This is the traditional ERC20 contract
100  */
101 contract ERC20 is Manager
102 {
103 
104     mapping(address => uint256) public balanceOf; //this variable displays users balances
105     
106     string public name;//this variable displays token contract name
107 	
108     string public symbol;//this variable displays token contract ticker symbol
109 	
110     uint256 public decimal; //this variable displays the number of decimals for the token
111 	
112     uint256 public totalSupply;//this variable displays the total supply of tokens
113     
114     mapping(address => mapping(address => uint256)) public allowance;//this will list of addresses a user will allow to Transfer his/her tokens
115     
116     event Transfer(address indexed from, address indexed to, uint256 value); //this event will notifies Transfers
117 	
118     event Approval(address indexed owner, address indexed spender, uint256 value);//this event will notifies Approval
119     
120     /**
121     * @notice Function constructor for ERC20 contract
122     */
123     function ERC20(uint256 initialSupply, string _name, string _symbol, uint256 _decimal)  public
124 	{
125 		require(initialSupply >= 0);//prevent negative numbers
126 
127 		require(_decimal >= 0);//no negative decimals allowed
128 		
129         balanceOf[msg.sender] = initialSupply;//give the contract creator address the total created tokens
130 		
131         name = _name; //When the contract is being created give it a name
132 		
133         symbol = _symbol;//When the contract is being created give it a symbol
134 		
135         decimal = _decimal;//When the contract is being created give it decimals standard is  18
136 		
137         totalSupply = initialSupply; //When the contract is being created set the token total supply
138     }
139     
140     /**
141     * @notice function transfer which will move tokens from user account to an address specified at to parameter
142     *
143     */
144     function transfer(address _to, uint256 _value)public whenNotPaused returns (bool success)
145 	{
146 		require(_value > 0);//prevent transferring nothing
147 		
148 		require(balanceOf[msg.sender] >= _value);//the token sender must have tokens to transfer
149 		
150 		require(balanceOf[_to] + _value >= balanceOf[_to]);//the token receiver balance must change and be bigger
151 
152         balanceOf[msg.sender] -= _value;//the balance of the token sender must decrease accordingly
153 		
154         balanceOf[_to] += _value;//effect the actual transfer of tokens
155 		
156         emit Transfer(msg.sender, _to, _value);//publish addresses and amount Transferred
157 
158         return true;
159     }
160     
161     /**
162     * @notice function approve gives an address power to spend specified amount
163     *
164     */
165     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) 
166 	{
167 		require(_value > 0); //approved amount must be greater than zero
168 		
169 		allowance[msg.sender][_spender] = _value;//_spender will be approved to spend _value from as user's address that called this function
170 
171         emit Approval(msg.sender, _spender, _value);//broadcast the activity
172 		
173         return true;
174     }
175     
176     /**
177     * @notice function allowance : displays address allow to transfer tokens from owner
178     * 
179     */    
180     function allowance(address _owner, address _spender) public view returns (uint256 remaining) 
181 	{
182       return allowance[_owner][_spender];
183     }
184 
185 	/**
186     * @notice function transferFrom : moves tokens from one address to another
187     * 
188     */
189     function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused returns (bool success)
190 	{
191 		require(_value > 0); //move at least 1 token
192 		
193         require(balanceOf[_from] >= _value);//check that there tokens to move
194 		
195         require(balanceOf[_to] + _value >= balanceOf[_to]);//after the move the new value must be greater
196         
197         require(_value <= allowance[_from][msg.sender]); //only authorized addresses can transferFrom
198 
199         balanceOf[_from] -= _value;//remove tokens from _from address
200 		
201         balanceOf[_to] += _value;//add these tokens to _to address
202         
203         allowance[_from][msg.sender] -= _value; //change the base token balance
204 
205         emit Transfer(_from, _to, _value);//publish transferFrom activity to network
206 
207         return true;
208     }
209     
210     /**
211     * @notice function balanceOf will display balance of given address
212     * 
213     */
214     function balanceOf(address _owner)public constant returns (uint256 balance) 
215 	{
216         return balanceOf[_owner];
217     }
218 }
219 
220 /**
221  *@notice  WIMT Token implements Manager and ERC contracts
222  */
223 contract WIMT is Manager, ERC20
224 {
225     /**
226      * @notice function constructor for the WIMT contract
227      */
228      
229     function WIMT(uint256 _totalSupply, string _name, string _symbol, uint8 _decimal ) public  ERC20(_totalSupply, _name, _symbol, _decimal)
230 	{
231 
232         contractManager = msg.sender;
233 
234         balanceOf[contractManager] = _totalSupply;
235 		
236         totalSupply = _totalSupply;
237 		
238 		decimal = _decimal;
239 
240     }
241     
242     /**
243     * @notice function mint to be executed by Manager of token
244     * 
245     */
246     function mint(address target, uint256 mintedAmount)public onlyManager whenNotPaused
247 	{
248 		require(target != 0);//check executor is supplied 
249 		
250 		require(mintedAmount > 0);//disallow negative minting
251 		
252 	    require(balanceOf[target] + mintedAmount >= balanceOf[target]);//after the move the new value must be greater
253         
254         require(totalSupply + mintedAmount >= totalSupply);//after the move the new value must be greater
255         
256         balanceOf[target] += mintedAmount;//add tokens to address target
257 		
258         totalSupply += mintedAmount;//increase totalSupply
259 		
260         emit Transfer(0, this, mintedAmount);//publish transfer
261 		
262         emit Transfer(this, target, mintedAmount);//publish transfer
263     }
264     
265 	/**
266     * @notice function burn decrease total Supply of tokens
267     * 
268     */
269 	function burn(uint256 mintedAmount) public onlyManager whenNotPaused
270 	{
271 		
272 		require(mintedAmount > 0);//at least 1 token must be destroyed
273 		
274 		require(totalSupply - mintedAmount <= totalSupply);//after the move the new value must be greater
275         
276 	    require(balanceOf[msg.sender] - mintedAmount <= balanceOf[msg.sender]);//after the move the new value must be greater
277 
278         balanceOf[msg.sender] -= mintedAmount;//decrease balance of destroyer
279 		
280         totalSupply -= mintedAmount;//decrease totalSupply by destroyed tokens
281 		
282         emit Transfer(0, msg.sender, mintedAmount);//publish burn activity
283 		
284         
285 
286     }
287 
288 }