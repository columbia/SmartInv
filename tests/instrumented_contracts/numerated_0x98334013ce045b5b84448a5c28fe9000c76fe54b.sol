1 contract BitSTDLogic {
2     function name()constant  public returns(string) {}
3 	function symbol()constant  public returns(string) {}
4 	function decimals()constant  public returns(uint8) {}
5 	function totalSupply()constant  public returns(uint256) {}
6 	function allowance(address add,address _add)constant  public returns(uint256) {}
7 	function sellPrice()constant  public returns(uint256) {}
8 	function buyPrice()constant  public returns(uint256) {}
9 	function frozenAccount(address add)constant  public returns(bool) {}
10 	function migration(address sender,address add) public{}
11 	function balanceOf(address add)constant  public returns(uint256) {}
12 	function transfer(address sender,address _to, uint256 _value) public {}
13 	function transferFrom(address _from,address sender, address _to, uint256 _value) public returns (bool success) {}
14 	function approve(address _spender,address sender, uint256 _value) public returns (bool success) {}
15 	function approveAndCall(address _spender,address sender,address _contract, uint256 _value, bytes _extraData)public returns (bool success) {}
16 	function burn(address sender,uint256 _value) public returns (bool success) {}
17 	function burnFrom(address _from,address sender, uint256 _value) public returns (bool success) {}
18 	function mintToken(address target,address _contract, uint256 mintedAmount)  public {}
19 	function freezeAccount(address target, bool freeze)  public {}
20 	function buy(address _contract,address sender,uint256 value) payable public {}
21 	function sell(address _contract,address sender,uint256 amount) public {}
22 	function Transfer_of_authority(address newOwner) public{}
23 	function Transfer_of_authority_data(address newOwner) public {}
24 	function setData(address dataAddress) public {}
25 	// Old contract data
26     function getOld_BalanceOfr(address add)constant  public returns(uint256){}
27 }
28 contract BitSTDView{
29 
30 	BitSTDLogic private logic;
31 	address public owner;
32 
33     // This creates a public event on the blockchain that notifies the customer
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event FrozenFunds(address target, bool frozen);
36 
37     // This tells the customer how much money is being burned
38     event Burn(address indexed from, uint256 value);
39 
40 	//start Query data interface
41     function balanceOf(address add)constant  public returns(uint256) {
42 	    return logic.balanceOf(add);
43 	}
44 
45 	function name() constant  public returns(string) {
46 	    return logic.name();
47 	}
48 
49 	function symbol() constant  public returns(string) {
50 	    return logic.symbol();
51 	}
52 
53 	function decimals() constant  public returns(uint8) {
54 	    return logic.decimals();
55 	}
56 
57 	function totalSupply() constant  public returns(uint256) {
58 	    return logic.totalSupply();
59 	}
60 
61 	function allowance(address add,address _add) constant  public returns(uint256) {
62 	    return logic.allowance(add,_add);
63 	}
64 
65 	function sellPrice() constant  public returns(uint256) {
66 	    return logic.sellPrice();
67 	}
68 
69 	function buyPrice() constant  public returns(uint256) {
70 	    return logic.buyPrice();
71 	}
72 
73 	function frozenAccount(address add) constant  public returns(bool) {
74 	    return logic.frozenAccount(add);
75 	}
76 
77 	//End Query data interface
78 
79 	//initialize
80     function BitSTDView(address logicAddressr) public {
81         logic=BitSTDLogic(logicAddressr);
82         owner=msg.sender;
83     }
84 
85     //start Authority and control
86     modifier onlyOwner(){
87 		require(msg.sender == owner);
88         _;
89 	}
90 
91 	//Update the address of the data and logic layer
92     function setBitSTD(address dataAddress,address logicAddressr) onlyOwner public{
93         logic=BitSTDLogic(logicAddressr);
94         logic.setData(dataAddress);
95     }
96 
97     //Hand over the logical layer authority
98     function Transfer_of_authority_logic(address newOwner) onlyOwner public{
99         logic.Transfer_of_authority(newOwner);
100     }
101 
102     //Hand over the data layer authority
103     function Transfer_of_authority_data(address newOwner) onlyOwner public{
104         logic.Transfer_of_authority_data(newOwner);
105     }
106 
107     //Hand over the view layer authority
108     function Transfer_of_authority(address newOwner) onlyOwner public{
109         owner=newOwner;
110     }
111     //End Authority and control
112 
113     //data migration
114     function migration(address add) public{
115         logic.migration(msg.sender,add);
116         emit Transfer(msg.sender, add,logic.getOld_BalanceOfr(add));
117     }
118 
119     /**
120      * Transfer tokens
121      *
122      * Send `_value` tokens to `_to` from your account
123      *
124      * @param _to The address of the recipient
125      * @param _value the amount to send
126      */
127 	function transfer(address _to, uint256 _value) public {
128 	    logic.transfer(msg.sender,_to,_value);
129 	    emit Transfer(msg.sender, _to, _value);
130 	}
131 
132 	/**
133      * Transfer tokens from other address
134      *
135      * Send `_value` tokens to `_to` in behalf of `_from`
136      *
137      * @param _from The address of the sender
138      * @param _to The address of the recipient
139      * @param _value the amount to send
140      */
141 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142 	    return logic.transferFrom( _from, msg.sender,  _to,  _value);
143 	     emit Transfer(_from, _to, _value);
144 	}
145 
146 	/**
147      * Set allowance for other address
148      *
149      * Allows `_spender` to spend no more than `_value` tokens in your behalf
150      *
151      * @param _spender The address authorized to spend
152      * @param _value the max amount they can spend
153      */
154 	function approve(address _spender, uint256 _value) public returns (bool success) {
155 	    return logic.approve( _spender, msg.sender,  _value);
156 	}
157 
158 	/**
159      * Set allowance for other address and notify
160      *
161      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      * @param _extraData some extra information to send to the approved contract
166      */
167 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
168 	    return logic.approveAndCall( _spender, msg.sender,this,  _value,  _extraData);
169 	}
170 
171 	/**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178 	function burn(uint256 _value) public returns (bool success) {
179 	    return logic.burn( msg.sender, _value);
180 	    emit Burn(msg.sender, _value);
181 	}
182 
183 	/**
184      * Destroy tokens from other account
185      *
186      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187      *
188      * @param _from the address of the sender
189      * @param _value the amount of money to burn
190      */
191 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
192 	    return logic.burnFrom( _from, msg.sender,  _value);
193 	    emit Burn(_from, _value);
194 	}
195 
196 	/// @notice Create `mintedAmount` tokens and send it to `target`
197     /// @param target Address to receive the tokens
198     /// @param mintedAmount the amount of tokens it will receive
199 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
200 	    logic.mintToken( target,this,  mintedAmount);
201 	    emit Transfer(0, this, mintedAmount);
202         emit Transfer(this, target, mintedAmount);
203 	}
204 
205 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
206     /// @param target Address to be frozen
207     /// @param freeze either to freeze it or not
208 	function freezeAccount(address target, bool freeze) onlyOwner public {
209 	    logic.freezeAccount( target,  freeze);
210 	    emit FrozenFunds(target, freeze);
211 	}
212 
213 	//The next two are buying and selling tokens
214 	function buy() payable public {
215 	    logic.buy( this,msg.sender,msg.value);
216 	}
217 
218 	function sell(uint256 amount) public {
219 	    logic.sell( this,msg.sender, amount);
220 	}
221 
222 }