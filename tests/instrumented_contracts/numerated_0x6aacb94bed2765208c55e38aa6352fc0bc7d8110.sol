1 contract BitSTDLogic {
2     function name()constant  public returns(string) {}
3 	function symbol()constant  public returns(string) {}
4 	function decimals()constant  public returns(uint8) {}
5 	function totalSupply()constant  public returns(uint256) {}
6 	function allowance(address add,address _add)constant  public returns(uint256) {}
7 	function sellPrice()constant  public returns(uint256) {}
8 	function buyPrice()constant  public returns(uint256) {}
9 	function frozenAccount(address add)constant  public returns(bool) {}
10     function BitSTDLogic(address dataAddress){}
11 	function migration(address sender,address add) public{}
12 	function balanceOf(address add)constant  public returns(uint256) {}
13 	function transfer(address sender,address _to, uint256 _value) public {}
14 	function transferFrom(address _from,address sender, address _to, uint256 _value) public returns (bool success) {}
15 	function approve(address _spender,address sender, uint256 _value) public returns (bool success) {}
16 	function approveAndCall(address _spender,address sender,address _contract, uint256 _value, bytes _extraData)public returns (bool success) {}
17 	function burn(address sender,uint256 _value) public returns (bool success) {}
18 	function burnFrom(address _from,address sender, uint256 _value) public returns (bool success) {}
19 	function mintToken(address target,address _contract, uint256 mintedAmount)  public {}
20 	function freezeAccount(address target, bool freeze)  public {}
21 	function buy(address _contract,address sender,uint256 value) payable public {}
22 	function sell(address _contract,address sender,uint256 amount) public {}
23 	function Transfer_of_authority(address newOwner) public{}
24 	function Transfer_of_authority_data(address newOwner) public {}
25 	function setData(address dataAddress) public {}
26 }
27 contract BitSTDView{
28 
29 	BitSTDLogic private logic;
30 	address public owner;
31 
32 	//start Query data interface
33     function balanceOf(address add)constant  public returns(uint256) {
34 	    return logic.balanceOf(add);
35 	}
36 
37 	function name() constant  public returns(string) {
38 	    return logic.name();
39 	}
40 
41 	function symbol() constant  public returns(string) {
42 	    return logic.symbol();
43 	}
44 
45 	function decimals() constant  public returns(uint8) {
46 	    return logic.decimals();
47 	}
48 
49 	function totalSupply() constant  public returns(uint256) {
50 	    return logic.totalSupply();
51 	}
52 
53 	function allowance(address add,address _add) constant  public returns(uint256) {
54 	    return logic.allowance(add,_add);
55 	}
56 
57 	function sellPrice() constant  public returns(uint256) {
58 	    return logic.sellPrice();
59 	}
60 
61 	function buyPrice() constant  public returns(uint256) {
62 	    return logic.buyPrice();
63 	}
64 
65 	function frozenAccount(address add) constant  public returns(bool) {
66 	    return logic.frozenAccount(add);
67 	}
68 
69 	//End Query data interface
70 
71 	//initialize
72     function BitSTDView(address logicAddressr) public {
73         logic=BitSTDLogic(logicAddressr);
74         owner=msg.sender;
75     }
76 
77     //start Authority and control
78     modifier onlyOwner(){
79 		require(msg.sender == owner);
80         _;
81 	}
82 
83 	//Update the address of the data and logic layer
84     function setBitSTD(address dataAddress,address logicAddressr) onlyOwner public{
85         logic=BitSTDLogic(logicAddressr);
86         logic.setData(dataAddress);
87     }
88 
89     //Hand over the logical layer authority
90     function Transfer_of_authority_logic(address newOwner) onlyOwner public{
91         logic.Transfer_of_authority(newOwner);
92     }
93 
94     //Hand over the data layer authority
95     function Transfer_of_authority_data(address newOwner) onlyOwner public{
96         logic.Transfer_of_authority_data(newOwner);
97     }
98 
99     //Hand over the view layer authority
100     function Transfer_of_authority(address newOwner) onlyOwner public{
101         owner=newOwner;
102     }
103     //End Authority and control
104 
105     //data migration
106     function migration(address add) public{
107         logic.migration(msg.sender,add);
108     }
109 
110     /**
111      * Transfer tokens
112      *
113      * Send `_value` tokens to `_to` from your account
114      *
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118 	function transfer(address _to, uint256 _value) public {
119 	    logic.transfer(msg.sender,_to,_value);
120 	}
121 
122 	/**
123      * Transfer tokens from other address
124      *
125      * Send `_value` tokens to `_to` in behalf of `_from`
126      *
127      * @param _from The address of the sender
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132 	    return logic.transferFrom( _from, msg.sender,  _to,  _value);
133 	}
134 
135 	/**
136      * Set allowance for other address
137      *
138      * Allows `_spender` to spend no more than `_value` tokens in your behalf
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      */
143 	function approve(address _spender, uint256 _value) public returns (bool success) {
144 	    return logic.approve( _spender, msg.sender,  _value);
145 	}
146 
147 	/**
148      * Set allowance for other address and notify
149      *
150      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
151      *
152      * @param _spender The address authorized to spend
153      * @param _value the max amount they can spend
154      * @param _extraData some extra information to send to the approved contract
155      */
156 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
157 	    return logic.approveAndCall( _spender, msg.sender,this,  _value,  _extraData);
158 	}
159 
160 	/**
161      * Destroy tokens
162      *
163      * Remove `_value` tokens from the system irreversibly
164      *
165      * @param _value the amount of money to burn
166      */
167 	function burn(uint256 _value) public returns (bool success) {
168 	    return logic.burn( msg.sender, _value);
169 	}
170 
171 	/**
172      * Destroy tokens from other account
173      *
174      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
175      *
176      * @param _from the address of the sender
177      * @param _value the amount of money to burn
178      */
179 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
180 	    return logic.burnFrom( _from, msg.sender,  _value);
181 	}
182 
183 	/// @notice Create `mintedAmount` tokens and send it to `target`
184     /// @param target Address to receive the tokens
185     /// @param mintedAmount the amount of tokens it will receive
186 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
187 	    logic.mintToken( target,this,  mintedAmount);
188 	}
189 
190 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
191     /// @param target Address to be frozen
192     /// @param freeze either to freeze it or not
193 	function freezeAccount(address target, bool freeze) onlyOwner public {
194 	    logic.freezeAccount( target,  freeze);
195 	}
196 
197 	//The next two are buying and selling tokens
198 	function buy() payable public {
199 	    logic.buy( this,msg.sender,msg.value);
200 	}
201 
202 	function sell(uint256 amount) public {
203 	    logic.sell( this,msg.sender, amount);
204 	}
205 
206 }